Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57758 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2AQPdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 10:33:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Abhishek Reddy Kondaveeti" <areddykondaveeti@aptina.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
Date: Tue, 17 Jan 2012 16:33:50 +0100
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com>
In-Reply-To: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201171633.50619.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Abhishek,

Thank you for the patch, and sorry for the very late reply. For some reason 
the mail slipped through and I've only noticed it now.

First of all, please fix your mailer. The message is sent in plain text + HTML 
format, which is refused by many mailing lists. You should use plain text 
only. The message also has tabs converted to spaces. This will break the 
scripts that handle patches sent by e-mail.

The preferred way to send patches is to use the 'git send-email' tool. This 
will make sure that patches are properly formatted. I've reformatted the patch 
manually to comment it this time, but please make sure it gets formatted 
properly next time.

On Tuesday 06 December 2011 12:45:51 Abhishek Reddy Kondaveeti wrote:
> Adding YUV input support for Omap3ISp driver, so that we don't need to
> use entire pipeline while working with SOC camera chips.
> 
> Signed-off-by: Abhishek <areddykondaveeti@aptina.com>
> 
> From 32d0984fa18fa324dd9dc628d1cfb1d369c2298f Mon Sep 17 00:00:00 2001
> From: Abhishek <areddykondaveeti@aptina.com>
> Date: Tue, 6 Dec 2011 15:11:06 +0530
> Subject: [PATCH 10217/10217] "Added YUV Support for OMAP3ISP driver"
> 
> ---
> 
> drivers/media/video/omap3isp/isp.c      |    2 +-
> drivers/media/video/omap3isp/ispccdc.c  |    9 +++++++++
> drivers/media/video/omap3isp/ispvideo.c |    4 ++--
> 3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c
> index b818cac..417d97b 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -308,7 +308,7 @@ void omap3isp_configure_bridge(struct isp_device
> *isp,
>			case CCDC_INPUT_PARALLEL:
>				ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
>				ispctrl_val |= pdata->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
> -				ispctrl_val |= pdata->bridge << ISPCTRL_PAR_BRIDGE_SHIFT;
> +				ispctrl_val |= pdata->bridge;

Why is this needed ? Board code should use the constants defined in 
include/media/omap3isp.h (ISP_BRIDGE_DISABLE, ISP_BRIDGE_LITTLE_ENDIAN or 
ISP_BRIDGE_BIG_ENDIAN), so they should be shifted left here.

>				shift += pdata->data_lane_shift * 2;
>				break;
> 
> diff --git a/drivers/media/video/omap3isp/ispccdc.c
> b/drivers/media/video/omap3isp/ispccdc.c
> index b0b0fa5..0268097 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -58,6 +58,8 @@ static const unsigned int ccdc_fmts[] = {
>	V4L2_MBUS_FMT_SRGGB12_1X12,
>	V4L2_MBUS_FMT_SBGGR12_1X12,
>	V4L2_MBUS_FMT_SGBRG12_1X12,
> +	V4L2_MBUS_FMT_UYVY8_1X16,
> +	V4L2_MBUS_FMT_YUYV8_1X16,

You should use V4L2_MBUS_FMT_UYVY8_2X8 and V4L2_MBUS_FMT_YUYV8_2X8 instead, as 
the sensor bus is 8 bits wide, not 16 bits wide.

The format at the CCDC output, however, will be V4L2_MBUS_FMT_UYVY8_1X16 or 
V4L2_MBUS_FMT_YUYV8_1X16. ccdc_try_format() needs to be modified to handle 
that.

> };
>  /*
> 
> @@ -1158,6 +1160,13 @@ static void ccdc_configure(struct isp_ccdc_device
> *ccdc)
>		format = &ccdc->formats[CCDC_PAD_SINK];
>		syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
> 
> +		if((format->code == V4L2_MBUS_FMT_UYVY8_1X16) ||
> +		   (format->code == V4L2_MBUS_FMT_YUYV8_1X16))
> +		{
> +			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
> +			syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_10;
> +		}
> +

Why DATSIZ_10 ? Isn't the input data 8-bits wide ?

I already had a couple of YUV support patches in my OMAP3 ISP tree at 
git.kernel.org. I've rebased them on top of the lastest V4L/DVB tree and 
pushed them to 
http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
omap3isp-yuv. Could you please try them, and see if they're usable with your 
sensor ?

>		/* Use the raw, unprocessed data when writing to memory. The H3A and
>		 * histogram modules are still fed with lens shading corrected data.
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c
> index d100072..be738a5 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -95,10 +95,10 @@ static struct isp_format_info formats[] = {
>		  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB8_1X8,
>		  V4L2_PIX_FMT_SRGGB12, 12, },
>		{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
> -		  V4L2_MBUS_FMT_UYVY8_1X16, 0,
> +		  V4L2_MBUS_FMT_UYVY8_1X16, 8,
>		  V4L2_PIX_FMT_UYVY, 16, },
>		{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
> -		  V4L2_MBUS_FMT_YUYV8_1X16, 0,
> +		  V4L2_MBUS_FMT_YUYV8_1X16, 8,
>		  V4L2_PIX_FMT_YUYV, 16, },
> };

-- 
Regards,

Laurent Pinchart
