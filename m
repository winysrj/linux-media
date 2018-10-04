Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46286 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeJEFJU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 01:09:20 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 1/3] media: v4l2-core: cleanup coding style at V4L2 async/fwnode
Date: Thu,  4 Oct 2018 18:13:46 -0400
Message-Id: <cde4a0f967c695aa56fcb28f1b70cffcd4b55666.1538690587.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1538690587.git.mchehab+samsung@kernel.org>
References: <cover.1538690587.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1538690587.git.mchehab+samsung@kernel.org>
References: <cover.1538690587.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several coding style issues at those definitions,
and the previous patchset added even more.

Address the trivial ones by first calling:

	./scripts/checkpatch.pl --strict --fix-inline include/media/v4l2-async.h include/media/v4l2-fwnode.h include/media/v4l2-mediabus.h drivers/media/v4l2-core/v4l2-async.c drivers/media/v4l2-core/v4l2-fwnode.c

and then manually adjusting the style where needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c  |  45 ++++---
 drivers/media/v4l2-core/v4l2-fwnode.c | 185 +++++++++++++++-----------
 include/media/v4l2-async.h            |  12 +-
 include/media/v4l2-fwnode.h           |  46 ++++---
 include/media/v4l2-mediabus.h         |  32 +++--
 5 files changed, 179 insertions(+), 141 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 70adbd9a01a2..6fdda745a1da 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -57,6 +57,7 @@ static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
 #if IS_ENABLED(CONFIG_I2C)
 	struct i2c_client *client = i2c_verify_client(sd->dev);
+
 	return client &&
 		asd->match.i2c.adapter_id == client->adapter->nr &&
 		asd->match.i2c.address == client->addr;
@@ -89,10 +90,11 @@ static LIST_HEAD(subdev_list);
 static LIST_HEAD(notifier_list);
 static DEFINE_MUTEX(list_lock);
 
