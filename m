Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44790 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdBNWi4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 17:38:56 -0500
Date: Tue, 14 Feb 2017 23:38:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [PATCH 2/4] Core changes for CCP2/CSI1 support.
Message-ID: <d4975edca738adaf3d263b100f7c1219a0bf8c08.1487111824.git.pavel@ucw.cz>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sakari Ailus <sakari.ailus@iki.fi>

CCP2, or CSI-1, is an older single data lane serial bus. Add core
support neccessary for it.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 include/media/v4l2-mediabus.h |  4 ++++
 include/media/v4l2-of.h       | 17 +++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 34cc99e..315c167 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -69,11 +69,15 @@
  * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
  * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
  *			also be used for BT.1120
+ * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
+ * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
  * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
  */
 enum v4l2_mbus_type {
 	V4L2_MBUS_PARALLEL,
 	V4L2_MBUS_BT656,
+	V4L2_MBUS_CSI1,
+	V4L2_MBUS_CCP2,
 	V4L2_MBUS_CSI2,
 };
=20
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 4dc34b2..63a52ee 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -53,6 +53,22 @@ struct v4l2_of_bus_parallel {
 };
=20
 /**
+ * struct v4l2_of_bus_csi1 - CSI-1/CCP2 data bus structure
+ * @clock_inv: polarity of clock/strobe signal
+ *	       false - not inverted, true - inverted
+ * @strobe: false - data/clock, true - data/strobe
+ * @data_lane: the number of the data lane
+ * @clock_lane: the number of the clock lane
+ */
+struct v4l2_of_bus_mipi_csi1 {
+	bool clock_inv;
+	bool strobe;
+	bool lane_polarity[2];
+	unsigned char data_lane;
+	unsigned char clock_lane;
+};
+
+/**
  * struct v4l2_of_endpoint - the endpoint data structure
  * @base: struct of_endpoint containing port, id, and local of_node
  * @bus_type: bus type
@@ -66,6 +82,7 @@ struct v4l2_of_endpoint {
 	enum v4l2_mbus_type bus_type;
 	union {
 		struct v4l2_of_bus_parallel parallel;
+		struct v4l2_of_bus_mipi_csi1 mipi_csi1;
 		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
 	} bus;
 	u64 *link_frequencies;
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijhv0ACgkQMOfwapXb+vLSLQCcCe+nLsQ5P0aDtvv65DL1VL9Q
ZWMAn3kYuzhcprsXMDsPPRg/MjE41Uz7
=vEbr
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
