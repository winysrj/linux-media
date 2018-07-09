Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:42770 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932798AbeGIWjq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 18:39:46 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-renesas-soc@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS
        - VIN)
Subject: [PATCH v6 05/17] media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev
Date: Mon,  9 Jul 2018 15:39:05 -0700
Message-Id: <1531175957-1973-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fwnode endpoint and reference parsing functions in v4l2-fwnode.c
are modified to make use of v4l2_async_notifier_add_subdev().
As a result the notifier->subdevs array is no longer allocated or
re-allocated, and by extension the max_subdevs value is also no
longer needed.

Callers of the fwnode endpoint and reference parsing functions must now
first initialize the notifier with a call to v4l2_async_notifier_init().
This includes the function v4l2_async_register_subdev_sensor_common(),
and the intel-ipu3, omap3isp, and rcar-vin drivers.

Since the notifier->subdevs array is no longer allocated in the
fwnode endpoint and reference parsing functions, the callers of
those functions must never reference that array, since it is now
NULL. Of the drivers that make use of the fwnode/ref parsing,
only the intel-ipu3 driver references the ->subdevs[] array,
(in the notifier completion callback), so that driver has been
modified to iterate through the notifier->asd_list instead.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v5:
- drivers must now initialize the notifier. Suggested by Sakari Ailus.
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c    |  12 +--
 drivers/media/platform/omap3isp/isp.c       |   1 +
 drivers/media/platform/rcar-vin/rcar-core.c |   4 +
 drivers/media/v4l2-core/v4l2-async.c        |   4 -
 drivers/media/v4l2-core/v4l2-fwnode.c       | 132 ++++++----------------------
 include/media/v4l2-async.h                  |   2 -
 include/media/v4l2-fwnode.h                 |  22 ++---
 7 files changed, 52 insertions(+), 125 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 2902715..4a5f7c3 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1435,13 +1435,13 @@ static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
 	struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
 						notifier);
 	struct sensor_async_subdev *s_asd;
+	struct v4l2_async_subdev *asd;
 	struct cio2_queue *q;
-	unsigned int i, pad;
+	unsigned int pad;
 	int ret;
 
-	for (i = 0; i < notifier->num_subdevs; i++) {
-		s_asd = container_of(cio2->notifier.subdevs[i],
-				     struct sensor_async_subdev, asd);
+	list_for_each_entry(asd, &cio2->notifier.asd_list, asd_list) {
+		s_asd = container_of(asd, struct sensor_async_subdev, asd);
 		q = &cio2->queue[s_asd->csi2.port];
 
 		for (pad = 0; pad < q->sensor->entity.num_pads; pad++)
@@ -1463,7 +1463,7 @@ static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
 		if (ret) {
 			dev_err(&cio2->pci_dev->dev,
 				"failed to create link for %s\n",
-				cio2->queue[i].sensor->name);
+				q->sensor->name);
 			return ret;
 		}
 	}
