Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54829 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbcL0U70 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 15:59:26 -0500
Date: Tue, 27 Dec 2016 21:59:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mark myself as mainainer for camera on N900
Message-ID: <20161227205923.GA7859@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161227092634.GK16630@valkosipuli.retiisi.org.uk>
 <20161227204558.GA23676@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20161227204558.GA23676@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Mark and Sakari as maintainers for Nokia N900 camera pieces.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

Hi!

> Yeah, there was big flamewar about the permissions. In the end Linus
> decided that everyone knows the octal numbers, but the constants are
> tricky. It began with patch series with 1000 patches...
>=20
> > Btw. should we update maintainers as well? Would you like to put yourse=
lf
> > there? Feel free to add me, too...
>=20
> Ok, will do.

Something like this? Actually, I guess we could merge ADP1653 entry
there. Yes, it is random collection of devices, but are usually tested
"together", so I believe one entry makes sense.

(But I have no problem with having multiple entries, too.)

Thanks,
								Pavel


diff --git a/MAINTAINERS b/MAINTAINERS
index 63cefa6..1cb1d97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8613,6 +8613,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git=
/lftan/nios2.git
 S:	Maintained
 F:	arch/nios2/
=20
+NOKIA N900 CAMERA SUPPORT (ET8EK8 SENSOR, AD5820 FOCUS)
+M:	Pavel Machek <pavel@ucw.cz>
+M:	Sakari Ailus <sakari.ailus@iki.fi>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/et8ek8
+F:	drivers/media/i2c/ad5820.c
+
 NOKIA N900 POWER SUPPLY DRIVERS
 R:	Pali Roh=E1r <pali.rohar@gmail.com>
 F:	include/linux/power/bq2415x_charger.h



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhi1isACgkQMOfwapXb+vJQ6ACfT+9U0uAJNcOJQTj2SFd/W8J3
nAcAnA4Ux50PEHs0gNoFbNivHs/NOG3S
=19H3
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
