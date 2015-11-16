Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbKPKVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 04/16] [media] dvb_frontend.h: Add a description for the header
Date: Mon, 16 Nov 2015 08:21:01 -0200
Message-Id: <b0d0e6a770c92aa0f0f1bff9242413341d538e52.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This header file provides the kABI functions used by the
Digital TV Frontend core support. Add a description for
this kABI, to add at the device_drivers Kernel DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/device-drivers.tmpl |  1 +
 drivers/media/dvb-core/dvb_frontend.h     | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index fc7242dd5d65..7b3fcc5effcd 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -244,6 +244,7 @@ X!Isound/sound_firmware.c
 !Idrivers/media/dvb-core/dvbdev.h
 	</sect1>
 	<sect1><title>Digital TV Frontend kABI</title>
+!Pdrivers/media/dvb-core/dvb_frontend.h Digital TV Frontend
 !Idrivers/media/dvb-core/dvb_frontend.h
 	</sect1>
 	<sect1><title>Digital TV Demux kABI</title>
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 5eaacaeb518f..2fa23b05749a 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -42,6 +42,29 @@
 
 #include "dvbdev.h"
 
+/**
+ * DOC: Digital TV Frontend
+ *
+ * The Digital TV Frontend kABI defines a driver-internal interface for
+ * registering low-level, hardware specific driver to a hardware independent
+ * frontend layer. It is only of interest for Digital TV device driver writers.
+ * The header file for this API is named dvb_frontend.h and located in
+ * drivers/media/dvb-core.
+ *
+ * Before using the Digital TV frontend core, the bridge driver should attach
+ * the frontend demod, tuner and SEC devices and call dvb_register_frontend(),
+ * in order to register the new frontend at the subsystem. At device
+ * detach/removal, the bridge driver should call dvb_unregister_frontend() to
+ * remove the frontend from the core and then dvb_frontend_detach() to free the
+ * memory allocated by the frontend drivers.
+ *
+ * The drivers should also call dvb_frontend_suspend() as part of their
+ * handler for the &device_driver.suspend(), and dvb_frontend_resume() as
+ * part of their handler for &device_driver.resume().
+ *
+ * A few other optional functions are provided to handle some special cases.
+ */
+
 /*
  * Maximum number of Delivery systems per frontend. It
  * should be smaller or equal to 32
-- 
2.5.0

