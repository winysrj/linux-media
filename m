Return-path: <linux-media-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([91.227.64.183]:50706 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbeJBKDx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Oct 2018 06:03:53 -0400
Date: Tue, 2 Oct 2018 05:05:26 +0200
From: =?iso-8859-2?B?TWljaGGzoE1pcm9zs2F3?= <mirq-linux@rere.qmqm.pl>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: rtl2832_sdr: Use-after-free when unplugging busy device
Message-ID: <20181002030526.GA20031@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

While testing rtl-sdr (v3) dongle, I've hit an memory corruption while
unplugging the device. With KASAN enabled, I get use-after-free report
from it (see below). This is on Linux v4.18.11.

Best Regards,
Micha³ Miros³aw


[16141.107421] usb 3-2.1: new high-speed USB device number 10 using xhci_hcd
[16141.213180] usb 3-2.1: New USB device found, idVendor=0bda, idProduct=2838, bcdDevice= 1.00
[16141.213194] usb 3-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[16141.213197] usb 3-2.1: Product: RTL2838UHIDIR
[16141.213200] usb 3-2.1: Manufacturer: Realtek
[16141.213202] usb 3-2.1: SerialNumber: 00000001
[16141.224531] usb 3-2.1: dvb_usb_v2: found a 'Realtek RTL2832U reference design' in warm state
[16141.286662] usb 3-2.1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[16141.286762] dvbdev: DVB: registering new adapter (Realtek RTL2832U reference design)
[16141.290794] i2c i2c-1: Added multiplexed i2c bus 2
[16141.290799] rtl2832 1-0010: Realtek RTL2832 successfully attached
[16141.290885] usb 3-2.1: DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
[16141.291209] r820t 2-001a: creating new instance
[16141.298378] r820t 2-001a: Rafael Micro r820t successfully identified
[16141.301125] rtl2832_sdr rtl2832_sdr.2.auto: Registered as swradio0
[16141.301129] rtl2832_sdr rtl2832_sdr.2.auto: Realtek RTL2832 SDR attached
[16141.301133] rtl2832_sdr rtl2832_sdr.2.auto: SDR API is still slightly experimental and functionality changes may follow
[16141.312612] Registered IR keymap rc-empty
[16141.312838] rc rc0: Realtek RTL2832U reference design as /devices/pci0000:00/0000:00:1c.1/0000:07:00.0/usb3/3-2/3-2.1/rc/rc0
[16141.313149] input: Realtek RTL2832U reference design as /devices/pci0000:00/0000:00:1c.1/0000:07:00.0/usb3/3-2/3-2.1/rc/rc0/input16
[16141.313679] rc rc0: lirc_dev: driver dvb_usb_rtl28xxu registered at minor = 0, raw IR receiver, no transmitter
[16141.313749] usb 3-2.1: dvb_usb_v2: schedule remote query interval to 200 msecs
[16141.322310] usb 3-2.1: dvb_usb_v2: 'Realtek RTL2832U reference design' successfully initialized and connected
[16171.703626] rtl2832_sdr_urb_complete: 138 callbacks suppressed
[16171.703636] rtl2832_sdr rtl2832_sdr.2.auto: videobuf is full, 1 packets dropped
[...]
[17946.704899] rtl2832_sdr rtl2832_sdr.2.auto: videobuf is full, 6071 packets dropped
[18831.758684] usb 3-2.1: dvb_usb_v2: rc.query() failed=-71
[18831.758883] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.759678] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.760263] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.760865] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.761443] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.762080] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.762713] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.763316] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.763923] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.764567] rtl2832_sdr rtl2832_sdr.2.auto: urb failed=-71
[18831.778416] usb 3-2.1: USB disconnect, device number 10
[18831.825671] r820t 2-001a: destroying instance
[18831.827016] dvb_usb_v2: 'Realtek RTL2832U reference design:3-2.1' successfully deinitialized and disconnected
[18840.759215] ==================================================================
[18840.759223] BUG: KASAN: use-after-free in rtl2832_sdr_stop_streaming+0x3e/0x4c0 [rtl2832_sdr]
[18840.759226] Read of size 8 at addr ffff8803775fc420 by task kdec/9354

