Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:14510 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbeJEHWY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 03:22:24 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] v4l2-ioctl: fix CROPCAP type handling
Date: Fri,  5 Oct 2018 02:24:54 +0200
Message-Id: <20181005002454.2387-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The type field in struct v4l2_cropcap is supposed to never use the
_MPLANE variants. E.g. if the driver supports V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
then userspace should still pass V4L2_BUF_TYPE_VIDEO_CAPTURE.

To fix that code is added to the v4l2 core that maps the _MPLANE buffer
types to their regular equivalents before calling the driver.

Effectively this allows for userspace to use either _MPLANE or the regular
buffer type. This keeps backwards compatibility while making things easier
for userspace.

Since drivers now never see the _MPLANE buffer types the exynos driver
had to be adapted as well.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
Hi,

This solves the v4l2-compliance failure on R-Car platforms which became 
apparent on with the v4l-utils commit [1].

I have checked all vidioc_cropcap callers and I can only find the exynos 
driver who do not already do the right thing. Please note that the 
exynos driver change is only compile tested.

1. d26e4941419b05fc ("v4l2-compliance: allow both regular and mplane 
   variants for crop API")

Regards,
Niklas
---
 drivers/media/platform/exynos4-is/fimc-m2m.c | 9 ++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c         | 9 ++++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index a19f8b164a47d460..57ba713708d5e175 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -389,9 +389,12 @@ static int fimc_m2m_cropcap(struct file *file, void *fh,
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_frame *frame;
 
-	frame = ctx_get_frame(ctx, cr->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		frame = &ctx->s_frame;
+	else if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		frame = &ctx->d_frame;
+	else
+		return -EINVAL;
 
 	cr->bounds.left = 0;
 	cr->bounds.top = 0;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7de041bae84fb2f2..a8db0870411db84a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2251,6 +2251,7 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_cropcap *p = arg;
 	struct v4l2_selection s = { .type = p->type };
+	u32 old_type = p->type;
 	int ret = 0;
 
 	/* setting trivial pixelaspect */
@@ -2264,8 +2265,14 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_g_selection))
 		return -ENOTTY;
 
-	if (ops->vidioc_cropcap)
+	if (ops->vidioc_cropcap) {
+		if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+			p->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		else if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+			p->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 		ret = ops->vidioc_cropcap(file, fh, p);
+		p->type = old_type;
+	}
 
 	if (!ops->vidioc_g_selection)
 		return ret;
-- 
2.19.0
