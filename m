Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:50242 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751168AbeFDLWd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:22:33 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.18] v4l2-ioctl.c: fix missing unlock in
 __video_do_ioctl()
Message-ID: <0aa9ff8a-2675-008a-6441-164d60ecb017@xs4all.nl>
Date: Mon, 4 Jun 2018 13:22:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If dev_debug was active, then the code could return without unlocking the
core mutex. Replace the return with a 'goto unlock' to ensure proper unlocking.

Fixes: 73a110623e7b ("v4l2-core: push taking ioctl mutex down to ioctl handler")
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 965fd301f617..dd210067151f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2777,7 +2777,7 @@ static long __video_do_ioctl(struct file *file,
 	if (dev_debug & (V4L2_DEV_DEBUG_IOCTL | V4L2_DEV_DEBUG_IOCTL_ARG)) {
 		if (!(dev_debug & V4L2_DEV_DEBUG_STREAMING) &&
 		    (cmd == VIDIOC_QBUF || cmd == VIDIOC_DQBUF))
-			return ret;
+			goto unlock;

 		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
 		if (ret < 0)
