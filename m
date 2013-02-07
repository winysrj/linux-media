Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33449 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3BGHM4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 02:12:56 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so1256655pad.34
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 23:12:56 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/2] [media] s5p-tv: Include missing platform_device.h header
Date: Thu,  7 Feb 2013 12:25:55 +0530
Message-Id: <1360220155-28819-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1360220155-28819-1-git-send-email-sachin.kamat@linaro.org>
References: <1360220155-28819-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this patch we get the following build error:
drivers/media/platform/s5p-tv/mixer_video.c:
In function ‘find_and_register_subdev’:
drivers/media/platform/s5p-tv/mixer_video.c:42:34: error:
‘platform_bus_type’ undeclared (first use in this function)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index c087b66..82142a2 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -19,6 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/timer.h>
 #include <media/videobuf2-dma-contig.h>
 
-- 
1.7.4.1

