Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36763 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2HPLyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 07:54:51 -0400
Received: by ghrr11 with SMTP id r11so2781842ghr.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 04:54:49 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	andrzej.p@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH Trivial] [media] s5p-jpeg: Add missing braces around sizeof
Date: Thu, 16 Aug 2012 17:22:58 +0530
Message-Id: <1345117978-3374-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following warning:
WARNING: sizeof *ctx should be sizeof(*ctx)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 72c3e52..ae916cd 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -288,7 +288,7 @@ static int s5p_jpeg_open(struct file *file)
 	struct s5p_jpeg_fmt *out_fmt;
 	int ret = 0;
 
-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-- 
1.7.4.1

