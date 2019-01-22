Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC943C282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 16:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971E320870
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 16:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfAVQPB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:15:01 -0500
Received: from mga07.intel.com ([134.134.136.100]:32754 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbfAVQPB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 11:15:01 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 08:15:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,507,1539673200"; 
   d="scan'208";a="108858443"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga007.jf.intel.com with ESMTP; 22 Jan 2019 08:14:58 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id D84C1205C8; Tue, 22 Jan 2019 18:14:57 +0200 (EET)
Date:   Tue, 22 Jan 2019 18:14:57 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190122161457.gzkngziyixsef7qo@paasikivi.fi.intel.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190115235145.GF31088@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115235145.GF31088@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 01:51:45AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:30AM +0100, Niklas Söderlund wrote:
> > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > 
> > - Add sink and source streams for multiplexed links
> > - Copy the argument back in case of an error. This is needed to let the
> >   caller know the number of routes.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/v4l2-core/v4l2-ioctl.c  | 20 +++++++++++++-
> >  drivers/media/v4l2-core/v4l2-subdev.c | 28 +++++++++++++++++++
> >  include/media/v4l2-subdev.h           |  7 +++++
> >  include/uapi/linux/v4l2-subdev.h      | 40 +++++++++++++++++++++++++++
> 
> Missing documentation :-(
> 
> >  4 files changed, 94 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > index 7de041bae84fb2f2..40406acb51ec0906 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/version.h>
> >  
> > +#include <linux/v4l2-subdev.h>
> >  #include <linux/videodev2.h>
> >  
> >  #include <media/v4l2-common.h>
> > @@ -2924,6 +2925,23 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
> >  		}
> >  		break;
> >  	}
> > +
> > +	case VIDIOC_SUBDEV_G_ROUTING:
> > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > +		struct v4l2_subdev_routing *route = parg;
> > +
> > +		if (route->num_routes > 0) {
> > +			if (route->num_routes > 256)
> > +				return -EINVAL;
> > +
> > +			*user_ptr = (void __user *)route->routes;
> > +			*kernel_ptr = (void *)&route->routes;
> > +			*array_size = sizeof(struct v4l2_subdev_route)
> > +				    * route->num_routes;
> > +			ret = 1;
> > +		}
> > +		break;
> > +	}
> >  	}
> >  
> >  	return ret;
> > @@ -3033,7 +3051,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
> >  	 * Some ioctls can return an error, but still have valid
> >  	 * results that must be returned.
> >  	 */
> > -	if (err < 0 && !always_copy)
> > +	if (err < 0 && !always_copy && cmd != VIDIOC_SUBDEV_G_ROUTING)
> 
> This seems like a hack. Shouldn't VIDIOC_SUBDEV_G_ROUTING set
> always_copy instead ?

Sub-device IOCTLs are partially handled in v4l2-subdev.c, not here. In
particular, __video_do_ioctl() that digs that information from v4l2_ioctls
array is not in the call path for sub-device IOCTLs. So, it'd take a
refactoring of IOCTL handling to change this, which I think should be a
different patchset --- we're already at 30 patches here.

