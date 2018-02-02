Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43664 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751709AbeBBNF2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Feb 2018 08:05:28 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-subdev: without controls return -ENOTTY
Message-ID: <6fce05be-3e9e-5c0e-eb55-efc73c978ab7@xs4all.nl>
Date: Fri, 2 Feb 2018 14:05:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the subdev did not define any controls, then return -ENOTTY if
userspace attempts to call these ioctls.

The control framework functions will return -EINVAL, not -ENOTTY if
vfh->ctrl_handler is NULL.

Several of these framework functions are also called directly from
drivers, so I don't want to change the error code there.

Found with vimc and v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 43fefa73e0a3..be7a19272614 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -187,27 +187,43 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)

 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
+		if (!vfh->ctrl_handler)
+			return -ENOTTY;
 		return v4l2_queryctrl(vfh->ctrl_handler, arg);

 	case VIDIOC_QUERY_EXT_CTRL:
+		if (!vfh->ctrl_handler)
+			return -ENOTTY;
 		return v4l2_query_ext_ctrl(vfh->ctrl_handler, arg);

 	case VIDIOC_QUERYMENU:
+		if (!vfh->ctrl_handler)
+			return -ENOTTY;
 		return v4l2_querymenu(vfh->ctrl_handler, arg);

 	case VIDIOC_G_CTRL:
+		if (!vfh->ctrl_handler)
+			return -ENOTTY;
 		return v4l2_g_ctrl(vfh->ctrl_handler, arg);

 	case VIDIOC_S_CTRL:
+		if (!vfh->ctrl_handler)
+			return -ENOTTY;
 		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, arg);

 	case VIDIOC_G_EXT_CTRLS:
+		if (!vfh->ctrl_handler)
+			return -ENOTTY;
 		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);

 	case VIDIOC_S_EXT_CTRLS:
+		if (!vfh->ctrl_handler)
+			return -ENOTTY;
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);

 	case VIDIOC_TRY_EXT_CTRLS:
+		if (!vfh->ctrl_handler)
+			return -ENOTTY;
 		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);

 	case VIDIOC_DQEVENT:
