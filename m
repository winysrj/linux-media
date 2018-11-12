Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:46938 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbeKMGB7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 01:01:59 -0500
Received: by mail-io1-f67.google.com with SMTP id y22-v6so7115748ioj.13
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 12:07:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2424fcd2-d001-4e33-85d3-290e9a5e4168@xs4all.nl>
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl> <CACT4Y+Y396cyUx+tmo6_YT7bmBt63-AYe5i0OG_5tuAUc+281A@mail.gmail.com>
 <20334055-77db-49cc-f0f6-f467ea9c220f@xs4all.nl> <CACT4Y+Y-0Dge=2atfX+_33+q1=wJ_82hzRKoeGSx7oRrds4R4A@mail.gmail.com>
 <CACT4Y+a+UkMHZ6kgfLBvgv5QB9++hMtaFnvT67NqHfWXzv3+zg@mail.gmail.com>
 <ee98996f-7e4c-84e5-801f-4f381c33950e@xs4all.nl> <CACT4Y+bL=on5CqFxXpF8W0rSEGWUtcaESC9d9iO1naP_Vam6-Q@mail.gmail.com>
 <2424fcd2-d001-4e33-85d3-290e9a5e4168@xs4all.nl>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 12 Nov 2018 12:06:51 -0800
Message-ID: <CACT4Y+a=0LV0GOfBTf6=7E7BJUtxm4E9WzUBvDsMdr5PHh9ACg@mail.gmail.com>
Subject: Re: VIVID/VIMC and media fuzzing
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: helen.koike@collabora.com, syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 12, 2018 at 7:11 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>>> What would be a good improvement is if you add this to the kernel command options:
>>>>>> "vivid.n_devs=2 vivid.multiplanar=1,2"
>>>>>>
>>>>>> This will create two vivid instances, one using the single planar API and one using
>>>>>> the multiplanar API. That will improve the test coverage.
>>>>>
>>>>> Re this and collisions between multiple test processes. We actually
>>>>> would like to have moar devices and partition them between test
>>>>> processes. Say if we need need devices for 8 test processes, will it
>>>>> work to specify something like "vivid.n_devs=16
>>>>> vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2" and then use
>>>>> devices 0/1 in the first test process, 2/3 in the second and so on?
>>>>>
>>>>> Without giving any flags, I see 8 /dev/video* devices, does
>>>>> vivid.n_devs defaults to 8?
>>>>
>>>> I am a bit lost.
>>>>
>>>> vivid.n_devs=16 vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2
>>>> creates 32 /dev/video* devices.
>>>
>>> I see 38 /dev/video* devices: the first 3 are from vimc, then 2 * 16 = 32
>>> vivid devices (2 video nodes for each instance), then a vim2m device and
>>> finally two vicodec devices.
>>>
>>> So you should always see 6 + n_devs * 2 video devices.
>>>
>>>>
>>>> but vivid.n_devs=8 vivid.multiplanar=1,2,1,2,1,2,1,2 creates 24
>>>> /dev/video* devices.
>>>>
>>>> These parameters also affect /dev/{vbi,radio,swradio} in strange ways
>>>>
>>>> Also, by default there is /dev/radio0 and /dev/radio1, are these
>>>> different types of devices, e.g. "source" and "sink"? Or they are
>>>> identical? And the same question for other types of devices?
>>>
>>> vivid creates two radio devices per instance: one emulates a radio tuner,
>>> one emulates a radio modulator (so yes, source and sink). Same for vbi
>>> (one source, one sink) and one swradio device. It also creates two cec
>>> devices (source and sink).
>>>
>>>>
>>>> How can I create 8 independent partitions of devices? What devices
>>>> will belong to each partition?
>>>
>>> Exactly as you did above. Instance X (starting at 0) uses video nodes
>>> 3+2*X and 4+2*X.
>>
>> Thanks! Now I got it.
>> I've extended syzkaller to create more devices, use planar/non-planar,
>> radio, swradio, cec, vbi:
>>
>> https://github.com/google/syzkaller/commit/f3c4e6185953baea53d5651b84bd5897c02627f4#diff-a6fc2c4d3df5a6bcb42a628db614175f
>>
>> https://github.com/google/syzkaller/commit/f3c4e6185953baea53d5651b84bd5897c02627f4#diff-c60ec5d4add9b876f5d28fdeeaf3b7b8
>
> The cec devices do not use the V4L2 API, so it might be premature to add those.

It won't harm either. Fuzzer will still be able to call some
completely random stuff on them. It also serves as a reminded that
this is something we want to give to fuzzer, but don't have more
detailed descriptions.

> I plan on providing a patch for CEC in the near (?) future. Do you happen to
> have a script or something that can convert an API header to something that
> syzkaller needs? Or is it all manual?

It's manual at the moment.
We want to create some kind of helper thing that would at least
provide a skeleton. But in the end manual work is required anyway. For
example, there is an int field, is it just an int, or an fd, or some
set of flags, or something else? If there is a string, what are the
expected values? Etc. This information is simply not in the existing
kernel headers.
