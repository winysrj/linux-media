Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720Ab3DYTIH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 15:08:07 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PJ87dl011814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 15:08:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] r820t: Remove a warning for an unused value
Date: Thu, 25 Apr 2013 16:07:59 -0300
Message-Id: <1366916882-3565-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the driver complains about the pre_detect var:

	drivers/media/tuners/r820t.c: In function 'r820t_sysfreq_sel':
	drivers/media/tuners/r820t.c:722:31: warning: variable 'pre_dect' set but not used [-Wunused-but-set-variable]

While rtl8232 code comments it, perhaps some other driver may use.
So, the better is to keep the code there, allowing to enable it
via r820t config data.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 7 +++++++
 drivers/media/tuners/r820t.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index e6e7a06..4835021 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -797,6 +797,13 @@ static int r820t_sysfreq_sel(struct r820t_priv *priv, u32 freq,
 		cable2_in = 0x00;
 	}
 
+
+	if (priv->cfg->use_predetect) {
+		rc = r820t_write_reg_mask(priv, 0x06, pre_dect, 0x40);
+		if (rc < 0)
+			return rc;
+	}
+
 	rc = r820t_write_reg_mask(priv, 0x1d, lna_top, 0xc7);
 	if (rc < 0)
 		return rc;
diff --git a/drivers/media/tuners/r820t.h b/drivers/media/tuners/r820t.h
index 4c0823b..48af354 100644
--- a/drivers/media/tuners/r820t.h
+++ b/drivers/media/tuners/r820t.h
@@ -39,6 +39,7 @@ struct r820t_config {
 	enum r820t_chip rafael_chip;
 	unsigned max_i2c_msg_len;
 	bool use_diplexer;
+	bool use_predetect;
 };
 
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_R820T)
-- 
1.8.1.4

