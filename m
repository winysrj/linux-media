Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49661 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754028AbeEWFmq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 01:42:46 -0400
Received: from mail-pl0-f71.google.com ([209.85.160.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1fLMXt-0000AN-6f
        for linux-media@vger.kernel.org; Wed, 23 May 2018 05:42:45 +0000
Received: by mail-pl0-f71.google.com with SMTP id a5-v6so13437081plp.8
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 22:42:45 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 11.4 \(3445.8.2\))
Subject: Re: [PATCH] media: uvcvideo: Support realtek's UVC 1.5 device
From: Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <2510852.fx2XduE8hM@avalon>
Date: Wed, 23 May 2018 13:42:38 +0800
Cc: ming_qian@realsil.com.cn,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Ana Guerrero Lopez <ana.guerrero@collabora.com>
Content-Transfer-Encoding: 7bit
Message-Id: <C2D9C61E-F990-4C47-8E9E-18CA74C79FA2@canonical.com>
References: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
 <2510852.fx2XduE8hM@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On May 23, 2018, at 4:32 AM, Laurent Pinchart  
> <laurent.pinchart@ideasonboard.com> wrote:
>
> Hello,
>
> Thank you for the patch.
>
> On Wednesday, 9 May 2018 05:13:08 EEST ming_qian@realsil.com.cn wrote:
>> From: ming_qian <ming_qian@realsil.com.cn>
>>
>> The length of UVC 1.5 video control is 48, and it id 34 for UVC 1.1.
>> Change it to 48 for UVC 1.5 device,
>> and the UVC 1.5 device can be recognized.
>>
>> More changes to the driver are needed for full UVC 1.5 compatibility.
>> However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have
>> been reported to work well.
>
> This patch is however not specific to Realtek devices, so I think we should
> make the subject line more generic. It's fine mentioning in the commit  
> message
> itself that the Realtek RTS5847/RTS5852 cameras have been successfully  
> tested.
>
>> Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
>> ---
>>  drivers/media/usb/uvc/uvc_video.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_video.c
>> b/drivers/media/usb/uvc/uvc_video.c index aa0082f..32dfb32 100644
>> --- a/drivers/media/usb/uvc/uvc_video.c
>> +++ b/drivers/media/usb/uvc/uvc_video.c
>> @@ -171,6 +171,8 @@ static int uvc_get_video_ctrl(struct uvc_streaming
>> *stream, int ret;
>>
>>  	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
>> +	if (stream->dev->uvc_version >= 0x0150)
>> +		size = 48;
>>  	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
>>  			query == UVC_GET_DEF)
>>  		return -EIO;
>> @@ -259,6 +261,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming
>> *stream, int ret;
>>
>>  	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
>> +	if (stream->dev->uvc_version >= 0x0150)
>> +		size = 48;
>>  	data = kzalloc(size, GFP_KERNEL);
>>  	if (data == NULL)
>>  		return -ENOMEM;
>
> Instead of duplicating the computation in both functions, I think we should
> move the code to a helper function.
>
> Furthermore there are equality checks further down both functions that  
> compare
> the size to 34, they should be updated to also support UVC 1.5.
>
> I propose the following updated patch. If you're fine with it there's no  
> need
> to resubmit, I'll queue it for v4.19.
>
> I have dropped the Reviewed-by and Tested-by tags as the patch has changed.
>
> commit a9c002732695eab2096580a0d1a1687bc2f95928
> Author: ming_qian <ming_qian@realsil.com.cn>
> Date:   Wed May 9 10:13:08 2018 +0800
>
>     media: uvcvideo: Support UVC 1.5 video probe & commit controls
>
>     The length of UVC 1.5 video control is 48, and it is 34 for UVC 1.1.
>     Change it to 48 for UVC 1.5 device, and the UVC 1.5 device can be
>     recognized.
>
>     More changes to the driver are needed for full UVC 1.5 compatibility.
>     However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have been
>     reported to work well.
>
>     Cc: stable@vger.kernel.org
>     Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
>     [Factor out code to helper function, update size checks]
>     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I tested this new patch and it works well.

Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

>
> diff --git a/drivers/media/usb/uvc/uvc_video.c  
> b/drivers/media/usb/uvc/uvc_video.c
> index eb9e04a59427..285b0e813b9d 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -207,14 +207,27 @@ static void uvc_fixup_video_ctrl(struct  
> uvc_streaming *stream,
>  	}
>  }
>
> +static size_t uvc_video_ctrl_size(struct uvc_streaming *stream)
> +{
> +	/*
> +	 * Return the size of the video probe and commit controls, which depends
> +	 * on the protocol version.
> +	 */
> +	if (stream->dev->uvc_version < 0x0110)
> +		return 26;
> +	else if (stream->dev->uvc_version < 0x0150)
> +		return 34;
> +	else
> +		return 48;
> +}
> +
>  static int uvc_get_video_ctrl(struct uvc_streaming *stream,
>  	struct uvc_streaming_control *ctrl, int probe, u8 query)
>  {
> +	u16 size = uvc_video_ctrl_size(stream);
>  	u8 *data;
> -	u16 size;
>  	int ret;
>
> -	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
>  	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
>  			query == UVC_GET_DEF)
>  		return -EIO;
> @@ -271,7 +284,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming  
> *stream,
>  	ctrl->dwMaxVideoFrameSize = get_unaligned_le32(&data[18]);
>  	ctrl->dwMaxPayloadTransferSize = get_unaligned_le32(&data[22]);
>
> -	if (size == 34) {
> +	if (size >= 34) {
>  		ctrl->dwClockFrequency = get_unaligned_le32(&data[26]);
>  		ctrl->bmFramingInfo = data[30];
>  		ctrl->bPreferedVersion = data[31];
> @@ -300,11 +313,10 @@ static int uvc_get_video_ctrl(struct uvc_streaming  
> *stream,
>  static int uvc_set_video_ctrl(struct uvc_streaming *stream,
>  	struct uvc_streaming_control *ctrl, int probe)
>  {
> +	u16 size = uvc_video_ctrl_size(stream);
>  	u8 *data;
> -	u16 size;
>  	int ret;
>
> -	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
>  	data = kzalloc(size, GFP_KERNEL);
>  	if (data == NULL)
>  		return -ENOMEM;
> @@ -321,7 +333,7 @@ static int uvc_set_video_ctrl(struct uvc_streaming  
> *stream,
>  	put_unaligned_le32(ctrl->dwMaxVideoFrameSize, &data[18]);
>  	put_unaligned_le32(ctrl->dwMaxPayloadTransferSize, &data[22]);
>
> -	if (size == 34) {
> +	if (size >= 34) {
>  		put_unaligned_le32(ctrl->dwClockFrequency, &data[26]);
>  		data[30] = ctrl->bmFramingInfo;
>  		data[31] = ctrl->bPreferedVersion;
>
> -- 
> Regards,
>
> Laurent Pinchart
