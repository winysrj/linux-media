Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 01/26] [media] DocBook: Document include/media/tuner.h
Date: Sat, 10 Oct 2015 10:35:44 -0300
Message-Id: <07c68a7423c4e44cc4f85caa83bb7fae36367250.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is part of the V4L2 core, so its kABI should be
documented at device-drivers DocBook.

Add the meta-tags for that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 31cefc9af98e..2fc3bca44f49 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -221,6 +221,7 @@ X!Isound/sound_firmware.c
      <title>Media Devices</title>
 
      <sect1><title>Video2Linux devices</title>
+!Iinclude/media/tuner.h
 !Iinclude/media/v4l2-async.h
 !Iinclude/media/v4l2-ctrls.h
 !Iinclude/media/v4l2-dv-timings.h
diff --git a/include/media/tuner.h b/include/media/tuner.h
index b46ebb48fe74..4445dcbfdb80 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -166,33 +166,67 @@
 #define TDA9887_GAIN_NORMAL		(1<<20)
 #define TDA9887_RIF_41_3		(1<<21)  /* radio IF1 41.3 vs 33.3 */
 
+/**
+ * enum tuner_mode      - Mode of the tuner
+ *
+ * @T_RADIO:        Tuner core will work in radio mode
+ * @T_ANALOG_TV:    Tuner core will work in analog TV mode
+ *
+ * Older boards only had a single tuner device, but some devices have a
+ * separate tuner for radio. In any case, the tuner-core needs to know if
+ * the tuner chip(s) will be used in radio mode or analog TV mode, as, on
+ * radio mode, frequencies are specified on a different range than on TV
+ * mode. This enum is used by the tuner core in order to work with the
+ * proper tuner range and eventually use a different tuner chip while in
+ * radio mode.
+ */
 enum tuner_mode {
 	T_RADIO		= 1 << V4L2_TUNER_RADIO,
 	T_ANALOG_TV     = 1 << V4L2_TUNER_ANALOG_TV,
 	/* Don't need to map V4L2_TUNER_DIGITAL_TV, as tuner-core won't use it */
 };
 
-/* Older boards only had a single tuner device. Nowadays multiple tuner
-   devices may be present on a single board. Using TUNER_SET_TYPE_ADDR
-   to pass the tuner_setup structure it is possible to setup each tuner
-   device in turn.
-
-   Since multiple devices may be present it is no longer sufficient to
-   send a command to a single i2c device. Instead you should broadcast
-   the command to all i2c devices.
-
-   By setting the mode_mask correctly you can select which commands are
-   accepted by a specific tuner device. For example, set mode_mask to
-   T_RADIO if the device is a radio-only tuner. That specific tuner will
-   only accept commands when the tuner is in radio mode and ignore them
-   when the tuner is set to TV mode.
+/**
+ * struct tuner_setup   - setup the tuner chipsets
+ *
+ * @addr:		I2C address used to control the tuner device/chipset
+ * @type:		Type of the tuner, as defined at the TUNER_* macros.
+ *			Each different tuner model should have an unique
+ *			identifier.
+ * @mode_mask:		Mask with the allowed tuner modes: V4L2_TUNER_RADIO,
+ *			V4L2_TUNER_ANALOG_TV and/or V4L2_TUNER_DIGITAL_TV,
+ *			describing if the tuner should be used to support
+ *			Radio, analog TV and/or digital TV.
+ * @config:		Used to send tuner-specific configuration for complex
+ *			tuners that require extra parameters to be set.
+ *			Only a very few tuners require it and its usage on
+ *			newer tuners should be avoided.
+ * @tuner_callback:	Some tuners require to call back the bridge driver,
+ *			in order to do some tasks like rising a GPIO at the
+ *			bridge chipset, in order to do things like resetting
+ *			the device.
+ *
+ * Older boards only had a single tuner device. Nowadays multiple tuner
+ * devices may be present on a single board. Using TUNER_SET_TYPE_ADDR
+ * to pass the tuner_setup structure it is possible to setup each tuner
+ * device in turn.
+ *
+ * Since multiple devices may be present it is no longer sufficient to
+ * send a command to a single i2c device. Instead you should broadcast
+ * the command to all i2c devices.
+ *
+ * By setting the mode_mask correctly you can select which commands are
+ * accepted by a specific tuner device. For example, set mode_mask to
+ * T_RADIO if the device is a radio-only tuner. That specific tuner will
+ * only accept commands when the tuner is in radio mode and ignore them
+ * when the tuner is set to TV mode.
  */
 
 struct tuner_setup {
-	unsigned short	addr; 	/* I2C address */
-	unsigned int	type;   /* Tuner type */
-	unsigned int	mode_mask;  /* Allowed tuner modes */
-	void		*config;    /* configuraion for more complex tuners */
+	unsigned short	addr;
+	unsigned int	type;
+	unsigned int	mode_mask;
+	void		*config;
 	int (*tuner_callback) (void *dev, int component, int cmd, int arg);
 };
 
-- 
2.4.3


