Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1311 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3BJRxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 12/12] stk-webcam: implement support for count == 0 when calling REQBUFS.
Date: Sun, 10 Feb 2013 18:52:53 +0100
Message-Id: <b3ffc78282cdb3930ee22f8bc39c58f3b0b5ba90.1360518391.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
References: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The spec specifies that setting count to 0 in v4l2_requestbuffers
should result in releasing any streaming resources and the stream
ownership. Implement this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 0b25448..5aeef83 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1008,6 +1008,13 @@ static int stk_vidioc_reqbufs(struct file *filp,
 	if (is_streaming(dev)
 		|| (dev->owner && dev->owner != filp))
 		return -EBUSY;
+	stk_free_buffers(dev);
+	if (rb->count == 0) {
+		stk_camera_write_reg(dev, 0x0, 0x49); /* turn off the LED */
+		unset_initialised(dev);
+		dev->owner = NULL;
+		return 0;
+	}
 	dev->owner = filp;
 
 	/*FIXME If they ask for zero, we must stop streaming and free */
-- 
1.7.10.4

