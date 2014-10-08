Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:36241 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbaJHIrM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 04:47:12 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND4005U7B2MFY90@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 17:47:10 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Cc: s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 3/3] exynos4-is: Open shouldn't fail when sensor entity is not
 linked
Date: Wed, 08 Oct 2014 10:46:53 +0200
Message-id: <1412758013-23608-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1412758013-23608-1-git-send-email-j.anaszewski@samsung.com>
References: <1412758013-23608-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to allow for automatic media device entities linking
from the level of libv4l plugin the open system call shouldn't
fail, as the libv4l plugins can begin their job not until it
succeeds.
This patch allows for leaving the  pipeline not linked on
open and postpones verifying it to the moment when streamon
callback is called.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   45 ++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index c867c46..3732663 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -217,7 +217,7 @@ static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
 		fimc_pipeline_prepare(p, me);
 
 	sd = p->subdevs[IDX_SENSOR];
-	if (sd == NULL)
+	if (sd == NULL && !fmd->user_subdev_api)
 		return -EINVAL;
 
 	/* Disable PXLASYNC clock if this pipeline includes FIMC-IS */
@@ -277,10 +277,46 @@ static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
 		{ IDX_CSIS, IDX_FLITE, IDX_FIMC, IDX_SENSOR, IDX_IS_ISP },
 	};
 	struct fimc_pipeline *p = to_fimc_pipeline(ep);
-	int i, ret = 0;
+	struct fimc_md *fmd = entity_to_fimc_mdev(&p->subdevs[IDX_CSIS]->entity);
+	enum fimc_subdev_index sd_id;
+	int i = 0, ret = 0;
 
-	if (p->subdevs[IDX_SENSOR] == NULL)
-		return -ENODEV;
+	/*
+	 * Sensor might not be discovered upon device open
+	 * due to not linked pipeline. User space is expected to
+	 * link the pipeline prior calling VIDIOC_STREAMON ioctl,
+	 * when in user_subdev_api mode.
+	 */
+	while (p->subdevs[IDX_SENSOR] == NULL) {
+		/*
+		 * Sensor must be already discovered if
+		 * we are in non user_subdev_api mode.
+		 */
+		if (!fmd->user_subdev_api) {
+			return -ENODEV;
+		} else if (i++ == 0) {
+			/* Determine which entity is last in the pipeline */
+			if (p->subdevs[IDX_FIMC])
+				sd_id = IDX_FIMC;
+			else if (p->subdevs[IDX_IS_ISP])
+				sd_id = IDX_IS_ISP;
+			else if (p->subdevs[IDX_FLITE])
+				sd_id = IDX_FLITE;
+			else
+				return -ENODEV;
+
+			ret = __fimc_pipeline_open(ep,
+					&p->subdevs[sd_id]->entity,
+					true);
+			if (ret < 0)
+				return ret;
+
+			if (p->subdevs[IDX_SENSOR] == NULL)
+				return -ENODEV;
+		} else {
+			return -ENODEV;
+		}
+	}
 
 	/* Wait until all devices in the chain are powered up */
 	async_synchronize_full_domain(&ep->async_domain);
@@ -293,6 +329,7 @@ static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
 		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 			goto error;
 	}
+
 	return 0;
 error:
 	for (; i >= 0; i--) {
-- 
1.7.9.5

