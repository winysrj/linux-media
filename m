Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63983 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1IWKNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 06:13:02 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRZ00CRA0DN9K@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Sep 2011 11:12:59 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRZ0000N0DMXU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Sep 2011 11:12:59 +0100 (BST)
Date: Fri, 23 Sep 2011 12:12:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
In-reply-to: <20110922220259.GS1845@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <4E7C5BAA.9090900@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1316627107-18709-1-git-send-email-s.nawrocki@samsung.com>
 <1316627107-18709-3-git-send-email-s.nawrocki@samsung.com>
 <20110922220259.GS1845@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/23/2011 12:02 AM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> I have a few additional comments below, they don't depend on my earlier
> ones.

Thanks a lot for your follow up review!

> 
> On Wed, Sep 21, 2011 at 07:45:07PM +0200, Sylwester Nawrocki wrote:
>> This driver exposes preview mode operation of the S5K6AAFX sensor with
>> embedded SoC ISP. It uses one of the five user predefined configuration
>> register sets. There is yet no support for capture (snapshot) operation.
>> Following controls are supported:
>> manual/auto exposure and gain, power line frequency (anti-flicker),
>> saturation, sharpness, brightness, contrast, white balance temperature,
>> color effects, horizontal/vertical image flip, frame interval.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
...
>> +
>> +struct s5k6aa_pixfmt {
>> +	enum v4l2_mbus_pixelcode code;
>> +	u32 colorspace;
>> +	/* REG_P_FMT(x) register value */
>> +	u16 reg_p_fmt;
>> +};
>> +
>> +struct s5k6aa_preset {
>> +	struct v4l2_frmsize_discrete out_size;
>> +	struct v4l2_rect in_win;
>> +	const struct s5k6aa_pixfmt *pixfmt;
>> +	unsigned int inv_hflip:1;
>> +	unsigned int inv_vflip:1;
>> +	u8 frame_rate_type;
>> +	u8 index;
>> +};
>> +
>> +/* Not all controls supported by the driver are in this struct. */
>> +struct s5k6aa_ctrls {
>> +	struct v4l2_ctrl_handler handler;
>> +	/* Mirror cluster */
>> +	struct v4l2_ctrl *hflip;
>> +	struct v4l2_ctrl *vflip;
>> +	/* Auto exposure / manual exposure and gain cluster */
>> +	struct v4l2_ctrl *auto_exp;
>> +	struct v4l2_ctrl *exposure;
>> +	struct v4l2_ctrl *gain;
>> +};
>> +
>> +struct s5k6aa_interval {
>> +	u16 reg_fr_time;
>> +	struct v4l2_fract interval;
>> +	/* Maximum rectangle for the interval */
>> +	struct v4l2_frmsize_discrete size;
>> +};
>> +
>> +struct s5k6aa {
>> +	struct v4l2_subdev sd;
>> +	struct media_pad pad;
>> +
>> +	enum v4l2_mbus_type bus_type;
>> +	u8 mipi_lanes;
>> +
>> +	int (*s_power)(int enable);
>> +	struct regulator_bulk_data supplies[S5K6AA_NUM_SUPPLIES];
>> +	struct s5k6aa_gpio gpio[GPIO_NUM];
>> +
>> +	/* master clock frequency */
>> +	unsigned long mclk_frequency;
>> +	u16 clk_fop;
>> +	u16 clk_fmin;
>> +	u16 clk_fmax;
>> +
>> +	/* protects the struct members below */
>> +	struct mutex lock;
>> +
>> +	struct s5k6aa_ctrls ctrls;
>> +	struct s5k6aa_preset presets[S5K6AA_MAX_PRESETS];
>> +	struct s5k6aa_preset *preset;
>> +	const struct s5k6aa_interval *fiv;
>> +
>> +	unsigned int streaming:1;
>> +	unsigned int apply_new_cfg:1;
>> +	unsigned int power;
>> +};
>> +
>> +static struct s5k6aa_regval s5k6aa_analog_config[] = {
>> +	/* Analog settings */
>> +	{ 0x112A, 0x0000 }, { 0x1132, 0x0000 },
>> +	{ 0x113E, 0x0000 }, { 0x115C, 0x0000 },
>> +	{ 0x1164, 0x0000 }, { 0x1174, 0x0000 },
>> +	{ 0x1178, 0x0000 }, { 0x077A, 0x0000 },
>> +	{ 0x077C, 0x0000 }, { 0x077E, 0x0000 },
>> +	{ 0x0780, 0x0000 }, { 0x0782, 0x0000 },
>> +	{ 0x0784, 0x0000 }, { 0x0786, 0x0000 },
>> +	{ 0x0788, 0x0000 }, { 0x07A2, 0x0000 },
>> +	{ 0x07A4, 0x0000 }, { 0x07A6, 0x0000 },
>> +	{ 0x07A8, 0x0000 }, { 0x07B6, 0x0000 },
>> +	{ 0x07B8, 0x0002 }, { 0x07BA, 0x0004 },
>> +	{ 0x07BC, 0x0004 }, { 0x07BE, 0x0005 },
>> +	{ 0x07C0, 0x0005 }, { S5K6AA_TERM, 0 },
> 
> A number of the hexadecimals are upper case. Should be lower.

opps, looking at this so many times still missed that:) I'll fix it.

