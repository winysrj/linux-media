Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39716 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752898AbeDJOvw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 10:51:52 -0400
Date: Tue, 10 Apr 2018 11:51:43 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 04/29] media-request: core request support
Message-ID: <20180410115143.41178f68@vento.lan>
In-Reply-To: <20180410123234.ifo6v23wztsslmdp@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-5-hverkuil@xs4all.nl>
        <20180410073206.12d4c67d@vento.lan>
        <20180410123234.ifo6v23wztsslmdp@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Apr 2018 15:32:34 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro and Hans,
> 
> On Tue, Apr 10, 2018 at 07:32:06AM -0300, Mauro Carvalho Chehab wrote:
> ...
> > > +static void media_request_release(struct kref *kref)
> > > +{
> > > +	struct media_request *req =
> > > +		container_of(kref, struct media_request, kref);
> > > +	struct media_device *mdev = req->mdev;
> > > +	unsigned long flags;
> > > +
> > > +	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
> > > +
> > > +	spin_lock_irqsave(&req->lock, flags);
> > > +	req->state = MEDIA_REQUEST_STATE_CLEANING;
> > > +	spin_unlock_irqrestore(&req->lock, flags);
> > > +
> > > +	media_request_clean(req);
> > > +
> > > +	if (mdev->ops->req_free)
> > > +		mdev->ops->req_free(req);
> > > +	else
> > > +		kfree(req);  
> > 
> > Without looking at req_free() implementation, I would actually prefer
> > to always do a kfree(req) here. So, a req_free() function would only
> > free "extra" allocations, and not the request itself. e. g.:
> > 
> > ...
> > 	if (mdev->ops->req_free)
> > 		mdev->ops->req_free(req);
> > 
> > 	kfree(req);
> > }  
> 
> The idea is that you can embed the request object in a driver specific
> struct. The drivers can store information related to that request rather
> easily that way, without requiring to be aware of two objects with
> references pointing to each other. I rather prefer the current
> implementation. It same pattern is actually used on videobuf2 buffers.

Ok, then document it so.

Btw, one of the things it is missing is a kAPI documentation patch,
describing things like that.

