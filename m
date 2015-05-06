Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54419 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479AbbEFG5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:57:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 5/8] v4l2-subdev: add MEDIA_IOC_DEVICE_INFO
Date: Wed,  6 May 2015 08:57:20 +0200
Message-Id: <1430895443-41839-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the MEDIA_IOC_DEVICE_INFO ioctl for entities.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 50ada27..ae7480b 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -201,6 +201,18 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		break;
 	}
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	case MEDIA_IOC_DEVICE_INFO: {
+		struct media_device_info *info = arg;
+
+		if (sd->entity.parent == NULL)
+			return -ENOTTY;
+		media_device_fill_info(sd->entity.parent, info);
+		info->entity_id = sd->entity.id;
+		return 0;
+	}
+#endif
+
 	case VIDIOC_QUERYCTRL:
 		return v4l2_queryctrl(vfh->ctrl_handler, arg);
 
-- 
2.1.4

