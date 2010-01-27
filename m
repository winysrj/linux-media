Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:23872 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab0A0FbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 00:31:03 -0500
Received: by fg-out-1718.google.com with SMTP id e12so88287fga.1
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2010 21:31:00 -0800 (PST)
Date: Wed, 27 Jan 2010 14:36:37 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: saa7134 and =?UTF-8?B?w4PCjsOCwrxQRDYxMTUx?= MPEG2 coder
Message-ID: <20100127143637.26465503@glory.loctelecom.ru>
In-Reply-To: <201001130838.23949.hverkuil@xs4all.nl>
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>
	<200912160849.17005.hverkuil@xs4all.nl>
	<20100112172209.464e88cd@glory.loctelecom.ru>
	<201001130838.23949.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ckG7z_s72hy+8MgR_b5qyfE"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/ckG7z_s72hy+8MgR_b5qyfE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hans.

I finished saa7134 part of SPI. Please review saa7134-spi.c and diff saa7134-core and etc.
I wrote config of SPI to board structure. Use this config for register master and slave devices.

SPI other then I2C, do not need call request_module. Udev do it. 
I spend 10 days for understanding :(  

I need help with v4l2-common.c -> function v4l2_spi_new_subdev_board
The module of SPI slave loading after some time and spi device hasn't v4l2_subdev structure
for v4l2_device_register_subdev.

Now I get kernel crash when call v4l2_device_register_subdev.

Need use a callback metod or other. I don't know.

Copy to Mauro Carvalho Chehab and mailing lists for review my code too.

Dmesg log without call v4l2_device_register_subdev.
[    4.742279] Linux video capture interface: v2.00
[    4.816171] saa7130/34: v4l2 driver version 0.2.15 loaded
[    4.816253] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.816304] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
[    4.816363] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[    4.816430] saa7133[0]: board init: gpio is 200000
[    4.816481] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    4.976010] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[    4.976635] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.977231] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.977827] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.978423] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.979019] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.979615] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.980223] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.980820] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.981416] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.982012] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.982608] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.983204] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.983800] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.984437] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[    4.985033] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[    5.008041] tuner 1-0061: chip found @ 0xc2 (saa7133[0])
[    5.024036] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.024109] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.066725] xc5000 1-0061: creating new instance
[    5.076009] xc5000: Successfully identified at address 0x61
[    5.076060] xc5000: Firmware has not been loaded previously

[   33.381216] saa7134 0000:04:01.0: spi master registered: bus_num=32766 num_chipselect=1
[   33.381274] saa7133[0]: found muPD61151 MPEG encoder
[   33.381430] saa7133[0]: registered device video0 [v4l2]
[   33.381491] saa7133[0]: registered device vbi0
[   33.381551] saa7133[0]: registered device radio0
[   33.406256] saa7133[0]: registered device video1 [mpeg]
[   33.407628] upd61151_probe function
[   33.407672] Read test REG 0xD8 :
[   33.409502] REG = 0x0
[   33.409547] Write test 0x03 to REG 0xD8 :
[   33.411353] Next read test REG 0xD8 :
[   33.413176] REG = 0x3
[   33.431308] saa7134 ALSA driver for DMA sound loaded
[   33.431363] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   33.431425] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered as card -1

