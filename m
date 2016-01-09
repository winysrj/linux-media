Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:41027 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbcAINQP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 08:16:15 -0500
Date: Sat, 9 Jan 2016 14:16:07 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] soc_camera: cleanup control device on async_unbind
Message-ID: <20160109131607.GA1520@katana>
References: <1451911723-10868-1-git-send-email-wsa@the-dreams.de>
 <Pine.LNX.4.64.1601091226440.15612@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1601091226440.15612@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Thanks for the patch! From looking at it, I agree, that this looks like a=
=20
> fix, and I even would recommend it for stable, but - at least for that I'=
d=20
> like this patch to actually be tested! At least if someone could try to=
=20
> use the camera after such a unbind / bind cycle. Would you be able to tes=
t=20
> this? Until then I'll just push this for the forthcoming 4.5.

I'll try to get it tested.

Thanks,

   Wolfram


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWkQgXAAoJEBQN5MwUoCm27pMP/RxmsC0VkAOQPz8N3/Srfcgq
Lc+3bumUT5NlLbelIcNoAx2MVNR8wypbqeA7XuudL0DVCNsfivWdvaTY8aQaRSjF
gsKRs3U4TMasW8i+TyAEE4qVHhfSxWYYGMfkJIJt5QzdQPsYPmOE5d+TV6p6TrBF
k255RlD9SQ7hwupDobIykAMt0LPjttvNh3jFQXcgey9aQW6pBIwGcsLbcbDD9fmd
c9LM9Q72rtn9EtGVS2r/792BuABmHRt45yv83bUVYBW7TfxD7brP6OZj8li4QxXs
kQru/sxjS3/vOL1QfVxfTXFcKNEHF+zSJX2gN5E818jLc65ngGHXlQG6g5uV0A6g
TePyqRBVi6OZiSGFTmUU0oQBkXxGXK0DQ8f3brC12JFa0ZGL+zJO5YtyjZTwxClE
fPXBdZdTsVhC6GQD7HSy67Zlvxkn9Rk5uQopGZTasAfR5fMwwbwGUwxaKQLgAR04
+3DGAZ56zTSIdT0HuIxJoXIVwi5DcfUJW0v1y6AIE7XEuITf796Y8V2FV2X6+21v
9RZzUhWjvoCJwO8rihHRNjGtSQk3sH2opJQJw0lcGgP7kjiRz2/ptJz24yF+EUAy
gITkNDPZqbcbSKKy6ZJEtAPUk3PEjkg49REwDwo32mmfpI2lFdIdMBuTNfYGF0GA
iSv0QuaqgujUxc914MG/
=J3l4
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
