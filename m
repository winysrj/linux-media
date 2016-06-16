Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48269 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbcFPVlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 17:41:39 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 5/6] [media] gsc-m2m: add device name sufix to bus_info capatiliby field
Date: Thu, 16 Jun 2016 17:40:34 -0400
Message-Id: <1466113235-25909-6-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
References: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver doesn't set the device in the struct v4l2_capability bus_info
field so v4l2-compliance reports the following error for VIDIOC_QUERYCAP:

Required ioctls:
                fail: v4l2-compliance.cpp(537): missing bus_info prefix ('platform')
        test VIDIOC_QUERYCAP: FAIL

This patch fixes this by filling also the device besides the bus.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/exynos-gsc/gsc-m2m.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index a600e32e2543..af81383086b8 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -281,7 +281,8 @@ static int gsc_m2m_querycap(struct file *file, void *fh,
 
 	strlcpy(cap->driver, gsc->pdev->name, sizeof(cap->driver));
 	strlcpy(cap->card, gsc->pdev->name, sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(&gsc->pdev->dev));
 	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
 		V4L2_CAP_VIDEO_CAPTURE_MPLANE |	V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 
-- 
2.5.5

