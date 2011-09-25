Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59675 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1IYQ7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 12:59:30 -0400
Received: by fxe4 with SMTP id 4so5317353fxe.19
        for <linux-media@vger.kernel.org>; Sun, 25 Sep 2011 09:59:28 -0700 (PDT)
Message-ID: <4E7F5DEC.8020808@gmail.com>
Date: Sun, 25 Sep 2011 18:59:24 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
References: <1316627107-18709-1-git-send-email-s.nawrocki@samsung.com> <1316627107-18709-3-git-send-email-s.nawrocki@samsung.com> <20110922220259.GS1845@valkosipuli.localdomain> <4E7C5BAA.9090900@samsung.com> <20110925100804.GU1845@valkosipuli.localdomain>
In-Reply-To: <20110925100804.GU1845@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

On 09/25/2011 12:08 PM, Sakari Ailus wrote:
> On Fri, Sep 23, 2011 at 12:12:58PM +0200, Sylwester Nawrocki wrote:
>> On 09/23/2011 12:02 AM, Sakari Ailus wrote:
>>> Hi Sylwester,
>>>
>>> I have a few additional comments below, they don't depend on my earlier
>>> ones.
>>
>> Thanks a lot for your follow up review!
>>>
>>> On Wed, Sep 21, 2011 at 07:45:07PM +0200, Sylwester Nawrocki wrote:
>>>> This driver exposes preview mode operation of the S5K6AAFX sensor with
>>>> embedded SoC ISP. It uses one of the five user predefined configuration
>>>> register sets. There is yet no support for capture (snapshot) operation.
>>>> Following controls are supported:
>>>> manual/auto exposure and gain, power line frequency (anti-flicker),
>>>> saturation, sharpness, brightness, contrast, white balance temperature,
>>>> color effects, horizontal/vertical image flip, frame interval.
>>>>
>>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>> ---
>> ...
>>>> +
>>>> +struct s5k6aa_pixfmt {
>>>> +	enum v4l2_mbus_pixelcode code;
>>>> +	u32 colorspace;
>>>> +	/* REG_P_FMT(x) register value */
>>>> +	u16 reg_p_fmt;
>>>> +};
>>>> +
>>>> +struct s5k6aa_preset {
>>>> +	struct v4l2_frmsize_discrete out_size;
>>>> +	struct v4l2_rect in_win;
>>>> +	const struct s5k6aa_pixfmt *pixfmt;
>>>> +	unsigned int inv_hflip:1;
>>>> +	unsigned int inv_vflip:1;
>>>> +	u8 frame_rate_type;
>>>> +	u8 index;
>>>> +};
>>>> +
> 
> [clip]
> 
>>>> +/* Set initial values for all preview presets */
>>>> +static void s5k6aa_presets_data_init(struct s5k6aa *s5k6aa,
>>>> +				     int hflip, int vflip)
>>>> +{
>>>> +	struct s5k6aa_preset *preset =&s5k6aa->presets[0];
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i<  S5K6AA_MAX_PRESETS; i++) {
>>>> +		preset->pixfmt		=&s5k6aa_formats[0];
>>>> +		preset->frame_rate_type	= FR_RATE_DYNAMIC;
>>>> +		preset->inv_hflip	= hflip;
>>>> +		preset->inv_vflip	= vflip;
>>>> +		preset->out_size.width	= S5K6AA_OUT_WIDTH_DEF;
>>>> +		preset->out_size.height	= S5K6AA_OUT_HEIGHT_DEF;
>>>> +		preset->in_win.width	= S5K6AA_WIN_WIDTH_MAX;
>>>> +		preset->in_win.height	= S5K6AA_WIN_HEIGHT_MAX;
>>>> +		preset->in_win.left	= 0;
>>>> +		preset->in_win.top	= 0;
>>>
>>> Much of this data is static, why is it copied to the presets struct?
>>>
>>> What is the intended purpose of these presets?
>>
>> I agree there is no need to keep inv_hflip/inv_vflip there. It's more a
>> leftover from previous driver version. I'll move it to struct s5k6aa.
>> And I try to keep copy of each platform_data attribute in driver's
>> private struct to make future transition to DT driver probing easier.
>>
>> inv_[hv]flip variables are used to indicate physical layout of the sensor,
>> as it varies across multiple machines. So indeed they're global, not per
>> the configuration set.
>>
>> Preset are there in the s5k6aafx register interface to allow fast transition
>> between, for instance, low resolution preview and high resolution snapshot.
>> I'm planning to use this driver as an experimental rabbit for the future
>> snapshot mode API.
> 
> It sounds like that a "snapshot mode" would be an use case that presets
> could support in a way, but what I'd really like to ask is how much
> advantage one can get by using this mode, say, vs. re-programming the same
> settings over the I2C bus? The bus transfers (I assume) roughly 40 kB/s, so
> I imagine a few tens of register writes can be avoided by most, taking
> somewhere in the range of a few milliseconds.

As far as the timings are concerned, for this particular device, the advantage
is not really meaningful. We are talking about appr. 20 registers 
(~50 bytes on I2C bus), which is a ridiculously low number. However, even if 
the interface isn't exposed to user space, in the hardware there exist separate
registers for preview and (still) capture and it makes much sense in the driver
to model this, for easier device control.

Anyway, I've taken a closer look at what I need in the single user configuration
set data structure and reworked the driver quite extensively. Should post that
in the coming week, unless some unexpected disasters occur;)

