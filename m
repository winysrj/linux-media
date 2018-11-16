Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60752 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727711AbeKPXay (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 18:30:54 -0500
Date: Fri, 16 Nov 2018 15:18:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] media: ov5640: Add additional media bus formats
Message-ID: <20181116131831.tun2uo2daii4jbd2@valkosipuli.retiisi.org.uk>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
 <1539067682-60604-5-git-send-email-sam@elite-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539067682-60604-5-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sam,

On Mon, Oct 08, 2018 at 11:48:02PM -0700, Sam Bobrowicz wrote:
> Add support for 1X16 yuv media bus formats (v4l2_mbus_framefmt).
> These formats are equivalent to the 2X8 formats that are already
> supported, both of which accurately describe the data present on
> the CSI2 interface. This change will increase compatibility with
> CSI2 RX drivers that only advertise support for the 1X16 formats.
> 
> Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
> ---
>  drivers/media/i2c/ov5640.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index a50d884..ca9de56 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -125,6 +125,8 @@ static const struct ov5640_pixfmt ov5640_formats[] = {
>  	{ MEDIA_BUS_FMT_JPEG_1X8, V4L2_COLORSPACE_JPEG, },
>  	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_SRGB, },
>  	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_SRGB, },
> +	{ MEDIA_BUS_FMT_UYVY8_1X16, V4L2_COLORSPACE_SRGB, },
> +	{ MEDIA_BUS_FMT_YUYV8_1X16, V4L2_COLORSPACE_SRGB, },
>  	{ MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB, },
>  	{ MEDIA_BUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB, },
>  };

Can you make these selectable only for the CSI-2 bus? I understand the
driver also supports the parallel interface.

> @@ -2069,10 +2071,12 @@ static int ov5640_set_framefmt(struct ov5640_dev *sensor,
>  
>  	switch (format->code) {
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
>  		/* YUV422, UYVY */
>  		val = 0x3f;
>  		break;
>  	case MEDIA_BUS_FMT_YUYV8_2X8:
> +	case MEDIA_BUS_FMT_YUYV8_1X16:
>  		/* YUV422, YUYV */
>  		val = 0x30;
>  		break;

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
