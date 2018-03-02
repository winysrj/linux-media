Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52779 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946437AbeCBLcy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 06:32:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 19/28] rcar-vin: use different v4l2 operations in media controller mode
Date: Fri, 02 Mar 2018 13:33:43 +0200
Message-ID: <2344398.o1kP0vunrN@avalon>
In-Reply-To: <20180119004603.GD10270@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <4037381.ip89KhYXee@avalon> <20180119004603.GD10270@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Friday, 19 January 2018 02:46:03 EET Niklas S=F6derlund wrote:
> Hi Laurent,
>=20
> Thanks for your comments.
>=20
> Apart from the issue with the input API Hans pointed which indicates I
> need to keep that around until it's fixed in the framework I agree with
> all your comments but one.
>=20
> <snip>
>=20
> On 2017-12-08 12:14:05 +0200, Laurent Pinchart wrote:
> >> @@ -628,7 +628,8 @@ static int rvin_setup(struct rvin_dev *vin)
> >>  		/* Default to TB */
> >>  		vnmc =3D VNMC_IM_FULL;
> >>  		/* Use BT if video standard can be read and is 60 Hz format */
> >> -		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
> >> +		if (!vin->info->use_mc &&
> >> +		    !v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
> >>  			if (std & V4L2_STD_525_60)
> >>  				vnmc =3D VNMC_IM_FULL | VNMC_FOC;
> >>  		}
> >=20
> > I think the subdev should be queried in rcar-v4l2.c and the information
> > cached in the rvin_dev structure instead of queried here. Interactions
> > with the subdev should be minimized in rvin-dma.c. You can fix this in a
> > separate patch if you prefer.
>=20
> This can't be a cached value it needs to be read at stream on time. The
> input source could have changed format, e.g. the user may have
> disconnected a NTSC source and plugged in a PAL.

Please note that in that case the source subdev will not have changed its=20
format yet, it only does so when the s_std operation is called.

> This is a shame as I otherwise agree with you that interactions with the
> subdevice should be kept at a minimum.
>=20
> <snip>

=2D-=20
Regards,

Laurent Pinchart