[18840.759232] CPU: 4 PID: 9354 Comm: kdec Tainted: P           O      4.18.11mq+ #265
[18840.759234] Hardware name: System manufacturer System Product Name/P8Z68-V PRO, BIOS 3603 11/09/2012
[18840.759236] Call Trace:
[18840.759241]  dump_stack+0x5b/0x8c
[18840.759246]  print_address_description+0x67/0x237
[18840.759249]  kasan_report.cold.6+0x243/0x2ff
[18840.759253]  ? rtl2832_sdr_stop_streaming+0x3e/0x4c0 [rtl2832_sdr]
[18840.759257]  rtl2832_sdr_stop_streaming+0x3e/0x4c0 [rtl2832_sdr]
[18840.759262]  __vb2_queue_cancel+0x54/0x390 [videobuf2_common]
[18840.759267]  ? fsnotify+0x8f3/0x920
[18840.759271]  vb2_core_streamoff+0x22/0x80 [videobuf2_common]
[18840.759275]  __vb2_cleanup_fileio+0x34/0x90 [videobuf2_common]
[18840.759280]  vb2_core_queue_release+0xa/0x50 [videobuf2_common]
[18840.759284]  _vb2_fop_release+0xe3/0x110 [videobuf2_v4l2]
[18840.759292]  v4l2_release+0x65/0xa0 [videodev]
[18840.759295]  __fput+0x12b/0x310
[18840.759300]  task_work_run+0xb5/0xe0
[18840.759303]  do_exit+0x47a/0x11f0
[18840.759306]  ? mm_update_next_owner+0x350/0x350
[18840.759309]  ? memset+0x1f/0x40
[18840.759312]  ? __dequeue_signal+0x1f8/0x210
[18840.759315]  ? recalc_sigpending_tsk+0x6b/0x90
[18840.759317]  ? recalc_sigpending+0x12/0x60
[18840.759320]  ? dequeue_signal+0x8b/0x290
[18840.759323]  ? vb2_fop_read+0xc7/0x1a0 [videobuf2_v4l2]
[18840.759326]  ? kernel_sigaction+0x160/0x160
[18840.759329]  do_group_exit+0x74/0x110
[18840.759332]  get_signal+0x30c/0x7c0
[18840.759336]  do_signal+0x80/0xac0
[18840.759338]  ? fsnotify+0x8f3/0x920
[18840.759342]  ? setup_sigcontext+0x250/0x250
[18840.759345]  ? __fsnotify_inode_delete+0x10/0x10
[18840.759348]  ? lockref_get_or_lock+0x130/0x130
[18840.759353]  ? kernel_write+0x90/0x90
[18840.759355]  ? task_work_run+0x90/0xe0
[18840.759359]  exit_to_usermode_loop+0x58/0xe0
[18840.759361]  do_syscall_64+0x11e/0x150
[18840.759365]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[18840.759368] RIP: 0033:0x7f6c7ac3ea79
[18840.759369] Code: Bad RIP value.
[18840.759374] RSP: 002b:00007ffdbdf95878 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[18840.759377] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007f6c7ac3ea79
[18840.759379] RDX: 0000000000200000 RSI: 0000557980cd1ef0 RDI: 0000000000000003
[18840.759381] RBP: 0000000000000003 R08: 00007f6c7ad043e0 R09: 0000557980cd1ef0
[18840.759383] R10: 00007f6c7b2441d8 R11: 0000000000000246 R12: 0000000000000000
[18840.759385] R13: 00007f6c7b244020 R14: 00007f6c7a636620 R15: 0000000000000000

