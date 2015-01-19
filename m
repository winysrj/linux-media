Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46681 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbbASJeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 04:34:09 -0500
Message-ID: <54BCCF7B.9040305@xs4all.nl>
Date: Mon, 19 Jan 2015 10:33:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	isely@isely.net
Subject: [PATCH for v3.19] pvrusb2: fix missing device_caps in querycap
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDIOC_QUERYCAP function should set device_caps, but this was missing.
In addition, it set the version field as well, but that should be done by
the core, not by the driver.

If a driver doesn't set device_caps the v4l2 core will issue a WARN_ON, so
it's important that this is set correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 422d79e..35e4ea5 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -89,16 +89,6 @@ static int vbi_nr[PVR_NUM] = {[0 ... PVR_NUM-1] = -1};
 module_param_array(vbi_nr, int, NULL, 0444);
 MODULE_PARM_DESC(vbi_nr, "Offset for device's vbi dev minor");
 
-static struct v4l2_capability pvr_capability ={
-	.driver         = "pvrusb2",
-	.card           = "Hauppauge WinTV pvr-usb2",
-	.bus_info       = "usb",
-	.version        = LINUX_VERSION_CODE,
-	.capabilities   = (V4L2_CAP_VIDEO_CAPTURE |
-			   V4L2_CAP_TUNER | V4L2_CAP_AUDIO | V4L2_CAP_RADIO |
-			   V4L2_CAP_READWRITE),
-};
-
 static struct v4l2_fmtdesc pvr_fmtdesc [] = {
 	{
 		.index          = 0,
@@ -160,10 +150,22 @@ static int pvr2_querycap(struct file *file, void *priv, struct v4l2_capability *
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
 
-	memcpy(cap, &pvr_capability, sizeof(struct v4l2_capability));
+	strlcpy(cap->driver, "pvrusb2", sizeof(cap->driver));
 	strlcpy(cap->bus_info, pvr2_hdw_get_bus_info(hdw),
 			sizeof(cap->bus_info));
 	strlcpy(cap->card, pvr2_hdw_get_desc(hdw), sizeof(cap->card));
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
+			    V4L2_CAP_AUDIO | V4L2_CAP_RADIO |
+			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
+	switch (fh->pdi->devbase.vfl_type) {
+	case VFL_TYPE_GRABBER:
+		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_AUDIO;
+		break;
+	case VFL_TYPE_RADIO:
+		cap->device_caps = V4L2_CAP_RADIO;
+		break;
+	}
+	cap->device_caps |= V4L2_CAP_TUNER | V4L2_CAP_READWRITE;
 	return 0;
 }
 
-- 
2.1.4

