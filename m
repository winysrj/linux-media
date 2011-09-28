Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38297 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1I1PRk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 11:17:40 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LS800GBENTE7M@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Sep 2011 16:17:38 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LS8008T3NTE9H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Sep 2011 16:17:38 +0100 (BST)
Date: Wed, 28 Sep 2011 17:17:33 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
In-reply-to: <4E82F9AB.9030109@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-id: <4E833A8D.2020909@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com>
 <4E81D93E.1060107@redhat.com> <4E81FDD2.3090501@samsung.com>
 <201109281001.03564.hverkuil@xs4all.nl> <4E82EFF1.4000102@samsung.com>
 <4E82F9AB.9030109@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 09/28/2011 12:40 PM, Mauro Carvalho Chehab wrote:
> Em 28-09-2011 06:59, Tomasz Stanislawski escreveu:
>> On 09/28/2011 10:01 AM, Hans Verkuil wrote:
>>> On Tuesday, September 27, 2011 18:46:10 Tomasz Stanislawski wrote:
>>>> On 09/27/2011 04:10 PM, Mauro Carvalho Chehab wrote:
>>>>> Em 27-09-2011 10:02, Tomasz Stanislawski escreveu:
>>>>>> On 09/26/2011 02:10 PM, Mauro Carvalho Chehab wrote:
>>>>>>> Em 26-09-2011 05:42, Tomasz Stanislawski escreveu:
>>>>>>>> On 09/24/2011 05:58 AM, Mauro Carvalho Chehab wrote:
>>>>>>>>> Em 22-09-2011 12:13, Marek Szyprowski escreveu:
>>>>
>>>> [snip]
>>>>
>>>>>>
>>>>>> What do you mean by 'scale type'? Do you mean types like 'shrink', 'enlarge', 'no scale'?
>>>>>
>>>>> I mean: what's the scale that the application should expect for cropping? pixel, sub-mixel, percentage, etc.
>>>>>
>>>>
>>>> Hans suggest to use pixels as units. I bear to a very similar but
>>>> slightly different idea that the driver should use units system that
>>>> guarantees that no scaling is applied while the composing and cropping
>>>> rectangle are equal. I mean rectangle's width and height.
>>>
>>> As I asked before: what's the use-case of non-pixel units anyway?
>>
>> I just prefer to avoid calling this units a pixels for signals that have little common with pixels.
>> The example is analog TV. There is no such a thing as horizontal resolution. The units are samples in
>> that case.
>
> When the userspace application sets the format for the analog TV, it
> tells how much pixels the sampler will use.

I assume that you mean VIDIOC_S_FMT ioctl, right?

> The crop API will then tell
> the initial/final pixel at the horizontal resolution that will be used
> when displaying the image. See? This can happen before the settings on the
> memory buffers.

Not exactly. There was a long discussion over VIDIOC_S_FMT ioctl. It was 
decided that the ioctl does too much and that it should be modified.

BTW. What are the units currently used by VIDIOC_S_CROP ?

The spec says 'To support a wide range of hardware this specification 
does not define an origin or units'. You say that it uses pixels 
(samples). Who is right? What does the protocol for cropping 
configuration look like?

>
>> I agree that the unit should be strongly correlated with pixels on images in memory buffers.
>>  From application point of there is no difference if the units are defined as pixels or units that guarantee
>> no scaling if crop and compose are equal. The numerical value are exactly the same in both cases. I just think
>> that pixels sounds strange and awkward when taking about analog signal or sensor arrays that use a
>> bunch of R/G/B detectors (subpixels).
>
> If the numerical value is the same, then userspace can specify it in
> pixels. However, if the SELECTION api would accept anything else,
> then it should have some way for userspace to get/set using a different
> type of scale like subpixels and/or percentage values.

Why? The pixel (sample) related units are ok.
Arbitrary percentage can be computed by multiplying a requested fraction 
by size of bound rectangle?

