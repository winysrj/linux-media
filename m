Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:59948 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab0KLPnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 10:43:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/10] MCDE: Add hardware abstraction layer
Date: Fri, 12 Nov 2010 16:43:52 +0100
Cc: Jimmy Rubin <jimmy.rubin@stericsson.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	Dan Johansson <dan.johansson@stericsson.com>,
	Linus Walleij <linus.walleij@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121643.52923.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 10 November 2010, Jimmy Rubin wrote:
> This patch adds support for MCDE, Memory-to-display controller
> found in the ST-Ericsson ux500 products.

Hi Jimmy,

I haven't looked at what this device does, but I've tried to do
a review based on coding style and common practices. I hope this
is useful to you.

> This patch adds the hardware abstraction layer.
> All calls to the hardware is handled in mcde_hw.c

A "hardware abstraction layer" is generally considered a bad thing,
you're usually better off not advertising your code as being one.

As a rule, the device driver *is* the hardware abstraction, so you
should not add another one ;-)

> +static void disable_channel(struct mcde_chnl_state *chnl);
> +static void enable_channel(struct mcde_chnl_state *chnl);
> +static void watchdog_auto_sync_timer_function(unsigned long arg);

I generally recomment avoiding forward declarations of static functions.
Just reorder the code so you don't need them.

> +u8 *mcdeio;
> +u8 **dsiio;
> +DEFINE_SPINLOCK(mcde_lock); /* REVIEW: Remove or use */
> +struct platform_device *mcde_dev;
> +u8 num_dsilinks;

You should try hard to avoid global variables in a well-designed driver.
There are many ways around them, like accessor functions or splitting the
driver into files in a more logical way where each file only accesses
its own data. If you really cannot think of a way to avoid these,
put them in a proper name space in the way that you have done for the
global functions, by prefixing each identifier with "mcde_".

> +static u8 hardware_version;
> +
> +static struct regulator *regulator;
> +static struct clk *clock_dsi;
> +static struct clk *clock_mcde;
> +static struct clk *clock_dsi_lp;
> +static u8 mcde_is_enabled;

Even static variables like these can cause problems. Ideally all of these
are referenced through a driver private data structure that is passed around
with the device. This way you can trivially support multiple devices if 
that ever becomes necessary.

> +static inline u32 dsi_rreg(int i, u32 reg)
> +{
> +	return readl(dsiio[i] + reg);
> +}
> +static inline void dsi_wreg(int i, u32 reg, u32 val)
> +{
> +	writel(val, dsiio[i] + reg);
> +}

dsiio is not marked __iomem, so there is something wrong here.
Moreover, why do you need two indexes? If you have multiple identical
"dsiio" structures, maybe each of them should just be a device by itself?

> +struct mcde_ovly_state {
> +	bool inuse;
> +	u8 idx; /* MCDE overlay index */
> +	struct mcde_chnl_state *chnl; /* Owner channel */
> +	u32 transactionid; /* Apply time stamp */
> +	u32 transactionid_regs; /* Register update time stamp */
> +	u32 transactionid_hw; /* HW completed time stamp */
> +	wait_queue_head_t waitq_hw; /* Waitq for transactionid_hw */
> +
> +	/* Staged settings */
> +	u32 paddr;
> +	u16 stride;
> +	enum mcde_ovly_pix_fmt pix_fmt;
> +
> +	u16 src_x;
> +	u16 src_y;
> +	u16 dst_x;
> +	u16 dst_y;
> +	u16 dst_z;
> +	u16 w;
> +	u16 h;
> +
> +	/* Applied settings */
> +	struct ovly_regs regs;
> +};

There should probably be a "struct device" pointer in this, so you can pass
it around as a real object.

> +	/* Handle channel irqs */
> +	irq_status = mcde_rreg(MCDE_RISPP);
> +	if (irq_status & MCDE_RISPP_VCMPARIS_MASK) {
> +		chnl = &channels[MCDE_CHNL_A];
> ...
> +	}
> +	if (irq_status & MCDE_RISPP_VCMPBRIS_MASK) {
> +		chnl = &channels[MCDE_CHNL_B];
> ...
> +	}
> +	if (irq_status & MCDE_RISPP_VCMPC0RIS_MASK) {
> +		chnl = &channels[MCDE_CHNL_C0];
> ...
> +	}

This looks a bit like you actually have multiple interrupt lines multiplexed
through a private interrupt controller. Have you considered making this controller
a separate device to multiplex the interrupt numbers?

> +void wait_for_overlay(struct mcde_ovly_state *ovly)

Not an appropriate name for a global function. Either make this static or
call it mcde_wait_for_overlay. Same for some other functions.

> +#ifdef CONFIG_AV8100_SDTV
> +	/* TODO: check if these watermark levels work for HDMI as well. */
> +	pixelfetchwtrmrklevel = MCDE_PIXFETCH_SMALL_WTRMRKLVL;
> +#else
> +	if ((fifo == MCDE_FIFO_A || fifo == MCDE_FIFO_B) &&
> +					regs->ppl >= fifo_size * 2)
> +		pixelfetchwtrmrklevel = MCDE_PIXFETCH_LARGE_WTRMRKLVL;
> +	else
> +		pixelfetchwtrmrklevel = MCDE_PIXFETCH_MEDIUM_WTRMRKLVL;
> +#endif /* CONFIG_AV8100_SDTV */

Be careful with config options like this. If you want to build a kernel
to run on all machines, the first part probably needs to check where it
is running and consider the other pixelfetchwtrmrklevel values as well.

> +/* Channel path */
> +#define MCDE_CHNLPATH(__chnl, __fifo, __type, __ifc, __link) \
> +	(((__chnl) << 16) | ((__fifo) << 12) | \
> +	 ((__type) << 8) | ((__ifc) << 4) | ((__link) << 0))
> +enum mcde_chnl_path {
> +	/* Channel A */
> +	MCDE_CHNLPATH_CHNLA_FIFOA_DPI_0 = MCDE_CHNLPATH(MCDE_CHNL_A,
> +		MCDE_FIFO_A, MCDE_PORTTYPE_DPI, 0, 0),
> +	MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC0_0 = MCDE_CHNLPATH(MCDE_CHNL_A,
> +		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 0, 0),
> +	MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC0_1 = MCDE_CHNLPATH(MCDE_CHNL_A,
> +		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 0, 1),
> +	MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC0_2 = MCDE_CHNLPATH(MCDE_CHNL_A,
> +		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 0, 2),
> +	MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC1_0 = MCDE_CHNLPATH(MCDE_CHNL_A,
> +		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 1, 0),
> +	MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC1_1 = MCDE_CHNLPATH(MCDE_CHNL_A,
> +		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 1, 1),
> +	MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC1_2 = MCDE_CHNLPATH(MCDE_CHNL_A,
> +		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 1, 2),

A table like this would become more readable by making each entry a single line,
even if that goes beyond the 80-character limit.

	Arnd
