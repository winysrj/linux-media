Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.53]:38372 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbaFEHUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jun 2014 03:20:41 -0400
Message-ID: <53901A41.70804@xs4all.nl>
Date: Thu, 05 Jun 2014 09:20:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC ATTN] Cropping, composing, scaling and S_FMT
References: <538C35A2.8030307@xs4all.nl> <20140604154012.13ddd6a9.m.chehab@samsung.com>
In-Reply-To: <20140604154012.13ddd6a9.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/2014 08:40 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 02 Jun 2014 10:28:18 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> During the media mini-summit I went through all 8 combinations of cropping,
>> composing and scaling (i.e. none of these features is present, or only cropping,
>> only composing, etc.).
>>
>> In particular I showed what I thought should happen if you change a crop rectangle,
>> compose rectangle or the format rectangle (VIDIOC_S_FMT).
>>
>> In my proposal the format rectangle would increase in size if you attempt to set
>> the compose rectangle wholly or partially outside the current format rectangle.
>> Most (all?) of the developers present didn't like that and I was asked to take
>> another look at that.
>>
>> After looking at this some more I realized that there was no need for this and
>> it is OK to constrain a compose rectangle to the current format rectangle. All
>> you need to do if you want to place the compose rectangle outside of the format
>> rectangle is to just change the format rectangle first. If the driver supports
>> composition then increasing the format rectangle will not change anything else,
>> so that is a safe operation without side-effects.
> 
> Good!
> 
>> However, changing the crop rectangle *can* change the format rectangle. In the
>> simple case of hardware that just supports cropping this is obvious, since
>> the crop and format rectangles must always be of the same size, so changing
>> one will change the other.
> 
> True, but, in such case, I'm in doubt if it is worth to implement crop API
> support, as just format API support is enough. The drawback is that
> userspace won't know how to differentiate between:
> 
> 1) scaler, no-crop, where changing the format changes the scaler;
> 2) crop, no scaler, where changing the format changes the crop region.
> 
> That could easily be fixed with a new caps flag, to announce if a device 
> has scaler or not.

Erm, the format just specifies a size, crop specifies a rectangle. You can't
use S_FMT to specify the crop rectangle.

Also, this case of crop and no scaler exists today in various drivers and
works as described (I'm sure about vpfe_capture, vino and I believe that there
are various exynos drivers as well).

> 
>> But if you throw in a scaler as well, you usually
>> still have such constraints based on the scaler capabilities.
>>
>> So assuming a scaler that can only scale 4 times (or less) up or down in each
>> direction, then setting a crop rectangle of 240x160 will require that the
>> format rectangle has a width in the range of 240/4 - 240*4 (60-960) and a
>> height in the range of 160/4 - 160*4 (40-640). Anything outside of that will
>> have to be corrected.
> 
> This can be done on two directions, e. g. rounding the crop area or
> rounding the scaler area.
> 
> I is not obvious at all (nor backward compat) to change the format
> rectangle when the crop rea is changed.
> 
> So, the best approach in this case is to round the crop rectangle to fit
> into the scaler limits, preserving the format rectangle.

I disagree with that for several reasons:

1) In the case of no-scaler the format is already changed by s_crop in existing
drivers. That can't be changed. So doing something else if there is a scaler is
inconsistent behavior.

2) The spec clearly specifies that changing the crop rectangle may change the
format size. It has always said so. From the section "Image Cropping, Insertion
and Scaling", "Scaling Adjustments":

"Applications can change the source or the target rectangle first, as they may
 prefer a particular image size or a certain area in the video signal. If the
 driver has to adjust both to satisfy hardware limitations, the last requested
 rectangle shall take priority, and the driver should preferably adjust the
 opposite one. The VIDIOC_TRY_FMT ioctl however shall not change the driver
 state and therefore only adjust the requested rectangle."

The two following paragraphs actually describe exactly the crop+scaler case and
how setting the crop rectangle can change the format size.

3) If an application desires a specific crop rectangle that is possible by the
hardware but is changed just because the format size is not suitable, then it
is hard (perhaps even impossible) for the application to figure out how to change
the format so the crop request can be achieved. That's quite a different situation
compared to the compose case where that is easy to decide.

4) This is actually how bttv behaves. So this is well-established behavior.

Regards,

	Hans

> 
>>
>> In my opinion this is valid behavior, and the specification also clearly
>> specifies in the VIDIOC_S_CROP and VIDIOC_S_SELECTION documentation that the
>> format may change after changing the crop rectangle.
>>
>> Note that for output streams the role of crop and compose is swapped. So for
>> output streams it is the crop rectangle that will always be constrained by
>> the format rectangle, and it is the compose rectangle that might change the
>> format rectangle based on scaler constraints.
>>
>> I think this makes sense and unless there are comments this is what I plan
>> to implement in my vivi rewrite which supports all these crop/compose/scale
>> combinations.
>>
>> Regards,
>>
>> 	Hans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

