Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33692 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3F0P5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 11:57:34 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MP2000HT6ZMW750@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Jun 2013 16:57:32 +0100 (BST)
Message-id: <51CC60EA.1010706@samsung.com>
Date: Thu, 27 Jun 2013 17:57:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC v3] s5k5baf: add camera sensor driver
References: <1370432696-24762-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1370432696-24762-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On 06/05/2013 01:44 PM, Andrzej Hajda wrote:
> Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
> with embedded SoC ISP.
> The driver exposes the sensor as two V4L2 subdevices:
> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
>   no controls.
> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
>   pre/post ISP cropping, downscaling via selection API, controls.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v3:
> - narrowed state->error usage to i2c and power errors,

Hmm, there still seems to be quite a few functions that use state->error
and IMHO it would be better if those just return the result directly.
How about changing at least these:

static void s5k5baf_check_fw_revision(struct s5k5baf *state)
static void s5k5baf_hw_set_video_bus(struct s5k5baf *state)
static void s5k5baf_power_on(struct s5k5baf *state)
static void s5k5baf_power_off(struct s5k5baf *state)
static void s5k5baf_hw_set_crop_rects(struct s5k5baf *state)

to return result directly ?

Personally I would also convert functins used in s5k5baf_s_ctrl()
handler:
	s5k5baf_hw_set_awb()
	s5k5baf_hw_set_colorfx()
	s5k5baf_hw_set_auto_exposure()
	s5k5baf_hw_set_mirror()
	s5k5baf_hw_set_anti_flicker()
	s5k5baf_hw_set_test_pattern()

And have state->err cleared at beginning of s5k5baf_s_ctrl().
But I'll probably not complain if those are left as they are. :)

> - private gain controls replaced by red/blue balance user controls,
> - added checks to devicetree gpio node parsing
> 
> v2:
> - lower-cased driver name,
> - removed underscore from regulator names,
> - removed platform data code,
> - v4l controls grouped in anonymous structs,
> - added s5k5baf_clear_error function,
> - private controls definitions moved to uapi header file,
> - added v4l2-controls.h reservation for private controls,
> - corrected subdev registered/unregistered code,
> - .log_status sudbev op set to v4l2 helper,
> - moved entity link creation to probe routines,
> - added cleanup on error to probe function.
> ---
>  .../devicetree/bindings/media/samsung-s5k5baf.txt  |   53 +
>  MAINTAINERS                                        |    7 +
>  drivers/media/i2c/Kconfig                          |    7 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/s5k5baf.c                        | 1979 ++++++++++++++++++++
>  5 files changed, 2047 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>  create mode 100644 drivers/media/i2c/s5k5baf.c
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt 
> b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> new file mode 100644
> index 0000000..0e46743
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> @@ -0,0 +1,53 @@
> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
> +-------------------------------------------------------------
> +
> +Required properties:
> +
> +- compatible	  : "samsung,s5k5baf";
> +- reg		  : i2c slave address of the sensor;

i2c should be capitalized.

[...]
> +/* Auto-algorithms enable mask */
> +#define REG_DBG_AUTOALG_EN		0x03f8
> +#define  AALG_ALL_EN			BIT(0)
> +#define  AALG_AE_EN			BIT(1)
> +#define  AALG_DIVLEI_EN			BIT(2)
> +#define  AALG_WB_EN			BIT(3)
> +#define  AALG_USE_WB_FOR_ISP		BIT(4)
> +#define  AALG_FLICKER_EN		BIT(5)
> +#define  AALG_FIT_EN			BIT(6)
> +#define  AALG_WRHW_EN			BIT(7)

Perhaps some comment on what the below definitions refer to ?

