Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54988 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1DJH7h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 03:59:37 -0400
Received: by ewy4 with SMTP id 4so1445866ewy.19
        for <linux-media@vger.kernel.org>; Sun, 10 Apr 2011 00:59:36 -0700 (PDT)
Message-ID: <4DA16362.6040004@gmail.com>
Date: Sun, 10 Apr 2011 09:59:30 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API, ver2
References: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com> <201104081453.02965.hverkuil@xs4all.nl> <4DA08CA4.60200@gmail.com>
In-Reply-To: <4DA08CA4.60200@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/09/2011 06:43 PM, Sylwester Nawrocki wrote:
> Hello,
> 
> On 04/08/2011 02:53 PM, Hans Verkuil wrote:
>> Hi Tomasz!
>>
>> Some comments below...
>>
>> On Wednesday, April 06, 2011 10:44:17 Tomasz Stanislawski wrote:
>>> Hello everyone,
>>>
>>> This patch-set introduces new ioctls to V4L2 API. The new method for
>>> configuration of cropping and composition is presented.
>>>
>>> This is the second version of extcrop RFC. It was enriched with new features
>>> like additional hint flags, and a support for auxiliary crop/compose
>>> rectangles.
>>>
>>> There is some confusion in understanding of a cropping in current version of
>>> V4L2. For CAPTURE devices cropping refers to choosing only a part of input
>>> data stream and processing it and storing it in a memory buffer. The buffer is
>>> fully filled by data. It is not possible to choose only a part of a buffer for
>>> being updated by hardware.
>>>
>>> In case of OUTPUT devices, the whole content of a buffer is passed by hardware
>>> to output display. Cropping means selecting only a part of an output
>>> display/signal. It is not possible to choose only a part for a memory buffer
>>> to be processed.
>>>
>>> The overmentioned flaws in cropping API were discussed in post:
>>> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/28945
>>>
>>> A solution was proposed during brainstorming session in Warsaw.
>>>
> ...
>>> - merge v4l2_selection::target and v4l2_selection::flags into single field
>>> - allow using VIDIOC_S_EXTCROP with target type V4L2_SEL_TARGET_BOUNDS to
>>>     choose a resolution of a sensor
> 
> Assuming here that the "resolution of a sensor" refers to the output resolution
> of a sensor with embedded ISP as seen by a bridge. Otherwise if it refers to
> the active pixel matrix resolution VIDIOC_S_EXTCROP(V4L2_SEL_TARGET_BOUNDS)
> would only make sense for sensors that support different pixel matrix layout,
> e.g. portrait/landscape. Something that Laurent brought to our attention during
> the Warsaw meeting, i.e. where actual sensor matrix contour is square but there
> are square polygons of dark pixels at each corner of the contour.
> 
>>
>> Too obscure IMHO. That said, it would be nice to have a more explicit method
>> of selecting a sensor resolution. You can enumerate them, but you choose it
>> using VIDIOC_S_FMT, which I've always thought was very dubious. This prevents
>> any sensor-built-in scalers from being used. For video you have S_STD and
> 
> IMHO sensor-built-in scalers can be used by means of the VIDIOC_[S/G]_CROP
> ioctls, which allows to select not only width/height of the part of a sensor
> matrix to be fed to the sensor's scaler but also a position of a pixel crop
> rectangle.
> 
>> S_DV_PRESET that select a particular input resolution, but a similar ioctl is
>> missing for sensors. Laurent, what are your thoughts?
>>
> 
> I suppose new ioctls like [G/S]_FRAMESIZE could be useful for selecting
> sensor's output resolution, those could then call sensor's pad set_fmt/get_fmt
> ops. Please note there are image sensors that support any resolution in their
> nominal range with some alignment requirements. For a maximum resolution 1024x1280
> and 2 pixels alignment those would yield 327680 different resolutions.
> Does enum_framesizes make sense in such cases?

Oops, I should have read the documentation carefully before asking silly
questions.. :/ Of course the above case could be easily covered by
the step-wise frame size type.

> 
> There is currently no way to configure a scaler built in in the bridge with
> the regular V4L2 API though. Only the final output buffer resolution can be set
> with VIDIOC_S_FMT. We can select an active pixel array area with S_CROP.
> Depending where the cropping is actually performed - in an image sensor or in
> a bridge we are able to use sensor-built-in scaler OR bridge-built-in scaler,
> never both. Would setting sensor's output and bridge's input resolution with
> new VIDIOC_S_FRAMESIZE ioctl make sense?
> 
> .........................................         .....................................
> .                                       .         .                                   .
> .                G/S_CROP              G/S_FRAMESIZE               G/S_FMT            .
> .             (x,y) w1 x h1             . w2 x h2 .                w3 x h3            .
> . +-------------+       +------------+  .         .  +------------+       +---------+ .
> . |             |       |            |  .         .  |            |       |         | .
> . |   Pixel     |       |   ISP      |  .         .  |  SCALER    |       |  DMA    | .
> . |   matrix    |_______| (scaler)   |_______________|            |_______|  eng.   | .
> . |             |       |            |  .         .  | (color     |       |         | .
> . |             |       |            |  .         .  | converter) |       |         | .
> . |             |       |            |  .         .  |            |       |         | .
> . +-------------+       +------------+  .         .  +------------+       +---------+ .
> .                                       .         .                                   .
> .  SENSOR        PAD S0           PAD S1.         . PAD B0                    BRIDGE  .
>   ........................................         .....................................
> 
> 
> Also how could one enumerate what media bus formats are supported at bridge input pad
> (PAD B0 in the ascii diagram above) if the bridge does not support the v4l2 subdev
> user space API and the application needs to match formats at pads PAD S1 and PAD B0 ?


--
Regards,
Sylwester Nawrocki

