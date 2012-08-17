Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2HQGaY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 02:30:24 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so2835582pbb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 23:30:24 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH-Trivial 2/2] [media] s5p-fimc: Add missing braces around sizeof
Date: Fri, 17 Aug 2012 11:58:27 +0530
Message-Id: <1345184907-8317-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1345184907-8317-1-git-send-email-sachin.kamat@linaro.org>
References: <1345184907-8317-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following warning:
WARNING: sizeof *ctx should be sizeof(*ctx)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 8e413dd..5283957 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1593,7 +1593,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	struct vb2_queue *q;
 	int ret = -ENOMEM;

-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;

diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index c587011..1b1e564 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -661,7 +661,7 @@ static int fimc_m2m_open(struct file *file)
 	if (fimc->vid_cap.refcnt > 0)
 		goto unlock;

-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
 		ret = -ENOMEM;
 		goto unlock;
--
1.7.4.1

