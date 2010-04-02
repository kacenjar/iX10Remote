//
//  MainViewController.h
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

#import "FlipsideViewController.h"

#define PACHUBE_API_KEY @"API_KEY"
#define PACHUBE_FEED_ID_KEY @"FEED_ID"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *x10PickerView;

	NSArray *houseCodes;
	NSArray *keyCodes;

	NSMutableDictionary *pachubePrefs; 
	NSString *prefsFilePath;
	
}

@property(nonatomic, retain) IBOutlet UIPickerView *x10PickerView;
@property(nonatomic, retain) NSMutableDictionary *pachubePrefs;

- (IBAction)showInfo;
- (IBAction) x10ButtonPressed: (id)sender;
- (void) pachubePut: (NSInteger)onOffState;
- (void) savePrefs;
- (void) loadPrefs;
@end
