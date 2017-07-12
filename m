Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33472 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbdGLUbI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 16:31:08 -0400
Date: Wed, 12 Jul 2017 22:31:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: omap3isp: is capture mode working? what hardware? was Re:
 v4l2-fwnode: status, plans for merge, any branch to merge against?
Message-ID: <20170712203105.GA26734@amd>
References: <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
 <20170704150819.GA10703@localhost>
 <20170705093248.hndchnamibhqczfr@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20170705093248.hndchnamibhqczfr@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> What I've done is just rebased the ccp2 branch. In other words, the patch=
es
> in that branch are no more ready than they were.
>=20
> To get these merged we should ideally
>=20
> 1) Make sure there will be no regressions,

I grepped dts trees a bit... where is omap3isp currently used?
Anything besides N9 and N950?

Does the capture mode currently work for you?

Because as far as I can tell, formatter is disabled, so video is in
wrong format for the userspace.

So something like patch below is needed; (of course after adjusting
the comment etc.)

Thanks,
								Pavel

commit eb81524b8b44bbff2518b272cb3de304157bd3ba
Author: Pavel <pavel@ucw.cz>
Date:   Mon Feb 13 21:26:51 2017 +0100

    omap3isp: fix VP2SDR bit so capture (not preview) works
   =20
    This is neccessary for capture (not preview) to work properly on
    N900. Why is unknown.

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/plat=
form/omap3isp/ispccdc.c
index 7207558..2fb755f 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1186,7 +1186,8 @@ static void ccdc_configure(struct isp_ccdc_device *cc=
dc)
 	/* Use the raw, unprocessed data when writing to memory. The H3A and
 	 * histogram modules are still fed with lens shading corrected data.
 	 */
-	syn_mode &=3D ~ISPCCDC_SYN_MODE_VP2SDR;
+//	syn_mode &=3D ~ISPCCDC_SYN_MODE_VP2SDR;
+	syn_mode |=3D ISPCCDC_SYN_MODE_VP2SDR;
=20
 	if (ccdc->output & CCDC_OUTPUT_MEMORY)
 		syn_mode |=3D ISPCCDC_SYN_MODE_WEN;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllmhwkACgkQMOfwapXb+vJydgCgrVXXuPPfWgcdslnYbZp/eFbc
uBQAoKF/mS/j8XKEEb7aL4ljcCNppaxT
=XbeF
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
