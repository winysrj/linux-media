Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39052 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753280AbbC3XOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 19:14:19 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, sre@kernel.org
Cc: linux-omap@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	pali.rohar@gmail.com, tony@atomide.com
Subject: [PATCH 1/1] omap3isp: Don't pass uninitialised arguments to of_graph_get_next_endpoint()
Date: Tue, 31 Mar 2015 02:13:28 +0300
Message-Id: <1427757208-1938-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20150330174123.GA2658@earth>
References: <20150330174123.GA2658@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

isp_of_parse_nodes() passed an uninitialised prev argument to
of_graph_get_next_endpoint(). This is bad, fix it by assigning NULL to it in
the initialisation.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Reported-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/media/platform/omap3isp/isp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index ff8f633..ff51c4f 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2338,7 +2338,7 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 static int isp_of_parse_nodes(struct device *dev,
 			      struct v4l2_async_notifier *notifier)
 {
-	struct device_node *node;
+	struct device_node *node = NULL;
 
 	notifier->subdevs = devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
-- 
1.7.10.4

