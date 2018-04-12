Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56258 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752125AbeDLKk5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 06:40:57 -0400
Date: Thu, 12 Apr 2018 13:40:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 05/29] media-request: add request ioctls
Message-ID: <20180412104055.cusncz3d6llpwblp@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-6-hverkuil@xs4all.nl>
 <20180410075756.3975ed22@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410075756.3975ed22@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Apr 10, 2018 at 07:57:56AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon,  9 Apr 2018 16:20:02 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Implement the MEDIA_REQUEST_IOC_QUEUE and MEDIA_REQUEST_IOC_REINIT
> > ioctls.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/media-request.c | 80 +++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 78 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> > index dffc290e4ada..27739ff7cb09 100644
> > --- a/drivers/media/media-request.c
> > +++ b/drivers/media/media-request.c
> > @@ -118,10 +118,86 @@ static unsigned int media_request_poll(struct file *filp,
> >  	return 0;
> >  }
> >  
> > +static long media_request_ioctl_queue(struct media_request *req)
> > +{
> > +	struct media_device *mdev = req->mdev;
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	dev_dbg(mdev->dev, "request: queue %s\n", req->debug_str);
> > +
> > +	spin_lock_irqsave(&req->lock, flags);
> > +	if (req->state != MEDIA_REQUEST_STATE_IDLE) {
> > +		dev_dbg(mdev->dev,
> > +			"request: unable to queue %s, request in state %s\n",
> > +			req->debug_str, media_request_state_str(req->state));
> > +		spin_unlock_irqrestore(&req->lock, flags);
> > +		return -EINVAL;
> > +	}
> > +	req->state = MEDIA_REQUEST_STATE_QUEUEING;
> > +
> > +	spin_unlock_irqrestore(&req->lock, flags);
> > +
> > +	/*
> > +	 * Ensure the request that is validated will be the one that gets queued
> > +	 * next by serialising the queueing process.
> > +	 */
> > +	mutex_lock(&mdev->req_queue_mutex);
> 
> The locking here seems really weird. IMHO, it should lock before
> touching state, as otherwise race conditions may happen.
> 
> As I suggested before, I would use an atomic type for state, and get rid
> of the spin lock (as it seems that it is meant to be used just
> for state).

The new request state depends on the old state; I don't think you can
meaningfully do that using the atomic API.

> 
> > +
> > +	ret = mdev->ops->req_queue(req);
> > +	spin_lock_irqsave(&req->lock, flags);
> > +	req->state = ret ? MEDIA_REQUEST_STATE_IDLE : MEDIA_REQUEST_STATE_QUEUED;
> > +	spin_unlock_irqrestore(&req->lock, flags);
> > +	mutex_unlock(&mdev->req_queue_mutex);
> > +
> 
> Here, you have both mutex and spin locked. This is a strong indication
> that locks are not well designed, are you're using two different locks
> to protect the same data.

Not the same, it's different data. What is no longer visible in this
patchset is how request objects are referenced in a request. Effectively
that part is missing altogether. It will be needed when adding support for
objects that are not managed through the V4L2 framework such as pixel
formats or selection rectangles.

You could move the serialisation of queueing requests to drivers altogether
but I don't think that'd be a wise choice: the device state at request
queue head will need to be maintained so that queued requests can be
validated against it (right now validation is embedded in queueing).
Failing validation will result into restoring the previous state.

I had an implementation of that in my previous request set here:

<URL:https://www.spinics.net/lists/linux-media/msg130994.html>

We'll implement it but not yet: right now there's just a need for buffers
and controls. Still, knowing where we're going I'd keep the mutex where it
is.

> > +static long media_request_ioctl_reinit(struct media_request *req)
> > +{
> > +	struct media_device *mdev = req->mdev;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&req->lock, flags);
> > +	if (req->state != MEDIA_REQUEST_STATE_IDLE &&
> > +	    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
> > +		dev_dbg(mdev->dev,
> > +			"request: %s not in idle or complete state, cannot reinit\n",
> > +			req->debug_str);
> > +		spin_unlock_irqrestore(&req->lock, flags);
> > +		return -EINVAL;
> > +	}
> > +	req->state = MEDIA_REQUEST_STATE_CLEANING;
> > +	spin_unlock_irqrestore(&req->lock, flags);
> > +
> > +	media_request_clean(req);
> > +
> > +	spin_lock_irqsave(&req->lock, flags);
> > +	req->state = MEDIA_REQUEST_STATE_IDLE;
> > +	spin_unlock_irqrestore(&req->lock, flags);
> 
> This code should be called with the mutex hold.

That's not necessary. A request which is being re-initialised was in an
idle or complete state; nothing of that request is bound to the current
device state in any way. Therefore the objects in that request can be
simply thrown out.

The state change to CLEANING is there to prevent the request being e.g.
queued during the cleaning.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
