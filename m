Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47607 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759381Ab3BXDQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Feb 2013 22:16:49 -0500
Message-ID: <1361675795.27602.9.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Firmware for cx23885 in linux-firmware.git is broken
From: Ben Hutchings <ben@decadent.org.uk>
To: Joseph Yasi <joe.yasi@gmail.com>
Cc: linux-media@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Date: Sun, 24 Feb 2013 03:16:35 +0000
In-Reply-To: <CADzA9okNTohmDwxbQNri4y8Gb-=BksugMSiCNaGMzFQXDyLu7g@mail.gmail.com>
References: <CADzA9okNTohmDwxbQNri4y8Gb-=BksugMSiCNaGMzFQXDyLu7g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1vFnLj3oEXrDOqAsbNZN"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-1vFnLj3oEXrDOqAsbNZN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-02-22 at 19:30 -0500, Joseph Yasi wrote:
> Hi,
>=20
> I'm not sure the appropriate list to email for this, but the
> v4l-cx23885-enc.fw file in the linux-firmware.git tree is incorrect.
> It is the wrong size and just a duplicate of the
> v4l-cx23885-avcore-01.fw. The correct file can be extracted from the
> HVR1800 drivers here: http://steventoth.net/linux/hvr1800/.

This was previously requested
<http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/578=
16> but unfortunately it's not clear that it would be legal to redistribute=
 firmware extracted from that driver (or the driver itself).

For now, I think we should delete the current version.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-1vFnLj3oEXrDOqAsbNZN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUSmGE+e/yOyVhhEJAQrRsw/9EigoGj+jnQVoUfqrPfqSWndfl5Fzzslw
Ii2ccAFvJrwRcquX+A95L2hlAawIHDdPQdy+DhhsVvpRGAvptTjM2R6L9TQnMBDa
xTdqvjO9nWHQPW+w0cwFuAhiVo7z56LjIr9DQA8+F/oUFhTAicpntkNNdpQMh7lY
Dqec05qbtnAjyvmAaK5KEyxOdX9KtXDP0U8Ag5Cu06bfNlmDhDatSTA5QzeASPLA
I7cLH4GHfEYEebVlzhTrk7IsqZeiD6QQDrFWTqqYwW3GEEC8JKstEYwgUlNjh2Wt
EMktelQ3hw1hILzyVhC8S2db43YVcOyDVMQb6ScwoG43oU8b0dRdMP54odqZ64Qy
klZx87qEvITZPcA8td9GPtUcARcRNkmdpO8aKyUsPXgXK8Yu573oeHLNX3mtjREN
S/wFnW2QvZo9BNJKVWgAM9cVHooRh3SSZg33mkjEntTDGh0gSaSJs2mUL2jMbF1J
PbhS8c2a3UDjW3BngRBvPI2VxLPQJciBVy6uZ+iLD+ECV0DbV0ZEJ0B+7C9skig4
0oGYV4oe48u1syqibdVuN5titMLTaZDQ0/bSx/QPQAthjqi0+1vGsrkumKIU+/1h
TADc5bJK+5l+6vqi5q9x0SxPf4v44YF70mdeX6uRvZrDhxPSiAELoTKAGhgpT5jj
894NnMO5Rwg=
=U36w
-----END PGP SIGNATURE-----

--=-1vFnLj3oEXrDOqAsbNZN--
