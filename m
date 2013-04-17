Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab3DQAnB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:43:01 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0h1MQ002426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:43:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 15/31] [media] r820t: add support for diplexer
Date: Tue, 16 Apr 2013 21:42:26 -0300
Message-Id: <1366159362-3773-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is part of the original driver, and adding it doesn't hurt,
so add it, to better sync the code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 12 ++++++++++++
 drivers/media/tuners/r820t.h |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index bb154449..5be4635 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -101,6 +101,7 @@ struct r820t_freq_range {
 };
 
 #define VCO_POWER_REF   0x02
+#define DIP_FREQ	32000000
 
 /*
  * Static constants
@@ -751,6 +752,17 @@ static int r820t_sysfreq_sel(struct r820t_priv *priv, u32 freq,
 		break;
 	}
 
+	if (priv->cfg->use_diplexer &&
+	   ((priv->cfg->rafael_chip == CHIP_R820T) ||
+	   (priv->cfg->rafael_chip == CHIP_R828S) ||
+	   (priv->cfg->rafael_chip == CHIP_R820C))) {
+		if (freq > DIP_FREQ)
+			air_cable1_in = 0x00;
+		else
+			air_cable1_in = 0x60;
+		cable2_in = 0x00;
+	}
+
 	rc = r820t_write_reg_mask(priv, 0x1d, lna_top, 0xc7);
 	if (rc < 0)
 		return rc;
diff --git a/drivers/media/tuners/r820t.h b/drivers/media/tuners/r820t.h
index a64a7b6..949575a 100644
--- a/drivers/media/tuners/r820t.h
+++ b/drivers/media/tuners/r820t.h
@@ -32,10 +32,10 @@ enum r820t_chip {
 
 struct r820t_config {
 	u8 i2c_addr;		/* 0x34 */
-
 	u32 xtal;
 	enum r820t_chip rafael_chip;
 	unsigned max_i2c_msg_len;
+	bool use_diplexer;
 };
 
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_R820T)
-- 
1.8.1.4

