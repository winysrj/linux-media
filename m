Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52732 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbeKMBFL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:05:11 -0500
Subject: Re: VIVID/VIMC and media fuzzing
To: Dmitry Vyukov <dvyukov@google.com>
Cc: helen.koike@collabora.com, syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
 <CACT4Y+Y396cyUx+tmo6_YT7bmBt63-AYe5i0OG_5tuAUc+281A@mail.gmail.com>
 <20334055-77db-49cc-f0f6-f467ea9c220f@xs4all.nl>
 <CACT4Y+Y-0Dge=2atfX+_33+q1=wJ_82hzRKoeGSx7oRrds4R4A@mail.gmail.com>
 <CACT4Y+a+UkMHZ6kgfLBvgv5QB9++hMtaFnvT67NqHfWXzv3+zg@mail.gmail.com>
 <ee98996f-7e4c-84e5-801f-4f381c33950e@xs4all.nl>
 <CACT4Y+bL=on5CqFxXpF8W0rSEGWUtcaESC9d9iO1naP_Vam6-Q@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2424fcd2-d001-4e33-85d3-290e9a5e4168@xs4all.nl>
Date: Mon, 12 Nov 2018 16:11:25 +0100
MIME-Version: 1.0
In-Reply-To: <CACT4Y+bL=on5CqFxXpF8W0rSEGWUtcaESC9d9iO1naP_Vam6-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/10/2018 08:28 PM, Dmitry Vyukov wrote:
> On Sat, Nov 10, 2018 at 2:01 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 11/09/2018 10:34 PM, Dmitry Vyukov wrote:
>>>>> What would be a good improvement is if you add this to the kernel command options:
>>>>> "vivid.n_devs=2 vivid.multiplanar=1,2"
>>>>>
>>>>> This will create two vivid instances, one using the single planar API and one using
>>>>> the multiplanar API. That will improve the test coverage.
>>>>
>>>> Re this and collisions between multiple test processes. We actually
>>>> would like to have moar devices and partition them between test
>>>> processes. Say if we need need devices for 8 test processes, will it
>>>> work to specify something like "vivid.n_devs=16
>>>> vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2" and then use
>>>> devices 0/1 in the first test process, 2/3 in the second and so on?
>>>>
>>>> Without giving any flags, I see 8 /dev/video* devices, does
>>>> vivid.n_devs defaults to 8?
>>>
>>> I am a bit lost.
>>>
>>> vivid.n_devs=16 vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2
>>> creates 32 /dev/video* devices.
>>
>> I see 38 /dev/video* devices: the first 3 are from vimc, then 2 * 16 = 32
>> vivid devices (2 video nodes for each instance), then a vim2m device and
>> finally two vicodec devices.
>>
>> So you should always see 6 + n_devs * 2 video devices.
>>
>>>
>>> but vivid.n_devs=8 vivid.multiplanar=1,2,1,2,1,2,1,2 creates 24
>>> /dev/video* devices.
>>>
>>> These parameters also affect /dev/{vbi,radio,swradio} in strange ways
>>>
>>> Also, by default there is /dev/radio0 and /dev/radio1, are these
>>> different types of devices, e.g. "source" and "sink"? Or they are
>>> identical? And the same question for other types of devices?
>>
>> vivid creates two radio devices per instance: one emulates a radio tuner,
>> one emulates a radio modulator (so yes, source and sink). Same for vbi
>> (one source, one sink) and one swradio device. It also creates two cec
>> devices (source and sink).
>>
>>>
>>> How can I create 8 independent partitions of devices? What devices
>>> will belong to each partition?
>>
>> Exactly as you did above. Instance X (starting at 0) uses video nodes
>> 3+2*X and 4+2*X.
> 
> Thanks! Now I got it.
> I've extended syzkaller to create more devices, use planar/non-planar,
> radio, swradio, cec, vbi:
> 
> https://github.com/google/syzkaller/commit/f3c4e6185953baea53d5651b84bd5897c02627f4#diff-a6fc2c4d3df5a6bcb42a628db614175f
> 
> https://github.com/google/syzkaller/commit/f3c4e6185953baea53d5651b84bd5897c02627f4#diff-c60ec5d4add9b876f5d28fdeeaf3b7b8

The cec devices do not use the V4L2 API, so it might be premature to add those.

I plan on providing a patch for CEC in the near (?) future. Do you happen to
have a script or something that can convert an API header to something that
syzkaller needs? Or is it all manual?

Regards,

	Hans

> 
> 
>>>>> I also noticed that you appear to test only video devices. But vivid also creates
>>>>> vbi, radio and swradio devices. It would be nice to have those tested as well.
>>>>
>>>> Will do.
>>>> FTR, this is these devices:
>>>>
>>>> # ls -l /dev/{vbi,radio,swradio}*
>>>> crw-rw---- 1 root video 81, 14 Nov  9 21:07 /dev/radio0
>>>> crw-rw---- 1 root video 81, 15 Nov  9 21:07 /dev/radio1
>>>> crw-rw---- 1 root video 81, 13 Nov  9 21:07 /dev/swradio0
>>>> crw-rw---- 1 root video 81, 11 Nov  9 21:07 /dev/vbi0
>>>> crw-rw---- 1 root video 81, 12 Nov  9 21:07 /dev/vbi1
>>>>
>>>> Why are there 2 radio and vbi? Are they different? Is it possible to
>>>> also create more of them? Are there any other useful command line args
>>>> for them?
>>
>> As mentioned: the first is capture, the second output. It's per vivid
>> instance.
>>
>> <snip>
>>
>>>>>> CREATE_BUFS privatization is somewhat unfortunate, but I guess we can
>>>>>> live with it for now.
>>>>>
>>>>> Sorry, I'm not sure what you mean.
>>>>
>>>> You said:
>>>>
>>>>>> But after calling REQBUFS or CREATE_BUFS the filehandle that
>>>>>> called those ioctls becomes owner of the device until the buffers are
>>>>>> released. So other filehandles cannot do any streaming operations (EBUSY
>>>>>> will be returned).
>>>>
>>>> This semantics are somewhat unfortunate for syzkaller because one test
>>>> process will affect/block other test processes, and we try to make
>>>> them as independent as possible. E.g. If this can affect syzkaller
>>>> ability to create reproducers, because in one run of a test if was
>>>> affected by an unrelated test and crashed, but if we try to reproduce
>>>> the crash on the same test it won't crash again because now it's not
>>>> affected by the unrelated test.
>>>>
>>>> But if we create more devices and partition them across test
>>>> processes, it will resolve this problem?
>>
>> I think it will help, yes.
>>
>>>>
>>>>
>>>>>> I assume that when the process dies it will release everything at
>>>>>> least, because fuzzer will sure not pair create with release all the
>>>>>> time.
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
>> For more options, visit https://groups.google.com/d/optout.
