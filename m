Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:57620 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1IAGKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 02:10:34 -0400
Date: Thu, 1 Sep 2011 08:10:32 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 16/21] [staging] tm6000: Select interface on first open.
Message-ID: <20110901061032.GG18473@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <1312442059-23935-17-git-send-email-thierry.reding@avionic-design.de>
 <4E5E934A.7000500@redhat.com>
 <20110901051945.GD18473@avionic-0098.mockup.avionic-design.de>
 <4E5F1DCA.3000804@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3607uds81ZQvwCD0"
Content-Disposition: inline
In-Reply-To: <4E5F1DCA.3000804@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3607uds81ZQvwCD0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> Em 01-09-2011 02:19, Thierry Reding escreveu:
> > * Mauro Carvalho Chehab wrote:
> >> Em 04-08-2011 04:14, Thierry Reding escreveu:
> >>> Instead of selecting the default interface setting when preparing
> >>> isochronous transfers, select it on the first call to open() to make
> >>> sure it is available earlier.
> >>
> >> Hmm... I fail to see what this is needed earlier. The ISOC endpont is =
used
> >> only when the device is streaming.
> >>
> >> Did you get any bug related to it? If so, please describe it better.
> >=20
> > I'm not sure whether this really fixes a bug, but it seems a little wro=
ng to
> > me to selecting the interface so late in the process when in fact the d=
evice
> > is already being configured before (video standard, audio mode, firmware
> > upload, ...).
>=20
> Some applications may open the device just to change the controls. All ot=
her drivers
> only set alternates/interfaces when the streaming is requested, as altern=
ates/interfaces
> are needed only there.

Okay, I didn't know that it was only necessary for streaming.

> > Thinking about it, this may actually be part of the fix for the "device=
 hangs
> > sometimes for inexplicable reasons" bug that this whole patch series se=
ems to
> > fix.
>=20
> It is unlikely, except if the firmware inside the chip is broken (unfortu=
nately,=20
> we have serious reasons to believe that the internal firmware on this chi=
pset has
> serious bugs).

Indeed! =3D)

> I prefer to not apply this patch, except if we have a good reason for tha=
t,
> as otherwise this driver will behave different than the others.

Okay, it's your call. Unfortunately I no longer have the hardware available
to test if this is really related to the bug. I'll have to check again when=
 I
have the hardware.

Thierry

--3607uds81ZQvwCD0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5fIdgACgkQZ+BJyKLjJp8AxgCfTSmXYANNvNwnUImrHtXbUHcX
0yMAnRQrcD+Hj4DZZKdIEZO6QyTHjc6J
=EpNs
-----END PGP SIGNATURE-----

--3607uds81ZQvwCD0--
