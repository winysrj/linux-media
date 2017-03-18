Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34600 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdCRDeW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 23:34:22 -0400
Received: by mail-qk0-f173.google.com with SMTP id p64so78565083qke.1
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 20:34:03 -0700 (PDT)
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
Subject: [RFC PATCHv2 10/21] staging: android: ion: Remove import interface
Date: Fri, 17 Mar 2017 17:54:42 -0700
Message-Id: <1489798493-16600-11-git-send-email-labbott@redhat.com>
In-Reply-To: <1489798493-16600-1-git-send-email-labbott@redhat.com>
References: <1489798493-16600-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


With the expansion of dma-buf and the move for Ion to be come just an
allocator, the import mechanism is mostly useless. There isn't a kernel
component to Ion anymore and handles are private to Ion. Remove this
interface.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/compat_ion.c |  1 -
 drivers/staging/android/ion/ion-ioctl.c  | 11 -----
 drivers/staging/android/ion/ion.c        | 76 --------------------------------
 drivers/staging/android/uapi/ion.h       |  9 ----
 4 files changed, 97 deletions(-)

diff --git a/drivers/staging/android/ion/compat_ion.c b/drivers/staging/android/ion/compat_ion.c
index 5b192ea..ae1ffc3 100644
--- a/drivers/staging/android/ion/compat_ion.c
+++ b/drivers/staging/android/ion/compat_ion.c
@@ -145,7 +145,6 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 	case ION_IOC_SHARE:
 	case ION_IOC_MAP:
-	case ION_IOC_IMPORT:
 		return filp->f_op->unlocked_ioctl(filp, cmd,
 						(unsigned long)compat_ptr(arg));
 	default:
diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index 2b475bf..7b54eea 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -131,17 +131,6 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			ret = data.fd.fd;
 		break;
 	}
-	case ION_IOC_IMPORT:
-	{
-		struct ion_handle *handle;
-
-		handle = ion_import_dma_buf_fd(client, data.fd.fd);
-		if (IS_ERR(handle))
-			ret = PTR_ERR(handle);
-		else
-			data.handle.handle = handle->id;
-		break;
-	}
 	case ION_IOC_HEAP_QUERY:
 		ret = ion_query_heaps(client, &data.query);
 		break;
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 125c537..3d979ef5 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -274,24 +274,6 @@ int ion_handle_put(struct ion_handle *handle)
 	return ret;
 }
 
-static struct ion_handle *ion_handle_lookup(struct ion_client *client,
-					    struct ion_buffer *buffer)
-{
-	struct rb_node *n = client->handles.rb_node;
-
-	while (n) {
-		struct ion_handle *entry = rb_entry(n, struct ion_handle, node);
-
-		if (buffer < entry->buffer)
-			n = n->rb_left;
-		else if (buffer > entry->buffer)
-			n = n->rb_right;
-		else
-			return entry;
-	}
-	return ERR_PTR(-EINVAL);
-}
-
 struct ion_handle *ion_handle_get_by_id_nolock(struct ion_client *client,
 					       int id)
 {
@@ -1023,64 +1005,6 @@ int ion_share_dma_buf_fd(struct ion_client *client, struct ion_handle *handle)
 }
 EXPORT_SYMBOL(ion_share_dma_buf_fd);
 
-struct ion_handle *ion_import_dma_buf(struct ion_client *client,
-				      struct dma_buf *dmabuf)
-{
-	struct ion_buffer *buffer;
-	struct ion_handle *handle;
-	int ret;
-
-	/* if this memory came from ion */
-
-	if (dmabuf->ops != &dma_buf_ops) {
-		pr_err("%s: can not import dmabuf from another exporter\n",
-		       __func__);
-		return ERR_PTR(-EINVAL);
-	}
-	buffer = dmabuf->priv;
-
-	mutex_lock(&client->lock);
-	/* if a handle exists for this buffer just take a reference to it */
-	handle = ion_handle_lookup(client, buffer);
-	if (!IS_ERR(handle)) {
-		ion_handle_get(handle);
-		mutex_unlock(&client->lock);
-		goto end;
-	}
-
-	handle = ion_handle_create(client, buffer);
-	if (IS_ERR(handle)) {
-		mutex_unlock(&client->lock);
-		goto end;
-	}
-
-	ret = ion_handle_add(client, handle);
-	mutex_unlock(&client->lock);
-	if (ret) {
-		ion_handle_put(handle);
-		handle = ERR_PTR(ret);
-	}
-
-end:
-	return handle;
-}
-EXPORT_SYMBOL(ion_import_dma_buf);
-
-struct ion_handle *ion_import_dma_buf_fd(struct ion_client *client, int fd)
-{
-	struct dma_buf *dmabuf;
-	struct ion_handle *handle;
-
-	dmabuf = dma_buf_get(fd);
-	if (IS_ERR(dmabuf))
-		return ERR_CAST(dmabuf);
-
-	handle = ion_import_dma_buf(client, dmabuf);
-	dma_buf_put(dmabuf);
-	return handle;
-}
-EXPORT_SYMBOL(ion_import_dma_buf_fd);
-
 int ion_query_heaps(struct ion_client *client, struct ion_heap_query *query)
 {
 	struct ion_device *dev = client->dev;
diff --git a/drivers/staging/android/uapi/ion.h b/drivers/staging/android/uapi/ion.h
index 8ff471d..3a59044 100644
--- a/drivers/staging/android/uapi/ion.h
+++ b/drivers/staging/android/uapi/ion.h
@@ -185,15 +185,6 @@ struct ion_heap_query {
 #define ION_IOC_SHARE		_IOWR(ION_IOC_MAGIC, 4, struct ion_fd_data)
 
 /**
- * DOC: ION_IOC_IMPORT - imports a shared file descriptor
- *
- * Takes an ion_fd_data struct with the fd field populated with a valid file
- * descriptor obtained from ION_IOC_SHARE and returns the struct with the handle
- * filed set to the corresponding opaque handle.
- */
-#define ION_IOC_IMPORT		_IOWR(ION_IOC_MAGIC, 5, struct ion_fd_data)
-
-/**
  * DOC: ION_IOC_HEAP_QUERY - information about available heaps
  *
  * Takes an ion_heap_query structure and populates information about
-- 
2.7.4