> +#define REG_PTR_CCM_HORIZON		0x06d0
> +#define REG_PTR_CCM_INCANDESCENT	0x06d4
> +#define REG_PTR_CCM_WARM_WHITE		0x06d8
> +#define REG_PTR_CCM_COOL_WHITE		0x06dc
> +#define REG_PTR_CCM_DL50		0x06e0
> +#define REG_PTR_CCM_DL65		0x06e4
> +#define REG_PTR_CCM_OUTDOOR		0x06ec
> +
> +#define REG_ARR_CCM(n)			(0x2800 + 36 * (n))
> +
[...]
> +struct s5k5baf_ctrls {
> +	struct v4l2_ctrl_handler handler;
> +	struct { /* Auto / manual white balance cluster */
> +		struct v4l2_ctrl *awb;
> +		struct v4l2_ctrl *gain_red;
> +		struct v4l2_ctrl *gain_blue;
> +	};
> +	struct { /* Mirror cluster */
> +		struct v4l2_ctrl *hflip;
> +		struct v4l2_ctrl *vflip;
> +	};
> +	struct { /* Auto exposure / manual exposure and gain cluster */
> +		struct v4l2_ctrl *auto_exp;
> +		struct v4l2_ctrl *exposure;
> +		struct v4l2_ctrl *gain;
> +	};
> +};
> +
> +struct s5k5baf {
> +	u32 mclk_frequency;
> +	struct s5k5baf_gpio gpios[2];

	struct s5k5baf_gpio gpios[GPIO_NUM]; ?

> +	enum v4l2_mbus_type bus_type;
> +	u8 nlanes;
> +	u8 hflip:1;
> +	u8 vflip:1;

I would just make these 2 fields u8, no need to complicate it with
bitfields.

> +	struct regulator_bulk_data supplies[S5K5BAF_NUM_SUPPLIES];
> +
> +	struct v4l2_subdev cis_sd;
> +	struct media_pad cis_pad;
> +
> +	struct v4l2_subdev sd;
> +	struct media_pad pads[2];
> +
> +	/* protects the struct members below */
> +	struct mutex lock;
> +
> +	int error;
> +
> +	struct v4l2_rect crop_sink;
> +	struct v4l2_rect compose;
> +	struct v4l2_rect crop_source;
> +	/* index to s5k5baf_formats array */
> +	int pixfmt;
> +	/* actual frame interval in 100us */
> +	u16 fiv;
> +	/* requested frame interval in 100us */
> +	u16 req_fiv;
> +
> +	struct s5k5baf_ctrls ctrls;
> +
> +	unsigned int streaming:1;
> +	unsigned int apply_cfg:1;
> +	unsigned int apply_crop:1;
> +	unsigned int power;
> +};
> +
> +static const struct s5k5baf_pixfmt s5k5baf_formats[] = {
> +	{ V4L2_MBUS_FMT_VYUY8_2X8,	V4L2_COLORSPACE_JPEG,	5 },
> +	/* range 16-240 */
> +	{ V4L2_MBUS_FMT_VYUY8_2X8,	V4L2_COLORSPACE_REC709,	6 },
> +	{ V4L2_MBUS_FMT_RGB565_2X8_BE,	V4L2_COLORSPACE_JPEG,	0 },
> +};
> +
> +static struct v4l2_rect s5k5baf_cis_rect = { 0, 0, S5K5BAF_CIS_WIDTH,
> +				     S5K5BAF_CIS_HEIGHT };
> +static struct v4l2_rect s5k5baf_def_rect = { 0, 0, S5K5BAF_OUT_WIDTH_DEF,
> +				     S5K5BAF_OUT_HEIGHT_DEF };
> +
> +static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
> +{
> +	return &container_of(ctrl->handler, struct s5k5baf, ctrls.handler)->sd;
> +}
> +
> +static inline bool s5k5baf_is_cis_subdev(struct v4l2_subdev *sd)
> +{
> +	return sd->entity.type == MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +}
> +
> +static inline struct s5k5baf *to_s5k5baf(struct v4l2_subdev *sd)
> +{
> +	if (s5k5baf_is_cis_subdev(sd))
> +		return container_of(sd, struct s5k5baf, cis_sd);
> +	else
> +		return container_of(sd, struct s5k5baf, sd);
> +}
> +
> +static u16 s5k5baf_i2c_read(struct s5k5baf *state, u16 addr)
> +{
> +	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
> +	u16 w, r;
> +	struct i2c_msg msg[] = {
> +		{.addr = c->addr, .flags = 0, .len = 2, .buf = (u8 *)&w},
> +		{.addr = c->addr, .flags = I2C_M_RD, .len = 2, .buf = (u8 *)&r},
> +	};
> +	int ret;
> +
> +	if (state->error)
> +		return 0;
> +
> +	w = htons(addr);
> +	ret = i2c_transfer(c->adapter, msg, 2);
> +	r = ntohs(r);
> +
> +	v4l2_dbg(3, debug, c, "i2c_read: 0x%04x : 0x%04x\n", addr, r);
> +
> +	if (ret != 2) {
> +		v4l2_err(c, "i2c_read: error during transfer (%d)\n", ret);
> +		state->error = ret;
> +	}
> +	return r;
> +}
> +
> +static void s5k5baf_i2c_write(struct s5k5baf *state, u16 addr, u16 val)
> +{
> +	u8 buf[4] = { addr >> 8, addr & 0xFF, val >> 8, val & 0xFF };
> +	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
> +	int ret;
> +
> +	if (state->error)
> +		return;
> +
> +	ret = i2c_master_send(c, buf, 4);
> +	v4l2_dbg(3, debug, c, "i2c_write: 0x%04x : 0x%04x\n", addr, val);
> +
> +	if (ret != 4) {
> +		v4l2_err(c, "i2c_write: error during transfer (%d)\n", ret);
> +		state->error = ret;
> +	}
> +}
> +
> +static u16 s5k5baf_read(struct s5k5baf *state, u16 addr)
> +{
> +	s5k5baf_i2c_write(state, REG_CMDRD_ADDR, addr);
> +	return s5k5baf_i2c_read(state, REG_CMD_BUF);
> +}
> +
> +static void s5k5baf_write(struct s5k5baf *state, u16 addr, u16 val)
> +{
> +	s5k5baf_i2c_write(state, REG_CMDWR_ADDR, addr);
> +	s5k5baf_i2c_write(state, REG_CMD_BUF, val);
> +}
> +
> +static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
> +				  u16 count, const u16 *seq)
> +{
> +	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
> +	u16 buf[count + 1];
> +	int ret, n;
> +
> +	s5k5baf_i2c_write(state, REG_CMDWR_ADDR, addr);
> +	if (state->error)
> +		return;
> +
> +	buf[0] = __constant_htons(REG_CMD_BUF);
> +	for (n = 1; n <= count; ++n)
> +		buf[n] = htons(*seq++);
> +
> +	n *= 2;
> +	ret = i2c_master_send(c, (char *)buf, n);
> +	v4l2_dbg(3, debug, c, "i2c_write_seq(count=%d): %*ph\n", count,
> +		 min(2 * count, 64), seq - count);
> +
> +	if (ret != n) {
> +		v4l2_err(c, "i2c_write_seq: error during transfer (%d)\n", ret);
> +		state->error = ret;
> +	}
> +}
> +
> +#define s5k5baf_write_seq(state, addr, seq...) \
> +	s5k5baf_write_arr_seq(state, addr, sizeof((char[]){ seq }), \
> +			      (const u16 []){ seq });
> +
> +/* add items count at the beginning of the list */
> +#define NSEQ(seq...) sizeof((char[]){ seq }), seq
> +
> +/*
> + * s5k5baf_write_nseq() - Writes sequences of values to sensor memory via i2c
> + * @nseq: sequence of u16 words in format:
> + *	(N, address, value[1]...value[N-1])*,0
> + * Ex.:
> + *	u16 seq[] = { NSEQ(0x4000, 1, 1), NSEQ(0x4010, 640, 480), 0 };
> + *	ret = s5k5baf_write_nseq(c, seq);
> + */
> +static void s5k5baf_write_nseq(struct s5k5baf *state, const u16 *nseq)
> +{
> +	int count;
> +
> +	while ((count = *nseq++)) {
> +		u16 addr = *nseq++;
> +		--count;
> +
> +		s5k5baf_write_arr_seq(state, addr, count, nseq);
> +		nseq += count;
> +	}
> +}
> +
> +static void s5k5baf_synchronize(struct s5k5baf *state, int timeout, u16 addr)
> +{
> +	unsigned long end = jiffies + msecs_to_jiffies(timeout);
> +	u16 reg;
> +
> +	s5k5baf_write(state, addr, 1);
> +	do {
> +		reg = s5k5baf_read(state, addr);
> +		if (state->error || !reg)
> +			return;
> +		usleep_range(5000, 10000);
> +	} while (time_is_after_jiffies(end));
> +
> +	v4l2_err(&state->sd, "timeout on register synchronize (%#x)\n", addr);
> +	state->error = -ETIMEDOUT;
> +}
> +
> +static void s5k5baf_hw_patch(struct s5k5baf *state)
> +{
> +	static const u16 nseq_patch[] = {
> +		NSEQ(0x1668,
> +		0xb5fe, 0x0007, 0x683c, 0x687e, 0x1da5, 0x88a0, 0x2800, 0xd00b,
[...]
> +		0x0058, 0x0000),
> +		0
> +	};
> +
> +	s5k5baf_write_nseq(state, nseq_patch);
> +}
> +
> +static void s5k5baf_hw_set_clocks(struct s5k5baf *state)
> +{
> +	unsigned long mclk = state->mclk_frequency / 1000;
> +	u16 status;
> +	static const u16 nseq_clk_cfg[] = {
> +		NSEQ(REG_I_USE_NPVI_CLOCKS,
> +		  NPVI_CLOCKS, NMIPI_CLOCKS, 0,
> +		  SCLK_PVI_FREQ / 4, PCLK_MIN_FREQ / 4, PCLK_MAX_FREQ / 4,
> +		  SCLK_MIPI_FREQ / 4, PCLK_MIN_FREQ / 4, PCLK_MAX_FREQ / 4),
> +		NSEQ(REG_I_USE_REGS_API, 1),
> +		0
> +	};
> +
> +	s5k5baf_write_seq(state, REG_I_INCLK_FREQ_L, mclk & 0xffff, mclk >> 16);
> +	s5k5baf_write_nseq(state, nseq_clk_cfg);
> +
> +	s5k5baf_synchronize(state, 250, REG_I_INIT_PARAMS_UPDATED);
> +	status = s5k5baf_read(state, REG_I_ERROR_INFO);
> +	if (!state->error && status) {
> +		v4l2_err(&state->sd, "error configuring PLL (%d)\n", status);
> +		state->error = -EINVAL;
> +	}
> +}
> +
> +static void s5k5baf_hw_set_ccm(struct s5k5baf *state)
> +{
> +	static const u16 nseq_cfg[] = {
> +		NSEQ(REG_PTR_CCM_HORIZON,
[...]
> +		0
> +	};
> +	s5k5baf_write_nseq(state, nseq_cfg);
> +}
> +
> +static void s5k5baf_hw_set_cis(struct s5k5baf *state)
> +{
> +	static const u16 nseq_cfg[] = {
> +		NSEQ(0xc202, 0x0700),
[...]
> +		0
> +	};
> +
> +	s5k5baf_i2c_write(state, REG_CMDWR_PAGE, PAGE_IF_HW);
> +	s5k5baf_write_nseq(state, nseq_cfg);
> +	s5k5baf_i2c_write(state, REG_CMDWR_PAGE, PAGE_IF_SW);
> +}
> +
> +static void s5k5baf_hw_sync_cfg(struct s5k5baf *state)
> +{
> +	s5k5baf_write(state, REG_G_PREV_CFG_CHG, 1);
> +	if (state->apply_crop) {
> +		s5k5baf_write(state, REG_G_INPUTS_CHANGE_REQ, 1);
> +		s5k5baf_write(state, REG_G_PREV_CFG_BYPASS_CHANGED, 1);
> +	}
> +	s5k5baf_synchronize(state, 500, REG_G_NEW_CFG_SYNC);
> +
> +}
> +/* Set horizontal and vertical image flipping */
> +static void s5k5baf_hw_set_mirror(struct s5k5baf *state, int horiz_flip)
> +{
> +	u16 vflip = state->ctrls.vflip->val ^ state->vflip;
> +	u16 flip = (horiz_flip ^ state->hflip) | (vflip << 1);
> +
> +	s5k5baf_write(state, REG_P_PREV_MIRROR(0), flip);
> +	if (state->streaming)
> +		s5k5baf_hw_sync_cfg(state);
> +}
> +
> +/* Configure auto/manual white balance and R/G/B gains */
> +static void s5k5baf_hw_set_awb(struct s5k5baf *state, int awb)
> +{
> +	struct s5k5baf_ctrls *ctrls = &state->ctrls;
> +	u16 reg;
> +
> +	reg = s5k5baf_read(state, REG_DBG_AUTOALG_EN);
> +
> +	if (!awb)
> +		s5k5baf_write_seq(state, REG_SF_RGAIN,
> +				  ctrls->gain_red->val, 1,
> +				  S5K5BAF_GAIN_GREEN_DEF, 1,
> +				  ctrls->gain_blue->val, 1,
> +				  1);
> +	reg = awb ? reg | AALG_WB_EN : reg & ~AALG_WB_EN;
> +	s5k5baf_write(state, REG_DBG_AUTOALG_EN, reg);
> +}
> +
> +/* Program FW with exposure time, 'exposure' in us units */
> +static void s5k5baf_hw_set_user_exposure(struct s5k5baf *state, int exposure)
> +{
> +	unsigned int time = exposure / 10;
> +
> +	s5k5baf_write_seq(state, REG_SF_USR_EXPOSURE_L,
> +			  time & 0xffff, time >> 16, 1);
> +}
> +
> +static void s5k5baf_hw_set_user_gain(struct s5k5baf *state, int gain)
> +{
> +	s5k5baf_write_seq(state, REG_SF_USR_TOT_GAIN, gain, 1);
> +}
> +
> +/* Set auto/manual exposure and total gain */
> +static void s5k5baf_hw_set_auto_exposure(struct s5k5baf *state, int value)
> +{
> +	unsigned int exp_time = state->ctrls.exposure->val;
> +	u16 auto_alg;
> +
> +	auto_alg = s5k5baf_read(state, REG_DBG_AUTOALG_EN);
> +
> +	if (value == V4L2_EXPOSURE_AUTO) {
> +		auto_alg |= AALG_AE_EN | AALG_DIVLEI_EN;
> +	} else {
> +		s5k5baf_hw_set_user_exposure(state, exp_time);
> +		s5k5baf_hw_set_user_gain(state, state->ctrls.gain->val);
> +		auto_alg &= ~(AALG_AE_EN | AALG_DIVLEI_EN);
> +	}
> +
> +	s5k5baf_write(state, REG_DBG_AUTOALG_EN, auto_alg);
> +}
> +
> +static void s5k5baf_hw_set_anti_flicker(struct s5k5baf *state, int v)
> +{
> +	u16 auto_alg;
> +
> +	auto_alg = s5k5baf_read(state, REG_DBG_AUTOALG_EN);
> +
> +	if (v == V4L2_CID_POWER_LINE_FREQUENCY_AUTO) {
> +		auto_alg |= AALG_FLICKER_EN;
> +	} else {
> +		auto_alg &= ~AALG_FLICKER_EN;
> +		/* The V4L2_CID_LINE_FREQUENCY control values match
> +		 * the register values */
> +		s5k5baf_write_seq(state, REG_SF_FLICKER_QUANT, v, 1);
> +	}
> +
> +	s5k5baf_write(state, REG_DBG_AUTOALG_EN, auto_alg);
> +}
> +
> +static void s5k5baf_hw_set_colorfx(struct s5k5baf *state, int val)
> +{
> +	static const u16 colorfx[] = {
> +		[V4L2_COLORFX_NONE] = 0,
> +		[V4L2_COLORFX_BW] = 1,
> +		[V4L2_COLORFX_NEGATIVE] = 2,
> +		[V4L2_COLORFX_SEPIA] = 3,
> +		[V4L2_COLORFX_SKY_BLUE] = 4,
> +		[V4L2_COLORFX_SKETCH] = 5,
> +	};
> +
> +	if (val >= ARRAY_SIZE(colorfx)) {
> +		v4l2_err(&state->sd, "colorfx(%d) out of range(%d)\n",
> +			 val, ARRAY_SIZE(colorfx));
> +		state->error = -EINVAL;
> +	} else {
> +		s5k5baf_write(state, REG_G_SPEC_EFFECTS, colorfx[val]);
> +	}
> +}
> +
> +static int s5k5baf_find_pixfmt(struct v4l2_mbus_framefmt *mf)
> +{
> +	int i, c = -1;
> +
> +	for (i = 0; i < ARRAY_SIZE(s5k5baf_formats); i++) {
> +		if (mf->colorspace != s5k5baf_formats[i].colorspace)
> +			continue;
> +		if (mf->code == s5k5baf_formats[i].code)
> +			return i;
> +		if (c < 0)
> +			c = i;
> +	}
> +	return (c < 0) ? 0 : c;
> +}
> +
> +static void s5k5baf_hw_set_video_bus(struct s5k5baf *state)
> +{
> +	u16 en_packets;
> +
> +	switch (state->bus_type) {
> +	case V4L2_MBUS_CSI2:
> +		en_packets = EN_PACKETS_CSI2;
> +		break;
> +	case V4L2_MBUS_PARALLEL:
> +		en_packets = 0;
> +		break;
> +	default:
> +		v4l2_err(&state->sd, "unknown video bus: %d\n", state->bus_type);
> +		state->error = -EINVAL;
> +		return;
> +	};
> +
> +	s5k5baf_write_seq(state, REG_OIF_EN_MIPI_LANES,
> +			  state->nlanes, en_packets, 1);
> +}
> +
> +static u16 s5k5baf_get_cfg_error(struct s5k5baf *state)
> +{
> +	u16 err = s5k5baf_read(state, REG_G_PREV_CFG_ERROR);
> +	if (err)
> +		s5k5baf_write(state, REG_G_PREV_CFG_ERROR, 0);
> +	return err;
> +}
> +
> +static void s5k5baf_hw_set_fiv(struct s5k5baf *state, u16 fiv)
> +{
> +	s5k5baf_write(state, REG_P_MAX_FR_TIME(0), fiv);
> +	s5k5baf_hw_sync_cfg(state);
> +}
> +
> +static void s5k5baf_hw_find_min_fiv(struct s5k5baf *state)
> +{
> +	u16 err, fiv;
> +	int n;
> +
> +	fiv = s5k5baf_read(state,  REG_G_ACTUAL_P_FR_TIME);
> +	if (state->error)
> +		return;
> +
> +	for (n = 5; n > 0; --n) {
> +		s5k5baf_hw_set_fiv(state, fiv);
> +		err = s5k5baf_get_cfg_error(state);
> +		if (state->error)
> +			return;
> +		switch (err) {
> +		case CFG_ERROR_RANGE:
> +			++fiv;
> +			break;
> +		case 0:
> +			state->fiv = fiv;
> +			v4l2_info(&state->sd,
> +				  "found valid frame interval: %d00us\n", fiv);
> +			return;
> +		default:
> +			v4l2_err(&state->sd,
> +				 "error setting frame interval: %d\n", err);
> +			state->error = -EINVAL;
> +		}
> +	};
> +	v4l2_err(&state->sd, "cannot find correct frame interval\n");
> +	state->error = -ERANGE;
> +}
> +
> +static void s5k5baf_hw_validate_cfg(struct s5k5baf *state)
> +{
> +	u16 err;
> +
> +	err = s5k5baf_get_cfg_error(state);
> +	if (state->error)
> +		return;
> +
> +	switch (err) {
> +	case 0:
> +		state->apply_cfg = 1;
> +		return;
> +	case CFG_ERROR_RANGE:
> +		s5k5baf_hw_find_min_fiv(state);
> +		if (!state->error)
> +			state->apply_cfg = 1;
> +		return;
> +	default:
> +		v4l2_err(&state->sd,
> +			 "error setting format: %d\n", err);
> +		state->error = -EINVAL;
> +	}
> +}
> +
> +static void s5k5baf_rescale(struct v4l2_rect *r, const struct v4l2_rect *v,
> +			    const struct v4l2_rect *n,
> +			    const struct v4l2_rect *d)
> +{
> +	r->left = v->left * n->width / d->width;
> +	r->top = v->top * n->height / d->height;
> +	r->width = v->width * n->width / d->width;
> +	r->height = v->height * n->height / d->height;
> +}
> +
> +static void s5k5baf_hw_set_crop_rects(struct s5k5baf *state)
> +{
> +	struct v4l2_rect *p, r;
> +	u16 err;
> +
> +	p = &state->crop_sink;
> +	s5k5baf_write_seq(state, REG_G_PREVREQ_IN_WIDTH, p->width, p->height,
> +			  p->left, p->top);
> +
> +	s5k5baf_rescale(&r, &state->crop_source, &state->crop_sink,
> +			&state->compose);
> +	s5k5baf_write_seq(state, REG_G_PREVZOOM_IN_WIDTH, r.width, r.height,
> +			  r.left, r.top);
> +
> +	s5k5baf_synchronize(state, 500, REG_G_INPUTS_CHANGE_REQ);
> +	s5k5baf_synchronize(state, 500, REG_G_PREV_CFG_BYPASS_CHANGED);
> +	err = s5k5baf_get_cfg_error(state);
> +	if (state->error)
> +		return;
> +
> +	switch (err) {
> +	case 0:
> +		break;
> +	case CFG_ERROR_RANGE:
> +		/* retry crop with frame interval set to max */
> +		s5k5baf_hw_set_fiv(state, S5K5BAF_MAX_FR_TIME);
> +		err = s5k5baf_get_cfg_error(state);
> +		if (state->error)
> +			return;
> +		if (err) {
> +			v4l2_err(&state->sd,
> +				 "crop error on max frame interval: %d\n", err);
> +			state->error = -EINVAL;
> +		}
> +		s5k5baf_hw_set_fiv(state, state->req_fiv);
> +		s5k5baf_hw_validate_cfg(state);
> +		break;
> +	default:
> +		v4l2_err(&state->sd, "crop error: %d\n", err);
> +		state->error = -EINVAL;
> +		return;
> +	}
> +
> +	if (!state->apply_cfg)
> +		return;
> +
> +	p = &state->crop_source;
> +	s5k5baf_write_seq(state, REG_P_OUT_WIDTH(0), p->width, p->height);
> +	s5k5baf_hw_set_fiv(state, state->req_fiv);
> +	s5k5baf_hw_validate_cfg(state);
> +}
> +
> +static void s5k5baf_hw_set_config(struct s5k5baf *state)
> +{
> +	u16 reg_fmt = s5k5baf_formats[state->pixfmt].reg_p_fmt;
> +	struct v4l2_rect *r = &state->crop_source;
> +
> +	s5k5baf_write_seq(state, REG_P_OUT_WIDTH(0),
> +			  r->width, r->height, reg_fmt,
> +			  PCLK_MAX_FREQ >> 2, PCLK_MIN_FREQ >> 2,
> +			  PVI_MASK_MIPI, CLK_MIPI_INDEX,
> +			  FR_RATE_FIXED, FR_RATE_Q_DYNAMIC,
> +			  state->req_fiv, S5K5BAF_MIN_FR_TIME);
> +	s5k5baf_hw_sync_cfg(state);
> +	s5k5baf_hw_validate_cfg(state);
> +}
> +
> +
> +static void s5k5baf_hw_set_test_pattern(struct s5k5baf *state, int id)
> +{
> +	s5k5baf_i2c_write(state, REG_PATTERN_WIDTH, 800);
> +	s5k5baf_i2c_write(state, REG_PATTERN_HEIGHT, 511);
> +	s5k5baf_i2c_write(state, REG_PATTERN_PARAM, 0);
> +	s5k5baf_i2c_write(state, REG_PATTERN_SET, id);
> +}
[...]
> +static void s5k5baf_power_on(struct s5k5baf *state)
> +{
> +	int ret;
> +
> +	ret = regulator_bulk_enable(S5K5BAF_NUM_SUPPLIES, state->supplies);
> +	if (ret) {
> +		state->error = ret;
> +		return;
> +	}
> +
> +	s5k5baf_gpio_deassert(state, STBY);
> +	usleep_range(50, 100);
> +	s5k5baf_gpio_deassert(state, RST);
> +}
> +
> +static void s5k5baf_power_off(struct s5k5baf *state)
> +{
> +	int ret;
> +
> +	state->streaming = 0;
> +	state->apply_cfg = 0;
> +	state->apply_crop = 0;
> +	s5k5baf_gpio_assert(state, RST);
> +	s5k5baf_gpio_assert(state, STBY);
> +	ret = regulator_bulk_disable(S5K5BAF_NUM_SUPPLIES, state->supplies);
> +	if (ret && !state->error)
> +		state->error = ret;
> +}
> +
> +static void s5k5baf_hw_init(struct s5k5baf *state)
> +{
> +	s5k5baf_i2c_write(state, AHB_MSB_ADDR_PTR, PAGE_IF_HW);
> +	s5k5baf_i2c_write(state, REG_CLEAR_HOST_INT, 0);
> +	s5k5baf_i2c_write(state, REG_SW_LOAD_COMPLETE, 1);
> +	s5k5baf_i2c_write(state, REG_CMDRD_PAGE, PAGE_IF_SW);
> +	s5k5baf_i2c_write(state, REG_CMDWR_PAGE, PAGE_IF_SW);
> +}
> +
> +static int s5k5baf_clear_error(struct s5k5baf *state)
> +{
> +	int ret = state->error;
> +
> +	state->error = 0;
> +	return ret;
> +}
> +
> +/*
> + * V4L2 subdev core and video operations
> + */
> +
> +static void s5k5baf_initialize_data(struct s5k5baf *state)
> +{
> +	state->crop_sink = s5k5baf_cis_rect;
> +	state->compose = s5k5baf_def_rect;
> +	state->crop_source = state->compose;
> +	state->pixfmt = 0;
> +	state->req_fiv = 10000 / 15;
> +	state->fiv = state->req_fiv;
> +}
> +
> +static int s5k5baf_set_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +	int ret;
> +
> +	mutex_lock(&state->lock);
> +
> +	if (!on == state->power) {
> +		if (on) {
> +			s5k5baf_initialize_data(state);
> +			s5k5baf_power_on(state);
> +			s5k5baf_hw_init(state);
> +			s5k5baf_hw_patch(state);
> +			s5k5baf_i2c_write(state, REG_SET_HOST_INT, 1);
> +			s5k5baf_hw_set_clocks(state);
> +			s5k5baf_hw_set_video_bus(state);
> +			s5k5baf_hw_set_cis(state);
> +			s5k5baf_hw_set_ccm(state);
> +		} else {
> +			s5k5baf_power_off(state);
> +		}
> +
> +		if (!state->error)
> +			state->power += on ? 1 : -1;
> +	}
> +
> +	ret = s5k5baf_clear_error(state);
> +	mutex_unlock(&state->lock);
> +
> +	if (!ret && on && state->power == 1)
> +		ret = v4l2_ctrl_handler_setup(&state->ctrls.handler);
> +
> +	return ret;
> +}
> +
> +static void s5k5baf_hw_set_stream(struct s5k5baf *state, int enable)
> +{
> +	s5k5baf_write_seq(state, REG_G_ENABLE_PREV, enable, 1);
> +}
> +
> +static int s5k5baf_s_stream(struct v4l2_subdev *sd, int on)
> +{
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +	int ret;
> +
> +	if (state->streaming == !!on)
> +		return 0;
> +
> +	mutex_lock(&state->lock);
> +
> +	if (!on) {
> +		s5k5baf_hw_set_stream(state, 0);
> +		goto out;
> +	}
> +
> +	s5k5baf_hw_set_config(state);
> +	s5k5baf_hw_set_stream(state, 1);
> +	s5k5baf_i2c_write(state, 0xb0cc, 0x000b);
> +
> +	if (!state->error)
> +		state->streaming = 1;

state->streaming seems to never be cleared in this callback, only
on power off.

How about rewriting it as:

	if (!on) {
		s5k5baf_hw_set_config(state);
		s5k5baf_hw_set_stream(state, 1);
		s5k5baf_i2c_write(state, 0xb0cc, 0x000b);
	} else {
		s5k5baf_hw_set_stream(state, 0);
	}
	if (!state->error)
		state->streaming = 1;

without an ugly as hell 'goto' ? :-)

