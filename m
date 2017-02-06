Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51435 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdBFJhw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 04:37:52 -0500
Date: Mon, 6 Feb 2017 10:37:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>, mchehab@s-opensource.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        laurent.pinchart@ideasonboard.com, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: add operation to get configuration of "the other
 side" of the link
Message-ID: <20170206093748.GA17017@amd>
References: <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
 <20170203210610.GA18379@amd>
 <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
 <20170204215610.GA9243@amd>
 <20170204223350.GF12291@valkosipuli.retiisi.org.uk>
 <20170205211219.GA27072@amd>
 <20170205234011.nyttcpurodvoztor@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20170205234011.nyttcpurodvoztor@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Normally, link configuration can be determined at probe time... but
Nokia N900 has two cameras, and can switch between them at runtime, so
that mechanism is not suitable here.

Add a hook that tells us link configuration.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index cf778c5..74148b9 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -25,6 +25,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-mediabus.h>
+#include <media/v4l2-of.h>
=20
 /* generic v4l2_device notify callback notification values */
 #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
@@ -383,6 +384,8 @@ struct v4l2_mbus_frame_desc {
  * @s_rx_buffer: set a host allocated memory buffer for the subdev. The su=
bdev
  *	can adjust @size to a lower value and must not write more data to the
  *	buffer starting at @data than the original value of @size.
+ *
+ * @g_endpoint_config: get link configuration required by this device.
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 confi=
g);
@@ -415,6 +418,8 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	int (*g_endpoint_config)(struct v4l2_subdev *sd,
+			    struct v4l2_of_endpoint *cfg);
 };
=20
 /**




--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliYQ+wACgkQMOfwapXb+vLzNACfa1Mhc8Zo9eUdw8zm3gJZpG2V
PlMAoKJN5rjBHo9rNomw7tJ9p5CK0uZE
=ibQw
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
