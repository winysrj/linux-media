Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:34102 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaKYJdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 04:33:22 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<g.liakhovetski@gmx.de>, <voice.shen@atmel.com>,
	<nicolas.ferre@atmel.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] media: atmel-isi: increase the burst length to improve the performance
Date: Tue, 25 Nov 2014 17:30:25 +0800
Message-ID: <1416907825-23826-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The burst length could be BEATS_4/8/16. Before this patch, isi use default
value BEATS_4. To imporve the performance we could set it to BEATS_16.

Otherwise sometime it would cause the ISI overflow error.

Reported-by: Bo Shen <voice.shen@atmel.com>
Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 2 ++
 include/media/atmel-isi.h                     | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ee5650f..fda587b 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -839,6 +839,8 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	if (isi->pdata.full_mode)
 		cfg1 |= ISI_CFG1_FULL_MODE;
 
+	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
+
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
 	isi_writel(isi, ISI_CFG1, cfg1);
 
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
index c2e5703..6008b09 100644
--- a/include/media/atmel-isi.h
+++ b/include/media/atmel-isi.h
@@ -59,6 +59,10 @@
 #define		ISI_CFG1_FRATE_DIV_MASK		(7 << 8)
 #define ISI_CFG1_DISCR				(1 << 11)
 #define ISI_CFG1_FULL_MODE			(1 << 12)
+/* Definition for THMASK(ISI_V2) */
+#define		ISI_CFG1_THMASK_BEATS_4		(0 << 13)
+#define		ISI_CFG1_THMASK_BEATS_8		(1 << 13)
+#define		ISI_CFG1_THMASK_BEATS_16	(2 << 13)
 
 /* Bitfields in CFG2 */
 #define ISI_CFG2_GRAYSCALE			(1 << 13)
-- 
1.9.1

