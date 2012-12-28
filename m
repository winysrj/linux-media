Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:47389 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2L1Kep (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 05:34:45 -0500
Received: by mail-da0-f41.google.com with SMTP id e20so4761477dak.0
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 02:34:44 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: andrzej.p@samsung.com, s.nawrocki@samsung.com,
	sylvester.nawrocki@gmail.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 2/2] [media] s5p-fimc: Use spinlock_t instead of 'struct spinlock'
Date: Fri, 28 Dec 2012 15:50:44 +0530
Message-Id: <1356690044-8694-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1356690044-8694-1-git-send-email-sachin.kamat@linaro.org>
References: <1356690044-8694-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following checkpatch warning:
WARNING: struct spinlock should be spinlock_t

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 4c961b1..86c8775 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -187,7 +187,7 @@ struct csis_state {
 	const struct csis_pix_format *csis_fmt;
 	struct v4l2_mbus_framefmt format;
 
-	struct spinlock slock;
+	spinlock_t slock;
 	struct csis_pktbuf pkt_buf;
 	struct s5pcsis_event events[S5PCSIS_NUM_EVENTS];
 };
-- 
1.7.4.1

