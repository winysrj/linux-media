Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56179 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755264AbeDWOH3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 10:07:29 -0400
Date: Mon, 23 Apr 2018 11:07:22 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 04/29] media-request: core request support
Message-ID: <20180423110722.793da375@vento.lan>
In-Reply-To: <e5ef55bd-56fd-a1bb-3bb7-b745c8baca05@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-5-hverkuil@xs4all.nl>
        <20180410073206.12d4c67d@vento.lan>
        <e5ef55bd-56fd-a1bb-3bb7-b745c8baca05@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Apr 2018 14:23:28 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> >> +	spin_lock_irqsave(&req->lock, flags);
> >> +	state = req->state;
> >> +	spin_unlock_irqrestore(&req->lock, flags);  
> > 
> > IMO, it would be better to use an atomic var for state, having a
> > lockless access to it.  
> 
> In most cases I need to do more than just change the state. I don't see
> enough benefits from using an atomic.

On several cases, it is doing this check without changing the state.
Also, the IRQ logic seems to require changing the status, and it can't
use a mutex_lock while there.

Anyway, I'll review the locking at the next version.

> >> +	get_task_comm(comm, current);
> >> +	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
> >> +		 comm, fd);  
> > 
> > Not sure if it is a good idea to store the task that allocated
> > the request. While it makes sense for the dev_dbg() below, it
> > may not make sense anymore on other dev_dbg() you would be
> > using it.  
> 
> This is actually copied from Laurent's code. I'm not sure either. I don't
> have enough experience with this yet to tell whether or not this is useful.

I remember a long time ago I considered using current task for
debugging. I ended by giving up, as separate tasks/threads could
be used internally by V4L2 apps. The same applies here. Also,
it seems overkill to me to always call get_task_comm() here, just
in case someone would ever enable a debug.

If the user wants the task, he can just enable it in realtime via
debugfs.

> >> +#ifdef CONFIG_MEDIA_CONTROLLER
> >> +static inline void media_request_object_get(struct media_request_object *obj)
> >> +{
> >> +	kref_get(&obj->kref);
> >> +}  
> > 
> > Why do you need a function? Just use kref_get() were needed, instead of
> > aliasing it for no good reason.  
> 
> Because that's what everyone does? That way you have nicely balanced
> media_request_object_get/put functions. Easier to review.

IMHO, having a kref_get()/kref_put() is a way easier to review, as
I know exactly where objects can be freed, but I can live with that.

Thanks,
Mauro
