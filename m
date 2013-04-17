Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab3DQAm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:59 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gxEm031269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 31/31] [media] r820t: Don't divide the IF by two
Date: Tue, 16 Apr 2013 21:42:42 -0300
Message-Id: <1366159362-3773-32-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original Win driver doesn't do; rtl-sdr also disabled that
piece of the code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 8d99779..905a106 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -559,6 +559,8 @@ static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
 	freq = freq / 1000;
 	pll_ref = priv->cfg->xtal / 1000;
 
+#if 0
+	/* Doesn't exist on rtl-sdk, and on field tests, caused troubles */
 	if ((priv->cfg->rafael_chip == CHIP_R620D) ||
 	   (priv->cfg->rafael_chip == CHIP_R828D) ||
 	   (priv->cfg->rafael_chip == CHIP_R828)) {
@@ -574,6 +576,7 @@ static int r820t_set_pll(struct r820t_priv *priv, enum v4l2_tuner_type type,
 			refdiv2 = 0x10;
 		}
 	}
+#endif
 
 	rc = r820t_write_reg_mask(priv, 0x10, refdiv2, 0x10);
 	if (rc < 0)
-- 
1.8.1.4

