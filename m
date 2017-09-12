Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751418AbdILNmF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 09:42:05 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v12 06/26] v4l: fwnode: Support generic parsing of graph endpoints, per port
Date: Tue, 12 Sep 2017 16:41:40 +0300
Message-Id: <20170912134200.19556-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is just like like v4l2_async_notifier_parse_fwnode_endpoints but it
only parses endpoints on a single port. The behaviour is useful on devices
that have both sinks and sources, in other words only some of these should
be parsed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 59 ++++++++++++++++++++++++++++++++---
 include/media/v4l2-fwnode.h           | 59 +++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index d978f2d714ca..44ee35f6aad5 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -398,9 +398,9 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 	return ret == -ENOTCONN ? 0 : ret;
 }
 
-int v4l2_async_notifier_parse_fwnode_endpoints(
+static int __v4l2_async_notifier_parse_fwnode_endpoints(
 	struct device *dev, struct v4l2_async_notifier *notifier,
-	size_t asd_struct_size,
+	size_t asd_struct_size, unsigned int port, bool has_port,
 	int (*parse_endpoint)(struct device *dev,
 			    struct v4l2_fwnode_endpoint *vep,
 			    struct v4l2_async_subdev *asd))
@@ -413,10 +413,25 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
 		return -EINVAL;
 
 	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
-				     dev_fwnode(dev), fwnode)); )
-		if (fwnode_device_is_available(
+				     dev_fwnode(dev), fwnode)); ) {
+		if (!fwnode_device_is_available(
 			    fwnode_graph_get_port_parent(fwnode)))
-			max_subdevs++;
+			continue;
+
+		if (has_port) {
+			struct fwnode_endpoint ep;
+
+			ret = fwnode_graph_parse_endpoint(fwnode, &ep);
+			if (ret) {
+				fwnode_handle_put(fwnode);
+				return ret;
+			}
+
+			if (ep.port != port)
+				continue;
+		}
+		max_subdevs++;
+	}
 
 	/* No subdevs to add? Return here. */
 	if (max_subdevs == notifier->max_subdevs)
@@ -437,6 +452,17 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
 			break;
 		}
 
+		if (has_port) {
+			struct fwnode_endpoint ep;
+
+			ret = fwnode_graph_parse_endpoint(fwnode, &ep);
+			if (ret)
+				break;
+
+			if (ep.port != port)
+				continue;
+		}
+
 		ret = v4l2_async_notifier_fwnode_parse_endpoint(
 			dev, notifier, fwnode, asd_struct_size, parse_endpoint);
 		if (ret < 0)
@@ -447,8 +473,31 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
 
 	return ret;
 }
+
+int v4l2_async_notifier_parse_fwnode_endpoints(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	size_t asd_struct_size,
+	int (*parse_endpoint)(struct device *dev,
+			    struct v4l2_fwnode_endpoint *vep,
+			    struct v4l2_async_subdev *asd))
+{
+	return __v4l2_async_notifier_parse_fwnode_endpoints(
+		dev, notifier, asd_struct_size, 0, false, parse_endpoint);
+}
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
 
+int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	size_t asd_struct_size, unsigned int port,
+	int (*parse_endpoint)(struct device *dev,
+			    struct v4l2_fwnode_endpoint *vep,
+			    struct v4l2_async_subdev *asd))
+{
+	return __v4l2_async_notifier_parse_fwnode_endpoints(
+		dev, notifier, asd_struct_size, port, true, parse_endpoint);
+}
+EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints_by_port);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 31fb77e470fa..b2eed4f33e6a 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -257,4 +257,63 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
 			      struct v4l2_fwnode_endpoint *vep,
 			      struct v4l2_async_subdev *asd));
 
+/**
+ * v4l2_async_notifier_parse_fwnode_endpoints_by_port - Parse V4L2 fwnode
+ *							endpoints of a port in a
+ *							device node
+ * @dev: the device the endpoints of which are to be parsed
+ * @notifier: notifier for @dev
+ * @asd_struct_size: size of the driver's async sub-device struct, including
+ *		     sizeof(struct v4l2_async_subdev). The &struct
+ *		     v4l2_async_subdev shall be the first member of
+ *		     the driver's async sub-device struct, i.e. both
+ *		     begin at the same memory address.
+ * @port: port number where endpoints are to be parsed
+ * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
+ *		    endpoint. Optional.
+ *		    Return: %0 on success
+ *			    %-ENOTCONN if the endpoint is to be skipped but this
+ *				       should not be considered as an error
+ *			    %-EINVAL if the endpoint configuration is invalid
+ *
+ * This function is just like @v4l2_async_notifier_parse_fwnode_endpoints with
+ * the exception that it only parses endpoints in a given port.
+ *
+ * Parse the fwnode endpoints of the @dev device on a given @port and populate
+ * the async sub-devices array of the notifier. The @parse_endpoint callback
+ * function is called for each endpoint with the corresponding async sub-device
+ * pointer to let the caller initialize the driver-specific part of the async
+ * sub-device structure.
+ *
+ * The notifier memory shall be zeroed before this function is called on the
+ * notifier.
+ *
+ * This function may not be called on a registered notifier and may be called on
+ * a notifier only once, per port.
+ *
+ * Do not change the notifier's subdevs array, take references to the subdevs
+ * array itself or change the notifier's num_subdevs field. This is because this
+ * function allocates and reallocates the subdevs array based on parsing
+ * endpoints.
+ *
+ * The @struct v4l2_fwnode_endpoint passed to the callback function
+ * @parse_endpoint is released once the function is finished. If there is a need
+ * to retain that configuration, the user needs to allocate memory for it.
+ *
+ * Any notifier populated using this function must be released with a call to
+ * v4l2_async_notifier_release() after it has been unregistered and the async
+ * sub-devices are no longer in use, even if the function returned an error.
+ *
+ * Return: %0 on success, including when no async sub-devices are found
+ *	   %-ENOMEM if memory allocation failed
+ *	   %-EINVAL if graph or endpoint parsing failed
+ *	   Other error codes as returned by @parse_endpoint
+ */
+int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	size_t asd_struct_size, unsigned int port,
+	int (*parse_endpoint)(struct device *dev,
+			      struct v4l2_fwnode_endpoint *vep,
+			      struct v4l2_async_subdev *asd));
+
 #endif /* _V4L2_FWNODE_H */
-- 
2.11.0
