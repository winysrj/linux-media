Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59541 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbbKBSbq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2015 13:31:46 -0500
Message-ID: <1446489100.15819.15.camel@collabora.com>
Subject: Re: [PATCH 4/4] v4l2-mem2mem: allow reqbufs(0) with "in use" MMAP
 buffers
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	'John Sheu' <sheu@google.com>, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, posciak@google.com, arun.m@samsung.com,
	kgene.kim@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 02 Nov 2015 13:31:40 -0500
In-Reply-To: <5343D4BD.4090809@samsung.com>
References: <1394578325-11298-1-git-send-email-sheu@google.com>
	 <1394578325-11298-5-git-send-email-sheu@google.com>
	 <06c801cf526f$7b0498a0$710dc9e0$%debski@samsung.com>
	 <5343D4BD.4090809@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-US8E6cjaXSeEcT/+K2Tq"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-US8E6cjaXSeEcT/+K2Tq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 08 avril 2014 =C3=A0 12:51 +0200, Marek Szyprowski a =C3=A9crit :
> Hello,
>=20
> On 2014-04-07 16:41, Kamil Debski wrote:
> > Pawel, Marek,
> >=20
> > Before taking this to my tree I wanted to get an ACK from one of
> > the
> > videobuf2 maintainers. Could you spare a moment to look through
> > this
> > patch?
>=20
> It's not a bug, it is a feature. This was one of the fundamental
> design=20
> requirements to allow applications to track if the memory is used or
> not.

I still have the impression it is not fully correct for the case
buffers are exported using DMABUF. Like if the dmabuf was owning the
vb2 buffer instead of the opposite ...

Nicolas
--=-US8E6cjaXSeEcT/+K2Tq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlY3rAwACgkQcVMCLawGqBwRVQCgtHrcXCcrXSKTHpgbJa8KIdZ6
bpQAn3sw32AhbPEdC1bVvjotnMUTkaAL
=59Lf
-----END PGP SIGNATURE-----

--=-US8E6cjaXSeEcT/+K2Tq--

