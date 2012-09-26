Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39605 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2IZHVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 03:21:46 -0400
Received: by padhz1 with SMTP id hz1so235782pad.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 00:21:46 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.ameer@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/2] [media] exynos-gsc: Remove <linux/version.h> header file inclusion
Date: Wed, 26 Sep 2012 12:48:03 +0530
Message-Id: <1348643884-4005-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version.h is not needed for these files.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    1 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index c5c7625..90a6c55 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/bug.h>
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 2589cae..a4f327e 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/bug.h>
-- 
1.7.4.1

