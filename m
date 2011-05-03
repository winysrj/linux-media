Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39689 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1ECJPf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 05:15:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers
Date: Tue, 3 May 2011 11:16:03 +0200
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, kgene.kim@samsung.com,
	sungchun.kang@samsung.com, jonghun.han@samsung.com
References: <1303399264-3849-1-git-send-email-s.nawrocki@samsung.com> <1303399264-3849-4-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1303399264-3849-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031116.04467.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

Thanks for the patch.

On Thursday 21 April 2011 17:21:04 Sylwester Nawrocki wrote:
> Add the subdev driver for the MIPI CSIS units available in
> S5P and Exynos4 SoC series. This driver supports both CSIS0
> and CSIS1 MIPI-CSI2 receivers.
> The driver requires Runtime PM to be enabled for proper operation.

Then maybe it should depend on runtime PM ?

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

[snip]

> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 4f0ac2d..1da961a 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -939,6 +939,15 @@ config  VIDEO_SAMSUNG_S5P_FIMC
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called s5p-fimc.
> 
> +config VIDEO_S5P_MIPI_CSIS
> +	tristate "S5P and EXYNOS4 MIPI CSI Receiver driver"

Maybe "Samsung S5P and EXYNOS4" as well ?

> +	depends on VIDEO_V4L2 && VIDEO_SAMSUNG_S5P_FIMC && MEDIA_CONTROLLER
> +	---help---
> +	  This is a v4l2 driver for the S5P/EXYNOS4 MIPI-CSI Receiver.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called s5p-csis.
> +

[snip]

> diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c
> b/drivers/media/video/s5p-fimc/mipi-csis.c new file mode 100644
> index 0000000..6219754
> --- /dev/null
> +++ b/drivers/media/video/s5p-fimc/mipi-csis.c

[snip]

> +enum {
> +	CSIS_FMT_TRY,
> +	CSIS_FMT_ACTIVE,
> +	CSIS_NUM_FMTS
> +}

There's no need to define new TRY/ACTIVE constants, use the existing 
V4L2_SUBDEV_FORMAT_TRY and V4L2_SUBDEV_FORMAT_ACTIVE values.

> +struct csis_state {
> +	struct mutex lock;

checkpatch.pl requires mutexes to be documented. You should add a comment 
(here, or even better, before the structure, with the documentation of all 
memebers) that explains what the mutex protects.

> +	struct media_pad pads[CSIS_PADS_NUM];
> +	struct v4l2_subdev sd;
> +	struct platform_device *pdev;
> +	struct resource *regs_res;
> +	void __iomem *regs;
> +	struct clk *clock[NUM_CSIS_CLOCKS];
> +	int irq;
> +	struct regulator *supply;
> +	u32 flags;
> +	/* Common format for the source and sink pad. */
> +	const struct csis_pix_format *csis_fmt;
> +	struct v4l2_mbus_framefmt mf[CSIS_NUM_FMTS];

As try formats are stored in the file handle, and as the formats on the sink 
and source pads are identical, a single v4l2_mbus_framefmt will do here.

> +};

[snip]

> +struct csis_pix_format {
> +	enum v4l2_mbus_pixelcode code;
> +	u32 fmt_reg;
> +	u16 pix_hor_align;

You won't save memory by using a 16-bit integer here, and the code might be 
slower. I would go for a regular unsigned int.

> +};
> +
> +static const struct csis_pix_format s5pcsis_formats[] = {
> +	{
> +		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
> +		.fmt_reg	= S5PCSIS_CFG_FMT_YCBCR422_8BIT,
> +		.pix_hor_align	= 1,
> +	},
> +	{
> +		.code		= V4L2_MBUS_FMT_JPEG_1X8,
> +		.fmt_reg	= S5PCSIS_CFG_FMT_USER(1),
> +		.pix_hor_align	= 1,
> +	},
> +};

Do you plan to add formats with pix_hor_align != 1 ? If not you could remove 
the field completely.

