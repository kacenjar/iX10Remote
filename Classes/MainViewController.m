//
//  MainViewController.m
//  iX10Remote
//
// BSD License
// Copyright (c) 2010, Dan Kacenjar
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// * Neither the name iX10Remote nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
// INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "MainViewController.h"
#import "MainView.h"


@implementation MainViewController

@synthesize x10PickerView;
@synthesize pachubePrefs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 [self loadPrefs];
	 	 
	 houseCodes = [[NSArray alloc] initWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", nil];
	 keyCodes = [[NSArray alloc] initWithObjects: @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", nil];
 }


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger) component {
	if (component == 0) {
		return [houseCodes count];
	} else {
		return [keyCodes count];
	}
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger) row forComponent:(NSInteger) component {
	switch (component) {
		case 0:
			return [houseCodes objectAtIndex:row];
		case 1:
			return [keyCodes objectAtIndex:row];
	}
	return nil;
}

-(IBAction) x10ButtonPressed: (id)sender {
	NSInteger onOffState = [[sender titleForState:UIControlStateNormal] isEqual: @"On"] ? 1 : 0;
	NSLog(@"%@ Button Pressed  - House Code: %@   Key Code: %@  State: %d", [sender titleForState:UIControlStateNormal], [houseCodes objectAtIndex:[x10PickerView selectedRowInComponent:0]], [keyCodes objectAtIndex:[x10PickerView selectedRowInComponent:1]], onOffState);
	[self pachubePut: onOffState];
}


- (void) pachubePut: (NSInteger)onOffState {
	
	NSString *x10Data = [NSString stringWithFormat:@"%@,%@,%d", [houseCodes objectAtIndex:[x10PickerView selectedRowInComponent:0]], [keyCodes objectAtIndex:[x10PickerView selectedRowInComponent:1]], onOffState];
	
	NSString *pachubeURL = [NSString stringWithFormat:@"http://www.pachube.com/api/%@.csv", [pachubePrefs objectForKey:PACHUBE_FEED_ID_KEY]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pachubeURL]];
	NSData *requestData = [x10Data dataUsingEncoding:NSASCIIStringEncoding];
	[request setHTTPBody: requestData];
	[request setHTTPMethod: @"PUT"];
	
	[request setValue:@"www.pachube.com" forHTTPHeaderField:@"Host"];
	[request setValue:[pachubePrefs objectForKey:PACHUBE_API_KEY] forHTTPHeaderField: @"X-PachubeApiKey"];
	[request setValue:[NSString stringWithFormat:@"%d", [x10Data length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"close" forHTTPHeaderField:@"Connection"];
	
	NSURLResponse *urlResponse;
	NSError *error;
	

	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	NSLog(@"URL Response: %@", urlResponse);
	//NSLog(@"Error Response: %@", error);
	NSLog(@"URL Connection call response: %@", response);
	
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void) initPrefsFilePath { 
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [searchPaths objectAtIndex:0];
	prefsFilePath = [documentsDirectory stringByAppendingPathComponent: @"pachubeprefs.plist"]; 
	[prefsFilePath retain]; 
} 

- (void) loadPrefs { 
	if (prefsFilePath == nil) 
		[self initPrefsFilePath]; 
	if ([[NSFileManager defaultManager] fileExistsAtPath: prefsFilePath]) { 
		pachubePrefs = [[NSMutableDictionary alloc] initWithContentsOfFile: prefsFilePath]; 
	}
	else { 
		pachubePrefs = [[NSMutableDictionary alloc] initWithCapacity: 2]; 
		[pachubePrefs setObject: @"" forKey: PACHUBE_API_KEY]; 
		[pachubePrefs setObject: @"" forKey: PACHUBE_FEED_ID_KEY]; 
	} 
} 
- (void) savePrefs {
	[pachubePrefs writeToFile: prefsFilePath atomically: YES]; 
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[pachubePrefs setObject:[controller apiKey] forKey:PACHUBE_API_KEY];
	[pachubePrefs setObject:[controller feedId] forKey:PACHUBE_FEED_ID_KEY];
	[self savePrefs];
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[x10PickerView release];
	[houseCodes release];
	[keyCodes release];
	[pachubePrefs release];
    [super dealloc];
}


@end
