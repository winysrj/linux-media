Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49960 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966463AbcHBNRE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 09:17:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH (repost) 2/2] cec: improve locking
Date: Tue,  2 Aug 2016 15:16:51 +0200
Message-Id: <1470143811-9228-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470143811-9228-1-git-send-email-hverkuil@xs4all.nl>
References: <1470143811-9228-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- The global lock was used in cec_get_device when it should have
  used the devnode lock.
- cec_put_device also took the global lock, but since the release
  function takes that lock as well this could lead to a deadlock.
  Just don't take the lock here since there is no reason for it.
- cec_devnode_register() should take the global lock when clearing
  the bit in the global bitmap.
- In cec_devnode_unregister() place the devnode->(un)register tests
  and assignments under the devnode lock as well: this has to be
  in a critical block.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-core.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/cec/cec-core.c b/drivers/staging/media/cec/cec-core.c
index 73792d0..3b1e4d2 100644
--- a/drivers/staging/media/cec/cec-core.c
+++ b/drivers/staging/media/cec/cec-core.c
@@ -51,31 +51,29 @@ int cec_get_device(struct cec_devnode *devnode)
 {
 	/*
 	 * Check if the cec device is available. This needs to be done with
-	 * the cec_devnode_lock held to prevent an open/unregister race:
+	 * the devnode->lock held to prevent an open/unregister race:
 	 * without the lock, the device could be unregistered and freed between
 	 * the devnode->registered check and get_device() calls, leading to
 	 * a crash.
 	 */
-	mutex_lock(&cec_devnode_lock);
+	mutex_lock(&devnode->lock);
 	/*
 	 * return ENXIO if the cec device has been removed
 	 * already or if it is not registered anymore.
 	 */
 	if (!devnode->registered) {
-		mutex_unlock(&cec_devnode_lock);
+		mutex_unlock(&devnode->lock);
 		return -ENXIO;
 	}
 	/* and increase the device refcount */
 	get_device(&devnode->dev);
-	mutex_unlock(&cec_devnode_lock);
+	mutex_unlock(&devnode->lock);
 	return 0;
 }
 
 void cec_put_device(struct cec_devnode *devnode)
 {
-	mutex_lock(&cec_devnode_lock);
 	put_device(&devnode->dev);
-	mutex_unlock(&cec_devnode_lock);
 }
 
 /* Called when the last user of the cec device exits. */
@@ -84,11 +82,10 @@ static void cec_devnode_release(struct device *cd)
 	struct cec_devnode *devnode = to_cec_devnode(cd);
 
 	mutex_lock(&cec_devnode_lock);
-
 	/* Mark device node number as free */
 	clear_bit(devnode->minor, cec_devnode_nums);
-
 	mutex_unlock(&cec_devnode_lock);
+
 	cec_delete_adapter(to_cec_adapter(devnode));
 }
 
@@ -160,7 +157,9 @@ static int __must_check cec_devnode_register(struct cec_devnode *devnode,
 cdev_del:
 	cdev_del(&devnode->cdev);
 clr_bit:
+	mutex_lock(&cec_devnode_lock);
 	clear_bit(devnode->minor, cec_devnode_nums);
+	mutex_unlock(&cec_devnode_lock);
 	return ret;
 }
 
@@ -177,17 +176,21 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 {
 	struct cec_fh *fh;
 
+	mutex_lock(&devnode->lock);
+
 	/* Check if devnode was never registered or already unregistered */
-	if (!devnode->registered || devnode->unregistered)
+	if (!devnode->registered || devnode->unregistered) {
+		mutex_unlock(&devnode->lock);
 		return;
+	}
 
-	mutex_lock(&devnode->lock);
 	list_for_each_entry(fh, &devnode->fhs, list)
 		wake_up_interruptible(&fh->wait);
-	mutex_unlock(&devnode->lock);
 
 	devnode->registered = false;
 	devnode->unregistered = true;
+	mutex_unlock(&devnode->lock);
+
 	device_del(&devnode->dev);
 	cdev_del(&devnode->cdev);
 	put_device(&devnode->dev);
-- 
2.8.1

