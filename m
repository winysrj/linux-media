Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55056 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750828AbcHKLSY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 07:18:24 -0400
Date: Thu, 11 Aug 2016 14:18:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] [media] v4l2-async: call registered_async after
 subdev registration
Message-ID: <20160811111817.GS3182@valkosipuli.retiisi.org.uk>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
 <1454699398-8581-3-git-send-email-javier@osg.samsung.com>
 <20160811111042.GQ3182@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160811111042.GQ3182@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 11, 2016 at 02:10:43PM +0300, Sakari Ailus wrote:
> Hi Javier,
> 
> On Fri, Feb 05, 2016 at 04:09:52PM -0300, Javier Martinez Canillas wrote:
> > V4L2 sub-devices might need to do initialization that depends on being
> > registered with a V4L2 device. As an example, sub-devices with Media
> > Controller support may need to register entities and create pad links.
> > 
> > Execute the registered_async callback after the sub-device has been
> > registered with the V4L2 device so the driver can do any needed init.
> > 
> > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-async.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 5bada202b2d3..716bfd47daab 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -119,6 +119,13 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
> >  		return ret;
> >  	}
> >  
> > +	ret = v4l2_subdev_call(sd, core, registered_async);
> > +	if (ret < 0) {
> > +		if (notifier->unbind)
> > +			notifier->unbind(notifier, sd, asd);
> > +		return ret;
> > +	}
> > +
> >  	if (list_empty(&notifier->waiting) && notifier->complete)
> >  		return notifier->complete(notifier);
> 
> I noticed this just now but what do you need this and the next patch for?
> 
> We already have a callback for the same purpose: it's
> v4l2_subdev_ops.internal_ops.registered(). And there's similar
> unregistered() callback as well.
> 
> Could you use these callbacks instead?
> 
> What made me notice this is because the two patches break all other drivers
> that do not implement registered_async(). This would be fixed by your
> follow-up patch which is not merged, but the real question is: are these
> patches needed to begin with?

Ah, it's actually merged now. So all is well. The question still remains.
:-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
