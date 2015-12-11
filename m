Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43328 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbbLKAWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 19:22:33 -0500
Message-ID: <1449793346.2521.11.camel@collabora.com>
Subject: Re: v4l2 kernel module debugging methods
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Ran Shalit <ranshalit@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Thu, 10 Dec 2015 19:22:26 -0500
In-Reply-To: <CAJ2oMh+MG20jYdNSfXWZN+0vH2BPi_Z+v4OB-VH5ehi7qmfmpw@mail.gmail.com>
References: <CAJ2oMhKbYfqz1Vy5-ERPTZAkNZt=9+rzr6yNduQiyfAWM_Zfug@mail.gmail.com>
	 <1449361427.31991.17.camel@collabora.com>
	 <CAJ2oMh+MG20jYdNSfXWZN+0vH2BPi_Z+v4OB-VH5ehi7qmfmpw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3wybsOvsQOrOlHRatSAy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-3wybsOvsQOrOlHRatSAy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 10 d=C3=A9cembre 2015 =C3=A0 23:46 +0200, Ran Shalit a =C3=A9crit=
=C2=A0:
> Thank you for the comment.
> As someone expreinced with v4l2 device driver, do you recommened
> using
> debugging technique such as qemu (or kgdb) or do you rather use plain
> printing ?

I never used that, printing I used. You should also run v4l2-
compliance. It's a test suite, part of v4l-utils.

Nicolas
--=-3wybsOvsQOrOlHRatSAy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlZqF0IACgkQcVMCLawGqByBNgCfdfPUh3INT8angllZanCcVfh9
lVcAnjaQsSDSAuDJqAkCN5Icqkbb54uE
=hTk2
-----END PGP SIGNATURE-----

--=-3wybsOvsQOrOlHRatSAy--

