Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49308 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732169AbeGaPfy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 11:35:54 -0400
Subject: Re: [PATCH][media-next] media: i2c: mt9v111: fix off-by-one array
 bounds check
To: jacopo mondi <jacopo@jmondi.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180731133343.22337-1-colin.king@canonical.com>
 <20180731135341.GD370@w540>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <c2684aa2-71d7-b82e-df18-65ea3f026d97@canonical.com>
Date: Tue, 31 Jul 2018 14:55:25 +0100
MIME-Version: 1.0
In-Reply-To: <20180731135341.GD370@w540>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LZ1qMDqUuxCCXYuIsl94ncFyuaq2aEgbe"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LZ1qMDqUuxCCXYuIsl94ncFyuaq2aEgbe
Content-Type: multipart/mixed; boundary="xJWLQlqaIbhqGrEllJgQyVPkM8z6YSdnR";
 protected-headers="v1"
From: Colin Ian King <colin.king@canonical.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <c2684aa2-71d7-b82e-df18-65ea3f026d97@canonical.com>
Subject: Re: [PATCH][media-next] media: i2c: mt9v111: fix off-by-one array
 bounds check
References: <20180731133343.22337-1-colin.king@canonical.com>
 <20180731135341.GD370@w540>
In-Reply-To: <20180731135341.GD370@w540>

--xJWLQlqaIbhqGrEllJgQyVPkM8z6YSdnR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 31/07/18 14:53, jacopo mondi wrote:
> Hi Colin,
>    thanks for the patch.
>=20
> On Tue, Jul 31, 2018 at 02:33:43PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The check of fse->index is off-by-one and should be using >=3D rather
>> than > to check the maximum allowed array index. Fix this.
>>
>> Detected by CoverityScan, CID#172122 ("Out-of-bounds read")
>>
>> Fixes: aab7ed1c3927 ("media: i2c: Add driver for Aptina MT9V111")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>=20
> Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>=20
> Thanks
>   j
>=20

Just to note, I also got a build warning on this driver, so that's
something that should be fixed up too.

drivers/media/i2c/mt9v111.c:887:15: warning: 'idx' may be used
uninitialized in this function [-Wmaybe-uninitialized]
  unsigned int idx;



--xJWLQlqaIbhqGrEllJgQyVPkM8z6YSdnR--

--LZ1qMDqUuxCCXYuIsl94ncFyuaq2aEgbe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEcGLapPABucZhZwDPaMKH38aoAiYFAltgak0ACgkQaMKH38ao
AiakZA//R+e/bYVFB1kP+CDC3nVxffaAMDLFejUiGZfn5xkpyVLkp5cnIas1g4En
Yzxe8IRm9tS3iByFeQA/jZPgg3uyJjAB6qei9sKPx0RWzw/7uFTjycDs8DXpxoY5
ZExZtWd7/Afx+IoXy1O2r6HFKkmOQ1l2uYSYV3wBh9O43rQra9tJna4w5E2dFZmr
DaFUtbD4eynrTXzMC7ct8uaP6ijGDOKPztnLNRSqDRRl9yOmSKcaOzARtluhicn3
stBTjqtqIRhbtejMhNyNjAvmHf+PXCZ7CTS8Vt4vCwBWc0ikeUeNu7he7xP5mA4V
fSSaAZRaLMtk5l2nzJCqeZEOg1ROJ1GmTvYQx/AKn3R+eS3PVxUTqLVmZLUtATNQ
V+6jhA4Av6Von1bXaLgqBbW4tZ5PMEFGQI+vsRTh9n2jGuadYsQgRVobnWvfCqAE
yXDxwes6ILwfEzzEf+VnpEuFQSTDD5Rmdh8pPKc6FhVMXzU1uc2cU09YRZzv0RLJ
Pq4ARPLgkljGilDp266+61I1oDx3uG3HpOuCX4MtjUnsBAYljT4tM9588ioc8B3E
O5qjrZrHhe4Ebumcbb6ZnE+NwkJNLL4QNMSA2lpNNjlTgYhr880gzC4rke1cAq+E
pkfrhWbxRaDwY+rQd4xwmzzvZhzxrsbmt0WIfDqp7kYe0Iiu/tw=
=qqSn
-----END PGP SIGNATURE-----

--LZ1qMDqUuxCCXYuIsl94ncFyuaq2aEgbe--
