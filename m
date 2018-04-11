Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51843 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbeDKODI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 10:03:08 -0400
Message-ID: <7985c22782a0ab8bdbf0b8c0b7ca98a80ee77ddf.camel@bootlin.com>
Subject: Re: [RFCv11 PATCH 27/29] vim2m: support requests
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Wed, 11 Apr 2018 16:01:46 +0200
In-Reply-To: <20180409142026.19369-28-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
         <20180409142026.19369-28-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-qxQKOyLcvrefIEqo5pz4"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-qxQKOyLcvrefIEqo5pz4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-04-09 at 16:20 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> Add support for requests to vim2m.

Depending on where STREAMON happens in the sequence, there is a
possibility that v4l2_m2m_try_schedule is never called and thus that
device_run never runs when submitting the request.

More specifically, the m2m fashion of the STREAMON ioctl handler will
normally call v4l2_m2m_try_schedule. Hence, there is no issue if it's
called after submitting the request. On the other hand, if the request
was not submitted when calling STREAMON (which is a valid use case),
buffers are not available and v4l2_m2m_try_schedule won't schedule
anything. Once the request is submitted, the internal plumbing will
detect that STREAMON was requested but did not take effect, so it will
call vb2_streamon. And of course, vb2_streamon has no provision for
trying to schedule a m2m device run.

One way to fix this is to call v4l2_m2m_try_schedule from a workqueue
triggered in the driver's start_streaming qop. The same is also probably
necessary in buf_queue and buf_prepare since those qops are not called
from the m2m ioctl handler either.

What do you think?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/vim2m.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/drivers/media/platform/vim2m.c
> b/drivers/media/platform/vim2m.c
> index 9b18b32c255d..2dcf0ea85705 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -387,8 +387,26 @@ static void device_run(void *priv)
>  	src_buf =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>  	dst_buf =3D v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> =20
> +	/* Apply request if needed */
> +	if (src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +	if (dst_buf->vb2_buf.req_obj.req &&
> +	    dst_buf->vb2_buf.req_obj.req !=3D src_buf-
> >vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_setup(dst_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +
>  	device_process(ctx, src_buf, dst_buf);
> =20
> +	/* Complete request if needed */
> +	if (src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_complete(src_buf-
> >vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +	if (dst_buf->vb2_buf.req_obj.req &&
> +	    dst_buf->vb2_buf.req_obj.req !=3D src_buf-
> >vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_complete(dst_buf-
> >vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +
>  	/* Run a timer, which simulates a hardware irq  */
>  	schedule_irq(dev, ctx->transtime);
>  }
> @@ -823,6 +841,8 @@ static void vim2m_stop_streaming(struct vb2_queue
> *q)
>  			vbuf =3D v4l2_m2m_dst_buf_remove(ctx-
> >fh.m2m_ctx);
>  		if (vbuf =3D=3D NULL)
>  			return;
> +		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> +					   &ctx->hdl);
>  		spin_lock_irqsave(&ctx->dev->irqlock, flags);
>  		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>  		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
> @@ -1003,6 +1023,10 @@ static const struct v4l2_m2m_ops m2m_ops =3D {
>  	.job_abort	=3D job_abort,
>  };
> =20
> +static const struct media_device_ops m2m_media_ops =3D {
> +	.req_queue =3D vb2_request_queue,
> +};
> +
>  static int vim2m_probe(struct platform_device *pdev)
>  {
>  	struct vim2m_dev *dev;
> @@ -1027,6 +1051,7 @@ static int vim2m_probe(struct platform_device
> *pdev)
>  	dev->mdev.dev =3D &pdev->dev;
>  	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
>  	media_device_init(&dev->mdev);
> +	dev->mdev.ops =3D &m2m_media_ops;
>  	dev->v4l2_dev.mdev =3D &dev->mdev;
>  	dev->pad[0].flags =3D MEDIA_PAD_FL_SINK;
>  	dev->pad[1].flags =3D MEDIA_PAD_FL_SOURCE;
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-qxQKOyLcvrefIEqo5pz4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrOFUoACgkQ3cLmz3+f
v9GS0gf+OoZ2qZTv21sum5vY+poxZ/krJ4b/Bc6XQj4Z2jrarCYfgcl/M7B3y6ah
xzlWaezRogxbo+gzjjBqIX3tAVy6WjX1LB4fJeBTEvd3Xe86rkp6wi+vfGCaIape
C0fIgGyCJ+Jinz2I77BkiZQycQahLiXPd5nMWxVm4cNzD7d+BZFFi/fM7JmAmQva
Ru8K/IZ47lJqvsLCcuZDcfOgD2R879F6SsQvrAVVLKaIFIWJsbd7U2jOYJ0mQL11
S55+H8DKxsWElzKx2f+KCDTCOQST4a6W85k+CR1TPj9eN+uYY9r5bJkoKm0syk6G
aPbnZWI1f+9n7j5BDN83C3/A1M8uTw==
=W83j
-----END PGP SIGNATURE-----

--=-qxQKOyLcvrefIEqo5pz4--
