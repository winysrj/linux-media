Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43926 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdKAGg5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 02:36:57 -0400
Date: Wed, 1 Nov 2017 07:36:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: Nokia N9: fun with camera
Message-ID: <20171101063655.GA16895@amd>
References: <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426082608.7dd52fbf@vento.lan>
 <20171021220026.GA26881@amd>
 <f85cab54-30cf-0774-7376-abced86842af@xs4all.nl>
 <20171023185414.GA2258@amd>
 <40C85971-7DDE-4FB0-AB90-C52CA864C0D4@xs4all.nl>
 <20171023201557.hecu4e6o3ynp5hmv@valkosipuli.retiisi.org.uk>
 <20171031212812.GA11148@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20171031212812.GA11148@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Sakari, I am actually playing with N9 camera, not N950. That comes
> next.
>=20
> And the clock error I mentioned ... seems to be
> -EPROBE_DEFER. So... not an issue.

Hmm, and with similar config, I got N950 to work. ... which should
give me enough clues to get N9 to work. I guess I forgot to reset the
pipeline between the tries, or something.

For the record, this got me some data on n950:

 m.media_ctl( [ '-f', '"OMAP3 ISP CSI2a":0 [fmt:%s/%dx%d]' % (m.fmt, m.cap_=
x, m.cap_y) ] )
 m.media_ctl( [ '-l', '"OMAP3 ISP CSI2a":1 -> "OMAP3 ISP CSI2a output":0[1]=
' ] )

 # WORKS!!!!
 # pavel@n900:~/g/tui/camera$ sudo /my/tui/yavta/yavta
 # --capture=3D8 --skip 0 --format SGRBG10 --size 4272x3016 /dev/video1 --f=
ile=3D/tmp/delme#

=2E..ouch. It only worked twice :-(. Either driver gets confused by my
attempts, or it relied on some other initialization code. Strange.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAln5a4cACgkQMOfwapXb+vKgFgCeIC51RHGxuOfU3rWVF/Xx54CS
1OAAoKXYL8Hg3g6SHcC8MqbTSFRldb22
=s7t5
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
