Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3181 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3LLMjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 07:39:15 -0500
Message-ID: <52A9ADF6.2090900@xs4all.nl>
Date: Thu, 12 Dec 2013 13:37:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use
 it
References: <201308281419.52009.hverkuil@xs4all.nl> <2062971.KPW0FZTQyQ@avalon> <20130905163130.GF4493@valkosipuli.retiisi.org.uk> <344618801.kmLM0jZvMY@avalon>
In-Reply-To: <344618801.kmLM0jZvMY@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari asked me to reply to this old thread...

On 09/06/13 13:05, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday 05 September 2013 19:31:30 Sakari Ailus wrote:
>> On Sat, Aug 31, 2013 at 11:43:18PM +0200, Laurent Pinchart wrote:
>>> On Friday 30 August 2013 19:08:48 Sakari Ailus wrote:
>>>> On Fri, Aug 30, 2013 at 01:31:44PM +0200, Laurent Pinchart wrote:
>>>>> On Thursday 29 August 2013 14:33:39 Sakari Ailus wrote:
>>>>>> On Thu, Aug 29, 2013 at 01:25:05AM +0200, Laurent Pinchart wrote:
>>>>>>> On Wednesday 28 August 2013 19:39:19 Sakari Ailus wrote:
>>>>>>>> On Wed, Aug 28, 2013 at 06:14:44PM +0200, Laurent Pinchart
>>>>>>>> wrote:
>>>>>>>> ...
>>>>>>>>
>>>>>>>>>>> UVC devices timestamp frames when the frame is captured,
>>>>>>>>>>> not when the first pixel is transmitted.
>>>>>>>>>>
>>>>>>>>>> I.e. we shouldn't set the SOF flag? "When the frame is
>>>>>>>>>> captured" doesn't say much, or almost anything in terms of
>>>>>>>>>> *when*. The frames have exposure time and rolling shutter
>>>>>>>>>> makes a difference, too.
>>>>>>>>>
>>>>>>>>> The UVC 1.1 specification defines the timestamp as
>>>>>>>>>
>>>>>>>>> "The source clock time in native deviceclock units when the
>>>>>>>>> raw frame capture begins."
>>>>>>>>>
>>>>>>>>> What devices do in practice may differ :-)
>>>>>>>>
>>>>>>>> I think that this should mean start-of-frame - exposure time.
>>>>>>>> I'd really wonder if any practical implementation does that
>>>>>>>> however.
>>>>>>>
>>>>>>> It's start-of-frame - exposure time - internal delays (UVC webcams
>>>>>>> are supposed to report their internal delay value as well).
>>>>>>
>>>>>> Do they report it? How about the exposure time?
>>>>>
>>>>> It's supposed to be configurable.
>>>>
>>>> Is the exposure reported with the frame so it could be used to construct
>>>> the per-frame SOF timestamp?
>>>
>>> Not when auto-exposure is turned on I'm afraid :-S
>>>
>>> I believe that the capture timestamp makes more sense than the SOF
>>> timestamp for applications. SOF/EOF are more of a poor man's timestamp in
>>> case nothing else is available, but when you want to synchronize multiple
>>> audio and/or video streams the capture timestamp is what you're
>>> interested in. I don't think converting a capture timestamp to an SOF
>>> would be a good idea.
>>
>> I'm not quite sure of that --- I think the SOF/EOF will be more stable than
>> the exposure start which depends on the exposure time. If you're recording a
>> video you may want to keep the time between the frames constant.
> 
> I can see two main use cases for timestamps. The first one is multi-stream 
> synchronization (audio and video, stereo video, ...), the second one is 
> playback rate control.
> 
> To synchronize media streams you need to timestamp samples with a common 
> clock. Timestamps must be correlated to the time at which the sound and/or 
> image events occur. If we consider the speed of sound and speed of light as 
> negligible (the former could be compensated for if needed, but that's out of 
> scope), the time at which the sound or image is produced can be considered as 
> equal to the time at which they're captured. Given that we only need to 
> synchronize streams here, an offset wouldn't matter, so any clock that is 
> synchronized to the capture clock with a fixed offset would do. The SOF event, 
> in particular, will do if the capture time and device processing time is 
> constant, and if interrupt latencies are kept small enough.. So will the EOF 
> event if the transmission time is also constant.
> 
> Granted, frames are not captured at a precise point of time, as the sensor 
> needs to be exposed for a certain duration. There is thus no such thing as a 
> capture time, we instead have a capture interval. However, that's irrelevant 
> for multi-video synchronization purposes. It could matter for audio+video 
> synchronization though.
> 
> Regarding playback rate control, the goal is to render frames at the same rate 
> they are captured. If the frame rate isn't constant (for instance because of a 
> variable exposure time), then a time stamp is required for every frame. Here 
> we care about the difference between timestamps for two consecutive frames, 
> and the start of capture timestamp is what will give best results.
> 
> Let's consider three frames, A, B and C, captured as follows.
> 
> 
> 00000000001111111111222222222233333333334444444444555555555566666666667777
> 01234567890123456789012345678901234567890123456789012345678901234567890123
> 
> | --------- A ------------ |      | ----- B ----- |      | ----- C ----- |
> 
> On the playback side, we want to display A for a duration of 34. If we 
> timestamp the frames with the start of capture time, we will have the 
> following timestamps.
> 
> A  0
> B  34
> C  57
> 
> B-A = 34, which is the time during which A needs to be displayed.
> 
> If we use the end of capture time, we will get
> 
> A  27
> B  50
> C  73
> 
> B-A = 23, which is too short.
> 
>> Nevertheless --- if we don't get such a timestamp from the device this will
>> only remain speculation. Applications might be best using e.g. half the
>> frame period to get a guesstimate of the differences between the two
>> timestamps.
> 
> Obviously if the device can't provide the start of capture timestamp we will 
> need to use any source of timestamps, but I believe we should aim for start of 
> capture as a first class citizen.
> 
>>>>>> If you know them all you can calculate the SOF timestamp. The fewer
>>>>>> timestamps are available for user programs the better.
>>>>>>
>>>>>> It's another matter then if there are webcams that report these
>>>>>> values wrong.
>>>>>
>>>>> There most probably are :-)
>>>>>
>>>>>> Then you could get timestamps that are complete garbage. But I guess
>>>>>> you could compare them to the current monotonic timestamp and detect
>>>>>> such cases.
>>>>>>
>>>>>>>> What's your suggestion; should we use the SOF flag for this or
>>>>>>>> do you prefer the end-of-frame timestamp instead? I think it'd
>>>>>>>> be quite nice for drivers to know which one is which without
>>>>>>>> having to guess, and based on the above start-of-frame comes as
>>>>>>>> close to that definition as is meaningful.
>>>>>>>
>>>>>>> SOF is better than EOF. Do we need a start-of-capture flag, or
>>>>>>> could we document SOF as meaning start-of-capture or start-of-
>>>>>>> reception depending on what the device can do ?
>>>>>>
>>>>>> One possibility is to dedicate a few flags for this; by using three
>>>>>> bits we'd get eight different timestamps already. But I have to say
>>>>>> that fewer is better. :-)
>>>>>
>>>>> Does it really need to be a per-buffer flag ? This seems to be a
>>>>> driver-wide (or at least device-wide) behaviour to me.
>>>>
>>>> Same goes for timestamp clock sources. It was concluded to use buffer
>>>> flags for those as well.
>>>
>>> Yes, and I don't think I was convinced, so I'm not convinced here either
>>> :-)
>>>
>>>> Using a control for the purpose would however require quite non-zero
>>>> amount of initialisation code from each driver so that would probably
>>>> need to be sorted out first.
>>>
>>> We could also use a capabilities flag.
>>
>> Interesting idea. I'm fine that as well. Hans?

That would work for uvc, but not in the general case. Depending on the video
routing you might have either SOF or EOF timestamps. Unlikely, I admit, but
I feel keeping this flag in v4l2_buffers is the most generic solution.

Regards,

	Hans
