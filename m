Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64378 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1HVV1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Aug 2011 17:27:39 -0400
Received: by fxh19 with SMTP id 19so3535296fxh.19
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2011 14:27:38 -0700 (PDT)
Message-ID: <4E52C9CE.3040900@googlemail.com>
Date: Mon, 22 Aug 2011 23:27:42 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: moinejf@free.fr
Subject: Re: [PATCH] gspca_sn9c20x: device 0c45:62b3: fix status LED
References: <1309515598-14669-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1309515598-14669-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping ... what happened to this patch ? ;-)

Am 01.07.2011 12:19, schrieb Frank Schaefer:
> gspca_sn9c20x: device 0c45:62b3: fix status LED
>
> Tested with webcam "SilverCrest WC2130".
>
> Signed-off-by: Frank Schaefer<fschaefer.oss@googlemail.com>
>
> Cc: stable@kernel.org
> ---
>   drivers/media/video/gspca/sn9c20x.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
> index c431900..af9cd50 100644
> --- a/drivers/media/video/gspca/sn9c20x.c
> +++ b/drivers/media/video/gspca/sn9c20x.c
> @@ -2513,7 +2513,7 @@ static const struct usb_device_id device_table[] = {
>   	{USB_DEVICE(0x0c45, 0x628f), SN9C20X(OV9650, 0x30, 0)},
>   	{USB_DEVICE(0x0c45, 0x62a0), SN9C20X(OV7670, 0x21, 0)},
>   	{USB_DEVICE(0x0c45, 0x62b0), SN9C20X(MT9VPRB, 0x00, 0)},
> -	{USB_DEVICE(0x0c45, 0x62b3), SN9C20X(OV9655, 0x30, 0)},
> +	{USB_DEVICE(0x0c45, 0x62b3), SN9C20X(OV9655, 0x30, LED_REVERSE)},
>   	{USB_DEVICE(0x0c45, 0x62bb), SN9C20X(OV7660, 0x21, LED_REVERSE)},
>   	{USB_DEVICE(0x0c45, 0x62bc), SN9C20X(HV7131R, 0x11, 0)},
>   	{USB_DEVICE(0x045e, 0x00f4), SN9C20X(OV9650, 0x30, 0)},

