Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38455 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S937980AbeBUPcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:32:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 03/15] v4l2-subdev: without controls return -ENOTTY
Date: Wed, 21 Feb 2018 16:32:06 +0100
Message-Id: <20180221153218.15654-4-hverkuil@xs4all.nl>
In-Reply-To: <20180221153218.15654-1-hverkuil@xs4all.nl>
References: <20180221153218.15654-1-hverkuil@xs4all.nl>
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
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index c5639817db34..b14c5e1705ca 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -187,27 +187,51 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
+		/*
+		 * TODO: this really should be folded into v4l2_queryctrl (this
+		 * currently returns -EINVAL for NULL control handlers).
+		 * However, v4l2_queryctrl() is still called directly by
+		 * drivers as well and until that has been addressed I believe
+		 * it is safer to do the check here. The same is true for the
+		 * other control ioctls below.
+		 */
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
-- 
2.16.1
