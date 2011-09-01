Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1IAFN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 01:13:27 -0400
Date: Thu, 1 Sep 2011 07:13:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 07/21] [staging] tm6000: Remove artificial delay.
Message-ID: <20110901051324.GC18473@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <1312442059-23935-8-git-send-email-thierry.reding@avionic-design.de>
 <4E5E9089.8030804@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
In-Reply-To: <4E5E9089.8030804@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> Em 04-08-2011 04:14, Thierry Reding escreveu:
> > ---
> >  drivers/staging/tm6000/tm6000-core.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6=
000/tm6000-core.c
> > index e14bd3d..2c156dd 100644
> > --- a/drivers/staging/tm6000/tm6000-core.c
> > +++ b/drivers/staging/tm6000/tm6000-core.c
> > @@ -86,9 +86,6 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8=
 req_type, u8 req,
> >  	}
> > =20
> >  	kfree(data);
> > -
> > -	msleep(5);
> > -
> >  	return ret;
> >  }
> > =20
>=20
> This delay is needed by some tm5600/6000 devices. Maybe it is due to
> some specific chipset revision, but I can't remember anymore what
> device(s) were affected.
>=20
> The right thing to do seems to whitelist the devices that don't need
> any delay there.

This was actually the first thing I patched because I couldn't see any need
for it (the Cinergy Hybrid USB Stick worked fine without) and it made the
device pretty much unusable (with this delay, firmware loading takes about
30 seconds!).

Do you want me to follow up with a white-listing patch?

Thierry

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5fFHQACgkQZ+BJyKLjJp9m/wCfUTA5GNh7uS9R7qRnczuY4mac
vs0An0qILatL97gC0Z3lBaCTYrscVB5e
=Qf+P
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
