Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:35576 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbeGYRvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 13:51:23 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 06/34] media: camss: Fix OF node usage
Date: Wed, 25 Jul 2018 19:38:15 +0300
Message-Id: <1532536723-19062-7-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
References: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_graph_get_next_endpoint increases the refcount of the returned
node and decreases the refcount of the passed node. Take this into
account and use of_node_put properly.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 45285eb..abf6184 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -296,6 +296,7 @@ static int camss_of_parse_ports(struct device *dev,
 		if (of_device_is_available(node))
 			notifier->num_subdevs++;
 
+	of_node_put(node);
 	size = sizeof(*notifier->subdevs) * notifier->num_subdevs;
 	notifier->subdevs = devm_kzalloc(dev, size, GFP_KERNEL);
 	if (!notifier->subdevs) {
@@ -326,16 +327,16 @@ static int camss_of_parse_ports(struct device *dev,
 		}
 
 		remote = of_graph_get_remote_port_parent(node);
-		of_node_put(node);
-
 		if (!remote) {
 			dev_err(dev, "Cannot get remote parent\n");
+			of_node_put(node);
 			return -EINVAL;
 		}
 
 		csd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 		csd->asd.match.fwnode = of_fwnode_handle(remote);
 	}
+	of_node_put(node);
 
 	return notifier->num_subdevs;
 }
-- 
2.7.4
