Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48087 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbcFPRno (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 13:43:44 -0400
Message-ID: <1466099012.11108.17.camel@ndufresne.ca>
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Jack Mitchell <ml@embed.me.uk>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
Date: Thu, 16 Jun 2016 13:43:32 -0400
In-Reply-To: <5762DB8A.8090906@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <64c29bbc-2273-2a9d-3059-ab8f62dc531b@embed.me.uk>
 <576202D0.6010608@mentor.com>
 <597d73df-0fa0-fa8d-e0e5-0ad8b2c49bcf@embed.me.uk>
	 <5762DB8A.8090906@mentor.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HR4ykn+boAJviEQ05ydc"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-HR4ykn+boAJviEQ05ydc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 16 juin 2016 =C3=A0 10:02 -0700, Steve Longerbeam a =C3=A9crit=C2=
=A0:
> I found the cause at least in my case. After enabling dynamic debug in
> videobuf2-dma-contig.c, "v4l2-ctl -d/dev/video0 --stream-user=3D8" gives
> me
>=20
> [=C2=A0 468.826046] user data must be aligned to 64 bytes
>=20
>=20
>=20
> But even getting past that alignment issue, I've only tested userptr (in =
mem2mem
> driver) by giving the driver a user address of a mmap'ed kernel contiguou=
s
> buffer. A true discontiguous user buffer may not work, the IPU DMA does n=
ot
> support scatter-gather.

If it's dma-contig, you'll need page aligned and contiguous memory.
What some test application do when testing their driver with that, is
to allocate memory using another device, or m2m device, that uses the
same allocator.

regards,
Nicolas
--=-HR4ykn+boAJviEQ05ydc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAldi5UQACgkQcVMCLawGqBwX8QCfVFNHTp8e4ZmukmgYSYyZu4Kd
qpgAoM/gHSYcvp7UlTwPvWD2mw4TUcZj
=sJvA
-----END PGP SIGNATURE-----

--=-HR4ykn+boAJviEQ05ydc--

