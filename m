Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:49869 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759763AbZKFVFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 16:05:08 -0500
Message-ID: <4AF48F80.4000809@freemail.hu>
Date: Fri, 06 Nov 2009 22:05:04 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: pac7302: INFO: possible circular locking dependency detected
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

sometimes when I plug my Labtec Webcam 2200 and then try to start capturing I get
no picture but some error message in dmesg. I am using 13326:40705fec2fb2 from
http://linuxtv.org/hg/v4l-dvb/ on top of Linux 2.6.32-rc6.

[ 2282.076229] usb 3-2: new full speed USB device using uhci_hcd and address 2
[ 2282.314601] usb 3-2: New USB device found, idVendor=093a, idProduct=2626
[ 2282.314622] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 2282.317636] usb 3-2: configuration #1 chosen from 1 choice
[ 2282.562231] Linux video capture interface: v2.00
[ 2282.599805] gspca: main v2.7.0 registered
[ 2282.628561] gspca: probing 093a:2626
[ 2282.629052] usbcore: registered new interface driver snd-usb-audio
[ 2282.634125] gspca: /dev/video0 created
[ 2282.634563] usbcore: registered new interface driver pac7302
[ 2282.634602] pac7302: registered
[ 2298.627711]
[ 2298.627715] =======================================================
[ 2298.627725] [ INFO: possible circular locking dependency detected ]
[ 2298.627734] 2.6.32-rc6 #1
[ 2298.627738] -------------------------------------------------------
[ 2298.627745] svv/3820 is trying to acquire lock:
[ 2298.627751]  (sysfs_mutex){+.+.+.}, at: [<c110778b>] sysfs_get_dirent+0x15/0x4c
[ 2298.627773]
[ 2298.627775] but task is already holding lock:
[ 2298.627781]  (&gspca_dev->usb_lock){+.+...}, at: [<f81400c2>] gspca_init_transfer+0x20/0x384 [gspca_main]
[ 2298.627801]
[ 2298.627803] which lock already depends on the new lock.
[ 2298.627806]
[ 2298.627811]
[ 2298.627813] the existing dependency chain (in reverse order) is:
[ 2298.627819]
[ 2298.627821] -> #3 (&gspca_dev->usb_lock){+.+...}:
[ 2298.627833]        [<c105da6b>] __lock_acquire+0x10e9/0x13ea
[ 2298.627846]        [<c105de1f>] lock_acquire+0xb3/0xd0
[ 2298.627856]        [<c128619c>] mutex_lock_interruptible_nested+0x50/0x37b
[ 2298.627869]        [<f81400c2>] gspca_init_transfer+0x20/0x384 [gspca_main]
[ 2298.627883]        [<f81404a3>] vidioc_streamon+0x4a/0x95 [gspca_main]
[ 2298.627895]        [<f80d1384>] __video_do_ioctl+0x167d/0x3688 [videodev]
[ 2298.627910]        [<f80d365e>] video_ioctl2+0x2cf/0x371 [videodev]
[ 2298.627923]        [<f80cf15b>] v4l2_unlocked_ioctl+0x2e/0x32 [videodev]
[ 2298.627936]        [<c10d20d3>] vfs_ioctl+0x22/0x69
[ 2298.627947]        [<c10d2642>] do_vfs_ioctl+0x484/0x4be
[ 2298.627958]        [<c10d26bc>] sys_ioctl+0x40/0x5a
[ 2298.627969]        [<c10032a4>] sysenter_do_call+0x12/0x38
[ 2298.627981]
[ 2298.627983] -> #2 (&gspca_dev->queue_lock){+.+.+.}:
[ 2298.627994]        [<c105da6b>] __lock_acquire+0x10e9/0x13ea
[ 2298.628005]        [<c105de1f>] lock_acquire+0xb3/0xd0
[ 2298.628015]        [<c128619c>] mutex_lock_interruptible_nested+0x50/0x37b
[ 2298.628027]        [<f814149d>] dev_mmap+0x5a/0x1c7 [gspca_main]
[ 2298.628039]        [<f80cf191>] v4l2_mmap+0x32/0x3d [videodev]
[ 2298.628052]        [<c10b5207>] mmap_region+0x246/0x40b
[ 2298.628063]        [<c10b566c>] do_mmap_pgoff+0x2a0/0x2f0
[ 2298.628073]        [<c100704c>] sys_mmap2+0x5a/0x7b
[ 2298.628083]        [<c10032a4>] sysenter_do_call+0x12/0x38
[ 2298.628094]
[ 2298.628096] -> #1 (&mm->mmap_sem){++++++}:
[ 2298.628107]        [<c105da6b>] __lock_acquire+0x10e9/0x13ea
[ 2298.628118]        [<c105de1f>] lock_acquire+0xb3/0xd0
[ 2298.628128]        [<c10aef03>] might_fault+0x6b/0x88
[ 2298.628138]        [<c11581ac>] copy_to_user+0x2c/0xfc
[ 2298.628149]        [<c10d2aab>] filldir64+0x97/0xcd
[ 2298.628160]        [<c1107691>] sysfs_readdir+0x117/0x14b
[ 2298.628171]        [<c10d2cbd>] vfs_readdir+0x68/0x94
[ 2298.628181]        [<c10d2d4c>] sys_getdents64+0x63/0xa0
[ 2298.628192]        [<c10032a4>] sysenter_do_call+0x12/0x38
[ 2298.628202]
[ 2298.628204] -> #0 (sysfs_mutex){+.+.+.}:
[ 2298.628215]        [<c105d7f6>] __lock_acquire+0xe74/0x13ea
[ 2298.628226]        [<c105de1f>] lock_acquire+0xb3/0xd0
[ 2298.628236]        [<c128688e>] mutex_lock_nested+0x47/0x2c6
[ 2298.628246]        [<c110778b>] sysfs_get_dirent+0x15/0x4c
[ 2298.628257]        [<c1108e7a>] sysfs_remove_group+0x1e/0xa3
[ 2298.628268]        [<c11c8c1c>] dpm_sysfs_remove+0x10/0x12
[ 2298.628279]        [<c11c41c1>] device_del+0x33/0x131
[ 2298.628291]        [<c11c42ca>] device_unregister+0xb/0x15
[ 2298.628301]        [<f84c22a1>] usb_remove_ep_devs+0x15/0x1f [usbcore]
[ 2298.628338]        [<f84bcbd8>] remove_intf_ep_devs+0x21/0x32 [usbcore]
[ 2298.628372]        [<f84bda27>] usb_set_interface+0xd9/0x16c [usbcore]
[ 2298.628406]        [<f8140078>] get_ep+0x145/0x16f [gspca_main]
[ 2298.628418]        [<f814011c>] gspca_init_transfer+0x7a/0x384 [gspca_main]
[ 2298.628431]        [<f81404a3>] vidioc_streamon+0x4a/0x95 [gspca_main]
[ 2298.628443]        [<f80d1384>] __video_do_ioctl+0x167d/0x3688 [videodev]
[ 2298.628457]        [<f80d365e>] video_ioctl2+0x2cf/0x371 [videodev]
[ 2298.628470]        [<f80cf15b>] v4l2_unlocked_ioctl+0x2e/0x32 [videodev]
[ 2298.628482]        [<c10d20d3>] vfs_ioctl+0x22/0x69
[ 2298.628493]        [<c10d2642>] do_vfs_ioctl+0x484/0x4be
[ 2298.628504]        [<c10d26bc>] sys_ioctl+0x40/0x5a
[ 2298.628514]        [<c10032a4>] sysenter_do_call+0x12/0x38
[ 2298.628525]
[ 2298.628527] other info that might help us debug this:
[ 2298.628529]
[ 2298.628536] 2 locks held by svv/3820:
[ 2298.628541]  #0:  (&gspca_dev->queue_lock){+.+.+.}, at: [<f814047d>] vidioc_streamon+0x24/0x95 [gspca_main]
[ 2298.628561]  #1:  (&gspca_dev->usb_lock){+.+...}, at: [<f81400c2>] gspca_init_transfer+0x20/0x384 [gspca_main]
[ 2298.628581]
[ 2298.628583] stack backtrace:
[ 2298.628591] Pid: 3820, comm: svv Not tainted 2.6.32-rc6 #1
[ 2298.628597] Call Trace:
[ 2298.628608]  [<c1284b9c>] ? printk+0xf/0x13
[ 2298.628618]  [<c105c53b>] print_circular_bug+0x90/0x9c
[ 2298.628628]  [<c105d7f6>] __lock_acquire+0xe74/0x13ea
[ 2298.628639]  [<c11c8f93>] ? device_pm_remove+0x12/0x33
[ 2298.628651]  [<c105de1f>] lock_acquire+0xb3/0xd0
[ 2298.628661]  [<c110778b>] ? sysfs_get_dirent+0x15/0x4c
[ 2298.628671]  [<c110778b>] ? sysfs_get_dirent+0x15/0x4c
[ 2298.628682]  [<c128688e>] mutex_lock_nested+0x47/0x2c6
[ 2298.628692]  [<c110778b>] ? sysfs_get_dirent+0x15/0x4c
[ 2298.628701]  [<c105ba51>] ? mark_held_locks+0x43/0x5b
[ 2298.628712]  [<c1285fe8>] ? __mutex_unlock_slowpath+0xf8/0x11a
[ 2298.628722]  [<c105bcb7>] ? trace_hardirqs_on_caller+0x103/0x124
[ 2298.628732]  [<c110778b>] sysfs_get_dirent+0x15/0x4c
[ 2298.628743]  [<c1108e7a>] sysfs_remove_group+0x1e/0xa3
[ 2298.628753]  [<c11c8c1c>] dpm_sysfs_remove+0x10/0x12
[ 2298.628763]  [<c11c41c1>] device_del+0x33/0x131
[ 2298.628773]  [<c11c42ca>] device_unregister+0xb/0x15
[ 2298.628810]  [<f84c22a1>] usb_remove_ep_devs+0x15/0x1f [usbcore]
[ 2298.628846]  [<f84bcbd8>] remove_intf_ep_devs+0x21/0x32 [usbcore]
[ 2298.628881]  [<f84bda27>] usb_set_interface+0xd9/0x16c [usbcore]
[ 2298.628894]  [<f8140078>] get_ep+0x145/0x16f [gspca_main]
[ 2298.628906]  [<f81400c2>] ? gspca_init_transfer+0x20/0x384 [gspca_main]
[ 2298.628919]  [<f814011c>] gspca_init_transfer+0x7a/0x384 [gspca_main]
[ 2298.628932]  [<f81404a3>] vidioc_streamon+0x4a/0x95 [gspca_main]
[ 2298.628945]  [<f80d1384>] __video_do_ioctl+0x167d/0x3688 [videodev]
[ 2298.628957]  [<c105df9b>] ? lock_release_non_nested+0x88/0x239
[ 2298.628966]  [<c10aeee6>] ? might_fault+0x4e/0x88
[ 2298.628976]  [<c10aeee6>] ? might_fault+0x4e/0x88
[ 2298.628985]  [<c10aeee6>] ? might_fault+0x4e/0x88
[ 2298.628995]  [<c10aef1b>] ? might_fault+0x83/0x88
[ 2298.629005]  [<c1158099>] ? copy_from_user+0x2a/0x111
[ 2298.629018]  [<f80d365e>] video_ioctl2+0x2cf/0x371 [videodev]
[ 2298.629030]  [<c1287b31>] ? _spin_unlock_irqrestore+0x3f/0x68
[ 2298.629040]  [<c105bcb7>] ? trace_hardirqs_on_caller+0x103/0x124
[ 2298.629050]  [<c105bce3>] ? trace_hardirqs_on+0xb/0xd
[ 2298.629063]  [<f80d338f>] ? video_ioctl2+0x0/0x371 [videodev]
[ 2298.629075]  [<f80cf15b>] v4l2_unlocked_ioctl+0x2e/0x32 [videodev]
[ 2298.629087]  [<f80cf12d>] ? v4l2_unlocked_ioctl+0x0/0x32 [videodev]
[ 2298.629098]  [<c10d20d3>] vfs_ioctl+0x22/0x69
[ 2298.629108]  [<c10d2642>] do_vfs_ioctl+0x484/0x4be
[ 2298.629119]  [<c10c6de3>] ? vfs_write+0xff/0x13d
[ 2298.629130]  [<c10d26bc>] sys_ioctl+0x40/0x5a
[ 2298.629140]  [<c10032a4>] sysenter_do_call+0x12/0x38
[ 2298.755224] pac7302: reg_w_page(): Failed to write register to index 0x49, value 0x0, error -71
[ 2298.756412] pac7302: reg_w_page(): Failed to write register to index 0x4a, value 0x0, error -71
[ 2298.757215] pac7302: reg_w_page(): Failed to write register to index 0x4b, value 0xc0, error -71
[ 2298.758213] pac7302: reg_w_page(): Failed to write register to index 0x4c, value 0xc0, error -71
[ 2298.759212] pac7302: reg_w_page(): Failed to write register to index 0x4d, value 0x10, error -71
[ 2298.760408] pac7302: reg_w_page(): Failed to write register to index 0x4e, value 0x0, error -71
[ 2298.761356] pac7302: reg_w_page(): Failed to write register to index 0x4f, value 0x0, error -71
[ 2298.762227] pac7302: reg_w_page(): Failed to write register to index 0x50, value 0x0, error -71
[ 2298.763213] pac7302: reg_w_page(): Failed to write register to index 0x51, value 0x40, error -71
[ 2298.764334] pac7302: reg_w_page(): Failed to write register to index 0x52, value 0x0, error -71
[ 2298.765228] pac7302: reg_w_page(): Failed to write register to index 0x53, value 0x0, error -71
[ 2298.766214] pac7302: reg_w_page(): Failed to write register to index 0x54, value 0x0, error -71
[ 2298.767212] pac7302: reg_w_page(): Failed to write register to index 0x55, value 0x0, error -71
[ 2298.768642] pac7302: reg_w_page(): Failed to write register to index 0x56, value 0x0, error -71
[ 2298.769216] pac7302: reg_w_page(): Failed to write register to index 0x57, value 0x0, error -71
[ 2298.770213] pac7302: reg_w_page(): Failed to write register to index 0x58, value 0x0, error -71
[ 2298.771212] pac7302: reg_w_page(): Failed to write register to index 0x59, value 0x40, error -71
[ 2298.772764] pac7302: reg_w_page(): Failed to write register to index 0x5a, value 0xff, error -71
[ 2298.773216] pac7302: reg_w_page(): Failed to write register to index 0x5b, value 0x3, error -71
[ 2298.774213] pac7302: reg_w_page(): Failed to write register to index 0x5c, value 0x19, error -71
[ 2298.775212] pac7302: reg_w_page(): Failed to write register to index 0x5d, value 0x0, error -71
[ 2298.776765] pac7302: reg_w_page(): Failed to write register to index 0x5e, value 0x0, error -71
[ 2298.777216] pac7302: reg_w_page(): Failed to write register to index 0x5f, value 0x0, error -71
[ 2298.778213] pac7302: reg_w_page(): Failed to write register to index 0x60, value 0x0, error -71
[ 2298.779212] pac7302: reg_w_page(): Failed to write register to index 0x61, value 0x0, error -71
[ 2298.780842] pac7302: reg_w_page(): Failed to write register to index 0x62, value 0x0, error -71
[ 2298.781218] pac7302: reg_w_page(): Failed to write register to index 0x63, value 0x0, error -71
[ 2298.782213] pac7302: reg_w_page(): Failed to write register to index 0x64, value 0x0, error -71
[ 2298.783211] pac7302: reg_w_page(): Failed to write register to index 0x65, value 0x0, error -71
[ 2298.784756] pac7302: reg_w_page(): Failed to write register to index 0x66, value 0x0, error -71
[ 2298.785217] pac7302: reg_w_page(): Failed to write register to index 0x67, value 0x0, error -71
[ 2298.786212] pac7302: reg_w_page(): Failed to write register to index 0x68, value 0x0, error -71
[ 2298.787212] pac7302: reg_w_page(): Failed to write register to index 0x69, value 0x0, error -71
[ 2298.788444] pac7302: reg_w_page(): Failed to write register to index 0x6a, value 0x0, error -71
[ 2298.789216] pac7302: reg_w_page(): Failed to write register to index 0x6b, value 0x0, error -71
[ 2298.790213] pac7302: reg_w_page(): Failed to write register to index 0x6c, value 0x0, error -71
[ 2298.791212] pac7302: reg_w_page(): Failed to write register to index 0x6d, value 0xc8, error -71
[ 2298.792342] pac7302: reg_w_page(): Failed to write register to index 0x6e, value 0xc8, error -71
[ 2298.793219] pac7302: reg_w_page(): Failed to write register to index 0x6f, value 0xc8, error -71
[ 2298.794213] pac7302: reg_w_page(): Failed to write register to index 0x70, value 0xc8, error -71
[ 2298.795212] pac7302: reg_w_page(): Failed to write register to index 0x71, value 0x0, error -71
[ 2298.796320] pac7302: reg_w_page(): Failed to write register to index 0x72, value 0x0, error -71
[ 2298.797219] pac7302: reg_w_page(): Failed to write register to index 0x73, value 0x0, error -71
[ 2298.798213] pac7302: reg_w_page(): Failed to write register to index 0x74, value 0x0, error -71
[ 2298.799212] pac7302: reg_w_page(): Failed to write register to index 0x75, value 0x0, error -71
[ 2298.800322] pac7302: reg_w_page(): Failed to write register to index 0x76, value 0x0, error -71
[ 2298.801217] pac7302: reg_w_page(): Failed to write register to index 0x77, value 0x50, error -71
[ 2298.802213] pac7302: reg_w_page(): Failed to write register to index 0x78, value 0x8, error -71
[ 2298.803212] pac7302: reg_w_page(): Failed to write register to index 0x79, value 0x10, error -71
[ 2298.804339] pac7302: reg_w_page(): Failed to write register to index 0x7a, value 0x24, error -71
[ 2298.805218] pac7302: reg_w_page(): Failed to write register to index 0x7b, value 0x40, error -71
[ 2298.806213] pac7302: reg_w_page(): Failed to write register to index 0x7c, value 0x0, error -71
[ 2298.807212] pac7302: reg_w_page(): Failed to write register to index 0x7d, value 0x0, error -71
[ 2298.808320] pac7302: reg_w_page(): Failed to write register to index 0x7e, value 0x0, error -71
[ 2298.809219] pac7302: reg_w_page(): Failed to write register to index 0x7f, value 0x0, error -71
[ 2298.810213] pac7302: reg_w_page(): Failed to write register to index 0x80, value 0x1, error -71
[ 2298.811212] pac7302: reg_w_page(): Failed to write register to index 0x81, value 0x0, error -71
[ 2298.812322] pac7302: reg_w_page(): Failed to write register to index 0x82, value 0x2, error -71
[ 2298.813219] pac7302: reg_w_page(): Failed to write register to index 0x83, value 0x47, error -71
[ 2298.814213] pac7302: reg_w_page(): Failed to write register to index 0x84, value 0x0, error -71
[ 2298.815212] pac7302: reg_w_page(): Failed to write register to index 0x85, value 0x0, error -71
[ 2298.816342] pac7302: reg_w_page(): Failed to write register to index 0x86, value 0x0, error -71
[ 2298.817219] pac7302: reg_w_page(): Failed to write register to index 0x87, value 0x0, error -71
[ 2298.818213] pac7302: reg_w_page(): Failed to write register to index 0x88, value 0x0, error -71
[ 2298.819212] pac7302: reg_w_page(): Failed to write register to index 0x89, value 0x0, error -71
[ 2298.820319] pac7302: reg_w_page(): Failed to write register to index 0x8a, value 0x0, error -71
[ 2298.821217] pac7302: reg_w_page(): Failed to write register to index 0x8b, value 0x0, error -71
[ 2298.822213] pac7302: reg_w_page(): Failed to write register to index 0x8c, value 0x0, error -71
[ 2298.823212] pac7302: reg_w_page(): Failed to write register to index 0x8d, value 0x0, error -71
[ 2298.824214] pac7302: reg_w_page(): Failed to write register to index 0x8e, value 0x0, error -71
[ 2298.825229] pac7302: reg_w_page(): Failed to write register to index 0x8f, value 0x0, error -71
[ 2298.826214] pac7302: reg_w_page(): Failed to write register to index 0x90, value 0x0, error -71
[ 2298.827212] pac7302: reg_w_page(): Failed to write register to index 0x91, value 0x2, error -71
[ 2298.828213] pac7302: reg_w_page(): Failed to write register to index 0x92, value 0xfa, error -71
[ 2298.829229] pac7302: reg_w_page(): Failed to write register to index 0x93, value 0x0, error -71
[ 2298.830214] pac7302: reg_w_page(): Failed to write register to index 0x94, value 0x64, error -71
[ 2298.831212] pac7302: reg_w_page(): Failed to write register to index 0x95, value 0x5a, error -71
[ 2298.832214] pac7302: reg_w_page(): Failed to write register to index 0x96, value 0x28, error -71
[ 2298.833227] pac7302: reg_w_page(): Failed to write register to index 0x97, value 0x0, error -71
[ 2298.834213] pac7302: reg_w_page(): Failed to write register to index 0x98, value 0x0, error -71
[ 2298.835211] pac7302: reg_w_buf(): Failed to write registers to index 0x11, error -71
[ 2298.836214] pac7302: reg_w_buf(): Failed to write registers to index 0xff, error -71
[ 2298.837225] pac7302: reg_w_buf(): Failed to write registers to index 0x13, error -71
[ 2298.838213] pac7302: reg_w_buf(): Failed to write registers to index 0x22, error -71
[ 2298.839212] pac7302: reg_w_buf(): Failed to write registers to index 0x27, error -71
[ 2298.840213] pac7302: reg_w_buf(): Failed to write registers to index 0x2a, error -71
[ 2298.841230] pac7302: reg_w_buf(): Failed to write registers to index 0x64, error -71
[ 2298.842213] pac7302: reg_w_buf(): Failed to write registers to index 0x6e, error -71
[ 2298.843211] pac7302: reg_w_buf(): Failed to write registers to index 0xff, error -71
[ 2298.844215] pac7302: reg_w_buf(): Failed to write registers to index 0x78, error -71
[ 2298.845228] pac7302: reg_w(): Failed to write register to index 0xff, value 0x0, error -71
[ 2298.846213] pac7302: reg_w(): Failed to write register to index 0xa2, value 0x0, error -71
[ 2298.847212] pac7302: reg_w(): Failed to write register to index 0xa3, value 0x0, error -71
[ 2298.848215] pac7302: reg_w(): Failed to write register to index 0xa4, value 0x0, error -71
[ 2298.849227] pac7302: reg_w(): Failed to write register to index 0xa5, value 0x0, error -71
[ 2298.850213] pac7302: reg_w(): Failed to write register to index 0xa6, value 0xf, error -71
[ 2298.851212] pac7302: reg_w(): Failed to write register to index 0xa7, value 0x23, error -71
[ 2298.852213] pac7302: reg_w(): Failed to write register to index 0xa8, value 0x46, error -71
[ 2298.853227] pac7302: reg_w(): Failed to write register to index 0xa9, value 0x65, error -71
[ 2298.854213] pac7302: reg_w(): Failed to write register to index 0xaa, value 0x81, error -71
[ 2298.855212] pac7302: reg_w(): Failed to write register to index 0xab, value 0x9c, error -71
[ 2298.856214] pac7302: reg_w(): Failed to write register to index 0xdc, value 0x1, error -71
[ 2298.857228] pac7302: reg_w(): Failed to write register to index 0xff, value 0x3, error -71
[ 2298.858213] pac7302: reg_w(): Failed to write register to index 0x11, value 0x1, error -71
[ 2298.859213] pac7302: reg_w(): Failed to write register to index 0xff, value 0x0, error -71
[ 2298.860214] pac7302: reg_w(): Failed to write register to index 0xf, value 0x0, error -71
[ 2298.861228] pac7302: reg_w(): Failed to write register to index 0x10, value 0x7f, error -71
[ 2298.862213] pac7302: reg_w(): Failed to write register to index 0x11, value 0x0, error -71
[ 2298.863213] pac7302: reg_w(): Failed to write register to index 0x12, value 0x1, error -71
[ 2298.864213] pac7302: reg_w(): Failed to write register to index 0x13, value 0x0, error -71
[ 2298.865226] pac7302: reg_w(): Failed to write register to index 0x14, value 0x0, error -71
[ 2298.866213] pac7302: reg_w(): Failed to write register to index 0x15, value 0x7, error -71
[ 2298.867211] pac7302: reg_w(): Failed to write register to index 0x16, value 0xe1, error -71
[ 2298.868214] pac7302: reg_w(): Failed to write register to index 0x17, value 0x0, error -71
[ 2298.869227] pac7302: reg_w(): Failed to write register to index 0x18, value 0xbe, error -71
[ 2298.870213] pac7302: reg_w(): Failed to write register to index 0x19, value 0x7, error -71
[ 2298.871212] pac7302: reg_w(): Failed to write register to index 0x1a, value 0xe0, error -71
[ 2298.872262] pac7302: reg_w(): Failed to write register to index 0x1b, value 0x0, error -71
[ 2298.873219] pac7302: reg_w(): Failed to write register to index 0x1c, value 0x1, error -71
[ 2298.874213] pac7302: reg_w(): Failed to write register to index 0x1d, value 0x7, error -71
[ 2298.875212] pac7302: reg_w(): Failed to write register to index 0x1e, value 0xce, error -71
[ 2298.876332] pac7302: reg_w(): Failed to write register to index 0x1f, value 0x0, error -71
[ 2298.877219] pac7302: reg_w(): Failed to write register to index 0x20, value 0xb1, error -71
[ 2298.878213] pac7302: reg_w(): Failed to write register to index 0xdc, value 0x1, error -71
[ 2298.879212] pac7302: reg_w(): Failed to write register to index 0xff, value 0x3, error -71
[ 2298.880097] pac7302: reg_w(): Failed to write register to index 0x10, value 0xf, error -71
[ 2298.881227] pac7302: reg_w(): Failed to write register to index 0x11, value 0x1, error -71
[ 2298.882213] pac7302: reg_w(): Failed to write register to index 0xff, value 0x3, error -71
[ 2298.883211] pac7302: reg_w(): Failed to write register to index 0x2, value 0x3, error -71
[ 2298.884264] pac7302: reg_w(): Failed to write register to index 0x11, value 0x1, error -71
[ 2298.885218] pac7302: reg_w(): Failed to write register to index 0xff, value 0x3, error -71
[ 2298.886213] pac7302: reg_w(): Failed to write register to index 0x21, value 0x0, error -71
[ 2298.887212] pac7302: reg_w(): Failed to write register to index 0x11, value 0x1, error -71
[ 2298.888333] pac7302: reg_w(): Failed to write register to index 0xff, value 0x1, error -71
[ 2298.889219] pac7302: reg_w(): Failed to write register to index 0x78, value 0x1, error -71
[ 2302.944305] pac7302: reg_w(): Failed to write register to index 0xff, value 0x1, error -71
[ 2302.945984] pac7302: reg_w(): Failed to write register to index 0x78, value 0x0, error -71
[ 2302.946303] pac7302: reg_w(): Failed to write register to index 0x78, value 0x0, error -71
[ 2302.950279] gspca: set alt 0 err -71
[ 2302.951298] pac7302: reg_w(): Failed to write register to index 0xff, value 0x1, error -71
[ 2302.952903] pac7302: reg_w(): Failed to write register to index 0x78, value 0x40, error -71

If I unplug the device, plug it again and try to start capture it works without problem.

Regars,

	Márton Németh
