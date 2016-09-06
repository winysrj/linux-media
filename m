Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56259 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755981AbcIFSe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 14:34:58 -0400
Message-ID: <1473186892.2668.14.camel@ndufresne.ca>
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Date: Tue, 06 Sep 2016 14:34:52 -0400
In-Reply-To: <20160720132005.GC7976@valkosipuli.retiisi.org.uk>
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
         <20160720132005.GC7976@valkosipuli.retiisi.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-RcdezD98ndYiF1pBg0DM"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-RcdezD98ndYiF1pBg0DM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 20 juillet 2016 =C3=A0 16:20 +0300, Sakari Ailus a =C3=A9crit=
=C2=A0:
> Hi Javier,
>=20
> On Fri, Jul 15, 2016 at 12:26:06PM -0400, Javier Martinez Canillas
> wrote:
> > The buffer planes' dma-buf are currently mapped when buffers are queued
> > from userspace but it's more appropriate to do the mapping when buffers
> > are queued in the driver since that's when the actual DMA operation are
> > going to happen.
> >=20
> > Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> >=20
> > ---
> >=20
> > Hello,
> >=20
> > A side effect of this change is that if the dmabuf map fails for some
> > reasons (i.e: a driver using the DMA contig memory allocator but CMA
> > not being enabled), the fail will no longer happen on VIDIOC_QBUF but
> > later (i.e: in VIDIOC_STREAMON).
> >=20
> > I don't know if that's an issue though but I think is worth mentioning.
>=20
> I have the same question has Hans --- why?
>=20
> I rather think we should keep the buffers mapped all the time. That'd
> require a bit of extra from the DMA-BUF framework I suppose, to support
> streaming mappings.
>=20
> The reason for that is performance. If you're passing the buffer between =
a
> couple of hardware devices, there's no need to map and unmap it every tim=
e
> the buffer is accessed by the said devices. That'd avoid an unnecessary
> cache flush as well, something that tends to be quite expensive. On a PC
> with resolutions typically used on webcams that might not really matter. =
But
> if you have an embedded system with a relatively modest 10 MP camera sens=
or,
> it's one of the first things you'll notice if you check where the CPU tim=
e
> is being spent.

That is very interesting since the initial discussion started from the
idea of adding an implicit fence wait to the map operation. This way we
could have a dma-buf fence attached without having to modify the
drivers to support it. Buffer handles could be dispatched before there
is any data in it. Though, if we keep it mapped, I believe this idea is
simply incompatible and fences should remain explicit for extra
flexibility.
--=-RcdezD98ndYiF1pBg0DM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlfPDEwACgkQcVMCLawGqByubACgu+GXVJ9P6QTCgaFIeJAhiKS9
AKwAnjkyUr9jyj4g85VYxoPQdtoLRjWN
=nxBJ
-----END PGP SIGNATURE-----

--=-RcdezD98ndYiF1pBg0DM--

