Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759623AbZKKXVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 18:21:55 -0500
Date: Wed, 11 Nov 2009 15:21:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: knife@toaster.net
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bugme-new] [Bug 14564] New: capture-example sleeping function
 called from invalid context at arch/x86/mm/fault.c
Message-Id: <20091111152127.0c97a620.akpm@linux-foundation.org>
In-Reply-To: <bug-14564-10286@http.bugzilla.kernel.org/>
References: <bug-14564-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

(lotsa cc's added)

On Mon, 9 Nov 2009 08:59:05 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14564
> 
>            Summary: capture-example sleeping function called from invalid
>                     context at arch/x86/mm/fault.c
>            Product: Memory Management
>            Version: 2.5
>     Kernel Version: 2.6.31.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Slab Allocator
>         AssignedTo: akpm@linux-foundation.org
>         ReportedBy: knife@toaster.net
>         Regression: No
> 

Thhis is odd.

> On a DM&P ebox2300sx, 300Mhz Vortex86 cpu, I have a vanilla 2.6.31.5 kernel
> with a pac207 webcam. I run capture-example from the v4l-dvb sample
> applications and it crashes 1 out of 5 times. Let me know if I need to collect
> more data or try anything.
> 
> [root@X-Linux]:~ # capture-example                                              
> ......................................................................BUG:
> sleeping function called from invalid context at arch/x86/mm/fault.c:1069       
> in_atomic(): 0, irqs_disabled(): 1, pid: 1178, name: capture-example            
> 4 locks held by capture-example/1178:                                           
>  #0:  (&gspca_dev->queue_lock){+.+.+.}, at: [<c8872eda>]
> vidioc_streamoff+0x3b/0xb4 [gspca_main]                                         
>  #1:  (&gspca_dev->usb_lock){+.+.+.}, at: [<c8872eed>]
> vidioc_streamoff+0x4e/0xb4 [gspca_main]                                         
>  #2:  (&ohci->lock){-.-...}, at: [<c11c8093>] ohci_endpoint_disable+0x31/0x192  
>  #3:  (&mm->mmap_sem){++++++}, at: [<c100c168>] do_page_fault+0xc1/0x1fe        
> irq event stamp: 11656                                                          
> hardirqs last  enabled at (11655): [<c12e41a0>] _spin_unlock_irq+0x22/0x26      
> hardirqs last disabled at (11656): [<c12e41da>] _spin_lock_irqsave+0x10/0x5a    
> softirqs last  enabled at (11610): [<c101a87f>] __do_softirq+0x145/0x14d        
> softirqs last disabled at (11605): [<c101a8b1>] do_softirq+0x2a/0x42            
> Pid: 1178, comm: capture-example Not tainted 2.6.31.5 #2                        
> Call Trace:                                                                     
>  [<c101222d>] __might_sleep+0xcb/0xd0                                           
>  [<c100c1ad>] do_page_fault+0x106/0x1fe                                         
>  [<c100c0a7>] ? do_page_fault+0x0/0x1fe                                         
>  [<c12e43c3>] error_code+0x63/0x70                                              
>  [<c100c0a7>] ? do_page_fault+0x0/0x1fe                                         
>  [<c11c5cef>] ? td_free+0x23/0x75                                               
>  [<c11c8175>] ohci_endpoint_disable+0x113/0x192                                 
>  [<c11b4428>] usb_hcd_disable_endpoint+0x2e/0x32                                
>  [<c11b5b3f>] usb_disable_endpoint+0x6d/0x72                                    
>  [<c11b5cae>] usb_disable_interface+0x30/0x3f                                   
>  [<c11b70ac>] usb_set_interface+0x11b/0x1a0                                     
>  [<c8872e1d>] gspca_set_alt0+0x23/0x46 [gspca_main]                             
>  [<c8872e75>] gspca_stream_off+0x35/0x5f [gspca_main]                           
>  [<c8872ef8>] vidioc_streamoff+0x59/0xb4 [gspca_main]                           
>  [<c8817244>] __video_do_ioctl+0x17af/0x3920 [videodev]                         
>  [<c1032fa1>] ? __lock_acquire+0x6ef/0x755                                      
>  [<c102f436>] ? lock_release_holdtime+0x81/0x86                                 
>  [<c103315c>] ? lock_release_non_nested+0xab/0x1cf                              
>  [<c105382f>] ? might_fault+0x3d/0x79                                           
>  [<c105382f>] ? might_fault+0x3d/0x79                                           
>  [<c11123d4>] ? copy_from_user+0x31/0x54                                        
>  [<c88196b8>] video_ioctl2+0x303/0x3ea [videodev]                               
>  [<c102f436>] ? lock_release_holdtime+0x81/0x86                                 
>  [<c12e430e>] ? _spin_unlock_irqrestore+0x36/0x3c                               
>  [<c103086c>] ? trace_hardirqs_on_caller+0x104/0x12b                            
>  [<c103089e>] ? trace_hardirqs_on+0xb/0xd                                       
>  [<c88193b5>] ? video_ioctl2+0x0/0x3ea [videodev]                               
>  [<c88156d8>] v4l2_unlocked_ioctl+0x2e/0x32 [videodev]                          
>  [<c88156aa>] ? v4l2_unlocked_ioctl+0x0/0x32 [videodev]                         
>  [<c106dd91>] vfs_ioctl+0x19/0x50                                               
>  [<c106e36b>] do_vfs_ioctl+0x458/0x4a3                                          
>  [<c1155a42>] ? tty_ldisc_deref+0x8/0xa                                         
>  [<c1150c1c>] ? tty_write+0x1b1/0x1c2                                           
>  [<c1152d69>] ? n_tty_write+0x0/0x2e6                                           
>  [<c1150a6b>] ? tty_write+0x0/0x1c2                                             
>  [<c106431d>] ? vfs_write+0xe3/0xfa                                             
>  [<c1002858>] ? restore_all_notrace+0x0/0x18                                    
>  [<c106e3e2>] sys_ioctl+0x2c/0x45                                               
>  [<c1002825>] syscall_call+0x7/0xb                                              

We oopsed in td_free() (see below).  But as part of that oops
processing the kernel entered do_page_fault() and emitted a
might_sleep() warning because we took a pagefault with local interrupts
disabled.

This is undesirable behaviour from the low-level x86 fault code and I
don't think it normally happens.

Did we break something in x86 land, or is this oops sufficiently weird
and whacky to bypass existing checks for this false positive?

> BUG: unable to handle kernel paging request at a7a7a7c3                         
> IP: [<c11c5cef>] td_free+0x23/0x75                                              
> *pde = 00000000                                                                 
> Oops: 0000 [#1] DEBUG_PAGEALLOC                                                 
> last sysfs file:                                                                
> Modules linked in: gspca_pac207 gspca_main videodev v4l1_compat                 
> 
> Pid: 1178, comm: capture-example Not tainted (2.6.31.5 #2)                      
> EIP: 0060:[<c11c5cef>] EFLAGS: 00000083 CPU: 0                                  
> EIP is at td_free+0x23/0x75                                                     
> EAX: a7a7a7a7 EBX: c6b35bf0 ECX: c6b35ce4 EDX: a7a7a7c3                         
> ESI: c6b7d800 EDI: c6b35cd4 EBP: c6785cc4 ESP: c6785cb8                         
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068                                   
> Process capture-example (pid: 1178, ti=c6784000 task=c678d338 task.ti=c6784000) 
> Stack:                                                                          
>  c6b35bf0 000003e8 c6b35cd4 c6785cf0 c11c8175 c6ba2ea0 c6b35bf0 00000000        
> <0> c6b35bf0 00000292 c6b7c040 c6b35bf0 c6ba2ea0 c6b99ed8 c6785d00 c11b4428     
> <0> c6b32bf0 c6ba2ea0 c6785d14 c11b5b3f 01ba3df0 000000dc 00000005 c6785d30     
> Call Trace:                                                                     
>  [<c11c8175>] ? ohci_endpoint_disable+0x113/0x192                               
>  [<c11b4428>] ? usb_hcd_disable_endpoint+0x2e/0x32                              
>  [<c11b5b3f>] ? usb_disable_endpoint+0x6d/0x72                                  
>  [<c11b5cae>] ? usb_disable_interface+0x30/0x3f                                 
>  [<c11b70ac>] ? usb_set_interface+0x11b/0x1a0                                   
>  [<c8872e1d>] ? gspca_set_alt0+0x23/0x46 [gspca_main]                           
>  [<c8872e75>] ? gspca_stream_off+0x35/0x5f [gspca_main]                         
>  [<c8872ef8>] ? vidioc_streamoff+0x59/0xb4 [gspca_main]                         
>  [<c8817244>] ? __video_do_ioctl+0x17af/0x3920 [videodev]                       
>  [<c1032fa1>] ? __lock_acquire+0x6ef/0x755                                      
>  [<c102f436>] ? lock_release_holdtime+0x81/0x86                                 
>  [<c103315c>] ? lock_release_non_nested+0xab/0x1cf                              
>  [<c105382f>] ? might_fault+0x3d/0x79                                           
>  [<c105382f>] ? might_fault+0x3d/0x79                                           
>  [<c11123d4>] ? copy_from_user+0x31/0x54                                        
>  [<c88196b8>] ? video_ioctl2+0x303/0x3ea [videodev]                             
>  [<c102f436>] ? lock_release_holdtime+0x81/0x86                                 
>  [<c12e430e>] ? _spin_unlock_irqrestore+0x36/0x3c                               
>  [<c103086c>] ? trace_hardirqs_on_caller+0x104/0x12b                            
>  [<c103089e>] ? trace_hardirqs_on+0xb/0xd                                       
>  [<c88193b5>] ? video_ioctl2+0x0/0x3ea [videodev]                               
>  [<c88156d8>] ? v4l2_unlocked_ioctl+0x2e/0x32 [videodev]                        
>  [<c88156aa>] ? v4l2_unlocked_ioctl+0x0/0x32 [videodev]                         
>  [<c106dd91>] ? vfs_ioctl+0x19/0x50                                             
>  [<c106e36b>] ? do_vfs_ioctl+0x458/0x4a3                                        
>  [<c1155a42>] ? tty_ldisc_deref+0x8/0xa                                         
>  [<c1150c1c>] ? tty_write+0x1b1/0x1c2                                           
>  [<c1152d69>] ? n_tty_write+0x0/0x2e6                                           
>  [<c1150a6b>] ? tty_write+0x0/0x1c2                                             
>  [<c106431d>] ? vfs_write+0xe3/0xfa                                             
>  [<c1002858>] ? restore_all_notrace+0x0/0x18                                    
>  [<c106e3e2>] ? sys_ioctl+0x2c/0x45                                             
>  [<c1002825>] ? syscall_call+0x7/0xb                                            
> Code: e5 e8 bf 7b e9 ff 5d c3 55 89 e5 57 89 c7 56 89 d6 53 8b 42 28 89 c2 c1
> ea 06 31 d0 83 e0 3f 8d 94 87 cc 00 00 00 eb 03 8d 50 1c <8b> 02 85 c0 74 0b 39 
> EIP: [<c11c5cef>] td_free+0x23/0x75 SS:ESP 0068:c6785cb8                        
> CR2: 00000000a7a7a7c3                                                           

And here's the real oops.  drivers/usb/host/ohci-mem.c:td_free()
dereferenced a7a7a7c3.  Which looks like

/********** drivers/base/dmapool.c **********/
#define	POOL_POISON_FREED	0xa7	/* !inuse */
#define	POOL_POISON_ALLOCATED	0xa9	/* !initted */