> +
> +out:
> +	ret = s5k5baf_clear_error(state);
> +	mutex_unlock(&state->lock);
> +
> +	return ret;
> +}
> +
> +static int s5k5baf_g_frame_interval(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +
> +	mutex_lock(&state->lock);
> +	fi->interval.numerator = state->fiv;
> +	fi->interval.denominator = 10000;
> +	mutex_unlock(&state->lock);
> +
> +	return 0;
> +}
> +
> +static void s5k5baf_set_frame_interval(struct s5k5baf *state,
> +				       struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct v4l2_fract *i = &fi->interval;
> +
> +	if (fi->interval.denominator == 0)
> +		state->req_fiv = S5K5BAF_MAX_FR_TIME;
> +	else
> +		state->req_fiv = clamp_t(u32,
> +					 i->numerator * 10000 / i->denominator,
> +					 S5K5BAF_MIN_FR_TIME,
> +					 S5K5BAF_MAX_FR_TIME);
> +
> +	state->fiv = state->req_fiv;
> +	if (state->apply_cfg) {
> +		s5k5baf_hw_set_fiv(state, state->req_fiv);
> +		s5k5baf_hw_validate_cfg(state);
> +	}
> +	*i = (struct v4l2_fract){state->fiv, 10000};

I find it more readable with spaces inside {}

	*i = (struct v4l2_fract){ state->fiv, 10000 };

> +	if (state->fiv == state->req_fiv)
> +		v4l2_info(&state->sd, "frame interval changed to %d00us\n",
> +			  state->fiv);
> +}
> +
> +static int s5k5baf_s_frame_interval(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_frame_interval *fi)
> +{
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +
> +	mutex_lock(&state->lock);
> +	s5k5baf_set_frame_interval(state, fi);
> +	mutex_unlock(&state->lock);
> +	return 0;
> +}
> +
> +/*
> + * V4L2 subdev pad level and video operations
> + */
> +static int s5k5baf_enum_frame_interval(struct v4l2_subdev *sd,
> +			      struct v4l2_subdev_fh *fh,
> +			      struct v4l2_subdev_frame_interval_enum *fie)
> +{
> +	if (fie->index > S5K5BAF_MAX_FR_TIME - S5K5BAF_MIN_FR_TIME ||
> +	    fie->pad != 0)
> +		return -EINVAL;
> +
> +	v4l_bound_align_image(&fie->width, S5K5BAF_WIN_WIDTH_MIN,
> +			      S5K5BAF_CIS_WIDTH, 1,
> +			      &fie->height, S5K5BAF_WIN_HEIGHT_MIN,
> +			      S5K5BAF_CIS_HEIGHT, 1, 0);
> +
> +	fie->interval.numerator = S5K5BAF_MIN_FR_TIME + fie->index;
> +	fie->interval.denominator = 10000;
> +
> +	return 0;
> +}
> +
> +static int s5k5baf_enum_mbus_code(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->pad == 0) {
> +		if (code->index > 0)
> +			return -EINVAL;
> +		code->code = V4L2_MBUS_FMT_FIXED;
> +		return 0;
> +	}
> +
> +	if (code->index >= ARRAY_SIZE(s5k5baf_formats))
> +		return -EINVAL;
> +
> +	code->code = s5k5baf_formats[code->index].code;
> +	return 0;
> +}
> +
> +static int s5k5baf_enum_frame_size(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	int i;
> +
> +	if (fse->index > 0)
> +		return -EINVAL;
> +
> +	if (fse->pad == 0) {
> +		fse->code = V4L2_MBUS_FMT_FIXED;
> +		fse->min_width = S5K5BAF_CIS_WIDTH;
> +		fse->max_width = S5K5BAF_CIS_WIDTH;
> +		fse->min_height = S5K5BAF_CIS_HEIGHT;
> +		fse->max_height = S5K5BAF_CIS_HEIGHT;
> +		return 0;
> +	}
> +
> +	i = ARRAY_SIZE(s5k5baf_formats);
> +	while (--i)
> +		if (fse->code == s5k5baf_formats[i].code)
> +			break;
> +	fse->code = s5k5baf_formats[i].code;
> +	fse->min_width = S5K5BAF_WIN_WIDTH_MIN;
> +	fse->max_width = S5K5BAF_CIS_WIDTH;
> +	fse->max_height = S5K5BAF_WIN_HEIGHT_MIN;
> +	fse->min_height = S5K5BAF_CIS_HEIGHT;
> +
> +	return 0;
> +}
> +
> +static void s5k5baf_try_cis_format(struct v4l2_mbus_framefmt *mf)
> +{
> +	mf->width = S5K5BAF_CIS_WIDTH;
> +	mf->height = S5K5BAF_CIS_HEIGHT;
> +	mf->code = V4L2_MBUS_FMT_FIXED;
> +	mf->colorspace = V4L2_COLORSPACE_JPEG;
> +	mf->field = V4L2_FIELD_NONE;
> +}
> +
> +static int s5k5baf_try_isp_format(struct v4l2_mbus_framefmt *mf)
> +{
> +	int pixfmt;
> +
> +	v4l_bound_align_image(&mf->width, S5K5BAF_WIN_WIDTH_MIN,
> +			      S5K5BAF_CIS_WIDTH, 1,
> +			      &mf->height, S5K5BAF_WIN_HEIGHT_MIN,
> +			      S5K5BAF_CIS_HEIGHT, 1, 0);
> +
> +	pixfmt = s5k5baf_find_pixfmt(mf);
> +
> +	mf->colorspace = s5k5baf_formats[pixfmt].colorspace;
> +	mf->code = s5k5baf_formats[pixfmt].code;
> +	mf->field = V4L2_FIELD_NONE;
> +
> +	return pixfmt;
> +}
> +
> +static int s5k5baf_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> +			  struct v4l2_subdev_format *fmt)
> +{
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +	const struct s5k5baf_pixfmt *pixfmt;
> +	struct v4l2_mbus_framefmt *mf;
> +
> +	memset(fmt->reserved, 0, sizeof(fmt->reserved));

I think this should should be moved to v4l2-core/v4l2-subdev.c.
Not seem to be some drivers that don't clear this field.
I would just remove this memset from this patch.

> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
> +		fmt->format = *mf;
> +		return 0;
> +	}
> +
> +	mf = &fmt->format;
> +	if (fmt->pad == 0) {
> +		s5k5baf_try_cis_format(mf);
> +		return 0;
> +	}
> +	mf->field = V4L2_FIELD_NONE;
> +	mutex_lock(&state->lock);
> +	pixfmt = &s5k5baf_formats[state->pixfmt];
> +	mf->width = state->crop_source.width;
> +	mf->height = state->crop_source.height;
> +	mf->code = pixfmt->code;
> +	mf->colorspace = pixfmt->colorspace;
> +	mutex_unlock(&state->lock);
> +
> +	return 0;
> +}
> +
> +static int s5k5baf_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> +			  struct v4l2_subdev_format *fmt)
> +{
> +	struct v4l2_mbus_framefmt *mf = &fmt->format;
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +	const struct s5k5baf_pixfmt *pixfmt;
> +	int ret = 0;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		*v4l2_subdev_get_try_format(fh, fmt->pad) = *mf;
> +		return 0;
> +	}
> +
> +	if (fmt->pad == 0) {
> +		s5k5baf_try_cis_format(mf);
> +		return 0;
> +	}
> +
> +	mutex_lock(&state->lock);
> +
> +	if (state->streaming) {
> +		ret = -EBUSY;
> +		goto out;

It might be a matter of taste, but I think that 'goto' is not
justified  here.

> +	}
> +
> +	state->pixfmt = s5k5baf_try_isp_format(mf);
> +	pixfmt = &s5k5baf_formats[state->pixfmt];
> +	mf->code = pixfmt->code;
> +	mf->colorspace = pixfmt->colorspace;
> +	mf->width = state->crop_source.width;
> +	mf->height = state->crop_source.height;
> +
> +out:
> +	mutex_unlock(&state->lock);
> +
> +	return ret;
> +}
> +
> +enum selection_rect {R_CIS, R_CROP_SINK, R_COMPOSE, R_CROP_SOURCE, R_INVALID};

