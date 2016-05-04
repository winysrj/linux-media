Return-path: <linux-media-owner@vger.kernel.org>
Received: from 18.mo5.mail-out.ovh.net ([178.33.45.10]:60695 "EHLO
	18.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbcEDQEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 12:04:36 -0400
Received: from player788.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo5.mail-out.ovh.net (Postfix) with ESMTP id D74841004126
	for <linux-media@vger.kernel.org>; Wed,  4 May 2016 16:47:04 +0200 (CEST)
Subject: Re: [PATCH v2] Add GS driver (SPI video serializer family)
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <dfff4181-edd7-b855-cdad-9d35fe940704@nexvision.fr>
 <5729DFE0.6080600@xs4all.nl>
 <40ac6b0a-2234-0a29-2932-12f922fa2609@nexvision.fr>
 <5729FD4F.4010901@xs4all.nl>
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <f49f3ad8-3e19-e03c-311d-3d61286f51e8@nexvision.fr>
Date: Wed, 4 May 2016 16:47:03 +0200
MIME-Version: 1.0
In-Reply-To: <5729FD4F.4010901@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 04/05/2016 à 15:46, Hans Verkuil a écrit :
>> Ok, but I should have difficulties to define correctly these standards.
>> I worked on video stream in SMPTE-125M and I don't know if other SMPTE standards are based on the same characteristics.
>> In addition to this, those standards are not public.
> 
> I have access to the SMPTE standards, I'll take a look next week.

Oh, nice. Thanks. :)

> Regarding timings: I think this requires a separate discussion. I need to loop in 'nohous'
> who is also working on SDI support, but unfortunately I don't have his email handy, otherwise
> I'd have CC-ed him.
> 
> I'm no SDI expert myself, but I think I should set time aside to read up on this
> and figure out together with you guys how this should be handled.
> 
> So I don't have a quick answer here, this requires more R&D.

Ok. I could help a little bit I think.

>>> So, regarding the reset, s_dv_timings and query_dv_timings: it's not clear
>>> what is happening here. The usual way things work is that the timings that
>>> s/g_dv_timings set and get are indepedent of the timings that are detected
>>> (query_dv_timings). The reason is that the explicitly set timings relate to
>>> the buffers that the DMA engine needs to store the frames. Receivers that
>>> spontaneously switch when new timings are detected can be very dangerous
>>> depending on the details of the DMA engine (think buffer overruns when you
>>> go from e.g. 720p to 1080p).
>>
>> It's the case here.
>> s/g_dv_timings are independent of query_detect_timings which reads internal registers to
>> define the stream detected by the component.
>>
>> The reset function are an error, I think.
>> By default the GS1662 is in auto-mode: it detects the input stream to create the serialized output stream.
>> The reset was to return in auto-mode selection, but this function should be to reset the component and not the mode.
>>
>> I don't have idea to define properly the auto-mode, for userspace and the driver.
>> It's a useful information and I think, the userspace should force this mode. Define a specific timings for that?
> 
> I think that you can use the s_stream op here: when you start streaming you force
> the mode to whatever the timings set by s_dv_timings() requires. When you stop streaming
> you go back to auto-mode.

Hum. I agree with you.
But, if the stream was starting without previous timings settings, I should use a default value or keep the auto-mode?
I prefer the auto-mode solution in this case.

>>> So typically when you set the timings the device is fixed to those timings,
>>> even if it receives something different. If the device supports an interrupt,
>>> then it is good practice to hook into that interrupt and, when it detects
>>> that the timings changed, the device sends a V4L2_EVENT_SOURCE_CHANGE event.
>>>
>>> Userspace will then typically stop streaming, query the new timings, setup
>>> the new buffers and restart streaming.
>>
>> GS1662 don't have interruption line to do that.
>>
>>> Some devices cannot query the new timings unless they are in autodetect mode.
>>> The correct implementation for that is that query_dv_timings returns EBUSY
>>> while the device is streaming (you hook into the s_stream core op to know that),
>>> otherwise it configures itself to autodetect mode and sees what is detected.
>>>
>>> It is not really clear to me from the datasheet how this device behaves. But
>>> having to use the reset op is almost certainly wrong.
>>
>> I don't understand.
>> The GS1662 has a status to say the input format detected. Useful in auto-detect mode,
>> less in other cases. But, it needs a input, why send EBUSY error when the device streams?
> 
> Hmm, I don't understand either :-)
> 
> The question is: when the device is streaming video for a specific format (as set
> by s_dv_timings), can it still detect the actual video format it receives? If so,
> then there is no need for EBUSY since query_dv_timings will always work. If not,
> then query_dv_timings should report that it is unable to query the detected timings
> because it is in the wrong mode (EBUSY).

Oh, I see.

I didn't remember my results around that. I will configure like your suggestion.

> BTW, you also need to implement the g_input_status video op. I just realized that
> that is missing. It is used to fill in the status field when calling VIDIOC_ENUMINPUTS.

Ok, I will add that. Thanks.

> Remember that today there are no SDI drivers in the kernel. So you and nohous are the first
> that work on this. So there will be some missing pieces that we need to add. It seems that
> for SDI the timings are one such area.
> 
> It will be useful if you join the #v4l irc room (http://linuxtv.org/lists.php).
> 
> I think that's a good place to have a meeting about this topic together with nohous. I'm
> traveling for a bit but will be back on Tuesday. Perhaps we can schedule something later
> that week.

Ok, I could participate the next week.
Thank you for all.

Regards.
Charles-Antoine Couret
