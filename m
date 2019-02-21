Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E07C00319
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D64D02083B
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbfBUO7B (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:59:01 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:56879 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfBUO7B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:59:01 -0500
X-Originating-IP: 37.176.227.16
Received: from uno.localdomain (unknown [37.176.227.16])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id EAAE6C0002;
        Thu, 21 Feb 2019 14:58:54 +0000 (UTC)
Date:   Thu, 21 Feb 2019 15:59:20 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190221145920.7w7mynzhdwln4drb@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190115235145.GF31088@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v7bjnusd5smqrpld"
Content-Disposition: inline
In-Reply-To: <20190115235145.GF31088@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--v7bjnusd5smqrpld
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari, Laurent, Niklas,
   (another) quick question, but a different one :)

On Wed, Jan 16, 2019 at 01:51:45AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
>
> Thank you for the patch.
>
> On Fri, Nov 02, 2018 at 12:31:30AM +0100, Niklas S=C3=B6derlund wrote:
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
> > Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
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
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-=
core/v4l2-ioctl.c
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
> > @@ -2924,6 +2925,23 @@ static int check_array_args(unsigned int cmd, vo=
id *parg, size_t *array_size,
> >  		}
> >  		break;
> >  	}
> > +
> > +	case VIDIOC_SUBDEV_G_ROUTING:
> > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > +		struct v4l2_subdev_routing *route =3D parg;
> > +
> > +		if (route->num_routes > 0) {
> > +			if (route->num_routes > 256)
> > +				return -EINVAL;
> > +
> > +			*user_ptr =3D (void __user *)route->routes;
> > +			*kernel_ptr =3D (void *)&route->routes;
> > +			*array_size =3D sizeof(struct v4l2_subdev_route)
> > +				    * route->num_routes;
> > +			ret =3D 1;
> > +		}
> > +		break;
> > +	}
> >  	}
> >
> >  	return ret;
> > @@ -3033,7 +3051,7 @@ video_usercopy(struct file *file, unsigned int cm=
d, unsigned long arg,
> >  	 * Some ioctls can return an error, but still have valid
> >  	 * results that must be returned.
> >  	 */
> > -	if (err < 0 && !always_copy)
> > +	if (err < 0 && !always_copy && cmd !=3D VIDIOC_SUBDEV_G_ROUTING)
>
> This seems like a hack. Shouldn't VIDIOC_SUBDEV_G_ROUTING set
> always_copy instead ?
>
> >  		goto out;
> >
> >  out_array_args:
> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2=
-core/v4l2-subdev.c
> > index 792f41dffe2329b9..1d3b37cf548fa533 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -516,7 +516,35 @@ static long subdev_do_ioctl(struct file *file, uns=
igned int cmd, void *arg)
> >
> >  	case VIDIOC_SUBDEV_QUERYSTD:
> >  		return v4l2_subdev_call(sd, video, querystd, arg);
> > +
> > +	case VIDIOC_SUBDEV_G_ROUTING:
> > +		return v4l2_subdev_call(sd, pad, get_routing, arg);
> > +
> > +	case VIDIOC_SUBDEV_S_ROUTING: {
> > +		struct v4l2_subdev_routing *route =3D arg;
> > +		unsigned int i;
> > +
> > +		if (route->num_routes > sd->entity.num_pads)
> > +			return -EINVAL;
> > +
> > +		for (i =3D 0; i < route->num_routes; ++i) {

How have you envisioned the number of routes to be negotiated with
applications? I'm writing the documentation for this ioctl, and I
would like to insert this part as well.

Would a model like the one implemented in G_TOPOLOGY work in your
opinion? In my understanding, at the moment applications do not have a
way to reserve a known number of routes entries, but would likely
reserve 'enough(tm)' (ie 256) and pass them to the G_ROUTING ioctl that the
first time will likely adjust the number of num_routes and return -ENOSPC.

Wouldn't it work to make the IOCTL behave in a way that it
expects the first call to be performed with (num_routes =3D=3D 0) and no ro=
utes
entries reserved, and just adjust 'num_routes' in that case?
So that applications should call G_ROUTING a first time with
num_routes =3D 0, get back the number of routes entries, reserve memory
for them, and then call G_ROUTING again to have the entries populated
by the driver. Do you have different ideas or was this the intended
behavior already?

Thanks
   j

> > +			unsigned int sink =3D route->routes[i].sink_pad;
> > +			unsigned int source =3D route->routes[i].source_pad;
> > +			struct media_pad *pads =3D sd->entity.pads;
> > +
> > +			if (sink >=3D sd->entity.num_pads ||
> > +			    source >=3D sd->entity.num_pads)
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
> >   * @set_frame_desc: set the low level media bus frame parameters, @fd =
array
> >   *                  may be adjusted by the subdev driver to device cap=
abilities.
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
> > diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2=
-subdev.h
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
>
> > + * @flags: route flags:
> > + *
> > + *	V4L2_SUBDEV_ROUTE_FL_ACTIVE: Is the stream in use or not? An
> > + *	active stream will start when streaming is enabled on a video
> > + *	node. Set by the user.
>
> This is very confusing as "stream" isn't defined. The documentation
> needs a rewrite with more details.
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
>
> > +	__u32 num_routes;
> > +	__u32 reserved[5];
> > +};
> > +
> >  /* Backwards compatibility define --- to be removed */
> >  #define v4l2_subdev_edid v4l2_edid
> >
> > @@ -181,5 +219,7 @@ struct v4l2_subdev_selection {
> >  #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum=
_dv_timings)
> >  #define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 99, struct v4l2_dv_t=
imings)
> >  #define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 100, struct v4l2_dv_t=
imings_cap)
> > +#define VIDIOC_SUBDEV_G_ROUTING			_IOWR('V', 38, struct v4l2_subdev_ro=
uting)
> > +#define VIDIOC_SUBDEV_S_ROUTING			_IOWR('V', 39, struct v4l2_subdev_ro=
uting)
> >
> >  #endif
> > --
> > 2.19.1
> >
>
> --
> Regards,
>
> Laurent Pinchart

