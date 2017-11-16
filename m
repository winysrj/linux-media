Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42604 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932594AbdKPAd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 19:33:56 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC 2/2] v4l: rcar-vin: Wait for device access to complete before unplugging
Date: Thu, 16 Nov 2017 02:33:49 +0200
Message-Id: <20171116003349.19235-3-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To avoid races between device access and unplug, call the
video_device_unplug() function in the platform driver remove handler.
This will unsure that all device access completes before the remove
handler proceeds to free resources.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index bd7976efa1fb..c5210f1d09ed 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1273,6 +1273,7 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	video_device_unplug(&vin->vdev);
 
 	if (!vin->info->use_mc) {
 		v4l2_async_notifier_unregister(&vin->notifier);
-- 
Regards,

Laurent Pinchart
