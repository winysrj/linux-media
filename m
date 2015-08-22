Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbbHVR2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 32/39] [media] Docbook: Document struct analog_parameters
Date: Sat, 22 Aug 2015 14:28:17 -0300
Message-Id: <f7fe5bd178de5368fd6906fd9cf883c9fbed1106.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That struct inside dvb-frontend.h stores some parameters
from V4L2 API (videodev2.h), in order to be used by the
hybrid analog/digital TV tuners.

Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 1cd1dcde93c2..afcd02932a92 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -90,6 +90,20 @@ struct dvb_tuner_info {
 	u32 bandwidth_step;
 };
 
+/**
+ * struct analog_parameters - Parameters to tune into an analog/radio channel
+ *
+ * @frequency:	Frequency used by analog TV tuner (either in 62.5 kHz step,
+ * 		for TV, or 62.5 Hz for radio)
+ * @mode:	Tuner mode, as defined on enum v4l2_tuner_type
+ * @audmode:	Audio mode as defined for the rxsubchans field at videodev2.h,
+ * 		e. g. V4L2_TUNER_MODE_*
+ * @std:	TV standard bitmap as defined at videodev2.h, e. g. V4L2_STD_*
+ *
+ * Hybrid tuners should be supported by both V4L2 and DVB APIs. This
+ * struct contains the data that are used by the V4L2 side. To avoid
+ * dependencies from V4L2 headers, all enums here are declared as integers.
+ */
 struct analog_parameters {
 	unsigned int frequency;
 	unsigned int mode;
@@ -110,16 +124,16 @@ enum tuner_param {
 /**
  * enum dvbfe_algo - defines the algorithm used to tune into a channel
  *
- * @DVBFE_ALGO_HW: (Hardware Algorithm)
+ * @DVBFE_ALGO_HW: Hardware Algorithm -
  *	Devices that support this algorithm do everything in hardware
  *	and no software support is needed to handle them.
  *	Requesting these devices to LOCK is the only thing required,
  *	device is supposed to do everything in the hardware.
  *
- * @DVBFE_ALGO_SW: (Software Algorithm)
+ * @DVBFE_ALGO_SW: Software Algorithm -
  * These are dumb devices, that require software to do everything
  *
- * @DVBFE_ALGO_CUSTOM: (Customizable Agorithm)
+ * @DVBFE_ALGO_CUSTOM: Customizable Agorithm -
  *	Devices having this algorithm can be customized to have specific
  *	algorithms in the frontend driver, rather than simply doing a
  *	software zig-zag. In this case the zigzag maybe hardware assisted
@@ -127,7 +141,7 @@ enum tuner_param {
  *	this algorithm, in conjunction with the search and track
  *	callbacks, utilizes the driver specific algorithm.
  *
- * @DVBFE_ALGO_RECOVERY: (Recovery Algorithm)
+ * @DVBFE_ALGO_RECOVERY: Recovery Algorithm -
  *	These devices have AUTO recovery capabilities from LOCK failure
  */
 enum dvbfe_algo {
-- 
2.4.3

