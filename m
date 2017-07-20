Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38932 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S964945AbdGTPXS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:23:18 -0400
Date: Thu, 20 Jul 2017 18:23:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 22/23] camss: Use optimal clock frequency rates
Message-ID: <20170720152313.joqfo7dqg5gbxrfl@valkosipuli.retiisi.org.uk>
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-23-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500287629-23703-23-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Jul 17, 2017 at 01:33:48PM +0300, Todor Tomov wrote:
> Use standard V4L2 control to get pixel clock rate from a sensor
> linked in the media controller pipeline. Then calculate clock
> rates on CSIPHY, CSID and VFE to use the lowest possible.
> 
> If the currnet pixel clock rate of the sensor cannot be read then
> use the highest possible. This case covers also the CSID test
> generator usage.
> 
> If VFE is already powered on by another pipeline, check that the
> current VFE clock rate is high enough for the new pipeline.
> If not return busy error code as VFE clock rate cannot be changed
> while VFE is running.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  .../media/platform/qcom/camss-8x16/camss-csid.c    | 324 ++++++++++++++-------
>  .../media/platform/qcom/camss-8x16/camss-csid.h    |   2 +-
>  .../media/platform/qcom/camss-8x16/camss-csiphy.c  | 112 +++++--
>  .../media/platform/qcom/camss-8x16/camss-csiphy.h  |   2 +-
>  .../media/platform/qcom/camss-8x16/camss-ispif.c   |  23 +-
>  .../media/platform/qcom/camss-8x16/camss-ispif.h   |   4 +-
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 289 +++++++++++++++---
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.h |   2 +-
>  drivers/media/platform/qcom/camss-8x16/camss.c     |  51 +++-
>  drivers/media/platform/qcom/camss-8x16/camss.h     |  17 +-
>  10 files changed, 634 insertions(+), 192 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.c b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
> index 2bf3415..5c0e359 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-csid.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
> @@ -68,122 +68,224 @@ static const struct {
>  	u8 data_type;
>  	u8 decode_format;
>  	u8 uncompr_bpp;
> +	u8 spp; /* bus samples per pixel */
>  } csid_input_fmts[] = {
>  	{
>  		MEDIA_BUS_FMT_UYVY8_2X8,
>  		MEDIA_BUS_FMT_UYVY8_2X8,
>  		DATA_TYPE_YUV422_8BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
> -		16
> +		8,
> +		2

If your original patch had added the comma on the previous line, this would
be simply adding a line per array entry.

>  	},
>  	{
>  		MEDIA_BUS_FMT_VYUY8_2X8,
>  		MEDIA_BUS_FMT_VYUY8_2X8,
>  		DATA_TYPE_YUV422_8BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
> -		16
> +		8,
> +		2
>  	},
>  	{
>  		MEDIA_BUS_FMT_YUYV8_2X8,
>  		MEDIA_BUS_FMT_YUYV8_2X8,
>  		DATA_TYPE_YUV422_8BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
> -		16
> +		8,
> +		2
>  	},
>  	{
>  		MEDIA_BUS_FMT_YVYU8_2X8,
>  		MEDIA_BUS_FMT_YVYU8_2X8,
>  		DATA_TYPE_YUV422_8BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
> -		16
> +		8,
> +		2
>  	},
>  	{
>  		MEDIA_BUS_FMT_SBGGR8_1X8,
>  		MEDIA_BUS_FMT_SBGGR8_1X8,
>  		DATA_TYPE_RAW_8BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
> -		8
> +		8,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SGBRG8_1X8,
>  		MEDIA_BUS_FMT_SGBRG8_1X8,
>  		DATA_TYPE_RAW_8BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
> -		8
> +		8,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SGRBG8_1X8,
>  		MEDIA_BUS_FMT_SGRBG8_1X8,
>  		DATA_TYPE_RAW_8BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
> -		8
> +		8,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SRGGB8_1X8,
>  		MEDIA_BUS_FMT_SRGGB8_1X8,
>  		DATA_TYPE_RAW_8BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_8_BIT,
> -		8
> +		8,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SBGGR10_1X10,
>  		MEDIA_BUS_FMT_SBGGR10_1X10,
>  		DATA_TYPE_RAW_10BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
> -		10
> +		10,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SGBRG10_1X10,
>  		MEDIA_BUS_FMT_SGBRG10_1X10,
>  		DATA_TYPE_RAW_10BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
> -		10
> +		10,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SGRBG10_1X10,
>  		MEDIA_BUS_FMT_SGRBG10_1X10,
>  		DATA_TYPE_RAW_10BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
> -		10
> +		10,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SRGGB10_1X10,
>  		MEDIA_BUS_FMT_SRGGB10_1X10,
>  		DATA_TYPE_RAW_10BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_10_BIT,
> -		10
> +		10,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SBGGR12_1X12,
>  		MEDIA_BUS_FMT_SBGGR12_1X12,
>  		DATA_TYPE_RAW_12BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
> -		12
> +		12,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SGBRG12_1X12,
>  		MEDIA_BUS_FMT_SGBRG12_1X12,
>  		DATA_TYPE_RAW_12BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
> -		12
> +		12,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SGRBG12_1X12,
>  		MEDIA_BUS_FMT_SGRBG12_1X12,
>  		DATA_TYPE_RAW_12BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
> -		12
> +		12,
> +		1
>  	},
>  	{
>  		MEDIA_BUS_FMT_SRGGB12_1X12,
>  		MEDIA_BUS_FMT_SRGGB12_1X12,
>  		DATA_TYPE_RAW_12BIT,
>  		DECODE_FORMAT_UNCOMPRESSED_12_BIT,
> -		12
> +		12,
> +		1
>  	}
>  };
>  
>  /*
> + * csid_get_uncompressed - map media bus format to uncompressed media bus format
> + * @code: media bus format code
> + *
> + * Return uncompressed media bus format code
> + */
> +static u32 csid_get_uncompressed(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
> +		if (code == csid_input_fmts[i].code)
> +			break;
> +
> +	return csid_input_fmts[i].uncompressed;
> +}

