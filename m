Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38206 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752194AbeDJLOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 07:14:32 -0400
Date: Tue, 10 Apr 2018 14:14:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 03/29] media-request: allocate media requests
Message-ID: <20180410111430.iuacaxpleiwfpzok@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-4-hverkuil@xs4all.nl>
 <20180410065239.7e1036d0@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410065239.7e1036d0@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Hans,

On Tue, Apr 10, 2018 at 06:52:39AM -0300, Mauro Carvalho Chehab wrote:
> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > index bcc6ec434f1f..07e323c57202 100644
> > --- a/include/media/media-device.h
> > +++ b/include/media/media-device.h
> > @@ -19,6 +19,7 @@
> >  #ifndef _MEDIA_DEVICE_H
> >  #define _MEDIA_DEVICE_H
> >  
> > +#include <linux/anon_inodes.h>
> 
> Why do you need it? I don't see anything below needing it.

This should be on the 4th patch actually. The .c file should suffice.

> 
> >  #include <linux/list.h>
> >  #include <linux/mutex.h>
> >  
> > @@ -27,6 +28,7 @@
> >  
> >  struct ida;
> >  struct device;
> > +struct media_device;
> >  
> >  /**
> >   * struct media_entity_notify - Media Entity Notify
> > @@ -50,10 +52,16 @@ struct media_entity_notify {
> >   * struct media_device_ops - Media device operations
> >   * @link_notify: Link state change notification callback. This callback is
> >   *		 called with the graph_mutex held.
> > + * @req_alloc: Allocate a request
> > + * @req_free: Free a request
> > + * @req_queue: Queue a request
> >   */
> >  struct media_device_ops {
> >  	int (*link_notify)(struct media_link *link, u32 flags,
> >  			   unsigned int notification);
> > +	struct media_request *(*req_alloc)(struct media_device *mdev);
> > +	void (*req_free)(struct media_request *req);
> > +	int (*req_queue)(struct media_request *req);
> >  };
> >  
> >  /**
> > @@ -88,6 +96,8 @@ struct media_device_ops {
> >   * @disable_source: Disable Source Handler function pointer
> >   *
> >   * @ops:	Operation handler callbacks
> > + * @req_lock:	Serialise access to requests
> > + * @req_queue_mutex: Serialise validating and queueing requests
> 
> IMHO, this would better describe it:
> 	Serialise validate and queue requests
> 
> Yet, IMO, it doesn't let it clear when the spin lock should be
> used and when the mutex should be used.
> 
> I mean, what of them protect what variable?

It might not be obvious, but the purpose of this mutex is to prevent
queueing multiple requests simultaneously in order to serialise access to
the top of the queue. How about this instead:

	Serialise access to accessing device state on the tail of the
	request queue.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
