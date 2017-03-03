Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60077 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbdCCV7t (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 16:59:49 -0500
Date: Fri, 3 Mar 2017 22:48:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [media] omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for
 CCP2 mode
Message-ID: <20170303214838.GA26826@amd>
References: <20170301114545.GA19201@amd>
 <201703031931.OeUvSOwD%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <201703031931.OeUvSOwD%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on v4.10 next-20170303]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>=20

Yes, the patch is against Sakari's ccp2 branch. It should work ok there.

I don't think you can do much to fix the automated system....

										Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli55LYACgkQMOfwapXb+vJwOgCgpHtfwTUnju0cSy4GjCmwXOVh
sfcAoINCDyz4x/i56TqZlZc4ZXzFQdqx
=AbTk
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