--v7bjnusd5smqrpld
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxuvMgACgkQcjQGjxah
Vjw5aw//YrSucONGr9+jfeeqhSXniWx9hxNybLlwxmOo6IU7TEQpNtpQFJ0AJHx9
9p0Fl0sXhl8k83bV3qENTRjO3izGF7g7qEECP7RwB4kyf9+9ZTlHZ+wObenq0OB6
d093uWOvY3XFsqzWqTUt4tkNHBCgRUG6go/L/J7xL1UTI2qiUi1PrYzWIo/v4Z49
lAZzfpbQcx4Zd/5G/4YC/dlNoa7pMCkVaslkKOOGPdFCXUA5fEPfc+I89bjvAxqC
yro+Dn9oTmFR9kUOKUFwh89QG1do3n4/JlSaQ3gAu1i2EcFIrJNKvtlcMXyJ1xH9
m/zLuG2F1ZEg2l1MHipOGKIxIBtvLvc0X2J+mKPakeqpRVm0/ee44VvCopkJnaFq
Vj7ZCTltgb5OCiltW9tahSwnVuSLypXGfsUGKQUgQuh10ybplC/agUuL2qmt0+FM
RCmbdWIl3kNly8+PezxECd6mG3U7rPEJAahOlrl51gCe/BDVVS5coMzcDcM9CI2O
peXjAr4IFSAjf2FuLK4hBR4tIWBgkOQtkJlZ2BS3oe/Lw6yQEUfmqvfy14zJDDMe
mSxdOxhAlUFKeVVkJulv+NRHjSmXPP1cYnIPvC/sWjH10ZieMtDh5yZMBU/22Vat
3sV1WAkuxH22vFI4H3zIiZjAc0Tcl+BtzfceaSMq9xFR87bNRMc=
=Mug5
-----END PGP SIGNATURE-----

--v7bjnusd5smqrpld--