@@ -1499,6 +1499,8 @@ static int cio2_notifier_init(struct cio2_device *cio2)
 {
 	int ret;
 
+	v4l2_async_notifier_init(&cio2->notifier);
+
 	ret = v4l2_async_notifier_parse_fwnode_endpoints(
 		&cio2->pci_dev->dev, &cio2->notifier,
 		sizeof(struct sensor_async_subdev),
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 03354d51..1211bfe 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2220,6 +2220,7 @@ static int isp_probe(struct platform_device *pdev)
 
 	mutex_init(&isp->isp_mutex);
 	spin_lock_init(&isp->stat_lock);
+	v4l2_async_notifier_init(&isp->notifier);
 
 	ret = v4l2_async_notifier_parse_fwnode_endpoints(
 		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 8843367..10ee1859 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -615,6 +615,8 @@ static int rvin_parallel_init(struct rvin_dev *vin)
 {
 	int ret;
 
+	v4l2_async_notifier_init(&vin->notifier);
+
 	ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
 		vin->dev, &vin->notifier, sizeof(struct rvin_parallel_entity),
 		0, rvin_parallel_parse_v4l2);
@@ -807,6 +809,8 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 		return 0;
 	}
 
+	v4l2_async_notifier_init(&vin->group->notifier);
+
 	/*
 	 * Have all VIN's look for CSI-2 subdevices. Some subdevices will
 	 * overlap but the parser function can handle it, so each subdevice
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index e60a82a..78cf1a9 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -562,9 +562,6 @@ static void __v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
 		return;
 
 	if (notifier->subdevs) {
-		if (!notifier->max_subdevs)
-			return;
-
 		for (i = 0; i < notifier->num_subdevs; i++) {
 			asd = notifier->subdevs[i];
 
@@ -579,7 +576,6 @@ static void __v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
 			kfree(asd);
 		}
 
-		notifier->max_subdevs = 0;
 		kvfree(notifier->subdevs);
 		notifier->subdevs = NULL;
 	} else {
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 3240c2a..67ad333 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -316,33 +316,6 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
 
-static int v4l2_async_notifier_realloc(struct v4l2_async_notifier *notifier,
-				       unsigned int max_subdevs)
-{
-	struct v4l2_async_subdev **subdevs;
-
-	if (max_subdevs <= notifier->max_subdevs)
-		return 0;
-
-	subdevs = kvmalloc_array(
-		max_subdevs, sizeof(*notifier->subdevs),
-		GFP_KERNEL | __GFP_ZERO);
-	if (!subdevs)
-		return -ENOMEM;
-
-	if (notifier->subdevs) {
-		memcpy(subdevs, notifier->subdevs,
-		       sizeof(*subdevs) * notifier->num_subdevs);
-
-		kvfree(notifier->subdevs);
-	}
-
-	notifier->subdevs = subdevs;
-	notifier->max_subdevs = max_subdevs;
-
-	return 0;
-}
-
 static int v4l2_async_notifier_fwnode_parse_endpoint(
 	struct device *dev, struct v4l2_async_notifier *notifier,
 	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
@@ -387,8 +360,13 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 	if (ret < 0)
 		goto out_err;
 
-	notifier->subdevs[notifier->num_subdevs] = asd;
-	notifier->num_subdevs++;
+	ret = v4l2_async_notifier_add_subdev(notifier, asd);
+	if (ret < 0) {
+		/* not an error if asd already exists */
+		if (ret == -EEXIST)
+			ret = 0;
+		goto out_err;
+	}
 
 	return 0;
 
@@ -407,8 +385,7 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 			    struct v4l2_async_subdev *asd))
 {
 	struct fwnode_handle *fwnode;
-	unsigned int max_subdevs = notifier->max_subdevs;
-	int ret;
+	int ret = 0;
 
 	if (WARN_ON(asd_struct_size < sizeof(struct v4l2_async_subdev)))
 		return -EINVAL;
@@ -428,40 +405,6 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 			struct fwnode_endpoint ep;
 
 			ret = fwnode_graph_parse_endpoint(fwnode, &ep);
-			if (ret) {
-				fwnode_handle_put(fwnode);
-				return ret;
-			}
-
-			if (ep.port != port)
-				continue;
-		}
-		max_subdevs++;
-	}
-
-	/* No subdevs to add? Return here. */
-	if (max_subdevs == notifier->max_subdevs)
-		return 0;
-
-	ret = v4l2_async_notifier_realloc(notifier, max_subdevs);
-	if (ret)
-		return ret;
-
-	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
-				     dev_fwnode(dev), fwnode)); ) {
-		struct fwnode_handle *dev_fwnode;
-		bool is_available;
-
-		dev_fwnode = fwnode_graph_get_port_parent(fwnode);
-		is_available = fwnode_device_is_available(dev_fwnode);
-		fwnode_handle_put(dev_fwnode);
-		if (!is_available)
-			continue;
-
-		if (has_port) {
-			struct fwnode_endpoint ep;
-
-			ret = fwnode_graph_parse_endpoint(fwnode, &ep);
 			if (ret)
 				break;
 
@@ -469,11 +412,6 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 				continue;
 		}
 
-		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
-			ret = -EINVAL;
-			break;
-		}
-
 		ret = v4l2_async_notifier_fwnode_parse_endpoint(
 			dev, notifier, fwnode, asd_struct_size, parse_endpoint);
 		if (ret < 0)
@@ -544,31 +482,23 @@ static int v4l2_fwnode_reference_parse(
 	if (ret != -ENOENT && ret != -ENODATA)
 		return ret;
 
-	ret = v4l2_async_notifier_realloc(notifier,
-					  notifier->num_subdevs + index);
-	if (ret)
-		return ret;
-
 	for (index = 0; !fwnode_property_get_reference_args(
 		     dev_fwnode(dev), prop, NULL, 0, index, &args);
 	     index++) {
 		struct v4l2_async_subdev *asd;
 
-		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
-			ret = -EINVAL;
-			goto error;
-		}
+		asd = v4l2_async_notifier_add_fwnode_subdev(
+			notifier, args.fwnode, sizeof(*asd));
+		if (IS_ERR(asd)) {
+			ret = PTR_ERR(asd);
+			/* not an error if asd already exists */
+			if (ret == -EEXIST) {
+				fwnode_handle_put(args.fwnode);
+				continue;
+			}
 
-		asd = kzalloc(sizeof(*asd), GFP_KERNEL);
-		if (!asd) {
-			ret = -ENOMEM;
 			goto error;
 		}
-
-		notifier->subdevs[notifier->num_subdevs] = asd;
-		asd->match.fwnode = args.fwnode;
-		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		notifier->num_subdevs++;
 	}
 
 	return 0;
@@ -839,31 +769,23 @@ static int v4l2_fwnode_reference_parse_int_props(
 		index++;
 	} while (1);
 
-	ret = v4l2_async_notifier_realloc(notifier,
-					  notifier->num_subdevs + index);
-	if (ret)
-		return -ENOMEM;
-
 	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
 					 dev_fwnode(dev), prop, index, props,
 					 nprops))); index++) {
 		struct v4l2_async_subdev *asd;
 
-		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
-			ret = -EINVAL;
-			goto error;
-		}
+		asd = v4l2_async_notifier_add_fwnode_subdev(notifier, fwnode,
+							    sizeof(*asd));
+		if (IS_ERR(asd)) {
+			ret = PTR_ERR(asd);
+			/* not an error if asd already exists */
+			if (ret == -EEXIST) {
+				fwnode_handle_put(fwnode);
+				continue;
+			}
 
-		asd = kzalloc(sizeof(struct v4l2_async_subdev), GFP_KERNEL);
-		if (!asd) {
-			ret = -ENOMEM;
 			goto error;
 		}
-
-		notifier->subdevs[notifier->num_subdevs] = asd;
-		asd->match.fwnode = fwnode;
-		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		notifier->num_subdevs++;
 	}
 
 	return PTR_ERR(fwnode) == -ENOENT ? 0 : PTR_ERR(fwnode);
