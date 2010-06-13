Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.tu-cottbus.de ([141.43.99.248]:39426 "EHLO
	smtp2.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab0FMPP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 11:15:29 -0400
Date: Sun, 13 Jun 2010 17:09:38 +0200
From: Eugeniy Meshcheryakov <eugen@debian.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with em28xx card, PAL and teletext
Message-ID: <20100613150938.GA5483@localhost.localdomain>
References: <20100317145900.GA7875@localhost.localdomain>
 <829197381003170843u73743ccand32e7d0d2e6d3ca6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <829197381003170843u73743ccand32e7d0d2e6d3ca6@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I was waiting with reply to look at improvements you made in the driver.
But the problem did not go away. Actually it became worser. In recent
kernels the picture is not only shifted, but amount of shift changes
with the time. Every second or so picture is shifted 1-2 pixels right
or left. This problem is introduced with this patch:

   V4L/DVB: em28xx: rework buffer pointer tracking for offset to start of v=
ideo
   5fee334039550bdd5efed9e69af7860a66a9de37

After reverting this patch the picture does not move anymore. Also there
is still green line on the bottom, and still some pixels that should be
on the right edge are on the left edge.

I'm using mplayer to watch tv. If it helps, it is cable tv in Germany.
Some maplyer parameters related to tv:
norm=3Dpal-bg:device=3D/dev/video1:tdevice=3D/dev/vbi0:width=3D640:height=
=3D480:alsa=3Dyes:adevice=3Dhw.2,0:amode=3D1:immediatemode=3D0:audiorate=3D=
48000

Regards,
Eugeniy Meshcheryakov

17 =D0=B1=D0=B5=D1=80=D0=B5=D0=B7=D0=BD=D1=8F 2010 =D0=BE 11:43 -0400 Devin=
 Heitmueller =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=B2(-=D0=BB=D0=B0):
> On Wed, Mar 17, 2010 at 10:59 AM, Eugeniy Meshcheryakov
> <eugen@debian.org> wrote:
> > Hello,
> >
> > I have a Pinnacle Hybrid Pro Stick (in kernel source "Pinnacle Hybrid
> > Pro (2)", driver em28xx). Several kernel releases ago it started to have
> > problem displaying analog tv correctly. The picture is shifted and
> > there is green line on the bottom (see http://people.debian.org/~eugen/=
tv.png).
> > Also part of the picture is shifted from the right edge to the left
> > (several columns). TV norm is PAL-BG. I noticed that teletext is also
> > not correct. I can see some full words, but text itself is not readable.
> > Picture is correct if i load em28xx with disable_vbi=3D1.
> >
> > Please CC me in replies.
> >
> > Regards,
> > Eugeniy Meshcheryakov
>=20
> The green line is because in order to add the VBI support I had to
> crop a few lines off of the active video area at the top.  I've
> actually made some additional improvements in this area on a
> development tree which I am preparing to submit upstream.  Most
> applications such as tvtime crop the area in question (around 1.5% on
> all edges) to behave comparably to a television, which results in
> users not seeing the top and bottom couple of lines.
>=20
> The teletext should be working (it was tested against a live source).
> Which application are you using?  It's been my experience that the
> application support for VBI could be described as "crappy at best", so
> it wouldn't surprise me to find that there is an application level
> issue.
>=20
> Devin
>=20
>=20
> --=20
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwU9LIACgkQKaC6+zmozOLSJwCfV13finqSfiL8s3E3lQCsuu28
GcEAn2Zg9/rE9VjfgFsQV+pFmdlImEFy
=V4X6
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
