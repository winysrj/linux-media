Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3794 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3BJRxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/12] stk-webcam: fix read() handling when reqbufs was already called.
Date: Sun, 10 Feb 2013 18:52:51 +0100
Message-Id: <086a8470ea44918e838d08aa54bc51bde3fb6564.1360518391.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
References: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |    3 ++-
 drivers/media/usb/stkwebcam/stk-webcam.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index f3fabda..e3442de 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -616,7 +616,7 @@ static ssize_t stk_read(struct file *fp, char __user *buf,
 
 	if (!is_present(dev))
 		return -EIO;
-	if (dev->owner && dev->owner != fp)
+	if (dev->owner && (!dev->reading || dev->owner != fp))
 		return -EBUSY;
 	dev->owner = fp;
 	if (!is_streaming(dev)) {
@@ -624,6 +624,7 @@ static ssize_t stk_read(struct file *fp, char __user *buf,
 			|| stk_allocate_buffers(dev, 3)
 			|| stk_start_stream(dev))
 			return -ENOMEM;
+		dev->reading = 1;
 		spin_lock_irqsave(&dev->spinlock, flags);
 		for (i = 0; i < dev->n_sbufs; i++) {
 			list_add_tail(&dev->sio_bufs[i].list, &dev->sio_avail);
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.h b/drivers/media/usb/stkwebcam/stk-webcam.h
index 03550cf..9bbfa3d 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.h
+++ b/drivers/media/usb/stkwebcam/stk-webcam.h
@@ -118,6 +118,7 @@ struct stk_camera {
 
 	int frame_size;
 	/* Streaming buffers */
+	int reading;
 	unsigned int n_sbufs;
 	struct stk_sio_buffer *sio_bufs;
 	struct list_head sio_avail;
-- 
1.7.10.4

