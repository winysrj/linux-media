Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54962 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1KRRtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Nov 2011 12:49:05 -0500
Received: by fagn18 with SMTP id n18so4591680fag.19
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2011 09:49:02 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 18 Nov 2011 12:49:02 -0500
Message-ID: <CABUBpLc1kjz-zZzo4abWjyHc9U-V1Lgjr9S5VCTNnQnsSmmNng@mail.gmail.com>
Subject: Mygica U6012B support
From: M Eaton <tv@divinehawk.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently purchased a Mygica U6012B hybrid ATSC usb tuner, and made
an attempt at adding support.

It has the following chips (by visual inspection):
CX23102
CX24227
TDA18271

I based the GPIO and memory address on the inf file that came with the
tuner: http://sites.google.com/a/divinehawk.com/tv/home/GTATSC.inf

Here is the patch and the logs from inserting and scanning. I am
unable to pick up anything on my scans - what is my next step? Any
help appreciated!

diff -ur linux/drivers/media/video/cx231xx/cx231xx-avcore.c
newlinux/drivers/media/video/cx231xx/cx231xx-avcore.c
--- linux/drivers/media/video/cx231xx/cx231xx-avcore.c	2011-06-21
23:45:32.000000000 -0400
+++ newlinux/drivers/media/video/cx231xx/cx231xx-avcore.c	2011-11-18
08:23:27.595967953 -0500
@@ -352,6 +352,7 @@
 	case CX231XX_BOARD_CNXT_RDE_253S:
 	case CX231XX_BOARD_CNXT_RDU_253S:
 	case CX231XX_BOARD_CNXT_VIDEO_GRABBER:
+	case CX231XX_BOARD_GTECH_U6012B:
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 	case CX231XX_BOARD_HAUPPAUGE_USBLIVE2:
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
@@ -1730,6 +1731,7 @@
 	case CX231XX_BOARD_CNXT_SHELBY:
 	case CX231XX_BOARD_CNXT_RDU_250:
 	case CX231XX_BOARD_CNXT_VIDEO_GRABBER:
+	case CX231XX_BOARD_GTECH_U6012B:
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 		func_mode = 0x03;
 		break;
diff -ur linux/drivers/media/video/cx231xx/cx231xx-cards.c
newlinux/drivers/media/video/cx231xx/cx231xx-cards.c
--- linux/drivers/media/video/cx231xx/cx231xx-cards.c	2011-07-27
23:45:49.000000000 -0400
+++ newlinux/drivers/media/video/cx231xx/cx231xx-cards.c	2011-11-18
08:26:04.480745912 -0500
@@ -336,6 +336,45 @@
 			}
 		},
 	},
