Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EDCC00319
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 22:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E1B20836
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 22:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfBUWbl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 17:31:41 -0500
Received: from mga05.intel.com ([192.55.52.43]:26367 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfBUWbl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 17:31:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2019 14:31:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,397,1544515200"; 
   d="scan'208";a="148827126"
Received: from oliviapo-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.44.84])
  by fmsmga001.fm.intel.com with ESMTP; 21 Feb 2019 14:31:38 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 0456921D81; Fri, 22 Feb 2019 00:31:32 +0200 (EET)
Date:   Fri, 22 Feb 2019 00:31:32 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190221223131.rago5jmpxhygtuep@kekkonen.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190221143940.k56z2vwovu3y5okh@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190221143940.k56z2vwovu3y5okh@uno.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Thu, Feb 21, 2019 at 03:39:40PM +0100, Jacopo Mondi wrote:
> Hi Sakari,
>    one quick question
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
> 
> Can't the number of routes exceeds the total number of pad?
> 
> To make an example, a subdevice with 2 sink pads, and 1 multiplexed
> source pad, with 2 streams would expose the following routing table,
> right?
> 
> pad #0 = sink, 1 stream
> pad #1 = sink, 1 stream
> pad #2 = source, 2 streams
> 
> Routing table:
> 0/0 -> 2/0
> 0/0 -> 2/1
> 1/0 -> 2/0
> 1/0 -> 2/1
> 
> In general, the number of accepted routes should depend on the number
> of streams, not pads, and that's better handled by drivers, am I
> wrong?

Good point. Is the above configuration meaningful? I.e. you have a mux
device that does some processing as well by combining the streams?

It's far-fetched but at the moment the API does not really bend for that.
It still might in the future.

I guess we could just remove the check, and let drivers handle it.

> 
> Thanks
>   j
> 
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
> > + * @flags: route flags:
> > + *
> > + *	V4L2_SUBDEV_ROUTE_FL_ACTIVE: Is the stream in use or not? An
> > + *	active stream will start when streaming is enabled on a video
> > + *	node. Set by the user.
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

This should be just __u64, to avoid writing compat code. The patch was
written before we started doing that. :-) Please see e.g. the media device
topology IOCTL.

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
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
