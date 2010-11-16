Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1897 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab0KPV4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:56:47 -0500
Message-Id: <731d59e84965d0357a4124a98b137f4df5fac031.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289944159.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:56:43 +0100
Subject: [RFCv2 PATCH 13/15] radio-timb: convert to unlocked_ioctl.
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-timb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index b8bb3ef..a185610 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -34,6 +34,7 @@ struct timbradio {
 	struct v4l2_subdev	*sd_dsp;
 	struct video_device	video_dev;
 	struct v4l2_device	v4l2_dev;
+	struct mutex		lock;
 };
 
 
@@ -142,7 +143,7 @@ static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
 
 static const struct v4l2_file_operations timbradio_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static int __devinit timbradio_probe(struct platform_device *pdev)
@@ -164,6 +165,7 @@ static int __devinit timbradio_probe(struct platform_device *pdev)
 	}
 
 	tr->pdata = *pdata;
+	mutex_init(&tr->lock);
 
 	strlcpy(tr->video_dev.name, "Timberdale Radio",
 		sizeof(tr->video_dev.name));
@@ -171,6 +173,7 @@ static int __devinit timbradio_probe(struct platform_device *pdev)
 	tr->video_dev.ioctl_ops = &timbradio_ioctl_ops;
 	tr->video_dev.release = video_device_release_empty;
 	tr->video_dev.minor = -1;
+	tr->video_dev.lock = &tr->lock;
 
 	strlcpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
 	err = v4l2_device_register(NULL, &tr->v4l2_dev);
-- 
1.7.0.4

