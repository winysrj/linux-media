Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 17/39] [media] DocBook: add dvb_frontend.h to documentation
Date: Sat, 22 Aug 2015 14:28:02 -0300
Message-Id: <b7e7d9550b314418285045ba495ce7638eac3f5e.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are already some comments at dvb_frontend.h that are ready
for DocBook, although not properly formatted.

Convert them, and add this file to the device-drivers DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index e0c358760344..fb5c16a24e4b 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -228,6 +228,7 @@ X!Isound/sound_firmware.c
 !Iinclude/media/v4l2-subdev.h
 !Iinclude/media/rc-core.h
 !Idrivers/media/dvb-core/dvb_ca_en50221.h
+!Idrivers/media/dvb-core/dvb_frontend.h
 <!-- FIXME: Removed for now due to document generation inconsistency
 X!Iinclude/media/v4l2-ctrls.h
 X!Iinclude/media/v4l2-dv-timings.h
@@ -237,7 +238,6 @@ X!Iinclude/media/videobuf2-memops.h
 X!Iinclude/media/videobuf2-core.h
 X!Iinclude/media/lirc.h
 X!Edrivers/media/dvb-core/dvb_demux.c
-X!Idrivers/media/dvb-core/dvb_frontend.h
 X!Idrivers/media/dvb-core/dvbdev.h
 X!Edrivers/media/dvb-core/dvb_net.c
 X!Idrivers/media/dvb-core/dvb_ringbuffer.h
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 4816947294fe..d20d3da97201 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -121,30 +121,28 @@ enum tuner_param {
 	DVBFE_TUNER_DUMMY		= (1 << 31)
 };
 
-/*
- * ALGO_HW: (Hardware Algorithm)
- * ----------------------------------------------------------------
- * Devices that support this algorithm do everything in hardware
- * and no software support is needed to handle them.
- * Requesting these devices to LOCK is the only thing required,
- * device is supposed to do everything in the hardware.
+/**
+ * enum dvbfe_algo - defines the algorithm used to tune into a channel
  *
- * ALGO_SW: (Software Algorithm)
- * ----------------------------------------------------------------
+ * @DVBFE_ALGO_HW: (Hardware Algorithm)
+ *	Devices that support this algorithm do everything in hardware
+ *	and no software support is needed to handle them.
+ *	Requesting these devices to LOCK is the only thing required,
+ *	device is supposed to do everything in the hardware.
+ *
+ * @DVBFE_ALGO_SW: (Software Algorithm)
  * These are dumb devices, that require software to do everything
  *
- * ALGO_CUSTOM: (Customizable Agorithm)
- * ----------------------------------------------------------------
- * Devices having this algorithm can be customized to have specific
- * algorithms in the frontend driver, rather than simply doing a
- * software zig-zag. In this case the zigzag maybe hardware assisted
- * or it maybe completely done in hardware. In all cases, usage of
- * this algorithm, in conjunction with the search and track
- * callbacks, utilizes the driver specific algorithm.
+ * @DVBFE_ALGO_CUSTOM: (Customizable Agorithm)
+ *	Devices having this algorithm can be customized to have specific
+ *	algorithms in the frontend driver, rather than simply doing a
+ *	software zig-zag. In this case the zigzag maybe hardware assisted
+ *	or it maybe completely done in hardware. In all cases, usage of
+ *	this algorithm, in conjunction with the search and track
+ *	callbacks, utilizes the driver specific algorithm.
  *
- * ALGO_RECOVERY: (Recovery Algorithm)
- * ----------------------------------------------------------------
- * These devices have AUTO recovery capabilities from LOCK failure
+ * @DVBFE_ALGO_RECOVERY: (Recovery Algorithm)
+ *	These devices have AUTO recovery capabilities from LOCK failure
  */
 enum dvbfe_algo {
 	DVBFE_ALGO_HW			= (1 <<  0),
@@ -162,27 +160,27 @@ struct tuner_state {
 	u32 refclock;
 };
 
-/*
- * search callback possible return status
+/**
+ * enum dvbfe_search - search callback possible return status
  *
- * DVBFE_ALGO_SEARCH_SUCCESS
- * The frontend search algorithm completed and returned successfully
+ * @DVBFE_ALGO_SEARCH_SUCCESS:
+ *	The frontend search algorithm completed and returned successfully
  *
- * DVBFE_ALGO_SEARCH_ASLEEP
- * The frontend search algorithm is sleeping
+ * @DVBFE_ALGO_SEARCH_ASLEEP:
+ *	The frontend search algorithm is sleeping
  *
- * DVBFE_ALGO_SEARCH_FAILED
- * The frontend search for a signal failed
+ * @DVBFE_ALGO_SEARCH_FAILED:
+ *	The frontend search for a signal failed
  *
- * DVBFE_ALGO_SEARCH_INVALID
- * The frontend search algorith was probably supplied with invalid
- * parameters and the search is an invalid one
+ * @DVBFE_ALGO_SEARCH_INVALID:
+ *	The frontend search algorith was probably supplied with invalid
+ *	parameters and the search is an invalid one
  *
- * DVBFE_ALGO_SEARCH_ERROR
- * The frontend search algorithm failed due to some error
+ * @DVBFE_ALGO_SEARCH_ERROR:
+ *	The frontend search algorithm failed due to some error
  *
- * DVBFE_ALGO_SEARCH_AGAIN
- * The frontend search algorithm was requested to search again
+ * @DVBFE_ALGO_SEARCH_AGAIN:
+ *	The frontend search algorithm was requested to search again
  */
 enum dvbfe_search {
 	DVBFE_ALGO_SEARCH_SUCCESS	= (1 <<  0),
-- 
2.4.3