[18840.759390] Allocated by task 26512:
[18840.759393]  kasan_kmalloc+0xbf/0xe0
[18840.759396]  __kmalloc+0x113/0x240
[18840.759398]  platform_device_alloc+0x22/0x90
[18840.759401]  platform_device_register_full+0x38/0x1d0
[18840.759404]  rtl2832u_tuner_attach+0xc11/0xe60 [dvb_usb_rtl28xxu]
[18840.759408]  dvb_usbv2_probe+0xb39/0x19b0 [dvb_usb_v2]
[18840.759411]  usb_probe_interface+0x15c/0x420
[18840.759415]  driver_probe_device+0x413/0x610
[18840.759417]  bus_for_each_drv+0xe1/0x140
[18840.759420]  __device_attach+0x161/0x1e0
[18840.759422]  bus_probe_device+0xeb/0x110
[18840.759424]  device_add+0x5be/0x9b0
[18840.759427]  usb_set_configuration+0x6ac/0xca0
[18840.759429]  generic_probe+0x52/0x80
[18840.759432]  driver_probe_device+0x413/0x610
[18840.759434]  bus_for_each_drv+0xe1/0x140
[18840.759436]  __device_attach+0x161/0x1e0
[18840.759439]  bus_probe_device+0xeb/0x110
[18840.759441]  device_add+0x5be/0x9b0
[18840.759443]  usb_new_device+0x471/0x790
[18840.759445]  hub_event+0xb61/0x1f10
[18840.759448]  process_one_work+0x49f/0x7b0
[18840.759450]  worker_thread+0x69/0x6d0
[18840.759453]  kthread+0x19b/0x1c0
[18840.759455]  ret_from_fork+0x35/0x40

[18840.759458] Freed by task 16025:
[18840.759460]  __kasan_slab_free+0x12e/0x180
[18840.759462]  kfree+0x8d/0x1c0
[18840.759465]  device_release+0x42/0xd0
[18840.759467]  kobject_put+0xbe/0x220
[18840.759470]  rtl28xxu_tuner_detach+0x5e/0xe0 [dvb_usb_rtl28xxu]
[18840.759473]  dvb_usbv2_exit+0x1a1/0x490 [dvb_usb_v2]
[18840.759476]  dvb_usbv2_disconnect+0xaf/0x170 [dvb_usb_v2]
[18840.759479]  usb_unbind_interface+0xd6/0x420
[18840.759481]  device_release_driver_internal+0x228/0x350
[18840.759484]  bus_remove_device+0x18f/0x270
[18840.759486]  device_del+0x237/0x540
[18840.759488]  usb_disable_device+0xf5/0x370
[18840.759490]  usb_disconnect+0x155/0x400
[18840.759493]  hub_event+0x7ab/0x1f10
[18840.759495]  process_one_work+0x49f/0x7b0
[18840.759497]  worker_thread+0x69/0x6d0
[18840.759499]  kthread+0x19b/0x1c0
[18840.759502]  ret_from_fork+0x35/0x40

[18840.759505] The buggy address belongs to the object at ffff8803775fc380
                which belongs to the cache kmalloc-1024 of size 1024
[18840.759508] The buggy address is located 160 bytes inside of
                1024-byte region [ffff8803775fc380, ffff8803775fc780)
[18840.759510] The buggy address belongs to the page:
[18840.759513] page:ffffea000ddd7e00 count:1 mapcount:0 mapping:ffff88038e40ebc0 index:0xffff8803775fec00 compound_mapcount: 0
[18840.759517] flags: 0x2000000000008100(slab|head)
[18840.759520] raw: 2000000000008100 ffffea000dd29808 ffffea000dfd5e08 ffff88038e40ebc0
[18840.759523] raw: ffff8803775fec00 00000000001c0013 00000001ffffffff 0000000000000000
[18840.759525] page dumped because: kasan: bad access detected

[18840.759527] Memory state around the buggy address:
[18840.759530]  ffff8803775fc300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[18840.759532]  ffff8803775fc380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[18840.759534] >ffff8803775fc400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[18840.759536]                                ^
[18840.759538]  ffff8803775fc480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[18840.759540]  ffff8803775fc500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[18840.759542] ==================================================================
[18840.759543] Disabling lock debugging due to kernel taint
