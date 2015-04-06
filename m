Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37702 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752785AbbDFW7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 18:59:02 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com
Subject: [PATCH v3 3/4] v4l: of: Parse variable length properties --- link-frequencies
Date: Tue,  7 Apr 2015 01:57:31 +0300
Message-Id: <1428361053-20411-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
References: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The link-frequencies property is a variable length array of link frequencies
in an endpoint. The array is needed by an increasing number of drivers, so
it makes sense to add it to struct v4l2_of_endpoint.

However, the length of the array is variable and the size of struct
v4l2_of_endpoint is fixed since it is allocated by the caller. The options
here are

1. to define a fixed maximum limit of link frequencies that has to be the
global maximum of all boards. This is seen as problematic since the maximum
could be largish, and everyone hitting the problem would need to submit a
patch to fix it, or

2. parse the property in every driver. This doesn't sound appealing as two
of the three implementations submitted to linux-media were wrong, and one of
them was even merged before this was noticed, or

3. change the interface so that allocating and releasing memory according to
the size of the array is possible. This is what the patch does.

v4l2_of_alloc_parse_endpoint() is just like v4l2_of_parse_endpoint(), but it
will allocate the memory resources needed to store struct v4l2_of_endpoint
and the additional arrays pointed to by this struct. A corresponding release
function v4l2_of_free_endpoint() is provided to release the memory allocated
by v4l2_of_alloc_parse_endpoint().

In addition to this, the link-frequencies property is parsed as well, and
the result is stored to struct v4l2_of_endpoint field link_frequencies.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-of.c |   88 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-of.h           |   17 +++++++
 2 files changed, 105 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 3ac6348..9810cc6 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
@@ -141,6 +142,10 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
  * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
  * The caller should hold a reference to @node.
  *
+ * NOTE: This function does not parse properties the size of which is
+ * variable without a low fixed limit. Please use
+ * v4l2_of_alloc_parse_endpoint() in new drivers instead.
+ *
  * Return: 0.
  */
 int v4l2_of_parse_endpoint(const struct device_node *node,
@@ -167,6 +172,89 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
 
+/*
+ * v4l2_of_free_endpoint() - release resources acquired by
+ * v4l2_of_alloc_parse_endpoint()
+ * @endpoint - the endpoint the resources of which are to be released
+ *
+ * It is safe to call this function with NULL argument or on and
+ * endpoint the parsing of which failed.
+ */
+void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
+{
+	if (IS_ERR_OR_NULL(endpoint))
+		return;
+
+	kfree(endpoint->link_frequencies);
+	kfree(endpoint);
+}
+EXPORT_SYMBOL(v4l2_of_free_endpoint);
+
+/**
+ * v4l2_of_alloc_parse_endpoint() - parse all endpoint node properties
+ * @node: pointer to endpoint device_node
+ *
+ * All properties are optional. If none are found, we don't set any flags.
+ * This means the port has a static configuration and no properties have
+ * to be specified explicitly.
+ * If any properties that identify the bus as parallel are found and
+ * slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if we recognise
+ * the bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
+ * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
+ * The caller should hold a reference to @node.
+ *
+ * v4l2_of_alloc_parse_endpoint() has two important differences to
+ * v4l2_of_parse_endpoint():
+ *
+ * 1. It also parses variable size data and
+ *
+ * 2. The memory resources it has acquired to store the variable size
+ *    data must be released using v4l2_of_free_endpoint() when no longer
+ *    needed.
+ *
+ * Return: Pointer to v4l2_of_endpoint if successful, on error a
+ * negative error code.
+ */
+struct v4l2_of_endpoint *v4l2_of_alloc_parse_endpoint(
+	const struct device_node *node)
+{
+	struct v4l2_of_endpoint *endpoint;
+	int len;
+	int rval;
+
+	endpoint = kzalloc(sizeof(*endpoint), GFP_KERNEL);
+	if (!endpoint)
+		return ERR_PTR(-ENOMEM);
+
+	rval = v4l2_of_parse_endpoint(node, endpoint);
+	if (rval < 0)
+		goto out_err;
+
+	if (of_get_property(node, "link-frequencies", &len)) {
+		endpoint->link_frequencies = kmalloc(len, GFP_KERNEL);
+		if (!endpoint->link_frequencies) {
+			rval = -ENOMEM;
+			goto out_err;
+		}
+
+		endpoint->nr_of_link_frequencies =
+			len / sizeof(*endpoint->link_frequencies);
+
+		rval = of_property_read_u64_array(
+			node, "link-frequencies", endpoint->link_frequencies,
+			endpoint->nr_of_link_frequencies);
+		if (rval < 0)
+			goto out_err;
+	}
+
+	return endpoint;
+
+out_err:
+	v4l2_of_free_endpoint(endpoint);
+	return ERR_PTR(rval);
+}
+EXPORT_SYMBOL(v4l2_of_alloc_parse_endpoint);
+
 /**
  * v4l2_of_parse_link() - parse a link between two endpoints
  * @node: pointer to the endpoint at the local end of the link
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 5bbdfbf..88eb572 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -57,6 +57,8 @@ struct v4l2_of_bus_parallel {
  * @base: struct of_endpoint containing port, id, and local of_node
  * @bus_type: bus type
  * @bus: bus configuration data structure
+ * @link_frequencies: array of supported link frequencies
+ * @nr_of_link_frequencies: number of elements in link_frequenccies array
  */
 struct v4l2_of_endpoint {
 	struct of_endpoint base;
@@ -66,6 +68,8 @@ struct v4l2_of_endpoint {
 		struct v4l2_of_bus_parallel parallel;
 		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
 	} bus;
+	u64 *link_frequencies;
+	unsigned int nr_of_link_frequencies;
 };
 
 /**
@@ -85,6 +89,9 @@ struct v4l2_of_link {
 #ifdef CONFIG_OF
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint);
+struct v4l2_of_endpoint *v4l2_of_alloc_parse_endpoint(
+	const struct device_node *node);
+void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint);
 int v4l2_of_parse_link(const struct device_node *node,
 		       struct v4l2_of_link *link);
 void v4l2_of_put_link(struct v4l2_of_link *link);
@@ -96,6 +103,16 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
+struct v4l2_of_endpoint *v4l2_of_alloc_parse_endpoint(
+	const struct device_node *node)
+{
+	return NULL;
+}
+
+static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
+{
+}
+
 static inline int v4l2_of_parse_link(const struct device_node *node,
 				     struct v4l2_of_link *link)
 {
-- 
1.7.10.4

