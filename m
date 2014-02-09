Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:40290 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaBIPju (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 10:39:50 -0500
Date: Sun, 9 Feb 2014 16:33:24 +0100
From: Heiko Voigt <hvoigt@hvoigt.net>
To: Antti Palosaari <crope@iki.fi>,
	Ivan Kalvachev <ikalvachev@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFH: Trying to implement support PCTV Quatro Stick 522e
Message-ID: <20140209153324.GA4043@sandbox-ub>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I just purchased a PCTV QuatroStick 522e (2013:025e). Since it is the successor
of the 520e I believed that there would probably be Linux support for it, it
seems not.

But I do not want to give up so easily and since there is support for the
previous models I would like to have a go at adding support for this one.

I already tried a simple copy and paste approach from the 520e
(resulting in the attached patch[1]) but it seems too many things have been
changed, since it leads to this error[2]. To test I applied my patch on top of
Ubuntus 13.10 kernel repository so I can easily build packages.

My questions are probably mainly directed to Antti since he implemented the
support for 520e:

How did you get the information about 520e? Does it make sense to contact pctv?
I will send an email to their support anyway. Did they provide you with any
information or did you crack open the housing of the stick to find out whats on
the board? Is there anyone else doing development for this device?

Maybe someone can give me some pointers?

Thanks a lot in advance.

Cheers Heiko

[1] ---8<---

Subject: [PATCH] [media] em28xx: support for 2013:0251 PCTV QuatroStick (522e)

Heavily based on copy and paste from c247d7b, fa5527c and 795cb41

Signed-off-by: Heiko Voigt <hvoigt@hvoigt.net>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 28 ++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |  1 +
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 3 files changed, 30 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index eb39903..d91477a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -433,6 +433,20 @@ static struct em28xx_reg_seq pctv_520e[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
+/* 2013:025e PCTV QuatroStick nano (522e)
+ * GPIO_2: decoder reset, 0=active
+ * GPIO_4: decoder suspend, 0=active
+ * GPIO_6: demod reset, 0=active
+ * GPIO_7: LED, 1=active
+ */
+static struct em28xx_reg_seq pctv_522e[] = {
+	{EM2874_R80_GPIO_P0_CTRL,	0x10,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0x14,	0xff,	100}, /* GPIO_2 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,	0x54,	0xff,	050}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO_P0_CTRL,	0xd4,	0xff,	000}, /* GPIO_7 = 1 */
+	{	-1,			-1,	-1,	-1},
+};
+
 /* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
  * reg 0x80/0x84:
  * GPIO_0: capturing LED, 0=on, 1=off
@@ -2094,6 +2108,18 @@ struct em28xx_board em28xx_boards[] = {
 		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	/* 2013:025e PCTV QuatroStick (522e)
+	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2 */
+	[EM2884_BOARD_PCTV_522E] = {
+		.name          = "PCTV QuatroStick nano (522e)",
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = pctv_522e,
+		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
+		.def_i2c_bus   = 1,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 	[EM2884_BOARD_TERRATEC_HTC_USB_XS] = {
 		.name         = "Terratec Cinergy HTC USB XS",
 		.has_dvb      = 1,
@@ -2322,6 +2348,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_PCTV_510E },
 	{ USB_DEVICE(0x2013, 0x0251),
 			.driver_info = EM2884_BOARD_PCTV_520E },
+	{ USB_DEVICE(0x2013, 0x025e),
+			.driver_info = EM2884_BOARD_PCTV_522E },
 	{ USB_DEVICE(0x1b80, 0xe1cc),
 			.driver_info = EM2874_BOARD_DELOCK_61959 },
 	{ USB_DEVICE(0x1ae7, 0x9003),
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a0a669e..fd65825 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1298,6 +1298,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2884_BOARD_PCTV_510E:
 	case EM2884_BOARD_PCTV_520E:
+	case EM2884_BOARD_PCTV_522E:
 		pctv_520e_init(dev);
 
 		/* attach demodulator */
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 32d8a4b..00c083e 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -137,6 +137,7 @@
 #define EM2874_BOARD_KWORLD_UB435Q_V2		  90
 #define EM2765_BOARD_SPEEDLINK_VAD_LAPLACE	  91
 #define EM28178_BOARD_PCTV_461E                   92
+#define EM2884_BOARD_PCTV_522E			  93
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.8.5.1.44.gf92a2f6

[2] ---8<----
[   68.970322] usb 1-2: new high-speed USB device number 4 using ehci-pci
[   69.105487] usb 1-2: New USB device found, idVendor=2013, idProduct=025e
[   69.105495] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   69.105501] usb 1-2: Product: Hauppauge Device
[   69.105505] usb 1-2: Manufacturer: Hauppauge
[   69.105509] usb 1-2: SerialNumber: 4035141730
[   69.245853] em28xx: error: skipping audio endpoint 0x83, because it uses bulk transfers !
[   69.245857] em28xx: New device Hauppauge Hauppauge Device @ 480 Mbps (2013:025e, interface 3, class 3)
[   69.245859] em28xx: Audio interface 3 found (Vendor Class)
[   69.246349] em28xx #0: Config register raw data: 0xfffffffb
[   69.246868] em28xx #0: AC97 chip type couldn't be determined
[   69.246870] em28xx #0: No AC97 audio processor
[   69.246902] em28xx: New device Hauppauge Hauppauge Device @ 480 Mbps (2013:025e, interface 4, class 4)
[   69.246904] em28xx: DVB interface 4 found: bulk isoc
[   69.339091] em28xx #1: reading from i2c device at 0xa0 failed (error=-5)
[   69.339094] em28xx #1: board has no eeprom
[   69.339130] em28xx #1: Identified as PCTV QuatroStick nano (522e) (card=93)
[   69.339465] em28xx #1: Config register raw data: 0xfffffffb
[   69.339840] em28xx #1: AC97 chip type couldn't be determined
[   69.339842] em28xx #1: No AC97 audio processor
[   69.339844] em28xx #1: v4l2 driver version 0.2.0
[   69.795543] em28xx #1: V4L2 video device registered as video1
[   69.795546] em28xx #1: dvb set to isoc mode.
[   69.796766] usbcore: registered new interface driver em28xx
[   69.825313] BUG: unable to handle kernel NULL pointer dereference at 00000008
[   69.825316] IP: [<c14d6f23>] i2c_transfer+0x13/0xc0
[   69.825322] *pdpt = 0000000029a88001 *pde = 0000000000000000 
[   69.825324] Oops: 0000 [#1] SMP 
[   69.825326] Modules linked in: em28xx_dvb(+) dvb_core em28xx tveeprom v4l2_common videobuf2_vmalloc videobuf2_memops videobuf2_core webcamstudio(OF) videodev pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) vesafb bnep rfcomm bluetooth parport_pc ppdev binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel fglrx(POF) kvm_amd eeepc_wmi kvm snd_hda_codec asus_wmi mxm_wmi crc32_pclmul aesni_intel aes_i586 sparse_keymap video xts lrw gf128mul snd_usb_audio ablk_helper snd_usbmidi_lib cryptd snd_hwdep joydev snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore fam15h_power dm_multipath ati_agp scsi_dh k10temp psmouse microcode sp5100_tco i2c_piix4 wmi serio_raw mac_hid lp parport hid_logitech ff_memless hid_generic usbhid hid r8169 ahci libahci mii
[   69.825362] CPU: 5 PID: 3494 Comm: modprobe Tainted: PF          O 3.11.0-17-generic #31
[   69.825364] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 R2.0, BIOS 1302 11/14/2012
[   69.825366] task: e8c26700 ti: e7062000 task.ti: e7062000
[   69.825368] EIP: 0060:[<c14d6f23>] EFLAGS: 00010296 CPU: 5
[   69.825370] EIP is at i2c_transfer+0x13/0xc0
[   69.825371] EAX: 00000000 EBX: 00000000 ECX: 00000001 EDX: e7063d48
[   69.825372] ESI: 00000004 EDI: e7063d90 EBP: e7063d40 ESP: e7063d24
[   69.825374]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   69.825375] CR0: 8005003b CR2: 00000008 CR3: 27061000 CR4: 000407f0
[   69.825376] Stack:
[   69.825377]  e8958c00 f7401a80 e7063d5c c1157699 00000000 00000004 e7063d90 e7063d5c
[   69.825382]  c14d700a 00000041 e7bd0004 e7063d88 e895b400 e7bdb000 e7063dd4 f8ff0490
[   69.825386]  f7be69e8 f7be5c80 00000008 e7063d7c c103ae6b f7be69e8 e7063d88 e7bdba30
[   69.825390] Call Trace:
[   69.825395]  [<c1157699>] ? kmem_cache_alloc_trace+0xe9/0x110
[   69.825398]  [<c14d700a>] i2c_master_send+0x3a/0x50
[   69.825402]  [<f8ff0490>] em28xx_dvb_init+0x460/0x1740 [em28xx_dvb]
[   69.825405]  [<c103ae6b>] ? default_send_IPI_allbutself+0x6b/0x70
[   69.825410]  [<f8ed1e2d>] em28xx_register_extension+0x4d/0x90 [em28xx]
[   69.825413]  [<c1047edf>] ? change_page_attr_set_clr+0x2cf/0x3c0
[   69.825416]  [<f8795000>] ? 0xf8794fff
[   69.825419]  [<f879500d>] em28xx_dvb_register+0xd/0x1000 [em28xx_dvb]
[   69.825422]  [<c10020ca>] do_one_initcall+0xca/0x190
[   69.825425]  [<c10e38e8>] ? tracepoint_module_notify+0x118/0x180
[   69.825429]  [<f8795000>] ? 0xf8794fff
[   69.825431]  [<c104872f>] ? set_memory_nx+0x5f/0x70
[   69.825436]  [<c10b4f2e>] load_module+0x10ce/0x18d0
[   69.825440]  [<c10b57bf>] SyS_init_module+0x8f/0xf0
[   69.825442]  [<c112f46b>] ? vm_mmap_pgoff+0x7b/0xa0
[   69.825451]  [<c1634e8d>] sysenter_do_call+0x12/0x28
[   69.825452] Code: 8d 42 d8 e8 d0 ff ff ff 5d c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 e4 f8 83 ec 0c 3e 8d 74 26 00 89 c3 <8b> 40 08 89 d6 89 cf 8b 00 85 c0 74 58 89 e0 25 00 e0 ff ff f7
[   69.825477] EIP: [<c14d6f23>] i2c_transfer+0x13/0xc0 SS:ESP 0068:e7063d24
[   69.825479] CR2: 0000000000000008
[   69.825481] ---[ end trace 880d31b85ddb74d8 ]---