[   48.657067] xc5000: I2C write failed (len=4)
[   48.760018] xc5000: I2C write failed (len=4)
[   48.762960] xc5000: I2C read failed
[   48.763011] xc5000: I2C read failed
[   48.763054] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[   48.763102] saa7134 0000:04:01.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[   48.802473] xc5000: firmware read 12401 bytes.
[   48.802477] xc5000: firmware uploading...
[   49.328504] eth0: no IPv6 routers present
[   52.132007] xc5000: firmware upload complete...
[   53.366772] ------------[ cut here ]------------
[   53.366820] kernel BUG at lib/kernel_lock.c:126!
[   53.366865] invalid opcode: 0000 [#1] SMP 
[   53.366973] last sysfs file: /sys/class/firmware/0000:04:01.0/loading
[   53.367019] Modules linked in: ipv6 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod loop saa7134_alsa upd61151 saa7134_empress ir_kbd_i2c snd_hda_codec_realtek xc5000 snd_hda_intel snd_hda_codec tuner snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq saa7134 snd_timer ir_common v4l2_common videodev snd_seq_device v4l1_compat videobuf_dma_sg videobuf_core spi_bitbang psmouse snd ir_core serio_raw tveeprom soundcore parport_pc parport processor i2c_i801 button snd_page_alloc i2c_core intel_agp agpgart rng_core pcspkr evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic ata_piix libata scsi_mod ide_pci_generic ide_core ehci_hcd uhci_hcd r8169 mii usbcore thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[   53.369624] 
[   53.369666] Pid: 2659, comm: hald-probe-vide Not tainted (2.6.30.5 #1) G31M-ES2L
[   53.369721] EIP: 0060:[<c02f81e3>] EFLAGS: 00010286 CPU: 0
[   53.369770] EIP is at unlock_kernel+0xd/0x24
[   53.369814] EAX: f6bc26ac EBX: f6bc2000 ECX: f6bc26ac EDX: f707e4d0
[   53.369860] ESI: 00000000 EDI: f6aa90c0 EBP: f6bc26ac ESP: f65b1e68
[   53.369906]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   53.369952] Process hald-probe-vide (pid: 2659, ti=f65b0000 task=f707e4d0 task.ti=f65b0000)
[   53.370008] Stack:
[   53.370049]  f873e9c9 00000000 f687c804 f6aa90c0 00000000 f848e309 00000000 f6b4d680
[   53.370298]  f6b4d680 c0190049 f6aa90c0 f6a144e4 00000000 f6aa90c0 00000000 f6a144e4
[   53.370298]  c018ff24 c018c3b9 f701ef40 f6d11a5c f6aa90c0 f65b1f0c f65b1f0c 00008001
[   53.370298] Call Trace:
[   53.370298]  [<f873e9c9>] ? ts_open+0x8c/0x93 [saa7134_empress]
[   53.370298]  [<f848e309>] ? v4l2_open+0x65/0x78 [videodev]
[   53.370298]  [<c0190049>] ? chrdev_open+0x125/0x13c
[   53.370298]  [<c018ff24>] ? chrdev_open+0x0/0x13c
[   53.370298]  [<c018c3b9>] ? __dentry_open+0x119/0x208
[   53.370298]  [<c018c539>] ? nameidata_to_filp+0x29/0x3c
[   53.370298]  [<c0197338>] ? do_filp_open+0x41e/0x7bc
[   53.370298]  [<c017bb3c>] ? handle_mm_fault+0x294/0x5fd
[   53.370298]  [<c019e267>] ? alloc_fd+0x52/0xb8
[   53.370298]  [<c018c1d1>] ? do_sys_open+0x44/0xb4
[   53.370298]  [<c018c285>] ? sys_open+0x1e/0x23
[   53.370298]  [<c0102f74>] ? sysenter_do_call+0x12/0x28
[   53.370298] Code: 0f c1 05 e0 4b 3e c0 38 e0 74 09 f3 90 a0 e0 4b 3e c0 eb f3 64 a1 00 b0 43 c0 89 50 14 c3 64 8b 15 00 b0 43 c0 83 7a 14 00 79 04 <0f> 0b eb fe 8b 42 14 48 85 c0 89 42 14 79 07 f0 fe 05 e0 4b 3e 
[   53.370298] EIP: [<c02f81e3>] unlock_kernel+0xd/0x24 SS:ESP 0068:f65b1e68
[   53.374302] ---[ end trace 05965e9e089c46c7 ]---


With my best regards, Dmitry.

--MP_/ckG7z_s72hy+8MgR_b5qyfE
Content-Type: text/x-patch; name=behold_spi.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_spi.diff

diff -r b6b82258cf5e linux/drivers/media/video/saa7134/Makefile
--- a/linux/drivers/media/video/saa7134/Makefile	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/Makefile	Wed Jan 27 07:54:50 2010 +0900
@@ -1,9 +1,9 @@
 
 saa7134-objs :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o	\
 		saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o    \
-		saa7134-video.o saa7134-input.o
+		saa7134-video.o saa7134-input.o saa7134-spi.o
 
-obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
+obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o upd61151.o
 
 obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Jan 27 07:54:50 2010 +0900
@@ -4619,6 +4619,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4656,6 +4657,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4695,6 +4697,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -5279,23 +5282,51 @@
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x00860000,
 		.inputs         = { {
 			.name = name_tv,
 			.vmux = 2,
 			.amux = TV,
 			.tv   = 1,
-		}, {
-			.name = name_comp1,
-			.vmux = 0,
-			.amux = LINE1,
+			.gpio = 0x00860000
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+			.gpio = 0x00860000
 		}, {
 			.name = name_svideo,
 			.vmux = 9,
 			.amux = LINE1,
-		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
+			.gpio = 0x00860000
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x00860000
+		},
+		.encoder_type = SAA7134_ENCODER_muPD61151,
+		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
+		.spi = {
+			.cs    = 17,
+			.clock = 18,
+			.mosi  = 23,
+			.miso  = 21,
+			.num_chipselect = 1,
+			.spi_enable = 1,
+		},
+		.spi_conf = {
+			.modalias	= "upd61151",
+			.max_speed_hz	= 10000000,
+			.chip_select	= 0,
+			.mode		= SPI_MODE_0,
+			.controller_data = NULL,
+			.platform_data  = NULL,
 		},
 	},
 	[SAA7134_BOARD_ZOLID_HYBRID_PCI] = {
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Wed Jan 27 07:54:50 2010 +0900
@@ -139,6 +139,18 @@
 		break;
 	}
 }
+
+unsigned long saa7134_get_gpio(struct saa7134_dev *dev)
+{
+	unsigned long status;
+
+	/* rising SAA7134_GPIO_GPRESCAN reads the status */
+	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,0);
+	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,SAA7134_GPIO_GPRESCAN);
+	status = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & 0xfffffff;
+	return status;
+}
+
 
 /* ------------------------------------------------------------------ */
 
@@ -1057,12 +1069,42 @@
 
 	saa7134_hwinit2(dev);
 
-	/* load i2c helpers */
+	/* initialize software SPI bus */
+	if (saa7134_boards[dev->board].spi.spi_enable)
+	{
+		dev->spi = saa7134_boards[dev->board].spi;
+
+		/* register SPI master and SPI slave */
+		if (saa7134_spi_register(dev, &saa7134_boards[dev->board].spi_conf))
+			saa7134_boards[dev->board].spi.spi_enable = 0;
+	}
+
+	/* load bus helpers */
 	if (card_is_empress(dev)) {
-		struct v4l2_subdev *sd =
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		struct v4l2_subdev *sd = NULL;
+
+		dev->encoder_type = saa7134_boards[dev->board].encoder_type;
+
+		switch (dev->encoder_type) {
+		case SAA7134_ENCODER_muPD61151:
+		{
+			printk(KERN_INFO "%s: found muPD61151 MPEG encoder\n", dev->name);
+
+			if (saa7134_boards[dev->board].spi.spi_enable)
+				sd = v4l2_spi_new_subdev(&dev->v4l2_dev, dev->spi_adap, &saa7134_boards[dev->board].spi_conf);
+		}
+			break;
+		case SAA7134_ENCODER_SAA6752HS:
+		{
+			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 				"saa6752hs", "saa6752hs",
 				saa7134_boards[dev->board].empress_addr, NULL);
+		}
+			break;
+		default:
+			printk(KERN_INFO "%s: MPEG encoder is not configured\n", dev->name);
+		    break;
+		}
 
 		if (sd)
 			sd->grp_id = GRP_EMPRESS;
