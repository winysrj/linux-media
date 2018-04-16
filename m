Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:48465 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeDPMrN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:47:13 -0400
Date: Mon, 16 Apr 2018 14:46:47 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180416124647.GA3377@w540>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <20180405091001.GI20945@w540>
 <20180415231635.GH20093@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20180415231635.GH20093@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Mon, Apr 16, 2018 at 01:16:35AM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your feedback.
>
> Comments I have snipped out from this reply are addressed, thanks for
> bringing them to my attention!
>
> On 2018-04-05 11:10:01 +0200, Jacopo Mondi wrote:
>
> [snip]
>
> > > +static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
> > > +{
> > > +	int timeout;
> > > +
> > > +	/* Wait for the clock and data lanes to enter LP-11 state. */
> > > +	for (timeout =3D 100; timeout > 0; timeout--) {
> > > +		const u32 lane_mask =3D (1 << priv->lanes) - 1;
> > > +
> > > +		if ((rcar_csi2_read(priv, PHCLM_REG) & 1) =3D=3D 1 &&
> >
> > Nitpicking:
> > 		if ((rcar_csi2_read(priv, PHCLM_REG) & 0x01) &&
> >
> > Don't you prefer to provide defines also for bit fields instead of
> > using magic values? In this case something like
> > PHCLM_REG_STOPSTATE_CLK would do.
>
> Thanks addressed per your and Kieran's suggestion.
>
> >
> > Also, from tables 25.[17-20] it seems to me that for H3 and V3 you
> > have to set INSTATE to an hardcoded value after having validated PHDLM.
> > Maybe it is not necessary, just pointing it out.
>
> I assume you mean Figures 25.[17-20] and not Tables as the last table in
> chapter 25 is Table 25.15 and the register in question is INTSTATE :-)
> And to clarify this is documented for H3 which this driver supports and
> V3H and M3-N which this driver dose not yet support. And the constant
> you are to set it to is ULPS_START | UPLS_END.

Yes, Figures, not Tables, sorry about this.

>
> This is a good catch as this was introduced in a later version of the
> datasheet and the current code where the ULPS_START | UPLS_END is set
> before confirming LP-11 have kept on working. Check the
> priv->info->clear_ulps usage in rcar_csi2_start(). I do think it's
> better to follow the flow-chart in the new datasheet so I will move this
> to the end of rcar_csi2_start() to reflect that (provided that the end
> result still works :-) Thanks for pointing this out!
>

I see...

Actually, I don't see M3-N in the manual version I'm looking at.
Anyway, I just hope this per-soc specificities are limited.

> [snip]
>
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
> > > +
> > > +	/*
> > > +	 * Enable all Virtual Channels
> > > +	 *
> > > +	 * NOTE: It's not possible to get individual datatype for each
> > > +	 *       source virtual channel. Once this is possible in V4L2
> > > +	 *       it should be used here.
> > > +	 */
> > > +	for (i =3D 0; i < 4; i++) {
> > > +		u32 vcdt_part;
> > > +
> > > +		vcdt_part =3D VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
> > > +			VCDT_SEL_DT(format->datatype);
> > > +
> > > +		/* Store in correct reg and offset */
> > > +		if (i < 2)
> > > +			vcdt |=3D vcdt_part << ((i % 2) * 16);
> > > +		else
> > > +			vcdt2 |=3D vcdt_part << ((i % 2) * 16);
> > > +	}
> > > +
> > > +	switch (priv->lanes) {
> > > +	case 1:
> > > +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
> > > +		break;
> > > +	case 2:
> > > +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> > > +		break;
> > > +	case 4:
> > > +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2 |
> > > +			PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> > > +		break;
> >
> > Even simpler this could be written as
> >
> >                 phycnt =3D PHYCNT_ENABLECLK | (1 << priv->lanes) - 1;
>
> Fixed per your and Geert's suggestion.
>
> >
> > > +	default:
> > > +		return -EINVAL;
> >
> > Can this happen? You have validated priv->lanes already when parsing
> > DT
>
> This can't happen but I like to have a catch all in any case, but since
> I took yours and Geert's suggestion above this issue goes away :-)
>

Does gcc complains about the missing default case?

> >
> > > +	}
> > > +
> > > +	ret =3D rcar_csi2_calc_phypll(priv, format->bpp, &phypll);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	/* Clear Ultra Low Power interrupt */
> > > +	if (priv->info->clear_ulps)
> > > +		rcar_csi2_write(priv, INTSTATE_REG,
> > > +				INTSTATE_INT_ULPS_START |
> > > +				INTSTATE_INT_ULPS_END);
> > > +
> > > +	/* Init */
> > > +	rcar_csi2_write(priv, TREF_REG, TREF_TREF);
> > > +	rcar_csi2_reset(priv);
> > > +	rcar_csi2_write(priv, PHTC_REG, 0);
> > > +
> > > +	/* Configure */
> > > +	rcar_csi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> > > +			FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> >
> > On the FLD_FLD_NUM(2) mask. Why 2?
> > I read on the datasheet "the register must not be changed from default
> > value" and I read defaul to be 0x0000
>
> This is based on feedback from Renesas. The register is not properly
> documented. I'm working on improving it but for now I would like to keep
> it as FLD_FLD_NUM(2) and make a neater and documented fix in a follow up
> commit. In short it controls which field is captured first (ODD/EVEN).
>

Would you mind adding a small comment there?

> >
> > Also, please consider a make as all other fields are enabled
> > unconditionally.
>
> No I don't like the idea of a mask here, I feel it better to be
> explicit.
>

Up to you :)

> >
> > > +	rcar_csi2_write(priv, VCDT_REG, vcdt);
> > > +	rcar_csi2_write(priv, VCDT2_REG, vcdt2);
> > > +	/* Lanes are zero indexed */
> > > +	rcar_csi2_write(priv, LSWAP_REG,
> > > +			LSWAP_L0SEL(priv->lane_swap[0] - 1) |
> > > +			LSWAP_L1SEL(priv->lane_swap[1] - 1) |
> > > +			LSWAP_L2SEL(priv->lane_swap[2] - 1) |
> > > +			LSWAP_L3SEL(priv->lane_swap[3] - 1));
> >
> > EDIT:
> > (This comment is way too long for the real value it has, but since I
> > already wrote it, and my initial doubt clarified while I was writing,
> > resulting in a much less serious issues, I'm gonna keep it all anyway.
> > Sorry about this :)
> >
> > Why - 1 ?
> > Is this because it is assumed clock lane is in position 0? Is this
> > fixed by design?
> >
> > What I read in datasheet for LSWAP_REG is:
> > L[0-3]SEL       0 =3D Use PHY lane 0
> >                 1 =3D Use PHY lane 1
> >                 2 =3D Use PHY lane 2
> >                 3 =3D Use PHY lane 3
> >
> > priv->lane_swap[i] is collected parsing 'data_lanes' property and
> > should reflect the actual physical lane value assigned to logical lane
> > numbers. If 'data_lanes' is, say <1 2> I expect
> >
> > priv->lane_swap[0] =3D 1;
> > priv->lane_swap[1] =3D 2;
> > priv->lane_swap[1] =3D 3; //assigned by your parsing routine
> > priv->lane_swap[1] =3D 4; //assigned by your parsing routine
> >
> > And I understand LSWAP counts instead from [0-3] so, ok, I get why you
> > subtract one. But now I wonder what happens if instead, lane position
> > is specified counting from 0 in DT. Ah, I see you refuse lane_swap
> > values < 1! So It should be assumed clock is by HW design on lane 0,
> > so wouldn't you need to mention in DT bindings that the HW has clock
> > lanes fixed in position 0 and the accepted values for the 'data_lanes'
> > property ranges in the [1-4] interval?
>
> My understanding of video-interfaces.txt which is reference in the DT
> documentation is that the clock is always 0 and the data lanes are
> numbers 1-4 for CSI-2.
>

Quoting the DT bindings:

- data-lanes: an array of physical data lane indexes. Position of an entry
  determines the logical lane number, while the value of an entry indicates
  physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
  "data-lanes =3D <1 2>;", assuming the clock lane is on hardware lane 0.
  If the hardware does not support lane reordering, monotonically
  incremented values shall be used from 0 or 1 onwards, depending on
  whether or not there is also a clock lane. This property is valid for
  serial busses only (e.g. MIPI CSI-2).

So yes, you're correct. I got confused by the "depending on whether or
not there is also a clock lane.". I assume this phrase is to
accommodate C-PHYs that embed the clock lane in each data 'trios'.
> >
> > > +
> > > +	if (priv->info->init_phtw) {
> > > +		/*
> > > +		 * This is for H3 ES2.0
> > > +		 *
> > > +		 * NOTE: Additional logic is needed here when
> > > +		 * support for V3H and/or M3-N is added
> > > +		 */
> > > +		rcar_csi2_write(priv, PHTW_REG, 0x01cc01e2);
> > > +		rcar_csi2_write(priv, PHTW_REG, 0x010101e3);
> > > +		rcar_csi2_write(priv, PHTW_REG, 0x010101e4);
> > > +		rcar_csi2_write(priv, PHTW_REG, 0x01100104);
> > > +		rcar_csi2_write(priv, PHTW_REG, 0x01030100);
> > > +		rcar_csi2_write(priv, PHTW_REG, 0x01800100);
> > > +	}
> > > +
> > > +	/* Start */
> > > +	rcar_csi2_write(priv, PHYPLL_REG, phypll);
> > > +
> > > +	/* Set frequency range if we have it */
> > > +	if (priv->info->csi0clkfreqrange)
> > > +		rcar_csi2_write(priv, CSI0CLKFCPR_REG,
> > > +				CSI0CLKFREQRANGE(priv->info->csi0clkfreqrange));
> > > +
> > > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt);
> > > +	rcar_csi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
> > > +			LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> > > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
> > > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ |
> > > +			PHYCNT_RSTZ);
> >
> > Nit: from tables 25.[17-20] it seems to me you do not have to re-issue
> > PHYCNT_SHUTDOWNZ when writing PHYCNT_RSTZ to PHYCNT_REG.
>
> You are correct, I miss read '.... Here, the ENABLE_0 to ENABLE_3 and
> ENABLECLK values set above should be retained' as all previous PHYCNT
> bits should be retained not just the ones explicitly listed. I will give
> this a test and if it still works I will remove it for the next version.
>
> >
> > > +
> > > +	return rcar_csi2_wait_phy_start(priv);
> > > +}
> > > +
> > > +static void rcar_csi2_stop(struct rcar_csi2 *priv)
> > > +{
> > > +	rcar_csi2_write(priv, PHYCNT_REG, 0);
> > > +
> > > +	rcar_csi2_reset(priv);
> > > +}
> > > +
> > > +static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> > > +{
> > > +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> > > +	struct v4l2_subdev *nextsd;
> > > +	int ret =3D 0;
> > > +
> > > +	mutex_lock(&priv->lock);
> > > +
> > > +	if (!priv->remote) {
> > > +		ret =3D -ENODEV;
> > > +		goto out;
> > > +	}
> >
> > Can this happen?
>
> Sure, the video source is unbound and as you note bellow the unbind
> callback sets priv->remote =3D NULL. Or even simpler the driver for the
> video source is not loaded at all so the rcar-csi2 drivers bound
> callback is never called.

My reasoning was that if the driver for the video source is not
loaded, so you won't have any 'bound()' callback, you won't have any
video device created to call s_stream() on.

Am I biased by how the R-Car VIN works?

>
> >
> > The 'bind' callback sets priv->remote and it gets assigned back to
> > NULL only on 'unbind'. Wouldn't it be better to remove the link in the
> > media graph and let the system return an EPIPE before calling this?
>
> That would be very complex as some driver in the pipeline (VIN?) would
> have to parse the full graph in DT and somehow with subdevice support
> helpers to traverse the DT port to MC pad mapping using helpers that do
> not exist yet (and are hard to use if the remote subdevice driver is not
> loaded) to build a full view of the pipeline and return -EPIPE if not
> all entities are present in the media graph :-)

