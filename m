Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:41719 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751548AbeECOx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 10:53:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv13 28/28] RFC: media-requests: add debugfs node
Date: Thu,  3 May 2018 16:53:18 +0200
Message-Id: <20180503145318.128315-29-hverkuil@xs4all.nl>
In-Reply-To: <20180503145318.128315-1-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Keep track of the number of requests and request objects of a media
device. Helps to verify that all request-related memory is freed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c  | 41 +++++++++++++++++++++++++++++++++++
 drivers/media/media-devnode.c | 17 +++++++++++++++
 drivers/media/media-request.c |  5 +++++
 include/media/media-device.h  | 11 ++++++++++
 include/media/media-devnode.h |  4 ++++
 include/media/media-request.h |  1 +
 6 files changed, 79 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index bb6a64acd3f0..e39731cc1add 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -680,6 +680,23 @@ void media_device_unregister_entity(struct media_entity *entity)
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
+#ifdef CONFIG_DEBUG_FS
+/*
+ * Log the state of media requests.
+ * Very useful for debugging.
+ */
+static int media_device_requests(struct seq_file *file, void *priv)
+{
+	struct media_device *dev = dev_get_drvdata(file->private);
+
+	seq_printf(file, "number of requests: %d\n",
+		   atomic_read(&dev->num_requests));
+	seq_printf(file, "number of request objects: %d\n",
+		   atomic_read(&dev->num_request_objects));
+	return 0;
+}
+#endif
+
 /**
  * media_device_init() - initialize a media device
  * @mdev:	The media device
@@ -702,6 +719,9 @@ void media_device_init(struct media_device *mdev)
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
 
+	atomic_set(&mdev->num_requests, 0);
+	atomic_set(&mdev->num_request_objects, 0);
+
 	dev_dbg(mdev->dev, "Media device initialized\n");
 }
 EXPORT_SYMBOL_GPL(media_device_init);
@@ -753,6 +773,26 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	dev_dbg(mdev->dev, "Media device registered\n");
 
+#ifdef CONFIG_DEBUG_FS
+	if (!media_top_dir)
+		return 0;
+
+	mdev->media_dir = debugfs_create_dir(dev_name(&devnode->dev),
+					     media_top_dir);
+	if (IS_ERR_OR_NULL(mdev->media_dir)) {
+		dev_warn(mdev->dev, "Failed to create debugfs dir\n");
+		return 0;
+	}
+	mdev->requests_file = debugfs_create_devm_seqfile(&devnode->dev,
+		"requests", mdev->media_dir, media_device_requests);
+	if (IS_ERR_OR_NULL(mdev->requests_file)) {
+		dev_warn(mdev->dev, "Failed to create requests file\n");
+		debugfs_remove_recursive(mdev->media_dir);
+		mdev->media_dir = NULL;
+		return 0;
+	}
+#endif
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
@@ -830,6 +870,7 @@ void media_device_unregister(struct media_device *mdev)
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 
+	debugfs_remove_recursive(mdev->media_dir);
 	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
 	media_devnode_unregister(mdev->devnode);
 	/* devnode free is handled in media_devnode_*() */
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 67ac51eff15c..2656c2d7a312 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -53,6 +53,12 @@ static dev_t media_dev_t;
 static DEFINE_MUTEX(media_devnode_lock);
 static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEVICES);
 
+/*
+ * debugfs
+ */
+struct dentry *media_top_dir;
+
+
 /* Called when the last user of the media device exits. */
 static void media_devnode_release(struct device *cd)
 {
@@ -259,6 +265,8 @@ int __must_check media_devnode_register(struct media_device *mdev,
 		goto cdev_add_error;
 	}
 
+	dev_set_drvdata(&devnode->dev, mdev);
+
 	/* Part 4: Activate this minor. The char device can now be used. */
 	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 
@@ -310,6 +318,14 @@ static int __init media_devnode_init(void)
 		return ret;
 	}
 
