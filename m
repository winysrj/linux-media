Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f180.google.com ([209.85.210.180]:44705 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbeK3GsI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 01:48:08 -0500
Subject: Re: Possible regression in v4l2-async
From: Steve Longerbeam <slongerbeam@gmail.com>
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
References: <20181129184710.GA10382@bigcity.dyn.berto.se>
 <d2eb601a-80a8-41d5-ebd0-56159d339604@gmail.com>
Message-ID: <880ff893-9e7a-6140-0261-4b8d88c69b5b@gmail.com>
Date: Thu, 29 Nov 2018 11:41:32 -0800
MIME-Version: 1.0
In-Reply-To: <d2eb601a-80a8-41d5-ebd0-56159d339604@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/29/18 11:26 AM, Steve Longerbeam wrote:
> Hi Niklas,
>
> On 11/29/18 10:47 AM, Niklas Söderlund wrote:
>> Hi Steve, Sakari and Hans,
>>
>> I have been made aware of a possible regression by a few users of
>> rcar-vin and I'm a bit puzzled how to best handle it. Maybe you can help
>> me out?
>>
>> The issue is visible when running with LOCKDEP enabled and it prints a
>> warning about a possible circular locking dependency, see end of mail.
>> The warning is triggered because rcar-vin takes a mutex (group->lock) in
>> its async bound call back while the async framework already holds one
>> (lisk_lock).
>
> I see two possible solutions to this:
>
> A. Remove acquiring the list_lock in v4l2_async_notifier_init().
>
> B. Move the call to v4l2_async_notifier_init()**to the top of 
> rvin_mc_parse_of_graph() (before acquiring group->lock).
>
> It's most likely safe to remove the list_lock from 
> v4l2_async_notifier_init(), because all drivers should be calling that 
> function at probe start, before it begins to add async subdev 
> descriptors to their notifiers. But just the same, I think it would be 
> safer to keep list_lock in v4l2_async_notifier_init(), just in case of 
> some strange corner case (such as a driver that adds descriptors in a 
> separate thread from the thread that calls v4l2_async_notifier_init()).

Well, on second thought that's probably a lame example, no driver should 
be doing that. So removing the list_lock from v4l2_async_notifier_init() 
is probably safe. The notifier is not registered with v4l2-async at that 
point.

Steve

>
> So I would prefer B, but I'm open to either solution.
>
> **
>>
>> I traced the issue back to [1]. I don't believe this is any real trouble
>> here unless any of the async callbacks where to call into the async
>> framework themself which would trigger further calls to driver
>> callbacks, or maybe I'm naive and this is a real problem today.
>>
>> Even if it's no real problem today I'm not sure this is never going to
>> be a problem, it would be nice if this warning could be handled somehow.
>> It is my understanding that any implementation of the async callbacks
>> who take a driver specific lock would trigger this warning which is not
>> nice.
>
> It has always been the case that v4l2-async holds the list_lock when 
> it calls a driver's async bound callback.
>
> So the problem is only that v4l2_async_notifier_init() acquires the 
> list_lock, which can create the reverse lock order 
> driver-specific-lock -> list_lock. Which is solved by either A or B 
> above.
>
> Steve
>
>> Any suggestions or hints on how to move forward with this would be
>> appreciated.
>>
>> 1. eae2aed1eab9bf08 ("media: v4l2-fwnode: Switch to 
>> v4l2_async_notifier_add_subdev")
>>
>> ---->> Warning output <<----
>>
>>   ======================================================
>>   WARNING: possible circular locking dependency detected
>>   4.19.0-rc1-arm64-renesas-00212-geae2aed1eab9bf08 #56 Not tainted
>>   ------------------------------------------------------
>>   swapper/0/1 is trying to acquire lock:
>>   (____ptrval____) (&group->lock){+.+.}, at: 
>> rvin_group_notify_bound+0x30/0xa8
>>
>>   but task is already holding lock:
>>   (____ptrval____) (list_lock){+.+.}, at: 
>> __v4l2_async_notifier_register+0x54/0x1b0
>>
>>   which lock already depends on the new lock.
>>
>>
>>   the existing dependency chain (in reverse order) is:
>>
>>   -> #1 (list_lock){+.+.}:
>>          __mutex_lock+0x70/0x7f0
>>          mutex_lock_nested+0x1c/0x28
>>          v4l2_async_notifier_init+0x28/0x48
>>          rcar_vin_probe+0x13c/0x630
>>          platform_drv_probe+0x50/0xa0
>>          really_probe+0x1e0/0x298
>>          driver_probe_device+0x54/0xe8
>>          __driver_attach+0xf0/0xf8
>>          bus_for_each_dev+0x70/0xc0
>>          driver_attach+0x20/0x28
>>          bus_add_driver+0x1d4/0x200
>>          driver_register+0x60/0x110
>>          __platform_driver_register+0x44/0x50
>>          rcar_vin_driver_init+0x18/0x20
>>          do_one_initcall+0x180/0x35c
>>          kernel_init_freeable+0x454/0x4f8
>>          kernel_init+0x10/0xfc
>>          ret_from_fork+0x10/0x1c
>>
>>   -> #0 (&group->lock){+.+.}:
>>          lock_acquire+0xc8/0x238
>>          __mutex_lock+0x70/0x7f0
>>          mutex_lock_nested+0x1c/0x28
>>          rvin_group_notify_bound+0x30/0xa8
>>          v4l2_async_match_notify+0x50/0x138
>>          v4l2_async_notifier_try_all_subdevs+0x58/0xb8
>>          __v4l2_async_notifier_register+0xdc/0x1b0
>>          v4l2_async_notifier_register+0x38/0x58
>>          rcar_vin_probe+0x1b8/0x630
>>          platform_drv_probe+0x50/0xa0
>>          really_probe+0x1e0/0x298
>>          driver_probe_device+0x54/0xe8
>>          __driver_attach+0xf0/0xf8
>>          bus_for_each_dev+0x70/0xc0
>>          driver_attach+0x20/0x28
>>          bus_add_driver+0x1d4/0x200
>>          driver_register+0x60/0x110
>>          __platform_driver_register+0x44/0x50
>>          rcar_vin_driver_init+0x18/0x20
>>          do_one_initcall+0x180/0x35c
>>          kernel_init_freeable+0x454/0x4f8
>>          kernel_init+0x10/0xfc
>>          ret_from_fork+0x10/0x1c
>>
>>   other info that might help us debug this:
>>
>>    Possible unsafe locking scenario:
>>
>>          CPU0                    CPU1
>>          ----                    ----
>>     lock(list_lock);
>>                                  lock(&group->lock);
>>                                  lock(list_lock);
>>     lock(&group->lock);
>>
>>    *** DEADLOCK ***
>>
>>   2 locks held by swapper/0/1:
>>    #0: (____ptrval____) (&dev->mutex){....}, at: 
>> __driver_attach+0x60/0xf8
>>    #1: (____ptrval____) (list_lock){+.+.}, at: 
>> __v4l2_async_notifier_register+0x54/0x1b0
>>
>>   stack backtrace:
>>   CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
>> 4.19.0-rc1-arm64-renesas-00212-geae2aed1eab9bf08 #56
>>   Hardware name: Renesas Salvator-X 2nd version board based on 
>> r8a77965 (DT)
>>   Call trace:
>>    dump_backtrace+0x0/0x188
>>    show_stack+0x14/0x20
>>    dump_stack+0xbc/0xf4
>>    print_circular_bug.isra.18+0x270/0x2d8
>>    __lock_acquire+0x12e8/0x17c8
>>    lock_acquire+0xc8/0x238
>>    __mutex_lock+0x70/0x7f0
>>    mutex_lock_nested+0x1c/0x28
>>    rvin_group_notify_bound+0x30/0xa8
>>    v4l2_async_match_notify+0x50/0x138
>>    v4l2_async_notifier_try_all_subdevs+0x58/0xb8
>>    __v4l2_async_notifier_register+0xdc/0x1b0
>>    v4l2_async_notifier_register+0x38/0x58
>>    rcar_vin_probe+0x1b8/0x630
>>    platform_drv_probe+0x50/0xa0
>>    really_probe+0x1e0/0x298
>>    driver_probe_device+0x54/0xe8
>>    __driver_attach+0xf0/0xf8
>>    bus_for_each_dev+0x70/0xc0
>>    driver_attach+0x20/0x28
>>    bus_add_driver+0x1d4/0x200
>>    driver_register+0x60/0x110
>>    __platform_driver_register+0x44/0x50
>>    rcar_vin_driver_init+0x18/0x20
>>    do_one_initcall+0x180/0x35c
>>    kernel_init_freeable+0x454/0x4f8
>>    kernel_init+0x10/0xfc
>>    ret_from_fork+0x10/0x1c
>>
>>
>
