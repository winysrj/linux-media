Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1165849AbdD1S0R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 14:26:17 -0400
Date: Fri, 28 Apr 2017 20:26:11 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
Message-ID: <20170428182611.t77hv3ufstlrntmf@earth>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
 <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
 <20170428150859.GI3780@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="unjhfg6llgi42tc2"
Content-Disposition: inline
In-Reply-To: <20170428150859.GI3780@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--unjhfg6llgi42tc2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 28, 2017 at 08:08:59AM -0700, Tony Lindgren wrote:
> * Tomi Valkeinen <tomi.valkeinen@ti.com> [170428 04:15]:
> > On 14/04/17 13:25, Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > >=20
> > > The CEC pin was always pulled up, making it impossible to use it.
> > >=20
> > > Change to PIN_INPUT so it can be used by the new CEC support.
> ...
>=20
> > Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> >=20
> > Tony, can you queue this? It's safe to apply separately from the rest of
> > the HDMI CEC work.
>=20
> Sure will do.

I guess the same patch should be applied to Droid 4?

-- Sebastian

--unjhfg6llgi42tc2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkDiUEACgkQ2O7X88g7
+pp44xAAniaDvSTIAwPZmu/zjflyeSIbzC4je90amggXGafCpIbnq1A33VY1JmcE
vOeB4Z9GmUi7eUS4UsnRsZzz8fAzjJSkrsEeh1cVRK7L/yRtvPb7bJ4reHQr3WWs
R7ewN8KdEJPzuNi9TGyUfPwUG2Y95Il60FFFqMYHZog/tqyAG1GDrDt9MRd4mvVO
cZiYskFc2Xf4Lyq0CXbUcrsPNapWmS3u73lXNzTqovEEkOuMz0ke7jX7UbXNGOOn
fA0t0J0/2nnfyDWTpyYK0PRW0IoMD8o86lLv0aY+d7T0YJf50ueRuirzqCMv1sD7
iT60PHUOny4nGh4wR1GXaFhrZTGz79Wjill5Zb/vWnrLRe9YF4KjsAnjKotlIPhI
Adf5BtWKiNFF5LZK8lG211NhAkEjVcBFJZMaGPTvjNxkhgP8xXOJpDuDvA9z51L2
JQEwqmawSmtYWznsIHFDTM/8VulcfqC3y4slDZfqu2+4sU4ThY2KIZz82nln3A5R
/UKS3rTerN2CpTkSkpKNa/uHIrGR/+7rq2WA2R1vu/zyf28nhTI+cFnyUg34re8+
lXVmDLGYxRsarAn81rBBFuw9K4ldcBusUKZ31IIbaDL5gG6veX3PY+k7zXtz3DU/
4a2iH9wUwfrgkUTnnm8Qksoi+e6+2SdUNaKXmwk0eMd22YXJ7VI=
=vt/+
-----END PGP SIGNATURE-----

--unjhfg6llgi42tc2--
