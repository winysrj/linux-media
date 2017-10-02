Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:52076 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdJBLtv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Oct 2017 07:49:51 -0400
Received: by mail-oi0-f42.google.com with SMTP id n82so8546476oib.8
        for <linux-media@vger.kernel.org>; Mon, 02 Oct 2017 04:49:51 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 2 Oct 2017 13:49:50 +0200
Message-ID: <CAAeHK+zO7XBpqTUd5q6L8cyMOAVPmXFbwD+nvZGrEWPTO5gcqA@mail.gmail.com>
Subject: usb/media/v4l2: use-after-free in video_unregister_device/device_del
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit 9e66317d3c92ddaab330c125dfe9d06eee268aff (4.14-rc3).

usb 1-1: config 48 interface 0 altsetting 0 endpoint 0x4 has invalid
maxpacket 1956, setting to 64
usb 1-1: New USB device found, idVendor=0573, idProduct=4d34
usb 1-1: New USB device strings: Mfr=63, Product=4, SerialNumber=2
usb 1-1: Product: a
usb 1-1: Manufacturer: a
usb 1-1: SerialNumber: a
gadgetfs: configuration #48
usbvision_probe: Hauppauge WinTV USB Pro (PAL D/K FM) found
usb 1-1: usbvision_write_reg: failed: error -2
usbvision_audio_off: can't write reg
usb 1-1: usbvision_write_reg: failed: error -2
usb 1-1: usbvision_write_reg: failed: error -2
usb 1-1: usbvision_write_reg: failed: error -2
usb 1-1: usbvision_write_reg: failed: error -2
usb 1-1: usbvision_write_reg: failed: error -2
usbvision_i2c_register: can't write reg
USBVision[15]: registered USBVision Video device video0 [v4l2]
USBVision[15]: registered USBVision Radio device radio0 [v4l2]
usb 1-1: usbvision_write_reg: failed: error -2
usbvision_set_audio: can't write iopin register for audio switching
usb 1-1: usbvision_write_reg: failed: error -2
usbvision_audio_off: can't write reg
usbvision_set_video_format: ERROR=-2. USBVISION stopped - reconnect or
reload driver.
usb 1-1: usbvision_set_dram_settings: ERROR=-2
usbvision_set_compresion_params: ERROR=-2. USBVISION stopped -
reconnect or reload driver.
usb 1-1: usbvision_write_reg: failed: error -2
usbvision_set_input: ERROR=-2. USBVISION stopped - reconnect or reload driver.
usb 1-1: usbvision_set_output failed: error -2
usb 1-1: usbvision_write_reg: failed: error -2
usb 1-1: usbvision_write_reg: failed: error -2
usb 1-1: usbvision_read_reg: failed: error -90
usb 1-1: usbvision_init_isoc: usb_submit_urb(0) failed: error -90
usb 1-1: usbvision_init_isoc: usb_submit_urb(1) failed: error -90
usb 1-1: usbvision_write_reg: failed: error -2
usbvision_set_audio: can't write iopin register for audio switching
usb 1-1: usbvision_write_reg: failed: error -2
usbvision_audio_off: can't write reg
usb 1-1: usbvision_write_reg: failed: error -2
gadgetfs: disconnected
usb 1-1: USB disconnect, device number 17
usb 1-1: usbvision_stop_isoc: usb_set_interface() failed: error -71
usbvision_v4l2_close: Final disconnect
==================================================================
BUG: KASAN: use-after-free in device_del+0xa1c/0xab0
Read of size 8 at addr ffff8800692649f8 by task kworker/1:1/1150

CPU: 1 PID: 1150 Comm: kworker/1:1 Not tainted
4.14.0-rc3-42944-g2de0634c9ea5 #347
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x78/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x23d/0x350 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 device_del+0xa1c/0xab0 drivers/base/core.c:1970
 device_unregister+0x1a/0x40 drivers/base/core.c:2020
 video_unregister_device+0x80/0x90 drivers/media/v4l2-core/v4l2-dev.c:1028
 usbvision_unregister_video+0xb1/0x200
drivers/media/usb/usbvision/usbvision-video.c:1264
 usbvision_release+0x105/0x1f0
drivers/media/usb/usbvision/usbvision-video.c:1364
 usbvision_disconnect+0x15e/0x260
drivers/media/usb/usbvision/usbvision-video.c:1593
 usb_unbind_interface+0x21c/0xa90 drivers/usb/core/driver.c:423
 __device_release_driver drivers/base/dd.c:861
 device_release_driver_internal+0x4f4/0x5c0 drivers/base/dd.c:893
 device_release_driver+0x1e/0x30 drivers/base/dd.c:918
 bus_remove_device+0x2f4/0x4b0 drivers/base/bus.c:565
 device_del+0x5c4/0xab0 drivers/base/core.c:1985
 usb_disable_device+0x1e9/0x680 drivers/usb/core/message.c:1170
 usb_disconnect+0x260/0x7a0 drivers/usb/core/hub.c:2124
 hub_port_connect drivers/usb/core/hub.c:4754
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x1318/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Allocated by task 24:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11e/0x2d0 mm/slub.c:2772
 kmalloc ./include/linux/slab.h:493
 kzalloc ./include/linux/slab.h:666
 usbvision_alloc drivers/media/usb/usbvision/usbvision-video.c:1322
 usbvision_probe+0x72e/0x1cf0 drivers/media/usb/usbvision/usbvision-video.c:1476
 usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
 generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
 usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Freed by task 4383:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1390
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2988
 kfree+0xf6/0x2f0 mm/slub.c:3919
 usbvision_release+0x17d/0x1f0
drivers/media/usb/usbvision/usbvision-video.c:1371
 usbvision_v4l2_close+0x1b0/0x1d0
drivers/media/usb/usbvision/usbvision-video.c:412
 v4l2_release+0xfe/0x210 drivers/media/v4l2-core/v4l2-dev.c:446
 __fput+0x33e/0x800 fs/file_table.c:210
 ____fput+0x1a/0x20 fs/file_table.c:244
 task_work_run+0x1af/0x280 kernel/task_work.c:112
 tracehook_notify_resume ./include/linux/tracehook.h:191
 exit_to_usermode_loop+0x1d4/0x210 arch/x86/entry/common.c:162
 prepare_exit_to_usermode arch/x86/entry/common.c:197
 syscall_return_slowpath+0x3e2/0x4a0 arch/x86/entry/common.c:266
 entry_SYSCALL_64_fastpath+0xc0/0xc2 arch/x86/entry/entry_64.S:238

The buggy address belongs to the object at ffff880069264200
 which belongs to the cache kmalloc-8192 of size 8192
The buggy address is located 2040 bytes inside of
 8192-byte region [ffff880069264200, ffff880069266200)
The buggy address belongs to the page:
page:ffffea0001a49800 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 0000000100030003
raw: dead000000000100 dead000000000200 ffff88006c402a80 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880069264880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff880069264900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff880069264980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff880069264a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff880069264a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
