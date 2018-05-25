Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:47937 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935163AbeEYHQV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 03:16:21 -0400
Date: Fri, 25 May 2018 09:16:15 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 5/9] media: rcar-vin: Parse parallel input on Gen3
Message-ID: <20180525071615.GJ18369@w540>
References: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527199339-7724-6-git-send-email-jacopo+renesas@jmondi.org>
 <20180524222944.GI31036@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yklP1rR72f9kjNtc"
Content-Disposition: inline
In-Reply-To: <20180524222944.GI31036@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yklP1rR72f9kjNtc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Fri, May 25, 2018 at 12:29:44AM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your work.
>
> I really like what you did with this patch in v4.

Thanks for review and suggestions, what's there comes mostly from your
comments and guidance.

>
> On 2018-05-25 00:02:15 +0200, Jacopo Mondi wrote:
> > The rcar-vin driver so far had a mutually exclusive code path for
> > handling parallel and CSI-2 video input subdevices, with only the CSI-2
> > use case supporting media-controller. As we add support for parallel
> > inputs to Gen3 media-controller compliant code path now parse both port=
@0
> > and port@1, handling the media-controller use case in the parallel
> > bound/unbind notifier operations.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >
> > ---
> > v3 -> v4:
> > - Change the mc/parallel initialization order. Initialize mc first, then
> >   parallel
> > - As a consequence no need to delay parallel notifiers registration, the
> >   media controller is set up already when parallel input got parsed,
> >   this greatly simplify the group notifier complete callback.
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 56 ++++++++++++++++++---=
--------
> >  1 file changed, 35 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/medi=
a/platform/rcar-vin/rcar-core.c
> > index a799684..29619c2 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -399,6 +399,11 @@ static int rvin_parallel_subdevice_attach(struct r=
vin_dev *vin,
> >  	ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> >  	vin->parallel->sink_pad =3D ret < 0 ? 0 : ret;
> >
> > +	if (vin->info->use_mc) {
> > +		vin->parallel->subdev =3D subdev;
> > +		return 0;
> > +	}
> > +
> >  	/* Find compatible subdevices mbus format */
> >  	vin->mbus_code =3D 0;
> >  	code.index =3D 0;
> > @@ -460,10 +465,12 @@ static int rvin_parallel_subdevice_attach(struct =
rvin_dev *vin,
> >  static void rvin_parallel_subdevice_detach(struct rvin_dev *vin)
> >  {
> >  	rvin_v4l2_unregister(vin);
> > -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> > -
> > -	vin->vdev.ctrl_handler =3D NULL;
> >  	vin->parallel->subdev =3D NULL;
> > +
> > +	if (!vin->info->use_mc) {
> > +		v4l2_ctrl_handler_free(&vin->ctrl_handler);
> > +		vin->vdev.ctrl_handler =3D NULL;
> > +	}
> >  }
> >
> >  static int rvin_parallel_notify_complete(struct v4l2_async_notifier *n=
otifier)
> > @@ -552,18 +559,18 @@ static int rvin_parallel_parse_v4l2(struct device=
 *dev,
> >  	return 0;
> >  }
> >
> > -static int rvin_parallel_graph_init(struct rvin_dev *vin)
> > +static int rvin_parallel_init(struct rvin_dev *vin)
> >  {
> >  	int ret;
> >
> > -	ret =3D v4l2_async_notifier_parse_fwnode_endpoints(
> > -		vin->dev, &vin->notifier,
> > -		sizeof(struct rvin_parallel_entity), rvin_parallel_parse_v4l2);
> > +	ret =3D v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> > +		vin->dev, &vin->notifier, sizeof(struct rvin_parallel_entity),
> > +		0, rvin_parallel_parse_v4l2);
> >  	if (ret)
> >  		return ret;
> >
> >  	if (!vin->parallel)
> > -		return -ENODEV;
> > +		return -ENOTCONN;
>
> I think you still should return -ENODEV here if !vin->info->use_mc to
> preserve Gen2 which runs without media controller behavior. How about:
>
>     return vin->info->use_mc ? -ENOTCONN : -ENODEV;

Right, I wish I had some gen2 board to test. I wonder if that's not
better handled in probe though... I'll see how it looks like.
>
> >
> >  	vin_dbg(vin, "Found parallel subdevice %pOF\n",
> >  		to_of_node(vin->parallel->asd.match.fwnode));
> > @@ -784,14 +791,8 @@ static int rvin_mc_init(struct rvin_dev *vin)
> >  {
> >  	int ret;
> >
> > -	vin->pad.flags =3D MEDIA_PAD_FL_SINK;
> > -	ret =3D media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> > -	if (ret)
> > -		return ret;
> > -
> > -	ret =3D rvin_group_get(vin);
> > -	if (ret)
> > -		return ret;
> > +	if (!vin->info->use_mc)
> > +		return 0;
> >
> >  	ret =3D rvin_mc_parse_of_graph(vin);
> >  	if (ret)
> > @@ -1074,11 +1075,24 @@ static int rcar_vin_probe(struct platform_devic=
e *pdev)
> >  		return ret;
> >
> >  	platform_set_drvdata(pdev, vin);
> > -	if (vin->info->use_mc)
> > -		ret =3D rvin_mc_init(vin);
> > -	else
> > -		ret =3D rvin_parallel_graph_init(vin);
> > -	if (ret < 0)
> > +
> > +	if (vin->info->use_mc) {
> > +		vin->pad.flags =3D MEDIA_PAD_FL_SINK;
> > +		ret =3D media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> > +		if (ret)
> > +			return ret;
> > +
> > +		ret =3D rvin_group_get(vin);
> > +		if (ret)
> > +			return ret;
> > +	}
>
> I don't see why you need to move the media pad creation out of
> rvin_mc_init(). With the reorder of the rvin_mc_init()
> rvin_parallel_init() I would keep this in rvin_mc_init().
>

Just because I've been lazy re-structuring that part of code I broke
up in previous versions. I'll move that part back to mc_init() and
possibly also remove the

+	if (!vin->info->use_mc)
+		return 0;

in that function and handle this in probe().

Thanks
   j


> > +
> > +	ret =3D rvin_mc_init(vin);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret =3D rvin_parallel_init(vin);
> > +	if (ret < 0 && ret !=3D -ENOTCONN)
> >  		goto error;
> >
> >  	pm_suspend_ignore_children(&pdev->dev, true);
> > --
> > 2.7.4
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--yklP1rR72f9kjNtc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbB7g/AAoJEHI0Bo8WoVY8H9sP/jLqdwWBXmOLiZJzrVaKVwsS
WD+g30BByEOBcXRQ2gty34wl/ORXQiHTHW0kVnltl1KH/KzDRsi3p7FOQxJZ0bu7
LtBpKMQzIY0sW3TFPKxxTIXUvgKNdbzflBb2swA6nsieNwnJwCHE7wugEd8eX3r9
iLNEXSCX1fp6J8AtIT0iFMEwhCEDNndt6PESVE9HpImxNnejXQT37AXGBd8+Rmlf
cj218kbnxrSW58Qt/NNeC2oj0nxlO9mR41I7oUflKjI+0BrWChLVFmOEah3Y7pFT
bcUO6ab7trKwrlmIKSt0y6JFdqdqHIDz19MbVCvz7BP4qVhGvCmxzecvgFUsHCl/
2XQgn8qnamA+JiuMwFQiJh+OtlYF/Zo7l9+JOmSxrL/Pc26tCJ6tPWZdlO1oiuRE
kpP74iXqv/Ic8oCli1qhIfdXx5uySv0UTdbW1u0l3XFK1VPE1fRky+W2HwIbFfxQ
NxVn5VjPefqTPtgg/I5CFZvxDqz73mAPrMOn8NtaF+Rg2c14ZHVUxY/9rf33TpDz
/X5iyZ2FmWqDCWbMYuYdrW72B7QtHauRV8L4ImJh8Ed6ZQlIRitJ93CF1W/7XNz6
btRPg5CIBdSDeXfx7VJ1RoiCp1dUkVpdoxYINncz+73dhNOqopnM2w4Xh9/UIuTe
i9Vd1tZLJSao7okVkT0t
=Idy5
-----END PGP SIGNATURE-----

--yklP1rR72f9kjNtc--
