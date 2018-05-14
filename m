Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35598 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752586AbeENRaB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 13:30:01 -0400
Received: by mail-wr0-f194.google.com with SMTP id i14-v6so13207763wre.2
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 10:30:00 -0700 (PDT)
From: =?UTF-8?q?Josef=20=C5=A0im=C3=A1nek?= <josef.simanek@gmail.com>
To: ming_qian@realsil.com.cn
Cc: linux-media@vger.kernel.org,
        =?UTF-8?q?Josef=20=C5=A0im=C3=A1nek?= <josef.simanek@gmail.com>
Subject: RE: media: uvcvideo: Support realtek's UVC 1.5 device
Date: Mon, 14 May 2018 19:29:57 +0200
Message-Id: <20180514172957.27752-1-josef.simanek@gmail.com>
In-Reply-To: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
References: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The length of UVC 1.5 video control is 48, and it id 34 for UVC 1.1.
> Change it to 48 for UVC 1.5 device,
> and the UVC 1.5 device can be recognized.
> 
> More changes to the driver are needed for full UVC 1.5 compatibility.
> However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have
> been reported to work well.
> 
> Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Hello! I have sucessfully tested this patch on Kernel 4.16.1 (Fedora 28) with Dell XPS 9370
using following device (output from lsusb):

Bus 001 Device 002: ID 0bda:58f4 Realtek Semiconductor Corp.

You can also find related dmesg output at https://bugs.launchpad.net/dell-sputnik/+bug/1763748/comments/35

Tested-by: Josef Šimánek <josef.simanek@gmail.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index aa0082f..32dfb32 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -171,6 +171,8 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
>  	int ret;
>  
>  	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> +	if (stream->dev->uvc_version >= 0x0150)
> +		size = 48;
>  	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
>  			query == UVC_GET_DEF)
>  		return -EIO;
> @@ -259,6 +261,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
>  	int ret;
>  
>  	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> +	if (stream->dev->uvc_version >= 0x0150)
> +		size = 48;
>  	data = kzalloc(size, GFP_KERNEL);
>  	if (data == NULL)
>  		return -ENOMEM;