Could you add spaces around { } ?

> +static enum selection_rect s5k5baf_get_sel_rect(u32 pad, u32 target)
> +{
> +	switch (target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		return pad ? R_COMPOSE : R_CIS;
> +	case V4L2_SEL_TGT_CROP:
> +		return pad ? R_CROP_SOURCE : R_CROP_SINK;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +		return pad ? R_INVALID : R_CROP_SINK;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		return pad ? R_INVALID : R_COMPOSE;
> +	default:
> +		return R_INVALID;
> +	}
> +}
> +
> +static int s5k5baf_is_bound_tgt(u32 target)

nit: s5k5baf_is_bounds_target() ?

> +{
> +	return (target == V4L2_SEL_TGT_CROP_BOUNDS ||
> +		target == V4L2_SEL_TGT_COMPOSE_BOUNDS);
> +}
> +
[...]
> +/*
> + * V4L2 subdev controls
> + */
> +
> +static int s5k5baf_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +	int ret;
> +
> +	v4l2_dbg(1, debug, sd, "ctrl: %s, value: %d\n", ctrl->name, ctrl->val);
> +
> +	mutex_lock(&state->lock);
> +
> +	if (state->power == 0)
> +		goto unlock;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		s5k5baf_hw_set_awb(state, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_BRIGHTNESS:
> +		s5k5baf_write(state, REG_USER_BRIGHTNESS, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_COLORFX:
> +		s5k5baf_hw_set_colorfx(state, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_CONTRAST:
> +		s5k5baf_write(state, REG_USER_CONTRAST, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		s5k5baf_hw_set_auto_exposure(state, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_HFLIP:
> +		s5k5baf_hw_set_mirror(state, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_POWER_LINE_FREQUENCY:
> +		s5k5baf_hw_set_anti_flicker(state, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_SATURATION:
> +		s5k5baf_write(state, REG_USER_SATURATION, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_SHARPNESS:
> +		s5k5baf_write(state, REG_USER_SHARPBLUR, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_WHITE_BALANCE_TEMPERATURE:
> +		s5k5baf_write(state, REG_P_COLORTEMP(0), ctrl->val);
> +		if (state->apply_cfg)
> +			s5k5baf_hw_sync_cfg(state);
> +		break;
> +
> +	case V4L2_CID_TEST_PATTERN:
> +		s5k5baf_hw_set_test_pattern(state, ctrl->val);
> +		break;
> +	}
> +unlock:
> +	ret = s5k5baf_clear_error(state);
> +	mutex_unlock(&state->lock);
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops s5k5baf_ctrl_ops = {
> +	.s_ctrl	= s5k5baf_s_ctrl,
> +};
> +
> +static const char * const s5k5baf_test_pattern_menu[] = {
> +	"Disabled",
> +	"Blank",
> +	"Bars",
> +	"Gradients",
> +	"Textile",
> +	"Textile2",
> +	"Squares"
> +};
> +
> +static int s5k5baf_initialize_ctrls(struct s5k5baf *state)
> +{
> +	const struct v4l2_ctrl_ops *ops = &s5k5baf_ctrl_ops;
> +	struct s5k5baf_ctrls *ctrls = &state->ctrls;
> +	struct v4l2_ctrl_handler *hdl = &ctrls->handler;
> +	int ret;
> +
> +	ret = v4l2_ctrl_handler_init(hdl, 16);

You seem to have at least 18 controls.

> +	if (ret) {
> +		v4l2_err(&state->sd, "cannot init ctrl handler (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Auto white balance cluster */
> +	ctrls->awb = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTO_WHITE_BALANCE,
> +				       0, 1, 1, 1);
> +	ctrls->gain_red = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_RED_BALANCE,
> +					    0, 255, 1, S5K5BAF_GAIN_RED_DEF);
> +	ctrls->gain_blue = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BLUE_BALANCE,
> +					     0, 255, 1, S5K5BAF_GAIN_BLUE_DEF);
> +	v4l2_ctrl_auto_cluster(3, &ctrls->awb, 0, false);
> +
> +	ctrls->hflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	ctrls->vflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_cluster(2, &ctrls->hflip);
> +
> +	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
> +				V4L2_CID_EXPOSURE_AUTO,
> +				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
> +	/* Exposure time: x 1 us */
> +	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_EXPOSURE,
> +					    0, 6000000U, 1, 100000U);
> +	/* Total gain: 256 <=> 1x */
> +	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
> +					0, 256, 1, 256);
> +	v4l2_ctrl_auto_cluster(3, &ctrls->auto_exp, 0, false);
> +
> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_POWER_LINE_FREQUENCY,
> +			       V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
> +			       V4L2_CID_POWER_LINE_FREQUENCY_AUTO);
> +
> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_COLORFX,
> +			       V4L2_COLORFX_SKY_BLUE, ~0x6f, V4L2_COLORFX_NONE);
> +
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_WHITE_BALANCE_TEMPERATURE,
> +			  0, 256, 1, 0);
> +
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION, -127, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS, -127, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST, -127, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS, -127, 127, 1, 0);
> +
> +	v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
> +				     ARRAY_SIZE(s5k5baf_test_pattern_menu) - 1,
> +				     0, 0, s5k5baf_test_pattern_menu);
> +
> +	if (hdl->error) {
> +		v4l2_err(&state->sd, "error creating controls (%d)\n",
> +			 hdl->error);
> +		ret = hdl->error;
> +		v4l2_ctrl_handler_free(hdl);
> +		return ret;
> +	}
> +
> +	state->sd.ctrl_handler = hdl;
> +	return 0;
> +}
> +
> +/*
> + * V4L2 subdev internal operations
> + */
> +static int s5k5baf_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_mbus_framefmt *mf;
> +	struct v4l2_rect *r;
> +
> +	mf = v4l2_subdev_get_try_format(fh, 0);
> +	s5k5baf_try_cis_format(mf);
> +
> +	if (s5k5baf_is_cis_subdev(sd))
> +		return 0;
> +
> +	mf = v4l2_subdev_get_try_format(fh, 1);
> +	mf->colorspace = s5k5baf_formats[0].colorspace;
> +	mf->code = s5k5baf_formats[0].code;
> +	mf->width = s5k5baf_def_rect.width;
> +	mf->height = s5k5baf_def_rect.height;
> +	mf->field = V4L2_FIELD_NONE;
> +
> +	*v4l2_subdev_get_try_crop(fh, 0) = s5k5baf_cis_rect;
> +	r = v4l2_subdev_get_try_compose(fh, 0);
> +	*r = s5k5baf_def_rect;
> +	*v4l2_subdev_get_try_crop(fh, 1) = *r;
> +
> +	return 0;
> +}
> +
> +static void s5k5baf_check_fw_revision(struct s5k5baf *state)
> +{
> +	u16 api_ver = 0, fw_rev = 0, s_id = 0;
> +
> +	api_ver = s5k5baf_read(state, REG_FW_APIVER);
> +	fw_rev = s5k5baf_read(state, REG_FW_REVISION) & 0xff;
> +	s_id = s5k5baf_read(state, REG_FW_SENSOR_ID);
> +	if (state->error)
> +		return;
> +
> +	v4l2_info(&state->sd, "FW API=%#x, revision=%#x sensor_id=%#x\n",
> +		  api_ver, fw_rev, s_id);
> +
> +	if (api_ver == S5K5BAF_FW_APIVER)
> +		return;
> +
> +	v4l2_err(&state->sd, "FW API version not supported\n");
> +	state->error = -ENODEV;
> +}
> +
> +static int s5k5baf_registered(struct v4l2_subdev *sd)
> +{
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +	int ret;
> +
> +	ret = v4l2_device_register_subdev(sd->v4l2_dev, &state->cis_sd);
> +	if (ret) {
> +		v4l2_err(sd, "failed to register subdev %s\n",
> +			 state->cis_sd.name);
> +		return ret;
> +	}
> +
> +	mutex_lock(&state->lock);
> +
> +	s5k5baf_power_on(state);
> +	s5k5baf_hw_init(state);
> +	s5k5baf_check_fw_revision(state);
> +	s5k5baf_power_off(state);
> +	ret = s5k5baf_clear_error(state);


After the exynos4-is is converted to the asynchronous subdev probing
API this H/W revision probing could be moved to probe. For the final
version of this driver the async API support will need to be added to
this driver.

> +	mutex_unlock(&state->lock);
> +
> +	if (ret)
> +		v4l2_device_unregister_subdev(&state->cis_sd);
> +
> +	return ret;
> +}
> +
> +static void s5k5baf_unregistered(struct v4l2_subdev *sd)
> +{
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +	v4l2_device_unregister_subdev(&state->cis_sd);
> +}
> +
[...]
> +static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
> +{
> +	struct device_node *node = dev->of_node;
> +	struct device_node *node_ep;
> +	struct v4l2_of_endpoint ep;
> +	int ret;
> +
> +	if (!node) {
> +		dev_err(dev, "no device-tree node provided\n");
> +		return -EINVAL;
> +	}
> +
> +	of_property_read_u32(node, "clock-frequency", &state->mclk_frequency);
> +	state->hflip = of_property_read_bool(node, "samsung,hflip");
> +	state->vflip = of_property_read_bool(node, "samsung,vflip");
> +	ret = s5k5baf_parse_gpio(&state->gpios[STBY], node, STBY);
> +	if (ret) {
> +		dev_err(dev, "no standby gpio pin provided\n");
> +		return -EINVAL;
> +	}
> +	ret = s5k5baf_parse_gpio(&state->gpios[RST], node, RST);
> +	if (ret) {
> +		dev_err(dev, "no reset gpio pin provided\n");
> +		return -EINVAL;
> +	}
> +
> +	node_ep = v4l2_of_get_next_endpoint(node, NULL);
> +	if (!node_ep) {
> +		dev_err(dev, "no endpoint defined\n");

nit:
		dev_err(dev, "no endpoint defined at node %s\n",
				node->full_name);
?
> +		return -EINVAL;
> +	}

nit: an empty line here ?

> +	v4l2_of_parse_endpoint(node_ep, &ep);
> +	of_node_put(node_ep);
> +	state->bus_type = ep.bus_type;
> +	if (state->bus_type == V4L2_MBUS_CSI2)
> +		state->nlanes = ep.bus.mipi_csi2.num_data_lanes;
> +	return 0;
> +}
> +
> +static int s5k5baf_configure_subdevs(struct s5k5baf *state,
> +				     struct i2c_client *c)
> +{
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	sd = &state->cis_sd;
> +	v4l2_subdev_init(sd, &s5k5baf_cis_subdev_ops);
> +	sd->owner = c->driver->driver.owner;

It could be simplified to:

	sd->owner = THIS_MODULE;

> +	v4l2_set_subdevdata(sd, state);
> +	strlcpy(sd->name, "S5K5BAF-CIS", sizeof(sd->name));

I think we need instead something like:

	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
		"S5K5BAF-CIS", i2c_adapter_id(c->adapter), c->addr);

