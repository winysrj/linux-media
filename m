Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4352 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFEMEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 08:04:44 -0400
Message-ID: <53905CA0.7040108@xs4all.nl>
Date: Thu, 05 Jun 2014 14:03:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC ATTN] Cropping, composing, scaling and S_FMT
References: <538C35A2.8030307@xs4all.nl> <20140604154012.13ddd6a9.m.chehab@samsung.com> <53901A41.70804@xs4all.nl> <20140605080620.53c6a803.m.chehab@samsung.com>
In-Reply-To: <20140605080620.53c6a803.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/05/14 13:06, Mauro Carvalho Chehab wrote:
> Em Thu, 05 Jun 2014 09:20:33 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 06/04/2014 08:40 PM, Mauro Carvalho Chehab wrote:
>>> Em Mon, 02 Jun 2014 10:28:18 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> During the media mini-summit I went through all 8 combinations of cropping,
>>>> composing and scaling (i.e. none of these features is present, or only cropping,
>>>> only composing, etc.).
>>>>
>>>> In particular I showed what I thought should happen if you change a crop rectangle,
>>>> compose rectangle or the format rectangle (VIDIOC_S_FMT).
>>>>
>>>> In my proposal the format rectangle would increase in size if you attempt to set
>>>> the compose rectangle wholly or partially outside the current format rectangle.
>>>> Most (all?) of the developers present didn't like that and I was asked to take
>>>> another look at that.
>>>>
>>>> After looking at this some more I realized that there was no need for this and
>>>> it is OK to constrain a compose rectangle to the current format rectangle. All
>>>> you need to do if you want to place the compose rectangle outside of the format
>>>> rectangle is to just change the format rectangle first. If the driver supports
>>>> composition then increasing the format rectangle will not change anything else,
>>>> so that is a safe operation without side-effects.
>>>
>>> Good!
>>>
>>>> However, changing the crop rectangle *can* change the format rectangle. In the
>>>> simple case of hardware that just supports cropping this is obvious, since
>>>> the crop and format rectangles must always be of the same size, so changing
>>>> one will change the other.
>>>
>>> True, but, in such case, I'm in doubt if it is worth to implement crop API
>>> support, as just format API support is enough. The drawback is that
>>> userspace won't know how to differentiate between:
>>>
>>> 1) scaler, no-crop, where changing the format changes the scaler;
>>> 2) crop, no scaler, where changing the format changes the crop region.
>>>
>>> That could easily be fixed with a new caps flag, to announce if a device 
>>> has scaler or not.
>>
>> Erm, the format just specifies a size, crop specifies a rectangle. You can't
>> use S_FMT to specify the crop rectangle.
> 
> You said above about the format rectangle, and not about the crop rectangle.
> I think we need first to use a consistent glossary on those discussions ;)
> 
> I'm understanding "format rectangle" as the one defined by S_FMT.

Sorry for the ambiguous terminology. S_FMT sets a size, not a rectangle.
So whenever I talk about a format rectangle, read format size.

> 
>> Also, this case of crop and no scaler exists today in various drivers and
>> works as described (I'm sure about vpfe_capture, vino and I believe that there
>> are various exynos drivers as well).
> 
> This is confusing, and some drivers actually set both format and crop
> rectangles at the same time, on S_FMT. See, for example, set_res() on:
> 	drivers/media/i2c/mt9v011.c
> 
> This one explicitly does crop for a random resolution, but there are other
> sensor drivers that have multiple resolutions that are actually doing
> crop instead of scaling, when changing the resolution, and don't implement
> the crop API (I think that this is the case, for example, of ov7670).
> 
> This is also the case of the gspca driver, and most of their sub-drivers.
> 
> I'd say that there are a lot more sensor drivers doing crop at S_FMT
> than via crop/selection API.
> 
> We need to decide what's the best way for apps to set it, and then
> see an strategy to migrate the non-compliant drivers. Whatever
> decision, we'll need to concern about backward compat.

These drivers just do not implement cropping (probably because nobody
ever needed it), instead they just center a crop window if the requested
image size is smaller than the sensor size. I would consider this out
of spec actually: if a sensor allows formats of a different size than
the native size, then that implies the presence of a scaler unless
crop functionality is present.

