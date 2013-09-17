Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:29378 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3IQMXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 08:23:40 -0400
From: Inki Dae <inki.dae@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-kernel@lists.linaro.org
Cc: Roger.Teague@arm.com, jesse.barker@arm.com,
	jesse.barker@linaro.org, maarten.lankhorst@canonical.com,
	sumit.semwal@linaro.org, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v2 2/2] dma-buf: Add user interfaces for dmabuf sync support
Date: Tue, 17 Sep 2013 21:23:36 +0900
Message-id: <1379420616-9194-3-git-send-email-inki.dae@samsung.com>
In-reply-to: <1379420616-9194-1-git-send-email-inki.dae@samsung.com>
References: <1379420616-9194-1-git-send-email-inki.dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds lock and poll callbacks to dma buf file operations,
and these callbacks will be called by fcntl and select system calls.

fcntl and select system calls can be used to wait for the completion
of DMA or CPU access to a shared dmabuf. The difference of them is
fcntl system call takes a lock after the completion but select system
call doesn't. So in case of fcntl system call, it's useful when a task
wants to access a shared dmabuf without any broken. On the other hand,
it's useful when a task wants to just wait for the completion.

Changelog v2:
- Add select system call support.
  . The purpose of this feature is to wait for the completion of DMA or
    CPU access to a dmabuf without that caller locks the dmabuf again
    after the completion.
    That is useful when caller wants to be aware of the completion of
    DMA access to the dmabuf, and the caller doesn't use intefaces for
    the DMA device driver.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/base/dma-buf.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 3985751..73234ba 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -29,6 +29,7 @@
 #include <linux/export.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/poll.h>
 #include <linux/dmabuf-sync.h>
 
 static inline int is_dma_buf_file(struct file *);
@@ -106,10 +107,90 @@ static loff_t dma_buf_llseek(struct file *file, loff_t offset, int whence)
 	return base + offset;
 }
 
+static unsigned int dma_buf_poll(struct file *filp,
+					struct poll_table_struct *poll)
+{
+	struct dma_buf *dmabuf;
+	struct dmabuf_sync_reservation *robj;
+	int ret = 0;
+
+	if (!is_dma_buf_file(filp))
+		return POLLERR;
+
+	dmabuf = filp->private_data;
+	if (!dmabuf || !dmabuf->sync)
+		return POLLERR;
+
+	robj = dmabuf->sync;
+
+	mutex_lock(&robj->lock);
+
+	robj->polled = true;
+
+	/*
+	 * CPU or DMA access to this buffer has been completed, and
+	 * the blocked task has been waked up. Return poll event
+	 * so that the task can get out of select().
+	 */
+	if (robj->poll_event) {
+		robj->poll_event = false;
+		mutex_unlock(&robj->lock);
+		return POLLIN | POLLOUT;
+	}
+
+	/*
+	 * There is no anyone accessing this buffer so just return.
+	 */
+	if (!robj->locked) {
+		mutex_unlock(&robj->lock);
+		return POLLIN | POLLOUT;
+	}
+
+	poll_wait(filp, &robj->poll_wait, poll);
+
+	mutex_unlock(&robj->lock);
+
+	return ret;
+}
+
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
 	.llseek		= dma_buf_llseek,
+	.poll		= dma_buf_poll,
+	.lock		= dma_buf_lock,
 };
 
 /*
-- 
1.7.9.5

