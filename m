Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58617 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaC1QDu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:03:50 -0400
Date: Fri, 28 Mar 2014 11:01:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: Re: [PATCH v2 2/3] usb: gadget: uvc: Set the V4L2 buffer field to
 V4L2_FIELD_NONE
Message-ID: <20140328160145.GJ17820@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1396022568-6794-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr/DzoowOgTDcSCF"
Content-Disposition: inline
In-Reply-To: <1396022568-6794-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--yr/DzoowOgTDcSCF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2014 at 05:02:47PM +0100, Laurent Pinchart wrote:
> The UVC gadget driver doesn't support interlaced video but left the
> buffer field uninitialized. Set it to V4L2_FIELD_NONE.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/uvc_queue.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queu=
e.c
> index 9ac4ffe1..305eb49 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -380,6 +380,7 @@ static struct uvc_buffer *uvc_queue_next_buffer(struc=
t uvc_video_queue *queue,
>  	else
>  		nextbuf =3D NULL;
> =20
> +	buf->buf.v4l2_buf.field =3D V4L2_FIELD_NONE;
>  	buf->buf.v4l2_buf.sequence =3D queue->sequence++;
>  	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
> =20
> --=20
> 1.8.3.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
balbi

--yr/DzoowOgTDcSCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNZzpAAoJEIaOsuA1yqREZTcP/2JBA074K+ShwG3f9UsjOq6C
1EOSAfK/xk7MDz0MGCKBRPS+q2HWUr4r8OgHfRLf9XA12WwMjP+4BXMLzIzeSq6m
n+1H3uJAET6Kw0aXK0Y3ssjMIAmW5RV52ZSrsAO4/4jVpiygNCOIiGJmqhmZHooY
eA9aUxFm5vEmycVRNZipreBts4gXdaUie3wDpWwrAmwyz2KGo2bYTG44rN6VE9pf
u9UUla3s2p0RbttieBMg5Xee5ALqZEc5/2BTa0VkwUxAfTqKIJlYoFaE7lojKJtO
ZzboUgqXRujoGMDRfmqgOkQkdTjtqHSI6Av9fuEnLaN6JsbeotekC3MaAJEV7bxU
fgMkRW/QVbSoV1NyU5+qXItP7CnlR0xAh7lGliZjQSGh1PATwBCDTPzdBCJhIwoy
YIcdY4rrA9K8gpWZuEv/VjVxBauF9xcWAbHIeOL1L+vFfIvGBwcCpdAiUrHCyxvz
xmoYkR1fJwkm1hx0hgcjMHNI6xJsETNpspd26hXUym+mofgwccmDYc2a2Y4h/7MC
Tz+agwAxda6sbATAkRoRT7L34/rv69AYHDmjvp8wrvb6NWRZiF1+4bIHYXpNRnMa
mGOnr+esKH0Sif6mwQuOEDmFWrp6Mf8S/J7qElUkjVjZUdHno3xfMbAOPW8xUVsw
GRRugaSPbHtFJlo6vdsO
=6ePW
-----END PGP SIGNATURE-----

--yr/DzoowOgTDcSCF--
