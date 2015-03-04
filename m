Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45831 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759109AbbCDJso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 04:48:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/8] v4l2-subdev.c: add 'which' checks for enum ops.
Date: Wed,  4 Mar 2015 10:47:56 +0100
Message-Id: <1425462481-8200-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
References: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Return an error if an invalid 'which' valid is passed in.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
2.1.4

