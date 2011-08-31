Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55185 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab1HaNMd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:12:33 -0400
Date: Wed, 31 Aug 2011 15:12:31 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/21] [staging] tm6000: Assorted fixes and improvements.
Message-ID: <20110831131231.GA32056@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <4E5E2BF8.6040701@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <4E5E2BF8.6040701@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> Hi Thierry,
>=20
> Em 04-08-2011 04:13, Thierry Reding escreveu:
> > This patch series fixes up some issues with the tm6000 driver. These
> > patches were tested with a Cinergy Hybrid XE which is the only one I
> > have access to, so it would be nice if someone with access to the other
> > supported devices could take this series for a test run.
> >=20
> > Among the changes are several speed-ups for firmware loading, addition
> > of radio support for the Cinergy Hybrid XE and some memory leak fixes. I
> > was able to reproduce the behaviour documented in the README about the
> > device stopping to work for unknown reasons. Running tests with this
> > series applied no longer exposes the problem, so I have high hopes that
> > it's also fixed.
>=20
> You forgot to send your Signed-off-by: at the patches you sent me. Could =
you
> please reply on this email with your SOB, for me to be able to apply them
> on my tree?
>=20
> Thanks!
> Mauro
> >=20
> > Thierry Reding (21):
> >   [media] tuner/xc2028: Add I2C flush callback.
> >   [media] tuner/xc2028: Fix frequency offset for radio mode.
> >   [staging] tm6000: Miscellaneous cleanups.
> >   [staging] tm6000: Use correct input in radio mode.
> >   [staging] tm6000: Implement I2C flush callback.
> >   [staging] tm6000: Increase maximum I2C packet size.
> >   [staging] tm6000: Remove artificial delay.
> >   [staging] tm6000: Flesh out the IRQ callback.
> >   [staging] tm6000: Rename active interface register.
> >   [staging] tm6000: Disable video interface in radio mode.
> >   [staging] tm6000: Rework standard register tables.
> >   [staging] tm6000: Add locking for USB transfers.
> >   [staging] tm6000: Properly count device usage.
> >   [staging] tm6000: Initialize isochronous transfers only once.
> >   [staging] tm6000: Execute lightweight reset on close.
> >   [staging] tm6000: Select interface on first open.
> >   [staging] tm6000: Do not use video buffers in radio mode.
> >   [staging] tm6000: Plug memory leak on PCM free.
> >   [staging] tm6000: Enable audio clock in radio mode.
> >   [staging] tm6000: Enable radio mode for Cinergy Hybrid XE.
> >   [staging] tm6000: Remove unnecessary workaround.
> >=20
> >  drivers/media/common/tuners/tuner-xc2028.c |  144 ++++---
> >  drivers/media/common/tuners/tuner-xc2028.h |    1 +
> >  drivers/staging/tm6000/tm6000-alsa.c       |    9 +-
> >  drivers/staging/tm6000/tm6000-cards.c      |   35 +-
> >  drivers/staging/tm6000/tm6000-core.c       |  102 +++--
> >  drivers/staging/tm6000/tm6000-dvb.c        |   14 +-
> >  drivers/staging/tm6000/tm6000-i2c.c        |    7 +-
> >  drivers/staging/tm6000/tm6000-input.c      |    2 +-
> >  drivers/staging/tm6000/tm6000-regs.h       |    4 +-
> >  drivers/staging/tm6000/tm6000-stds.c       |  642 ++++++++++++++------=
--------
> >  drivers/staging/tm6000/tm6000-video.c      |  188 +++++----
> >  drivers/staging/tm6000/tm6000.h            |    6 +-
> >  12 files changed, 600 insertions(+), 554 deletions(-)

Sorry for not adding it in the first place. All of the above patches:

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Thierry

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5eMz8ACgkQZ+BJyKLjJp/cbACgl/XP3seSfDk+KbAebPImBRvS
4lMAn0IZ9Na2hzMJ+X2SCs2OQBIs7qic
=qL9u
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
