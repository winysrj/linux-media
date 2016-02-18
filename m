Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425281AbcBRJKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 04:10:36 -0500
Date: Thu, 18 Feb 2016 07:10:14 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Russel Winder <russel@winder.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
Message-ID: <20160218071014.61fb3d18@recife.lan>
In-Reply-To: <20160218063114.370b84cf@recife.lan>
References: <20160217145254.3085b333@lwn.net>
	<20160217215138.15b6de82@recife.lan>
	<1455783420.10645.21.camel@winder.org.uk>
	<20160218063114.370b84cf@recife.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TlN3slZuZVbtW2dTVxMIM1C"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/TlN3slZuZVbtW2dTVxMIM1C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Em Thu, 18 Feb 2016 06:31:14 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Thu, 18 Feb 2016 08:17:00 +0000
> Russel Winder <russel@winder.org.uk> escreveu:
>=20
> > On Wed, 2016-02-17 at 21:51 -0200, Mauro Carvalho Chehab wrote: =20
> > > [=E2=80=A6]
> > >=20
> > > We have 2 types of documentation for the Kernel part of the
> > > subsystem,
> > > Both using DocBook:
> > > - The uAPI documentation:
> > > 	https://linuxtv.org/downloads/v4l-dvb-apis
> > > - The kAPI documentation:
> > > 	https://linuxtv.org/downloads/v4l-dvb-internals/device-drivers/
> > > mediadev.html   =20
> > [=E2=80=A6]
> >=20
> > I may not be introducing new data here but=E2=80=A6
> >=20
> > Whilst ReStructuredText and Markdown are fairly popular text markup
> > languages, they are not related to the DocBook/XML toolchain.
> >=20
> > Many people, especially authors of books etc. are not really willing to
> > write in DocBook/XML even though it is the re-purposable representation
> > of choice for most of the major publishers. This led to ASCIIDoc.
> >=20
> > ASCIIDoc is a plain text markup language in the same way
> > ReStructuredText and Markdown are, but it's intention was always to be
> > a lightweight front end to DocBook/XML so as to allow authors to write
> > in a nice markup language but work with the DocBook/XML toolchain.
> >=20
> > ASCIIDoc has gained quite a strong following. So much so that it now
> > has a life of its own separate from the DocBook/XML tool chain. There
> > is ASCIIDoctor which generates PDF, HTML,=E2=80=A6 from the source with=
out
> > using DocBook/XML, yet the source can quite happily go through a
> > DocBook/XML toolchain as well.
> >=20
> > Many of the open source projects I am involved with are now using
> > ASCIIDoctor as the documentation form. This has increased the number of
> > non-main-contributor contributions via pull requests. It is so much
> > easier to work with ASCIIDoc(tor) source than DocBook/XML source.=C2=A0=
 =20
>=20
> Are there any tools that would convert from DocBook to ASCIIDoc?

Answering myself:

I found one tool at:
	https://github.com/oreillymedia/docbook2asciidoc

That seemed to work. I ran it with:
	$ make DOCBOOKS=3Dmedia_api.xml htmldocs 2>&1 | grep -v "element.*: validi=
ty error : ID .* already defined"
	$ xmllint --noent --postvalid "$PWD/Documentation/DocBook/media_api.xml" >=
/tmp/x.xml 2>/dev/null
	$ java -jar saxon9he.jar -s /tmp/x.xml -o book.asciidoc d2a_docbook.xsl ch=
unk-output=3Dtrue

And it produced a series of documents, that I stored at:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/

I noticed, however, that it kept some things using DocBook xml. Perhaps
because some things cannot be translated to markup (see appa.asciidoc)?

Also, converting them to HTML produced me some errors, but perhaps because
I don't know what I'm doing ;)

What I did was:
	for i in book-docinfo.xml *.asciidoc; do asciidoc $i; done

errors enclosed.

Yet, it seems there are some hope on using asciidoc for the kAPI
documentation.

Thanks,
Mauro

---

asciidoc: ERROR: book.asciidoc: line 9: only book doctypes can contain leve=
l 0 sections
asciidoc: ERROR: ch01.asciidoc: line 588: only book doctypes can contain le=
vel 0 sections
asciidoc: ERROR: ch02.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch03.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch03.asciidoc: line 370: illegal style name: capture examp=
le
asciidoc: ERROR: ch04.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch04.asciidoc: line 719: illegal style name: to do
asciidoc: ERROR: ch05.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch06.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch07.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch07.asciidoc: line 907: illegal style name: Solution?
asciidoc: ERROR: ch07.asciidoc: line 2208: illegal style name: to do - OSS/=
ALSA
asciidoc: ERROR: appa.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appa.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: appb.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: WARNING: appb.asciidoc: line 7: missing style: [paradef-default]:=
 appendix
