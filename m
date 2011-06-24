Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:60675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1FXMmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 08:42:06 -0400
Date: Fri, 24 Jun 2011 14:42:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Chew <achew@nvidia.com>
cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, olof@lixom.net
Subject: Re: [PATCH 1/6 v3] [media] ov9740: Cleanup hex casing inconsistencies
In-Reply-To: <1308871184-6307-1-git-send-email-achew@nvidia.com>
Message-ID: <Pine.LNX.4.64.1106241441330.6014@axis700.grange>
References: <1308871184-6307-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 23 Jun 2011, achew@nvidia.com wrote:

> From: Andrew Chew <achew@nvidia.com>
> 
> Made all hex number casing use lower-case throughout the entire driver
> for consistency.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>

All look good to me now, thanks! Queued for 3.1.

Regards
Guennadi

> ---
>  drivers/media/video/ov9740.c |  111 +++++++++++++++++++++---------------------
>  1 files changed, 55 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
> index 4d4ee4f..96811e4 100644
> --- a/drivers/media/video/ov9740.c
> +++ b/drivers/media/video/ov9740.c
> @@ -44,12 +44,12 @@
>  #define OV9740_Y_ADDR_START_LO		0x0347
>  #define OV9740_X_ADDR_END_HI		0x0348
>  #define OV9740_X_ADDR_END_LO		0x0349
> -#define OV9740_Y_ADDR_END_HI		0x034A
> -#define OV9740_Y_ADDR_END_LO		0x034B
> -#define OV9740_X_OUTPUT_SIZE_HI		0x034C
> -#define OV9740_X_OUTPUT_SIZE_LO		0x034D
> -#define OV9740_Y_OUTPUT_SIZE_HI		0x034E
> -#define OV9740_Y_OUTPUT_SIZE_LO		0x034F
> +#define OV9740_Y_ADDR_END_HI		0x034a
> +#define OV9740_Y_ADDR_END_LO		0x034b
> +#define OV9740_X_OUTPUT_SIZE_HI		0x034c
> +#define OV9740_X_OUTPUT_SIZE_LO		0x034d
> +#define OV9740_Y_OUTPUT_SIZE_HI		0x034e
> +#define OV9740_Y_OUTPUT_SIZE_LO		0x034f
>  
>  /* IO Control Registers */
>  #define OV9740_IO_CREL00		0x3002
> @@ -89,28 +89,28 @@
>  #define OV9740_TIMING_CTRL35		0x3835
>  
>  /* Banding Filter */
> -#define OV9740_AEC_MAXEXPO_60_H		0x3A02
> -#define OV9740_AEC_MAXEXPO_60_L		0x3A03
> -#define OV9740_AEC_B50_STEP_HI		0x3A08
> -#define OV9740_AEC_B50_STEP_LO		0x3A09
> -#define OV9740_AEC_B60_STEP_HI		0x3A0A
> -#define OV9740_AEC_B60_STEP_LO		0x3A0B
> -#define OV9740_AEC_CTRL0D		0x3A0D
> -#define OV9740_AEC_CTRL0E		0x3A0E
> -#define OV9740_AEC_MAXEXPO_50_H		0x3A14
> -#define OV9740_AEC_MAXEXPO_50_L		0x3A15
> +#define OV9740_AEC_MAXEXPO_60_H		0x3a02
> +#define OV9740_AEC_MAXEXPO_60_L		0x3a03
> +#define OV9740_AEC_B50_STEP_HI		0x3a08
> +#define OV9740_AEC_B50_STEP_LO		0x3a09
> +#define OV9740_AEC_B60_STEP_HI		0x3a0a
> +#define OV9740_AEC_B60_STEP_LO		0x3a0b
> +#define OV9740_AEC_CTRL0D		0x3a0d
> +#define OV9740_AEC_CTRL0E		0x3a0e
> +#define OV9740_AEC_MAXEXPO_50_H		0x3a14
> +#define OV9740_AEC_MAXEXPO_50_L		0x3a15
>  
>  /* AEC/AGC Control */
>  #define OV9740_AEC_ENABLE		0x3503
> -#define OV9740_GAIN_CEILING_01		0x3A18
> -#define OV9740_GAIN_CEILING_02		0x3A19
> -#define OV9740_AEC_HI_THRESHOLD		0x3A11
> -#define OV9740_AEC_3A1A			0x3A1A
> -#define OV9740_AEC_CTRL1B_WPT2		0x3A1B
> -#define OV9740_AEC_CTRL0F_WPT		0x3A0F
> -#define OV9740_AEC_CTRL10_BPT		0x3A10
> -#define OV9740_AEC_CTRL1E_BPT2		0x3A1E
> -#define OV9740_AEC_LO_THRESHOLD		0x3A1F
> +#define OV9740_GAIN_CEILING_01		0x3a18
> +#define OV9740_GAIN_CEILING_02		0x3a19
> +#define OV9740_AEC_HI_THRESHOLD		0x3a11
> +#define OV9740_AEC_3A1A			0x3a1a
> +#define OV9740_AEC_CTRL1B_WPT2		0x3a1b
> +#define OV9740_AEC_CTRL0F_WPT		0x3a0f
> +#define OV9740_AEC_CTRL10_BPT		0x3a10
> +#define OV9740_AEC_CTRL1E_BPT2		0x3a1e
> +#define OV9740_AEC_LO_THRESHOLD		0x3a1f
>  
>  /* BLC Control */
>  #define OV9740_BLC_AUTO_ENABLE		0x4002
> @@ -132,7 +132,7 @@
>  #define OV9740_VT_SYS_CLK_DIV		0x0303
>  #define OV9740_VT_PIX_CLK_DIV		0x0301
>  #define OV9740_PLL_CTRL3010		0x3010
> -#define OV9740_VFIFO_CTRL00		0x460E
> +#define OV9740_VFIFO_CTRL00		0x460e
>  
>  /* ISP Control */
>  #define OV9740_ISP_CTRL00		0x5000
> @@ -141,9 +141,9 @@
>  #define OV9740_ISP_CTRL05		0x5005
>  #define OV9740_ISP_CTRL12		0x5012
>  #define OV9740_ISP_CTRL19		0x5019
> -#define OV9740_ISP_CTRL1A		0x501A
> -#define OV9740_ISP_CTRL1E		0x501E
> -#define OV9740_ISP_CTRL1F		0x501F
> +#define OV9740_ISP_CTRL1A		0x501a
> +#define OV9740_ISP_CTRL1E		0x501e
> +#define OV9740_ISP_CTRL1F		0x501f
>  #define OV9740_ISP_CTRL20		0x5020
>  #define OV9740_ISP_CTRL21		0x5021
>  
> @@ -158,12 +158,12 @@
>  #define OV9740_AWB_ADV_CTRL04		0x5187
>  #define OV9740_AWB_ADV_CTRL05		0x5188
>  #define OV9740_AWB_ADV_CTRL06		0x5189
> -#define OV9740_AWB_ADV_CTRL07		0x518A
> -#define OV9740_AWB_ADV_CTRL08		0x518B
> -#define OV9740_AWB_ADV_CTRL09		0x518C
> -#define OV9740_AWB_ADV_CTRL10		0x518D
> -#define OV9740_AWB_ADV_CTRL11		0x518E
> -#define OV9740_AWB_CTRL0F		0x518F
> +#define OV9740_AWB_ADV_CTRL07		0x518a
> +#define OV9740_AWB_ADV_CTRL08		0x518b
> +#define OV9740_AWB_ADV_CTRL09		0x518c
> +#define OV9740_AWB_ADV_CTRL10		0x518d
> +#define OV9740_AWB_ADV_CTRL11		0x518e
> +#define OV9740_AWB_CTRL0F		0x518f
>  #define OV9740_AWB_CTRL10		0x5190
>  #define OV9740_AWB_CTRL11		0x5191
>  #define OV9740_AWB_CTRL12		0x5192
> @@ -241,36 +241,36 @@ static const struct ov9740_reg ov9740_defaults[] = {
>  	/* Un-documented OV9740 registers */
>  	{ 0x5800, 0x29 }, { 0x5801, 0x25 }, { 0x5802, 0x20 }, { 0x5803, 0x21 },
>  	{ 0x5804, 0x26 }, { 0x5805, 0x2e }, { 0x5806, 0x11 }, { 0x5807, 0x0c },
> -	{ 0x5808, 0x09 }, { 0x5809, 0x0a }, { 0x580A, 0x0e }, { 0x580B, 0x16 },
> -	{ 0x580C, 0x06 }, { 0x580D, 0x02 }, { 0x580E, 0x00 }, { 0x580F, 0x00 },
> +	{ 0x5808, 0x09 }, { 0x5809, 0x0a }, { 0x580a, 0x0e }, { 0x580b, 0x16 },
> +	{ 0x580c, 0x06 }, { 0x580d, 0x02 }, { 0x580e, 0x00 }, { 0x580f, 0x00 },
>  	{ 0x5810, 0x04 }, { 0x5811, 0x0a }, { 0x5812, 0x05 }, { 0x5813, 0x02 },
>  	{ 0x5814, 0x00 }, { 0x5815, 0x00 }, { 0x5816, 0x03 }, { 0x5817, 0x09 },
> -	{ 0x5818, 0x0f }, { 0x5819, 0x0a }, { 0x581A, 0x07 }, { 0x581B, 0x08 },
> -	{ 0x581C, 0x0b }, { 0x581D, 0x14 }, { 0x581E, 0x28 }, { 0x581F, 0x23 },
> +	{ 0x5818, 0x0f }, { 0x5819, 0x0a }, { 0x581a, 0x07 }, { 0x581b, 0x08 },
> +	{ 0x581c, 0x0b }, { 0x581d, 0x14 }, { 0x581e, 0x28 }, { 0x581f, 0x23 },
>  	{ 0x5820, 0x1d }, { 0x5821, 0x1e }, { 0x5822, 0x24 }, { 0x5823, 0x2a },
>  	{ 0x5824, 0x4f }, { 0x5825, 0x6f }, { 0x5826, 0x5f }, { 0x5827, 0x7f },
> -	{ 0x5828, 0x9f }, { 0x5829, 0x5f }, { 0x582A, 0x8f }, { 0x582B, 0x9e },
> -	{ 0x582C, 0x8f }, { 0x582D, 0x9f }, { 0x582E, 0x4f }, { 0x582F, 0x87 },
> +	{ 0x5828, 0x9f }, { 0x5829, 0x5f }, { 0x582a, 0x8f }, { 0x582b, 0x9e },
> +	{ 0x582c, 0x8f }, { 0x582d, 0x9f }, { 0x582e, 0x4f }, { 0x582f, 0x87 },
>  	{ 0x5830, 0x86 }, { 0x5831, 0x97 }, { 0x5832, 0xae }, { 0x5833, 0x3f },
>  	{ 0x5834, 0x8e }, { 0x5835, 0x7c }, { 0x5836, 0x7e }, { 0x5837, 0xaf },
> -	{ 0x5838, 0x8f }, { 0x5839, 0x8f }, { 0x583A, 0x9f }, { 0x583B, 0x7f },
> -	{ 0x583C, 0x5f },
> +	{ 0x5838, 0x8f }, { 0x5839, 0x8f }, { 0x583a, 0x9f }, { 0x583b, 0x7f },
> +	{ 0x583c, 0x5f },
>  
>  	/* Y Gamma */
>  	{ 0x5480, 0x07 }, { 0x5481, 0x18 }, { 0x5482, 0x2c }, { 0x5483, 0x4e },
>  	{ 0x5484, 0x5e }, { 0x5485, 0x6b }, { 0x5486, 0x77 }, { 0x5487, 0x82 },
> -	{ 0x5488, 0x8c }, { 0x5489, 0x95 }, { 0x548A, 0xa4 }, { 0x548B, 0xb1 },
> -	{ 0x548C, 0xc6 }, { 0x548D, 0xd8 }, { 0x548E, 0xe9 },
> +	{ 0x5488, 0x8c }, { 0x5489, 0x95 }, { 0x548a, 0xa4 }, { 0x548b, 0xb1 },
> +	{ 0x548c, 0xc6 }, { 0x548d, 0xd8 }, { 0x548e, 0xe9 },
>  
>  	/* UV Gamma */
>  	{ 0x5490, 0x0f }, { 0x5491, 0xff }, { 0x5492, 0x0d }, { 0x5493, 0x05 },
>  	{ 0x5494, 0x07 }, { 0x5495, 0x1a }, { 0x5496, 0x04 }, { 0x5497, 0x01 },
> -	{ 0x5498, 0x03 }, { 0x5499, 0x53 }, { 0x549A, 0x02 }, { 0x549B, 0xeb },
> -	{ 0x549C, 0x02 }, { 0x549D, 0xa0 }, { 0x549E, 0x02 }, { 0x549F, 0x67 },
> -	{ 0x54A0, 0x02 }, { 0x54A1, 0x3b }, { 0x54A2, 0x02 }, { 0x54A3, 0x18 },
> -	{ 0x54A4, 0x01 }, { 0x54A5, 0xe7 }, { 0x54A6, 0x01 }, { 0x54A7, 0xc3 },
> -	{ 0x54A8, 0x01 }, { 0x54A9, 0x94 }, { 0x54AA, 0x01 }, { 0x54AB, 0x72 },
> -	{ 0x54AC, 0x01 }, { 0x54AD, 0x57 },
> +	{ 0x5498, 0x03 }, { 0x5499, 0x53 }, { 0x549a, 0x02 }, { 0x549b, 0xeb },
> +	{ 0x549c, 0x02 }, { 0x549d, 0xa0 }, { 0x549e, 0x02 }, { 0x549f, 0x67 },
> +	{ 0x54a0, 0x02 }, { 0x54a1, 0x3b }, { 0x54a2, 0x02 }, { 0x54a3, 0x18 },
> +	{ 0x54a4, 0x01 }, { 0x54a5, 0xe7 }, { 0x54a6, 0x01 }, { 0x54a7, 0xc3 },
> +	{ 0x54a8, 0x01 }, { 0x54a9, 0x94 }, { 0x54aa, 0x01 }, { 0x54ab, 0x72 },
> +	{ 0x54ac, 0x01 }, { 0x54ad, 0x57 },
>  
>  	/* AWB */
>  	{ OV9740_AWB_CTRL00,		0xf0 },
> @@ -296,18 +296,18 @@ static const struct ov9740_reg ov9740_defaults[] = {
>  	{ OV9740_AWB_CTRL14,		0x00 },
>  
>  	/* CIP */
> -	{ 0x530D, 0x12 },
> +	{ 0x530d, 0x12 },
>  
>  	/* CMX */
>  	{ 0x5380, 0x01 }, { 0x5381, 0x00 }, { 0x5382, 0x00 }, { 0x5383, 0x17 },
>  	{ 0x5384, 0x00 }, { 0x5385, 0x01 }, { 0x5386, 0x00 }, { 0x5387, 0x00 },
> -	{ 0x5388, 0x00 }, { 0x5389, 0xe0 }, { 0x538A, 0x00 }, { 0x538B, 0x20 },
> -	{ 0x538C, 0x00 }, { 0x538D, 0x00 }, { 0x538E, 0x00 }, { 0x538F, 0x16 },
> +	{ 0x5388, 0x00 }, { 0x5389, 0xe0 }, { 0x538a, 0x00 }, { 0x538b, 0x20 },
> +	{ 0x538c, 0x00 }, { 0x538d, 0x00 }, { 0x538e, 0x00 }, { 0x538f, 0x16 },
>  	{ 0x5390, 0x00 }, { 0x5391, 0x9c }, { 0x5392, 0x00 }, { 0x5393, 0xa0 },
>  	{ 0x5394, 0x18 },
>  
>  	/* 50/60 Detection */
> -	{ 0x3C0A, 0x9c }, { 0x3C0B, 0x3f },
> +	{ 0x3c0a, 0x9c }, { 0x3c0b, 0x3f },
>  
>  	/* Output Select */
>  	{ OV9740_IO_OUTPUT_SEL01,	0x00 },
> @@ -909,7 +909,6 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
>  	.g_register		= ov9740_get_register,
>  	.s_register		= ov9740_set_register,
>  #endif
> -
>  };
>  
>  static struct v4l2_subdev_video_ops ov9740_video_ops = {
> -- 
> 1.7.5.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
