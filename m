Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47934 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab1D1POb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 11:14:31 -0400
Subject: [PATCH 05/10] rc-core: add separate defines for protocol bitmaps and
	numbers
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@redhat.com
Date: Thu, 28 Apr 2011 17:13:37 +0200
Message-ID: <20110428151337.8272.78812.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The RC_TYPE_* defines are currently used both where a single protocol is
expected and where a bitmap of protocols is expected. This patch tries
to separate the two in preparation for the following patches.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/dvb-usb/af9015.c                 |   12 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    2 
 drivers/media/dvb/dvb-usb/dib0700_core.c           |    8 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  116 ++++++++++----------
 drivers/media/dvb/dvb-usb/technisat-usb2.c         |    2 
 drivers/media/dvb/dvb-usb/ttusb2.c                 |    2 
 drivers/media/dvb/mantis/mantis_input.c            |    2 
 drivers/media/dvb/siano/smsir.c                    |    2 
 drivers/media/rc/ene_ir.c                          |    2 
 drivers/media/rc/imon.c                            |   26 ++--
 drivers/media/rc/ir-jvc-decoder.c                  |    4 -
 drivers/media/rc/ir-lirc-codec.c                   |    4 -
 drivers/media/rc/ir-nec-decoder.c                  |    4 -
 drivers/media/rc/ir-rc5-decoder.c                  |   12 ++
 drivers/media/rc/ir-rc5-sz-decoder.c               |    4 -
 drivers/media/rc/ir-rc6-decoder.c                  |    4 -
 drivers/media/rc/ir-sony-decoder.c                 |   17 +++
 drivers/media/rc/ite-cir.c                         |    2 
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |    2 
 drivers/media/rc/keymaps/rc-alink-dtu-m.c          |    2 
 drivers/media/rc/keymaps/rc-anysee.c               |    2 
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |    2 
 drivers/media/rc/keymaps/rc-asus-pc39.c            |    2 
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |    2 
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |    2 
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |    2 
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |    2 
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |    2 
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |    2 
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |    2 
 drivers/media/rc/keymaps/rc-avermedia.c            |    2 
 drivers/media/rc/keymaps/rc-avertv-303.c           |    2 
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c   |    2 
 drivers/media/rc/keymaps/rc-behold-columbus.c      |    2 
 drivers/media/rc/keymaps/rc-behold.c               |    2 
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |    2 
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |    2 
 drivers/media/rc/keymaps/rc-cinergy.c              |    2 
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |    2 
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |    2 
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c  |    2 
 drivers/media/rc/keymaps/rc-digittrade.c           |    2 
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |    2 
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |    2 
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |    2 
 drivers/media/rc/keymaps/rc-em-terratec.c          |    2 
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |    2 
 drivers/media/rc/keymaps/rc-encore-enltv.c         |    2 
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |    2 
 drivers/media/rc/keymaps/rc-evga-indtube.c         |    2 
 drivers/media/rc/keymaps/rc-eztv.c                 |    2 
 drivers/media/rc/keymaps/rc-flydvb.c               |    2 
 drivers/media/rc/keymaps/rc-flyvideo.c             |    2 
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |    2 
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |    2 
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |    2 
 drivers/media/rc/keymaps/rc-gotview7135.c          |    2 
 drivers/media/rc/keymaps/rc-hauppauge.c            |    2 
 drivers/media/rc/keymaps/rc-imon-mce.c             |    2 
 drivers/media/rc/keymaps/rc-imon-pad.c             |    2 
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |    2 
 drivers/media/rc/keymaps/rc-kaiomy.c               |    2 
 drivers/media/rc/keymaps/rc-kworld-315u.c          |    2 
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |    2 
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c     |    2 
 drivers/media/rc/keymaps/rc-lirc.c                 |    2 
 drivers/media/rc/keymaps/rc-lme2510.c              |    2 
 drivers/media/rc/keymaps/rc-manli.c                |    2 
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |    2 
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |    2 
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |    2 
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |    2 
 drivers/media/rc/keymaps/rc-nebula.c               |    2 
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |    2 
 drivers/media/rc/keymaps/rc-norwood.c              |    2 
 drivers/media/rc/keymaps/rc-npgtech.c              |    2 
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |    2 
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |    2 
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |    2 
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |    2 
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |    2 
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |    2 
 drivers/media/rc/keymaps/rc-pixelview-new.c        |    2 
 drivers/media/rc/keymaps/rc-pixelview.c            |    2 
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |    2 
 drivers/media/rc/keymaps/rc-proteus-2309.c         |    2 
 drivers/media/rc/keymaps/rc-purpletv.c             |    2 
 drivers/media/rc/keymaps/rc-pv951.c                |    2 
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    2 
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |    2 
 drivers/media/rc/keymaps/rc-streamzap.c            |    2 
 drivers/media/rc/keymaps/rc-tbs-nec.c              |    2 
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |    2 
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |    2 
 drivers/media/rc/keymaps/rc-terratec-slim-2.c      |    2 
 drivers/media/rc/keymaps/rc-terratec-slim.c        |    2 
 drivers/media/rc/keymaps/rc-tevii-nec.c            |    2 
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |    2 
 drivers/media/rc/keymaps/rc-trekstor.c             |    2 
 drivers/media/rc/keymaps/rc-tt-1500.c              |    2 
 drivers/media/rc/keymaps/rc-twinhan1027.c          |    2 
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |    2 
 drivers/media/rc/keymaps/rc-videomate-s350.c       |    2 
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |    2 
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |    2 
 drivers/media/rc/keymaps/rc-winfast.c              |    2 
 drivers/media/rc/mceusb.c                          |    2 
 drivers/media/rc/nuvoton-cir.c                     |    2 
 drivers/media/rc/rc-loopback.c                     |    2 
 drivers/media/rc/rc-main.c                         |   21 ++--
 drivers/media/rc/streamzap.c                       |    2 
 drivers/media/video/cx18/cx18-i2c.c                |    2 
 drivers/media/video/cx231xx/cx231xx-input.c        |    2 
 drivers/media/video/cx23885/cx23885-input.c        |    4 -
 drivers/media/video/cx88/cx88-input.c              |    8 +
 drivers/media/video/em28xx/em28xx-input.c          |   10 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c              |    2 
 drivers/media/video/ir-kbd-i2c.c                   |   14 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    8 +
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    4 -
 drivers/media/video/saa7134/saa7134-input.c        |    2 
 drivers/staging/tm6000/tm6000-input.c              |   14 +-
 include/media/rc-map.h                             |   41 +++++--
 123 files changed, 291 insertions(+), 250 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 100ebc3..a4f4324 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1365,11 +1365,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = RC_TYPE_NEC,
