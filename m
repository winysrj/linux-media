Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:60474 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753024AbdFMObE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:31:04 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 2/2] v4l: async: add subnotifier registration for subdevices
Date: Tue, 13 Jun 2017 16:30:36 +0200
Message-Id: <20170613143036.533-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170613143036.533-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170613143036.533-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the registered() callback of v4l2_subdev_internal_ops is called the
subdevice has access to the master devices v4l2_dev and it's called with
the async frameworks list_lock held. In this context the subdevice can
register its own notifiers to allow for incremental discovery of
subdevices.

The master device registers the subdevices closest to itself in its
notifier while the subdevice(s) register notifiers for their closest
neighboring devices when they are registered. Using this incremental
approach two problems can be solved:

1. The master device no longer has to care how many devices exist in
   the pipeline. It only needs to care about its closest subdevice and
   arbitrary long pipelines can be created without having to adapt the
   master device for each case.

2. Subdevices which are represented as a single DT node but register
   more than one subdevice can use this to improve the pipeline
   discovery, since the subdevice driver is the only one who knows which
   of its subdevices is linked with which subdevice of a neighboring DT
   node.

To enable subdevices to register/unregister notifiers from the
registered()/unregistered() callback v4l2_async_subnotifier_register()
and v4l2_async_subnotifier_unregister() are added. These new notifier
register functions are similar to the master device equivalent functions
but run without taking the v4l2-async list_lock which already is held
when the registered()/unregistered() callbacks are called.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/kapi/v4l2-subdev.rst | 20 ++++++++++
 drivers/media/v4l2-core/v4l2-async.c     | 65 +++++++++++++++++++++++++++-----
 include/media/v4l2-async.h               | 22 +++++++++++
 3 files changed, 98 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index e1f0b726e438f963..e308f30887a8f1b5 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -262,6 +262,26 @@ is called. After all subdevices have been located the .complete() callback is
 called. When a subdevice is removed from the system the .unbind() method is
 called. All three callbacks are optional.
 
+Subdevice drivers might in turn register subnotifier objects with an
+array of other subdevice descriptors that the subdevice needs for its
+own operation. Subnotifiers are an extension of the bridge drivers
+notifier to allow for a incremental registering and matching of
+subdevices. This is useful when a driver only has information about
+which subdevice is closest to itself and would require knowledge from the
+driver of that subdevice to know which other subdevice(s) lie beyond.
+By registering subnotifiers drivers can incrementally move the subdevice
+matching down the chain of drivers. This is performed using the
+:c:func:`v4l2_async_subnotifier_register` call. To unregister the
+subnotifier the driver has to call
+:c:func:`v4l2_async_subnotifier_unregister`. These functions and their
+arguments behave almost the same as the bridge driver notifiers
+described above and are treated equally by the V4L2 core when matching
+asynchronously registered subdevices. The differences are that the
+subnotifier functions act on :c:type:`v4l2_subdev` instead of
+:c:type:`v4l2_device` and that they should be called from the subdevice's
+``.registered()`` and ``.unregistered()``
+:c:type:`v4l2_subdev_internal_ops` callbacks instead of at probe time.
+
 V4L2 sub-device userspace API
 -----------------------------
 
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index c16200c88417b151..0b8135bf55af6b09 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -141,8 +141,9 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 	sd->dev = NULL;
 }
 
-int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
-				 struct v4l2_async_notifier *notifier)
+static int v4l2_async_do_notifier_register(struct v4l2_device *v4l2_dev,
+					   struct v4l2_async_notifier *notifier,
+					   bool subnotifier)
 {
 	struct v4l2_subdev *sd, *tmp;
 	struct v4l2_async_subdev *asd;
@@ -174,8 +175,17 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		list_add_tail(&asd->list, &notifier->waiting);
 	}
 
-	mutex_lock(&list_lock);
+	if (subnotifier)
+		lockdep_assert_held(&list_lock);
+	else
+		mutex_lock(&list_lock);
 
+	/*
+	 * This function can be called recursively so the list
+	 * might be modified in a recursive call. Start from the
+	 * top of the list each iteration.
+	 */
+again:
 	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
 		int ret;
 
