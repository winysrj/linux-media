Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59128 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754000AbdBNNkS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:40:18 -0500
Date: Tue, 14 Feb 2017 14:40:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 10/13] omap3isp: fix capture
Message-ID: <20170214134013.GA8611@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is neccessary for capture (not preview) to work properly on
N900. Why is unknown.
---
 drivers/media/platform/omap3isp/ispccdc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
@@ -1253,6 +1254,8 @@ static void ccdc_configure(struct isp_ccdc_device *cc=
dc)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
=20
+	printk("configuring for %d(%d)x%d\n", crop->width, ccdc->video_out.bpl_va=
lue, crop->height);
+
 	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value,
 				  format->field);
=20
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCL0ACgkQMOfwapXb+vLv3ACgnTY69ORIQVKkH6R4byddET88
idoAn1LM3qN9dRl0y2nZ2guTPc6Pxr8U
=bSYl
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