Do you see any problem in defining real still capture interface in V4L ?
It's probably just a small set of new controls, new capability, plus multi-size
buffer queue Guennadi has been working on.  
Some devices will require explicitly switching between preview and capture mode,
and it may make difference if they are programmed in advance or on demand.

If the hardware (or it's firmware) supports something natively why should we go
for a less efficient SW emulated replacement? After all, preview and capture mode
seem pretty basic features that applications will want to use.

> 
> I would rather measure and attempt to optimise the register writes in the
> driver first before adding complexity to user space interface.

Yeah, I'm not planning to use the presets plainly for different user configurations,
just trying to design the driver so those may be utilised for the device various 
operation modes.

> 
> Or do the presets provide other advantages than just storing configurations?

The H/W requires different register sets for preview and capture. For instance
only in the capture mode the flash control is performed. So it's important
to know whether we start in preview or capture mode, and these modes have distinct
registers for resolution setup, etc.
As a side note, I'm not highly interested in supporting snapshot mode with
S5K6AAFX. The M-5MOLS sensor is a better target for this, for instance.  

> 
> [clip]
> 
>>>> +
>>>> +/* Set horizontal and vertical image flipping */
>>>> +static int s5k6aa_set_mirror(struct s5k6aa *s5k6aa, int horiz_flip)
>>>> +{
>>>> +	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
>>>> +	struct s5k6aa_preset *preset = s5k6aa->preset;
>>>> +
>>>> +	unsigned int vflip = s5k6aa->ctrls.vflip->val ^ preset->inv_vflip;
>>>> +	unsigned int hflip = horiz_flip ^ preset->inv_hflip;
>>>
>>> I don't see a need to store inv_hflip to presets. Instead, you might just
>>> have a mirror bit in the platform data.
>>
>> Agreed, except I'd like to keep that in driver's private data structure,
>> not to rely on the platform data after the driver probing.
> 
> There's no reason to avoid using platform data after probing that I am aware
> of.

What I meant was that for DT enabled systems you won't have the platform data 
at all. Instead you parse the properties, that were so far being passed in 
platform data struct, from struct device_node (dev.of_node) in driver's probe().
So, in order to make things less complicated for DT probing case, I just put all
the properties in driver's private struct, not relying on any dereferencing of
the platform data. Which I know in advance may not exist in some cases. For
non-DT systems the attributes are copied from platform data and for DT-enabled
ones they will be retrieved from DT in probe(). Except that the driver behaves 
identical regardless of the way the device was created. This is really just
a prerequisite, still there is quite a few unresolved issues, like set_power/
clock callbacks into platform code.

Different topic is the design of the v4l2/media devices bindings. As it has been
already roughly discussed, we probably need a root DT node at the level of
nowadays media device. So various initialization dependencies between media
entities (host dev./subdevs) can be satisfied. This, at least, was my
understanding.

> 
>>>
>>>> +	return s5k6aa_write(client, REG_P_PREV_MIRROR(preset->index),
>>>> +			    hflip | (vflip<<  1));
>>>> +}
>>>> +
>> ...
>>>> +
>>>> +static int __s5k6aa_power_enable(struct s5k6aa *s5k6aa)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	ret = regulator_bulk_enable(S5K6AA_NUM_SUPPLIES, s5k6aa->supplies);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +	if (s5k6aa_gpio_deassert(s5k6aa, STBY))
>>>> +		udelay(200);
>>>
>>> It's a small delay but still a busy loop. What about usleep_range() for the
>>> same length?
>>
>> One could arque, but...yes, might make sense to change.
> 
> I guess it's up to how much time e.g. a task switch would take. These days 1
> GHz and over CPUs might be able to do something useful during that time. :)

Yes, the context switch, involving caches invalidation, might take some time.
I have never really measured that though. Also an overhead of setting up the high
resolution timer for usleep_range() should be considered. Nevertheless 
Documentation/timers-howto.txt recommends using udelay only up to 10 us delays.
So for 100..200 us it seems better to stick with usleep_range(). 

--
Regards,
Sylwester
