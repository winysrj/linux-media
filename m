Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36484 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751423AbdILNmG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 09:42:06 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v12 09/26] omap3isp: Fix check for our own sub-devices
Date: Tue, 12 Sep 2017 16:41:43 +0300
Message-Id: <20170912134200.19556-10-sakari.ailus@linux.intel.com>
In-Reply-To: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We only want to link sub-devices that were bound to the async notifier the
isp driver registered but there may be other sub-devices in the
v4l2_device as well. Check for the correct async notifier.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/platform/omap3isp/isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index a546cf774d40..3b1a9cd0e591 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2155,7 +2155,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 		return ret;
 
 	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
-		if (!sd->asd)
+		if (sd->notifier != &isp->notifier)
 			continue;
 
 		ret = isp_link_entity(isp, &sd->entity,
-- 
2.11.0
