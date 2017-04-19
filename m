Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40004 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968108AbdDSVll (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 17:41:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter =?ISO-8859-1?Q?Bostr=F6m?= <pbos@google.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4] [media] uvcvideo: Add iFunction or iInterface to device names.
Date: Thu, 20 Apr 2017 00:42:42 +0300
Message-ID: <4928224.bcUm3SHKWn@avalon>
In-Reply-To: <20170419204527.113504-1-pbos@google.com>
References: <20170419204527.113504-1-pbos@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Thank you for the patch.

On Wednesday 19 Apr 2017 16:45:27 Peter Bostr=F6m wrote:
> Permits distinguishing between two /dev/videoX entries from the same
> physical UVC device (that naturally share the same iProduct name).
>=20
> This change matches current Windows behavior by prioritizing iFunctio=
n
> over iInterface, but unlike Windows it displays both iProduct and
> iFunction/iInterface strings when both are available.
>=20
> Signed-off-by: Peter Bostr=F6m <pbos@google.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 04bf35063c4c..ae22fcf0a529=

> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1998,6 +1998,7 @@ static int uvc_probe(struct usb_interface *intf=
,
>  {
>  =09struct usb_device *udev =3D interface_to_usbdev(intf);
>  =09struct uvc_device *dev;
> +=09int function;
>  =09int ret;
>=20
>  =09if (id->idVendor && id->idProduct)
> @@ -2029,9 +2030,26 @@ static int uvc_probe(struct usb_interface *int=
f,
>  =09=09strlcpy(dev->name, udev->product, sizeof dev->name);
>  =09else
>  =09=09snprintf(dev->name, sizeof dev->name,
> -=09=09=09"UVC Camera (%04x:%04x)",
> -=09=09=09le16_to_cpu(udev->descriptor.idVendor),
> -=09=09=09le16_to_cpu(udev->descriptor.idProduct));
> +=09=09=09 "UVC Camera (%04x:%04x)",
> +=09=09=09 le16_to_cpu(udev->descriptor.idVendor),
> +=09=09=09 le16_to_cpu(udev->descriptor.idProduct));
> +
> +=09/*
> +=09 * Add iFunction or iInterface to names when available as additio=
nal
> +=09 * distinguishers between interfaces. iFunction is prioritized ov=
er
> +=09 * iInterface which matches Windows behavior at the point of writ=
ing.
> +=09 */
> +=09function =3D intf->cur_altsetting->desc.iInterface;
> +=09if (intf->intf_assoc && intf->intf_assoc->iFunction !=3D 0)
> +=09=09function =3D intf->intf_assoc->iFunction;

Nitpicking, I'd prefer writing this as

=09if (intf->intf_assoc && intf->intf_assoc->iFunction !=3D 0)
=09=09function =3D intf->intf_assoc->iFunction;
=09else
=09=09function =3D intf->cur_altsetting->desc.iInterface;

to clearly show what is the preferred case and what is the fallback. I'=
ll fix=20
that when applying, no need to resubmit the patch.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +=09if (function !=3D 0) {
> +=09=09size_t len;
> +
> +=09=09strlcat(dev->name, ": ", sizeof(dev->name));
> +=09=09len =3D strlen(dev->name);
> +=09=09usb_string(udev, function, dev->name + len,
> +=09=09=09   sizeof(dev->name) - len);
> +=09}
>=20
>  =09/* Parse the Video Class control descriptor. */
>  =09if (uvc_parse_control(dev) < 0) {

--=20
Regards,

Laurent Pinchart
