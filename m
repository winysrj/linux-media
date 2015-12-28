Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60418 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbbL1NhC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 08:37:02 -0500
Date: Mon, 28 Dec 2015 11:36:57 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: subdev: Register the entity before calling
 subdev's registered op
Message-ID: <20151228113657.5db4dcc0@recife.lan>
In-Reply-To: <20151228131806.GB26561@valkosipuli.retiisi.org.uk>
References: <1451259900-9295-1-git-send-email-sakari.ailus@iki.fi>
	<20151228104158.6d550224@recife.lan>
	<20151228131806.GB26561@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Dec 2015 15:18:06 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Mon, Dec 28, 2015 at 10:41:58AM -0200, Mauro Carvalho Chehab wrote:
> > Em Mon, 28 Dec 2015 01:45:00 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > 
> > > Registering a V4L2 sub-device includes, among other things, registering
> > > the related media entity and calling the sub-device's registered op. Since
> > > patch "media: convert links from array to list", creating a link between
> > > two pads requires registering the entity first. If the registered() op
> > > involves link creation, the link list head will not be initialised before
> > > it is used.
> > > 
> > > Resolve this by first registering the entity, then calling its
> > > registered() op.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > > Hi Mauro,
> > > 
> > > You seem to be missing this patch from your media-controller-rc4 branch.
> > > Not having it breaks at least the smiapp driver. I was pretty sure to have
> > > sent it but I can't find it on linux-media. Oh well.
> > 
> > Perhaps it was on some of your replies. There were too many OOT media
> > controller patches floating around ;)
> > 
> > Anyway, I applied the patches at:
> > 
> > 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=media-controller-rc6
> 
> Thanks!
> 
> > 
> > > 
> > > Speaking of the entity function warnings --- I'd omit them until we've
> > > agreed that this is what we should really have (I don't think so). I can
> > > submit a patch to remove them if you like.
> > 
> > There were some discussions about that and I was thinking that we had an
> > agreement about that. Anyway, I don't object to remove the warning for
> > now, and discuss that a little more.
> > 
> > > 
> > > ----------8<------------
> > > [  108.919189] omap3isp 480bc000.isp: Entity type for entity jt8ew9 binner 1-0010 was not initialized!
> > > [  108.929046] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > > [  108.937652] pgd = ed0b8000
> > > [  108.940521] [00000000] *pgd=aefc3831, *pte=00000000, *ppte=00000000
> > > [  108.947204] Internal error: Oops: 817 [#1] ARM
> > > [  108.951904] Modules linked in: smiapp(+) smiapp_pll omap3_isp videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_core v4l2_common videodev media
> > > [  108.966735] CPU: 0 PID: 1163 Comm: modprobe Not tainted 4.4.0-rc2-00328-g40e950d #507
> > > [  108.975006] Hardware name: Generic OMAP36xx (Flattened Device Tree)
> > > [  108.981597] task: eeb91340 ti: eec6e000 task.ti: eec6e000
> > > [  108.987335] PC is at media_add_link+0x34/0x44 [media]
> > > [  108.992645] LR is at 0x0
> > > [  108.995330] pc : [<bf001850>]    lr : [<00000000>]    psr: a0000013
> > > [  108.995330] sp : eec6fc78  ip : 00000000  fp : 00000000
> > > [  109.007415] r10: 00000000  r9 : 00000003  r8 : eeee1c40
> > > [  109.012939] r7 : 00000000  r6 : 0000001c  r5 : ee9a7248  r4 : ee9a70c4
> > > [  109.019805] r3 : 00000000  r2 : eeee1c10  r1 : ee8000c0  r0 : eeee1c00
> > > [  109.026672] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> > > [  109.034210] Control: 10c5387d  Table: ad0b8019  DAC: 00000051
> > > [  109.040252] Process modprobe (pid: 1163, stack limit = 0xeec6e208)
> > > [  109.046752] Stack: (0xeec6fc78 to 0xeec70000)
> > > [  109.051361] fc60:                                                       ee9a7098 bf0021b4
> > > [  109.059997] fc80: 00000000 ee9a7010 eec6fcbc eea1fc00 ee9a7248 00000000 eec6fcc0 ee9a7098
> > > [  109.068634] fca0: 00000136 bf09c520 00000003 ee9a7140 eeb91340 ee9a7098 ee9a7248 ee9a73f8
> > > [  109.077270] fcc0: ee9a7010 ee9a7098 eefd0010 ed08f620 00000000 bf024d8c 0000035a 1dc13000
> > > [  109.085906] fce0: 00000000 bf014488 eefd0084 ee9a7098 ed08f620 00000000 bf024d8c bf01d384
> > > [  109.094543] fd00: ee9a7140 eefd0090 ed08f620 bf024d48 ee9a7098 eefd0084 ee9a7140 bf01d444
> > > [  109.103179] fd20: eeee6650 eea1fc00 ee9a7010 eeee66c0 00000003 bf09c3f8 1dc13000 00000000
> > > [  109.111785] fd40: 00000002 c02bab44 ef7e2994 00000000 eea1fc00 bf09c13c bf09eba4 eea1fc04
> > > [  109.120422] fd60: 00000000 eea1fc20 eec6ff0c c028b7dc eea1fc20 bf09ebc0 00000000 c0dce564
> > > [  109.129058] fd80: 00000002 00000000 00000000 c02112dc bf09ebc0 eea1fc20 00000000 00000002
> > > [  109.137695] fda0: eea1fc20 eea1fc54 bf09ebc0 00000000 c05908e0 c02115c8 bf09ebc0 eec6fdc8
> > > [  109.146331] fdc0: c0211560 c020f8ac ee92c6a4 eea78410 bf09ebc0 bf09ebc0 ee9ec240 c05d1e74
> > > [  109.154968] fde0: c05908e0 c0210110 bf09d8ec eec6fd90 bf09ebc0 bf0a3000 00000000 c0211cc4
> > > [  109.163604] fe00: bf09eba4 bf0a3000 00000000 c028bd94 eeee6780 bf0a3000 00000000 c0009784
> > > [  109.172241] fe20: efdd6ca0 efdd6cc0 00000000 00000001 00000000 c009709c eeb91340 efdd6ca0
> > > [  109.180877] fe40: 00000000 c0063428 00000000 00000000 eeb91340 00000001 c00c4f1c eedb13c0
> > > [  109.189514] fe60: 00000018 c005fdc8 024000c0 ee8000c0 60000013 bf09f340 eec6ff48 eedb13c0
> > > [  109.198150] fe80: 00000001 00000018 00000000 00000000 eec6ff0c c008ac94 bf09f340 00000000
> > > [  109.206756] fea0: efd99ff4 bf09f340 eec6ff48 bf09f34c 00000001 c008c634 ffff8000 00007fff
> > > [  109.215393] fec0: 00000000 c008a8f4 f163a300 f163a448 000007d0 00000186 0001cfc0 f16b9e80
> > > [  109.224029] fee0: 00000000 00000000 00000000 00000000 00000000 00000000 bf09f344 eec6ff1c
> > > [  109.232666] ff00: 00001c02 c019cf24 20000013 c050e0b8 00000055 00000001 00010000 b6dfdea8
> > > [  109.241302] ff20: 00006ea8 0001cfc0 00000000 f16b9ea8 eec6e000 00000051 0001cf48 c008cb04
> > > [  109.249938] ff40: 60000013 c005dcf4 f1633000 00086ea8 f16b96b0 f1697f05 f1699958 00007560
> > > [  109.258575] ff60: 00008670 bf09ef90 00000025 00000000 00000031 00000032 00000017 0000001b
> > > [  109.267211] ff80: 00000010 00000000 0001b070 0001b070 00000000 00000000 00000080 c000fa44
> > > [  109.275848] ffa0: 00000000 c000f8a0 0001b070 00000000 b6d77000 00086ea8 0001cfc0 00000000
> > > [  109.284484] ffc0: 0001b070 00000000 00000000 00000080 00000000 0001cfe0 00000000 0001cf48
> > > [  109.293121] ffe0: 0001cfc0 bea866fc 0000b720 b6ec6ed4 60000010 b6d77000 afffd861 afffdc61
> > > [  109.301788] [<bf001850>] (media_add_link [media]) from [<bf0021b4>] (media_create_pad_link+0xb0/0x134 [media])
> > > [  109.312408] [<bf0021b4>] (media_create_pad_link [media]) from [<bf09c520>] (smiapp_registered+0xd0/0x114 [smiapp])
> > > [  109.323455] [<bf09c520>] (smiapp_registered [smiapp]) from [<bf014488>] (v4l2_device_register_subdev+0xb8/0x17c [videodev])
> > > [  109.335327] [<bf014488>] (v4l2_device_register_subdev [videodev]) from [<bf01d384>] (v4l2_async_test_notify+0x90/0xf0 [videodev])
> > > [  109.347778] [<bf01d384>] (v4l2_async_test_notify [videodev]) from [<bf01d444>] (v4l2_async_register_subdev+0x60/0xbc [videodev])
> > > [  109.360046] [<bf01d444>] (v4l2_async_register_subdev [videodev]) from [<bf09c3f8>] (smiapp_probe+0x2bc/0x314 [smiapp])
> > > [  109.371368] [<bf09c3f8>] (smiapp_probe [smiapp]) from [<c028b7dc>] (i2c_device_probe+0x1b8/0x214)
> > > [  109.380737] [<c028b7dc>] (i2c_device_probe) from [<c02112dc>] (driver_probe_device+0x18c/0x410)
> > > [  109.389923] [<c02112dc>] (driver_probe_device) from [<c02115c8>] (__driver_attach+0x68/0x8c)
> > > [  109.398834] [<c02115c8>] (__driver_attach) from [<c020f8ac>] (bus_for_each_dev+0x4c/0x90)
> > > [  109.407470] [<c020f8ac>] (bus_for_each_dev) from [<c0210110>] (bus_add_driver+0x118/0x238)
> > > [  109.416198] [<c0210110>] (bus_add_driver) from [<c0211cc4>] (driver_register+0xa0/0xe4)
> > > [  109.424652] [<c0211cc4>] (driver_register) from [<c028bd94>] (i2c_register_driver+0x40/0x9c)
> > > [  109.433563] [<c028bd94>] (i2c_register_driver) from [<c0009784>] (do_one_initcall+0x118/0x1e0)
> > > [  109.442657] [<c0009784>] (do_one_initcall) from [<c008ac94>] (do_init_module+0x58/0x1b0)
> > > [  109.451202] [<c008ac94>] (do_init_module) from [<c008c634>] (load_module+0x1240/0x1584)
> > > [  109.459655] [<c008c634>] (load_module) from [<c008cb04>] (SyS_init_module+0x18c/0x1a4)
> > > [  109.468017] [<c008cb04>] (SyS_init_module) from [<c000f8a0>] (ret_fast_syscall+0x0/0x1c)
> > > [  109.476562] Code: e2802010 e5842004 e5804010 e5803014 (e5832000) 
> > > [  109.483062] ---[ end trace aa9de464363318da ]---
> > > ----------8<------------
> > > 
> > > Kind regards,
> > > Sakari
> > > 
> > >  drivers/media/v4l2-core/v4l2-device.c | 19 +++++++++----------
> > >  1 file changed, 9 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> > > index 85b1e98..b50fb8d 100644
> > > --- a/drivers/media/v4l2-core/v4l2-device.c
> > > +++ b/drivers/media/v4l2-core/v4l2-device.c
> > > @@ -180,26 +180,26 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
> > >  		return -ENODEV;
> > >  
> > >  	sd->v4l2_dev = v4l2_dev;
> > > -	if (sd->internal_ops && sd->internal_ops->registered) {
> > > -		err = sd->internal_ops->registered(sd);
> > > -		if (err)
> > > -			goto error_module;
> > > -	}
> > > -
> > >  	/* This just returns 0 if either of the two args is NULL */
> > >  	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
> > >  	if (err)
> > > -		goto error_unregister;
> > > +		goto error_module;
> > >  
> > >  #if defined(CONFIG_MEDIA_CONTROLLER)
> > >  	/* Register the entity. */
> > >  	if (v4l2_dev->mdev) {
> > >  		err = media_device_register_entity(v4l2_dev->mdev, entity);
> > >  		if (err < 0)
> > > -			goto error_unregister;
> > > +			goto error_module;
> > >  	}
> > >  #endif
> > >  
> > > +	if (sd->internal_ops && sd->internal_ops->registered) {
> > > +		err = sd->internal_ops->registered(sd);
> > > +		if (err)
> > > +			goto error_unregister;
> > > +	}
> > > +
> > >  	spin_lock(&v4l2_dev->lock);
> > >  	list_add_tail(&sd->list, &v4l2_dev->subdevs);
> > >  	spin_unlock(&v4l2_dev->lock);
> > > @@ -207,8 +207,7 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
> > >  	return 0;
> > >  
> > >  error_unregister:
> > > -	if (sd->internal_ops && sd->internal_ops->unregistered)
> > > -		sd->internal_ops->unregistered(sd);
> > > +	media_device_unregister_entity(entity);
> > 
> > This breaks if !CONFIG_MEDIA_CONTROLLER. So, I'm folding the following fixup:
> 
> Looks good. Thanks for spotting this. I'm so inclined to think MC is always
> enabled. ;)

:)

