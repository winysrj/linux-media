Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33460 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755976AbdLOVEs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 16:04:48 -0500
Received: by mail-qt0-f195.google.com with SMTP id e2so13750448qti.0
        for <linux-media@vger.kernel.org>; Fri, 15 Dec 2017 13:04:47 -0800 (PST)
Message-ID: <1513371884.3541.8.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 0/9] media: base request API support
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 15 Dec 2017 16:04:44 -0500
In-Reply-To: <20171215075625.27028-1-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-j/NCpvtJNNqRVfjUVq+K"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-j/NCpvtJNNqRVfjUVq+K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 15 d=C3=A9cembre 2017 =C3=A0 16:56 +0900, Alexandre Courbot a =
=C3=A9crit :
> Here is a new attempt at the request API, following the UAPI we agreed on=
 in
> Prague. Hopefully this can be used as the basis to move forward.
>=20
> This series only introduces the very basics of how requests work: allocat=
e a
> request, queue buffers to it, queue the request itself, wait for it to co=
mplete,
> reuse it. It does *not* yet use Hans' work with controls setting. I have
> preferred to submit it this way for now as it allows us to concentrate on=
 the
> basic request/buffer flow, which was harder to get properly than I initia=
lly
> thought. I still have a gut feeling that it can be improved, with less ba=
ck-and-
> forth into drivers.
>=20
> Plugging in controls support should not be too hard a task (basically jus=
t apply
> the saved controls when the request starts), and I am looking at it now.
>=20
> The resulting vim2m driver can be successfully used with requests, and my=
 tests
> so far have been successful.
>=20
> There are still some rougher edges:
>=20
> * locking is currently quite coarse-grained
> * too many #ifdef CONFIG_MEDIA_CONTROLLER in the code, as the request API
>   depends on it - I plan to craft the headers so that it becomes unnecess=
ary.
>   As it is, some of the code will probably not even compile if
>   CONFIG_MEDIA_CONTROLLER is not set

Would it be possible to explain why this relation between request and
the media controller ? Why couldn't request be created from video
devices ?

>=20
> But all in all I think the request flow should be clear and easy to revie=
w, and
> the possibility of custom queue and entity support implementations should=
 give
> us the flexibility we need to support more specific use-cases (I expect t=
he
> generic implementations to be sufficient most of the time though).
>=20
> A very simple test program exercising this API is available here (don't f=
orget
> to adapt the /dev/media0 hardcoding):
> https://gist.github.com/Gnurou/dbc3776ed97ea7d4ce6041ea15eb0438
>=20
> Looking forward to your feedback and comments!
>=20
> Alexandre Courbot (8):
>   media: add request API core and UAPI
>   media: request: add generic queue
>   media: request: add generic entity ops
>   media: vb2: add support for requests
>   media: vb2: add support for requests in QBUF ioctl
>   media: v4l2-mem2mem: add request support
>   media: vim2m: add media device
>   media: vim2m: add request support
>=20
> Hans Verkuil (1):
>   videodev2.h: Add request field to v4l2_buffer
>=20
>  drivers/media/Makefile                        |   4 +-
>  drivers/media/media-device.c                  |   6 +
>  drivers/media/media-request-entity-generic.c  |  56 ++++
>  drivers/media/media-request-queue-generic.c   | 150 ++++++++++
>  drivers/media/media-request.c                 | 390 ++++++++++++++++++++=
++++++
>  drivers/media/platform/vim2m.c                |  46 +++
>  drivers/media/usb/cpia2/cpia2_v4l.c           |   2 +-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   7 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c          |  99 ++++++-
>  drivers/media/v4l2-core/v4l2-mem2mem.c        |  34 +++
>  drivers/media/v4l2-core/videobuf2-core.c      |  59 +++-
>  drivers/media/v4l2-core/videobuf2-v4l2.c      |  32 ++-
>  include/media/media-device.h                  |   3 +
>  include/media/media-entity.h                  |   6 +
>  include/media/media-request.h                 | 282 +++++++++++++++++++
>  include/media/v4l2-mem2mem.h                  |  19 ++
>  include/media/videobuf2-core.h                |  25 +-
>  include/media/videobuf2-v4l2.h                |   2 +
>  include/uapi/linux/media.h                    |  11 +
>  include/uapi/linux/videodev2.h                |   3 +-
>  20 files changed, 1216 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/media/media-request-entity-generic.c
>  create mode 100644 drivers/media/media-request-queue-generic.c
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request.h
>=20
--=-j/NCpvtJNNqRVfjUVq+K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWjQ47AAKCRBxUwItrAao
HAL5AKDWN6q7LabzB3Mzcru7kWKJbMWUeACgzUbFt9fA6si+fdDn6420KgpYKjk=
=MRzW
-----END PGP SIGNATURE-----

--=-j/NCpvtJNNqRVfjUVq+K--
