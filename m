Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44778 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750824AbdJEGLn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 02:11:43 -0400
Date: Thu, 5 Oct 2017 09:11:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org,
        marc.herbert@intel.com, hyungwoo.yang@intel.com,
        rajmohan.mani@intel.com, yong.zhi@intel.com
Subject: Re: [PATCH v15 00/32] Unified fwnode endpoint parser, async
 sub-device notifier support, N9 flash DTS
Message-ID: <20171005061139.cqrauwjjhy4pwvy6@valkosipuli.retiisi.org.uk>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 05, 2017 at 12:50:19AM +0300, Sakari Ailus wrote:
> Hi folks,
> 
> 	I've dropped the full set from devicetree and linux-acpi lists;
> 	let me know if you want it back. The entire set is posted to
> 	linux-media list.

Here's the diff between v14 and v15. The patches can be found here, with
the dependencies:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=fwnode-parse>

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5aae5cb38b81..ae026eee3d03 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -248,18 +248,20 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 	list_move(&sd->async_list, &notifier->done);
 
 	/*
-	 * See if the sub-device has a notifier. If it does, proceed
-	 * with checking for its async sub-devices.
+	 * See if the sub-device has a notifier. If not, return here.
 	 */
 	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
-	if (subdev_notifier && !subdev_notifier->parent) {
-		subdev_notifier->parent = notifier;
-		ret = v4l2_async_notifier_try_all_subdevs(subdev_notifier);
-		if (ret)
-			return ret;
-	}
+	if (!subdev_notifier || subdev_notifier->parent)
+		return 0;
 
-	return 0;
+	/*
+	 * Proceed with checking for the sub-device notifier's async
+	 * sub-devices, and return the result. The error will be handled by the
+	 * caller.
+	 */
+	subdev_notifier->parent = notifier;
+
+	return v4l2_async_notifier_try_all_subdevs(subdev_notifier);
 }
 
 /* Test all async sub-devices in a notifier for a match. */
@@ -304,7 +306,28 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 	/* Subdevice driver will reprobe and put the subdev back onto the list */
 	list_del_init(&sd->async_list);
 	sd->asd = NULL;
-	sd->dev = NULL;
+}
+
+/* Unbind all sub-devices in the notifier tree. */
+static void v4l2_async_notifier_unbind_all_subdevs(
+	struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd, *tmp;
+
+	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
+		struct v4l2_async_notifier *subdev_notifier =
+			v4l2_async_find_subdev_notifier(sd);
+
+		if (subdev_notifier)
+			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
+
+		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
+		v4l2_async_cleanup(sd);
+
+		list_move(&sd->async_list, &subdev_list);
+	}
+
+	notifier->parent = NULL;
 }
 
 /* See if an fwnode can be found in a notifier's lists. */
@@ -412,9 +435,11 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 
 	ret = v4l2_async_notifier_try_all_subdevs(notifier);
 	if (ret)
-		goto out_unlock;
+		goto err_unbind;
 
 	ret = v4l2_async_notifier_try_complete(notifier);
+	if (ret)
+		goto err_unbind;
 
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
@@ -422,69 +447,74 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 out_unlock:
 	mutex_unlock(&list_lock);
 
