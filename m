Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49056 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754328AbdHVAT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 20:19:26 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2] device property: preserve usecount for node passed to of_fwnode_graph_get_port_parent()
Date: Tue, 22 Aug 2017 02:19:12 +0200
Message-Id: <20170822001912.27638-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
node being passed to of_fwnode_graph_get_port_parent(). Preserve the
usecount by using of_get_parent() instead of of_get_next_parent() which
don't decrement the usecount of the node passed to it.

Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/of/property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 067f9fab7b77c794..59afeea9888e3b3d 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -923,7 +923,7 @@ of_fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
 	struct device_node *np;
 
 	/* Get the parent of the port */
-	np = of_get_next_parent(to_of_node(fwnode));
+	np = of_get_parent(to_of_node(fwnode));
 	if (!np)
 		return NULL;
 
-- 
2.14.0
