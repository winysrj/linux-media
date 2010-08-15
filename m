Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61271 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0HOFU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Aug 2010 01:20:26 -0400
Received: by wwj40 with SMTP id 40so4902396wwj.1
        for <linux-media@vger.kernel.org>; Sat, 14 Aug 2010 22:20:16 -0700 (PDT)
Message-ID: <4C67790D.3060600@gmail.com>
Date: Sun, 15 Aug 2010 07:20:13 +0200
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: patch for lifeview hybrid mini
Content-Type: multipart/mixed;
 boundary="------------030603070407060105060604"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This is a multi-part message in MIME format.
--------------030603070407060105060604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

the proposed patch is 6 month old and the owner of the card does not 
give any more sign of life for the support of the radio.
can someone review it and push it as is?

Cheers,

Signed-off-by: thomas genty<tomlohave@gmail.com>




--------------030603070407060105060604
Content-Type: text/x-patch;
 name="medion.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="medion.patch"

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 07f6bb8..d246e15 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5462,6 +5462,37 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_FLYDVBTDUO_MEDION] = {
+		/* Thomas Genty <tomlohave@gmail.com> */
+		.name           = "LifeView FlyDVB-T DUO Mini",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.gpiomask	= 0x00600000,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.gpio = 0x200000,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+			.gpio = 0x200000,	/* No tested */
+		},
+	},
 
 };
 
@@ -6631,6 +6662,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0x6655,
 		.driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5168,         
+		.subdevice    = 0x0307,  /* Lifeview flydvb-t hybrid mini, LR307-N */       
+		.driver_data  = SAA7134_BOARD_FLYDVBTDUO_MEDION,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7383,6 +7420,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 	case SAA7134_BOARD_CREATIX_CTX953:
+	case SAA7134_BOARD_FLYDVBTDUO_MEDION:
 	{
 		/* this is a hybrid board, initialize to analog mode
 		 * and configure firmware eeprom address
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 31e82be..2a2e3d8 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -824,6 +824,19 @@ static struct tda1004x_config asus_tiger_3in1_config = {
 	.request_firmware = philips_tda1004x_request_firmware
 };
 
+static struct tda1004x_config tda827x_flydvbtduo_medion_config = {
+	.demod_address = 0x08,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_16M,
+	.agc_config    = TDA10046_AGC_TDA827X,
+	.gpio_config   = TDA10046_GP01_I,
+	.if_freq       = TDA10046_FREQ_045,
+	.i2c_gate      = 0x4b,
+	.tuner_address = 0x61,
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
 /* ------------------------------------------------------------------
  * special case: this card uses saa713x GPIO22 for the mode switch
  */
@@ -1590,6 +1603,22 @@ static int dvb_init(struct saa7134_dev *dev)
 				   &dtv1000s_tda18271_config);
 		}
 		break;
+	case SAA7134_BOARD_FLYDVBTDUO_MEDION:
+		/* this card uses saa713x GPIO22 for the mode switch */
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
+					       &tda827x_flydvbtduo_medion_config,
+					       &dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			if (dvb_attach(tda827x_attach,fe0->dvb.frontend,
+				   tda827x_flydvbtduo_medion_config.tuner_address, &dev->i2c_adap,
+								&ads_duo_cfg) == NULL) {
+				wprintk("no tda827x tuner found at addr: %02x\n",
+					tda827x_flydvbtduo_medion_config.tuner_address);
+				goto dettach_frontend;
+			}
+		} else
+			wprintk("failed to attach tda10046\n");
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 756a1ca..c1f213c 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -304,6 +304,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_H7             178
 #define SAA7134_BOARD_BEHOLD_A7             179
 #define SAA7134_BOARD_AVERMEDIA_M733A       180
+#define SAA7134_BOARD_FLYDVBTDUO_MEDION     181
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--------------030603070407060105060604--
