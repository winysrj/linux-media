Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45269 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdKKGRx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 01:17:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v10 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Sat, 11 Nov 2017 08:17:59 +0200
Message-ID: <2456560.miCsvfXtsD@avalon>
In-Reply-To: <20171110223227.pug7d4qi7rdi4b4b@valkosipuli.retiisi.org.uk>
References: <20171110133137.9137-1-niklas.soderlund+renesas@ragnatech.se> <20171110133137.9137-3-niklas.soderlund+renesas@ragnatech.se> <20171110223227.pug7d4qi7rdi4b4b@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday, 11 November 2017 00:32:27 EET Sakari Ailus wrote:
> On Fri, Nov 10, 2017 at 02:31:37PM +0100, Niklas S=F6derlund wrote:
> > A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> > supports the rcar-vin driver on R-Car Gen3 SoCs where separate CSI-2
> > hardware blocks are connected between the video sources and the video
> > grabbers (VIN).
> >=20
> > Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
> >=20
> > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.s=
e>
> > ---
> >=20
> >  drivers/media/platform/rcar-vin/Kconfig     |  12 +
> >  drivers/media/platform/rcar-vin/Makefile    |   1 +
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 934 ++++++++++++++++++++=
+++
> >  3 files changed, 947 insertions(+)
> >  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> > index 0000000000000000..27d09da191a09b39
> > --- /dev/null
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> > +static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv,
> > +				 struct v4l2_subdev *source,
> > +				 struct v4l2_mbus_framefmt *mf,
> > +				 u32 *phypll)
> > +{
> > +	const struct phypll_hsfreqrange *hsfreq;
> > +	const struct rcar_csi2_format *format;
> > +	struct v4l2_ctrl *ctrl;
> > +	u64 mbps;
> > +
> > +	ctrl =3D v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
>=20
> How about LINK_FREQ instead? It'd be more straightforward to calculate
> this. Up to you.

This probably needs to be documented, but I think the official API is=20
V4L2_CID_PIXEL_RATE. The link frequency control is not mandatory.

> > +	if (!ctrl) {
> > +		dev_err(priv->dev, "no link freq control in subdev %s\n",
> > +			source->name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	format =3D rcar_csi2_code_to_fmt(mf->code);
> > +	if (!format) {
> > +		dev_err(priv->dev, "Unknown format: %d\n", mf->code);
> > +		return -EINVAL;
> > +	}
> > +
> > +	mbps =3D v4l2_ctrl_g_ctrl_int64(ctrl) * format->bpp;
> > +	do_div(mbps, priv->lanes * 1000000);
> > +
> > +	for (hsfreq =3D priv->info->hsfreqrange; hsfreq->mbps !=3D 0; hsfreq+=
+)
> > +		if (hsfreq->mbps >=3D mbps)
> > +			break;
> > +
> > +	if (!hsfreq->mbps) {
> > +		dev_err(priv->dev, "Unsupported PHY speed (%llu Mbps)", mbps);
> > +		return -ERANGE;
> > +	}
> > +
> > +	dev_dbg(priv->dev, "PHY HSFREQRANGE requested %llu got %u Mbps\n",=20
mbps,
> > +		hsfreq->mbps);
> > +
> > +	*phypll =3D PHYPLL_HSFREQRANGE(hsfreq->reg);
> > +
> > +	return 0;
> > +}

[snip]

> > +static int rcar_csi2_s_power(struct v4l2_subdev *sd, int on)
> > +{
> > +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> > +
> > +	if (on)
> > +		pm_runtime_get_sync(priv->dev);
> > +	else
> > +		pm_runtime_put(priv->dev);
>=20
> The pipeline you have is already rather complex. Would it be an option to
> power the hardware on when streaming is started? The smiapp driver does
> this, without even implementing the s_power callback. (You'd still need to
> call it on the image source, as long as we have drivers that need it.)

We've briefly discussed this before, and I agree that pipeline power=20
management needs to be redesigned, but we still haven't agreed on a proper=
=20
architecture for that. Feel free to propose an RFC :-) In the meantime I=20
wouldn't try to enforce one specific model.

> > +
> > +	return 0;
> > +}

[snip]

=2D-=20
Regards,

Laurent Pinchart
