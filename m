Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60035 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbFLJ0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:26:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Fabian Frederick <fabf@skynet.be>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 2/9] [media] media: omap_vout: Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
Date: Fri, 12 Jun 2015 12:26:54 +0300
Message-ID: <29269630.Rti2m5eC9a@avalon>
In-Reply-To: <557AA489.2010809@ti.com>
References: <cover.1433927458.git.mchehab@osg.samsung.com> <1439884.SWlnxou8Xt@avalon> <557AA489.2010809@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1635631.KTWNiAdqH6"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1635631.KTWNiAdqH6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Friday 12 June 2015 12:21:13 Tomi Valkeinen wrote:
> On 11/06/15 07:21, Laurent Pinchart wrote:
> > On Wednesday 10 June 2015 06:20:45 Mauro Carvalho Chehab wrote:
> >> From: Jan Kara <jack@suse.cz>
> >>=20
> >> Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns() inste=
ad of
> >> hand made mapping of virtual address to physical address. Also the=

> >> function leaked page reference from get_user_pages() so fix that b=
y
> >> properly release the reference when omap_vout_buffer_release() is
> >> called.
> >>=20
> >> Signed-off-by: Jan Kara <jack@suse.cz>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> [hans.verkuil@cisco.com: remove unused struct omap_vout_device *vo=
ut
> >> variable]
> >>=20
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >>=20
> >> diff --git a/drivers/media/platform/omap/omap_vout.c
> >> b/drivers/media/platform/omap/omap_vout.c index
> >> f09c5f17a42f..7feb6394f111
> >> 100644
> >> --- a/drivers/media/platform/omap/omap_vout.c
> >> +++ b/drivers/media/platform/omap/omap_vout.c
> >> @@ -195,46 +195,34 @@ static int omap_vout_try_format(struct
> >> v4l2_pix_format *pix) }
> >>=20
> >>  /*
> >>=20
> >> - * omap_vout_uservirt_to_phys: This inline function is used to co=
nvert
> >> user - * space virtual address to physical address.
> >> + * omap_vout_get_userptr: Convert user space virtual address to p=
hysical
> >> + * address.
> >>=20
> >>   */
> >>=20
> >> -static unsigned long omap_vout_uservirt_to_phys(unsigned long vir=
tp)
> >> +static int omap_vout_get_userptr(struct videobuf_buffer *vb, u32 =
virtp,
> >> +=09=09=09=09 u32 *physp)
> >>=20
> >>  {
> >>=20
> >> -=09unsigned long physp =3D 0;
> >> -=09struct vm_area_struct *vma;
> >> -=09struct mm_struct *mm =3D current->mm;
> >> +=09struct frame_vector *vec;
> >> +=09int ret;
> >>=20
> >>  =09/* For kernel direct-mapped memory, take the easy way */
> >>=20
> >> -=09if (virtp >=3D PAGE_OFFSET)
> >> -=09=09return virt_to_phys((void *) virtp);
> >> -
> >> -=09down_read(&current->mm->mmap_sem);
> >> -=09vma =3D find_vma(mm, virtp);
> >> -=09if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
> >> -=09=09/* this will catch, kernel-allocated, mmaped-to-usermode
> >> -=09=09   addresses */
> >> -=09=09physp =3D (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_=
start);
> >> -=09=09up_read(&current->mm->mmap_sem);
> >> -=09} else {
> >> -=09=09/* otherwise, use get_user_pages() for general userland pag=
es */
> >> -=09=09int res, nr_pages =3D 1;
> >> -=09=09struct page *pages;
> >> +=09if (virtp >=3D PAGE_OFFSET) {
> >> +=09=09*physp =3D virt_to_phys((void *)virtp);
> >=20
> > Lovely. virtp comes from userspace and as far as I know it arrives =
here
> > completely unchecked. The problem isn't introduced by this patch, b=
ut
> > omap_vout buffer management seems completely broken to me, and nobo=
dy
> > seems to care about the driver. Given that omapdrm should now provi=
de the
> > video output capabilities that are missing from omapfb and resulted=
 in
> > the development of omap_vout, shouldn't we drop the omap_vout drive=
r ?
> >=20
> > Tomi, any opinion on this ? Do you see any omap_vout capability mis=
sing
> > from omapdrm ?
>=20
> I've never used omap_vout, so I don't even know what it offers. I do
> know it supports VRFB rotation (omap3), which we don't have on omapdr=
m,
> though. Whether anyone uses that (or omap_vout), I have no idea...
>=20
> I'd personally love to get rid of omap_vout, as it causes complicatio=
ns
> on omapfb/omapdss side.

How difficult would it be to implement VRFB rotation in omapdrm ?

=2D-=20
Regards,

Laurent Pinchart

--nextPart1635631.KTWNiAdqH6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJVeqXjAAoJEGIlXSmeKAskt/MQAI9B6niIHSKkKdj18FKdQRKP
pBHiMTCW0KQJakWeu8zI01BBp05srwU+1mMSKUCcNcaDmEkNi+rTIwvWAZvnabyj
rD8Cjf/hn554Ydrz0Pgjrb+H3JV5AzyzTaFmKI3LUk5Q+MKR+//vnxyi45F+jJ2E
3FWDFmMvCK0p4VdKg2AOTPfwSmzFc57dGdeeF6tgRDZDXjdZj9OSi7Yo4+euYdIN
/FL/a+JZt6fAJSktkWW09k5ftpTEWdh2OOy7+PHX3lWNI6BvdxTNJEQP+4XAxFXE
qGEX1P04EarESK38jAmfcr4ho1nRFM1fDEtI6lKr4jeQy6eGl2HXBwN+IcNJMk5F
7dI15hV60AINFIoSlqxDwQGJBDsRxDxKDXpMxr85a2HXZqaL7jwJ/buUJce+Ret4
2rothyXZG/n41KwVm4TH8A7iG/JJvSDKYyakDpIH9ZceJ9d1WgYK5Xqj9Gu81Clt
yMNbesrFTPGAge+T1adOmmWL3k2Vcc6mLXYNYrBnIWMv9Vidkwad8RxWnjqvyo5s
S1GflCjzXUBGNsdhRruKuhO77Zsq9L84fV8z0wsTGRlBLETVkIt06pT/2Y5vNesw
vnGhovIscC5DY5VuAhhBAgI3JwJ02PCmAQ1xayoZ26bTrHxRBBB92MqqUN69lix5
I5zdqleMX3bYBzTS7Wli
=g6iC
-----END PGP SIGNATURE-----

--nextPart1635631.KTWNiAdqH6--

