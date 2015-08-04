Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:14079 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932179AbbHDJct (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 05:32:49 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	<linux-arm-kernel@lists.infradead.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v3] media: atmel-isi: parse the DT parameters for vsync/hsync/pixclock polarity
Date: Tue, 4 Aug 2015 17:37:49 +0800
Message-ID: <1438681069-16981-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will get the DT parameters of vsync/hsync/pixclock polarity, and
pass to driver.

Also add a debug information for test purpose.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v3:
- add embedded sync dt property support.

Changes in v2:
- rewrite the debug message and add pix clock polarity setup thanks to
  Laurent.
- update the commit log.

 drivers/media/platform/soc_camera/atmel-isi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index fead841..4efc939 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -1061,6 +1061,11 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
 
+	dev_dbg(icd->parent, "vsync active %s, hsync active %s, sampling on pix clock %s edge\n",
+		common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" : "high",
+		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" : "high",
+		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ? "falling" : "rising");
+
 	if (isi->pdata.has_emb_sync)
 		cfg1 |= ISI_CFG1_EMB_SYNC;
 	if (isi->pdata.full_mode)
@@ -1148,6 +1153,16 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
 		return -EINVAL;
 	}
 
+	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+		isi->pdata.hsync_act_low = true;
+	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+		isi->pdata.vsync_act_low = true;
+	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		isi->pdata.pclk_act_falling = true;
+
+	if (ep.bus_type == V4L2_MBUS_BT656)
+		isi->pdata.has_emb_sync = true;
+
 	return 0;
 }
 
-- 
1.9.1

