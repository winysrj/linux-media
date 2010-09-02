Return-path: <mchehab@localhost>
Received: from arroyo.ext.ti.com ([192.94.94.40]:59966 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab0IBOqa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Sep 2010 10:46:30 -0400
From: raja_mani@ti.com
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mchehab@infradead.org
Cc: matti.j.aaltonen@nokia.com, Raja Mani <raja_mani@ti.com>,
	Pramodh AG <pramodh_ag@ti.com>
Subject: [RFC/PATCH 4/8] drivers:staging:ti-st: Move get region func to FM RX module.
Date: Thu,  2 Sep 2010 11:57:56 -0400
Message-Id: <1283443080-30644-5-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-4-git-send-email-raja_mani@ti.com>
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com>
 <1283443080-30644-2-git-send-email-raja_mani@ti.com>
 <1283443080-30644-3-git-send-email-raja_mani@ti.com>
 <1283443080-30644-4-git-send-email-raja_mani@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

From: Raja Mani <raja_mani@ti.com>

fm_rx_get_region() API is specific to FM RX module, So
moving this from FM Common module to FM RX module.

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
---
 drivers/staging/ti-st/fmdrv_rx.c |    7 +++++++
 drivers/staging/ti-st/fmdrv_rx.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ti-st/fmdrv_rx.c b/drivers/staging/ti-st/fmdrv_rx.c
index a9df59f..1213927 100644
--- a/drivers/staging/ti-st/fmdrv_rx.c
+++ b/drivers/staging/ti-st/fmdrv_rx.c
@@ -319,6 +319,13 @@ int fm_rx_get_currband_lowhigh_freq(struct fmdrv_ops *fmdev,
 	return 0;
 }
 
+/* Returns current band index (0-Europe/US; 1-Japan) */
+int fm_rx_get_region(struct fmdrv_ops *fmdev, unsigned char *region)
+{
+	*region = fmdev->rx.region.region_index;
+	return 0;
+}
+
 /* Sets band (0-Europe/US; 1-Japan) */
 int fm_rx_set_region(struct fmdrv_ops *fmdev,
 			unsigned char region_to_set)
diff --git a/drivers/staging/ti-st/fmdrv_rx.h b/drivers/staging/ti-st/fmdrv_rx.h
index 2ca3eda..e89a175 100644
--- a/drivers/staging/ti-st/fmdrv_rx.h
+++ b/drivers/staging/ti-st/fmdrv_rx.h
@@ -51,6 +51,7 @@ int fm_rx_get_rssi_threshold(struct fmdrv_ops *, short*);
 int fm_rx_get_rfdepend_softmute(struct fmdrv_ops *, unsigned char*);
 int fm_rx_get_deemphasis_mode(struct fmdrv_ops *, unsigned short*);
 int fm_rx_get_af_switch(struct fmdrv_ops *, unsigned char *);
+int fm_rx_get_region(struct fmdrv_ops*, unsigned char*);
 
 #endif
 
-- 
1.5.6.3