>>> I haven't
>>> seen anything yet. In addition, do you know how other hardware handles
>>> sub-pixel cropping/composing? Do you actually know how this is done in practice?
>>
>> I think that word subpixel is a bit ambiguous. It may mean monochrome light emitters
>> like ones on LCD displays. In the contexts of scaling I understand the subpixel
>> as a part of the pixel (like 1/16th of pixel).
>>
>> The Video Processor chip in S5P-TV supports cropping at subpixel resolution.
>> The cropping is done by using polyphase filters. I don't know any video hardware
>> that supports composing at resolution higher than pixels. 3D graphic cards can do
>> it but they are out of V4L2 scope :).
>
> If subpixel may be required in the future, the best would be to think on how
> it will be implemented, in order to be sure that the current way will be compatible
> with it, for example, by having a flag there (currently set to 0) that could later
> be used to specify subpixels.
>
>>>
>>> I strongly feel that the default unit should be pixels. If you want something
>>> else you need to request that (by perhaps setting a SUBPIXEL flag, or by having
>>> SUBPIXEL target rectangles, or perhaps by only doing subpixel selection on the
>>> subdev device node).
>>
>> Extending the selection to support subpixel resolution is easy. I and Laurent were
>> discussing it. The idea was to add 'denominator' field in v4l2_selection. The rectangle
>> coordinates would be divided by this number. The denominator equal to 0 indicates that
>> the driver does not support cropping/composing at precision higher than a pixel.
>> This extension could be added at any time in future.
>
> Ok. We shouldn't add it if not needed right now, but the API specs should tell that
> userspace should specify the units in pixels, after setting the resolution with
> VIDIOC_S_FMT, in order to be sure that the analog sampler will be properly set, on
> the analog TV case.
>
>>>> If new applications and drivers support only for selection API then we
>>>> will have:
>>>> - less ioctl
>>>> - less structures
>>>> - more functionality
>>>>
>>>> The legacy applications would be supported by simulation of old API
>>>> using selection API.
>>>
>>> As I said before, G/S_CROP is perfectly valid and will not go away or be
>>> deprecated.
>>
>> Why? Deprecating means only that this ioctls should not be used in new code
>> and drivers. I do not want to remove existing ioctls. Anyway, both APIs can
>> coexist. So I let's keep them both. The selection may need improvements so
>> it gains 'experimental' status.
>
> If it is experimental, it can deprecate anything, even on the above sense.
>
OK.
>>
>>> Just as S_CTRL is not replaced by S_EXT_CTRLS. There is no need
>>> to force apps to move to the selection API. The selection API extends the
>>> old crop API for good reasons, but for simple cropping S_CROP remains perfectly
>>> fine.
>>>
>>> What would be nice is to deprecate the old crop ops for new drivers and (ideally)
>>> convert existing drivers that use vidioc_g/s_crop to the new vidioc_g/s_selection
>>> (with the final goal of removing vidioc_g/s_crop).
>>
>> I agree.
>
> I don't. We should stop touching at the existing drivers to add things that they
> don't need, just because a new SoC chip needs some neat feature.
>

We should focus on the new drivers that do not exist yet or are in 
experimental phase. The decision whether or not to implement the 
selection in the existing drivers belongs to their maintainers.

>>
>>>
>>> And also note that cropcap is still needed to get the pixelaspect.
>>
>> The pixelaspect is another problematic issue. IMO, it does not suit to crop/compose operations. This parameters is strongly related to analog TV. Refer to the sentence from pixelaspect definition:
>>
>> "When cropping coordinates refer to square pixels, the driver sets pixelaspect to 1/1. Other common values are 54/59 for PAL and SECAM, 11/10 for NTSC sampled according to [[ITU BT.601]]."
>>
>> It seams that this parameters is valid in contest of analog TV standards.
>>
>> What is the definition of the pixelaspect for capture devices other than cards for analog TV?
>
> It would be easy to change the specs wording to apply also digital TV standards.
>
>> IMO, this field should be moved to struct v4l2_standard obtained using VIDIOC_ENUMSTD.
>> There are still many reserved fields there. Of course this field would still be present
>> in v4l2_cropcap for compatibility reasons.
>
> I agree that this would fit better at VIDIOC_ENUMSTD, but not fully convinced that
> we should change it. From one side, pixelaspect has nothing to do with crop, so it
> is at the wrong place, but from the other side, this would mean that the same info
> would be duplicated into two different ioctls, which is messy.

I think it is worth to put it in two places. The pixelaspect is 
read-only value so there are no dependency problems. Another thing is 
that only analog TV drivers uses the value other than 1/1. Some drivers 
even use value 0/0.

Moreover, there are duplications in existing API. Example:
Structure v4l2_buffer has 'memory' field. The value of the field must be 
equal to the one used in VIDIOC_REQBUFS. So there is no need to use this 
field.

Best regards,
Tomasz Stanislawski

>
>>>>> It is doubtful that any of the above hardware would support composing.
>>>>> Maybe only cx18 might have this capability, but I don't think that the
>>>
>>> ivtv, not cx18.
>>>
>>>>> existing devices support it anyway.
>>>
>>> Most devices that can scale can do composition by being creative with the DMA
>>> engine setup. Just by fiddling with strides and offsets you can achieve this.
>
>>
>> I'll try to ask the maintainers to consider using selection API for those drivers. Maybe they could add some fixes or improvements to current proposition.
>
> Yes, this could probably be done at bttv and cx88 hardware, by changing the RISC
> code. As bttv (and saa7134) supports overlay mode, perhaps the basic code is
> already there. Still, I don't think that anybody is interested (or have enough
> time) to change something at this part of the code.
>
> Regards,
> Mauro

