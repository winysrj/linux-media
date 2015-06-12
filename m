Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbbFLDgx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 23:36:53 -0400
Message-ID: <557A53CA.8030607@redhat.com>
Date: Thu, 11 Jun 2015 23:36:42 -0400
From: Doug Ledford <dledford@redhat.com>
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	mchehab@osg.samsung.com, tomi.valkeinen@ti.com,
	bhelgaas@google.com, luto@amacapital.net,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Toshi Kani <toshi.kani@hp.com>,
	Roland Dreier <roland@kernel.org>,
	Sean Hefty <sean.hefty@intel.com>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Juergen Gross <jgross@suse.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@redhat.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	infinipath@intel.com, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v6 2/3] IB/ipath: add counting for MTRR
References: <1434045002-31575-1-git-send-email-mcgrof@do-not-panic.com> <1434045002-31575-3-git-send-email-mcgrof@do-not-panic.com> <20150611195424.GG30391@pd.tnic>
In-Reply-To: <20150611195424.GG30391@pd.tnic>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TjKokMuvLWFTs6vss1j9T2rV73fUmrJvX"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TjKokMuvLWFTs6vss1j9T2rV73fUmrJvX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/11/2015 03:54 PM, Borislav Petkov wrote:
> On Thu, Jun 11, 2015 at 10:50:01AM -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>
>> There is no good reason not to, we eventually delete it as well.
>>
>> Cc: Toshi Kani <toshi.kani@hp.com>
>> Cc: Roland Dreier <roland@kernel.org>
>> Cc: Sean Hefty <sean.hefty@intel.com>
>> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
>> Cc: Suresh Siddha <sbsiddha@gmail.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Juergen Gross <jgross@suse.com>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Dave Airlie <airlied@redhat.com>
>> Cc: Antonino Daplas <adaplas@gmail.com>
>> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
>> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Cc: infinipath@intel.com
>> Cc: linux-rdma@vger.kernel.org
>> Cc: linux-fbdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
>> ---
>>  drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/i=
nfiniband/hw/ipath/ipath_wc_x86_64.c
>> index 4ad0b93..70c1f3a 100644
>> --- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
>> +++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
>> @@ -127,7 +127,7 @@ int ipath_enable_wc(struct ipath_devdata *dd)
>>  			   "(addr %llx, len=3D0x%llx)\n",
>>  			   (unsigned long long) pioaddr,
>>  			   (unsigned long long) piolen);
>> -		cookie =3D mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 0);
>> +		cookie =3D mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
>>  		if (cookie < 0) {
>>  			{
>>  				dev_info(&dd->pcidev->dev,
>> --
>=20
> Doug, ack?
>=20

Ack.



--TjKokMuvLWFTs6vss1j9T2rV73fUmrJvX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVelPLAAoJELgmozMOVy/dhN4P+wSfNLyRQ9hda9uQfjQS5eDK
VrFc32VnqudghW4diOrN2mi3yOFZ6bD0MVoM4LlBCRxdTB6tFt8o6mmfIMZhzQnr
SO2P3taBPJHyPJJ4n8IggNdbsZJzrws9TU5PxlSFGrq6qEG25w/fCCwxYUocpZlS
3Ux3lLj/5LcJxiukiEVOwH9aUS/LyzCoQK5m6aqB+bGpQGZN+ypM6Xv6aWElFHCt
1CXI02toYztImpoliozpr+OS/pkXFlopct774ckw0w/DlqgDgU/H2QbRadDPIaDy
iuifQB1scnFvoxfzR6ZstPkQfAKcoKJM+s1TOAjUP4YzcOd1jBJ7QXDRa0AcaTrG
TaA/Xu08uUrteUolmV85o3bnxGBIjrbLThNkiIsmlA70kTVoSctxskpiIQ+qeyV0
PrrWfHIGS9scFwLz+YcxHc98g9891u6cS4OLy+R8ovQu7osGGshgaCmMB2pRXx1H
fT4h238bFbF9/tCLy7XcWxA5QzaKnzNH/zzNi8JE1cgzrD7QJceJ4KGwtCnZXD/a
lGF/0SnctcQo3FVJYkifn9lL28iyKRPuADxnsCDDD5k3AmvvzDuOjX6VSrUqkD0m
yGEuVIGUph2uyMg27GserInmgvoN2+hnQt0hd0DVobOOuTU2g+XImgc1cPsaE4KZ
xVmBwq+6mVMXYItcFLyC
=hDOz
-----END PGP SIGNATURE-----

--TjKokMuvLWFTs6vss1j9T2rV73fUmrJvX--
