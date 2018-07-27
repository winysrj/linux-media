Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58256 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730205AbeG0Ntc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 09:49:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: update stream start for V3M
Date: Fri, 27 Jul 2018 15:28:20 +0300
Message-ID: <2795245.SRuJKGOtsb@avalon>
In-Reply-To: <20180727115140.GC14328@bigcity.dyn.berto.se>
References: <20180726223657.26340-1-niklas.soderlund+renesas@ragnatech.se> <2085902.EcbZgA7qhr@avalon> <20180727115140.GC14328@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Friday, 27 July 2018 14:51:40 EEST Niklas S=F6derlund wrote:
> On 2018-07-27 12:25:13 +0300, Laurent Pinchart wrote:
> > On Friday, 27 July 2018 01:36:57 EEST Niklas S=F6derlund wrote:
> >> Latest errata document updates the start procedure for V3M. This change
> >> in addition to adhering to the datasheet update fixes capture on early
> >> revisions of V3M.
> >>=20
> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >> ---
> >>=20
> >>  drivers/media/platform/rcar-vin/rcar-csi2.c | 20 ++++++++++++++------
> >>  1 file changed, 14 insertions(+), 6 deletions(-)
> >>=20
> >> ---
> >>=20
> >> Hi Hans, Mauro and Sakari
> >>=20
> >> I know this is late for v4.19 but if possible can it be considered? It
> >> fixes a real issue on R-Car V3M boards. I'm sorry for the late
> >> submission, the errata document accesses unfortunate did not align with
> >> the release schedule.
> >>=20
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> b/drivers/media/platform/rcar-vin/rcar-csi2.c index
> >> daef72d410a3425d..dc5ae8025832ab6e 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> @@ -339,6 +339,7 @@ enum rcar_csi2_pads {
> >>=20
> >>  struct rcar_csi2_info {
> >>  	int (*init_phtw)(struct rcar_csi2 *priv, unsigned int mbps);
> >> +	int (*confirm_start)(struct rcar_csi2 *priv);
> >>  	const struct rcsi2_mbps_reg *hsfreqrange;
> >>  	unsigned int csi0clkfreqrange;
> >>  	bool clear_ulps;
> >> @@ -545,6 +546,13 @@ static int rcsi2_start(struct rcar_csi2 *priv)
> >>  	if (ret)
> >>  		return ret;
> >>=20
> >> +	/* Confirm start */
> >> +	if (priv->info->confirm_start) {
> >> +		ret =3D priv->info->confirm_start(priv);
> >> +		if (ret)
> >> +			return ret;
> >> +	}
> >> +
> >=20
> > While PHTW has to be written in the "Confirmation of PHY start" sequenc=
e,
> > the operation doesn't seem to be related to confirmation of PHY start, =
it
> > instead looks like a shuffle of the configuration sequence. I would thus
> > not name the operation .confirm_start() as that's not what it does.
>=20
> I think the hook name being .confirm_start() is good as it is where in
> stream start procedure it is called. What the operation do in the V3M
> case is for me hidden as the datasheet only lists register writes and
> instructs you to check what I believe is the result of each "operation".

The PHTW register is used to communicate with the PHY through an internal b=
us=20
(could it be I2C ? That would be similar to what a well known HDMI TX IP=20
provider does). I believe that the read following the write is just a way t=
o=20
way for the internal write to complete. The whole sequence is thus in my=20
opinion really a set of writes to PHY registers, and thus a configuration=20
sequence. I don't have more insight on this particular IP core though, all=
=20
this is based on a combination of knowledge of other multimedia IPs and som=
e=20
guesswork. It would be worth asking Renesas for clarification.

> For all I know it might be a configuration sequence or a method to
> confirm that the stream is started. Do you have anymore insight to what
> it does? All I know is prior to datasheet v1.0 it was not documented for
> V3M and streaming worked fine without it, and still do.
>=20
> >>  	/* Clear Ultra Low Power interrupt. */
> >>  	if (priv->info->clear_ulps)
> >>  		rcsi2_write(priv, INTSTATE_REG,
> >> @@ -880,6 +888,11 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct
> >> rcar_csi2 *priv, unsigned int mbps)
> >>  }
> >>=20
> >>  static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int
> >> mbps)
> >> +{
> >> +	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> >> +}
> >> +
> >> +static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
> >>  {
> >>  	static const struct phtw_value step1[] =3D {
> >>  		{ .data =3D 0xed, .code =3D 0x34 },
> >> @@ -890,12 +903,6 @@ static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2
> >> *priv, unsigned int mbps) { /* sentinel */
> >>  		},
> >>  	};
> >>=20
> >> -	int ret;
> >> -
> >> -	ret =3D rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> >> -	if (ret)
> >> -		return ret;
> >> -
> >=20
> > There's something I don't get here. According to the errata, it's the
> > step1 array write sequence that need to be moved from "Start of PHY" to
> > "Confirmation of PHY start". This patch moves the PHTW frequency
> > configuration instead.
>=20
> Is this not what this patch do? I agree the diff is hard to read. The
> result however is more clear.

Of course, my bad. I had missed the fact that the patch also turned=20
rcsi2_init_phtw_v3m_e3() into rcsi2_confirm_start_v3m_e3(). Sorry for the=20
noise.

Given that the operation name isn't a blocker as it can be renamed later if=
=20
needed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>     static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int
> mbps) {
> 	    return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
>     }
>=20
>     static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
>     {
> 	    static const struct phtw_value step1[] =3D {
> 		    { .data =3D 0xed, .code =3D 0x34 },
> 		    { .data =3D 0xed, .code =3D 0x44 },
> 		    { .data =3D 0xed, .code =3D 0x54 },
> 		    { .data =3D 0xed, .code =3D 0x84 },
> 		    { .data =3D 0xed, .code =3D 0x94 },
> 		    { /* sentinel */ },
> 	    };
>=20
> 	    return rcsi2_phtw_write_array(priv, step1);
>     }
>=20
>     ...
>=20
>     static const struct rcar_csi2_info rcar_csi2_info_r8a77970 =3D {
> 	    .init_phtw =3D rcsi2_init_phtw_v3m_e3,
> 	    .confirm_start =3D rcsi2_confirm_start_v3m_e3,
>     };
>=20
> >>  	return rcsi2_phtw_write_array(priv, step1);
> >>  }
> >>=20
> >> @@ -949,6 +956,7 @@ static const struct rcar_csi2_info
> >> rcar_csi2_info_r8a77965 =3D {
> >>=20
> >>  static const struct rcar_csi2_info rcar_csi2_info_r8a77970 =3D {
> >>  	.init_phtw =3D rcsi2_init_phtw_v3m_e3,
> >> +	.confirm_start =3D rcsi2_confirm_start_v3m_e3,
> >>  };
> >> =20
> >>  static const struct of_device_id rcar_csi2_of_table[] =3D {

=2D-=20
Regards,

Laurent Pinchart
