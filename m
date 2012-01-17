Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62044 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2AQI7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 03:59:52 -0500
Received: by iagf6 with SMTP id f6so3950583iag.19
        for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 00:59:52 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH] [media] s5p-fimc: Remove linux/version.h include from fimc-mdevice.c
Date: Tue, 17 Jan 2012 14:25:25 +0530
Message-Id: <1326790525-25263-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 615c862..8ea4ee1 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -21,7 +21,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <media/v4l2-ctrls.h>
 #include <media/media-device.h>
 
-- 
1.7.4.1

