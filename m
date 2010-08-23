Return-path: <mchehab@pedra>
Received: from server.klug.on.ca ([205.189.48.131]:4277 "EHLO
	server.klug.on.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0HWOd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 10:33:27 -0400
Subject: Re: hvr950q stopped working: read of drv0 never returns
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTim0Gn8F9bjsnykOkfn54dajtnJRryhRQdJ76thw@mail.gmail.com>
References: <1282537951.32217.3874.camel@pc.interlinx.bc.ca>
	 <AANLkTim0Gn8F9bjsnykOkfn54dajtnJRryhRQdJ76thw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UP82uGXXnGzyiRpwKv9H"
Date: Mon, 23 Aug 2010 10:33:22 -0400
Message-ID: <1282574002.32217.4511.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


--=-UP82uGXXnGzyiRpwKv9H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-08-23 at 07:19 -0400, Devin Heitmueller wrote:=20
>=20
> Hi Brian,

Hi Devin,

> What command are you using to control the frontend?  If it's "azap",
> did you remember to specify the "-r" argument?

Uh-oh.  Here comes a grand display of my ignorance for the manual
workings of this device.  :-/

Primarily I use this device with Mythtv but have been forced into trying
to debug this as it's not working in Myth.  I thought that using this
device was as simple as one of the PVR-{50,{1.2}5}0 devices and I could
just "cat < /dev/dvb/adapter0/dvr0 > file.mpg".

Your reference to azap gave me something to research.  Subsequently I
have done the following:

$ brian@pc:~$ w_scan -c US -x -A2 > /tmp/initial-tuning-data.txt
$ mkdir ~/.azap
$ scan -A2 initial-tuning-data.txt > ~/.azap/channels.conf

But now I can't get azap to do anything useful:

$ azap -r 291
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ERROR: could not find channel '291' in channel list
$ azap -r 145
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ERROR: error while parsing modulation (syntax error)

Not sure what to try next.

b.


--=-UP82uGXXnGzyiRpwKv9H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxyhq8ACgkQl3EQlGLyuXD5NACgtCTDy4Ils2zisYMw0tqgumJ0
eRAAoISSNWrbqwk+xFk5dQ+wwU5djPjA
=D1Y8
-----END PGP SIGNATURE-----

--=-UP82uGXXnGzyiRpwKv9H--

