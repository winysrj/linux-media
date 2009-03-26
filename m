Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:45316 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863AbZCZOaB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 10:30:01 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch] allow v4l2 drivers to provide a get_unmapped_area handler
Date: Thu, 26 Mar 2009 15:31:08 +0100
Message-Id: <1238077868-25812-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shared memory mappings on nommu machines require a get_unmapped_area
file operation that suggests an address for the mapping. This patch
adds a way for v4l2 drivers to provide this callback.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/media/video/v4l2-dev.c |   19 +++++++++++++++++++
 include/media/v4l2-dev.h       |    2 ++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 13f87c2..8c84037 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -198,6 +198,23 @@ static long v4l2_unlocked_ioctl(struct file *filp,
 	return vdev->fops->unlocked_ioctl(filp, cmd, arg);
 }
 
+#ifdef CONFIG_MMU
+#define v4l2_get_unmapped_area NULL
+#else
+static unsigned long v4l2_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	struct video_device *vdev = video_devdata(filp);
+
+	if (!vdev->fops->get_unmapped_area)
+		return -ENOSYS;
+	if (video_is_unregistered(vdev))
+		return -ENODEV;
+	return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+#endif
+
 static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 {
 	struct video_device *vdev = video_devdata(filp);
@@ -250,6 +267,7 @@ static const struct file_operations v4l2_unlocked_fops = {
 	.read = v4l2_read,
 	.write = v4l2_write,
 	.open = v4l2_open,
+	.get_unmapped_area = v4l2_get_unmapped_area,
 	.mmap = v4l2_mmap,
 	.unlocked_ioctl = v4l2_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
@@ -265,6 +283,7 @@ static const struct file_operations v4l2_fops = {
 	.read = v4l2_read,
 	.write = v4l2_write,
 	.open = v4l2_open,
+	.get_unmapped_area = v4l2_get_unmapped_area,
 	.mmap = v4l2_mmap,
 	.ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index e36faab..2058dd4 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -40,6 +40,8 @@ struct v4l2_file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
+	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
+				unsigned long, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct file *);
 	int (*release) (struct file *);
-- 
1.6.2.107.ge47ee

