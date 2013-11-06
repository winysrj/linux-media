Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:54663 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab3KFOfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 09:35:38 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Ricardo Ribalda <ricardo.ribalda@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"open list:SAMSUNG S5P/EXYNO..." <linux-media@vger.kernel.org>,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-arm-kernel@lists.infradead.org>,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-samsung-soc@vger.kernel.org>
Subject: [PATCH v6] videobuf2: Add missing lock held on vb2_fop_relase
Date: Wed,  6 Nov 2013 15:35:33 +0100
Message-Id: <1383748533-22394-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

vb2_fop_release does not held the lock although it is modifying the
queue->owner field.

This could lead to race conditions on the vb2_perform_io function
when multiple applications are accessing the video device via
read/write API:

[ 308.297741] BUG: unable to handle kernel NULL pointer dereference at
0000000000000260
[ 308.297759] IP: [<ffffffffa07a9fd2>] vb2_perform_fileio+0x372/0x610
[videobuf2_core]
[ 308.297794] PGD 159719067 PUD 158119067 PMD 0
[ 308.297812] Oops: 0000 #1 SMP
[ 308.297826] Modules linked in: qt5023_video videobuf2_dma_sg
qtec_xform videobuf2_vmalloc videobuf2_memops videobuf2_core
qtec_white qtec_mem gpio_xilinx qtec_cmosis qtec_pcie fglrx(PO)
spi_xilinx spi_bitbang qt5023
[ 308.297888] CPU: 1 PID: 2189 Comm: java Tainted: P O 3.11.0-qtec-standard #1
[ 308.297919] Hardware name: QTechnology QT5022/QT5022, BIOS
PM_2.1.0.309 X64 05/23/2013
[ 308.297952] task: ffff8801564e1690 ti: ffff88014dc02000 task.ti:
ffff88014dc02000
[ 308.297962] RIP: 0010:[<ffffffffa07a9fd2>] [<ffffffffa07a9fd2>]
vb2_perform_fileio+0x372/0x610 [videobuf2_core]
[ 308.297985] RSP: 0018:ffff88014dc03df8 EFLAGS: 00010202
[ 308.297995] RAX: 0000000000000000 RBX: ffff880158a23000 RCX: dead000000100100
[ 308.298003] RDX: 0000000000000000 RSI: dead000000200200 RDI: 0000000000000000
[ 308.298012] RBP: ffff88014dc03e58 R08: 0000000000000000 R09: 0000000000000001
[ 308.298020] R10: ffffea00051e8380 R11: ffff88014dc03fd8 R12: ffff880158a23070
[ 308.298029] R13: ffff8801549040b8 R14: 0000000000198000 R15: 0000000001887e60
[ 308.298040] FS: 00007f65130d5700(0000) GS:ffff88015ed00000(0000)
knlGS:0000000000000000
[ 308.298049] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 308.298057] CR2: 0000000000000260 CR3: 0000000159630000 CR4: 00000000000007e0
[ 308.298064] Stack:
[ 308.298071] ffff880156416c00 0000000000198000 0000000000000000
ffff880100000001
[ 308.298087] ffff88014dc03f50 00000000810a79ca 0002000000000001
ffff880154904718
[ 308.298101] ffff880156416c00 0000000000198000 ffff880154904338
ffff88014dc03f50
[ 308.298116] Call Trace:
[ 308.298143] [<ffffffffa07aa3c4>] vb2_read+0x14/0x20 [videobuf2_core]
[ 308.298198] [<ffffffffa07aa494>] vb2_fop_read+0xc4/0x120 [videobuf2_core]
[ 308.298252] [<ffffffff8154ee9e>] v4l2_read+0x7e/0xc0
[ 308.298296] [<ffffffff8116e639>] vfs_read+0xa9/0x160
[ 308.298312] [<ffffffff8116e882>] SyS_read+0x52/0xb0
[ 308.298328] [<ffffffff81784179>] tracesys+0xd0/0xd5
[ 308.298335] Code: e5 d6 ff ff 83 3d be 24 00 00 04 89 c2 4c 8b 45 b0
44 8b 4d b8 0f 8f 20 02 00 00 85 d2 75 32 83 83 78 03 00 00 01 4b 8b
44 c5 48 <8b> 88 60 02 00 00 85 c9 0f 84 b0 00 00 00 8b 40 58 89 c2 41
89
[ 308.298487] RIP [<ffffffffa07a9fd2>] vb2_perform_fileio+0x372/0x610
[videobuf2_core]
[ 308.298507] RSP <ffff88014dc03df8>
[ 308.298514] CR2: 0000000000000260
[ 308.298526] ---[ end trace e8f01717c96d1e41 ]---

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v2: Comments by Sylvester Nawrocki

