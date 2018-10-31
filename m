Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50112 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbeJaUrW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 16:47:22 -0400
Subject: Re: VIVID/VIMC and media fuzzing
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Dmitry Vyukov <dvyukov@google.com>
Cc: syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <f5c8b506-325c-0164-c258-5c103592598d@collabora.com>
Date: Wed, 31 Oct 2018 08:49:27 -0300
MIME-Version: 1.0
In-Reply-To: <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

On 10/31/18 7:46 AM, Hans Verkuil wrote:
> On 10/30/2018 03:02 PM, Dmitry Vyukov wrote:
>> Hello Helen and linux-media,
>>
>> I've attended your talk "Shifting Media App Development into High
>> Gear" on OSS Summit last week and approached you with some questions
>> if/how this can be used for kernel testing. Thanks, turn out to be a
>> very useful talk!

Great, I am  glad it was useful :)

>>
>> I am working on syzkaller/syzbot, continuous kernel fuzzing system:
>> https://github.com/google/syzkaller
>> https://github.com/google/syzkaller/blob/master/docs/syzbot.md
>> https://syzkaller.appspot.com
>>
>> After simply enabling CONFIG_VIDEO_VIMC, CONFIG_VIDEO_VIM2M,
>> CONFIG_VIDEO_VIVID, CONFIG_VIDEO_VICODEC syzbot has found 8 bugs in
>> media subsystem in just 24 hours:
>>
>> KASAN: use-after-free Read in vb2_mmap
>> https://groups.google.com/forum/#!msg/syzkaller-bugs/XGGH69jMWQ0/S8vfxgEmCgAJ
>>
>> KASAN: use-after-free Write in __vb2_cleanup_fileio
>> https://groups.google.com/forum/#!msg/syzkaller-bugs/qKKhsZVPo3o/P6AB2of2CQAJ
>>
>> WARNING in __vb2_queue_cancel
>> https://groups.google.com/forum/#!msg/syzkaller-bugs/S29GU_NtfPY/ZvAz8UDtCQAJ
>>
>> divide error in vivid_vid_cap_s_dv_timings
>> https://groups.google.com/forum/#!msg/syzkaller-bugs/GwF5zGBCfyg/wnuWmW_sCQAJ
> 
> Should be fixed by https://patchwork.linuxtv.org/patch/52641/
> 
>>
>> KASAN: use-after-free Read in wake_up_if_idle
>> https://groups.google.com/forum/#!msg/syzkaller-bugs/aBWb_yV1kiI/sWQO63fkCQAJ
>>
>> KASAN: use-after-free Read in __vb2_perform_fileio
>> https://groups.google.com/forum/#!msg/syzkaller-bugs/MdFCZHz0LUQ/qSK_bFbcCQAJ
>>
>> INFO: task hung in vivid_stop_generating_vid_cap
>> https://groups.google.com/forum/#!msg/syzkaller-bugs/F_KFW6PVyTA/wTBeHLfTCQAJ
>>
>> KASAN: null-ptr-deref Write in kthread_stop
>> https://groups.google.com/forum/#!msg/syzkaller-bugs/u0AGnYvSlf4/fUiyfA_TCQAJ
> 
> These last two should be fixed by https://patchwork.linuxtv.org/patch/52640/
> 
> Haven't figured out the others yet (hope to get back to that next week).
> 
>>
>> Based on this I think if we put more effort into media fuzzing, it
>> will be able to find dozens more.
> 
> Yeah, this is good stuff. Thank you for setting this up.

Agreed, Dmitry thank you for doing this.

> 
>>
>> syzkaller needs descriptions of kernel interfaces to efficiently cover
>> a subsystem. For example, see:
>> https://github.com/google/syzkaller/blob/master/sys/linux/uinput.txt
>> Hopefully you can read it without much explanation, it basically
>> states that there is that node in /dev and here are ioctls and other
>> syscalls that are relevant for this device and here are types of
>> arguments and layout of involved data structures.
>>
>> Turned we actually have such descriptions for /dev/video* and /dev/v4l-subdev*:
>> https://github.com/google/syzkaller/blob/master/sys/linux/video4linux.txt
>> But we don't have anything for /dev/media*, fuzzer merely knows that
>> it can open the device:
>> https://github.com/google/syzkaller/blob/12b38f22c18c6109a5cc1c0238d015eef121b9b7/sys/linux/sys.txt#L479
>> and then it will just blindly execute completely random workload on
>> it, e.g. most likely it won't be able to come up with a proper complex
>> structure layout for some ioctls. And I am actually not completely
>> sure about completeness and coverage of video4linux.txt descriptions
>> too as they were contributed by somebody interested in android
>> testing.
> 
> A quick look suggests that it is based on the 4.9 videodev2.h, which ain't
> too bad. There are some differences between the 4.20 videodev2.h and the
> 4.9, but not too many.
> 
>>
>> I wonder if somebody knowledgeable in /dev/media interface be willing
>> to contribute additional descriptions?
> 
> We'll have to wait for 4.20-rc1 to be released since there are important
> additions to the media API. I can probably come up with something, I'm
> just not sure when I get around to it. Ping me in three weeks time if you
> haven't heard from me.
> 
>>
>> We also have code coverage reports with the coverage fuzzer achieved
>> so far. Here in the Cover column:
>> https://syzkaller.appspot.com/#managers
>> e.g. this one (but note this is a ~80MB html file):
>> https://storage.googleapis.com/syzkaller/cover/ci-upstream-kasan-gce-root.html
>> This can be used to assess e.g. v4l coverage. But I don't know what's
>> coverable in general from syscalls and what's coverable via the stub
>> drivers in particular. So some expertise from media developers would
>> be helpful too.
> 
> The four virtual drivers should give pretty decent coverage of the core
> code. Are you able to test with a 32-bit syzkaller application on a 64-bit
> kernel as well? That way the compat32 code is tested.
> 
>>
>> Do I understand it correctly that when a process opens /dev/video* or
>> /dev/media* it gets a private instance of the device? In particular,
>> if several processes test this in parallel, will they collide? Or they
>> will stress separate objects?
> 
> It actually depends on the driver. M2M devices will give you a private
> instance whenever you open it. Others do not, but you can call most ioctls
> in parallel. But after calling REQBUFS or CREATE_BUFS the filehandle that
> called those ioctls becomes owner of the device until the buffers are
> released. So other filehandles cannot do any streaming operations (EBUSY
> will be returned).
> 
>> You also mentioned that one of the devices requires some complex setup
>> via configfs. Is this interface described somewhere? Do you think it's
>> more profitable to pre-setup some fixed configuration for each test
>> process? Or just give the setup interface to fuzzer and let it do
>> random setup? Or both?
> 
> That's the vimc driver, but the configfs code isn't in yet.

I'll try to submit it later this week (with documentation) :)

> 
> Regards,
> 
> 	Hans
> 
>>
>> Thanks in advance
>>
> 


Thanks
Helen
