Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40595 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3AKLGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 06:06:39 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGG00CQKK71L3Y0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Jan 2013 20:06:37 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGG0051IK6URY90@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Jan 2013 20:06:37 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Fix fimc-lite entities deregistration
Date: Fri, 11 Jan 2013 12:06:28 +0100
Message-id: <1357902388-24500-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clear the proper array when deregistering FIMC-LITE devices. Now
fimc[] array is erroneously accessed instead of fimc_lite[] and
fimc_md_unregister_entities() function call can result in an oops
from NULL pointer dereference, since fmd->fimc[] is cleared earlier.
This might happen in normal conditions when the driver's probing
is deferred and then retried.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 1288c88..4f21d80 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -768,7 +768,7 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		if (fmd->fimc_lite[i] == NULL)
 			continue;
 		v4l2_device_unregister_subdev(&fmd->fimc_lite[i]->subdev);
-		fmd->fimc[i]->pipeline_ops = NULL;
+		fmd->fimc_lite[i]->pipeline_ops = NULL;
 		fmd->fimc_lite[i] = NULL;
 	}
 	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
--
1.7.9.5

