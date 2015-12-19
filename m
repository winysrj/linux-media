Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36535 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbbLSGNL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2015 01:13:11 -0500
Received: by mail-io0-f178.google.com with SMTP id o67so110756344iof.3
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2015 22:13:11 -0800 (PST)
MIME-Version: 1.0
From: Christopher Chavez <chrischavez@gmx.us>
Date: Sat, 19 Dec 2015 00:12:51 -0600
Message-ID: <CAAFQ00=2qFjs41KJs5evJVcCHjuCwtATeTL6aOvz8tN47_RyTQ@mail.gmail.com>
Subject: usbvision: problems adding support for ATI TV Wonder USB Edition
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Not yet an experienced developer here, still working on BSCmpE.

I have attempted to add long-awaited support for the ATI TV Wonder USB Edition
(NTSC) to usbvision. I have patches of what I've accomplished so far, but I'm
not yet able to test it due to a couple of issues, at least one of which appears
to be an outstanding bug from a few years ago (the "cannot change alternate
number to 1 (error=-22)" issue). The entry in usbvision-cards.c is based on a
similar Pinnacle and Hauppauge entries: the device looks like it might have been
a rebadged Hauppauge WinTV USB, but inside it has both the NT1004 and NT1005
bridges, SAA7113H input processor, and FI1236MK2 tuner (although none of the
supported devices use .tuner_type = TUNER_PHILIPS_NTSC).

I'm still researching what other programs to test this with (VLC? v4l-utils?)...

Christopher Chavez


---
 drivers/media/usb/usbvision/usbvision-cards.c | 15 +++++++++++++++
 drivers/media/usb/usbvision/usbvision-cards.h |  1 +
 drivers/media/usb/usbvision/usbvision-video.c |  3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-cards.c
b/drivers/media/usb/usbvision/usbvision-cards.c
index 3103d0d..7b1edb7 100644
--- a/drivers/media/usb/usbvision/usbvision-cards.c
+++ b/drivers/media/usb/usbvision/usbvision-cards.c
@@ -1054,6 +1054,20 @@ struct usbvision_device_data_st
usbvision_device_data[] = {
         .y_offset       = 18,
         .model_string   = "Nogatech USB MicroCam PAL (NV3001P)",
     },
+    [ATI_TV_WONDER_USB_NTSC] = {
+        .interface      = 0,
+        .codec          = CODEC_SAA7113,
+        .video_channels = 3,
+        .video_norm     = V4L2_STD_NTSC,
+        .audio_channels = 1,
+        .radio          = 0,
+        .vbi            = 1,
+        .tuner          = 1,
+        .tuner_type     = TUNER_PHILIPS_NTSC,
+        .x_offset       = -1,
+        .y_offset       = -1,
+        .model_string   = "ATI TV Wonder USB Edition (NTSC)",
+    },
 };
 const int usbvision_device_data_size = ARRAY_SIZE(usbvision_device_data);

