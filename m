Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42738 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488AbbGTNBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:01:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/12] usbvision: set field and colorspace.
Date: Mon, 20 Jul 2015 14:59:34 +0200
Message-Id: <1437397178-5013-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set the colorspace and field in vidioc_try_fmt_vid_cap().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index dc0e034..4f425f3 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -880,6 +880,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	vf->fmt.pix.bytesperline = vf->fmt.pix.width*
 		usbvision->palette.bytes_per_pixel;
 	vf->fmt.pix.sizeimage = vf->fmt.pix.bytesperline*vf->fmt.pix.height;
+	vf->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	vf->fmt.pix.field = V4L2_FIELD_NONE; /* Always progressive image */
 
 	return 0;
 }
-- 
2.1.4