+			.protocol         = RC_BIT_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
@@ -1493,11 +1493,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = RC_TYPE_NEC,
+			.protocol         = RC_BIT_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
@@ -1605,11 +1605,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = RC_TYPE_NEC,
+			.protocol         = RC_BIT_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 6b402e9..58a709a 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -476,7 +476,7 @@ static struct dvb_usb_device_properties anysee_properties = {
 
 	.rc.core = {
 		.rc_codes         = RC_MAP_ANYSEE,
-		.protocol         = RC_TYPE_OTHER,
+		.protocol         = RC_BIT_OTHER,
 		.module_name      = "anysee",
 		.rc_query         = anysee_rc_query,
 		.rc_interval      = 250,  /* windows driver uses 500ms */
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index b79af68..268c46b 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -514,11 +514,11 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
 	int new_proto, ret;
 
 	/* Set the IR mode */
-	if (rc_type == RC_TYPE_RC5)
+	if (rc_type == RC_BIT_RC5)
 		new_proto = 1;
-	else if (rc_type == RC_TYPE_NEC)
+	else if (rc_type == RC_BIT_NEC)
 		new_proto = 0;
-	else if (rc_type == RC_TYPE_RC6) {
+	else if (rc_type == RC_BIT_RC6) {
 		if (st->fw_version < 0x10200)
 			return -EINVAL;
 
@@ -597,7 +597,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		 purb->actual_length);
 
 	switch (d->props.rc.core.protocol) {
-	case RC_TYPE_NEC:
+	case RC_BIT_NEC:
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 97af266..f76003b 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -512,7 +512,7 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 
 	d->last_event = 0;
 	switch (d->props.rc.core.protocol) {
-	case RC_TYPE_NEC:
+	case RC_BIT_NEC:
 		/* NEC protocol sends repeat code as 0 0 0 FF */
 		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
 		    (key[3] == 0xff))
@@ -2887,9 +2887,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2921,9 +2921,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -2980,9 +2980,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3022,9 +3022,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3098,9 +3098,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3142,9 +3142,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3210,9 +3210,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3257,9 +3257,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3326,9 +3326,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3362,9 +3362,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3434,9 +3434,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3478,9 +3478,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3527,9 +3527,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3564,9 +3564,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3601,9 +3601,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3638,9 +3638,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3675,9 +3675,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3712,9 +3712,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3763,9 +3763,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6 |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	},
diff --git a/drivers/media/dvb/dvb-usb/technisat-usb2.c b/drivers/media/dvb/dvb-usb/technisat-usb2.c
index 08f8842..544f56c 100644
--- a/drivers/media/dvb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/dvb/dvb-usb/technisat-usb2.c
@@ -729,7 +729,7 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
 		.rc_codes    = RC_MAP_TECHNISAT_USB2,
 		.module_name = "technisat-usb2",
 		.rc_query    = technisat_usb2_rc_query,
-		.allowed_protos = RC_TYPE_ALL,
+		.allowed_protos = RC_BIT_ALL,
 		.driver_type    = RC_DRIVER_IR_RAW,
 	}
 };
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index 0d4709f..c22ef1a 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -377,7 +377,7 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
 		.rc_interval      = 150, /* Less than IR_KEYPRESS_TIMEOUT */
 		.rc_codes         = RC_MAP_TT_1500,
 		.rc_query         = tt3650_rc_query,
-		.allowed_protos   = RC_TYPE_UNKNOWN,
+		.allowed_protos   = RC_BIT_UNKNOWN,
 	},
 
 	.num_adapters = 1,
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index db6d54d..8efd971 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -99,7 +99,7 @@ static struct rc_map_list ir_mantis_map = {
 	.map = {
 		.scan = mantis_ir_table,
 		.size = ARRAY_SIZE(mantis_ir_table),
-		.rc_type = RC_TYPE_UNKNOWN,
+		.rc_type = RC_BIT_UNKNOWN,
 		.name = RC_MAP_MANTIS,
 	}
 };
diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index 37bc5c4..b8c5cad 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -88,7 +88,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	dev->priv = coredev;
 	dev->driver_type = RC_DRIVER_IR_RAW;
