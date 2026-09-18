#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import <objc/runtime.h>

@interface TALabWindow:UIWindow @end
@implementation TALabWindow
- (UIView*)hitTest:(CGPoint)p withEvent:(UIEvent*)e{return nil;}
@end

static NSString*const P=@"/var/mobile/TestTaLab.txt";
static TALabWindow*gW=nil;static UIView*gB=nil;static __weak UIWindowScene*gLast=nil;static BOOL gLoop=NO;static UIView*gHosted=nil;
static void L(NSString*f,...){va_list a;va_start(a,f);NSString*m=[[NSString alloc]initWithFormat:f arguments:a];va_end(a);FILE*x=fopen(P.UTF8String,"a");if(x){fprintf(x,"[TESTTA-3.2] %s\\n",m.UTF8String);fclose(x);}}
static BOOL CP(UIWindowScene*s){if(!s)return NO;NSString*r=s.session.role?:@"";if([r localizedCaseInsensitiveContainsString:@"CarPlay"])return YES;CGSize z=s.screen.bounds.size;return z.width>z.height&&z.width>=300&&z.height<=500;}
static UIWindowScene*Find(void){UIWindowScene*best=nil;CGFloat score=-CGFLOAT_MAX;NSString*bid=nil;for(UIScene*r in UIApplication.sharedApplication.connectedScenes){if(![r isKindOfClass:UIWindowScene.class])continue;UIWindowScene*s=(UIWindowScene*)r;if(!CP(s))continue;CGSize z=s.screen.bounds.size;NSString*pid=s.session.persistentIdentifier?:@"";BOOL dash=[pid containsString:@"DBDashboard-Car"]||[pid containsString:@"DBDashboard"];CGFloat hi=-CGFLOAT_MAX;for(UIWindow*w in s.windows)if(w&&!w.hidden&&w.alpha>.01)hi=MAX(hi,w.windowLevel);if(hi==-CGFLOAT_MAX)hi=-10000;CGFloat q=(dash?1e9:0)+(hi>=UIWindowLevelAlert?1e8:0)+z.width*z.height+hi;BOOL tie=fabs(q-score)<.5&&(!bid||[pid compare:bid]==NSOrderedAscending);if(!best||q>score||tie){best=s;score=q;bid=pid;}}if(best!=gLast){gLast=best;if(best)L(@"SELECTED pid=%@ role=%@ size=%@",best.session.persistentIdentifier,best.session.role,NSStringFromCGSize(best.screen.bounds.size));}return best;}
static UIView*Bubble(CGFloat s){UIView*v=[[UIView alloc]initWithFrame:CGRectMake(8,8,s,s)];v.backgroundColor=UIColor.systemYellowColor;v.layer.cornerRadius=s/2;v.layer.borderWidth=7;v.layer.borderColor=UIColor.systemGreenColor.CGColor;UILabel*l=[[UILabel alloc]initWithFrame:v.bounds];l.text=@"LAB";l.textAlignment=NSTextAlignmentCenter;l.font=[UIFont boldSystemFontOfSize:s*.25];l.textColor=UIColor.blackColor;[v addSubview:l];return v;}
static NSUInteger HC(UIView*v,NSUInteger d){if(!v||d>18)return 0;NSString*n=NSStringFromClass(v.class);NSUInteger c=([n containsString:@"_UISceneLayerHostContainerView"]||[n containsString:@"UIContextLayerHostView"])?1:0;for(UIView*x in v.subviews)c+=HC(x,d+1);return c;}
static void HostLab(UIWindowScene*s){UIWindow*best=nil;NSUInteger bc=0;CGFloat bs=-CGFLOAT_MAX;CGRect sb=s.coordinateSpace.bounds;for(UIWindow*w in s.windows){if(!w||w==gW||w.hidden||w.alpha<=.01||!w.rootViewController.view)continue;NSUInteger n=HC(w.rootViewController.view,0);if(!n)continue;CGRect f=w.frame;BOOL inset=CGRectGetMinX(f)>1&&CGRectGetWidth(f)<CGRectGetWidth(sb)-1;CGFloat q=(w.windowLevel>=UIWindowLevelAlert?1e6:0)+(inset?1e5:0)+n*1000+w.windowLevel;if(!best||q>bs){best=w;bc=n;bs=q;}}if(!best){if(gHosted){[gHosted removeFromSuperview];gHosted=nil;L(@"HOST LAB REMOVED");}return;}UIView*canvas=best.rootViewController.view;if(!gHosted||gHosted.superview!=canvas){[gHosted removeFromSuperview];gHosted=Bubble(82);UILabel*l=(UILabel*)gHosted.subviews.firstObject;l.text=@"HOST";[canvas addSubview:gHosted];L(@"HOST LAB ATTACHED window=%@ level=%.1f frame=%@ surfaces=%lu",NSStringFromClass(best.class),best.windowLevel,NSStringFromCGRect(best.frame),(unsigned long)bc);}gHosted.frame=CGRectMake(MAX(4,CGRectGetWidth(canvas.bounds)-90),8,82,82);gHosted.layer.zPosition=CGFLOAT_MAX;[canvas bringSubviewToFront:gHosted];}
static void Tick(void){UIWindowScene*s=Find();if(!s){dispatch_after(dispatch_time(DISPATCH_TIME_NOW,500*NSEC_PER_MSEC),dispatch_get_main_queue(),^{Tick();});return;}if(!gW||gW.windowScene!=s){gW.hidden=YES;gW.rootViewController=nil;gW=[[TALabWindow alloc]initWithWindowScene:s];gW.backgroundColor=UIColor.clearColor;UIViewController*vc=[UIViewController new];vc.view.backgroundColor=UIColor.clearColor;gW.rootViewController=vc;CGRect b=s.coordinateSpace.bounds;if(CGRectIsEmpty(b))b=s.screen.bounds;CGFloat sz=MAX(84,MIN(112,MAX(b.size.height,1)*.40));gB=Bubble(sz);[vc.view addSubview:gB];L(@"CREATED scene=%@ frame=%@",s.session.persistentIdentifier,NSStringFromCGRect(b));}CGRect b=s.coordinateSpace.bounds;if(CGRectIsEmpty(b))b=s.screen.bounds;gW.frame=b;gW.rootViewController.view.frame=(CGRect){CGPointZero,b.size};CGFloat hi=UIWindowLevelAlert;for(UIWindow*w in s.windows)if(w&&w!=gW)hi=MAX(hi,w.windowLevel);CGFloat target=MAX(UIWindowLevelAlert+100,hi+100);if(fabs(gW.windowLevel-target)>.5){gW.windowLevel=target;L(@"PROMOTED %.1f highest=%.1f",target,hi);}gW.hidden=NO;gW.alpha=1;gB.hidden=NO;gB.alpha=1;gB.layer.zPosition=CGFLOAT_MAX;[gB.superview bringSubviewToFront:gB];HostLab(s);dispatch_after(dispatch_time(DISPATCH_TIME_NOW,500*NSEC_PER_MSEC),dispatch_get_main_queue(),^{Tick();});}
%ctor {
 @autoreleasepool {
  NSString *b=NSBundle.mainBundle.bundleIdentifier?:@"";
  L(@"LOAD bundle=%@ process=%@",b,NSProcessInfo.processInfo.processName);
  if([b isEqualToString:@"com.apple.CarPlayApp"]&&!gLoop){
   gLoop=YES;
   dispatch_async(dispatch_get_main_queue(),^{ Tick(); });
  }
 }
}





