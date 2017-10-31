Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60124 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753670AbdJaV2P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 17:28:15 -0400
Date: Tue, 31 Oct 2017 22:28:12 +0100
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
Subject: Nokia N9: fun with camera
Message-ID: <20171031212812.GA11148@amd>
References: <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426082608.7dd52fbf@vento.lan>
 <20171021220026.GA26881@amd>
 <f85cab54-30cf-0774-7376-abced86842af@xs4all.nl>
 <20171023185414.GA2258@amd>
 <40C85971-7DDE-4FB0-AB90-C52CA864C0D4@xs4all.nl>
 <20171023201557.hecu4e6o3ynp5hmv@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20171023201557.hecu4e6o3ynp5hmv@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Sakari, I am actually playing with N9 camera, not N950. That comes
next.

And the clock error I mentioned ... seems to be
-EPROBE_DEFER. So... not an issue.

Strange thing is, that my sensors seems to have different resolution
=66rom yours:

- entity 89: smiapp pixel_array 1-0010 (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
	                  device node name /dev/v4l-subdev9
		          pad0: Source [fmt:SRGGB10_1X10/3572x2464 field:none
	                      crop.bounds:(0,0)/3572x2464 crop:(0,0)/3572x2464]
 ->
             "smiapp binner 1-0010":0 [ENABLED,IMMUTABLE]

(And you mentioned width 3600, and SGRBG10).

I updated my scripts accordingly. Now I get

pavel@n900:~/g/tui/camera$ /my/tui/yavta/yavta -c5 -f SRGGB10
-F/tmp/foo -s 3572x2464 /dev/video1
Device /dev/video1 opened.
Device `OMAP3 ISP CSI2a output' on `media' is a video capture (without
mplanes) device.
Video format set: SRGGB10 (30314752) 3572x2464 (stride 7144) field
none buffer size 17602816
Video format: SRGGB10 (30314752) 3572x2464 (stride 7144) field none
buffer size 17602816
2 buffers requested.
length: 17602816 offset: 0 timestamp type/source: mono/EoF
Buffer 0/0 mapped at address 0xb5cb1000.
length: 17602816 offset: 17604608 timestamp type/source: mono/EoF
Buffer 1/0 mapped at address 0xb4be7000.

=2E..but here it hangs. (Kernel v4.13).

dmesg says:

[ 2862.229736] smiapp 1-0010: flip 0
[ 2862.229766] smiapp 1-0010: new pixel order RGGB
[ 2862.233764] smiapp 1-0010: 0x00021700 "min_frame_length_lines_bin"
=3D 166, 0xa6
[ 2862.234558] smiapp 1-0010: 0x00021702 "max_frame_length_lines_bin"
=3D 65535, 0xffff
[ 2862.235351] smiapp 1-0010: 0x00021704 "min_line_length_pck_bin" =3D
3812, 0xee4
[ 2862.236114] smiapp 1-0010: 0x00021706 "max_line_length_pck_bin" =3D
32752, 0x7ff0
[ 2862.238067] smiapp 1-0010: 0x00021708 "min_line_blanking_pck_bin" =3D
240, 0xf0
[ 2862.240844] smiapp 1-0010: 0x0002170a
"fine_integration_time_min_bin" =3D 0, 0x0
[ 2862.242553] smiapp 1-0010: 0x0002170c
"fine_integration_time_max_margin_bin" =3D 0, 0x0
[ 2862.242614] smiapp 1-0010: vblank   	 26
[ 2862.242645] smiapp 1-0010: hblank		240
[ 2862.242675] smiapp 1-0010: real timeperframe	100/839

I did some more experiments, but could not grab a frame.

Best regards,
									Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAln46uwACgkQMOfwapXb+vI4wQCcDnSoPXKD9u552laIAG9RpKBx
YfEAmgM7yKPCzclVB+2YDWtepocg/WZ/
=+qTq
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
