Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40562
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933417AbcI3VRe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 17:17:34 -0400
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
Subject: [PATCH 4/4] [media] exynos-gsc: do proper bytesperline and sizeimage calculation
Date: Fri, 30 Sep 2016 17:16:44 -0400
Message-Id: <1475270204-14005-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
References: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver don't take into account the differences between packed, semi
planar and multi planar formats when calculating the pixel format bytes
per lines and image size values. This makes GStreamer to fail when the
following formats are used NV12, NV21, NV16, NV61, YV12, I420 and Y42B:

"gst_video_frame_map_id: failed to map video frame plane 1"

Nicolas suggested to use the logic found in the Exynos FIMC v4l2 driver
since does this correctly. So this patch changes the bytes per line and
image size calculation according to what's done in this media driver.

After this patch most supported formats work correctly. There are still
issues with the NV21 and NV61 formats, but that seems to be a separate
problem since NV12 and NV16 work and these formats use the same values.

So this can be fixed as a follow-up and shouldn't be a blocker for this
change that improves the driver's support.

Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/exynos-gsc/gsc-core.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 8bb1d2be7234..a6c47deba3b7 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -451,12 +451,25 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 	else /* SD */
 		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
-
 	for (i = 0; i < pix_mp->num_planes; ++i) {
-		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
-		pix_mp->plane_fmt[i].bytesperline = bpl;
-		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+		struct v4l2_plane_pix_format *plane_fmt = &pix_mp->plane_fmt[i];
+		u32 bpl = plane_fmt->bytesperline;
+
+		if (fmt->num_comp == 1 && /* Packed */
+		    (bpl == 0 || (bpl * 8 / fmt->depth[i]) < pix_mp->width))
+			bpl = pix_mp->width * fmt->depth[i] / 8;
+
+		if (fmt->num_comp > 1 && /* Planar */
+		    (bpl == 0 || bpl < pix_mp->width))
+			bpl = pix_mp->width;
+
+		if (i != 0 && fmt->num_comp == 3)
+			bpl /= 2;
 
+		plane_fmt->bytesperline = bpl;
+		plane_fmt->sizeimage = max(pix_mp->width * pix_mp->height *
+					   fmt->depth[i] / 8,
+					   plane_fmt->sizeimage);
 		pr_debug("[%d]: bpl: %d, sizeimage: %d",
 				i, bpl, pix_mp->plane_fmt[i].sizeimage);
 	}
-- 
2.7.4