I think my suggestion of returning an array entry (a struct) was a good
one. :-)

> +
> +/*
> + * csid_get_data_type - map media bus format to data type
> + * @code: media bus format code
> + *
> + * Return data type code
> + */
> +static u8 csid_get_data_type(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
> +		if (code == csid_input_fmts[i].code)
> +			break;
> +
> +	return csid_input_fmts[i].data_type;
> +}
> +
> +/*
> + * csid_get_decode_format - map media bus format to decode format
> + * @code: media bus format code
> + *
> + * Return decode format code
> + */
> +static u8 csid_get_decode_format(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
> +		if (code == csid_input_fmts[i].code)
> +			break;
> +
> +	return csid_input_fmts[i].decode_format;
> +}
> +
> +/*
> + * csid_get_bpp - map media bus format to bits per pixel
> + * @code: media bus format code
> + *
> + * Return number of bits per pixel
> + */
> +static u8 csid_get_bpp(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
> +		if (code == csid_input_fmts[i].uncompressed)
> +			break;
> +
> +	return csid_input_fmts[i].uncompr_bpp;
> +}
> +
> +/*
> + * csid_get_spp - map media bus format to bus samples per pixel
> + * @code: media bus format code
> + *
> + * Return number of bus samples per pixel
> + */
> +static u8 csid_get_spp(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(csid_input_fmts); i++)
> +		if (code == csid_input_fmts[i].uncompressed)
> +			break;
> +
> +	return csid_input_fmts[i].spp;
> +}
> +
> +/*
>   * csid_isr - CSID module interrupt handler
>   * @irq: Interrupt line
>   * @dev: CSID device

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
