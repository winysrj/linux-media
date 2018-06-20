Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44556 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbeFTLzI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:55:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 27/27] media: uvcvideo: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 14:55:23 +0300
Message-ID: <3925059.Md1u3KRT1n@avalon>
In-Reply-To: <20180620110105.19955-28-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de> <20180620110105.19955-28-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Thank you for the patch.

On Wednesday, 20 June 2018 14:01:05 EEST Sebastian Andrzej Siewior wrote:
> Using usb_fill_int_urb() helps to find code which initializes an
> URB. A grep for members of the struct (like ->complete) reveal lots
> of other things, too.
> usb_fill_int_urb() also checks bInterval to be in the 1=E2=80=A616 range =
on
> HS/SS.
>=20
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index a88b2e51a666..79e7a827ed44 1006=
44
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1619,21 +1619,19 @@ static int uvc_init_video_isoc(struct uvc_streami=
ng
> *stream, return -ENOMEM;
>  		}
>=20
> -		urb->dev =3D stream->dev->udev;
> -		urb->context =3D stream;
> -		urb->pipe =3D usb_rcvisocpipe(stream->dev->udev,
> -				ep->desc.bEndpointAddress);
> +		usb_fill_int_urb(urb, stream->dev->udev,
> +				 usb_rcvisocpipe(stream->dev->udev,
> +						 ep->desc.bEndpointAddress),
> +				 stream->urb_buffer[i], size,
> +				 uvc_video_complete, stream,
> +				 ep->desc.bInterval);

You're filling an isoc URB with usb_fill_int_urb(), which is explicitly=20
documented as usable to fill an interrupt URB. Shouldn't we create a=20
usb_fill_isoc_urb() function ? It could just be an alias for=20
usb_fill_int_urb() if isoc and interrupt URBs don't need to be treated=20
differently. Alternatively, I'd be fine using usb_fill_int_urb() if the=20
function documentation's was updated to mention isoc URBs as well.

>  #ifndef CONFIG_DMA_NONCOHERENT
>  		urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
>  		urb->transfer_dma =3D stream->urb_dma[i];
>  #else
>  		urb->transfer_flags =3D URB_ISO_ASAP;
>  #endif
> -		urb->interval =3D ep->desc.bInterval;

Unless I'm mistaken this introduces a change in behaviour for HS and SS, an=
d=20
should thus be documented in the commit message. I suspect that this is the=
=20
real reason for this patch. I'd thus update the subject line to describe th=
is=20
fix, and the body of the message to explain why using usb_fill_int_urb() is=
=20
the proper fix.

> -		urb->transfer_buffer =3D stream->urb_buffer[i];
> -		urb->complete =3D uvc_video_complete;
>  		urb->number_of_packets =3D npackets;
> -		urb->transfer_buffer_length =3D size;

usb_fill_int_urb() sets urb->start_frame to -1. Does that impact us in any =
way=20
?

>  		for (j =3D 0; j < npackets; ++j) {
>  			urb->iso_frame_desc[j].offset =3D j * psize;

=2D-=20
Regards,

Laurent Pinchart
