Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50465 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965665AbeEJPGH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 11:06:07 -0400
Received: from mail-pf0-f197.google.com ([209.85.192.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1fGn8w-0003VT-Iw
        for linux-media@vger.kernel.org; Thu, 10 May 2018 15:06:06 +0000
Received: by mail-pf0-f197.google.com with SMTP id e3-v6so1282973pfe.15
        for <linux-media@vger.kernel.org>; Thu, 10 May 2018 08:06:06 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH] media: uvcvideo: Support realtek's UVC 1.5 device
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
Date: Thu, 10 May 2018 23:05:54 +0800
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C4B48A97-2942-4E37-A65C-DD0570FAA52C@canonical.com>
References: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
To: ming_qian@realsil.com.cn
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

at 10:13, ming_qian@realsil.com.cn wrote:

> From: ming_qian <ming_qian@realsil.com.cn>
>
> The length of UVC 1.5 video control is 48, and it id 34 for UVC 1.1.
> Change it to 48 for UVC 1.5 device,
> and the UVC 1.5 device can be recognized.
>
> More changes to the driver are needed for full UVC 1.5 compatibility.
> However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have
> been reported to work well.

I think this should also Cc: stable.

Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

>
> Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/usb/uvc/uvc_video.c  
> b/drivers/media/usb/uvc/uvc_video.c
> index aa0082f..32dfb32 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -171,6 +171,8 @@ static int uvc_get_video_ctrl(struct uvc_streaming  
> *stream,
>  	int ret;
>
>  	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> +	if (stream->dev->uvc_version >= 0x0150)
> +		size = 48;
>  	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
>  			query == UVC_GET_DEF)
>  		return -EIO;
> @@ -259,6 +261,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming  
> *stream,
>  	int ret;
>
>  	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> +	if (stream->dev->uvc_version >= 0x0150)
> +		size = 48;
>  	data = kzalloc(size, GFP_KERNEL);
>  	if (data == NULL)
>  		return -ENOMEM;
> -- 
> 2.7.4
