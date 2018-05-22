Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35282 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeEVUcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 16:32:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: ming_qian@realsil.com.cn
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Ana Guerrero Lopez <ana.guerrero@collabora.com>
Subject: Re: [PATCH] media: uvcvideo: Support realtek's UVC 1.5 device
Date: Tue, 22 May 2018 23:32:19 +0300
Message-ID: <2510852.fx2XduE8hM@avalon>
In-Reply-To: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
References: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Thank you for the patch.

On Wednesday, 9 May 2018 05:13:08 EEST ming_qian@realsil.com.cn wrote:
> From: ming_qian <ming_qian@realsil.com.cn>
> 
> The length of UVC 1.5 video control is 48, and it id 34 for UVC 1.1.
> Change it to 48 for UVC 1.5 device,
> and the UVC 1.5 device can be recognized.
> 
> More changes to the driver are needed for full UVC 1.5 compatibility.
> However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have
> been reported to work well.

This patch is however not specific to Realtek devices, so I think we should
make the subject line more generic. It's fine mentioning in the commit message
itself that the Realtek RTS5847/RTS5852 cameras have been successfully tested.

> Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index aa0082f..32dfb32 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -171,6 +171,8 @@ static int uvc_get_video_ctrl(struct uvc_streaming
> *stream, int ret;
> 
>  	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> +	if (stream->dev->uvc_version >= 0x0150)
> +		size = 48;
>  	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
>  			query == UVC_GET_DEF)
>  		return -EIO;
> @@ -259,6 +261,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> *stream, int ret;
> 
>  	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> +	if (stream->dev->uvc_version >= 0x0150)
> +		size = 48;
>  	data = kzalloc(size, GFP_KERNEL);
>  	if (data == NULL)
>  		return -ENOMEM;

Instead of duplicating the computation in both functions, I think we should
move the code to a helper function.

Furthermore there are equality checks further down both functions that compare
the size to 34, they should be updated to also support UVC 1.5.

I propose the following updated patch. If you're fine with it there's no need
to resubmit, I'll queue it for v4.19.

I have dropped the Reviewed-by and Tested-by tags as the patch has changed.

commit a9c002732695eab2096580a0d1a1687bc2f95928
Author: ming_qian <ming_qian@realsil.com.cn>
Date:   Wed May 9 10:13:08 2018 +0800

    media: uvcvideo: Support UVC 1.5 video probe & commit controls
    
    The length of UVC 1.5 video control is 48, and it is 34 for UVC 1.1.
    Change it to 48 for UVC 1.5 device, and the UVC 1.5 device can be
    recognized.
    
    More changes to the driver are needed for full UVC 1.5 compatibility.
    However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have been
    reported to work well.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
    [Factor out code to helper function, update size checks]
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index eb9e04a59427..285b0e813b9d 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -207,14 +207,27 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
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
 	struct uvc_streaming_control *ctrl, int probe, u8 query)
 {
+	u16 size = uvc_video_ctrl_size(stream);
 	u8 *data;
-	u16 size;
 	int ret;
 
-	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
 	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
 			query == UVC_GET_DEF)
 		return -EIO;
@@ -271,7 +284,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 	ctrl->dwMaxVideoFrameSize = get_unaligned_le32(&data[18]);
 	ctrl->dwMaxPayloadTransferSize = get_unaligned_le32(&data[22]);
 
-	if (size == 34) {
+	if (size >= 34) {
 		ctrl->dwClockFrequency = get_unaligned_le32(&data[26]);
 		ctrl->bmFramingInfo = data[30];
 		ctrl->bPreferedVersion = data[31];
@@ -300,11 +313,10 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl, int probe)
 {
+	u16 size = uvc_video_ctrl_size(stream);
 	u8 *data;
-	u16 size;
 	int ret;
 
-	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
 	data = kzalloc(size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
@@ -321,7 +333,7 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
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
