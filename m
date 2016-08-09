Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:51785 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400AbcHIVlp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:45 -0400
Subject: [PATCH 07/12] [media] dvb_frontend: merge the two
 dvb_frontend_detach() versions
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:36 +0200
Message-ID: <147077835649.21835.12512832101795060316.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code duplication is confusing and error prone.  Let's merge them
by moving the release/dvb_detach call into one function with one
#ifdef.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c |   42 +++++++++------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index fea635b..1177414 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2754,40 +2754,22 @@ int dvb_unregister_frontend(struct dvb_frontend* fe)
 }
 EXPORT_SYMBOL(dvb_unregister_frontend);
 
-#ifdef CONFIG_MEDIA_ATTACH
-void dvb_frontend_detach(struct dvb_frontend* fe)
+static void dvb_frontend_invoke_release(struct dvb_frontend *fe,
+					void (*release)(struct dvb_frontend *fe))
 {
-	void *ptr;
-
-	if (fe->ops.release_sec) {
-		fe->ops.release_sec(fe);
-		dvb_detach(fe->ops.release_sec);
-	}
-	if (fe->ops.tuner_ops.release) {
-		fe->ops.tuner_ops.release(fe);
-		dvb_detach(fe->ops.tuner_ops.release);
-	}
-	if (fe->ops.analog_ops.release) {
-		fe->ops.analog_ops.release(fe);
-		dvb_detach(fe->ops.analog_ops.release);
-	}
-	ptr = (void*)fe->ops.release;
-	if (ptr) {
-		fe->ops.release(fe);
-		dvb_detach(ptr);
+	if (release) {
+		release(fe);
+#ifdef CONFIG_MEDIA_ATTACH
+		dvb_detach(release);
+#endif
 	}
 }
-#else
+
 void dvb_frontend_detach(struct dvb_frontend* fe)
 {
-	if (fe->ops.release_sec)
-		fe->ops.release_sec(fe);
-	if (fe->ops.tuner_ops.release)
-		fe->ops.tuner_ops.release(fe);
-	if (fe->ops.analog_ops.release)
-		fe->ops.analog_ops.release(fe);
-	if (fe->ops.release)
-		fe->ops.release(fe);
+	dvb_frontend_invoke_release(fe, fe->ops.release_sec);
+	dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release);
+	dvb_frontend_invoke_release(fe, fe->ops.analog_ops.release);
+	dvb_frontend_invoke_release(fe, fe->ops.release);
 }
-#endif
 EXPORT_SYMBOL(dvb_frontend_detach);

