Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36672 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbdCFHcu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 02:32:50 -0500
Date: Mon, 6 Mar 2017 08:23:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: [PATCH] v4l2-fwnode: Fix clock lane parsing
Message-ID: <20170306072323.GA23509@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fix clock lane parsing in v4l2-fwnode.
   =20
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-cor=
e/v4l2-fwnode.c
index d6666d3..44036b8 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -167,7 +167,7 @@ void v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_=
handle *fwn,
                bus->data_lane =3D v;
=20
        if (!fwnode_property_read_u32(fwn, "clock-lanes", &v))
-               bus->data_lane =3D v;
+               bus->clock_lane =3D v;
=20
        if (bus_type =3D=3D V4L2_FWNODE_BUS_TYPE_CCP2)
 	       vfwn->bus_type =3D V4L2_MBUS_CCP2;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli9DmsACgkQMOfwapXb+vIzLACgq4focZdJCGxfNBogfvTptqBx
DEwAn11zwZBU8TZu49EhB6ydT9TGzIPK
=YsJ8
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
