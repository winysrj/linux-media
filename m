Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:58661 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0AJTmK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 14:42:10 -0500
Message-ID: <4B4A2D8C.9030801@freemail.hu>
Date: Sun, 10 Jan 2010 20:42:04 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: leandro Costantino <lcostantino@gmail.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_sunplus problem: more than one device is created
References: <4B4A0268.20104@freemail.hu> <c2fe070d1001100911o52d989cdm69bda5bff94b37f5@mail.gmail.com>
In-Reply-To: <c2fe070d1001100911o52d989cdm69bda5bff94b37f5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

leandro Costantino wrote:
> Did that happen  with the included version on the kernel?.
> The kernel is calling the probe for the isoch and the bulk, i really
> dont have a sunplus webcam to test, and ignore the older behavior,
> that's why i am asking.

I tested with 2.6.33-rc2 on a Clevo D4J model D410J laptop. There only one
device is created. Not counting the circular locking that version is working
properly:

[  280.578560] usb 3-1: new full speed USB device using uhci_hcd and address 2
[  281.177675] Linux video capture interface: v2.00
[  281.229464] gspca: main v2.8.0 registered
[  281.260399] gspca: probing 06d6:0031
[  281.286724] gspca: video0 created
[  281.286909] gspca: probing 06d6:0031
[  281.286914] gspca: intf != 0
[  281.295106] usbcore: registered new interface driver sunplus
[  281.295122] sunplus: registered
[  581.086743]
[  581.086753] =======================================================
[  581.086770] [ INFO: possible circular locking dependency detected ]
[  581.086783] 2.6.33-rc2 #1
[  581.086790] -------------------------------------------------------
[  581.086800] svv/3409 is trying to acquire lock:
[  581.086811]  (sysfs_mutex){+.+.+.}, at: [<c03338e3>] sysfs_get_dirent+0x23/0xe0
[  581.086846]
[  581.086849] but task is already holding lock:
[  581.086858]  (&gspca_dev->usb_lock){+.+...}, at: [<f80f7019>] gspca_init_transfer+0x29/0x840 [gspca_main]
[  581.086888]
[  581.086891] which lock already depends on the new lock.
[  581.086895]
[  581.086903]
[  581.086905] the existing dependency chain (in reverse order) is:
[  581.086915]
[  581.086917] -> #3 (&gspca_dev->usb_lock){+.+...}:
[  581.086935]        [<c01bd1da>] validate_chain+0x12ea/0x1e40
[  581.086953]        [<c01be064>] __lock_acquire+0x334/0x15a0
[  581.086968]        [<c01bf39a>] lock_acquire+0xca/0x220
[  581.086982]        [<c0649d9a>] mutex_lock_interruptible_nested+0xaa/0xa20
[  581.087002]        [<f80f7019>] gspca_init_transfer+0x29/0x840 [gspca_main]
[  581.087020]        [<f80f79ad>] vidioc_streamon+0xfd/0x180 [gspca_main]
[  581.087037]        [<f80e6abc>] __video_do_ioctl+0x29ec/0x71c0 [videodev]
[  581.087057]        [<f80eb36d>] video_ioctl2+0xdd/0x980 [videodev]
[  581.087074]        [<f80e22e7>] v4l2_unlocked_ioctl+0x37/0x70 [videodev]
[  581.087091]        [<c02bd6ed>] vfs_ioctl+0x3d/0x130
[  581.087109]        [<c02bda60>] do_vfs_ioctl+0x80/0xb10
[  581.087111]        [<c02be539>] sys_ioctl+0x49/0xc0
[  581.087111]        [<c010484c>] sysenter_do_call+0x12/0x32
[  581.087111]
[  581.087111] -> #2 (&gspca_dev->queue_lock){+.+.+.}:
[  581.087111]        [<c01bd1da>] validate_chain+0x12ea/0x1e40
[  581.087111]        [<c01be064>] __lock_acquire+0x334/0x15a0
[  581.087111]        [<c01bf39a>] lock_acquire+0xca/0x220
[  581.087111]        [<c0649d9a>] mutex_lock_interruptible_nested+0xaa/0xa20
[  581.087111]        [<f80fa4ad>] dev_mmap+0x4d/0x3e0 [gspca_main]
[  581.087111]        [<f80e238a>] v4l2_mmap+0x6a/0x80 [videodev]
[  581.087111]        [<c027b234>] mmap_region+0x7a4/0x890
[  581.087111]        [<c027b8aa>] do_mmap_pgoff+0x58a/0x5c0
[  581.087111]        [<c0267296>] sys_mmap_pgoff+0xf6/0x240
[  581.087111]        [<c010484c>] sysenter_do_call+0x12/0x32
[  581.087111]
[  581.087111] -> #1 (&mm->mmap_sem){++++++}:
[  581.087111]        [<c01bd1da>] validate_chain+0x12ea/0x1e40
[  581.087111]        [<c01be064>] __lock_acquire+0x334/0x15a0
[  581.087111]        [<c01bf39a>] lock_acquire+0xca/0x220
[  581.087111]        [<c026ccef>] might_fault+0xdf/0x120
[  581.087111]        [<c0427670>] copy_to_user+0x60/0x1c0
[  581.087111]        [<c02bf0cf>] filldir64+0x17f/0x210
[  581.087111]        [<c03334b4>] sysfs_readdir+0x174/0x320
[  581.087111]        [<c02bf5fc>] vfs_readdir+0xec/0x130
[  581.087111]        [<c02bf6c7>] sys_getdents64+0x87/0x150
[  581.087111]        [<c010484c>] sysenter_do_call+0x12/0x32
[  581.087111]
[  581.087111] -> #0 (sysfs_mutex){+.+.+.}:
[  581.087111]        [<c01bdb3a>] validate_chain+0x1c4a/0x1e40
[  581.087111]        [<c01be064>] __lock_acquire+0x334/0x15a0
[  581.087111]        [<c01bf39a>] lock_acquire+0xca/0x220
[  581.087111]        [<c064b210>] mutex_lock_nested+0xa0/0x820
[  581.087111]        [<c03338e3>] sysfs_get_dirent+0x23/0xe0
[  581.087111]        [<c0337220>] sysfs_remove_group+0x30/0x220
[  581.087111]        [<c050e5be>] dpm_sysfs_remove+0x1e/0x30
[  581.087111]        [<c0501711>] device_del+0x71/0x310
[  581.087111]        [<c05019c9>] device_unregister+0x19/0x40
[  581.087111]        [<f899d1c1>] usb_remove_ep_devs+0x31/0x50 [usbcore]
[  581.087111]        [<f898fa13>] remove_intf_ep_devs+0x43/0xa0 [usbcore]
[  581.087111]        [<f8991c83>] usb_set_interface+0x1e3/0x430 [usbcore]
[  581.087111]        [<f80f6f33>] get_ep+0x293/0x350 [gspca_main]
[  581.087111]        [<f80f70c8>] gspca_init_transfer+0xd8/0x840 [gspca_main]
[  581.087111]        [<f80f79ad>] vidioc_streamon+0xfd/0x180 [gspca_main]
[  581.087111]        [<f80e6abc>] __video_do_ioctl+0x29ec/0x71c0 [videodev]
[  581.087111]        [<f80eb36d>] video_ioctl2+0xdd/0x980 [videodev]
[  581.087111]        [<f80e22e7>] v4l2_unlocked_ioctl+0x37/0x70 [videodev]
[  581.087111]        [<c02bd6ed>] vfs_ioctl+0x3d/0x130
[  581.087111]        [<c02bda60>] do_vfs_ioctl+0x80/0xb10
[  581.087111]        [<c02be539>] sys_ioctl+0x49/0xc0
[  581.087111]        [<c010484c>] sysenter_do_call+0x12/0x32
[  581.087111]
[  581.087111] other info that might help us debug this:
[  581.087111]
[  581.087111] 2 locks held by svv/3409:
[  581.087111]  #0:  (&gspca_dev->queue_lock){+.+.+.}, at: [<f80f78e7>] vidioc_streamon+0x37/0x180 [gspca_main]
[  581.087111]  #1:  (&gspca_dev->usb_lock){+.+...}, at: [<f80f7019>] gspca_init_transfer+0x29/0x840 [gspca_main]
[  581.087111]
[  581.087111] stack backtrace:
[  581.087111] Pid: 3409, comm: svv Not tainted 2.6.33-rc2 #1
[  581.087111] Call Trace:
[  581.087111]  [<c06473f8>] ? printk+0x34/0x54
[  581.087111]  [<c01bb456>] print_circular_bug+0x196/0x1b0
[  581.087111]  [<c01bdb3a>] validate_chain+0x1c4a/0x1e40
[  581.087111]  [<c01b7638>] ? save_trace+0x48/0x150
[  581.087111]  [<c050eab0>] ? device_pm_remove+0x20/0x60
[  581.087111]  [<c01be064>] __lock_acquire+0x334/0x15a0
[  581.087111]  [<c01be064>] ? __lock_acquire+0x334/0x15a0
[  581.087111]  [<c01bf39a>] lock_acquire+0xca/0x220
[  581.087111]  [<c03338e3>] ? sysfs_get_dirent+0x23/0xe0
[  581.087111]  [<c03338e3>] ? sysfs_get_dirent+0x23/0xe0
[  581.087111]  [<c064b210>] mutex_lock_nested+0xa0/0x820
[  581.087111]  [<c03338e3>] ? sysfs_get_dirent+0x23/0xe0
[  581.087111]  [<c01b96fb>] ? mark_held_locks+0x9b/0xe0
[  581.087111]  [<c03338e3>] sysfs_get_dirent+0x23/0xe0
[  581.087111]  [<c0337220>] sysfs_remove_group+0x30/0x220
[  581.087111]  [<c01b9f37>] ? trace_hardirqs_on+0x27/0x40
[  581.087111]  [<c050e5be>] dpm_sysfs_remove+0x1e/0x30
[  581.087111]  [<c0501711>] device_del+0x71/0x310
[  581.087111]  [<c05019c9>] device_unregister+0x19/0x40
[  581.087111]  [<f899d1c1>] usb_remove_ep_devs+0x31/0x50 [usbcore]
[  581.087111]  [<f898fa13>] remove_intf_ep_devs+0x43/0xa0 [usbcore]
[  581.087111]  [<f8991c83>] usb_set_interface+0x1e3/0x430 [usbcore]
[  581.087111]  [<f80f6f33>] get_ep+0x293/0x350 [gspca_main]
[  581.087111]  [<c064a6be>] ? mutex_lock_interruptible_nested+0x9ce/0xa20
[  581.087111]  [<f80f7019>] ? gspca_init_transfer+0x29/0x840 [gspca_main]
[  581.087111]  [<f80f70c8>] gspca_init_transfer+0xd8/0x840 [gspca_main]
[  581.087111]  [<f80f78e7>] ? vidioc_streamon+0x37/0x180 [gspca_main]
[  581.087111]  [<f80f78e7>] ? vidioc_streamon+0x37/0x180 [gspca_main]
[  581.087111]  [<f80f79ad>] vidioc_streamon+0xfd/0x180 [gspca_main]
[  581.087111]  [<f80e6abc>] __video_do_ioctl+0x29ec/0x71c0 [videodev]
[  581.087111]  [<c064ee8f>] ? _raw_spin_unlock_irq+0x8f/0x100
[  581.087111]  [<c01be064>] ? __lock_acquire+0x334/0x15a0
[  581.087111]  [<c01bf7c0>] ? lock_release_non_nested+0xc0/0x550
[  581.087111]  [<c026ccb0>] ? might_fault+0xa0/0x120
[  581.087111]  [<c026ccb0>] ? might_fault+0xa0/0x120
[  581.087111]  [<c026ccb0>] ? might_fault+0xa0/0x120
[  581.087111]  [<c026cd12>] ? might_fault+0x102/0x120
[  581.087111]  [<c026ccb0>] ? might_fault+0xa0/0x120
[  581.087111]  [<c0427491>] ? _copy_from_user+0x51/0x1d0
[  581.087111]  [<f80eb36d>] video_ioctl2+0xdd/0x980 [videodev]
[  581.087111]  [<c0149199>] ? __wake_up+0x29/0x90
[  581.087111]  [<c064f003>] ? _raw_spin_unlock_irqrestore+0x103/0x150
[  581.087111]  [<c01b9e12>] ? trace_hardirqs_on_caller+0x312/0x410
[  581.087111]  [<c01b9f37>] ? trace_hardirqs_on+0x27/0x40
[  581.087111]  [<f80eb290>] ? video_ioctl2+0x0/0x980 [videodev]
[  581.087111]  [<f80e22e7>] v4l2_unlocked_ioctl+0x37/0x70 [videodev]
[  581.087111]  [<f80e22b0>] ? v4l2_unlocked_ioctl+0x0/0x70 [videodev]
[  581.087111]  [<c02bd6ed>] vfs_ioctl+0x3d/0x130
[  581.087111]  [<c01b9f37>] ? trace_hardirqs_on+0x27/0x40
[  581.087111]  [<c02bda60>] do_vfs_ioctl+0x80/0xb10
[  581.087111]  [<c04cde27>] ? tty_write+0x2a7/0x490
[  581.087111]  [<c02a22a7>] ? vfs_write+0x177/0x260
[  581.087111]  [<c010487b>] ? sysenter_exit+0xf/0x16
[  581.087111]  [<c02be539>] sys_ioctl+0x49/0xc0
[  581.087111]  [<c010484c>] sysenter_do_call+0x12/0x32

