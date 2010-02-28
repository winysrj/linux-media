Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out108.alice.it ([85.37.17.108]:4534 "EHLO
	smtp-out108.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936423Ab0B1TTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 14:19:00 -0500
Date: Sun, 28 Feb 2010 20:18:50 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org,
	Mosalam Ebrahimi <m.ebrahimi@ieee.org>,
	Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-Id: <20100228201850.81f7904a.ospite@studenti.unina.it>
In-Reply-To: <20100228194951.1c1e26ce@tele>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
	<20100228194951.1c1e26ce@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Feb_2010_20_18_50_+0100_SENPwp89SYb3ocFD"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sun__28_Feb_2010_20_18_50_+0100_SENPwp89SYb3ocFD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Feb 2010 19:49:51 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Sat, 27 Feb 2010 21:20:27 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > +static int sd_querymenu(struct gspca_dev *gspca_dev,
> > +		struct v4l2_querymenu *menu)
> > +{
> > +	switch (menu->id) {
> > +	case V4L2_CID_POWER_LINE_FREQUENCY:
> > +		switch (menu->index) {
> > +		case 0:         /*
> > V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
> > +			strcpy((char *) menu->name, "50 Hz");
> > +			return 0;
> > +		case 1:         /*
> > V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
> > +			strcpy((char *) menu->name, "60 Hz");
> > +			return 0;
> > +		}
> > +		break;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
>=20
> In videodev2.h, there is:
>=20
> V4L2_CID_POWER_LINE_FREQUENCY_50HZ      =3D 1,
> V4L2_CID_POWER_LINE_FREQUENCY_60HZ      =3D 2,
>

Maybe we could just use
	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	=3D 0,
	V4L2_CID_POWER_LINE_FREQUENCY_50HZ	=3D 1,

It looks like the code matches the DISABLED state (writing 0 to the
register). Mosalam?

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Sun__28_Feb_2010_20_18_50_+0100_SENPwp89SYb3ocFD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuKwZoACgkQ5xr2akVTsAHd4gCgqCjrVCw2mft7s1HgLfATxw+h
nhUAnRz/CwP9uTZtxK0K6ib7DwI+LX3G
=Uoan
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Feb_2010_20_18_50_+0100_SENPwp89SYb3ocFD--
