Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59815 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754731AbdHYIOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 04:14:07 -0400
Subject: Re: DRM Format Modifiers in v4l2
To: Brian Starkey <brian.starkey@arm.com>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
 <CAKMK7uFdQPUomZDCp_ak6sTsUayZuut4us08defjKmiy=24QnA@mail.gmail.com>
 <47128f36-2990-bd45-ead9-06a31ed8cde0@xs4all.nl>
 <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
 <ba202456-4bc6-733e-4950-88ce64ca990e@xs4all.nl>
 <20170824122647.GA28829@e107564-lin.cambridge.arm.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>, jonathan.chai@arm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <af5d5cc3-b87f-25d8-4d66-bb027e38721a@xs4all.nl>
Date: Fri, 25 Aug 2017 10:14:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170824122647.GA28829@e107564-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/08/17 14:26, Brian Starkey wrote:
> On Thu, Aug 24, 2017 at 01:37:35PM +0200, Hans Verkuil wrote:
>> On 08/24/17 13:14, Brian Starkey wrote:
>>> Hi Hans,
>>>
>>> On Mon, Aug 21, 2017 at 06:36:29PM +0200, Hans Verkuil wrote:
>>>> On 08/21/2017 06:01 PM, Daniel Vetter wrote:
>>>>> On Mon, Aug 21, 2017 at 5:52 PM, Brian Starkey <brian.starkey@arm.com> wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> I couldn't find this topic talked about elsewhere, but apologies if
>>>>>> it's a duplicate - I'll be glad to be steered in the direction of a
>>>>>> thread.
>>>>>>
>>>>>> We'd like to support DRM format modifiers in v4l2 in order to share
>>>>>> the description of different (mostly proprietary) buffer formats
>>>>>> between e.g. a v4l2 device and a DRM device.
>>>>>>
>>>>>> DRM format modifiers are defined in include/uapi/drm/drm_fourcc.h and
>>>>>> are a vendor-namespaced 64-bit value used to describe various
>>>>>> vendor-specific buffer layouts. They are combined with a (DRM) FourCC
>>>>>> code to give a complete description of the data contained in a buffer.
>>>>>>
>>>>>> The same modifier definition is used in the Khronos EGL extension
>>>>>> EGL_EXT_image_dma_buf_import_modifiers, and is supported in the
>>>>>> Wayland linux-dmabuf protocol.
>>>>>>
>>>>>>
>>>>>> This buffer information could of course be described in the
>>>>>> vendor-specific part of V4L2_PIX_FMT_*, but this would duplicate the
>>>>>> information already defined in drm_fourcc.h. Additionally, there
>>>>>> would be quite a format explosion where a device supports a dozen or
>>>>>> more formats, all of which can use one or more different
>>>>>> layouts/compression schemes.
>>>>>>
>>>>>> So, I'm wondering if anyone has views on how/whether this could be
>>>>>> incorporated?
>>>>>>
>>>>>> I spoke briefly about this to Laurent at LPC last year, and he
>>>>>> suggested v4l2_control as one approach.
>>>>>>
>>>>>> I also wondered if could be added in v4l2_pix_format_mplane - looks
>>>>>> like there's 8 bytes left before it exceeds the 200 bytes, or could go
>>>>>> in the reserved portion of v4l2_plane_pix_format.
>>>>>>
>>>>>> Thanks for any thoughts,
>>>>>
>>>>> One problem is that the modifers sometimes reference the DRM fourcc
>>>>> codes. v4l has a different (and incompatible set) of fourcc codes,
>>>>> whereas all the protocols and specs (you can add DRI3.1 for Xorg to
>>>>> that list btw) use both drm fourcc and drm modifiers.
>>>>>
>>>>> This might or might not make this proposal unworkable, but it's
>>>>> something I'd at least review carefully.
>>>>>
>>>>> Otherwise I think it'd be great if we could have one namespace for all
>>>>> modifiers, that's pretty much why we have them. Please also note that
>>>>> for drm_fourcc.h we don't require an in-kernel user for a new modifier
>>>>> since a bunch of them might need to be allocated just for
>>>>> userspace-to-userspace buffer sharing (e.g. in EGL/vk). One example
>>>>> for this would be compressed surfaces with fast-clearing, which is
>>>>> planned for i915 (but current hw can't scan it out). And we really
>>>>> want to have one namespace for everything.
>>>>
>>>> Who sets these modifiers? Kernel or userspace? Or can it be set by both?
>>>> I assume any userspace code that sets/reads this is code specific for that
>>>> hardware?
>>>
>>> I think normally the modifier would be set by userspace. However it
>>> might not necessarily be device-specific code. In DRM the intention is
>>> for userspace to query the set of modifiers which are supported, and
>>> then use them without necessarily knowing exactly what they mean
>>> (insofar as that is possible).
>>>
>>> e.g. if I have two devices which support MODIFIER_FOO, I could attempt
>>> to share a buffer between them which uses MODIFIER_FOO without
>>> necessarily knowing exactly what it is/does.
>>>
>>>>
>>>> I think Laurent's suggestion of using a 64 bit V4L2 control for this makes
>>>> the most sense.
>>>>
>>>> Especially if you can assume that whoever sets this knows the hardware.
>>>>
>>>> I think this only makes sense if you pass buffers from one HW device to another.
>>>>
>>>> Because you cannot expect generic video capture code to be able to interpret
>>>> all the zillion different combinations of modifiers.
>>>
>>> I don't quite follow this last bit. The control could report the set
>>> of supported modifiers.
>>
>> What I mean was: an application can use the modifier to give buffers from
>> one device to another without needing to understand it.
>>
>> But a generic video capture application that processes the video itself
>> cannot be expected to know about the modifiers. It's a custom HW specific
>> format that you only use between two HW devices or with software written
>> for that hardware.
>>
> 
> Yes, makes sense.
> 
>>>
>>> However, in DRM the API lets you get the supported formats for each
>>> modifier as-well-as the modifier list itself. I'm not sure how exactly
>>> to provide that in a control.
>>
>> We have support for a 'menu' of 64 bit integers: V4L2_CTRL_TYPE_INTEGER_MENU.
>> You use VIDIOC_QUERYMENU to enumerate the available modifiers.
>>
>> So enumerating these modifiers would work out-of-the-box.
> 
> Right. So I guess the supported set of formats could be somehow
> enumerated in the menu item string. In DRM the pairs are (modifier +
> bitmask) where bits represent formats in the supported formats list
> (commit db1689aa61bd in drm-next). Printing a hex representation of
> the bitmask would be functional but I concede not very pretty.

So this patch limits the number of formats to 64 (being the size of
the bit mask). I was hoping these modifiers applied to all formats,
but unfortunately that isn't the case apparently.

How it would work with my proposal is that the integer menu control
would reflect the list of supported modifiers for the currently selected
format. If you change format, then the available modifier list changes
as well. The advantage is that there is no '64 formats' limitation,
something that I feel very uncomfortable about since some devices support
a *lot* of formats. The disadvantage is that it is harder to get a quick
overview of all combinations for formats and modifiers.

This has more to do with limitations in the V4L2 API than with supporting
modifiers in general. We need something better to give userspace a quick
overview of all combinations of pixelformats, framesizes, frameintervals
and now modifiers. However, that's our problem :-)

Regards,

	Hans

> 
> Cheers,
> -Brian
> 
>>
>> Regards,
>>
>>     Hans
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
