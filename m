Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39594 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750780AbdH3IKF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 04:10:05 -0400
Subject: Re: DRM Format Modifiers in v4l2
To: Daniel Vetter <daniel@ffwll.ch>,
        Brian Starkey <brian.starkey@arm.com>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
 <CAKMK7uFdQPUomZDCp_ak6sTsUayZuut4us08defjKmiy=24QnA@mail.gmail.com>
 <47128f36-2990-bd45-ead9-06a31ed8cde0@xs4all.nl>
 <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
 <ba202456-4bc6-733e-4950-88ce64ca990e@xs4all.nl>
 <20170824122647.GA28829@e107564-lin.cambridge.arm.com>
 <1503943642.3316.7.camel@ndufresne.ca>
 <CAKMK7uGaQ+9cZ2PyLkwC06Qpch3AK+Tkr4SZFZVLfUqUFKyygQ@mail.gmail.com>
 <20170829094701.GB26907@e107564-lin.cambridge.arm.com>
 <20170830075035.ojzhefm3ysqzigkg@phenom.ffwll.local>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4399d87d-9b60-1d8b-cb83-b62f134a0aa5@xs4all.nl>
Date: Wed, 30 Aug 2017 10:10:01 +0200
MIME-Version: 1.0
In-Reply-To: <20170830075035.ojzhefm3ysqzigkg@phenom.ffwll.local>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/08/17 09:50, Daniel Vetter wrote:
> On Tue, Aug 29, 2017 at 10:47:01AM +0100, Brian Starkey wrote:
>> On Mon, Aug 28, 2017 at 10:49:07PM +0200, Daniel Vetter wrote:
>>> On Mon, Aug 28, 2017 at 8:07 PM, Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
>>>> Le jeudi 24 ao??t 2017 ?? 13:26 +0100, Brian Starkey a ??crit :
>>>>>> What I mean was: an application can use the modifier to give buffers from
>>>>>> one device to another without needing to understand it.
>>>>>>
>>>>>> But a generic video capture application that processes the video itself
>>>>>> cannot be expected to know about the modifiers. It's a custom HW specific
>>>>>> format that you only use between two HW devices or with software written
>>>>>> for that hardware.
>>>>>>
>>>>>
>>>>> Yes, makes sense.
>>>>>
>>>>>>>
>>>>>>> However, in DRM the API lets you get the supported formats for each
>>>>>>> modifier as-well-as the modifier list itself. I'm not sure how exactly
>>>>>>> to provide that in a control.
>>>>>>
>>>>>> We have support for a 'menu' of 64 bit integers: V4L2_CTRL_TYPE_INTEGER_MENU.
>>>>>> You use VIDIOC_QUERYMENU to enumerate the available modifiers.
>>>>>>
>>>>>> So enumerating these modifiers would work out-of-the-box.
>>>>>
>>>>> Right. So I guess the supported set of formats could be somehow
>>>>> enumerated in the menu item string. In DRM the pairs are (modifier +
>>>>> bitmask) where bits represent formats in the supported formats list
>>>>> (commit db1689aa61bd in drm-next). Printing a hex representation of
>>>>> the bitmask would be functional but I concede not very pretty.
>>>>
>>>> The problem is that the list of modifiers depends on the format
>>>> selected. Having to call S_FMT to obtain this list is quite
>>>> inefficient.
>>>>
>>>> Also, be aware that DRM_FORMAT_MOD_SAMSUNG_64_32_TILE modifier has been
>>>> implemented in V4L2 with a direct format (V4L2_PIX_FMT_NV12MT). I think
>>>> an other one made it the same way recently, something from Mediatek if
>>>> I remember. Though, unlike the Intel one, the same modifier does not
>>>> have various result depending on the hardware revision.
>>>
>>> Note on the intel modifers: On most recent platforms (iirc gen9) the
>>> modifier is well defined and always describes the same byte layout. We
>>> simply didn't want to rewrite our entire software stack for all the
>>> old gunk platforms, hence the language. I guess we could/should
>>> describe the layout in detail, but atm we're the only ones using it.
>>>
>>> On your topic of v4l2 encoding the drm fourcc+modifier combo into a
>>> special v4l fourcc: That's exactly the mismatch I was thinking of.
>>> There's other examples of v4l2 fourcc being more specific than their
>>> drm counters (e.g. specific way the different planes are laid out).
>>
>> I'm not entirely clear on the v4l2 fourccs being more specific than
>> DRM ones - do you mean e.g. NV12 vs NV12M? Specifically in the case of
>> multi-planar formats I think it's a non-issue because modifiers are
>> allowed to alter the number of planes and the meanings of them. Also
>> V4L2 NV12M is a superset of NV12 - so NV12M would always be able to
>> describe a DRM NV12 buffer.
>>
>> I don't see the "special v4l2 format already exists" case as a problem
>> either. It would be up to any drivers that already have special
>> formats to decide if they want to also support it via a more generic
>> modifiers API or not.
>>
>> The fact is, adding special formats for each combination is
>> unmanageable - we're talking dozens in the case of our hardware.
> 
> Hm right, we can just remap the special combos to the drm-fourcc +
> modifier style. Bonus point if v4l does that in the core so not everyone
> has to reinvent that wheel :-)

Probably not something we'll do: there are I believe only two drivers that
are affected (exynos & mediatek), so they can do that in their driver.

Question: how many modifiers will typically apply to a format? I ask
because I realized that V4L2 could use VIDIOC_ENUMFMT to make the link
between a fourcc and modifiers:

https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-enum-fmt.html

The __u32 reserved[4] array can be used to provide a bitmask to modifier
indices (for the integer menu control). It's similar to what drm does,
except instead of modifiers mapping to fourccs it is the other way around.

This would avoid having to change the modifiers control whenever a new
format is set and it makes it easy to enumerate all combinations.

But this only works if the total number of modifiers used by a single driver
is expected to remain small (let's say no more than 64).

Regards,

	Hans
