Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54771 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2AQI5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 03:57:04 -0500
Received: by iagf6 with SMTP id f6so3947771iag.19
        for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 00:57:03 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: chehab@infradead.org, k.debski@samsung.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-mfc: Remove linux/version.h include from s5p_mfc.c
Date: Tue, 17 Jan 2012 14:22:41 +0530
Message-Id: <1326790361-24498-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-mfc/s5p_mfc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index e43e128..ec7f000 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -18,7 +18,6 @@
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <media/videobuf2-core.h>
-- 
1.7.4.1

