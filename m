Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AD9C00319
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A9202075A
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfBUORm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:17:42 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:46989 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfBUORm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:17:42 -0500
X-Originating-IP: 37.176.70.49
Received: from uno.localdomain (unknown [37.176.70.49])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 1307E20005;
        Thu, 21 Feb 2019 14:17:38 +0000 (UTC)
Date:   Thu, 21 Feb 2019 15:18:04 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 25/30] adv748x: csi2: only allow formats on sink pads
Message-ID: <20190221141804.rntwfqvzxfa4vwu7@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-26-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tbr22lmxwfeoguyc"
Content-Disposition: inline
In-Reply-To: <20181101233144.31507-26-niklas.soderlund+renesas@ragnatech.se>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--tbr22lmxwfeoguyc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Fri, Nov 02, 2018 at 12:31:39AM +0100, Niklas S=C3=B6derlund wrote:
> Once the CSI-2 subdevice of the ADV748X becomes aware of multiplexed
> streams the format of the source pad is of no value as it carries
> multiple streams. Prepare for this by explicitly denying setting a
> format on anything but the sink pad.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c=
/adv748x/adv748x-csi2.c
> index 8a7cc713c7adfcc1..9f2c49221a8ddebc 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -163,6 +163,9 @@ static int adv748x_csi2_get_format(struct v4l2_subdev=
 *sd,
>  	struct adv748x_state *state =3D tx->state;
>  	struct v4l2_mbus_framefmt *mbusformat;
>
> +	if (sdformat->pad !=3D ADV748X_CSI2_SINK)
> +		return -EINVAL;
> +
>  	mbusformat =3D adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
>  						 sdformat->which);
>  	if (!mbusformat)
> @@ -186,6 +189,9 @@ static int adv748x_csi2_set_format(struct v4l2_subdev=
 *sd,
>  	struct v4l2_mbus_framefmt *mbusformat;
>  	int ret =3D 0;
>
> +	if (sdformat->pad !=3D ADV748X_CSI2_SINK)
> +		return -EINVAL;
> +

The adv748x set_format on the source pad already ignores the provided
format argument and just replicates the format applied on the sink on
itself. I agree this change makes sense, but then you should remove
the big if switch a few lines here below.

	if (sdformat->pad =3D=3D ADV748X_CSI2_SOURCE) {

With your ack, I can make this change in the forthcoming v3.

Thanks
   j

PS: I'm thinking of sending the v4l2-mux core patches (01->23 of v2)
separate from adv748x and rcar-csi2 ones, to ease review, and maybe
speed up inclusion of the core changes. What would your (and Sakari's
and Laurent's) opinion on that?

>  	mbusformat =3D adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
>  						 sdformat->which);
>  	if (!mbusformat)
> --
> 2.19.1
>

--tbr22lmxwfeoguyc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxusxwACgkQcjQGjxah
VjwWJBAAs3A0CNxm4v+h6+9Ku+WO3W8NMMd/x1rYJyDK71biVFVaYD0W3tX5FYL3
fG7YIeDrsUhoFmWY3rh6dgUj5QIokFOsOCOkXa2w3rUa1k0kFfq0P8T00l6VxyL5
AtQ0KF8XG+iRnKgqejO1HgfqbptnUySluTWdzt6B1aBFa2Urqu28PSi2J/fdprCB
qC260jzYvW4JAT9hi8RnpiPbsSv4dTzyHnJ0tVYCDas46UeroQUxkA6cuU91iiz4
C2HPg+ryWEXlfZT50lmu6qZdHBTf4NzduHV1MVJNtLx7ihLtXj9C+ZjB3QtKuYVE
VFBEbiNdlY7DRNNpu4KcOjK2p0mjSytpt+UYVYCyPjHHEmi1d/5vJLDp+BZFWAIT
K342vCpLs3PQStsPm4I3dNQFZ/adSoRvaQwNXmsTsW13VUbDmeZM7TdFx2hhleAr
DTavDf4ucrGY11G5dCEVz1AJNNtRXWWl5KmlbgjiJggmoZ0fct/Q6fmjYWBySV0a
G7l90ZvnicmAhNMA9gcW2gUlrUCx8yf3Ueor1BEnXuXinfXeBGSX5Mocmb5sCaoX
cRLqoLG2vJHvLp19s4vyeKoYvJZ5dB4HjJ42CI76IWcYD4mlufzGXMgZsEdOLum+
iz2jQ6Aa10dfqeCuYsvpyVVUx7TQvk172NM2dZjI8WSHgN2Kw1Y=
=W0Uz
-----END PGP SIGNATURE-----

--tbr22lmxwfeoguyc--
