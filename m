Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751428AbdESQQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 12:16:09 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 1/2] device property: Add fwnode_graph_get_port_parent
Date: Fri, 19 May 2017 17:16:02 +0100
Message-Id: <6d3ca9a2f4af281191b6672489f6d2a6d036d372.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.9f22ad082e363959e4679246793bc4698479a44e.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.9f22ad082e363959e4679246793bc4698479a44e.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.9f22ad082e363959e4679246793bc4698479a44e.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.9f22ad082e363959e4679246793bc4698479a44e.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Provide a helper to obtain the parent device fwnode without first
parsing the remote-endpoint as per fwnode_graph_get_remote_port_parent.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - Rebase on top of Sakari's acpi-graph-clean branch and simplify

 drivers/base/property.c  | 13 +++++++++++++
 include/linux/property.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index b311a6fa7d0c..310c53b6b7fc 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1169,6 +1169,19 @@ fwnode_graph_get_next_endpoint(struct fwnode_handle *fwnode,
 EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
 
 /**
+ * fwnode_graph_get_port_parent - Return the device fwnode of a port endpoint
+ * @endpoint: Endpoint firmware node of the port
+ *
+ * Returns firmware node of the device the @endpoint belongs to.
+ */
+struct fwnode_handle *
+fwnode_graph_get_port_parent(struct fwnode_handle *endpoint)
+{
+	return fwnode_call_ptr_op(endpoint, graph_get_port_parent);
+}
+EXPORT_SYMBOL_GPL(fwnode_graph_get_port_parent);
+
+/**
  * fwnode_graph_get_remote_port_parent - Return fwnode of a remote device
  * @fwnode: Endpoint firmware node pointing to the remote endpoint
  *
diff --git a/include/linux/property.h b/include/linux/property.h
index b9f4838d9882..af95d5d84192 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -275,6 +275,8 @@ void *device_get_mac_address(struct device *dev, char *addr, int alen);
 
 struct fwnode_handle *fwnode_graph_get_next_endpoint(
 	struct fwnode_handle *fwnode, struct fwnode_handle *prev);
+struct fwnode_handle *fwnode_graph_get_port_parent(
+	struct fwnode_handle *fwnode);
 struct fwnode_handle *fwnode_graph_get_remote_port_parent(
 	struct fwnode_handle *fwnode);
 struct fwnode_handle *fwnode_graph_get_remote_port(
-- 
git-series 0.9.1
