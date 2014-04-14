Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:49593 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752553AbaDNCVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Apr 2014 22:21:44 -0400
Date: Sun, 13 Apr 2014 22:21:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sander Eikelenboom <linux@eikelenboom.it>
cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Williams <dan.j.williams@intel.com>,
	<linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-usb@vger.kernel.org>
Subject: Re: stk1160 / ehci-pci 0000:00:0a.0: DMA-API: device driver maps
 memory fromstack [addr=ffff88003d0b56bf]
In-Reply-To: <438386739.20140413224553@eikelenboom.it>
Message-ID: <Pine.LNX.4.44L0.1404132220550.24243-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 13 Apr 2014, Sander Eikelenboom wrote:

> Hi,
> 
> I'm hitting this warning on boot with a syntek usb video grabber, it's not clear 
> to me if it's a driver issue of the stk1160 or a generic ehci issue.

It is a bug in the stk1160 driver.

> This is with a 3.15-mergewindow kernel (pull of Linus his tree of today). 
> 
> --
> Sander
> 
> [    5.587759] ------------[ cut here ]------------
> [    5.591210] WARNING: CPU: 0 PID: 1376 at lib/dma-debug.c:1153 check_for_stack+0xa0/0x100()
> [    5.596612] ehci-pci 0000:00:0a.0: DMA-API: device driver maps memory fromstack [addr=ffff88003d0b56bf]
> [    5.602548] Modules linked in:
> [    5.605380] CPU: 0 PID: 1376 Comm: khubd Not tainted 3.14.0-security-20140413-v4lall+ #1
> [    5.611042] Hardware name: Xen HVM domU, BIOS 4.5-unstable 04/10/2014
> [    5.615314]  0000000000000009 ffff88003d0b5348 ffffffff81c516fe ffff88003d0b5390
> [    5.622147]  ffff88003d0b5380 ffffffff810e4aa3 ffff88003ceae898 ffff88003cf14070
> [    5.628926]  ffff88003d0b56bf ffff88003ceae898 ffffffff8241ab40 ffff88003d0b53e0
> [    5.635536] Call Trace:
> [    5.638001]  [<ffffffff81c516fe>] dump_stack+0x45/0x56
> [    5.641633]  [<ffffffff810e4aa3>] warn_slowpath_common+0x73/0x90
> [    5.645688]  [<ffffffff810e4b07>] warn_slowpath_fmt+0x47/0x50
> [    5.649843]  [<ffffffff81468820>] check_for_stack+0xa0/0x100
> [    5.652420] systemd-udevd[2143]: starting version 204
> [    5.657709]  [<ffffffff814699fc>] debug_dma_map_page+0xfc/0x150
> [    5.661836]  [<ffffffff8172109c>] usb_hcd_map_urb_for_dma+0x5fc/0x710
> [    5.666132]  [<ffffffff817214c5>] usb_hcd_submit_urb+0x315/0xa30
> [    5.670247]  [<ffffffff810ef85a>] ? del_timer_sync+0x4a/0x60
> [    5.674072]  [<ffffffff81c6291d>] ? schedule_timeout+0x14d/0x1f0
> [    5.678083]  [<ffffffff810ef2a0>] ? migrate_timer_list+0x60/0x60
> [    5.682167]  [<ffffffff81722fac>] usb_submit_urb+0x30c/0x580
> [    5.685989]  [<ffffffff81c63f4b>] ? wait_for_common+0x16b/0x240
> [    5.689919]  [<ffffffff817236fa>] usb_start_wait_urb+0x5a/0xe0
> [    5.693830]  [<ffffffff811b0000>] ? mpol_rebind_policy+0x30/0xa0
> [    5.697638]  [<ffffffff81723838>] usb_control_msg+0xb8/0x100
> [    5.701468]  [<ffffffff81984ab2>] stk1160_read_reg+0x52/0x80
> [    5.705358]  [<ffffffff8198690c>] stk1160_i2c_busy_wait+0x6c/0x90

The bug is here.  stk1160_i2c_busy_wait() passes the address of a   
variable on the stack to stk1160_read_reg(), and that routine passes
the address to usb_control_msg().  But usb_control_msg() requires the
buffer to be allocated by kmalloc, not on the stack.

Alan Stern

