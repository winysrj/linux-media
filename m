Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C691BC67838
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 19:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FC0D20837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 19:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FC0D20837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=collabora.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbeLGTWw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 14:22:52 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59746 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeLGTWu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 14:22:50 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id 9ED09263B43
Subject: Re: VIVID/VIMC and media fuzzing
From:   Helen Koike <helen.koike@collabora.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
 <f5c8b506-325c-0164-c258-5c103592598d@collabora.com>
Openpgp: preference=signencrypt
Autocrypt: addr=helen.koike@collabora.com; keydata=
 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
Message-ID: <02f4c514-e899-513a-7e2c-3a005bbf7f2c@collabora.com>
Date:   Fri, 7 Dec 2018 17:22:42 -0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <f5c8b506-325c-0164-c258-5c103592598d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dmitry,

On 10/31/18 9:49 AM, Helen Koike wrote:
> Hi Dmitry,
> 
> On 10/31/18 7:46 AM, Hans Verkuil wrote:
>> On 10/30/2018 03:02 PM, Dmitry Vyukov wrote:
>>> Hello Helen and linux-media,
>>>
>>> I've attended your talk "Shifting Media App Development into High
>>> Gear" on OSS Summit last week and approached you with some questions
>>> if/how this can be used for kernel testing. Thanks, turn out to be a
>>> very useful talk!
> 
> Great, I am  glad it was useful :)
> 
>>>
>>> I am working on syzkaller/syzbot, continuous kernel fuzzing system:
>>> https://github.com/google/syzkaller
>>> https://github.com/google/syzkaller/blob/master/docs/syzbot.md
>>> https://syzkaller.appspot.com
>>>
>>> After simply enabling CONFIG_VIDEO_VIMC, CONFIG_VIDEO_VIM2M,
>>> CONFIG_VIDEO_VIVID, CONFIG_VIDEO_VICODEC syzbot has found 8 bugs in
>>> media subsystem in just 24 hours:
>>>
>>> KASAN: use-after-free Read in vb2_mmap
>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/XGGH69jMWQ0/S8vfxgEmCgAJ
>>>
>>> KASAN: use-after-free Write in __vb2_cleanup_fileio
>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/qKKhsZVPo3o/P6AB2of2CQAJ
>>>
>>> WARNING in __vb2_queue_cancel
>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/S29GU_NtfPY/ZvAz8UDtCQAJ
>>>
>>> divide error in vivid_vid_cap_s_dv_timings
>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/GwF5zGBCfyg/wnuWmW_sCQAJ
>>
>> Should be fixed by https://patchwork.linuxtv.org/patch/52641/
>>
>>>
>>> KASAN: use-after-free Read in wake_up_if_idle
>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/aBWb_yV1kiI/sWQO63fkCQAJ
>>>
>>> KASAN: use-after-free Read in __vb2_perform_fileio
>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/MdFCZHz0LUQ/qSK_bFbcCQAJ
>>>
>>> INFO: task hung in vivid_stop_generating_vid_cap
>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/F_KFW6PVyTA/wTBeHLfTCQAJ
>>>
>>> KASAN: null-ptr-deref Write in kthread_stop
>>> https://groups.google.com/forum/#!msg/syzkaller-bugs/u0AGnYvSlf4/fUiyfA_TCQAJ
>>
>> These last two should be fixed by https://patchwork.linuxtv.org/patch/52640/
>>
>> Haven't figured out the others yet (hope to get back to that next week).
>>
>>>
>>> Based on this I think if we put more effort into media fuzzing, it
>>> will be able to find dozens more.
>>
>> Yeah, this is good stuff. Thank you for setting this up.
> 
> Agreed, Dmitry thank you for doing this.
> 
>>
>>>
>>> syzkaller needs descriptions of kernel interfaces to efficiently cover
>>> a subsystem. For example, see:
>>> https://github.com/google/syzkaller/blob/master/sys/linux/uinput.txt
>>> Hopefully you can read it without much explanation, it basically
>>> states that there is that node in /dev and here are ioctls and other
>>> syscalls that are relevant for this device and here are types of
>>> arguments and layout of involved data structures.
>>>
>>> Turned we actually have such descriptions for /dev/video* and /dev/v4l-subdev*:
>>> https://github.com/google/syzkaller/blob/master/sys/linux/video4linux.txt
>>> But we don't have anything for /dev/media*, fuzzer merely knows that
>>> it can open the device:
>>> https://github.com/google/syzkaller/blob/12b38f22c18c6109a5cc1c0238d015eef121b9b7/sys/linux/sys.txt#L479
>>> and then it will just blindly execute completely random workload on
>>> it, e.g. most likely it won't be able to come up with a proper complex
>>> structure layout for some ioctls. And I am actually not completely
>>> sure about completeness and coverage of video4linux.txt descriptions
>>> too as they were contributed by somebody interested in android
>>> testing.
>>
>> A quick look suggests that it is based on the 4.9 videodev2.h, which ain't
>> too bad. There are some differences between the 4.20 videodev2.h and the
>> 4.9, but not too many.
>>
>>>
>>> I wonder if somebody knowledgeable in /dev/media interface be willing
>>> to contribute additional descriptions?
>>
>> We'll have to wait for 4.20-rc1 to be released since there are important
>> additions to the media API. I can probably come up with something, I'm
>> just not sure when I get around to it. Ping me in three weeks time if you
>> haven't heard from me.
>>
>>>
>>> We also have code coverage reports with the coverage fuzzer achieved
>>> so far. Here in the Cover column:
>>> https://syzkaller.appspot.com/#managers
>>> e.g. this one (but note this is a ~80MB html file):
>>> https://storage.googleapis.com/syzkaller/cover/ci-upstream-kasan-gce-root.html
>>> This can be used to assess e.g. v4l coverage. But I don't know what's
>>> coverable in general from syscalls and what's coverable via the stub
>>> drivers in particular. So some expertise from media developers would
>>> be helpful too.
>>
>> The four virtual drivers should give pretty decent coverage of the core
>> code. Are you able to test with a 32-bit syzkaller application on a 64-bit
>> kernel as well? That way the compat32 code is tested.
>>
>>>
>>> Do I understand it correctly that when a process opens /dev/video* or
>>> /dev/media* it gets a private instance of the device? In particular,
>>> if several processes test this in parallel, will they collide? Or they
>>> will stress separate objects?
>>
>> It actually depends on the driver. M2M devices will give you a private
>> instance whenever you open it. Others do not, but you can call most ioctls
>> in parallel. But after calling REQBUFS or CREATE_BUFS the filehandle that
>> called those ioctls becomes owner of the device until the buffers are
>> released. So other filehandles cannot do any streaming operations (EBUSY
>> will be returned).
>>
>>> You also mentioned that one of the devices requires some complex setup
>>> via configfs. Is this interface described somewhere? Do you think it's
>>> more profitable to pre-setup some fixed configuration for each test
>>> process? Or just give the setup interface to fuzzer and let it do
>>> random setup? Or both?
>>
>> That's the vimc driver, but the configfs code isn't in yet.
> 
> I'll try to submit it later this week (with documentation) :)

I submitted the first version at:
https://www.spinics.net/lists/linux-media/msg144244.html
As soon as it is updated we can add it to fuzzer. I believe some
pre-setup/fixed configuration would work.

I don't know much about fuzzer's code, if you could give me some
pointers I can help with that.

Thanks
Helen

> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Thanks in advance
>>>
>>
> 
> 
> Thanks
> Helen
> 
