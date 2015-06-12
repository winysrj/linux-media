Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38775 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbbFLJpm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:45:42 -0400
Message-ID: <557AAA0F.2030400@ti.com>
Date: Fri, 12 Jun 2015 12:44:47 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Fabian Frederick <fabf@skynet.be>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 2/9] [media] media: omap_vout: Convert omap_vout_uservirt_to_phys()
 to use get_vaddr_pfns()
References: <cover.1433927458.git.mchehab@osg.samsung.com> <1439884.SWlnxou8Xt@avalon> <557AA489.2010809@ti.com> <29269630.Rti2m5eC9a@avalon>
In-Reply-To: <29269630.Rti2m5eC9a@avalon>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="KVDhI5J0bg9D3UgKaMmKPCxWlFwsaBFKI"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--KVDhI5J0bg9D3UgKaMmKPCxWlFwsaBFKI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable



On 12/06/15 12:26, Laurent Pinchart wrote:
> Hi Tomi,
>=20
> On Friday 12 June 2015 12:21:13 Tomi Valkeinen wrote:
>> On 11/06/15 07:21, Laurent Pinchart wrote:
>>> On Wednesday 10 June 2015 06:20:45 Mauro Carvalho Chehab wrote:
>>>> From: Jan Kara <jack@suse.cz>
>>>>
>>>> Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns() instead=
 of
>>>> hand made mapping of virtual address to physical address. Also the
>>>> function leaked page reference from get_user_pages() so fix that by
>>>> properly release the reference when omap_vout_buffer_release() is
>>>> called.
>>>>
>>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> [hans.verkuil@cisco.com: remove unused struct omap_vout_device *vout=

>>>> variable]
>>>>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>
>>>> diff --git a/drivers/media/platform/omap/omap_vout.c
>>>> b/drivers/media/platform/omap/omap_vout.c index
>>>> f09c5f17a42f..7feb6394f111
>>>> 100644
>>>> --- a/drivers/media/platform/omap/omap_vout.c
>>>> +++ b/drivers/media/platform/omap/omap_vout.c
>>>> @@ -195,46 +195,34 @@ static int omap_vout_try_format(struct
>>>> v4l2_pix_format *pix) }
>>>>
>>>>  /*
>>>>
>>>> - * omap_vout_uservirt_to_phys: This inline function is used to conv=
ert
>>>> user - * space virtual address to physical address.
>>>> + * omap_vout_get_userptr: Convert user space virtual address to phy=
sical
>>>> + * address.
>>>>
>>>>   */
>>>>
>>>> -static unsigned long omap_vout_uservirt_to_phys(unsigned long virtp=
)
>>>> +static int omap_vout_get_userptr(struct videobuf_buffer *vb, u32 vi=
rtp,
>>>> +				 u32 *physp)
>>>>
>>>>  {
>>>>
>>>> -	unsigned long physp =3D 0;
>>>> -	struct vm_area_struct *vma;
>>>> -	struct mm_struct *mm =3D current->mm;
>>>> +	struct frame_vector *vec;
>>>> +	int ret;
>>>>
>>>>  	/* For kernel direct-mapped memory, take the easy way */
>>>>
>>>> -	if (virtp >=3D PAGE_OFFSET)
>>>> -		return virt_to_phys((void *) virtp);
>>>> -
>>>> -	down_read(&current->mm->mmap_sem);
>>>> -	vma =3D find_vma(mm, virtp);
>>>> -	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
>>>> -		/* this will catch, kernel-allocated, mmaped-to-usermode
>>>> -		   addresses */
>>>> -		physp =3D (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start)=
;
>>>> -		up_read(&current->mm->mmap_sem);
>>>> -	} else {
>>>> -		/* otherwise, use get_user_pages() for general userland pages */
>>>> -		int res, nr_pages =3D 1;
>>>> -		struct page *pages;
>>>> +	if (virtp >=3D PAGE_OFFSET) {
>>>> +		*physp =3D virt_to_phys((void *)virtp);
>>>
>>> Lovely. virtp comes from userspace and as far as I know it arrives he=
re
>>> completely unchecked. The problem isn't introduced by this patch, but=

>>> omap_vout buffer management seems completely broken to me, and nobody=

>>> seems to care about the driver. Given that omapdrm should now provide=
 the
>>> video output capabilities that are missing from omapfb and resulted i=
n
>>> the development of omap_vout, shouldn't we drop the omap_vout driver =
?
>>>
>>> Tomi, any opinion on this ? Do you see any omap_vout capability missi=
ng
>>> from omapdrm ?
>>
>> I've never used omap_vout, so I don't even know what it offers. I do
>> know it supports VRFB rotation (omap3), which we don't have on omapdrm=
,
>> though. Whether anyone uses that (or omap_vout), I have no idea...
>>
>> I'd personally love to get rid of omap_vout, as it causes complication=
s
>> on omapfb/omapdss side.
>=20
> How difficult would it be to implement VRFB rotation in omapdrm ?

I don't know... drivers/video/fbdev/omap2/vrfb.c contains the code to
handle the VRFB hardware, but it does require certain amount of book
keeping and tweaking of the fb size etc from the omapdrm side. And
probably a new parameter to somehow enable vrfb for a buffer, as you
don't want it to be used by default.

 Tomi


--KVDhI5J0bg9D3UgKaMmKPCxWlFwsaBFKI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVeqoPAAoJEPo9qoy8lh710fcP/2v/+Z4PaxAOu02L5DRa7CrC
HHiR9oFn8cC5pJeql/Ja2BFDaLi11NstsqiuNxKeYQoKCRzNWFCdvQxXjHnHAN0t
/WSfVxkZvOxNVJrIqW8qCxma6NHJ/fBkxLNegxb2rxH3p0fkaCdUSh63496RO1AN
uslLl0Ux7Roz7LjEMmdnX8ohfLjWQ9CWD6qouxU5Ep0rlTCBlnlKcZ5Bx/wqewNQ
IESXrQobFB9KF8vRM2GEI25JF9PP7j7zDigtlE5amNJv29Og07we8Lkn6y1PWgxF
k3lc10tWgI1V+34q8RLwAyNZTWy17e/HRoHh+GW0HF1mY1d2j1kBZa2UwcYcLIi9
m6LWFh9Rekng7ADx5eJrlnm2r24Kx58FjXipZu/YwuycZdJkObHVvZ4oFugsUaKl
/HFQaEqOW/TzHjFwieu+sMjbSzqAqsC/AW3jF3lofhx5ix/SGbywo3j9sEJnbT8O
+jlvF4XcjgxMSKUeSdkPyjLoBgCNVLHDFeGqOrVUrWfQjREu2NvxAlx4iJuDaTTf
Jhf51Bc4WJICz2mHbV7rL5vfptFyGYJ1jLEkzNwant9NLFhwYe+2BsoGUG/Og4R9
c1YXaroNs9umY34CeSLRwibVXl0kSb1KwP4czB9bOQdRRJ3ezLFjGE7O4vls3KiU
CX7zl0i9odO28okD8KjQ
=tk4z
-----END PGP SIGNATURE-----

--KVDhI5J0bg9D3UgKaMmKPCxWlFwsaBFKI--
