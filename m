Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41469 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257Ab1JFUBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 16:01:15 -0400
Received: by ywb5 with SMTP id 5so2966341ywb.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 13:01:15 -0700 (PDT)
Message-ID: <4E8E08F2.10904@gmail.com>
Date: Thu, 06 Oct 2011 22:00:50 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
References: <1316627107-18709-1-git-send-email-s.nawrocki@samsung.com> <1316627107-18709-3-git-send-email-s.nawrocki@samsung.com> <20110922220259.GS1845@valkosipuli.localdomain> <4E7C5BAA.9090900@samsung.com> <20110925100804.GU1845@valkosipuli.localdomain> <4E7F5DEC.8020808@gmail.com> <20110927205532.GA6180@valkosipuli.localdomain> <4E86DAA7.4@gmail.com> <20111002072011.GJ6180@valkosipuli.localdomain>
In-Reply-To: <20111002072011.GJ6180@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Sakari,

On 10/02/2011 09:20 AM, Sakari Ailus wrote:
> On Sat, Oct 01, 2011 at 11:17:27AM +0200, Sylwester Nawrocki wrote:
>> Hi Sakari,
>>
>> I'm sorry, I've been a little bit busy in the week to get back to this.
> 
> Hi Sylwester,
> 
> No worries!
> 
>> On 09/27/2011 10:55 PM, Sakari Ailus wrote:
>>> Sylwester Nawrocki wrote:
>>>> On 09/25/2011 12:08 PM, Sakari Ailus wrote:
>>>>> On Fri, Sep 23, 2011 at 12:12:58PM +0200, Sylwester Nawrocki wrote:
>>>>>> On 09/23/2011 12:02 AM, Sakari Ailus wrote:
>>>>>>> Hi Sylwester,
>>>>>>>
>>>>>>> I have a few additional comments below, they don't depend on my earlier
>>>>>>> ones.
>>>>>>
>>>>>> Thanks a lot for your follow up review!
>>>>>>>
>>>>>>> On Wed, Sep 21, 2011 at 07:45:07PM +0200, Sylwester Nawrocki wrote:
>>>>>>>> This driver exposes preview mode operation of the S5K6AAFX sensor with
>>>>>>>> embedded SoC ISP. It uses one of the five user predefined configuration
>>>>>>>> register sets. There is yet no support for capture (snapshot) operation.
>>>>>>>> Following controls are supported:
>>>>>>>> manual/auto exposure and gain, power line frequency (anti-flicker),
>>>>>>>> saturation, sharpness, brightness, contrast, white balance temperature,
>>>>>>>> color effects, horizontal/vertical image flip, frame interval.
>>>>>>>>
>>>>>>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>>>>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>>>>>> ---
>>>>>> ...
>>>>>>>> +
>>>>>>>> +struct s5k6aa_pixfmt {
>>>>>>>> +	enum v4l2_mbus_pixelcode code;
>>>>>>>> +	u32 colorspace;
>>>>>>>> +	/* REG_P_FMT(x) register value */
>>>>>>>> +	u16 reg_p_fmt;
>>>>>>>> +};
>>>>>>>> +
>>>>>>>> +struct s5k6aa_preset {
>>>>>>>> +	struct v4l2_frmsize_discrete out_size;
>>>>>>>> +	struct v4l2_rect in_win;
>>>>>>>> +	const struct s5k6aa_pixfmt *pixfmt;
>>>>>>>> +	unsigned int inv_hflip:1;
>>>>>>>> +	unsigned int inv_vflip:1;
>>>>>>>> +	u8 frame_rate_type;
>>>>>>>> +	u8 index;
>>>>>>>> +};
>>>>>>>> +
>>>>>
>>>>> [clip]
>>>>>
>>>>>>>> +/* Set initial values for all preview presets */
>>>>>>>> +static void s5k6aa_presets_data_init(struct s5k6aa *s5k6aa,
>>>>>>>> +				     int hflip, int vflip)
>>>>>>>> +{
>>>>>>>> +	struct s5k6aa_preset *preset =&s5k6aa->presets[0];
>>>>>>>> +	int i;
>>>>>>>> +
>>>>>>>> +	for (i = 0; i<    S5K6AA_MAX_PRESETS; i++) {
>>>>>>>> +		preset->pixfmt		=&s5k6aa_formats[0];
>>>>>>>> +		preset->frame_rate_type	= FR_RATE_DYNAMIC;
>>>>>>>> +		preset->inv_hflip	= hflip;
>>>>>>>> +		preset->inv_vflip	= vflip;
>>>>>>>> +		preset->out_size.width	= S5K6AA_OUT_WIDTH_DEF;
>>>>>>>> +		preset->out_size.height	= S5K6AA_OUT_HEIGHT_DEF;
>>>>>>>> +		preset->in_win.width	= S5K6AA_WIN_WIDTH_MAX;
>>>>>>>> +		preset->in_win.height	= S5K6AA_WIN_HEIGHT_MAX;
>>>>>>>> +		preset->in_win.left	= 0;
>>>>>>>> +		preset->in_win.top	= 0;
>>>>>>>
>>>>>>> Much of this data is static, why is it copied to the presets struct?
>>>>>>>
>>>>>>> What is the intended purpose of these presets?
>>>>>>
>>>>>> I agree there is no need to keep inv_hflip/inv_vflip there. It's more a
>>>>>> leftover from previous driver version. I'll move it to struct s5k6aa.
>>>>>> And I try to keep copy of each platform_data attribute in driver's
>>>>>> private struct to make future transition to DT driver probing easier.
>>>>>>
>>>>>> inv_[hv]flip variables are used to indicate physical layout of the sensor,
>>>>>> as it varies across multiple machines. So indeed they're global, not per
>>>>>> the configuration set.
>>>>>>
>>>>>> Preset are there in the s5k6aafx register interface to allow fast transition
>>>>>> between, for instance, low resolution preview and high resolution snapshot.
>>>>>> I'm planning to use this driver as an experimental rabbit for the future
>>>>>> snapshot mode API.
>>>>>
>>>>> It sounds like that a "snapshot mode" would be an use case that presets
>>>>> could support in a way, but what I'd really like to ask is how much
>>>>> advantage one can get by using this mode, say, vs. re-programming the same
>>>>> settings over the I2C bus? The bus transfers (I assume) roughly 40 kB/s, so
>>>>> I imagine a few tens of register writes can be avoided by most, taking
>>>>> somewhere in the range of a few milliseconds.
>>>>
>>>> As far as the timings are concerned, for this particular device, the
>>>> advantage is not really meaningful. We are talking about appr. 20
>>>> registers (~50 bytes on I2C bus), which is a ridiculously low number.
>>>> However, even if the interface isn't exposed to user space, in the
>>>> hardware there exist separate registers for preview and (still) capture
>>>> and it makes much sense in the driver to model this, for easier device
>>>> control.
>>>
>>> How do you know when to switch the preset if you don't expose this to the
>>> user space?
>>
>> I don't, the user configuration data structure is there in the driver to more
>> precisely reflect the control interface of the device and better understand
>> what this driver supports and what it doesn't. Even if I use only one user
>> configuration register set _internally_ in the driver, there must be some
>> information provided to the device associated with it, like which user config
>> set we use, which clocks configuration applies to it, etc. Please don't make
>> me converting this driver to a total mess. :)
> 
> :)
> 
> Indeed. After reading the patch 4th time, I realised there's just one preset
> supported right now.
> 
> I found a relatively decent datasheet, too.

