Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46978 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbeKTARz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 19:17:55 -0500
Message-ID: <4e517aa9f91b006ddcf2cd9631cee101a66470b8.camel@bootlin.com>
Subject: Re: [PATCHv2 0/9] vb2/cedrus: add tag support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, tfiga@chromium.org,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Date: Mon, 19 Nov 2018 14:53:51 +0100
In-Reply-To: <93b53779-2218-e69a-5f2b-bdf5d76d6d15@xs4all.nl>
References: <20181114134743.18993-1-hverkuil@xs4all.nl>
         <93b53779-2218-e69a-5f2b-bdf5d76d6d15@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-AnlUza8hGhX2anTDXEft"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-AnlUza8hGhX2anTDXEft
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-11-19 at 12:18 +0100, Hans Verkuil wrote:
> On 11/14/2018 02:47 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hansverk@cisco.com>
> >=20
> > As was discussed here (among other places):
> >=20
> > https://lkml.org/lkml/2018/10/19/440
> >=20
> > using capture queue buffer indices to refer to reference frames is
> > not a good idea. A better idea is to use a 'tag' where the
> > application can assign a u64 tag to an output buffer, which is then=20
> > copied to the capture buffer(s) derived from the output buffer.
> >=20
> > A u64 is chosen since this allows userspace to also use pointers to
> > internal structures as 'tag'.
> >=20
> > The first three patches add core tag support, the next patch document
> > the tag support, then a new helper function is added to v4l2-mem2mem.c
> > to easily copy data from a source to a destination buffer that drivers
> > can use.
> >=20
> > Next a new supports_tags vb2_queue flag is added to indicate that
> > the driver supports tags. Ideally this should not be necessary, but
> > that would require that all m2m drivers are converted to using the
> > new helper function introduced in the previous patch. That takes more
> > time then I have now since we want to get this in for 4.20.
> >=20
> > Finally the vim2m, vicodec and cedrus drivers are converted to support
> > tags.
> >=20
> > I also removed the 'pad' fields from the mpeg2 control structs (it
> > should never been added in the first place) and aligned the structs
> > to a u32 boundary (u64 for the tag values).
> >=20
> > Note that this might change further (Paul suggested using bitfields).
> >=20
> > Also note that the cedrus code doesn't set the sequence counter, that's
> > something that should still be added before this driver can be moved
> > out of staging.
> >=20
> > Note: if no buffer is found for a certain tag, then the dma address
> > is just set to 0. That happened before as well with invalid buffer
> > indices. This should be checked in the driver!
> >=20
> > The previous RFC series was tested successfully with the cedrus driver.
> >=20
> > Regards,
> >=20
> >         Hans
>=20
> I'd like to get some Acked-by or Reviewed-by replies for this series.
> Or comments if you don't like something.

The series looks good to me, so consider it:
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Also, I'm glad you made the v4l2_m2m_buf_copy_data helper function,
since all drivers will need to do these same operations anyway.

> I would really like to get this in for 4.20 so the cedrus API is stable
> (hopefully), since this is a last outstanding API item.

I see a few more items that we need to tackle before we can consider the
MPEG-2 stateless API as stable.

* I mentionned using flags in the mpeg2 structures to solve the
alignment issues, but I failed to provide a patch implementing it at
this point. This would make the MPEG-2 controls more similar to the
proposed H.264 ones and generally makes more sense than using a u8 for a
binary value.

* Some time ago, we also discussed adding extra fields to the structures
for later use. Do you think that is still relevant? Adding a flags
elements (with unused bits) would certainly help in this direction
anyway.

* During the discussions on the spec, the concensus was also to use one
slice_params per-slice (instead of per-picture) which requires splitting
the per-picture and the per-slice parameters. On this as well, I fell
behind and didn't send a proposal yet.

So my question is: does it need to be done for 4.20 or can we affoard
going through another version cycle for these changes?

It was my impression that we wanted to wait for another driver to use
the API to declare it stable (and move the driver out of staging).

Cheers,

Paul

> Tomasz: you commented that the text still referred to the tag as a u64,
> but that was only in the cover letter, not the patches themselves. So
> I don't plan to post a v3 just for that.
>=20
> Regards,
>=20
> 	Hans
>=20
> > Changes since v1:
> >=20
> > - changed to a u32 tag. Using a 64 bit tag was overly complicated due
> >   to the bad layout of the v4l2_buffer struct, and there is no real
> >   need for it by applications.
> >=20
> > Main changes since the RFC:
> >=20
> > - Added new buffer capability flag
> > - Added m2m helper to copy data between buffers
> > - Added documentation
> > - Added tag logging in v4l2-ioctl.c
> >=20
> > Hans Verkuil (9):
> >   videodev2.h: add tag support
> >   vb2: add tag support
> >   v4l2-ioctl.c: log v4l2_buffer tag
> >   buffer.rst: document the new buffer tag feature.
> >   v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
> >   vb2: add new supports_tags queue flag
> >   vim2m: add tag support
> >   vicodec: add tag support
> >   cedrus: add tag support
> >=20
> >  Documentation/media/uapi/v4l/buffer.rst       | 32 +++++++++----
> >  .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++
> >  .../media/common/videobuf2/videobuf2-v4l2.c   | 45 ++++++++++++++++---
> >  drivers/media/platform/vicodec/vicodec-core.c | 14 ++----
> >  drivers/media/platform/vim2m.c                | 14 ++----
> >  drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
> >  drivers/media/v4l2-core/v4l2-ioctl.c          |  9 ++--
> >  drivers/media/v4l2-core/v4l2-mem2mem.c        | 23 ++++++++++
> >  drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++--
> >  .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 +
> >  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++-----
> >  .../staging/media/sunxi/cedrus/cedrus_video.c |  2 +
> >  include/media/v4l2-mem2mem.h                  | 21 +++++++++
> >  include/media/videobuf2-core.h                |  2 +
> >  include/media/videobuf2-v4l2.h                | 21 ++++++++-
> >  include/uapi/linux/v4l2-controls.h            | 14 +++---
> >  include/uapi/linux/videodev2.h                |  9 +++-
> >  17 files changed, 178 insertions(+), 73 deletions(-)
> >=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-AnlUza8hGhX2anTDXEft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvywG8ACgkQ3cLmz3+f
v9HmNggAj1MP5t5mtQ2XbpEnzkCbjfBIGUamxiWORpUcCDkp1lVqqo+LNXPIg9Ux
4US9d2n0+Jth2OPpHbz+o9nsBFmADM07tWAfdT3oHLzaE1Ooui5AGugmz+6yzgOV
632rLbqVUH7sRG+CZPrZqwRaTejNQUvuazuJF19fCkvgRAVv790ArxklysIFkdBc
TCLx/JJ2eeJsSsjlcIRhDypRbgbYY/oKPJWI5s2S1v2GsCZSfo3iSG773CU5vjae
D+gMfWlBLo35a1Ymfs3SJ2W3i4UsFs6yCrU9RZovogzI0SmIDLzk+AnvzLkOCl8+
jrsRR5bGE59C6fLBA1uHXomVj11zkg==
=OfU1
-----END PGP SIGNATURE-----

--=-AnlUza8hGhX2anTDXEft--
