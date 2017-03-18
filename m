Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:34587 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdCRBEz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 21:04:55 -0400
Received: by mail-qt0-f177.google.com with SMTP id n21so75312764qta.1
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 18:03:31 -0700 (PDT)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC PATCHv2 09/21] staging: android: ion: Remove custom ioctl interface
Date: Fri, 17 Mar 2017 17:54:41 -0700
Message-Id: <1489798493-16600-10-git-send-email-labbott@redhat.com>
In-Reply-To: <1489798493-16600-1-git-send-email-labbott@redhat.com>
References: <1489798493-16600-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Ion is now moving towards a unified interfact. This makes the custom
ioctl interface unneeded. Remove it.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/compat_ion.c | 40 --------------------------------
 drivers/staging/android/ion/ion-ioctl.c  | 11 ---------
 drivers/staging/android/ion/ion.c        |  6 +----
 drivers/staging/android/ion/ion_priv.h   |  8 +------
 drivers/staging/android/uapi/ion.h       | 21 -----------------
 5 files changed, 2 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/android/ion/compat_ion.c b/drivers/staging/android/ion/compat_ion.c
index b892d3a..5b192ea 100644
--- a/drivers/staging/android/ion/compat_ion.c
+++ b/drivers/staging/android/ion/compat_ion.c
@@ -30,11 +30,6 @@ struct compat_ion_allocation_data {
 	compat_int_t handle;
 };
 
-struct compat_ion_custom_data {
-	compat_uint_t cmd;
-	compat_ulong_t arg;
-};
-
 struct compat_ion_handle_data {
 	compat_int_t handle;
 };
@@ -43,8 +38,6 @@ struct compat_ion_handle_data {
 				      struct compat_ion_allocation_data)
 #define COMPAT_ION_IOC_FREE	_IOWR(ION_IOC_MAGIC, 1, \
 				      struct compat_ion_handle_data)
-#define COMPAT_ION_IOC_CUSTOM	_IOWR(ION_IOC_MAGIC, 6, \
-				      struct compat_ion_custom_data)
 
 static int compat_get_ion_allocation_data(
 			struct compat_ion_allocation_data __user *data32,
@@ -105,22 +98,6 @@ static int compat_put_ion_allocation_data(
 	return err;
 }
 
-static int compat_get_ion_custom_data(
-			struct compat_ion_custom_data __user *data32,
-			struct ion_custom_data __user *data)
-{
-	compat_uint_t cmd;
-	compat_ulong_t arg;
-	int err;
-
-	err = get_user(cmd, &data32->cmd);
-	err |= put_user(cmd, &data->cmd);
-	err |= get_user(arg, &data32->arg);
-	err |= put_user(arg, &data->arg);
-
-	return err;
-};
-
 long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	long ret;
@@ -166,23 +143,6 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return filp->f_op->unlocked_ioctl(filp, ION_IOC_FREE,
 							(unsigned long)data);
 	}
-	case COMPAT_ION_IOC_CUSTOM: {
-		struct compat_ion_custom_data __user *data32;
-		struct ion_custom_data __user *data;
-		int err;
-
-		data32 = compat_ptr(arg);
-		data = compat_alloc_user_space(sizeof(*data));
-		if (!data)
-			return -EFAULT;
-
-		err = compat_get_ion_custom_data(data32, data);
-		if (err)
-			return err;
-
-		return filp->f_op->unlocked_ioctl(filp, ION_IOC_CUSTOM,
-							(unsigned long)data);
-	}
 	case ION_IOC_SHARE:
 	case ION_IOC_MAP:
 	case ION_IOC_IMPORT:
diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index e096bcd..2b475bf 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -26,7 +26,6 @@ union ion_ioctl_arg {
 	struct ion_fd_data fd;
 	struct ion_allocation_data allocation;
 	struct ion_handle_data handle;
-	struct ion_custom_data custom;
 	struct ion_heap_query query;
 };
 
