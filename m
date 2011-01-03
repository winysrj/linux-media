Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4917 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1ACSbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 13:31:31 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03IVMuX006180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 19:31:30 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 06/10] radio_ms800: use video_drvdata instead of filp->private_data
Date: Mon,  3 Jan 2011 19:31:11 +0100
Message-Id: <7e1e3d8066d44fb6b9e1caba57378a2efbe891c1.1294078230.git.hverkuil@xs4all.nl>
In-Reply-To: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
References: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
References: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

filp->private_data will be used to store v4l2_fh instead.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-mr800.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index b540e80..492cfca 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -297,7 +297,7 @@ static void usb_amradio_disconnect(struct usb_interface *intf)
 static int vidioc_querycap(struct file *file, void *priv,
 					struct v4l2_capability *v)
 {
-	struct amradio_device *radio = file->private_data;
+	struct amradio_device *radio = video_drvdata(file);
 
 	strlcpy(v->driver, "radio-mr800", sizeof(v->driver));
 	strlcpy(v->card, "AverMedia MR 800 USB FM Radio", sizeof(v->card));
@@ -311,7 +311,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	struct amradio_device *radio = file->private_data;
+	struct amradio_device *radio = video_drvdata(file);
 	int retval;
 
 	if (v->index > 0)
@@ -347,7 +347,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	struct amradio_device *radio = file->private_data;
+	struct amradio_device *radio = video_drvdata(file);
 	int retval = -EINVAL;
 
 	if (v->index > 0)
@@ -370,7 +370,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct amradio_device *radio = file->private_data;
+	struct amradio_device *radio = video_drvdata(file);
 
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
@@ -381,7 +381,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct amradio_device *radio = file->private_data;
+	struct amradio_device *radio = video_drvdata(file);
 
 	if (f->tuner != 0)
 		return -EINVAL;
@@ -407,7 +407,7 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct amradio_device *radio = file->private_data;
+	struct amradio_device *radio = video_drvdata(file);
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
@@ -422,7 +422,7 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct amradio_device *radio = file->private_data;
+	struct amradio_device *radio = video_drvdata(file);
 	int retval = -EINVAL;
 
 	switch (ctrl->id) {
@@ -501,7 +501,6 @@ static int usb_amradio_open(struct file *file)
 	struct amradio_device *radio = video_drvdata(file);
 	int retval;
 
-	file->private_data = radio;
 	retval = usb_autopm_get_interface(radio->intf);
 	if (retval)
 		return retval;
@@ -517,7 +516,7 @@ static int usb_amradio_open(struct file *file)
 /*close device */
 static int usb_amradio_close(struct file *file)
 {
-	struct amradio_device *radio = file->private_data;
+	struct amradio_device *radio = video_drvdata(file);
 
 	if (video_is_registered(&radio->videodev))
 		usb_autopm_put_interface(radio->intf);
-- 
1.7.0.4

