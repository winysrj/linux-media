Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33203 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZGWN4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 09:56:49 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n6NDuSaU010987
	for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 16:56:41 +0300
From: tuukka.o.toivonen@nokia.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	tuukka.o.toivonen@nokia.com
Subject: [PATCH] omap34xxcam: each video buffer takes multiple of PAGE_SIZE bytes
Date: Thu, 23 Jul 2009 16:56:27 +0300
Message-Id: <1248357387-14720-4-git-send-email-tuukka.o.toivonen@nokia.com>
In-Reply-To: <1248357387-14720-3-git-send-email-tuukka.o.toivonen@nokia.com>
References: <1248357387-14720-1-git-send-email-tuukka.o.toivonen@nokia.com>
 <1248357387-14720-2-git-send-email-tuukka.o.toivonen@nokia.com>
 <1248357387-14720-3-git-send-email-tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>

When restricting the required memory for video buffers,
take into account that each buffer allocation takes multiple
of PAGE_SIZE bytes.

Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
---
 drivers/media/video/omap34xxcam.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap34xxcam.c b/drivers/media/video/omap34xxcam.c
index 08d8253..be2dd2d 100644
--- a/drivers/media/video/omap34xxcam.c
+++ b/drivers/media/video/omap34xxcam.c
@@ -154,7 +154,8 @@ static int omap34xxcam_vbq_setup(struct videobuf_queue *vbq, unsigned int *cnt,
 
 	*size = vdev->pix.sizeimage;
 
-	while (*size * *cnt > fh->vdev->vdev_sensor_config.capture_mem)
+	while (PAGE_ALIGN(*size) * *cnt >
+	       fh->vdev->vdev_sensor_config.capture_mem)
 		(*cnt)--;
 
 	return isp_vbq_setup(vdev->cam->isp, vbq, cnt, size);
-- 
1.5.4.3

