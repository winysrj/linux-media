Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:53110 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbeKCCXi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 22:23:38 -0400
Received: by mail-it1-f193.google.com with SMTP id r5-v6so4132365ith.2
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2018 10:15:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 2 Nov 2018 18:15:24 +0100
Message-ID: <CACT4Y+Y396cyUx+tmo6_YT7bmBt63-AYe5i0OG_5tuAUc+281A@mail.gmail.com>
Subject: Re: VIVID/VIMC and media fuzzing
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: helen.koike@collabora.com, syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 31, 2018 at 10:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
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

This is great!
This last one happens super frequently, so harms ability to find other bugs.

> Haven't figured out the others yet (hope to get back to that next week).

But note that syzbot added few more too! :)

And there will be more, when I run syzkaller locally aimed only at
these devices I got:

general protection fault in vma_interval_tree_subtree_search
WARNING in dev_watchdog
BUG: unable to handle kernel paging request in tpg_print_str_6
kernel BUG at arch/x86/mm/physaddr.c:LINE!
BUG: unable to handle kernel NULL pointer dereference in qlist_free_all
INFO: rcu detected stall in corrupted
general protection fault in debug_check_no_obj_freed
KASAN: use-after-free Write in __vb2_cleanup_fileio
INFO: task hung in vivid_stop_generating_vid_cap
general protection fault in __bfs
divide error in vivid_thread_vid_out
KASAN: null-ptr-deref Write in kthread_stop
lost connection to test machine
general protection fault in __neigh_notify
BUG: unable to handle kernel paging request in tpg_print_str_2
BUG: unable to handle kernel NULL pointer dereference in corrupted
INFO: trying to register non-static key in corrupted
divide error in vivid_vid_cap_s_dv_timings
KASAN: null-ptr-deref Read in refcount_sub_and_test_checked
KASAN: use-after-free Read in v4l2_ctrl_grab
INFO: rcu detected stall in v4l2_ioctl
kernel panic: stack-protector: Kernel stack is corrupted in: do_vfs_ioctl
INFO: rcu detected stall in e1000_watchdog
BUG: unable to handle kernel paging request in corrupted
KASAN: use-after-free Read in vb2_mmap
BUG: unable to handle kernel paging request in tpg_print_str_4
BUG: unable to handle kernel paging request in tpg_print_str_8
kernel BUG at mm/vmalloc.c:LINE!
kernel panic: corrupted stack end detected inside scheduler
KASAN: stack-out-of-bounds Read in __schedule
WARNING in __vb2_queue_cancel
general protection fault in corrupted
KASAN: use-after-free Read in __vb2_perform_fileio
BUG: unable to handle kernel NULL pointer dereference in kthread_stop
general protection fault in fib_sync_down_dev
BUG: pagefault on kernel address ADDR in non-whitelisted uaccess
general protection fault in __vb2_queue_free
INFO: rcu detected stall in do_signal
INFO: task hung in corrupted
kernel BUG at include/linux/mm.h:LINE!
no output from test machine
BUG: workqueue lockup
KASAN: null-ptr-deref in kthread_stop
INFO: rcu detected stall in tcp_keepalive_timer



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


Makes sense because the latest android use 4.9.
Looking at the diff with 4.9 it seems that the APIs were mostly just
extended, so we just need to extend syzkaller descriptions
correspondingly.

>> I wonder if somebody knowledgeable in /dev/media interface be willing
>> to contribute additional descriptions?
>
> We'll have to wait for 4.20-rc1 to be released since there are important
> additions to the media API.

Additions are fine. We can extend syzkaller descriptions later too.
But if they are already in, say, linux-next, then syzbot tests it too.


> I can probably come up with something, I'm
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

This is coverage from 32-bit instance:
https://storage.googleapis.com/syzkaller/cover/ci-upstream-kasan-gce-386.html
There is some coverage in drivers/media, but I don't know where to
look specifically. E.g. drivers/media/v4l2-core/v4l2-ioctl.c does not
mention "compat".


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

Are the devices created by VIMC, VIM2M, VIVID, VICODEC M2M or not?
I guess VIM2M is M2M, but what about others?

CREATE_BUFS privatization is somewhat unfortunate, but I guess we can
live with it for now.
I assume that when the process dies it will release everything at
least, because fuzzer will sure not pair create with release all the
time.


>> You also mentioned that one of the devices requires some complex setup
>> via configfs. Is this interface described somewhere? Do you think it's
>> more profitable to pre-setup some fixed configuration for each test
>> process? Or just give the setup interface to fuzzer and let it do
>> random setup? Or both?
>
> That's the vimc driver, but the configfs code isn't in yet.
>
> Regards,
>
>         Hans
>
