Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:40138 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeK3NdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 08:33:12 -0500
Received: by mail-lj1-f180.google.com with SMTP id n18-v6so3600392lji.7
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 18:25:31 -0800 (PST)
Date: Fri, 30 Nov 2018 03:25:29 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: Possible regression in v4l2-async
Message-ID: <20181130022529.GA30723@bigcity.dyn.berto.se>
References: <20181129184710.GA10382@bigcity.dyn.berto.se>
 <d2eb601a-80a8-41d5-ebd0-56159d339604@gmail.com>
 <880ff893-9e7a-6140-0261-4b8d88c69b5b@gmail.com>
 <20181129203752.lw6cy4gopxmoc7fe@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181129203752.lw6cy4gopxmoc7fe@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, Steve,

Thanks for your quick response.

On 2018-11-29 22:37:53 +0200, Sakari Ailus wrote:
> Hi Steve, Niklas,
> 
> On Thu, Nov 29, 2018 at 11:41:32AM -0800, Steve Longerbeam wrote:
> > 
> > 
> > On 11/29/18 11:26 AM, Steve Longerbeam wrote:
> > > Hi Niklas,
> > > 
> > > On 11/29/18 10:47 AM, Niklas Söderlund wrote:
> > > > Hi Steve, Sakari and Hans,
> > > > 
> > > > I have been made aware of a possible regression by a few users of
> > > > rcar-vin and I'm a bit puzzled how to best handle it. Maybe you can help
> > > > me out?
> > > > 
> > > > The issue is visible when running with LOCKDEP enabled and it prints a
> > > > warning about a possible circular locking dependency, see end of mail.
> > > > The warning is triggered because rcar-vin takes a mutex (group->lock) in
> > > > its async bound call back while the async framework already holds one
> > > > (lisk_lock).
> > > 
> > > I see two possible solutions to this:
> > > 
> > > A. Remove acquiring the list_lock in v4l2_async_notifier_init().
> > > 
> > > B. Move the call to v4l2_async_notifier_init()**to the top of
> > > rvin_mc_parse_of_graph() (before acquiring group->lock).
> > > 
> > > It's most likely safe to remove the list_lock from
> > > v4l2_async_notifier_init(), because all drivers should be calling that
> > > function at probe start, before it begins to add async subdev
> > > descriptors to their notifiers. But just the same, I think it would be
> > > safer to keep list_lock in v4l2_async_notifier_init(), just in case of
> > > some strange corner case (such as a driver that adds descriptors in a
> > > separate thread from the thread that calls v4l2_async_notifier_init()).
> > 
> > Well, on second thought that's probably a lame example, no driver should be
> > doing that. So removing the list_lock from v4l2_async_notifier_init() is
> > probably safe. The notifier is not registered with v4l2-async at that point.
> 
> I agree, apart from "probably". It is safe.
> 
> Niklas: would you like to send a patch? :-)

Thanks for your suggestions, I have sent a patch [1] for Steves 
alternative A as I agree that is the correct approach to cure the 
symptom of the problem and have value in its own right. Unfortunately 
this do not cover the core of the problem.

As I tried to describe in my first mail, maybe I could have described it 
better, sorry about that. This problem comes from the adding of 
subdevices to notifiers using a list instead of a array allocated and 
handled by the driver. Even with [1] applied a LOCKDEP warning is still 
trigged (see end of mail) as one thread could be busy adding subdevs to 
it's notifier using the fwnode helpers who take the list_lock as another 
thread is busy processing and binding subdevices also holding the 
list_lock. Then if a async callback implemented by a driver also takes a 
driver local lock the warning is still triggered as described in my 
first mail.

1. [PATCH] v4l2: async: remove locking when initializing async notifier

