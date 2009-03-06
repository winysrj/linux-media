Return-path: <linux-media-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:27084 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZCFTMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 14:12:03 -0500
Date: Fri, 6 Mar 2009 11:11:22 -0800
From: Brandon Philips <brandon@ifup.org>
To: laurent.pinchart@skynet.be, gregkh@suse.de
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: S4 hang with uvcvideo causing "Unlink after no-IRQ?  Controller is
	probably using the wrong IRQ."
Message-ID: <20090306191122.GA4799@jenkins.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello-

When an UVC device is open and a S4 is attempted the thaw hangs (see the
stack below). I don't see what the UVC driver is doing wrong to cause
this to happen though.

To make it quick to reproduce you can use init=/bin/bash and a little
program to open up and setup the device:
 http://ifup.org/~philips/467317/v4l-open-sleep.c

Here is a full log with some verbose debugging on:
 http://ifup.org/~philips/467317/pearl.log

The driver acts fine when using s2ram suspend and pm debugging levels.
On my Poweredge SC440 the S4 suspend restores the device properly but on
my Lenovo x200s and this Intel test box it hangs.

Cheers,

	Brandon

Linux version 2.6.29-rc7-1-default (root@pearl) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #4 SMP Fri Mar 6 01:29:35 PST 2009

SysRq : Show Blocked State
  task                        PC stack   pid father
bash          D ffff880078524c94     0     1      0
 ffff88007bb9fae8 0000000000000082 0000000000000292 ffff88003747d140
 ffffffff80816f00 ffffffff80816f00 ffff88007bb9c040 ffff88007bb9c3b8
 0000000000000292 ffffffff80630350 ffff88003754d000 ffff880078524c80
Call Trace:
 [<ffffffff8036d8a8>] ? kobject_put+0x47/0x4b
 [<ffffffff802253a5>] ? default_spin_lock_flags+0x17/0x1a
 [<ffffffffa011ae2b>] usb_kill_urb+0x9d/0xbd [usbcore]
 [<ffffffff80258ca4>] ? autoremove_wake_function+0x0/0x38
 [<ffffffffa011c3a3>] usb_start_wait_urb+0xd9/0x1c2 [usbcore]
 [<ffffffffa011b52c>] ? usb_init_urb+0x22/0x33 [usbcore]
 [<ffffffffa011c6c8>] usb_control_msg+0x114/0x15b [usbcore]
 [<ffffffffa03433e7>] uvc_set_video_ctrl+0x134/0x184 [uvcvideo]
 [<ffffffffa0343442>] uvc_commit_video+0xb/0xd [uvcvideo]
 [<ffffffffa0343504>] uvc_video_resume+0x1e/0x58 [uvcvideo]
 [<ffffffffa033e112>] __uvc_resume+0x99/0xa1 [uvcvideo]
 [<ffffffffa033e135>] uvc_resume+0xb/0xd [uvcvideo]
 [<ffffffffa011dce6>] usb_resume_interface+0xdf/0x165 [usbcore]
 [<ffffffffa011e1ee>] usb_resume_both+0x102/0x128 [usbcore]
 [<ffffffffa011ed37>] usb_external_resume_device+0x33/0x6e [usbcore]
 [<ffffffffa011ed8d>] usb_resume+0x1b/0x1d [usbcore]
 [<ffffffffa0113178>] usb_dev_thaw+0xe/0x10 [usbcore]
 [<ffffffff803fb100>] pm_op+0xa4/0xe5
 [<ffffffff803fbd02>] device_resume+0x137/0x47b
 [<ffffffff8026e4e9>] hibernation_snapshot+0x1ba/0x1fa
 [<ffffffff8026e5ec>] hibernate+0xc3/0x1a1
 [<ffffffff8026d15a>] state_store+0x59/0xd8
 [<ffffffff8036d69f>] kobj_attr_store+0x17/0x19
 [<ffffffff8031d04b>] sysfs_write_file+0xdf/0x114
 [<ffffffff802cc8bd>] vfs_write+0xae/0x157
 [<ffffffff802cca2a>] sys_write+0x47/0x70
 [<ffffffff8020c42a>] system_call_fastpath+0x16/0x1b
