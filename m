Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:32964 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbcC1T2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 15:28:09 -0400
Received: by mail-io0-f193.google.com with SMTP id g185so4393115ioa.0
        for <linux-media@vger.kernel.org>; Mon, 28 Mar 2016 12:28:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160328150948.3efa93ee@recife.lan>
References: <1458858164-1066-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<20160328150948.3efa93ee@recife.lan>
Date: Mon, 28 Mar 2016 15:28:08 -0400
Message-ID: <CABxcv=n8LeMjk6PMbfk3WBOA8zrsOYadfeZo-coh9edh7cozSQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] media: Revert broken locking changes
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On Mon, Mar 28, 2016 at 2:09 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Fri, 25 Mar 2016 00:22:42 +0200
> Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:
>
>> Commit c38077d39c7e ("[media] media-device: get rid of the spinlock")
>> introduced a deadlock in the MEDIA_IOC_ENUM_LINKS ioctl handler.
>>
>> Revert the broken commit as well as another that has been merged on top, and
>> let's implement a proper fix instead of half-baked hacks this time.
>>
>> [ 2760.127749] INFO: task media-ctl:954 blocked for more than 120 seconds.
>> [ 2760.131867]       Not tainted 4.5.0+ #357
>> [ 2760.134622] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [ 2760.139310] media-ctl       D ffffffc000086bcc     0   954    671 0x00000001
>> [ 2760.143618] Call trace:
>> [ 2760.145601] [<ffffffc000086bcc>] __switch_to+0x90/0xa4
>> [ 2760.148941] [<ffffffc0004e6ef0>] __schedule+0x188/0x5b0
>> [ 2760.152309] [<ffffffc0004e7354>] schedule+0x3c/0xa0
>> [ 2760.155495] [<ffffffc0004e7768>] schedule_preempt_disabled+0x20/0x38
>> [ 2760.159423] [<ffffffc0004e8d28>] __mutex_lock_slowpath+0xc4/0x148
>> [ 2760.163217] [<ffffffc0004e8df0>] mutex_lock+0x44/0x5c
>> [ 2760.166483] [<ffffffc0003e87d4>] find_entity+0x2c/0xac
>> [ 2760.169773] [<ffffffc0003e8d34>] __media_device_enum_links+0x20/0x1dc
>> [ 2760.173711] [<ffffffc0003e9718>] media_device_ioctl+0x214/0x33c
>> [ 2760.177384] [<ffffffc0003e9eec>] media_ioctl+0x24/0x3c
>> [ 2760.180671] [<ffffffc0001bee64>] do_vfs_ioctl+0xac/0x758
>> [ 2760.184026] [<ffffffc0001bf594>] SyS_ioctl+0x84/0x98
>> [ 2760.187196] [<ffffffc000085d30>] el0_svc_naked+0x24/0x28
>>
>>
>> Laurent Pinchart (2):
>>   Revert "[media] media-device: use kref for media_device instance"
>
> This patch is unrelated with the above error report.
>
>>   Revert "[media] media-device: get rid of the spinlock"
>
> When Sakari proposed to replace the spin locks by a mutex, I was naive
> to expect that the MC won't be getting both spin_lock and mutex locks
> at the same time to protect the same memory, as it seems silly...
>
> Anyway, the fix for that is simple. I'm sending the patches in a few.
>
> On my test scenario, I'm using a 4 CPU i7core machine with 5
> endless loop processes running on it, being:
>
> 3 processes testing media-ctl -p, using this script:
>         https://mchehab.fedorapeople.org/mc_stress_test_scripts/mediactl-test-loop.sh
>
> 2 processes testing mc_nextgen_test, using this script:
>         https://mchehab.fedorapeople.org/mc_stress_test_scripts/mc-test-loop.sh
>
> I ran each loop for more than 10k interactions of media-ctl and about
> 20k interactions of mc_nextgen_test[1], and tested wit both uvcvideo
> and au0828+snd-usb-audio drivers.
>
> [1] It looks like getting the entire topology calling G_TOPOLOGY
> twice is two times faster than using the legacy ioctls (even
> retrieving more information - interfaces and interface links), with
> seems a good sign that the new API works better. The same behavior
> happened with both uvcvideo and au0828.
>
>
> Javier,
>
> Could you please test them with OMAP3?
>

I've tested on my OMAP3 IGEPv2 board by running concurrently 2
instances of your mc-test-loop.sh and mc-test-loop.sh scripts, and
also another 2 instances of a script [0] that called media-ctl -f -l
to stress the MEDIA_IOC_SETUP_LINK ioctl path since that is what
Laurent reported.

I waited until all the scripts had ~8K iterations and saw no issues
after your patches.

> Thanks,
> Mauro
>

[0]: http://hastebin.com/xaqasapifa.bash

Best regards,
Javier
