Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:55683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1AQRie (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 12:38:34 -0500
Date: Mon, 17 Jan 2011 18:38:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera jpeg support?
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF237@SC-VEXCH2.marvell.com>
Message-ID: <Pine.LNX.4.64.1101171826340.16051@axis700.grange>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040171EE@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
 <201101101133.01636.laurent.pinchart@ideasonboard.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF237@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 17 Jan 2011, Qing Xu wrote:

> Hi,
> 
> Many of our sensors support directly outputting JPEG data to camera 
> controller, do you feel it's reasonable to add jpeg support into 
> soc-camera? As it seems that there is no define in v4l2-mediabus.h which 
> is suitable for our case.

In principle I have nothing against this, but, I'm afraid, it is not quite 
that simple. I haven't worked with such sensors myself, but, AFAIU, the 
JPEG image format doesn't have fixed bytes-per-line and bytes-per-frame 
values. If you add it like you propose, this would mean, that it just 
delivers "normal" 8 bits per pixel images. OTOH, soc_mbus_bytes_per_line() 
would just return -EINVAL for your JPEG format, so, unsupporting drivers 
would just error out, which is not all that bad. When the first driver 
decides to support JPEG, they will have to handle that error. But maybe 
we'll want to return a special error code for it.

But, in fact, that is in a way my problem with your patches: you propose 
extensions to generic code without showing how this is going to be used in 
specific drivers. Could you show us your host driver, please? I don't 
think this is still the pxa27x driver, is it?

Thanks
Guennadi

> 
> Such as:
> --- a/drivers/media/video/soc_mediabus.c
> +++ b/drivers/media/video/soc_mediabus.c
> @@ -130,6 +130,13 @@ static const struct soc_mbus_pixelfmt mbus_fmt[] = {
>                 .packing                = SOC_MBUS_PACKING_2X8_PADLO,
>                 .order                  = SOC_MBUS_ORDER_BE,
>         },
> +       [MBUS_IDX(JPEG_1X8)] = {
> +               .fourcc                 = V4L2_PIX_FMT_JPEG,
> +               .name                   = "JPEG",
> +               .bits_per_sample        = 8,
> +               .packing                = SOC_MBUS_PACKING_NONE,
> +               .order                  = SOC_MBUS_ORDER_LE,
> +       },
>  };
> 
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -41,6 +41,7 @@ enum v4l2_mbus_pixelcode {
>         V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
>         V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
>         V4L2_MBUS_FMT_SGRBG8_1X8,
> +       V4L2_MBUS_FMT_JPEG_1X8,
>  };
> 
> Any ideas will be appreciated!
> Thanks!
> Qing Xu
> 
> Email: qingx@marvell.com
> Application Processor Systems Engineering,
> Marvell Technology Group Ltd.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
