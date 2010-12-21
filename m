Return-path: <mchehab@gaivota>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:36831 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0LUL6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 06:58:30 -0500
Received: by eyg5 with SMTP id 5so1994898eyg.2
        for <linux-media@vger.kernel.org>; Tue, 21 Dec 2010 03:58:29 -0800 (PST)
Message-ID: <4D109625.6050301@mvista.com>
Date: Tue, 21 Dec 2010 14:57:25 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v8 5/8] davinci vpbe: platform specific additions
References: <1292853280-2617-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1292853280-2617-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello.

On 20-12-2010 16:54, Manjunath Hadli wrote:

> This patch implements the overall device creation for the Video
> display driver

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index 5e5b0a7..e8b8e94 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -640,6 +640,142 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
>   	vpfe_capture_dev.dev.platform_data = cfg;
>   }
>
> +static struct resource dm644x_osd_resources[] = {
> +	{
> +		.start  = 0x01C72600,
> +		.end    = 0x01C72600 + 0x200,
                                        ^^^^^^
    Rather 0x1ff? Else it looks like off-by-one error.

> +		.flags  = IORESOURCE_MEM,
> +	},
> +};
[...]
> +static struct resource dm644x_venc_resources[] = {
> +	/* venc registers io space */
> +	{
> +		.start  = 0x01C72400,
> +		.end    = 0x01C72400 + 0x180,

    Same here...

> +		.flags  = IORESOURCE_MEM,
> +	},
> +};
> +
> +static u64 dm644x_venc_dma_mask = DMA_BIT_MASK(32);
> +
> +#define VPSS_CLKCTL     0x01C40044

    Empty line here, please.

> +static void __iomem *vpss_clkctl_reg;
> +
> +/* TBD. Check what VENC_CLOCK_SEL settings for HDTV and EDTV */
> +static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type, __u64 mode)
> +{
> +	int ret = 0;
> +
> +	if (NULL == vpss_clkctl_reg)
> +		return -EINVAL;
> +	if (type == VPBE_ENC_STD) {

    *switch* would look more natural here.

> +		__raw_writel(0x18, vpss_clkctl_reg);
> +	} else if (type == VPBE_ENC_DV_PRESET) {
> +		switch ((unsigned int)mode) {
> +		case V4L2_DV_480P59_94:
> +		case V4L2_DV_576P50:
> +			 __raw_writel(0x19, vpss_clkctl_reg);
> +			break;
> +		case V4L2_DV_720P60:
> +		case V4L2_DV_1080I60:
> +		case V4L2_DV_1080P30:
> +		/*
> +		* For HD, use external clock source since HD requires higher
> +		* clock rate
> +		*/

    Please indent the comment properly. And the preferred style is this:

			/*
			 * For HD, use external clock source since HD
			 * requires higher clock rate
			 */

> +			__raw_writel(0xa, vpss_clkctl_reg);
> +			break;
> +		default:
> +			ret  = -EINVAL;
> +			break;
> +		}
> +	} else
> +		ret  = -EINVAL;
> +
> +	return ret;
> +}
> +
> +

    One empty line too many?

> +static inline u32 dm644x_reg_modify(void *reg, u32 val, u32 mask)
> +{
> +	u32 new_val = (__raw_readl(reg) & ~mask) | (val & mask);
> +	__raw_writel(new_val, reg);
> +	return new_val;
> +}
> +
> +static u64 vpbe_display_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct resource dm644x_v4l2_disp_resources[] = {
> +	{
> +		.start  = IRQ_VENCINT,
> +		.end    = IRQ_VENCINT,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start  = 0x01C72400,

    Haven't you already declared resources with the same base address?

> +		.end    = 0x01C72400 + 0x180,
                                        ^^^^^ 0x17f?

> +		.flags  = IORESOURCE_MEM,
> +	},
> +
> +};

    Empty line wouldn't hurt here...

> +static struct platform_device dm644x_venc_dev = {
> +	.name           = VPBE_VENC_SUBDEV_NAME,
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(dm644x_venc_resources),
> +	.resource       = dm644x_venc_resources,
> +	.dev = {
> +		.dma_mask               =&dm644x_venc_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +		.platform_data          = (void *)&dm644x_venc_pdata,

    There's no need to cast to 'void *' explicitly.

> @@ -767,20 +903,36 @@ void __init dm644x_init(void)
[...]
> +static int __init dm644x_init_video(void)
> +{
> +	/* Add ccdc clock aliases */
> +	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
> +	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
> +	vpss_clkctl_reg = ioremap_nocache(VPSS_CLKCTL, 4);

    ioremap_nocache() can fail -- you should check the result.

WBR, Sergei