asciidoc: ERROR: appc.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appc.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: appd.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appd.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: appe.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appe.asciidoc: line 5: missing style: [paradef-default]:=
 appendix
asciidoc: ERROR: book.asciidoc: line 142: section title not permitted in de=
limited block
asciidoc: ERROR: book.asciidoc: line 148: section title not permitted in de=
limited block
asciidoc: ERROR: ch08.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch09.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch10.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch11.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch12.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch13.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: ch14.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: appf.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appf.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: appg.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appg.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: apph.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: apph.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: appi.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appi.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: appj.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appj.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: appk.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appk.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: book.asciidoc: line 193: section title not permitted in de=
limited block
asciidoc: ERROR: ch15.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: book.asciidoc: line 201: section title not permitted in de=
limited block
asciidoc: ERROR: ch16.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: appl.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appl.asciidoc: line 7: missing style: [blockdef-pass]: a=
ppendix
asciidoc: ERROR: ch17.asciidoc: line 2: section title not permitted in deli=
mited block
asciidoc: ERROR: appm.asciidoc: line 3: section title not permitted in deli=
mited block
asciidoc: WARNING: appm.asciidoc: line 6: missing style: [paradef-literal]:=
 appendix
asciidoc: ERROR: appm.asciidoc: line 17: section title not permitted in del=
imited block
asciidoc: ERROR: appm.asciidoc: line 50: section title not permitted in del=
imited block
asciidoc: ERROR: appm.asciidoc: line 144: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 166: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 217: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 434: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 471: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 492: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 514: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 531: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 545: section title not permitted in de=
limited block
asciidoc: ERROR: appm.asciidoc: line 569: section title not permitted in de=
limited block
asciidoc: ERROR: ch04.asciidoc: line 2845: [blockdef-example] missing closi=
ng delimiter
asciidoc: ERROR: ch01.asciidoc: line 588: only book doctypes can contain le=
vel 0 sections
asciidoc: ERROR: ch01.asciidoc: line 4224: [blockdef-example] missing closi=
ng delimiter
asciidoc: ERROR: ch03.asciidoc: line 370: illegal style name: capture examp=
le
asciidoc: ERROR: ch04.asciidoc: line 719: illegal style name: to do
asciidoc: ERROR: ch07.asciidoc: line 907: illegal style name: Solution?
asciidoc: ERROR: ch07.asciidoc: line 2208: illegal style name: to do - OSS/=
ALSA



--Sig_/TlN3slZuZVbtW2dTVxMIM1C
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxYp2AAoJEAhfPr2O5OEVwZUP/jCnE8obKwwXDOkyV2qmNJ7X
dVy6/GC6zcINQb36e1FTwF14jox0Nwrvbv7ukfNxoZ58hZmEfX6iQNWyd8XFi0eU
kc0iUQxUguIH8PinswTsmGVqzVX2iWtO8ML31/2O/Bm9+TBn96Twcna5l+0Ro15q
I1Bp7gU/vFVIy597OyAmc7EOwpuZ5VrbsVLiqxPfXOr6T7wQpRR5+YwGSqggJXrE
VOJbDIqbc6uz3sBsYzL3CKLskMs+pLQC5KmrkEV6/Kg8r1RzqoKgCzkxKPlNInhW
WzNNJOgMmUEn07GrNm6i3qfeaDIw+8hv+b3JUsbO+TsQmjeg2bn+CG3LuWFNk5Ze
mMucYVtUKGN0fFDVI1oU8aKuLTlRm2jtPjpdw3WlF4aAPc6lRB8WGRT+HB98Dqaq
M/OaUIbjr/B4FQZaRzPm1muujmjl4JEZzLFI9w1mOa/2Sbyll+4uonAMRxAvRL8t
EccZdhEZ1AI+4MuiTSGw1nRDZ6V69/x2LAPzcWQBJMSxolMtD6UaHpbdS96bmH8p
PzHTubfF4U16iDOSpJ7vjW4o97Roa569eICXvIolbDsSs5m7iosVWH4aSF3XH2bQ
8aMRkSDFyETxVJBDd0qdPtHMJy26HBz/1h08FBpZY8jaIcfs6E9neCU861CnNGAq
jDovXUav5H/id2RTMZXx
=DZyk
-----END PGP SIGNATURE-----

--Sig_/TlN3slZuZVbtW2dTVxMIM1C--
