Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27753 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbaAaP0H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 10:26:07 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 055752001D
	for <linux-media@vger.kernel.org>; Fri, 31 Jan 2014 17:25:30 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: subdev: Allow 32-bit compat IOCTLs
Date: Fri, 31 Jan 2014 17:28:49 +0200
Message-Id: <1391182129-5234-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I thought this was already working but apparently not. Allow 32-bit compat
IOCTLs on 64-bit systems.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..99c54f4 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -389,6 +389,9 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
 	.owner = THIS_MODULE,
 	.open = subdev_open,
 	.unlocked_ioctl = subdev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32 = subdev_ioctl,
+#endif /* CONFIG_COMPAT */
 	.release = subdev_close,
 	.poll = subdev_poll,
 };
-- 
1.8.3.2

