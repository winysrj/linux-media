Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:33961 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab1FPTG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 15:06:56 -0400
From: <hvaibhav@ti.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@redhat.com>, <hverkuil@xs4all.nl>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH] OMAP_VOUT: Change hardcoded device node number to -1
Date: Fri, 17 Jun 2011 00:36:44 +0530
Message-ID: <1308251204-15633-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Vaibhav Hiremath <hvaibhav@ti.com>

With addition of media-controller framework, now we have various
device nodes (/dev/videoX) getting created, so hardcoding
minor number in video_register_device() is not recommended.

So let V4L2 framework choose free minor number for the device.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 0bc776c..3bc909a 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1993,7 +1993,7 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 		/* Register the Video device with V4L2
 		 */
 		vfd = vout->vfd;
-		if (video_register_device(vfd, VFL_TYPE_GRABBER, k + 1) < 0) {
+		if (video_register_device(vfd, VFL_TYPE_GRABBER, -1) < 0) {
 			dev_err(&pdev->dev, ": Could not register "
 					"Video for Linux device\n");
 			vfd->minor = -1;
-- 
1.6.2.4

