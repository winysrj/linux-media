Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53993 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbcCOPzs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 11:55:48 -0400
Date: Tue, 15 Mar 2016 12:55:35 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	a.hajda@samsung.com, s.nawrocki@samsung.com, kgene@kernel.org,
	k.kozlowski@samsung.com, laurent.pinchart@ideasonboard.com,
	hyun.kwon@xilinx.com, soren.brinkmann@xilinx.com,
	gregkh@linuxfoundation.org, perex@perex.cz, tiwai@suse.com,
	hans.verkuil@cisco.com, lixiubo@cmss.chinamobile.com,
	javier@osg.samsung.com, g.liakhovetski@gmx.de,
	chehabrafael@gmail.com, crope@iki.fi, tommi.franttila@intel.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	hamohammed.sa@gmail.com, der.herr@hofr.at, navyasri.tech@gmail.com,
	Julia.Lawall@lip6.fr, amitoj1606@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH] media: add GFP flag to media_*() that could get called
 in atomic context
Message-ID: <20160315125535.775c8cc3@recife.lan>
In-Reply-To: <20160314120909.GS11084@valkosipuli.retiisi.org.uk>
References: <1457833689-4926-1-git-send-email-shuahkh@osg.samsung.com>
	<20160314072236.GO11084@valkosipuli.retiisi.org.uk>
	<20160314071358.27c87dab@recife.lan>
	<20160314105253.GQ11084@valkosipuli.retiisi.org.uk>
	<20160314084633.521d3e35@recife.lan>
	<20160314120909.GS11084@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Mar 2016 14:09:09 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Mon, Mar 14, 2016 at 08:46:33AM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 14 Mar 2016 12:52:54 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > On Mon, Mar 14, 2016 at 07:13:58AM -0300, Mauro Carvalho Chehab wrote:  
> > > > Em Mon, 14 Mar 2016 09:22:37 +0200
> > > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > > >     
> > > > > Hi Shuah,
> > > > > 
> > > > > On Sat, Mar 12, 2016 at 06:48:09PM -0700, Shuah Khan wrote:    
> > > > > > Add GFP flags to media_create_pad_link(), media_create_intf_link(),
> > > > > > media_devnode_create(), and media_add_link() that could get called
> > > > > > in atomic context to allow callers to pass in the right flags for
> > > > > > memory allocation.
> > > > > > 
> > > > > > tree-wide driver changes for media_*() GFP flags change:
> > > > > > Change drivers to add gfpflags to interffaces, media_create_pad_link(),
> > > > > > media_create_intf_link() and media_devnode_create().
> > > > > > 
> > > > > > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> > > > > > Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>      
> > > > > 
> > > > > What's the use case for calling the above functions in an atomic context?
> > > > >     
> > > > 
> > > > ALSA code seems to do a lot of stuff at atomic context. That's what
> > > > happens on my test machine when au0828 gets probed before
> > > > snd-usb-audio:
> > > > 	http://pastebin.com/LEX5LD5K
> > > > 
> > > > It seems that ALSA USB probe routine (usb_audio_probe) happens in
> > > > atomic context.    
> > > 
> > > usb_audio_probe() grabs a mutex (register_mutex) on its own. It certainly
> > > cannot be called in atomic context.
> > > 
> > > In the above log, what I did notice, though, was that because *we* grab
> > > mdev->lock spinlock in media_device_register_entity(), we may not sleep
> > > which is what the notify() callback implementation in au0828 driver does
> > > (for memory allocation).  
> > 
> > True. After looking into the code, the problem is that the notify
> > callbacks are called with the spinlock hold. I don't see any reason
> > to do that.  
> 
> Notify callbacks, perhaps not, but the list is still protected by the
> spinlock. It perhaps is not likely that another process would change it but
> I don't think we can rely on that.

I can see only 2 risks protected by the lock:

1) mdev gets freed while an entity is being created. This is a problem
   with the current memory protection schema we're using. I guess the
   only way to fix it is to use kref for mdev/entities/interfaces/links/pads.
   This change doesn't make it better or worse.
   Also, I don't think we have such risk with the current devices.

2) a notifier may be inserted or removed by another driver, while the
   loop is running.

To avoid (2), I see 3 alternatives:

a) keep the loop as proposed on this patch. As the list is navigated using 
list_for_each_entry_safe(), I guess[1] it should be safe to remove/add
new notify callbacks there while the loop is running by some other process. 

[1] It *is* safe if the change were done inside the loop - but I'm not
100% sure that it is safe if some other CPU touches the notify list.

b) Unlock/relock the spinlock every time:

	/* previous code that locks mdev->lock spinlock */

 	/* invoke entity_notify callbacks */
 	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
		spin_unlock(&mdev->lock);
 		(notify)->notify(entity, notify->notify_data);
		spin_lock(&mdev->lock);
 	}
 
	spin_unlock(&mdev->lock);

c) use a separate lock for the notify list -this seems to be an overkill.

d) Protect it with the graph traversal mutex. That sounds the worse idea,
   IMHO, as we'll be abusing the lock.

