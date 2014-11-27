Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:51446 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaK0Ftt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 00:49:49 -0500
Received: by mail-qa0-f42.google.com with SMTP id j7so2937091qaq.1
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 21:49:48 -0800 (PST)
Date: Thu, 27 Nov 2014 02:49:44 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Andrey Utkin <andrey.krieger.utkin@gmail.com>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any
 ideas or help?
Message-ID: <20141127024944.3161f7b7@pirotess.bf.iodev.co.uk>
In-Reply-To: <m3wq6ww602.fsf@t19.piap.pl>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<m3sihmf3mc.fsf@t19.piap.pl>
	<CANZNk81y8=ugk3Ds0FhoeYBzh7ATy1Uyo8gxUQFoiPcYcwD+yQ@mail.gmail.com>
	<CAM_ZknUoNBfnKJW-76FE1tW29O6oFAw+KDYPsViTLw7u-vFXuw@mail.gmail.com>
	<m3wq6ww602.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/zfaQiG0ilO97ZF=hq5_+wlK"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/zfaQiG0ilO97ZF=hq5_+wlK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Nov 2014 21:42:05 +0100
khalasa@piap.pl (Krzysztof Ha=C5=82asa) wrote:
> Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:
>=20
> > In upstream there's no more module parameter for video standard
> > (NTSC/PAL). But there's VIDIOC_S_STD handling procedure. But it
> > turns out not to work correctly: the frame is offset, so that in
> > the bottom there's black horizontal bar.
> > The S_STD ioctl call actually makes difference, because without that
> > the frame "slides" vertically all the time. But after the call the
> > picture is not correct.
>=20
> Which kernel version are you using?
> I remember there were some problems with earlier versions, where the
> NTSC vs PAL wasn't consistenly a bool but rather a raw register value
> (or something like this), but it was fixed last time I checked.
> I'm personally using SOLO6110-based cards with v3.17 and PAL and it
> works, with minimal unrelated patches.
>=20

The selection works correctly for me, tested recently after a server
upgrade.

--Sig_/zfaQiG0ilO97ZF=hq5_+wlK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUdrt4AAoJEBH/VE8bKTLbjpYH/j7D5VooqxBYZZOWvS8TkLHo
mh4oIqm7QUGTtYerJMZqPho0mHgoLYCE7M9wjB/2W4n/PrPcTojGOXA4JpAZaFh3
Gf2lse8WwbGxW93TFieS5NTYtDDEi4nfQccUy3doxg2pdxiaNYh+gdnn8rnN1tAU
+EJuBPKAgO1E8mabkaz8KYI5QixIPDZCa+1sIzkDl9ylOc83eom0yKKP+OdaE547
nROZofUEWMQp4cGn0P/az/JkIWK2ZRc8xzdW0O2+IGsnktP1EegWTEHcdUcFaegc
Qu358BuNvXBmpcj1kW0azUKEEwSE2yW1zXiD/7YtJjHTmQJeuhNwXMzyWhH//2k=
=jxhi
-----END PGP SIGNATURE-----

--Sig_/zfaQiG0ilO97ZF=hq5_+wlK--
