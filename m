Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:58574 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1IYKIK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 06:08:10 -0400
Date: Sun, 25 Sep 2011 13:08:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
Message-ID: <20110925100804.GU1845@valkosipuli.localdomain>
References: <1316627107-18709-1-git-send-email-s.nawrocki@samsung.com>
 <1316627107-18709-3-git-send-email-s.nawrocki@samsung.com>
 <20110922220259.GS1845@valkosipuli.localdomain>
 <4E7C5BAA.9090900@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7C5BAA.9090900@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 23, 2011 at 12:12:58PM +0200, Sylwester Nawrocki wrote:
> Hi Sakari,

Hi Sylwester,

> On 09/23/2011 12:02 AM, Sakari Ailus wrote:
> > Hi Sylwester,
> > 
> > I have a few additional comments below, they don't depend on my earlier
> > ones.
> 
> Thanks a lot for your follow up review!
> 
> > 
> > On Wed, Sep 21, 2011 at 07:45:07PM +0200, Sylwester Nawrocki wrote:
> >> This driver exposes preview mode operation of the S5K6AAFX sensor with
> >> embedded SoC ISP. It uses one of the five user predefined configuration
> >> register sets. There is yet no support for capture (snapshot) operation.
> >> Following controls are supported:
> >> manual/auto exposure and gain, power line frequency (anti-flicker),
> >> saturation, sharpness, brightness, contrast, white balance temperature,
> >> color effects, horizontal/vertical image flip, frame interval.
> >>
> >> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> ...
> >> +
> >> +struct s5k6aa_pixfmt {
> >> +	enum v4l2_mbus_pixelcode code;
> >> +	u32 colorspace;
> >> +	/* REG_P_FMT(x) register value */
> >> +	u16 reg_p_fmt;
> >> +};
> >> +
> >> +struct s5k6aa_preset {
> >> +	struct v4l2_frmsize_discrete out_size;
> >> +	struct v4l2_rect in_win;
> >> +	const struct s5k6aa_pixfmt *pixfmt;
> >> +	unsigned int inv_hflip:1;
> >> +	unsigned int inv_vflip:1;
> >> +	u8 frame_rate_type;
> >> +	u8 index;
> >> +};
> >> +

[clip]

> >> +/* Set initial values for all preview presets */
> >> +static void s5k6aa_presets_data_init(struct s5k6aa *s5k6aa,
> >> +				     int hflip, int vflip)
> >> +{
> >> +	struct s5k6aa_preset *preset = &s5k6aa->presets[0];
> >> +	int i;
> >> +
> >> +	for (i = 0; i < S5K6AA_MAX_PRESETS; i++) {
> >> +		preset->pixfmt		= &s5k6aa_formats[0];
> >> +		preset->frame_rate_type	= FR_RATE_DYNAMIC;
> >> +		preset->inv_hflip	= hflip;
> >> +		preset->inv_vflip	= vflip;
> >> +		preset->out_size.width	= S5K6AA_OUT_WIDTH_DEF;
> >> +		preset->out_size.height	= S5K6AA_OUT_HEIGHT_DEF;
> >> +		preset->in_win.width	= S5K6AA_WIN_WIDTH_MAX;
> >> +		preset->in_win.height	= S5K6AA_WIN_HEIGHT_MAX;
> >> +		preset->in_win.left	= 0;
> >> +		preset->in_win.top	= 0;
> > 
> > Much of this data is static, why is it copied to the presets struct?
> > 
> > What is the intended purpose of these presets?
> 
> I agree there is no need to keep inv_hflip/inv_vflip there. It's more a
> leftover from previous driver version. I'll move it to struct s5k6aa.
> And I try to keep copy of each platform_data attribute in driver's
> private struct to make future transition to DT driver probing easier.
> 
> inv_[hv]flip variables are used to indicate physical layout of the sensor,
> as it varies across multiple machines. So indeed they're global, not per
> the configuration set.
> 
> Preset are there in the s5k6aafx register interface to allow fast transition
> between, for instance, low resolution preview and high resolution snapshot.
> I'm planning to use this driver as an experimental rabbit for the future
> snapshot mode API.

It sounds like that a "snapshot mode" would be an use case that presets
could support in a way, but what I'd really like to ask is how much
advantage one can get by using this mode, say, vs. re-programming the same
settings over the I2C bus? The bus transfers (I assume) roughly 40 kB/s, so
I imagine a few tens of register writes can be avoided by most, taking
somewhere in the range of a few milliseconds.

I would rather measure and attempt to optimise the register writes in the
driver first before adding complexity to user space interface.

Or do the presets provide other advantages than just storing configurations?

> in_win field is there for cropping support. So for now it's static data,
> but this will change. I've covered pretty much functionality of the device
> in this driver and I'd like to have it in mainline at this stage.
> I've spent pretty much time on this driver, trying to figure out some
> things on trial and error basis.
> 

[clip]

> >> +
> >> +/* Set horizontal and vertical image flipping */
> >> +static int s5k6aa_set_mirror(struct s5k6aa *s5k6aa, int horiz_flip)
> >> +{
> >> +	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
> >> +	struct s5k6aa_preset *preset = s5k6aa->preset;
> >> +
> >> +	unsigned int vflip = s5k6aa->ctrls.vflip->val ^ preset->inv_vflip;
> >> +	unsigned int hflip = horiz_flip ^ preset->inv_hflip;
> > 
> > I don't see a need to store inv_hflip to presets. Instead, you might just
> > have a mirror bit in the platform data.
> 
> Agreed, except I'd like to keep that in driver's private data structure,
> not to rely on the platform data after the driver probing.

There's no reason to avoid using platform data after probing that I am aware
of.

> > 
> >> +	return s5k6aa_write(client, REG_P_PREV_MIRROR(preset->index),
> >> +			    hflip | (vflip << 1));
> >> +}
> >> +
> ...
> >> +
> >> +static int __s5k6aa_power_enable(struct s5k6aa *s5k6aa)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = regulator_bulk_enable(S5K6AA_NUM_SUPPLIES, s5k6aa->supplies);
> >> +	if (ret)
> >> +		return ret;
> >> +	if (s5k6aa_gpio_deassert(s5k6aa, STBY))
> >> +		udelay(200);
> > 
> > It's a small delay but still a busy loop. What about usleep_range() for the
> > same length?
> 
> One could arque, but...yes, might make sense to change.

I guess it's up to how much time e.g. a task switch would take. These days 1
GHz and over CPUs might be able to do something useful during that time. :)

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