> 
>>>> But if you throw in a scaler as well, you usually
>>>> still have such constraints based on the scaler capabilities.
>>>>
>>>> So assuming a scaler that can only scale 4 times (or less) up or down in each
>>>> direction, then setting a crop rectangle of 240x160 will require that the
>>>> format rectangle has a width in the range of 240/4 - 240*4 (60-960) and a
>>>> height in the range of 160/4 - 160*4 (40-640). Anything outside of that will
>>>> have to be corrected.
>>>
>>> This can be done on two directions, e. g. rounding the crop area or
>>> rounding the scaler area.
>>>
>>> I is not obvious at all (nor backward compat) to change the format
>>> rectangle when the crop rea is changed.
>>>
>>> So, the best approach in this case is to round the crop rectangle to fit
>>> into the scaler limits, preserving the format rectangle.
>>
>> I disagree with that for several reasons:
>>
>> 1) In the case of no-scaler the format is already changed by s_crop in existing
>> drivers. That can't be changed. So doing something else if there is a scaler is
>> inconsistent behavior.
> 
> See above. The inconsistent behavior is already there.
> 
>> 2) The spec clearly specifies that changing the crop rectangle may change the
>> format size. It has always said so. From the section "Image Cropping, Insertion
>> and Scaling", "Scaling Adjustments":
>>
>> "Applications can change the source or the target rectangle first, as they may
>>  prefer a particular image size or a certain area in the video signal. If the
>>  driver has to adjust both to satisfy hardware limitations, the last requested
>>  rectangle shall take priority, and the driver should preferably adjust the
>>  opposite one. The VIDIOC_TRY_FMT ioctl however shall not change the driver
>>  state and therefore only adjust the requested rectangle."
>>
>> The two following paragraphs actually describe exactly the crop+scaler case and
>> how setting the crop rectangle can change the format size.
> 
> The above paragraph is too vague and leaves to several different
> interpretations. 
> 
> One could read that "last requested rectangle" simply means that, if 
> userspace calls a rectangle API call (like S_FMT) several times, the
> last one will prevail.

In this context it is IMHO clear that is not what was meant. And the following
two paragraphs in the spec make it clear as well.

Also read e.g. the VIDIOC_S_CROP documentation which also clearly states that
changing the crop rectangle can change the image size.

>> 3) If an application desires a specific crop rectangle that is possible by the
>> hardware but is changed just because the format size is not suitable, then it
>> is hard (perhaps even impossible) for the application to figure out how to change
>> the format so the crop request can be achieved. That's quite a different situation
>> compared to the compose case where that is easy to decide.
> 
> I don't think that this makes it impossible.
> 
> See, if an application wants a crop area of (cx, cy), it should take a S_FMT
> resolution (x, y) with an algo that will get the minimal resolution where
> cx >=x and cy >= y condition met.
> 
> So, let's say that a sensor supports those resolutions:	
> 	(160, 120)
> 	(176, 144)
> 	(320, 240)
> 	(352, 288)
> 	(640, 480)
> 	(800, 600)
> 	(1024, 768)
> 	(1280, 1024)
> 	(1600, 1200)
> 	(2048, 1536)
> 
> And one wants a crop area of (100, 80), the format rectangle that
> has more chance for the crop to work is (160, 120).
> 
> So, app should set res to (160, 120) and then set crop to (100, 80).
> 
> That's is more likely to work than setting a res (2048, 1536) and
> try to crop to (100, 80).
> 
>> 4) This is actually how bttv behaves. So this is well-established behavior.
> 
> Ok, this is actually a very good point, since the crop API was
> originally added for bttv, back in 2007.
> 
> That means that applications implementing the crop API should already
> be expecting the format resolution to change.
> 
> Yet, as I pointed, there's a huge number of drivers using S_FMT
> to actually set both crop and format rectangles without implementing
> the crop API.
> 
> I really don't think it is worth to change all of them.

What's the point of supporting crop if every driver implements it differently?
That makes supporting cropping in an application impossible.

I know very well that crop is implemented in different ways by different
drivers. That's the problem that needs to be solved by clearly defining how
it should behave. At least new drivers can be written correctly and older
drivers can be analyzed and fixed where possible.

I don't know what to tell an application developer that wants to implement
crop today because there are too many different behaviors. That needs to
be solved. And I want to have this described correctly in the spec and
tested by v4l2-compliance.

No more wild west, this stuff needs to be unambiguous and testable.

The lack of clarity w.r.t. the whole cropping/composing/formatting
relationship has always been a thorn in my side. If that means that I need
to change drivers to fix them, then I'll do that.

Regards,

	Hans
