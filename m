Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35158 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbeCJT65 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 14:58:57 -0500
Received: by mail-pf0-f195.google.com with SMTP id y186so2681123pfb.2
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2018 11:58:57 -0800 (PST)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 01/13] media: v4l2-fwnode: ignore endpoints that have no remote port parent
Date: Sat, 10 Mar 2018 11:58:30 -0800
Message-Id: <1520711922-17338-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1520711922-17338-1-git-send-email-steve_longerbeam@mentor.com>
References: <1520711922-17338-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation/devicetree/bindings/media/video-interfaces.txt states that
the 'remote-endpoint' property is optional.

So v4l2_async_notifier_fwnode_parse_endpoint() should not return error
if the endpoint has no remote port parent. Just ignore the endpoint,
skip adding an asd to the notifier and return 0.
__v4l2_async_notifier_parse_fwnode_endpoints() will then continue
parsing the remaining port endpoints of the device.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index d630640..b8afbac 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -363,7 +363,7 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 		fwnode_graph_get_remote_port_parent(endpoint);
 	if (!asd->match.fwnode) {
 		dev_warn(dev, "bad remote port parent\n");
-		ret = -EINVAL;
+		ret = -ENOTCONN;
 		goto out_err;
 	}
 
-- 
2.7.4
