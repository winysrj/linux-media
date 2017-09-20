Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32275 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751751AbdITJqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 05:46:08 -0400
Date: Wed, 20 Sep 2017 12:42:28 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v13 14/25] v4l: async: Allow binding notifiers to
 sub-devices
Message-ID: <20170920094228.2sqweboecndi4z3u@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <3338675.o4HGi8X83V@avalon>
 <20170919151732.4yafxfcxrreizd7r@valkosipuli.retiisi.org.uk>
 <2127988.4UKDZnTvMM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2127988.4UKDZnTvMM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 08:52:56PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday, 19 September 2017 18:17:32 EEST Sakari Ailus wrote:
> > On Tue, Sep 19, 2017 at 04:52:29PM +0300, Laurent Pinchart wrote:
> > > On Friday, 15 September 2017 17:17:13 EEST Sakari Ailus wrote:
> > > > Registering a notifier has required the knowledge of struct v4l2_device
> > >> for the reason that sub-devices generally are registered to the
> > >> v4l2_device (as well as the media device, also available through
> > >> v4l2_device).
> > >> 
> > >> This information is not available for sub-device drivers at probe time.
> > >> 
> > >> What this patch does is that it allows registering notifiers without
> > >> having v4l2_device around. Instead the sub-device pointer is stored in
> > >> the notifier. Once the sub-device of the driver that registered the
> > >> notifier is registered, the notifier will gain the knowledge of the
> > >> v4l2_device, and the binding of async sub-devices from the sub-device
> > >> driver's notifier may proceed.
> > >> 
> > >> The root notifier's complete callback is only called when all sub-device
> > >> notifiers are completed.
> > > 
> > > This is a bit hard to review, shouldn't it be split in two patches, one
> > > that refactors the functions, and another one that allows binding
> > > notifiers to subdevs ?
> > > 
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >> ---
> > >> 
> > >>  drivers/media/v4l2-core/v4l2-async.c | 218 ++++++++++++++++++++++++-----
> > >>  include/media/v4l2-async.h           |  16 ++-
> > >>  2 files changed, 203 insertions(+), 31 deletions(-)
> > >> 
> > >> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > >> b/drivers/media/v4l2-core/v4l2-async.c index 4be2f16af051..52fe22b9b6b4
> > >> 100644
> > >> --- a/drivers/media/v4l2-core/v4l2-async.c
> > >> +++ b/drivers/media/v4l2-core/v4l2-async.c
> 
> [snip]
> 
> > >> +/* Unbind all sub-devices in the notifier tree. */
> > >> +static void v4l2_async_notifier_unbind_all_subdevs(
> > >> +	struct v4l2_async_notifier *notifier)
> > >> +{
> > >> +	struct v4l2_subdev *sd, *tmp;
> > >> 
> > >>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> > >> 
> > >> +		struct v4l2_async_notifier *subdev_notifier =
> > >> +			v4l2_async_find_subdev_notifier(sd);
> > >> +
> > >> +		if (subdev_notifier)
> > >> +			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> > >> +
> > >>  		v4l2_async_cleanup(sd);
> > >>  		
> > >>  		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
> > >> -	}
> > >> 
> > >> -	mutex_unlock(&list_lock);
> > >> +		list_del(&sd->async_list);
> > >> +		list_add(&sd->async_list, &subdev_list);
> > > 
> > > How about list_move() ?
> > 
> > Yeah.
> > 
> > > This seems to be new code, and by the look of it, I wonder whether it
> > > doesn't belong in the reprobing removal patch.
> > 
> > This is not related to re-probing. Here we're moving an async sub-device
> > back to the global sub-device list when its notifier is going away.
> 
> In order to make the subdev bindable again when the notifier will be re-
> registered. This wasn't needed before, as reprobing took care of that.

Ah, I see what you mean now. That the async sub-device is returned to the
global list?

I also noticed the sd shouldn't be set NULL except to the notifier this is
directly called on. I'll fix that as well.

> 
> > >> +	}
> > >> 
> > >> +	notifier->parent = NULL;
> > >> +	notifier->sd = NULL;
> > >>  	notifier->v4l2_dev = NULL;
> > >>  }
> 

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
