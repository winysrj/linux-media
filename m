Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54368 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161082AbbKSUE6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:04:58 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 05/10] si2165: move setting ts config to init
Date: Thu, 19 Nov 2015 21:03:57 +0100
Message-Id: <1447963442-9764-6-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TS config is fixed, so no need to write it for each tune.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 07247e3..0c1f4c4 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -690,6 +690,20 @@ static int si2165_init(struct dvb_frontend *fe)
 			goto error;
 	}
 
+	/* ts output config */
+	ret = si2165_writereg8(state, 0x04e4, 0x20);
+	if (ret < 0)
+		return ret;
+	ret = si2165_writereg16(state, 0x04ef, 0x00fe);
+	if (ret < 0)
+		return ret;
+	ret = si2165_writereg24(state, 0x04f4, 0x555555);
+	if (ret < 0)
+		return ret;
+	ret = si2165_writereg8(state, 0x04e5, 0x01);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 error:
 	return ret;
@@ -824,19 +838,6 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	ret = si2165_writereg8(state, 0x08f8, 0x00);
 	if (ret < 0)
 		return ret;
-	/* ts output config */
-	ret = si2165_writereg8(state, 0x04e4, 0x20);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg16(state, 0x04ef, 0x00fe);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg24(state, 0x04f4, 0x555555);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x04e5, 0x01);
-	if (ret < 0)
-		return ret;
 	/* bandwidth in 10KHz steps */
 	ret = si2165_writereg16(state, 0x0308, bw10k);
 	if (ret < 0)
-- 
2.6.3

