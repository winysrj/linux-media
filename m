Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway08.websitewelcome.com ([69.56.159.17]:48954 "HELO
	gateway08.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756143Ab0CaOkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 10:40:25 -0400
Received: from [66.15.212.169] (port=23900 helo=user-desktop.local)
	by gator886.hostgator.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <dean@sensoray.com>)
	id 1NwyzL-0000FP-8t
	for linux-media@vger.kernel.org; Wed, 31 Mar 2010 09:33:47 -0500
Date: Wed, 31 Mar 2010 07:33:43 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: video_device_alloc call not checked fix
To: linux-media@vger.kernel.org
Message-ID: <tkrat.bc9b9151df9c7a44@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1270045856 25200
# Node ID 2ab296deae938864b06b29cc224eb4b670ae3aa9
# Parent  18586e4ac3ed5972dac2015600f8c21e26c0fc16
s2255drv: video_device allocation fix

From: Dean Anderson <dean@sensoray.com>

call to video_device_alloc was not being checked in probe function.
code simplified and uses video_device inside device structure.

Priority: high

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r 18586e4ac3ed -r 2ab296deae93 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Mon Mar 29 15:11:18 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Wed Mar 31 07:30:56 2010 -0700
@@ -224,6 +224,7 @@
 struct s2255_fmt; /*forward declaration */
 
 struct s2255_dev {
+	struct video_device	vdev[MAX_CHANNELS];
 	int			frames;
 	struct mutex		lock;
 	struct mutex		open_lock;
@@ -233,7 +234,6 @@
 	u8			read_endpoint;
 
 	struct s2255_dmaqueue	vidq[MAX_CHANNELS];
-	struct video_device	*vdev[MAX_CHANNELS];
 	struct timer_list	timer;
 	struct s2255_fw	*fw_data;
 	struct s2255_pipeinfo	pipe;
@@ -719,10 +719,10 @@
 	if (fh->fmt == NULL)
 		return -EINVAL;
 
-	if ((fh->width < norm_minw(fh->dev->vdev[fh->channel])) ||
-	    (fh->width > norm_maxw(fh->dev->vdev[fh->channel])) ||
-	    (fh->height < norm_minh(fh->dev->vdev[fh->channel])) ||
-	    (fh->height > norm_maxh(fh->dev->vdev[fh->channel]))) {
+	if ((fh->width < norm_minw(&fh->dev->vdev[fh->channel])) ||
+	    (fh->width > norm_maxw(&fh->dev->vdev[fh->channel])) ||
+	    (fh->height < norm_minh(&fh->dev->vdev[fh->channel])) ||
+	    (fh->height > norm_maxh(&fh->dev->vdev[fh->channel]))) {
 		dprintk(4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
@@ -896,7 +896,7 @@
 	int is_ntsc;
 
 	is_ntsc =
-	    (dev->vdev[fh->channel]->current_norm & V4L2_STD_NTSC) ? 1 : 0;
+	    (dev->vdev[fh->channel].current_norm & V4L2_STD_NTSC) ? 1 : 0;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 
@@ -1029,9 +1029,9 @@
 	fh->height = f->fmt.pix.height;
 	fh->vb_vidq.field = f->fmt.pix.field;
 	fh->type = f->type;
-	norm = norm_minw(fh->dev->vdev[fh->channel]);
-	if (fh->width > norm_minw(fh->dev->vdev[fh->channel])) {
-		if (fh->height > norm_minh(fh->dev->vdev[fh->channel])) {
+	norm = norm_minw(&fh->dev->vdev[fh->channel]);
+	if (fh->width > norm_minw(&fh->dev->vdev[fh->channel])) {
+		if (fh->height > norm_minh(&fh->dev->vdev[fh->channel])) {
 			if (fh->dev->cap_parm[fh->channel].capturemode &
 			    V4L2_MODE_HIGHQUALITY) {
 				fh->mode.scale = SCALE_4CIFSI;
@@ -1755,7 +1755,7 @@
 		video_device_node_name(vdev));
 	lock_kernel();
 	for (i = 0; i < MAX_CHANNELS; i++)
-		if (dev->vdev[i] == vdev) {
+		if (&dev->vdev[i] == vdev) {
 			cur_channel = i;
 			break;
 		}
@@ -1985,7 +1985,6 @@
 static void s2255_video_device_release(struct video_device *vdev)
 {
 	struct s2255_dev *dev = video_get_drvdata(vdev);
-	video_device_release(vdev);
 	kref_put(&dev->kref, s2255_destroy);
 	return;
 }
@@ -2012,19 +2011,18 @@
 		dev->vidq[i].dev = dev;
 		dev->vidq[i].channel = i;
 		/* register 4 video devices */
-		dev->vdev[i] = video_device_alloc();
-		memcpy(dev->vdev[i], &template, sizeof(struct video_device));
-		dev->vdev[i]->parent = &dev->interface->dev;
-		video_set_drvdata(dev->vdev[i], dev);
+		memcpy(&dev->vdev[i], &template, sizeof(struct video_device));
+		dev->vdev[i].parent = &dev->interface->dev;
+		video_set_drvdata(&dev->vdev[i], dev);
 		if (video_nr == -1)
-			ret = video_register_device(dev->vdev[i],
+			ret = video_register_device(&dev->vdev[i],
 						    VFL_TYPE_GRABBER,
 						    video_nr);
 		else
-			ret = video_register_device(dev->vdev[i],
+			ret = video_register_device(&dev->vdev[i],
 						    VFL_TYPE_GRABBER,
 						    cur_nr + i);
-		video_set_drvdata(dev->vdev[i], dev);
+		video_set_drvdata(&dev->vdev[i], dev);
 
 		if (ret != 0) {
 			dev_err(&dev->udev->dev,
@@ -2721,8 +2719,8 @@
 	return 0;
 errorV4L:
 	for (i = 0; i < MAX_CHANNELS; i++)
-		if (dev->vdev[i] && video_is_registered(dev->vdev[i]))
-			video_unregister_device(dev->vdev[i]);
+		if (video_is_registered(&dev->vdev[i]))
+			video_unregister_device(&dev->vdev[i]);
 errorBOARDINIT:
 	s2255_board_shutdown(dev);
 errorFWMARKER:
@@ -2755,8 +2753,8 @@
 	dev = usb_get_intfdata(interface);
 	/* unregister each video device. */
 	for (i = 0; i < MAX_CHANNELS; i++)
-		if (video_is_registered(dev->vdev[i]))
-			video_unregister_device(dev->vdev[i]);
+		if (video_is_registered(&dev->vdev[i]))
+			video_unregister_device(&dev->vdev[i]);
 	/* wake up any of our timers */
 	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
 	wake_up(&dev->fw_data->wait_fw);

