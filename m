Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:56294 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbeKJHRH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 02:17:07 -0500
Received: by mail-it1-f194.google.com with SMTP id b7-v6so5042384itd.5
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 13:34:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACT4Y+Y-0Dge=2atfX+_33+q1=wJ_82hzRKoeGSx7oRrds4R4A@mail.gmail.com>
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl> <CACT4Y+Y396cyUx+tmo6_YT7bmBt63-AYe5i0OG_5tuAUc+281A@mail.gmail.com>
 <20334055-77db-49cc-f0f6-f467ea9c220f@xs4all.nl> <CACT4Y+Y-0Dge=2atfX+_33+q1=wJ_82hzRKoeGSx7oRrds4R4A@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 9 Nov 2018 13:34:20 -0800
Message-ID: <CACT4Y+a+UkMHZ6kgfLBvgv5QB9++hMtaFnvT67NqHfWXzv3+zg@mail.gmail.com>
Subject: Re: VIVID/VIMC and media fuzzing
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: helen.koike@collabora.com, syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 9, 2018 at 1:17 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Fri, Nov 9, 2018 at 6:16 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Dmitry,
>>
>> On 11/02/18 18:15, Dmitry Vyukov wrote:
>>> On Wed, Oct 31, 2018 at 10:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 10/30/2018 03:02 PM, Dmitry Vyukov wrote:
>>>>> Hello Helen and linux-media,
>>>>>
>>>>> I've attended your talk "Shifting Media App Development into High
>>>>> Gear" on OSS Summit last week and approached you with some questions
>>>>> if/how this can be used for kernel testing. Thanks, turn out to be a
>>>>> very useful talk!
>>>>>
>>>>> I am working on syzkaller/syzbot, continuous kernel fuzzing system:
>>>>> https://github.com/google/syzkaller
>>>>> https://github.com/google/syzkaller/blob/master/docs/syzbot.md
>>>>> https://syzkaller.appspot.com
>>>>>
>>>>> After simply enabling CONFIG_VIDEO_VIMC, CONFIG_VIDEO_VIM2M,
>>>>> CONFIG_VIDEO_VIVID, CONFIG_VIDEO_VICODEC syzbot has found 8 bugs in
>>>>> media subsystem in just 24 hours:
>>>>>
>>>>> KASAN: use-after-free Read in vb2_mmap
>>>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/XGGH69jMWQ0/S8vfxgEmCgAJ
>>>>>
>>>>> KASAN: use-after-free Write in __vb2_cleanup_fileio
>>>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/qKKhsZVPo3o/P6AB2of2CQAJ
>>>>>
>>>>> WARNING in __vb2_queue_cancel
>>>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/S29GU_NtfPY/ZvAz8UDtCQAJ
>>>>>
>>>>> divide error in vivid_vid_cap_s_dv_timings
>>>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/GwF5zGBCfyg/wnuWmW_sCQAJ
>>>>
>>>> Should be fixed by https://patchwork.linuxtv.org/patch/52641/
>>>>
>>>>>
>>>>> KASAN: use-after-free Read in wake_up_if_idle
>>>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/aBWb_yV1kiI/sWQO63fkCQAJ
>>>>>
>>>>> KASAN: use-after-free Read in __vb2_perform_fileio
>>>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/MdFCZHz0LUQ/qSK_bFbcCQAJ
>>>>>
>>>>> INFO: task hung in vivid_stop_generating_vid_cap
>>>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/F_KFW6PVyTA/wTBeHLfTCQAJ
>>>>>
>>>>> KASAN: null-ptr-deref Write in kthread_stop
>>>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/u0AGnYvSlf4/fUiyfA_TCQAJ
>>>>
>>>> These last two should be fixed by https://patchwork.linuxtv.org/patch/52640/
>>>
>>> This is great!
>>> This last one happens super frequently, so harms ability to find other bugs.
>>>
>>>> Haven't figured out the others yet (hope to get back to that next week).
>>>
>>> But note that syzbot added few more too! :)
>>
>> As of now (Fri Nov  9 14:47:31 CET 2018) I fixed all media-related syzbot
>> issues with the exception of https://syzkaller.appspot.com/bug?extid=f9966a25169b6d66d61f
>
> This is great!
> I will look into that one, or maybe syzbot will come up with a repro
> later. But since it happened only 2 times, it's probably either a
> subtle race, or requires interaction between several test processes
> (we generally try to keep them isolated, but since this is a global
> device collisions are possible).
>
>> There is no reproducer for that one and I couldn't figure out how it could
>> happen.
>>
>> I've posted patches for all issues except for two that deal with reproducers
>> using dup2(). I need to think about my fixes a bit more. dup2() is very nasty :-)
>>
>> What would be a good improvement is if you add this to the kernel command options:
>> "vivid.n_devs=2 vivid.multiplanar=1,2"
>>
>> This will create two vivid instances, one using the single planar API and one using
>> the multiplanar API. That will improve the test coverage.
>
> Re this and collisions between multiple test processes. We actually
> would like to have moar devices and partition them between test
> processes. Say if we need need devices for 8 test processes, will it
> work to specify something like "vivid.n_devs=16
> vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2" and then use
> devices 0/1 in the first test process, 2/3 in the second and so on?
>
> Without giving any flags, I see 8 /dev/video* devices, does
> vivid.n_devs defaults to 8?

