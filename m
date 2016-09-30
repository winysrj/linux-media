Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40536
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933618AbcI3VRR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 17:17:17 -0400
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
Subject: [PATCH 1/4] [media] exynos-gsc: change spamming try_fmt log message to debug
Date: Fri, 30 Sep 2016 17:16:41 -0400
Message-Id: <1475270204-14005-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
References: <1475270204-14005-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver try_fmt handler prints a message each time that the image
size has been changed due the maximum and minimum width and height.

Since user-space can try different format and sizes, this logs a lot
of unnecessary messages. Change the message log level to debug and
while being there, also add a new line to the message.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/exynos-gsc/gsc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 787bd16c19e5..fac0c0246ad4 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -441,7 +441,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
 	v4l_bound_align_image(&pix_mp->width, min_w, max_w, mod_x,
 		&pix_mp->height, min_h, max_h, mod_y, 0);
 	if (tmp_w != pix_mp->width || tmp_h != pix_mp->height)
-		pr_info("Image size has been modified from %dx%d to %dx%d",
+		pr_debug("Image size has been modified from %dx%d to %dx%d\n",
 			 tmp_w, tmp_h, pix_mp->width, pix_mp->height);
 
 	pix_mp->num_planes = fmt->num_planes;
-- 
2.7.4

