Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59805 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EYGkR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 02:40:17 -0400
Received: by dady13 with SMTP id y13so843812dad.19
        for <linux-media@vger.kernel.org>; Thu, 24 May 2012 23:40:16 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/3] [media] s5p-fimc: Stop media entity pipeline if fimc_pipeline_validate fails
Date: Fri, 25 May 2012 11:59:40 +0530
Message-Id: <1337927380-4435-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1337927380-4435-1-git-send-email-sachin.kamat@linaro.org>
References: <1337927380-4435-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stops the media entity pipeline which was started earlier
if fimc_pipeline_validate fails.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 587d087..d9efa64 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1057,8 +1057,10 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 
 	if (fimc->vid_cap.user_subdev_api) {
 		ret = fimc_pipeline_validate(fimc);
-		if (ret)
+		if (ret) {
+			media_entity_pipeline_stop(&p->subdevs[IDX_SENSOR]->entity);
 			return ret;
+		}
 	}
 	return vb2_streamon(&fimc->vid_cap.vbq, type);
 }
-- 
1.7.4.1

