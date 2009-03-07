Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCGF01 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 00:26:27 -0500
Date: Fri, 6 Mar 2009 21:26:11 -0800
From: Greg KH <gregkh@suse.de>
To: Brandon Philips <brandon@ifup.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: laurent.pinchart@skynet.be, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
	is probably using the wrong IRQ."
Message-ID: <20090307052611.GA15139@suse.de>
References: <20090306191122.GA4799@jenkins.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306191122.GA4799@jenkins.ifup.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 06, 2009 at 11:11:22AM -0800, Brandon Philips wrote:
> Hello-
> 
> When an UVC device is open and a S4 is attempted the thaw hangs (see the
> stack below). I don't see what the UVC driver is doing wrong to cause
> this to happen though.

I don't think this is a uvc driver issue, it looks like all you are
trying to do is a usb control message when things hang.

> To make it quick to reproduce you can use init=/bin/bash and a little
> program to open up and setup the device:
>  http://ifup.org/~philips/467317/v4l-open-sleep.c
> 
> Here is a full log with some verbose debugging on:
>  http://ifup.org/~philips/467317/pearl.log
> 
> The driver acts fine when using s2ram suspend and pm debugging levels.
> On my Poweredge SC440 the S4 suspend restores the device properly but on
> my Lenovo x200s and this Intel test box it hangs.
> 
> Cheers,
> 
> 	Brandon
> 
> Linux version 2.6.29-rc7-1-default (root@pearl) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #4 SMP Fri Mar 6 01:29:35 PST 2009
> 
> SysRq : Show Blocked State
>   task                        PC stack   pid father
> bash          D ffff880078524c94     0     1      0
>  ffff88007bb9fae8 0000000000000082 0000000000000292 ffff88003747d140
>  ffffffff80816f00 ffffffff80816f00 ffff88007bb9c040 ffff88007bb9c3b8
>  0000000000000292 ffffffff80630350 ffff88003754d000 ffff880078524c80
> Call Trace:
>  [<ffffffff8036d8a8>] ? kobject_put+0x47/0x4b
>  [<ffffffff802253a5>] ? default_spin_lock_flags+0x17/0x1a
>  [<ffffffffa011ae2b>] usb_kill_urb+0x9d/0xbd [usbcore]
>  [<ffffffff80258ca4>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffffa011c3a3>] usb_start_wait_urb+0xd9/0x1c2 [usbcore]
>  [<ffffffffa011b52c>] ? usb_init_urb+0x22/0x33 [usbcore]
>  [<ffffffffa011c6c8>] usb_control_msg+0x114/0x15b [usbcore]
>  [<ffffffffa03433e7>] uvc_set_video_ctrl+0x134/0x184 [uvcvideo]
>  [<ffffffffa0343442>] uvc_commit_video+0xb/0xd [uvcvideo]
>  [<ffffffffa0343504>] uvc_video_resume+0x1e/0x58 [uvcvideo]
>  [<ffffffffa033e112>] __uvc_resume+0x99/0xa1 [uvcvideo]
>  [<ffffffffa033e135>] uvc_resume+0xb/0xd [uvcvideo]
>  [<ffffffffa011dce6>] usb_resume_interface+0xdf/0x165 [usbcore]
>  [<ffffffffa011e1ee>] usb_resume_both+0x102/0x128 [usbcore]
>  [<ffffffffa011ed37>] usb_external_resume_device+0x33/0x6e [usbcore]
>  [<ffffffffa011ed8d>] usb_resume+0x1b/0x1d [usbcore]
>  [<ffffffffa0113178>] usb_dev_thaw+0xe/0x10 [usbcore]
>  [<ffffffff803fb100>] pm_op+0xa4/0xe5
>  [<ffffffff803fbd02>] device_resume+0x137/0x47b
>  [<ffffffff8026e4e9>] hibernation_snapshot+0x1ba/0x1fa
>  [<ffffffff8026e5ec>] hibernate+0xc3/0x1a1
>  [<ffffffff8026d15a>] state_store+0x59/0xd8
>  [<ffffffff8036d69f>] kobj_attr_store+0x17/0x19
>  [<ffffffff8031d04b>] sysfs_write_file+0xdf/0x114
>  [<ffffffff802cc8bd>] vfs_write+0xae/0x157
>  [<ffffffff802cca2a>] sys_write+0x47/0x70
>  [<ffffffff8020c42a>] system_call_fastpath+0x16/0x1b

That's the control message timing out and trying to reap the urb.

But the problem is the khubd is asleep, from your log file:

khubd         D 0000000000000000     0   255      2
 ffff880037509d80 0000000000000046 ffff88007864ba80 ffffffff8088fcf8
 ffffffff80816f00 ffffffff80816f00 ffff8800375b0380 ffff8800375b06f8
 0000000080816f00 ffff88007bb9c040 ffff8800375b0380 ffff8800375b06f8
Call Trace:
 [<ffffffff802253a5>] ? default_spin_lock_flags+0x17/0x1a
 [<ffffffff8025e7a9>] refrigerator+0x170/0x1cf
 [<ffffffffa01187ab>] hub_thread+0x1370/0x13bd [usbcore]
 [<ffffffff8020a7c2>] ? __switch_to+0xd4/0x4b3
 [<ffffffff80258ca4>] ? autoremove_wake_function+0x0/0x38
 [<ffffffffa011743b>] ? hub_thread+0x0/0x13bd [usbcore]
 [<ffffffff8025890b>] kthread+0x49/0x76
 [<ffffffff8020d69a>] child_rip+0xa/0x20
 [<ffffffff802588c2>] ? kthread+0x0/0x76
 [<ffffffff8020d690>] ? child_rip+0x0/0x20

udevd is also stuck in the refrigerator, which seems wierd as well.
a.out is also stuck, is that your test program?

It looks like things die right after this message:
	ehci_hcd 0000:00:1d.7: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.

Alan, what causes this at resume time?

thanks,

greg k-h
