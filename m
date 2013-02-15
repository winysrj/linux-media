Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1448 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab3BOJTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 04:19:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/9] s2255: add device_caps support to querycap.
Date: Fri, 15 Feb 2013 10:18:49 +0100
Message-Id: <08023b889999bcdc7f60bac7c4b4c0c3303ae40c.1360919695.git.hans.verkuil@cisco.com>
In-Reply-To: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
References: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <fa483ff8ca5aae815cd227f47fe797c1c5a8a73d.1360919695.git.hans.verkuil@cisco.com>
References: <fa483ff8ca5aae815cd227f47fe797c1c5a8a73d.1360919695.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 55c972a..9cb8325 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -821,10 +821,12 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct s2255_fh *fh = file->private_data;
 	struct s2255_dev *dev = fh->dev;
+
 	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
 	strlcpy(cap->card, "s2255", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10.4