@@ -1139,6 +1181,8 @@
 	return 0;
 
  fail4:
+	if ((card_is_empress(dev)) && (dev->encoder_type == SAA7134_ENCODER_muPD61151))
+		saa7134_spi_unregister(dev);
 	saa7134_unregister_video(dev);
 	saa7134_i2c_unregister(dev);
 	free_irq(pci_dev->irq, dev);
@@ -1412,6 +1456,7 @@
 /* ----------------------------------------------------------- */
 
 EXPORT_SYMBOL(saa7134_set_gpio);
+EXPORT_SYMBOL(saa7134_get_gpio);
 EXPORT_SYMBOL(saa7134_boards);
 
 /* ----------------- for the DMA sound modules --------------- */
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Jan 27 07:54:50 2010 +0900
@@ -30,6 +30,13 @@
 #include <linux/notifier.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+
+/* ifdef software SPI insert here start */
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_gpio.h>
+#include <linux/spi/spi_bitbang.h>
+/* ifdef software SPI insert here stop */
 
 #include <asm/io.h>
 
@@ -337,6 +344,21 @@
 	SAA7134_MPEG_TS_SERIAL,
 };
 
+enum saa7134_encoder_type {
+	SAA7134_ENCODER_UNUSED,
+	SAA7134_ENCODER_SAA6752HS,
+	SAA7134_ENCODER_muPD61151,
+};
+
+struct saa7134_software_spi {
+	unsigned char cs:5;
+	unsigned char clock:5;
+	unsigned char mosi:5;
+	unsigned char miso:5;
+	unsigned char num_chipselect:3;
+	unsigned char spi_enable:1;
+};
+
 struct saa7134_board {
 	char                    *name;
 	unsigned int            audio_clock;
@@ -355,6 +377,10 @@
 	unsigned char		empress_addr;
 	unsigned char		rds_addr;
 
+	/* SPI info */
+	struct saa7134_software_spi	spi;
+	struct spi_board_info   spi_conf;
+
 	unsigned int            tda9887_conf;
 	unsigned int            tuner_config;
 
@@ -362,6 +388,7 @@
 	enum saa7134_video_out  video_out;
 	enum saa7134_mpeg_type  mpeg;
 	enum saa7134_mpeg_ts_type ts_type;
+	enum saa7134_encoder_type encoder_type;
 	unsigned int            vid_port_opts;
 	unsigned int            ts_force_val:1;
 };
@@ -506,6 +533,12 @@
 	void                       (*signal_change)(struct saa7134_dev *dev);
 };
 
+struct saa7134_spi_gpio {
+	struct spi_bitbang         bitbang;
+	struct spi_master          *master;
+	struct saa7134_dev         *controller_data;
+};
+
 /* global device status */
 struct saa7134_dev {
 	struct list_head           devlist;
@@ -553,6 +586,10 @@
 	struct i2c_client          i2c_client;
 	unsigned char              eedata[256];
 	int 			   has_rds;
+
+	/* software spi */
+	struct saa7134_software_spi spi;
+	struct spi_master          *spi_adap;
 
 	/* video overlay */
 	struct v4l2_framebuffer    ovbuf;
@@ -615,6 +652,7 @@
 	atomic_t 		   empress_users;
 	struct work_struct         empress_workqueue;
 	int                        empress_started;
+	enum saa7134_encoder_type  encoder_type;
 
 #if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
 	/* SAA7134_MPEG_DVB only */
@@ -681,6 +719,7 @@
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg);
 void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value);
+unsigned long saa7134_get_gpio(struct saa7134_dev *dev);
 
 #define SAA7134_PGTABLE_SIZE 4096
 
@@ -726,6 +765,11 @@
 int saa7134_i2c_register(struct saa7134_dev *dev);
 int saa7134_i2c_unregister(struct saa7134_dev *dev);
 
+/* ----------------------------------------------------------- */
+/* saa7134-spi.c                                               */
+
+int saa7134_spi_register(struct saa7134_dev *dev, struct spi_board_info *info);
+int saa7134_spi_unregister(struct saa7134_dev *dev);
 
 /* ----------------------------------------------------------- */
 /* saa7134-video.c                                             */
diff -r b6b82258cf5e linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-common.c	Wed Jan 27 07:54:50 2010 +0900
@@ -51,6 +51,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
+#include <linux/spi/spi.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -1069,6 +1070,87 @@
 
 #endif /* defined(CONFIG_I2C) */
 
