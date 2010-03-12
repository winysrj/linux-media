Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out108.alice.it ([85.37.17.108]:2798 "EHLO
	smtp-out108.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167Ab0CLVDr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 16:03:47 -0500
Date: Fri, 12 Mar 2010 22:03:27 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pushes at v4l-utils tree
Message-Id: <20100312220327.0a37ee65.ospite@studenti.unina.it>
In-Reply-To: <4B9A962A.2020407@redhat.com>
References: <4B99891E.9010406@redhat.com>
	<4B9A62B6.7090004@redhat.com>
	<4B9A962A.2020407@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Mar_2010_22_03_28_+0100_lkXMP4+4tvvNdce_"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__12_Mar_2010_22_03_28_+0100_lkXMP4+4tvvNdce_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Mar 2010 16:29:46 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Hans de Goede wrote:
> > Hi,
> >=20
> > On 03/12/2010 01:21 AM, Mauro Carvalho Chehab wrote:
> >> Hi Hans,
> >>
> >> As we've agreed that the idea is to allow multiple people to commit at
> >> v4l-utils,
> >> today, I've added 3 commits at v4l-utils tree (2 keycode-related and 1
> >> is .gitignore
> >> stuff). One of the reasons were to test the viability for such commits.
> >>
> >> I've temporarily enabled the same script that we use for upstream
> >> patches to
> >> generate patches against linuxtv-commits ML.
> >>
> >>  From my experiences, I have some notes:
> >>     1) git won't work fine if more than one is committing at the same
> >> tree.
> >> The reason is simple: it won't preserve the same group as the previous
> >> commits. So,
> >> the next committer will have troubles if we allow multiple committers;
> >>
> >=20
> > I assume you are talking about some issues with permissions on the
> > server side here ?
>=20
> Yes. The new objects and the touched files got a different group ownership
> after git push. I had to manually fix them at the server.
>=20

The following might be inappropriate, as I didn't follow the discussion
about the linuxtv git infrastructure.

Using gitosis[1,2] these permission issues shouldn't occur, because only
one user (usually "git") actually writes to the filesystem while commit
rights are still handled with ssh pubkeys, and this doesn't even
require creating users on the server.

As I said I don't know if you are using gitosis already, if so then
sorry for the noise.

Regards,
   Antonio

[1] http://eagain.net/gitweb/?p=3Dgitosis.git
[2] http://ao2.it/wiki/How_to_setup_a_GIT_server_with_gitosis_and_gitweb

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Fri__12_Mar_2010_22_03_28_+0100_lkXMP4+4tvvNdce_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuarCAACgkQ5xr2akVTsAEdHwCfYsAn/25jIXieNAGfzsau/a4Q
FVIAnRIdykWr25N6mfKgb6JtA/KKJXXy
=c8le
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Mar_2010_22_03_28_+0100_lkXMP4+4tvvNdce_--
