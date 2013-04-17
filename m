Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab3DQAmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:54 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gsXt031256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 30/31] [media] r820t: disable auto gain/VGA setting
Date: Tue, 16 Apr 2013 21:42:41 -0300
Message-Id: <1366159362-3773-31-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On field tests, the auto gain routine is not working, nor it is
used by the original driver. Let's comment it for now.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index e63ee94..8d99779 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1163,6 +1163,8 @@ static int r820t_read_gain(struct r820t_priv *priv)
 	return ((data[3] & 0x0f) << 1) + ((data[3] & 0xf0) >> 4);
 }
 
+#if 0
+/* FIXME: This routine requires more testing */
 static int r820t_set_gain_mode(struct r820t_priv *priv,
 			       bool set_manual_gain,
 			       int gain)
@@ -1233,7 +1235,7 @@ static int r820t_set_gain_mode(struct r820t_priv *priv,
 
 	return 0;
 }
-
+#endif
 
 static int generic_set_freq(struct dvb_frontend *fe,
 			    u32 freq /* in HZ */,
@@ -1261,10 +1263,6 @@ static int generic_set_freq(struct dvb_frontend *fe,
 	if (rc < 0)
 		goto err;
 
-	rc = r820t_set_gain_mode(priv, false, 0);
-	if (rc < 0)
-		goto err;
-
 	rc = r820t_set_pll(priv, type, lo_freq);
 	if (rc < 0 || !priv->has_lock)
 		goto err;
-- 
1.8.1.4