+	[CX231XX_BOARD_GTECH_U6012B] = {
+		.name = "GeniaTech/Mygica U6012B",
+		.tuner_type = TUNER_NXP_TDA18271,
+		.tuner_addr = 0x60,
+		.tuner_gpio = RDE250_XCV_TUNER,
+		.tuner_sif_gpio = 0x05,
+		.tuner_scl_gpio = 0x1a,
+		.tuner_sda_gpio = 0x1b,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.demod_xfer_mode = 0,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0x1c,
+		.gpio_pin_status_mask = 0x4001000,
+		.tuner_i2c_master = 1,
+		.demod_i2c_master = 2,
+		.has_dvb = 1,
+		.demod_addr = 0x19,
+		.norm = V4L2_STD_NTSC,
+
+		.input = {{
+			.type = CX231XX_VMUX_TELEVISION,
+			.vmux = CX231XX_VIN_3_1,
+			.amux = CX231XX_AMUX_VIDEO,
+			.gpio = NULL,
+		}, {
+			.type = CX231XX_VMUX_COMPOSITE1,
+			.vmux = CX231XX_VIN_2_1,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		}, {
+			.type = CX231XX_VMUX_SVIDEO,
+			.vmux = CX231XX_VIN_1_1 |
+				(CX231XX_VIN_1_2 << 8) |
+				CX25840_SVIDEO_ON,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		} },
+	},
 	[CX231XX_BOARD_HAUPPAUGE_EXETER] = {
 		.name = "Hauppauge EXETER",
 		.tuner_type = TUNER_NXP_TDA18271,
@@ -624,6 +663,8 @@
 	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
 	{USB_DEVICE(0x0572, 0x58A0),
 	 .driver_info = CX231XX_BOARD_CNXT_RDU_250},
+	{USB_DEVICE(0x1F4D, 0x6011),
+	 .driver_info = CX231XX_BOARD_GTECH_U6012B},
 	{USB_DEVICE(0x2040, 0xb110),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL},
 	{USB_DEVICE(0x2040, 0xb111),
diff -ur linux/drivers/media/video/cx231xx/cx231xx-core.c
newlinux/drivers/media/video/cx231xx/cx231xx-core.c
--- linux/drivers/media/video/cx231xx/cx231xx-core.c	2011-06-21
23:45:32.000000000 -0400
+++ newlinux/drivers/media/video/cx231xx/cx231xx-core.c	2011-11-18
08:23:27.599967977 -0500
@@ -720,6 +720,7 @@
 			break;
 		case CX231XX_BOARD_CNXT_RDE_253S:
 		case CX231XX_BOARD_CNXT_RDU_253S:
+		case CX231XX_BOARD_GTECH_U6012B:
 			errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 1);
 			break;
 		case CX231XX_BOARD_HAUPPAUGE_EXETER:
@@ -740,6 +741,7 @@
 			break;
 		case CX231XX_BOARD_CNXT_RDE_253S:
 		case CX231XX_BOARD_CNXT_RDU_253S:
+		case CX231XX_BOARD_GTECH_U6012B:
 		case CX231XX_BOARD_HAUPPAUGE_EXETER:
 		case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 		case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
@@ -1381,6 +1383,7 @@
 		break;
 	case CX231XX_BOARD_CNXT_RDE_253S:
 	case CX231XX_BOARD_CNXT_RDU_253S:
+	case CX231XX_BOARD_GTECH_U6012B:
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
diff -ur linux/drivers/media/video/cx231xx/cx231xx-dvb.c
newlinux/drivers/media/video/cx231xx/cx231xx-dvb.c
--- linux/drivers/media/video/cx231xx/cx231xx-dvb.c	2011-05-02
23:45:27.000000000 -0400
+++ newlinux/drivers/media/video/cx231xx/cx231xx-dvb.c	2011-11-18
08:23:27.599967977 -0500
@@ -30,6 +30,7 @@
 #include "xc5000.h"
 #include "s5h1432.h"
 #include "tda18271.h"
+#include "s5h1409.h"
 #include "s5h1411.h"
 #include "lgdt3305.h"
 #include "mb86a20s.h"
@@ -98,6 +99,16 @@
 	.gate    = TDA18271_GATE_ANALOG,
 };

+static struct s5h1409_config tda18271_s5h1409_config = {
+	.demod_address  = 0x32 >> 1,
+	.output_mode   = S5H1409_SERIAL_OUTPUT,
+	.gpio          = S5H1409_GPIO_OFF,
+	.qam_if        = 4000,
+	.inversion     = S5H1409_INVERSION_ON,
+	.status_mode   = S5H1409_DEMODLOCKING,
+	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+};
+
 static struct s5h1411_config tda18271_s5h1411_config = {
 	.output_mode   = S5H1411_SERIAL_OUTPUT,
 	.gpio          = S5H1411_GPIO_OFF,
@@ -668,6 +679,29 @@
 			result = -EINVAL;
 			goto out_free;
 		}
