Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:49353 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3BGHL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 02:11:58 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so1030486dak.25
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 23:11:58 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/2] [media] s5p-tv: Include missing irqreturn.h header
Date: Thu,  7 Feb 2013 12:25:54 +0530
Message-Id: <1360220155-28819-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this patch we get the following compilation errors:
drivers/media/platform/s5p-tv/mixer.h:345:13: error: Expected ; at end of declaration
drivers/media/platform/s5p-tv/mixer.h:345:13: error: got mxr_irq_handler

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index b671e20..04e6490 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -19,6 +19,7 @@
 #endif
 
 #include <linux/fb.h>
+#include <linux/irqreturn.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-- 
1.7.4.1

