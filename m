Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4051 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3A2Qd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 02/20] cx231xx: add required VIDIOC_DBG_G_CHIP_IDENT support.
Date: Tue, 29 Jan 2013 17:32:55 +0100
Message-Id: <f8cf5ba0c7bfd620ada8601885e8190dd2799ead.1359476776.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This fixes a v4l2_compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 7324624..44bc687 100644
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
@@ -2513,6 +2525,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner                = vidioc_s_tuner,
 	.vidioc_g_frequency            = vidioc_g_frequency,
 	.vidioc_s_frequency            = vidioc_s_frequency,
+	.vidioc_g_chip_ident           = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register             = vidioc_g_register,
 	.vidioc_s_register             = vidioc_s_register,
-- 
1.7.10.4