+//#if defined(CONFIG_SPI) || (defined(CONFIG_SPI_MODULE) && defined(MODULE)) + SPI_BITBANG
+
+/* Load an spi sub-device. */
+
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops)
+{
+	v4l2_subdev_init(sd, ops);
+	sd->flags |= V4L2_SUBDEV_FL_IS_SPI;
+	/* the owner is the same as the spi_device's driver owner */
+	sd->owner = spi->dev.driver->owner;
+	/* spi_device and v4l2_subdev point to one another */
+	v4l2_set_subdevdata(sd, spi);
+	dev_set_drvdata(&spi->dev, sd);
+	/* initialize name */
+	snprintf(sd->name, sizeof(sd->name), "%s",
+		spi->dev.driver->name);
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
+
+struct v4l2_subdev *v4l2_spi_new_subdev_board(struct v4l2_device *v4l2_dev,
+		struct spi_master *spi, struct spi_board_info *info)
+{
+	struct v4l2_subdev *sd = NULL;
+
+	BUG_ON(!v4l2_dev);
+
+	if (spi == NULL)
+		goto error;
+
+	spi_new_device(spi,info);
+
+#if 0
+	if (module_name)
+		request_module(module_name);
+
+	if (!try_module_get(spi->dev.driver->owner))
+		goto error;
+
+	sd = dev_get_drvdata(&spi->dev);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+
+	if (v4l2_device_register_subdev(v4l2_dev, sd))
+		sd = NULL;
+
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(spi->dev.driver->owner);
+#endif
+error:
+	/* If we have a client but no subdev, then something went wrong and
+	   we must unregister the client. */
+#if 0
+	if (spi && sd == NULL)
+		spi_unregister_device(spi);
+#endif
+	return sd;
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev_board);
+
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *spi, struct spi_board_info *spi_slave)
+{
+	struct spi_board_info info;
+
+	memset(&info, 0, sizeof(info));
+	strlcpy(info.modalias,spi_slave->modalias,sizeof(info.modalias));
+	info.max_speed_hz = spi_slave->max_speed_hz;
+	info.chip_select = spi_slave->chip_select;
+	info.mode = spi_slave->mode;
+	info.bus_num = spi_slave->bus_num;
+	info.platform_data = spi_slave->platform_data;
+	info.controller_data = spi_slave->controller_data;
+
+	return v4l2_spi_new_subdev_board(v4l2_dev, spi, &info);
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);
+
+//#endif /* defined(CONFIG_SPI) */
+
 /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
  * and max don't have to be aligned, but there must be at least one valid
  * value.  E.g., min=17,max=31,align=4 is not allowed as there are no multiples
diff -r b6b82258cf5e linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-common.h	Wed Jan 27 07:54:50 2010 +0900
@@ -191,6 +191,28 @@
 
 /* ------------------------------------------------------------------------- */
 
+/* SPI Helper functions */
+
+#include <linux/spi/spi.h>
+
+struct spi_device_id;
+struct spi_device;
+
+/* Load an spi module and return an initialized v4l2_subdev struct.
+   Only call request_module if module_name != NULL.
+   The client_type argument is the name of the chip that's on the adapter. */
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *spi, struct spi_board_info *spi_slave);
+
+struct v4l2_subdev *v4l2_spi_new_subdev_board(struct v4l2_device *v4l2_dev,
+		struct spi_master *spi, struct spi_board_info *info);
+
+/* Initialize an v4l2_subdev with data from an spi_device struct */
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops);
+
+/* ------------------------------------------------------------------------- */
+
 /* Note: these remaining ioctls/structs should be removed as well, but they are
    still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
    v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
diff -r b6b82258cf5e linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-subdev.h	Wed Jan 27 07:54:50 2010 +0900
@@ -387,6 +387,8 @@
 
 /* Set this flag if this subdev is a i2c device. */
 #define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
+/* Set this flag if this subdev is a spi device. */
+#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.

--MP_/ckG7z_s72hy+8MgR_b5qyfE
Content-Type: text/x-log; name=dmesg.log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.log

[    4.742279] Linux video capture interface: v2.00
[    4.816171] saa7130/34: v4l2 driver version 0.2.15 loaded
[    4.816253] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.816304] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
[    4.816363] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[    4.816430] saa7133[0]: board init: gpio is 200000
[    4.816481] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    4.976010] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[    4.976635] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.977231] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.977827] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.978423] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.979019] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.979615] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.980223] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.980820] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.981416] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.982012] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.982608] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.983204] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.983800] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.984437] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[    4.985033] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[    5.008041] tuner 1-0061: chip found @ 0xc2 (saa7133[0])
[    5.024036] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.024109] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.066725] xc5000 1-0061: creating new instance
[    5.076009] xc5000: Successfully identified at address 0x61
[    5.076060] xc5000: Firmware has not been loaded previously

[   33.381216] saa7134 0000:04:01.0: spi master registered: bus_num=32766 num_chipselect=1
[   33.381274] saa7133[0]: found muPD61151 MPEG encoder
[   33.381430] saa7133[0]: registered device video0 [v4l2]
[   33.381491] saa7133[0]: registered device vbi0
[   33.381551] saa7133[0]: registered device radio0
[   33.406256] saa7133[0]: registered device video1 [mpeg]
[   33.407628] upd61151_probe function
[   33.407672] Read test REG 0xD8 :
[   33.409502] REG = 0x0
[   33.409547] Write test 0x03 to REG 0xD8 :
[   33.411353] Next read test REG 0xD8 :
[   33.413176] REG = 0x3
[   33.431308] saa7134 ALSA driver for DMA sound loaded
[   33.431363] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   33.431425] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered as card -1

