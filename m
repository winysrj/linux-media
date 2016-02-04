Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f57.google.com ([209.85.192.57]:33985 "EHLO
	mail-qg0-f57.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748AbcBDLVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 06:21:07 -0500
Received: by mail-qg0-f57.google.com with SMTP id 69so12585510qgn.1
        for <linux-media@vger.kernel.org>; Thu, 04 Feb 2016 03:21:05 -0800 (PST)
Date: Wed, 3 Feb 2016 22:48:39 -0800 (PST)
From: yangkkokk@gmail.com
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: patapovich@gmail.com, linux-media@vger.kernel.org
Message-Id: <1a36e3cf-2ec4-4428-92db-1b721d7873c8@googlegroups.com>
In-Reply-To: <CA+C5N_r6Vm8O==F4-EDakMPDnzTVKW9aifDPiEtFCW=9UBkQ8Q@mail.gmail.com>
References: <520BC1EF.9030204@gmail.com>
 <ed81b21e-44e4-40db-bfaa-6fbad2b5d7cb@googlegroups.com>
 <53E9C88B.7050400@gmail.com>
 <729740fb-4a6f-4a7e-a151-dd12d2d8d944@googlegroups.com>
 <CA+C5N_r6Vm8O==F4-EDakMPDnzTVKW9aifDPiEtFCW=9UBkQ8Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] [stage/sunxi-3.4] Add support for Allwinner
 (DVB/ATSC) Transport Stream Controller(s) (TSC)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_54_86844627.1454568519524"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_Part_54_86844627.1454568519524
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2014=E5=B9=B48=E6=9C=8812=E6=97=A5=E6=98=9F=E6=9C=9F=E4=BA=8C UTC=
+8=E4=B8=8B=E5=8D=8811:20:16=EF=BC=8Canuroop kamu=E5=86=99=E9=81=93=EF=BC=
=9A
> Hi Miska, Thanks for that Doc
>=20
>=20
> I am still not able to visualize it fully. if this Tsc driver works well,=
 which buffer/fifo will the data be available?=C2=A0
> Do I need to make a separate media player app to get this data? Or any de=
fault media player can play the video directly from /dev/tsc_dev (or /dev/v=
ideo0) ?
>=20
> I am trying to use the default AW TS driver for A20.
>=20
>=20
> please correct me if my understanding is wrong.
>=20
>=20
> thanks
> Anuroop=C2=A0
>=20
>=20
>=20
>=20
>=20
> On Tue, Aug 12, 2014 at 5:51 PM, Mihail Tommonen <patap...@gmail.com> wro=
te:
>=20
>=20
> Hi,
>=20
>=20
> 2. I've suspended my TSC project until a complete A20 TSC manual is avail=
able or I get the time for register probe rev. engineering.
>=20
>=20
>=20
> Have you seen this: http://dl.linux-sunxi.org/A10/A10%20Transport%20Strea=
m%20Controller%20V1.00%2020120917.pdf
>=20
> I expect a20 tsc to be really similiart to a10.=20
>=20
> WBR
>=20
> Miska

hi
  you must have a tsdeviver like dibcom 3000 or anything,so you can done it=
.
------=_Part_54_86844627.1454568519524--