-static struct v4l2_async_subdev *v4l2_async_find_match(
-	struct v4l2_async_notifier *notifier, struct v4l2_subdev *sd)
+static struct
+v4l2_async_subdev *v4l2_async_find_match(struct v4l2_async_notifier *notifier,
+					 struct v4l2_subdev *sd)
 {
-	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
+	bool (*match)(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd);
 	struct v4l2_async_subdev *asd;
 
 	list_for_each_entry(asd, &notifier->waiting, list) {
@@ -150,8 +152,8 @@ static bool asd_equal(struct v4l2_async_subdev *asd_x,
 }
 
 /* Find the sub-device notifier registered by a sub-device driver. */
-static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
-	struct v4l2_subdev *sd)
+static struct v4l2_async_notifier *
+v4l2_async_find_subdev_notifier(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *n;
 
@@ -163,8 +165,8 @@ static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
 }
 
 /* Get v4l2_device related to the notifier if one can be found. */
-static struct v4l2_device *v4l2_async_notifier_find_v4l2_dev(
-	struct v4l2_async_notifier *notifier)
+static struct v4l2_device *
+v4l2_async_notifier_find_v4l2_dev(struct v4l2_async_notifier *notifier)
 {
 	while (notifier->parent)
 		notifier = notifier->parent;
@@ -175,8 +177,8 @@ static struct v4l2_device *v4l2_async_notifier_find_v4l2_dev(
 /*
  * Return true if all child sub-device notifiers are complete, false otherwise.
  */
-static bool v4l2_async_notifier_can_complete(
-	struct v4l2_async_notifier *notifier)
+static bool
+v4l2_async_notifier_can_complete(struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_subdev *sd;
 
@@ -199,8 +201,8 @@ static bool v4l2_async_notifier_can_complete(
  * Complete the master notifier if possible. This is done when all async
  * sub-devices have been bound; v4l2_device is also available then.
  */
-static int v4l2_async_notifier_try_complete(
-	struct v4l2_async_notifier *notifier)
+static int
+v4l2_async_notifier_try_complete(struct v4l2_async_notifier *notifier)
 {
 	/* Quick check whether there are still more sub-devices here. */
 	if (!list_empty(&notifier->waiting))
@@ -221,8 +223,8 @@ static int v4l2_async_notifier_try_complete(
 	return v4l2_async_notifier_call_complete(notifier);
 }
 
-static int v4l2_async_notifier_try_all_subdevs(
-	struct v4l2_async_notifier *notifier);
+static int
+v4l2_async_notifier_try_all_subdevs(struct v4l2_async_notifier *notifier);
 
 static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 				   struct v4l2_device *v4l2_dev,
@@ -268,8 +270,8 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 }
 
 /* Test all async sub-devices in a notifier for a match. */
-static int v4l2_async_notifier_try_all_subdevs(
-	struct v4l2_async_notifier *notifier)
+static int
+v4l2_async_notifier_try_all_subdevs(struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_device *v4l2_dev =
 		v4l2_async_notifier_find_v4l2_dev(notifier);
@@ -306,14 +308,17 @@ static int v4l2_async_notifier_try_all_subdevs(
 static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 {
 	v4l2_device_unregister_subdev(sd);
-	/* Subdevice driver will reprobe and put the subdev back onto the list */
+	/*
+	 * Subdevice driver will reprobe and put the subdev back
+	 * onto the list
+	 */
 	list_del_init(&sd->async_list);
 	sd->asd = NULL;
 }
 
 /* Unbind all sub-devices in the notifier tree. */
-static void v4l2_async_notifier_unbind_all_subdevs(
-	struct v4l2_async_notifier *notifier)
+static void
+v4l2_async_notifier_unbind_all_subdevs(struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_subdev *sd, *tmp;
 
@@ -508,8 +513,8 @@ int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
 }
 EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
 
-static void __v4l2_async_notifier_unregister(
-	struct v4l2_async_notifier *notifier)
+static void
+__v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
 	if (!notifier || (!notifier->v4l2_dev && !notifier->sd))
 		return;
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 6300b599c73d..4e518d5fddd8 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -211,7 +211,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	if (lanes_used & BIT(clock_lane)) {
 		if (have_clk_lane || !use_default_lane_mapping)
 			pr_warn("duplicated lane %u in clock-lanes, using defaults\n",
-			v);
+				v);
 		use_default_lane_mapping = true;
 	}
 
@@ -265,9 +265,10 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 			     V4L2_MBUS_FIELD_EVEN_HIGH |	\
 			     V4L2_MBUS_FIELD_EVEN_LOW)
 
-static void v4l2_fwnode_endpoint_parse_parallel_bus(
-	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep,
-	enum v4l2_mbus_type bus_type)
+static void
+v4l2_fwnode_endpoint_parse_parallel_bus(struct fwnode_handle *fwnode,
+					struct v4l2_fwnode_endpoint *vep,
+					enum v4l2_mbus_type bus_type)
 {
 	struct v4l2_fwnode_bus_parallel *bus = &vep->bus.parallel;
 	unsigned int flags = 0;
@@ -436,8 +437,7 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		if (mbus_type != V4L2_MBUS_UNKNOWN &&
 		    vep->bus_type != mbus_type) {
 			pr_debug("expecting bus type %s\n",
-				 v4l2_fwnode_mbus_type_to_string(
-					 vep->bus_type));
+				 v4l2_fwnode_mbus_type_to_string(vep->bus_type));
 			return -ENXIO;
 		}
 	} else {
@@ -452,8 +452,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			return rval;
 
 		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
-			v4l2_fwnode_endpoint_parse_parallel_bus(
-				fwnode, vep, V4L2_MBUS_UNKNOWN);
+			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep,
+								V4L2_MBUS_UNKNOWN);
 
 		pr_debug("assuming media bus type %s (%u)\n",
 			 v4l2_fwnode_mbus_type_to_string(vep->bus_type),
@@ -511,8 +511,8 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep)
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_free);
 
-int v4l2_fwnode_endpoint_alloc_parse(
-	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep)
+int v4l2_fwnode_endpoint_alloc_parse(struct fwnode_handle *fwnode,
+				     struct v4l2_fwnode_endpoint *vep)
 {
 	int rval;
 
@@ -533,9 +533,10 @@ int v4l2_fwnode_endpoint_alloc_parse(
 
 		vep->nr_of_link_frequencies = rval;
 
-		rval = fwnode_property_read_u64_array(
-			fwnode, "link-frequencies", vep->link_frequencies,
-			vep->nr_of_link_frequencies);
+		rval = fwnode_property_read_u64_array(fwnode,
+						      "link-frequencies",
+						      vep->link_frequencies,
+						      vep->nr_of_link_frequencies);
 		if (rval < 0) {
 			v4l2_fwnode_endpoint_free(vep);
 			return rval;
@@ -593,12 +594,14 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
 
-static int v4l2_async_notifier_fwnode_parse_endpoint(
-	struct device *dev, struct v4l2_async_notifier *notifier,
-	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
-	int (*parse_endpoint)(struct device *dev,
-			    struct v4l2_fwnode_endpoint *vep,
-			    struct v4l2_async_subdev *asd))
+static int
+v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
+		struct v4l2_async_notifier *notifier,
+		struct fwnode_handle *endpoint,
+		unsigned int asd_struct_size,
+		int (*parse_endpoint)(struct device *dev,
+				      struct v4l2_fwnode_endpoint *vep,
+				      struct v4l2_async_subdev *asd))
 {
 	struct v4l2_fwnode_endpoint vep = { .bus_type = 0 };
 	struct v4l2_async_subdev *asd;
@@ -653,12 +656,14 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 	return ret == -ENOTCONN ? 0 : ret;
 }
 
-static int __v4l2_async_notifier_parse_fwnode_endpoints(
-	struct device *dev, struct v4l2_async_notifier *notifier,
-	size_t asd_struct_size, unsigned int port, bool has_port,
-	int (*parse_endpoint)(struct device *dev,
-			    struct v4l2_fwnode_endpoint *vep,
-			    struct v4l2_async_subdev *asd))
+static int
+__v4l2_async_notifier_parse_fwnode_endpoints(struct device *dev,
+			struct v4l2_async_notifier *notifier,
+			size_t asd_struct_size,
+			unsigned int port, bool has_port,
+			int (*parse_endpoint)(struct device *dev,
+					      struct v4l2_fwnode_endpoint *vep,
+					      struct v4l2_async_subdev *asd))
 {
 	struct fwnode_handle *fwnode;
 	int ret = 0;
@@ -687,8 +692,11 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 				continue;
 		}
 
-		ret = v4l2_async_notifier_fwnode_parse_endpoint(
-			dev, notifier, fwnode, asd_struct_size, parse_endpoint);
+		ret = v4l2_async_notifier_fwnode_parse_endpoint(dev,
+								notifier,
+								fwnode,
+								asd_struct_size,
+								parse_endpoint);
 		if (ret < 0)
 			break;
 	}
@@ -698,27 +706,33 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 	return ret;
 }
 
-int v4l2_async_notifier_parse_fwnode_endpoints(
-	struct device *dev, struct v4l2_async_notifier *notifier,
-	size_t asd_struct_size,
-	int (*parse_endpoint)(struct device *dev,
-			    struct v4l2_fwnode_endpoint *vep,
-			    struct v4l2_async_subdev *asd))
+int
+v4l2_async_notifier_parse_fwnode_endpoints(struct device *dev,
+		struct v4l2_async_notifier *notifier,
+		size_t asd_struct_size,
+		int (*parse_endpoint)(struct device *dev,
+				      struct v4l2_fwnode_endpoint *vep,
+				      struct v4l2_async_subdev *asd))
 {
-	return __v4l2_async_notifier_parse_fwnode_endpoints(
-		dev, notifier, asd_struct_size, 0, false, parse_endpoint);
+	return __v4l2_async_notifier_parse_fwnode_endpoints(dev, notifier,
+							    asd_struct_size, 0,
+							    false,
+							    parse_endpoint);
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
 
-int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
-	struct device *dev, struct v4l2_async_notifier *notifier,
-	size_t asd_struct_size, unsigned int port,
-	int (*parse_endpoint)(struct device *dev,
-			    struct v4l2_fwnode_endpoint *vep,
-			    struct v4l2_async_subdev *asd))
+int
+v4l2_async_notifier_parse_fwnode_endpoints_by_port(struct device *dev,
+			struct v4l2_async_notifier *notifier,
+			size_t asd_struct_size, unsigned int port,
+			int (*parse_endpoint)(struct device *dev,
+					      struct v4l2_fwnode_endpoint *vep,
+					      struct v4l2_async_subdev *asd))
 {
-	return __v4l2_async_notifier_parse_fwnode_endpoints(
-		dev, notifier, asd_struct_size, port, true, parse_endpoint);
+	return __v4l2_async_notifier_parse_fwnode_endpoints(dev, notifier,
+							    asd_struct_size,
+							    port, true,
+							    parse_endpoint);
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints_by_port);
 
@@ -733,17 +747,18 @@ EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints_by_port);
  *	   -ENOMEM if memory allocation failed
  *	   -EINVAL if property parsing failed
  */
-static int v4l2_fwnode_reference_parse(
-	struct device *dev, struct v4l2_async_notifier *notifier,
-	const char *prop)
+static int v4l2_fwnode_reference_parse(struct device *dev,
+				       struct v4l2_async_notifier *notifier,
+				       const char *prop)
 {
 	struct fwnode_reference_args args;
 	unsigned int index;
 	int ret;
 
 	for (index = 0;
-	     !(ret = fwnode_property_get_reference_args(
-		       dev_fwnode(dev), prop, NULL, 0, index, &args));
+	     !(ret = fwnode_property_get_reference_args(dev_fwnode(dev),
+							prop, NULL, 0,
+							index, &args));
 	     index++)
 		fwnode_handle_put(args.fwnode);
 
@@ -757,13 +772,15 @@ static int v4l2_fwnode_reference_parse(
 	if (ret != -ENOENT && ret != -ENODATA)
 		return ret;
 
-	for (index = 0; !fwnode_property_get_reference_args(
-		     dev_fwnode(dev), prop, NULL, 0, index, &args);
+	for (index = 0;
+	     !fwnode_property_get_reference_args(dev_fwnode(dev), prop, NULL,
+						 0, index, &args);
 	     index++) {
 		struct v4l2_async_subdev *asd;
 
-		asd = v4l2_async_notifier_add_fwnode_subdev(
-			notifier, args.fwnode, sizeof(*asd));
+		asd = v4l2_async_notifier_add_fwnode_subdev(notifier,
+							    args.fwnode,
+							    sizeof(*asd));
 		if (IS_ERR(asd)) {
 			ret = PTR_ERR(asd);
 			/* not an error if asd already exists */
@@ -939,9 +956,12 @@ static int v4l2_fwnode_reference_parse(
  *	   -EINVAL if property parsing otherwise failed
  *	   -ENOMEM if memory allocation failed
  */
-static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
-	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
-	const char * const *props, unsigned int nprops)
+static struct fwnode_handle *
+v4l2_fwnode_reference_get_int_prop(struct fwnode_handle *fwnode,
+				   const char *prop,
+				   unsigned int index,
+				   const char * const *props,
+				   unsigned int nprops)
 {
 	struct fwnode_reference_args fwnode_args;
 	u64 *args = fwnode_args.args;
@@ -1016,9 +1036,12 @@ static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
  *	   -EINVAL if property parsing otherwisefailed
  *	   -ENOMEM if memory allocation failed
  */
-static int v4l2_fwnode_reference_parse_int_props(
-	struct device *dev, struct v4l2_async_notifier *notifier,
-	const char *prop, const char * const *props, unsigned int nprops)
+static int
+v4l2_fwnode_reference_parse_int_props(struct device *dev,
+				      struct v4l2_async_notifier *notifier,
+				      const char *prop,
+				      const char * const *props,
+				      unsigned int nprops)
 {
 	struct fwnode_handle *fwnode;
 	unsigned int index;
@@ -1044,9 +1067,12 @@ static int v4l2_fwnode_reference_parse_int_props(
 		index++;
 	} while (1);
 
-	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
-					 dev_fwnode(dev), prop, index, props,
-					 nprops))); index++) {
+	for (index = 0;
+	     !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(dev_fwnode(dev),
+								  prop, index,
+								  props,
+								  nprops)));
+	     index++) {
 		struct v4l2_async_subdev *asd;
 
 		asd = v4l2_async_notifier_add_fwnode_subdev(notifier, fwnode,
@@ -1070,8 +1096,8 @@ static int v4l2_fwnode_reference_parse_int_props(
 	return ret;
 }
 
-int v4l2_async_notifier_parse_fwnode_sensor_common(
-	struct device *dev, struct v4l2_async_notifier *notifier)
+int v4l2_async_notifier_parse_fwnode_sensor_common(struct device *dev,
+						   struct v4l2_async_notifier *notifier)
 {
 	static const char * const led_props[] = { "led" };
 	static const struct {
@@ -1088,12 +1114,14 @@ int v4l2_async_notifier_parse_fwnode_sensor_common(
 		int ret;
 
 		if (props[i].props && is_acpi_node(dev_fwnode(dev)))
-			ret = v4l2_fwnode_reference_parse_int_props(
-				dev, notifier, props[i].name,
-				props[i].props, props[i].nprops);
+			ret = v4l2_fwnode_reference_parse_int_props(dev,
+								    notifier,
+								    props[i].name,
+								    props[i].props,
+								    props[i].nprops);
 		else
-			ret = v4l2_fwnode_reference_parse(
-				dev, notifier, props[i].name);
+			ret = v4l2_fwnode_reference_parse(dev, notifier,
+							  props[i].name);
 		if (ret && ret != -ENOENT) {
 			dev_warn(dev, "parsing property \"%s\" failed (%d)\n",
 				 props[i].name, ret);
@@ -1147,12 +1175,12 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
 }
 EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
 
-int v4l2_async_register_fwnode_subdev(
-	struct v4l2_subdev *sd, size_t asd_struct_size,
-	unsigned int *ports, unsigned int num_ports,
-	int (*parse_endpoint)(struct device *dev,
-			      struct v4l2_fwnode_endpoint *vep,
-			      struct v4l2_async_subdev *asd))
+int v4l2_async_register_fwnode_subdev(struct v4l2_subdev *sd,
+			size_t asd_struct_size,
+			unsigned int *ports, unsigned int num_ports,
+			int (*parse_endpoint)(struct device *dev,
+					      struct v4l2_fwnode_endpoint *vep,
+					      struct v4l2_async_subdev *asd))
 {
 	struct v4l2_async_notifier *notifier;
 	struct device *dev = sd->dev;
@@ -1173,17 +1201,16 @@ int v4l2_async_register_fwnode_subdev(
 	v4l2_async_notifier_init(notifier);
 
 	if (!ports) {
-		ret = v4l2_async_notifier_parse_fwnode_endpoints(
-			dev, notifier, asd_struct_size, parse_endpoint);
+		ret = v4l2_async_notifier_parse_fwnode_endpoints(dev, notifier,
+								 asd_struct_size,
+								 parse_endpoint);
 		if (ret < 0)
 			goto out_cleanup;
 	} else {
 		unsigned int i;
 
 		for (i = 0; i < num_ports; i++) {
-			ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
-				dev, notifier, asd_struct_size,
-				ports[i], parse_endpoint);
+			ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(dev, notifier, asd_struct_size, ports[i], parse_endpoint);
 			if (ret < 0)
 				goto out_cleanup;
 		}
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 89b152f52ef9..1497bda66c3b 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -89,8 +89,8 @@ struct v4l2_async_subdev {
 			unsigned short address;
 		} i2c;
 		struct {
-			bool (*match)(struct device *,
-				      struct v4l2_async_subdev *);
+			bool (*match)(struct device *dev,
+				      struct v4l2_async_subdev *sd);
 			void *priv;
 		} custom;
 	} match;
@@ -222,7 +222,6 @@ v4l2_async_notifier_add_devname_subdev(struct v4l2_async_notifier *notifier,
 				       const char *device_name,
 				       unsigned int asd_struct_size);
 
-
 /**
  * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
  *
@@ -243,7 +242,8 @@ int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
 					struct v4l2_async_notifier *notifier);
 
 /**
- * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
+ * v4l2_async_notifier_unregister - unregisters a subdevice
+ *	asynchronous notifier
  *
  * @notifier: pointer to &struct v4l2_async_notifier
  */
@@ -294,8 +294,8 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd);
  * An error is returned if the module is no longer loaded on any attempts
  * to register it.
  */
-int __must_check v4l2_async_register_subdev_sensor_common(
-	struct v4l2_subdev *sd);
+int __must_check
+v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd);
 
 /**
  * v4l2_async_unregister_subdev - unregisters a sub-device to the asynchronous
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index b4a49ca27579..21b3f9e5c269 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -71,8 +71,8 @@ struct v4l2_fwnode_bus_parallel {
  * @clock_lane: the number of the clock lane
  */
 struct v4l2_fwnode_bus_mipi_csi1 {
-	bool clock_inv;
-	bool strobe;
+	unsigned char clock_inv:1;
+	unsigned char strobe:1;
 	bool lane_polarity[2];
 	unsigned char data_lane;
 	unsigned char clock_lane;
@@ -203,8 +203,8 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
  *	   %-EINVAL on parsing failure
  *	   %-ENXIO on mismatching bus types
  */
-int v4l2_fwnode_endpoint_alloc_parse(
-	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep);
+int v4l2_fwnode_endpoint_alloc_parse(struct fwnode_handle *fwnode,
+				     struct v4l2_fwnode_endpoint *vep);
 
 /**
  * v4l2_fwnode_parse_link() - parse a link between two endpoints
@@ -236,7 +236,6 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
  */
 void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
 
-
 /**
  * typedef parse_endpoint_func - Driver's callback function to be called on
  *	each V4L2 fwnode endpoint.
@@ -255,7 +254,6 @@ typedef int (*parse_endpoint_func)(struct device *dev,
 				  struct v4l2_fwnode_endpoint *vep,
 				  struct v4l2_async_subdev *asd);
 
-
 /**
  * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints in a
  *						device node
@@ -294,10 +292,11 @@ typedef int (*parse_endpoint_func)(struct device *dev,
  *	   %-EINVAL if graph or endpoint parsing failed
  *	   Other error codes as returned by @parse_endpoint
  */
-int v4l2_async_notifier_parse_fwnode_endpoints(
-	struct device *dev, struct v4l2_async_notifier *notifier,
-	size_t asd_struct_size,
-	parse_endpoint_func parse_endpoint);
+int
+v4l2_async_notifier_parse_fwnode_endpoints(struct device *dev,
+					   struct v4l2_async_notifier *notifier,
+					   size_t asd_struct_size,
+					   parse_endpoint_func parse_endpoint);
 
 /**
  * v4l2_async_notifier_parse_fwnode_endpoints_by_port - Parse V4L2 fwnode
@@ -345,10 +344,11 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
  *	   %-EINVAL if graph or endpoint parsing failed
  *	   Other error codes as returned by @parse_endpoint
  */
-int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
-	struct device *dev, struct v4l2_async_notifier *notifier,
-	size_t asd_struct_size, unsigned int port,
-	parse_endpoint_func parse_endpoint);
+int
+v4l2_async_notifier_parse_fwnode_endpoints_by_port(struct device *dev,
+				struct v4l2_async_notifier *notifier,
+				size_t asd_struct_size, unsigned int port,
+				parse_endpoint_func parse_endpoint);
 
 /**
  * v4l2_fwnode_reference_parse_sensor_common - parse common references on
@@ -368,8 +368,8 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
  *	   -ENOMEM if memory allocation failed
  *	   -EINVAL if property parsing failed
  */
-int v4l2_async_notifier_parse_fwnode_sensor_common(
-	struct device *dev, struct v4l2_async_notifier *notifier);
+int v4l2_async_notifier_parse_fwnode_sensor_common(struct device *dev,
+					struct v4l2_async_notifier *notifier);
 
 /**
  * v4l2_async_register_fwnode_subdev - registers a sub-device to the
@@ -401,11 +401,13 @@ int v4l2_async_notifier_parse_fwnode_sensor_common(
  * An error is returned if the module is no longer loaded on any attempts
  * to register it.
  */
-int v4l2_async_register_fwnode_subdev(
-	struct v4l2_subdev *sd, size_t asd_struct_size,
-	unsigned int *ports, unsigned int num_ports,
-	int (*parse_endpoint)(struct device *dev,
-			      struct v4l2_fwnode_endpoint *vep,
-			      struct v4l2_async_subdev *asd));
+int
+v4l2_async_register_fwnode_subdev(struct v4l2_subdev *sd,
+			size_t asd_struct_size,
+			unsigned int *ports,
+			unsigned int num_ports,
+			int (*parse_endpoint)(struct device *dev,
+					      struct v4l2_fwnode_endpoint *vep,
+					      struct v4l2_async_subdev *asd));
 
 #endif /* _V4L2_FWNODE_H */
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index df1d552e9df6..66cb746ceeb5 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -14,7 +14,6 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/bitops.h>
 
-
 /* Parallel flags */
 /*
  * Can the client run in master or in slave mode. By "Master mode" an operation
@@ -63,10 +62,14 @@
 #define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		BIT(8)
 #define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	BIT(9)
 
-#define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE | V4L2_MBUS_CSI2_2_LANE | \
-					 V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
-#define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 | V4L2_MBUS_CSI2_CHANNEL_1 | \
-					 V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
+#define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE | \
+					 V4L2_MBUS_CSI2_2_LANE | \
+					 V4L2_MBUS_CSI2_3_LANE | \
+					 V4L2_MBUS_CSI2_4_LANE)
+#define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 | \
+					 V4L2_MBUS_CSI2_CHANNEL_1 | \
+					 V4L2_MBUS_CSI2_CHANNEL_2 | \
+					 V4L2_MBUS_CSI2_CHANNEL_3)
 
 /**
  * enum v4l2_mbus_type - media bus type
@@ -106,8 +109,9 @@ struct v4l2_mbus_config {
  * @pix_fmt:	pointer to &struct v4l2_pix_format to be filled
  * @mbus_fmt:	pointer to &struct v4l2_mbus_framefmt to be used as model
  */
-static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
-				const struct v4l2_mbus_framefmt *mbus_fmt)
+static inline void
+v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
+		     const struct v4l2_mbus_framefmt *mbus_fmt)
 {
 	pix_fmt->width = mbus_fmt->width;
 	pix_fmt->height = mbus_fmt->height;
@@ -128,7 +132,7 @@ static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
  * @code:	data format code (from &enum v4l2_mbus_pixelcode)
  */
 static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
-			   const struct v4l2_pix_format *pix_fmt,
+					 const struct v4l2_pix_format *pix_fmt,
 			   u32 code)
 {
 	mbus_fmt->width = pix_fmt->width;
@@ -148,9 +152,9 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
  * @pix_mp_fmt:	pointer to &struct v4l2_pix_format_mplane to be filled
  * @mbus_fmt:	pointer to &struct v4l2_mbus_framefmt to be used as model
  */
-static inline void v4l2_fill_pix_format_mplane(
-				struct v4l2_pix_format_mplane *pix_mp_fmt,
-				const struct v4l2_mbus_framefmt *mbus_fmt)
+static inline void
+v4l2_fill_pix_format_mplane(struct v4l2_pix_format_mplane *pix_mp_fmt,
+			    const struct v4l2_mbus_framefmt *mbus_fmt)
 {
 	pix_mp_fmt->width = mbus_fmt->width;
 	pix_mp_fmt->height = mbus_fmt->height;
@@ -168,9 +172,9 @@ static inline void v4l2_fill_pix_format_mplane(
  * @mbus_fmt:	pointer to &struct v4l2_mbus_framefmt to be filled
  * @pix_mp_fmt:	pointer to &struct v4l2_pix_format_mplane to be used as model
  */
-static inline void v4l2_fill_mbus_format_mplane(
-				struct v4l2_mbus_framefmt *mbus_fmt,
-				const struct v4l2_pix_format_mplane *pix_mp_fmt)
+static inline void
+v4l2_fill_mbus_format_mplane(struct v4l2_mbus_framefmt *mbus_fmt,
+			     const struct v4l2_pix_format_mplane *pix_mp_fmt)
 {
 	mbus_fmt->width = pix_mp_fmt->width;
 	mbus_fmt->height = pix_mp_fmt->height;
-- 
2.17.1
