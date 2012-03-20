Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:21546 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CTNhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 09:37:37 -0400
Date: Tue, 20 Mar 2012 16:37:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: volokh <volokh@telros.ru>
Cc: devel@linuxdriverproject.org, linux-media@vger.kernel.org
Subject: Re: go7007 patch for 3.2.11
Message-ID: <20120320133750.GA3967@mwanda>
References: <1332247500.6182.30.camel@VPir>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <1332247500.6182.30.camel@VPir>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 20, 2012 at 04:45:00PM +0400, volokh wrote:
> Good day.
>=20
> I`ve Angelo PCI-MPG24 (Adlink manufacture) video capture grubber with
> go7007&tw2804 on board.
>=20
> I am video surveillance developer (through web,tcp,etc net), so I`m
> interest with well quality(stability) of this card driver.So this patch=
=20
> improve some part of driver,eg tuning,motion detection, etc.
>=20
> There are two attachments, so patch19032012.tar.bz2 is patch for kernel,
> and other one is patch for testing card.
>=20
> I send it for you with hope this patch will be assign in new kernels.
>=20

go7007 is handled by the linux-media people these days, not us.

Anyway, the patch needs to be submitted in the proper way so we can
save the raw email and apply it like this:
	cat raw_email.txt | git am
or
	cat raw_email.txt | patch -P1

Send the patch to yourself first and verify that it applies.

Read Documentation/SubmittingPatches.  There are bunch of tutorials
on how to submit patches online as well.
http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel

regards,
dan carpenter

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaIgtAAoJEOnZkXI/YHqRDCEP/0DQadceLE4OHO4LcT3zI8/D
uSVBg+FcH5zhXeq4/xeZgtUqP9dIDZD3oi+R2dLhvz+kpzPag8LBeCLpiTuxW1WD
YhetSn4UTkVKyTDcdU3V7aZhE6TyW4/gU+acCCfIg+FXJjvmnZknQGdJhAMMAKEA
OINUvcjCBP1C0T9lnZCL/yC5qHUJODRnQG3GuAdoY1ilYGatoCvAtHhYe4AAilUC
9/DrQSA5wFRWxQv975Lfx1cCdA3EqKeAcdrPU18ZUnOjA/y7yHSOsxWiobJXR+b2
8JyYfIcr1tY4SDzhF99FKU+dmaZ3n389BCcHh74+xoKkvf33XO3M/tRqVxQeaEtP
Fsa61soXjpLtMHuxIxycuAgcxfeg0ehnElvVwjrQJndDqeKQ75GKSWdzqYpHLndH
aTg7LL9401xI5IklctrBLO2Y6ZI+w8cQQ24Zg2UIXQG6V3BqdHD6N1on8uQSeZd0
qSu/HmtvxhchJkbG3mloNZNB+CsvM/iUzjFK0cCKL15P916hTHcavEnofA1UYiNR
wNok3vxkbocKSF7ZRjMd2MpiENZF89R285BTOrfQMPdZmgo03XAaYFqKjIAuC8XA
fkewy3m35afNYg9e3EGZfpAflNwOT/q2gkLjW5jbUVmOWWMQ1YffJfQT09WtUzF0
qO93V5mANJXz48JyfyxS
=SMj4
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
