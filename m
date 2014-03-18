Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2387 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaCRJdf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 05:33:35 -0400
Message-ID: <532812B0.6000109@xs4all.nl>
Date: Tue, 18 Mar 2014 10:32:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 36/48] adv7604: Make output format configurable through
 pad format operations
References: <1394493359-14115-37-git-send-email-laurent.pinchart@ideasonboard.com> <1394550634-25242-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394550634-25242-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I've tested it and I thought I was going crazy. Everything was fine after
applying this patch, but as soon as I applied the next patch (37/48) the
colors were wrong. But that patch had nothing whatsoever to do with the
bus ordering. You managed to make a small but crucial bug and it was pure
bad luck that it ever worked.

See details below:

On 03/11/14 16:10, Laurent Pinchart wrote:
> Replace the dummy video format operations by pad format operations that
> configure the output format.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/adv7604.c | 280 ++++++++++++++++++++++++++++++++++++++++----
>  include/media/adv7604.h     |  56 ++++-----
>  2 files changed, 275 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 851b350..5aa7c29 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -53,6 +53,28 @@ MODULE_LICENSE("GPL");
>  /* ADV7604 system clock frequency */
>  #define ADV7604_fsc (28636360)
>  
> +#define ADV7604_RGB_OUT					(1 << 1)
> +
> +#define ADV7604_OP_FORMAT_SEL_8BIT			(0 << 0)
> +#define ADV7604_OP_FORMAT_SEL_10BIT			(1 << 0)
> +#define ADV7604_OP_FORMAT_SEL_12BIT			(2 << 0)
> +
> +#define ADV7604_OP_MODE_SEL_SDR_422			(0 << 5)
> +#define ADV7604_OP_MODE_SEL_DDR_422			(1 << 5)
> +#define ADV7604_OP_MODE_SEL_SDR_444			(2 << 5)
> +#define ADV7604_OP_MODE_SEL_DDR_444			(3 << 5)
> +#define ADV7604_OP_MODE_SEL_SDR_422_2X			(4 << 5)
> +#define ADV7604_OP_MODE_SEL_ADI_CM			(5 << 5)
> +
> +#define ADV7604_OP_CH_SEL_GBR				(0 << 5)
> +#define ADV7604_OP_CH_SEL_GRB				(1 << 5)
> +#define ADV7604_OP_CH_SEL_BGR				(2 << 5)
> +#define ADV7604_OP_CH_SEL_RGB				(3 << 5)
> +#define ADV7604_OP_CH_SEL_BRG				(4 << 5)
> +#define ADV7604_OP_CH_SEL_RBG				(5 << 5)

Note that these values are shifted 5 bits to the left...

