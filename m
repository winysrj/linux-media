Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42818 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2HNMpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 08:45:03 -0400
Received: by ggdk6 with SMTP id k6so366347ggd.19
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 05:45:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502A47F5.5050008@redhat.com>
References: <201208131427.56961.hverkuil@xs4all.nl> <2697809.QgTso8NvEE@avalon>
 <201208141254.34095.hverkuil@xs4all.nl> <502A47F5.5050008@redhat.com>
From: Chinmay V S <cvs268@gmail.com>
Date: Tue, 14 Aug 2012 18:14:31 +0530
Message-ID: <CAK-9PRDXP3Cj80beJeSx3PU+xOqLaFLGjuuKKaeV84KwfE87qg@mail.gmail.com>
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	workshop-2011@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 14, 2012 at 6:13 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 08/14/2012 12:54 PM, Hans Verkuil wrote:
>>
>> On Tue August 14 2012 01:54:16 Laurent Pinchart wrote:
>>>
>>> Hi Hans,
>>>
>>> On Monday 13 August 2012 14:27:56 Hans Verkuil wrote:
>>>>
>>>> Hi all!
>>>>
>>>> As part of the 2012 Kernel Summit V4L2 workshop I will be discussing a
>>>> bunch
>>>> of V4L2 ambiguities/improvements.
>>>>
>>>> I've made a list of all the V4L2 issues and put them in two categories:
>>>> issues that I think are easy to resolve (within a few minutes at most),
>>>> and
>>>> those that are harder.
>>>>
>>>> If you think I put something in the easy category that you believe is
>>>> actually hard, then please let me know.
>>>>
>>>> If you attend the workshop, then please read through this and think
>>>> about it
>>>> a bit, particularly for the second category.
>>>>
>>>> If something is unclear, or you think another topic should be added,
>>>> then
>>>> let me know as well.
>>>>
>>>> Easy:
>>>
>>>
>>> [snip]
>>>
>>>> 4) What should a driver return in TRY_FMT/S_FMT if the requested format
>>>> is
>>>> not supported (possible behaviours include returning the currently
>>>> selected
>>>> format or a default format).
>>>>
>>>>     The spec says this: "Drivers should not return an error code unless
>>>> the
>>>> input is ambiguous", but it does not explain what constitutes an
>>>> ambiguous
>>>> input. Frankly, I can't think of any and in my opinion TRY/S_FMT should
>>>> never return an error other than EINVAL (if the buffer type is
>>>> unsupported)
>>>> or EBUSY (for S_FMT if streaming is in progress).
>>>>
>>>>     Returning an error for any other reason doesn't help the application
>>>> since the app will have no way of knowing what to do next.
>>>
>>>
>>> That wasn't my point. Drivers should obviously not return an error. Let's
>>> consider the case of a driver supporting YUYV and MJPEG. If the user
>>> calls
>>> TRY_FMT or S_FMT with the pixel format set to RGB565, should the driver
>>> return
>>> a hardcoded default format (one of YUYV or MJPEG), or the currently
>>> selected
>>> format ? In other words, should the pixel format returned by TRY_FMT or
>>> S_FMT
>>> when the requested pixel format is not valid be a fixed default pixel
>>> format,
>>> or should it depend on the currently selected pixel format ?
>>
>>
>> Actually, in this case I would probably choose a YUYV format that is
>> closest
>> to the requested size. If a driver supports both compressed and
>> uncompressed
>> formats, then it should only select a compressed format if the application
>> explicitly asked for it. Handling compressed formats is more complex than
>> uncompressed formats, so that seems a sensible rule.
>>
>> The next heuristic I would apply is to choose a format that is closest to
>> the
>> requested size.
>
>
> Size as in resolution or size as in bpp?
>
>
>> So I guess my guidelines would be:
>>
>> 1) If the pixelformat is not supported, then choose an uncompressed format
>> (if possible) instead.
>> 2) Next choose a format closest to, but smaller than (if possible) the
>> requested size.
>>
>> But this would be a guideline only, and in the end it should be up to the
>> driver. Just as long TRY/S_FMT always returns a format.
>
>
> I think we're making this way too complicated. I agree that TRY/S_FMT should
> always returns a format and not EINVAL, but other then that lets just
> document
> that if the driver does not know the passed in format it should return a
> default
> format and not make this dependent on the passed in fmt, esp. since
> otherwise
> the driver would need to know about all formats it does not support to best
> map
> that to a one which it does support, which is just crazy.
>
> So I suggest adding the following to the spec:
>
> When a driver receives an unsupported pixfmt as input on a TRY/S_FMT call it
> should replace this with a default pixfmt, independent of input pixfmt and
> current driver state. Preferably a driver uses a well known uncompressed
> pixfmt as its default.
>
>
> Regards,
>
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Consistent results for TRY_FMT calls with the exact same parameters
seems proper from an application's perspective.

One reason why anyone would want the driver to return the current
format would be if there is some penalty associated with switching
formats in the driver/hardware. Currently, if one expects to avoid
such a penalty, one can always explicitly code for that in the
application by calling G_FMT rather than solely depending on the
result of TRY_FMT.

regards
CVS
