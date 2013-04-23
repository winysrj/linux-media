Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:53132 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab3DWPlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 11:41:42 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLP00L1ZSXHU830@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Apr 2013 00:41:41 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] exynos4-is: Fix TRY format propagation at MIPI-CSIS subdev
Date: Tue, 23 Apr 2013 17:41:27 +0200
Message-id: <1366731687-32566-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure TRY format is propagated from the sink to source pad.
The format at both pads is always same so the TRY format buffer
for pad 0 is used to hold format for both pads.
While at it remove redundant fmt->pad checking.

Reported-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index d62b0d2..50f3c5c 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -579,10 +579,10 @@ static struct csis_pix_format const *s5pcsis_try_format(
 
 static struct v4l2_mbus_framefmt *__s5pcsis_get_format(
 		struct csis_state *state, struct v4l2_subdev_fh *fh,
-		u32 pad, enum v4l2_subdev_format_whence which)
+		enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return fh ? v4l2_subdev_get_try_format(fh, pad) : NULL;
+		return fh ? v4l2_subdev_get_try_format(fh, 0) : NULL;
 
 	return &state->format;
 }
@@ -594,10 +594,7 @@ static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	struct csis_pix_format const *csis_fmt;
 	struct v4l2_mbus_framefmt *mf;
 
-	if (fmt->pad != CSIS_PAD_SOURCE && fmt->pad != CSIS_PAD_SINK)
-		return -EINVAL;
-
-	mf = __s5pcsis_get_format(state, fh, fmt->pad, fmt->which);
+	mf = __s5pcsis_get_format(state, fh, fmt->which);
 
 	if (fmt->pad == CSIS_PAD_SOURCE) {
 		if (mf) {
@@ -624,10 +621,7 @@ static int s5pcsis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	struct csis_state *state = sd_to_csis_state(sd);
 	struct v4l2_mbus_framefmt *mf;
 
-	if (fmt->pad != CSIS_PAD_SOURCE && fmt->pad != CSIS_PAD_SINK)
-		return -EINVAL;
-
-	mf = __s5pcsis_get_format(state, fh, fmt->pad, fmt->which);
+	mf = __s5pcsis_get_format(state, fh, fmt->which);
 	if (!mf)
 		return -EINVAL;
 
-- 
1.7.9.5