> 
> >   
> > > Could we instead replace mdev->lock by a mutex?  
> > 
> > We changed the code to use a spinlock for a reason: this fixed some
> > troubles in the past with the code locking (can't remember the problem,
> > but this was documented at the kernel logs and at the ML). Yet, the code
> > under the spinlock never sleeps, so this is fine.  
> 
> struct media_device.lock was added by this patch:
> 
> commit 53e269c102fbaf77e7dc526b1606ad4a48e57200
> Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Date:   Wed Dec 9 08:40:00 2009 -0300
> 
>     [media] media: Entities, pads and links
> 
>     As video hardware pipelines become increasingly complex and
>     configurable, the current hardware description through v4l2 subdevices
>     reaches its limits. In addition to enumerating and configuring
>     subdevices, video camera drivers need a way to discover and modify at
>     runtime how those subdevices are connected. This is done through new
>     elements called entities, pads and links.
> 
> ...
> 
>     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>     Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> I think it was always a spinlock, for the reason you stated above as well:
> it did not need to sleep. But if there is a need to sleep, I think we should
> consider changing that.

True, but there were some places that were using the graph_mutex
instead of the spinlock. 

> 
> > 
> > Yet, in the future, we'll need to do a review of all the locking schema,
> > in order to better support dynamic graph changes.  
> 
> Agreed. I think more fine grained locking should be considered. The media
> graph mutex will become a bottleneck at some point, especially if we make
> the media devices system wide at some point.

Yes. I guess we should protect the memory allocated stuff with a kref,
and try to use RCS on most places, but we need more discussions and
more tests to implement a solution that would be reliable even if the
callers don't behave well.

> >   
> > > If there is no pressing need to implement atomic memory allocation I simply
> > > wouldn't do it, especially in device initialisation where an allocation
> > > failure will lead to probe failure as well.  
> > 
> > The fix for this issue should be simple. See the enclosed code. Btw.
> > it probably makes sense to add some code here to avoid starving the
> > stack, as a notify callback could try to create an entity, with,
> > in turn, would call the notify callback again.
> > 
> > I'll run some tests here to double check if it fixes the issue.
> > 
> > ---
> > 
> > [media] media-device: Don't call notify callbacks holding a spinlock
> > 
> > The notify routines may sleep. So, they can't be called in spinlock
> > context. Also, they may want to call other media routines that might
> > be spinning the spinlock, like creating a link.
> > 
> > This fixes the following bug:
> > 
> > [ 1839.510587] BUG: sleeping function called from invalid context at mm/slub.c:1289
> > [ 1839.510881] in_atomic(): 1, irqs_disabled(): 0, pid: 3479, name: modprobe
> > [ 1839.511157] 4 locks held by modprobe/3479:
> > [ 1839.511415]  #0:  (&dev->mutex){......}, at: [<ffffffff81ce8933>] __driver_attach+0xa3/0x160
> > [ 1839.512381]  #1:  (&dev->mutex){......}, at: [<ffffffff81ce8941>] __driver_attach+0xb1/0x160
> > [ 1839.512388]  #2:  (register_mutex#5){+.+.+.}, at: [<ffffffffa10596c7>] usb_audio_probe+0x257/0x1c90 [snd_usb_audio]
> > [ 1839.512401]  #3:  (&(&mdev->lock)->rlock){+.+.+.}, at: [<ffffffffa0e6051b>] media_device_register_entity+0x1cb/0x700 [media]
> > [ 1839.512412] CPU: 2 PID: 3479 Comm: modprobe Not tainted 4.5.0-rc3+ #49
> > [ 1839.512415] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
> > [ 1839.512417]  0000000000000000 ffff8803b3f6f288 ffffffff81933901 ffff8803c4bae000
> > [ 1839.512422]  ffff8803c4bae5c8 ffff8803b3f6f2b0 ffffffff811c6af5 ffff8803c4bae000
> > [ 1839.512427]  ffffffff8285d7f6 0000000000000509 ffff8803b3f6f2f0 ffffffff811c6ce5
> > [ 1839.512432] Call Trace:
> > [ 1839.512436]  [<ffffffff81933901>] dump_stack+0x85/0xc4
> > [ 1839.512440]  [<ffffffff811c6af5>] ___might_sleep+0x245/0x3a0
> > [ 1839.512443]  [<ffffffff811c6ce5>] __might_sleep+0x95/0x1a0
> > [ 1839.512446]  [<ffffffff8155aade>] kmem_cache_alloc_trace+0x20e/0x300
> > [ 1839.512451]  [<ffffffffa0e66e3d>] ? media_add_link+0x4d/0x140 [media]
> > [ 1839.512455]  [<ffffffffa0e66e3d>] media_add_link+0x4d/0x140 [media]
> > [ 1839.512459]  [<ffffffffa0e69931>] media_create_pad_link+0xa1/0x600 [media]
> > [ 1839.512463]  [<ffffffffa0fe11b3>] au0828_media_graph_notify+0x173/0x360 [au0828]
> > [ 1839.512467]  [<ffffffffa0e68a6a>] ? media_gobj_create+0x1ba/0x480 [media]
> > [ 1839.512471]  [<ffffffffa0e606fb>] media_device_register_entity+0x3ab/0x700 [media]
> > 
> > (untested)
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 6ba6e8f982fc..fc3c199e5500 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -587,14 +587,15 @@ int __must_check media_device_register_entity(struct media_device *mdev,
> >  		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
> >  			       &entity->pads[i].graph_obj);
> >  
> > +	spin_unlock(&mdev->lock);
> > +
> >  	/* invoke entity_notify callbacks */
> >  	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
> >  		(notify)->notify(entity, notify->notify_data);
> >  	}
> >  
> > -	spin_unlock(&mdev->lock);
> > -
> >  	mutex_lock(&mdev->graph_mutex);
> > +
> >  	if (mdev->entity_internal_idx_max  
> >  	    >= mdev->pm_count_walk.ent_enum.idx_max) {  
> >  		struct media_entity_graph new = { .top = 0 };
> >   
> 


-- 
Thanks,
Mauro
