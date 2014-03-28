Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39763 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaC1QEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:04:12 -0400
Date: Fri, 28 Mar 2014 11:02:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: Re: [PATCH v2 3/3] usb: gadget: uvc: Set the vb2 queue timestamp
 flags
Message-ID: <20140328160209.GK17820@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1396022568-6794-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BFVE2HhgxTpCzM8t"
Content-Disposition: inline
In-Reply-To: <1396022568-6794-4-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--BFVE2HhgxTpCzM8t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2014 at 05:02:48PM +0100, Laurent Pinchart wrote:
> The vb2 queue timestamp_flags field must be set by drivers, as enforced
> by a WARN_ON in vb2_queue_init. The UVC gadget driver failed to do so.
> This resulted in the following warning.
>=20
> [    2.104371] g_webcam gadget: uvc_function_bind
> [    2.105567] ------------[ cut here ]------------
> [    2.105567] ------------[ cut here ]------------
> [    2.106779] WARNING: CPU: 0 PID: 1 at drivers/media/v4l2-core/videobuf=
2-core.c:2207 vb2_queue_init+0xa3/0x113()
>=20
> Fix it.
>=20
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/uvc_queue.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queu=
e.c
> index 305eb49..1c29bc9 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -137,6 +137,8 @@ static int uvc_queue_init(struct uvc_video_queue *que=
ue,
>  	queue->queue.buf_struct_size =3D sizeof(struct uvc_buffer);
>  	queue->queue.ops =3D &uvc_queue_qops;
>  	queue->queue.mem_ops =3D &vb2_vmalloc_memops;
> +	queue->queue.timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> +				     | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
>  	ret =3D vb2_queue_init(&queue->queue);
>  	if (ret)
>  		return ret;
> --=20
> 1.8.3.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
balbi

--BFVE2HhgxTpCzM8t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNZ0BAAoJEIaOsuA1yqREgREQAJaVKmZARUO9o5CQN7n71IHj
kOrkQldhhxfDDF72BbCZZiMKyqsHPFxqva6qMgHOdj0+Bnzcv1xbwFoVhSgK84a0
iYZZt5NnmGNY/VO2ghgFxIU0XCsNBWXriQZMGumOjpSCZ4bW8TmJcPg2735wuk1Y
xpnC4zzeSjcqyZB0+oAmxCxNky5HDRSSYPO0gqCMG37L0elUQSTbu0KDkbpHfgi5
kY3tnCSqMe2GVSMFjnM/ew/dzgEJeDXnCcj4nAfiwtXb0Qfivb4+JKF8MEh+9OEj
Qo3B6Gnkh+rA65CevEChNquLLhIz7mOXA0V4CUgrcNOXd/8R3N14Q+OUgCXalfcz
+qDZ4Xub/KDJgaMs3Vs42bFQnAr2ffSs781xBeq7bXna4Q/yAHHSwqpC8qpNQ1KL
5L0gsWNYfGhkkhGzQ4RvNqGTQviCy8T63zZrMR+kbCNv9XOtFCUHA9Jrh4L971ue
MtsNtRAO11jP8J4EjvbyqsRj4lN4rmZSVrLCjBOX9E6eSIoKgUnveHuGAr4wCTQC
S+kLzMx4rFBmkkhf5CnLdCwsrggcleKlagaU0sheQ2VmNZToW3prxcodww3ymgaG
fYuLqEYOETbW6E6ypFmGcpd2kCAjU8l2BB5CHYEECgmkn9B8c105qdw78CuPU3R9
W3dsTP+KHJnPwRqfVkIy
=Cy7r
-----END PGP SIGNATURE-----

--BFVE2HhgxTpCzM8t--
