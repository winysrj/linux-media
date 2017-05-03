Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35973 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754402AbdECTun (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 15:50:43 -0400
Date: Wed, 3 May 2017 21:50:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
Message-ID: <20170503195039.GB12396@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <db549a81-0c1f-3ff0-6293-050ec2e0af84@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <db549a81-0c1f-3ff0-6293-050ec2e0af84@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Could you try to two patches I've applied on the ccp2 branch (I'll remo=
ve
> > them if there are issues).
> >=20
> > That's compile tested for now only.
> >=20
>=20
> I've updated the CCP2 patches here on top of the latest fwnode patches:
>=20
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=3Dccp2>
>=20
> No even compile testing this time though. I'm afraid I haven't had the
> time to otherwise to work on the CCP2 support, so there are no other
> changes besides the rebase.

It seems they don't compile. Hmmm. Did I do something wrong? "struct
fwnode_endpoint" seems to be only used in v4l2-fwnode.h; that can't be righ=
t...?

  CC      drivers/media/i2c/smiapp/smiapp-core.o
  In file included from drivers/media/i2c/smiapp/smiapp-core.c:35:0:
  ./include/media/v4l2-fwnode.h:83:25: error: field 'base' has
  incomplete type
  drivers/media/i2c/smiapp/smiapp-core.c: In function
  'smiapp_get_hwconfig':
  drivers/media/i2c/smiapp/smiapp-core.c:2790:9: error: implicit
  declaration of function 'dev_fwnode'
  [-Werror=3Dimplicit-function-declaration]
  drivers/media/i2c/smiapp/smiapp-core.c:2790:33: warning:
  initialization makes pointer from integer without a cast [enabled by
  default]
  drivers/media/i2c/smiapp/smiapp-core.c:2797:2: error: implicit
  declaration of function 'fwnode_graph_get_next_endpoint'
  [-Werror=3Dimplicit-function-declaration]

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkKNI8ACgkQMOfwapXb+vLvjACfbtPfVbjxzMYCJSfuKP00X96Y
zj4AnjA9RQIvbOfng+IgRpDipeQm/cAd
=zS1z
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
