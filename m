Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:56052 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1CNIpw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 04:45:52 -0400
Date: Mon, 14 Mar 2011 09:28:22 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH v2 2/8] ARM: S5PV310: Add clock support for MFC v5.1
In-reply-to: <1299676567-14194-3-git-send-email-jtp.park@samsung.com>
To: 'Jeongtae Park' <jtp.park@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: jaeryul.oh@samsung.com, kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002701cbe221$cb3de360$61b9aa20$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
 <1299676567-14194-3-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

It looks ok for me. Thanks for fixing the clock patch.

> From: Jeongtae Park [mailto:jtp.park@samsung.com]
> Subject: [PATCH v2 2/8] ARM: S5PV310: Add clock support for MFC v5.1
> 
> This patch adds clock support for MFC v5.1.
> 
> Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
> Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> ---
>  arch/arm/mach-s5pv310/clock.c                   |   68
> +++++++++++++++++++++++
>  arch/arm/mach-s5pv310/include/mach/regs-clock.h |    3 +
>  2 files changed, 71 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s5pv310/clock.c b/arch/arm/mach-
> s5pv310/clock.c
> index fc7c2f8..88c7943 100644
> --- a/arch/arm/mach-s5pv310/clock.c
> +++ b/arch/arm/mach-s5pv310/clock.c
> @@ -86,6 +86,11 @@ static int s5pv310_clk_ip_cam_ctrl(struct clk *clk,
> int enable)
>  	return s5p_gatectrl(S5P_CLKGATE_IP_CAM, clk, enable);
>  }
> 
> +static int s5pv310_clk_ip_mfc_ctrl(struct clk *clk, int enable)
> +{
> +	return s5p_gatectrl(S5P_CLKGATE_IP_MFC, clk, enable);
> +}
> +
>  static int s5pv310_clk_ip_image_ctrl(struct clk *clk, int enable)
>  {
>  	return s5p_gatectrl(S5P_CLKGATE_IP_IMAGE, clk, enable);
> @@ -417,6 +422,11 @@ static struct clk init_clocks_off[] = {
>  		.enable		= s5pv310_clk_ip_cam_ctrl,
>  		.ctrlbit	= (1 << 2),
>  	}, {
> +		.name		= "mfc",
> +		.id		= -1,
> +		.enable		= s5pv310_clk_ip_mfc_ctrl,
> +		.ctrlbit	= (1 << 0),
> +	}, {
>  		.name		= "fimc",
>  		.id		= 3,
>  		.enable		= s5pv310_clk_ip_cam_ctrl,
> @@ -643,6 +653,54 @@ static struct clksrc_sources clkset_group = {
>  	.nr_sources	= ARRAY_SIZE(clkset_group_list),
>  };
> 
> +static struct clk *clkset_mout_mfc0_list[] = {
> +	[0] = &clk_mout_mpll.clk,
> +	[1] = &clk_sclk_apll.clk,
> +};
> +
> +static struct clksrc_sources clkset_mout_mfc0 = {
> +	.sources	= clkset_mout_mfc0_list,
> +	.nr_sources	= ARRAY_SIZE(clkset_mout_mfc0_list),
> +};
> +
> +static struct clksrc_clk clk_mout_mfc0 = {
> +	.clk	= {
> +		.name		= "mout_mfc0",
> +		.id		= -1,
> +	},
> +	.sources	= &clkset_mout_mfc0,
> +	.reg_src	= { .reg = S5P_CLKSRC_MFC, .shift = 0, .size = 1 },
> +};
> +
> +static struct clk *clkset_mout_mfc1_list[] = {
> +	[0] = &clk_mout_epll.clk,
> +	[1] = &clk_sclk_vpll.clk,
> +};
> +
> +static struct clksrc_sources clkset_mout_mfc1 = {
> +	.sources	= clkset_mout_mfc1_list,
> +	.nr_sources	= ARRAY_SIZE(clkset_mout_mfc1_list),
> +};
> +
> +static struct clksrc_clk clk_mout_mfc1 = {
> +	.clk	= {
> +		.name		= "mout_mfc1",
> +		.id		= -1,
> +	},
> +	.sources	= &clkset_mout_mfc1,
> +	.reg_src	= { .reg = S5P_CLKSRC_MFC, .shift = 4, .size = 1 },
> +};
> +
> +static struct clk *clkset_mout_mfc_list[] = {
> +	[0] = &clk_mout_mfc0.clk,
> +	[1] = &clk_mout_mfc1.clk,
> +};
> +
> +static struct clksrc_sources clkset_mout_mfc = {
> +	.sources	= clkset_mout_mfc_list,
> +	.nr_sources	= ARRAY_SIZE(clkset_mout_mfc_list),
> +};
> +
>  static struct clk *clkset_mout_g2d0_list[] = {
>  	[0] = &clk_mout_mpll.clk,
>  	[1] = &clk_sclk_apll.clk,
> @@ -814,6 +872,14 @@ static struct clksrc_clk clksrcs[] = {
>  		.reg_div = { .reg = S5P_CLKDIV_CAM, .shift = 28, .size = 4
> },
>  	}, {
>  		.clk		= {
> +			.name		= "sclk_mfc",
> +			.id		= -1,
> +		},
> +		.sources = &clkset_mout_mfc,
> +		.reg_src = { .reg = S5P_CLKSRC_MFC, .shift = 8, .size = 1
> },
> +		.reg_div = { .reg = S5P_CLKDIV_MFC, .shift = 0, .size = 4
> },
> +	}, {
> +		.clk		= {
>  			.name		= "sclk_cam",
>  			.id		= 0,
>  			.enable		= s5pv310_clksrc_mask_cam_ctrl,
> @@ -1018,6 +1084,8 @@ static struct clksrc_clk *sysclks[] = {
>  	&clk_dout_mmc2,
>  	&clk_dout_mmc3,
>  	&clk_dout_mmc4,
> +	&clk_mout_mfc0,
> +	&clk_mout_mfc1,
>  };
> 
>  static int xtal_rate;
> diff --git a/arch/arm/mach-s5pv310/include/mach/regs-clock.h
> b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
> index b5c4ada..27b02e8 100644
> --- a/arch/arm/mach-s5pv310/include/mach/regs-clock.h
> +++ b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
> @@ -33,6 +33,7 @@
>  #define S5P_CLKSRC_TOP0			S5P_CLKREG(0x0C210)
>  #define S5P_CLKSRC_TOP1			S5P_CLKREG(0x0C214)
>  #define S5P_CLKSRC_CAM			S5P_CLKREG(0x0C220)
> +#define S5P_CLKSRC_MFC			S5P_CLKREG(0x0C228)
>  #define S5P_CLKSRC_IMAGE		S5P_CLKREG(0x0C230)
>  #define S5P_CLKSRC_LCD0			S5P_CLKREG(0x0C234)
>  #define S5P_CLKSRC_LCD1			S5P_CLKREG(0x0C238)
> @@ -42,6 +43,7 @@
> 
>  #define S5P_CLKDIV_TOP			S5P_CLKREG(0x0C510)
>  #define S5P_CLKDIV_CAM			S5P_CLKREG(0x0C520)
> +#define S5P_CLKDIV_MFC			S5P_CLKREG(0x0C528)
>  #define S5P_CLKDIV_IMAGE		S5P_CLKREG(0x0C530)
>  #define S5P_CLKDIV_LCD0			S5P_CLKREG(0x0C534)
>  #define S5P_CLKDIV_LCD1			S5P_CLKREG(0x0C538)
> @@ -67,6 +69,7 @@
>  #define S5P_CLKDIV_STAT_TOP		S5P_CLKREG(0x0C610)
> 
>  #define S5P_CLKGATE_IP_CAM		S5P_CLKREG(0x0C920)
> +#define S5P_CLKGATE_IP_MFC		S5P_CLKREG(0x0C928)
>  #define S5P_CLKGATE_IP_IMAGE		S5P_CLKREG(0x0C930)
>  #define S5P_CLKGATE_IP_LCD0		S5P_CLKREG(0x0C934)
>  #define S5P_CLKGATE_IP_LCD1		S5P_CLKREG(0x0C938)
> --
> 1.7.1

