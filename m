Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63275 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GLGMz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 02:12:55 -0400
From: Inki Dae <inki.dae@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: maarten.lankhorst@canonical.com, daniel@ffwll.ch,
	robdclark@gmail.com, sumit.semwal@linaro.org,
	linux@arm.linux.org.uk, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, yj44.cho@samsung.com,
	Inki Dae <inki.dae@samsung.com>
Subject: [RFC PATCH v1 2/2] dma-buf: add lock callback for fcntl system call
Date: Fri, 12 Jul 2013 15:12:46 +0900
Message-id: <1373609566-10784-3-git-send-email-inki.dae@samsung.com>
In-reply-to: <1373609566-10784-1-git-send-email-inki.dae@samsung.com>
References: <1373609566-10784-1-git-send-email-inki.dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds lock callback to dma buf file operations,
and this callback will be called by fcntl system call.

With this patch, fcntl system call can be used for buffer
synchronization between CPU and CPU, and CPU and DMA in user mode.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/base/dma-buf.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 9a26981..e1b8583 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -80,9 +80,42 @@ static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
 	return dmabuf->ops->mmap(dmabuf, vma);
 }
 
+static int dma_buf_lock(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct dma_buf *dmabuf;
+	unsigned int type;
+	bool wait = false;
+
+	if (!is_dma_buf_file(file))
+		return -EINVAL;
+
+	dmabuf = file->private_data;
+
+	if ((fl->fl_type & F_UNLCK) == F_UNLCK) {
+		dmabuf_sync_single_unlock(dmabuf);
+		return 0;
+	}
+
+	/* convert flock type to dmabuf sync type. */
+	if ((fl->fl_type & F_WRLCK) == F_WRLCK)
+		type = DMA_BUF_ACCESS_W;
+	else if ((fl->fl_type & F_RDLCK) == F_RDLCK)
+		type = DMA_BUF_ACCESS_R;
+	else
+		return -EINVAL;
+
+	if (fl->fl_flags & FL_SLEEP)
+		wait = true;
+
+	/* TODO. the locking to certain region should also be considered. */
+
+	return dmabuf_sync_single_lock(dmabuf, type, wait);
+}
+
 static const struct file_operations dma_buf_fops = {
 	.release	= dma_buf_release,
 	.mmap		= dma_buf_mmap_internal,
+	.lock		= dma_buf_lock,
 };
 
 /*
-- 
1.7.5.4

