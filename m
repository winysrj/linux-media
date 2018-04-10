Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63446 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751849AbeDJJyn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 05:54:43 -0400
Date: Tue, 10 Apr 2018 06:54:37 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Tomasz Figa <tfiga@google.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 03/29] media-request: allocate media requests
Message-ID: <20180410065419.37d24e74@vento.lan>
In-Reply-To: <CAAFQd5D4b2=cAM+64Oyt=8VEhxevyZ=rJjgZK7Eds_+du9uOEw@mail.gmail.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-4-hverkuil@xs4all.nl>
        <CAAFQd5D4b2=cAM+64Oyt=8VEhxevyZ=rJjgZK7Eds_+du9uOEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Apr 2018 05:35:37 +0000
Tomasz Figa <tfiga@google.com> escreveu:

> Hi Hans,
> 
> On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> [snip]
> > diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> > new file mode 100644
> > index 000000000000..ead78613fdbe
> > --- /dev/null
> > +++ b/drivers/media/media-request.c
> > @@ -0,0 +1,23 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Media device request objects
> > + *
> > + * Copyright (C) 2018 Intel Corporation
> > + * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.  
> 
> I'm not sure about the origin of this line, but it's not a correct
> copyright for kernel code produced as a part of Chrome OS project. It would
> normally be something like
> 
> Copyright (C) 2018 Google, Inc.

Also, it sounds a lot of copyright for a file with just stub :-)

> 
> > + *
> > + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> > + */
> > +
> > +#include <linux/anon_inodes.h>
> > +#include <linux/file.h>
> > +#include <linux/mm.h>
> > +#include <linux/string.h>
> > +
> > +#include <media/media-device.h>
> > +#include <media/media-request.h>
> > +
> > +int media_request_alloc(struct media_device *mdev,
> > +                       struct media_request_alloc *alloc)
> > +{
> > +       return -ENOMEM;
> > +}
> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > index bcc6ec434f1f..07e323c57202 100644
> > --- a/include/media/media-device.h
> > +++ b/include/media/media-device.h
> > @@ -19,6 +19,7 @@
> >   #ifndef _MEDIA_DEVICE_H
> >   #define _MEDIA_DEVICE_H  
> 
> > +#include <linux/anon_inodes.h>  
> 
> What is the need for anon_inodes in this header?
> 
> >   #include <linux/list.h>
> >   #include <linux/mutex.h>  
> 
> > @@ -27,6 +28,7 @@  
> 
> >   struct ida;
> >   struct device;
> > +struct media_device;  
> 
> >   /**
> >    * struct media_entity_notify - Media Entity Notify
> > @@ -50,10 +52,16 @@ struct media_entity_notify {
> >    * struct media_device_ops - Media device operations
> >    * @link_notify: Link state change notification callback. This callback  
> is
> >    *              called with the graph_mutex held.
> > + * @req_alloc: Allocate a request
> > + * @req_free: Free a request
> > + * @req_queue: Queue a request
> >    */
> >   struct media_device_ops {
> >          int (*link_notify)(struct media_link *link, u32 flags,
> >                             unsigned int notification);
> > +       struct media_request *(*req_alloc)(struct media_device *mdev);
> > +       void (*req_free)(struct media_request *req);
> > +       int (*req_queue)(struct media_request *req);
> >   };  
> 
> >   /**
> > @@ -88,6 +96,8 @@ struct media_device_ops {
> >    * @disable_source: Disable Source Handler function pointer
> >    *
> >    * @ops:       Operation handler callbacks
> > + * @req_lock:  Serialise access to requests
> > + * @req_queue_mutex: Serialise validating and queueing requests  
> 
> Let's bikeshed a bit! "access" sounds like a superset of "validating and
> queuing" to me. Perhaps it could make sense to be a bit more specific on
> what type of access the spinlock is used for?
> 
> Best regards,
> Tomasz



Thanks,
Mauro
