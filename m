Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39218 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933271AbdC3MFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 08:05:30 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-compat-ioctl32: VIDIOC_S_EDID should return all fields
 on error.
Message-ID: <60d00b48-8aaf-2a80-02ea-c873071d5533@xs4all.nl>
Date: Thu, 30 Mar 2017 14:05:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most ioctls do not have to write back the contents of the argument
if an error is returned. But VIDIOC_S_EDID is an exception together
with the EXT_CTRLS ioctls (already handled correctly).

Add this exception to v4l2-compat-ioctl32.

This fixes a compliance error when using compat32 and trying to
set a new EDID with more blocks than the hardware supports. In
that case the driver will return -E2BIG and set edid.blocks to the
actual maximum number of blocks. This field was never copied back
to userspace due to this bug.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index b9caaf7fa828..5f29e18868f8 100755
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -956,6 +956,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		if (put_v4l2_ext_controls32(&karg.v2ecs, up))
 			err = -EFAULT;
 		break;
+	case VIDIOC_S_EDID:
+		if (put_v4l2_edid32(&karg.v2edid, up))
+			err = -EFAULT;
+		break;
 	}
 	if (err)
 		return err;
@@ -977,7 +981,6 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		break;

 	case VIDIOC_G_EDID:
-	case VIDIOC_S_EDID:
 		err = put_v4l2_edid32(&karg.v2edid, up);
 		break;

-- 
2.11.0
