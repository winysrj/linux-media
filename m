Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1265 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3BIKBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/26] cx231xx: add required VIDIOC_DBG_G_CHIP_IDENT support.
Date: Sat,  9 Feb 2013 11:00:32 +0100
Message-Id: <2c7d32b3e8252198ec61b5071d32c98265c50293.1360403309.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This fixes a v4l2_compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index ffeedcd..794b83c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1456,6 +1456,18 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return rc;
 }
 
+static int vidioc_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_ident *chip)
+{
+	chip->ident = V4L2_IDENT_NONE;
+	chip->revision = 0;
+	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
+		if (v4l2_chip_match_host(&chip->match))
+			chip->ident = V4L2_IDENT_CX23100;
+		return 0;
+	}
+	return -EINVAL;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 
 /*
@@ -2514,6 +2526,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner                = vidioc_s_tuner,
 	.vidioc_g_frequency            = vidioc_g_frequency,
 	.vidioc_s_frequency            = vidioc_s_frequency,
+	.vidioc_g_chip_ident           = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register             = vidioc_g_register,
 	.vidioc_s_register             = vidioc_s_register,
-- 
1.7.10.4

