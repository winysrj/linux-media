Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60769 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2KWEvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 23:51:37 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3277571pad.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 20:51:36 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH 4/4] [media] exynos-gsc: Fix checkpatch warning in gsc-m2m.c
Date: Fri, 23 Nov 2012 10:15:02 +0530
Message-Id: <1353645902-7467-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
References: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warning:
WARNING: space prohibited between function name and open parenthesis '('
FILE: media/platform/exynos-gsc/gsc-m2m.c:606:
	ctx = kzalloc(sizeof (*ctx), GFP_KERNEL);

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 39dff20..10036d6 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -603,7 +603,7 @@ static int gsc_m2m_open(struct file *file)
 	if (mutex_lock_interruptible(&gsc->lock))
 		return -ERESTARTSYS;
 
-	ctx = kzalloc(sizeof (*ctx), GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
 		ret = -ENOMEM;
 		goto unlock;
-- 
1.7.4.1

