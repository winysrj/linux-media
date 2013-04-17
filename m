Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab3DQAnB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:43:01 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0h0DY031275
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:43:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 24/31] [media] r820t: avoid rewrite all regs when not needed
Date: Tue, 16 Apr 2013 21:42:35 -0300
Message-Id: <1366159362-3773-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 2e6a690..fc660f2 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -2006,18 +2006,17 @@ static int r820t_imr_callibrate(struct r820t_priv *priv)
 	if (priv->init_done)
 		return 0;
 
-	/* Initialize registers */
-	rc = r820t_write(priv, 0x05,
-			 r820t_init_array, sizeof(r820t_init_array));
-	if (rc < 0)
-		return rc;
-
 	/* Detect Xtal capacitance */
 	if ((priv->cfg->rafael_chip == CHIP_R820T) ||
 	    (priv->cfg->rafael_chip == CHIP_R828S) ||
 	    (priv->cfg->rafael_chip == CHIP_R820C)) {
 		priv->xtal_cap_sel = XTAL_HIGH_CAP_0P;
 	} else {
+		/* Initialize registers */
+		rc = r820t_write(priv, 0x05,
+				r820t_init_array, sizeof(r820t_init_array));
+		if (rc < 0)
+			return rc;
 		for (i = 0; i < 3; i++) {
 			rc = r820t_xtal_check(priv);
 			if (rc < 0)
-- 
1.8.1.4

