Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44108 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933955AbeCGQv0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 11:51:26 -0500
Message-ID: <1520441424.1092.25.camel@bootlin.com>
Subject: Re: [RFCv4,13/21] media: videobuf2-v4l2: support for requests
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Date: Wed, 07 Mar 2018 17:50:24 +0100
In-Reply-To: <20180220044425.169493-14-acourbot@chromium.org>
References: <20180220044425.169493-14-acourbot@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-h1q3yGSgdWOpu6oM+3qZ"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-h1q3yGSgdWOpu6oM+3qZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-02-20 at 13:44 +0900, Alexandre Courbot wrote:
> Add a new vb2_qbuf_request() (a request-aware version of vb2_qbuf())
> that request-aware drivers can call to queue a buffer into a request
> instead of directly into the vb2 queue if relevent.
>=20
> This function expects that drivers invoking it are using instances of
> v4l2_request_entity and v4l2_request_entity_data to describe their
> entity and entity data respectively.
>=20
> Also add the vb2_request_submit() helper function which drivers can
> invoke in order to queue all the buffers previously queued into a
> request into the regular vb2 queue.

See a comment/proposal below about an issue I encountered when using
multi-planar formats.

> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 129
> +++++++++++++++++-
>  include/media/videobuf2-v4l2.h                |  59 ++++++++
>  2 files changed, 187 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 6d4d184aa68e..0627c3339572 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c

[...]

> +#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
> +int vb2_qbuf_request(struct vb2_queue *q, struct v4l2_buffer *b,
> +		     struct media_request_entity *entity)
> +{
> +	struct v4l2_request_entity_data *data;
> +	struct v4l2_vb2_request_buffer *qb;
> +	struct media_request *req;
> +	struct vb2_buffer *vb;
> +	int ret =3D 0;
> +
> +	if (b->request_fd <=3D 0)
> +		return vb2_qbuf(q, b);
> +
> +	if (!q->allow_requests)
> +		return -EINVAL;
> +
> +	req =3D media_request_get_from_fd(b->request_fd);
> +	if (!req)
> +		return -EINVAL;
> +
> +	data =3D to_v4l2_entity_data(media_request_get_entity_data(req,
> entity));
> +	if (IS_ERR(data)) {
> +		ret =3D PTR_ERR(data);
> +		goto out;
> +	}
> +
> +	mutex_lock(&req->lock);
> +
> +	if (req->state !=3D MEDIA_REQUEST_STATE_IDLE) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	ret =3D vb2_queue_or_prepare_buf(q, b, "qbuf");
> +	if (ret)
> +		goto out;
> +
> +	vb =3D q->bufs[b->index];
> +	switch (vb->state) {
> +	case VB2_BUF_STATE_DEQUEUED:
> +		break;
> +	case VB2_BUF_STATE_PREPARED:
> +		break;
> +	case VB2_BUF_STATE_PREPARING:
> +		dprintk(1, "buffer still being prepared\n");
> +		ret =3D -EINVAL;
> +		goto out;
> +	default:
> +		dprintk(1, "invalid buffer state %d\n", vb->state);
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	/* do we already have a buffer for this request in the queue?
> */
> +	list_for_each_entry(qb, &data->queued_buffers, node) {
> +		if (qb->queue =3D=3D q) {
> +			ret =3D -EBUSY;
> +			goto out;
> +		}
> +	}
> +
> +	qb =3D kzalloc(sizeof(*qb), GFP_KERNEL);
> +	if (!qb) {
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	/*
> +	 * TODO should be prepare the buffer here if needed, to
> report errors
> +	 * early?
> +	 */
> +	qb->pre_req_state =3D vb->state;
> +	qb->queue =3D q;
> +	memcpy(&qb->v4l2_buf, b, sizeof(*b));

I am getting data corruption on qb->v4l2_buf.m.planes from this when
using planar buffers, only after exiting the ioctl handler (i.e. when
accessing this buffer later from the queue).

I initially thought this was because the planes pointer was copied as-is=
=20
from userspace, but Maxime Ripard suggested that this would have
automatically triggered a visible fault in the kernel.

Thus, my best guess is that the data is properly copied from userspace
but freed when leaving the ioctl handler, which doesn't work our with
the request API.

A dirty fix that I came up with consists in re-allocating the planes
buffer here and copying its contents from "b", so that it can live
beyond the ioctl call.

I am not too sure whether this should be fixed here or in the part of
the v4l2 common code that frees this data. What do you think?

Cheers!

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-h1q3yGSgdWOpu6oM+3qZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqgGFAACgkQ3cLmz3+f
v9H32gf+LN5xXtYIVPuQZAYOR6pf/9murfObKJFco8ChzvzGjXC9+YdvqotP54u3
S4BNV/YFaSx9A6qCkiKarjIV9TQ8lAkqtDYd7RrsHEnKthPX8plZgN4sCUjVEpfA
t93wB+kdTQOHZa8GeBLKTIR9J5eV9APNI8Gjz42AmzYOIuCm0MtN/DAGjDefGO+K
5l65Rtolcj3JavRnLHGe5KpGXusuiXzYd2Tuh733LCKabRq2ANXwgecfdAsn7uqo
5V+H54tgRD3uBZXc/+vnWvJHQ13wIetU6t+As+Q6VkioOSsFJhueL5NOanMzwn99
W3Xm6atM7ezcHgkYWOGwPDULaYGxEA==
=/MVj
-----END PGP SIGNATURE-----

--=-h1q3yGSgdWOpu6oM+3qZ--
