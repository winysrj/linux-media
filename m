Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59782 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdGRKZ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 06:25:26 -0400
Date: Tue, 18 Jul 2017 12:25:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 0/7] Omap3isp CCP2 support
Message-ID: <20170718102524.GA28992@amd>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I rebased the ccp2 branch and went through the patches. I didn't find
> anything really alarming there; I changed one commit description of
> "omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2 mode" that had
> some junk in it as well as in the last patch changed the condition in
> omap3isp_csiphy_release() that was obviously wrong.
>=20
> Let me know what you think.
>=20
> If we merge these, is there anything still missing from plain ccp2
> support?

I believe we are fine.

Tested-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Pavel Machek <pavel@ucw.cz>

There is still

commit 629fcfe04ef5f1aee5280b2e0208cc891503824a
Author: Pavel <pavel@ucw.cz>
Date:   Mon Feb 13 21:26:51 2017 +0100

    omap3isp: fix VP2SDR bit so capture (not preview) works

issue, but that's independend of ccp2 support, and driver is useful
without that fix. (Preview works ok, capture results in distorted
picture but...)

Plus I'll need to submit dts changes for N900, and subdev support for
camera flash/focus would be useful.

But with this series we have basic support in.

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllt4hQACgkQMOfwapXb+vLJOwCfd6Tofx6EL7QQ5oefMe/M1gA6
LD4An3/pUcKeAIv3VKvtgmIz+eE+ho5G
=hlwK
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
