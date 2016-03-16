Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50314 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964956AbcCPI2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 04:28:44 -0400
Date: Wed, 16 Mar 2016 10:28:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
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
Message-ID: <20160316082834.GX11084@valkosipuli.retiisi.org.uk>
References: <1457833689-4926-1-git-send-email-shuahkh@osg.samsung.com>
 <20160314072236.GO11084@valkosipuli.retiisi.org.uk>
 <20160314071358.27c87dab@recife.lan>
 <20160314105253.GQ11084@valkosipuli.retiisi.org.uk>
 <20160314084633.521d3e35@recife.lan>
 <20160314120909.GS11084@valkosipuli.retiisi.org.uk>
 <20160315125535.775c8cc3@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160315125535.775c8cc3@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Mar 15, 2016 at 12:55:35PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 14 Mar 2016 14:09:09 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Mon, Mar 14, 2016 at 08:46:33AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Mon, 14 Mar 2016 12:52:54 +0200
> > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > On Mon, Mar 14, 2016 at 07:13:58AM -0300, Mauro Carvalho Chehab wrote:  
> > > > > Em Mon, 14 Mar 2016 09:22:37 +0200
> > > > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > > > >     
> > > > > > Hi Shuah,
> > > > > > 
> > > > > > On Sat, Mar 12, 2016 at 06:48:09PM -0700, Shuah Khan wrote:    
> > > > > > > Add GFP flags to media_create_pad_link(), media_create_intf_link(),
> > > > > > > media_devnode_create(), and media_add_link() that could get called
> > > > > > > in atomic context to allow callers to pass in the right flags for
> > > > > > > memory allocation.
> > > > > > > 
> > > > > > > tree-wide driver changes for media_*() GFP flags change:
> > > > > > > Change drivers to add gfpflags to interffaces, media_create_pad_link(),
> > > > > > > media_create_intf_link() and media_devnode_create().
> > > > > > > 
> > > > > > > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> > > > > > > Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>      
> > > > > > 
> > > > > > What's the use case for calling the above functions in an atomic context?
> > > > > >     
> > > > > 
> > > > > ALSA code seems to do a lot of stuff at atomic context. That's what
> > > > > happens on my test machine when au0828 gets probed before
> > > > > snd-usb-audio:
> > > > > 	http://pastebin.com/LEX5LD5K
> > > > > 
> > > > > It seems that ALSA USB probe routine (usb_audio_probe) happens in
> > > > > atomic context.    
> > > > 
> > > > usb_audio_probe() grabs a mutex (register_mutex) on its own. It certainly
> > > > cannot be called in atomic context.
> > > > 
> > > > In the above log, what I did notice, though, was that because *we* grab
> > > > mdev->lock spinlock in media_device_register_entity(), we may not sleep
> > > > which is what the notify() callback implementation in au0828 driver does
> > > > (for memory allocation).  
> > > 
> > > True. After looking into the code, the problem is that the notify
> > > callbacks are called with the spinlock hold. I don't see any reason
> > > to do that.  
> > 
> > Notify callbacks, perhaps not, but the list is still protected by the
> > spinlock. It perhaps is not likely that another process would change it but
> > I don't think we can rely on that.
> 
> I can see only 2 risks protected by the lock:
> 
> 1) mdev gets freed while an entity is being created. This is a problem
>    with the current memory protection schema we're using. I guess the
>    only way to fix it is to use kref for mdev/entities/interfaces/links/pads.
>    This change doesn't make it better or worse.
>    Also, I don't think we have such risk with the current devices.
> 
> 2) a notifier may be inserted or removed by another driver, while the
>    loop is running.
> 
> To avoid (2), I see 3 alternatives:
> 
> a) keep the loop as proposed on this patch. As the list is navigated using 
> list_for_each_entry_safe(), I guess[1] it should be safe to remove/add
> new notify callbacks there while the loop is running by some other process. 

list_for_each_entry_safe() does not protect against concurrent access, only
against adding and removing list entries by the same user. List access
serialisation is still needed, whether you use _safe() functions or not.

> 
> [1] It *is* safe if the change were done inside the loop - but I'm not
> 100% sure that it is safe if some other CPU touches the notify list.

Indeed.

> 
> b) Unlock/relock the spinlock every time:
> 
> 	/* previous code that locks mdev->lock spinlock */
> 
>  	/* invoke entity_notify callbacks */
>  	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
> 		spin_unlock(&mdev->lock);
>  		(notify)->notify(entity, notify->notify_data);
> 		spin_lock(&mdev->lock);
>  	}
>  
> 	spin_unlock(&mdev->lock);
> 
> c) use a separate lock for the notify list -this seems to be an overkill.
> 
> d) Protect it with the graph traversal mutex. That sounds the worse idea,
>    IMHO, as we'll be abusing the lock.

I'd simply replace the spinlock with a mutex here. As we want to get rid of
the graph mutex anyway in the long run, let's not mix the two as they're
well separated now. As long as the mutex users do not sleep (i.e. the
notify() callback) the mutex is about as fast to use as the spinlock.

> 
> > 
> > >   
> > > > Could we instead replace mdev->lock by a mutex?  
> > > 
> > > We changed the code to use a spinlock for a reason: this fixed some
> > > troubles in the past with the code locking (can't remember the problem,
> > > but this was documented at the kernel logs and at the ML). Yet, the code
> > > under the spinlock never sleeps, so this is fine.  
> > 
> > struct media_device.lock was added by this patch:
> > 
> > commit 53e269c102fbaf77e7dc526b1606ad4a48e57200
> > Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Date:   Wed Dec 9 08:40:00 2009 -0300
> > 
> >     [media] media: Entities, pads and links
> > 
> >     As video hardware pipelines become increasingly complex and
> >     configurable, the current hardware description through v4l2 subdevices
> >     reaches its limits. In addition to enumerating and configuring
> >     subdevices, video camera drivers need a way to discover and modify at
> >     runtime how those subdevices are connected. This is done through new
> >     elements called entities, pads and links.
> > 
> > ...
> > 
> >     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >     Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >     Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > I think it was always a spinlock, for the reason you stated above as well:
> > it did not need to sleep. But if there is a need to sleep, I think we should
> > consider changing that.
> 
> True, but there were some places that were using the graph_mutex
> instead of the spinlock. 

Hmm. If it's used to serialise access to the same data, it's most likely a
bug.

> 
> > 
> > > 
> > > Yet, in the future, we'll need to do a review of all the locking schema,
> > > in order to better support dynamic graph changes.  
> > 
> > Agreed. I think more fine grained locking should be considered. The media
> > graph mutex will become a bottleneck at some point, especially if we make
> > the media devices system wide at some point.
> 
> Yes. I guess we should protect the memory allocated stuff with a kref,
> and try to use RCS on most places, but we need more discussions and
> more tests to implement a solution that would be reliable even if the
> callers don't behave well.

Yes.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
