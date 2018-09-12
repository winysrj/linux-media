Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41010 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728257AbeIMCgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 14/23] v4l: fwnode: Parse the graph endpoint as last
Date: Thu, 13 Sep 2018 00:29:33 +0300
Message-Id: <20180912212942.19641-15-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing the graph endpoint is always successful; therefore parse it as
last.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index dbe0ada74c63..bdb0a355b66b 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -308,7 +308,11 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 
 	pr_debug("===== begin V4L2 endpoint properties\n");
 
-	fwnode_graph_parse_endpoint(fwnode, &vep->base);
+	/*
+	 * Zero the fwnode graph endpoint memory in case we don't end up parsing
+	 * the endpoint.
+	 */
+	memset(&vep->base, 0, sizeof(vep->base));
 
 	/* Zero fields from bus_type to until the end */
 	memset(&vep->bus_type, 0, sizeof(*vep) -
@@ -351,6 +355,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		return -EINVAL;
 	}
 
+	fwnode_graph_parse_endpoint(fwnode, &vep->base);
+
 	return 0;
 }
 
-- 
2.11.0
