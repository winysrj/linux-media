Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail08.syd.optusnet.com.au ([211.29.132.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <russell@kliese.wattle.id.au>) id 1JQ1ep-00020H-Io
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 15:35:20 +0100
Received: from [192.168.0.4] (c220-239-70-96.rochd3.qld.optusnet.com.au
	[220.239.70.96]) (authenticated sender russell.kliese)
	by mail08.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m1FEZ5E2000744
	for <linux-dvb@linuxtv.org>; Sat, 16 Feb 2008 01:35:10 +1100
Message-ID: <47B5A504.9080400@kliese.wattle.id.au>
Date: Sat, 16 Feb 2008 00:43:16 +1000
From: Russell Kliese <russell@kliese.wattle.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------020103080407030709060403"
Subject: [linux-dvb] MSI TV@nywhere A/D v1.1 patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------020103080407030709060403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've created a patch to support the MSI TV@nywhere A/D v1.1 card. This 
card previously had firmware upload issues when using card=109. With 
this patch, it's auto-detected and I haven't experienced any firmware 
upload problems (although my testing hasn't been exhaustive, but I have 
tried a couple of cold boots).

I've tested both analog and digital TV. I haven't yet tested S-Video or 
composite inputs, so these might need to be tweaked.

It would be great if this patch could be merged into the main 
repository. If there are any special requirements to allow this to be 
done, please let me know.

Cheers,

Russell Kliese



--------------020103080407030709060403
Content-Type: text/x-patch;
 name="v4l-dvb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v4l-dvb.diff"

diff -r 20bb80659549 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Mon Feb 11 21:08:12 2008 +0000
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Sat Feb 16 00:40:50 2008 +1000
@@ -131,3 +131,4 @@ 130 -> Beholder BeholdTV M6 / BeholdTV M
 130 -> Beholder BeholdTV M6 / BeholdTV M6 Extra [5ace:6190,5ace:6193]
 131 -> Twinhan Hybrid DTV-DVB 3056 PCI          [1822:0022]
 132 -> Genius TVGO AM11MCE
+133 -> MSI TV@nywhere A/D v1.1                  [1462:8625]
diff -r 20bb80659549 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Feb 11 21:08:12 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Feb 16 00:06:18 2008 +1000
@@ -4030,6 +4030,36 @@ struct saa7134_board saa7134_boards[] = 
 			.gpio = 0x6000,
 		},
 	},
+	[SAA7134_BOARD_MSI_TVANYWHERE_AD11] = {
+		.name           = "MSI TV@nywhere A/D v1.1",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tuner_config   = 2,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x0200000,
+		.inputs = {{
+			.name   = name_tv,
+			.vmux   = 1,
+			.amux   = TV,
+			.tv     = 1,
+		},{
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE1,
+		},{
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE1,
+		}},
+		.radio = {
+			.name   = name_radio,
+			.amux   = TV,
+			.gpio   = 0x0200000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -4980,6 +5010,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subvendor    = 0x1822, /*Twinhan Technology Co. Ltd*/
 		.subdevice    = 0x0022,
 		.driver_data  = SAA7134_BOARD_TWINHAN_DTV_DVB_3056,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1462, /* MSI */
+		.subdevice    = 0x8625, /* TV@nywhere A/D v1.1 */
+		.driver_data  = SAA7134_BOARD_MSI_TVANYWHERE_AD11,
 	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -5477,6 +5513,16 @@ int saa7134_board_init2(struct saa7134_d
 			break;
 		}
 		break;
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
+		{
+		tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
+		tun_setup.type = TUNER_PHILIPS_TDA8290;
+		tun_setup.addr = 0x4b;
+		tun_setup.config = 2;
+
+		saa7134_i2c_call_clients (dev, TUNER_SET_TYPE_ADDR,&tun_setup);
+		}
+		break;
 	}
 	return 0;
 }
diff -r 20bb80659549 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Feb 11 21:08:12 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Feb 15 19:32:26 2008 +1000
@@ -794,6 +794,21 @@ static struct tda1004x_config twinhan_dt
 	.request_firmware = philips_tda1004x_request_firmware
 };
 
+static struct tda1004x_config msi_tvanywhere_ad11_config = {
+	.demod_address = 0x08,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_16M,
+	.agc_config    = TDA10046_AGC_TDA827X,
+	.gpio_config   = TDA10046_GP01_I,
+	.if_freq       = TDA10046_FREQ_045,
+	.i2c_gate      = 0x4b,
+	.tuner_address = 0x61,
+	.tuner_config  = 2,
+	.antenna_switch= 1,
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
 /* ------------------------------------------------------------------
  * special case: this card uses saa713x GPIO22 for the mode switch
  */
@@ -1064,6 +1079,9 @@ static int dvb_init(struct saa7134_dev *
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 		configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config);
 		break;
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
+		configure_tda827x_fe(dev, &msi_tvanywhere_ad11_config);
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r 20bb80659549 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Feb 11 21:08:12 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Feb 13 21:42:57 2008 +1000
@@ -261,6 +261,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
 #define SAA7134_BOARD_GENIUS_TVGO_A11MCE 132
+#define SAA7134_BOARD_MSI_TVANYWHERE_AD11  133
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--------------020103080407030709060403
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020103080407030709060403--