Regards,

	Márton Németh

> 2010/1/10 Németh Márton <nm127@freemail.hu>:
>> Hi,
>>
>> I tried the gspca_sunplus driver from http://linuxtv.org/hg/~jfrancois/gspca/
>> rev 13915 on top of Linux kernel 2.6.32. When I plug the Trust 610 LCD PowerC@m Zoom
>> device in webcam mode (0x06d6:0x0031) then two devices are created: /dev/video0
>> and /dev/video1:
>>
>> [31636.528184] usb 3-2: new full speed USB device using uhci_hcd and address 5
>> [31636.740722] usb 3-2: New USB device found, idVendor=06d6, idProduct=0031
>> [31636.740744] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [31636.740760] usb 3-2: Product: Trust 610 LCD POWERC@M ZOOM
>> [31636.740772] usb 3-2: Manufacturer: Trust
>> [31636.744229] usb 3-2: configuration #1 chosen from 1 choice
>> [31636.747584] gspca: probing 06d6:0031
>> [31636.760176] gspca: video0 created
>> [31636.760643] gspca: probing 06d6:0031
>> [31636.772063] gspca: video1 created
>>
>> The /dev/video0 is working correctly but the /dev/video1 just causes error:
>> $ ./svv -d /dev/video1
>> raw pixfmt: JPEG 464x480
>> pixfmt: RGB3 464x480
>> mmap method
>> VIDIOC_STREAMON error 5, Input/output error
>>
>> Here is the USB descriptor of the device:
>>
>> Trust 610 LCD POWERC@M ZOOM
>> Manufacturer: Trust
>> Speed: 12Mb/s (full)
>> USB Version:  1.00
>> Device Class: 00(>ifc )
>> Device Subclass: 00
>> Device Protocol: 00
>> Maximum Default Endpoint Size: 8
>> Number of Configurations: 1
>> Vendor Id: 06d6
>> Product Id: 0031
>> Revision Number:  1.00
>>
>> Config Number: 1
>>        Number of Interfaces: 2
>>        Attributes: 80
>>        MaxPower Needed: 500mA
>>
>>        Interface Number: 0
>>                Name: sunplus
>>                Alternate Number: 0
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 1
>>
>>                        Endpoint Address: 81
>>                        Direction: in
>>                        Attribute: 1
>>                        Type: Isoc
>>                        Max Packet Size: 0
>>                        Interval: 1ms
>>
>>        Interface Number: 0
>>                Name: sunplus
>>                Alternate Number: 1
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 1
>>
>>                        Endpoint Address: 81
>>                        Direction: in
>>                        Attribute: 1
>>                        Type: Isoc
>>                        Max Packet Size: 128
>>                        Interval: 1ms
>>
>>        Interface Number: 0
>>                Name: sunplus
>>                Alternate Number: 2
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 1
>>
>>                        Endpoint Address: 81
>>                        Direction: in
>>                        Attribute: 1
>>                        Type: Isoc
>>                        Max Packet Size: 384
>>                        Interval: 1ms
>>
>>        Interface Number: 0
>>                Name: sunplus
>>                Alternate Number: 3
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 1
>>
>>                        Endpoint Address: 81
>>                        Direction: in
>>                        Attribute: 1
>>                        Type: Isoc
>>                        Max Packet Size: 512
>>                        Interval: 1ms
>>
>>        Interface Number: 0
>>                Name: sunplus
>>                Alternate Number: 4
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 1
>>
>>                        Endpoint Address: 81
>>                        Direction: in
>>                        Attribute: 1
>>                        Type: Isoc
>>                        Max Packet Size: 640
>>                        Interval: 1ms
>>
>>        Interface Number: 0
>>                Name: sunplus
>>                Alternate Number: 5
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 1
>>
>>                        Endpoint Address: 81
>>                        Direction: in
>>                        Attribute: 1
>>                        Type: Isoc
>>                        Max Packet Size: 768
>>                        Interval: 1ms
>>
>>        Interface Number: 0
>>                Name: sunplus
>>                Alternate Number: 6
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 1
>>
>>                        Endpoint Address: 81
>>                        Direction: in
>>                        Attribute: 1
>>                        Type: Isoc
>>                        Max Packet Size: 896
>>                        Interval: 1ms
>>
>>        Interface Number: 0
>>                Name: sunplus
>>                Alternate Number: 7
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 1
>>
>>                        Endpoint Address: 81
>>                        Direction: in
>>                        Attribute: 1
>>                        Type: Isoc
>>                        Max Packet Size: 1023
>>                        Interval: 1ms
>>
>>        Interface Number: 1
>>                Name: sunplus
>>                Alternate Number: 0
>>                Class: ff(vend.)
>>                Sub Class: 00
>>                Protocol: 00
>>                Number of Endpoints: 3
>>
>>                        Endpoint Address: 82
>>                        Direction: in
>>                        Attribute: 2
>>                        Type: Bulk
>>                        Max Packet Size: 64
>>                        Interval: 0ms
>>
>>                        Endpoint Address: 03
>>                        Direction: out
>>                        Attribute: 2
>>                        Type: Bulk
>>                        Max Packet Size: 64
>>                        Interval: 0ms
>>
>>                        Endpoint Address: 84
>>                        Direction: in
>>                        Attribute: 3
>>                        Type: Int.
>>                        Max Packet Size: 1
>>                        Interval: 1ms
>>
>> Regards,
>>
>>        Márton Németh
