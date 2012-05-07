Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab2EGTUi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:38 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 13/23] gspca: Fix locking issues related to suspend/resume.
Date: Mon,  7 May 2012 21:01:24 +0200
Message-Id: <1336417294-4566-14-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There are two bugs here: first the calls to stop0 (in gspca_suspend) and
gspca_init_transfer (in gspca_resume) need to be called with the usb_lock held.
That's true for the other places they are called and it is what subdrivers
expect. Quite a few will unlock the usb_lock in stop0 while waiting for a
worker thread to finish, and if usb_lock isn't held then that can cause a
kernel oops.

The other problem is that a worker thread needs to detect that it has to
halt due to a suspend. Otherwise it will just go on looping. So add tests
against gspca_dev->frozen in the worker threads that need it.

Hdg, 2 minor changes:
1) The finepix device is ok with stopping reading a frame halfway through,
   so add frozen checks in all places where we also check if we're still
   streaming
2) Use gspca_dev->dev instead of gspca_dev->present to check for disconnect
   in all touched drivers. I plan to do this everywhere in the future, and
   most relevant lines in the touched drivers are already modified by this
   patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/finepix.c   |    8 +++++---
 drivers/media/video/gspca/gspca.c     |   15 +++++++++++----
 drivers/media/video/gspca/jl2005bcd.c |    6 +++---
 drivers/media/video/gspca/sq905.c     |    8 ++++----
 drivers/media/video/gspca/sq905c.c    |    6 +++---
 drivers/media/video/gspca/vicam.c     |    4 ++--
 drivers/media/video/gspca/zc3xx.c     |    5 +++--
 7 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/gspca/finepix.c b/drivers/media/video/gspca/finepix.c
index 0107513..d0befe9 100644
--- a/drivers/media/video/gspca/finepix.c
+++ b/drivers/media/video/gspca/finepix.c
@@ -94,7 +94,7 @@ static void dostream(struct work_struct *work)
 
 	/* loop reading a frame */
 again:
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->dev && gspca_dev->streaming) {
 
 		/* request a frame */
 		mutex_lock(&gspca_dev->usb_lock);
@@ -102,7 +102,8 @@ again:
 		mutex_unlock(&gspca_dev->usb_lock);
 		if (ret < 0)
 			break;
-		if (!gspca_dev->present || !gspca_dev->streaming)
+		if (gspca_dev->frozen || !gspca_dev->dev ||
+					 !gspca_dev->streaming)
 			break;
 
 		/* the frame comes in parts */
@@ -117,7 +118,8 @@ again:
 				 * error. Just restart. */
 				goto again;
 			}
-			if (!gspca_dev->present || !gspca_dev->streaming)
+			if (gspca_dev->frozen || !gspca_dev->dev ||
+						 !gspca_dev->streaming)
 				goto out;
 			if (len < FPIX_MAX_TRANSFER ||
 				(data[len - 2] == 0xff &&
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 7577e99..2c61f58 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -2499,8 +2499,11 @@ int gspca_suspend(struct usb_interface *intf, pm_message_t message)
 	destroy_urbs(gspca_dev);
 	gspca_input_destroy_urb(gspca_dev);
 	gspca_set_alt0(gspca_dev);
-	if (gspca_dev->sd_desc->stop0)
+	if (gspca_dev->sd_desc->stop0) {
+		mutex_lock(&gspca_dev->usb_lock);
 		gspca_dev->sd_desc->stop0(gspca_dev);
+		mutex_unlock(&gspca_dev->usb_lock);
+	}
 	return 0;
 }
 EXPORT_SYMBOL(gspca_suspend);
@@ -2508,13 +2511,17 @@ EXPORT_SYMBOL(gspca_suspend);
 int gspca_resume(struct usb_interface *intf)
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
+	int ret = 0;
 
 	gspca_dev->frozen = 0;
 	gspca_dev->sd_desc->init(gspca_dev);
 	gspca_input_create_urb(gspca_dev);
-	if (gspca_dev->streaming)
-		return gspca_init_transfer(gspca_dev);
-	return 0;
+	if (gspca_dev->streaming) {
+		mutex_lock(&gspca_dev->queue_lock);
+		ret = gspca_init_transfer(gspca_dev);
+		mutex_unlock(&gspca_dev->queue_lock);
+	}
+	return ret;
 }
 EXPORT_SYMBOL(gspca_resume);
 #endif
diff --git a/drivers/media/video/gspca/jl2005bcd.c b/drivers/media/video/gspca/jl2005bcd.c
index 53f58ef..e1fc256 100644
--- a/drivers/media/video/gspca/jl2005bcd.c
+++ b/drivers/media/video/gspca/jl2005bcd.c
@@ -335,7 +335,7 @@ static void jl2005c_dostream(struct work_struct *work)
 		goto quit_stream;
 	}
 
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->dev && gspca_dev->streaming) {
 		/* Check if this is a new frame. If so, start the frame first */
 		if (!header_read) {
 			mutex_lock(&gspca_dev->usb_lock);
@@ -367,7 +367,7 @@ static void jl2005c_dostream(struct work_struct *work)
 					buffer, act_len);
 			header_read = 1;
 		}
