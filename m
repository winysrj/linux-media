Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:44726 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbbGTNTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:19:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/5] zoran: remove unused read/write functions
Date: Mon, 20 Jul 2015 15:18:19 +0200
Message-Id: <1437398302-6211-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
References: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The zoran_read/write functions always return an error. Just remove them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/zoran/zoran_driver.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 25cd18b..3d3a0c0 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1032,29 +1032,6 @@ zoran_close(struct file  *file)
 	return 0;
 }
 
-
-static ssize_t
-zoran_read (struct file *file,
-	    char        __user *data,
-	    size_t       count,
-	    loff_t      *ppos)
-{
-	/* we simply don't support read() (yet)... */
-
-	return -EINVAL;
-}
-
-static ssize_t
-zoran_write (struct file *file,
-	     const char  __user *data,
-	     size_t       count,
-	     loff_t      *ppos)
-{
-	/* ...and the same goes for write() */
-
-	return -EINVAL;
-}
-
 static int setup_fbuffer(struct zoran_fh *fh,
 	       void                      *base,
 	       const struct zoran_format *fmt,
@@ -3052,8 +3029,6 @@ static const struct v4l2_file_operations zoran_fops = {
 	.open = zoran_open,
 	.release = zoran_close,
 	.unlocked_ioctl = zoran_ioctl,
-	.read = zoran_read,
-	.write = zoran_write,
 	.mmap = zoran_mmap,
 	.poll = zoran_poll,
 };
-- 
2.1.4

