Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33503 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3H3CRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:36 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so1696083pad.0
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:36 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 05/19] uvcvideo: Add support for UVC1.5 P&C control.
Date: Fri, 30 Aug 2013 11:17:04 +0900
Message-Id: <1377829038-4726-6-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for UVC 1.5 Probe & Commit control.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_video.c | 52 ++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/usb/video.h    |  7 ++++++
 2 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 1198989..b4ebccd 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -168,14 +168,25 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 	}
 }
 
+int uvc_get_probe_ctrl_size(struct uvc_streaming *stream)
+{
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
 	__u8 *data;
 	__u16 size;
 	int ret;
+	int i;
 
-	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
+	size = uvc_get_probe_ctrl_size(stream);
 	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
 			query == UVC_GET_DEF)
 		return -EIO;
@@ -230,7 +241,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 	ctrl->dwMaxVideoFrameSize = get_unaligned_le32(&data[18]);
 	ctrl->dwMaxPayloadTransferSize = get_unaligned_le32(&data[22]);
 
-	if (size == 34) {
+	if (size >= 34) {
 		ctrl->dwClockFrequency = get_unaligned_le32(&data[26]);
 		ctrl->bmFramingInfo = data[30];
 		ctrl->bPreferedVersion = data[31];
@@ -244,6 +255,26 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		ctrl->bMaxVersion = 0;
 	}
 
+	if (size >= 48) {
+		ctrl->bUsage = data[34];
+		ctrl->bBitDepthLuma = data[35];
+		ctrl->bmSetting = data[36];
+		ctrl->bMaxNumberOfRefFramesPlus1 = data[37];
+		ctrl->bmRateControlModes = get_unaligned_le16(&data[38]);
+		for (i = 0; i < ARRAY_SIZE(ctrl->bmLayoutPerStream); ++i) {
+			ctrl->bmLayoutPerStream[i] =
+				get_unaligned_le16(&data[40 + i * 2]);
+		}
+	} else {
+		ctrl->bUsage = 0;
+		ctrl->bBitDepthLuma = 0;
+		ctrl->bmSetting = 0;
+		ctrl->bMaxNumberOfRefFramesPlus1 = 0;
+		ctrl->bmRateControlModes = 0;
+		for (i = 0; i < ARRAY_SIZE(ctrl->bmLayoutPerStream); ++i)
+			ctrl->bmLayoutPerStream[i] = 0;
+	}
+
 	/* Some broken devices return null or wrong dwMaxVideoFrameSize and
 	 * dwMaxPayloadTransferSize fields. Try to get the value from the
 	 * format and frame descriptors.
@@ -262,8 +293,9 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 	__u8 *data;
 	__u16 size;
 	int ret;
+	int i;
 
-	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
+	size = uvc_get_probe_ctrl_size(stream);
 	data = kzalloc(size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
@@ -280,7 +312,7 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 	put_unaligned_le32(ctrl->dwMaxVideoFrameSize, &data[18]);
 	put_unaligned_le32(ctrl->dwMaxPayloadTransferSize, &data[22]);
 
-	if (size == 34) {
+	if (size >= 34) {
 		put_unaligned_le32(ctrl->dwClockFrequency, &data[26]);
 		data[30] = ctrl->bmFramingInfo;
 		data[31] = ctrl->bPreferedVersion;
@@ -288,6 +320,18 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 		data[33] = ctrl->bMaxVersion;
 	}
 
+	if (size >= 48) {
+		data[34] = ctrl->bUsage;
+		data[35] = ctrl->bBitDepthLuma;
+		data[36] = ctrl->bmSetting;
+		data[37] = ctrl->bMaxNumberOfRefFramesPlus1;
+		*(__le16 *)&data[38] = cpu_to_le16(ctrl->bmRateControlModes);
+		for (i = 0; i < ARRAY_SIZE(ctrl->bmLayoutPerStream); ++i) {
+			*(__le16 *)&data[40 + i * 2] =
+				cpu_to_le16(ctrl->bmLayoutPerStream[i]);
+		}
+	}
+
 	ret = __uvc_query_ctrl(stream->dev, UVC_SET_CUR, 0, stream->intfnum,
 		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
 		size, uvc_timeout_param);
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index 3b3b95e..331c071 100644
--- a/include/uapi/linux/usb/video.h
+++ b/include/uapi/linux/usb/video.h
@@ -432,6 +432,7 @@ struct uvc_color_matching_descriptor {
 #define UVC_DT_COLOR_MATCHING_SIZE			6
 
 /* 4.3.1.1. Video Probe and Commit Controls */
+#define UVC_NUM_SIMULCAST_STREAMS			4
 struct uvc_streaming_control {
 	__u16 bmHint;
 	__u8  bFormatIndex;
@@ -449,6 +450,12 @@ struct uvc_streaming_control {
 	__u8  bPreferedVersion;
 	__u8  bMinVersion;
 	__u8  bMaxVersion;
+	__u8  bUsage;
+	__u8  bBitDepthLuma;
+	__u8  bmSetting;
+	__u8  bMaxNumberOfRefFramesPlus1;
+	__u16 bmRateControlModes;
+	__u16 bmLayoutPerStream[UVC_NUM_SIMULCAST_STREAMS];
 } __attribute__((__packed__));
 
 /* Uncompressed Payload - 3.1.1. Uncompressed Video Format Descriptor */
-- 
1.8.4

