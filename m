Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49426 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750922AbdIKIVp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 04:21:45 -0400
Date: Mon, 11 Sep 2017 11:21:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        linux-acpi@vger.kernel.org, mika.westerberg@intel.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v9 13/24] v4l: async: Allow async notifier register call
 succeed with no subdevs
Message-ID: <20170911082140.ejsajh6zq2kfdxn2@valkosipuli.retiisi.org.uk>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-9-sakari.ailus@linux.intel.com>
 <beb494e4-44f7-2eec-8d24-8d92e23dafd2@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beb494e4-44f7-2eec-8d24-8d92e23dafd2@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 11, 2017 at 10:05:40AM +0200, Hans Verkuil wrote:
> On 09/08/2017 03:18 PM, Sakari Ailus wrote:
> > The information on how many async sub-devices would be bindable to a
> > notifier is typically dependent on information from platform firmware and
> > it's not driver's business to be aware of that.
> > 
> > Many V4L2 main drivers are perfectly usable (and useful) without async
> > sub-devices and so if there aren't any around, just proceed call the
> > notifier's complete callback immediately without registering the notifier
> > itself.
> > 
> > If a driver needs to check whether there are async sub-devices available,
> > it can be done by inspecting the notifier's num_subdevs field which tells
> > the number of async sub-devices.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 7b396ff4302b..9ebc2e079d03 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -170,10 +170,12 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  	struct v4l2_async_subdev *asd;
> >  	int i;
> >  
> > -	if (!v4l2_dev || !notifier->num_subdevs ||
> > -	    notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> > +	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> >  		return -EINVAL;
> >  
> > +	if (!notifier->num_subdevs)
> > +		return v4l2_async_notifier_call_complete(notifier);
> > +
> 
> I would move this 'if' down to after the next three lines...
> 
> >  	notifier->v4l2_dev = v4l2_dev;
> >  	INIT_LIST_HEAD(&notifier->waiting);
> >  	INIT_LIST_HEAD(&notifier->done);
> > 
> 
> ...that way the notifier struct is properly initialized. Just in case anyone
> ever looks at these three fields.

Makes sense. Fixed.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