> +#define csis_pad_valid(pad) (pad == CSIS_PAD_SOURCE || pad ==
> CSIS_PAD_SINK) +
> +static struct csis_state *sd_to_csis_state(struct v4l2_subdev *sdev)
> +{
> +	return container_of(sdev, struct csis_state, sd);
> +}
> +
> +static const struct csis_pix_format *find_csis_format(
> +	struct v4l2_mbus_framefmt *mf)
> +{
> +	int i = ARRAY_SIZE(s5pcsis_formats);
> +
> +	while (--i >= 0)

I'm curious, why do you search backward instead of doing the usual

for (i = 0; i < ARRAY_SIZE(s5pcsis_formats); ++i)

(in that case 'i' could be unsigned) ?

> +		if (mf->code == s5pcsis_formats[i].code)
> +			return &s5pcsis_formats[i];
> +
> +	return NULL;
> +}
> +
> +static void s5pcsis_enable_interrupts(struct csis_state *state, bool on)
> +{
> +	u32 reg = readl(state->regs + S5PCSIS_CTRL);

I haven't read the hardware spec, but shouldn't the register be S5PCSIS_INTMSK 
here ?

> +
> +	if (on)
> +		reg |= S5PCSIS_INTMSK_EN_ALL;
> +	else
> +		reg &= ~S5PCSIS_INTMSK_EN_ALL;
> +	writel(reg, state->regs + S5PCSIS_INTMSK);
> +}
> +
> +static void s5pcsis_reset(struct csis_state *state)
> +{
> +	u32 reg = readl(state->regs + S5PCSIS_CTRL);
> +
> +	writel(reg | S5PCSIS_CTRL_RESET, state->regs + S5PCSIS_CTRL);

Would the code be more readable if you defined macros or inline functions for 
the read, write and read-modify-write register operations ? Something like

s5pcsis_read(struct csis_state *state, u32 reg);
s5pcsis_write(struct csis_state *state, u32 reg, u32 value);
s5pcsis_clr(struct csis_state *state, u32 reg, u32 clr);
s5pcsis_set(struct csis_state *state, u32 reg, u32 set);
s5pcsis_clr_set(struct csis_state *state, u32 reg, u32 clr, u32 set);

> +	udelay(10);
> +}
> +
> +static void s5pcsis_system_enable(struct csis_state *state, int on)

s/int on/bool on/ ? I have no preference for int or bool in this case, it's 
just for consistency reasons as you use bool in s5pcsis_enable_interrupts().

> +{
> +	u32 reg;
> +
> +	reg = readl(state->regs + S5PCSIS_CTRL);
> +	if (on)
> +		reg |= S5PCSIS_CTRL_ENABLE;
> +	else
> +		reg &= ~S5PCSIS_CTRL_ENABLE;
> +	writel(reg, state->regs + S5PCSIS_CTRL);
> +
> +	reg = readl(state->regs + S5PCSIS_DPHYCTRL);
> +	if (on)
> +		reg |= S5PCSIS_DPHYCTRL_ENABLE;
> +	else
> +		reg &= ~S5PCSIS_DPHYCTRL_ENABLE;
> +	writel(reg, state->regs + S5PCSIS_DPHYCTRL);
> +}
> +
> +static int __s5pcsis_set_format(struct csis_state *state)
> +{
> +	struct v4l2_mbus_framefmt *mf = &state->mf[CSIS_FMT_ACTIVE];
> +	u32 reg;
> +
> +	v4l2_dbg(1, debug, &state->sd, "fmt: %d, %d x %d\n",
> +		 mf->code, mf->width, mf->height);
> +
> +	if (WARN_ON(state->csis_fmt == NULL))
> +		return -EINVAL;

This will happen if __s5pcsis_set_format() is called before s5pcsis_set_fmt(). 
You should set state->csis_fmt to a default value at initialization time and 
remove the check.

> +	/* Color format */
> +	reg = readl(state->regs + S5PCSIS_CONFIG);
> +	reg = (reg & ~S5PCSIS_CFG_FMT_MASK) | state->csis_fmt->fmt_reg;
> +	writel(reg, state->regs + S5PCSIS_CONFIG);
> +
> +	/* Pixel resolution */

Do you need to protect read access to state->mf, or do you guarantee that the 
functions that read and write it will be serialized by the caller ?

> +	reg = (mf->width << 16) | mf->height;
> +	writel(reg, state->regs + S5PCSIS_RESOL);
> +
> +	return 0;
> +}

