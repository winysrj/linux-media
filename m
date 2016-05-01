Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48399 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbcEAQni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 May 2016 12:43:38 -0400
Subject: Re: 4.6 regression: deadlock in exynos fimc_md_probe()
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <57262BAD.2020704@xs4all.nl> <572631F8.1020705@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57263234.1060400@xs4all.nl>
Date: Sun, 1 May 2016 18:43:32 +0200
MIME-Version: 1.0
In-Reply-To: <572631F8.1020705@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/01/2016 06:42 PM, Hans Verkuil wrote:
> I'm adding Sakari since this problem was introduced in his commit 0c426c472b5585ed6e59160359c979506d45ae49:
> "media: Always keep a graph walk large enough around".

And now adding linux-media as well. Sorry about that.

	Hans

> 
> Regards,
> 
> 	Hans
> 
> On 05/01/2016 06:15 PM, Hans Verkuil wrote:
>> Hi Mauro,
>>
>> While testing an unrelated patch series for the exynos4 using kernel 4.6 I
>> came across this deadlock that caused the boot sequence to hang (I'm using
>> an exynos4 Odroid U3):
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 4.6.0-rc5-odroid #987 Not tainted
>> ---------------------------------------------
>> swapper/0/1 is trying to acquire lock:
>>  (&mdev->graph_mutex){+.+.+.}, at: [<c05d96d4>] media_device_register_entity+0x78/0x1e8
>>
>> but task is already holding lock:
>>  (&mdev->graph_mutex){+.+.+.}, at: [<c060cec8>] fimc_md_probe+0x22c/0xac0
>>
>> other info that might help us debug this:
>>  Possible unsafe locking scenario:
>>
>>        CPU0
>>        ----
>>   lock(&mdev->graph_mutex);
>>   lock(&mdev->graph_mutex);
>>
>>  *** DEADLOCK ***
>>
>>  May be due to missing lock nesting notation
>>
>> 4 locks held by swapper/0/1:
>>  #0:  (&dev->mutex){......}, at: [<c04aed50>] __driver_attach+0x58/0xcc
>>  #1:  (&dev->mutex){......}, at: [<c04aed60>] __driver_attach+0x68/0xcc
>>  #2:  (&mdev->graph_mutex){+.+.+.}, at: [<c060cec8>] fimc_md_probe+0x22c/0xac0
>>  #3:  (&dev->mutex){......}, at: [<c060cf98>] fimc_md_probe+0x2fc/0xac0
>>
>> stack backtrace:
>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.6.0-rc5-odroid #987
>> Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
>> Backtrace:
>> [<c010bd94>] (dump_backtrace) from [<c010bf90>] (show_stack+0x18/0x1c)
>>  r7:c0d1c9a4 r6:c0d1c9a4 r5:200001d3 r4:00000000
>> [<c010bf78>] (show_stack) from [<c03e65dc>] (dump_stack+0xb0/0xdc)
>> [<c03e652c>] (dump_stack) from [<c016c854>] (__lock_acquire+0x19bc/0x1dcc)
>>  r9:ee880000 r8:c1516a7c r7:c14dc9ec r6:c0e99058 r5:c0e99058 r4:c0e99058
>> [<c016ae98>] (__lock_acquire) from [<c016d518>] (lock_acquire+0x78/0x98)
>>  r10:eefad144 r9:eea95044 r8:ee880000 r7:00000001 r6:00000000 r5:60000153
>>  r4:00000000
>> [<c016d4a0>] (lock_acquire) from [<c089bd74>] (mutex_lock_nested+0x70/0x4c0)
>>  r7:c14dc9ec r6:c05d96d4 r5:00000000 r4:ee2bdcac
>> [<c089bd04>] (mutex_lock_nested) from [<c05d96d4>] (media_device_register_entity+0x78/0x1e8)
>>  r10:eefad144 r9:eea95044 r8:ee2bdc44 r7:ee2bdcac r6:ee2bd910 r5:00000000
>>  r4:ee30d4d0
>> [<c05d965c>] (media_device_register_entity) from [<c05e3ed8>] (v4l2_device_register_subdev+0xa4/0x174)
>>  r8:ee30d010 r7:eefad4ac r6:00000000 r5:ee2bdd90 r4:ee30d4d0
>> [<c05e3e34>] (v4l2_device_register_subdev) from [<c060d1e0>] (fimc_md_probe+0x544/0xac0)
>>  r7:eefad4ac r6:eea95000 r5:ee30d4d0 r4:ee2bd810
>> [<c060cc9c>] (fimc_md_probe) from [<c04b06bc>] (platform_drv_probe+0x54/0xb8)
>>  r10:00000116 r9:00000000 r8:c0d36da4 r7:fffffdfb r6:c0d36da4 r5:eea94c10
>>  r4:eea94c10
>> [<c04b0668>] (platform_drv_probe) from [<c04aec4c>] (driver_probe_device+0x21c/0x2c8)
>>  r7:00000000 r6:c151c298 r5:c151c290 r4:eea94c10
>> [<c04aea30>] (driver_probe_device) from [<c04aedc0>] (__driver_attach+0xc8/0xcc)
>>  r9:c0d52000 r8:00000000 r7:00000000 r6:eea94c44 r5:c0d36da4 r4:eea94c10
>> [<c04aecf8>] (__driver_attach) from [<c04acd04>] (bus_for_each_dev+0x70/0xa4)
>>  r7:00000000 r6:c04aecf8 r5:c0d36da4 r4:00000000
>> [<c04acc94>] (bus_for_each_dev) from [<c04ae43c>] (driver_attach+0x24/0x28)
>>  r6:c0d26af8 r5:eea76c80 r4:c0d36da4
>> [<c04ae418>] (driver_attach) from [<c04adfd8>] (bus_add_driver+0x1a8/0x220)
>> [<c04ade30>] (bus_add_driver) from [<c04af560>] (driver_register+0x80/0x100)
>>  r7:edd74d80 r6:c0d05a90 r5:c0c1c83c r4:c0d36da4
>> [<c04af4e0>] (driver_register) from [<c04b061c>] (__platform_driver_register+0x48/0x50)
>>  r5:c0c1c83c r4:c0d05a90
>> [<c04b05d4>] (__platform_driver_register) from [<c0c1c870>] (fimc_md_init+0x34/0x40)
>> [<c0c1c83c>] (fimc_md_init) from [<c0101898>] (do_one_initcall+0x98/0x1e4)
>> [<c0101800>] (do_one_initcall) from [<c0c00e34>] (kernel_init_freeable+0x164/0x208)
>>  r8:00000006 r7:c0c34858 r6:c0c00608 r5:c0c34850 r4:c0d52000
>> [<c0c00cd0>] (kernel_init_freeable) from [<c0899c84>] (kernel_init+0x10/0x11c)
>>  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0899c74
>>  r4:00000000
>> [<c0899c74>] (kernel_init) from [<c0107cf0>] (ret_from_fork+0x14/0x24)
>>  r5:c0899c74 r4:00000000
>>
>> Commenting out 'mutex_lock(&fmd->media_dev.graph_mutex);' in fimc_md_probe()
>> makes it boot again, but I'm not 100% certain that's correct.
>>
>> Can you take a look?
>>
>> Thanks!
>>
>> 	Hans
>>
