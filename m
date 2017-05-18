Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:43345 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754107AbdERVfj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 17:35:39 -0400
Date: Thu, 18 May 2017 22:55:09 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: Re: [PATCH 1/4] [media] tw5864, fc0011: better handle WARN_ON()
Message-ID: <20170518225509.29d05893@wiggum>
In-Reply-To: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5IKRFB6WjV7F+VTuTRpwfN4"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/5IKRFB6WjV7F+VTuTRpwfN4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 18 May 2017 11:06:43 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
> index 192b1c7740df..145407dee3db 100644
> --- a/drivers/media/tuners/fc0011.c
> +++ b/drivers/media/tuners/fc0011.c
> @@ -342,6 +342,7 @@ static int fc0011_set_params(struct dvb_frontend *fe)
>  	switch (vco_sel) {
>  	default:
>  		WARN_ON(1);
> +		return -EINVAL;
>  	case 0:
>  		if (vco_cal < 8) {
>  			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);

This fall through is intentional, but I guess returning an error is OK,
too. This should not happen anyway.
I cannot test this, though.

Acked-by: Michael B=C3=BCsch <m@bues.ch>

--=20
Michael

--Sig_/5IKRFB6WjV7F+VTuTRpwfN4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlkeCi0ACgkQ9TK+HZCN
iw4oMQ/+LLUuo8kH4YcS3U/i9TwSRKeb0TOyToClUKCzvhwSto8tX5we68/t6bru
RxlucQqM0do3UieokM+XTc+gKq2N1fbhDGv0ReFrHuOokf/bs15jbhSRpNd99P/p
PHy9rzsxEFMlLgWMMCk1cupFIiFBeUEJwcaflECXZjYZ2zUWFR6T9EOgymCwk/Eq
Gc+7yV5KLso8EQS93slHRGPYJJl7P1WMIOyEEe59W2uORTYumTUHr0KJyh2AQMHN
OBNFIqT36G/EMMQenEykBOMaHEM1NRFV0uk66f5I9aFyz00g1azUFhEOID7QgPMh
3EKUtJMjraVjfuk2s5Ga7kdCNUmP7qTsR+a4oGIwjln54YICBqAuS+2JUBs9jnBb
4VwpAe3cWHI0tJvcJqMBhezjRBKSm6aAR2cnh5qgrvzBs0rYxQKGstOJ5UqqlH75
5X/vrhkWW5dlkRnhGGcfGTWfg0GZNBxpqdij9GKCBkclcuQ0aViTmwnudF7xAPrZ
F8z94NZmtZrlGEb6o8Scsa2wWsfn3/GcOT7U4nCWDO4+8LsZqsHcfbCMMmR5JSsx
9LKsakH6NdLma8fyVe3m3t2hzAt/5KpToVGpUC+bwRytua3mSc5E6HK/mRqEVAab
wzpGgnIwipKjM5vjSNavkKJ27lpKeCYAmSXLWudPBzCIY0QMiZ4=
=OVfs
-----END PGP SIGNATURE-----

--Sig_/5IKRFB6WjV7F+VTuTRpwfN4--
