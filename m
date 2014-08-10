Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 14/18] [media] xc5000: fix xc5000 suspend
Date: Sat,  9 Aug 2014 21:47:20 -0300
Message-Id: <1407631644-11990-15-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After xc5000 stops working, it waits for 5 seconds, waiting
for a new usage. Only after that it goes to low power mode.

If a suspend event happens before that, a work queue will
remain active, with causes suspend to crash.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index e135760f7d48..af137046bfe5 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1229,6 +1229,24 @@ static int xc5000_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int xc5000_suspend(struct dvb_frontend *fe)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+	int ret;
+
+	dprintk(1, "%s()\n", __func__);
+
+	cancel_delayed_work(&priv->timer_sleep);
+
+	ret = xc5000_tuner_reset(fe);
+	if (ret != 0)
+		printk(KERN_ERR
+			"xc5000: %s() unable to shutdown tuner\n",
+			__func__);
+
+	return 0;
+}
+
 static int xc5000_init(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
@@ -1293,6 +1311,7 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.release	   = xc5000_release,
 	.init		   = xc5000_init,
 	.sleep		   = xc5000_sleep,
+	.suspend	   = xc5000_suspend,
 
 	.set_config	   = xc5000_set_config,
 	.set_params	   = xc5000_set_params,
-- 
1.9.3

