Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753849AbdEQPDw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 11:03:52 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        laurent.pinchart@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        John Youn <johnyoun@synopsys.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/3] device property: Add fwnode_graph_get_port_parent
Date: Wed, 17 May 2017 16:03:38 +0100
Message-Id: <e81284b2bb29552ab7cf02c07367a6a542f06d49.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

V4L2 async notifiers can pass the endpoint fwnode rather than the device
fwnode.

Provide a helper to obtain the parent device fwnode without first
parsing the remote-endpoint as per fwnode_graph_get_remote_port_parent.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/base/property.c  | 25 +++++++++++++++++++++++++
 include/linux/property.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 627ebc9b570d..caf4316fe565 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1245,6 +1245,31 @@ fwnode_graph_get_next_endpoint(struct fwnode_handle *fwnode,
 EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
 
 /**
+ * fwnode_graph_get_port_parent - Return device node of a port endpoint
+ * @fwnode: Endpoint firmware node pointing of the port
+ *
+ * Extracts firmware node of the device the @fwnode belongs to.
+ */
+struct fwnode_handle *
+fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *parent = NULL;
+
+	if (is_of_node(fwnode)) {
+		struct device_node *node;
+
+		node = of_graph_get_port_parent(to_of_node(fwnode));
+		if (node)
+			parent = &node->fwnode;
+	} else if (is_acpi_node(fwnode)) {
+		parent = acpi_node_get_parent(fwnode);
+	}
+
+	return parent;
+}
+EXPORT_SYMBOL_GPL(fwnode_graph_get_port_parent);
+
+/**
  * fwnode_graph_get_remote_port_parent - Return fwnode of a remote device
  * @fwnode: Endpoint firmware node pointing to the remote endpoint
  *
diff --git a/include/linux/property.h b/include/linux/property.h
index 2f482616a2f2..624129b86c82 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -274,6 +274,8 @@ void *device_get_mac_address(struct device *dev, char *addr, int alen);
 
 struct fwnode_handle *fwnode_graph_get_next_endpoint(
 	struct fwnode_handle *fwnode, struct fwnode_handle *prev);
+struct fwnode_handle *fwnode_graph_get_port_parent(
+	struct fwnode_handle *fwnode);
 struct fwnode_handle *fwnode_graph_get_remote_port_parent(
 	struct fwnode_handle *fwnode);
 struct fwnode_handle *fwnode_graph_get_remote_port(
-- 
git-series 0.9.1
