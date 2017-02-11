Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43716 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdBKXXB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Feb 2017 18:23:01 -0500
Date: Sun, 12 Feb 2017 00:22:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smiapp: add CCP2 support
Message-ID: <20170211232258.GA11232@amd>
References: <20170208131127.GA29237@amd>
 <20170211220752.zr3j7irpxl42ewo3@ihha.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20170211220752.zr3j7irpxl42ewo3@ihha.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Besides this patch, what else is needed? The CSI-2 / CCP2 support is
> missing in V4L2 OF at least. It'd be better to have this all in the same
> set.

Quite a lot of is needed.

> I pushed the two DT patches here:
>=20
> <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=3Dccp2>

Thanks for a branch. If you could the two patches that look ok there,
it would mean less work for me, I could just mark those two as applied
here.

Core changes for CSI2 support are needed.

There are core changes in notifier locking, and subdev support.

I need video-bus-switch, at least for testing.

I need subdev support for omap3isp, so that we can attach flash and
focus devices.

Finally dts support on N900 can be enabled.

Thanks,

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlifnNIACgkQMOfwapXb+vL4yQCeJZC3jF8ZTPRe+eE3OqeP6Qhi
/qUAn1kAZhKI9RP/QjRFxMQVCTil2Tjq
=EQw9
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
