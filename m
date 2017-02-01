Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44681
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750990AbdBAUFs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 15:05:48 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 1/2] [media] exynos-gsc: Do not swap cb/cr for semi planar formats
Date: Wed,  1 Feb 2017 17:05:21 -0300
Message-Id: <1485979523-32404-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1485979523-32404-1-git-send-email-javier@osg.samsung.com>
References: <1485979523-32404-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thibault Saunier <thibault.saunier@osg.samsung.com>

In the case of semi planar formats cb and cr are in the same plane
in memory, meaning that will be set to 'cb' whatever the format is,
and whatever the (packed) order of those components are.

Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/exynos-gsc/gsc-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 40aff08dd51d..a846659ae5c1 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -861,9 +861,7 @@ int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
 
 	if ((frame->fmt->pixelformat == V4L2_PIX_FMT_VYUY) ||
 		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVYU) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_NV61) ||
 		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420) ||
-		(frame->fmt->pixelformat == V4L2_PIX_FMT_NV21) ||
 		(frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420M))
 		swap(addr->cb, addr->cr);
 
-- 
2.7.4

