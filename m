Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41722 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754718AbeEHMlL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 08:41:11 -0400
Date: Tue, 8 May 2018 09:41:03 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 03/28] media-request: implement media requests
Message-ID: <20180508094103.61b68552@vento.lan>
In-Reply-To: <20180508105233.kuuzas77w3s73xio@valkosipuli.retiisi.org.uk>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
        <20180503145318.128315-4-hverkuil@xs4all.nl>
        <20180504122750.bcmbhnwtpibd7425@valkosipuli.retiisi.org.uk>
        <20180508072116.265756e1@vento.lan>
        <20180508105233.kuuzas77w3s73xio@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 8 May 2018 13:52:33 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro, Hans,
> 
> On Tue, May 08, 2018 at 07:21:16AM -0300, Mauro Carvalho Chehab wrote:
> > Em Fri, 4 May 2018 15:27:50 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Hans,
> > > 
> > > I've read this patch a large number of times and I think also the details
> > > begin to seem sound. A few comments below.  
> > 
> > I'm sending this after analyzing the other patches in this series,
> > as this is the core of the changes. So, although I wrote the comments
> > early, I wanted to read first all other patches before sending it.
> >   
> > > 
> > > On Thu, May 03, 2018 at 04:52:53PM +0200, Hans Verkuil wrote:  
> > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > 
> > > > Add initial media request support:
> > > > 
> > > > 1) Add MEDIA_IOC_REQUEST_ALLOC ioctl support to media-device.c
> > > > 2) Add struct media_request to store request objects.
> > > > 3) Add struct media_request_object to represent a request object.
> > > > 4) Add MEDIA_REQUEST_IOC_QUEUE/REINIT ioctl support.
> > > > 
> > > > Basic lifecycle: the application allocates a request, adds
> > > > objects to it, queues the request, polls until it is completed
> > > > and can then read the final values of the objects at the time
> > > > of completion. When it closes the file descriptor the request
> > > > memory will be freed (actually, when the last user of that request
> > > > releases the request).
> > > > 
> > > > Drivers will bind an object to a request (the 'adds objects to it'
> > > > phase), when MEDIA_REQUEST_IOC_QUEUE is called the request is
> > > > validated (req_validate op), then queued (the req_queue op).
> > > > 
> > > > When done with an object it can either be unbound from the request
> > > > (e.g. when the driver has finished with a vb2 buffer) or marked as
> > > > completed (e.g. for controls associated with a buffer). When all
> > > > objects in the request are completed (or unbound), then the request
> > > > fd will signal an exception (poll).
> > > > 
> > > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>  
> > 
> > Hmm... As you're adding Copyrights from Intel/Google in this patch, that
> > indicates that part of the stuff you're adding here were authored by
> > others. So, you should use Co-developed-by: tag here, and get the SOBs
> > from the other developers that did part of the work[1].
> > 
> > [1] except if your work was sponsored by Cisco, Intel and Google, but
> >     I think this is not the case.  
> 
> I think this could be appropriate:
> 
>     Co-developed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>     Co-developed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>     Co-developed-by: Alexandre Courbot <acourbot@chromium.org>
> 
> ...
> 
> > > > +static long media_request_ioctl_queue(struct media_request *req)
> > > > +{
> > > > +	struct media_device *mdev = req->mdev;
> > > > +	enum media_request_state state;
> > > > +	unsigned long flags;
> > > > +	int ret = 0;    
> > > 
> > > ret is unconditionally assigned below, no need to initialise here.
> > >   
> > > > +
> > > > +	dev_dbg(mdev->dev, "request: queue %s\n", req->debug_str);
> > > > +
> > > > +	/*
> > > > +	 * Ensure the request that is validated will be the one that gets queued
> > > > +	 * next by serialising the queueing process. This mutex is also used
> > > > +	 * to serialize with canceling a vb2 queue and with setting values such
> > > > +	 * as controls in a request.
> > > > +	 */
> > > > +	mutex_lock(&mdev->req_queue_mutex);
> > > > +
> > > > +	spin_lock_irqsave(&req->lock, flags);
> > > > +	state = atomic_cmpxchg(&req->state, MEDIA_REQUEST_STATE_IDLE,
> > > > +			       MEDIA_REQUEST_STATE_VALIDATING);
> > > > +	spin_unlock_irqrestore(&req->lock, flags);  
> > 
> > It looks weird to serialize access to it with a mutex, a spin lock and 
> > an atomic call.  
> 
> req->lock is needed for state changes from idle to other states as also
> other struct members need to be serialised with that, with the request
> state. Which is kind of in line with my earlier point: there's little
> if any benefit in making this field atomic.

In this case, only req->state change is serialized - although atomic
also serializes it.

> The mutex is there to ensure only a single request remains in validating
> state, i.e. we will be changing the state of the device request tip one
> request at a time.

Better to add a comment explaining it.

> > 
> > IMHO, locking is still an issue here. I would love to test the 
> > locks with some tool that would randomize syscalls, issuing close(),
> > poll() and read() at wrong times and inverting the order of some calls, 
> > in order to do some empiric test that all locks are at the right places.
> > 
> > Complex locking schemas like that usually tend to cause a lot of
> > troubles.
> >   
> > > > +	if (state != MEDIA_REQUEST_STATE_IDLE) {
> > > > +		dev_dbg(mdev->dev,
> > > > +			"request: unable to queue %s, request in state %s\n",
> > > > +			req->debug_str, media_request_state_str(state));
> > > > +		mutex_unlock(&mdev->req_queue_mutex);
> > > > +		return -EBUSY;
> > > > +	}
> > > > +
> > > > +	ret = mdev->ops->req_validate(req);
> > > > +
> > > > +	/*
> > > > +	 * If the req_validate was successful, then we mark the state as QUEUED
> > > > +	 * and call req_queue. The reason we set the state first is that this
> > > > +	 * allows req_queue to unbind or complete the queued objects in case
> > > > +	 * they are immediately 'consumed'. State changes from QUEUED to another
> > > > +	 * state can only happen if either the driver changes the state or if
> > > > +	 * the user cancels the vb2 queue. The driver can only change the state
> > > > +	 * after each object is queued through the req_queue op (and note that
> > > > +	 * that op cannot fail), so setting the state to QUEUED up front is
> > > > +	 * safe.
> > > > +	 *
> > > > +	 * The other reason for changing the state is if the vb2 queue is
> > > > +	 * canceled, and that uses the req_queue_mutex which is still locked
> > > > +	 * while req_queue is called, so that's safe as well.
> > > > +	 */
> > > > +	atomic_set(&req->state,
> > > > +		   ret ? MEDIA_REQUEST_STATE_IDLE : MEDIA_REQUEST_STATE_QUEUED);  
> > 
> > Why are you changing state also when ret fails?
> > 
> > Also, why you had to use a spin lock earlier in this function just 
> > to change the req->state but you don't need to use it here?  
> 
> The reason is subtle: the operations that need spinlock protection can take
> place in request states other than "validating".

Sorry but I didn't get. Assuming that only req->state changes, it
should *either* use the spin lock or not. Doing it on some places
and not doing on others seems wrong.

Ok, if there are very good reasons why doing that, it should be 
documented, as people will see this as a mistake.

> 
> ...
> 
> > > > +/**
> > > > + * struct media_request_object_ops - Media request object operations
> > > > + * @prepare: Validate and prepare the request object, optional.
> > > > + * @unprepare: Unprepare the request object, optional.
> > > > + * @queue: Queue the request object, optional.
> > > > + * @unbind: Unbind the request object, optional.
> > > > + * @release: Release the request object, required.
> > > > + */
> > > > +struct media_request_object_ops {
> > > > +	int (*prepare)(struct media_request_object *object);
> > > > +	void (*unprepare)(struct media_request_object *object);
> > > > +	void (*queue)(struct media_request_object *object);
> > > > +	void (*unbind)(struct media_request_object *object);
> > > > +	void (*release)(struct media_request_object *object);
> > > > +};
> > > > +
> > > > +/**
> > > > + * struct media_request_object - An opaque object that belongs to a media
> > > > + *				 request
> > > > + *
> > > > + * @ops: object's operations
> > > > + * @priv: object's priv pointer
> > > > + * @req: the request this object belongs to (can be NULL)
> > > > + * @list: List entry of the object for @struct media_request
> > > > + * @kref: Reference count of the object, acquire before releasing req->lock
> > > > + * @completed: If true, then this object was completed.
> > > > + *
> > > > + * An object related to the request. This struct is embedded in the
> > > > + * larger object data.  
> > 
> > what do you mean by "the larger object data"? What struct is "the" struct?  
> 
> There is no particular type: the API offers generic binding of objects to a
> request. The objects are later retrieved when validating, queueing and
> implementing that request.

it if can be any type, then it should be saying instead something like: 

	"An object related to the request. This struct should be embedded
	 into a larger object data."

Thanks,
Mauro
