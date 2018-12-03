Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:52089 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbeLCVJl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 16:09:41 -0500
Subject: Re: [PATCH v6 2/2] media: platform: Add Aspeed Video Engine driver
To: Eddie James <eajames@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org
References: <1543347457-59224-1-git-send-email-eajames@linux.ibm.com>
 <1543347457-59224-3-git-send-email-eajames@linux.ibm.com>
 <1d5f3260-2d95-32b2-090e-2f57ae9e6833@xs4all.nl>
 <52cae852-5a2b-ee37-3829-73de7a47df1c@linux.ibm.com>
 <0c5dbd34-a10c-04ce-43bb-646e712f0e99@xs4all.nl>
 <6c92cb5c-2134-e5d8-1a6b-2d311731cef3@linux.ibm.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b1b1f60-d21c-c0a2-2597-8bdb77f5f7c9@xs4all.nl>
Date: Mon, 3 Dec 2018 22:09:35 +0100
MIME-Version: 1.0
In-Reply-To: <6c92cb5c-2134-e5d8-1a6b-2d311731cef3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2018 09:37 PM, Eddie James wrote:

<snip>

>>>>> +static int aspeed_video_start(struct aspeed_video *video)
>>>>> +{
>>>>> +	int rc;
>>>>> +
>>>>> +	aspeed_video_on(video);
>>>>> +
>>>>> +	aspeed_video_init_regs(video);
>>>>> +
>>>>> +	rc = aspeed_video_get_resolution(video);
>>>>> +	if (rc)
>>>>> +		return rc;
>>>>> +
>>>>> +	/*
>>>>> +	 * Set the timings here since the device was just opened for the first
>>>>> +	 * time.
>>>>> +	 */
>>>>> +	video->active_timings = video->detected_timings;
>>>> What happens if no valid signal was detected?
>>>>
>>>> My recommendation is to fallback to some default timings (VGA?) if no valid
>>>> initial timings were found.
>>>>
>>>> The expectation is that applications will always call QUERY_DV_TIMINGS first,
>>>> so it is really not all that important what the initial active_timings are,
>>>> as long as they are valid timings (valid as in: something that the hardware
>>>> can support).
>>> See just above, this call returns with a failure if no signal is
>>> detected, meaning the device cannot be opened. The only valid timings
>>> are the detected timings.
>> That's wrong. You must ALWAYS be able to open the device. If not valid
>> resolution is detected, just fallback to some default.
> 
> Why must open always succeed? What use is a video device that cannot 
> provide any video?
You always must be able to open the video device so applications can call
QUERYCAP. In fact, any ioctl that returns state information (G_FMT, G_CTRL,
G_INPUT, ENUM_*, etc) can always be called, regardless of whether there is
a video signal or if video streaming is in progress.

With this restriction I cannot even run an application that waits for the
SOURCE_CHANGE event to start streaming, such as 'v4l2-ctl --stream-mmap'
does because the open() will fail immediately.

Sorry, this is really wrong.

Regards,

	Hans
