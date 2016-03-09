Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37853 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbcCIIyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 03:54:15 -0500
Received: by mail-wm0-f43.google.com with SMTP id p65so61000095wmp.0
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2016 00:54:14 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	sumit.semwal@linaro.org, john.stultz@linaro.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH] dmabuf: allow exporter to define customs ioctls
Date: Wed,  9 Mar 2016 09:54:02 +0100
Message-Id: <1457513642-10859-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In addition of the already existing operations allow exporter
to use it own custom ioctls.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/dma-buf/dma-buf.c | 3 +++
 include/linux/dma-buf.h   | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 9810d1d..6abd129 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -291,6 +291,9 @@ static long dma_buf_ioctl(struct file *file,
 
 		return 0;
 	default:
+		if (dmabuf->ops->ioctl)
+			return dmabuf->ops->ioctl(dmabuf, cmd, arg);
+
 		return -ENOTTY;
 	}
 }
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 532108e..b6f9837 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -70,6 +70,9 @@ struct dma_buf_attachment;
  * @vmap: [optional] creates a virtual mapping for the buffer into kernel
  *	  address space. Same restrictions as for vmap and friends apply.
  * @vunmap: [optional] unmaps a vmap from the buffer
+ * @ioctl: [optional] ioctls supported by the exporter.
+ *	   It is up to the exporter to do the proper copy_{from/to}_user
+ *	   calls. Should return -EINVAL in case of error.
  */
 struct dma_buf_ops {
 	int (*attach)(struct dma_buf *, struct device *,
@@ -104,6 +107,8 @@ struct dma_buf_ops {
 
 	void *(*vmap)(struct dma_buf *);
 	void (*vunmap)(struct dma_buf *, void *vaddr);
+
+	int (*ioctl)(struct dma_buf *, unsigned int cmd, unsigned long arg);
 };
 
 /**
-- 
1.9.1

