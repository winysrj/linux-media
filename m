Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2494 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3EaKDV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 12/21] radio-timb: convert to the control framework.
Date: Fri, 31 May 2013 12:02:32 +0200
Message-Id: <1369994561-25236-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
---
 drivers/media/radio/radio-timb.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index cecf7d7..99694dd 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -77,36 +77,12 @@ static int timbradio_vidioc_g_frequency(struct file *file, void *priv,
 	return v4l2_subdev_call(tr->sd_tuner, tuner, g_frequency, f);
 }
 
-static int timbradio_vidioc_queryctrl(struct file *file, void *priv,
-	struct v4l2_queryctrl *qc)
-{
-	struct timbradio *tr = video_drvdata(file);
-	return v4l2_subdev_call(tr->sd_dsp, core, queryctrl, qc);
-}
-
-static int timbradio_vidioc_g_ctrl(struct file *file, void *priv,
-	struct v4l2_control *ctrl)
-{
-	struct timbradio *tr = video_drvdata(file);
-	return v4l2_subdev_call(tr->sd_dsp, core, g_ctrl, ctrl);
-}
-
-static int timbradio_vidioc_s_ctrl(struct file *file, void *priv,
-	struct v4l2_control *ctrl)
-{
-	struct timbradio *tr = video_drvdata(file);
-	return v4l2_subdev_call(tr->sd_dsp, core, s_ctrl, ctrl);
-}
-
 static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
 	.vidioc_querycap	= timbradio_vidioc_querycap,
 	.vidioc_g_tuner		= timbradio_vidioc_g_tuner,
 	.vidioc_s_tuner		= timbradio_vidioc_s_tuner,
 	.vidioc_g_frequency	= timbradio_vidioc_g_frequency,
 	.vidioc_s_frequency	= timbradio_vidioc_s_frequency,
-	.vidioc_queryctrl	= timbradio_vidioc_queryctrl,
-	.vidioc_g_ctrl		= timbradio_vidioc_g_ctrl,
-	.vidioc_s_ctrl		= timbradio_vidioc_s_ctrl
 };
 
 static const struct v4l2_file_operations timbradio_fops = {
-- 
1.7.10.4

