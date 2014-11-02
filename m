Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53331 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaKBOxg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 09:53:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 05/13] v4l: of: Add v4l2_of_parse_link() function
Date: Sun,  2 Nov 2014 16:53:30 +0200
Message-Id: <1414940018-3016-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function fills a link data structure with the device node and port
number at both the local and remote ends of a link defined by one of its
endpoint nodes.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-of.c | 61 +++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-of.h           | 27 +++++++++++++++++
 2 files changed, 88 insertions(+)

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index b4ed9a9..c473479 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -142,3 +142,64 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
+
+/**
+ * v4l2_of_parse_link() - parse a link between two endpoints
+ * @node: pointer to the endpoint at the local end of the link
+ * @link: pointer to the V4L2 OF link data structure
+ *
+ * Fill the link structure with the local and remote nodes and port numbers.
+ * The local_node and remote_node fields are set to point to the local and
+ * remote port parent nodes respectively (the port parent node being the parent
+ * node of the port node if that node isn't a 'ports' node, or the grand-parent
+ * node of the port node otherwise).
+ *
+ * A reference is taken to both the local and remote nodes, the caller must use
+ * v4l2_of_put_link() to drop the references when done with the link.
+ *
+ * Return: 0 on success, or -ENOLINK if the remote endpoint can't be found.
+ */
+int v4l2_of_parse_link(const struct device_node *node,
+		       struct v4l2_of_link *link)
+{
+	struct device_node *np;
+
+	memset(link, 0, sizeof(*link));
+
+	np = of_get_parent(node);
+	of_property_read_u32(np, "reg", &link->local_port);
+	np = of_get_next_parent(np);
+	if (of_node_cmp(np->name, "ports") == 0)
+		np = of_get_next_parent(np);
+	link->local_node = np;
+
+	np = of_parse_phandle(node, "remote-endpoint", 0);
+	if (!np) {
+		of_node_put(link->local_node);
+		return -ENOLINK;
+	}
+
+	np = of_get_parent(np);
+	of_property_read_u32(np, "reg", &link->remote_port);
+	np = of_get_next_parent(np);
+	if (of_node_cmp(np->name, "ports") == 0)
+		np = of_get_next_parent(np);
+	link->remote_node = np;
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_of_parse_link);
+
+/**
+ * v4l2_of_put_link() - drop references to nodes in a link
+ * @link: pointer to the V4L2 OF link data structure
+ *
+ * Drop references to the local and remote nodes in the link. This function must
+ * be called on every link parsed with v4l2_of_parse_link().
+ */
+void v4l2_of_put_link(struct v4l2_of_link *link)
+{
+	of_node_put(link->local_node);
+	of_node_put(link->remote_node);
+}
+EXPORT_SYMBOL(v4l2_of_put_link);
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 70fa7b7..078846d 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -66,9 +66,26 @@ struct v4l2_of_endpoint {
 	struct list_head head;
 };
 
+/**
+ * struct v4l2_of_link - a link between two endpoints
+ * @local_node: pointer to device_node of this endpoint
+ * @local_port: identifier of the port this endpoint belongs to
+ * @remote_node: pointer to device_node of the remote endpoint
+ * @remote_port: identifier of the port the remote endpoint belongs to
+ */
+struct v4l2_of_link {
+	struct device_node *local_node;
+	unsigned int local_port;
+	struct device_node *remote_node;
+	unsigned int remote_port;
+};
+
 #ifdef CONFIG_OF
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint);
+int v4l2_of_parse_link(const struct device_node *node,
+		       struct v4l2_of_link *link);
+void v4l2_of_put_link(struct v4l2_of_link *link);
 #else /* CONFIG_OF */
 
 static inline int v4l2_of_parse_endpoint(const struct device_node *node,
@@ -77,6 +94,16 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
+static inline int v4l2_of_parse_link(const struct device_node *node,
+				     struct v4l2_of_link *link)
+{
+	return -ENOSYS;
+}
+
+static inline void v4l2_of_put_link(struct v4l2_of_link *link)
+{
+}
+
 #endif /* CONFIG_OF */
 
 #endif /* _V4L2_OF_H */
-- 
2.0.4