---->> warning output <<----
 ======================================================
 WARNING: possible circular locking dependency detected
 4.20.0-rc1-arm64-renesas-00141-gcadfba6a1339544c #58 Not tainted
 ------------------------------------------------------
 swapper/0/1 is trying to acquire lock:
 (____ptrval____) (&group->lock){+.+.}, at: rvin_group_notify_bound+0x30/0xa8
 
 but task is already holding lock:
 (____ptrval____) (list_lock){+.+.}, at: __v4l2_async_notifier_register+0x4c/0x140
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #1 (list_lock){+.+.}:
        __mutex_lock+0x70/0x7e0
        mutex_lock_nested+0x1c/0x28
        v4l2_async_notifier_add_subdev+0x2c/0x78
        __v4l2_async_notifier_parse_fwnode_ep+0x17c/0x310
        v4l2_async_notifier_parse_fwnode_endpoints_by_port+0x14/0x20
        rcar_vin_probe+0x174/0x638
        platform_drv_probe+0x50/0xa0
        really_probe+0x1c8/0x2a8
        driver_probe_device+0x54/0xe8
        __driver_attach+0xf0/0xf8
        bus_for_each_dev+0x70/0xc0
        driver_attach+0x20/0x28
        bus_add_driver+0x1d4/0x200
        driver_register+0x60/0x110
        __platform_driver_register+0x44/0x50
        rcar_vin_driver_init+0x18/0x20
        do_one_initcall+0x180/0x35c
        kernel_init_freeable+0x450/0x4f4
        kernel_init+0x10/0xfc
        ret_from_fork+0x10/0x1c
 
 -> #0 (&group->lock){+.+.}:
        lock_acquire+0xc8/0x238
        __mutex_lock+0x70/0x7e0
        mutex_lock_nested+0x1c/0x28
        rvin_group_notify_bound+0x30/0xa8
        v4l2_async_match_notify+0x50/0x138
        v4l2_async_notifier_try_all_subdevs+0x58/0xb8
        __v4l2_async_notifier_register+0xd0/0x140
        v4l2_async_notifier_register+0x38/0x58
        rcar_vin_probe+0x1c0/0x638
        platform_drv_probe+0x50/0xa0
        really_probe+0x1c8/0x2a8
        driver_probe_device+0x54/0xe8
        __driver_attach+0xf0/0xf8
        bus_for_each_dev+0x70/0xc0
        driver_attach+0x20/0x28
        bus_add_driver+0x1d4/0x200
        driver_register+0x60/0x110
        __platform_driver_register+0x44/0x50
        rcar_vin_driver_init+0x18/0x20
        do_one_initcall+0x180/0x35c
        kernel_init_freeable+0x450/0x4f4
        kernel_init+0x10/0xfc
        ret_from_fork+0x10/0x1c
 
 other info that might help us debug this:
 
  Possible unsafe locking scenario:
 
        CPU0                    CPU1
        ----                    ----
   lock(list_lock);
                                lock(&group->lock);
                                lock(list_lock);
   lock(&group->lock);
 
  *** DEADLOCK ***
 
 2 locks held by swapper/0/1:
  #0: (____ptrval____) (&dev->mutex){....}, at: __driver_attach+0x60/0xf8
  #1: (____ptrval____) (list_lock){+.+.}, at: __v4l2_async_notifier_register+0x4c/0x140
 
 stack backtrace:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.20.0-rc1-arm64-renesas-00141-gcadfba6a1339544c #58
 Hardware name: Renesas Salvator-X 2nd version board based on r8a77965 (DT)
 Call trace:
  dump_backtrace+0x0/0x188
  show_stack+0x14/0x20
  dump_stack+0xbc/0xf4
  print_circular_bug.isra.18+0x270/0x2d8
  __lock_acquire+0x12e8/0x1790
  lock_acquire+0xc8/0x238
  __mutex_lock+0x70/0x7e0
  mutex_lock_nested+0x1c/0x28
  rvin_group_notify_bound+0x30/0xa8
  v4l2_async_match_notify+0x50/0x138
  v4l2_async_notifier_try_all_subdevs+0x58/0xb8
  __v4l2_async_notifier_register+0xd0/0x140
  v4l2_async_notifier_register+0x38/0x58
  rcar_vin_probe+0x1c0/0x638
  platform_drv_probe+0x50/0xa0
  really_probe+0x1c8/0x2a8
  driver_probe_device+0x54/0xe8
  __driver_attach+0xf0/0xf8
  bus_for_each_dev+0x70/0xc0
  driver_attach+0x20/0x28
  bus_add_driver+0x1d4/0x200
  driver_register+0x60/0x110
  __platform_driver_register+0x44/0x50
  rcar_vin_driver_init+0x18/0x20
  do_one_initcall+0x180/0x35c
  kernel_init_freeable+0x450/0x4f4
  kernel_init+0x10/0xfc
  ret_from_fork+0x10/0x1c

-- 
Regards,
Niklas Söderlund
