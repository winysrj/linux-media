Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3779 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab2EFM2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/17] gspca: fix locking issues related to suspend/resume.
Date: Sun,  6 May 2012 14:28:22 +0200
Message-Id: <a4f3c638d6b9cc93f143ffecc3a8025562319faa.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
References: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
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

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/finepix.c   |    2 +-
 drivers/media/video/gspca/gspca.c     |   15 +++++++++++----
 drivers/media/video/gspca/jl2005bcd.c |    2 +-
 drivers/media/video/gspca/sq905.c     |    2 +-
 drivers/media/video/gspca/sq905c.c    |    2 +-
 drivers/media/video/gspca/vicam.c     |    2 +-
 6 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/gspca/finepix.c b/drivers/media/video/gspca/finepix.c
index 0107513..1d11976 100644
--- a/drivers/media/video/gspca/finepix.c
+++ b/drivers/media/video/gspca/finepix.c
@@ -102,7 +102,7 @@ again:
 		mutex_unlock(&gspca_dev->usb_lock);
 		if (ret < 0)
 			break;
-		if (!gspca_dev->present || !gspca_dev->streaming)
+		if (gspca_dev->frozen || !gspca_dev->present || !gspca_dev->streaming)
 			break;
 
 		/* the frame comes in parts */
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 730d8eb..f840bed 100644
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
@@ -2508,14 +2511,18 @@ EXPORT_SYMBOL(gspca_suspend);
 int gspca_resume(struct usb_interface *intf)
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
+	int ret = 0;
 
 	gspca_dev->frozen = 0;
 	gspca_dev->sd_desc->init(gspca_dev);
 	gspca_set_default_mode(gspca_dev);
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
index 53f58ef..f5b88e9 100644
--- a/drivers/media/video/gspca/jl2005bcd.c
+++ b/drivers/media/video/gspca/jl2005bcd.c
@@ -335,7 +335,7 @@ static void jl2005c_dostream(struct work_struct *work)
 		goto quit_stream;
 	}
 
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->present && gspca_dev->streaming) {
 		/* Check if this is a new frame. If so, start the frame first */
 		if (!header_read) {
 			mutex_lock(&gspca_dev->usb_lock);
diff --git a/drivers/media/video/gspca/sq905.c b/drivers/media/video/gspca/sq905.c
index 2fe3c29..7b72a20 100644
--- a/drivers/media/video/gspca/sq905.c
+++ b/drivers/media/video/gspca/sq905.c
@@ -232,7 +232,7 @@ static void sq905_dostream(struct work_struct *work)
 	frame_sz = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].sizeimage
 			+ FRAME_HEADER_LEN;
 
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->present && gspca_dev->streaming) {
 		/* request some data and then read it until we have
 		 * a complete frame. */
 		bytes_left = frame_sz;
diff --git a/drivers/media/video/gspca/sq905c.c b/drivers/media/video/gspca/sq905c.c
index ae78363..52e42ca 100644
--- a/drivers/media/video/gspca/sq905c.c
+++ b/drivers/media/video/gspca/sq905c.c
@@ -150,7 +150,7 @@ static void sq905c_dostream(struct work_struct *work)
 		goto quit_stream;
 	}
 
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->present && gspca_dev->streaming) {
 		/* Request the header, which tells the size to download */
 		ret = usb_bulk_msg(gspca_dev->dev,
 				usb_rcvbulkpipe(gspca_dev->dev, 0x81),
diff --git a/drivers/media/video/gspca/vicam.c b/drivers/media/video/gspca/vicam.c
index e48ec4d..0d532ec 100644
--- a/drivers/media/video/gspca/vicam.c
+++ b/drivers/media/video/gspca/vicam.c
@@ -225,7 +225,7 @@ static void vicam_dostream(struct work_struct *work)
 		goto exit;
 	}
 
-	while (gspca_dev->present && gspca_dev->streaming) {
+	while (!gspca_dev->frozen && gspca_dev->present && gspca_dev->streaming) {
 		ret = vicam_read_frame(gspca_dev, buffer, frame_sz);
 		if (ret < 0)
 			break;
-- 
1.7.10

