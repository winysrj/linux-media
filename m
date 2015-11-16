Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbbKPKVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:25 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/16] [media] dvb_frontend: document the most used functions
Date: Mon, 16 Nov 2015 08:21:00 -0200
Message-Id: <6e4861e774caf50e95a2479f17251550ae5cc1e1.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documents the most used functions at the Digital TV
kABI: dvb_frontend_register(), dvb_frontend_unregister()
and dvb_frontend_detach().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 43 ++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index c068bce274e4..5eaacaeb518f 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -687,12 +687,49 @@ struct dvb_frontend {
 	unsigned int exit;
 };
 
-extern int dvb_register_frontend(struct dvb_adapter *dvb,
+/**
+ * dvb_register_frontend() - Registers a DVB frontend at the adapter
+ *
+ * @dvb: pointer to the dvb adapter
+ * @fe: pointer to the frontend struct
+ *
+ * Allocate and initialize the private data needed by the frontend core to
+ * manage the frontend and calls dvb_register_device() to register a new
+ * frontend. It also cleans the property cache that stores the frontend
+ * parameters and selects the first available delivery system.
+ */
+int dvb_register_frontend(struct dvb_adapter *dvb,
 				 struct dvb_frontend *fe);
 
-extern int dvb_unregister_frontend(struct dvb_frontend *fe);
+/**
+ * dvb_unregister_frontend() - Unregisters a DVB frontend
+ *
+ * @fe: pointer to the frontend struct
+ *
+ * Stops the frontend kthread, calls dvb_unregister_device() and frees the
+ * private frontend data allocated by dvb_register_frontend().
+ *
+ * NOTE: This function doesn't frees the memory allocated by the demod,
+ * by the SEC driver and by the tuner. In order to free it, an explicit call to
+ * dvb_frontend_detach() is needed, after calling this function.
+ */
+int dvb_unregister_frontend(struct dvb_frontend *fe);
 
-extern void dvb_frontend_detach(struct dvb_frontend *fe);
+/**
+ * dvb_frontend_detach() - Detaches and frees frontend specific data
+ *
+ * @fe: pointer to the frontend struct
+ *
+ * This function should be called after dvb_unregister_frontend(). It
+ * calls the SEC, tuner and demod release functions:
+ * &dvb_frontend_ops.release_sec, &dvb_frontend_ops.tuner_ops.release,
+ * &dvb_frontend_ops.analog_ops.release and &dvb_frontend_ops.release.
+ *
+ * If the driver is compiled with CONFIG_MEDIA_ATTACH, it also decreases
+ * the module reference count, needed to allow userspace to remove the
+ * previously used DVB frontend modules.
+ */
+void dvb_frontend_detach(struct dvb_frontend *fe);
 
 extern int dvb_frontend_suspend(struct dvb_frontend *fe);
 extern int dvb_frontend_resume(struct dvb_frontend *fe);
-- 
2.5.0