@@ -1064,6 +1078,7 @@ struct usb_device_id usbvision_table[] = {
     { USB_DEVICE(0x050d, 0x0106), .driver_info = BELKIN_VIDEOBUS_II },
     { USB_DEVICE(0x050d, 0x0207), .driver_info = BELKIN_VIDEOBUS },
     { USB_DEVICE(0x050d, 0x0208), .driver_info = BELKIN_USB_VIDEOBUS_II },
+    { USB_DEVICE(0x0528, 0x7561), .driver_info = ATI_TV_WONDER_USB_NTSC },
     { USB_DEVICE(0x0571, 0x0002), .driver_info = ECHOFX_INTERVIEW_LITE },
     { USB_DEVICE(0x0573, 0x0003), .driver_info = USBGEAR_USBG_V1 },
     { USB_DEVICE(0x0573, 0x0400), .driver_info = D_LINK_V100 },
diff --git a/drivers/media/usb/usbvision/usbvision-cards.h
b/drivers/media/usb/usbvision/usbvision-cards.h
index a51cc11..ed1197c 100644
--- a/drivers/media/usb/usbvision/usbvision-cards.h
+++ b/drivers/media/usb/usbvision/usbvision-cards.h
@@ -65,5 +65,6 @@
 #define PINNA_PCTV_USB_NTSC_FM_V3                64
 #define MICROCAM_NTSC                            65
 #define MICROCAM_PAL                             66
+#define ATI_TV_WONDER_USB_NTSC                   67

 extern const int usbvision_device_data_size;
diff --git a/drivers/media/usb/usbvision/usbvision-video.c
b/drivers/media/usb/usbvision/usbvision-video.c
index de9ff3b..c76e1397 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1511,7 +1511,8 @@ static int usbvision_probe(struct usb_interface *intf,

     if (dev->descriptor.bNumConfigurations > 1)
         usbvision->bridge_type = BRIDGE_NT1004;
-    else if (model == DAZZLE_DVC_90_REV_1_SECAM)
+    else if ((model == DAZZLE_DVC_90_REV_1_SECAM) ||
+             (model == ATI_TV_WONDER_USB_NTSC))
         usbvision->bridge_type = BRIDGE_NT1005;
     else
         usbvision->bridge_type = BRIDGE_NT1003;
-- 


example of dmesg after `modprobe usbvision`, plugging in device,
and a couple of guvcview segfaults on Ubuntu 15.04 amd64:

[  101.761249] media: module verification failed: signature and/or
required key missing - tainting kernel
[  101.761870] media: Linux media interface: v0.10
[  101.781325] Linux video capture interface: v2.00
[  101.781332] WARNING: You are using an experimental version of the
media stack.
    As the driver is backported to an older kernel, it doesn't offer
    enough quality for its usage in production.
    Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
    52d60eb7e6d6429a766ea1b8f67e01c3b2dcd3c5 Revert [media] UVC: Add
support for ds4 depth camera
    991ce92f8de24cde063d531246602b6e14d3fef2 [media] use
https://linuxtv.org for LinuxTV URLs
    4a3d0cb06b3e4248ba4a659d7f2a7a8fa1a877fc drm, ipu-v3: use
https://linuxtv.org for LinuxTV URL
[  101.836434] usbcore: registered new interface driver usbvision
[  101.836439] USBVision USB Video Device Driver for Linux : 0.9.11
[  128.024178] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[  128.256154] usb 5-2: New USB device found, idVendor=0528, idProduct=7561
[  128.256164] usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  128.258136] usbvision_probe: ATI TV Wonder USB Edition (NTSC) found
[  128.634944] saa7115 7-0025: saa7113 found @ 0x4a (usbvision-5-2)
[  130.300445] USBVision[0]: registered USBVision Video device video0 [v4l2]
[  130.300810] usbvision_probe: ATI TV Wonder USB Edition (NTSC) found
[  130.651030] saa7115 8-0025: saa7113 found @ 0x4a (usbvision-5-2)
[  132.291544] USBVision[1]: registered USBVision Video device video1 [v4l2]
[  132.364165] usb 5-2: selecting invalid altsetting 1
[  132.364171] usb 5-2: cannot change alternate number to 1 (error=-22)
[  267.843881] show_signal_msg: 6 callbacks suppressed
[  267.843890] guvcview[2045]: segfault at 0 ip 00007f59e4ba8bdd sp
00007ffc1c19cfd8 error 4 in
libgviewv4l2core-1.0.so.0.1.0[7f59e4ba3000+1d000]
[  304.692260] usb 5-2: USB disconnect, device number 2
[  304.692822] usbvision_disconnect: In use, disconnect pending
[  321.168164] usb 5-2: new full-speed USB device number 3 using uhci_hcd
[  321.399304] usb 5-2: New USB device found, idVendor=0528, idProduct=7561
[  321.399314] usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  321.401375] usbvision_probe: ATI TV Wonder USB Edition (NTSC) found
[  321.419325] ------------[ cut here ]------------
[  321.419341] WARNING: CPU: 1 PID: 16 at
/build/linux-65tOBW/linux-3.19.0/lib/kobject.c:244
kobject_add_internal+0x134/0x460()
[  321.419346] kobject_add_internal failed for i2c-9 (error: -2 parent: i2c-dev)
[  321.419349] Modules linked in: tuner(OE) saa7115(OE) usbvision(OE)
v4l2_common(OE) videodev(OE) media(OE) ctr ccm binfmt_misc zram
lz4_compress snd_hda_codec_idt snd_hda_codec_hdmi arc4
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec
dell_wmi dell_laptop r852 gpio_ich iwl4965 snd_hwdep sparse_keymap
sm_common iwlegacy dcdbas nand snd_pcm mac80211 i8k snd_seq_midi
nand_ecc snd_seq_midi_event cfg80211 nand_bch snd_rawmidi i915
coretemp snd_seq bch joydev nand_ids snd_seq_device mtd drm_kms_helper
serio_raw snd_timer lpc_ich r592 snd mac_hid drm memstick wmi
i2c_algo_bit shpchp soundcore video parport_pc ppdev lp parport
autofs4 btrfs xor raid6_pq ahci psmouse libahci sdhci_pci
firewire_ohci pata_acpi firewire_core crc_itu_t sdhci sky2
[  321.419469] CPU: 1 PID: 16 Comm: kworker/1:0 Tainted: G        W
OE  3.19.0-41-generic #46-Ubuntu
[  321.419471] Hardware name: Dell Inc. Inspiron 1525
 /0U990C, BIOS A16 10/16/2008
