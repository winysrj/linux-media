Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4283 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab0KPV4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:56:33 -0500
Message-Id: <5b543344708b09e84dbac1ea6db313a8edb90abe.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289944159.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:56:29 +0100
Subject: [RFCv2 PATCH 08/15] BKL: trivial ioctl -> unlocked_ioctl video driver conversions
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

These drivers could be trivially converted to unlocked_ioctl since they
already did locking.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/arv.c     |    2 +-
 drivers/media/video/bw-qcam.c |    2 +-
 drivers/media/video/c-qcam.c  |    2 +-
 drivers/media/video/meye.c    |   14 +++++++-------
 drivers/media/video/pms.c     |    2 +-
 drivers/media/video/w9966.c   |    2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/arv.c b/drivers/media/video/arv.c
index 31e7a12..f989f28 100644
--- a/drivers/media/video/arv.c
+++ b/drivers/media/video/arv.c
@@ -712,7 +712,7 @@ static int ar_initialize(struct ar *ar)
 static const struct v4l2_file_operations ar_fops = {
 	.owner		= THIS_MODULE,
 	.read		= ar_read,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops ar_ioctl_ops = {
diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index 935e0c9..c119350 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -860,7 +860,7 @@ static ssize_t qcam_read(struct file *file, char __user *buf,
 
 static const struct v4l2_file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl          = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.read		= qcam_read,
 };
 
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
index 6e4b196..24fc009 100644
--- a/drivers/media/video/c-qcam.c
+++ b/drivers/media/video/c-qcam.c
@@ -718,7 +718,7 @@ static ssize_t qcam_read(struct file *file, char __user *buf,
 
 static const struct v4l2_file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.read		= qcam_read,
 };
 
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index 2be23bc..48d2c24 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -1659,7 +1659,7 @@ static const struct v4l2_file_operations meye_fops = {
 	.open		= meye_open,
 	.release	= meye_release,
 	.mmap		= meye_mmap,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.poll		= meye_poll,
 };
 
@@ -1831,12 +1831,6 @@ static int __devinit meye_probe(struct pci_dev *pcidev,
 	msleep(1);
 	mchip_set(MCHIP_MM_INTA, MCHIP_MM_INTA_HIC_1_MASK);
 
-	if (video_register_device(meye.vdev, VFL_TYPE_GRABBER,
-				  video_nr) < 0) {
-		v4l2_err(v4l2_dev, "video_register_device failed\n");
-		goto outvideoreg;
-	}
-
 	mutex_init(&meye.lock);
 	init_waitqueue_head(&meye.proc_list);
 	meye.brightness = 32 << 10;
@@ -1858,6 +1852,12 @@ static int __devinit meye_probe(struct pci_dev *pcidev,
 	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAPICTURE, 0);
 	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAAGC, 48);
 
+	if (video_register_device(meye.vdev, VFL_TYPE_GRABBER,
+				  video_nr) < 0) {
+		v4l2_err(v4l2_dev, "video_register_device failed\n");
+		goto outvideoreg;
+	}
+
 	v4l2_info(v4l2_dev, "Motion Eye Camera Driver v%s.\n",
 	       MEYE_DRIVER_VERSION);
 	v4l2_info(v4l2_dev, "mchip KL5A72002 rev. %d, base %lx, irq %d\n",
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 7129b50..7551907 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -932,7 +932,7 @@ static ssize_t pms_read(struct file *file, char __user *buf,
 
 static const struct v4l2_file_operations pms_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.read           = pms_read,
 };
 
diff --git a/drivers/media/video/w9966.c b/drivers/media/video/w9966.c
index 635420d..019ee20 100644
--- a/drivers/media/video/w9966.c
+++ b/drivers/media/video/w9966.c
@@ -815,7 +815,7 @@ out:
 
 static const struct v4l2_file_operations w9966_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl          = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.read           = w9966_v4l_read,
 };
 
-- 
1.7.0.4