+
+		/* define general-purpose callback pointer */
+		dvb->frontend->callback = cx231xx_tuner_callback;
+
+		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
+			       0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       &cnxt_rde253s_tunerconfig)) {
+			result = -EINVAL;
+			goto out_free;
+		}
+		break;
+	case CX231XX_BOARD_GTECH_U6012B:
+
+		dev->dvb->frontend = dvb_attach(s5h1409_attach,
+					       &tda18271_s5h1409_config,
+					       &dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+
+		if (dev->dvb->frontend == NULL) {
+			printk(DRIVER_NAME
+			       ": Failed to attach s5h1409 front end\n");
+			result = -EINVAL;
+			goto out_free;
+		}

 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;
diff -ur linux/drivers/media/video/cx231xx/cx231xx.h
newlinux/drivers/media/video/cx231xx/cx231xx.h
--- linux/drivers/media/video/cx231xx/cx231xx.h	2011-07-27
23:45:49.000000000 -0400
+++ newlinux/drivers/media/video/cx231xx/cx231xx.h	2011-11-18
08:27:09.761069603 -0500
@@ -69,6 +69,7 @@
 #define CX231XX_BOARD_ICONBIT_U100 13
 #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL 14
 #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC 15
+#define CX231XX_BOARD_GTECH_U6012B 16

 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4

kernel: [  470.080206] usb 2-2: new high speed USB device number 3
using ehci_hcd
kernel: [  470.644867] cx231xx v4l2 driver loaded.
kernel: [  470.644926] cx231xx #0: New device Geniatech ATSC Hybrid TV
Device @ 480 Mbps (1f4d:6011) with 6 interfaces
kernel: [  470.644930] cx231xx #0: registering interface 1
kernel: [  470.645923] cx231xx #0: Identified as GeniaTech/Mygica
U6012B (card=16)
kernel: [  470.853486] cx231xx #0: cx231xx_dif_set_standard:
setStandard to ffffffff
kernel: [  470.879606] cx25840 0-0044: cx23102 A/V decoder found @
0x88 (cx231xx #0)
kernel: [  470.897637] cx25840 0-0044:  Firmware download size changed
to 16 bytes max length
kernel: [  473.007114] cx25840 0-0044: loaded v4l-cx231xx-avcore-01.fw
firmware (16382 bytes)
kernel: [  473.043973] i2c-core: driver [tuner] using legacy suspend method
kernel: [  473.043981] i2c-core: driver [tuner] using legacy resume method
kernel: [  473.111475] Chip ID is not zero. It is not a TEA5767
kernel: [  473.111484] tuner 1-0060: Tuner -1 found with type(s) Radio TV.
kernel: [  473.125416] tda18271 1-0060: creating new instance
kernel: [  473.127477] TDA18271HD/C2 detected @ 1-0060
kernel: [  473.372043] tda18271: performing RF tracking filter calibration
kernel: [  475.067859] tda18271: RF tracking filter calibration complete
kernel: [  475.105635] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.2
kernel: [  475.121736] cx231xx #0: cx231xx_dif_set_standard: setStandard to b000
kernel: [  475.194490] cx231xx #0: video_mux : 0
kernel: [  475.194494] cx231xx #0: do_mode_ctrl_overrides : 0xb000
kernel: [  475.195235] cx231xx #0: do_mode_ctrl_overrides NTSC
kernel: [  475.202158] cx231xx #0: cx231xx #0/0: registered device video1 [v4l2]
kernel: [  475.202234] cx231xx #0: cx231xx #0/0: registered device vbi0
kernel: [  475.202241] cx231xx #0: V4L2 device registered as video1 and vbi0
kernel: [  475.202249] cx231xx #0: EndPoint Addr 0x84, Alternate settings: 5
kernel: [  475.202255] cx231xx #0: Alternate setting 0, max size= 512
kernel: [  475.202260] cx231xx #0: Alternate setting 1, max size= 184
kernel: [  475.202265] cx231xx #0: Alternate setting 2, max size= 728
kernel: [  475.202270] cx231xx #0: Alternate setting 3, max size= 2892
kernel: [  475.202276] cx231xx #0: Alternate setting 4, max size= 1800
kernel: [  475.202281] cx231xx #0: EndPoint Addr 0x85, Alternate settings: 2
kernel: [  475.202288] cx231xx #0: Alternate setting 0, max size= 512
kernel: [  475.202293] cx231xx #0: Alternate setting 1, max size= 512
kernel: [  475.202299] cx231xx #0: EndPoint Addr 0x86, Alternate settings: 2
kernel: [  475.202306] cx231xx #0: Alternate setting 0, max size= 512
kernel: [  475.202311] cx231xx #0: Alternate setting 1, max size= 576
kernel: [  475.202316] cx231xx #0: EndPoint Addr 0x81, Alternate settings: 6
kernel: [  475.202321] cx231xx #0: Alternate setting 0, max size= 512
kernel: [  475.202326] cx231xx #0: Alternate setting 1, max size= 64
kernel: [  475.202331] cx231xx #0: Alternate setting 2, max size= 128
kernel: [  475.202336] cx231xx #0: Alternate setting 3, max size= 316
kernel: [  475.202341] cx231xx #0: Alternate setting 4, max size= 712
kernel: [  475.202347] cx231xx #0: Alternate setting 5, max size= 1424
kernel: [  475.202458] usbcore: registered new interface driver cx231xx
kernel: [  475.220771] cx231xx #0: cx231xx-audio.c: probing for
cx231xx non standard usbaudio
kernel: [  475.221111] cx231xx #0: EndPoint Addr 0x83, Alternate settings: 3
kernel: [  475.221118] cx231xx #0: Alternate setting 0, max size= 512
kernel: [  475.221124] cx231xx #0: Alternate setting 1, max size= 28
kernel: [  475.221129] cx231xx #0: Alternate setting 2, max size= 52
kernel: [  475.221134] cx231xx: Cx231xx Audio Extension initialized
kernel: [  475.259853] cx231xx #0:  setPowerMode::mode = 32, No Change req.
kernel: [  475.265604] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
kernel: [  475.266390] cx231xx #0: cx231xxcx231xx: called
cx231xx_uninit_vbi_isoc
kernel: [  475.266392] cx231xx #0: cx231xx_stop_stream():: ep_mask = 10
kernel: [  475.275043] WARNING: You are using an experimental version
of the media stack.
kernel, it doesn't offer
kernel: [  475.275046] 	enough quality for its usage in production.
kernel: [  475.275046] 	Use it with care.
kernel: [  475.275047] Latest git patches (needed if you report a bug
to linux-media@vger.kernel.org):
kernel: [  475.275048] 	e9eb0dadba932940f721f9d27544a7818b2fa1c5
[media] V4L menu: add submenu for platform devices
kernel: [  475.275049] 	1df3a2c6d036f4923c229fa98725deda320680e1
[media] cx88: fix menu level for the VP-3054 module
kernel: [  475.275050] 	486eeb5628f812b4836405e2b2e76594287dd873
[media] V4L menu: move all PCI(e) devices to their own submenu
kernel: [  475.398103] tda18271 1-0060: attaching existing instance
kernel: [  475.398115] DVB: registering new adapter (cx231xx #0)
kernel: [  475.398124] DVB: registering adapter 0 frontend 0 (Samsung
S5H1409 QAM/8VSB Frontend)...
kernel: [  475.399130] Successfully loaded cx231xx-dvb
kernel: [  475.399364] cx231xx: Cx231xx dvb Extension initialized
kernel: [  475.404892] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
kernel: [  475.405319] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
kernel: [  475.407641] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
kernel: [  475.408138] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
kernel: [  475.410932] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
kernel: [  475.411408] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
kernel: [  475.416257] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
kernel: [  475.416893] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
kernel: [  475.418995] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
kernel: [  475.421651] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
kernel: [  475.425493] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
kernel: [  475.437819] cx231xx #0: cx231xx_init_audio_isoc: Starting
ISO AUDIO transfers
kernel: [  480.452502] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
