Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63563 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2LCGvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 01:51:14 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1691798pad.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 22:51:14 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: sylvester.nawrocki@gmail.com, sachin.kamat@linaro.org,
	patches@linaro.org, s.nawrocki@samsung.com
Subject: [PATCH 1/1] [media] s3c-camif: Add missing version.h header file
Date: Mon,  3 Dec 2012 12:14:31 +0530
Message-Id: <1354517071-1003-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

versioncheck script complains about missing linux/version.h header
file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s3c-camif/camif-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 0dd6537..37c9b6f 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -27,6 +27,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/version.h>
 
 #include <media/media-device.h>
 #include <media/v4l2-ctrls.h>
-- 
1.7.4.1

