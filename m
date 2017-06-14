Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40852 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbdFNTlb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 15:41:31 -0400
Date: Wed, 14 Jun 2017 21:41:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: v4l2-fwnode: status, plans for merge, any branch to merge
 against?
Message-ID: <20170614194128.GA5669@amd>
References: <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > Are there any news about the fwnode branch?
> > > >=20
> > > > I have quite usable camera, but it is still based on
> > > > 982e8e40390d26430ef106fede41594139a4111c (that's v4.10). It would be
> > > > good to see fwnode stuff upstream... are there any plans for that?
> > > >=20
> > > > Is there stable branch to which I could move the stuff?
> > >=20
> > > What's relevant for most V4L2 drivers is in linux-media right now.
> > >=20
> > > There are new features that will take some time to get in. The troubl=
e has
> > > been, and continue to be, that the patches need to go through various=
 trees
> > > so it'll take some time for them to be merged.
> > >=20
> > > I expect to have most of them in during the next merge window.
> >=20
> > So git://linuxtv.org/media_tree.git branch master is the right one to
> > work one?
>=20
> I also pushed the rebased ccp2 branch there:
>=20
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=3Dccp2>
>=20
> It's now right on the top of media-tree master.

Thanks, that's what I was looking for.

Unfortunately, it does not compile.

  CC      drivers/media/platform/omap3isp/ispcsiphy.o
  drivers/media/platform/omap3isp/isp.c: In function
  'isp_fwnode_parse':
  drivers/media/platform/omap3isp/isp.c:2029:35: error: 'fwn'
  undeclared (first use in this function)
  drivers/media/platform/omap3isp/isp.c:2029:35: note: each undeclared
  identifier is reported only once for each function it appears in
  drivers/media/platform/omap3isp/isp.c:2029:2: error: incompatible
  type for argument 2 of 'v4l2_fwnode_endpoint_parse'
  In file included from drivers/media/platform/omap3isp/isp.c:67:0:
  ./include/media/v4l2-fwnode.h:112:5: note: expected 'struct
  v4l2_fwnode_endpoint *' but argument is of type 'struct
  v4l2_fwnode_endpoint'
  scripts/Makefile.build:302: recipe for target
  'drivers/media/platform/omap3isp/isp.o' failed
  make[4]: *** [drivers/media/platform/omap3isp/isp.o] Error 1
  make[4]: *** Waiting for unfinished jobs....
  scripts/Makefile.build:561: recipe for target
  'drivers/media/platform/omap3isp' failed
  make[3]: *** [drivers/media/platform/omap3isp] Error 2

You can get my config if needed. Now let me try to fix it... It was
not too bad, good.

commit 364340e7aa037535a65d2ef2a1711c97d233fede
Author: Pavel <pavel@ucw.cz>
Date:   Wed Jun 14 21:40:37 2017 +0200

Fix compilation of omap3isp/isp.c.
   =20
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index 4ca3fc9..b80debf 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2026,7 +2026,7 @@ static int isp_fwnode_parse(struct device *dev, struc=
t fwnode_handle *fwnode,
=20
 	isd->bus =3D buscfg;
=20
-	ret =3D v4l2_fwnode_endpoint_parse(fwn, vep);
+	ret =3D v4l2_fwnode_endpoint_parse(fwnode, &vep);
 	if (ret)
 		return ret;
=20

									Pavel
 =20
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllBkWgACgkQMOfwapXb+vKKYQCgk4H0wXEnRUSs5DEh7YxkIOdb
rMsAn2f6gvWoJOLGC5YUPcTmWXA8kjDZ
=N8aT
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
