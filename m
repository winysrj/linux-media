Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:23058 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbbGaK20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 06:28:26 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	<linux-arm-kernel@lists.infradead.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] media: atmel-isi: parse the DT parameters for vsync/hsync polarity
Date: Fri, 31 Jul 2015 18:33:32 +0800
Message-ID: <1438338812-22329-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will get the DT parameters of vsync/hsync polarity, and pass to
the platform data.

Also add a debug information for test purpose.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index fe9247a..a7de55c 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -811,6 +811,11 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
 
+	dev_dbg(icd->parent, "vsync is active %s, hsyc is active %s, pix clock is sampling %s\n",
+		common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" : "high",
+		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" : "high",
+		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ? "fall" : "rise");
+
 	if (isi->pdata.has_emb_sync)
 		cfg1 |= ISI_CFG1_EMB_SYNC;
 	if (isi->pdata.full_mode)
@@ -898,6 +903,11 @@ static int atmel_isi_probe_dt(struct atmel_isi *isi,
 		goto err_probe_dt;
 	}
 
+	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+		isi->pdata.hsync_act_low = true;
+	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+		isi->pdata.vsync_act_low = true;
+
 err_probe_dt:
 	of_node_put(np);
 
-- 
1.9.1