[   48.657067] xc5000: I2C write failed (len=4)
[   48.760018] xc5000: I2C write failed (len=4)
[   48.762960] xc5000: I2C read failed
[   48.763011] xc5000: I2C read failed
[   48.763054] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[   48.763102] saa7134 0000:04:01.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[   48.802473] xc5000: firmware read 12401 bytes.
[   48.802477] xc5000: firmware uploading...
[   49.328504] eth0: no IPv6 routers present
[   52.132007] xc5000: firmware upload complete...
[   53.366772] ------------[ cut here ]------------
[   53.366820] kernel BUG at lib/kernel_lock.c:126!
[   53.366865] invalid opcode: 0000 [#1] SMP 
[   53.366973] last sysfs file: /sys/class/firmware/0000:04:01.0/loading
[   53.367019] Modules linked in: ipv6 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod loop saa7134_alsa upd61151 saa7134_empress ir_kbd_i2c snd_hda_codec_realtek xc5000 snd_hda_intel snd_hda_codec tuner snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq saa7134 snd_timer ir_common v4l2_common videodev snd_seq_device v4l1_compat videobuf_dma_sg videobuf_core spi_bitbang psmouse snd ir_core serio_raw tveeprom soundcore parport_pc parport processor i2c_i801 button snd_page_alloc i2c_core intel_agp agpgart rng_core pcspkr evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic ata_piix libata scsi_mod ide_pci_generic ide_core ehci_hcd uhci_hcd r8169 mii usbcore thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[   53.369624] 
[   53.369666] Pid: 2659, comm: hald-probe-vide Not tainted (2.6.30.5 #1) G31M-ES2L
[   53.369721] EIP: 0060:[<c02f81e3>] EFLAGS: 00010286 CPU: 0
[   53.369770] EIP is at unlock_kernel+0xd/0x24
[   53.369814] EAX: f6bc26ac EBX: f6bc2000 ECX: f6bc26ac EDX: f707e4d0
[   53.369860] ESI: 00000000 EDI: f6aa90c0 EBP: f6bc26ac ESP: f65b1e68
[   53.369906]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   53.369952] Process hald-probe-vide (pid: 2659, ti=f65b0000 task=f707e4d0 task.ti=f65b0000)
[   53.370008] Stack:
[   53.370049]  f873e9c9 00000000 f687c804 f6aa90c0 00000000 f848e309 00000000 f6b4d680
[   53.370298]  f6b4d680 c0190049 f6aa90c0 f6a144e4 00000000 f6aa90c0 00000000 f6a144e4
[   53.370298]  c018ff24 c018c3b9 f701ef40 f6d11a5c f6aa90c0 f65b1f0c f65b1f0c 00008001
[   53.370298] Call Trace:
[   53.370298]  [<f873e9c9>] ? ts_open+0x8c/0x93 [saa7134_empress]
[   53.370298]  [<f848e309>] ? v4l2_open+0x65/0x78 [videodev]
[   53.370298]  [<c0190049>] ? chrdev_open+0x125/0x13c
[   53.370298]  [<c018ff24>] ? chrdev_open+0x0/0x13c
[   53.370298]  [<c018c3b9>] ? __dentry_open+0x119/0x208
[   53.370298]  [<c018c539>] ? nameidata_to_filp+0x29/0x3c
[   53.370298]  [<c0197338>] ? do_filp_open+0x41e/0x7bc
[   53.370298]  [<c017bb3c>] ? handle_mm_fault+0x294/0x5fd
[   53.370298]  [<c019e267>] ? alloc_fd+0x52/0xb8
[   53.370298]  [<c018c1d1>] ? do_sys_open+0x44/0xb4
[   53.370298]  [<c018c285>] ? sys_open+0x1e/0x23
[   53.370298]  [<c0102f74>] ? sysenter_do_call+0x12/0x28
[   53.370298] Code: 0f c1 05 e0 4b 3e c0 38 e0 74 09 f3 90 a0 e0 4b 3e c0 eb f3 64 a1 00 b0 43 c0 89 50 14 c3 64 8b 15 00 b0 43 c0 83 7a 14 00 79 04 <0f> 0b eb fe 8b 42 14 48 85 c0 89 42 14 79 07 f0 fe 05 e0 4b 3e 
[   53.370298] EIP: [<c02f81e3>] unlock_kernel+0xd/0x24 SS:ESP 0068:f65b1e68
[   53.374302] ---[ end trace 05965e9e089c46c7 ]---

--MP_/ckG7z_s72hy+8MgR_b5qyfE
Content-Type: text/x-c++src; name=saa7134-spi.c
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=saa7134-spi.c

/*
 *
 * Device driver for philips saa7134 based TV cards
 * SPI software interface support
 *
 * (c) 2009 Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
 *
 *  Important: now support ONLY SPI_MODE_0, see FIXME
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include "saa7134-reg.h"
#include "saa7134.h"
#include <media/v4l2-common.h>

/* ----------------------------------------------------------- */

static unsigned int spi_debug;
module_param(spi_debug, int, 0644);
MODULE_PARM_DESC(spi_debug,"enable debug messages [spi]");

#define d1printk if (1 == spi_debug) printk
#define d2printk if (2 == spi_debug) printk

static inline void spidelay(unsigned d)
{
	udelay(d);
}

static inline struct saa7134_spi_gpio *to_sb(struct spi_device *spi)
{
	return spi_master_get_devdata(spi->master);
}

static inline void setsck(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.clock, on ? 1 : 0);
}

static inline void setmosi(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.mosi, on ? 1 : 0);
}

static inline u32 getmiso(struct spi_device *dev)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);
	unsigned long status;

	status = saa7134_get_gpio(sb->controller_data);
	if ( status & (1 << sb->controller_data->spi.miso))
		return 1;
	else
		return 0;
}

#define EXPAND_BITBANG_TXRX 1
#include <linux/spi/spi_bitbang.h>