> +	sd->internal_ops = &s5k5baf_cis_subdev_internal_ops;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	state->cis_pad.flags = MEDIA_PAD_FL_SOURCE;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	ret = media_entity_init(&sd->entity, 1, &state->cis_pad, 0);
> +	if (ret)
> +		goto err;
> +
> +	sd = &state->sd;
> +	v4l2_i2c_subdev_init(sd, c, &s5k5baf_subdev_ops);
> +	strlcpy(sd->name, "S5K5BAF-ISP", sizeof(sd->name));

Ditto.

> +	sd->internal_ops = &s5k5baf_subdev_internal_ops;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	state->pads[0].flags = MEDIA_PAD_FL_SINK;
> +	state->pads[1].flags = MEDIA_PAD_FL_SOURCE;

Might be a good idea to create some enum/macros to those pad indexes.

> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> +	ret = media_entity_init(&sd->entity, 2, state->pads, 0);

And for the number of pads too.

> +	if (ret)
> +		goto err_cis;
> +
> +	ret = media_entity_create_link(&state->cis_sd.entity,
> +				       0, &state->sd.entity, 0,
> +				       MEDIA_LNK_FL_IMMUTABLE |
> +				       MEDIA_LNK_FL_ENABLED);

This link needs now to be created in .registered callback, so it
is re-created after this subdev gets unregistered from the host
and the state->cis_sd.entity links get removed.

> +	if (!ret)
> +		return 0;
> +
> +	media_entity_cleanup(&state->sd.entity);
> +err_cis:
> +	media_entity_cleanup(&state->cis_sd.entity);
> +err:
> +	dev_err(&c->dev, "cannot init media entity %s\n", sd->name);
> +	return ret;
> +}
[...]
> +
> +MODULE_DESCRIPTION("Samsung S5K5BAF(X) UXGA camera driver");
> +MODULE_AUTHOR("Andrzej Hajda <a.hajda@samsung.com>");
> +MODULE_LICENSE("GPL");

I think this should be "GPL v2".

Otherwise it look pretty good! And more importantly the overall
image quality is much better than with the s5k6aa driver for
a similar sensor. :)

Thanks,
Sylwester

