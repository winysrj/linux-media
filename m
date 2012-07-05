Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60436 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab2GEUip (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 16:38:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 2/9] soc-camera: Pass the physical device to the power operation
Date: Thu,  5 Jul 2012 22:38:41 +0200
Message-Id: <1341520728-2707-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There will be no soc_camera_device instance with a soc-camera device is
used with a non soc-camera host, so we won't be able to pass the
soc_camera_device fake platform device to board code. Pass the physical
device instead.

The argument is currently not used by any board file so this is safe.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/soc_camera.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index e7c6809..b03ffec 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -62,7 +62,7 @@ static int soc_camera_power_on(struct soc_camera_device *icd,
 	}
 
 	if (icl->power) {
-		ret = icl->power(icd->pdev, 1);
+		ret = icl->power(icd->control, 1);
 		if (ret < 0) {
 			dev_err(icd->pdev,
 				"Platform failed to power-on the camera.\n");
@@ -78,7 +78,7 @@ static int soc_camera_power_on(struct soc_camera_device *icd,
 
 esdpwr:
 	if (icl->power)
-		icl->power(icd->pdev, 0);
+		icl->power(icd->control, 0);
 elinkpwr:
 	regulator_bulk_disable(icl->num_regulators,
 			       icl->regulators);
@@ -95,7 +95,7 @@ static int soc_camera_power_off(struct soc_camera_device *icd,
 		return ret;
 
 	if (icl->power) {
-		ret = icl->power(icd->pdev, 0);
+		ret = icl->power(icd->control, 0);
 		if (ret < 0) {
 			dev_err(icd->pdev,
 				"Platform failed to power-off the camera.\n");
-- 
1.7.8.6