> 
> >  		goto out;
> >  
> >  out_array_args:
> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> > index 792f41dffe2329b9..1d3b37cf548fa533 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -516,7 +516,35 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> >  
> >  	case VIDIOC_SUBDEV_QUERYSTD:
> >  		return v4l2_subdev_call(sd, video, querystd, arg);
> > +
> > +	case VIDIOC_SUBDEV_G_ROUTING:
> > +		return v4l2_subdev_call(sd, pad, get_routing, arg);
> > +
> > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > +		struct v4l2_subdev_routing *route = arg;
> > +		unsigned int i;
> > +
> > +		if (route->num_routes > sd->entity.num_pads)
> > +			return -EINVAL;
> > +
> > +		for (i = 0; i < route->num_routes; ++i) {
> > +			unsigned int sink = route->routes[i].sink_pad;
> > +			unsigned int source = route->routes[i].source_pad;
> > +			struct media_pad *pads = sd->entity.pads;
> > +
> > +			if (sink >= sd->entity.num_pads ||
> > +			    source >= sd->entity.num_pads)
> > +				return -EINVAL;
> > +
> > +			if (!(pads[sink].flags & MEDIA_PAD_FL_SINK) ||
> > +			    !(pads[source].flags & MEDIA_PAD_FL_SOURCE))
> > +				return -EINVAL;
> > +		}
> > +
> > +		return v4l2_subdev_call(sd, pad, set_routing, route);
> > +	}
> >  #endif
> > +
> >  	default:
> >  		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> >  	}
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 9102d6ca566e01f2..5acaeeb9b3cacefa 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -679,6 +679,9 @@ struct v4l2_subdev_pad_config {
> >   *
> >   * @set_frame_desc: set the low level media bus frame parameters, @fd array
> >   *                  may be adjusted by the subdev driver to device capabilities.
> > + *
> > + * @get_routing: callback for VIDIOC_SUBDEV_G_ROUTING IOCTL handler.
> > + * @set_routing: callback for VIDIOC_SUBDEV_S_ROUTING IOCTL handler.
> 
> Please define the purpose of those operations instead of just pointing
> to the userspace API.
> 
> >   */
> >  struct v4l2_subdev_pad_ops {
> >  	int (*init_cfg)(struct v4l2_subdev *sd,
> > @@ -719,6 +722,10 @@ struct v4l2_subdev_pad_ops {
> >  			      struct v4l2_mbus_frame_desc *fd);
> >  	int (*set_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
> >  			      struct v4l2_mbus_frame_desc *fd);
> > +	int (*get_routing)(struct v4l2_subdev *sd,
> > +			   struct v4l2_subdev_routing *route);
> > +	int (*set_routing)(struct v4l2_subdev *sd,
> > +			   struct v4l2_subdev_routing *route);
> >  };
> >  
> >  /**
> > diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
> > index 03970ce3074193e6..af069bfb10ca23a5 100644
> > --- a/include/uapi/linux/v4l2-subdev.h
> > +++ b/include/uapi/linux/v4l2-subdev.h
> > @@ -155,6 +155,44 @@ struct v4l2_subdev_selection {
> >  	__u32 reserved[8];
> >  };
> >  
> > +#define V4L2_SUBDEV_ROUTE_FL_ACTIVE	(1 << 0)
> > +#define V4L2_SUBDEV_ROUTE_FL_IMMUTABLE	(1 << 1)
> > +
> > +/**
> > + * struct v4l2_subdev_route - A signal route inside a subdev
> > + * @sink_pad: the sink pad
> > + * @sink_stream: the sink stream
> > + * @source_pad: the source pad
> > + * @source_stream: the source stream
> 
> At this point in the series there's no concept of multiplexed streams,
> so the two fields don't make sense. You may want to reorder patches, or
> split this in two.

I think it would make sense to reorder, as adding an IOCTL and then
changing the argument struct would be something to avoid if possible.

> 
> > + * @flags: route flags:
> > + *
> > + *	V4L2_SUBDEV_ROUTE_FL_ACTIVE: Is the stream in use or not? An
> > + *	active stream will start when streaming is enabled on a video
> > + *	node. Set by the user.
> 
> This is very confusing as "stream" isn't defined. The documentation
> needs a rewrite with more details.

Yes, we need a little more documentation on this.

> 
> > + *
> > + *	V4L2_SUBDEV_ROUTE_FL_IMMUTABLE: Is the stream immutable, i.e.
> > + *	can it be activated and inactivated? Set by the driver.
> > + */
> > +struct v4l2_subdev_route {
> > +	__u32 sink_pad;
> > +	__u32 sink_stream;
> > +	__u32 source_pad;
> > +	__u32 source_stream;
> > +	__u32 flags;
> > +	__u32 reserved[5];
> > +};
> > +
> > +/**
> > + * struct v4l2_subdev_routing - Routing information
> > + * @routes: the routes array
> > + * @num_routes: the total number of routes in the routes array
> > + */
> > +struct v4l2_subdev_routing {
> > +	struct v4l2_subdev_route *routes;
> 
> Missing __user ?

We actually don't have any IOCTLs using __u64 pointer values in V4L2. I
wonder what Hans thinks, too. I guess it's the way to go. Compat code is so
awful. :-I

> 
> > +	__u32 num_routes;
> > +	__u32 reserved[5];
> > +};
> > +
> >  /* Backwards compatibility define --- to be removed */
> >  #define v4l2_subdev_edid v4l2_edid
> >  
> > @@ -181,5 +219,7 @@ struct v4l2_subdev_selection {
> >  #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum_dv_timings)
> >  #define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 99, struct v4l2_dv_timings)
> >  #define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 100, struct v4l2_dv_timings_cap)
> > +#define VIDIOC_SUBDEV_G_ROUTING			_IOWR('V', 38, struct v4l2_subdev_routing)
> > +#define VIDIOC_SUBDEV_S_ROUTING			_IOWR('V', 39, struct v4l2_subdev_routing)
> >  
> >  #endif

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
