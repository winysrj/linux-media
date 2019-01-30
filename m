Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CCAC282D4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA32521848
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfA3HmY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:42:24 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49709 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbfA3HmX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 02:42:23 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id okVlgyxI3BDyIokVpgtpVt; Wed, 30 Jan 2019 08:42:22 +0100
Subject: Re: [PATCH v10 0/4] Media Device Allocator API
To:     shuah <shuah@kernel.org>, mchehab@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <cover.1548360791.git.shuah@kernel.org>
 <e8717d11-1eff-2e07-53d5-6cd55356c66a@xs4all.nl>
 <481787e7-112a-80dd-228c-2497a12547b9@kernel.org>
 <d9ae1073-f6a9-1085-c8f8-8edd05daece5@xs4all.nl>
 <b9a62121-8ab0-5c1c-79ff-8bb39fc8b762@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fe6d6f63-72e3-8e2f-462d-b029997d8ee9@xs4all.nl>
Date:   Wed, 30 Jan 2019 08:42:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <b9a62121-8ab0-5c1c-79ff-8bb39fc8b762@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfC1iiIVuahTVxwYNG40X1zEK+9nMKOHAiDRD5PFTZiKQbqqMraBMMYeWBuzIhMXIUQHUh4D6RGn4IgaGyXtm30KSw7LrkoSsNaU+xi50/ef7kmuHUPc2
 oD03UhE9qy5CsqBrs7FV7UjFTG6a4YYhY07NW6fF9ADl6HY6rnoEesXMXAvvBNNbr2KXo0uf+lno7GlcMtbVDTL13b/UpeqV9TrguospbZNPx1sPX4ik/PMz
 /WP2joPK89NpeFv6yNcaNVxmgW08xWhlW+/Bfl06VLxDsfB5vNZcoyfctHy8eimxsUyab/qX+ChKYtz3pW1yUwvqWrHChK4h7JMat4Dvjb3p64q1vP8Z28l7
 Dvr3YGdowx2jKFYIBD9+IEFNdQPkdQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/30/19 2:50 AM, shuah wrote:
> On 1/29/19 2:43 AM, Hans Verkuil wrote:
>> On 1/29/19 12:48 AM, shuah wrote:
>>> Hi Hans,
>>>
>>> On 1/28/19 5:03 AM, Hans Verkuil wrote:
>>>> Hi Shuah,
>>>>
>>>> On 1/24/19 9:32 PM, Shuah Khan wrote:
>>>>> Media Device Allocator API to allows multiple drivers share a media device.
>>>>> This API solves a very common use-case for media devices where one physical
>>>>> device (an USB stick) provides both audio and video. When such media device
>>>>> exposes a standard USB Audio class, a proprietary Video class, two or more
>>>>> independent drivers will share a single physical USB bridge. In such cases,
>>>>> it is necessary to coordinate access to the shared resource.
>>>>>
>>>>> Using this API, drivers can allocate a media device with the shared struct
>>>>> device as the key. Once the media device is allocated by a driver, other
>>>>> drivers can get a reference to it. The media device is released when all
>>>>> the references are released.
>>>>>
>>>>> - This patch series is tested on 5.0-rc3 and addresses comments on
>>>>>     v9 series from Hans Verkuil.
>>>>> - v9 was tested on 4.20-rc6.
>>>>> - Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
>>>>>     arecord. When analog is streaming, digital and audio user-space
>>>>>     applications detect that the tuner is busy and exit. When digital
>>>>>     is streaming, analog and audio applications detect that the tuner is
>>>>>     busy and exit. When arecord is owns the tuner, digital and analog
>>>>>     detect that the tuner is busy and exit.
>>>>
>>>> I've been doing some testing with my au0828, and I am confused about one
>>>> thing, probably because it has been too long ago since I last looked into
>>>> this in detail:
>>>>
>>>
>>> Great.
>>>
>>>> Why can't I change the tuner frequency if arecord (and only arecord) is
>>>> streaming audio? If arecord is streaming, then it is recording the audio
>>>> from the analog TV tuner, right? So changing the analog TV frequency
>>>> should be fine.
>>>>
>>>
>>> Changing analog TV frequency would be s_frequency. The way it works is
>>> any s_* calls would require holding the pipeline. In Analog TV case, it
>>> would mean holding both audio and video pipelines for any changes
>>> including TV.
>>>
>>> As I recall, we discussed this design and the decision was to make all
>>> s_* calls interfaces to hold the tuner. A special exception is g_tuner
>>> in case of au0828. au0828 initializes the tuner from s_* interfaces and
>>> its g_tuner interfaces. Allowing s_frequency to proceed will disrupt the
>>> arecord audio stream.
>>>
>>> Query (q_*) works just fine without holding the pipeline. I limited the
>>> analog holds to just the ones that are required. The current set is
>>> required to avoid audio stream disruptions.
>>
>> So I am not sure about that ('avoid audio stream disruptions'): if I
>> stream video AND use arecord, then I can just set the frequency while
>> streaming. Doesn't that interrupt audio as well? And are you sure changing
>> the tuner frequency actually disrupts audio? And if audio is disrupted,
>> are we talking about a glitch or is audio permanently disrupted?
> 
> I think it is a glitch. I will run some tests and let you know.
>>
>> That's basically the inconsistent behavior I noticed: just running arecord
>> will prevent me from changing the frequency, but if I run arecord and stream
>> video, then it is suddenly OK to change the frequency.
> 
> How are you changing frequency? I want to duplicate what you are doing.

v4l2-ctl -f <freq>

> 
>>
>> BTW, I think there was also inconsistent behavior in the order of streaming
>> audio and video: if I stream video first, then I can stream audio afterwards.
>> But if I stream audio first, then (if I remember correctly) I can't start
>> video streaming.
>>
> 
> I will run some tests tomorrow and see what I find. Which video apps are
> you running for these tests?

v4l2-ctl or qv4l2.

Regards,

	Hans

> 
> thanks,
> -- Shuah
> 