@@ -185,21 +195,39 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 
 		ret = v4l2_async_test_notify(notifier, sd, asd);
 		if (ret < 0) {
-			mutex_unlock(&list_lock);
+			if (!subnotifier)
+				mutex_unlock(&list_lock);
 			return ret;
 		}
+		goto again;
 	}
 
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
-	mutex_unlock(&list_lock);
+	if (!subnotifier)
+		mutex_unlock(&list_lock);
 
 	return 0;
 }
+
+int v4l2_async_subnotifier_register(struct v4l2_subdev *sd,
+				    struct v4l2_async_notifier *notifier)
+{
+	return v4l2_async_do_notifier_register(sd->v4l2_dev, notifier, true);
+}
+EXPORT_SYMBOL(v4l2_async_subnotifier_register);
+
+int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
+				 struct v4l2_async_notifier *notifier)
+{
+	return v4l2_async_do_notifier_register(v4l2_dev, notifier, false);
+}
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
-void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
+static void
+v4l2_async_do_notifier_unregister(struct v4l2_async_notifier *notifier,
+				  bool subnotifier)
 {
 	struct v4l2_subdev *sd, *tmp;
 	unsigned int notif_n_subdev = notifier->num_subdevs;
@@ -216,7 +244,10 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 			"Failed to allocate device cache!\n");
 	}
 
-	mutex_lock(&list_lock);
+	if (subnotifier)
+		lockdep_assert_held(&list_lock);
+	else
+		mutex_lock(&list_lock);
 
 	list_del(&notifier->list);
 
@@ -243,15 +274,20 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 			put_device(d);
 	}
 
-	mutex_unlock(&list_lock);
+	if (!subnotifier)
+		mutex_unlock(&list_lock);
 
 	/*
 	 * Call device_attach() to reprobe devices
 	 *
 	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
 	 * executed.
+	 * TODO: If we are unregistering a subdevice notifier we can't reprobe
+	 * since the lock_list is held by the master device and attaching that
+	 * device would call v4l2_async_register_subdev() and end in a deadlock
+	 * on list_lock.
 	 */
-	while (i--) {
+	while (i-- && !subnotifier) {
 		struct device *d = dev[i];
 
 		if (d && device_attach(d) < 0) {
@@ -275,6 +311,17 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	 * upon notifier registration.
 	 */
 }
+
+void v4l2_async_subnotifier_unregister(struct v4l2_async_notifier *notifier)
+{
+	v4l2_async_do_notifier_unregister(notifier, true);
+}
+EXPORT_SYMBOL(v4l2_async_subnotifier_unregister);
+
+void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
+{
+	v4l2_async_do_notifier_unregister(notifier, false);
+}
 EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 
 int v4l2_async_register_subdev(struct v4l2_subdev *sd)
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index c69d8c8a66d0093a..f7e2a1a8ead55de2 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -105,6 +105,18 @@ struct v4l2_async_notifier {
 };
 
 /**
+ * v4l2_async_notifier_register - registers a subdevice asynchronous subnotifier
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @notifier: pointer to &struct v4l2_async_notifier
+ *
+ * This function assumes the async list_lock is already locked, allowing it to
+ * be used from the struct v4l2_subdev_internal_ops registered() callback.
+ */
+int v4l2_async_subnotifier_register(struct v4l2_subdev *sd,
+				    struct v4l2_async_notifier *notifier);
+
+/**
  * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
  *
  * @v4l2_dev: pointer to &struct v4l2_device
@@ -114,6 +126,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier);
 
 /**
+ * v4l2_async_subnotifier_unregister - unregisters a asynchronous subnotifier
+ *
+ * @notifier: pointer to &struct v4l2_async_notifier
+ *
+ * This function assumes the async list_lock is already locked, allowing it to
+ * be used from the struct v4l2_subdev_internal_ops unregistered() callback.
+ */
+void v4l2_async_subnotifier_unregister(struct v4l2_async_notifier *notifier);
+
+/**
  * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
  *
  * @notifier: pointer to &struct v4l2_async_notifier
-- 
2.13.1
