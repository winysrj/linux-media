Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43295 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab1EKQO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 12:14:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Current status report of mt9p031.
Date: Wed, 11 May 2011 11:41:54 +0200
Cc: Chris Rodley <carlighting@yahoo.co.nz>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <928748.83563.qm@web112012.mail.gq1.yahoo.com> <BANLkTimrE0gLBQg1bdfSR32miNp5Q-BiRg@mail.gmail.com>
In-Reply-To: <BANLkTimrE0gLBQg1bdfSR32miNp5Q-BiRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105111141.54830.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Javier,

On Wednesday 11 May 2011 09:15:29 javier Martin wrote:
> On 11 May 2011 06:54, Chris Rodley <carlighting@yahoo.co.nz> wrote:
> > I am having a problem with these commands:
> > 
> > root@chris:/home# ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CC
> > 
> > DC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> > Resetting all links to inactive
> > Setting up link 16:0 -> 5:0 [1]
> > Setting up link 5:1 -> 6:0 [1]
> > root@chris:/home# ./media-ctl -f '"mt9p031 2-0048":0[SGRBG8 320x240],
> > "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
> > Unable to parse format
> 
> Hi Chris,
> you have to add SGRBG8 and SGRBG12 formats to media-ctl with the following
> patch:
> 
> diff --git a/src/main.c b/src/main.c
> index 461dae1..fb1bfbe 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -52,8 +52,10 @@ static struct {
>         { "Y8", V4L2_MBUS_FMT_Y8_1X8},
>         { "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
>         { "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
> +       { "SGRBG8", V4L2_MBUS_FMT_SGRBG8_1X8 },
>         { "SGRBG10", V4L2_MBUS_FMT_SGRBG10_1X10 },
>         { "SGRBG10_DPCM8", V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 },
> +       { "SGRBG12", V4L2_MBUS_FMT_SGRBG12_1X12 },
>  };
> 
>  static const char *pixelcode_to_string(enum v4l2_mbus_pixelcode code)

Thanks for the patch. I've committed it to the media-ctl repository (with 
additional Bayer formats).

-- 
Regards,

Laurent Pinchart
