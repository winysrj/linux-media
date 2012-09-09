Return-path: <linux-media-owner@vger.kernel.org>
Received: from whitehail.bostoncoop.net ([66.199.252.235]:42161 "EHLO
	bostoncoop.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2IIMV4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 08:21:56 -0400
Date: Sun, 9 Sep 2012 08:21:55 -0400
From: Adam Rosi-Kessel <adam@rosi-kessel.org>
To: volokh@telros.ru
Cc: linux-media@vger.kernel.org, volokh84@gmail.com
Subject: Re: go7007 question
Message-ID: <20120909122155.GA29057@whitehail.bostoncoop.net>
References: <5044F8DC.20509@rosi-kessel.org> <20120906191014.GA2540@VPir.Home> <20120907141831.GA12333@VPir.telros.ru> <20120909022331.GA28838@whitehail.bostoncoop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120909022331.GA28838@whitehail.bostoncoop.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 08, 2012 at 10:23:31PM -0400, Adam Rosi-Kessel wrote:
> On Fri, Sep 07, 2012 at 06:18:31PM +0400, volokh@telros.ru wrote:
> > On Thu, Sep 06, 2012 at 11:10:14PM +0400, Volokh Konstantin wrote:
> e > On Mon, Sep 03, 2012 at 02:37:16PM -0400, Adam Rosi-Kessel wrote:
> > > > [469.928881] wis-saa7115: initializing SAA7115 at address 32 on WIS
> > > > GO7007SB EZ-USB
> > Hi, I generated patchs, that u may in your own go7007/ folder
> > It contains go7007 initialization and i2c_subdev fixing
> > It was checked for 3.6 branch (compile only)
> So I have this installed now (patched with your 3.6 patch) but I'm not
> seeing the device.

OK, this was just a problem of needing to mount /proc/usb. With that
mounted, the device is detected and the modules load automatically.
gorecord just hangs, however:

------------[ cut here ]------------
WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Hardware name: Inspiron 530
Device: usb
BOGUS urb xfer, pipe 1 != type 3
Modules linked in: wis_sony_tuner(C) wis_uda1342(C) go7007_usb(C) go7007(C) v4l2_common videodev media xt_LOG fuse ext4 jbd2 crc16 e1000e
[last unloaded: go7007]
Pid: 18595, comm: gorecord Tainted: G        WC   3.6.0-rc4
Call Trace:
 [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
 [<c13bc8fa>] ? usb_submit_urb+0x12a/0x3e0
 [<c13bc8fa>] ? usb_submit_urb+0x12a/0x3e0
 [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
 [<c13bc8fa>] usb_submit_urb+0x12a/0x3e0
 [<f938625a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
 [<f9371af4>] go7007_read_interrupt+0x24/0x100 [go7007]
 [<f938615e>] ? go7007_usb_send_firmware+0x3e/0x60 [go7007_usb]
 [<f9371c4d>] go7007_start_encoder+0x7d/0x120 [go7007]
 [<c1624d84>] ? mutex_lock+0x14/0x40
 [<f9370c2c>] vidioc_streamon+0xdc/0xf0 [go7007]
 [<f9004b75>] v4l_streamon+0x15/0x20 [videodev]
 [<f90070cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
 [<c1075933>] ? ktime_get+0x43/0xf0
 [<c107b9fa>] ? clockevents_program_event+0xca/0x180
 [<c122bd28>] ? _copy_from_user+0x38/0x130
 [<f9008b83>] video_usercopy+0x143/0x320 [videodev]
 [<c103be44>] ? irq_exit+0x54/0xc0
 [<c10218a4>] ? smp_apic_timer_interrupt+0x54/0x90
 [<c113b631>] ? inotify_handle_event+0x51/0xc0
 [<c113b510>] ? idr_callback+0x80/0x80
 [<c1626f66>] ? apic_timer_interrupt+0x2a/0x30
 [<f9008d72>] video_ioctl2+0x12/0x20 [videodev]
 [<f9006e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
 [<f9003913>] v4l2_ioctl+0x103/0x150 [videodev]
 [<f9003810>] ? v4l2_open+0x140/0x140 [videodev]
 [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
 [<c11e198a>] ? file_has_perm+0x9a/0xc0
 [<c11e1e86>] ? selinux_file_ioctl+0x56/0x110
 [<c11149cf>] sys_ioctl+0x7f/0x90
 [<c162d18c>] sysenter_do_call+0x12/0x22
---[ end trace 04d11de2981e53e3 ]---
