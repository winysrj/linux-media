Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46404 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751020AbdIMI3F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 04:29:05 -0400
Date: Wed, 13 Sep 2017 11:29:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v12 15/26] v4l: async: Allow binding notifiers to
 sub-devices
Message-ID: <20170913082901.fbxxphn7s3ljn3mc@valkosipuli.retiisi.org.uk>
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
 <20170912134200.19556-16-sakari.ailus@linux.intel.com>
 <575bf15b-62d2-3a51-d550-d462578471f7@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <575bf15b-62d2-3a51-d550-d462578471f7@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Sep 13, 2017 at 09:17:08AM +0200, Hans Verkuil wrote:
> On 09/12/2017 03:41 PM, Sakari Ailus wrote:
> > Registering a notifier has required the knowledge of struct v4l2_device
> > for the reason that sub-devices generally are registered to the
> > v4l2_device (as well as the media device, also available through
> > v4l2_device).
> > 
> > This information is not available for sub-device drivers at probe time.
> > 
> > What this patch does is that it allows registering notifiers without
> > having v4l2_device around. Instead the sub-device pointer is stored in the
> > notifier. Once the sub-device of the driver that registered the notifier
> > is registered, the notifier will gain the knowledge of the v4l2_device,
> > and the binding of async sub-devices from the sub-device driver's notifier
> > may proceed.
> > 
> > The root notifier's complete callback is only called when all sub-device
> > notifiers are completed.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Just two small comments (see below).
> 
> After changing those (the first is up to you) you can add my:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks; please see my comments below.

...

> > +/* Return true if all sub-device notifiers are complete, false otherwise. */
> > +static bool v4l2_async_subdev_notifiers_complete(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_subdev *sd;
> > +
> > +	if (!list_empty(&notifier->waiting))
> > +		return false;
> > +
> > +	list_for_each_entry(sd, &notifier->done, async_list) {
> > +		struct v4l2_async_notifier *subdev_notifier =
> > +			v4l2_async_find_subdev_notifier(sd);
> > +
> > +		if (!subdev_notifier)
> > +			continue;
> > +
> > +		if (!v4l2_async_subdev_notifiers_complete(subdev_notifier))
> 
> I think it is better to change this to:
> 
> 		if (subdev_notifier &&
> 		    !v4l2_async_subdev_notifiers_complete(subdev_notifier))
> 
> and drop this if..continue above. That's a bit overkill in this simple case.
> 
> It's up to you, though.

Yes, makes sense.

...

> > +/* Try completing a notifier. */
> > +static int v4l2_async_notifier_try_complete(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	do {
> > +		int ret;
> > +
> > +		/* Any local async sub-devices left? */
> > +		if (!list_empty(&notifier->waiting))
> > +			return 0;
> > +
> > +		/*
> > +		 * Any sub-device notifiers waiting for async subdevs
> > +		 * to be bound?
> > +		 */
> > +		if (!v4l2_async_subdev_notifiers_complete(notifier))
> > +			return 0;
> > +
> > +		/* Proceed completing the notifier */
> > +		ret = v4l2_async_notifier_call_complete(notifier);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		/*
> > +		 * Obtain notifier's parent. If there is one, repeat
> > +		 * the process, otherwise we're done here.
> > +		 */
> > +	} while ((notifier = notifier->parent));
> 
> I'd change this to:
> 
> 		notifier = notifier->parent;
> 	} while (notifier);
> 
> Assignment in a condition is frowned upon, and there is no need to do that
> here.

Wouldn't that equally apply to any statement with side effects? In other
words, what you're suggesting for patch 19? :-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
