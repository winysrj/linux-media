Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EYGkL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 02:40:11 -0400
Received: by pbbrp8 with SMTP id rp8so1351574pbb.19
        for <linux-media@vger.kernel.org>; Thu, 24 May 2012 23:40:10 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/3] [media] s5p-fimc: Fix compiler warning in fimc-lite.c
Date: Fri, 25 May 2012 11:59:38 +0530
Message-Id: <1337927380-4435-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the followng warning:
drivers/media/video/s5p-fimc/fimc-lite.c: In function ‘fimc_lite_streamon’:
drivers/media/video/s5p-fimc/fimc-lite.c:765:29: warning: ignoring return value
of ‘media_entity_pipeline_start’, declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-lite.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 400d701a..62faca5 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -762,7 +762,9 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 	if (fimc_lite_active(fimc))
 		return -EBUSY;
 
-	media_entity_pipeline_start(&sensor->entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(&sensor->entity, p->m_pipeline);
+	if (ret)
+		return ret;
 
 	ret = fimc_pipeline_validate(fimc);
 	if (ret) {
-- 
1.7.4.1

