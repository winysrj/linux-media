Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2788 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3BIKBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 11/26] cx231xx: remove current_norm usage.
Date: Sat,  9 Feb 2013 11:00:41 +0100
Message-Id: <67bb173daa262cee7f732d91ecafa481893f3be7.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The use of this field is deprecated since it will not work when multiple
device nodes reference the same video input (the video and vbi nodes in
this case). The norm field should be a device-global value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   |    1 -
 drivers/media/usb/cx231xx/cx231xx-video.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 28688db..a4091dd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -2115,7 +2115,6 @@ static struct video_device cx231xx_mpeg_template = {
 	.ioctl_ops     = &mpeg_ioctl_ops,
 	.minor         = -1,
 	.tvnorms       = CX231xx_NORMS,
-	.current_norm  = V4L2_STD_NTSC_M,
 };
 
 void cx231xx_417_unregister(struct cx231xx *dev)
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 48a0269..617dc32 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2229,7 +2229,6 @@ static const struct video_device cx231xx_video_template = {
 	.release      = video_device_release,
 	.ioctl_ops    = &video_ioctl_ops,
 	.tvnorms      = V4L2_STD_ALL,
-	.current_norm = V4L2_STD_PAL,
 };
 
 static const struct v4l2_file_operations radio_fops = {
@@ -2300,7 +2299,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 		     dev->name, CX231XX_VERSION);
 
 	/* set default norm */
-	/*dev->norm = cx231xx_video_template.current_norm; */
+	dev->norm = V4L2_STD_PAL;
 	dev->width = norm_maxw(dev);
 	dev->height = norm_maxh(dev);
 	dev->interlaced = 0;
-- 
1.7.10.4

