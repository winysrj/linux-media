Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934549Ab3DGXxt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Apr 2013 19:53:49 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r37NrnpB012338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 7 Apr 2013 19:53:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH 1/5] r820t: Give a better estimation of the signal strength
Date: Sun,  7 Apr 2013 20:53:26 -0300
Message-Id: <1365378810-1637-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
References: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of a binary signal strength measure, use the tuner gain
to obtain a better estimation of the signal strength.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 7e02920..ed9cd65 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1082,6 +1082,18 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 	return 0;
 }
 
+static int r820t_read_gain(struct r820t_priv *priv)
+{
+	u8 data[4];
+	int rc;
+
+	rc = r820_read(priv, 0x00, data, sizeof(data));
+	if (rc < 0)
+		return rc;
+
+	return ((data[3] & 0x0f) << 1) + ((data[3] & 0xf0) >> 4);
+}
+
 static int generic_set_freq(struct dvb_frontend *fe,
 			    u32 freq /* in HZ */,
 			    unsigned bw,
@@ -1353,11 +1365,23 @@ static int r820t_set_params(struct dvb_frontend *fe)
 static int r820t_signal(struct dvb_frontend *fe, u16 *strength)
 {
 	struct r820t_priv *priv = fe->tuner_priv;
+	int rc = 0;
 
-	if (priv->has_lock)
-		*strength = 0xffff;
-	else
+	if (priv->has_lock) {
+		rc = r820t_read_gain(priv);
+		if (rc < 0)
+			return rc;
+
+		/* A higher gain at LNA means a lower signal strength */
+		*strength = (45 - rc) << 4 | 0xff;
+	} else {
 		*strength = 0;
+	}
+
+	tuner_dbg("%s: %s, gain=%d strength=%d\n",
+		  __func__,
+		  priv->has_lock ? "PLL locked" : "no signal",
+		  rc, *strength);
 
 	return 0;
 }
-- 
1.8.1.4

