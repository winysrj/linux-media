Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57716 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753570AbdE0IMr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 May 2017 04:12:47 -0400
Date: Sat, 27 May 2017 10:12:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] Doc*/media/uapi: fix control name
Message-ID: <20170527081239.GA9484@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

V4L2_CID_EXPOSURE_BIAS does not exist, fix documentation.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documenta=
tion/media/uapi/v4l/extended-controls.rst
index abb1057..76c5b1a 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -2019,7 +2019,7 @@ enum v4l2_exposure_auto_type -
     dynamically vary the frame rate. By default this feature is disabled
     (0) and the frame rate must remain constant.
=20
-``V4L2_CID_EXPOSURE_BIAS (integer menu)``
+``V4L2_CID_AUTO_EXPOSURE_BIAS (integer menu)``
     Determines the automatic exposure compensation, it is effective only
     when ``V4L2_CID_EXPOSURE_AUTO`` control is set to ``AUTO``,
     ``SHUTTER_PRIORITY`` or ``APERTURE_PRIORITY``. It is expressed in

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkpNPcACgkQMOfwapXb+vJulACgku9Xfrr8kWJsLjwaWjZfuCQu
Ae0Anixo323638huKc7yaRlgdPWitp7k
=0Ay3
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
