Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41756 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1LGN1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 08:27:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	sakari.ailus@iki.fi
Subject: [PATCH] as3645a: Handle power on errors when registering the device
Date: Wed,  7 Dec 2011 14:27:40 +0100
Message-Id: <1323264460-17846-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return an error in the registered handler if the device can't be powered
on.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/as3645a.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

Hi everybody,

This patch applies on top of the as3645a driver that I'm going to submit for
v3.3. In order to make review easier I'm sending it separately, I will then
squash it into the driver for submission.

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index d583a9c..f7c3178 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -557,7 +557,9 @@ static int as3645a_registered(struct v4l2_subdev *sd)
 	/* Power up the flash driver and read manufacturer ID, model ID, RFU
 	 * and version.
 	 */
-	as3645a_set_power(&flash->subdev, 1);
+	rval = as3645a_set_power(&flash->subdev, 1);
+	if (rval < 0)
+		return rval;
 
 	rval = as3645a_read(flash, AS_DESIGN_INFO_REG);
 	if (rval < 0)
-- 
Regards,

Laurent Pinchart

