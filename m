Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:55596 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932785AbeF2Mc7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:32:59 -0400
Subject: Re: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
 <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
 <20180628083732.3679d730@coco.lan>
 <536a05bd-372e-a509-a6b6-0a3e916e48ae@xs4all.nl>
 <20180629070647.1ce7f73b@coco.lan>
 <1b948535-8067-fef6-efd9-92aff3049ec5@xs4all.nl>
 <20180629092856.73406202@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6a37f16c-eb12-b60d-667f-169364d74dbe@xs4all.nl>
Date: Fri, 29 Jun 2018 14:32:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180629092856.73406202@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/29/18 14:28, Mauro Carvalho Chehab wrote:
> Em Fri, 29 Jun 2018 12:26:20 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 06/29/18 12:06, Mauro Carvalho Chehab wrote:
>>> Em Thu, 28 Jun 2018 14:47:05 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>   
>>>> On 06/28/18 13:37, Mauro Carvalho Chehab wrote:  
>>>>> Em Thu, 17 May 2018 16:30:16 +0200
>>>>> Niklas Söderlund         <niklas.soderlund+renesas@ragnatech.se> escreveu:
>>>>>     
>>>>>> There is no way to control the standard of subdevices which are part of
>>>>>> a media device. The ioctls which exists all target video devices
>>>>>> explicitly and the idea is that the video device should talk to the
>>>>>> subdevice. For subdevices part of a media graph this is not possible and
>>>>>> the standard must be controlled on the subdev device directly.    
>>>>>
>>>>> Why isn't it possible? A media pipeline should have at least a video
>>>>> devnode where the standard ioctls will be issued.    
>>>>
>>>> Not for an MC-centric device like the r-car or imx. It's why we have v4l-subdev
>>>> ioctls for the DV_TIMINGS API, but the corresponding SDTV standards API is
>>>> missing.
>>>>
>>>> And in a complex scenario there is nothing preventing you from having multiple
>>>> SDTV inputs, some of which need PAL-BG, some SECAM, some NTSC (less likely)
>>>> which are all composed together (think security cameras or something like that).
>>>>
>>>> You definitely cannot set the standard from a video device. If nothing else,
>>>> it would be completely inconsistent with how HDMI inputs work.
>>>>
>>>> The whole point of MC centric devices is that you *don't* control subdevs
>>>> from video nodes.  
>>>
>>> Well, the way it is, this change is disruptive, as, as far as I remember,
>>> MC-based devices with tvp5150 already sets STD via the /dev/video device.  
>>
>> Really? Which driver? I am not aware of this and I think you are mistaken.
>> Remember that we are talking about MC-centric drivers. em28xx is not MC-centric,
>> even though it has a media device.
> 
> OMAP3. There are some boards out there with tvp5150.

There is no standards support in omap3isp. It only supports sensors, not
analog or digital video receivers. So if they support SDTV, then they hacked
the omap3isp driver.

Regards,

	Hans

> 
>>
>>>
>>> If we're willing to add it, we'll need to be clear when one approach
>>> should be taken, and be clear that, if the SUBDEV version is used, the
>>> driver should not support the non-subdev option.  
>>
>> Of course, but in the case of em28xx the tvp5150 v4l-subdev node is never
>> created, so this is not a problem.
>>
>> Regards,
>>
>> 	Hans
>>
>>>   
>>>>
>>>> Regards,
>>>>
>>>> 	Hans
>>>>  
>>>>> So, I don't see why you would need to explicitly set the standard inside
>>>>> a sub-device.
>>>>>
>>>>> The way I see, inside a given pipeline, all subdevs should be using the
>>>>> same video standard (maybe except for a m2m device with would have some
>>>>> coded that would be doing format conversion).
>>>>>
>>>>> Am I missing something?
>>>>>
>>>>> Thanks,
>>>>> Mauro
>>>>>     
>>>>  
>>>
>>>
>>>
>>> Thanks,
>>> Mauro
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 
