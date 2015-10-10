Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 06/26] [media] DocBook: Document tveeprom.h
Date: Sat, 10 Oct 2015 10:35:49 -0300
Message-Id: <326ab27bbddf053e6b578fde312b5069aa55b2ab.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This header declares the code and structures used to parse
Hauppauge eeproms. As this is part of the V4L2 common, and
used by several drivers, let's properly document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 8ce967a48c58..bdc0f7e0a55d 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -223,6 +223,7 @@ X!Isound/sound_firmware.c
      <sect1><title>Video2Linux devices</title>
 !Iinclude/media/tuner.h
 !Iinclude/media/tuner-types.h
+!Iinclude/media/tveeprom.h
 !Iinclude/media/v4l2-async.h
 !Iinclude/media/v4l2-ctrls.h
 !Iinclude/media/v4l2-dv-timings.h
diff --git a/include/media/tveeprom.h b/include/media/tveeprom.h
index bb484967ef8b..8be898739e0c 100644
--- a/include/media/tveeprom.h
+++ b/include/media/tveeprom.h
@@ -1,28 +1,63 @@
+
 /*
+ * tveeprom - Contains structures and functions to work with Hauppauge
+ *	      eeproms.
  */
 
+#include <linux/if_ether.h>
+
+/**
+ * enum tveeprom_audio_processor - Specifies the type of audio processor
+ *				   used on a Hauppauge device.
+ *
+ * @TVEEPROM_AUDPROC_NONE:	No audio processor present
+ * @TVEEPROM_AUDPROC_INTERNAL:	The audio processor is internal to the
+ *				video processor
+ * @TVEEPROM_AUDPROC_MSP:	The audio processor is a MSPXXXX device
+ * @TVEEPROM_AUDPROC_OTHER:	The audio processor is another device
+ */
 enum tveeprom_audio_processor {
-	/* No audio processor present */
 	TVEEPROM_AUDPROC_NONE,
-	/* The audio processor is internal to the video processor */
 	TVEEPROM_AUDPROC_INTERNAL,
-	/* The audio processor is a MSPXXXX device */
 	TVEEPROM_AUDPROC_MSP,
-	/* The audio processor is another device */
 	TVEEPROM_AUDPROC_OTHER,
 };
 
-#include <linux/if_ether.h>
-
+/**
+ * struct tveeprom - Contains the fields parsed from Hauppauge eeproms
+ *
+ * @has_radio:			1 if the device has radio; 0 otherwise.
+ * @has_ir:			If has_ir == 0, then it is unknown what the IR
+ *				capabilities are. Otherwise:
+ *					bit 0) 1 (= IR capabilities are known);
+ *					bit 1) IR receiver present;
+ *					bit 2) IR transmitter (blaster) present.
+ * @has_MAC_address:		0: no MAC, 1: MAC present, 2: unknown.
+ * @tuner_type:			type of the tuner (TUNER_*, as defined at
+ *				include/media/tuner.h).
+ * @tuner_formats:		Supported analog TV standards (V4L2_STD_*).
+ * @tuner_hauppauge_model:	Hauppauge's code for the device model number.
+ * @tuner2_type:		type of the second tuner (TUNER_*, as defined
+ *				at include/media/tuner.h).
+ * @tuner2_formats:		Tuner 2 supported analog TV standards
+ *				(V4L2_STD_*).
+ * @tuner2_hauppauge_model:	tuner 2 Hauppauge's code for the device model
+ *				number.
+ * @audio_processor:		analog audio decoder, as defined by enum
+ *				tveeprom_audio_processor.
+ * @decoder_processor:		Hauppauge's code for the decoder chipset.
+ *				Unused by the drivers, as they probe the
+ *				decoder based on the PCI or USB ID.
+ * @model:			Hauppauge's model number
+ * @revision:			Card revision number
+ * @serial_number:		Card's serial number
+ * @rev_str:			Card revision converted to number
+ * @MAC_address:		MAC address for the network interface
+ */
 struct tveeprom {
 	u32 has_radio;
-	/* If has_ir == 0, then it is unknown what the IR capabilities are,
-	   otherwise:
-	   bit 0: 1 (= IR capabilities are known)
-	   bit 1: IR receiver present
-	   bit 2: IR transmitter (blaster) present */
 	u32 has_ir;
-	u32 has_MAC_address; /* 0: no MAC, 1: MAC present, 2: unknown */
+	u32 has_MAC_address;
 
 	u32 tuner_type;
 	u32 tuner_formats;
@@ -42,7 +77,28 @@ struct tveeprom {
 	u8 MAC_address[ETH_ALEN];
 };
 
+/**
+ * tveeprom_hauppauge_analog - Fill struct tveeprom using the contents
+ *			       of the eeprom previously filled at
+ *			       @eeprom_data field.
+ *
+ * @c:			I2C client struct
+ * @tvee:		Struct to where the eeprom parsed data will be filled;
+ * @eeprom_data:	Array with the contents of the eeprom_data. It should
+ *			contain 256 bytes filled with the contents of the
+ *			eeprom read from the Hauppauge device.
+ */
 void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			       unsigned char *eeprom_data);
 
+/**
+ * tveeprom_read - Reads the contents of the eeprom found at the Hauppauge
+ *		   devices.
+ *
+ * @c:		I2C client struct
+ * @eedata:	Array where the eeprom content will be stored.
+ * @len:	Size of @eedata array. If the eeprom content will be latter
+ *		be parsed by tveeprom_hauppauge_analog(), len should be, at
+ *		least, 256.
+ */
 int tveeprom_read(struct i2c_client *c, unsigned char *eedata, int len);
-- 
2.4.3


