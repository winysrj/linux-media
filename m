Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:49410 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2L1K2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 05:28:31 -0500
Received: by mail-da0-f49.google.com with SMTP id v40so4722438dad.8
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 02:28:30 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: andrzej.p@samsung.com, s.nawrocki@samsung.com,
	sylvester.nawrocki@gmail.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 1/2] [media] s5p-jpeg: Use spinlock_t instead of 'struct spinlock'
Date: Fri, 28 Dec 2012 15:50:43 +0530
Message-Id: <1356690044-8694-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following checkpatch warning:
WARNING: struct spinlock should be spinlock_t

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 022b9b9..8a4013e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -62,7 +62,7 @@
  */
 struct s5p_jpeg {
 	struct mutex		lock;
-	struct spinlock		slock;
+	spinlock_t		slock;
 
 	struct v4l2_device	v4l2_dev;
 	struct video_device	*vfd_encoder;
-- 
1.7.4.1

