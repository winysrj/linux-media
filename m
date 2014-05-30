Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:41940 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaE3Ah0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 20:37:26 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6D00EGH32CZB40@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 May 2014 20:37:24 -0400 (EDT)
Date: Thu, 29 May 2014 21:37:09 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Jonathan McCrohan <jmccrohan@gmail.com>
Cc: linux-media@vger.kernel.org, oliver@schinagl.nl
Subject: Re: [PATCH 00/12] dvbv5 scan tables for Brazil
Message-id: <20140529213709.1165c967.m.chehab@samsung.com>
In-reply-to: <20140530002345.GA12450@lambda.dereenigne.org>
References: <1401209432-7327-1-git-send-email-m.chehab@samsung.com>
 <20140530002345.GA12450@lambda.dereenigne.org>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=Yifi=+P4.yCP/XEr8LkAL3"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/=Yifi=+P4.yCP/XEr8LkAL3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jonathan,

Em Fri, 30 May 2014 01:23:45 +0100
Jonathan McCrohan <jmccrohan@gmail.com> escreveu:

> Hi Mauro,
>=20
> On Tue, 27 May 2014 13:50:20 -0300, Mauro Carvalho Chehab wrote:
> > This patch series add the DTV scan tables for Brazilian ISDB-T
> > and for the Brazilian Countys that have already digital TV.
>=20
> Thanks for the DVBv5 scan files. I had the attached draft patch sitting
> in my tree. I don't think it is ready to be committed yet, but probably
> worth sending now to discuss.

Sure.

> How do we want to manage the migration from DVBv3 to DVBv5:
> 1) point in time migration from DVBv3 to DVBv5?
> 2) maintain both until DVBv5 is in widespread use?

IMHO, the best strategy would be to convert all files at the tree to
DVBv5, and add a Makefile target to produce the DVBv3 files and
another one to install the DVBv5 files on a shared repository.

That gives to distro maintainers the flexibility to have either one=20
or two packages for each format, and let them to remove the dvbv3
when all apps on an specific distro would be using just the new format.

> On a side note, I found a bug in dvb-format-convert; it cannot parse
> DVB-T2 DVBv3 scan files.

Well, at the time it was written, there were no DVB-T2 files.

Feel free to send patches improving the library to also handle the
DVB-T2 formats.

Regards,
Mauro

--Sig_/=Yifi=+P4.yCP/XEr8LkAL3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTh9LAAAoJEAhfPr2O5OEVrU0P/1eUfCi+TSJT78fHKMnllfuV
a4szNbIXkWdmVSVyGEUZ5Az1l6mORMLMOwDti3okqNnKx1yRV9VTLphxg7v3qoBq
tgt3xj7LkoPBpltqoRRAfsCTuSlBpEAmpAyifvbWQoWpncmnXQe9NwyGOkWv53fX
upN1R5hHxVhYwmMzl77FAlUszWQZ/6kbMPE4LmoIvuwkRlGDM7fNqTTy2bQTUgw4
o+in4o/ZUFIgI8s6rDyDzv16B3VTdSD9s56UGEPmdqQW7hs6AVuzWGrugH2l+SwP
11AWQaMXuRaApMrXl+XLhL+obeyBfA+gE4lYm/PSYPL1JNvwEHmzPiyQgSQ6ywzP
ylnXWoh4iW42Vi78v52VPsmc058A6D1uSQ913riBRO1OTiXSwlkiQ0yaS6x3aHau
kk9ePBiFDERdcfutII3jPNKg2Tjh/e4NJVig3vIuZTw2PPqcQ5Vrv0edZhqmTKmn
guZIyHVazN6um6wQIq0oVZuqTLH787bEGIzWHcAN+PSVQFhv+IhDoyfoRDc9p0pe
2NuCT7GU23XDYlQhAKlAtysxvmOYkMnHInjLAyDNYf7VV1eL8/yDu0CpL3aczD1X
Qj+QUnjV+ks9z4sKxE1x6ZiqgwsJxITXuaeFz4NQ6odUXc1Lzr2HFB2D9mBipBVU
inPGb28i7krHMmuIr/pL
=ciKn
-----END PGP SIGNATURE-----

--Sig_/=Yifi=+P4.yCP/XEr8LkAL3--
