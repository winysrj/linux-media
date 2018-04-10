Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39196 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752587AbeDJNEN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 09:04:13 -0400
Date: Tue, 10 Apr 2018 16:04:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@google.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 04/29] media-request: core request support
Message-ID: <20180410130410.o4a2qdpnhent2kud@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-5-hverkuil@xs4all.nl>
 <CAAFQd5AwZZ3EXbOdpOrVMupDY8ZvzL0j0sPYxgFCicAY3tn9mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5AwZZ3EXbOdpOrVMupDY8ZvzL0j0sPYxgFCicAY3tn9mA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz and Hans,

On Tue, Apr 10, 2018 at 08:21:27AM +0000, Tomasz Figa wrote:
> > +void media_request_cancel(struct media_request *req)
> > +{
> > +       struct media_request_object *obj, *obj_safe;
> > +
> > +       if (req->state != MEDIA_REQUEST_STATE_QUEUED)
> > +               return;
> 
> I can see that media_request_release() guards the state change with
> req->lock. However we access the state here without holding the spinlock.

The driver is supposed to own a queued request so any serialisation is the
responsibility of the driver here. But I wouldn't mind taking a lock
either, it's safer.

> 
> Also, should we perhaps have MEDIA_REQUEST_STATE_CANCELLED (or maybe just
> reset to MEDIA_REQUEST_STATE_IDLE?), so that we can guard against calling
> this multiple times?
> 
> Or perhaps we're expecting this to be called with req_queue_mutex held?
> 
> > +
> > +       list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
> > +               if (obj->ops->cancel)
> > +                       obj->ops->cancel(obj);

Hans: how is cancel different from simply unbinding the object? I guess
we'll need precise definitions of what these ops mean.

Same question; should the request return to IDLE state here as well? Or an
error? I'd presume this is for a driver to cancel a request due to an error
of some sort.

...

> > +       spin_lock_irqsave(&req->lock, flags);
> > +       if (WARN_ON(req->state != MEDIA_REQUEST_STATE_IDLE))
> > +               goto unlock;
> > +       list_add_tail(&obj->list, &req->objects);
> > +       req->num_incomplete_objects++;
> > +unlock:
> > +       spin_unlock_irqrestore(&req->lock, flags);
> > +}
> > +EXPORT_SYMBOL_GPL(media_request_object_bind);
> > +
> > +void media_request_object_unbind(struct media_request_object *obj)
> > +{
> > +       struct media_request *req = obj->req;
> > +       unsigned long flags;
> > +       bool completed = false;
> > +
> > +       if (!req)
> > +               return;
> 
> No need for any locking here?

I wonder if WARN_ON() would be appropriate above.

Request objects, such as video buffers, can be bound and unbound multiple
times over the lifetime of the object. Video buffer state in this case
provides information whether the object is bound to a request (or not).

For objects the lifetime of which depends on the request only (controls?),
the bound request won't change until the object is unbound. The caller must
be aware of the state of the object, otherwise it could not meaningfully
unbind the object from a request.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
