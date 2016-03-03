Return-path: <linux-media-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:43449 "EHLO elaine.keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbcCCXX0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 18:23:26 -0500
From: Keith Packard <keithp@keithp.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Jani Nikula <jani.nikula@intel.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <20160303155037.705f33dd@recife.lan>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan>
Date: Thu, 03 Mar 2016 15:23:23 -0800
Message-ID: <86egbrm9hw.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Mauro Carvalho Chehab <mchehab@osg.samsung.com> writes:

> On my tests, Sphinix seemed too limited to format tables. Asciidoc
> produced an output that worked better.

Yes, asciidoc has much more flexibility in table formatting, including
the ability to control text layout within cells and full control over
borders.

However, I think asciidoc has two serious problems:

  1) the python version (asciidoc) appears to have been abandoned in
     favor of the ruby version.=20

  2) It really is just a docbook pre-processor. Native html/latex output
     is poorly supported at best, and exposes only a small subset of the
     full capabilities of the input language.

As such, we would have to commit to using the ruby version and either
committing to fixing the native html output backend or continuing to use
the rest of the docbook toolchain.

We could insist on using the python version, of course. I spent a bit of
time hacking that up to add 'real' support for a table-of-contents in
the native HTML backend and it looks like getting those changes
upstreamed would be reasonably straightforward. However, we'd end up
'owning' the code, and I'm not sure we want to.

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVtjHa9siGmkAAAARAQiNaw//RtWj3w/yFqFZ1dcPe09OIBoerzkkJGw0
sPTf04vADfVrDdDgu5ck3neuDE44H4+tEjcI7hDHZJzQdgTvHbkKar/MK2DzzS47
Dv/LHeD8A/uN0mH+U1zC6Zf/olJghl6l/Mve7h8ULQmz8qwzAM+G1rDIUD/gXErR
fqdQy7uPaSI0QMSjxIkXfGky7QOiCiR5Hn9KVG0+dwz9eTuUphUT0miwtSnsYjqp
6qqQhcm+iL0L2veNNJOH468+889OhUtYTfc4AWrwchjRV1Sb0hEUksRTaj1fV61e
k+ZNTmTUKDITUm+MTk4MkUvyAHr9CPU7qBJ+sytzknBIvqG2FVeIdgSnVy4ta0Pm
wuLnS0QLsphY2ESORuvWnQ9Pt1xXuouVLpY6Ef0/QVd+WBuF1Ci/m7gGfWI7L0mC
bNnnXPrd8wIWHEJndyM9ty673LTUMhugkoVJWPbeRSXptBf0a6s7r56xXa4FPyt/
sID1RD6dQkLAQ+5vTGkB9YJZZmuN/1SMSGdaECl3IpLKldAyvvx+0ejZlAJqO0+p
hG49A/WNLTGwUAMT2xu9e9AytTvsIZHyr6kizJ4lO5jifA753D3Sy7WAJTTugKGx
JsyakCQOFCjlbmwaNYV2ikKfarXbuFVNoiqF8c5vpTLgOuaGJOkdqHVbw3yknNIP
63/ZjpYDV60=
=9aNz
-----END PGP SIGNATURE-----
--=-=-=--