> Speaking of which --- now that there seem to be drivers, too, that can be
> used with and without MC, working with the two possibilities isn't as easy
> as it could be for drivers. It's not a major painpoint, but I think we could
> get rid of (some if not most of) these #ifdefs.

Shuah did some work on adding some stub at media-entity.h to avoid some
ifdefs. Yet, there are more things to do. See below.

> 
> > diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> > index b50fb8d7d62e..06fa5f1b2cff 100644
> > --- a/drivers/media/v4l2-core/v4l2-device.c
> > +++ b/drivers/media/v4l2-core/v4l2-device.c
> > @@ -207,7 +207,9 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
> >  	return 0;
> >  
> >  error_unregister:
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> >  	media_device_unregister_entity(entity);
> > +#endif

In the above, "entity" is only defined if CONFIG_MEDIA_CONTROLLER.

Ok, we could change the logic there, but it is not trivial to
completely get rid of a #if CONFIG_MEDIA_CONTROLLER at v4l2-device.c.
The same is true inside the drivers code.

We could do some effort to try to cleanup this in the future.

> >  error_module:
> >  	if (!sd->owner_v4l2_dev)
> >  		module_put(sd->owner);
> > 
> > 
> > 
> > 
> > >  error_module:
> > >  	if (!sd->owner_v4l2_dev)
> > >  		module_put(sd->owner);
> 
