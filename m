Return-path: <mchehab@pedra>
Received: from mail.perches.com ([173.55.12.10]:4921 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab0KJROi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 12:14:38 -0500
Subject: Re: [PATCH 01/10] MCDE: Add hardware abstraction layer
From: Joe Perches <joe@perches.com>
To: Jimmy Rubin <jimmy.rubin@stericsson.com>
Cc: linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	Dan Johansson <dan.johansson@stericsson.com>,
	Linus Walleij <linus.walleij@stericsson.com>
In-Reply-To: <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
	 <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 09:14:36 -0800
Message-ID: <1289409276.15905.65.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2010-11-10 at 13:04 +0100, Jimmy Rubin wrote:
> This patch adds support for MCDE, Memory-to-display controller
> found in the ST-Ericsson ux500 products.

Just trivia:

> diff --git a/drivers/video/mcde/mcde_hw.c b/drivers/video/mcde/mcde_hw.c

[]

> +#define dsi_rfld(__i, __reg, __fld) \
> +	((dsi_rreg(__i, __reg) & __reg##_##__fld##_MASK) >> \
> +		__reg##_##__fld##_SHIFT)
> +#define dsi_wfld(__i, __reg, __fld, __val) \
> +	dsi_wreg(__i, __reg, (dsi_rreg(__i, __reg) & \
> +	~__reg##_##__fld##_MASK) | (((__val) << __reg##_##__fld##_SHIFT) & \
> +		 __reg##_##__fld##_MASK))

These macros are not particularly readable.
Perhaps use statement expression macros like:

#define dsi_rfld(__i, __reg, __fld) 					\
({									\
	const u32 mask = __reg##_#__fld##_MASK;				\
	const u32 shift = __reg##_##__fld##_SHIFT;			\
	((dsi_rreg(__i, __reg) & mask) >> shift;			\
})

#define dsi_wfld(__i, __reg, __fld, __val)				\
({									\
	const u32 mask = __reg##_#__fld##_MASK;				\
	const u32 shift = __reg##_##__fld##_SHIFT;			\
	dsi_wreg(__i, __reg,						\
		 (dsi_rreg(__i, __reg) & ~mask) | (((__val) << shift) & mask));\
})

> +static struct mcde_chnl_state channels[] = {

Should more static structs be static const?

[]

> +	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);

If your dev_<level> logging messages use "%s", __func__
I suggest you use a set of local macros to preface this.

I don't generally find the function name useful.

Maybe only use the %s __func__ pair when you are also
setting verbose debugging.

#ifdef VERBOSE_DEBUG
#define mcde_printk(level, dev, fmt, args) \
	dev_printk(level, dev, "%s: " fmt, __func__, ##args)
#else
#define mcde_printk(level, dev, fmt, args) \
	dev_printk(level, dev, fmt, args)
#endif

#ifdef VERBOSE_DEBUG
#define mcde_vdbg(dev, fmt, args) \
	mcde_printk(KERN_DEBUG, dev, fmt, ##args)
#else
#define mcde_vdbg(dev, fmt, args) \
	do { if (0) mcde_printk(KERN_DEBUG, dev, fmt, ##args); } while (0)
#endif

#ifdef DEBUG
#define mcde_dbg(dev, fmt, args) \
	mcde_printk(KERN_DEBUG, dev, fmt, ##args)
#else
#define mcde_dbg(dev, fmt, args) \
	do { if (0) mcde_printk(KERN_DEBUG, dev, fmt, ##args); } while (0)
#endif

#define mcde_ERR(dev, fmt, args) \
	mcde_printk(KERN_ERR, dev, fmt, ##args)
#define mcde_warn(dev, fmt, args) \
	mcde_printk(KERN_WARNING, dev, fmt, ##args)
#define mcde_info(dev, fmt, args) \
	mcde_printk(KERN_INFO, dev, fmt, ##args)

> +static void disable_channel(struct mcde_chnl_state *chnl)
> +{
> +	int i;
> +	const struct mcde_port *port = &chnl->port;
> +
> +	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
> +
> +	if (hardware_version == MCDE_CHIP_VERSION_3_0_8 &&
> +				!is_channel_enabled(chnl)) {
> +		chnl->continous_running = false;

It'd be nice to change to continuous_running

> +int mcde_dsi_dcs_write(struct mcde_chnl_state *chnl, u8 cmd, u8* data, int len)
> +{
> +	int i;
> +	u32 wrdat[4] = { 0, 0, 0, 0 };
> +	u32 settings;
> +	u8 link = chnl->port.link;
> +	u8 virt_id = chnl->port.phy.dsi.virt_id;
> +
> +	/* REVIEW: One command at a time */
> +	/* REVIEW: Allow read/write on unreserved ports */
> +	if (len > MCDE_MAX_DCS_WRITE || chnl->port.type != MCDE_PORTTYPE_DSI)
> +		return -EINVAL;
> +
> +	wrdat[0] = cmd;
> +	for (i = 1; i <= len; i++)
> +		wrdat[i>>2] |= ((u32)data[i-1] << ((i & 3) * 8));

Ever overrun wrdat?
Maybe WARN_ON(len > 16, "oops?")