[  321.419476] Workqueue: usb_hub_wq hub_event
[  321.419479]  ffffffff81ad96e8 ffff88011a423298 ffffffff817c58a2
0000000000000007
[  321.419483]  ffff88011a4232e8 ffff88011a4232d8 ffffffff81076aaa
ffff8800bb3750f0
[  321.419487]  ffff88011755f810 00000000fffffffe ffff8800daf79060
ffff88011755f800
[  321.419491] Call Trace:
[  321.419498]  [<ffffffff817c58a2>] dump_stack+0x45/0x57
[  321.419503]  [<ffffffff81076aaa>] warn_slowpath_common+0x8a/0xc0
[  321.419506]  [<ffffffff81076b26>] warn_slowpath_fmt+0x46/0x50
[  321.419510]  [<ffffffff813b9304>] kobject_add_internal+0x134/0x460
[  321.419513]  [<ffffffff813b9823>] kobject_add+0x63/0xb0
[  321.419517]  [<ffffffff817ca506>] ? mutex_lock+0x16/0x40
[  321.419521]  [<ffffffff81505400>] device_add+0x120/0x6c0
[  321.419525]  [<ffffffff81505bc8>] device_create_groups_vargs+0xe8/0x100
[  321.419528]  [<ffffffff81505c3b>] device_create+0x3b/0x40
[  321.419533]  [<ffffffff8126e194>] ? kernfs_add_one+0xf4/0x160
[  321.419538]  [<ffffffff8162eee6>] i2cdev_attach_adapter+0xd6/0x150
[  321.419542]  [<ffffffff812703f7>] ? sysfs_add_file_mode_ns+0xa7/0x1c0
[  321.419545]  [<ffffffff8162ef9a>] i2cdev_notifier_call+0x3a/0x40
[  321.419550]  [<ffffffff810968df>] notifier_call_chain+0x4f/0x80
[  321.419553]  [<ffffffff81096c3b>] __blocking_notifier_call_chain+0x4b/0x70
[  321.419557]  [<ffffffff81096c76>] blocking_notifier_call_chain+0x16/0x20
[  321.419560]  [<ffffffff815057ad>] device_add+0x4cd/0x6c0
[  321.419563]  [<ffffffff815059be>] device_register+0x1e/0x30
[  321.419567]  [<ffffffff8162d87e>] i2c_register_adapter+0xbe/0x4b0
[  321.419570]  [<ffffffff8162dccc>] i2c_add_adapter+0x5c/0x70
[  321.419578]  [<ffffffffc07ed0bb>] usbvision_i2c_register+0xfb/0x310
[usbvision]
[  321.419583]  [<ffffffffc07ec439>] usbvision_probe+0x539/0x9d0 [usbvision]
[  321.419588]  [<ffffffff815c550b>] usb_probe_interface+0x1bb/0x300
[  321.419592]  [<ffffffff815088e5>] driver_probe_device+0xb5/0x430
[  321.419596]  [<ffffffff81508c60>] ? driver_probe_device+0x430/0x430
[  321.419599]  [<ffffffff81508c9b>] __device_attach+0x3b/0x40
[  321.419602]  [<ffffffff81506733>] bus_for_each_drv+0x63/0xa0
[  321.419605]  [<ffffffff815087c8>] device_attach+0xb8/0xd0
[  321.419609]  [<ffffffff81507bd0>] bus_probe_device+0xa0/0xc0
[  321.419612]  [<ffffffff815057bf>] device_add+0x4df/0x6c0
[  321.419615]  [<ffffffff815c31db>] usb_set_configuration+0x53b/0x930
[  321.419619]  [<ffffffff8126e194>] ? kernfs_add_one+0xf4/0x160
[  321.419623]  [<ffffffff815ce08e>] generic_probe+0x2e/0x90
[  321.419626]  [<ffffffff815c5302>] usb_probe_device+0x32/0x80
[  321.419630]  [<ffffffff815088e5>] driver_probe_device+0xb5/0x430
[  321.419633]  [<ffffffff81508c60>] ? driver_probe_device+0x430/0x430
[  321.419636]  [<ffffffff81508c9b>] __device_attach+0x3b/0x40
[  321.419639]  [<ffffffff81506733>] bus_for_each_drv+0x63/0xa0
[  321.419643]  [<ffffffff815087c8>] device_attach+0xb8/0xd0
[  321.419646]  [<ffffffff81507bd0>] bus_probe_device+0xa0/0xc0
[  321.419649]  [<ffffffff815057bf>] device_add+0x4df/0x6c0
[  321.419653]  [<ffffffff815b7c78>] usb_new_device+0x2b8/0x510
[  321.419656]  [<ffffffff815b94e0>] hub_port_connect+0x5d0/0xa50
[  321.419660]  [<ffffffff815b9ca4>] port_event+0x344/0x7e0
[  321.419663]  [<ffffffff815ba34d>] hub_event+0x20d/0x400
[  321.419667]  [<ffffffff8108fd88>] process_one_work+0x158/0x430
[  321.419670]  [<ffffffff810908cb>] worker_thread+0x5b/0x530
[  321.419674]  [<ffffffff81090870>] ? rescuer_thread+0x3a0/0x3a0
[  321.419677]  [<ffffffff81095939>] kthread+0xc9/0xe0
[  321.419681]  [<ffffffff81095870>] ? kthread_create_on_node+0x1c0/0x1c0
[  321.419685]  [<ffffffff817cc918>] ret_from_fork+0x58/0x90
[  321.419688]  [<ffffffff81095870>] ? kthread_create_on_node+0x1c0/0x1c0
[  321.419691] ---[ end trace 967acd45f404663b ]---
[  321.755377] saa7115 9-0025: saa7113 found @ 0x4a (usbvision-5-2)
[  323.402574] USBVision[2]: registered USBVision Video device video0 [v4l2]
[  323.402762] usbvision_probe: ATI TV Wonder USB Edition (NTSC) found
[  323.753479] saa7115 10-0025: saa7113 found @ 0x4a (usbvision-5-2)
[  325.416798] USBVision[3]: registered USBVision Video device video2 [v4l2]
[  325.457575] usb 5-2: usbvision_write_reg: failed: error -2
[  325.457583] usb 5-2: selecting invalid altsetting 1
[  325.457587] usb 5-2: cannot change alternate number to 1 (error=-22)
[  326.215766] guvcview[2112]: segfault at 0 ip 00007f85ce708bdd sp
00007fff6ce98948 error 4 in
libgviewv4l2core-1.0.so.0.1.0[7f85ce703000+1d000]


output of lsusb -D for device:
https://gist.github.com/chrstphrchvz/6e8c470f38f20ed6c1ff
