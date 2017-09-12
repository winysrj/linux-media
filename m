Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33456 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751266AbdILImu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 04:42:50 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v11 19/24] v4l: fwnode: Add convenience function for parsing common external refs
Date: Tue, 12 Sep 2017 11:42:31 +0300
Message-Id: <20170912084236.1154-20-sakari.ailus@linux.intel.com>
In-Reply-To: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
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
 drivers/media/v4l2-core/v4l2-fwnode.c | 35 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h            |  3 ++-
 include/media/v4l2-fwnode.h           | 21 +++++++++++++++++++++
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 93bd9c29fd43..ffe86ca656f4 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -663,6 +663,41 @@ static int v4l2_fwnode_reference_parse_int_props(
 	return ret;
 }
 
+int v4l2_fwnode_reference_parse_sensor_common(
+	struct device *dev, struct v4l2_async_notifier *notifier)
+{
+	static const char *led_props[] = { "led" };
+	static const struct {
+		const char *name;
+		const char **props;
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
+EXPORT_SYMBOL_GPL(v4l2_fwnode_reference_parse_sensor_common);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index a13803a6371d..378e20e3b44d 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -155,7 +155,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
  * Release memory resources related to a notifier, including the async
  * sub-devices allocated for the purposes of the notifier. The user is
  * responsible for releasing the notifier's resources after calling
- * @v4l2_async_notifier_parse_fwnode_endpoints.
+ * @v4l2_async_notifier_parse_fwnode_endpoints or
+ * @v4l2_fwnode_reference_parse_sensor_common.
  *
  * There is no harm from calling v4l2_async_notifier_release in other
  * cases as long as its memory has been zeroed after it has been
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 31fb77e470fa..fcea9886a2b6 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -257,4 +257,25 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
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
+int v4l2_fwnode_reference_parse_sensor_common(
+	struct device *dev, struct v4l2_async_notifier *notifier);
+
 #endif /* _V4L2_FWNODE_H */
-- 
2.11.0