Nice. There is also some more details in the available application note. 

> 
>>> I'm not sure if this makes it easier for the user space. The user space must
>>> know about such a think and aslo which parameters it applies to. I don't
>>
>> Yes, I agree on this entirely.
>>
>>> think this ocnforms to V4L2 either, but I might have misunderstood
>>> something.
>>
>> If there is anything in the code not conforming to V4L2 please indicate it
>> clearly.
> 
> Ok, what the driver currently implements, does conform to V4L2. But getting
> advantage (which I'd like to argue might be irrelevant) using different
> presets would be challenging to implement while obeying the V4L2 spec.
> 
>>>> Anyway, I've taken a closer look at what I need in the single user
>>>> configuration set data structure and reworked the driver quite
>>>> extensively. Should post that in the coming week, unless some unexpected
>>>> disasters occur;)
>>>>
>>>> Do you see any problem in defining real still capture interface in V4L ?
>>>> It's probably just a small set of new controls, new capability, plus
>>>> multi-size buffer queue Guennadi has been working on. Some devices will
>>>> require explicitly switching between preview and capture mode, and it may
>>>> make difference if they are programmed in advance or on demand.
>>>
>>> I don't think V4L2 should have a still capture interface. Still capture is
>>> just one use case as viewfinder and video. V4L2 deals with frames, formats
>>> and parameters that are all generic and use case independent. Instead of use
>>> cases, we have independent configurable settings and that's the way I think
>>> it should stay.
>>>
>>> If your hardware requires switching mode to "still" before taking a still
>>> image, then the driver should expose this functionality as such. I'd be
>>
>> Yeah, of course this should work. But I don't quite see how would I expose the
>> "still"/"normal" switch control with existing API. Aren't you going to blackball
>> this as just another 'use case' ? :)
> 
> That's fine because it's implemented by the sensor already. My point is that
> we should only show this fact in V4L2 API as little as possible.
> 
> I remember Guennadi had sensors which provide something called "snapshot
> mode". A single boolean control to turn this on or off would suffice ---
> snapshot mode is something that's going to be discussed in the Multimedia
> summit if my memory serves me right.

