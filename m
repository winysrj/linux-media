Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54095 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965816AbcCPMCi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 08:02:38 -0400
Date: Wed, 16 Mar 2016 09:02:21 -0300
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
Message-ID: <20160316090221.02d0a699@recife.lan>
In-Reply-To: <20160316082834.GX11084@valkosipuli.retiisi.org.uk>
References: <1457833689-4926-1-git-send-email-shuahkh@osg.samsung.com>
	<20160314072236.GO11084@valkosipuli.retiisi.org.uk>
	<20160314071358.27c87dab@recife.lan>
	<20160314105253.GQ11084@valkosipuli.retiisi.org.uk>
	<20160314084633.521d3e35@recife.lan>
	<20160314120909.GS11084@valkosipuli.retiisi.org.uk>
	<20160315125535.775c8cc3@recife.lan>
	<20160316082834.GX11084@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Mar 2016 10:28:35 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Mar 15, 2016 at 12:55:35PM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 14 Mar 2016 14:09:09 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 

...

> > > Notify callbacks, perhaps not, but the list is still protected by the
> > > spinlock. It perhaps is not likely that another process would change it but
> > > I don't think we can rely on that.  
> > 
> > I can see only 2 risks protected by the lock:
> > 
> > 1) mdev gets freed while an entity is being created. This is a problem
> >    with the current memory protection schema we're using. I guess the
> >    only way to fix it is to use kref for mdev/entities/interfaces/links/pads.
> >    This change doesn't make it better or worse.
> >    Also, I don't think we have such risk with the current devices.
> > 
> > 2) a notifier may be inserted or removed by another driver, while the
> >    loop is running.
> > 
> > To avoid (2), I see 3 alternatives:
> > 
> > a) keep the loop as proposed on this patch. As the list is navigated using 
> > list_for_each_entry_safe(), I guess[1] it should be safe to remove/add
> > new notify callbacks there while the loop is running by some other process.   
> 
> list_for_each_entry_safe() does not protect against concurrent access, only
> against adding and removing list entries by the same user. List access
> serialisation is still needed, whether you use _safe() functions or not.
> 
> > 
> > [1] It *is* safe if the change were done inside the loop - but I'm not
> > 100% sure that it is safe if some other CPU touches the notify list.  
> 
> Indeed.
> 
> > 
> > b) Unlock/relock the spinlock every time:
> > 
> > 	/* previous code that locks mdev->lock spinlock */
> > 
> >  	/* invoke entity_notify callbacks */
> >  	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
> > 		spin_unlock(&mdev->lock);
> >  		(notify)->notify(entity, notify->notify_data);
> > 		spin_lock(&mdev->lock);
> >  	}
> >  
> > 	spin_unlock(&mdev->lock);
> > 
> > c) use a separate lock for the notify list -this seems to be an overkill.
> > 
> > d) Protect it with the graph traversal mutex. That sounds the worse idea,
> >    IMHO, as we'll be abusing the lock.  
> 
> I'd simply replace the spinlock with a mutex here. As we want to get rid of
> the graph mutex anyway in the long run, let's not mix the two as they're
> well separated now. As long as the mutex users do not sleep (i.e. the
> notify() callback) the mutex is about as fast to use as the spinlock.

It could work. I added such patch on an experimental branch, where
I'm addressing a few troubles with au0828 unbind logic:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=au0828-unbind-fixes

The patch itself is at:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=au0828-unbind-fixes&id=dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4

At least for au0828, it seems to work fine.

Regards,
Mauro
