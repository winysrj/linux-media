Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56848 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbFLJVw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:21:52 -0400
Message-ID: <557AA489.2010809@ti.com>
Date: Fri, 12 Jun 2015 12:21:13 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Fabian Frederick <fabf@skynet.be>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 2/9] [media] media: omap_vout: Convert omap_vout_uservirt_to_phys()
 to use get_vaddr_pfns()
References: <cover.1433927458.git.mchehab@osg.samsung.com> <0bec810973e08df0e66260e84d2dcea055a3fad7.1433927458.git.mchehab@osg.samsung.com> <1439884.SWlnxou8Xt@avalon>
In-Reply-To: <1439884.SWlnxou8Xt@avalon>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="bsiV35k3TlaTVqjU2LBbdjHtoxwglj1ci"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--bsiV35k3TlaTVqjU2LBbdjHtoxwglj1ci
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable



On 11/06/15 07:21, Laurent Pinchart wrote:
> Hello,
>=20
> (CC'ing Tomi Valkeinen)
>=20
> On Wednesday 10 June 2015 06:20:45 Mauro Carvalho Chehab wrote:
>> From: Jan Kara <jack@suse.cz>
>>
>> Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns() instead o=
f
>> hand made mapping of virtual address to physical address. Also the
>> function leaked page reference from get_user_pages() so fix that by
>> properly release the reference when omap_vout_buffer_release() is
>> called.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> [hans.verkuil@cisco.com: remove unused struct omap_vout_device *vout
>> variable]
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>> diff --git a/drivers/media/platform/omap/omap_vout.c
>> b/drivers/media/platform/omap/omap_vout.c index f09c5f17a42f..7feb6394=
f111
>> 100644
>> --- a/drivers/media/platform/omap/omap_vout.c
>> +++ b/drivers/media/platform/omap/omap_vout.c
>> @@ -195,46 +195,34 @@ static int omap_vout_try_format(struct v4l2_pix_=
format
>> *pix) }
>>
>>  /*
>> - * omap_vout_uservirt_to_phys: This inline function is used to conver=
t user
>> - * space virtual address to physical address.
>> + * omap_vout_get_userptr: Convert user space virtual address to physi=
cal
>> + * address.
>>   */
>> -static unsigned long omap_vout_uservirt_to_phys(unsigned long virtp)
>> +static int omap_vout_get_userptr(struct videobuf_buffer *vb, u32 virt=
p,
>> +				 u32 *physp)
>>  {
>> -	unsigned long physp =3D 0;
>> -	struct vm_area_struct *vma;
>> -	struct mm_struct *mm =3D current->mm;
>> +	struct frame_vector *vec;
>> +	int ret;
>>
>>  	/* For kernel direct-mapped memory, take the easy way */
>> -	if (virtp >=3D PAGE_OFFSET)
>> -		return virt_to_phys((void *) virtp);
>> -
>> -	down_read(&current->mm->mmap_sem);
>> -	vma =3D find_vma(mm, virtp);
>> -	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
>> -		/* this will catch, kernel-allocated, mmaped-to-usermode
>> -		   addresses */
>> -		physp =3D (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
>> -		up_read(&current->mm->mmap_sem);
>> -	} else {
>> -		/* otherwise, use get_user_pages() for general userland pages */
>> -		int res, nr_pages =3D 1;
>> -		struct page *pages;
>> +	if (virtp >=3D PAGE_OFFSET) {
>> +		*physp =3D virt_to_phys((void *)virtp);
>=20
> Lovely. virtp comes from userspace and as far as I know it arrives here=
=20
> completely unchecked. The problem isn't introduced by this patch, but=20
> omap_vout buffer management seems completely broken to me, and nobody s=
eems to=20
> care about the driver. Given that omapdrm should now provide the video =
output=20
> capabilities that are missing from omapfb and resulted in the developme=
nt of=20
> omap_vout, shouldn't we drop the omap_vout driver ?
>=20
> Tomi, any opinion on this ? Do you see any omap_vout capability missing=
 from=20
> omapdrm ?

I've never used omap_vout, so I don't even know what it offers. I do
know it supports VRFB rotation (omap3), which we don't have on omapdrm,
though. Whether anyone uses that (or omap_vout), I have no idea...

I'd personally love to get rid of omap_vout, as it causes complications
on omapfb/omapdss side.

 Tomi


--bsiV35k3TlaTVqjU2LBbdjHtoxwglj1ci
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVeqSJAAoJEPo9qoy8lh71y64P/18CghTefqd9nk8DuUmYsD87
dgBI4j2byY2h58UiI0XZZwOcNUWLKOTELxhMHSG82m/6E3qwL53ExYBFG3th5hhu
X2AQ3BhtOjxz3/ARrhKzuslshVrWNjw24dLaIcFdoHXb6TK+b+Xq2PPaGssTcQIH
CN77dg/hrPc9sqAXoVp8ygwrFwVCV6dZEZBTvWYCLNA639eKWhYxIfRjR9aKRdBi
Vcd0sjjXK19y61cOJYS6abYrsgUrkgV8PSNeNgSYEZH8qv2sae57beX8JdwjeWy6
4xdaa3wSNxGY2/t5Kee0/XOngaXJy6PhUU8oAIuTWK+nWzfxta3BZxyr+QEUKMK5
Isji8+fba+9JcHe7A93bKrKUIyxJQT4GvuzhuGFEwrbf8T8pdb/8pEJ6CDL6xLqg
ErC6SbbF+NkFGgVoBpTDgV/8gic9iR+oa4cSvr4EgjUnlvZYvmPJeJKhin3vmroa
alrubJVQEDL0TSzK6lR/n9eSaFisdH5YVy0Zuv1VL6zjQ7CikWV1Z2A/53uwm4Pm
QWtg4bUX1gnCkIQpnHWc9C6BxSSr1LBazd9JgodhYEM/WlOr1u1N32PRhAeTtai8
Weo7zueSIpYwRjJbgpkFZEL5YB7/qQ1riJ7uxNnVn/1MnLTA9ml77FH8phGYMnB/
2/trcdR9MgYc+fXgabcm
=wryq
-----END PGP SIGNATURE-----

--bsiV35k3TlaTVqjU2LBbdjHtoxwglj1ci--
