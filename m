Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45779 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2JQLQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:52 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so7059174pbb.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 04:16:51 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 8/8] [media] s5p-fimc: Make 'fimc_pipeline_s_stream' function static
Date: Wed, 17 Oct 2012 16:41:51 +0530
Message-Id: <1350472311-9748-8-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:
drivers/media/platform/s5p-fimc/fimc-mdevice.c:216:5: warning:
symbol 'fimc_pipeline_s_stream' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index e1f7cbe..0cd05b2 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -213,7 +213,7 @@ static int fimc_pipeline_close(struct fimc_pipeline *p)
  * @pipeline: video pipeline structure
  * @on: passed as the s_stream call argument
  */
-int fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
+static int fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 {
 	int i, ret;
 
-- 
1.7.4.1

