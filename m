Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40546
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932382AbcI3VRX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 17:17:23 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/4] [media] exynos-gsc: don't clear format when freeing buffers with REQBUFS(0)
Date: Fri, 30 Sep 2016 17:16:42 -0400
Message-Id: <1475270204-14005-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
References: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

User-space applications can use the VIDIOC_REQBUFS ioctl to determine if a
memory mapped, user pointer or DMABUF based I/O is supported by a driver.

For example, GStreamer attempts to determine the I/O methods supported by
the driver by doing many VIDIOC_REQBUFS ioctl calls with different memory
types and count 0. And then the real VIDIOC_REQBUFS call with count == n
is be made to allocate the buffers. But for count 0, the driver not only
frees the buffers but also clears the format set before with VIDIOC_S_FMT.

This is a problem since STREAMON fails if a format isn't set but GStreamer
first sets a format and then tries to determine the supported I/O methods,
so the format will be cleared on REQBUFS(0), before the call to STREAMON.

To avoid this issue, only free the buffers on VIDIOC_REQBUFS(0) but don't
clear the format. Since is completely valid to set the format and then do
different calls to REQBUFS before a call to STREAMON.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/exynos-gsc/gsc-m2m.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 9f03b791b711..e2a16b52f87d 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -365,14 +365,8 @@ static int gsc_m2m_reqbufs(struct file *file, void *fh,
 
 	max_cnt = (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
 		gsc->variant->in_buf_cnt : gsc->variant->out_buf_cnt;
-	if (reqbufs->count > max_cnt) {
+	if (reqbufs->count > max_cnt)
 		return -EINVAL;
-	} else if (reqbufs->count == 0) {
-		if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-			gsc_ctx_state_lock_clear(GSC_SRC_FMT, ctx);
-		else
-			gsc_ctx_state_lock_clear(GSC_DST_FMT, ctx);
-	}
 
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
-- 
2.7.4