static void saa7134_spi_gpio_chipsel(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	if (on)
	{
		/* FIXME: set clock to zero by default, only SPI_MODE_0 compatible */
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.clock, 0);
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.cs, 0);
	}
	else
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.cs, 1);
}

/* Our actual bitbanger routine. */
static u32 saa7134_txrx(struct spi_device *spi, unsigned nsecs, u32 word, u8 bits)
{
	return bitbang_txrx_be_cpha0(spi, nsecs, 0, word, bits);
}

static int saa7134_setup(struct spi_device *spi, struct spi_transfer *t)
{
	return spi_bitbang_setup_transfer(spi, t);
}

int saa7134_spi_register(struct saa7134_dev *dev, struct spi_board_info *info)
{
	struct spi_master *master = NULL;
	struct saa7134_spi_gpio *sb = NULL;
	int ret = 0;

	master = spi_alloc_master(&dev->pci->dev, sizeof(struct saa7134_spi_gpio));

	if (master == NULL) {
		dev_err(&dev->pci->dev, "failed to allocate spi master\n");
		ret = -ENOMEM;
		goto err;
	}

	sb = spi_master_get_devdata(master);

	master->num_chipselect = dev->spi.num_chipselect;
	master->bus_num = -1;
	sb->master = spi_master_get(master);
	sb->bitbang.master = sb->master;
	sb->bitbang.master->bus_num = -1;
	sb->bitbang.master->num_chipselect = dev->spi.num_chipselect;
	sb->bitbang.chipselect = saa7134_spi_gpio_chipsel;
	sb->bitbang.txrx_word[SPI_MODE_0] = saa7134_txrx;
	sb->bitbang.setup_transfer = saa7134_setup;

	/* set state of spi pins */
	saa7134_set_gpio(dev, dev->spi.cs, 1);
	/* FIXME: set clock to zero by default, only SPI_MODE_0 compatible */
	saa7134_set_gpio(dev, dev->spi.clock, 0);
	saa7134_set_gpio(dev, dev->spi.mosi, 1);
	saa7134_set_gpio(dev, dev->spi.miso, 3);

	/* start SPI bitbang master */
	ret = spi_bitbang_start(&sb->bitbang);
	if (ret) {
		dev_err(&dev->pci->dev, "Failed to register SPI master\n");
		goto err_no_bitbang;
	}
	dev_info(&dev->pci->dev,
		"spi master registered: bus_num=%d num_chipselect=%d\n",
		master->bus_num, master->num_chipselect);

	sb->controller_data = dev;
	info->bus_num = sb->master->bus_num;
	info->controller_data = master;
	dev->spi_adap = master;

err_no_bitbang:
	spi_master_put(master);
err:
	return ret;
}

int saa7134_spi_unregister(struct saa7134_dev *dev)
{
	struct saa7134_spi_gpio *sb = spi_master_get_devdata(dev->spi_adap);

	spi_bitbang_stop(&sb->bitbang);
	spi_master_put(sb->master);

	return 0;
}


/*
 * Overrides for Emacs so that we follow Linus's tabbing style.
 * ---------------------------------------------------------------------------
 * Local variables:
 * c-basic-offset: 8
 * End:
 */
 
--MP_/ckG7z_s72hy+8MgR_b5qyfE
Content-Type: text/x-c++src; name=upd61151.c
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=upd61151.c

 /*
    upd61151 - driver for the uPD61151 by NEC

    Copyright (C) Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

    Based on the saa6752s.c driver.
    Copyright (C) 2004 Andrew de Quincey

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License vs published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mvss Ave, Cambridge, MA 02139, USA.
  */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/sysfs.h>
#include <linux/string.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <linux/errno.h>
#include <linux/slab.h>
#include <linux/poll.h>
#include <linux/spi/spi.h>
#include <linux/types.h>
//#include <linux/mod_devicetable.h>
#include "compat.h"
#include <linux/videodev2.h>
#include <media/v4l2-device.h>
#include <media/v4l2-common.h>
#include <media/v4l2-chip-ident.h>
#include <media/upd61151.h>

#include <linux/crc32.h>
#include "saa7134.h"

#define MPEG_VIDEO_TARGET_BITRATE_MAX  27000
#define MPEG_VIDEO_MAX_BITRATE_MAX     27000
#define MPEG_TOTAL_TARGET_BITRATE_MAX  27000
#define MPEG_PID_MAX ((1 << 14) - 1)

#define DRVNAME		"upd61151"

MODULE_DESCRIPTION("device driver for uPD61151 MPEG2 encoder");
MODULE_AUTHOR("Dmitry V Belimov");
MODULE_LICENSE("GPL");

enum upd61151_videoformat {
	UPD61151_VF_D1 = 0,    /* standard D1 video format: 720x576 */
	UPD61151_VF_2_3_D1 = 1,/* 2/3D1 video format: 480x576 */
	UPD61151_VF_1_2_D1 = 2,/* 1/2D1 video format: 352x576 */
	UPD61151_VF_SIF = 3,   /* SIF video format: 352x288 */
	UPD61151_VF_UNKNOWN,
};

struct upd61151_mpeg_params {
	/* transport streams */
	__u16				ts_pid_pmt;
	__u16				ts_pid_audio;
	__u16				ts_pid_video;
	__u16				ts_pid_pcr;

	/* audio */
	enum v4l2_mpeg_audio_encoding    au_encoding;
	enum v4l2_mpeg_audio_l2_bitrate  au_l2_bitrate;

	/* video */
	enum v4l2_mpeg_video_aspect	vi_aspect;
	enum v4l2_mpeg_video_bitrate_mode vi_bitrate_mode;
	__u32 				vi_bitrate;
	__u32 				vi_bitrate_peak;
};

