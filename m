Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44552 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932567AbeDWXXj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 19:23:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Tue, 24 Apr 2018 02:23:51 +0300
Message-ID: <2879939.4qmvGYligi@avalon>
In-Reply-To: <20180415212606.GG20093@bigcity.dyn.berto.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se> <5149348.Rp98f1K5qJ@avalon> <20180415212606.GG20093@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Monday, 16 April 2018 00:26:06 EEST Niklas S=F6derlund wrote:
> Hi Laurent,
>=20
> Thanks for your feedback.
>=20
> I have addressed all your comment's but one for the next version. Please
> indicate if you are fine with this and I can still keep your review tag
>=20
> :-)
>=20
> On 2018-04-04 18:15:16 +0300, Laurent Pinchart wrote:
>=20
> [snip]
>=20
> > > +static int rcar_csi2_start(struct rcar_csi2 *priv)
> > > +{
> > > +	const struct rcar_csi2_format *format;
> > > +	u32 phycnt, phypll, vcdt =3D 0, vcdt2 =3D 0;
> > > +	unsigned int i;
> > > +	int ret;
> > > +
> > > +	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
> > > +		priv->mf.width, priv->mf.height,
> > > +		priv->mf.field =3D=3D V4L2_FIELD_NONE ? 'p' : 'i');
> > > +
> > > +	/* Code is validated in set_fmt */
> > > +	format =3D rcar_csi2_code_to_fmt(priv->mf.code);
> >=20
> > You could store the format pointer iin the rcar_csi2 structure to avoid
> > looking it up here.
>=20
> I could do that, but then I would duplicate the storage of the code
> between the two cached values priv->mf and priv-><cached pointer to
> rcar_csi2>. I could find that acceptable but if you don't strongly
> disagree I would prefer to keep the current way of looking it up here
> :-)

I'm OK with that, even if I think that duplicating the code would be a very=
=20
small price to pay for not having to look up the format information structu=
re.

> [snip]
>=20
> > > +static int rcar_csi2_probe_resources(struct rcar_csi2 *priv,
> > > +				     struct platform_device *pdev)
> > > +{
> > > +	struct resource *res;
> > > +	int irq;
> > > +
> > > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +	priv->base =3D devm_ioremap_resource(&pdev->dev, res);
> > > +	if (IS_ERR(priv->base))
> > > +		return PTR_ERR(priv->base);
> > > +
> > > +	irq =3D platform_get_irq(pdev, 0);
> > > +	if (irq < 0)
> > > +		return irq;
> >=20
> > You don't seem to use the IRQ. Is this meant to catch invalid DT that
> > don't
> > specify an IRQ, to make sure we'll always have one available when we'll
> > need to later ?
>=20
> Yes, as you deducted this is currently only to catch invalid DT. In the
> DT documentation I list it as a mandatory property. I think there might
> be potential use-case to at some point add interrupt support of for the
> some of the error interrupts which can be enabled, specially now when we
> seen similar patches for VIN floating around.
>=20
> > > +
> > > +	return 0;
> > > +
> > > +error:
> > > +	v4l2_async_notifier_unregister(&priv->notifier);
> > > +	v4l2_async_notifier_cleanup(&priv->notifier);
> > > +
> > > +	return ret;
> > > +}
> >=20
> > [snip]
> >=20
> > With these small issues fixed and Kieran's and Maxime's comments addres=
sed
> > as you see fit,
> >=20
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>=20
> Thanks, I will hold of adding it until you indicate if you are OK with
> the one comment I'm not fully agreeing with you on.


=2D-=20
Regards,

Laurent Pinchart
