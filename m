Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DF7C10F05
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 00:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E187218B0
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 00:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfCUAvB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 20:51:01 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:58915 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfCUAvB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 20:51:01 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 17CBF20002;
        Thu, 21 Mar 2019 00:50:56 +0000 (UTC)
Date:   Thu, 21 Mar 2019 01:51:36 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, dave.stevenson@raspberrypi.org
Subject: Re: [RFC 5/5] media: rcar-csi2: Configure CSI-2 with frame desc
Message-ID: <20190321005135.tihupvjwkbhdmrqu@uno.localdomain>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
 <20190316154801.20460-6-jacopo+renesas@jmondi.org>
 <20190320195015.GN26015@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vwhx43kuoveroig2"
Content-Disposition: inline
In-Reply-To: <20190320195015.GN26015@bigcity.dyn.berto.se>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--vwhx43kuoveroig2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Wed, Mar 20, 2019 at 08:50:15PM +0100, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your patch.
>
> On 2019-03-16 16:48:01 +0100, Jacopo Mondi wrote:
> > Use the D-PHY configuration reported by the remote subdevice in its
> > frame descriptor to configure the interface.
> >
> > Store the number of lanes reported through the 'data-lanes' DT property
> > as the number of phyisically available lanes, which might not correspond
> > to the number of lanes actually in use.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 71 +++++++++++++--------
> >  1 file changed, 43 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/medi=
a/platform/rcar-vin/rcar-csi2.c
> > index 6c46bcc0ee83..70b9a8165a6e 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -375,8 +375,8 @@ struct rcar_csi2 {
> >  	struct mutex lock;
> >  	int stream_count;
> >
> > -	unsigned short lanes;
> > -	unsigned char lane_swap[4];
> > +	unsigned short available_data_lanes;
> > +	unsigned short num_data_lanes;
>
> I don't like this, I'm sorry :-(
>
> I think you should keep lanes and lane_swap and most code touching them
> intact. And drop num_data_lanes as it's only used when starting and only
> valid for one 'session' and should not be cached in the data structure
> unnecessary.
>
> Furthermore I think involving lane swapping in the runtime configurable
> parameters is a bad idea. Or do you see a scenario where lanes could be
> swapped in runtime? In my view DT should describe which physical lanes
> are connected and how. And the runtime configuration part should only
> deal with how many lanes are used for the particular capture session.
>

Yeah, it's dumb, it was noted in the review of the framework
side as well..

I'll drop anything related to lane re-ordering, so I should not need
to touch 'lanes' and 'lane_swap'. I need 'num_data_lanes' in 'struct
rcar_csi2' though, as it is used in a few function called by
rcsi2_start().

Thanks
  j

> >  };
> >
> >  static inline struct rcar_csi2 *sd_to_csi2(struct v4l2_subdev *sd)
> > @@ -424,7 +424,7 @@ static int rcsi2_get_remote_frame_desc(struct rcar_=
csi2 *priv,
> >  	if (ret)
> >  		return -ENODEV;
> >
> > -	if (fd->type !=3D V4L2_MBUS_FRAME_DESC_TYPE_CSI2) {
> > +	if (fd->type !=3D V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY) {
> >  		dev_err(priv->dev, "Frame desc do not describe CSI-2 link");
> >  		return -EINVAL;
> >  	}
> > @@ -438,7 +438,7 @@ static int rcsi2_wait_phy_start(struct rcar_csi2 *p=
riv)
> >
> >  	/* Wait for the clock and data lanes to enter LP-11 state. */
> >  	for (timeout =3D 0; timeout <=3D 20; timeout++) {
> > -		const u32 lane_mask =3D (1 << priv->lanes) - 1;
> > +		const u32 lane_mask =3D (1 << priv->num_data_lanes) - 1;
> >
> >  		if ((rcsi2_read(priv, PHCLM_REG) & PHCLM_STOPSTATECKL)  &&
> >  		    (rcsi2_read(priv, PHDLM_REG) & lane_mask) =3D=3D lane_mask)
> > @@ -511,14 +511,15 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv,
> >  	 * bps =3D link_freq * 2
> >  	 */
> >  	mbps =3D v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
> > -	do_div(mbps, priv->lanes * 1000000);
> > +	do_div(mbps, priv->num_data_lanes * 1000000);
> >
> >  	return mbps;
> >  }
> >
> >  static int rcsi2_start(struct rcar_csi2 *priv)
> >  {
> > -	u32 phycnt, vcdt =3D 0, vcdt2 =3D 0;
> > +	struct v4l2_mbus_frame_desc_entry_csi2_dphy *dphy;
> > +	u32 phycnt, vcdt =3D 0, vcdt2 =3D 0, lswap =3D 0;
> >  	struct v4l2_mbus_frame_desc fd;
> >  	unsigned int i;
> >  	int mbps, ret;
> > @@ -548,8 +549,26 @@ static int rcsi2_start(struct rcar_csi2 *priv)
> >  			entry->bus.csi2.channel, entry->bus.csi2.data_type);
> >  	}
> >
> > +	/* Get description of the D-PHY media bus configuration. */
> > +	dphy =3D &fd.phy.csi2_dphy;
> > +	if (dphy->clock_lane !=3D 0) {
> > +		dev_err(priv->dev,
> > +			"CSI-2 configuration not supported: clock at index %u",
> > +			dphy->clock_lane);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (dphy->num_data_lanes > priv->available_data_lanes ||
> > +	    dphy->num_data_lanes =3D=3D 3) {
> > +		dev_err(priv->dev,
> > +			"Number of CSI-2 data lanes not supported: %u",
> > +			dphy->num_data_lanes);
> > +		return -EINVAL;
> > +	}
> > +	priv->num_data_lanes =3D dphy->num_data_lanes;
> > +
> >  	phycnt =3D PHYCNT_ENABLECLK;
> > -	phycnt |=3D (1 << priv->lanes) - 1;
> > +	phycnt |=3D (1 << priv->num_data_lanes) - 1;
> >
> >  	mbps =3D rcsi2_calc_mbps(priv, &fd);
> >  	if (mbps < 0)
> > @@ -566,12 +585,11 @@ static int rcsi2_start(struct rcar_csi2 *priv)
> >  	rcsi2_write(priv, VCDT_REG, vcdt);
> >  	if (vcdt2)
> >  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> > +
> >  	/* Lanes are zero indexed. */
> > -	rcsi2_write(priv, LSWAP_REG,
> > -		    LSWAP_L0SEL(priv->lane_swap[0] - 1) |
> > -		    LSWAP_L1SEL(priv->lane_swap[1] - 1) |
> > -		    LSWAP_L2SEL(priv->lane_swap[2] - 1) |
> > -		    LSWAP_L3SEL(priv->lane_swap[3] - 1));
> > +	for (i =3D 0; i < priv->num_data_lanes; ++i)
> > +		lswap |=3D (dphy->data_lanes[i] - 1) << (i * 2);
> > +	rcsi2_write(priv, LSWAP_REG, lswap);
> >
> >  	/* Start */
> >  	if (priv->info->init_phtw) {
> > @@ -822,7 +840,7 @@ static const struct v4l2_async_notifier_operations =
rcar_csi2_notify_ops =3D {
> >  static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
> >  			    struct v4l2_fwnode_endpoint *vep)
> >  {
> > -	unsigned int i;
> > +	unsigned int num_data_lanes;
> >
> >  	/* Only port 0 endpoint 0 is valid. */
> >  	if (vep->base.port || vep->base.id)
> > @@ -833,24 +851,21 @@ static int rcsi2_parse_v4l2(struct rcar_csi2 *pri=
v,
> >  		return -EINVAL;
> >  	}
> >
> > -	priv->lanes =3D vep->bus.mipi_csi2.num_data_lanes;
> > -	if (priv->lanes !=3D 1 && priv->lanes !=3D 2 && priv->lanes !=3D 4) {
> > +	num_data_lanes =3D vep->bus.mipi_csi2.num_data_lanes;
> > +	switch (num_data_lanes) {
> > +	case 1:
> > +		/* fallthrough */
> > +	case 2:
> > +		/* fallthrough */
> > +	case 4:
> > +		priv->available_data_lanes =3D num_data_lanes;
> > +		break;
> > +	default:
>
> Nit pick, I don't like this switch statement and would prefer the
> original construct with an if.
>
> >  		dev_err(priv->dev, "Unsupported number of data-lanes: %u\n",
> > -			priv->lanes);
> > +			num_data_lanes);
> >  		return -EINVAL;
> >  	}
> >
> > -	for (i =3D 0; i < ARRAY_SIZE(priv->lane_swap); i++) {
> > -		priv->lane_swap[i] =3D i < priv->lanes ?
> > -			vep->bus.mipi_csi2.data_lanes[i] : i;
> > -
> > -		/* Check for valid lane number. */
> > -		if (priv->lane_swap[i] < 1 || priv->lane_swap[i] > 4) {
> > -			dev_err(priv->dev, "data-lanes must be in 1-4 range\n");
> > -			return -EINVAL;
> > -		}
> > -	}
> > -
> >  	return 0;
> >  }
> >
> > @@ -1235,7 +1250,7 @@ static int rcsi2_probe(struct platform_device *pd=
ev)
> >  	if (ret < 0)
> >  		goto error;
> >
> > -	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
> > +	dev_info(priv->dev, "%d lanes found\n", priv->available_data_lanes);
> >
> >  	return 0;
> >
> > --
> > 2.21.0
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--vwhx43kuoveroig2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyS4BcACgkQcjQGjxah
Vjw80Q/+PX0v+9AxLZxfuANJpexgKzGZwIReShcgC8U51eSTqbrIVguIc8h+T23e
7UySbCoF1kbklh/3dKTt6wrWzRjaxpejSKTKe10F7oWePW2Zis2oYSR8+PdGq0D3
w2yrhmfeQ2fRTOuWMwg2cNj5yQnRJBDyVvlECMt9bF0UifKZaWpW0O5wvRHnMb7/
vdUK2PwKNaBT25/93UyXY+kV5K0K7ePhUA7JtHTwfwAyxe34M2QamW6KqqV9xk0O
epSUlXt7NGp8IMTMA9B7SO637rbJUdEB1oAP7LSbCguWcwu1ZimX3P/D/AR0a2AO
6ITQdBJBIdc46yN5kn+PK7pcZQmVRxhit7xLSq+28VmYwIPfRy4mN0scgICo5IMm
NInHdWxvkP4bniXknSvqiDJVAJP6Q2bvb9GblikYJnOawMTd6LV0NiJOmeUTZ6Go
kCFaM+4KuVXA3t5CrXqvZQym6ADbJvMHP711HjIRLEe2cfwHKzVaoqJnwmckADVT
IY8OMROeGTgWVrg9iiz+c4oACcXjueLd0v1YKoammSUJlSTMXI54Qb0rePq/99SX
WqiqgxmWpAJI3yzUckEjzTgu67vFfXlQLooUrOERXhzS3ZbyITaOp4pCdM6iTPlL
gS2zCpVO3dAZUcF+ZMbdLFWVsO1HUsjpMPo3Pvw8wn4t7iPgNjA=
=Vf6M
-----END PGP SIGNATURE-----

--vwhx43kuoveroig2--
