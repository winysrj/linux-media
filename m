Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:41322 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422744AbbENV7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 17:59:22 -0400
Date: Thu, 14 May 2015 23:59:16 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] rc-core: use an IDA rather than a bitmap
Message-ID: <20150514235916.3d3fc1b3@mir>
In-Reply-To: <20150514172929.07e09549@recife.lan>
References: <20150402101855.5223.5158.stgit@zeus.muc.hardeman.nu>
	<20150514172929.07e09549@recife.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NFlL0ZBDeu.iiDN20HSvgfe"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/NFlL0ZBDeu.iiDN20HSvgfe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

On 2015-05-14, Mauro Carvalho Chehab wrote:
> Em Thu, 02 Apr 2015 12:18:55 +0200
> David H=C3=A4rdeman <david@hardeman.nu> escreveu:
>=20
> > This patch changes rc-core to use the kernel facilities that are already
> > available for handling unique numbers instead of rolling its own bitmap
> > stuff.
> >=20
> > Stefan, this should apply cleanly to the media git tree...could you tes=
t it?
>=20
> Patch looks good to me but...
>=20
> you forgot to add your SOB on it.

Just to follow this up, with this patch applied, I've never (for the=20
last 6 weeks already) seen sysfs file conflicts again. So now I'm=20
pretty confident that it really fixes my original problem.

Feel free to add the tested-by tag, if you like.

Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Thanks a lot
	Stefan Lippers-Hollmann

--Sig_/NFlL0ZBDeu.iiDN20HSvgfe
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVVRq0AAoJEL/gLWWx0ULtTkAP+QHaU/zuuye/MOqh5awegKon
VlY0rGkSYATquVmH9p4KZFgPtmWVpJbr4ylbHAuG54unlHyWHfwGD5tNMYCKQlkd
6QoI4bjUk6N+iJnLPhQgT/7OK9Lzb0ZdZSHQqRR3g4CTZEg4mTbYCXQ8dsb3mQhW
jdxTg6LLxugkAJCygGD6iYMRO6r770hfkpEG8loDc73oy/8wxu5ud4c9rwAJbJmA
JXl/NmqCVrm/CWsiLhBnr47v4+rCaDqT+EekKJxOWBSADCEMtKywMoXfP0bohLb/
G5nTCh4KTVOXntXREM1DIXfRQapMW3kbNNc6P1kz1hyUkeb7gh1CodXTsUM+rmG4
xIK3UzbgfkYH0iXdMzoW5bjYseeyMDWFQ18aECncORYzIgW88+HMA8YdWYDv20Fe
btd4YPnH9LQyGjZiI0U3CdQYijE465u5q+2U5vdE3uiLqURZ37ZINuk25+r7CnCk
JYDkrQeA3I4DSMg1I5Q0oOAhisfEFRJlz+WoUxTV0yfmU0CYhNsYvV5QdmlSwTVq
BvlQbD50h1N8Xk97BqAQrUM9qYJzkzIM1u10Mlxot6yqDs8Fui+30IVuCNtdorda
wq58MdHkJYlqUi+ORzzU01QTDxIBZbLPiIZAFuSHf2PMyhAkT6t0XYUkO38V8CnY
Z/02Qa9kid0xtzWiBtwr
=ljBj
-----END PGP SIGNATURE-----

--Sig_/NFlL0ZBDeu.iiDN20HSvgfe--
