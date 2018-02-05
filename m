Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42451 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbeBECd0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Feb 2018 21:33:26 -0500
Received: by mail-pl0-f67.google.com with SMTP id 11so10812078plc.9
        for <linux-media@vger.kernel.org>; Sun, 04 Feb 2018 18:33:26 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: v4l2_fh.h: add missing kconfig.h include
Date: Mon,  5 Feb 2018 11:33:04 +0900
Message-Id: <20180205023304.157171-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_fh.h uses the IS_ENABLED() macro and thus should include kconfig.h.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 include/media/v4l2-fh.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 62633e7d2630..ea73fef8bdc0 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -22,6 +22,7 @@
 #define V4L2_FH_H
 
 #include <linux/fs.h>
+#include <linux/kconfig.h>
 #include <linux/list.h>
 #include <linux/videodev2.h>
 
-- 
2.16.0.rc1.238.g530d649a79-goog
