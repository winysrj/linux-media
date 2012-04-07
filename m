Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab2DGO57 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Apr 2012 10:57:59 -0400
Message-ID: <4F8056BD.10305@redhat.com>
Date: Sat, 07 Apr 2012 17:01:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] tinyjpeg: Better luminance quantization table for Pixart
 JPEG
References: <20120323201945.39f26d98@tele>
In-Reply-To: <20120323201945.39f26d98@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch, I've pushed it to v4l-utils master and I will
cherry-pick it into the stable-0.8 branch after this mail.

I noticed while testing with a pac7302 camera, that under certain
circumstances the jpeg decompression still goes wrong. When you
point the camera at a high contrast picture in proper daylight,
it switches to a higher compression for certain areas of the picture,
and these areas become quite "blockey" when this happens the marker
changes to a different value. I think we should use a different
quant. table when this happens. It would be great if you can reproduce
this and find out a way to make the image less blocky in these
cases.

Thanks & Regards,

Hans


On 03/23/2012 08:19 PM, Jean-Francois Moine wrote:
> An other luminance quantization table gives a better quality to the
> Pixart images created by the webcams handled by the gspca drivers
> pac7302 and pac7311 (pixel format 'PJPG').
>
> Tests have been done with 5 different pac7302 webcams. The marker was
> always 0x44.
>
> Signed-off-by: Jean-François Moine<moinejf@free.fr>
>
> diff --git a/lib/libv4lconvert/tinyjpeg.c b/lib/libv4lconvert/tinyjpeg.c
> index e308f63..687e69c 100644
> --- a/lib/libv4lconvert/tinyjpeg.c
> +++ b/lib/libv4lconvert/tinyjpeg.c
> @@ -206,14 +206,14 @@ static const unsigned char val_ac_chrominance[] = {
>   };
>
>   const unsigned char pixart_quantization[][64] = { {
> -		0x07, 0x07, 0x08, 0x0a, 0x09, 0x07, 0x0d, 0x0b,
> -		0x0c, 0x0d, 0x11, 0x10, 0x0f, 0x12, 0x17, 0x27,
> -		0x1a, 0x18, 0x16, 0x16, 0x18, 0x31, 0x23, 0x25,
> -		0x1d, 0x28, 0x3a, 0x33, 0x3d, 0x3c, 0x39, 0x33,
> -		0x38, 0x37, 0x40, 0x48, 0x5c, 0x4e, 0x40, 0x44,
> -		0x57, 0x45, 0x37, 0x38, 0x50, 0x6d, 0x51, 0x57,
> -		0x5f, 0x62, 0x67, 0x68, 0x67, 0x3e, 0x4d, 0x71,
> -		0x79, 0x70, 0x64, 0x78, 0x5c, 0x65, 0x67, 0x63,
> +		0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x10, 0x10,
> +		0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
> +		0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
> +		0x10, 0x10, 0x10, 0x10, 0x20, 0x20, 0x20, 0x20,
> +		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +		0x20, 0x20, 0x20, 0x40, 0x40, 0x40, 0x40, 0x40,
> +		0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40,
> +		0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40,
>   	},
>   	{
>   		0x11, 0x12, 0x12, 0x18, 0x15, 0x18, 0x2f, 0x1a,
>