@@ -920,6 +842,8 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
 	if (!notifier)
 		return -ENOMEM;
 
+	v4l2_async_notifier_init(notifier);
+
 	ret = v4l2_async_notifier_parse_fwnode_sensor_common(sd->dev,
 							     notifier);
 	if (ret < 0)
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 3489e4c..16b1e2b 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -125,7 +125,6 @@ struct v4l2_async_notifier_operations {
  *
  * @ops:	notifier operations
  * @num_subdevs: number of subdevices used in the subdevs array
- * @max_subdevs: number of subdevices allocated in the subdevs array
  * @subdevs:	array of pointers to subdevice descriptors
  * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
  * @sd:		sub-device that registered the notifier, NULL otherwise
@@ -138,7 +137,6 @@ struct v4l2_async_notifier_operations {
 struct v4l2_async_notifier {
 	const struct v4l2_async_notifier_operations *ops;
 	unsigned int num_subdevs;
-	unsigned int max_subdevs;
 	struct v4l2_async_subdev **subdevs;
 	struct v4l2_device *v4l2_dev;
 	struct v4l2_subdev *sd;
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 9cccab6..ea7a8b2 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -247,7 +247,7 @@ typedef int (*parse_endpoint_func)(struct device *dev,
  *		    endpoint. Optional.
  *
  * Parse the fwnode endpoints of the @dev device and populate the async sub-
- * devices array of the notifier. The @parse_endpoint callback function is
+ * devices list in the notifier. The @parse_endpoint callback function is
  * called for each endpoint with the corresponding async sub-device pointer to
  * let the caller initialize the driver-specific part of the async sub-device
  * structure.
@@ -258,10 +258,11 @@ typedef int (*parse_endpoint_func)(struct device *dev,
  * This function may not be called on a registered notifier and may be called on
  * a notifier only once.
  *
- * Do not change the notifier's subdevs array, take references to the subdevs
- * array itself or change the notifier's num_subdevs field. This is because this
- * function allocates and reallocates the subdevs array based on parsing
- * endpoints.
+ * Do not allocate the notifier's subdevs array, or change the notifier's
+ * num_subdevs field. This is because this function uses
+ * @v4l2_async_notifier_add_subdev to populate the notifier's asd_list,
+ * which is in-place-of the subdevs array which must remain unallocated
+ * and unused.
  *
  * The &struct v4l2_fwnode_endpoint passed to the callback function
  * @parse_endpoint is released once the function is finished. If there is a need
@@ -303,7 +304,7 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
  * devices). In this case the driver must know which ports to parse.
  *
  * Parse the fwnode endpoints of the @dev device on a given @port and populate
- * the async sub-devices array of the notifier. The @parse_endpoint callback
+ * the async sub-devices list of the notifier. The @parse_endpoint callback
  * function is called for each endpoint with the corresponding async sub-device
  * pointer to let the caller initialize the driver-specific part of the async
  * sub-device structure.
@@ -314,10 +315,11 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
  * This function may not be called on a registered notifier and may be called on
  * a notifier only once per port.
  *
- * Do not change the notifier's subdevs array, take references to the subdevs
- * array itself or change the notifier's num_subdevs field. This is because this
- * function allocates and reallocates the subdevs array based on parsing
- * endpoints.
+ * Do not allocate the notifier's subdevs array, or change the notifier's
+ * num_subdevs field. This is because this function uses
+ * @v4l2_async_notifier_add_subdev to populate the notifier's asd_list,
+ * which is in-place-of the subdevs array which must remain unallocated
+ * and unused.
  *
  * The &struct v4l2_fwnode_endpoint passed to the callback function
  * @parse_endpoint is released once the function is finished. If there is a need
-- 
2.7.4
