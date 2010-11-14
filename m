Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3821 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab0KNN4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:56:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Richard =?iso-8859-1?q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
Subject: radio-timb: proposed patch to convert to unlocked_ioctl
Date: Sun, 14 Nov 2010 14:56:44 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011141456.44810.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Richard,

Can you check if this patch is OK? It's against the v2.6.38 media_tree branch.

It converts .ioctl to unlocked_ioctl by using the new v4l2 core locking. Before
it relied on the BKL to do the locking, but that is being phased out.

Regards,

	Hans

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
Hans Verkuil - video4linux developer - sponsored by Cisco
