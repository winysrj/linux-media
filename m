Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 04/13] [media] v4l2-mc.h: move tuner PAD definitions to this new header
Date: Fri, 29 Jan 2016 10:10:54 -0200
Message-Id: <ea2f7bff9379b1152a73be60c38921dcb48b66e0.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The customer PC hardware can be shipped with lots of different
configurations, as vendors use to replace some of the chips on
their hardware along the time. All drivers that support such
devices are prepared to handle the hardware differences, using
their own auto-probing logic.

They do it in a way that number of inputs and outputs for a given
hardware type doesn't change.

Now that we're adding media controller capabilities to those drivers,
we need to standardize the number of inputs and outputs for each
hardware type, as we want to have a generic function at the V4L2
core that would create the links for the entities that are expected
on such hardware.

Such standard is already there for tuners, but tuner.h is not the
best place to store such data, as we'll need to add definitions also
for analog TV demodulators.

Also, we'll need a place to put a set of MC handling functions. So,
let's create a v4l2-mc.h to store such kind of definitions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/device-drivers.tmpl |  1 +
 include/media/tuner.h                     | 24 +------------------
 include/media/v4l2-mc.h                   | 38 +++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 23 deletions(-)
 create mode 100644 include/media/v4l2-mc.h

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index cdd8b24db68d..cc303a2f641c 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -229,6 +229,7 @@ X!Isound/sound_firmware.c
 !Iinclude/media/v4l2-dv-timings.h
 !Iinclude/media/v4l2-event.h
 !Iinclude/media/v4l2-flash-led-class.h
+!Iinclude/media/v4l2-mc.h
 !Iinclude/media/v4l2-mediabus.h
 !Iinclude/media/v4l2-mem2mem.h
 !Iinclude/media/v4l2-of.h
diff --git a/include/media/tuner.h b/include/media/tuner.h
index c5994fe865a0..b3edc14e763f 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -20,29 +20,7 @@
 #ifdef __KERNEL__
 
 #include <linux/videodev2.h>
-
-/**
- * enum tuner_pad_index - tuner pad index
- *
- * @TUNER_PAD_RF_INPUT:	Radiofrequency (RF) sink pad, usually linked to a
- *			RF connector entity.
- * @TUNER_PAD_OUTPUT:	Tuner output pad. This is actually more complex than
- *			a single pad output, as, in addition to luminance and
- *			chrominance IF a tuner may have internally an
- *			audio decoder (like xc3028) or it may produce an audio
- *			IF that will be used by an audio decoder like msp34xx.
- *			It may also have an IF-PLL demodulator on it, like
- *			tuners with tda9887. Yet, currently, we don't need to
- *			represent all the dirty details, as this is transparent
- *			for the V4L2 API usage. So, let's represent all kinds
- *			of different outputs as a single source pad.
- * @TUNER_NUM_PADS:	Number of pads of the tuner.
- */
-enum tuner_pad_index {
-	TUNER_PAD_RF_INPUT,
-	TUNER_PAD_OUTPUT,
-	TUNER_NUM_PADS
-};
+#include <media/v4l2-mc.h>
 
 #define ADDR_UNSET (255)
 
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
new file mode 100644
index 000000000000..f6fcd70f3548
--- /dev/null
+++ b/include/media/v4l2-mc.h
@@ -0,0 +1,38 @@
+/*
+ * v4l2-mc.h - Media Controller V4L2 types and prototypes
+ *
+ * Copyright (C) 2016 Mauro Carvalho Chehab <mchehab@osg.samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/**
+ * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
+ *
+ * @TUNER_PAD_RF_INPUT:	Radiofrequency (RF) sink pad, usually linked to a
+ *			RF connector entity.
+ * @TUNER_PAD_OUTPUT:	Tuner output pad. This is actually more complex than
+ *			a single pad output, as, in addition to luminance and
+ *			chrominance IF a tuner may have internally an
+ *			audio decoder (like xc3028) or it may produce an audio
+ *			IF that will be used by an audio decoder like msp34xx.
+ *			It may also have an IF-PLL demodulator on it, like
+ *			tuners with tda9887. Yet, currently, we don't need to
+ *			represent all the dirty details, as this is transparent
+ *			for the V4L2 API usage. So, let's represent all kinds
+ *			of different outputs as a single source pad.
+ * @TUNER_NUM_PADS:	Number of pads of the tuner.
+ */
+enum tuner_pad_index {
+	TUNER_PAD_RF_INPUT,
+	TUNER_PAD_OUTPUT,
+	TUNER_NUM_PADS
+};
\ No newline at end of file
-- 
2.5.0