[snip]

> +static int s5pcsis_set_params(struct csis_state *state)
> +{
> +	struct s5p_platform_mipi_csis *pdata = state->pdev->dev.platform_data;
> +	u32 reg, tmp;
> +	int ret;
> +
> +	reg = readl(state->regs + S5PCSIS_CONFIG);
> +	reg &= ~S5PCSIS_CFG_NR_LANE_MASK;
> +	tmp = (pdata->lanes - 1) & 0x3;

tmp is a bad name, you could do

reg |= (pdata->lanes - 1) & S5PCSIS_CFG_NR_LANE_MASK;

and get rid of tmp completely.

> +	writel(reg | tmp, state->regs + S5PCSIS_CONFIG);
> +
> +	ret = __s5pcsis_set_format(state);
> +	if (ret)
> +		return ret;
> +
> +	s5pcsis_set_hsync_settle(state, pdata->hs_settle);
> +
> +	reg = readl(state->regs + S5PCSIS_CTRL);
> +
> +	if (pdata->alignment == 32)
> +		reg |= S5PCSIS_CTRL_ALIGN_32BIT;
> +	else /* 24-bits */
> +		reg &= ~S5PCSIS_CTRL_ALIGN_32BIT;
> +
> +	/* Not using external clock. */
> +	reg &= ~S5PCSIS_CTRL_WCLK_EXTCLK;
> +
> +	writel(reg, state->regs + S5PCSIS_CTRL);
> +
> +	/* Update the shadow register. */
> +	reg = readl(state->regs + S5PCSIS_CTRL);
> +	writel(reg | S5PCSIS_CTRL_UPDATE_SHADOW,
> +	       state->regs + S5PCSIS_CTRL);
> +
> +	return 0;
> +}

[snip]

> +static void s5pcsis_clk_put(struct csis_state *state)
> +{
> +	int i;
> +
> +	for (i = 0; i < NUM_CSIS_CLOCKS; i++)
> +		if (!IS_ERR(state->clock[i]))
> +			clk_put(state->clock[i]);
> +}
> +
> +static int s5pcsis_clk_get(struct csis_state *state)
> +{
> +	struct device *dev = &state->pdev->dev;
> +	int i;
> +
> +	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
> +		state->clock[i] = clk_get(dev, csi_clock_name[i]);
> +
> +		if (IS_ERR(state->clock[i])) {
> +			s5pcsis_clk_put(state);

If an error occurs here, some clock will be equal to NULL. This won't be 
caught by the IS_ERR check in s5pcsis_clk_put(), so clk_put() will be called 
with a NULL argument. Is that guaranteed to be safe ?

> +			dev_err(dev, "failed to get clock: %s\n",
> +				csi_clock_name[i]);
> +			return -ENXIO;
> +		}
> +	}
> +	return 0;
> +}

[snip]

