Return-path: <linux-media-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:58014 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbaDMUp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Apr 2014 16:45:59 -0400
Date: Sun, 13 Apr 2014 22:45:53 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <438386739.20140413224553@eikelenboom.it>
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: Dan Williams <dan.j.williams@intel.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-usb@vger.kernel.org>
Subject: stk1160 / ehci-pci 0000:00:0a.0: DMA-API: device driver maps memory fromstack [addr=ffff88003d0b56bf]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm hitting this warning on boot with a syntek usb video grabber, it's not clear 
to me if it's a driver issue of the stk1160 or a generic ehci issue.

This is with a 3.15-mergewindow kernel (pull of Linus his tree of today). 

--
Sander

[    5.587759] ------------[ cut here ]------------
[    5.591210] WARNING: CPU: 0 PID: 1376 at lib/dma-debug.c:1153 check_for_stack+0xa0/0x100()
[    5.596612] ehci-pci 0000:00:0a.0: DMA-API: device driver maps memory fromstack [addr=ffff88003d0b56bf]
[    5.602548] Modules linked in:
[    5.605380] CPU: 0 PID: 1376 Comm: khubd Not tainted 3.14.0-security-20140413-v4lall+ #1
[    5.611042] Hardware name: Xen HVM domU, BIOS 4.5-unstable 04/10/2014
[    5.615314]  0000000000000009 ffff88003d0b5348 ffffffff81c516fe ffff88003d0b5390
[    5.622147]  ffff88003d0b5380 ffffffff810e4aa3 ffff88003ceae898 ffff88003cf14070
[    5.628926]  ffff88003d0b56bf ffff88003ceae898 ffffffff8241ab40 ffff88003d0b53e0
[    5.635536] Call Trace:
[    5.638001]  [<ffffffff81c516fe>] dump_stack+0x45/0x56
[    5.641633]  [<ffffffff810e4aa3>] warn_slowpath_common+0x73/0x90
[    5.645688]  [<ffffffff810e4b07>] warn_slowpath_fmt+0x47/0x50
[    5.649843]  [<ffffffff81468820>] check_for_stack+0xa0/0x100
[    5.652420] systemd-udevd[2143]: starting version 204
[    5.657709]  [<ffffffff814699fc>] debug_dma_map_page+0xfc/0x150
[    5.661836]  [<ffffffff8172109c>] usb_hcd_map_urb_for_dma+0x5fc/0x710
[    5.666132]  [<ffffffff817214c5>] usb_hcd_submit_urb+0x315/0xa30
[    5.670247]  [<ffffffff810ef85a>] ? del_timer_sync+0x4a/0x60
[    5.674072]  [<ffffffff81c6291d>] ? schedule_timeout+0x14d/0x1f0
[    5.678083]  [<ffffffff810ef2a0>] ? migrate_timer_list+0x60/0x60
[    5.682167]  [<ffffffff81722fac>] usb_submit_urb+0x30c/0x580
[    5.685989]  [<ffffffff81c63f4b>] ? wait_for_common+0x16b/0x240
[    5.689919]  [<ffffffff817236fa>] usb_start_wait_urb+0x5a/0xe0
[    5.693830]  [<ffffffff811b0000>] ? mpol_rebind_policy+0x30/0xa0
[    5.697638]  [<ffffffff81723838>] usb_control_msg+0xb8/0x100
[    5.701468]  [<ffffffff81984ab2>] stk1160_read_reg+0x52/0x80
[    5.705358]  [<ffffffff8198690c>] stk1160_i2c_busy_wait+0x6c/0x90
[    5.709656]  [<ffffffff81986afb>] stk1160_i2c_xfer+0x1cb/0x440
[    5.713647]  [<ffffffff81126052>] ? irq_to_desc+0x12/0x20
[    5.717515]  [<ffffffff81129329>] ? irq_get_irq_data+0x9/0x10
[    5.721432]  [<ffffffff8178a1ac>] __i2c_transfer+0x5c/0x80
[    5.725783]  [<ffffffff8178b48b>] i2c_transfer+0x5b/0x90
[    5.730187]  [<ffffffff8178b676>] i2c_smbus_xfer_emulated+0x116/0x570
[    5.735194]  [<ffffffff8110f8ce>] ? wake_up_process+0x1e/0x40
[    5.739631]  [<ffffffff81c63f4b>] ? wait_for_common+0x16b/0x240
[    5.744338]  [<ffffffff8111da6f>] ? __wake_up+0x3f/0x50
[    5.748997]  [<ffffffff8178bbc2>] i2c_smbus_xfer+0xf2/0x140
[    5.753538]  [<ffffffff8178bcd3>] i2c_default_probe+0xc3/0x100
[    5.758173]  [<ffffffff8178a586>] ? i2c_check_addr_busy+0x36/0x60
[    5.763227]  [<ffffffff8178a892>] i2c_new_probed_device+0x92/0xe0
[    5.768736]  [<ffffffff8178bc10>] ? i2c_smbus_xfer+0x140/0x140
[    5.774035]  [<ffffffff81844bdf>] v4l2_i2c_new_subdev_board+0x4f/0x100
[    5.779495]  [<ffffffff81844ce8>] v4l2_i2c_new_subdev+0x58/0x70
[    5.784638]  [<ffffffff81984fdf>] stk1160_probe+0x3df/0x4e0
[    5.789553]  [<ffffffff81726dda>] usb_probe_interface+0xca/0x1d0
[    5.794659]  [<ffffffff816408d6>] really_probe+0x56/0x1e0
[    5.799231]  [<ffffffff81640a60>] ? really_probe+0x1e0/0x1e0
[    5.804225]  [<ffffffff81640aa8>] __device_attach+0x48/0x50
[    5.809514]  [<ffffffff8163ecf3>] bus_for_each_drv+0x53/0x90
[    5.814602]  [<ffffffff81640868>] device_attach+0x88/0xa0
[    5.819487]  [<ffffffff8163fe08>] bus_probe_device+0x98/0xc0
[    5.824337]  [<ffffffff8163dfbc>] device_add+0x4bc/0x5c0
[    5.829267]  [<ffffffff81725a15>] usb_set_configuration+0x495/0x7a0
[    5.834590]  [<ffffffff8172eff9>] generic_probe+0x29/0xa0
[    5.839419]  [<ffffffff81725db5>] usb_probe_device+0x15/0x20
[    5.844594]  [<ffffffff816408d6>] really_probe+0x56/0x1e0
[    5.849538]  [<ffffffff81640a60>] ? really_probe+0x1e0/0x1e0
[    5.854444]  [<ffffffff81640aa8>] __device_attach+0x48/0x50
[    5.859393]  [<ffffffff8163ecf3>] bus_for_each_drv+0x53/0x90
[    5.864390]  [<ffffffff81640868>] device_attach+0x88/0xa0
[    5.869408]  [<ffffffff8163fe08>] bus_probe_device+0x98/0xc0
[    5.874652]  [<ffffffff8163dfbc>] device_add+0x4bc/0x5c0
[    5.879185]  [<ffffffff8171aec8>] usb_new_device+0x228/0x390
[    5.884283]  [<ffffffff8171da60>] hub_thread+0xdb0/0x14e0
[    5.888638]  [<ffffffff8110f6f0>] ? try_to_wake_up+0x100/0x2c0
[    5.892802]  [<ffffffff8111dec0>] ? abort_exclusive_wait+0xa0/0xa0
[    5.896554]  [<ffffffff8171ccb0>] ? usb_reset_device+0x180/0x180
[    5.900309]  [<ffffffff81103e3d>] kthread+0xcd/0xf0
[    5.903619]  [<ffffffff81103d70>] ? kthread_create_on_node+0x170/0x170
[    5.908064]  [<ffffffff81c6754c>] ret_from_fork+0x7c/0xb0
[    5.912017]  [<ffffffff81103d70>] ? kthread_create_on_node+0x170/0x170
[    5.916654] ---[ end trace 18f58175dc2f3152 ]---

