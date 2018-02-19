Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39597 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752533AbeBSKiN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 05:38:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 05/15] v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO ioctl
Date: Mon, 19 Feb 2018 11:37:56 +0100
Message-Id: <20180219103806.17032-6-hverkuil@xs4all.nl>
In-Reply-To: <20180219103806.17032-1-hverkuil@xs4all.nl>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDIOC_DBG_G/S_REGISTER ioctls imply that VIDIOC_DBG_G_CHIP_INFO is also
present, since without that you cannot use v4l2-dbg.

Just like the implementation in v4l2-ioctl.c this can be implemented in the
core and no drivers need to be modified.

It also makes it possible for v4l2-compliance to properly test the
VIDIOC_DBG_G/S_REGISTER ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 168ecb4bed23..7cff4922e8d1 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -263,6 +263,19 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			return -EPERM;
 		return v4l2_subdev_call(sd, core, s_register, p);
 	}
+	case VIDIOC_DBG_G_CHIP_INFO:
+	{
+		struct v4l2_dbg_chip_info *p = arg;
+
+		if (p->match.type != V4L2_CHIP_MATCH_SUBDEV || p->match.addr)
+			return -EINVAL;
+		if (sd->ops->core && sd->ops->core->s_register)
+			p->flags |= V4L2_CHIP_FL_WRITABLE;
+		if (sd->ops->core && sd->ops->core->g_register)
+			p->flags |= V4L2_CHIP_FL_READABLE;
+		strlcpy(p->name, sd->name, sizeof(p->name));
+		return 0;
+	}
 #endif
 
 	case VIDIOC_LOG_STATUS: {
-- 
2.16.1