@@ -52,7 +51,6 @@ static unsigned int ion_ioctl_dir(unsigned int cmd)
 {
 	switch (cmd) {
 	case ION_IOC_FREE:
-	case ION_IOC_CUSTOM:
 		return _IOC_WRITE;
 	default:
 		return _IOC_DIR(cmd);
@@ -62,7 +60,6 @@ static unsigned int ion_ioctl_dir(unsigned int cmd)
 long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct ion_client *client = filp->private_data;
-	struct ion_device *dev = client->dev;
 	struct ion_handle *cleanup_handle = NULL;
 	int ret = 0;
 	unsigned int dir;
@@ -145,14 +142,6 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			data.handle.handle = handle->id;
 		break;
 	}
-	case ION_IOC_CUSTOM:
-	{
-		if (!dev->custom_ioctl)
-			return -ENOTTY;
-		ret = dev->custom_ioctl(client, data.custom.cmd,
-						data.custom.arg);
-		break;
-	}
 	case ION_IOC_HEAP_QUERY:
 		ret = ion_query_heaps(client, &data.query);
 		break;
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 8757164..125c537 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1347,10 +1347,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 }
 EXPORT_SYMBOL(ion_device_add_heap);
 
-struct ion_device *ion_device_create(long (*custom_ioctl)
-				     (struct ion_client *client,
-				      unsigned int cmd,
-				      unsigned long arg))
+struct ion_device *ion_device_create(void)
 {
 	struct ion_device *idev;
 	int ret;
@@ -1387,7 +1384,6 @@ struct ion_device *ion_device_create(long (*custom_ioctl)
 
 debugfs_done:
 
-	idev->custom_ioctl = custom_ioctl;
 	idev->buffers = RB_ROOT;
 	mutex_init(&idev->buffer_lock);
 	init_rwsem(&idev->lock);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 4fc7026..a86866a 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -95,8 +95,6 @@ struct ion_device {
 	struct mutex buffer_lock;
 	struct rw_semaphore lock;
 	struct plist_head heaps;
-	long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
-			     unsigned long arg);
 	struct rb_root clients;
 	struct dentry *debug_root;
 	struct dentry *heaps_debug_root;
@@ -260,14 +258,10 @@ bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer);
 
 /**
  * ion_device_create - allocates and returns an ion device
- * @custom_ioctl:	arch specific ioctl function if applicable
  *
  * returns a valid device or -PTR_ERR
  */
-struct ion_device *ion_device_create(long (*custom_ioctl)
-				     (struct ion_client *client,
-				      unsigned int cmd,
-				      unsigned long arg));
+struct ion_device *ion_device_create(void);
 
 /**
  * ion_device_destroy - free and device and it's resource
diff --git a/drivers/staging/android/uapi/ion.h b/drivers/staging/android/uapi/ion.h
index c3a87a5..8ff471d 100644
--- a/drivers/staging/android/uapi/ion.h
+++ b/drivers/staging/android/uapi/ion.h
@@ -115,19 +115,6 @@ struct ion_handle_data {
 	ion_user_handle_t handle;
 };
 
-/**
- * struct ion_custom_data - metadata passed to/from userspace for a custom ioctl
- * @cmd:	the custom ioctl function to call
- * @arg:	additional data to pass to the custom ioctl, typically a user
- *		pointer to a predefined structure
- *
- * This works just like the regular cmd and arg fields of an ioctl.
- */
-struct ion_custom_data {
-	unsigned int cmd;
-	unsigned long arg;
-};
-
 #define MAX_HEAP_NAME			32
 
 /**
@@ -207,14 +194,6 @@ struct ion_heap_query {
 #define ION_IOC_IMPORT		_IOWR(ION_IOC_MAGIC, 5, struct ion_fd_data)
 
 /**
- * DOC: ION_IOC_CUSTOM - call architecture specific ion ioctl
- *
- * Takes the argument of the architecture specific ioctl to call and
- * passes appropriate userdata for that ioctl
- */
-#define ION_IOC_CUSTOM		_IOWR(ION_IOC_MAGIC, 6, struct ion_custom_data)
-
-/**
  * DOC: ION_IOC_HEAP_QUERY - information about available heaps
  *
  * Takes an ion_heap_query structure and populates information about
-- 
2.7.4
