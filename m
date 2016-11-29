Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48623
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753895AbcK3AAD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 19:00:03 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, mkrufky@linuxtv.org, klock.android@gmail.com,
        elfring@users.sourceforge.net, max@duempel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart+renesas@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: Protect enable_source and disable_source handler code paths
Date: Tue, 29 Nov 2016 16:59:54 -0700
Message-Id: <20161129235954.8186-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers might try to access and run enable_source and disable_source
handlers when the driver that implements these handlers is clearing
the handlers during its unregister.

Fix the following race condition:

process 1				process 2

request video streaming			unbind au0828
v4l2 checks if tuner is free
...					...

					au0828_unregister_media_device()
...					...
					(doesn't hold graph_mutex)
					mdev->enable_source = NULL;
if (mdev && mdev->enable_source)	mdev->disable_source = NULL;
	mdev->enable_source()
(enable_source holds graph_mutex)

As shown above enable_source check is done without holding the graph_mutex.
If unbind happens to be in progress, au0828 could clear enable_source and
disable_source handlers leading to null pointer de-reference.

Fix it by protecting enable_source and disable_source set and clear and
protecting enable_source and disable_source handler access and the call
itself.

process 1				process 2

request video streaming			unbind au0828
v4l2 checks if tuner is free
...					...

					au0828_unregister_media_device()
...					...
					(hold graph_mutex while clearing)
					mdev->enable_source = NULL;
if (mdev)				mdev->disable_source = NULL;
(hold graph_mutex to check and
 call enable_source)
    if (mdev->enable_source)
	mdev->enable_source()

If graph_mutex is held to just heck for handler being null and needs to be
released before calling the handler, there will be another window for the
handlers to be cleared. Hence, enable_source and disable_source handlers
no longer hold the graph_mutex and expect callers to hold it to avoid
forcing them release the graph_mutex before calling the handlers.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

Changes since v1:
- Collapsed two patches into one.
- Updated changelog for clarity
- Updated Documentation

 drivers/media/dvb-core/dvb_frontend.c  | 24 ++++++++++++++++++------
 drivers/media/usb/au0828/au0828-core.c | 21 +++++++++------------
 drivers/media/v4l2-core/v4l2-mc.c      | 26 ++++++++++++++++++--------
 include/media/media-device.h           |  2 ++
 4 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 01511e5..2f09c7e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2527,9 +2527,13 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->voltage = -1;
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-		if (fe->dvb->mdev && fe->dvb->mdev->enable_source) {
-			ret = fe->dvb->mdev->enable_source(dvbdev->entity,
+		if (fe->dvb->mdev) {
+			mutex_lock(&fe->dvb->mdev->graph_mutex);
+			if (fe->dvb->mdev->enable_source)
+				ret = fe->dvb->mdev->enable_source(
+							   dvbdev->entity,
 							   &fepriv->pipe);
+			mutex_unlock(&fe->dvb->mdev->graph_mutex);
 			if (ret) {
 				dev_err(fe->dvb->device,
 					"Tuner is busy. Error %d\n", ret);
@@ -2553,8 +2557,12 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 
 err3:
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
-		fe->dvb->mdev->disable_source(dvbdev->entity);
+	if (fe->dvb->mdev) {
+		mutex_lock(&fe->dvb->mdev->graph_mutex);
+		if (fe->dvb->mdev->disable_source)
+			fe->dvb->mdev->disable_source(dvbdev->entity);
+		mutex_unlock(&fe->dvb->mdev->graph_mutex);
+	}
 err2:
 #endif
 	dvb_generic_release(inode, file);
@@ -2586,8 +2594,12 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 	if (dvbdev->users == -1) {
 		wake_up(&fepriv->wait_queue);
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-		if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
-			fe->dvb->mdev->disable_source(dvbdev->entity);
+		if (fe->dvb->mdev) {
+			mutex_lock(&fe->dvb->mdev->graph_mutex);
+			if (fe->dvb->mdev->disable_source)
+				fe->dvb->mdev->disable_source(dvbdev->entity);
+			mutex_unlock(&fe->dvb->mdev->graph_mutex);
+		}
 #endif
 		if (fe->exit != DVB_FE_NO_EXIT)
 			wake_up(&dvbdev->wait_queue);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index bf53553..bfd6482 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -153,9 +153,11 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	}
 
 	/* clear enable_source, disable_source */
+	mutex_lock(&mdev->graph_mutex);
 	dev->media_dev->source_priv = NULL;
 	dev->media_dev->enable_source = NULL;
 	dev->media_dev->disable_source = NULL;
+	mutex_unlock(&mdev->graph_mutex);
 
 	media_device_unregister(dev->media_dev);
 	media_device_cleanup(dev->media_dev);
@@ -278,6 +280,7 @@ static void au0828_media_graph_notify(struct media_entity *new,
 	}
 }
 
+/* Callers should hold graph_mutex */
 static int au0828_enable_source(struct media_entity *entity,
 				struct media_pipeline *pipe)
 {
@@ -291,8 +294,6 @@ static int au0828_enable_source(struct media_entity *entity,
 	if (!mdev)
 		return -ENODEV;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	dev = mdev->source_priv;
 
 	/*
@@ -419,12 +420,12 @@ static int au0828_enable_source(struct media_entity *entity,
 		 dev->active_source->name, dev->active_sink->name,
 		 dev->active_link_owner->name, ret);
 end:
-	mutex_unlock(&mdev->graph_mutex);
 	pr_debug("au0828_enable_source() end %s %d %d\n",
 		 entity->name, entity->function, ret);
 	return ret;
 }
 
+/* Callers should hold graph_mutex */
 static void au0828_disable_source(struct media_entity *entity)
 {
 	int ret = 0;
@@ -434,13 +435,10 @@ static void au0828_disable_source(struct media_entity *entity)
 	if (!mdev)
 		return;
 
-	mutex_lock(&mdev->graph_mutex);
 	dev = mdev->source_priv;
 
-	if (!dev->active_link) {
-		ret = -ENODEV;
-		goto end;
-	}
+	if (!dev->active_link)
+		return;
 
 	/* link is active - stop pipeline from source (tuner) */
 	if (dev->active_link->sink->entity == dev->active_sink &&
@@ -450,7 +448,7 @@ static void au0828_disable_source(struct media_entity *entity)
 		 * has active pipeline
 		*/
 		if (dev->active_link_owner != entity)
-			goto end;
+			return;
 		__media_entity_pipeline_stop(entity);
 		ret = __media_entity_setup_link(dev->active_link, 0);
 		if (ret)
@@ -465,9 +463,6 @@ static void au0828_disable_source(struct media_entity *entity)
 		dev->active_source = NULL;
 		dev->active_sink = NULL;
 	}
-
-end:
-	mutex_unlock(&mdev->graph_mutex);
 }
 #endif
 
@@ -549,9 +544,11 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 		return ret;
 	}
 	/* set enable_source */
+	mutex_lock(&dev->media_dev->graph_mutex);
 	dev->media_dev->source_priv = (void *) dev;
 	dev->media_dev->enable_source = au0828_enable_source;
 	dev->media_dev->disable_source = au0828_disable_source;
+	mutex_unlock(&dev->media_dev->graph_mutex);
 #endif
 	return 0;
 }
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 8bef433..b169d24 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -198,14 +198,20 @@ EXPORT_SYMBOL_GPL(v4l2_mc_create_media_graph);
 int v4l_enable_media_source(struct video_device *vdev)
 {
 	struct media_device *mdev = vdev->entity.graph_obj.mdev;
-	int ret;
+	int ret = 0, err;
 
-	if (!mdev || !mdev->enable_source)
+	if (!mdev)
 		return 0;
-	ret = mdev->enable_source(&vdev->entity, &vdev->pipe);
-	if (ret)
-		return -EBUSY;
-	return 0;
+
+	mutex_lock(&mdev->graph_mutex);
+	if (!mdev->enable_source)
+		goto end;
+	err = mdev->enable_source(&vdev->entity, &vdev->pipe);
+	if (err)
+		ret = -EBUSY;
+end:
+	mutex_unlock(&mdev->graph_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l_enable_media_source);
 
@@ -213,8 +219,12 @@ void v4l_disable_media_source(struct video_device *vdev)
 {
 	struct media_device *mdev = vdev->entity.graph_obj.mdev;
 
-	if (mdev && mdev->disable_source)
-		mdev->disable_source(&vdev->entity);
+	if (mdev) {
+		mutex_lock(&mdev->graph_mutex);
+		if (mdev->disable_source)
+			mdev->disable_source(&vdev->entity);
+		mutex_unlock(&mdev->graph_mutex);
+	}
 }
 EXPORT_SYMBOL_GPL(v4l_disable_media_source);
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 633f2e3..1189ac8 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -123,6 +123,8 @@ struct media_device_ops {
  *    bridge driver finds the media_device during probe.
  *    Bridge driver sets source_priv with information
  *    necessary to run @enable_source and @disable_source handlers.
+ *    Callers should hold graph_mutex to access and call @enable_source
+ *    and @disable_source handlers.
  */
 struct media_device {
 	/* dev->driver_data points to this struct. */
-- 
2.7.4

