Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48285 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbbK3U1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/11] ivtv/cx18: fix inverted pixel aspect ratio
Date: Mon, 30 Nov 2015 21:27:13 +0100
Message-Id: <1448915241-415-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These two drivers reported the pixel aspect ratio the wrong way around.
This caused qv4l2 to scale the image incorrectly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx18/cx18-ioctl.c | 4 ++--
 drivers/media/pci/ivtv/ivtv-ioctl.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 55525af..eeb741c 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -453,8 +453,8 @@ static int cx18_cropcap(struct file *file, void *fh,
 
 	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	cropcap->pixelaspect.numerator = cx->is_50hz ? 59 : 10;
-	cropcap->pixelaspect.denominator = cx->is_50hz ? 54 : 11;
+	cropcap->pixelaspect.numerator = cx->is_50hz ? 54 : 11;
+	cropcap->pixelaspect.denominator = cx->is_50hz ? 59 : 10;
 	return 0;
 }
 
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 2c54cb8..2dc4b20 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -831,11 +831,11 @@ static int ivtv_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropca
 	struct ivtv *itv = id->itv;
 
 	if (cropcap->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		cropcap->pixelaspect.numerator = itv->is_50hz ? 59 : 10;
-		cropcap->pixelaspect.denominator = itv->is_50hz ? 54 : 11;
+		cropcap->pixelaspect.numerator = itv->is_50hz ? 54 : 11;
+		cropcap->pixelaspect.denominator = itv->is_50hz ? 59 : 10;
 	} else if (cropcap->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		cropcap->pixelaspect.numerator = itv->is_out_50hz ? 59 : 10;
-		cropcap->pixelaspect.denominator = itv->is_out_50hz ? 54 : 11;
+		cropcap->pixelaspect.numerator = itv->is_out_50hz ? 54 : 11;
+		cropcap->pixelaspect.denominator = itv->is_out_50hz ? 59 : 10;
 	} else {
 		return -EINVAL;
 	}
-- 
2.6.2

