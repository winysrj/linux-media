Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37395 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaDQJUw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:20:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] vb2: Update buffer state flags after __vb2_dqbuf
Date: Thu, 17 Apr 2014 11:20:53 +0200
Message-ID: <2515793.GjYRvMgj81@avalon>
In-Reply-To: <1397676846.10347.11.camel@nicolas-tpx230>
References: <1397676846.10347.11.camel@nicolas-tpx230>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12156040.kAAMdRTHBf"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart12156040.kAAMdRTHBf
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Nicolas,

On Wednesday 16 April 2014 15:34:06 Nicolas Dufresne wrote:
> Previously we where updating the buffer state using __fill_v4l2_buffe=
r
> before the state transition was completed through __vb2_dqbuf. This
> would cause the V4L2_BUF_FLAG_DONE to be set, which would mean it sti=
ll
> queued. The spec says the dqbuf should clean the DONE flag, right not=
 it
> alway set it.
>=20
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

This looks fine to me, thanks for catching and fixing the problem.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index f9059bb..ac5026a 100=
644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1943,14 +1943,15 @@ static int vb2_internal_dqbuf(struct vb2_queu=
e *q,
> struct v4l2_buffer *b, bool n
>=20
>  =09call_vb_qop(vb, buf_finish, vb);
>=20
> -=09/* Fill buffer information for the userspace */
> -=09__fill_v4l2_buffer(vb, b);
>  =09/* Remove from videobuf queue */
>  =09list_del(&vb->queued_entry);
>  =09q->queued_count--;
>  =09/* go back to dequeued state */
>  =09__vb2_dqbuf(vb);
>=20
> +=09/* Fill buffer information for the userspace */
> +=09__fill_v4l2_buffer(vb, b);
> +
>  =09dprintk(1, "dqbuf of buffer %d, with state %d\n",
>  =09=09=09vb->v4l2_buf.index, vb->state);

=2D-=20
Regards,

Laurent Pinchart

--nextPart12156040.kAAMdRTHBf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTT5z1AAoJEIkPb2GL7hl1Re4H+wWbDinJvqt5ZMzArw5xP+O2
ab+lU1Pdge9j06pV8D8Cye7sKNTkytw+RCyut2EcL4msbhc9Ax++RY7LwKPwWHdD
5z4fsG6T77z6arRQSMcbWdYMzzHYEExnVk7xPwy6WgjOXXN0JEAS0WXFYtHG8qAl
c5Em2W6lxY5TZb1ZYtY9Irjx6B0Dh3oQkEJPwHrwy0vOp+ymOYvqRskKYlckSzmR
1PTjmKJl+rCrG7dJNChc9HcM8IzxFzQ7amG4MefKXW6HgOBG5QuRp+/pTj1fQWd7
dJSsYEXKIYLq1AuSI9O1UGVv6fxgHqi9/iDZfi450VB5GTkhwDsCU/Fy1Krc6X8=
=cQSR
-----END PGP SIGNATURE-----

--nextPart12156040.kAAMdRTHBf--

