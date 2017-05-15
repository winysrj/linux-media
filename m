Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:38928 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933188AbdEOU2w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 16:28:52 -0400
Date: Mon, 15 May 2017 22:28:37 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] si2157: get chip id during probing
Message-ID: <20170515222837.3d822338@aktux>
In-Reply-To: <43216679-3794-14ca-b489-00ac97a57777@iki.fi>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
        <1489616530-4025-2-git-send-email-andreas@kemnade.info>
        <43216679-3794-14ca-b489-00ac97a57777@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oogHG1diM.bt+O+Y=9DC2ZX"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/oogHG1diM.bt+O+Y=9DC2ZX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

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
Also this is needed for the Terratec CinergyTC2.
I see the ff even on windows. So it cannot be solved by usb-sniffing of
a working system, so, again how should we proceed?

a) not support dvb sticks which do not work with your preferred
   order of initialization.

b) change order of initialisation (maybe optionally add a flag like
   INIT_TUNER_BEFORE_DEMOD to avoid risk of breaking other things)

c) something like the current patch.

d) while(!i2c_readable(tuner)) {
     write_random_data_to_demod();
     write_random_data_it9306_bridge();
   }
   remember_random_data();


There was not much feedback here.

An excerpt from my windows sniff logs:
ep: 02 l:   15 GEN_I2C_WR 00 0603c6120100000000
ep: 02 l:    0
ep: 81 l:    0
ep: 81 l:    5 042300dcff
ep: 02 l:    9 GEN_I2C_RD 00 0603c6
ep: 02 l:    0
ep: 81 l:    0
ep: 81 l:   11 0a240080ffffffffff5b02
ep: 02 l:   15 GEN_I2C_WR 00 0603c6140011070300
ep: 02 l:    0
ep: 81 l:    0
ep: 81 l:    5 042500daff
ep: 02 l:    9 GEN_I2C_RD 00 0403c6
ep: 02 l:    0
ep: 81 l:    0
ep: 81 l:    9 08260080ffffff5901

here you see all the ffff from the device.



Regards,
Andreas

--Sig_/oogHG1diM.bt+O+Y=9DC2ZX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZGg9/AAoJEInxNTv1CwY06H8QAJv6kcPKXjy1CRnlUBWVTgzZ
SdIh00Y2rA3BvxdQKUTTyrSwWXXXrfdpHAaD9dG9nIKObPn7p6edXeXp71J2dU7D
fO72wXRpq2qhjJ17177qo1IdCa4Bh17PcStM7L+9QlHanPleLM7GpPYktA96LQXM
UxzB8YOo0qKIp5G0/oCtO7hXj32mzPRpb7ualjUGIyIlkNj/bG/4CNqm/OxuINaD
4/Kh8f4li2jlCRlkGEKA6Bx2C3V8owQUye0pf9T9rJtn7PBCcD3XD9RR+/dvVLFT
p8Yun3tn30cqX6S5eqOL4bispTlfrFI1/pFpnkOT6v0euq40m5FkHdPjxnOS+yaA
ooUZVd698x9+E+mq5/4434OUppxC4XP3kc2AAVjqWXjzCU8v2uhHLq51ogk52a+l
2Lm7yk6P3EsjcIZh7VYoGMyboqx8xH05GOhAc9MLypJ3xPlABxOOeUfsSaxWlejg
/ery2I6mW6UITyOHSpAnZpO0SHfIerqTNjxBjOZeGf+/O9RepLwGhzM9s5ogDEvX
7QhKKTwv8kvq7l/pqldhNe2zv4LLA2rpo/VuGczFeEBwNnuf9swCC52uknNcFL0A
liqH6XEx8z/4oA+eiSzl/AiqGi+cExAUFvomNVMtrslvWlL+W6Cq2MKtlhJ1Wv8N
wsrNUq4By/Ttgjd2qqQE
=9tY1
-----END PGP SIGNATURE-----

--Sig_/oogHG1diM.bt+O+Y=9DC2ZX--
