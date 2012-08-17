Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2HQGaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 02:30:22 -0400
Received: by pbbrr13 with SMTP id rr13so2835582pbb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 23:30:21 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH-Trivial 1/2] [media] s5p-fimc: Replace asm/* headers with linux/*
Date: Fri, 17 Aug 2012 11:58:26 +0530
Message-Id: <1345184907-8317-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following warning:
WARNING: Use #include <linux/sizes.h> instead of <asm/sizes.h>

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-core.h |    2 +-
 drivers/media/platform/s5p-fimc/fimc-lite.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 808ccc6..e787f65 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -17,7 +17,7 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
-#include <asm/sizes.h>
+#include <linux/sizes.h>

 #include <media/media-entity.h>
 #include <media/videobuf2-core.h>
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
index 44424ee..8dc3e9b 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
@@ -9,7 +9,7 @@
 #ifndef FIMC_LITE_H_
 #define FIMC_LITE_H_

-#include <asm/sizes.h>
+#include <linux/sizes.h>
 #include <linux/io.h>
 #include <linux/irqreturn.h>
 #include <linux/platform_device.h>
--
1.7.4.1

