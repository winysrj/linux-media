Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:53063 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbeJ3W4x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 18:56:53 -0400
Received: by mail-it1-f193.google.com with SMTP id r5-v6so11819364ith.2
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 07:03:16 -0700 (PDT)
MIME-Version: 1.0
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 30 Oct 2018 15:02:55 +0100
Message-ID: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
Subject: VIVID/VIMC and media fuzzing
To: helen.koike@collabora.com
Cc: syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>, hans.verkuil@cisco.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Helen and linux-media,

I've attended your talk "Shifting Media App Development into High
Gear" on OSS Summit last week and approached you with some questions
if/how this can be used for kernel testing. Thanks, turn out to be a
very useful talk!

I am working on syzkaller/syzbot, continuous kernel fuzzing system:
https://github.com/google/syzkaller
https://github.com/google/syzkaller/blob/master/docs/syzbot.md
https://syzkaller.appspot.com

After simply enabling CONFIG_VIDEO_VIMC, CONFIG_VIDEO_VIM2M,
CONFIG_VIDEO_VIVID, CONFIG_VIDEO_VICODEC syzbot has found 8 bugs in
media subsystem in just 24 hours:

KASAN: use-after-free Read in vb2_mmap
https://groups.google.com/forum/#!msg/syzkaller-bugs/XGGH69jMWQ0/S8vfxgEmCgAJ

KASAN: use-after-free Write in __vb2_cleanup_fileio
https://groups.google.com/forum/#!msg/syzkaller-bugs/qKKhsZVPo3o/P6AB2of2CQAJ

WARNING in __vb2_queue_cancel
https://groups.google.com/forum/#!msg/syzkaller-bugs/S29GU_NtfPY/ZvAz8UDtCQAJ

divide error in vivid_vid_cap_s_dv_timings
https://groups.google.com/forum/#!msg/syzkaller-bugs/GwF5zGBCfyg/wnuWmW_sCQAJ

KASAN: use-after-free Read in wake_up_if_idle
https://groups.google.com/forum/#!msg/syzkaller-bugs/aBWb_yV1kiI/sWQO63fkCQAJ

KASAN: use-after-free Read in __vb2_perform_fileio
https://groups.google.com/forum/#!msg/syzkaller-bugs/MdFCZHz0LUQ/qSK_bFbcCQAJ

INFO: task hung in vivid_stop_generating_vid_cap
https://groups.google.com/forum/#!msg/syzkaller-bugs/F_KFW6PVyTA/wTBeHLfTCQAJ

KASAN: null-ptr-deref Write in kthread_stop
https://groups.google.com/forum/#!msg/syzkaller-bugs/u0AGnYvSlf4/fUiyfA_TCQAJ

Based on this I think if we put more effort into media fuzzing, it
will be able to find dozens more.

syzkaller needs descriptions of kernel interfaces to efficiently cover
a subsystem. For example, see:
https://github.com/google/syzkaller/blob/master/sys/linux/uinput.txt
Hopefully you can read it without much explanation, it basically
states that there is that node in /dev and here are ioctls and other
syscalls that are relevant for this device and here are types of
arguments and layout of involved data structures.

Turned we actually have such descriptions for /dev/video* and /dev/v4l-subdev*:
https://github.com/google/syzkaller/blob/master/sys/linux/video4linux.txt
But we don't have anything for /dev/media*, fuzzer merely knows that
it can open the device:
https://github.com/google/syzkaller/blob/12b38f22c18c6109a5cc1c0238d015eef121b9b7/sys/linux/sys.txt#L479
and then it will just blindly execute completely random workload on
it, e.g. most likely it won't be able to come up with a proper complex
structure layout for some ioctls. And I am actually not completely
sure about completeness and coverage of video4linux.txt descriptions
too as they were contributed by somebody interested in android
testing.

I wonder if somebody knowledgeable in /dev/media interface be willing
to contribute additional descriptions?

We also have code coverage reports with the coverage fuzzer achieved
so far. Here in the Cover column:
https://syzkaller.appspot.com/#managers
e.g. this one (but note this is a ~80MB html file):
https://storage.googleapis.com/syzkaller/cover/ci-upstream-kasan-gce-root.html
This can be used to assess e.g. v4l coverage. But I don't know what's
coverable in general from syscalls and what's coverable via the stub
drivers in particular. So some expertise from media developers would
be helpful too.

Do I understand it correctly that when a process opens /dev/video* or
/dev/media* it gets a private instance of the device? In particular,
if several processes test this in parallel, will they collide? Or they
will stress separate objects?

You also mentioned that one of the devices requires some complex setup
via configfs. Is this interface described somewhere? Do you think it's
more profitable to pre-setup some fixed configuration for each test
process? Or just give the setup interface to fuzzer and let it do
random setup? Or both?

Thanks in advance
