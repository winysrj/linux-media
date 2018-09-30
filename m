Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51132 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbeI3RKo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Sep 2018 13:10:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, eric.bachard@free.fr
Subject: [PATCH] media: uvcvideo: Support UVC 1.5 video probe & commit controls
Date: Sun, 30 Sep 2018 13:38:16 +0300
Message-Id: <20180930103816.5115-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: ming_qian <ming_qian@realsil.com.cn>

commit f620d1d7afc7db57ab59f35000752840c91f67e7 upstream.

The length of UVC 1.5 video control is 48, and it is 34 for UVC 1.1.
Change it to 48 for UVC 1.5 device, and the UVC 1.5 device can be
recognized.

More changes to the driver are needed for full UVC 1.5 compatibility.
However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have been
reported to work well.

[laurent.pinchart@ideasonboard.com: Factor out code to helper function, update size checks]

Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Ana Guerrero Lopez <ana.guerrero@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

Hello,

This patch was originally marked as a stable candidate, but a driver-wide
switch from __u{8,16,32} to u{8,16,32} created conflicts that prevented
backporting. This version fixes the conflicts and is otherwise not modified.

The decision to mark the patch as a stable candidate came after reports from
distro users that their UVC 1.5 camera was otherwise unusable. A guide has
even been published to tell Debian users how to patch their kernel to fix the
problem. Including the fix in stable will make their life much easier.

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index fb86d6af398d..a6d800291883 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -163,14 +163,27 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 	}
 }
 
+static size_t uvc_video_ctrl_size(struct uvc_streaming *stream)
+{
+	/*
+	 * Return the size of the video probe and commit controls, which depends
+	 * on the protocol version.
+	 */
+	if (stream->dev->uvc_version < 0x0110)
+		return 26;
+	else if (stream->dev->uvc_version < 0x0150)
+		return 34;
+	else
+		return 48;
+}
+
 static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl, int probe, __u8 query)
 {
+	__u16 size = uvc_video_ctrl_size(stream);
 	__u8 *data;
-	__u16 size;
 	int ret;
 
-	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
 	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
 			query == UVC_GET_DEF)
 		return -EIO;
@@ -225,7 +238,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 	ctrl->dwMaxVideoFrameSize = get_unaligned_le32(&data[18]);
 	ctrl->dwMaxPayloadTransferSize = get_unaligned_le32(&data[22]);
 
-	if (size == 34) {
+	if (size >= 34) {
 		ctrl->dwClockFrequency = get_unaligned_le32(&data[26]);
 		ctrl->bmFramingInfo = data[30];
 		ctrl->bPreferedVersion = data[31];
@@ -254,11 +267,10 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl, int probe)
 {
+	__u16 size = uvc_video_ctrl_size(stream);
 	__u8 *data;
-	__u16 size;
 	int ret;
 
-	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
 	data = kzalloc(size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
@@ -275,7 +287,7 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 	put_unaligned_le32(ctrl->dwMaxVideoFrameSize, &data[18]);
 	put_unaligned_le32(ctrl->dwMaxPayloadTransferSize, &data[22]);
 
-	if (size == 34) {
+	if (size >= 34) {
 		put_unaligned_le32(ctrl->dwClockFrequency, &data[26]);
 		data[30] = ctrl->bmFramingInfo;
 		data[31] = ctrl->bPreferedVersion;
-- 
Regards,

Laurent Pinchart