fimc-capture and fimc-lite where calling vb2_fop_release with the lock held.
Therefore a new __vb2_fop_release function has been created to be used by
drivers that overload the release function.

v3: Comments by Sylvester Nawrocki and Mauro Carvalho Chehab

Use vb2_fop_release_locked instead of __vb2_fop_release

v4: Comments by Sylvester Nawrocki

Rename vb2_fop_release_locked to __vb2_fop_release and fix patch format

v5: Comments by Sylvester Nawrocki and Hans Verkuil

Rename __vb2_fop_release to vb2_fop_release_unlock and rearrange
arguments

v6: Comments by Hans Verkuil

Fix typo on description
Rename vb2_fop_release_locked to vb2_fop_release_no_lock

 drivers/media/platform/exynos4-is/fimc-capture.c |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c         | 20 +++++++++++++++++++-
 include/media/videobuf2-core.h                   |  1 +
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index fb27ff7..f3382c1 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -549,7 +549,7 @@ static int fimc_capture_release(struct file *file)
 		vc->streaming = false;
 	}
 
-	ret = vb2_fop_release(file);
+	ret = vb2_fop_release_no_lock(file);
 
 	if (close) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index e5798f7..5d2b50c 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -546,7 +546,7 @@ static int fimc_lite_release(struct file *file)
 		mutex_unlock(&entity->parent->graph_mutex);
 	}
 
-	vb2_fop_release(file);
+	vb2_fop_release_no_lock(file);
 	pm_runtime_put(&fimc->pdev->dev);
 	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
 
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 594c75e..0b1bfbe 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2619,18 +2619,36 @@ int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
 }
 EXPORT_SYMBOL_GPL(vb2_fop_mmap);
 
-int vb2_fop_release(struct file *file)
+static int _vb2_fop_release(struct file *file, struct mutex *lock)
 {
 	struct video_device *vdev = video_devdata(file);
 
 	if (file->private_data == vdev->queue->owner) {
+		if (lock)
+			mutex_lock(lock);
 		vb2_queue_release(vdev->queue);
 		vdev->queue->owner = NULL;
+		if (lock)
+			mutex_unlock(lock);
 	}
 	return v4l2_fh_release(file);
 }
+
+int vb2_fop_release(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+
+	return _vb2_fop_release(file, lock);
+}
 EXPORT_SYMBOL_GPL(vb2_fop_release);
 
+int vb2_fop_release_no_lock(struct file *file)
+{
+	return _vb2_fop_release(file, NULL);
+}
+EXPORT_SYMBOL_GPL(vb2_fop_release_no_lock);
+
 ssize_t vb2_fop_write(struct file *file, char __user *buf,
 		size_t count, loff_t *ppos)
 {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 6781258..5955b2d 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -491,6 +491,7 @@ int vb2_ioctl_expbuf(struct file *file, void *priv,
 
 int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
 int vb2_fop_release(struct file *file);
+int vb2_fop_release_no_lock(struct file *file);
 ssize_t vb2_fop_write(struct file *file, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vb2_fop_read(struct file *file, char __user *buf,
-- 
1.8.4.rc3

