Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53925 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2JMLpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Oct 2012 07:45:47 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3654663pbb.19
        for <linux-media@vger.kernel.org>; Sat, 13 Oct 2012 04:45:47 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-fimc: Fix potential NULL pointer dereference
Date: Sat, 13 Oct 2012 17:11:19 +0530
Message-Id: <1350128479-9619-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'fimc' was being dereferenced before the NULL check.
Moved it to after the check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 80ada58..61fab00 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -343,7 +343,7 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 static int fimc_register_callback(struct device *dev, void *p)
 {
 	struct fimc_dev *fimc = dev_get_drvdata(dev);
-	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
+	struct v4l2_subdev *sd;
 	struct fimc_md *fmd = p;
 	int ret = 0;
 
@@ -353,6 +353,7 @@ static int fimc_register_callback(struct device *dev, void *p)
 	if (fimc->pdev->id < 0 || fimc->pdev->id >= FIMC_MAX_DEVS)
 		return 0;
 
+	sd = &fimc->vid_cap.subdev;
 	fimc->pipeline_ops = &fimc_pipeline_ops;
 	fmd->fimc[fimc->pdev->id] = fimc;
 	sd->grp_id = FIMC_GROUP_ID;
@@ -369,7 +370,7 @@ static int fimc_register_callback(struct device *dev, void *p)
 static int fimc_lite_register_callback(struct device *dev, void *p)
 {
 	struct fimc_lite *fimc = dev_get_drvdata(dev);
-	struct v4l2_subdev *sd = &fimc->subdev;
+	struct v4l2_subdev *sd;
 	struct fimc_md *fmd = p;
 	int ret;
 
@@ -379,6 +380,7 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
 	if (fimc->index >= FIMC_LITE_MAX_DEVS)
 		return 0;
 
+	sd = &fimc->subdev;
 	fimc->pipeline_ops = &fimc_pipeline_ops;
 	fmd->fimc_lite[fimc->index] = fimc;
 	sd->grp_id = FLITE_GROUP_ID;
-- 
1.7.4.1

