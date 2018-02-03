Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:33750 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751787AbeBCNYt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Feb 2018 08:24:49 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO ioctl
Message-ID: <86057176-1174-6dd7-d086-9594ad72f277@xs4all.nl>
Date: Sat, 3 Feb 2018 14:24:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 43fefa73e0a3..77210a20e90e 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -239,6 +255,19 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
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
