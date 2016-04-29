Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42273 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2RqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 13:46:08 -0400
Date: Fri, 29 Apr 2016 19:45:59 +0200
From: Sebastian Reichel <sre@kernel.org>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?=
	<ivo.g.dimitrov.75@gmail.com>
Cc: pavel@ucw.cz, sakari.ailus@iki.fi, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160429174559.GA6431@earth>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com>
 <20160427164256.GA8156@earth>
 <1461777170.18568.2.camel@Nokia-N900>
 <20160429000551.GA29312@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20160429000551.GA29312@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 29, 2016 at 02:05:52AM +0200, Sebastian Reichel wrote:
> On Wed, Apr 27, 2016 at 08:12:50PM +0300, =D0=98=D0=B2=D0=B0=D0=B9=D0=BB=
=D0=BE =D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2 wrote:
> > > The zImage + initrd works with the steps you described below.
> >=20
> > Great!
>=20
> I also got it working with the previously referenced branch with the
> following built as modules:
>=20
> CONFIG_VIDEOBUF2_CORE=3Dm
> CONFIG_VIDEOBUF2_MEMOPS=3Dm
> CONFIG_VIDEOBUF2_DMA_CONTIG=3Dm
> CONFIG_VIDEO_OMAP3=3Dm
> CONFIG_VIDEO_BUS_SWITCH=3Dm
> CONFIG_VIDEO_SMIAPP_PLL=3Dm
> CONFIG_VIDEO_SMIAPP=3Dm
> CONFIG_VIDEO_SMIAREGS=3Dm
> CONFIG_VIDEO_ET8EK8=3Dm

Ok, I found the problem. CONFIG_VIDEO_OMAP3=3Dy does not work,
due to missing -EPROBE_DEFER handling for vdds_csib. I added
it and just got a test image with builtin CONFIG_VIDEO_OMAP3.
The below patch fixes the problem.

commit 9d8333b29207de3a9b6ac99db2dfd91e2f8c0216
Author: Sebastian Reichel <sre@kernel.org>
Date:   Fri Apr 29 19:23:02 2016 +0200

    omap3isp: handle -EPROBE_DEFER for vdds_csib
   =20
    omap3isp may be initialized before the regulator's driver has been
    loaded resulting in vdds_csib=3DNULL. Fix this by handling -EPROBE_DEFER
    for vdds_csib.
   =20
    Signed-Off-By: Sebastian Reichel <sre@kernel.org>

diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/plat=
form/omap3isp/ispccp2.c
index 833eed411886..2d1463a72d6a 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1167,6 +1167,8 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 	if (isp->revision =3D=3D ISP_REVISION_2_0) {
 		ccp2->vdds_csib =3D devm_regulator_get(isp->dev, "vdds_csib");
 		if (IS_ERR(ccp2->vdds_csib)) {
+			if (PTR_ERR(ccp2->vdds_csib) =3D=3D -EPROBE_DEFER)
+				return -EPROBE_DEFER;
 			dev_dbg(isp->dev,
 				"Could not get regulator vdds_csib\n");
 			ccp2->vdds_csib =3D NULL;

-- Sebastian

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXI53UAAoJENju1/PIO/qaIKYQAJkB02X6T1Hxfbq2tHl7rPin
Wz/rzlIkGK1DSOW5xRiTRvqbQX1TAants13YisR9avcb4nnE7kubsjBrTqgWtLAQ
1VhZzANzXuVDvQpyG77x4PuA+XNs/zK9//s3+h/mQ3MbX2Nkie1KGHs4JbSgukro
0XrfityWIITVDoGQO9IzX3IaXHT3smENAcdJcR58aSEXaEDxwvE7ZB/9+saD1mab
Fni1CCvbDCW90RQ0h1CwRXaBBICTISBGLbqvQHLuPsbx5G+Sfk9C8e5BujIWKXb6
RHPEl2Krcb63zwce91rYH2QorAjsemaoi5L50nJ25Om0G+z+TPbCFAIXpZzhj0ul
gBTDiZ6Jo07OMb0s8L7zWFVpioKVBk0dE2SAUw35zCL68VKKIgwmWj6jgw4P+8v+
lGYFE1uXILhkYugwDLndSsdHC6PhRRjXLGsaHemzYRPgeuW2nINxIQJbNbRsejqd
vgrGc4PaW/X9tti9djTObFXfDCiZi7yHMU4FWooxOdilB95+4+sMQYJmAgWFTaHY
aduARuA70nJl/hjd5CnK88dk6EeOkOw3Xi+3ju6DKogal39o+MFp9R3LFPlOgSIn
WO0aIt3S5GAmmGe8iOLsZIkLUXg1ub/0U9xrTTHb5BzgwFjgjt7zrUKwS5C3CpAi
nd5Y+W3YZa3HMql6XGtZ
=f2A5
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
