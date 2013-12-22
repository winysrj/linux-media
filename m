Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43727 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab3LVVRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 16:17:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC] v4l: disable lockdep on vb2_fop_mmap()
Date: Sun, 22 Dec 2013 23:17:26 +0200
Message-Id: <1387747046-12677-2-git-send-email-crope@iki.fi>
In-Reply-To: <1387747046-12677-1-git-send-email-crope@iki.fi>
References: <1387747046-12677-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid that lockdep warning:

[ INFO: possible circular locking dependency detected ]
3.13.0-rc1+ #77 Tainted: G         C O
-------------------------------------------------------
video_source:sr/32072 is trying to acquire lock:
 (&dev->mutex#2){+.+.+.}, at: [<ffffffffa073fde3>] vb2_fop_mmap+0x33/0x90 [videobuf2_core]

                                                but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff8117825f>] vm_mmap_pgoff+0x6f/0xc0

 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&mm->mmap_sem);
                               lock(&dev->mutex#2);
                               lock(&mm->mmap_sem);
  lock(&dev->mutex#2);
                                                 *** DEADLOCK ***

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/videobuf2-core.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 12df9fd..2a74295 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2641,12 +2641,24 @@ int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
 	struct video_device *vdev = video_devdata(file);
 	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
 	int err;
+	/*
+	 * FIXME: Ugly hack. Disable possible lockdep as it detects possible
+	 * deadlock. "INFO: possible circular locking dependency detected"
+	 */
+	lockdep_off();
 
-	if (lock && mutex_lock_interruptible(lock))
+	if (lock && mutex_lock_interruptible(lock)) {
+		lockdep_on();
 		return -ERESTARTSYS;
+	}
+
 	err = vb2_mmap(vdev->queue, vma);
+
 	if (lock)
 		mutex_unlock(lock);
+
+	lockdep_on();
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(vb2_fop_mmap);
-- 
1.8.4.2

