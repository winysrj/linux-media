Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ammma.de ([213.83.39.131]:2302 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756703AbZGOBA2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 21:00:28 -0400
Received: from ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id n6F0a0b18426
	for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 02:36:00 +0200
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by ammma.net (8.12.11.20060308/8.12.11/AMMMa AG) with ESMTP id n6F0V4HT014575
	for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 02:31:04 +0200
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id CE35042519E
	for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 02:31:03 +0200 (CEST)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vVp1wMocTfqO for <linux-media@vger.kernel.org>;
	Wed, 15 Jul 2009 02:30:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 7C01445E757
	for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 02:30:53 +0200 (CEST)
Message-ID: <20090715023053.52902q544z47hg84@neo.wg.de>
Date: Wed, 15 Jul 2009 02:30:53 +0200
From: Jan Schneider <jan@horde.org>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] TechnoTrend C-2300 and QAM 128
References: <30AD329C-50B6-44EA-ACD3-ED90713AA769@henes.no>
In-Reply-To: <30AD329C-50B6-44EA-ACD3-ED90713AA769@henes.no>
MIME-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_2bwsc0axww2s";
 protocol="application/pgp-signature";
 micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is in MIME format and has been PGP signed.

--=_2bwsc0axww2s
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Zitat von Johan Hen=E6s <johan@henes.no>:

> Hi !
>
> Recently I have bought three TechnoTrend C-2300 for use in my Mythtv-
> system. Everything seemed to go smooth, but for a major share of the
> channels I have problems getting a channel lock. (Or if I do on some
> of them, I get a "distorted" image with lots of "bit errors"....
>
> Using the latest firmware for Linux : dvb-ttpci-01.fw-2622...
>
> After poking around the Internet I found that QAM 128 has been a
> problem for TechnoTrend cards, and the funny thing is that my cable-
> provider is using QAM 128 for all channels (including the ones that
> works very well).
>
> As I experience problems with most of my channels I still thought
> maybe this would be the problem. I haven't seen posts on the issue for
> quite a while and realizing that the latest firmware available for
> these cards is dated 2005, I wondered where I can find an updated
> version or if anyone has a solution to my problem........

This card has a broken tuner. Try tuning down all frequencies. I got =20
best results by downtuning them by 500000.

Jan.

--=20
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/
--=_2bwsc0axww2s
Content-Type: application/pgp-signature
Content-Description: Digitale PGP-Unterschrift
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpdIz0ACgkQeZECfE3luWlY2gCgyU6b7rEe2wA8l/kU0ROXKF92
nzgAoNvvl8E0wKri1V1fiV5J1mkSFzG9
=JrxQ
-----END PGP SIGNATURE-----

--=_2bwsc0axww2s--

