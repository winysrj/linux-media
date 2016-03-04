Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:42592 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbcCDH2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 02:28:53 -0500
Message-ID: <1457076530.13171.13.camel@winder.org.uk>
Subject: Re: Kernel docs: muddying the waters a bit
From: Russel Winder <russel@winder.org.uk>
To: Keith Packard <keithp@keithp.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Jani Nikula <jani.nikula@intel.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Date: Fri, 04 Mar 2016 07:28:50 +0000
In-Reply-To: <86egbrm9hw.fsf@hiro.keithp.com>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com>
	 <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan>
	 <86egbrm9hw.fsf@hiro.keithp.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-TJ+o2a1+oyMNPgV9tjr3"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-TJ+o2a1+oyMNPgV9tjr3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-03-03 at 15:23 -0800, Keith Packard wrote:
>=20
[=E2=80=A6]
> However, I think asciidoc has two serious problems:
>=20
> =C2=A0 1) the python version (asciidoc) appears to have been abandoned in
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0favor of the ruby version.=C2=A0

This is I think true, however the Java-based tool chain Asciidoctor is
I believe the standard bearer for ASCIIdoc these days, albeit called
ASCIIdoctor.

> =C2=A0 2) It really is just a docbook pre-processor. Native html/latex
> output
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0is poorly supported at best, and exposes on=
ly a small subset of
> the
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0full capabilities of the input language.

This is not true. Yes ASCIIDoc started as a DocBook/XML frontend so as
to use a sane :-) markup language rather than XML (XML is a notation
for consenting computers only), but the current ASCIIDoctor toolchain
deals very well in direct HTML and PDF generation, without needing a
DocBook/XML toolchain.=C2=A0

> As such, we would have to commit to using the ruby version and either
> committing to fixing the native html output backend or continuing to
> use
> the rest of the docbook toolchain.

Or trial the JVM-based ASCIIdoctor which is what the projects I am
involved with chose to use. Perhaps as an example I can give you http:/
/gpars.website=C2=A0(it's a redirector) all the HTML and PDF is generated
from ASCIIDoc source using ASCIIDoctor driven with a Gradle build
system. This is still very much a work in progress (by Jim Northrop,
not me currently), but I like it.

> We could insist on using the python version, of course. I spent a bit
> of
> time hacking that up to add 'real' support for a table-of-contents in
> the native HTML backend and it looks like getting those changes
> upstreamed would be reasonably straightforward. However, we'd end up
> 'owning' the code, and I'm not sure we want to.

If the Python version is really not being maintained, I would suggest
that unless you want to take over the project and be it's maintainer,
you would be better advised to use a different version.

--=C2=A0Russel.=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3DDr Russel Winder=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0t:=
 +44 20 7585 2200=C2=A0=C2=A0=C2=A0voip: sip:russel.winder@ekiga.net41 Buck=
master Road=C2=A0=C2=A0=C2=A0=C2=A0m: +44 7770 465 077=C2=A0=C2=A0=C2=A0xmp=
p: russel@winder.org.ukLondon SW11 1EN, UK=C2=A0=C2=A0=C2=A0w: www.russel.o=
rg.uk=C2=A0=C2=A0skype: russel_winder

--=-TJ+o2a1+oyMNPgV9tjr3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlbZOTMACgkQ+ooS3F10Be8QnwCgybb2p+YcgxaSmXNITYQ52Nmt
N54An2UoA4usV8TyuGARqBMMWk/ArcVA
=CX1S
-----END PGP SIGNATURE-----

--=-TJ+o2a1+oyMNPgV9tjr3--

