Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45526 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752798AbeFTOOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 10:14:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 27/27] media: uvcvideo: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 17:14:53 +0300
Message-ID: <18211658.4PQ3SEps0f@avalon>
In-Reply-To: <20180620132144.5cdu2ydlqre4ijg6@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de> <3925059.Md1u3KRT1n@avalon> <20180620132144.5cdu2ydlqre4ijg6@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

On Wednesday, 20 June 2018 16:21:44 EEST Sebastian Andrzej Siewior wrote:
> On 2018-06-20 14:55:23 [+0300], Laurent Pinchart wrote:
> > Hi Sebastian,
>=20
> Hi Laurent,
>=20
> > Thank you for the patch.
> >=20
> > On Wednesday, 20 June 2018 14:01:05 EEST Sebastian Andrzej Siewior wrot=
e:
> > > Using usb_fill_int_urb() helps to find code which initializes an
> > > URB. A grep for members of the struct (like ->complete) reveal lots
> > > of other things, too.
> > > usb_fill_int_urb() also checks bInterval to be in the 1=E2=80=A616 ra=
nge on
> > > HS/SS.
> > >=20
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > ---
> > >=20
> > >  drivers/media/usb/uvc/uvc_video.c | 14 ++++++--------
> > >  1 file changed, 6 insertions(+), 8 deletions(-)
> > >=20
> > > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > > b/drivers/media/usb/uvc/uvc_video.c index a88b2e51a666..79e7a827ed44
> > > 100644
> > > --- a/drivers/media/usb/uvc/uvc_video.c
> > > +++ b/drivers/media/usb/uvc/uvc_video.c
> > > @@ -1619,21 +1619,19 @@ static int uvc_init_video_isoc(struct
> > > uvc_streaming *stream,
> > >  			return -ENOMEM;
> > >  		}
> > >=20
> > > -		urb->dev =3D stream->dev->udev;
> > > -		urb->context =3D stream;
> > > -		urb->pipe =3D usb_rcvisocpipe(stream->dev->udev,
> > > -				ep->desc.bEndpointAddress);
> > > +		usb_fill_int_urb(urb, stream->dev->udev,
> > > +				 usb_rcvisocpipe(stream->dev->udev,
> > > +						 ep->desc.bEndpointAddress),
> > > +				 stream->urb_buffer[i], size,
> > > +				 uvc_video_complete, stream,
> > > +				 ep->desc.bInterval);
> >=20
> > You're filling an isoc URB with usb_fill_int_urb(), which is explicitly
> > documented as usable to fill an interrupt URB. Shouldn't we create a
> > usb_fill_isoc_urb() function ? It could just be an alias for
> > usb_fill_int_urb() if isoc and interrupt URBs don't need to be treated
> > differently. Alternatively, I'd be fine using usb_fill_int_urb() if the
> > function documentation's was updated to mention isoc URBs as well.
>=20
> I thought I read it there but I couldn't find it. And then I found it in
>=20
> Documentation/driver-api/usb/URB.rst:
> | you specify. You can use the :c:func:`usb_fill_int_urb` macro to fill
> | most ISO transfer fields.
>=20
> So you simply asking that the kerneldoc of usb_fill_int_urb() is
> extended to mention isoc, too?

That would be nice I think.

> > >  #ifndef CONFIG_DMA_NONCOHERENT
> > >  		urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
> > >  		urb->transfer_dma =3D stream->urb_dma[i];
> > >  #else
> > > =20
> > >  #endif
> > > -		urb->interval =3D ep->desc.bInterval;
> >=20
> > Unless I'm mistaken this introduces a change in behaviour for HS and SS,
> > and should thus be documented in the commit message.
>=20
> I did:
> | usb_fill_int_urb() also checks bInterval to be in the 1=E2=80=A616 rang=
e on
> | HS/SS.
>=20
> so this wasn't enough?

This sounds to me like a sanity check, while the patch effectively changes =
the=20
code as follows for HS and SS:

=2D		urb->interval =3D ep->desc.bInterval;
+		urb->interval =3D 1 << (ep->desc.bInterval - 1);

I believe the change is correct, although it would be nice if you could=20
double-check, as the documentation of the function states:

 * @interval: what to set the urb interval to, encoded like
 *      the endpoint descriptor's bInterval value.

> > I suspect that this is the real reason for this patch. I'd thus update =
the
> > subject line to describe this fix, and the body of the message to expla=
in
> > why using usb_fill_int_urb() is the proper fix.
>=20
> Actually no. I was looking for all the ->complete handlers and most of
> them used usb_fill_=E2=80=A6 except a few. And while moving to the functi=
on I
> was checking if everything stays the same (and mentioned ->interval
> since ->start_frame is documented as a return parameter).
>=20
> So here you are asking for a description update which explicit says
> bug-fix?

I'd like that, as it seems to be a bugfix, not just a code cleanup without =
any=20
behavioural change.

> > > -		urb->transfer_buffer =3D stream->urb_buffer[i];
> > > -		urb->complete =3D uvc_video_complete;
> > >=20
> > >  		urb->number_of_packets =3D npackets;
> > >=20
> > > -		urb->transfer_buffer_length =3D size;
> >=20
> > usb_fill_int_urb() sets urb->start_frame to -1. Does that impact us in =
any
> > way ?
>=20
> It should not. The documentation says:
> |  * @start_frame: Returns the initial frame for isochronous transfers.

Thanks for checking.

> > >  		for (j =3D 0; j < npackets; ++j) {
> > >  	=09
> > >  			urb->iso_frame_desc[j].offset =3D j * psize;

=2D-=20
Regards,

Laurent Pinchart
