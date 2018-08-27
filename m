Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54590 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727178AbeH0NP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 09:15:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
Subject: [PATCH v2 14/23] v4l: fwnode: Parse the graph endpoint as last
Date: Mon, 27 Aug 2018 12:29:51 +0300
Message-Id: <20180827093000.29165-15-sakari.ailus@linux.intel.com>
In-Reply-To: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing the graph endpoint is always successful; therefore parse it as
last.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 0ddf05bb589a..c7a52962a9c0 100644
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
