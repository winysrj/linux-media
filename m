Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:47150 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbcCHExY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 23:53:24 -0500
Message-ID: <1457412801.3402.19.camel@winder.org.uk>
Subject: Re: Kernel docs: muddying the waters a bit
From: Russel Winder <russel@winder.org.uk>
To: Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Date: Tue, 08 Mar 2016 04:53:21 +0000
In-Reply-To: <87vb52r8gn.fsf@intel.com>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com>
	 <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan>
	 <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk>
	 <87vb52r8gn.fsf@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-2AizxRdWCOR2Ygm2RWAg"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-2AizxRdWCOR2Ygm2RWAg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-03-04 at 09:46 +0200, Jani Nikula wrote:
> [=E2=80=A6]
> If we're talking about the same asciidoctor (http://asciidoctor.org/)
> it's written in ruby but you can apparently run it in JVM using
> JRuby. Calling it Java-based is misleading.

Indeed, I was somewhat imprecise. Thanks to the work mostly of Charles
Nutter, JRuby is invariably a faster platform for Ruby code than Ruby
is. So yes ASCIIDoctor is JVM-based via JRuby, not Java-based.

The real point here is that in a move from DocBook/XML as a
documentation source, ASCIIDoctor is an excellent choice.

--=C2=A0Russel.=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3DDr Russel Winder=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0t:=
 +44 20 7585 2200=C2=A0=C2=A0=C2=A0voip: sip:russel.winder@ekiga.net41 Buck=
master Road=C2=A0=C2=A0=C2=A0=C2=A0m: +44 7770 465 077=C2=A0=C2=A0=C2=A0xmp=
p: russel@winder.org.ukLondon SW11 1EN, UK=C2=A0=C2=A0=C2=A0w: www.russel.o=
rg.uk=C2=A0=C2=A0skype: russel_winder

--=-2AizxRdWCOR2Ygm2RWAg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlbeWsEACgkQ+ooS3F10Be+mfACff+xNHQOosZkgA8RbHGdwGjDz
tKIAmgMp+FZIJDHA7eZKLi1YyVWma/gI
=FXkL
-----END PGP SIGNATURE-----

--=-2AizxRdWCOR2Ygm2RWAg--

