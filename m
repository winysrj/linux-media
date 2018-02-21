Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:60481 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S937941AbeBUPcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:32:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 02/15] vimc: use correct subdev functions
Date: Wed, 21 Feb 2018 16:32:05 +0100
Message-Id: <20180221153218.15654-3-hverkuil@xs4all.nl>
In-Reply-To: <20180221153218.15654-1-hverkuil@xs4all.nl>
References: <20180221153218.15654-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of calling everything a MEDIA_ENT_F_ATV_DECODER, pick the
correct functions for these blocks.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/vimc/vimc-debayer.c | 2 +-
 drivers/media/platform/vimc/vimc-scaler.c  | 2 +-
 drivers/media/platform/vimc/vimc-sensor.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
index 4d663e89d33f..6e10b63ba9ec 100644
--- a/drivers/media/platform/vimc/vimc-debayer.c
+++ b/drivers/media/platform/vimc/vimc-debayer.c
@@ -533,7 +533,7 @@ static int vimc_deb_comp_bind(struct device *comp, struct device *master,
 	/* Initialize ved and sd */
 	ret = vimc_ent_sd_register(&vdeb->ved, &vdeb->sd, v4l2_dev,
 				   pdata->entity_name,
-				   MEDIA_ENT_F_ATV_DECODER, 2,
+				   MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV, 2,
 				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
 				   MEDIA_PAD_FL_SOURCE},
 				   &vimc_deb_ops);
diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
index e1602e0bc230..e583ec7a91da 100644
--- a/drivers/media/platform/vimc/vimc-scaler.c
+++ b/drivers/media/platform/vimc/vimc-scaler.c
@@ -395,7 +395,7 @@ static int vimc_sca_comp_bind(struct device *comp, struct device *master,
 	/* Initialize ved and sd */
 	ret = vimc_ent_sd_register(&vsca->ved, &vsca->sd, v4l2_dev,
 				   pdata->entity_name,
-				   MEDIA_ENT_F_ATV_DECODER, 2,
+				   MEDIA_ENT_F_PROC_VIDEO_SCALER, 2,
 				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
 				   MEDIA_PAD_FL_SOURCE},
 				   &vimc_sca_ops);
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 54184cd9e0ff..605e2a2d5dd5 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -386,7 +386,7 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
 	/* Initialize ved and sd */
 	ret = vimc_ent_sd_register(&vsen->ved, &vsen->sd, v4l2_dev,
 				   pdata->entity_name,
-				   MEDIA_ENT_F_ATV_DECODER, 1,
+				   MEDIA_ENT_F_CAM_SENSOR, 1,
 				   (const unsigned long[1]) {MEDIA_PAD_FL_SOURCE},
 				   &vimc_sen_ops);
 	if (ret)
-- 
2.16.1