static const struct v4l2_format v4l2_format_table[] =
{
	[UPD61151_VF_D1] =
		{ .fmt = { .pix = { .width = 720, .height = 576 }}},
	[UPD61151_VF_2_3_D1] =
		{ .fmt = { .pix = { .width = 480, .height = 576 }}},
	[UPD61151_VF_1_2_D1] =
		{ .fmt = { .pix = { .width = 352, .height = 576 }}},
	[UPD61151_VF_SIF] =
		{ .fmt = { .pix = { .width = 352, .height = 288 }}},
	[UPD61151_VF_UNKNOWN] =
		{ .fmt = { .pix = { .width = 0, .height = 0}}},
};

struct upd61151_state {
	struct v4l2_subdev            sd;
//	struct spi_board_info         info;
	int 			      chip;
	u32 			      revision;
	struct upd61151_mpeg_params   params;
	enum upd61151_videoformat     video_format;
	v4l2_std_id                   standard;
};

enum upd61151_command {
	UPD61151_COMMAND_RESET = 0,
	UPD61151_COMMAND_STOP = 1,
	UPD61151_COMMAND_START = 2,
	UPD61151_COMMAND_PAUSE = 3,
	UPD61151_COMMAND_RECONFIGURE = 4,
	UPD61151_COMMAND_SLEEP = 5,
	UPD61151_COMMAND_RECONFIGURE_FORCE = 6,

	UPD61151_COMMAND_MAX
};


#if 0
static int write_reg( ??struct device *dev??, int address, unsigned char data)
{
	struct spi_device *spi = to_spi_device(dev);
	unsigned char buf[2];

	buf[0] = address & 0x7f;
	buf[1] = data;

	return spi_write(spi, buf, ARRAY_SIZE(buf));
}

static int read_regs( ??struct device *dev??, unsigned char *regs, int no_regs)
{
	struct spi_device *spi = to_spi_device(dev);
	u8 txbuf[1], rxbuf[1];
	int k, ret;

	ret = 0;

	for (k = 0; ret == 0 && k < no_regs; k++) {
		txbuf[0] = 0x80 | regs[k];
		ret = spi_write_then_read(spi, txbuf, 1, rxbuf, 1);
		regs[k] = rxbuf[0];
	}

	return ret;
}
#endif

static struct upd61151_mpeg_params param_defaults =
{
	.ts_pid_pmt      = 16,
	.ts_pid_video    = 260,
	.ts_pid_audio    = 256,
	.ts_pid_pcr      = 259,

	.vi_aspect       = V4L2_MPEG_VIDEO_ASPECT_4x3,
	.vi_bitrate      = 4000,
	.vi_bitrate_peak = 6000,
	.vi_bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,

	.au_encoding     = V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
	.au_l2_bitrate   = V4L2_MPEG_AUDIO_L2_BITRATE_256K,
};

#if 0
static int upd61151_chip_command(struct spi_device *spi,
				  enum upd61151_command command)
{
printk("DEBUG uPD61151: upd61151_chip_command\n");
	return 0;
}

static int upd61151_set_bitrate(struct spi_device *spi,
				 struct upd61151_state *h)
{
printk("DEBUG uPD61151: upd61151_set_bitrate\n");
	return 0;
}
#endif

static int upd61151_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
{
printk("DEBUG uPD61151: upd61151_queryctrl\n");
	return 0;
}

static int upd61151_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qmenu)
{
printk("DEBUG uPD61151: upd61151_querymenu\n");
	return 0;
}

static int upd61151_init(struct v4l2_subdev *sd, u32 flags)
{
printk("DEBUG uPD61151: upd61151_init\n");
	return 0;
}

static int upd61151_do_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls, int set)
{
printk("DEBUG uPD61151: upd61151_do_ext_ctrls\n");
	return 0;
}

static int upd61151_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_s_ext_ctrls\n");
	return upd61151_do_ext_ctrls(sd, ctrls, 1);
}

static int upd61151_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_s_ext_ctrls\n");
	return upd61151_do_ext_ctrls(sd, ctrls, 0);
}

static int upd61151_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_g_ext_ctrls\n");
	return 0;
}

static int upd61151_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
{
printk("DEBUG uPD61151: upd61151_g_fmt\n");
	return 0;
}

static int upd61151_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
{
printk("DEBUG uPD61151: upd61151_s_fmt\n");
	return 0;
}

static int upd61151_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
{
printk("DEBUG uPD61151: upd61151_s_std\n");
	return 0;
}

static int upd61151_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
{
printk("DEBUG uPD61151: upd61151_g_chip_ident\n");
	return 0;
}

/* ----------------------------------------------------------------------- */

static const struct v4l2_subdev_core_ops upd61151_core_ops = {
	.g_chip_ident = upd61151_g_chip_ident,
	.init = upd61151_init,
	.queryctrl = upd61151_queryctrl,
	.querymenu = upd61151_querymenu,
	.g_ext_ctrls = upd61151_g_ext_ctrls,
	.s_ext_ctrls = upd61151_s_ext_ctrls,
	.try_ext_ctrls = upd61151_try_ext_ctrls,
	.s_std = upd61151_s_std,
};

static const struct v4l2_subdev_video_ops upd61151_video_ops = {
	.s_fmt = upd61151_s_fmt,
	.g_fmt = upd61151_g_fmt,
};

static const struct v4l2_subdev_ops upd61151_ops = {
	.core = &upd61151_core_ops,
	.video = &upd61151_video_ops,
};

