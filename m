Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44957 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbKPKVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH 02/16] [media] Document the obscure dvb_frontend_reinitialise()
Date: Mon, 16 Nov 2015 08:20:59 -0200
Message-Id: <660472ba238e2b758745515892fd04d1d5e128a5.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_frontend_reinitialise() function is a special case
used by just one frontend. Document it, for completeness.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 9f724f4571f3..c068bce274e4 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -694,11 +694,24 @@ extern int dvb_unregister_frontend(struct dvb_frontend *fe);
 
 extern void dvb_frontend_detach(struct dvb_frontend *fe);
 
-extern void dvb_frontend_reinitialise(struct dvb_frontend *fe);
 extern int dvb_frontend_suspend(struct dvb_frontend *fe);
 extern int dvb_frontend_resume(struct dvb_frontend *fe);
 
 /**
+ * dvb_frontend_reinitialise() - forces a reinitialisation at the frontend
+ *
+ * @fe: pointer to the frontend struct
+ *
+ * Calls &dvb_frontend_ops.init() and &dvb_frontend_ops.tuner_ops.init(),
+ * and resets SEC tone and voltage (for Satellite systems).
+ *
+ * NOTE: Currently, this function is used only by one driver (budget-av).
+ * It seems to be due to address some special issue with that specific
+ * frontend.
+ */
+void dvb_frontend_reinitialise(struct dvb_frontend *fe);
+
+/**
  * dvb_frontend_sleep_until() - Sleep for the amount of time given by
  *                      add_usec parameter
  *
-- 
2.5.0

