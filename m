Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E39FC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 18:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0485217F9
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 18:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549390270;
	bh=hV1h2QEZh4sj0eOOvVq+UUR8daI4GbQa7rNj+rdTAv0=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=2KwwiIiU5lDU9xN4VjPiP/6A2+Hbit+HA8eBW+me2csNqExlPoFtkh44gnoCvYX+U
	 qrKV1MebbFI8cbglT2j8kFT88mVW6NDPw066XHKgMt1AUT+UAS7x0SP1tvavMtcYOf
	 yEdrlpM9Y5PvI+2ccBWwJA22JpyowMCaV5SJHc2M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfBESLK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 13:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbfBESLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 13:11:10 -0500
Received: from [10.0.2.154] (host81-133-38-158.in-addr.btopenworld.com [81.133.38.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68DE2083B;
        Tue,  5 Feb 2019 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549390268;
        bh=hV1h2QEZh4sj0eOOvVq+UUR8daI4GbQa7rNj+rdTAv0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=p2+rmDN2WkW/Mzz+Eihue95jfz7OfHTcBsB7cMTQWdVpteCtP4RqEqygdUxVFbGGj
         rKl517Uw0VdukfvJPXXEwZ6pGk//OJkqfICTR2LbEvIFul/lHzJR0uN/iuUjtNrrJH
         ySLcleFVPJeNr/jiIIYHpcNRFYJB6GlvqeElFt7k=
Subject: Re: [PATCH v10 0/4] Media Device Allocator API
To:     Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        perex@perex.cz, tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, shuah <shuah@kernel.org>
References: <cover.1548360791.git.shuah@kernel.org>
 <e8717d11-1eff-2e07-53d5-6cd55356c66a@xs4all.nl>
 <481787e7-112a-80dd-228c-2497a12547b9@kernel.org>
 <d9ae1073-f6a9-1085-c8f8-8edd05daece5@xs4all.nl>
 <b9a62121-8ab0-5c1c-79ff-8bb39fc8b762@kernel.org>
 <fe6d6f63-72e3-8e2f-462d-b029997d8ee9@xs4all.nl>
 <7a809bc8-f75e-04e6-f612-f6111c6b5a71@kernel.org>
 <7e6dc7f1-f596-22d7-bdd6-b54bd912a40d@xs4all.nl>
From:   shuah <shuah@kernel.org>
Message-ID: <80c87e59-bf25-d470-1566-c6aa60e9b0ed@kernel.org>
Date:   Tue, 5 Feb 2019 11:10:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <7e6dc7f1-f596-22d7-bdd6-b54bd912a40d@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/1/19 2:21 AM, Hans Verkuil wrote:
> On 2/1/19 1:46 AM, shuah wrote:
>> Hi Hans,
>>
>> On 1/30/19 12:42 AM, Hans Verkuil wrote:
>>> On 1/30/19 2:50 AM, shuah wrote:
>>>> On 1/29/19 2:43 AM, Hans Verkuil wrote:
>>>>> On 1/29/19 12:48 AM, shuah wrote:
>>>>>> Hi Hans,
>>>>>>
>>>>>> On 1/28/19 5:03 AM, Hans Verkuil wrote:
>>>>>>> Hi Shuah,
>>>>>>>
>>>>>>> On 1/24/19 9:32 PM, Shuah Khan wrote:
>>>>>>>> Media Device Allocator API to allows multiple drivers share a media device.
>>>>>>>> This API solves a very common use-case for media devices where one physical
>>>>>>>> device (an USB stick) provides both audio and video. When such media device
>>>>>>>> exposes a standard USB Audio class, a proprietary Video class, two or more
>>>>>>>> independent drivers will share a single physical USB bridge. In such cases,
>>>>>>>> it is necessary to coordinate access to the shared resource.
>>>>>>>>
>>>>>>>> Using this API, drivers can allocate a media device with the shared struct
>>>>>>>> device as the key. Once the media device is allocated by a driver, other
>>>>>>>> drivers can get a reference to it. The media device is released when all
>>>>>>>> the references are released.
>>>>>>>>
>>>>>>>> - This patch series is tested on 5.0-rc3 and addresses comments on
>>>>>>>>       v9 series from Hans Verkuil.
>>>>>>>> - v9 was tested on 4.20-rc6.
>>>>>>>> - Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
>>>>>>>>       arecord. When analog is streaming, digital and audio user-space
>>>>>>>>       applications detect that the tuner is busy and exit. When digital
>>>>>>>>       is streaming, analog and audio applications detect that the tuner is
>>>>>>>>       busy and exit. When arecord is owns the tuner, digital and analog
>>>>>>>>       detect that the tuner is busy and exit.
>>>>>>>
>>>>>>> I've been doing some testing with my au0828, and I am confused about one
>>>>>>> thing, probably because it has been too long ago since I last looked into
>>>>>>> this in detail:
>>>>>>>
>>>>>>
>>>>>> Great.
>>>>>>
>>>>>>> Why can't I change the tuner frequency if arecord (and only arecord) is
>>>>>>> streaming audio? If arecord is streaming, then it is recording the audio
>>>>>>> from the analog TV tuner, right? So changing the analog TV frequency
>>>>>>> should be fine.
>>>>>>>
>>>>>>
>>>>>> Changing analog TV frequency would be s_frequency. The way it works is
>>>>>> any s_* calls would require holding the pipeline. In Analog TV case, it
>>>>>> would mean holding both audio and video pipelines for any changes
>>>>>> including TV.
>>>>>>
>>>>>> As I recall, we discussed this design and the decision was to make all
>>>>>> s_* calls interfaces to hold the tuner. A special exception is g_tuner
>>>>>> in case of au0828. au0828 initializes the tuner from s_* interfaces and
>>>>>> its g_tuner interfaces. Allowing s_frequency to proceed will disrupt the
>>>>>> arecord audio stream.
>>>>>>
>>>>>> Query (q_*) works just fine without holding the pipeline. I limited the
>>>>>> analog holds to just the ones that are required. The current set is
>>>>>> required to avoid audio stream disruptions.
>>>>>
>>>>> So I am not sure about that ('avoid audio stream disruptions'): if I
>>>>> stream video AND use arecord, then I can just set the frequency while
>>>>> streaming. Doesn't that interrupt audio as well? And are you sure changing
>>>>> the tuner frequency actually disrupts audio? And if audio is disrupted,
>>>>> are we talking about a glitch or is audio permanently disrupted?
>>>>
>>>> I think it is a glitch. I will run some tests and let you know.
>>>>>
>>>>> That's basically the inconsistent behavior I noticed: just running arecord
>>>>> will prevent me from changing the frequency, but if I run arecord and stream
>>>>> video, then it is suddenly OK to change the frequency.
>>>>
>>>> How are you changing frequency? I want to duplicate what you are doing.
>>>
>>> v4l2-ctl -f <freq>
>>
>> I am not seeing the inconsistent behavior. Here are my results.
>>
>> 1. Started acecord and while it is running:
>>
>> arecord -M -D plughw:2,0 -c2  -f S16_LE -t wav foo.wav
>> Recording WAVE 'foo.wav' : Signed 16 bit Little Endian, Rate 8000 Hz, Stereo
>>
>> 2. Ran v4l2-ctl -f as follows:
>>
>> v4l2-ctl -f 700
>> VIDIOC_G_TUNER: failed: Device or resource busy
>> VIDIOC_S_FREQUENCY: failed: Device or resource busy
>>
>> Based on the current implementation, it failed with resource
>> busy as expected.
>>
>> 3. Started v4l2-ctl as follows:
>>
>>   v4l2-ctl --stream-mmap --stream-count=100 -d /dev/video0
>> VIDIOC_STREAMON: failed: Device or resource busy
> 
> Why is this? You have one analog tuner and it delivers independent audio
> and video streams. I should be able to start/stop audio and video independently.
> 
> And as mentioned above, if I use v4l2-ctl for video streaming, then start arecord,
> then that works fine. And I can change the tuner frequency while both are streaming.
> 
> But doing this the other way around (first start arecord, then v4l2-ctl) then that
> doesn't work.
> 
> It makes no sense.
> 
> Note that v4l2-ctl does not open audio, it solely deals with video. qv4l2 will
> open both audio and video, but for testing audio and video independently you
> need to use arecord/v4l2-ctl.
> 
> In any case, my understanding of how this should work is that both arecord and
> v4l2-ctl should attempt to lock the analog tuner resource, but they can share it.
> 
> If DVB is using the tuner, then both arecord and v4l2-ctl should fail with -EBUSY.
> Same if either of arecord/v4l2-ctl is running, then DVB should fail with -EBUSY.
> 
> BTW, I won't be able to test anything myself until Feb 9th since I'm abroad and
> don't have access to my au0828.
> 

I am also on a business trip at the moment and won't have access to my
au0828 until Feb 8th.

I think I understand your concern and the change to get the desired 
behavior of allowing tuner to be shared by arecord and v4l2-ctl is
going to in the code that is already in the mainline which is the
au0828_enable_source().

If you would like to wait to pull this series for the problem to be 
fixed, I can send that change in. It will be another patch added to
the series.

Or if you pull this and I can send fix on top. Let me know your preference.

thanks,
-- Shuah

