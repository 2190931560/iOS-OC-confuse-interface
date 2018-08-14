//
//  ViewController.m
//  test
//
//  Created by Dongliang Leng on 2018/8/2.
//  Copyright © 2018年 Dongliang Leng. All rights reserved.
//

#import "ViewController.h"
#import <dlfcn.h>
#import <sys/types.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@interface ViewController ()

@end

@implementation ViewController
static int is_debugged(){
    int name[4] = {CTL_KERN,KERN_PROC,KERN_PROC_PID,getpid()};
    struct kinfo_proc Kproc;
    size_t kproc_size = sizeof(Kproc);
    
    memset((void*)&Kproc, 0, kproc_size);
    
    if (sysctl(name, 4, &Kproc, &kproc_size, NULL, 0) == -1) {
        perror("sysctl error \n ");
        exit(-1);
    }
    
    return (Kproc.kp_proc.p_flag & P_TRACED) ? 1 : 0;
}
- (IBAction)btnClick:(id)sender {
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)test
{

}
+(void)staticTest
{
    
}
@end
