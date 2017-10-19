Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49811 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752857AbdJSMDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 08:03:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Yang <hansy@nvidia.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] [media] uvcvideo: zero seq number when disabling stream
Date: Thu, 19 Oct 2017 15:03:34 +0300
Message-ID: <4325498.0x3d1FfxvC@avalon>
In-Reply-To: <4037e7e9-e017-e096-8020-94395260655b@nvidia.com>
References: <1505456871-12680-1-git-send-email-hansy@nvidia.com> <alpine.DEB.2.20.1710181042550.11231@axis700.grange> <4037e7e9-e017-e096-8020-94395260655b@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday, 19 October 2017 10:23:06 EEST Hans Yang wrote:
> On 2017=E5=B9=B410=E6=9C=8818=E6=97=A5 16:52, Guennadi Liakhovetski wrote:
> > On Mon, 16 Oct 2017, Laurent Pinchart wrote:
> >>=20
> >> On Friday, 15 September 2017 09:27:51 EEST Hans Yang wrote:
> >>> For bulk-based devices, when disabling the video stream,
> >>> in addition to issue CLEAR_FEATURE(HALT), it is better to set
> >>> alternate setting 0 as well or the sequnce number in host
> >>> side will probably not reset to zero.
> >>=20
> >> The USB 2.0 specificatin states in the description of the SET_INTERFACE
> >> request that "If a device only supports a default setting for the
> >> specified interface, then a STALL may be returned in the Status stage =
of
> >> the request".
> >>=20
> >> The Linux implementation of usb_set_interface() deals with this by
> >> handling STALL conditions and manually clearing HALT for all endpoints=
 in
> >> the interface, but I'm still concerned that this change could break
> >> existing bulk- based cameras. Do you know what other operating systems=
 do
> >> when disabling the stream on bulk cameras ? According to a comment in =
the
> >> driver Windows calls CLEAR_FEATURE(HALT), but the situation might have
> >> changed since that was tested.
>=20
> Sorry I did not mention that it is about SS bulk-based cameras using
> sequence number technique.
>  From my observations, invoking usb_clear_halt() will reset the endpoint
> in the device side via CLEAR_FEATURE(HALT)
> and reset the sequence number as well; however usb_reset_endpoint() does
> not reset the host side endpoint with xhci driver,
> then the sequence number will mismatch in next time stream enable.
> I can always observe this through a bus analyzer on Linux implementation
> whatever X86 or ARM based.
> This is not observed on the Windows.

According to the USB 3.0 specification, section 9.4.5 ("Get Status"),

"Regardless of whether an endpoint has the Halt feature set, a=20
ClearFeature(ENDPOINT_HALT) request always results in the data sequence bei=
ng=20
reinitialized to zero, and if Streams are enabled, the Stream State Machine=
=20
shall be reinitialized to the Disabled state."

If Linux doesn't reset the sequence number when issuing a CLEAR_FEATURE(HAL=
T),=20
isn't it a Linux USB stack bug that should be fixed in the USB core ?

> >> Guennadi, how do your bulk-based cameras handle this ?
> >=20
> > I don't know what design decisions are implemented there, but I tested a
> > couple of cameras for sending a STREAMOFF after a few captured buffers,
> > sleeping for a couple of seconds, requeuing buffers, sending STREAMON a=
nd
> > capturing a few more - that seems to have worked. "Seems" because I only
> > used a modified version of capture-example, I haven't checked buffer
> > contents.
> >=20
> > BTW, Hans, may I ask - what cameras did you use?
>=20
> I have three SS bulk-based cameras as follows:
> e-con Systems See3CAM_CU130 (2560:c1d0)
> Leopard ZED (2b03:f580)
> Intel(R) RealSense(TM) Camera SR300 (8086:0aa5)
>=20
> I can observe the same issue on all above;
> besides, to reproduce issue do not let the camera enter suspend because
> it will *help* to reset the sequence number through usb_set_interface(0).
>=20
> >>> Then in next time video stream start, the device will expect
> >>> host starts packet from 0 sequence number but host actually
> >>> continue the sequence number from last transaction and this
> >>> causes transaction errors.
> >>=20
> >> Do you mean the DATA0/DATA1 toggle ? Why does the host continue toggli=
ng
> >> the PID from the last transation ? The usb_clear_halt() function calls
> >> usb_reset_endpoint() which should reset the DATA PID toggle.
> >>=20
> >>> This commit fixes this by adding set alternate setting 0 back
> >>> as what isoch-based devices do.
> >>>=20
> >>> Below error message will also be eliminated for some devices:
> >>> uvcvideo: Non-zero status (-71) in video completion handler.
> >>>=20
> >>> Signed-off-by: Hans Yang <hansy@nvidia.com>
> >>> ---
> >>>=20
> >>>   drivers/media/usb/uvc/uvc_video.c | 5 ++---
> >>>   1 file changed, 2 insertions(+), 3 deletions(-)
> >>>=20
> >>> diff --git a/drivers/media/usb/uvc/uvc_video.c
> >>> b/drivers/media/usb/uvc/uvc_video.c index fb86d6af398d..ad80c2a6da6a
> >>> 100644
> >>> --- a/drivers/media/usb/uvc/uvc_video.c
> >>> +++ b/drivers/media/usb/uvc/uvc_video.c
> >>> @@ -1862,10 +1862,9 @@ int uvc_video_enable(struct uvc_streaming
> >>> *stream, int enable)
> >>>=20
> >>>   	if (!enable) {
> >>>   		uvc_uninit_video(stream, 1);
> >>> -		if (stream->intf->num_altsetting > 1) {
> >>> -			usb_set_interface(stream->dev->udev,
> >>> +		usb_set_interface(stream->dev->udev,
> >>>   					  stream->intfnum, 0);
> >>> -		} else {
> >>> +		if (stream->intf->num_altsetting =3D=3D 1) {
> >>>   			/* UVC doesn't specify how to inform a bulk-based device
> >>>   			 * when the video stream is stopped. Windows sends a
> >>>   			 * CLEAR_FEATURE(HALT) request to the video streaming

=2D-=20
Regards,

Laurent Pinchart
