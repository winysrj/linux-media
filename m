Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50247 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758881Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH RFC 12/17] fc0012: remove unused callback and correct one comment
Date: Sun,  9 Dec 2012 21:56:23 +0200
Message-Id: <1355082988-6211-12-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to keep dummy sleep() callback implementation as
DVB-core checks existence of it before calls callback. Due to that
we can remove it.

FC0012 is based of direct-conversion receiver architecture
(aka Zero-IF) where is no IF used. Due to that IF is always 0 Hz.
Fix comment to point that.

Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc0012.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index 4491f06..f4d0e79 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -129,12 +129,6 @@ static int fc0012_init(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int fc0012_sleep(struct dvb_frontend *fe)
-{
-	/* nothing to do here */
-	return 0;
-}
-
 static int fc0012_set_params(struct dvb_frontend *fe)
 {
 	struct fc0012_priv *priv = fe->tuner_priv;
@@ -343,8 +337,7 @@ static int fc0012_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static int fc0012_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	/* CHECK: always ? */
-	*frequency = 0;
+	*frequency = 0; /* Zero-IF */
 	return 0;
 }
 
@@ -437,7 +430,6 @@ static const struct dvb_tuner_ops fc0012_tuner_ops = {
 	.release	= fc0012_release,
 
 	.init		= fc0012_init,
-	.sleep		= fc0012_sleep,
 
 	.set_params	= fc0012_set_params,
 
-- 
1.7.11.7

