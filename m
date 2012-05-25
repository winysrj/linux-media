Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48997 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab2EYRjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 13:39:23 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so1530415dad.19
        for <linux-media@vger.kernel.org>; Fri, 25 May 2012 10:39:22 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 4/4] [media] s5p-fimc: Add missing static storage class in fimc-capture.c file
Date: Fri, 25 May 2012 23:08:53 +0530
Message-Id: <1337967533-22240-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
References: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:
drivers/media/video/s5p-fimc/fimc-capture.c:1163:5: warning: symbol 'enclosed_rectangle' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 516cd5b..b7caaf5 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1160,7 +1160,7 @@ static int fimc_cap_g_selection(struct file *file, void *fh,
 }
 
 /* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
-int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
+static int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
 {
 	if (a->left < b->left || a->top < b->top)
 		return 0;
-- 
1.7.5.4