+#ifdef CONFIG_DEBUG_FS
+	media_top_dir = debugfs_create_dir("media", NULL);
+	if (IS_ERR_OR_NULL(media_top_dir)) {
+		pr_warn("Failed to create debugfs media dir\n");
+		media_top_dir = NULL;
+	}
+#endif
+
 	ret = bus_register(&media_bus_type);
 	if (ret < 0) {
 		unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
@@ -322,6 +338,7 @@ static int __init media_devnode_init(void)
 
 static void __exit media_devnode_exit(void)
 {
+	debugfs_remove_recursive(media_top_dir);
 	bus_unregister(&media_bus_type);
 	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
 }
diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index c7e11e816e27..a24706d9e33e 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -63,6 +63,7 @@ static void media_request_release(struct kref *kref)
 		mdev->ops->req_free(req);
 	else
 		kfree(req);
+	atomic_dec(&mdev->num_requests);
 }
 
 void media_request_put(struct media_request *req)
@@ -296,6 +297,7 @@ int media_request_alloc(struct media_device *mdev,
 	get_task_comm(comm, current);
 	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
 		 comm, fd);
+	atomic_inc(&mdev->num_requests);
 	dev_dbg(mdev->dev, "request: allocated %s\n", req->debug_str);
 
 	fd_install(fd, filp);
@@ -320,6 +322,7 @@ static void media_request_object_release(struct kref *kref)
 	if (req)
 		media_request_object_unbind(obj);
 	obj->ops->release(obj);
+	atomic_dec(&obj->mdev->num_request_objects);
 }
 
 struct media_request_object *
@@ -378,6 +381,7 @@ int media_request_object_bind(struct media_request *req,
 	obj->req = req;
 	obj->ops = ops;
 	obj->priv = priv;
+	obj->mdev = req->mdev;
 
 	spin_lock_irqsave(&req->lock, flags);
 
@@ -387,6 +391,7 @@ int media_request_object_bind(struct media_request *req,
 	list_add_tail(&obj->list, &req->objects);
 	req->num_incomplete_objects++;
 	ret = 0;
+	atomic_inc(&obj->mdev->num_request_objects);
 
 unlock:
 	spin_unlock_irqrestore(&req->lock, flags);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 7d855823341c..2e8e2d69f27f 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -21,6 +21,7 @@
 
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/atomic.h>
 
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
@@ -102,6 +103,10 @@ struct media_device_ops {
  * @ops:	Operation handler callbacks
  * @req_queue_mutex: Serialise the MEDIA_REQUEST_IOC_QUEUE ioctl w.r.t. this
  *		     media device.
+ * @num_requests: number of associated requests
+ * @num_request_objects: number of associated request objects
+ * @media_dir:	DebugFS media directory
+ * @requests_file: DebugFS requests file
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -174,6 +179,12 @@ struct media_device {
 	const struct media_device_ops *ops;
 
 	struct mutex req_queue_mutex;
+	atomic_t num_requests;
+	atomic_t num_request_objects;
+
+	/* debugfs */
+	struct dentry *media_dir;
+	struct dentry *requests_file;
 };
 
 /* We don't need to include pci.h or usb.h here */
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index dc2f64e1b08f..984b62b634d3 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -28,9 +28,13 @@
 #include <linux/fs.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/debugfs.h>
 
 struct media_device;
 
+/* DebugFS top-level media directory */
+extern struct dentry *media_top_dir;
+
 /*
  * Flag to mark the media_devnode struct as registered. Drivers must not touch
  * this flag directly, it will be set and cleared by media_devnode_register and
diff --git a/include/media/media-request.h b/include/media/media-request.h
index 5367b4a2f91c..2671b570c120 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -164,6 +164,7 @@ struct media_request_object_ops {
  * larger object data.
  */
 struct media_request_object {
+	struct media_device *mdev;
 	const struct media_request_object_ops *ops;
 	void *priv;
 	struct media_request *req;
-- 
2.17.0
