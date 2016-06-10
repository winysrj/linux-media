Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:51381 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932288AbcFJRh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 13:37:28 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, sakari.ailus@iki.fi
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix media devnode ioctl/syscall and unregister race
Date: Fri, 10 Jun 2016 11:37:23 -0600
Message-Id: <1465580243-7274-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media devnode open/ioctl could be in progress when media device unregister
is initiated. System calls and ioctls check media device registered status
at the beginning, however, there is a window where unregister could be in
progress without changing the media devnode status to unregistered.

process 1				process 2
fd = open(/dev/media0)
media_devnode_is_registered()
	(returns true here)

					media_device_unregister()
						(unregister is in progress
						and devnode isn't
						unregistered yet)
					...
ioctl(fd, ...)
__media_ioctl()
media_devnode_is_registered()
	(returns true here)
					...
					media_devnode_unregister()
					...
					(driver releases the media device
					memory)

media_device_ioctl()
	(By this point
	devnode->media_dev does not
	point to allocated memory.
	use-after free in in mutex_lock_nested)

BUG: KASAN: use-after-free in mutex_lock_nested+0x79c/0x800 at addr
ffff8801ebe914f0

Fix it by clearing register bit when unregister starts to avoid the race.

process 1                               process 2
fd = open(/dev/media0)
media_devnode_is_registered()
        (could return true here)

                                        media_device_unregister()
                                                (clear the register bit,
						 then start unregister.)
                                        ...
ioctl(fd, ...)
__media_ioctl()
media_devnode_is_registered()
        (return false here, ioctl
	 returns I/O error, and
	 will not access media
	 device memory)
                                        ...
                                        media_devnode_unregister()
                                        ...
                                        (driver releases the media device
					 memory)

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reported-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

Test Procedure and Results:

https://drive.google.com/file/d/0B0NIL0BQg-AlN1VxT2oyTXBPRHc/view?usp=sharing

 drivers/media/media-device.c  | 15 ++++++++-------
 drivers/media/media-devnode.c |  8 +++++++-
 include/media/media-devnode.h | 16 ++++++++++++++--
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 33a9952..1795abe 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -732,6 +732,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 	if (ret < 0) {
 		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
+		media_devnode_unregister_prepare(devnode);
 		media_devnode_unregister(devnode);
 		return ret;
 	}
@@ -788,6 +789,9 @@ void media_device_unregister(struct media_device *mdev)
 		return;
 	}
 
+	/* Clear the devnode register bit to avoid races with media dev open */
+	media_devnode_unregister_prepare(mdev->devnode);
+
 	/* Remove all entities from the media device */
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		__media_device_unregister_entity(entity);
@@ -808,13 +812,10 @@ void media_device_unregister(struct media_device *mdev)
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 
-	/* Check if mdev devnode was registered */
-	if (media_devnode_is_registered(mdev->devnode)) {
-		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
-		media_devnode_unregister(mdev->devnode);
-		/* devnode free is handled in media_devnode_*() */
-		mdev->devnode = NULL;
-	}
+	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
+	media_devnode_unregister(mdev->devnode);
+	/* devnode free is handled in media_devnode_*() */
+	mdev->devnode = NULL;
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 5b605ff..f2772ba 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -287,7 +287,7 @@ cdev_add_error:
 	return ret;
 }
 
-void media_devnode_unregister(struct media_devnode *devnode)
+void media_devnode_unregister_prepare(struct media_devnode *devnode)
 {
 	/* Check if devnode was ever registered at all */
 	if (!media_devnode_is_registered(devnode))
@@ -295,6 +295,12 @@ void media_devnode_unregister(struct media_devnode *devnode)
 
 	mutex_lock(&media_devnode_lock);
 	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
+	mutex_unlock(&media_devnode_lock);
+}
+
+void media_devnode_unregister(struct media_devnode *devnode)
+{
+	mutex_lock(&media_devnode_lock);
 	/* Delete the cdev on this minor as well */
 	cdev_del(&devnode->cdev);
 	mutex_unlock(&media_devnode_lock);
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 5bb3b0e..f0b7dd7 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -126,14 +126,26 @@ int __must_check media_devnode_register(struct media_device *mdev,
 					struct module *owner);
 
 /**
+ * media_devnode_unregister_prepare - clear the media device node register bit
+ * @devnode: the device node to prepare for unregister
+ *
+ * This clears the passed device register bit. Future open calls will be met
+ * with errors. Should be called before media_devnode_unregister() to avoid
+ * races with unregister and device file open calls.
+ *
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
+ */
+void media_devnode_unregister_prepare(struct media_devnode *devnode);
+
+/**
  * media_devnode_unregister - unregister a media device node
  * @devnode: the device node to unregister
  *
  * This unregisters the passed device. Future open calls will be met with
  * errors.
  *
- * This function can safely be called if the device node has never been
- * registered or has already been unregistered.
+ * Should be called after media_devnode_unregister_prepare()
  */
 void media_devnode_unregister(struct media_devnode *devnode);
 
-- 
2.7.4

