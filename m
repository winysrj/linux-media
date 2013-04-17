Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab3DQAm4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:56 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gtAm021070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 18/31] [media] r820t: fix prefix of the r820t_read() function
Date: Tue, 16 Apr 2013 21:42:29 -0300
Message-Id: <1366159362-3773-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just cosmetic changes: all other functions are prefixed
by r820t. Do the same for r820t_read().

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index ef100ab..e9367d8 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -425,7 +425,7 @@ static int r820t_write_reg_mask(struct r820t_priv *priv, u8 reg, u8 val,
 	return r820t_write(priv, reg, &val, 1);
 }
 
-static int r820_read(struct r820t_priv *priv, u8 reg, u8 *val, int len)
+static int r820t_read(struct r820t_priv *priv, u8 reg, u8 *val, int len)
 {
 	int rc, i;
 	u8 *p = &priv->buf[1];
@@ -573,7 +573,7 @@ static int r820t_set_pll(struct r820t_priv *priv, u32 freq)
 		mix_div = mix_div << 1;
 	}
 
-	rc = r820_read(priv, 0x00, data, sizeof(data));
+	rc = r820t_read(priv, 0x00, data, sizeof(data));
 	if (rc < 0)
 		return rc;
 
@@ -660,7 +660,7 @@ static int r820t_set_pll(struct r820t_priv *priv, u32 freq)
 		msleep(10);
 
 		/* Check if PLL has locked */
-		rc = r820_read(priv, 0x00, data, 3);
+		rc = r820t_read(priv, 0x00, data, 3);
 		if (rc < 0)
 			return rc;
 		if (data[2] & 0x40)
@@ -1062,7 +1062,7 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 				return rc;
 
 			/* Check if calibration worked */
-			rc = r820_read(priv, 0x00, data, sizeof(data));
+			rc = r820t_read(priv, 0x00, data, sizeof(data));
 			if (rc < 0)
 				return rc;
 
@@ -1135,7 +1135,7 @@ static int r820t_read_gain(struct r820t_priv *priv)
 	u8 data[4];
 	int rc;
 
-	rc = r820_read(priv, 0x00, data, sizeof(data));
+	rc = r820t_read(priv, 0x00, data, sizeof(data));
 	if (rc < 0)
 		return rc;
 
@@ -1163,7 +1163,7 @@ static int r820t_set_gain_mode(struct r820t_priv *priv,
 		if (rc < 0)
 			return rc;
 
-		rc = r820_read(priv, 0x00, data, sizeof(data));
+		rc = r820t_read(priv, 0x00, data, sizeof(data));
 		if (rc < 0)
 			return rc;
 
@@ -1349,7 +1349,7 @@ static int r820t_xtal_check(struct r820t_priv *priv)
 
 		msleep(5);
 
-		rc = r820_read(priv, 0x00, data, sizeof(data));
+		rc = r820t_read(priv, 0x00, data, sizeof(data));
 		if (rc < 0)
 			return rc;
 		if ((!data[2]) & 0x40)
@@ -1621,7 +1621,7 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	/* check if the tuner is there */
-	rc = r820_read(priv, 0x00, data, sizeof(data));
+	rc = r820t_read(priv, 0x00, data, sizeof(data));
 	if (rc < 0)
 		goto err;
 
-- 
1.8.1.4

