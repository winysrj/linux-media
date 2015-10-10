Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbJJNgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 04/26] [media] DocBook: add documentation for tuner-types.h
Date: Sat, 10 Oct 2015 10:35:47 -0300
Message-Id: <5057f3262c52434fea9eda17494716b9649f25bd.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tuner-types.h is part of the V4L2 core and should be
touched for every new tuner added. So, it deserves to be
documented at the device-drivers DocBook.

Add it to device-drivers.tmpl and add descriptions for
enum param_type and struct tuner_range.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 2fc3bca44f49..8ce967a48c58 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -222,6 +222,7 @@ X!Isound/sound_firmware.c
 
      <sect1><title>Video2Linux devices</title>
 !Iinclude/media/tuner.h
+!Iinclude/media/tuner-types.h
 !Iinclude/media/v4l2-async.h
 !Iinclude/media/v4l2-ctrls.h
 !Iinclude/media/v4l2-dv-timings.h
diff --git a/include/media/tuner-types.h b/include/media/tuner-types.h
index 011b4a20ee22..094e112cc325 100644
--- a/include/media/tuner-types.h
+++ b/include/media/tuner-types.h
@@ -5,6 +5,15 @@
 #ifndef __TUNER_TYPES_H__
 #define __TUNER_TYPES_H__
 
+/**
+ * enum param_type - type of the tuner pameters
+ *
+ * @TUNER_PARAM_TYPE_RADIO:	Tuner params are for FM and/or AM radio
+ * @TUNER_PARAM_TYPE_PAL:	Tuner params are for PAL color TV standard
+ * @TUNER_PARAM_TYPE_SECAM:	Tuner params are for SECAM color TV standard
+ * @TUNER_PARAM_TYPE_NTSC:	Tuner params are for NTSC color TV standard
+ * @TUNER_PARAM_TYPE_DIGITAL:	Tuner params are for digital TV
+ */
 enum param_type {
 	TUNER_PARAM_TYPE_RADIO,
 	TUNER_PARAM_TYPE_PAL,
@@ -13,6 +22,23 @@ enum param_type {
 	TUNER_PARAM_TYPE_DIGITAL,
 };
 
+/**
+ * struct tuner_range - define the frequencies supported by the tuner
+ *
+ * @limit:		Max frequency supported by that range, in 62.5 kHz
+ *			(TV) or 62.5 Hz (Radio), as defined by
+ *			V4L2_TUNER_CAP_LOW.
+ * @config:		Value of the band switch byte (BB) to setup this mode.
+ * @cb:			Value of the CB byte to setup this mode.
+ *
+ * Please notice that digital tuners like xc3028/xc4000/xc5000 don't use
+ * those ranges, as they're defined inside the driver. This is used by
+ * analog tuners that are compatible with the "Philips way" to setup the
+ * tuners. On those devices, the tuner set is done via 4 bytes:
+ *	divider byte1 (DB1), divider byte 2 (DB2), Control byte (CB) and
+ *	band switch byte (BB).
+ * Some tuners also have an additional optional Auxiliary byte (AB).
+ */
 struct tuner_range {
 	unsigned short limit;
 	unsigned char config;
-- 
2.4.3


