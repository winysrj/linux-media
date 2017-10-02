Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37088 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750878AbdJBL6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Oct 2017 07:58:15 -0400
Subject: Re: [PATCH v14 07/28] rcar-vin: Use generic parser for parsing fwnode
 endpoints
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-8-sakari.ailus@linux.intel.com>
 <20170930131709.GP17182@bigcity.dyn.berto.se>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <3f940721-f190-4662-cfda-d99a0d97bf08@linux.intel.com>
Date: Mon, 2 Oct 2017 14:58:10 +0300
MIME-Version: 1.0
In-Reply-To: <20170930131709.GP17182@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 09/30/17 16:17, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for your patch, I like it. Unfortunately it causes issues :-(
> 
> I picked the first 7 patches of this series on top of media-next and it 
> produce problems when tested on Koelsch with CONFIG_OF_DYNAMIC=y.
> 
> 1. It print's 'OF: ERROR: Bad of_node_put() on /video@e6ef0000/port' 
>    messages during boot.

Do you have your own patch to fix fwnode_graph_get_port_parent()
applied? I noticed it doesn't seem to be in Rob's tree; let's continue
in the other thread.

<URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg117450.html>

> 
>    OF: ERROR: Bad of_node_put() on /video@e6ef0000/port
>    CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.13.0-rc4-00632-gfae12f9c98a8c567 #7
>    Hardware name: Generic R8A7791 (Flattened Device Tree)
>    Backtrace: 
>    [<c010b16c>] (dump_backtrace) from [<c010b3b8>] (show_stack+0x18/0x1c)
>     r7:00000001 r6:60000013 r5:00000000 r4:c0a7c88c
>    [<c010b3a0>] (show_stack) from [<c06d9034>] (dump_stack+0x84/0xa0)
>    [<c06d8fb0>] (dump_stack) from [<c05814ac>] (of_node_release+0x2c/0x94)
>     r7:00000001 r6:c0a6fc4c r5:eb1284c0 r4:eb7c7a00
>    [<c0581480>] (of_node_release) from [<c06dcd3c>] (kobject_put+0xbc/0xdc)
>     r7:00000001 r6:c0a6fc4c r5:eb1284c0 r4:eb7c7a00
>    [<c06dcc80>] (kobject_put) from [<c0580d48>] (of_node_put+0x1c/0x20)
>     r6:eb7c7af8 r5:eb7c79e0 r4:eb7c7798
>    [<c0580d2c>] (of_node_put) from [<c057fc18>] (of_fwnode_put+0x38/0x44)
>    [<c057fbe0>] (of_fwnode_put) from [<c04244a8>] (fwnode_handle_put+0x30/0x34)
>    [<c0424478>] (fwnode_handle_put) from [<c0424714>] (fwnode_graph_get_port_parent+0x44/0x4c)
>    [<c04246d0>] (fwnode_graph_get_port_parent) from [<c0514820>] (__v4l2_async_notifier_parse_fwnode_endpoints+0x1dc/0x2d8)
>     r5:eaa56bd8 r4:00000000
>    [<c0514644>] (__v4l2_async_notifier_parse_fwnode_endpoints) from [<c0514a9c>] (v4l2_async_notifier_parse_fwnode_endpoints+0x20/0x28)
>     r10:00000000 r9:eaa56bd8 r8:c0a6c504 r7:eb251a10 r6:eb251a00 r5:00000000
>     r4:eaa56810
>    [<c0514a7c>] (v4l2_async_notifier_parse_fwnode_endpoints) from [<c05433b8>] (rcar_vin_probe+0xcc/0x178)
>    [<c05432ec>] (rcar_vin_probe) from [<c0420a3c>] (platform_drv_probe+0x58/0xa4)
>     r9:00000000 r8:c0a6c504 r7:00000000 r6:c0a6c504 r5:eb251a10 r4:c05432ec
>    [<c04209e4>] (platform_drv_probe) from [<c041f320>] (driver_probe_device+0x210/0x2d8)
>     r7:00000000 r6:c0ac72d4 r5:c0ac72c8 r4:eb251a10
>    [<c041f110>] (driver_probe_device) from [<c041f46c>] (__driver_attach+0x84/0xb0)
>     r10:00000000 r9:c096d224 r8:00000000 r7:c0a50cf0 r6:c0a6c504 r5:eb251a44
>     r4:eb251a10 r3:00000000
>    [<c041f3e8>] (__driver_attach) from [<c041da08>] (bus_for_each_dev+0x88/0x98)
>     r7:c0a50cf0 r6:c041f3e8 r5:c0a6c504 r4:00000000
>    [<c041d980>] (bus_for_each_dev) from [<c041f5bc>] (driver_attach+0x20/0x28)
>     r6:00000000 r5:eaa55f80 r4:c0a6c504
>    [<c041f59c>] (driver_attach) from [<c041e190>] (bus_add_driver+0x170/0x1e0)
>    [<c041e020>] (bus_add_driver) from [<c0420068>] (driver_register+0xa8/0xe8)
>     r7:c095883c r6:000000cb r5:ffffe000 r4:c0a6c504
>    [<c041ffc0>] (driver_register) from [<c04214b0>] (__platform_driver_register+0x38/0x4c)
>     r5:ffffe000 r4:c0935328
>    [<c0421478>] (__platform_driver_register) from [<c0935340>] (rcar_vin_driver_init+0x18/0x20)
>    [<c0935328>] (rcar_vin_driver_init) from [<c0900ecc>] (do_one_initcall+0x12c/0x154)
>    [<c0900da0>] (do_one_initcall) from [<c0901080>] (kernel_init_freeable+0x18c/0x1d0)
>     r8:c0a8a700 r7:c095883c r6:000000cb r5:c0a8a700 r4:00000007
>    [<c0900ef4>] (kernel_init_freeable) from [<c06eac64>] (kernel_init+0x10/0x110)
>     r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c06eac54 r4:00000000
>    [<c06eac54>] (kernel_init) from [<c0106db8>] (ret_from_fork+0x14/0x3c)
>     r5:c06eac54 r4:00000000
> 
> 2. It then proceeds to OOPS.
> 
>    Unable to handle kernel NULL pointer dereference at virtual address 0000000c
>    pgd = c0004000
>    [0000000c] *pgd=00000000
>    Internal error: Oops: 5 [#1] SMP ARM
>    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.13.0-rc4-00632-gfae12f9c98a8c567 #7
>    Hardware name: Generic R8A7791 (Flattened Device Tree)
>    task: eb09b840 task.stack: eb09c000
>    PC is at rvin_v4l2_probe+0x38/0x1ec
>    LR is at rvin_digital_notify_complete+0x10c/0x11c
>    pc : [<c054594c>]    lr : [<c0543614>]    psr: a0000013
>    sp : eb09dcf8  ip : eb09dd20  fp : eb09dd1c
>    r10: 00000000  r9 : eaa56bd8  r8 : 00002006
>    r7 : eaa56810  r6 : c0a1e6dc  r5 : 00000000  r4 : eaa56810
>    r3 : 00000000  r2 : 00000001  r1 : eaa57ec0  r0 : eaa56810
>    Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>    Control: 10c5387d  Table: 4000406a  DAC: 00000051
>    Process swapper/0 (pid: 1, stack limit = 0xeb09c210)
>    Stack: (0xeb09dcf8 to 0xeb09e000)
>    dce0:                                                       ea9e2868 eb1284c0
>    dd00: eaa56bd8 00000000 eb1284c0 eaa56810 eb09dd74 eb09dd20 c0543614 c0545920
>    dd20: 00000001 00000001 0000100a 00000001 00000000 00000000 00000000 00000000
>    dd40: 00000000 00000000 00000000 00000000 c051c17c eaa56bd8 c0543508 ea9e2868
>    dd60: eb1284c0 c0a5ff2c eb09dd94 eb09dd78 c0525164 c0543514 eaa56bd8 c0a5ff18
>    dd80: ea9e2868 eb3cda50 eb09ddbc eb09dd98 c0525288 c0525088 eaa56810 00000000
>    dda0: eb251a00 eb251a10 00000000 eaa56bd8 eb09dde4 eb09ddc0 c05433f0 c0525178
>    ddc0: c05432ec eb251a10 c0a6c504 00000000 c0a6c504 00000000 eb09de04 eb09dde8
>    dde0: c0420a3c c05432f8 eb251a10 c0ac72c8 c0ac72d4 00000000 eb09de34 eb09de08
>    de00: c041f320 c04209f0 00000000 eb251a10 eb251a44 c0a6c504 c0a50cf0 00000000
>    de20: c096d224 00000000 eb09de54 eb09de38 c041f46c c041f11c 00000000 c0a6c504
>    de40: c041f3e8 c0a50cf0 eb09de7c eb09de58 c041da08 c041f3f4 eb0eff58 eb2259b4
>    de60: eb0eff6c c0a6c504 eaa55f80 00000000 eb09de8c eb09de80 c041f5bc c041d98c
>    de80: eb09deb4 eb09de90 c041e190 c041f5a8 c0890798 eb09dea0 c0a6c504 ffffe000
>    dea0: 000000cb c095883c eb09decc eb09deb8 c0420068 c041e02c c0935328 ffffe000
>    dec0: eb09dedc eb09ded0 c04214b0 c041ffcc eb09deec eb09dee0 c0935340 c0421484
>    dee0: eb09df5c eb09def0 c0900ecc c0935334 00000000 c08b0334 eb09df00 eb09df08
>    df00: c013baa8 c09006a4 c010bf8c c08b0348 000000ca c08b0348 00000006 00000006
>    df20: 000000cb c08af36c ebfffca1 ebfffca4 c0a8a700 00000007 c0a8a700 00000007
>    df40: c0a8a700 000000cb c095883c c0a8a700 eb09df94 eb09df60 c0901080 c0900dac
>    df60: 00000006 00000006 00000000 c0900698 00000000 c06eac54 00000000 00000000
>    df80: 00000000 00000000 eb09dfac eb09df98 c06eac64 c0900f00 00000000 c06eac54
>    dfa0: 00000000 eb09dfb0 c0106db8 c06eac60 00000000 00000000 00000000 00000000
>    dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>    dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 420113b0 60d05413
>    Backtrace: 
>    [<c0545914>] (rvin_v4l2_probe) from [<c0543614>] (rvin_digital_notify_complete+0x10c/0x11c)
>     r7:eaa56810 r6:eb1284c0 r5:00000000 r4:eaa56bd8
>    [<c0543508>] (rvin_digital_notify_complete) from [<c0525164>] 
>    (v4l2_async_match_notify+0xe8/0xf0)
>     r8:c0a5ff2c r7:eb1284c0 r6:ea9e2868 r5:c0543508 r4:eaa56bd8

Could fixing the other issue fix this one as well?

I'll see how the rest works at my end with CONFIG_OF_DYNAMIC enabled.

>    [<c052507c>] (v4l2_async_match_notify) from [<c0525288>] (v4l2_async_notifier_register+0x11c/0x150)
>     r7:eb3cda50 r6:ea9e2868 r5:c0a5ff18 r4:eaa56bd8
>    [<c052516c>] (v4l2_async_notifier_register) from [<c05433f0>] (rcar_vin_probe+0x104/0x178)
>     r9:eaa56bd8 r8:00000000 r7:eb251a10 r6:eb251a00 r5:00000000 r4:eaa56810
>    [<c05432ec>] (rcar_vin_probe) from [<c0420a3c>] 
>    (platform_drv_probe+0x58/0xa4)
>     r9:00000000 r8:c0a6c504 r7:00000000 r6:c0a6c504 r5:eb251a10 r4:c05432ec
>    [<c04209e4>] (platform_drv_probe) from [<c041f320>] (driver_probe_device+0x210/0x2d8)
>     r7:00000000 r6:c0ac72d4 r5:c0ac72c8 r4:eb251a10
>    [<c041f110>] (driver_probe_device) from [<c041f46c>] (__driver_attach+0x84/0xb0)
>     r10:00000000 r9:c096d224 r8:00000000 r7:c0a50cf0 r6:c0a6c504 r5:eb251a44
>     r4:eb251a10 r3:00000000
>    [<c041f3e8>] (__driver_attach) from [<c041da08>] (bus_for_each_dev+0x88/0x98)
>     r7:c0a50cf0 r6:c041f3e8 r5:c0a6c504 r4:00000000
>    [<c041d980>] (bus_for_each_dev) from [<c041f5bc>] (driver_attach+0x20/0x28)
>     r6:00000000 r5:eaa55f80 r4:c0a6c504
>    [<c041f59c>] (driver_attach) from [<c041e190>] (bus_add_driver+0x170/0x1e0)
>    [<c041e020>] (bus_add_driver) from [<c0420068>] (driver_register+0xa8/0xe8)
>     r7:c095883c r6:000000cb r5:ffffe000 r4:c0a6c504
>    [<c041ffc0>] (driver_register) from [<c04214b0>] (__platform_driver_register+0x38/0x4c)
>     r5:ffffe000 r4:c0935328
>    [<c0421478>] (__platform_driver_register) from [<c0935340>] (rcar_vin_driver_init+0x18/0x20)
>    [<c0935328>] (rcar_vin_driver_init) from [<c0900ecc>] (do_one_initcall+0x12c/0x154)
>    [<c0900da0>] (do_one_initcall) from [<c0901080>] (kernel_init_freeable+0x18c/0x1d0)
>     r8:c0a8a700 r7:c095883c r6:000000cb r5:c0a8a700 r4:00000007
>    [<c0900ef4>] (kernel_init_freeable) from [<c06eac64>] (kernel_init+0x10/0x110)
>     r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c06eac54 r4:00000000
>    [<c06eac54>] (kernel_init) from [<c0106db8>] (ret_from_fork+0x14/0x3c)
>     r5:c06eac54 r4:00000000
>    Code: 03e05012 e5803368 0a00000a e5963068 (e593300c) 
>    ---[ end trace 82aa2a1c6173a5f6 ]---
> 
> 
> Oddly enough setting CONFIG_OF_DYNAMIC=n or applying the patch
> '[PATCH v2] device property: preserve usecount for node passed to 
> of_fwnode_graph_get_port_parent()' fixes _both_ issues. It obviously 
> would fix the 'Bad of_node_put() on ...' messages that it also fixes the 
> OOPS is strange, so I did some digging.
> 
> The problem is introduced when rcar-vin in its complete callback calls 
> v4l2_device_register_subdev_nodes(). Before the call 
> vin->digital->subdev pointer is correct but after the call the 
> vin->digital->subdev pointer is changed to a for me random value. And 
> this is what is causing the OOPS in rvin_v4l2_probe() once it tries to 
> operate on the subdevice using v4l2_subdev_call() using this bad 
> pointer.
> 
> I tried to track down the issue but I can't understand what is causing 
> it, but I managed to narrow it down. The callchain is:
> 
> - rvin_digital_notify_complete
>   - pr_dbg("sd: %p\n", vin->digital->subdev); # prints good pointer
>   - v4l2_device_register_subdev_nodes()
>     - __video_register_device()
>       - cdev_alloc()         # Here the pointer gets corrupted
>   - pr_dbg("sd: %p\n", vin->digital->subdev); # prints bad pointer
> 
> I can't figure out why cdev_alloc() would corrupt it. I can even corrupt 
> the pointer by calling cdev_alloc() directly from the rcar-vin driver 
> itself. I added to following to the top  of the complete callback before 
> v4l2_device_register_subdev_nodes() is called.
> 
>   pr_err("digital: %p sd: %p\n", vin->digital, vin->digital->subdev);
>   cdev_alloc();
>   pr_err("digital: %p sd: %p\n", vin->digital, vin->digital->subdev);
> 
> And the result is:
> 
> [    2.865306] digital: eb1284c0 sd: ea953068
> [    2.869414] digital: eb1284c0 sd: c0a1e6dc
> 
> If I set CONFIG_OF_DYNAMIC=n or apply the patch above the result is OK, 
> 
> [    1.961142] digital: ea8f8cc0 sd: ea8bac50
> [    1.965240] digital: ea8f8cc0 sd: ea8bac50
> 
> I can capture without issues so this patch in it self is good I think.  
> So please add
> 
> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se> 
> 
> However I would like the issue that is revealed by this patch to be 
> sorted out before this patch is picked up as it causes problems with 
> CONFIG_OF_DYNAMIC=y which is enabled by using the shmobile_defconfig.
> 
> On 2017-09-26 01:25:18 +0300, Sakari Ailus wrote:
>> Instead of using a custom driver implementation, use
>> v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoints
>> of the device.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/platform/rcar-vin/rcar-core.c | 107 +++++++++-------------------
>>  drivers/media/platform/rcar-vin/rcar-dma.c  |  10 +--
>>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  14 ++--
>>  drivers/media/platform/rcar-vin/rcar-vin.h  |   4 +-
>>  4 files changed, 46 insertions(+), 89 deletions(-)
>>
>> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
>> index 142de447aaaa..380288658601 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/pm_runtime.h>
>>  
>> +#include <media/v4l2-async.h>
>>  #include <media/v4l2-fwnode.h>
>>  
>>  #include "rcar-vin.h"
>> @@ -77,14 +78,14 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
>>  	int ret;
>>  
>>  	/* Verify subdevices mbus format */
>> -	if (!rvin_mbus_supported(&vin->digital)) {
>> +	if (!rvin_mbus_supported(vin->digital)) {
>>  		vin_err(vin, "Unsupported media bus format for %s\n",
>> -			vin->digital.subdev->name);
>> +			vin->digital->subdev->name);
>>  		return -EINVAL;
>>  	}
>>  
>>  	vin_dbg(vin, "Found media bus format for %s: %d\n",
>> -		vin->digital.subdev->name, vin->digital.code);
>> +		vin->digital->subdev->name, vin->digital->code);
>>  
>>  	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
>>  	if (ret < 0) {
>> @@ -103,7 +104,7 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
>>  
>>  	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
>>  	rvin_v4l2_remove(vin);
>> -	vin->digital.subdev = NULL;
>> +	vin->digital->subdev = NULL;
>>  }
>>  
>>  static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>> @@ -120,117 +121,71 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
>>  	if (ret < 0)
>>  		return ret;
>> -	vin->digital.source_pad = ret;
>> +	vin->digital->source_pad = ret;
>>  
>>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
>> -	vin->digital.sink_pad = ret < 0 ? 0 : ret;
>> +	vin->digital->sink_pad = ret < 0 ? 0 : ret;
>>  
>> -	vin->digital.subdev = subdev;
>> +	vin->digital->subdev = subdev;
>>  
>>  	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
>> -		subdev->name, vin->digital.source_pad,
>> -		vin->digital.sink_pad);
>> +		subdev->name, vin->digital->source_pad,
>> +		vin->digital->sink_pad);
>>  
>>  	return 0;
>>  }
>>  
>> -static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
>> -				    struct device_node *ep,
>> -				    struct v4l2_mbus_config *mbus_cfg)
>> +static int rvin_digital_parse_v4l2(struct device *dev,
>> +				   struct v4l2_fwnode_endpoint *vep,
>> +				   struct v4l2_async_subdev *asd)
>>  {
>> -	struct v4l2_fwnode_endpoint v4l2_ep;
>> -	int ret;
>> +	struct rvin_dev *vin = dev_get_drvdata(dev);
>> +	struct rvin_graph_entity *rvge =
>> +		container_of(asd, struct rvin_graph_entity, asd);
>>  
>> -	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
>> -	if (ret) {
>> -		vin_err(vin, "Could not parse v4l2 endpoint\n");
>> -		return -EINVAL;
>> -	}
>> +	if (vep->base.port || vep->base.id)
>> +		return -ENOTCONN;
>>  
>> -	mbus_cfg->type = v4l2_ep.bus_type;
>> +	rvge->mbus_cfg.type = vep->bus_type;
>>  
>> -	switch (mbus_cfg->type) {
>> +	switch (rvge->mbus_cfg.type) {
>>  	case V4L2_MBUS_PARALLEL:
>>  		vin_dbg(vin, "Found PARALLEL media bus\n");
>> -		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
>> +		rvge->mbus_cfg.flags = vep->bus.parallel.flags;
>>  		break;
>>  	case V4L2_MBUS_BT656:
>>  		vin_dbg(vin, "Found BT656 media bus\n");
>> -		mbus_cfg->flags = 0;
>> +		rvge->mbus_cfg.flags = 0;
>>  		break;
>>  	default:
>>  		vin_err(vin, "Unknown media bus type\n");
>>  		return -EINVAL;
>>  	}
>>  
>> -	return 0;
>> -}
>> -
>> -static int rvin_digital_graph_parse(struct rvin_dev *vin)
>> -{
>> -	struct device_node *ep, *np;
>> -	int ret;
>> -
>> -	vin->digital.asd.match.fwnode.fwnode = NULL;
>> -	vin->digital.subdev = NULL;
>> -
>> -	/*
>> -	 * Port 0 id 0 is local digital input, try to get it.
>> -	 * Not all instances can or will have this, that is OK
>> -	 */
>> -	ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 0, 0);
>> -	if (!ep)
>> -		return 0;
>> -
>> -	np = of_graph_get_remote_port_parent(ep);
>> -	if (!np) {
>> -		vin_err(vin, "No remote parent for digital input\n");
>> -		of_node_put(ep);
>> -		return -EINVAL;
>> -	}
>> -	of_node_put(np);
>> -
>> -	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->digital.mbus_cfg);
>> -	of_node_put(ep);
>> -	if (ret)
>> -		return ret;
>> -
>> -	vin->digital.asd.match.fwnode.fwnode = of_fwnode_handle(np);
>> -	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
>> +	vin->digital = rvge;
>>  
>>  	return 0;
>>  }
>>  
>>  static int rvin_digital_graph_init(struct rvin_dev *vin)
>>  {
>> -	struct v4l2_async_subdev **subdevs = NULL;
>>  	int ret;
>>  
>> -	ret = rvin_digital_graph_parse(vin);
>> +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
>> +		vin->dev, &vin->notifier,
>> +		sizeof(struct rvin_graph_entity), rvin_digital_parse_v4l2);
>>  	if (ret)
>>  		return ret;
>>  
>> -	if (!vin->digital.asd.match.fwnode.fwnode) {
>> -		vin_dbg(vin, "No digital subdevice found\n");
>> +	if (!vin->digital)
>>  		return -ENODEV;
>> -	}
>> -
>> -	/* Register the subdevices notifier. */
>> -	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
>> -	if (subdevs == NULL)
>> -		return -ENOMEM;
>> -
>> -	subdevs[0] = &vin->digital.asd;
>>  
>>  	vin_dbg(vin, "Found digital subdevice %pOF\n",
>> -		to_of_node(subdevs[0]->match.fwnode.fwnode));
>> +		to_of_node(vin->digital->asd.match.fwnode.fwnode));
>>  
>> -	vin->notifier.num_subdevs = 1;
>> -	vin->notifier.subdevs = subdevs;
>>  	vin->notifier.bound = rvin_digital_notify_bound;
>>  	vin->notifier.unbind = rvin_digital_notify_unbind;
>>  	vin->notifier.complete = rvin_digital_notify_complete;
>> -
>>  	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
>>  	if (ret < 0) {
>>  		vin_err(vin, "Notifier registration failed\n");
>> @@ -290,6 +245,8 @@ static int rcar_vin_probe(struct platform_device *pdev)
>>  	if (ret)
>>  		return ret;
>>  
>> +	platform_set_drvdata(pdev, vin);
>> +
>>  	ret = rvin_digital_graph_init(vin);
>>  	if (ret < 0)
>>  		goto error;
>> @@ -297,11 +254,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
>>  	pm_suspend_ignore_children(&pdev->dev, true);
>>  	pm_runtime_enable(&pdev->dev);
>>  
>> -	platform_set_drvdata(pdev, vin);
>> -
>>  	return 0;
>>  error:
>>  	rvin_dma_remove(vin);
>> +	v4l2_async_notifier_cleanup(&vin->notifier);
>>  
>>  	return ret;
>>  }
>> @@ -313,6 +269,7 @@ static int rcar_vin_remove(struct platform_device *pdev)
>>  	pm_runtime_disable(&pdev->dev);
>>  
>>  	v4l2_async_notifier_unregister(&vin->notifier);
>> +	v4l2_async_notifier_cleanup(&vin->notifier);
>>  
>>  	rvin_dma_remove(vin);
>>  
>> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
>> index b136844499f6..23fdff7a7370 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
>> @@ -183,7 +183,7 @@ static int rvin_setup(struct rvin_dev *vin)
>>  	/*
>>  	 * Input interface
>>  	 */
>> -	switch (vin->digital.code) {
>> +	switch (vin->digital->code) {
>>  	case MEDIA_BUS_FMT_YUYV8_1X16:
>>  		/* BT.601/BT.1358 16bit YCbCr422 */
>>  		vnmc |= VNMC_INF_YUV16;
>> @@ -191,7 +191,7 @@ static int rvin_setup(struct rvin_dev *vin)
>>  		break;
>>  	case MEDIA_BUS_FMT_UYVY8_2X8:
>>  		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>> -		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
>> +		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
>>  			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
>>  		input_is_yuv = true;
>>  		break;
>> @@ -200,7 +200,7 @@ static int rvin_setup(struct rvin_dev *vin)
>>  		break;
>>  	case MEDIA_BUS_FMT_UYVY10_2X10:
>>  		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
>> -		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
>> +		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
>>  			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
>>  		input_is_yuv = true;
>>  		break;
>> @@ -212,11 +212,11 @@ static int rvin_setup(struct rvin_dev *vin)
>>  	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
>>  
>>  	/* Hsync Signal Polarity Select */
>> -	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
>> +	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
>>  		dmr2 |= VNDMR2_HPS;
>>  
>>  	/* Vsync Signal Polarity Select */
>> -	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
>> +	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
>>  		dmr2 |= VNDMR2_VPS;
>>  
>>  	/*
>> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> index dd37ea811680..b479b882da12 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> @@ -111,7 +111,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
>>  	struct v4l2_mbus_framefmt *mf = &fmt.format;
>>  	int ret;
>>  
>> -	fmt.pad = vin->digital.source_pad;
>> +	fmt.pad = vin->digital->source_pad;
>>  
>>  	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
>>  	if (ret)
>> @@ -172,13 +172,13 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>>  
>>  	sd = vin_to_source(vin);
>>  
>> -	v4l2_fill_mbus_format(&format.format, pix, vin->digital.code);
>> +	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
>>  
>>  	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
>>  	if (pad_cfg == NULL)
>>  		return -ENOMEM;
>>  
>> -	format.pad = vin->digital.source_pad;
>> +	format.pad = vin->digital->source_pad;
>>  
>>  	field = pix->field;
>>  
>> @@ -555,7 +555,7 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
>>  	if (timings->pad)
>>  		return -EINVAL;
>>  
>> -	timings->pad = vin->digital.sink_pad;
>> +	timings->pad = vin->digital->sink_pad;
>>  
>>  	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
>>  
>> @@ -607,7 +607,7 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
>>  	if (cap->pad)
>>  		return -EINVAL;
>>  
>> -	cap->pad = vin->digital.sink_pad;
>> +	cap->pad = vin->digital->sink_pad;
>>  
>>  	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
>>  
>> @@ -625,7 +625,7 @@ static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
>>  	if (edid->pad)
>>  		return -EINVAL;
>>  
>> -	edid->pad = vin->digital.sink_pad;
>> +	edid->pad = vin->digital->sink_pad;
>>  
>>  	ret = v4l2_subdev_call(sd, pad, get_edid, edid);
>>  
>> @@ -643,7 +643,7 @@ static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
>>  	if (edid->pad)
>>  		return -EINVAL;
>>  
>> -	edid->pad = vin->digital.sink_pad;
>> +	edid->pad = vin->digital->sink_pad;
>>  
>>  	ret = v4l2_subdev_call(sd, pad, set_edid, edid);
>>  
>> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
>> index 9bfb5a7c4dc4..5382078143fb 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
>> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
>> @@ -126,7 +126,7 @@ struct rvin_dev {
>>  	struct v4l2_device v4l2_dev;
>>  	struct v4l2_ctrl_handler ctrl_handler;
>>  	struct v4l2_async_notifier notifier;
>> -	struct rvin_graph_entity digital;
>> +	struct rvin_graph_entity *digital;
>>  
>>  	struct mutex lock;
>>  	struct vb2_queue queue;
>> @@ -145,7 +145,7 @@ struct rvin_dev {
>>  	struct v4l2_rect compose;
>>  };
>>  
>> -#define vin_to_source(vin)		vin->digital.subdev
>> +#define vin_to_source(vin)		((vin)->digital->subdev)
>>  
>>  /* Debug */
>>  #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
>> -- 
>> 2.11.0
>>
> 


-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