// 3.2 — trace the actual CNAB hosting calls discovered by 3.1.
// READ ONLY: no z-order/window/context experiment.
static NSString *TAObj(id o){@try{return [o description];}@catch(__unused NSException*e){return @"<exception>";}}
%hook CNABSpringBoardObserver
-(void)hostSlots:(id)slots skipEvict:(BOOL)skip {
 L(@"CNAB hostSlots skipEvict=%d self=%@ slots=%@",skip,TAObj(self),TAObj(slots));
 %orig;
}
-(void)hostSplitL:(id)left right:(id)right skipEvict:(BOOL)skip {
 L(@"CNAB hostSplit left=%@ right=%@ skipEvict=%d self=%@",TAObj(left),TAObj(right),skip,TAObj(self));
 %orig;
}
-(void)onHostRequest:(id)req {
 L(@"CNAB onHostRequest req=%@ self=%@",TAObj(req),TAObj(self));
 %orig;
}
-(void)onHostRequestSplit:(id)req {
 L(@"CNAB onHostRequestSplit req=%@ self=%@",TAObj(req),TAObj(self));
 %orig;
}
%end
%hook CNABCarPlayObserver
-(void)onHostState:(id)state {
 L(@"CNAB onHostState state=%@ self=%@",TAObj(state),TAObj(self));
 %orig;
}
%end
%hook CNABHostUIAppResponder
-(void)onUIAppRequest:(id)req {
 L(@"CNAB onUIAppRequest req=%@ self=%@",TAObj(req),TAObj(self));
 %orig;
}
%end
%ctor {
 @autoreleasepool {
  NSString *b=NSBundle.mainBundle.bundleIdentifier?:@"";
  L(@"3.2 ACTIVE bundle=%@ process=%@",b,NSProcessInfo.processInfo.processName);
 }
}