> +static void s5pcsis_try_format(struct v4l2_mbus_framefmt *mf)
> +{
> +	struct csis_pix_format const *csis_fmt;
> +
> +	csis_fmt = find_csis_format(mf);
> +	if (csis_fmt == NULL)
> +		csis_fmt = &s5pcsis_formats[0];
> +
> +	mf->code = csis_fmt->code;
> +	v4l_bound_align_image(&mf->width, 1, CSIS_MAX_PIX_WIDTH,
> +			      csis_fmt->pix_hor_align,
> +			      &mf->height, 1, CSIS_MAX_PIX_HEIGHT, 1,
> +			      0);
> +}
> +
> +static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> *fh, +			    struct v4l2_subdev_format *fmt)
> +{
> +	struct csis_state *state = sd_to_csis_state(sd);
> +	struct v4l2_mbus_framefmt *mf = &fmt->format;
> +	struct csis_pix_format const *csis_fmt = find_csis_format(mf);
> +
> +	v4l2_dbg(1, debug, sd, "%s: %dx%d, code: %x, csis_fmt: %p\n",
> +		 __func__, mf->width, mf->height, mf->code, csis_fmt);
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		s5pcsis_try_format(mf);

You need to take the pad into account here. As you mention below, source and 
sink formats are identical. When the user tries to set the source format, the 
driver should just return the sink format without performing any modification.

> +		state->mf[CSIS_FMT_TRY] = *mf;
> +		return 0;
> +	}
> +
> +	/* Both source and sink pad have always same format. */
> +	if (!csis_pad_valid(fmt->pad) ||
> +	    csis_fmt == NULL ||
> +	    mf->width > CSIS_MAX_PIX_WIDTH  ||
> +	    mf->height > CSIS_MAX_PIX_HEIGHT ||
> +	    mf->width & (u32)(csis_fmt->pix_hor_align - 1))
> +		return -EINVAL;

Don't return an error, adjust the user supplied format instead.

> +
> +	mutex_lock(&state->lock);
> +	state->mf[CSIS_FMT_ACTIVE] = *mf;
> +	state->csis_fmt = csis_fmt;
> +	mutex_unlock(&state->lock);

The logic in this function is not correct. First of all, you need to adjust 
the user-supplied format in all cases, regardless of the format type 
(try/active). Then, as the formats on the sink and source pads are always 
identical, you should return the sink pad format when the user tries to set 
the source pad format. Setting the source pad format will have no effect. 
Finally, you should store try formats in the subdev file handle, not in the 
csis_state structure (see ccp2_set_format() in 
drivers/media/video/omap3isp/ispccp2.c for an example, in your case you don't 
need to propagate the format change from sink to source, as the source always 
has the same format as the sink).

> +
> +	return 0;
> +}
> +
> +static int s5pcsis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> *fh, +			   struct v4l2_subdev_format *fmt)
> +{
> +	struct csis_state *state = sd_to_csis_state(sd);
> +	int index = fmt->which == V4L2_SUBDEV_FORMAT_TRY ?
> +				CSIS_FMT_TRY : CSIS_FMT_ACTIVE;
> +
> +	if (!csis_pad_valid(fmt->pad))
> +		return -EINVAL;
> +
> +	mutex_lock(&state->lock);
> +	fmt->format = state->mf[index];
> +	mutex_unlock(&state->lock);

Try formats should be stored in the subdev file handle.

If your caller guarantees that get/set format calls are serialized, you don't 
need to use a mutex.

> +
> +	return 0;
> +}

[snip]

> +/* Media operations */
> +static int csis_link_setup(struct media_entity *entity,
> +			   const struct media_pad *local,
> +			   const struct media_pad *remote, u32 flags)
> +{
> +	v4l2_dbg(1, debug, entity, "%s: entity: %s, flags: 0x%x\n",
> +		 __func__, entity->name, flags);
> +
> +	return 0;
> +}
> +
> +static const struct media_entity_operations csis_media_ops = {
> +	.link_setup = csis_link_setup,
> +};

If you define the link as immutable, the link_setup operation isn't required.

> +static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
> +{
> +	struct csis_state *state = dev_id;
> +	u32 reg;
> +
> +	/* Just clear the interrupt pending bits. */

What is the IRQ for then ?

> +	reg = readl(state->regs + S5PCSIS_INTSRC);
> +	writel(reg, state->regs + S5PCSIS_INTSRC);
> +
> +	return IRQ_HANDLED;
> +}

[snip]

-- 
Regards,

Laurent Pinchart
