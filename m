Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:54362 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbeI1VAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 17:00:23 -0400
Subject: Re: [PATCH 0/5] Add units to controls
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Helmut Grohne <helmut.grohne@intenta.de>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "rajmohan.mani@intel.com" <rajmohan.mani@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "ricardo.ribalda@gmail.com" <ricardo.ribalda@gmail.com>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "ping-chung.chen@intel.com" <ping-chung.chen@intel.com>,
        "andy.yeh@intel.com" <andy.yeh@intel.com>,
        "jim.lai@intel.com" <jim.lai@intel.com>,
        "snawrocki@kernel.org" <snawrocki@kernel.org>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925114802.ywbboqlfxe56qeei@laureti-dev>
 <20180925123031.b6ay5piaqymi7kht@paasikivi.fi.intel.com>
 <8813465.rN2hJgabfF@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8beb840c-253f-6530-df3e-9066e13a0c03@xs4all.nl>
Date: Fri, 28 Sep 2018 16:36:16 +0200
MIME-Version: 1.0
In-Reply-To: <8813465.rN2hJgabfF@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2018 03:25 PM, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday, 25 September 2018 15:30:31 EEST Sakari Ailus wrote:
>> On Tue, Sep 25, 2018 at 01:48:02PM +0200, Helmut Grohne wrote:
>>> On Tue, Sep 25, 2018 at 12:14:29PM +0200, Sakari Ailus wrote:
>>>> This set adds a few things to the current control framework in terms of
>>>> what kind of information the user space may have on controls. It adds
>>>> support for units and prefixes, exponential base as well as information
>>>> on whether a control is linear or exponential, to struct
>>>> v4l2_query_ext_ctrl.
>>>
>>> That's a great improvement. Being able to give meaning to controls is
>>> great. However, I see two significant weaknesses in the approach being
>>> taken:
>>>
>>> 1. There are a number of controls whose value is not easily described as
>>>    either linear or exponential. I'm faced with at least two controls
>>>    that actually are floating point numbers. One with two bits for the
>>>    exponent and one (strange) bit for the mantissa (no joke) and another
>>>    with three bits for the exponent and four bits for the mantissa.
>>>    Neither can suitably be represented.
>>>    
>>>    Since the value ranges are small for the cases I mentioned, I looked
>>>    into using an integer menu. The present approach does not allow for
>>>    replacing an integer with an integer menu though. Each control id has
>>>    a fixed type. I'm not sure how to solve this.
>>
>> The proposal does not address all potential situations, that's true.
>> There's no way to try to represent everything out there (without
>> enumerating the values) in an easily generalised way but something can be
>> done.
> 
> [1]
> 
>> There are devices such as some flash LED controllers where the flash current
>> if simply a value you can pick from the list. It's currently implemented as
>> an integer control. AFAIR the driver is drivers/leds/leds-aat1290.c .
>>
>>> 2. The present implementation places the responsibility of assigning
>>>    units and scales into drivers. A number of controls (e.g.
>>>    V4L2_CID_EXPOSURE_ABSOLUTE, V4L2_CID_AUDIO_LIMITER_RELEASE_TIME,
>>>    V4L2_CID_PIXEL_RATE, ...) clearly state the scale and unit in the
>>>    documentation. Having each and every driver set units and scales in
>>>    the documented way will lead to duplication and buggy code. Having
>>>    each driver choose unit and scale will lead to inconsistency. It
>>>    would be very good to have a mechanism that puts the framework in
>>>    charge of maintaining units and scales for the standard control ids.
>>>    
>>>    What is a consumer supposed to do with a control that changes unit?
>>>    The algorithm expected e.g. a duration. It might be able to convert
>>>    to pixels, but what should it do if it gets back amperes? I argue
>>>    that the unit should be a property of the control id and be
>>>    documented (i.e. what is done now). If it is reported via an ioctl,
>>
>> The fact is that the unit is specific to hardware. The documentation
>> documents something, and often suggests a unit, but if the hardware does
>> something else, then that's what you get --- independently of what the
>> documentation says.
>>
>> Hence the need to convey it via the API.
>>
>> Some controls could have the unit set by the framework if that makes sense.
>> Most drivers shouldn't actually need to touch this if they're fine with
>> defaults (whenever a control has a default).
> 
> I have to agree with Helmut here. If we don't handle the 95% of the common 
> cases in the core, we'll never get it right. Drivers will be buggy in many 
> ways. Which leads me to a related comment, we need v4l2-compliance support for 
> this, to verify that each control reports valid information.