Ack. I thought the pipeline validation was performed during the
pipeline traversal by the media controller framework, and not that is
was responsability of the video capture driver (eg VIN)
>
> [snip]
>
> > > +static int rcar_csi2_parse_v4l2(struct rcar_csi2 *priv,
> > > +				struct v4l2_fwnode_endpoint *vep)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	/* Only port 0 endpoint 0 is valid */
> > > +	if (vep->base.port || vep->base.id)
> > > +		return -ENOTCONN;
> > > +
> > > +	if (vep->bus_type !=3D V4L2_MBUS_CSI2) {
> > > +		dev_err(priv->dev, "Unsupported bus: 0x%x\n", vep->bus_type);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	priv->lanes =3D vep->bus.mipi_csi2.num_data_lanes;
> > > +	if (priv->lanes !=3D 1 && priv->lanes !=3D 2 && priv->lanes !=3D 4)=
 {
> >
> > Is this an HW limitation? Like the 'data_lanes' comment, if it is,
> > shouldn't you mention in bindings that the accepted lane numbers is
> > limited to the [1,2,4] values.
>
> Yes, see chapter 25.4.8 Lane Setting.

What about mentioning it in DT? Not an expert, but this is an HW
limitation, so it can fit there.

>
> [snip]
>
> >
> > No serious issues though. So when fixed/clarified feel free to append my
> > Reviewed-by tag, if relevant at all.
>
> Thanks! I feel I managed to address all of your review comments but
> would still like your confirmation for me to add your tag. Thanks again
> for the review!

Since you have to send a new version anyhow, I'll reply with my tag to
that one.

Thanks
   j

>
> --
> Regards,
> Niklas S=C3=B6derlund

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1Js3AAoJEHI0Bo8WoVY8aLwP/2F1hMnKgmWtHcEAwlsGrXcp
pn+tJLwBts32tKMOLsP91ogmIuTlXWZBH2z90lTY+2R8EiTjak8py2Aq0oZz2L87
R/UA61ok5kSie777qv5sGL/c+HiYm+JjqOEZy+6KcuAw8Qe2b9AqRKz678hMSwAU
6pPQmvs7deUgAOOZCKQygBznaN26Mni1RwSPEzwGwlURWD1ZRsp9hL+HFVF6ynNy
Wr23gc4k0zIDUiAO47uZKs7efxJGiiy5FLZxn2odGG5n6nyPpnmcepm2crAQZsOm
E3SIkWJXRa/rT3ps4o61+k/hZD1k4KGvxNzvHM2M5M1mRjoypjsj/VtowrUTjO/8
cR4V1aAwZHf0hllf0ANnTIH4NIU4rYgT8fUNRm1G/V1WKGqfSYnkJ/Xk85jZHqDt
AuxJ6R61ip1t4CkqSA9o6BU72QiD3hSJNBHPuQgkCGvTrqf07j4/kIXXHtx2SRzK
HKCtEnCtjDxP+cYZlNGrgc0qFwZPURfg5yEr52sD/iq5a0tF/UjXi5tNgZ5ZrWwC
/6UBy9tzr3cGvOJKtiN9ZoqbnU62xR6AodUb17djATpiO9dbeYPE0i5tHYGn0Sw3
CnRfQ6wOI0DG4jzE5wz0AO/DVzCIpndg3vI5dy/vkv6LQkCRXZMDdWfXynGqukjA
uL+azZEdwOfFAMtDtFoh
=lIRO
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