I am a bit lost.

vivid.n_devs=16 vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2
creates 32 /dev/video* devices.

but vivid.n_devs=8 vivid.multiplanar=1,2,1,2,1,2,1,2 creates 24
/dev/video* devices.

These parameters also affect /dev/{vbi,radio,swradio} in strange ways

Also, by default there is /dev/radio0 and /dev/radio1, are these
different types of devices, e.g. "source" and "sink"? Or they are
identical? And the same question for other types of devices?

How can I create 8 independent partitions of devices? What devices
will belong to each partition?


>> I also noticed that you appear to test only video devices. But vivid also creates
>> vbi, radio and swradio devices. It would be nice to have those tested as well.
>
> Will do.
> FTR, this is these devices:
>
> # ls -l /dev/{vbi,radio,swradio}*
> crw-rw---- 1 root video 81, 14 Nov  9 21:07 /dev/radio0
> crw-rw---- 1 root video 81, 15 Nov  9 21:07 /dev/radio1
> crw-rw---- 1 root video 81, 13 Nov  9 21:07 /dev/swradio0
> crw-rw---- 1 root video 81, 11 Nov  9 21:07 /dev/vbi0
> crw-rw---- 1 root video 81, 12 Nov  9 21:07 /dev/vbi1
>
> Why are there 2 radio and vbi? Are they different? Is it possible to
> also create more of them? Are there any other useful command line args
> for them?
>
>
>>>>> Based on this I think if we put more effort into media fuzzing, it
>>>>> will be able to find dozens more.
>>>>
>>>> Yeah, this is good stuff. Thank you for setting this up.
>>>>
>>>>>
>>>>> syzkaller needs descriptions of kernel interfaces to efficiently cover
>>>>> a subsystem. For example, see:
>>>>> https://github.com/google/syzkaller/blob/master/sys/linux/uinput.txt
>>>>> Hopefully you can read it without much explanation, it basically
>>>>> states that there is that node in /dev and here are ioctls and other
>>>>> syscalls that are relevant for this device and here are types of
>>>>> arguments and layout of involved data structures.
>>>>>
>>>>> Turned we actually have such descriptions for /dev/video* and /dev/v4l-subdev*:
>>>>> https://github.com/google/syzkaller/blob/master/sys/linux/video4linux.txt
>>>>> But we don't have anything for /dev/media*, fuzzer merely knows that
>>>>> it can open the device:
>>>>> https://github.com/google/syzkaller/blob/12b38f22c18c6109a5cc1c0238d015eef121b9b7/sys/linux/sys.txt#L479
>>>>> and then it will just blindly execute completely random workload on
>>>>> it, e.g. most likely it won't be able to come up with a proper complex
>>>>> structure layout for some ioctls. And I am actually not completely
>>>>> sure about completeness and coverage of video4linux.txt descriptions
>>>>> too as they were contributed by somebody interested in android
>>>>> testing.
>>>>
>>>> A quick look suggests that it is based on the 4.9 videodev2.h, which ain't
>>>> too bad. There are some differences between the 4.20 videodev2.h and the
>>>> 4.9, but not too many.
>>>
>>>
>>> Makes sense because the latest android use 4.9.
>>> Looking at the diff with 4.9 it seems that the APIs were mostly just
>>> extended, so we just need to extend syzkaller descriptions
>>> correspondingly.
>>>
>>>>> I wonder if somebody knowledgeable in /dev/media interface be willing
>>>>> to contribute additional descriptions?
>>>>
>>>> We'll have to wait for 4.20-rc1 to be released since there are important
>>>> additions to the media API.
>>>
>>> Additions are fine. We can extend syzkaller descriptions later too.
>>> But if they are already in, say, linux-next, then syzbot tests it too.
>>>
>>>
>>>> I can probably come up with something, I'm
>>>> just not sure when I get around to it. Ping me in three weeks time if you
>>>> haven't heard from me.
>>>>
>>>>>
>>>>> We also have code coverage reports with the coverage fuzzer achieved
>>>>> so far. Here in the Cover column:
>>>>> https://syzkaller.appspot.com/#managers
>>>>> e.g. this one (but note this is a ~80MB html file):
>>>>> https://storage.googleapis.com/syzkaller/cover/ci-upstream-kasan-gce-root.html
>>>>> This can be used to assess e.g. v4l coverage. But I don't know what's
>>>>> coverable in general from syscalls and what's coverable via the stub
>>>>> drivers in particular. So some expertise from media developers would
>>>>> be helpful too.
>>>>
>>>> The four virtual drivers should give pretty decent coverage of the core
>>>> code. Are you able to test with a 32-bit syzkaller application on a 64-bit
>>>> kernel as well? That way the compat32 code is tested.
>>>
>>> This is coverage from 32-bit instance:
>>> https://storage.googleapis.com/syzkaller/cover/ci-upstream-kasan-gce-386.html
>>> There is some coverage in drivers/media, but I don't know where to
>>> look specifically. E.g. drivers/media/v4l2-core/v4l2-ioctl.c does not
>>> mention "compat".
>>
>> It's in drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>>
>> BTW, is ci-upstream-kasan-gce-386.html a 64 bit kernel with 32 bit apps? Or
>> is it a 32-bit kernel? The latter is not very interesting.
>
> Yes, it's 64-bit kernel and 32-bit app. Yet to find anybody who would
> be interested in 32-bit x86 kernel today :)
>
>
>>>>> Do I understand it correctly that when a process opens /dev/video* or
>>>>> /dev/media* it gets a private instance of the device? In particular,
>>>>> if several processes test this in parallel, will they collide? Or they
>>>>> will stress separate objects?
>>>>
>>>> It actually depends on the driver. M2M devices will give you a private
>>>> instance whenever you open it. Others do not, but you can call most ioctls
>>>> in parallel. But after calling REQBUFS or CREATE_BUFS the filehandle that
>>>> called those ioctls becomes owner of the device until the buffers are
>>>> released. So other filehandles cannot do any streaming operations (EBUSY
>>>> will be returned).
>>>
>>> Are the devices created by VIMC, VIM2M, VIVID, VICODEC M2M or not?
>>> I guess VIM2M is M2M, but what about others?
>>
>> vim2m and vicodec are memory-to-memory devices. But vivid and vimc are not.
>>
>> Easy to check: v4l2-ctl -D -d /dev/videoX will report Video Memory-to-Memory
>> capabilities.
>>
>>>
>>> CREATE_BUFS privatization is somewhat unfortunate, but I guess we can
>>> live with it for now.
>>
>> Sorry, I'm not sure what you mean.
>
> You said:
>
>>> But after calling REQBUFS or CREATE_BUFS the filehandle that
>>> called those ioctls becomes owner of the device until the buffers are
>>> released. So other filehandles cannot do any streaming operations (EBUSY
>>> will be returned).
>
> This semantics are somewhat unfortunate for syzkaller because one test
> process will affect/block other test processes, and we try to make
> them as independent as possible. E.g. If this can affect syzkaller
> ability to create reproducers, because in one run of a test if was
> affected by an unrelated test and crashed, but if we try to reproduce
> the crash on the same test it won't crash again because now it's not
> affected by the unrelated test.
>
> But if we create more devices and partition them across test
> processes, it will resolve this problem?
>
>
>>> I assume that when the process dies it will release everything at
>>> least, because fuzzer will sure not pair create with release all the
>>> time.
