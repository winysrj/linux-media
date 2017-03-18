Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:32992 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdCRB5F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 21:57:05 -0400
Received: by mail-qt0-f180.google.com with SMTP id i34so75896416qtc.0
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 18:56:46 -0700 (PDT)
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
Subject: [RFC PATCHv2 19/21] staging: android: ion: Drop ion_map_kernel interface
Date: Fri, 17 Mar 2017 17:54:51 -0700
Message-Id: <1489798493-16600-20-git-send-email-labbott@redhat.com>
In-Reply-To: <1489798493-16600-1-git-send-email-labbott@redhat.com>
References: <1489798493-16600-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Nobody uses this interface externally. Drop it.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/ion.c | 59 ---------------------------------------
 1 file changed, 59 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 7d40233..5a82bea 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -424,22 +424,6 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 	return vaddr;
 }
 
-static void *ion_handle_kmap_get(struct ion_handle *handle)
-{
-	struct ion_buffer *buffer = handle->buffer;
-	void *vaddr;
-
-	if (handle->kmap_cnt) {
-		handle->kmap_cnt++;
-		return buffer->vaddr;
-	}
-	vaddr = ion_buffer_kmap_get(buffer);
-	if (IS_ERR(vaddr))
-		return vaddr;
-	handle->kmap_cnt++;
-	return vaddr;
-}
-
 static void ion_buffer_kmap_put(struct ion_buffer *buffer)
 {
 	buffer->kmap_cnt--;
@@ -462,49 +446,6 @@ static void ion_handle_kmap_put(struct ion_handle *handle)
 		ion_buffer_kmap_put(buffer);
 }
 
-void *ion_map_kernel(struct ion_client *client, struct ion_handle *handle)
-{
-	struct ion_buffer *buffer;
-	void *vaddr;
-
-	mutex_lock(&client->lock);
-	if (!ion_handle_validate(client, handle)) {
-		pr_err("%s: invalid handle passed to map_kernel.\n",
-		       __func__);
-		mutex_unlock(&client->lock);
-		return ERR_PTR(-EINVAL);
-	}
-
-	buffer = handle->buffer;
-
-	if (!handle->buffer->heap->ops->map_kernel) {
-		pr_err("%s: map_kernel is not implemented by this heap.\n",
-		       __func__);
-		mutex_unlock(&client->lock);
-		return ERR_PTR(-ENODEV);
-	}
-
-	mutex_lock(&buffer->lock);
-	vaddr = ion_handle_kmap_get(handle);
-	mutex_unlock(&buffer->lock);
-	mutex_unlock(&client->lock);
-	return vaddr;
-}
-EXPORT_SYMBOL(ion_map_kernel);
-
-void ion_unmap_kernel(struct ion_client *client, struct ion_handle *handle)
-{
-	struct ion_buffer *buffer;
-
-	mutex_lock(&client->lock);
-	buffer = handle->buffer;
-	mutex_lock(&buffer->lock);
-	ion_handle_kmap_put(handle);
-	mutex_unlock(&buffer->lock);
-	mutex_unlock(&client->lock);
-}
-EXPORT_SYMBOL(ion_unmap_kernel);
-
 static struct mutex debugfs_mutex;
 static struct rb_root *ion_root_client;
 static int is_client_alive(struct ion_client *client)
-- 
2.7.4
