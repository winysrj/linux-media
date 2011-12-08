Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49282 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1LHLAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 06:00:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	sakari.ailus@iki.fi
Subject: [PATCH v2] as3645a: Handle power on errors when registering the device
Date: Thu,  8 Dec 2011 12:00:52 +0100
Message-Id: <1323342052-15808-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1323264460-17846-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1323264460-17846-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return an error in the registered handler if the device can't be powered
on.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/as3645a.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

Hi everybody,

This second version of the as3645a power on patch fixes a problem with the power
on operation that would leave the chip powered when it can't be initialized. It
still applies on top of the as3645a driver that I'm going to submit for
v3.3.

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index d583a9c..0ed52ee 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -523,7 +523,16 @@ static int __as3645a_set_power(struct as3645a *flash, int on)
 			return ret;
 	}
 
-	return on ? as3645a_setup(flash) : 0;
+	if (!on)
+		return 0;
+
+	ret = as3645a_setup(flash);
+	if (ret < 0) {
+		if (flash->pdata->set_power)
+			flash->pdata->set_power(&flash->subdev, 0);
+	}
+
+	return ret;
 }
 
 static int as3645a_set_power(struct v4l2_subdev *sd, int on)
@@ -557,7 +566,9 @@ static int as3645a_registered(struct v4l2_subdev *sd)
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

