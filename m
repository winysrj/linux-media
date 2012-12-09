Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58296 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH RFC 07/17] fc0012: enable clock output on attach()
Date: Sun,  9 Dec 2012 21:56:18 +0200
Message-Id: <1355082988-6211-7-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need feed clock to slave demodulator at the very beginning
in case of dual tuner configuration.

I am not sure if that configuration changes clock output divider
or enable clock output itself...

Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc0012.c | 7 +++++++
 drivers/media/tuners/fc0012.h | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index 636f951..1a52b76 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -460,6 +460,13 @@ struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 	if (priv->cfg->loop_through)
 		fc0012_writereg(priv, 0x09, 0x6f);
 
+	/*
+	 * TODO: Clock out en or div?
+	 * For dual tuner configuration clearing bit [0] is required.
+	 */
+	if (priv->cfg->clock_out)
+		fc0012_writereg(priv, 0x0b, 0x82);
+
 	memcpy(&fe->ops.tuner_ops, &fc0012_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
 
diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
index 891d66d..83a98e7 100644
--- a/drivers/media/tuners/fc0012.h
+++ b/drivers/media/tuners/fc0012.h
@@ -41,6 +41,11 @@ struct fc0012_config {
 	 * RF loop-through
 	 */
 	bool loop_through;
+
+	/*
+	 * clock output
+	 */
+	bool clock_out;
 };
 
 #if defined(CONFIG_MEDIA_TUNER_FC0012) || \
-- 
1.7.11.7

