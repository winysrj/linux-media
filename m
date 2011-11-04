Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14785 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab1KDOUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:09 -0400
Date: Fri, 04 Nov 2011 15:19:56 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/8] s5p-fimc: Fix error in the capture subdev deinitialization
In-reply-to: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320416402-22883-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure the subdev pointer is cleared when the subdev object
has been freed.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index c8d91b0..382dacd 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1375,7 +1375,7 @@ static void fimc_destroy_capture_subdev(struct fimc_dev *fimc)
 	media_entity_cleanup(&sd->entity);
 	v4l2_device_unregister_subdev(sd);
 	kfree(sd);
-	sd = NULL;
+	fimc->vid_cap.subdev = NULL;
 }
 
 /* Set default format at the sensor and host interface */
-- 
1.7.7.1