> +
> +#define ADV7604_OP_SWAP_CB_CR				(1 << 0)
> +
>  enum adv7604_type {
>  	ADV7604,
>  	ADV7611,
> @@ -63,6 +85,14 @@ struct adv7604_reg_seq {
>  	u8 val;
>  };
>  
> +struct adv7604_format_info {
> +	enum v4l2_mbus_pixelcode code;
> +	u8 op_ch_sel;
> +	bool rgb_out;
> +	bool swap_cb_cr;
> +	u8 op_format_sel;
> +};
> +
>  struct adv7604_chip_info {
>  	enum adv7604_type type;
>  
> @@ -78,6 +108,9 @@ struct adv7604_chip_info {
>  	unsigned int tdms_lock_mask;
>  	unsigned int fmt_change_digital_mask;
>  
> +	const struct adv7604_format_info *formats;
> +	unsigned int nformats;
> +
>  	void (*set_termination)(struct v4l2_subdev *sd, bool enable);
>  	void (*setup_irqs)(struct v4l2_subdev *sd);
>  	unsigned int (*read_hdmi_pixelclock)(struct v4l2_subdev *sd);
> @@ -101,12 +134,18 @@ struct adv7604_chip_info {
>  struct adv7604_state {
>  	const struct adv7604_chip_info *info;
>  	struct adv7604_platform_data pdata;
> +
>  	struct v4l2_subdev sd;
>  	struct media_pad pads[ADV7604_PAD_MAX];
>  	unsigned int source_pad;
> +
>  	struct v4l2_ctrl_handler hdl;
> +
>  	enum adv7604_pad selected_input;
> +
>  	struct v4l2_dv_timings timings;
> +	const struct adv7604_format_info *format;
> +
>  	struct {
>  		u8 edid[256];
>  		u32 present;
> @@ -771,6 +810,93 @@ static void adv7604_write_reg_seq(struct v4l2_subdev *sd,
>  		adv7604_write_reg(sd, reg_seq[i].reg, reg_seq[i].val);
>  }
>  
> +/* -----------------------------------------------------------------------------
> + * Format helpers
> + */
> +
> +static const struct adv7604_format_info adv7604_formats[] = {
> +	{ V4L2_MBUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
> +	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YUYV10_2X10, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
> +	{ V4L2_MBUS_FMT_YVYU10_2X10, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
> +	{ V4L2_MBUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_UYVY10_1X20, ADV7604_OP_CH_SEL_RBG, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
> +	{ V4L2_MBUS_FMT_VYUY10_1X20, ADV7604_OP_CH_SEL_RBG, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
> +	{ V4L2_MBUS_FMT_YUYV10_1X20, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
> +	{ V4L2_MBUS_FMT_YVYU10_1X20, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
> +	{ V4L2_MBUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
> +};
> +
> +static const struct adv7604_format_info adv7611_formats[] = {
> +	{ V4L2_MBUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
> +	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
> +	{ V4L2_MBUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
> +	{ V4L2_MBUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
> +};
> +
> +static const struct adv7604_format_info *
> +adv7604_format_info(struct adv7604_state *state, enum v4l2_mbus_pixelcode code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < state->info->nformats; ++i) {
> +		if (state->info->formats[i].code == code)
> +			return &state->info->formats[i];
> +	}
> +
> +	return NULL;
> +}
> +
>  /* ----------------------------------------------------------------------- */
>  
>  static inline bool is_analog_input(struct v4l2_subdev *sd)
> @@ -1720,29 +1846,132 @@ static int adv7604_s_routing(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> -static int adv7604_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
> -			     enum v4l2_mbus_pixelcode *code)
> +static int adv7604_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_mbus_code_enum *code)
>  {
> -	if (index)
> +	struct adv7604_state *state = to_state(sd);
> +
> +	if (code->index >= state->info->nformats)
>  		return -EINVAL;
> -	/* Good enough for now */
> -	*code = V4L2_MBUS_FMT_FIXED;
> +
> +	code->code = state->info->formats[code->index].code;
> +
>  	return 0;
>  }
>  
> -static int adv7604_g_mbus_fmt(struct v4l2_subdev *sd,
> -		struct v4l2_mbus_framefmt *fmt)
> +static void adv7604_fill_format(struct adv7604_state *state,
> +				struct v4l2_mbus_framefmt *format)
>  {
> -	struct adv7604_state *state = to_state(sd);
> +	memset(format, 0, sizeof(*format));
>  
> -	fmt->width = state->timings.bt.width;
> -	fmt->height = state->timings.bt.height;
> -	fmt->code = V4L2_MBUS_FMT_FIXED;
> -	fmt->field = V4L2_FIELD_NONE;
> -	if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
> -		fmt->colorspace = (state->timings.bt.height <= 576) ?
> +	format->width = state->timings.bt.width;
> +	format->height = state->timings.bt.height;
> +	format->field = V4L2_FIELD_NONE;
> +
> +	if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861)
> +		format->colorspace = (state->timings.bt.height <= 576) ?
>  			V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
> +}
> +
> +/*
> + * Compute the op_ch_sel value required to obtain on the bus the component order
> + * corresponding to the selected format taking into account bus reordering
> + * applied by the board at the output of the device.
> + *
> + * The following table gives the op_ch_value from the format component order
> + * (expressed as op_ch_sel value in column) and the bus reordering (expressed as
> + * adv7604_bus_order value in row).
> + *
> + *           |	GBR(0)	GRB(1)	BGR(2)	RGB(3)	BRG(4)	RBG(5)
> + * ----------+-------------------------------------------------
> + * RGB (NOP) |	GBR	GRB	BGR	RGB	BRG	RBG
> + * GRB (1-2) |	BGR	RGB	GBR	GRB	RBG	BRG
> + * RBG (2-3) |	GRB	GBR	BRG	RBG	BGR	RGB
> + * BGR (1-3) |	RBG	BRG	RGB	BGR	GRB	GBR
> + * BRG (ROR) |	BRG	RBG	GRB	GBR	RGB	BGR
> + * GBR (ROL) |	RGB	BGR	RBG	BRG	GBR	GRB
> + */
> +static unsigned int adv7604_op_ch_sel(struct adv7604_state *state)
> +{
> +#define _SEL(a,b,c,d,e,f)	{ \
> +	ADV7604_OP_CH_SEL_##a, ADV7604_OP_CH_SEL_##b, ADV7604_OP_CH_SEL_##c, \
> +	ADV7604_OP_CH_SEL_##d, ADV7604_OP_CH_SEL_##e, ADV7604_OP_CH_SEL_##f }
> +#define _BUS(x)			[ADV7604_BUS_ORDER_##x]
> +
> +	static const unsigned int op_ch_sel[6][6] = {
> +		_BUS(RGB) /* NOP */ = _SEL(GBR, GRB, BGR, RGB, BRG, RBG),
> +		_BUS(GRB) /* 1-2 */ = _SEL(BGR, RGB, GBR, GRB, RBG, BRG),
> +		_BUS(RBG) /* 2-3 */ = _SEL(GRB, GBR, BRG, RBG, BGR, RGB),
> +		_BUS(BGR) /* 1-3 */ = _SEL(RBG, BRG, RGB, BGR, GRB, GBR),
> +		_BUS(BRG) /* ROR */ = _SEL(BRG, RBG, GRB, GBR, RGB, BGR),
> +		_BUS(GBR) /* ROL */ = _SEL(RGB, BGR, RBG, BRG, GBR, GRB),
> +	};
> +
> +	return op_ch_sel[state->pdata.bus_order][state->format->op_ch_sel];

But you don't shift state->format->op_ch_sel back 5 bits to the right, so
you end up with a random memory value. It should be:

	return op_ch_sel[state->pdata.bus_order][state->format->op_ch_sel >> 5];

After correcting this everything worked fine for me.

Regards,

	Hans