-		while (bytes_left > 0 && gspca_dev->present) {
+		while (bytes_left > 0 && gspca_dev->dev) {
 			data_len = bytes_left > JL2005C_MAX_TRANSFER ?
 				JL2005C_MAX_TRANSFER : bytes_left;
 			ret = usb_bulk_msg(gspca_dev->dev,
@@ -390,7 +390,7 @@ static void jl2005c_dostream(struct work_struct *work)
 		}
 	}
 quit_stream:
-	if (gspca_dev->present) {
+	if (gspca_dev->dev) {
 		mutex_lock(&gspca_dev->usb_lock);
 		jl2005c_stop(gspca_dev);
 		mutex_unlock(&gspca_dev->usb_lock);
diff --git a/drivers/media/video/gspca/sq905.c b/drivers/media/video/gspca/sq905.c
index 2fe3c29..a144ce7 100644
--- a/drivers/media/video/gspca/sq905.c
+++ b/drivers/media/video/gspca/sq905.c
@@ -232,7 +232,7 @@ static void sq905_dostream(struct work_struct *work)
 	frame_sz = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].sizeimage
 			+ FRAME_HEADER_LEN;
 
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->dev && gspca_dev->streaming) {
 		/* request some data and then read it until we have
 		 * a complete frame. */
 		bytes_left = frame_sz;
@@ -242,7 +242,7 @@ static void sq905_dostream(struct work_struct *work)
 		   we must finish reading an entire frame, otherwise the
 		   next time we stream we start reading in the middle of a
 		   frame. */
-		while (bytes_left > 0 && gspca_dev->present) {
+		while (bytes_left > 0 && gspca_dev->dev) {
 			data_len = bytes_left > SQ905_MAX_TRANSFER ?
 				SQ905_MAX_TRANSFER : bytes_left;
 			ret = sq905_read_data(gspca_dev, buffer, data_len, 1);
@@ -274,7 +274,7 @@ static void sq905_dostream(struct work_struct *work)
 				gspca_frame_add(gspca_dev, LAST_PACKET,
 						NULL, 0);
 		}
-		if (gspca_dev->present) {
+		if (gspca_dev->dev) {
 			/* acknowledge the frame */
 			mutex_lock(&gspca_dev->usb_lock);
 			ret = sq905_ack_frame(gspca_dev);
@@ -284,7 +284,7 @@ static void sq905_dostream(struct work_struct *work)
 		}
 	}
 quit_stream:
-	if (gspca_dev->present) {
+	if (gspca_dev->dev) {
 		mutex_lock(&gspca_dev->usb_lock);
 		sq905_command(gspca_dev, SQ905_CLEAR);
 		mutex_unlock(&gspca_dev->usb_lock);
diff --git a/drivers/media/video/gspca/sq905c.c b/drivers/media/video/gspca/sq905c.c
index ae78363..720c187 100644
--- a/drivers/media/video/gspca/sq905c.c
+++ b/drivers/media/video/gspca/sq905c.c
@@ -150,7 +150,7 @@ static void sq905c_dostream(struct work_struct *work)
 		goto quit_stream;
 	}
 
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->dev && gspca_dev->streaming) {
 		/* Request the header, which tells the size to download */
 		ret = usb_bulk_msg(gspca_dev->dev,
 				usb_rcvbulkpipe(gspca_dev->dev, 0x81),
@@ -169,7 +169,7 @@ static void sq905c_dostream(struct work_struct *work)
 		packet_type = FIRST_PACKET;
 		gspca_frame_add(gspca_dev, packet_type,
 				buffer, FRAME_HEADER_LEN);
-		while (bytes_left > 0 && gspca_dev->present) {
+		while (bytes_left > 0 && gspca_dev->dev) {
 			data_len = bytes_left > SQ905C_MAX_TRANSFER ?
 				SQ905C_MAX_TRANSFER : bytes_left;
 			ret = usb_bulk_msg(gspca_dev->dev,
@@ -191,7 +191,7 @@ static void sq905c_dostream(struct work_struct *work)
 		}
 	}
 quit_stream:
-	if (gspca_dev->present) {
+	if (gspca_dev->dev) {
 		mutex_lock(&gspca_dev->usb_lock);
 		sq905c_command(gspca_dev, SQ905C_CLEAR, 0);
 		mutex_unlock(&gspca_dev->usb_lock);
diff --git a/drivers/media/video/gspca/vicam.c b/drivers/media/video/gspca/vicam.c
index e48ec4d..432d6cd 100644
--- a/drivers/media/video/gspca/vicam.c
+++ b/drivers/media/video/gspca/vicam.c
@@ -225,7 +225,7 @@ static void vicam_dostream(struct work_struct *work)
 		goto exit;
 	}
 
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->dev && gspca_dev->streaming) {
 		ret = vicam_read_frame(gspca_dev, buffer, frame_sz);
 		if (ret < 0)
 			break;
@@ -327,7 +327,7 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 	dev->work_thread = NULL;
 	mutex_lock(&gspca_dev->usb_lock);
 
-	if (gspca_dev->present)
+	if (gspca_dev->dev)
 		vicam_set_camera_power(gspca_dev, 0);
 }
 
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index a8282b8..998017e 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -6078,7 +6078,8 @@ static void transfer_update(struct work_struct *work)
 		msleep(100);
 
 		mutex_lock(&gspca_dev->usb_lock);
-		if (!gspca_dev->present || !gspca_dev->streaming)
+		if (gspca_dev->frozen || !gspca_dev->dev ||
+					 !gspca_dev->streaming)
 			goto err;
 
 		/* Bit 0 of register 11 indicates FIFO overflow */
@@ -6872,7 +6873,7 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 		mutex_lock(&gspca_dev->usb_lock);
 		sd->work_thread = NULL;
 	}
-	if (!gspca_dev->present)
+	if (!gspca_dev->dev)
 		return;
 	send_unknown(gspca_dev, sd->sensor);
 }
-- 
1.7.10