-	dev->allowed_protos = RC_TYPE_ALL;
+	dev->allowed_protos = RC_BIT_ALL;
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 1ac4913..569b07b 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1056,7 +1056,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		learning_mode_force = false;
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->priv = dev;
 	rdev->open = ene_open;
 	rdev->close = ene_close;
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index f714e1a..3819760 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1005,17 +1005,17 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 			 "this device does not support\n");
 
 	switch (rc_type) {
-	case RC_TYPE_RC6:
+	case RC_BIT_RC6:
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
 		ir_proto_packet[0] = 0x01;
 		break;
-	case RC_TYPE_UNKNOWN:
-	case RC_TYPE_OTHER:
+	case RC_BIT_UNKNOWN:
+	case RC_BIT_OTHER:
 		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		rc_type = RC_TYPE_OTHER;
+		rc_type = RC_BIT_OTHER;
 		break;
 	default:
 		dev_warn(dev, "Unsupported IR protocol specified, overriding "
@@ -1023,7 +1023,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		rc_type = RC_TYPE_OTHER;
+		rc_type = RC_BIT_OTHER;
 		break;
 	}
 
@@ -1305,7 +1305,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		rel_x = buf[2];
 		rel_y = buf[3];
 
-		if (ictx->rc_type == RC_TYPE_OTHER && pad_stabilize) {
+		if (ictx->rc_type == RC_BIT_OTHER && pad_stabilize) {
 			if ((buf[1] == 0) && ((rel_x != 0) || (rel_y != 0))) {
 				dir = stabilize((int)rel_x, (int)rel_y,
 						timeout, threshold);
@@ -1372,7 +1372,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		buf[0] = 0x01;
 		buf[1] = buf[4] = buf[5] = buf[6] = buf[7] = 0;
 
-		if (ictx->rc_type == RC_TYPE_OTHER && pad_stabilize) {
+		if (ictx->rc_type == RC_BIT_OTHER && pad_stabilize) {
 			dir = stabilize((int)rel_x, (int)rel_y,
 					timeout, threshold);
 			if (!dir) {
@@ -1494,7 +1494,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		kc = imon_panel_key_lookup(scancode);
 	} else {
 		scancode = be32_to_cpu(*((u32 *)buf));
-		if (ictx->rc_type == RC_TYPE_RC6) {
+		if (ictx->rc_type == RC_BIT_RC6) {
 			ktype = IMON_KEY_IMON;
 			if (buf[0] == 0x80)
 				ktype = IMON_KEY_MCE;
@@ -1708,7 +1708,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 {
 	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
 	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
-	u64 allowed_protos = RC_TYPE_OTHER;
+	u64 allowed_protos = RC_BIT_OTHER;
 
 	switch (ffdc_cfg_byte) {
 	/* iMON Knob, no display, iMON IR + vol knob */
@@ -1737,13 +1737,13 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	case 0x9e:
 		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		allowed_protos = RC_TYPE_RC6;
+		allowed_protos = RC_BIT_RC6;
 		break;
 	/* iMON LCD, MCE IR */
 	case 0x9f:
 		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_LCD;
-		allowed_protos = RC_TYPE_RC6;
+		allowed_protos = RC_BIT_RC6;
 		break;
 	default:
 		dev_info(ictx->dev, "Unknown 0xffdc device, "
@@ -1834,7 +1834,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	rdev->priv = ictx;
 	rdev->driver_type = RC_DRIVER_SCANCODE;
-	rdev->allowed_protos = RC_TYPE_OTHER | RC_TYPE_RC6; /* iMON PAD or MCE */
+	rdev->allowed_protos = RC_BIT_OTHER | RC_BIT_RC6; /* iMON PAD or MCE */
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
 
@@ -1852,7 +1852,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	imon_set_display_type(ictx);
 
-	if (ictx->rc_type == RC_TYPE_RC6)
+	if (ictx->rc_type == RC_BIT_RC6)
 		rdev->map_name = RC_MAP_IMON_MCE;
 	else
 		rdev->map_name = RC_MAP_IMON_PAD;
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 624449a..480a4a4 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -46,7 +46,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_JVC))
+	if (!(dev->raw->enabled_protocols & RC_BIT_JVC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -173,7 +173,7 @@ out:
 }
 
 static struct ir_raw_handler jvc_handler = {
-	.protocols	= RC_TYPE_JVC,
+	.protocols	= RC_BIT_JVC,
 	.decode		= ir_jvc_decode,
 };
 
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 1c5cc65..9ea93b6 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -34,7 +34,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_LIRC))
+	if (!(dev->raw->enabled_protocols & RC_BIT_LIRC))
 		return 0;
 
 	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
@@ -378,7 +378,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 }
 
 static struct ir_raw_handler lirc_handler = {
-	.protocols	= RC_TYPE_LIRC,
+	.protocols	= RC_BIT_LIRC,
 	.decode		= ir_lirc_decode,
 	.raw_register	= ir_lirc_register,
 	.raw_unregister	= ir_lirc_unregister,
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 63ee722..68fcab6 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -51,7 +51,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 address, not_address, command, not_command;
 	bool send_32bits = false;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_NEC))
+	if (!(dev->raw->enabled_protocols & RC_BIT_NEC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -200,7 +200,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 }
 
 static struct ir_raw_handler nec_handler = {
-	.protocols	= RC_TYPE_NEC,
+	.protocols	= RC_BIT_NEC,
 	.decode		= ir_nec_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index ebdba55..598fca4 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -51,7 +51,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle;
 	u32 scancode;
 
-        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5))
+        if (!(dev->raw->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
                 return 0;
 
 	if (!is_timing_event(ev)) {
@@ -126,6 +126,10 @@ again:
 
 		if (data->wanted_bits == RC5X_NBITS) {
 			/* RC5X */
+			if (!(dev->raw->enabled_protocols & RC_BIT_RC5X)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			u8 xdata, command, system;
 			xdata    = (data->bits & 0x0003F) >> 0;
 			command  = (data->bits & 0x00FC0) >> 6;
@@ -139,6 +143,10 @@ again:
 
 		} else {
 			/* RC5 */
+			if (!(dev->raw->enabled_protocols & RC_BIT_RC5)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			u8 command, system;
 			command  = (data->bits & 0x0003F) >> 0;
 			system   = (data->bits & 0x007C0) >> 6;
@@ -163,7 +171,7 @@ out:
 }
 
 static struct ir_raw_handler rc5_handler = {
-	.protocols	= RC_TYPE_RC5,
+	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X,
 	.decode		= ir_rc5_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 90aa886..ff6f66e 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -47,7 +47,7 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle, command, system;
 	u32 scancode;
 
-        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5_SZ))
+        if (!(dev->raw->enabled_protocols & RC_BIT_RC5_SZ))
                 return 0;
 
 	if (!is_timing_event(ev)) {
@@ -127,7 +127,7 @@ out:
 }
 
 static struct ir_raw_handler rc5_sz_handler = {
-	.protocols	= RC_TYPE_RC5_SZ,
+	.protocols	= RC_BIT_RC5_SZ,
 	.decode		= ir_rc5_sz_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 755dafa..73123e8 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -81,7 +81,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 toggle;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_RC6))
+	if (!(dev->raw->enabled_protocols & RC_BIT_RC6))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -255,7 +255,7 @@ out:
 }
 
 static struct ir_raw_handler rc6_handler = {
-	.protocols	= RC_TYPE_RC6,
+	.protocols	= RC_BIT_RC6,
 	.decode		= ir_rc6_decode,
 };
 
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index a92de80..dba56e5 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -44,7 +44,8 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 device, subdevice, function;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_SONY))
+	if (!(dev->raw->enabled_protocols &
+	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -122,16 +123,28 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->count) {
 		case 12:
+			if (!(dev->raw->enabled_protocols & RC_BIT_SONY12)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			device    = bitrev8((data->bits <<  3) & 0xF8);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  4) & 0xFE);
 			break;
 		case 15:
+			if (!(dev->raw->enabled_protocols & RC_BIT_SONY15)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			device    = bitrev8((data->bits >>  0) & 0xFF);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  7) & 0xFD);
 			break;
 		case 20:
+			if (!(dev->raw->enabled_protocols & RC_BIT_SONY20)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			device    = bitrev8((data->bits >>  5) & 0xF8);
 			subdevice = bitrev8((data->bits >>  0) & 0xFF);
 			function  = bitrev8((data->bits >> 12) & 0xFE);
@@ -156,7 +169,7 @@ out:
 }
 
 static struct ir_raw_handler sony_handler = {
-	.protocols	= RC_TYPE_SONY,
+	.protocols	= RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20,
 	.decode		= ir_sony_decode,
 };
 
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 9be6a83..3d13fcb 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1578,7 +1578,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* set up ir-core props */
 	rdev->priv = itdev;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->open = ite_open;
 	rdev->close = ite_close;
 	rdev->s_idle = ite_s_idle;
diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index 9a8752f..643dc7d 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -67,7 +67,7 @@ static struct rc_map_list adstech_dvb_t_pci_map = {
 	.map = {
 		.scan    = adstech_dvb_t_pci,
 		.size    = ARRAY_SIZE(adstech_dvb_t_pci),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ADSTECH_DVB_T_PCI,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-alink-dtu-m.c b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
index fe652e9..0ecb39e 100644
--- a/drivers/media/rc/keymaps/rc-alink-dtu-m.c
+++ b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
@@ -46,7 +46,7 @@ static struct rc_map_list alink_dtu_m_map = {
 	.map = {
 		.scan    = alink_dtu_m,
 		.size    = ARRAY_SIZE(alink_dtu_m),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_ALINK_DTU_M,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-anysee.c b/drivers/media/rc/keymaps/rc-anysee.c
index 884f1b5..28783e3 100644
--- a/drivers/media/rc/keymaps/rc-anysee.c
+++ b/drivers/media/rc/keymaps/rc-anysee.c
@@ -71,7 +71,7 @@ static struct rc_map_list anysee_map = {
 	.map = {
 		.scan    = anysee,
 		.size    = ARRAY_SIZE(anysee),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_ANYSEE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index 7af1882..7603de8 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -58,7 +58,7 @@ static struct rc_map_list apac_viewcomp_map = {
 	.map = {
 		.scan    = apac_viewcomp,
 		.size    = ARRAY_SIZE(apac_viewcomp),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_APAC_VIEWCOMP,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index b248115..73c7029 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -69,7 +69,7 @@ static struct rc_map_list asus_pc39_map = {
 	.map = {
 		.scan    = asus_pc39,
 		.size    = ARRAY_SIZE(asus_pc39),
-		.rc_type = RC_TYPE_RC5,
+		.rc_type = RC_BIT_RC5,
 		.name    = RC_MAP_ASUS_PC39,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index f766b24..98f62a2 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -47,7 +47,7 @@ static struct rc_map_list ati_tv_wonder_hd_600_map = {
 	.map = {
 		.scan    = ati_tv_wonder_hd_600,
 		.size    = ARRAY_SIZE(ati_tv_wonder_hd_600),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ATI_TV_WONDER_HD_600,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index ec9beee..407afc3 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -53,7 +53,7 @@ static struct rc_map_list avermedia_a16d_map = {
 	.map = {
 		.scan    = avermedia_a16d,
 		.size    = ARRAY_SIZE(avermedia_a16d),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERMEDIA_A16D,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index bdf97b7..1f56f8f 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -75,7 +75,7 @@ static struct rc_map_list avermedia_cardbus_map = {
 	.map = {
 		.scan    = avermedia_cardbus,
 		.size    = ARRAY_SIZE(avermedia_cardbus),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERMEDIA_CARDBUS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index c25809d..9e86e2e 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -56,7 +56,7 @@ static struct rc_map_list avermedia_dvbt_map = {
 	.map = {
 		.scan    = avermedia_dvbt,
 		.size    = ARRAY_SIZE(avermedia_dvbt),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERMEDIA_DVBT,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 3d2cbe4..f0dff61 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -125,7 +125,7 @@ static struct rc_map_list avermedia_m135a_map = {
 	.map = {
 		.scan    = avermedia_m135a,
 		.size    = ARRAY_SIZE(avermedia_m135a),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_AVERMEDIA_M135A,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index 8cd7f28..ddb0baa 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -73,7 +73,7 @@ static struct rc_map_list avermedia_m733a_rm_k6_map = {
 	.map = {
 		.scan    = avermedia_m733a_rm_k6,
 		.size    = ARRAY_SIZE(avermedia_m733a_rm_k6),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_AVERMEDIA_M733A_RM_K6,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
index 9d68af2..a3371b3 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -57,7 +57,7 @@ static struct rc_map_list avermedia_rm_ks_map = {
 	.map = {
 		.scan    = avermedia_rm_ks,
 		.size    = ARRAY_SIZE(avermedia_rm_ks),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_AVERMEDIA_RM_KS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index edfa715..3bc64cb 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -64,7 +64,7 @@ static struct rc_map_list avermedia_map = {
 	.map = {
 		.scan    = avermedia,
 		.size    = ARRAY_SIZE(avermedia),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERMEDIA,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index 32e9498..38e4619 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -63,7 +63,7 @@ static struct rc_map_list avertv_303_map = {
 	.map = {
 		.scan    = avertv_303,
 		.size    = ARRAY_SIZE(avertv_303),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_AVERTV_303,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
index c3f6d62..e049bde 100644
--- a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
+++ b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
@@ -80,7 +80,7 @@ static struct rc_map_list azurewave_ad_tu700_map = {
 	.map = {
 		.scan    = azurewave_ad_tu700,
 		.size    = ARRAY_SIZE(azurewave_ad_tu700),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_AZUREWAVE_AD_TU700,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 8bf058f..71cc1b4 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -86,7 +86,7 @@ static struct rc_map_list behold_columbus_map = {
 	.map = {
 		.scan    = behold_columbus,
 		.size    = ARRAY_SIZE(behold_columbus),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_BEHOLD_COLUMBUS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index c909a23..093b31b 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -119,7 +119,7 @@ static struct rc_map_list behold_map = {
 	.map = {
 		.scan    = behold,
 		.size    = ARRAY_SIZE(behold),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_BEHOLD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index 2f66e43..afd479e 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -71,7 +71,7 @@ static struct rc_map_list budget_ci_old_map = {
 	.map = {
 		.scan    = budget_ci_old,
 		.size    = ARRAY_SIZE(budget_ci_old),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_BUDGET_CI_OLD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index 284534b..91cef8e 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -62,7 +62,7 @@ static struct rc_map_list cinergy_1400_map = {
 	.map = {
 		.scan    = cinergy_1400,
 		.size    = ARRAY_SIZE(cinergy_1400),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_CINERGY_1400,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index cf3a6bf..06abebe 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -56,7 +56,7 @@ static struct rc_map_list cinergy_map = {
 	.map = {
 		.scan    = cinergy,
 		.size    = ARRAY_SIZE(cinergy),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_CINERGY,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 7a5f530..c946ec0 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -102,7 +102,7 @@ static struct rc_map_list dib0700_nec_map = {
 	.map = {
 		.scan    = dib0700_nec_table,
 		.size    = ARRAY_SIZE(dib0700_nec_table),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_DIB0700_NEC_TABLE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index 4af12e4..3fe9378 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -213,7 +213,7 @@ static struct rc_map_list dib0700_rc5_map = {
 	.map = {
 		.scan    = dib0700_rc5_table,
 		.size    = ARRAY_SIZE(dib0700_rc5_table),
-		.rc_type = RC_TYPE_RC5,
+		.rc_type = RC_BIT_RC5,
 		.name    = RC_MAP_DIB0700_RC5_TABLE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
index f68b450..6ce7bba 100644
--- a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
+++ b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
@@ -76,7 +76,7 @@ static struct rc_map_list digitalnow_tinytwin_map = {
 	.map = {
 		.scan    = digitalnow_tinytwin,
 		.size    = ARRAY_SIZE(digitalnow_tinytwin),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_DIGITALNOW_TINYTWIN,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-digittrade.c b/drivers/media/rc/keymaps/rc-digittrade.c
index 21d4987..34ec26d 100644
--- a/drivers/media/rc/keymaps/rc-digittrade.c
+++ b/drivers/media/rc/keymaps/rc-digittrade.c
@@ -60,7 +60,7 @@ static struct rc_map_list digittrade_map = {
 	.map = {
 		.scan    = digittrade,
 		.size    = ARRAY_SIZE(digittrade),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_DIGITTRADE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index d024fbf..dbae7b4 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -54,7 +54,7 @@ static struct rc_map_list dm1105_nec_map = {
 	.map = {
 		.scan    = dm1105_nec,
 		.size    = ARRAY_SIZE(dm1105_nec),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_DM1105_NEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 82c0200..4d291c36 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -56,7 +56,7 @@ static struct rc_map_list dntv_live_dvb_t_map = {
 	.map = {
 		.scan    = dntv_live_dvb_t,
 		.size    = ARRAY_SIZE(dntv_live_dvb_t),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_DNTV_LIVE_DVB_T,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index 015e99d..0a4239f 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -75,7 +75,7 @@ static struct rc_map_list dntv_live_dvbt_pro_map = {
 	.map = {
 		.scan    = dntv_live_dvbt_pro,
 		.size    = ARRAY_SIZE(dntv_live_dvbt_pro),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_DNTV_LIVE_DVBT_PRO,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index 269d429..2f5a7ce 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -47,7 +47,7 @@ static struct rc_map_list em_terratec_map = {
 	.map = {
 		.scan    = em_terratec,
 		.size    = ARRAY_SIZE(em_terratec),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_EM_TERRATEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index e388698..6bdb35e 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -59,7 +59,7 @@ static struct rc_map_list encore_enltv_fm53_map = {
 	.map = {
 		.scan    = encore_enltv_fm53,
 		.size    = ARRAY_SIZE(encore_enltv_fm53),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ENCORE_ENLTV_FM53,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index e56ac6e..8f2155f 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -90,7 +90,7 @@ static struct rc_map_list encore_enltv_map = {
 	.map = {
 		.scan    = encore_enltv,
 		.size    = ARRAY_SIZE(encore_enltv),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ENCORE_ENLTV,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index b6264f1..6d964b0 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -68,7 +68,7 @@ static struct rc_map_list encore_enltv2_map = {
 	.map = {
 		.scan    = encore_enltv2,
 		.size    = ARRAY_SIZE(encore_enltv2),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_ENCORE_ENLTV2,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index a2bf24f..e2f334d 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -39,7 +39,7 @@ static struct rc_map_list evga_indtube_map = {
 	.map = {
 		.scan    = evga_indtube,
 		.size    = ARRAY_SIZE(evga_indtube),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_EVGA_INDTUBE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index 1e8e5b2..c54e7eb 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -74,7 +74,7 @@ static struct rc_map_list eztv_map = {
 	.map = {
 		.scan    = eztv,
 		.size    = ARRAY_SIZE(eztv),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_EZTV,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index a8b0f66..2d813c2 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -55,7 +55,7 @@ static struct rc_map_list flydvb_map = {
 	.map = {
 		.scan    = flydvb,
 		.size    = ARRAY_SIZE(flydvb),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_FLYDVB,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index 5bbe683..925f42f 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -48,7 +48,7 @@ static struct rc_map_list flyvideo_map = {
 	.map = {
 		.scan    = flyvideo,
 		.size    = ARRAY_SIZE(flyvideo),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_FLYVIDEO,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index c80b25c..50e3f70 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -76,7 +76,7 @@ static struct rc_map_list fusionhdtv_mce_map = {
 	.map = {
 		.scan    = fusionhdtv_mce,
 		.size    = ARRAY_SIZE(fusionhdtv_mce),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_FUSIONHDTV_MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index 068c9ea..db3964d 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -59,7 +59,7 @@ static struct rc_map_list gadmei_rm008z_map = {
 	.map = {
 		.scan    = gadmei_rm008z,
 		.size    = ARRAY_SIZE(gadmei_rm008z),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_GADMEI_RM008Z,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index cdbbed4..7dfdfef 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -62,7 +62,7 @@ static struct rc_map_list genius_tvgo_a11mce_map = {
 	.map = {
 		.scan    = genius_tvgo_a11mce,
 		.size    = ARRAY_SIZE(genius_tvgo_a11mce),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_GENIUS_TVGO_A11MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index a38bdde..83ee207 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -57,7 +57,7 @@ static struct rc_map_list gotview7135_map = {
 	.map = {
 		.scan    = gotview7135,
 		.size    = ARRAY_SIZE(gotview7135),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_GOTVIEW7135,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
index cd3db77..afa0e9a 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -219,7 +219,7 @@ static struct rc_map_list rc5_hauppauge_new_map = {
 	.map = {
 		.scan    = rc5_hauppauge_new,
 		.size    = ARRAY_SIZE(rc5_hauppauge_new),
-		.rc_type = RC_TYPE_RC5,
+		.rc_type = RC_BIT_RC5,
 		.name    = RC_MAP_HAUPPAUGE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
index 937a819..7564607 100644
--- a/drivers/media/rc/keymaps/rc-imon-mce.c
+++ b/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -120,7 +120,7 @@ static struct rc_map_list imon_mce_map = {
 		.scan    = imon_mce,
 		.size    = ARRAY_SIZE(imon_mce),
 		/* its RC6, but w/a hardware decoder */
-		.rc_type = RC_TYPE_RC6,
+		.rc_type = RC_BIT_RC6,
 		.name    = RC_MAP_IMON_MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
index 63d42bd..dcd2501 100644
--- a/drivers/media/rc/keymaps/rc-imon-pad.c
+++ b/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -134,7 +134,7 @@ static struct rc_map_list imon_pad_map = {
 		.scan    = imon_pad,
 		.size    = ARRAY_SIZE(imon_pad),
 		/* actual protocol details unknown, hardware decoder */
-		.rc_type = RC_TYPE_OTHER,
+		.rc_type = RC_BIT_OTHER,
 		.name    = RC_MAP_IMON_PAD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index 1f59e16..77be76f 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -66,7 +66,7 @@ static struct rc_map_list iodata_bctv7e_map = {
 	.map = {
 		.scan    = iodata_bctv7e,
 		.size    = ARRAY_SIZE(iodata_bctv7e),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_IODATA_BCTV7E,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index f31dc5c..2806b04 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -65,7 +65,7 @@ static struct rc_map_list kaiomy_map = {
 	.map = {
 		.scan    = kaiomy,
 		.size    = ARRAY_SIZE(kaiomy),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_KAIOMY,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index 7f33edb..be43dd3 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -61,7 +61,7 @@ static struct rc_map_list kworld_315u_map = {
 	.map = {
 		.scan    = kworld_315u,
 		.size    = ARRAY_SIZE(kworld_315u),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_KWORLD_315U,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index 08d1831..3244113 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -77,7 +77,7 @@ static struct rc_map_list kworld_plus_tv_analog_map = {
 	.map = {
 		.scan    = kworld_plus_tv_analog,
 		.size    = ARRAY_SIZE(kworld_plus_tv_analog),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_KWORLD_PLUS_TV_ANALOG,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
index 8faa54f..20ded0c 100644
--- a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
+++ b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
@@ -77,7 +77,7 @@ static struct rc_map_list leadtek_y04g0051_map = {
 	.map = {
 		.scan    = leadtek_y04g0051,
 		.size    = ARRAY_SIZE(leadtek_y04g0051),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_LEADTEK_Y04G0051,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
index e8e23e2..dd4d7c9 100644
--- a/drivers/media/rc/keymaps/rc-lirc.c
+++ b/drivers/media/rc/keymaps/rc-lirc.c
@@ -19,7 +19,7 @@ static struct rc_map_list lirc_map = {
 	.map = {
 		.scan    = lirc,
 		.size    = ARRAY_SIZE(lirc),
-		.rc_type = RC_TYPE_LIRC,
+		.rc_type = RC_BIT_LIRC,
 		.name    = RC_MAP_LIRC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index 3c19139..f95895f 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -88,7 +88,7 @@ static struct rc_map_list lme2510_map = {
 	.map = {
 		.scan    = lme2510_rc,
 		.size    = ARRAY_SIZE(lme2510_rc),
-		.rc_type = RC_TYPE_UNKNOWN,
+		.rc_type = RC_BIT_UNKNOWN,
 		.name    = RC_MAP_LME2510,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index 23b2d04..d113a3b 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -112,7 +112,7 @@ static struct rc_map_list manli_map = {
 	.map = {
 		.scan    = manli,
 		.size    = ARRAY_SIZE(manli),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_MANLI,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
index 7b9a01b..1142eac 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
@@ -45,7 +45,7 @@ static struct rc_map_list msi_digivox_ii_map = {
 	.map = {
 		.scan    = msi_digivox_ii,
 		.size    = ARRAY_SIZE(msi_digivox_ii),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_MSI_DIGIVOX_II,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
index ae9d06b..f3c0d16 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
@@ -63,7 +63,7 @@ static struct rc_map_list msi_digivox_iii_map = {
 	.map = {
 		.scan    = msi_digivox_iii,
 		.size    = ARRAY_SIZE(msi_digivox_iii),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_MSI_DIGIVOX_III,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index 8e9969d..429e6af 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -101,7 +101,7 @@ static struct rc_map_list msi_tvanywhere_plus_map = {
 	.map = {
 		.scan    = msi_tvanywhere_plus,
 		.size    = ARRAY_SIZE(msi_tvanywhere_plus),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_MSI_TVANYWHERE_PLUS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index 18b37fa..52cf5f1 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -47,7 +47,7 @@ static struct rc_map_list msi_tvanywhere_map = {
 	.map = {
 		.scan    = msi_tvanywhere,
 		.size    = ARRAY_SIZE(msi_tvanywhere),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_MSI_TVANYWHERE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index ddae20e..91f24c6 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -74,7 +74,7 @@ static struct rc_map_list nebula_map = {
 	.map = {
 		.scan    = nebula,
 		.size    = ARRAY_SIZE(nebula),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_NEBULA,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index 26f114c..558276e 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -83,7 +83,7 @@ static struct rc_map_list nec_terratec_cinergy_xs_map = {
 	.map = {
 		.scan    = nec_terratec_cinergy_xs,
 		.size    = ARRAY_SIZE(nec_terratec_cinergy_xs),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_NEC_TERRATEC_CINERGY_XS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index f1c1281..8093ad5 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -63,7 +63,7 @@ static struct rc_map_list norwood_map = {
 	.map = {
 		.scan    = norwood,
 		.size    = ARRAY_SIZE(norwood),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_NORWOOD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index 4aa588b..07f5f7a 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -58,7 +58,7 @@ static struct rc_map_list npgtech_map = {
 	.map = {
 		.scan    = npgtech,
 		.size    = ARRAY_SIZE(npgtech),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_NPGTECH,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index 7cdef6e..30b7862 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -58,7 +58,7 @@ static struct rc_map_list pctv_sedna_map = {
 	.map = {
 		.scan    = pctv_sedna,
 		.size    = ARRAY_SIZE(pctv_sedna),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PCTV_SEDNA,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index 23b8c50..203c5c6 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -72,7 +72,7 @@ static struct rc_map_list pinnacle_color_map = {
 	.map = {
 		.scan    = pinnacle_color,
 		.size    = ARRAY_SIZE(pinnacle_color),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PINNACLE_COLOR,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index 6ba8c36..94eda32 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -67,7 +67,7 @@ static struct rc_map_list pinnacle_grey_map = {
 	.map = {
 		.scan    = pinnacle_grey,
 		.size    = ARRAY_SIZE(pinnacle_grey),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PINNACLE_GREY,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index bb10ffe..186454e 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -51,7 +51,7 @@ static struct rc_map_list pinnacle_pctv_hd_map = {
 	.map = {
 		.scan    = pinnacle_pctv_hd,
 		.size    = ARRAY_SIZE(pinnacle_pctv_hd),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PINNACLE_PCTV_HD,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
index e5ab071..f8ab181 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -55,7 +55,7 @@ static struct rc_map_list pixelview_map = {
 	.map = {
 		.scan    = pixelview_002t,
 		.size    = ARRAY_SIZE(pixelview_002t),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_PIXELVIEW_002T,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 125fc39..6cde384 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -61,7 +61,7 @@ static struct rc_map_list pixelview_map = {
 	.map = {
 		.scan    = pixelview_mk12,
 		.size    = ARRAY_SIZE(pixelview_mk12),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_PIXELVIEW_MK12,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index bd78d6a..c3d0486 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -61,7 +61,7 @@ static struct rc_map_list pixelview_new_map = {
 	.map = {
 		.scan    = pixelview_new,
 		.size    = ARRAY_SIZE(pixelview_new),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PIXELVIEW_NEW,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index 06187e7..de7e820 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -60,7 +60,7 @@ static struct rc_map_list pixelview_map = {
 	.map = {
 		.scan    = pixelview,
 		.size    = ARRAY_SIZE(pixelview),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PIXELVIEW,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index 5f9d546..c3f41a8 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -59,7 +59,7 @@ static struct rc_map_list powercolor_real_angel_map = {
 	.map = {
 		.scan    = powercolor_real_angel,
 		.size    = ARRAY_SIZE(powercolor_real_angel),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_POWERCOLOR_REAL_ANGEL,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index 8a3a643..9c013a4 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -47,7 +47,7 @@ static struct rc_map_list proteus_2309_map = {
 	.map = {
 		.scan    = proteus_2309,
 		.size    = ARRAY_SIZE(proteus_2309),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PROTEUS_2309,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index ef90296..4266744 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -59,7 +59,7 @@ static struct rc_map_list purpletv_map = {
 	.map = {
 		.scan    = purpletv,
 		.size    = ARRAY_SIZE(purpletv),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PURPLETV,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index 5e8beee..f3ff8e4 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -56,7 +56,7 @@ static struct rc_map_list pv951_map = {
 	.map = {
 		.scan    = pv951,
 		.size    = ARRAY_SIZE(pv951),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_PV951,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 8dd519e..68e87c2 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -97,7 +97,7 @@ static struct rc_map_list rc6_mce_map = {
 	.map = {
 		.scan    = rc6_mce,
 		.size    = ARRAY_SIZE(rc6_mce),
-		.rc_type = RC_TYPE_RC6,
+		.rc_type = RC_BIT_RC6,
 		.name    = RC_MAP_RC6_MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index 6813d11..f42addf 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -56,7 +56,7 @@ static struct rc_map_list real_audio_220_32_keys_map = {
 	.map = {
 		.scan    = real_audio_220_32_keys,
 		.size    = ARRAY_SIZE(real_audio_220_32_keys),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_REAL_AUDIO_220_32_KEYS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-streamzap.c b/drivers/media/rc/keymaps/rc-streamzap.c
index 92cc10d..93052d5 100644
--- a/drivers/media/rc/keymaps/rc-streamzap.c
+++ b/drivers/media/rc/keymaps/rc-streamzap.c
@@ -60,7 +60,7 @@ static struct rc_map_list streamzap_map = {
 	.map = {
 		.scan    = streamzap,
 		.size    = ARRAY_SIZE(streamzap),
-		.rc_type = RC_TYPE_RC5_SZ,
+		.rc_type = RC_BIT_RC5_SZ,
 		.name    = RC_MAP_STREAMZAP,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 7242ee6..ed756d0 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -53,7 +53,7 @@ static struct rc_map_list tbs_nec_map = {
 	.map = {
 		.scan    = tbs_nec,
 		.size    = ARRAY_SIZE(tbs_nec),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TBS_NEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-technisat-usb2.c b/drivers/media/rc/keymaps/rc-technisat-usb2.c
index 4afe577..1786948 100644
--- a/drivers/media/rc/keymaps/rc-technisat-usb2.c
+++ b/drivers/media/rc/keymaps/rc-technisat-usb2.c
@@ -71,7 +71,7 @@ static struct rc_map_list technisat_usb2_map = {
 	.map = {
 		.scan    = technisat_usb2,
 		.size    = ARRAY_SIZE(technisat_usb2),
-		.rc_type = RC_TYPE_RC5,
+		.rc_type = RC_BIT_RC5,
 		.name    = RC_MAP_TECHNISAT_USB2,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index bc38e34..d7aa9d2 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -70,7 +70,7 @@ static struct rc_map_list terratec_cinergy_xs_map = {
 	.map = {
 		.scan    = terratec_cinergy_xs,
 		.size    = ARRAY_SIZE(terratec_cinergy_xs),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TERRATEC_CINERGY_XS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim-2.c b/drivers/media/rc/keymaps/rc-terratec-slim-2.c
index 4409391..7f5b8cd 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim-2.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim-2.c
@@ -50,7 +50,7 @@ static struct rc_map_list terratec_slim_2_map = {
 	.map = {
 		.scan    = terratec_slim_2,
 		.size    = ARRAY_SIZE(terratec_slim_2),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_TERRATEC_SLIM_2,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim.c b/drivers/media/rc/keymaps/rc-terratec-slim.c
index 1abafa5..68b9394 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim.c
@@ -57,7 +57,7 @@ static struct rc_map_list terratec_slim_map = {
 	.map = {
 		.scan    = terratec_slim,
 		.size    = ARRAY_SIZE(terratec_slim),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_TERRATEC_SLIM,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index ef5ba3f..864f2ca 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -66,7 +66,7 @@ static struct rc_map_list tevii_nec_map = {
 	.map = {
 		.scan    = tevii_nec,
 		.size    = ARRAY_SIZE(tevii_nec),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TEVII_NEC,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand.c b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
index 20ac4e1..181eaa4 100644
--- a/drivers/media/rc/keymaps/rc-total-media-in-hand.c
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
@@ -63,7 +63,7 @@ static struct rc_map_list total_media_in_hand_map = {
 	.map = {
 		.scan    = total_media_in_hand,
 		.size    = ARRAY_SIZE(total_media_in_hand),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_TOTAL_MEDIA_IN_HAND,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-trekstor.c b/drivers/media/rc/keymaps/rc-trekstor.c
index f8190ea..5bb283a 100644
--- a/drivers/media/rc/keymaps/rc-trekstor.c
+++ b/drivers/media/rc/keymaps/rc-trekstor.c
@@ -58,7 +58,7 @@ static struct rc_map_list trekstor_map = {
 	.map = {
 		.scan    = trekstor,
 		.size    = ARRAY_SIZE(trekstor),
-		.rc_type = RC_TYPE_NEC,
+		.rc_type = RC_BIT_NEC,
 		.name    = RC_MAP_TREKSTOR,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index 295f373..d5d7903 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -60,7 +60,7 @@ static struct rc_map_list tt_1500_map = {
 	.map = {
 		.scan    = tt_1500,
 		.size    = ARRAY_SIZE(tt_1500),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TT_1500,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-twinhan1027.c b/drivers/media/rc/keymaps/rc-twinhan1027.c
index 8bf8df6..4a6aef6 100644
--- a/drivers/media/rc/keymaps/rc-twinhan1027.c
+++ b/drivers/media/rc/keymaps/rc-twinhan1027.c
@@ -65,7 +65,7 @@ static struct rc_map_list twinhan_vp1027_map = {
 	.map = {
 		.scan    = twinhan_vp1027,
 		.size    = ARRAY_SIZE(twinhan_vp1027),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_TWINHAN_VP1027_DVBS,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-videomate-m1f.c b/drivers/media/rc/keymaps/rc-videomate-m1f.c
index 4994d40..916b641 100644
--- a/drivers/media/rc/keymaps/rc-videomate-m1f.c
+++ b/drivers/media/rc/keymaps/rc-videomate-m1f.c
@@ -70,7 +70,7 @@ static struct rc_map_list videomate_m1f_map = {
 	.map = {
 		.scan    = videomate_m1f,
 		.size    = ARRAY_SIZE(videomate_m1f),
-		.rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,     /* Legacy IR type */
 		.name    = RC_MAP_VIDEOMATE_M1F,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index 9e474a6..26ca260 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -63,7 +63,7 @@ static struct rc_map_list videomate_s350_map = {
 	.map = {
 		.scan    = videomate_s350,
 		.size    = ARRAY_SIZE(videomate_s350),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_VIDEOMATE_S350,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index 5f2a46e..edc169b 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -65,7 +65,7 @@ static struct rc_map_list videomate_tv_pvr_map = {
 	.map = {
 		.scan    = videomate_tv_pvr,
 		.size    = ARRAY_SIZE(videomate_tv_pvr),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_VIDEOMATE_TV_PVR,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index bd8d021..44a5d6f 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -60,7 +60,7 @@ static struct rc_map_list winfast_usbii_deluxe_map = {
 	.map = {
 		.scan    = winfast_usbii_deluxe,
 		.size    = ARRAY_SIZE(winfast_usbii_deluxe),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_WINFAST_USBII_DELUXE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 0062ca2..4c8b4b1 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -80,7 +80,7 @@ static struct rc_map_list winfast_map = {
 	.map = {
 		.scan    = winfast,
 		.size    = ARRAY_SIZE(winfast),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_WINFAST,
 	}
 };
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 044fb7a..c51e7c2 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1067,7 +1067,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->dev.parent = dev;
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protos = RC_TYPE_ALL;
+	rc->allowed_protos = RC_BIT_ALL;
 	rc->timeout = US_TO_NS(1000);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index d4d6449..dba02b5 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1064,7 +1064,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index cc846b2..6dee719 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -214,7 +214,7 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
-	rc->allowed_protos	= RC_TYPE_ALL;
+	rc->allowed_protos	= RC_BIT_ALL;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
 	rc->max_timeout		= UINT_MAX;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 5b4422e..5a182b2 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -102,7 +102,7 @@ static struct rc_map_list empty_map = {
 	.map = {
 		.scan    = empty,
 		.size    = ARRAY_SIZE(empty),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_BIT_UNKNOWN,	/* Legacy IR type */
 		.name    = RC_MAP_EMPTY,
 	}
 };
@@ -725,14 +725,17 @@ static struct {
 	u64	type;
 	char	*name;
 } proto_names[] = {
-	{ RC_TYPE_UNKNOWN,	"unknown"	},
-	{ RC_TYPE_RC5,		"rc-5"		},
-	{ RC_TYPE_NEC,		"nec"		},
-	{ RC_TYPE_RC6,		"rc-6"		},
-	{ RC_TYPE_JVC,		"jvc"		},
-	{ RC_TYPE_SONY,		"sony"		},
-	{ RC_TYPE_RC5_SZ,	"rc-5-sz"	},
-	{ RC_TYPE_LIRC,		"lirc"		},
+	{ RC_BIT_OTHER,		"other"		},
+	{ RC_BIT_RC5,		"rc-5"		},
+	{ RC_BIT_RC5X,		"rc-5-x"	},
+	{ RC_BIT_RC5_SZ,	"rc-5-sz"	},
+	{ RC_BIT_RC6,		"rc-6"		},
+	{ RC_BIT_JVC,		"jvc"		},
+	{ RC_BIT_SONY12,	"sony12"	},
+	{ RC_BIT_SONY15,	"sony15"	},
+	{ RC_BIT_SONY20,	"sony20"	},
+	{ RC_BIT_NEC,		"nec"		},
+	{ RC_BIT_LIRC,		"lirc"		},
 };
 
 #define PROTO_NONE	"none"
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index e435d94..48cf47f 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -322,7 +322,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	rdev->dev.parent = dev;
 	rdev->priv = sz;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
 
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index 040aaa8..d5e249c 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -98,7 +98,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = RC_TYPE_RC5;
+		init_data->type = RC_BIT_RC5;
 		init_data->name = cx->card_name;
 		info.platform_data = init_data;
 		break;
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 45e14ca..8f44703 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -95,7 +95,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	/* The i2c micro-controller only outputs the cmd part of NEC protocol */
 	dev->init_data.rc_dev->scanmask = 0xff;
 	dev->init_data.rc_dev->driver_name = "cx231xx";
-	dev->init_data.type = RC_TYPE_NEC;
+	dev->init_data.type = RC_BIT_NEC;
 	info.addr = 0x30;
 
 	/* Load and bind ir-kbd-i2c */
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index e97cafd..7e5c4cb 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -262,14 +262,14 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/* Integrated CX2388[58] IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_TYPE_ALL;
+		allowed_protos = RC_BIT_ALL;
 		/* The grey Hauppauge RC-5 remote */
 		rc_map = RC_MAP_HAUPPAUGE;
 		break;
 	case CX23885_BOARD_TEVII_S470:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_TYPE_ALL;
+		allowed_protos = RC_BIT_ALL;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TEVII_NEC;
 		break;
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index c820e2f..5ce488d 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -244,7 +244,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	struct cx88_IR *ir;
 	struct rc_dev *dev;
 	char *ir_codes = NULL;
-	u64 rc_type = RC_TYPE_OTHER;
+	u64 rc_type = RC_BIT_OTHER;
 	int err = -ENOMEM;
 	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
 				 * used with a full-code IR table
@@ -408,7 +408,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		ir_codes         = RC_MAP_TWINHAN_VP1027_DVBS;
-		rc_type          = RC_TYPE_NEC;
+		rc_type          = RC_BIT_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	}
@@ -584,7 +584,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 	case CX88_BOARD_LEADTEK_PVR2000:
 		addr_list = pvr2000_addr_list;
 		core->init_data.name = "cx88 Leadtek PVR 2000 remote";
-		core->init_data.type = RC_TYPE_UNKNOWN;
+		core->init_data.type = RC_BIT_UNKNOWN;
 		core->init_data.get_key = get_key_pvr2000;
 		core->init_data.ir_codes = RC_MAP_EMPTY;
 		break;
@@ -605,7 +605,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 			/* Hauppauge XVR */
 			core->init_data.name = "cx88 Hauppauge XVR remote";
 			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
-			core->init_data.type = RC_TYPE_RC5;
+			core->init_data.type = RC_BIT_RC5;
 			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 
 			info.platform_data = &core->init_data;
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index ba1ba86..cfae6aa 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -352,14 +352,14 @@ int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
 
 	/* Adjust xclk based o IR table for RC5/NEC tables */
 
-	if (rc_type == RC_TYPE_RC5) {
+	if (rc_type == RC_BIT_RC5) {
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
 		ir->full_code = 1;
-	} else if (rc_type == RC_TYPE_NEC) {
+	} else if (rc_type == RC_BIT_NEC) {
 		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
 		ir_config = EM2874_IR_NEC;
 		ir->full_code = 1;
-	} else if (rc_type != RC_TYPE_UNKNOWN)
+	} else if (rc_type != RC_BIT_UNKNOWN)
 		rc = -EINVAL;
 
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
@@ -408,14 +408,14 @@ int em28xx_ir_init(struct em28xx *dev)
 	 * em2874 supports more protocols. For now, let's just announce
 	 * the two protocols that were already tested
 	 */
-	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
+	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
 	rc->priv = ir;
 	rc->change_protocol = em28xx_ir_change_protocol;
 	rc->open = em28xx_ir_start;
 	rc->close = em28xx_ir_stop;
 
 	/* By default, keep protocol field untouched */
-	err = em28xx_ir_change_protocol(rc, RC_TYPE_UNKNOWN);
+	err = em28xx_ir_change_protocol(rc, RC_BIT_UNKNOWN);
 	if (err)
 		goto err_out_free;
 
diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
index 2a1ac28..0a21abb 100644
--- a/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -54,7 +54,7 @@ struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
 	/* Our default information for ir-kbd-i2c.c to use */
 	init_data->ir_codes = RC_MAP_HAUPPAUGE;
 	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-	init_data->type = RC_TYPE_RC5;
+	init_data->type = RC_BIT_RC5;
 	init_data->name = "HD-PVR";
 	init_data->polling_interval = 405; /* ms, duplicated from Windows */
 	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 3ab875d..479a892 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -276,7 +276,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	char *ir_codes = NULL;
 	const char *name = NULL;
-	u64 rc_type = RC_TYPE_UNKNOWN;
+	u64 rc_type = RC_BIT_UNKNOWN;
 	struct IR_i2c *ir;
 	struct rc_dev *rc = NULL;
 	struct i2c_adapter *adap = client->adapter;
@@ -295,7 +295,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x64:
 		name        = "Pixelview";
 		ir->get_key = get_key_pixelview;
-		rc_type     = RC_TYPE_OTHER;
+		rc_type     = RC_BIT_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x18:
@@ -303,31 +303,31 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x1a:
 		name        = "Hauppauge";
 		ir->get_key = get_key_haup;
-		rc_type     = RC_TYPE_RC5;
+		rc_type     = RC_BIT_RC5;
 		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	case 0x30:
 		name        = "KNC One";
 		ir->get_key = get_key_knc1;
-		rc_type     = RC_TYPE_OTHER;
+		rc_type     = RC_BIT_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x6b:
 		name        = "FusionHDTV";
 		ir->get_key = get_key_fusionhdtv;
-		rc_type     = RC_TYPE_RC5;
+		rc_type     = RC_BIT_RC5;
 		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
 		break;
 	case 0x40:
 		name        = "AVerMedia Cardbus remote";
 		ir->get_key = get_key_avermedia_cardbus;
-		rc_type     = RC_TYPE_OTHER;
+		rc_type     = RC_BIT_OTHER;
 		ir_codes    = RC_MAP_AVERMEDIA_CARDBUS;
 		break;
 	case 0x71:
 		name        = "Hauppauge/Zilog Z8";
 		ir->get_key = get_key_haup_xvr;
-		rc_type     = RC_TYPE_RC5;
+		rc_type     = RC_BIT_RC5;
 		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	}
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index d47f41a..46e262b 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -200,21 +200,21 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->ir_codes = RC_MAP_AVERMEDIA_CARDBUS;
 		init_data->internal_get_key_func =
 					IR_KBD_GET_KEY_AVERMEDIA_CARDBUS;
-		init_data->type = RC_TYPE_OTHER;
+		init_data->type = RC_BIT_OTHER;
 		init_data->name = "AVerMedia AVerTV card";
 		break;
 	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
 	case IVTV_HW_I2C_IR_RX_HAUP_INT:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
-		init_data->type = RC_TYPE_RC5;
+		init_data->type = RC_BIT_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_Z8F0811_IR_RX_HAUP:
 		/* Default to grey remote */
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = RC_TYPE_RC5;
+		init_data->type = RC_BIT_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_I2C_IR_RX_ADAPTEC:
@@ -222,7 +222,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->name = itv->card_name;
 		/* FIXME: The protocol and RC_MAP needs to be corrected */
 		init_data->ir_codes = RC_MAP_EMPTY;
-		init_data->type = RC_TYPE_UNKNOWN;
+		init_data->type = RC_BIT_UNKNOWN;
 		break;
 	}
 
diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
index e72d510..ad0e033 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
@@ -580,7 +580,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 	case PVR2_IR_SCHEME_29XXX: /* Original 29xxx device */
 		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
-		init_data->type                  = RC_TYPE_RC5;
+		init_data->type                  = RC_BIT_RC5;
 		init_data->name                  = hdw->hdw_desc->description;
 		init_data->polling_interval      = 100; /* ms From ir-kbd-i2c */
 		/* IR Receiver */
@@ -595,7 +595,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 	case PVR2_IR_SCHEME_24XXX_MCE: /* 24xxx MCE device */
 		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type                  = RC_TYPE_RC5;
+		init_data->type                  = RC_BIT_RC5;
 		init_data->name                  = hdw->hdw_desc->description;
 		/* IR Receiver */
 		info.addr          = 0x71;
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index be1c2a2..f00f4bd 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -914,7 +914,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = RC_MAP_BEHOLD;
-		dev->init_data.type = RC_TYPE_NEC;
+		dev->init_data.type = RC_BIT_NEC;
 		info.addr = 0x2d;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 21e7da4..715629b 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -97,7 +97,7 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 	int rc;
 
 	switch (ir->rc_type) {
-	case RC_TYPE_NEC:
+	case RC_BIT_NEC:
 		/* Setup IR decoder for NEC standard 12MHz system clock */
 		/* IR_LEADER_CNT = 0.9ms             */
 		tm6000_set_reg(dev, TM6010_REQ07_RD8_IR_LEADER1, 0xaa);
@@ -174,10 +174,10 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 
 	if (&dev->int_in) {
 		switch (ir->rc_type) {
-		case RC_TYPE_RC5:
+		case RC_BIT_RC5:
 			poll_result->rc_data = ir->urb_data[0];
 			break;
-		case RC_TYPE_NEC:
+		case RC_BIT_NEC:
 			if (ir->urb_data[1] == ((ir->key_addr >> 8) & 0xff)) {
 				poll_result->rc_data = ir->urb_data[0]
 							| ir->urb_data[1] << 8;
@@ -194,7 +194,7 @@ static int default_polling_getkey(struct tm6000_IR *ir,
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 1);
 		msleep(10);
 
-		if (ir->rc_type == RC_TYPE_RC5) {
+		if (ir->rc_type == RC_BIT_RC5) {
 			rc = tm6000_read_write_usb(dev, USB_DIR_IN |
 				USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				REQ_02_GET_IR_CODE, 0, 0, buf, 1);
@@ -291,7 +291,7 @@ int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 	if (!ir)
 		return 0;
 
-	if ((rc->rc_map.scan) && (rc_type == RC_TYPE_NEC))
+	if ((rc->rc_map.scan) && (rc_type == RC_BIT_NEC))
 		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
 
 	ir->get_key = default_polling_getkey;
@@ -383,7 +383,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	ir->rc = rc;
 
 	/* input einrichten */
-	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
+	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
 	rc->priv = ir;
 	rc->change_protocol = tm6000_ir_change_protocol;
 	rc->open = tm6000_ir_start;
@@ -401,7 +401,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	tm6000_ir_change_protocol(rc, RC_TYPE_UNKNOWN);
+	tm6000_ir_change_protocol(rc, RC_BIT_UNKNOWN);
 
 	rc->input_name = ir->name;
 	rc->input_phys = ir->phys;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 9184751..2c68ca6 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -11,19 +11,36 @@
 
 #include <linux/input.h>
 
-#define RC_TYPE_UNKNOWN	0
-#define RC_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
-#define RC_TYPE_NEC	(1  << 1)
-#define RC_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
-#define RC_TYPE_JVC	(1  << 3)	/* JVC protocol */
-#define RC_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
-#define RC_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
-#define RC_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
-#define RC_TYPE_OTHER	(1u << 31)
+#define RC_TYPE_UNKNOWN		0	/* Protocol not known */
+#define RC_TYPE_OTHER		0	/* Protocol known but proprietary */
+#define RC_TYPE_RC5		1	/* Philips RC5 protocol */
+#define RC_TYPE_RC5X		2	/* Philips RC5x protocol */
+#define RC_TYPE_RC5_SZ		3	/* StreamZap variant of RC5 */
+#define RC_TYPE_RC6		4	/* Philips RC6 protocol */
+#define RC_TYPE_JVC		5	/* JVC protocol */
+#define RC_TYPE_SONY12		6	/* Sony 12 bit protocol */
+#define RC_TYPE_SONY15		7	/* Sony 15 bit protocol */
+#define RC_TYPE_SONY20		8	/* Sony 20 bit protocol */
+#define RC_TYPE_NEC		9	/* NEC protocol */
+#define RC_TYPE_LIRC		10	/* Pass raw IR to lirc userspace */
 
-#define RC_TYPE_ALL (RC_TYPE_RC5 | RC_TYPE_NEC  | RC_TYPE_RC6  | \
-		     RC_TYPE_JVC | RC_TYPE_SONY | RC_TYPE_LIRC | \
-		     RC_TYPE_RC5_SZ | RC_TYPE_OTHER)
+#define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
+#define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
+#define RC_BIT_RC5		(1 << RC_TYPE_RC5)
+#define RC_BIT_RC5X		(1 << RC_TYPE_RC5X)
+#define RC_BIT_RC5_SZ		(1 << RC_TYPE_RC5_SZ)
+#define RC_BIT_RC6		(1 << RC_TYPE_RC6)
+#define RC_BIT_JVC		(1 << RC_TYPE_JVC)
+#define RC_BIT_SONY12		(1 << RC_TYPE_SONY12)
+#define RC_BIT_SONY15		(1 << RC_TYPE_SONY15)
+#define RC_BIT_SONY20		(1 << RC_TYPE_SONY20)
+#define RC_BIT_NEC		(1 << RC_TYPE_NEC)
+#define RC_BIT_LIRC		(1 << RC_TYPE_LIRC)
+
+#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_RC5 | \
+			 RC_BIT_RC5X | RC_BIT_RC6 | RC_BIT_JVC | \
+			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
+			 RC_BIT_NEC | RC_BIT_LIRC)
 
 struct rc_map_table {
 	u32	scancode;

