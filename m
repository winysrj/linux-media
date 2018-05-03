Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58644 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751420AbeECPNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 11:13:53 -0400
Date: Thu, 3 May 2018 17:13:50 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v11 2/4] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20180503151350.7pdu5kdl6vp7wz4y@flea>
References: <20180424122700.5387-1-maxime.ripard@bootlin.com>
 <20180424122700.5387-3-maxime.ripard@bootlin.com>
 <4924400e-67ea-e523-321a-a9d3490d7873@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kpbebtlsvllvluiy"
Content-Disposition: inline
In-Reply-To: <4924400e-67ea-e523-321a-a9d3490d7873@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kpbebtlsvllvluiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Thanks for your review,

On Thu, May 03, 2018 at 12:54:57PM +0200, Hans Verkuil wrote:
> > +static int csi2rx_stop(struct csi2rx_priv *csi2rx)
> > +{
> > +	unsigned int i;
> > +
> > +	clk_prepare_enable(csi2rx->p_clk);
> > +	clk_disable_unprepare(csi2rx->sys_clk);
> > +
> > +	for (i =3D 0; i < csi2rx->max_streams; i++) {
> > +		writel(0, csi2rx->base + CSI2RX_STREAM_CTRL_REG(i));
> > +
> > +		clk_disable_unprepare(csi2rx->pixel_clk[i]);
> > +	}
> > +
> > +	clk_disable_unprepare(csi2rx->p_clk);
> > +
> > +	return v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, false=
);
> > +}
> > +
> > +static int csi2rx_s_stream(struct v4l2_subdev *subdev, int enable)
> > +{
> > +	struct csi2rx_priv *csi2rx =3D v4l2_subdev_to_csi2rx(subdev);
> > +	int ret =3D 0;
> > +
> > +	mutex_lock(&csi2rx->lock);
> > +
> > +	if (enable) {
> > +		/*
> > +		 * If we're not the first users, there's no need to
> > +		 * enable the whole controller.
> > +		 */
> > +		if (!csi2rx->count) {
> > +			ret =3D csi2rx_start(csi2rx);
> > +			if (ret)
> > +				goto out;
> > +		}
> > +
> > +		csi2rx->count++;
> > +	} else {
> > +		csi2rx->count--;
> > +
> > +		/*
> > +		 * Let the last user turn off the lights.
> > +		 */
> > +		if (!csi2rx->count) {
> > +			ret =3D csi2rx_stop(csi2rx);
> > +			if (ret)
> > +				goto out;
>=20
> Here the error from csi2rx_stop is propagated to the caller, but in the TX
> driver it is ignored. Is there a reason for the difference?

Even though that wasn't really intentional, TX only does a writel in
its stop (which cannot fail), while RX will need to communicate with
its subdev, and that can fail.

> In general I see little value in propagating errors when releasing/stoppi=
ng
> something, since there is usually very little you can do to handle the er=
ror.
> It really shouldn't fail.

So do you want me to ignore the values in the s_stream function and
log the error, or should I just make the start / stop function return
void?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--kpbebtlsvllvluiy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrrJy0ACgkQ0rTAlCFN
r3Tz7g//SY85eumghZcnYema9FJCOSmIJKhG9Bf+RthIn8D3gyqKYG0LXl0xWX59
xB/8QaQi3ZiG02h9973ziIpm+LwGwyXrLpPwk5Dkrv2R+yUO4TQrvt3eAditvlGl
mBXca95BJapHxgB2as7zbLNxfufX8mAYd5uCZfzS2obz2p36PCeedSROt3G1V9pL
egASswnz36PiOzPDuxm2b1vD+0JnZh0l5D0lyuuPY2wWmuzAGrAx3XVwXILx56/z
HMnP3Xhtgr62SRllRb8OBAAKrhHBZ5DUt/HZkoHMA5UlIGSC7PY5R0liAd1twmwv
8r+NRmMizyolvW1JCA/6CS/wLThfocZ3B13Ys3G8mZ8syCK+7xxNOEZZ61VIlScG
So46pZbqoJdl/qC0NZI8Yq9XDRj0PCt5r0wi0uIfLpjHrk0yX9wOe+66kzD3WQLd
TbWmdGRr2k8MzRcj4lgWhvKG66KtfrQAX/TkgUcDsO8FHdcOrMHAj8PZ0B31pLBa
n/XvppiztbGT/8mmBmQuNLevjMK29SB7b1anTfSb3YOznzU5S7H3WJT7JcSzogW0
OVlrol8+P6gXbXxD4xKMn5QUHShGuFMqBzl5NDaiRPVyepUi2umrBSCx9iZKkTZj
wl/JVbM7UEq301sAXmh3MUxyml47Cnl6AVccixwE8WQeEWkonpQ=
=F0QA
-----END PGP SIGNATURE-----

--kpbebtlsvllvluiy--
