Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50656 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbcEIMyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2016 08:54:16 -0400
Message-ID: <1462798448.9635.2.camel@ndufresne.ca>
Subject: Re: [RESEND PATCH] [media] s5p-mfc: don't close instance after free
 OUTPUT buffers
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	ayaka <ayaka@soulik.info>, Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date: Mon, 09 May 2016 08:54:08 -0400
In-Reply-To: <1462572682-5195-1-git-send-email-javier@osg.samsung.com>
References: <1462572682-5195-1-git-send-email-javier@osg.samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-I0Ge8qvyxu/dV7i0e+qd"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-I0Ge8qvyxu/dV7i0e+qd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 06 mai 2016 =C3=A0 18:11 -0400, Javier Martinez Canillas a
=C3=A9crit=C2=A0:
> From: ayaka <ayaka@soulik.info>
>=20
> User-space applications can use the VIDIOC_REQBUFS ioctl to determine
> if a
> memory mapped, user pointer or DMABUF based I/O is supported by the
> driver.
>=20
> So a set of VIDIOC_REQBUFS ioctl calls will be made with count 0 and
> then
> the real VIDIOC_REQBUFS call with count =3D=3D n. But for count 0, the
> driver
> not only frees the buffer but also closes the MFC instance and
> s5p_mfc_ctx
> state is set to MFCINST_FREE.
>=20
> The VIDIOC_REQBUFS handler for the output device checks if the
> s5p_mfc_ctx
> state is set to MFCINST_INIT (which happens on an VIDIOC_S_FMT) and
> fails
> otherwise. So after a VIDIOC_REQBUFS(n), future VIDIOC_REQBUFS(n)
> calls
> will fails unless a VIDIOC_S_FMT ioctl calls happens before the
> reqbufs.
>=20
> But applications may first set the format and then attempt to
> determine
> the I/O methods supported by the driver (for example Gstramer does
> it) so
> the state won't be set to MFCINST_INIT again and VIDIOC_REQBUFS will
> fail.
>=20
> To avoid this issue, only free the buffers on VIDIOC_REQBUFS(0) but
> don't
> close the MFC instance to allow future VIDIOC_REQBUFS(n) calls to
> succeed.
>=20
> Signed-off-by: ayaka <ayaka@soulik.info>
> [javier: Rewrote changelog to explain the problem more detailed]
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

I just tested this change, it also seems correct.

Acked-by: Nicolas Dufresne <nicolas@collabora.com>

>=20
> ---
> Hello,
>=20
> This is a resend of a patch posted by Ayaka some time ago [0].
> Without $SUBJECT, trying to decode a video using Gstramer fails
> on an Exynos5422 Odroid XU4 board with following error message:
>=20
> $ gst-launch-1.0 filesrc location=3Dtest.mov ! qtdemux ! h264parse !
> v4l2video0dec ! videoconvert ! autovideosink
>=20
> Setting pipeline to PAUSED ...
> Pipeline is PREROLLING ...
> [ 3947.114756] vidioc_reqbufs:576: Only V4L2_MEMORY_MAP is supported
> [ 3947.114771] vidioc_reqbufs:576: Only V4L2_MEMORY_MAP is supported
> [ 3947.114903] reqbufs_output:484: Reqbufs called in an invalid state
> [ 3947.114913] reqbufs_output:510: Failed allocating buffers for
> OUTPUT queue
> ERROR: from element
> /GstPipeline:pipeline0/v4l2video0dec:v4l2video0dec0: Failed to
> allocate required memory.
> Additional debug info:
> gstv4l2videodec.c(575): gst_v4l2_video_dec_handle_frame ():
> /GstPipeline:pipeline0/v4l2video0dec:v4l2video0dec0:
> Buffer pool activation failed
> ERROR: pipeline doesn't want to preroll.
> Setting pipeline to NULL ...
> Freeing pipeline ...
>=20
> [0]: https://patchwork.linuxtv.org/patch/32794/
>=20
> Best regards,
> Javier
>=20
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 1 -
> =C2=A01 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index f2d6376ce618..8b9467de2d6a 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -474,7 +474,6 @@ static int reqbufs_output(struct s5p_mfc_dev
> *dev, struct s5p_mfc_ctx *ctx,
> =C2=A0		ret =3D vb2_reqbufs(&ctx->vq_src, reqbufs);
> =C2=A0		if (ret)
> =C2=A0			goto out;
> -		s5p_mfc_close_mfc_inst(dev, ctx);
> =C2=A0		ctx->src_bufs_cnt =3D 0;
> =C2=A0		ctx->output_state =3D QUEUE_FREE;
> =C2=A0	} else if (ctx->output_state =3D=3D QUEUE_FREE) {
--=-I0Ge8qvyxu/dV7i0e+qd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlcwiHAACgkQcVMCLawGqBz4EgCgzAP9siAE8IwhRrBJhj8FtOvZ
RVkAniZCN51vAP8vX4bpK8czv+jVmLpj
=I5hn
-----END PGP SIGNATURE-----

--=-I0Ge8qvyxu/dV7i0e+qd--

