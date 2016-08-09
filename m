Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:37052 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbcHIVlr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:47 -0400
Subject: [PATCH 08/12] [media] dvb_frontend: add "detach" callback
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:41 +0200
Message-ID: <147077836154.21835.3044626398530289185.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare for making "release" asynchronous (via kref).  Some operations
may need to be run synchronously in dvb_frontend_detach(), and that's
why we need a "detach" callback.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c |    1 +
 drivers/media/dvb-core/dvb_frontend.h |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 1177414..5bbe389 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2770,6 +2770,7 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
 	dvb_frontend_invoke_release(fe, fe->ops.release_sec);
 	dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release);
 	dvb_frontend_invoke_release(fe, fe->ops.analog_ops.release);
+	dvb_frontend_invoke_release(fe, fe->ops.detach);
 	dvb_frontend_invoke_release(fe, fe->ops.release);
 }
 EXPORT_SYMBOL(dvb_frontend_detach);
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 5bfb16b..d535571 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -330,7 +330,11 @@ struct dtv_frontend_properties;
  *
  * @info:		embedded struct dvb_tuner_info with tuner properties
  * @delsys:		Delivery systems supported by the frontend
- * @release:		callback function called when frontend is dettached.
+ * @detach:		callback function called when frontend is detached.
+ *			drivers should clean up, but not yet free the struct
+ *			dvb_frontend allocation.
+ * @release:		callback function called when frontend is ready to be
+ *			freed.
  *			drivers should free any allocated memory.
  * @release_sec:	callback function requesting that the Satelite Equipment
  *			Control (SEC) driver to release and free any memory
@@ -415,6 +419,7 @@ struct dvb_frontend_ops {
 
 	u8 delsys[MAX_DELSYS];
 
+	void (*detach)(struct dvb_frontend *fe);
 	void (*release)(struct dvb_frontend* fe);
 	void (*release_sec)(struct dvb_frontend* fe);
 