Indeed.

> 
>>>    the framework needs to be in charge of setting it.
>>>    
>>>    The story is much different for scales. Scaling the value up and down
>>>    is something consumers can reasonably be expected to do. It allows
>>>    shifting the value range such that the relevant values can be fully
>>>    represented. Allowing drivers to change scales is much more
>>>    reasonable. Still the framework should provide a default such that
>>>    most drivers should not need any update.
>>>
>>> I acknowledge that these expectations are high and see that they're
>>> partially covered in your later remarks.
>>>
>>>> The smiapp driver gains support for the feature. In the near term, some
>>>> controls could also be assigned the unit automatically. The pixel rate,
>>>> for instance. Fewer driver changes would be needed this way. A driver
>>>> could override the value if there's a need to.
>>>
>>> I believe that in the interest of keeping maintenance cost low, this
>>> should happen rather sooner than later. Just even adding the support to
>>> smiapp seems wrong when it would be possible to have the framework do
>>> the work.
>>>
>>>> I think I'll merge the undefined and no unit cases. Same for the
>>>> exponential base actually --- the flag can be removed, too...
>>>
>>> I'm not sure I understand. It reads like you are going to revert a
>>> significant part of the patch.
>>
>> A macro or two, it's not a major change. From the user space point of view,
>> does it make a difference if a control has no unit or when it's not known
>> what the unit is?
>>
>>>> Regarding Ricardo's suggestion --- I was thinking of adding a control
>>>> flag (yes, there are a few bits available) to tell how to round the
>>>> value. The user could use the TRY_EXT_CTRLS IOCTL to figure out the next
>>>> (or previous) control value by incrementing the current value and
>>>> setting the appropriate flag. This is out of the scope of this set
>>>> though.
>>>
>>> This approach sounds really useful to me. Having control over the
>>> rounding would allow reading supported control values with reasonable
>>> effort.
> 
> That would result in way too many ioctl calls though. If we design an API to 
> report all valid values, we have to do it through a single ioctl call. I'm 
> however not opposed to rounding flags, as there could be a separate use for 
> that, but I'm concerned that drivers will not use them correctly and 
> consistently if we don't implement support for them in the core (and for any 
> integer control that can't be accurately represented by min, max and step, I 
> don't think we can).

We have rounding defines for the selection API as well: almost nobody uses them,
and they are hard to maintain and to verify. I can't say I am enthusiastic
about adding a rounding flag. Unless this can all be implemented in the core
together with v4l2-compliance checks to prevent regressions.

> 
> I'm also concerned about over-engineering a solution for a problem that I'm 
> still not convinced does exist. Applications needing precise information about 
> control will very likely be device-aware in my opinion (due to [1]). I'm open 
> to debating this, in which case I would ask for real use cases, and a real 
> implementation (in something else than a test program).
> 
> V4L2 is bloated with micro-features that have been badly designed and that are 
> mostly unused, let's try to get it right this time.
> 
>>> With such an approach, a very sparsely populated control becomes
>>> feasible and with integer64 controls that'd likely allow representing
>>> most exponential controls with linear values. If going this route, I
>>> don't see an application of V4L2_CTRL_FLAG_EXPONENTIAL.
>>
>> Yes, I think the flag can be dropped as I suggested.
>>
>>> Thus, I think that control over the rounding is tightly related to this
>>> patchset and needs to be discussed together.
>>
>> It addresses some of the same problem area but the implementation is
>> orthogonal to this.
>>
>> Providing that would probably make the base field less useful: the valid
>> control values could be enumerated by the user using TRY_EXT_CTRLS without
>> the need to tell the valid values are powers of e.g. two.

Another concern I have about the base field is how likely it is that it
actually follows the correct curve. Most gain or whatever curves depend on
the hardware details and are never perfect.

>>
>> I don't really have a strong opinion on that actually when it comes to the
>> API itself. The imx208 driver could proceed to use linear relation between
>> the control value and the digital gain. My worry is just the driver
>> implementation: this may not be entirely trivial. There's still no way to
>> address this problem in a generic way otherwise.
> 

Regards,

	Hans
