Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57224 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbdKAPcJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 11:32:09 -0400
Date: Wed, 1 Nov 2017 16:32:07 +0100
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
Message-ID: <20171101153207.GA28559@amd>
References: <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426082608.7dd52fbf@vento.lan>
 <20171021220026.GA26881@amd>
 <f85cab54-30cf-0774-7376-abced86842af@xs4all.nl>
 <20171023185414.GA2258@amd>
 <40C85971-7DDE-4FB0-AB90-C52CA864C0D4@xs4all.nl>
 <20171023201557.hecu4e6o3ynp5hmv@valkosipuli.retiisi.org.uk>
 <20171031212812.GA11148@amd>
 <20171101063655.GA16895@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20171101063655.GA16895@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Sakari, I am actually playing with N9 camera, not N950. That comes
> > next.
> >=20
> > And the clock error I mentioned ... seems to be
> > -EPROBE_DEFER. So... not an issue.
>=20
> Hmm, and with similar config, I got N950 to work. ... which should
> give me enough clues to get N9 to work. I guess I forgot to reset the
> pipeline between the tries, or something.
>=20
> For the record, this got me some data on n950:
>=20
>  m.media_ctl( [ '-f', '"OMAP3 ISP CSI2a":0 [fmt:%s/%dx%d]' % (m.fmt, m.ca=
p_x, m.cap_y) ] )
>  m.media_ctl( [ '-l', '"OMAP3 ISP CSI2a":1 -> "OMAP3 ISP CSI2a output":0[=
1]' ] )
>=20
>  # WORKS!!!!
>  # pavel@n900:~/g/tui/camera$ sudo /my/tui/yavta/yavta
>  # --capture=3D8 --skip 0 --format SGRBG10 --size 4272x3016 /dev/video1 -=
-file=3D/tmp/delme#
>=20
> ...ouch. It only worked twice :-(. Either driver gets confused by my
> attempts, or it relied on some other initialization code. Strange.

Hmm, so it works "reliably" after boot. But it also locks up machine
with high probability. If you have N950, it might still be handy...

Messages are:

['-r']
['-f', '"OMAP3 ISP CSI2a":0 [fmt:SGRBG10/4272x3016]']
Warning: the -f option is deprecated and has been replaced by -V.
['-l', '"OMAP3 ISP CSI2a":1 -> "OMAP3 ISP CSI2a output":0[1]']
Testing: is raw
Testing:  /my/tui/yavta/yavta --capture=3D8 --skip 0 --format SGRBG10
--size 4272x3016 /dev/video_sensor --file=3D/tmp/delme#
Error opening device /dev/video_sensor: Permission denied (13).
Raw mode is  1
Raw mode is  1
Testing: is raw
Testing:  /my/tui/yavta/yavta --capture=3D8 --skip 0 --format SGRBG10
--size 4272x3016 /dev/video_sensor --file=3D/tmp/delme#
Device /dev/video_sensor opened.
Device `OMAP3 ISP CSI2a output' on `media' is a video capture (without
mplanes) device.
Video format set: SGRBG10 (30314142) 4272x3016 (stride 8544) field
none buffer size 25768704
Video format: SGRBG10 (30314142) 4272x3016 (stride 8544) field none
buffer size 25768704
1 buffers requested.
length: 25768704 offset: 0 timestamp type/source: mono/EoF
Buffer 0/0 mapped at address 0xb54e9000.
0 (0) [-] none 0 25768704 B 691.756907 691.758403 6.212 fps ts
mono/EoF
1 (0) [-] none 1 25768704 B 694.821025 694.821422 0.326 fps ts
mono/EoF
2 (0) [E] none 2 25768704 B 698.530833 698.534739 0.270 fps ts
mono/EoF
3 (0) [-] none 3 25768704 B 700.788127 700.790996 0.443 fps ts
mono/EoF
(and here it locked up :-(. Sometimes it captures more.)

Thanks,

								Pavel




--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAln56PcACgkQMOfwapXb+vJl5ACfZsaVTvp6jJDxEs6OsbZPX4n2
BOMAnjh6w2YJHw/iNeGQARLtyCOjM7zB
=IXXy
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
