Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:1684 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZKGUL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 15:11:28 -0500
Message-ID: <4AF5D45B.2060003@toaster.net>
Date: Sat, 07 Nov 2009 12:11:07 -0800
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Another gpsca kernel BUG when disconnecting camera while streaming
 with mmap
References: <4AF14B43.6060303@toaster.net> <4AF57C74.8020402@redhat.com>
In-Reply-To: <4AF57C74.8020402@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your reply.

That makes a lot of sense, because this is an embedded platform and 
there is no swap! But there seems to be 89544K free while 
capture-example is running. hmmm.

Sean Lazar

Hans de Goede wrote:
> Hi,
>
> On 11/04/2009 10:37 AM, Sean wrote:
>> Hi, I am having a bug when removing my pac207 camera while
>> capture-example is streaming with mmap. It doesn't always do it. This is
>> a complete lock up - num lock key stops functioning. A related bug also
>> happens sometimes when capture-example finishes, that output is 
>> included.
>>
>> Debug kernel is 2.6.31.5, v4l-dvb version is f6680fa8e7ec.
>> (http://linuxtv.org/hg/v4l-dvb/archive/f6680fa8e7ec.tar.bz2) This is on
>> low end 486 hardware, 128MB ram, 300Mhz cpu.
>>
>> Let me know if I can try anything or if you need more output.
>>
>
> This does not seem to be a gspca specific bug, but you are simply running
> out of memory.
>
> The error:
> "unable to handle kernel paging request"
>
> Means the kernel could not find a free memory page for some data 
> structure
> it needed to allocate for itself at the time the oops happened.
>
> Regards,
>
> Hans
>
>
>
>> ------------------
>> pac207 camera removal - complete lock up:
>> ------------------
>> [root@X-Linux]:~ # capture-example
>> ..............................usb 4-2: USB disconnect, address 6
>> BUG: unable to handle kernel paging request at a7a7a7c3
>> IP: [<c11c5cef>] td_free+0x23/0x75
>> *pde = 00000000
>> Oops: 0000 [#1] DEBUG_PAGEALLOC
>> last sysfs file:
>> Modules linked in: gspca_pac207 gspca_main videodev v4l1_compat
>>
>> Pid: 160, comm: khubd Not tainted (2.6.31.5 #2)
>> EIP: 0060:[<c11c5cef>] EFLAGS: 00000087 CPU: 0
>> EIP is at td_free+0x23/0x75
>> EAX: a7a7a7a7 EBX: c6b46bf0 ECX: c6b46ce4 EDX: a7a7a7c3
>> ESI: c6b97880 EDI: c6b46cd4 EBP: c798de78 ESP: c798de6c
>> DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>> Process khubd (pid: 160, ti=c798c000 task=c7994338 task.ti=c798c000)
>> Stack:
>> c6b46bf0 000003e8 c6b46cd4 c798dea4 c11c8175 c6532ea0 c6b46bf0 00000000
>> <0> c11b518a 00000286 c6b96000 c6b46bf0 c6532ea0 c14062e5 c798deb4 
>> c11b4428
>> <0> c6b36bf0 c6532ea0 c798dec8 c11b5b3f 014234b3 00000006 00000000 
>> c798deec
>> Call Trace:
>> [<c11c8175>] ? ohci_endpoint_disable+0x113/0x192
>> [<c11b518a>] ? usb_free_urb+0x11/0x13
>> [<c11b4428>] ? usb_hcd_disable_endpoint+0x2e/0x32
>> [<c11b5b3f>] ? usb_disable_endpoint+0x6d/0x72
>> [<c11b5bad>] ? usb_disable_device+0x69/0x13a
>> [<c1017619>] ? printk+0x15/0x17
>> [<c11b12a8>] ? usb_disconnect+0xa1/0xf7
>> [<c11b18bf>] ? hub_thread+0x484/0xcec
>> [<c12e23cd>] ? schedule+0x3b0/0x3d5
>> [<c1026151>] ? autoremove_wake_function+0x0/0x33
>> [<c11b143b>] ? hub_thread+0x0/0xcec
>> [<c10260aa>] ? kthread+0x6b/0x71
>> [<c102603f>] ? kthread+0x0/0x71
>> [<c1002f97>] ? kernel_thread_helper+0x7/0x10
>> Code: e5 e8 bf 7b e9 ff 5d c3 55 89 e5 57 89 c7 56 89 d6 53 8b 42 28 89
>> c2 c1 ea 06 31 d0 83 e0 3f 8d 94 87 cc 00 00 00 eb 03 8d 50 1c <8b> 02
>> 85 c0 74 0b 39 f0 75 f3 8b 46 1c 89 02 eb 29 8b 06 25 00
>> EIP: [<c11c5cef>] td_free+0x23/0x75 SS:ESP 0068:c798de6c
>> CR2: 00000000a7a7a7c3
>> ---[ end trace 2ee1dbf620895015 ]---
>> BUG: spinlock lockup on CPU#0, swapper/0, c6b46cd4
>> Pid: 0, comm: swapper Tainted: G D 2.6.31.5 #2
>> Call Trace:
>> [<c111e85c>] _raw_spin_lock+0xad/0xc9
>> [<c12e4210>] _spin_lock_irqsave+0x46/0x5a
>> [<c11c991e>] ohci_hub_status_data+0x1d/0x1d8
>> [<c11b3779>] usb_hcd_poll_rh_status+0x49/0x148
>> [<c11b3880>] rh_timer_func+0x8/0xa
>> [<c101dcbe>] run_timer_softirq+0x154/0x1c3
>> [<c101dc59>] ? run_timer_softirq+0xef/0x1c3
>> [<c11b3878>] ? rh_timer_func+0x0/0xa
>> [<c101a7d9>] __do_softirq+0x9f/0x14d
>> [<c101a8b1>] do_softirq+0x2a/0x42
>> [<c101ab94>] irq_exit+0x33/0x35
>> [<c1004086>] do_IRQ+0x5b/0x71
>> [<c1002e6e>] common_interrupt+0x2e/0x40
>> [<c10018f8>] ? cpu_idle+0x1b/0x35
>> [<c1006d03>] ? default_idle+0x59/0x9c
>> [<c12e007b>] ? sdhci_pci_probe+0x410/0x42c
>> [<c1006d05>] ? default_idle+0x5b/0x9c
>> [<c10018fe>] cpu_idle+0x21/0x35
>> [<c12d3c31>] rest_init+0x4d/0x4f
>> [<c15ed72e>] start_kernel+0x2a6/0x2ad
>> [<c15ed068>] i386_start_kernel+0x68/0x6d
>>
>>
>> ------------------
>> capture-example crash on program end:
>> ------------------
>> [root@X-Linux]:~ # capture-example
>> ......................................................................BUG: 
>>
>> sleeping function called from invalid context at 
>> arch/x86/mm/fault.c:1069
>> in_atomic(): 0, irqs_disabled(): 1, pid: 1183, name: capture-example
>> 4 locks held by capture-example/1183:
>> #0: (&gspca_dev->queue_lock){+.+.+.}, at: [<c8866fbb>]
>> vidioc_streamoff+0x3b/0xb4 [gspca_main]
>> #1: (&gspca_dev->usb_lock){+.+.+.}, at: [<c8866fce>]
>> vidioc_streamoff+0x4e/0xb4 [gspca_main]
>> #2: (&ohci->lock){-.-...}, at: [<c11c8093>]
>> ohci_endpoint_disable+0x31/0x192
>> #3: (&mm->mmap_sem){++++++}, at: [<c100c168>] do_page_fault+0xc1/0x1fe
>> irq event stamp: 11502
>> hardirqs last enabled at (11501): [<c12e41a0>] 
>> _spin_unlock_irq+0x22/0x26
>> hardirqs last disabled at (11502): [<c12e41da>]
>> _spin_lock_irqsave+0x10/0x5a
>> softirqs last enabled at (11486): [<c101a87f>] __do_softirq+0x145/0x14d
>> softirqs last disabled at (11481): [<c101a8b1>] do_softirq+0x2a/0x42
>> Pid: 1183, comm: capture-example Not tainted 2.6.31.5 #2
>> Call Trace:
>> [<c101222d>] __might_sleep+0xcb/0xd0
>> [<c100c1ad>] do_page_fault+0x106/0x1fe
>> [<c100c0a7>] ? do_page_fault+0x0/0x1fe
>> [<c12e43c3>] error_code+0x63/0x70
>> [<c100c0a7>] ? do_page_fault+0x0/0x1fe
>> [<c11c5cef>] ? td_free+0x23/0x75
>> [<c11c8175>] ohci_endpoint_disable+0x113/0x192
>> [<c11b4428>] usb_hcd_disable_endpoint+0x2e/0x32
>> [<c11b5b3f>] usb_disable_endpoint+0x6d/0x72
>> [<c11b5cae>] usb_disable_interface+0x30/0x3f
>> [<c11b70ac>] usb_set_interface+0x11b/0x1a0
>> [<c8866efe>] gspca_set_alt0+0x23/0x46 [gspca_main]
>> [<c8866f56>] gspca_stream_off+0x35/0x5f [gspca_main]
>> [<c8866fd9>] vidioc_streamoff+0x59/0xb4 [gspca_main]
>> [<c881c24a>] __video_do_ioctl+0x17c5/0x39c3 [videodev]
>> [<c1032fa1>] ? __lock_acquire+0x6ef/0x755
>> [<c102f436>] ? lock_release_holdtime+0x81/0x86
>> [<c103315c>] ? lock_release_non_nested+0xab/0x1cf
>> [<c105382f>] ? might_fault+0x3d/0x79
>> [<c105382f>] ? might_fault+0x3d/0x79
>> [<c11123d4>] ? copy_from_user+0x31/0x54
>> [<c881e74b>] video_ioctl2+0x303/0x3ea [videodev]
>> [<c102f436>] ? lock_release_holdtime+0x81/0x86
>> [<c12e430e>] ? _spin_unlock_irqrestore+0x36/0x3c
>> [<c103086c>] ? trace_hardirqs_on_caller+0x104/0x12b
>> [<c103089e>] ? trace_hardirqs_on+0xb/0xd
>> [<c881e448>] ? video_ioctl2+0x0/0x3ea [videodev]
>> [<c881a6c8>] v4l2_unlocked_ioctl+0x2e/0x32 [videodev]
>> [<c881a69a>] ? v4l2_unlocked_ioctl+0x0/0x32 [videodev]
>> [<c106dd91>] vfs_ioctl+0x19/0x50
>> [<c106e36b>] do_vfs_ioctl+0x458/0x4a3
>> [<c1155a42>] ? tty_ldisc_deref+0x8/0xa
>> [<c1150c1c>] ? tty_write+0x1b1/0x1c2
>> [<c1152d69>] ? n_tty_write+0x0/0x2e6
>> [<c1150a6b>] ? tty_write+0x0/0x1c2
>> [<c106431d>] ? vfs_write+0xe3/0xfa
>> [<c1002858>] ? restore_all_notrace+0x0/0x18
>> [<c106e3e2>] sys_ioctl+0x2c/0x45
>> [<c1002825>] syscall_call+0x7/0xb
>> BUG: unable to handle kernel paging request at a7a7a7c3
>> IP: [<c11c5cef>] td_free+0x23/0x75
>> *pde = 00000000
>> Oops: 0000 [#1] DEBUG_PAGEALLOC
>> last sysfs file:
>> Modules linked in: gspca_pac207 gspca_main videodev v4l1_compat
>>
>> Pid: 1183, comm: capture-example Not tainted (2.6.31.5 #2)
>> EIP: 0060:[<c11c5cef>] EFLAGS: 00000083 CPU: 0
>> EIP is at td_free+0x23/0x75
>> EAX: a7a7a7a7 EBX: c6b46bf0 ECX: c6b46ce4 EDX: a7a7a7c3
>> ESI: c6b90840 EDI: c6b46cd4 EBP: c652dcc4 ESP: c652dcb8
>> DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>> Process capture-example (pid: 1183, ti=c652c000 task=c66fc338
>> task.ti=c652c000)
>> Stack:
>> c6b46bf0 000003e8 c6b46cd4 c652dcf0 c11c8175 c6bb7ea0 c6b46bf0 00000000
>> <0> c6b46bf0 00000292 c6b83040 c6b46bf0 c6bb7ea0 c6baced8 c652dd00 
>> c11b4428
>> <0> c6b44bf0 c6bb7ea0 c652dd14 c11b5b3f 01bb8df0 000000dc 00000005 
>> c652dd30
>> Call Trace:
>> [<c11c8175>] ? ohci_endpoint_disable+0x113/0x192
>> [<c11b4428>] ? usb_hcd_disable_endpoint+0x2e/0x32
>> [<c11b5b3f>] ? usb_disable_endpoint+0x6d/0x72
>> [<c11b5cae>] ? usb_disable_interface+0x30/0x3f
>> [<c11b70ac>] ? usb_set_interface+0x11b/0x1a0
>> [<c8866efe>] ? gspca_set_alt0+0x23/0x46 [gspca_main]
>> [<c8866f56>] ? gspca_stream_off+0x35/0x5f [gspca_main]
>> [<c8866fd9>] ? vidioc_streamoff+0x59/0xb4 [gspca_main]
>> [<c881c24a>] ? __video_do_ioctl+0x17c5/0x39c3 [videodev]
>> [<c1032fa1>] ? __lock_acquire+0x6ef/0x755
>> [<c102f436>] ? lock_release_holdtime+0x81/0x86
>> [<c103315c>] ? lock_release_non_nested+0xab/0x1cf
>> [<c105382f>] ? might_fault+0x3d/0x79
>> [<c105382f>] ? might_fault+0x3d/0x79
>> [<c11123d4>] ? copy_from_user+0x31/0x54
>> [<c881e74b>] ? video_ioctl2+0x303/0x3ea [videodev]
>> [<c102f436>] ? lock_release_holdtime+0x81/0x86
>> [<c12e430e>] ? _spin_unlock_irqrestore+0x36/0x3c
>> [<c103086c>] ? trace_hardirqs_on_caller+0x104/0x12b
>> [<c103089e>] ? trace_hardirqs_on+0xb/0xd
>> [<c881e448>] ? video_ioctl2+0x0/0x3ea [videodev]
>> [<c881a6c8>] ? v4l2_unlocked_ioctl+0x2e/0x32 [videodev]
>> [<c881a69a>] ? v4l2_unlocked_ioctl+0x0/0x32 [videodev]
>> [<c106dd91>] ? vfs_ioctl+0x19/0x50
>> [<c106e36b>] ? do_vfs_ioctl+0x458/0x4a3
>> [<c1155a42>] ? tty_ldisc_deref+0x8/0xa
>> [<c1150c1c>] ? tty_write+0x1b1/0x1c2
>> [<c1152d69>] ? n_tty_write+0x0/0x2e6
>> [<c1150a6b>] ? tty_write+0x0/0x1c2
>> [<c106431d>] ? vfs_write+0xe3/0xfa
>> [<c1002858>] ? restore_all_notrace+0x0/0x18
>> [<c106e3e2>] ? sys_ioctl+0x2c/0x45
>> [<c1002825>] ? syscall_call+0x7/0xb
>> Code: e5 e8 bf 7b e9 ff 5d c3 55 89 e5 57 89 c7 56 89 d6 53 8b 42 28 89
>> c2 c1 ea 06 31 d0 83 e0 3f 8d 94 87 cc 00 00 00 eb 03 8d 50 1c <8b> 02
>> 85 c0 74 0b 39 f0 75 f3 8b 46 1c 89 02 eb 29 8b 06 25 00
>> EIP: [<c11c5cef>] td_free+0x23/0x75 SS:ESP 0068:c652dcb8
>> CR2: 00000000a7a7a7c3
>> ---[ end trace 0f832b0b46200cb4 ]---
>>
>>
>> Sean Lazar
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
