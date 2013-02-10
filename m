Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1433 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3BJRxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 11/12] stk-webcam: s_fmt shouldn't grab ownership.
Date: Sun, 10 Feb 2013 18:52:52 +0100
Message-Id: <85dea2ed7659cdd1aa6b918d4228b5480640cff4.1360518391.git.hans.verkuil@cisco.com>
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
 drivers/media/usb/stkwebcam/stk-webcam.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index e3442de..0b25448 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -981,12 +981,11 @@ static int stk_vidioc_s_fmt_vid_cap(struct file *filp,
 		return -ENODEV;
 	if (is_streaming(dev))
 		return -EBUSY;
-	if (dev->owner && dev->owner != filp)
+	if (dev->owner)
 		return -EBUSY;
 	ret = stk_try_fmt_vid_cap(filp, fmtd, &idx);
 	if (ret)
 		return ret;
-	dev->owner = filp;
 
 	dev->vsettings.palette = fmtd->fmt.pix.pixelformat;
 	stk_free_buffers(dev);
-- 
1.7.10.4