static int __devinit upd61151_probe(struct spi_device *spi)
{
	struct upd61151_state *h = kzalloc(sizeof(*h), GFP_KERNEL);
	struct v4l2_subdev *sd;
	u8 tx_buf_r[2];
	u8 tx_buf_w[2];
	u8 rx_buf[2];
	int status;

printk("upd61151_probe function\n");

printk("Read test REG 0xD8 :\n");
	tx_buf_r[0] = ((0xD8 >> 2) << 2) | 0x02;

	status = spi_write_then_read(spi, tx_buf_r, 1, rx_buf, 1);
	if (status < 0) {
		printk("spi_write_then_read failed with status %d\n",
				status);
//		goto out;
	}

printk("REG = 0x%X\n",rx_buf[0]);

printk("Write test 0x03 to REG 0xD8 :\n");

	tx_buf_w[0] = ((0xD8 >> 2) << 2);
	tx_buf_w[1] = 0x03;
	spi_write(spi, tx_buf_w, 2);

printk("Next read test REG 0xD8 :\n");

	status = spi_write_then_read(spi, tx_buf_r, 1, rx_buf, 1);
	if (status < 0) {
		printk("spi_write_then_read failed with status %d\n",
				status);
//		goto out;
	}

printk("REG = 0x%X\n",rx_buf[0]);

	if (h == NULL)
		return -ENOMEM;
	sd = &h->sd;
//	v4l2_spi_subdev_init(sd, spi, &upd61151_ops);

	spi_set_drvdata(spi, h);

/* function for detect a chip here */
//	h->chip = upd61151_detect(h);

	h->params = param_defaults;
	h->standard = 0; /* Assume 625 input lines */
	return 0;
}

static int __devexit upd61151_remove(struct spi_device *spi)
{
	struct upd61151_state *h = spi_get_drvdata(spi);
printk("upd61151_remove function\n");
	v4l2_device_unregister_subdev(&h->sd);
	kfree(&h->sd);
	spi_unregister_device(spi);
	return 0;
}

#if 0
static const struct spi_device_id upd61151_ids[] = {
	{ "upd61151", 1 },
	{ "upd61152", 2 },
	{ },
};
MODULE_DEVICE_TABLE(spi, upd61151_ids);
#endif

static struct spi_driver upd61151_driver = {
	.driver = {
		.name   = DRVNAME,
		.bus    = &spi_bus_type,
		.owner  = THIS_MODULE,
	},
//	.id_table = upd61151_ids,
	.probe = upd61151_probe,
	.remove = __devexit_p(upd61151_remove),
};


static int __init init_upd61151(void)
{
	return spi_register_driver(&upd61151_driver);
}
module_init(init_upd61151);

static void __exit exit_upd61151(void)
{
	spi_unregister_driver(&upd61151_driver);
}
module_exit(exit_upd61151);

/*
 * Overrides for Emacs so that we follow Linus's tabbing style.
 * ---------------------------------------------------------------------------
 * Local variables:
 * c-basic-offset: 8
 * End:
 */

--MP_/ckG7z_s72hy+8MgR_b5qyfE
Content-Type: text/x-chdr; name=upd61151.h
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=upd61151.h

/*
    upd61151.h - definition for muPD61151 MPEG encoder

    Copyright (C) Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#if 0 /* ndef _UPD61151_H */
#define _UPD61151_H

#include <linux/firmware.h>

#define MUPD61151_DEFAULT_PS_FIRMWARE "D61151_PS_64_byte_7133_v22_031031.bin"
#define MUPD61151_DEFAULT_PS_FIRMWARE_SIZE 97002

#define MUPD61151_DEFAULT_AUDIO_FIRMWARE "audrey_MPE_V1r51.bin"
#define MUPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE 40064

enum mpeg_video_bitrate_mode {
	MPEG_VIDEO_BITRATE_MODE_VBR = 0, /* Variable bitrate */
	MPEG_VIDEO_BITRATE_MODE_CBR = 1, /* Constant bitrate */

	MPEG_VIDEO_BITRATE_MODE_MAX
};

enum mpeg_audio_bitrate {
	MPEG_AUDIO_BITRATE_256 = 0, /* 256 kBit/sec */
	MPEG_AUDIO_BITRATE_384 = 1, /* 384 kBit/sec */

	MPEG_AUDIO_BITRATE_MAX
};

enum mpeg_video_format {
	MPEG_VIDEO_FORMAT_D1 = 0,
	MPEG_VIDEO_FORMAT_2_3_D1 = 1,
	MPEG_VIDEO_FORMAT_1_2_D1 = 2,
	MPEG_VIDEO_FORMAT_SIF = 3,

	MPEG_VIDEO_FORMAT_MAX
};

#define MPEG_VIDEO_TARGET_BITRATE_MAX 27000
#define MPEG_VIDEO_MAX_BITRATE_MAX 27000
#define MPEG_TOTAL_BITRATE_MAX 27000
#define MPEG_PID_MAX ((1 << 14) - 1)

struct mpeg_params {
	enum mpeg_video_bitrate_mode video_bitrate_mode;
	unsigned int video_target_bitrate;
	unsigned int video_max_bitrate; // only used for VBR
	enum mpeg_audio_bitrate audio_bitrate;
	unsigned int total_bitrate;

	unsigned int pmt_pid;
	unsigned int video_pid;
	unsigned int audio_pid;
	unsigned int pcr_pid;

	enum mpeg_video_format video_format;
};

#endif // _UPD61151_H

/*
 * Local variables:
 * c-basic-offset: 8
 * End:
 */

--MP_/ckG7z_s72hy+8MgR_b5qyfE--
