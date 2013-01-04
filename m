Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:62407 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3ADVAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:02 -0500
Received: by mail-vc0-f179.google.com with SMTP id p1so16676881vcq.24
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:00:01 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/15] em28xx: fill in readbuffers and fix incorrect return code.
Date: Fri,  4 Jan 2013 15:59:39 -0500
Message-Id: <1357333186-8466-10-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

g/s_parm should fill in readbuffers.
For non-webcams s_parm should return -ENOTTY instead of -EINVAL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index acdb434..a91a248 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -972,6 +972,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
 	if (dev->board.is_webcam)
 		rc = v4l2_device_call_until_err(&dev->v4l2_dev, 0,
 						video, g_parm, p);
@@ -989,11 +990,12 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	struct em28xx      *dev = fh->dev;
 
 	if (!dev->board.is_webcam)
-		return -EINVAL;
+		return -ENOTTY;
 
 	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
 	return v4l2_device_call_until_err(&dev->v4l2_dev, 0, video, s_parm, p);
 }
 
-- 
1.7.9.5

