Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2764 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaBQLo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 06:44:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/3] tw9910: add g_tvnorms video op
Date: Mon, 17 Feb 2014 12:44:13 +0100
Message-Id: <1392637454-29179-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
References: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Report to soc_camera which standards are supported by tw9910.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/soc_camera/tw9910.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index ab54628..02a51ff 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -872,6 +872,12 @@ static int tw9910_s_mbus_config(struct v4l2_subdev *sd,
 	return i2c_smbus_write_byte_data(client, OUTCTR1, val);
 }
 
+static int tw9910_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
+{
+	*norm = V4L2_STD_NTSC | V4L2_STD_PAL;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_stream	= tw9910_s_stream,
 	.g_mbus_fmt	= tw9910_g_fmt,
@@ -882,6 +888,7 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.enum_mbus_fmt	= tw9910_enum_fmt,
 	.g_mbus_config	= tw9910_g_mbus_config,
 	.s_mbus_config	= tw9910_s_mbus_config,
+	.g_tvnorms	= tw9910_g_tvnorms,
 };
 
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
-- 
1.8.5.2