> 
> ...
> 
> > > +static unsigned int media_request_poll(struct file *filp,
> > > +				       struct poll_table_struct *wait)
> > > +{
> > > +	struct media_request *req = filp->private_data;
> > > +	unsigned long flags;
> > > +	enum media_request_state state;
> > > +
> > > +	if (!(poll_requested_events(wait) & POLLPRI))
> > > +		return 0;
> > > +
> > > +	spin_lock_irqsave(&req->lock, flags);
> > > +	state = req->state;
> > > +	spin_unlock_irqrestore(&req->lock, flags);  
> > 
> > IMO, it would be better to use an atomic var for state, having a
> > lockless access to it.  
> 
> The lock serialises access to the whole request, not just to its state.

>From what I understood at the code is that the spin lock
is used *sometimes* to protect just the state. I didn't
see it used to protect the hole data struct.

Instead, the mutex is used for that purpose, but, again,
it is *sometimes* used, but on several parts, neither the
spin lock nor the mutex is used.

It should be noticed that the data, itself, should be protected
by *either* mutex or spin lock.

> While it doesn't matter here as you're just reading the state, writing it
> would still require taking the lock. Using atomic_t might suggest
> otherwise, and could end up being a source of bugs.

There are already a lot of bugs at the locking, from what I noticed.

We should do it right: it should use *just one* kind of memory
protection for struct media_request. On the places where it is
safe to just read the status without locking, atomic_t() should
be used. Where it doesn't, probably the entire code should be
protected by the lock.

> >   
> > > +
> > > +	if (state == MEDIA_REQUEST_STATE_COMPLETE)
> > > +		return POLLPRI;
> > > +	if (state == MEDIA_REQUEST_STATE_IDLE)
> > > +		return POLLERR;
> > > +
> > > +	poll_wait(filp, &req->poll_wait, wait);
> > > +	return 0;
> > > +}
> > > +
> > > +static long media_request_ioctl(struct file *filp, unsigned int cmd,
> > > +				unsigned long __arg)
> > > +{
> > > +	return -ENOIOCTLCMD;
> > > +}
> > > +
> > > +static const struct file_operations request_fops = {
> > > +	.owner = THIS_MODULE,
> > > +	.poll = media_request_poll,
> > > +	.unlocked_ioctl = media_request_ioctl,
> > > +	.release = media_request_close,
> > > +};
> > > +
> > >  int media_request_alloc(struct media_device *mdev,
> > >  			struct media_request_alloc *alloc)
> > >  {
> > > -	return -ENOMEM;
> > > +	struct media_request *req;
> > > +	struct file *filp;
> > > +	char comm[TASK_COMM_LEN];
> > > +	int fd;
> > > +	int ret;
> > > +
> > > +	fd = get_unused_fd_flags(O_CLOEXEC);
> > > +	if (fd < 0)
> > > +		return fd;
> > > +
> > > +	filp = anon_inode_getfile("request", &request_fops, NULL, O_CLOEXEC);
> > > +	if (IS_ERR(filp)) {
> > > +		ret = PTR_ERR(filp);
> > > +		goto err_put_fd;
> > > +	}
> > > +
> > > +	if (mdev->ops->req_alloc)
> > > +		req = mdev->ops->req_alloc(mdev);
> > > +	else
> > > +		req = kzalloc(sizeof(*req), GFP_KERNEL);
> > > +	if (!req) {
> > > +		ret = -ENOMEM;
> > > +		goto err_fput;
> > > +	}
> > > +
> > > +	filp->private_data = req;
> > > +	req->mdev = mdev;
> > > +	req->state = MEDIA_REQUEST_STATE_IDLE;
> > > +	req->num_incomplete_objects = 0;
> > > +	kref_init(&req->kref);
> > > +	INIT_LIST_HEAD(&req->objects);
> > > +	spin_lock_init(&req->lock);
> > > +	init_waitqueue_head(&req->poll_wait);
> > > +
> > > +	alloc->fd = fd;  
> > 
> > Btw, this is a very good reason why you should define the ioctl to
> > have an integer argument instead of a struct with a __s32 field
> > on it, as per my comment to patch 02/29:
> > 
> > 	#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, int)
> > 
> > At 64 bit architectures, you're truncating the file descriptor!  
> 
> I'm not quite sure what do you mean. int is 32 bits on 64-bit systems as
> well.

Hmm.. you're right. I was thinking that it could be 64 bits on some
archs like sparc64 (Tru64 C compiler declares it with 64 bits), but,
according with:

	https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html

This is not the case on gcc.

> We actually replaced int by __s32 or __u32 everywhere in uAPI (apart from
> one particular struct; time to send a patch) about five years ago.
> 
> >   
> > > +	get_task_comm(comm, current);
> > > +	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
> > > +		 comm, fd);  
> > 
> > Not sure if it is a good idea to store the task that allocated
> > the request. While it makes sense for the dev_dbg() below, it
> > may not make sense anymore on other dev_dbg() you would be
> > using it.  
> 
> The lifetime of the file handle roughly matches that of the request. It's
> for debug only anyway.
> 
> Better proposals are always welcome of course. But I think we should have
> something here that helps debugging by meaningfully making the requests
> identifiable from logs.

What I meant to say is that one PID could be allocating the
request, while some other one could be actually doing Q/DQ_BUF.
On such scenario, the debug string could provide mislead prints.

> 
> ...
> 
> > > +#ifdef CONFIG_MEDIA_CONTROLLER
> > > +static inline void media_request_object_get(struct media_request_object *obj)
> > > +{
> > > +	kref_get(&obj->kref);
> > > +}  
> > 
> > Why do you need a function? Just use kref_get() were needed, instead of
> > aliasing it for no good reason.  
> 
> We have similar functions for get and put in many places in the kernel. If
> this were a static function only used in a single .c file, I'd most likely
> agree. Here it avoids having to know the internals of request objects
> elsewhere.
> 
> I wonder if this could be moved to the .c file actually; I haven't looked
> at the other patches.
> 



Thanks,
Mauro
