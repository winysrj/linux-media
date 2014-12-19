Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48532 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbaLSOw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 09:52:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/11] v4l2-subdev.c: add which checks for enum ops.
Date: Fri, 19 Dec 2014 15:51:33 +0100
Message-Id: <1419000696-25202-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
References: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 3c8b198..8bafb94 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -321,6 +321,10 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {
 		struct v4l2_subdev_mbus_code_enum *code = arg;
 
+		if (code->which != V4L2_SUBDEV_FORMAT_TRY &&
+		    code->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
 		if (code->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
@@ -331,6 +335,10 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_ENUM_FRAME_SIZE: {
 		struct v4l2_subdev_frame_size_enum *fse = arg;
 
+		if (fse->which != V4L2_SUBDEV_FORMAT_TRY &&
+		    fse->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
 		if (fse->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
@@ -359,6 +367,10 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL: {
 		struct v4l2_subdev_frame_interval_enum *fie = arg;
 
+		if (fie->which != V4L2_SUBDEV_FORMAT_TRY &&
+		    fie->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
 		if (fie->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
-- 
2.1.3

