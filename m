Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:41049 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1045256AbdDWMjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 08:39:20 -0400
Date: Sun, 23 Apr 2017 14:38:39 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] si2157: get chip id during probing
Message-ID: <20170423143839.11187c09@aktux>
In-Reply-To: <43216679-3794-14ca-b489-00ac97a57777@iki.fi>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
        <1489616530-4025-2-git-send-email-andreas@kemnade.info>
        <43216679-3794-14ca-b489-00ac97a57777@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KSkS+1J9h=U100QKkbWXaEt"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/KSkS+1J9h=U100QKkbWXaEt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Apr 2017 15:19:21 +0300
Antti Palosaari <crope@iki.fi> wrote:

> On 03/16/2017 12:22 AM, Andreas Kemnade wrote:
> > If the si2157 is behind a e.g. si2168, the si2157 will
> > at least in some situations not be readable after the si268
> > got the command 0101. It still accepts commands but the answer
> > is just ffffff. So read the chip id before that so the
> > information is not lost.
> >=20
> > The following line in kernel output is a symptome
> > of that problem:
> > si2157 7-0063: unknown chip version Si21255-\xffffffff\xffffffff\xfffff=
fff
> That is hackish solution :( Somehow I2C reads should be get working=20
> rather than making this kind of work-around. Returning 0xff to i2c reads=
=20
> means that signal strength also shows some wrong static value?
>=20
dvb-fe-tool -m is like this:

Lock   (0x1f) Signal=3D -1.00dBm C/N=3D 19.25dB UCB=3D 6061140 postBER=3D 4=
0.0x10^-6

Signal strength is static.

Yes, I do not like my solution, too.
Also i2c reads from the windows driver from the si2157 after that 0101
command give such problems. I have checked my usb logs again.
So the question is where a better solution can come from.
I do not find a proper datasheet of the si2157 or the si2168.

Just for reference: the stick is labeled VG0022a.
The usb strings are like that:
  idVendor           0x1d19 Dexatek Technology Ltd.
  idProduct          0x0100=20
  bcdDevice            1.00
  iManufacturer           1 ITE Tech., Inc.
  iProduct                2 TS Aggregator
  iSerial                 3 AF0102020700001

if that may lead to some information.

Regards,
Andreas

--Sig_/KSkS+1J9h=U100QKkbWXaEt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJY/KBxAAoJEInxNTv1CwY02O8QAIZv7o1L+UJBmcZEmZR8D8JA
kC/L1DwlpOPA6SdyChun7chyyO3wnEqREuSQ50J4V4tbLMZ3EQvKgai/4B7aU9zx
FTMVR7nWz2Fm82DafwYh4LX6YzlNAYMXdlXLpa38MJDk57vFm9r5X+2QYRG3W1ZL
PbzNKftpJazCRohSRKsQdoQIRggrVDUx4OUttz8KFUgpGkVdZL3RTMHmPBYqPD3b
SBIOxAt7EL1fjsTFZTwZlUZJWvRwNtbqMfQtjHxd9jzXbqTEmQuiVmnAEnz13wa9
+9mFUxshexrVmdc2/Kin2o5HSjMxi0PtoD+uwkoWbtOq3W9O1kixALPeCxmVQUKz
bnA9Y1scdJHG2rYKaLhDmu24W/kkJtFjmDfDW+s1jG+Zec1VHs7/UxFAd0zf8nWU
2Aw3jT/UjdbIU3wkJRm1L7LZ3KP5l3fajV8GIEaUeBVbbOUU2zNijRoLmpU2MoFM
xjyuZrDEs6037T1wixRtuGqz6/fdS/wzMLNOa2hGGSDdMcnzT7K8Vavug+Z/AgHm
LaZQwgLNjEkcVju8Zznk1KKZ/3gquctnto5C8I5jETNH0w0eygxJhJoFeN9HbZMX
7h7EEKEpQZ4Caic/zEc2oSYba161iauNcoqAtIqUZy7NEanjfI30WCs7dx4187Yv
Q8quxuRqfJxa7p6GX5P0
=mA0c
-----END PGP SIGNATURE-----

--Sig_/KSkS+1J9h=U100QKkbWXaEt--
