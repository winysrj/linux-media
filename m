Return-path: <mchehab@pedra>
Received: from smtp-cpk.frontbridge.com ([204.231.192.41]:12740 "EHLO
	WA2EHSNDR001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751900Ab1D2KIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 06:08:42 -0400
Received: from mail158-ch1 (localhost.localdomain [127.0.0.1])	by
 mail158-ch1-R.bigfish.com (Postfix) with ESMTP id 783313A0255	for
 <linux-media@vger.kernel.org>; Fri, 29 Apr 2011 09:54:22 +0000 (UTC)
Received: from CH1EHSMHS035.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.242])	by mail158-ch1.bigfish.com (Postfix) with ESMTP id
 4212B164804B	for <linux-media@vger.kernel.org>; Fri, 29 Apr 2011 09:54:22
 +0000 (UTC)
From: Bob Liu <lliubbo@gmail.com>
To: <linux-media@vger.kernel.org>
CC: <dhowells@redhat.com>, <linux-uvc-devel@lists.berlios.de>,
	<mchehab@redhat.com>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>,
	<sakari.ailus@maxwell.research.nokia.com>,
	<martin_rubli@logitech.com>, <jarod@redhat.com>, <tj@kernel.org>,
	<arnd@arndb.de>, <fweisbec@gmail.com>, <agust@denx.de>,
	<gregkh@suse.de>, <daniel-gl@gmx.net>, <vapier@gentoo.org>,
	Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 1/2] V4L/DVB: v4l2-dev: revert commit c29fcff3daafbf46d64a543c1950bbd206ad8c1c
Date: Fri, 29 Apr 2011 18:11:34 +0800
Message-ID: <1304071895-27898-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Reply-To: <lliubbo@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Revert commit:
V4L/DVB: v4l2-dev: remove get_unmapped_area(c29fcff3daafbf46d64a543c1950bb)
to restore NOMMU arch supporting.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/media/video/v4l2-dev.c |   18 ++++++++++++++++++
 include/media/v4l2-dev.h       |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 6dc7196..19d5ae2 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -352,6 +352,23 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	return ret;
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
+	if (!video_is_registered(vdev))
+		return -ENODEV;
+	return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+#endif
+
 static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 {
 	struct video_device *vdev = video_devdata(filp);
@@ -454,6 +471,7 @@ static const struct file_operations v4l2_fops = {
 	.read = v4l2_read,
 	.write = v4l2_write,
 	.open = v4l2_open,
+	.get_unmapped_area = v4l2_get_unmapped_area,
 	.mmap = v4l2_mmap,
 	.unlocked_ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 8266d5a..93e96fb 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -62,6 +62,8 @@ struct v4l2_file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
+	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
+				unsigned long, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct file *);
 	int (*release) (struct file *);
-- 
1.6.3.3


