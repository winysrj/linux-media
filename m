Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1IZMRZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 08:17:25 -0400
Message-ID: <4E806D4E.4020107@redhat.com>
Date: Mon, 26 Sep 2011 09:17:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com> <4E7D5561.6080303@redhat.com> <4E803B03.5090702@samsung.com> <4E806BCC.6000702@redhat.com>
In-Reply-To: <4E806BCC.6000702@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-09-2011 09:10, Mauro Carvalho Chehab escreveu:
> Em 26-09-2011 05:42, Tomasz Stanislawski escreveu:
>> On 09/24/2011 05:58 AM, Mauro Carvalho Chehab wrote:
>>
>> Hi Mauro
>> Thank you for your comments. Please refer to the answers below.
>>> Em 22-09-2011 12:13, Marek Szyprowski escreveu:
>>>> Hello Mauro,
>>>>
>>>> I've collected pending selection API patches together with pending
>>>> videobuf2 and Samsung driver fixes to a single git branch. Please pull
>>>> them to your media tree.
>>>>
>>>
>>>> Marek Szyprowski (1):
>>>>        staging: dt3155v4l: fix build break
>>>
>>> I've applied this one previously, from the patch you sent me.
>>>
>>>
>>>> Tomasz Stanislawski (6):
>>>>        v4l: add support for selection api
>>>>        v4l: add documentation for selection API
>>>
>>> I need more time to review those two patches. I'll probably do it at the next week.
>>> I generally start analyzing API changes based on the DocBook, so, let me point a few
>>> things I've noticed on a quick read, at the vidioc-g-selection.html DocBook-generated page:
>>>
>>> 1) "The coordinates are expressed in driver-dependant units"
>>>
>>> Why? coordinates should be expressed in pixels, as otherwise there's no way to
>>> use this API on a hardware-independent way.
>> The documentation for existing cropping API contains following sentence:
>>
>> "To support a wide range of hardware this specification does not define an origin or units."
>>
>> I decided to follow the same convention for the selection API.
>> I thought that the only exception would be images in memory buffers, whose coordinated would be pixels.
>>
>> However, as Laurent mentioned, some devices are capable of sub-pixel cropping. Moreover, there are image exotic formats that have no well-defined resolution (fractal or vector graphics). 
>> Now I am still not sure if the requirement for resolution in pixels should be used any more. The problem is that this requirement is very intuitive and useful in "let's say" 95% of cases.
> 
> How an userspace application is supposed to know the type of scale?
> I can't see any way of querying the scale type.
> 
>>>
>>> 2)
>>>      0 - driver is free to adjust size, it is recommended to choose the crop/compose rectangle as close as possible to the original one
>>>
>>>      SEL_SIZE_GE - driver is not allowed to shrink the rectangle. The original rectangle must lay inside the adjusted one
>>>
>>>      SEL_SIZE_LE - drive is not allowed to grow the rectangle. The adjusted rectangle must lay inside the original one
>>>
>>>      SEL_SIZE_GE | SEL_SIZE_LE - choose size exactly the same as in desired rectangle.
>>>
>>> The macro names above don't match the definition, as they aren't prefixed by V4L2_.
>> ok.. I will fix it.
>>>
>>> 3) There was no hyperlink for the struct v4l2_selection, as on other API definitions.
>> ok.. I will fix it.
>>>
>>> 4) the language doesn't seem too consistent with the way other ioctl's are defined. For example,
>>> you're using struct::field for a field at the struct. Other parts of the API just say "field foo of struct bar".
>> ok.. I will fix it.
>>
>>> 5) There's not a single mention at the git commit or at the DocBook about why the old crop API
>>> is being deprecated. You need to convince me about such need (ok, I followed a few discussions in
>>> the past, but, my brain patch buffer is shorter than the 7000 patchwork patches I reviewed just on
>>> this week). Besides that: do we really need to obsolete the crop API for TV cards? If so, why? If not,
>>> you need to explain why a developer should opt between one ioctl set of the other.
>>
>> There are a few reasons to drop support for the cropping ioctls.
>>
>> First, the selection API covers existing crop API. Therefore there is no need to implement {S/G}_CROP and G_CROPCAP. 
>> The {S/G}_SELECTION is enough to provide the same functionality. We should avoiding duplication inside the api, 
>> therefore S_CROP should be dropped.
>>
>> Second, there is a patch that adds simulation of old crop API using selection API. Therefore there is no need to 
>> change code of the existing applications.
> 
> Both are fine, but you should notice that they aren't arguments why an
> userspace application or a driver shouldn't implement/use the crop API.
> 
>> Third, the selection is much more powerful API, and it could be extended in future. There no more reserved fields inside structures
>> used by current cropping api.
> 
> Ok.
> 
>> Moreover cropping is very inconsistent.
> 
> Why? Please describe its inconsistencies at the DocBook.
> 
>> For output devices cropping into display actually means composing into display.
> 
> Ok.
> 
>> Moreover it not possible to select only 
>> the part of the image from the buffer to be inserted or filled by the hardware. 
> 
> You're talking again on output devices, right?
> 
> 
>> The selection API introduced the idea 
>> of the constraints flags, that are used for precise control of the coordinates' rounding policy.
> 
> Ok, but I fail to see where a rounding policy would be
> needed on an input device.
> 
> In other words, I think we should split the issues with 
> the crop api into two groups:
> 
> 1) for input devices
> 2) for output devices.
> 
> Are your idea to deprecate the usage of the crop API for both
> input and output devices? 
> 
> Please correct me if I'm wrong, but the problems you've mentioned are all
> about (2), right?
> 
> The crop API were designed originally for input devices, and is currently
> used on several TV and USB webcam devices for input. 
> Grepping for vidioc_s_crap:
> 	drivers/media/video/bt8xx/bttv-driver.c
> 	drivers/media/video/et61x251/et61x251_core.c
> 	drivers/media/video/saa7134/saa7134-video.c
> 	drivers/media/video/sn9c102/sn9c102_core.c
> 	drivers/media/video/vino.c
> 	drivers/media/video/zoran/zoran_driver.c
> 	drivers/media/video/cx18/cx18-ioctl.c
> 
> Porting them to the selection API means that userspace applications
> and kernel drivers will need changes, and this will take a long time
> to happen. Ok, this can be done, if there will be large gains on it,
> but I fail to see what will be such gains.
> 
> So, please explain us why the above drivers would need to be ported to
> the selection API, or why new input drivers/applications would need
> the new API instead of the old one.
> 
> With respect to (2), the only TV device that (ab)used the crop API to 
> control its output node is
> 	drivers/media/video/ivtv/ivtv-ioctl.c
> 
> To complete the drivers list, currently, the only SoC device currently
> implementing vidioc_s_crop for input/output is the davinci driver:
> 	drivers/media/video/davinci/vpif_capture.c
> 	drivers/media/video/davinci/vpif_display.c
> 
> IMO, what it seems to be happening with the crop API is similar to what
> happened in the past with the control API: the existing API works fine
> on simple cases, but fails on more complex scenarios. In the case of
> the control API, several controls need to be grouped when selecting an
> mpeg compression parameters. So, the VIDIOC_[G|S]_EXT_CTRLS were added
> without deprecating the old ioctl's. This way, applications that were
> only supporting controls like bright, volume, etc won't need to be changed.
> 
> Internally, it made sense to implement a core way of converting a legacy
> ioctl call into the new callbacks for the _EXT_ ioctl's, and to convert
> the existing drivers.
> 
>> I could split commit 'v4l: add documentation for selection API' into two commits. One that deprecates S_CROP, and another one that introduces selection.
> 
> Actually, It is too soon to deprecate S_CROP while the selection API is tagged
> as experimental, but if this is the idea, it is better to add a hint at the V4L2
> DocBook.
> 
>>> 6) You should add a note about it at hist-v4l2.html page, stating what happened, and why a new crop
>>> ioctl set is needed.
>> ok.. I missed it. Sorry.
>>>
>>> 7) You didn't update the Experimental API Elements or the Obsolete API Elements at the hist-v4l2.html
>> ok.. I missed it. Sorry.
>>>
>>> Thanks,
>>> Mauro
>>
>> Thank again for your comments.
>> I hope that my answers will convince you to the selection API.

In time: It is not a matter of convincing me, but, instead, to convince the
developers of the above drivers and the userspace application developers why
they should care to move from the CROP API to the one you're proposing.

>>
>> Best regards,
>> Tomasz Stanislawski
>>
> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

