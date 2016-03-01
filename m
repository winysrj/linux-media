Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44848 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbcCAO5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 09:57:22 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/8] v4l: exynos4-is: Drop unneeded check when setting up fimc-lite links
Date: Tue,  1 Mar 2016 16:57:20 +0200
Message-Id: <1456844246-18778-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver verifies that the type of the remote entity matches its
expectations when setting up fimc-lite links and returns an error if it
doesn't. Those checks can never fail as the links are created by the
driver in a way that always match its expectations (the SINK and
SOURCE_ISP pads are connected to subdevs only and the SOURCE_DMA pad is
connected to a video node only). Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index e85649147dc8..dc1b929f7a33 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -992,10 +992,6 @@ static int fimc_lite_link_setup(struct media_entity *entity,
 
 	switch (local->index) {
 	case FLITE_SD_PAD_SINK:
-		if (!is_media_entity_v4l2_subdev(remote->entity)) {
-			ret = -EINVAL;
-			break;
-		}
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (fimc->source_subdev_grp_id == 0)
 				fimc->source_subdev_grp_id = sd->grp_id;
@@ -1010,19 +1006,15 @@ static int fimc_lite_link_setup(struct media_entity *entity,
 	case FLITE_SD_PAD_SOURCE_DMA:
 		if (!(flags & MEDIA_LNK_FL_ENABLED))
 			atomic_set(&fimc->out_path, FIMC_IO_NONE);
-		else if (is_media_entity_v4l2_io(remote->entity))
-			atomic_set(&fimc->out_path, FIMC_IO_DMA);
 		else
-			ret = -EINVAL;
+			atomic_set(&fimc->out_path, FIMC_IO_DMA);
 		break;
 
 	case FLITE_SD_PAD_SOURCE_ISP:
 		if (!(flags & MEDIA_LNK_FL_ENABLED))
 			atomic_set(&fimc->out_path, FIMC_IO_NONE);
-		else if (is_media_entity_v4l2_subdev(remote->entity))
-			atomic_set(&fimc->out_path, FIMC_IO_ISP);
 		else
-			ret = -EINVAL;
+			atomic_set(&fimc->out_path, FIMC_IO_ISP);
 		break;
 
 	default:
-- 
2.4.10

