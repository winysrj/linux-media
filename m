Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37892 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbbIPXbs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 19:31:48 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] omap3isp: Fix module autoloading
Date: Thu, 17 Sep 2015 01:31:38 +0200
Message-Id: <1442446298-28179-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Platform drivers needs to export the OF id table and this be built
into the module or udev will not have the necessary information to
autoload the driver module when the device is registered via OF.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/omap3isp/isp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 56e683b19a73..2c2840650fb2 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2509,6 +2509,7 @@ static const struct of_device_id omap3isp_of_table[] = {
 	{ .compatible = "ti,omap3-isp" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, omap3isp_of_table);
 
 static struct platform_driver omap3isp_driver = {
 	.probe = isp_probe,
-- 
2.4.3

