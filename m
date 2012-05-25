Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EYGkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 02:40:13 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so1351574pbb.19
        for <linux-media@vger.kernel.org>; Thu, 24 May 2012 23:40:13 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/3] [media] s5p-fimc: Fix compiler warning in fimc-capture.c file
Date: Fri, 25 May 2012 11:59:39 +0530
Message-Id: <1337927380-4435-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1337927380-4435-1-git-send-email-sachin.kamat@linaro.org>
References: <1337927380-4435-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/video/s5p-fimc/fimc-capture.c: In function ‘fimc_cap_streamon’:
drivers/media/video/s5p-fimc/fimc-capture.c:1053:29: warning: ignoring return
value of ‘media_entity_pipeline_start’, declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 3545745..587d087 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1050,8 +1050,10 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	media_entity_pipeline_start(&p->subdevs[IDX_SENSOR]->entity,
+	ret = media_entity_pipeline_start(&p->subdevs[IDX_SENSOR]->entity,
 				    p->m_pipeline);
+	if (ret)
+		return ret;
 
 	if (fimc->vid_cap.user_subdev_api) {
 		ret = fimc_pipeline_validate(fimc);
-- 
1.7.4.1

