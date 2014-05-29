Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbaE2MUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 08:20:24 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/5] dvbdev: add a dvb_detach() macro
Date: Thu, 29 May 2014 09:20:13 -0300
Message-Id: <1401366017-19874-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1401366017-19874-1-git-send-email-m.chehab@samsung.com>
References: <1401366017-19874-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_attach() was unbalanced, as there was no dvb_dettach. Ok,
on current cases, the dettach is done by dvbdev, but that are some
future corner cases where we may need to do this before registering
the frontend.

So, add a dvb_detach() and use it at dvb_frontend.c.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 8 ++++----
 drivers/media/dvb-core/dvbdev.h       | 4 ++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6ce435ac866f..6cc2631d8f0e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2666,20 +2666,20 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
 
 	if (fe->ops.release_sec) {
 		fe->ops.release_sec(fe);
-		symbol_put_addr(fe->ops.release_sec);
+		dvb_detach(fe->ops.release_sec);
 	}
 	if (fe->ops.tuner_ops.release) {
 		fe->ops.tuner_ops.release(fe);
-		symbol_put_addr(fe->ops.tuner_ops.release);
+		dvb_detach(fe->ops.tuner_ops.release);
 	}
 	if (fe->ops.analog_ops.release) {
 		fe->ops.analog_ops.release(fe);
-		symbol_put_addr(fe->ops.analog_ops.release);
+		dvb_detach(fe->ops.analog_ops.release);
 	}
 	ptr = (void*)fe->ops.release;
 	if (ptr) {
 		fe->ops.release(fe);
-		symbol_put_addr(ptr);
+		dvb_detach(ptr);
 	}
 }
 #else
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 93a9470d3f0c..f96b28e7fc95 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -136,11 +136,15 @@ extern int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	__r; \
 })
 
+#define dvb_detach(FUNC)	symbol_put_addr(FUNC)
+
 #else
 #define dvb_attach(FUNCTION, ARGS...) ({ \
 	FUNCTION(ARGS); \
 })
 
+#define dvb_detach(FUNC)	{}
+
 #endif
 
 #endif /* #ifndef _DVBDEV_H_ */
-- 
1.9.3

