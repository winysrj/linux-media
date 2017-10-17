Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55130 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932480AbdJQFUl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 01:20:41 -0400
Date: Mon, 16 Oct 2017 22:20:30 -0700
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.14-rc6] media fixes
Message-ID: <20171016222030.07920410@vela.lan>
In-Reply-To: <CA+55aFxkX26JFqbbZOqTrKwwmNEk6eEH7ULEft84Vj148drj2w@mail.gmail.com>
References: <f89cef26-8003-96cb-a1eb-f9dbe1c0a9d2@infradead.org>
        <CA+55aFxkX26JFqbbZOqTrKwwmNEk6eEH7ULEft84Vj148drj2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AsFjnufbt5EylVlvmATH95a"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/AsFjnufbt5EylVlvmATH95a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Em Mon, 16 Oct 2017 20:15:33 -0400
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Mon, Oct 16, 2017 at 4:31 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media med=
ia/v4.14-2 =20
>=20
> No such tag.
>=20
> Did you forget to push out? The latest tag I see is v4.14-1.

Yes, I forgot to push, sorry[1]!

I just pushed it manually. You should now be able to see the
media/v4.14-2 tag there on my tree.

[1] Actually, my scripts were supposed to push it. I'm out of town for
two weeks (this week in US, next week in EU), so, I'm handling it from
my notebook, instead of using my usual machine. Maybe some setup
differences caused a flaw to it, or maybe the local copy of the script
is outdated. I'll double-check tomorrow to be sure that, if I need=20
to do another push before returning home, everything would be just fine.

> I do see the branch (v4l_for_linus) that contains the commit you
> mention, but no tag..

Yep, the branch is identical to what's referenced by the tag.

Thanks,
Mauro

--Sig_/AsFjnufbt5EylVlvmATH95a
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+QmuaPwR3wnBdVwACF8+vY7k4RUFAlnlkx4ACgkQCF8+vY7k
4RXWDA//X1OipERvrv2i15gZFSRGH66p9KcbbhSwBpKjdYl5B76LldU6/4BlHQNB
/JpzCGMIA7BSLAG7WtRpMWfxWke3fHvqBMNl42NVJ5mkqoQIH9bIgtCT08lCra37
XFAer63Xbf4PerJatc3+GSk4p9gZHQTcyJlMNUN6S92ehHmxlI90yRvL68lJlC1w
pn8zo5/2BhFkPN2f8w4jG2Sd4YyjZqgMr8Sbiss0kFwah5VIMWDmGRwcjq581uLR
MfYL8f6JypWhNIoNnXuASuSdEv6dAx3/gVTJSlGmA92V3B/5T1L6uCDgVbDNHzAl
pXvq+mFN5n2vljP5cjBtBKYGp85U2BVhl1XlE2b+DirhKiox9pXMGPhM80ZPN8Jk
f0qodrfdumwrZ8CRPFpJsaVGejnzN90C/K3ndn3qlftido0EgzRVLzjHvOgoPfYY
9lBD0nmki3i2fQ/NfbrVjGgUHeKx9wRqfjJXy3EqyfWoxES8skrPjlFt06dB5fUm
KtEQ6iIJn/cgPE6aKqopOSYep03Q7Ivj9Mj8csXvFfEVztgQ+WIByH4lSjphXItm
2B5IQ6AizCNm2Y+Rawra5DD9ytXzIugKR07rLZ7/soAGjlXrYleBTNkGjEr8up1u
vfWCHtZRCtz8XMiicZ1Mw4Q9QPzcbyvAhrWR9Y7/8BJN7QYPjbQ=
=MoxP
-----END PGP SIGNATURE-----

--Sig_/AsFjnufbt5EylVlvmATH95a--