> 
>> +};
>> +
>> +/* TODO: Add RGB888 and Bayer format */
>> +static const struct s5k6aa_pixfmt s5k6aa_formats[] = {
>> +	{ V4L2_MBUS_FMT_YUYV8_2X8,	V4L2_COLORSPACE_JPEG,	5 },
>> +	/* range 16-240 */
>> +	{ V4L2_MBUS_FMT_YUYV8_2X8,	V4L2_COLORSPACE_REC709,	6 },
>> +	{ V4L2_MBUS_FMT_RGB565_2X8_BE,	V4L2_COLORSPACE_JPEG,	0 },
>> +};
>> +
>> +static const struct s5k6aa_interval s5k6aa_intervals[] = {
>> +	{ 1000, {10000, 1000000}, {1280, 1024} }, /* 10 fps */
>> +	{ 666,  {15000, 1000000}, {1280, 1024} }, /* 15 fps */
>> +	{ 500,  {20000, 1000000}, {1280, 720} },  /* 20 fps */
>> +	{ 400,  {25000, 1000000}, {640, 480} },   /* 25 fps */
>> +	{ 333,  {33300, 1000000}, {640, 480} },   /* 30 fps */
>> +};
>> +
>> +#define S5K6AA_INTERVAL_DEF_INDEX 1 /* 15 fps */
>> +
>> +static struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
>> +{
>> +	return &container_of(ctrl->handler, struct s5k6aa, ctrls.handler)->sd;
>> +}
>> +
>> +static struct s5k6aa *to_s5k6aa(struct v4l2_subdev *sd)
>> +{
>> +	return container_of(sd, struct s5k6aa, sd);
>> +}
>> +
>> +/* Set initial values for all preview presets */
>> +static void s5k6aa_presets_data_init(struct s5k6aa *s5k6aa,
>> +				     int hflip, int vflip)
>> +{
>> +	struct s5k6aa_preset *preset = &s5k6aa->presets[0];
>> +	int i;
>> +
>> +	for (i = 0; i < S5K6AA_MAX_PRESETS; i++) {
>> +		preset->pixfmt		= &s5k6aa_formats[0];
>> +		preset->frame_rate_type	= FR_RATE_DYNAMIC;
>> +		preset->inv_hflip	= hflip;
>> +		preset->inv_vflip	= vflip;
>> +		preset->out_size.width	= S5K6AA_OUT_WIDTH_DEF;
>> +		preset->out_size.height	= S5K6AA_OUT_HEIGHT_DEF;
>> +		preset->in_win.width	= S5K6AA_WIN_WIDTH_MAX;
>> +		preset->in_win.height	= S5K6AA_WIN_HEIGHT_MAX;
>> +		preset->in_win.left	= 0;
>> +		preset->in_win.top	= 0;
> 
> Much of this data is static, why is it copied to the presets struct?
> 
> What is the intended purpose of these presets?

I agree there is no need to keep inv_hflip/inv_vflip there. It's more a
leftover from previous driver version. I'll move it to struct s5k6aa.
And I try to keep copy of each platform_data attribute in driver's
private struct to make future transition to DT driver probing easier.

inv_[hv]flip variables are used to indicate physical layout of the sensor,
as it varies across multiple machines. So indeed they're global, not per
the configuration set.

Preset are there in the s5k6aafx register interface to allow fast transition
between, for instance, low resolution preview and high resolution snapshot.
I'm planning to use this driver as an experimental rabbit for the future
snapshot mode API.

in_win field is there for cropping support. So for now it's static data,
but this will change. I've covered pretty much functionality of the device
in this driver and I'd like to have it in mainline at this stage.
I've spent pretty much time on this driver, trying to figure out some
things on trial and error basis.

> 
>> +		preset->index		= i;
>> +		preset++;
>> +	}
>> +
>> +	s5k6aa->fiv = &s5k6aa_intervals[S5K6AA_INTERVAL_DEF_INDEX];
>> +	s5k6aa->preset = &s5k6aa->presets[0];
>> +}
>> +
>> +static int s5k6aa_i2c_read(struct i2c_client *client, u16 addr, u16 *val)
>> +{
>> +	u8 wbuf[2] = {addr >> 8, addr & 0xFF};
>> +	struct i2c_msg msg[2];
>> +	u8 rbuf[2];
>> +	int ret;
>> +
>> +	msg[0].addr = client->addr;
>> +	msg[0].flags = 0;
>> +	msg[0].len = 2;
>> +	msg[0].buf = wbuf;
>> +
>> +	msg[1].addr = client->addr;
>> +	msg[1].flags = I2C_M_RD;
>> +	msg[1].len = 2;
>> +	msg[1].buf = rbuf;
>> +
>> +	ret = i2c_transfer(client->adapter, msg, 2);
>> +	*val = be16_to_cpu(*((u16 *)rbuf));
>> +
>> +	v4l2_dbg(3, debug, client, "i2c_read: 0x%04X : 0x%04x\n", addr, *val);
>> +
>> +	return ret == 2 ? 0 : ret;
>> +}
>> +
>> +static int s5k6aa_i2c_write(struct i2c_client *client, u16 addr, u16 val)
>> +{
>> +	u8 buf[4] = {addr >> 8, addr & 0xFF, val >> 8, val & 0xFF};
>> +
>> +	int ret = i2c_master_send(client, buf, 4);
>> +	v4l2_dbg(3, debug, client, "i2c_write: 0x%04X : 0x%04x\n", addr, val);
>> +
>> +	return ret == 4 ? 0 : ret;
>> +}
>> +
>> +/* The command register write, assumes Command_Wr_addH = 0x7000. */
>> +static int s5k6aa_write(struct i2c_client *c, u16 addr, u16 val)
>> +{
>> +	int ret = s5k6aa_i2c_write(c, REG_CMDWR_ADDRL, addr);
>> +	if (ret)
>> +		return ret;
>> +	return s5k6aa_i2c_write(c, REG_CMDBUF0_ADDR, val);
>> +}
>> +
>> +/* The command register read, assumes Command_Rd_addH = 0x7000. */
>> +static int s5k6aa_read(struct i2c_client *client, u16 addr, u16 *val)
>> +{
>> +	int ret = s5k6aa_i2c_write(client, REG_CMDRD_ADDRL, addr);
>> +	if (ret)
>> +		return ret;
>> +	return s5k6aa_i2c_read(client, REG_CMDBUF0_ADDR, val);
>> +}
>> +
>> +static int s5k6aa_write_array(struct v4l2_subdev *sd,
>> +			      const struct s5k6aa_regval *msg)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +	u16 addr_incr = 0;
>> +	int ret = 0;
>> +
>> +	while (msg->addr != S5K6AA_TERM) {
>> +		if (addr_incr != 2)
>> +			ret = s5k6aa_i2c_write(client, REG_CMDWR_ADDRL,
>> +					       msg->addr);
>> +		if (ret)
>> +			break;
>> +		ret = s5k6aa_i2c_write(client, REG_CMDBUF0_ADDR, msg->val);
>> +		if (ret)
>> +			break;
>> +		/* Assume that msg->addr is always less than 0xfffc */
>> +		addr_incr = (msg + 1)->addr - msg->addr;
>> +		msg++;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/* Configure the AHB high address bytes for GTG registers access */
>> +static int s5k6aa_set_ahb_address(struct i2c_client *client)
>> +{
>> +	int ret = s5k6aa_i2c_write(client, AHB_MSB_ADDR_PTR, GEN_REG_OFFSH);
>> +	if (ret)
>> +		return ret;
>> +	ret = s5k6aa_i2c_write(client, REG_CMDRD_ADDRH, HOST_SWIF_OFFSH);
>> +	if (ret)
>> +		return ret;
>> +	return s5k6aa_i2c_write(client, REG_CMDWR_ADDRH, HOST_SWIF_OFFSH);
>> +}
>> +
>> +/**
>> + * s5k6aa_configure_pixel_clock - apply ISP main clock/PLL configuration
>> + *
>> + * Configure the internal ISP PLL for 24 MHz output frequency.
>> + * Locking: called with s5k6aa->lock mutex held.
>> + */
>> +static int s5k6aa_configure_pixel_clock(struct s5k6aa *s5k6aa)
>> +{
>> +	struct i2c_client *c = v4l2_get_subdevdata(&s5k6aa->sd);
>> +	unsigned long fmclk = s5k6aa->mclk_frequency / 1000;
>> +	int ret;
>> +
>> +	if (WARN(fmclk < MIN_MCLK_FREQ_KHZ || fmclk > MAX_MCLK_FREQ_KHZ,
>> +		 "Invalid clock frequency: %ld\n", fmclk))
>> +		return -EINVAL;
>> +
>> +	s5k6aa->clk_fop  = 24000000U / 4000U;
>> +	s5k6aa->clk_fmin = 48000000U / 4000U;
>> +	s5k6aa->clk_fmax = 56000000U / 4000U;
>> +
>> +	/* External input clock frequency in kHz */
>> +	ret = s5k6aa_write(c, REG_I_INCLK_FREQ_H, fmclk >> 16);
>> +	if (!ret)
>> +		ret = s5k6aa_write(c, REG_I_INCLK_FREQ_L, fmclk & 0xFFFF);
>> +	if (!ret)
>> +		ret = s5k6aa_write(c, REG_I_USE_NPVI_CLOCKS, 1);
>> +	/* Internal PLL frequency */
>> +	if (!ret)
>> +		ret = s5k6aa_write(c, REG_I_OPCLK_4KHZ(0), s5k6aa->clk_fop);
>> +	if (!ret)
>> +		ret = s5k6aa_write(c, REG_I_MIN_OUTRATE_4KHZ(0),
>> +				   s5k6aa->clk_fmin);
>> +	if (!ret)
>> +		ret = s5k6aa_write(c, REG_I_MAX_OUTRATE_4KHZ(0),
>> +				   s5k6aa->clk_fmax);
>> +	return ret ? ret : s5k6aa_write(c, REG_I_INIT_PARAMS_UPDATED, 1);
>> +}
>> +
>> +/* Set horizontal and vertical image flipping */
>> +static int s5k6aa_set_mirror(struct s5k6aa *s5k6aa, int horiz_flip)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
>> +	struct s5k6aa_preset *preset = s5k6aa->preset;
>> +
>> +	unsigned int vflip = s5k6aa->ctrls.vflip->val ^ preset->inv_vflip;
>> +	unsigned int hflip = horiz_flip ^ preset->inv_hflip;
> 
> I don't see a need to store inv_hflip to presets. Instead, you might just
> have a mirror bit in the platform data.

Agreed, except I'd like to keep that in driver's private data structure,
not to rely on the platform data after the driver probing.

> 
>> +	return s5k6aa_write(client, REG_P_PREV_MIRROR(preset->index),
>> +			    hflip | (vflip << 1));
>> +}
>> +
...
>> +
>> +static int __s5k6aa_power_enable(struct s5k6aa *s5k6aa)
>> +{
>> +	int ret;
>> +
>> +	ret = regulator_bulk_enable(S5K6AA_NUM_SUPPLIES, s5k6aa->supplies);
>> +	if (ret)
>> +		return ret;
>> +	if (s5k6aa_gpio_deassert(s5k6aa, STBY))
>> +		udelay(200);
> 
> It's a small delay but still a busy loop. What about usleep_range() for the
> same length?

One could arque, but...yes, might make sense to change.

> 
>> +
>> +	if (s5k6aa->s_power)
>> +		ret = s5k6aa->s_power(1);
>> +	usleep_range(4000, 4000);
>> +
>> +	if (s5k6aa_gpio_deassert(s5k6aa, RST))
>> +		msleep(20);
>> +
>> +	return ret;
>> +}
>> +
>> +static int __s5k6aa_power_disable(struct s5k6aa *s5k6aa)
>> +{
>> +	int ret;
>> +
>> +	if (s5k6aa_gpio_assert(s5k6aa, RST))
>> +		udelay(100);
> 
> Same here.

Would argue even more here, but will change too;)



Best regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
