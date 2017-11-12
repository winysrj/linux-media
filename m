Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40424 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdKLL1b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Nov 2017 06:27:31 -0500
Date: Sun, 12 Nov 2017 12:27:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, sre@kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: et8ek8: Document support for flash and lens devices
Message-ID: <20171112112729.GA21247@amd>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-30-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-30-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Document dts support of LED/focus.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt=
 b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
index 0b7b6a4..e80d589 100644
--- a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
+++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
@@ -20,6 +20,13 @@ Mandatory properties
   is in hardware standby mode when the signal is in the low state.
=20
=20
+Optional properties
+-------------------
+
+- flash-leds: See ../video-interfaces.txt
+- lens-focus: See ../video-interfaces.txt
+
+
 Endpoint node mandatory properties
 ----------------------------------
=20
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloIMCEACgkQMOfwapXb+vIvvwCgovOzLS5wXz8nFZhPHXmoXMf5
yzAAnRVd8KAhtF72KttFGW2keU/MFEeH
=5wB8
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
