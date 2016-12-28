Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49407 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbcL1Saj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Dec 2016 13:30:39 -0500
Date: Wed, 28 Dec 2016 19:30:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sakari.ailus@iki.fi, sre@kernel.org,
        pali.rohar@gmail.com, pavel@ucw.cz, linux-media@vger.kernel.org
Subject: [PATCH] dt: bindings: Add support for CSI1 bus
Message-ID: <20161228183036.GA13139@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sakari Ailus <sakari.ailus@iki.fi>

In the vast majority of cases the bus type is known to the driver(s)
since a receiver or transmitter can only support a single one. There
are cases however where different options are possible.

Document the CSI1/CCP2 properties strobe_clk_inv and strobe_clock
properties. The former tells whether the strobe/clock signal is
inverted, while the latter signifies the clock or strobe mode.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b=
/Documentation/devicetree/bindings/media/video-interfaces.txt
index 9cd2a36..f0523f7 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -76,6 +76,10 @@ Optional endpoint properties
   mode horizontal and vertical synchronization signals are provided to the
   slave device (data source) by the master device (data sink). In the mast=
er
   mode the data source device is also the source of the synchronization si=
gnals.
+- bus-type: data bus type. Possible values are:
+  0 - CSI2
+  1 - parallel / Bt656
+  2 - CCP2
 - bus-width: number of data lines actively used, valid for the parallel bu=
sses.
 - data-shift: on the parallel data busses, if bus-width is used to specify=
 the
   number of data lines, data-shift can be used to specify which data lines=
 are
@@ -110,9 +114,10 @@ Optional endpoint properties
   lane and followed by the data lanes in the same order as in data-lanes.
   Valid values are 0 (normal) and 1 (inverted). The length of the array
   should be the combined length of data-lanes and clock-lanes properties.
-  If the lane-polarities property is omitted, the value must be interpreted
-  as 0 (normal). This property is valid for serial busses only.
-
+- clock-inv: Clock or strobe signal inversion.
+  Possible values: 0 -- not inverted; 1 -- inverted
+- strobe: Whether the clock signal is used as clock or strobe. Used
+  with CCP2, for instance.
=20
 Example
 -------


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhkBMwACgkQMOfwapXb+vIeugCcDQbShBzmWUEpckTMNxoGKCqc
pY0AoJalxbLyE/pMuLZG/PTDl6OVxj5g
=+RWz
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
