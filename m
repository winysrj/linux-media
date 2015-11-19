Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54364 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161082AbbKSUE4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:04:56 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 04/10] si2165: only write agc registers after reset before start_syncro
Date: Thu, 19 Nov 2015 21:03:56 +0100
Message-Id: <1447963442-9764-5-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Datasheet says they must be rewritten after reset.
But it only makes sense to write them when trying to tune afterwards.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 222d775..07247e3 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -690,23 +690,6 @@ static int si2165_init(struct dvb_frontend *fe)
 			goto error;
 	}
 
-	/* write adc values after each reset*/
-	ret = si2165_writereg8(state, 0x012a, 0x46);
-	if (ret < 0)
-		goto error;
-	ret = si2165_writereg8(state, 0x012c, 0x00);
-	if (ret < 0)
-		goto error;
-	ret = si2165_writereg8(state, 0x012e, 0x0a);
-	if (ret < 0)
-		goto error;
-	ret = si2165_writereg8(state, 0x012f, 0xff);
-	if (ret < 0)
-		goto error;
-	ret = si2165_writereg8(state, 0x0123, 0x70);
-	if (ret < 0)
-		goto error;
-
 	return 0;
 error:
 	return ret;
@@ -788,6 +771,14 @@ static int si2165_set_if_freq_shift(struct si2165_state *state, u32 IF)
 	return si2165_writereg32(state, 0x00e8, reg_value);
 }
 
+static const struct si2165_reg_value_pair agc_rewrite[] = {
+	{ 0x012a, 0x46 },
+	{ 0x012c, 0x00 },
+	{ 0x012e, 0x0a },
+	{ 0x012f, 0xff },
+	{ 0x0123, 0x70 }
+};
+
 static int si2165_set_frontend(struct dvb_frontend *fe)
 {
 	int ret;
@@ -924,6 +915,13 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	ret = si2165_writereg32(state, 0x0384, 0x00000000);
 	if (ret < 0)
 		return ret;
+
+	/* write adc values after each reset*/
+	ret = si2165_write_reg_list(state, agc_rewrite,
+				    ARRAY_SIZE(agc_rewrite));
+	if (ret < 0)
+		return ret;
+
 	/* start_synchro */
 	ret = si2165_writereg8(state, 0x02e0, 0x01);
 	if (ret < 0)
-- 
2.6.3

