Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2112 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBLPE5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 10:04:57 -0500
Message-ID: <52FB8CBD.9070602@xs4all.nl>
Date: Wed, 12 Feb 2014 16:01:17 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 36/47] adv7604: Make output format configurable through
 pad format operations
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-37-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-37-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/14 17:42, Laurent Pinchart wrote:
> Replace the dummy video format operations by pad format operations that
> configure the output format.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/adv7604.c | 243 +++++++++++++++++++++++++++++++++++++++-----
>  include/media/adv7604.h     |  47 ++-------
>  2 files changed, 225 insertions(+), 65 deletions(-)
> 

<snip>

> diff --git a/include/media/adv7604.h b/include/media/adv7604.h
> index 22811d3..2cc8e16 100644
> --- a/include/media/adv7604.h
> +++ b/include/media/adv7604.h
> @@ -32,16 +32,6 @@ enum adv7604_ain_sel {
>  	ADV7604_AIN9_4_5_6_SYNC_2_1 = 4,
>  };
>  
> -/* Bus rotation and reordering (IO register 0x04, [7:5]) */
> -enum adv7604_op_ch_sel {
> -	ADV7604_OP_CH_SEL_GBR = 0,
> -	ADV7604_OP_CH_SEL_GRB = 1,
> -	ADV7604_OP_CH_SEL_BGR = 2,
> -	ADV7604_OP_CH_SEL_RGB = 3,
> -	ADV7604_OP_CH_SEL_BRG = 4,
> -	ADV7604_OP_CH_SEL_RBG = 5,
> -};
> -
>  /* Input Color Space (IO register 0x02, [7:4]) */
>  enum adv7604_inp_color_space {
>  	ADV7604_INP_COLOR_SPACE_LIM_RGB = 0,
> @@ -55,29 +45,11 @@ enum adv7604_inp_color_space {
>  	ADV7604_INP_COLOR_SPACE_AUTO = 0xf,
>  };
>  
> -/* Select output format (IO register 0x03, [7:0]) */
> -enum adv7604_op_format_sel {
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_8 = 0x00,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_10 = 0x01,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_12_MODE0 = 0x02,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_12_MODE1 = 0x06,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_12_MODE2 = 0x0a,
> -	ADV7604_OP_FORMAT_SEL_DDR_422_8 = 0x20,
> -	ADV7604_OP_FORMAT_SEL_DDR_422_10 = 0x21,
> -	ADV7604_OP_FORMAT_SEL_DDR_422_12_MODE0 = 0x22,
> -	ADV7604_OP_FORMAT_SEL_DDR_422_12_MODE1 = 0x23,
> -	ADV7604_OP_FORMAT_SEL_DDR_422_12_MODE2 = 0x24,
> -	ADV7604_OP_FORMAT_SEL_SDR_444_24 = 0x40,
> -	ADV7604_OP_FORMAT_SEL_SDR_444_30 = 0x41,
> -	ADV7604_OP_FORMAT_SEL_SDR_444_36_MODE0 = 0x42,
> -	ADV7604_OP_FORMAT_SEL_DDR_444_24 = 0x60,
> -	ADV7604_OP_FORMAT_SEL_DDR_444_30 = 0x61,
> -	ADV7604_OP_FORMAT_SEL_DDR_444_36 = 0x62,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_16 = 0x80,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_20 = 0x81,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_24_MODE0 = 0x82,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_24_MODE1 = 0x86,
> -	ADV7604_OP_FORMAT_SEL_SDR_ITU656_24_MODE2 = 0x8a,
> +/* Select output format (IO register 0x03, [4:2]) */
> +enum adv7604_op_format_mode_sel {
> +	ADV7604_OP_FORMAT_MODE0 = 0x00,
> +	ADV7604_OP_FORMAT_MODE1 = 0x04,
> +	ADV7604_OP_FORMAT_MODE2 = 0x08,
>  };
>  
>  enum adv7604_drive_strength {
> @@ -104,11 +76,8 @@ struct adv7604_platform_data {
>  	/* Analog input muxing mode */
>  	enum adv7604_ain_sel ain_sel;
>  
> -	/* Bus rotation and reordering */
> -	enum adv7604_op_ch_sel op_ch_sel;

I would keep this as part of the platform_data. This is typically used if things
are wired up in a non-standard way and so is specific to the hardware. It is not
something that will change from format to format.

Other than this it all looks quite nice! Much more flexible than before.

Regards,

	Hans

> -
> -	/* Select output format */
> -	enum adv7604_op_format_sel op_format_sel;
> +	/* Select output format mode */
> +	enum adv7604_op_format_mode_sel op_format_mode_sel;
>  
>  	/* Configuration of the INT1 pin */
>  	enum adv7604_int1_config int1_config;
> @@ -116,14 +85,12 @@ struct adv7604_platform_data {
>  	/* IO register 0x02 */
>  	unsigned alt_gamma:1;
>  	unsigned op_656_range:1;
> -	unsigned rgb_out:1;
>  	unsigned alt_data_sat:1;
>  
>  	/* IO register 0x05 */
>  	unsigned blank_data:1;
>  	unsigned insert_av_codes:1;
>  	unsigned replicate_av_codes:1;
> -	unsigned invert_cbcr:1;
>  
>  	/* IO register 0x06 */
>  	unsigned inv_vs_pol:1;
> 

