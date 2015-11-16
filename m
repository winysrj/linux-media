Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44960 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbbKPKVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH 07/16] [media] dvb_frontend.h: Document suspend/resume functions
Date: Mon, 16 Nov 2015 08:21:04 -0200
Message-Id: <60bae34212cdc0c1729ec24ff944b20897a51d91.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those functions should be implemented on all drivers. So, document
them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 40 +++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 2fa23b05749a..7c99a9190574 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -754,8 +754,44 @@ int dvb_unregister_frontend(struct dvb_frontend *fe);
  */
 void dvb_frontend_detach(struct dvb_frontend *fe);
 
-extern int dvb_frontend_suspend(struct dvb_frontend *fe);
-extern int dvb_frontend_resume(struct dvb_frontend *fe);
+/**
+ * dvb_frontend_suspend() - Suspends a Digital TV frontend
+ *
+ * @fe: pointer to the frontend struct
+ *
+ * This function prepares a Digital TV frontend to suspend.
+ *
+ * In order to prepare the tuner to suspend, if
+ * &dvb_frontend_ops.tuner_ops.suspend() is available, it calls it. Otherwise,
+ * it will call &dvb_frontend_ops.tuner_ops.sleep(), if available.
+ *
+ * It will also call &dvb_frontend_ops.sleep() to put the demod to suspend.
+ *
+ * The drivers should also call dvb_frontend_suspend() as part of their
+ * handler for the &device_driver.suspend().
+ */
+int dvb_frontend_suspend(struct dvb_frontend *fe);
+
+/**
+ * dvb_frontend_resume() - Resumes a Digital TV frontend
+ *
+ * @fe: pointer to the frontend struct
+ *
+ * This function resumes the usual operation of the tuner after resume.
+ *
+ * In order to resume the frontend, it calls the demod &dvb_frontend_ops.init().
+ *
+ * If &dvb_frontend_ops.tuner_ops.resume() is available, It, it calls it.
+ * Otherwise,t will call &dvb_frontend_ops.tuner_ops.init(), if available.
+ *
+ * Once tuner and demods are resumed, it will enforce that the SEC voltage and
+ * tone are restored to their previous values and wake up the frontend's
+ * kthread in order to retune the frontend.
+ *
+ * The drivers should also call dvb_frontend_resume() as part of their
+ * handler for the &device_driver.resume().
+ */
+int dvb_frontend_resume(struct dvb_frontend *fe);
 
 /**
  * dvb_frontend_reinitialise() - forces a reinitialisation at the frontend
-- 
2.5.0

