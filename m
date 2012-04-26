Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22125 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2DZNt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 09:49:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 26 Apr 2012 15:49:22 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH FOR v3.4 1/2] s5p-fimc: Fix locking in subdev set_crop op
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	stable@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335448162-26512-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When setting TRY crop on the sub-device the mutex was erroneously acquired
rather than released on exit path. This bug is present in kernels starting
from v3.2.

Cc: stable@vger.kernel.org
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index dc18ba5..02bbfd7 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1385,7 +1385,7 @@ static int fimc_subdev_set_crop(struct v4l2_subdev *sd,
 	fimc_capture_try_crop(ctx, r, crop->pad);
 
 	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mutex_lock(&fimc->lock);
+		mutex_unlock(&fimc->lock);
 		*v4l2_subdev_get_try_crop(fh, crop->pad) = *r;
 		return 0;
 	}
-- 
1.7.10

