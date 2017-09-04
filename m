Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59518 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753764AbdIDQJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 12:09:03 -0400
Date: Mon, 4 Sep 2017 19:09:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v7 10/18] v4l: async: Introduce macros for calling async
 ops callbacks
Message-ID: <20170904160900.n7itc23b4xydrdn5@valkosipuli.retiisi.org.uk>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-11-sakari.ailus@linux.intel.com>
 <96c4a9cf-1231-b6c4-bc2b-a431f4bea7a4@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96c4a9cf-1231-b6c4-bc2b-a431f4bea7a4@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Sep 04, 2017 at 03:50:52PM +0200, Hans Verkuil wrote:
> On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> > Add two macros to call async operations callbacks. Besides simplifying
> > callbacks, this allows async notifiers to have no ops set, i.e. it can be
> > left NULL.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 19 +++++++------------
> >  include/media/v4l2-async.h           |  8 ++++++++
> >  2 files changed, 15 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 810f5e0273dc..91d04f00b4e4 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -107,16 +107,13 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
> >  {
> >  	int ret;
> >  
> > -	if (notifier->ops->bound) {
> > -		ret = notifier->ops->bound(notifier, sd, asd);
> > -		if (ret < 0)
> > -			return ret;
> > -	}
> > +	ret = v4l2_async_notifier_call_int_op(notifier, bound, sd, asd);
> 
> Hmm, I think this is rather ugly. We only have three ops, so why not make
> three macros:
> 
> 	v4l2_async_notifier_call_bound/unbind/complete?
> 
> Much cleaner than _int_op(...bound...).

Works for me.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
