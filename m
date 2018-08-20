Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40746 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeHTOxS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 10:53:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] uvcvideo: rename UVC_QUIRK_INFO to UVC_INFO_QUIRK
Date: Mon, 20 Aug 2018 14:38:55 +0300
Message-ID: <2296972.qjimPh87rg@avalon>
In-Reply-To: <0121adf26dc5df64a3955253795dc2e04610b1b5.camel@ndufresne.ca>
References: <alpine.DEB.2.20.1808031334440.13762@axis700.grange> <0121adf26dc5df64a3955253795dc2e04610b1b5.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Saturday, 4 August 2018 18:58:18 EEST Nicolas Dufresne wrote:
> Le vendredi 03 ao=FBt 2018 =E0 13:36 +0200, Guennadi Liakhovetski a =E9cr=
it :
> > This macro defines "information about quirks," not "quirks for
> > information."
>=20
> Does not sound better to me. It's "Quirk's information", vs
> "information about quirks". I prefer the first one. In term of C
> namespace the orignal is also better. So the name space is UVC_QUIRK,
> and the detail is INFO.
>=20
> If we where to apply your logic, you'd rename driver_info, into
> info_driver, because it's information about the driver.

The macro initializes an info structure with the .quirks field. We'll need =
a=20
similar macro that will set the .meta_format field, and I proposed naming i=
t=20
UVC_INFO_META, hence the rename of this macro.

The alternative would be to call the two macros UVC_QUIRK_INFO and=20
UVC_META_INFO, but I don't think that would be a good idea. All the macros=
=20
that initialize an info structure should start with the same UVC_INFO_ pref=
ix.

> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com
> >=20
> > ---
> >=20
> >  drivers/media/usb/uvc/uvc_driver.c | 18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c
> > index d46dc43..699984b 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -2344,7 +2344,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	.quirks =3D UVC_QUIRK_FORCE_Y8,
> > =20
> >  };
> >=20
> > -#define UVC_QUIRK_INFO(q) (kernel_ulong_t)&(struct
> > uvc_device_info){.quirks =3D q}
> > +#define UVC_INFO_QUIRK(q) (kernel_ulong_t)&(struct
> > uvc_device_info){.quirks =3D q}
> >=20
> >  /*
> > =20
> >   * The Logitech cameras listed below have their interface class set
> >=20
> > to
> > @@ -2453,7 +2453,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
> >  	  .bInterfaceSubClass	=3D 1,
> >  	  .bInterfaceProtocol	=3D 0,
> >=20
> > -	  .driver_info		=3D
> > UVC_QUIRK_INFO(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
> > +	  .driver_info		=3D
> > UVC_INFO_QUIRK(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
> >=20
> >  	/* Chicony CNF7129 (Asus EEE 100HE) */
> >  	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
> >  =09
> >  				| USB_DEVICE_ID_MATCH_INT_INFO,
> >=20
> > @@ -2462,7 +2462,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
> >  	  .bInterfaceSubClass	=3D 1,
> >  	  .bInterfaceProtocol	=3D 0,
> >=20
> > -	  .driver_info		=3D
> > UVC_QUIRK_INFO(UVC_QUIRK_RESTRICT_FRAME_RATE) },
> > +	  .driver_info		=3D
> > UVC_INFO_QUIRK(UVC_QUIRK_RESTRICT_FRAME_RATE) },
> >=20
> >  	/* Alcor Micro AU3820 (Future Boy PC USB Webcam) */
> >  	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
> >  =09
> >  				| USB_DEVICE_ID_MATCH_INT_INFO,
> >=20
> > @@ -2525,7 +2525,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
> >  	  .bInterfaceSubClass	=3D 1,
> >  	  .bInterfaceProtocol	=3D 0,
> >=20
> > -	  .driver_info		=3D
> > UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> > +	  .driver_info		=3D
> > UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
> >=20
> >  					| UVC_QUIRK_BUILTIN_ISIGHT) },
> >  =09
> >  	/* Apple Built-In iSight via iBridge */
> >  	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
> >=20
> > @@ -2607,7 +2607,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
> >  	  .bInterfaceSubClass	=3D 1,
> >  	  .bInterfaceProtocol	=3D 0,
> >=20
> > -	  .driver_info		=3D
> > UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> > +	  .driver_info		=3D
> > UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
> >=20
> >  					| UVC_QUIRK_PROBE_DEF) },
> >  =09
> >  	/* IMC Networks (Medion Akoya) */
> >  	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
> >=20
> > @@ -2707,7 +2707,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
> >  	  .bInterfaceSubClass	=3D 1,
> >  	  .bInterfaceProtocol	=3D 0,
> >=20
> > -	  .driver_info		=3D
> > UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> > +	  .driver_info		=3D
> > UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
> >=20
> >  					| UVC_QUIRK_PROBE_EXTRAFIELDS)
> >=20
> > },
> >=20
> >  	/* Aveo Technology USB 2.0 Camera (Tasco USB Microscope) */
> >  	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
> >=20
> > @@ -2725,7 +2725,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
> >  	  .bInterfaceSubClass	=3D 1,
> >  	  .bInterfaceProtocol	=3D 0,
> >=20
> > -	  .driver_info		=3D
> > UVC_QUIRK_INFO(UVC_QUIRK_PROBE_EXTRAFIELDS) },
> > +	  .driver_info		=3D
> > UVC_INFO_QUIRK(UVC_QUIRK_PROBE_EXTRAFIELDS) },
> >=20
> >  	/* Manta MM-353 Plako */
> >  	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
> >  =09
> >  				| USB_DEVICE_ID_MATCH_INT_INFO,
> >=20
> > @@ -2771,7 +2771,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
> >  	  .bInterfaceSubClass	=3D 1,
> >  	  .bInterfaceProtocol	=3D 0,
> >=20
> > -	  .driver_info		=3D
> > UVC_QUIRK_INFO(UVC_QUIRK_STATUS_INTERVAL) },
> > +	  .driver_info		=3D
> > UVC_INFO_QUIRK(UVC_QUIRK_STATUS_INTERVAL) },
> >=20
> >  	/* MSI StarCam 370i */
> >  	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
> >  =09
> >  				| USB_DEVICE_ID_MATCH_INT_INFO,
> >=20
> > @@ -2798,7 +2798,7 @@ static int uvc_clock_param_set(const char *val,
> > const struct kernel_param *kp)
> >=20
> >  	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
> >  	  .bInterfaceSubClass	=3D 1,
> >  	  .bInterfaceProtocol	=3D 0,
> >=20
> > -	  .driver_info		=3D
> > UVC_QUIRK_INFO(UVC_QUIRK_PROBE_MINMAX
> > +	  .driver_info		=3D
> > UVC_INFO_QUIRK(UVC_QUIRK_PROBE_MINMAX
> >=20
> > UVC_QUIRK_IGNORE_SELECTOR_UNIT) },
> >=20
> >  	/* Oculus VR Positional Tracker DK2 */
> >  	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE

=2D-=20
Regards,

Laurent Pinchart
