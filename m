Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:57217 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727436AbeJaTCk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 15:02:40 -0400
Subject: Re: VIVID/VIMC and media fuzzing
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitry Vyukov <dvyukov@google.com>, helen.koike@collabora.com
Cc: syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>,
        Sean Young <sean@mess.org>
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
Message-ID: <bd5bb1af-7863-18f2-103a-264ef091dbc0@xs4all.nl>
Date: Wed, 31 Oct 2018 11:05:10 +0100
MIME-Version: 1.0
In-Reply-To: <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC-ing Sean Young: please see question at the end.

On 10/31/2018 10:46 AM, Hans Verkuil wrote:
> On 10/30/2018 03:02 PM, Dmitry Vyukov wrote:
>> Hello Helen and linux-media,
>>
>> I've attended your talk "Shifting Media App Development into High
>> Gear" on OSS Summit last week and approached you with some questions
>> if/how this can be used for kernel testing. Thanks, turn out to be a
>> very useful talk!
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

While adding support for the media API I should also add support for the CEC
API, since vivid can emulate a CEC device as well.

It would be really neat to have similar support for DVB and RC as well, but we
don't have virtual drivers for those. Although CEC can expose an RC input device
if enabled by the kernel config.

Sean, would that be a good starting point for fuzzing the RC API? Or do you think
we really need proper RC emulation in vivid as we discussed last week?

Regards,

	Hans
