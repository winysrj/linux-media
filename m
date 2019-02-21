Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B99C4360F
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 23:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7269F20818
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 23:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfBUXtp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:49:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:18533 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfBUXtp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 18:49:45 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2019 15:49:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,397,1544515200"; 
   d="scan'208";a="145514176"
Received: from oliviapo-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.44.84])
  by fmsmga002.fm.intel.com with ESMTP; 21 Feb 2019 15:49:42 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 1909E21D81; Fri, 22 Feb 2019 01:49:37 +0200 (EET)
Date:   Fri, 22 Feb 2019 01:49:36 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190221234936.pbbymgzmqrv7ypje@kekkonen.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190115235145.GF31088@pendragon.ideasonboard.com>
 <20190221145920.7w7mynzhdwln4drb@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190221145920.7w7mynzhdwln4drb@uno.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Thu, Feb 21, 2019 at 03:59:20PM +0100, Jacopo Mondi wrote:
> Hi Sakari, Laurent, Niklas,
>    (another) quick question, but a different one :)
> 
> On Wed, Jan 16, 2019 at 01:51:45AM +0200, Laurent Pinchart wrote:
> > Hi Niklas,
> >
> > Thank you for the patch.
> >
> > On Fri, Nov 02, 2018 at 12:31:30AM +0100, Niklas Söderlund wrote:
> > > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > >
> > > - Add sink and source streams for multiplexed links
> > > - Copy the argument back in case of an error. This is needed to let the
> > >   caller know the number of routes.
> > >
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >  drivers/media/v4l2-core/v4l2-ioctl.c  | 20 +++++++++++++-
> > >  drivers/media/v4l2-core/v4l2-subdev.c | 28 +++++++++++++++++++
> > >  include/media/v4l2-subdev.h           |  7 +++++
> > >  include/uapi/linux/v4l2-subdev.h      | 40 +++++++++++++++++++++++++++
> >
> > Missing documentation :-(
> >
> > >  4 files changed, 94 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > index 7de041bae84fb2f2..40406acb51ec0906 100644
> > > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > @@ -19,6 +19,7 @@
> > >  #include <linux/kernel.h>
> > >  #include <linux/version.h>
> > >
> > > +#include <linux/v4l2-subdev.h>
> > >  #include <linux/videodev2.h>
> > >
> > >  #include <media/v4l2-common.h>
> > > @@ -2924,6 +2925,23 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
> > >  		}
> > >  		break;
> > >  	}
> > > +
> > > +	case VIDIOC_SUBDEV_G_ROUTING:
> > > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > > +		struct v4l2_subdev_routing *route = parg;
> > > +
> > > +		if (route->num_routes > 0) {
> > > +			if (route->num_routes > 256)
> > > +				return -EINVAL;
> > > +
> > > +			*user_ptr = (void __user *)route->routes;
> > > +			*kernel_ptr = (void *)&route->routes;
> > > +			*array_size = sizeof(struct v4l2_subdev_route)
> > > +				    * route->num_routes;
> > > +			ret = 1;
> > > +		}
> > > +		break;
> > > +	}
> > >  	}
> > >
> > >  	return ret;
> > > @@ -3033,7 +3051,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
> > >  	 * Some ioctls can return an error, but still have valid
> > >  	 * results that must be returned.
> > >  	 */
> > > -	if (err < 0 && !always_copy)
> > > +	if (err < 0 && !always_copy && cmd != VIDIOC_SUBDEV_G_ROUTING)
> >
> > This seems like a hack. Shouldn't VIDIOC_SUBDEV_G_ROUTING set
> > always_copy instead ?
> >
> > >  		goto out;
> > >
> > >  out_array_args:
> > > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> > > index 792f41dffe2329b9..1d3b37cf548fa533 100644
> > > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > > @@ -516,7 +516,35 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> > >
> > >  	case VIDIOC_SUBDEV_QUERYSTD:
> > >  		return v4l2_subdev_call(sd, video, querystd, arg);
> > > +
> > > +	case VIDIOC_SUBDEV_G_ROUTING:
> > > +		return v4l2_subdev_call(sd, pad, get_routing, arg);
> > > +
> > > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > > +		struct v4l2_subdev_routing *route = arg;
> > > +		unsigned int i;
> > > +
> > > +		if (route->num_routes > sd->entity.num_pads)
> > > +			return -EINVAL;
> > > +
> > > +		for (i = 0; i < route->num_routes; ++i) {
> 
> How have you envisioned the number of routes to be negotiated with
> applications? I'm writing the documentation for this ioctl, and I
> would like to insert this part as well.
> 
> Would a model like the one implemented in G_TOPOLOGY work in your
> opinion? In my understanding, at the moment applications do not have a
> way to reserve a known number of routes entries, but would likely
> reserve 'enough(tm)' (ie 256) and pass them to the G_ROUTING ioctl that the
> first time will likely adjust the number of num_routes and return -ENOSPC.
> 
> Wouldn't it work to make the IOCTL behave in a way that it
> expects the first call to be performed with (num_routes == 0) and no routes
> entries reserved, and just adjust 'num_routes' in that case?
> So that applications should call G_ROUTING a first time with
> num_routes = 0, get back the number of routes entries, reserve memory
> for them, and then call G_ROUTING again to have the entries populated
> by the driver. Do you have different ideas or was this the intended
> behavior already?

I think whenever the number of routes isn't enough to return them all, the
IOCTL should return -ENOSPC, and set the actual number of routes there. Not
just zero. The user could e.g. try with a static allocation of some, and
allocate memory if the static allocation turns not to be enough.

Btw. the idea behind S_ROUTING behaviour was to allow multiple users to
work on a single sub-device without having to know about each other. That's
why there are flags to tell which routes are enabled and which are not.

I'll be better available tomorrow, let's discuss e.g. on #v4l then.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
