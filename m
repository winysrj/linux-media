Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF47C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66AF52084A
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfA2JnI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:43:08 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40887 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725298AbfA2JnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 04:43:07 -0500
Received: from [IPv6:2001:420:44c1:2579:1c83:9203:362b:bf24] ([IPv6:2001:420:44c1:2579:1c83:9203:362b:bf24])
        by smtp-cloud9.xs4all.net with ESMTPA
        id oPv3g04HRRO5ZoPv7gNCz5; Tue, 29 Jan 2019 10:43:05 +0100
Subject: Re: [PATCH v10 0/4] Media Device Allocator API
To:     shuah <shuah@kernel.org>, mchehab@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <cover.1548360791.git.shuah@kernel.org>
 <e8717d11-1eff-2e07-53d5-6cd55356c66a@xs4all.nl>
 <481787e7-112a-80dd-228c-2497a12547b9@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d9ae1073-f6a9-1085-c8f8-8edd05daece5@xs4all.nl>
Date:   Tue, 29 Jan 2019 10:43:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <481787e7-112a-80dd-228c-2497a12547b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOeoGCy4X+FzaHpMSSJDnL8juMgRVeZapEcVbuqJ3eFzigEbOY7EE9EjMqggjVPIk/ISv9ExxzYrrqs7s2+40AVmU4dj1q8udJUZwPAKLKn+elaV4tqR
 6BqwvD83ZbP57w70CaVzIL+AAktHVsyxd3DXfAI4A2CH2k3yCFG0MOBPbCOpfsN7ofB3I+8fdMlCbB1MNEZDnWrbPSTAf3HpfY+LeLMzez7XgoExNG4VkRan
 MSMw2W3HYuGW6aKDjlsMH1q/FsTfmxVUYzNLw/JorFervMGNT5IhQCuRuW4/hKYbQWN/QwQUfY0ixlU5s5y+EalFD+7eTm8fvOiXc+EYEyVmqdAb3YIGwahv
 WNzqNIgf19qp3f36bWykeaS/u7s1f0otCSuI/2+jsedAYQD/1jlcGBVcDoqbS0D78vBSKlrpwr+ABDK4RKJAha+IPvvsAMxWTvixda8leFQ61cLtA7qRkuKN
 q7X/9GXwsyJZutk1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/29/19 12:48 AM, shuah wrote:
> Hi Hans,
> 
> On 1/28/19 5:03 AM, Hans Verkuil wrote:
>> Hi Shuah,
>>
>> On 1/24/19 9:32 PM, Shuah Khan wrote:
>>> Media Device Allocator API to allows multiple drivers share a media device.
>>> This API solves a very common use-case for media devices where one physical
>>> device (an USB stick) provides both audio and video. When such media device
>>> exposes a standard USB Audio class, a proprietary Video class, two or more
>>> independent drivers will share a single physical USB bridge. In such cases,
>>> it is necessary to coordinate access to the shared resource.
>>>
>>> Using this API, drivers can allocate a media device with the shared struct
>>> device as the key. Once the media device is allocated by a driver, other
>>> drivers can get a reference to it. The media device is released when all
>>> the references are released.
>>>
>>> - This patch series is tested on 5.0-rc3 and addresses comments on
>>>    v9 series from Hans Verkuil.
>>> - v9 was tested on 4.20-rc6.
>>> - Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
>>>    arecord. When analog is streaming, digital and audio user-space
>>>    applications detect that the tuner is busy and exit. When digital
>>>    is streaming, analog and audio applications detect that the tuner is
>>>    busy and exit. When arecord is owns the tuner, digital and analog
>>>    detect that the tuner is busy and exit.
>>
>> I've been doing some testing with my au0828, and I am confused about one
>> thing, probably because it has been too long ago since I last looked into
>> this in detail:
>>
> 
> Great.
> 
>> Why can't I change the tuner frequency if arecord (and only arecord) is
>> streaming audio? If arecord is streaming, then it is recording the audio
>> from the analog TV tuner, right? So changing the analog TV frequency
>> should be fine.
>>
> 
> Changing analog TV frequency would be s_frequency. The way it works is
> any s_* calls would require holding the pipeline. In Analog TV case, it
> would mean holding both audio and video pipelines for any changes
> including TV.
> 
> As I recall, we discussed this design and the decision was to make all
> s_* calls interfaces to hold the tuner. A special exception is g_tuner
> in case of au0828. au0828 initializes the tuner from s_* interfaces and
> its g_tuner interfaces. Allowing s_frequency to proceed will disrupt the
> arecord audio stream.
> 
> Query (q_*) works just fine without holding the pipeline. I limited the
> analog holds to just the ones that are required. The current set is
> required to avoid audio stream disruptions.

So I am not sure about that ('avoid audio stream disruptions'): if I
stream video AND use arecord, then I can just set the frequency while
streaming. Doesn't that interrupt audio as well? And are you sure changing
the tuner frequency actually disrupts audio? And if audio is disrupted,
are we talking about a glitch or is audio permanently disrupted?

That's basically the inconsistent behavior I noticed: just running arecord
will prevent me from changing the frequency, but if I run arecord and stream
video, then it is suddenly OK to change the frequency.

BTW, I think there was also inconsistent behavior in the order of streaming
audio and video: if I stream video first, then I can stream audio afterwards.
But if I stream audio first, then (if I remember correctly) I can't start
video streaming.

Regards,

	Hans

> 
> I made sure v4l-ctl --all works when the pipeline is locked by any one
> of the 3 (audio, video, DVB).
> 
> Hope this helps.
> 
> thanks,
> -- Shuah
> 
> 

