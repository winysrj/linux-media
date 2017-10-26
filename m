Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43822 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932246AbdJZPDb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 11:03:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v16.1 25/32] v4l: fwnode: Add convenience function for parsing common external refs
Date: Thu, 26 Oct 2017 18:03:27 +0300
Message-Id: <20171026150327.8247-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20171026075342.5760-26-sakari.ailus@linux.intel.com>
References: <20171026075342.5760-26-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add v4l2_fwnode_parse_reference_sensor_common for parsing common
sensor properties that refer to adjacent devices such as flash or lens
driver chips.

As this is an association only, there's little a regular driver needs to
know about these devices as such.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
since v16:

- use const char * const *props for string arrays with property names.

 drivers/media/v4l2-core/v4l2-fwnode.c | 35 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h            |  3 ++-
 include/media/v4l2-fwnode.h           | 21 +++++++++++++++++++++
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index f8cd88f791c4..39387dc6cadd 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -865,6 +865,41 @@ static int v4l2_fwnode_reference_parse_int_props(
 	return ret;
 }
 
+int v4l2_async_notifier_parse_fwnode_sensor_common(
+	struct device *dev, struct v4l2_async_notifier *notifier)
+{
+	static const char * const led_props[] = { "led" };
+	static const struct {
+		const char *name;
+		const char * const *props;
+		unsigned int nprops;
+	} props[] = {
+		{ "flash-leds", led_props, ARRAY_SIZE(led_props) },
+		{ "lens-focus", NULL, 0 },
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(props); i++) {
+		int ret;
+
+		if (props[i].props && is_acpi_node(dev_fwnode(dev)))
+			ret = v4l2_fwnode_reference_parse_int_props(
+				dev, notifier, props[i].name,
+				props[i].props, props[i].nprops);
+		else
+			ret = v4l2_fwnode_reference_parse(
+				dev, notifier, props[i].name);
+		if (ret && ret != -ENOENT) {
+			dev_warn(dev, "parsing property \"%s\" failed (%d)\n",
+				 props[i].name, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_sensor_common);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 17c4ac7c73e8..8d8cfc3f3100 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -156,7 +156,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
  * Release memory resources related to a notifier, including the async
  * sub-devices allocated for the purposes of the notifier but not the notifier
  * itself. The user is responsible for calling this function to clean up the
- * notifier after calling @v4l2_async_notifier_parse_fwnode_endpoints.
+ * notifier after calling @v4l2_async_notifier_parse_fwnode_endpoints or
+ * @v4l2_fwnode_reference_parse_sensor_common.
  *
  * There is no harm from calling v4l2_async_notifier_cleanup in other
  * cases as long as its memory has been zeroed after it has been
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 105cfeee44ef..ca50108dfd8f 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -319,4 +319,25 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
 			      struct v4l2_fwnode_endpoint *vep,
 			      struct v4l2_async_subdev *asd));
 
+/**
+ * v4l2_fwnode_reference_parse_sensor_common - parse common references on
+ *					       sensors for async sub-devices
+ * @dev: the device node the properties of which are parsed for references
+ * @notifier: the async notifier where the async subdevs will be added
+ *
+ * Parse common sensor properties for remote devices related to the
+ * sensor and set up async sub-devices for them.
+ *
+ * Any notifier populated using this function must be released with a call to
+ * v4l2_async_notifier_release() after it has been unregistered and the async
+ * sub-devices are no longer in use, even in the case the function returned an
+ * error.
+ *
+ * Return: 0 on success
+ *	   -ENOMEM if memory allocation failed
+ *	   -EINVAL if property parsing failed
+ */
+int v4l2_async_notifier_parse_fwnode_sensor_common(
+	struct device *dev, struct v4l2_async_notifier *notifier);
+
 #endif /* _V4L2_FWNODE_H */
-- 
2.11.0
