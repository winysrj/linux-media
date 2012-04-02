Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44582 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab2DBRvk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 13:51:40 -0400
Date: Mon, 2 Apr 2012 19:51:25 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add fc0011 tuner driver
Message-ID: <20120402195125.771b2c72@milhouse>
In-Reply-To: <4F79E49D.1020802@iki.fi>
References: <20120402181432.74e8bd50@milhouse>
	<4F79DA52.2050907@iki.fi>
	<20120402192011.4edc82ff@milhouse>
	<4F79E49D.1020802@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YlXiTebJZoW7yFIMvbW80Jt"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/YlXiTebJZoW7yFIMvbW80Jt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Apr 2012 20:40:45 +0300
Antti Palosaari <crope@iki.fi> wrote:

> hmmmm, I think Mauro will at least complain when I ask he to PULL that=20
> master. Personally I would like to see line len something more than 80=20
> chars, but as checkpatch.pl complains it I have shortened lines despite=20
> very few cases.

I'm not a friend of long lines. In fact, I'm developing on a Netbook
with split screen. So long lines will absolutely kill readability for me.
But there is "long" as in 90 or 100 chars and there is "long" as in
"uh let's stretch the 80 chars limit by a few chars, so that it's more read=
able".

I already worked on code from other kernel subsystems for quite some time
and the 80 char limit never was a hard limit there. For good reasons.

That said, iff the 80 char limit _is_ a hard limit for the DVB subsystem,
I'll honor it. I just think it would worsen the code.

> Likely tuner driver, or demod driver. But as demod tuner initialization=20
> tables are likely correct I suspect it is tuner issue at first hand. And=
=20
> secondly my other hardware with TUA9001 performs very well, better than=20
> old AF9015 sticks.

Well the fc0011 tuner driver still works worse on this af9035 driver
than on Hans' driver. I have absolutely no idea why this is the case.
I'm almost certain that it is not a timing issue of some sort. I tried
a zillion of delays and such.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/YlXiTebJZoW7yFIMvbW80Jt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeecdAAoJEPUyvh2QjYsO+pQQAMUA+qek90zXZla0aBAv2qyO
Y2wp7EiprCS428CXHIKILIXd3E7CzlYSfNurEMC+oq6mCB5UdV9vPfpR9lO3UEKT
h45+XwUzBBFhdb3yqRv376Nmo2Qe4x9gFTMnVe0A2kd1/xzTm98d53NkZzN/e7J+
v4QUdxTMplxYJd7144eKx3+6OE8JbYU6BmnDU+x5DhT7YoEYPQjAUcRLqyo9ouL9
tY2iV1MeVXTsfPOZDigzN9UCKPT2q+3eJV/fqCcM8TlFtsZ9+uaPROtiW390Sgt5
to8HV7diWehVMGznoGCyFXT4j+pVqwONTalRA36yxP0b6VPVYiq2NvrhaNZiBaDU
fhCFtKFUsPkfqt+L0OBOLiRUA2oNOz/jgTRnsN35soxVWq1XHW87w/X+mLcSbut4
gLbrKouT2Y5654E1tOELkVAQXfpbv0F6yQp8Pm2Sy3oSalE8eiQqP81IfpGSxIlK
+yN91qeJmvukygPSOVjYz18MmZ92r6MlACG2HSi5LCSnQLkp12LS34rbuqCbLvEh
v/k5tv7MwmDNTKPDq/kwuu7w5UcJhyfzvJ24Bfc3Zk8YtPLt62xVbpfvUu3+W347
211xMPomaOXmq1NasT4ZUm0c5XOI8ZoBgQBcyZ/rv+Z4vYDzDcDRHNac9kjyzP5N
8TCSD/XvpTnzMyewi/33
=Jn1D
-----END PGP SIGNATURE-----

--Sig_/YlXiTebJZoW7yFIMvbW80Jt--
