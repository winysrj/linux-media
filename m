Return-path: <mchehab@gaivota>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41042 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0LWMFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 07:05:08 -0500
Received: by ewy5 with SMTP id 5so3047382ewy.19
        for <linux-media@vger.kernel.org>; Thu, 23 Dec 2010 04:05:06 -0800 (PST)
Message-ID: <4D133AB2.40207@mvista.com>
Date: Thu, 23 Dec 2010 15:04:02 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v10 5/8] davinci vpbe: platform specific additions-khilman
References: <1293105284-17380-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1293105284-17380-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello.

On 23-12-2010 14:54, Manjunath Hadli wrote:

> This patch implements the overall device creation for the Video
> display driver

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index 9a2376b..02ec74b 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -654,6 +654,146 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
[...]
> +/* TBD. Check what VENC_CLOCK_SEL settings for HDTV and EDTV */
> +static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type, __u64 mode)
> +{
> +	int ret = 0;
> +
> +	if (NULL == vpss_clkctl_reg)
> +		return -EINVAL;
> +	switch (type) {
> +	case VPBE_ENC_STD:
> +		__raw_writel(0x18, vpss_clkctl_reg);
> +		break;
> +	case VPBE_ENC_DV_PRESET:
> +		switch ((unsigned int)mode) {
> +		case V4L2_DV_480P59_94:
> +		case V4L2_DV_576P50:
> +			 __raw_writel(0x19, vpss_clkctl_reg);
> +			break;
> +		case V4L2_DV_720P60:
> +		case V4L2_DV_1080I60:
> +		case V4L2_DV_1080P30:
> +		/*
> +		 * For HD, use external clock source since HD requires higher
> +		 * clock rate
> +		 */

    Indent the comment correctly, please.

> +			__raw_writel(0xa, vpss_clkctl_reg);
> +			break;
> +		default:
> +			ret  = -EINVAL;
> +			break;
> +		}
> +		break;
> +	default:
> +		ret  = -EINVAL;
> +	}
> +	return ret;
> +}
[...]
> +static struct resource dm644x_v4l2_disp_resources[] = {
> +	{
> +		.start  = IRQ_VENCINT,
> +		.end    = IRQ_VENCINT,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start  = 0x01C724B8,
> +		.end    = 0x01C724B8 + 0x4,

    s/0x4/0x3/?

[...]
> +static struct platform_device dm644x_venc_dev = {
> +	.name           = VPBE_VENC_SUBDEV_NAME,
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(dm644x_venc_resources),
> +	.resource       = dm644x_venc_resources,
> +	.dev = {
> +		.dma_mask               =&dm644x_venc_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +		.platform_data          = (void *)&dm644x_venc_pdata,

    There's no need to explicitly cast to 'void *'.

WBR, Sergei
