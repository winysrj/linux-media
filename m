Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:53855 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3KEWPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 17:15:47 -0500
Received: by mail-qe0-f49.google.com with SMTP id a11so5447449qen.22
        for <linux-media@vger.kernel.org>; Tue, 05 Nov 2013 14:15:46 -0800 (PST)
Date: Tue, 5 Nov 2013 19:08:34 -0300
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] SOLO6x10: don't do DMA from stack in
 solo_dma_vin_region().
Message-ID: <20131105190834.2473ace9@pirotess.bifrost.iodev.co.uk>
In-Reply-To: <m37gemb51b.fsf@t19.piap.pl>
References: <m37gemb51b.fsf@t19.piap.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.VFu8Sco4bF8nYaDCodawGm"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/.VFu8Sco4bF8nYaDCodawGm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Sep 2013 14:25:36 +0200
khalasa@piap.pl (Krzysztof Ha=C5=82asa) wrote:
> Signed-off-by: Krzysztof Ha=C5=82asa <khalasa@piap.pl>

Acked-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>

<...>

--Sig_/.VFu8Sco4bF8nYaDCodawGm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAEBAgAGBQJSeWxjAAoJEBrCLcBAAV+G7n4IAIaq0gNPygQLoYr9CVBV5X7I
1VeKco1He3PYUt8qoQLLYiAptQF1QsxM7L19Drnp8aj6UdRsDhm3QsNoVeQGepYv
MzCuozqM0u97WbXGre4mCPj8ktX6wYQSsTnhPkxD+NhicJp05IAPM26zdGZPm4pT
rsl66BpGSsRrFuzFzE4ihA1Eu6YQa3han2x+5NBtxYPRicpRdkoQ2yhWOVBSDj/9
2ojGwJEftAiafd+J8kFgsQKaxEsiOYS4jsQ6gDTZJSroloxiiar0kZJOAkGzqLe9
CIdFomDEx71GGCn+Vzsjkj6S5sZX8i9WYvNv1d+1Eq2YsuFBA4KCpziHVw01cFs=
=/Wqm
-----END PGP SIGNATURE-----

--Sig_/.VFu8Sco4bF8nYaDCodawGm--
