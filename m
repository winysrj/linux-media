Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34909 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbcCDBTq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 20:19:46 -0500
Date: Thu, 3 Mar 2016 22:19:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Keith Packard <keithp@keithp.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jani Nikula <jani.nikula@intel.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160303221930.32558496@recife.lan>
In-Reply-To: <86egbrm9hw.fsf@hiro.keithp.com>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VDS6=2IxlMcB/Np8zRxfhe."; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/VDS6=2IxlMcB/Np8zRxfhe.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Em Thu, 03 Mar 2016 15:23:23 -0800
Keith Packard <keithp@keithp.com> escreveu:

> Mauro Carvalho Chehab <mchehab@osg.samsung.com> writes:
>=20
> > On my tests, Sphinix seemed too limited to format tables. Asciidoc
> > produced an output that worked better. =20
>=20
> Yes, asciidoc has much more flexibility in table formatting, including
> the ability to control text layout within cells and full control over
> borders.
>=20
> However, I think asciidoc has two serious problems:
>=20
>   1) the python version (asciidoc) appears to have been abandoned in
>      favor of the ruby version.=20
>=20
>   2) It really is just a docbook pre-processor. Native html/latex output
>      is poorly supported at best, and exposes only a small subset of the
>      full capabilities of the input language.
>=20
> As such, we would have to commit to using the ruby version and either
> committing to fixing the native html output backend or continuing to use
> the rest of the docbook toolchain.
>=20
> We could insist on using the python version, of course. I spent a bit of
> time hacking that up to add 'real' support for a table-of-contents in
> the native HTML backend and it looks like getting those changes
> upstreamed would be reasonably straightforward. However, we'd end up
> 'owning' the code, and I'm not sure we want to.

I'm a way more concerned about using a tool that fulfill our needs
than to look for something that won't use the docbook toolchain or
require to install ruby.

In the case of Docbook, we know it works and we know already its
issues. Please correct me if I'm wrong, but the big problem we
have is not due to the DocBook toolchain, but due to the lack of
features at the kernel-doc script. Also, xmlto is already installed
by the ones that build the kernel docs. So, keeping use it won't
require to install a weird toolchain by hand.

So, to be frank, it doesn't scary me to use either pyhton or
ruby script + docbook.

Of course, having to own the code has a cost that should be evaluated.

If, on the other hand, we decide to use RST, we'll very likely need to
patch it to fulfill our needs in order to add proper table support.
I've no idea how easy/difficult would be to do that, nor if Sphinx
upstream would accept such changes.

So, at the end of the day, we may end by having to carry on our own
version of Sphinx inside our tree, with doesn't sound good, specially
since it is not just a script, but a package with hundreds of
files.

Thanks,
Mauro

--Sig_/VDS6=2IxlMcB/Np8zRxfhe.
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW2OKkAAoJEAhfPr2O5OEVkMIP/RZTvJk4EgvEf5R3eur4U4i0
i/5b5rf6IUfSLIaKVAR/mdJMUK6sqyu40bS6VbrijxZGCqoLcSebEB5cE5N9mq4B
39Lkqh292rrRPzVRzj0tgb0/KCJKNW9nCsLRT/s74ZHXt+8tn6scUJUqiS7eHaoX
hWADBoVg8VHFaFcvb5wvbQTcO0xI/q5izY9qsNxfT0PdQYv8+pr9GkvhPqh39/wU
FtGMYVNMX/uXErvWPjzmdffN0SjUSGDfJhzEcu8n1DN2JqAqT+SUR7Umj3PK9okj
hdaX6XPKfc/AK1rmRDA0qLO27XGKQJQnYQ5EjJDce7TGP2HoHMYc3lHVeUv1VzQ4
eeRjJfcLuo5VNc4iUIT3va02V5t2tHNpHSr134dfddyenw+wqUspLq4bchnD4ofE
AbSmxU+gTLsguvZULo2xq6zXheaQO0k59PoxDZom5o8lpyt8VEoHVPALyIZyutZn
lA9sI2k7nvCuDxegKMbHp7W3lvHdoW89qC8PXpKoiv9nCfmv9v+qKdIykYN1mt33
d8bLLf/cd3p/k1/h+k6+tqrZ82bwifD0691j7t5Ga6bqaCqNmC1DZaI4jPEO56Uj
n8HMQnGSf2wD7Lguw0HJhl1kV+r33x/Wkx8+3uoW0xLNrLKa/Ac3PBP4MpyC8Hjt
hnNI1E4jn1j4cFCFCCH8
=6guT
-----END PGP SIGNATURE-----

--Sig_/VDS6=2IxlMcB/Np8zRxfhe.--
