Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34034 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdHHL5z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 07:57:55 -0400
Date: Tue, 8 Aug 2017 13:57:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Nokia N900 camera support in linux-next
Message-ID: <20170808115752.GA19585@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Most of CSI-1 / N900 camera support is there in linux-next tree:
patches marked "n" are in, unmarked patches are only in Sakari's tree.

Is there something I can do to help merging patches to linux-next? We
are quite close, and it would be nice to have camera support in v4.14...

Thanks,
								Pavel

369e74605f768efa74483ab08e706347756e2092 omap3isp: Skip CSI-2 receiver init=
ialisation in CCP2 configuratio$
8f7dc67fed42fa3d36f590fb42769bcf1513e37a omap3isp: Correctly put the last i=
terated endpoint fwnode always
d3e8774ca1119c264886b84d49ef28da0b459bb4 omap3isp: Always initialise isp an=
d mutex for csiphy1
n 259c3fa06348d8142406796d0e7beb5753d07d31 omap3isp: Return -EPROBE_DEFER i=
f the required regulators can't$
5034d8d8eceec96908c4659be58507177d0a462c omap3isp: Correctly set IO_OUT_SEL=
 and VP_CLK_POL for CCP2 mode
bf54a7459801bde07e3c1bfc7840f30abc296f62 omap3isp: Parse CSI1 configuration=
 from the device tree
n 07120f2667ea1c02d86dce1b3d46e28cb23e3a15 omap3isp: Ignore endpoints with =
invalid configuration
n 5151d5af4010a2aeeaff1fb05de4661f2fd6d982 omap3isp: add CSI1 support
n 7947670b57539df822cabaaf1d0e8a78fbcd1290 omap3isp: Explicitly set the num=
ber of CSI-2 lanes used in lane$
n 7f52779e72e4c14ffdffcf0cebdefde193457a82 omap3isp: Destroy CSI-2 phy mute=
xes in error and module removal
n dbd6d72970e87f39936bc036a1a9441e59177434 omap3isp: Check for valid port i=
n endpoints
n 8a61b9bf1134d7f57e2bd65aeac0b553ecc7301e smiapp: add CCP2 support
n f71d8a1c3f33b510b379278ea171d3495ac98bb6 v4l: Add support for CSI-1 and C=
CP2 busses
n 1d2e2bc5f4bf78db9aa63e68dfd44823f9b62237 v4l: fwnode: Obtain data bus typ=
e from FW
n 3e4351a7e39775ef13c51950f83c51fb5d98b33c v4l: fwnode: Call CSI2 bus csi2,=
 not csi
n 5e8535c064363713855d975f2c9777bbc739c877 dt: bindings: Add strobe propert=
y for CCP2
n 3c736565c543ec97f54f177df295ed729e80d39f dt: bindings: Explicitly specify=
 bus type


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmJp0AACgkQMOfwapXb+vKxhgCdG8QK0dnmFIFp6AwnE002stXB
dsYAn00jcbUHoN0kIGS9jdXgf1/7Vr4e
=kkoJ
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
