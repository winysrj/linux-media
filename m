Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34148
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754533AbcJGUju (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 16:39:50 -0400
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
Subject: [PATCH 1/3] [media] exynos-gsc: don't release a non-dynamically allocated video_device
Date: Fri,  7 Oct 2016 17:39:17 -0300
Message-Id: <1475872759-17969-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1475872759-17969-1-git-send-email-javier@osg.samsung.com>
References: <1475872759-17969-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct v4l2_device instance for the G-Scaler is not dyanmically
allocated but a member of the struct gsc_dev. In fact, the assigned
.release callback is video_device_release_empty().

But gsc_register_m2m_device() attempts to release the v4l2_device by
calling video_device_release() in its error path. This is wrong since
the v4l2_device wasn't allocated directly and will be freed once its
parent struct gsc_dev is freed.

While being there, rename the remaining goto label in the error path
to something that better explains the error path cleanup.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/exynos-gsc/gsc-m2m.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index e2a16b52f87d..a1cac52ea230 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -760,24 +760,21 @@ int gsc_register_m2m_device(struct gsc_dev *gsc)
 	gsc->m2m.m2m_dev = v4l2_m2m_init(&gsc_m2m_ops);
 	if (IS_ERR(gsc->m2m.m2m_dev)) {
 		dev_err(&pdev->dev, "failed to initialize v4l2-m2m device\n");
-		ret = PTR_ERR(gsc->m2m.m2m_dev);
-		goto err_m2m_r1;
+		return PTR_ERR(gsc->m2m.m2m_dev);
 	}
 
 	ret = video_register_device(&gsc->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		dev_err(&pdev->dev,
 			 "%s(): failed to register video device\n", __func__);
-		goto err_m2m_r2;
+		goto err_m2m_release;
 	}
 
 	pr_debug("gsc m2m driver registered as /dev/video%d", gsc->vdev.num);
 	return 0;
 
-err_m2m_r2:
+err_m2m_release:
 	v4l2_m2m_release(gsc->m2m.m2m_dev);
-err_m2m_r1:
-	video_device_release(gsc->m2m.vfd);
 
 	return ret;
 }
-- 
2.7.4

