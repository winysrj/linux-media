Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2683 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0KNNXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:23:03 -0500
Message-Id: <7007d2c0dd243a8470cef235db52d352d32a7b72.1289740431.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289740431.git.hverkuil@xs4all.nl>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 14 Nov 2010 14:22:49 +0100
Subject: [RFC PATCH 6/8] typhoon: convert to unlocked_ioctl.
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Convert the typhoon driver from ioctl to unlocked_ioctl.

When doing this I noticed a bug where curfreq was not initialized correctly
to mutefreq (it wasn't multiplied by 16).

The initialization is now also done before the device node is created.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-typhoon.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/radio-typhoon.c
index b1f6305..8dbbf08 100644
--- a/drivers/media/radio/radio-typhoon.c
+++ b/drivers/media/radio/radio-typhoon.c
@@ -317,7 +317,7 @@ static int vidioc_log_status(struct file *file, void *priv)
 
 static const struct v4l2_file_operations typhoon_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops typhoon_ioctl_ops = {
@@ -344,18 +344,18 @@ static int __init typhoon_init(void)
 
 	strlcpy(v4l2_dev->name, "typhoon", sizeof(v4l2_dev->name));
 	dev->io = io;
-	dev->curfreq = dev->mutefreq = mutefreq;
 
 	if (dev->io == -1) {
 		v4l2_err(v4l2_dev, "You must set an I/O address with io=0x316 or io=0x336\n");
 		return -EINVAL;
 	}
 
-	if (dev->mutefreq < 87000 || dev->mutefreq > 108500) {
+	if (mutefreq < 87000 || mutefreq > 108500) {
 		v4l2_err(v4l2_dev, "You must set a frequency (in kHz) used when muting the card,\n");
 		v4l2_err(v4l2_dev, "e.g. with \"mutefreq=87500\" (87000 <= mutefreq <= 108500)\n");
 		return -EINVAL;
 	}
+	dev->curfreq = dev->mutefreq = mutefreq << 4;
 
 	mutex_init(&dev->lock);
 	if (!request_region(dev->io, 8, "typhoon")) {
@@ -378,17 +378,17 @@ static int __init typhoon_init(void)
 	dev->vdev.ioctl_ops = &typhoon_ioctl_ops;
 	dev->vdev.release = video_device_release_empty;
 	video_set_drvdata(&dev->vdev, dev);
+
+	/* mute card - prevents noisy bootups */
+	typhoon_mute(dev);
+
 	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		v4l2_device_unregister(&dev->v4l2_dev);
 		release_region(dev->io, 8);
 		return -EINVAL;
 	}
 	v4l2_info(v4l2_dev, "port 0x%x.\n", dev->io);
-	v4l2_info(v4l2_dev, "mute frequency is %lu kHz.\n", dev->mutefreq);
-	dev->mutefreq <<= 4;
-
-	/* mute card - prevents noisy bootups */
-	typhoon_mute(dev);
+	v4l2_info(v4l2_dev, "mute frequency is %lu kHz.\n", mutefreq);
 
 	return 0;
 }
-- 
1.7.0.4

