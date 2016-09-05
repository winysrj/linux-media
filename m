Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932483AbcIEKcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 04/12] [media] mb86a20s: fix the locking logic
Date: Mon,  5 Sep 2016 07:32:32 -0300
Message-Id: <15155db2de50cd9ceaa896a21a877211c1837b1c.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

On this frontend, it takes a while to start output normal
TS data. That only happens on state S9. On S8, the TS output
is enabled, but it is not reliable enough.

However, the zigzag loop is too fast to let it sync.

As, on practical tests, the zigzag software loop doesn't
seem to be helping, but just slowing down the tuning, let's
switch to hardware algorithm, as the tuners used on such
devices are capable of work with frequency drifts without
any help from software.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index fb88dddaf3a3..66939eca445b 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -317,7 +317,11 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	if (val >= 7)
 		*status |= FE_HAS_SYNC;
 
-	if (val >= 8)				/* Maybe 9? */
+	/*
+	 * Actually, on state S8, it starts receiving TS, but the TS
+	 * output is only on normal state after the transition to S9.
+	 */
+	if (val >= 9)
 		*status |= FE_HAS_LOCK;
 
 	dev_dbg(&state->i2c->dev, "%s: Status = 0x%02x (state = %d)\n",
@@ -2057,6 +2061,11 @@ static void mb86a20s_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
+static int mb86a20s_get_frontend_algo(struct dvb_frontend *fe)
+{
+        return DVBFE_ALGO_HW;
+}
+
 static struct dvb_frontend_ops mb86a20s_ops;
 
 struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
@@ -2129,6 +2138,7 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 	.read_status = mb86a20s_read_status_and_stats,
 	.read_signal_strength = mb86a20s_read_signal_strength_from_cache,
 	.tune = mb86a20s_tune,
+	.get_frontend_algo = mb86a20s_get_frontend_algo,
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Fujitsu mb86A20s hardware");
-- 
2.7.4


