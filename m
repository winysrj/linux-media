Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A504C4360F
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 08:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64596207E0
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 08:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfBVIj5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:39:57 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:49863 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfBVIj5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 03:39:57 -0500
X-Originating-IP: 31.157.247.153
Received: from uno.localdomain (unknown [31.157.247.153])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id AA0D820010;
        Fri, 22 Feb 2019 08:39:52 +0000 (UTC)
Date:   Fri, 22 Feb 2019 09:40:19 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190222084019.62atdkk6qipnugvf@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190221143940.k56z2vwovu3y5okh@uno.localdomain>
 <20190221223131.rago5jmpxhygtuep@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hm5x2ccoeh3cj5j2"
Content-Disposition: inline
In-Reply-To: <20190221223131.rago5jmpxhygtuep@kekkonen.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--hm5x2ccoeh3cj5j2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Fri, Feb 22, 2019 at 12:31:32AM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Thu, Feb 21, 2019 at 03:39:40PM +0100, Jacopo Mondi wrote:
> > Hi Sakari,
> >    one quick question
> >
> > On Fri, Nov 02, 2018 at 12:31:30AM +0100, Niklas S=C3=B6derlund wrote:
> > > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > >
> > > - Add sink and source streams for multiplexed links
> > > - Copy the argument back in case of an error. This is needed to let t=
he
> > >   caller know the number of routes.
> > >
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatec=
h.se>
> > > ---
> > >  drivers/media/v4l2-core/v4l2-ioctl.c  | 20 +++++++++++++-
> > >  drivers/media/v4l2-core/v4l2-subdev.c | 28 +++++++++++++++++++
> > >  include/media/v4l2-subdev.h           |  7 +++++
> > >  include/uapi/linux/v4l2-subdev.h      | 40 +++++++++++++++++++++++++=
++
> > >  4 files changed, 94 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l=
2-core/v4l2-ioctl.c
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
> > > @@ -2924,6 +2925,23 @@ static int check_array_args(unsigned int cmd, =
void *parg, size_t *array_size,
> > >  		}
> > >  		break;
> > >  	}
> > > +
> > > +	case VIDIOC_SUBDEV_G_ROUTING:
> > > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > > +		struct v4l2_subdev_routing *route =3D parg;
> > > +
> > > +		if (route->num_routes > 0) {
> > > +			if (route->num_routes > 256)
> > > +				return -EINVAL;
> > > +
> > > +			*user_ptr =3D (void __user *)route->routes;
> > > +			*kernel_ptr =3D (void *)&route->routes;
> > > +			*array_size =3D sizeof(struct v4l2_subdev_route)
> > > +				    * route->num_routes;
> > > +			ret =3D 1;
> > > +		}
> > > +		break;
> > > +	}
> > >  	}
> > >
> > >  	return ret;
> > > @@ -3033,7 +3051,7 @@ video_usercopy(struct file *file, unsigned int =
cmd, unsigned long arg,
> > >  	 * Some ioctls can return an error, but still have valid
> > >  	 * results that must be returned.
> > >  	 */
> > > -	if (err < 0 && !always_copy)
> > > +	if (err < 0 && !always_copy && cmd !=3D VIDIOC_SUBDEV_G_ROUTING)
> > >  		goto out;
> > >
> > >  out_array_args:
> > > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4=
l2-core/v4l2-subdev.c
> > > index 792f41dffe2329b9..1d3b37cf548fa533 100644
> > > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > > @@ -516,7 +516,35 @@ static long subdev_do_ioctl(struct file *file, u=
nsigned int cmd, void *arg)
> > >
> > >  	case VIDIOC_SUBDEV_QUERYSTD:
> > >  		return v4l2_subdev_call(sd, video, querystd, arg);
> > > +
> > > +	case VIDIOC_SUBDEV_G_ROUTING:
> > > +		return v4l2_subdev_call(sd, pad, get_routing, arg);
> > > +
> > > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > > +		struct v4l2_subdev_routing *route =3D arg;
> > > +		unsigned int i;
> > > +
> > > +		if (route->num_routes > sd->entity.num_pads)
> > > +			return -EINVAL;
> >
> > Can't the number of routes exceeds the total number of pad?
> >
> > To make an example, a subdevice with 2 sink pads, and 1 multiplexed
> > source pad, with 2 streams would expose the following routing table,
> > right?
> >
> > pad #0 =3D sink, 1 stream
> > pad #1 =3D sink, 1 stream
> > pad #2 =3D source, 2 streams
> >
> > Routing table:
> > 0/0 -> 2/0
> > 0/0 -> 2/1
> > 1/0 -> 2/0
> > 1/0 -> 2/1
> >
> > In general, the number of accepted routes should depend on the number
> > of streams, not pads, and that's better handled by drivers, am I
> > wrong?
>
> Good point. Is the above configuration meaningful? I.e. you have a mux
> device that does some processing as well by combining the streams?
>
> It's far-fetched but at the moment the API does not really bend for that.
> It still might in the future.

Well, how would you expect a routing table for a device that
supports multiplexing using Virtual Channels to look like?

As far as I got it, even with a single sink and a single source, it
would be:

[SINK/SINK_STREAM -> SOURCE/SOURCE_STREAM]
0/0 -> 1/0
0/0 -> 1/1
0/0 -> 1/2
0/0 -> 1/3

On the previous example, I thought about GMSL-like devices, that can
output the video streams received from different remotes in a
separate virtual channel, at the same time.

A possible routing table in that case would be like:

Pads 0, 1, 2, 3 =3D SINKS
Pad 4 =3D SOURCE with 4 streams (1 for each VC)

0/0 -> 4/0
0/0 -> 4/1
0/0 -> 4/2
0/0 -> 4/3
1/0 -> 4/0
1/0 -> 4/1
1/0 -> 4/2
1/0 -> 4/3
2/0 -> 4/0
2/0 -> 4/1
2/0 -> 4/2
2/0 -> 4/3
3/0 -> 4/0
3/0 -> 4/1
3/0 -> 4/2
3/0 -> 4/3

With only one route per virtual channel active at a time.

Does this match your idea?

>
> I guess we could just remove the check, and let drivers handle it.
>

Yup, I agree!

> >
> > Thanks
> >   j
> >
> > > +
> > > +		for (i =3D 0; i < route->num_routes; ++i) {
> > > +			unsigned int sink =3D route->routes[i].sink_pad;
> > > +			unsigned int source =3D route->routes[i].source_pad;
> > > +			struct media_pad *pads =3D sd->entity.pads;
> > > +
> > > +			if (sink >=3D sd->entity.num_pads ||
> > > +			    source >=3D sd->entity.num_pads)
> > > +				return -EINVAL;
> > > +
> > > +			if (!(pads[sink].flags & MEDIA_PAD_FL_SINK) ||
> > > +			    !(pads[source].flags & MEDIA_PAD_FL_SOURCE))
> > > +				return -EINVAL;
> > > +		}
> > > +
> > > +		return v4l2_subdev_call(sd, pad, set_routing, route);
> > > +	}
> > >  #endif
> > > +
> > >  	default:
> > >  		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> > >  	}
> > > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > > index 9102d6ca566e01f2..5acaeeb9b3cacefa 100644
> > > --- a/include/media/v4l2-subdev.h
> > > +++ b/include/media/v4l2-subdev.h
> > > @@ -679,6 +679,9 @@ struct v4l2_subdev_pad_config {
> > >   *
> > >   * @set_frame_desc: set the low level media bus frame parameters, @f=
d array
> > >   *                  may be adjusted by the subdev driver to device c=
apabilities.
> > > + *
> > > + * @get_routing: callback for VIDIOC_SUBDEV_G_ROUTING IOCTL handler.
> > > + * @set_routing: callback for VIDIOC_SUBDEV_S_ROUTING IOCTL handler.
> > >   */
> > >  struct v4l2_subdev_pad_ops {
> > >  	int (*init_cfg)(struct v4l2_subdev *sd,
> > > @@ -719,6 +722,10 @@ struct v4l2_subdev_pad_ops {
> > >  			      struct v4l2_mbus_frame_desc *fd);
> > >  	int (*set_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
> > >  			      struct v4l2_mbus_frame_desc *fd);
> > > +	int (*get_routing)(struct v4l2_subdev *sd,
> > > +			   struct v4l2_subdev_routing *route);
> > > +	int (*set_routing)(struct v4l2_subdev *sd,
> > > +			   struct v4l2_subdev_routing *route);
> > >  };
> > >
> > >  /**
> > > diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4=
l2-subdev.h
> > > index 03970ce3074193e6..af069bfb10ca23a5 100644
> > > --- a/include/uapi/linux/v4l2-subdev.h
> > > +++ b/include/uapi/linux/v4l2-subdev.h
> > > @@ -155,6 +155,44 @@ struct v4l2_subdev_selection {
> > >  	__u32 reserved[8];
> > >  };
> > >
> > > +#define V4L2_SUBDEV_ROUTE_FL_ACTIVE	(1 << 0)
> > > +#define V4L2_SUBDEV_ROUTE_FL_IMMUTABLE	(1 << 1)
> > > +
> > > +/**
> > > + * struct v4l2_subdev_route - A signal route inside a subdev
> > > + * @sink_pad: the sink pad
> > > + * @sink_stream: the sink stream
> > > + * @source_pad: the source pad
> > > + * @source_stream: the source stream
> > > + * @flags: route flags:
> > > + *
> > > + *	V4L2_SUBDEV_ROUTE_FL_ACTIVE: Is the stream in use or not? An
> > > + *	active stream will start when streaming is enabled on a video
> > > + *	node. Set by the user.
> > > + *
> > > + *	V4L2_SUBDEV_ROUTE_FL_IMMUTABLE: Is the stream immutable, i.e.
> > > + *	can it be activated and inactivated? Set by the driver.
> > > + */
> > > +struct v4l2_subdev_route {
> > > +	__u32 sink_pad;
> > > +	__u32 sink_stream;
> > > +	__u32 source_pad;
> > > +	__u32 source_stream;
> > > +	__u32 flags;
> > > +	__u32 reserved[5];
> > > +};
> > > +
> > > +/**
> > > + * struct v4l2_subdev_routing - Routing information
> > > + * @routes: the routes array
> > > + * @num_routes: the total number of routes in the routes array
> > > + */
> > > +struct v4l2_subdev_routing {
> > > +	struct v4l2_subdev_route *routes;
>
> This should be just __u64, to avoid writing compat code. The patch was
> written before we started doing that. :-) Please see e.g. the media device
> topology IOCTL.
>

Thanks, I had a look at the MEDIA_ ioctls yesterday, G_TOPOLOGY in
particular, which uses several pointers to arrays.

Unfortunately, I didn't come up with anything better than using a
translation structure, from the IOCTL layer to the subdevice
operations layer:
https://paste.debian.net/hidden/b192969d/
(sharing a link for early comments, I can send v3 and you can comment
there directly if you prefer to :)

Thanks
   j

> > > +	__u32 num_routes;
> > > +	__u32 reserved[5];
> > > +};
> > > +
> > >  /* Backwards compatibility define --- to be removed */
> > >  #define v4l2_subdev_edid v4l2_edid
> > >
> > > @@ -181,5 +219,7 @@ struct v4l2_subdev_selection {
> > >  #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_en=
um_dv_timings)
> > >  #define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 99, struct v4l2_dv=
_timings)
> > >  #define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 100, struct v4l2_dv=
_timings_cap)
> > > +#define VIDIOC_SUBDEV_G_ROUTING			_IOWR('V', 38, struct v4l2_subdev_=
routing)
> > > +#define VIDIOC_SUBDEV_S_ROUTING			_IOWR('V', 39, struct v4l2_subdev_=
routing)
> > >
> > >  #endif
>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--hm5x2ccoeh3cj5j2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxvtXMACgkQcjQGjxah
VjxXUA/+MRfkVydJLN8ZMESTYBdRd4jNVn0nehoQBQ/DUl1CGhDMXvFOEZfXwsM8
jkwDJwI09XkJnO1RSKQZexizhg6Fb1RXDC819KQ1XqscFBHqh5z/KRQ7Y2ypAHMV
fUez2JSNGKD0GAwTZnbp4af/KHc6yjXwyd//7xmKdXs0Fii01XGpfLCS7+ArUtZO
NAXEJCy32t+cN7cTST7sc4EnxnCQP+rXaDZGnoyIrh24rM5iKcJUlbUIpiCIj20T
w0Oor+cSom2uB4dExNhxhYY0MTK/QeyRV+eXT8exVGp1I4fQVkxYwVW2VBAsCK32
uhQCx2YJMc+xrZfLsrwyuLRGeSG8ocX2zuOHKgZtIpUH2YrnxIu4beFSGtLKlD3X
KHJ4h57cOMlDCc2UpBTpukRbRgDRiYwy00SMxhHq3Za2nzGiC0/5RXB9suUqtQ6o
dynG8uhWZYdRriIVt0eY2VGB+3IsX2sgErVFrbJcXejXSW59AxxCgRVztgp3aTV5
uAFiH1UbTFH8AG35MLwZQOPPKqyOyCvPBdQw6ETBeQ3wPrF+qS5Vw4WA5wwqFP/Z
Q0XoUnh9AIIgF7/eGNS3KAyypHIO1RW6jWKZizlLVtF7mW7/owDnGfkn8Q5mhTSq
WHXaTCrbOtBYx6EqTOnfRKt+3JyMS2XXCQALYBNCPlr84/0cWOM=
=9ddd
-----END PGP SIGNATURE-----

--hm5x2ccoeh3cj5j2--
