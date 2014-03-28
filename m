Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39728 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaC1QDn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:03:43 -0400
Date: Fri, 28 Mar 2014 11:01:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: Re: [PATCH v2 1/3] usb: gadget: uvc: Switch to monotonic clock for
 buffer timestamps
Message-ID: <20140328160131.GI17820@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1396022568-6794-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3U8TY7m7wOx7RL1F"
Content-Disposition: inline
In-Reply-To: <1396022568-6794-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--3U8TY7m7wOx7RL1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2014 at 05:02:46PM +0100, Laurent Pinchart wrote:
> The wall time clock isn't useful for applications as it can jump around
> due to time adjustement. Switch to the monotonic clock.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/uvc_queue.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>=20
> Changes since v1:
>=20
> - Replace ktime_get_ts() with v4l2_get_timestamp()
>=20
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queu=
e.c
> index 0bb5d50..9ac4ffe1 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -20,6 +20,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/wait.h>
> =20
> +#include <media/v4l2-common.h>
>  #include <media/videobuf2-vmalloc.h>
> =20
>  #include "uvc.h"
> @@ -379,14 +380,8 @@ static struct uvc_buffer *uvc_queue_next_buffer(stru=
ct uvc_video_queue *queue,
>  	else
>  		nextbuf =3D NULL;
> =20
> -	/*
> -	 * FIXME: with videobuf2, the sequence number or timestamp fields
> -	 * are valid only for video capture devices and the UVC gadget usually
> -	 * is a video output device. Keeping these until the specs are clear on
> -	 * this aspect.
> -	 */
>  	buf->buf.v4l2_buf.sequence =3D queue->sequence++;
> -	do_gettimeofday(&buf->buf.v4l2_buf.timestamp);
> +	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
> =20
>  	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
>  	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
> --=20
> 1.8.3.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
balbi

--3U8TY7m7wOx7RL1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNZzbAAoJEIaOsuA1yqREinIQALQ5V+Q4kr+LEVP776QKvat6
DG5GbAk7JKwDxX2O+THqRfzq1UZZoRIWWhXhGE12eGjjyinADNxrFkw7aQNyFbu5
BHYqrqeSLE8qRi5T3TK5SOPiF/+hu49/JvZkasVDkDNu8NOsp2jOhLnnWaqKzmdg
JnrwNeKHBMWBmPbg8MNu5RbWHCanT7YfJUuAn021cv0ZrLWfH7s5621dQ9uQkkCC
PX51SgyuQ8bZGtZ70ZHX6wfxRaDR7Q/cPWmBrUCQbnx34C4aUr5L+k10+kKXgl9y
wTzSpIlt302aAYir/qId6WeDzh/Q+0VKl8ICcMvHpmqtkRAA0vOMjKKohSBav8cs
nJLkqGppmvdf4SzvRwFfXyVPsETaAlDcOaxSB5iXrA2WkcNotn9mOcobaaBOdihx
8/6tzw20sZc2yGy9DKNGHuFi1NhDN+ORwIFn8NRktzWnbE1E0lOGLTg3m24SHZky
0z5Jgs6bOXHVEezVDoC95SRspU0EDsGnNSz8QtLUFSgNQfzD58jbpQAalKjvmgr9
ezUT4M620j4vQci3g5WdLVY3ccQJGhCpD2/yOd0N74TPaWn51HL1AYA8P1lu9uoC
RH7/NeMNFaVgHj6tCwzoUUW9CTRELCANJCMn/puels+CcW+39Jx+xj+x6IuywrAn
TBG2lk5yyjfTDkhSaAw0
=8Ibd
-----END PGP SIGNATURE-----

--3U8TY7m7wOx7RL1F--
