Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:57240 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbcHIO7E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 10:59:04 -0400
Date: Tue, 9 Aug 2016 16:58:56 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Abylay Ospan <aospan@netup.ru>
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	Sergey Kozlov <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] media: pci: netup_unidvb: don't print error when
 adding adapter fails
Message-ID: <20160809145856.GC1666@katana>
References: <1470742517-12774-1-git-send-email-wsa-dev@sang-engineering.com>
 <1470742517-12774-2-git-send-email-wsa-dev@sang-engineering.com>
 <CAK3bHNWmxQsAtefcUocoOcEwtWnpptiVxzhXR-+jVU524RmnPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Content-Disposition: inline
In-Reply-To: <CAK3bHNWmxQsAtefcUocoOcEwtWnpptiVxzhXR-+jVU524RmnPw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Sometimes it better to show more message - especially in error conditions=
 :)

Sure, if they contain additional information.

> btw, do you make sanity check for "duplicate" log messages ?

I checked all error messages if they contain additional information.

>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D i2c_add_adapter(&i2c->adap);
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret) {
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&ndev=
->pci_dev->dev,
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0"%s(): failed to add I2C adapter\n", __func__);
>     +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
>     =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>     -=C2=A0 =C2=A0 =C2=A0 =C2=A0}

IMHO, this one doesn't. __func__ is not helpful to users. And the error
messages in the core will make sure that a developer knows where to
start looking.


--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqe+wAAoJEBQN5MwUoCm2ZkwP/1vF0X1lQoqHci9o8z7a/vI/
EHtLWcEvszMoTiwQDSzFi2GsI1LqGVTHGS+h7+WrHCSgHQbL1F+VUuTl3A3mxNk3
8yanxLrEz/FT5OLxn040+rvDVeCftkzz/awhg4tsPBnyy0IQ6c0/YcRrY/pdKBUL
ElfNsRIJndK5/9RkrOFkk+EjJ/eqRgE7orB32PwYwwT/wRmhlPfXvp0Ehilv878k
315WxuBB1JyUa8S0mEeiD+kgGaPcAEPLfLc5bdmbBnqYMJO1QUvJ1youl1rzI5RN
ymW3i6LtMBN5aqLc33F4U1q2er5BpH1LvVPVzeiMZTzuS2k973nrHhChe29rmpGk
8Cb/kZHxsTv/VFnW5VvuM4Br64FNJOlI0YN8IPDTI/wsn+BXEQXdjU5gJpkqLcs1
mu9Q8IpKBw+ESgN2sVVutec1Yy8WkqYUTne7FroSLJA/kM/qc/59Po6dCAjuSUO9
EfON/IpnSWyORx9MDMDxS0PEi/qA/h+tvY1KgxRwHjrtbYFgJelhPMxou93nUt0B
dIy1ly/CLB4uBEPhkOf0tbyrk7pTF1JPh9tatdLtp2D+c/gMbnAz+TQnR6jiXWrQ
75miUJc+B6ToIj2PFBW7PQO0X8vcuyjW5wUpTfbNtNpYMOJ4BSVvOftk1/i1JHZ8
10rxnwHOJEStUExkMB24
=qqiA
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