+	return 0;
+
+err_unbind:
+	/*
+	 * On failure, unbind all sub-devices registered through this notifier.
+	 */
+	v4l2_async_notifier_unbind_all_subdevs(notifier);
+
+	mutex_unlock(&list_lock);
+
 	return ret;
 }
 
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier)
 {
+	int ret;
+
 	if (WARN_ON(!v4l2_dev || notifier->sd))
 		return -EINVAL;
 
 	notifier->v4l2_dev = v4l2_dev;
 
-	return __v4l2_async_notifier_register(notifier);
+	ret = __v4l2_async_notifier_register(notifier);
+	if (ret)
+		notifier->v4l2_dev = NULL;
+
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
 int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
 					struct v4l2_async_notifier *notifier)
 {
+	int ret;
+
 	if (WARN_ON(!sd || notifier->v4l2_dev))
 		return -EINVAL;
 
 	notifier->sd = sd;
 
-	return __v4l2_async_notifier_register(notifier);
+	ret = __v4l2_async_notifier_register(notifier);
+	if (ret)
+		notifier->sd = NULL;
+
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
 
-/* Unbind all sub-devices in the notifier tree. */
-static void v4l2_async_notifier_unbind_all_subdevs(
+static void __v4l2_async_notifier_unregister(
 	struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_subdev *sd, *tmp;
-
-	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		struct v4l2_async_notifier *subdev_notifier =
-			v4l2_async_find_subdev_notifier(sd);
-
-		if (subdev_notifier)
-			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
-
-		v4l2_async_cleanup(sd);
+	if (!notifier || (!notifier->v4l2_dev && !notifier->sd))
+		return;
 
-		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
+	v4l2_async_notifier_unbind_all_subdevs(notifier);
 
-		list_move(&sd->async_list, &subdev_list);
-	}
+	notifier->sd = NULL;
+	notifier->v4l2_dev = NULL;
 
-	notifier->parent = NULL;
+	list_del(&notifier->list);
 }
 
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
-	if (!notifier->v4l2_dev && !notifier->sd)
-		return;
-
 	mutex_lock(&list_lock);
 
-	v4l2_async_notifier_unbind_all_subdevs(notifier);
-
-	notifier->sd = NULL;
-	notifier->v4l2_dev = NULL;
-
-	list_del(&notifier->list);
+	__v4l2_async_notifier_unregister(notifier);
 
 	mutex_unlock(&list_lock);
 }
@@ -522,7 +552,9 @@ EXPORT_SYMBOL_GPL(v4l2_async_notifier_cleanup);
 
 int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
+	struct v4l2_async_notifier *subdev_notifier;
 	struct v4l2_async_notifier *notifier;
+	int ret;
 
 	/*
 	 * No reference taken. The reference is held by the device
@@ -549,47 +581,64 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 		if (!asd)
 			continue;
 
-		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
+		ret = v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
+					      asd);
+		if (ret)
+			goto err_unbind;
 
-		if (!ret)
-			ret = v4l2_async_notifier_try_complete(notifier);
+		ret = v4l2_async_notifier_try_complete(notifier);
+		if (ret)
+			goto err_unbind;
 
-		mutex_unlock(&list_lock);
-		return ret;
+		goto out_unlock;
 	}
 
 	/* None matched, wait for hot-plugging */
 	list_add(&sd->async_list, &subdev_list);
 
+out_unlock:
 	mutex_unlock(&list_lock);
 
 	return 0;
+
+err_unbind:
+	/*
+	 * Complete failed. Unbind the sub-devices bound through registering
+	 * this async sub-device.
+	 */
+	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
+	if (subdev_notifier)
+		v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
+
+	if (sd->asd)
+		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
+	v4l2_async_cleanup(sd);
+
+	mutex_unlock(&list_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_register_subdev);
 
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 {
-	struct v4l2_async_notifier *notifier = sd->notifier;
+	mutex_lock(&list_lock);
 
-	if (sd->subdev_notifier)
-		v4l2_async_notifier_unregister(sd->subdev_notifier);
+	__v4l2_async_notifier_unregister(sd->subdev_notifier);
 	v4l2_async_notifier_cleanup(sd->subdev_notifier);
 	kfree(sd->subdev_notifier);
+	sd->subdev_notifier = NULL;
 
-	if (!sd->asd) {
-		if (!list_empty(&sd->async_list))
-			v4l2_async_cleanup(sd);
-		return;
-	}
+	if (sd->asd) {
+		struct v4l2_async_notifier *notifier = sd->notifier;
 
-	mutex_lock(&list_lock);
+		list_add(&sd->asd->list, &notifier->waiting);
 
-	list_add(&sd->asd->list, &notifier->waiting);
+		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
+	}
 
 	v4l2_async_cleanup(sd);
 
-	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
-
 	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL(v4l2_async_unregister_subdev);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 74f2ea27d117..65f87e80081a 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -201,5 +201,4 @@ int __must_check v4l2_async_register_subdev_sensor_common(
  * @sd: pointer to &struct v4l2_subdev
  */
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
-
 #endif
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 834e74246412..43fd1a278bcc 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -137,7 +137,7 @@ struct v4l2_fwnode_link {
 int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 			       struct v4l2_fwnode_endpoint *vep);
 
-/*
+/**
  * v4l2_fwnode_endpoint_free() - free the V4L2 fwnode acquired by
  * v4l2_fwnode_endpoint_alloc_parse()
  * @vep - the V4L2 fwnode the resources of which are to be released


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
