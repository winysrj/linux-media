Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:35280 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751095AbeBYLzk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 06:55:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for 4.16] atomisp_fops.c: disable atomisp_compat_ioctl32
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <719145fe-b041-c88e-0afb-dcc15e9c8b8a@xs4all.nl>
Date: Sun, 25 Feb 2018 12:55:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The atomisp_compat_ioctl32() code has problems. This patch disables the
compat_ioctl32 support until those issues have been fixed.

Contact Sakari or me for more details.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.12 and up
---
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index 4f9f9dca5e6a..545ef024841d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -1279,7 +1279,10 @@ const struct v4l2_file_operations atomisp_fops = {
 	.mmap = atomisp_mmap,
 	.unlocked_ioctl = video_ioctl2,
 #ifdef CONFIG_COMPAT
+	/*
+	 * There are problems with this code. Disable this for now.
 	.compat_ioctl32 = atomisp_compat_ioctl32,
+	 */
 #endif
 	.poll = atomisp_poll,
 };
@@ -1291,7 +1294,10 @@ const struct v4l2_file_operations atomisp_file_fops = {
 	.mmap = atomisp_file_mmap,
 	.unlocked_ioctl = video_ioctl2,
 #ifdef CONFIG_COMPAT
+	/*
+	 * There are problems with this code. Disable this for now.
 	.compat_ioctl32 = atomisp_compat_ioctl32,
+	 */
 #endif
 	.poll = atomisp_poll,
 };