Perhaps, although I don't expect huge outcome from one or two days meeting. 
Hopefully it gets us closer into the right direction. 
I'll try to prepare a brief summary of the m-5mols sensor requirements. 

> 
> This could be one option for this sensor as well but the implementation
> might not be quite optimal since you'd still need to switch the
> configuration.

I believe the final result would be acceptable as well.

However I recall going through a datasheet of a camera device which was capable
of generating simultaneously low resolution YUV and a higher resolution capture 
JPEG data stream. Either on same MIPI-CSI channel or on separate ones. This was
to achieve so called "zero shutter lag".
For this kind of device you may need two separate resolutions, at least
an application and the driver must keep track of them.   

> 
>> In fact preview/still mode control seems to be a minimum needed to expose full
>> functionality of the S5K6AAFX device in V4L2 API. But I am not really interested
>> in "still" capture with this device ATM. The current driver is more than enough :)
>>
>>> really wary of e.g. exposing register configuration flipping to user space
>>> even if the driver can do that.
>>
>> Nor do I intend to make such attempts in the future, neither there is anything
>> like this in my driver.
> 
> Ack.
> 
>>>> If the hardware (or it's firmware) supports something natively why should
>>>> we go for a less efficient SW emulated replacement? After all, preview and
>>>> capture mode seem pretty basic features that applications will want to
>>>> use.
>>>
>>> I think it depends on an application. If your application only knows it
>>> wants to do "viewfinder" or "capture" then it might be V4L2 could be a too
>>> low level interface for that job.
>>
>> Sorry, this is all not about the applications capabilities. Only about the V4L2 API
>> limitations in using the existing devices.
>>
>>>
>>> I might suggest GSTphotography instead.
>>
>> GstPhotography is not really impressive in its current state:
>> http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-bad-plugins/html/GstPhotography.html
> 
> I'm probably not the best person to comment on this, but do you think
> something is e.g. either missing or should be implemented differently?

I'm not a big expert either. The GstPhotography interface seems not well documented,
I just tried to imagine how it could be used with above mentioned camera chip
supporting interlaced viewfinder/capture data stream.  

> 
>> It still belongs to the Bad Plugins group, right ?
> 
> That's right.
> 
>> Although I am not an OpenMAX advocate, it seems top have a better defined interface
>> (chapter 8.9.1).
>> http://www.khronos.org/registry/omxil/specs/OpenMAX_IL_1_1_2_Specification.pdf
>>
>>>
>>>>> I would rather measure and attempt to optimise the register writes in the
>>>>> driver first before adding complexity to user space interface.
>>>>
>>>> Yeah, I'm not planning to use the presets plainly for different user
>>>> configurations, just trying to design the driver so those may be utilised
>>>> for the device various operation modes.
>>>>
>>>>>
>>>>> Or do the presets provide other advantages than just storing configurations?
>>>>
>>>> The H/W requires different register sets for preview and capture. For
>>>> instance only in the capture mode the flash control is performed. So it's
>>>> important to know whether we start in preview or capture mode, and these
>>>> modes have distinct registers for resolution setup, etc. As a side note,
>>>> I'm not highly interested in supporting snapshot mode with S5K6AAFX. The
>>>> M-5MOLS sensor is a better target for this, for instance.
>>>
>>> As far as I understand, the M-5MOLS indeed needs to know it's capturing a
>>> still image. Raw non-smart sensors, however, don't even recognise such a
>>> concept.
>>
>> Yes. Although the world is not all made of raw ("non-smart") sensorer
>> + local SoC ISP configurations.
> 
> I intended to refer to that as an example only.

Sorry, I must just have overreacted here.


-- 
Regards,
Sylwester
