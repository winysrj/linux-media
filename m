Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1IAPam (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Sep 2011 17:30:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 19/19 v4] s5p-fimc: Remove single-planar capability flags
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-20-git-send-email-s.nawrocki@samsung.com>
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver supports only multi-planar API and conversion to single-planar
API should be done in libv4l2. Remove misleading single planar capability
flags to avoid problems in applications and libv4l2.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    3 +--
 drivers/media/video/s5p-fimc/fimc-core.c    |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 9ca9462..de885db 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -615,8 +615,7 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
 	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
-			    V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
 
 	return 0;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 8978360..4158cb3 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -864,7 +864,6 @@ static int fimc_m2m_querycap(struct file *file, void *fh,
 	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
 	cap->capabilities = V4L2_CAP_STREAMING |
-		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
 		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 
 	return 0;
-- 
1.7.6

