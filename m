Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48414 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754857AbdDQVzz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 17:55:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter =?ISO-8859-1?Q?Bostr=F6m?= <pbos@google.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: Add iFunction or iInterface to device names.
Date: Tue, 18 Apr 2017 00:56:53 +0300
Message-ID: <2802801.qUPbLntPTP@avalon>
In-Reply-To: <20170406175825.90406-1-pbos@google.com>
References: <20170406175825.90406-1-pbos@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Thank you for the patch.

On Thursday 06 April 2017 13:58:25 Peter Bostr=F6m wrote:
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
>  drivers/media/usb/uvc/uvc_driver.c | 43 ++++++++++++++++++++++++++++=
-------
>  drivers/media/usb/uvc/uvcvideo.h   |  4 +++-
>  2 files changed, 39 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 04bf35063c4c..66adf8a77e56=

> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1998,6 +1998,8 @@ static int uvc_probe(struct usb_interface *intf=
,
>  {
>  =09struct usb_device *udev =3D interface_to_usbdev(intf);
>  =09struct uvc_device *dev;
> +=09char additional_name_buf[UVC_DEVICE_NAME_SIZE];
> +=09const char *additional_name =3D NULL;
>  =09int ret;
>=20
>  =09if (id->idVendor && id->idProduct)
> @@ -2025,13 +2027,40 @@ static int uvc_probe(struct usb_interface *in=
tf,
>  =09dev->quirks =3D (uvc_quirks_param =3D=3D -1)
>  =09=09    ? id->driver_info : uvc_quirks_param;
>=20
> -=09if (udev->product !=3D NULL)
> -=09=09strlcpy(dev->name, udev->product, sizeof dev->name);
> -=09else
> -=09=09snprintf(dev->name, sizeof dev->name,
> -=09=09=09"UVC Camera (%04x:%04x)",
> -=09=09=09le16_to_cpu(udev->descriptor.idVendor),
> -=09=09=09le16_to_cpu(udev->descriptor.idProduct));
> +=09/*
> +=09 * Add iFunction or iInterface to names when available as additio=
nal
> +=09 * distinguishers between interfaces. iFunction is prioritized ov=
er
> +=09 * iInterface which matches Windows behavior at the point of writ=
ing.
> +=09 */
> +=09if (intf->intf_assoc && intf->intf_assoc->iFunction !=3D 0) {
> +=09=09usb_string(udev, intf->intf_assoc->iFunction,
> +=09=09=09   additional_name_buf, sizeof(additional_name_buf));
> +=09=09additional_name =3D additional_name_buf;
> +=09} else if (intf->cur_altsetting->desc.iInterface !=3D 0) {
> +=09=09usb_string(udev, intf->cur_altsetting->desc.iInterface,
> +=09=09=09   additional_name_buf, sizeof(additional_name_buf));
> +=09=09additional_name =3D additional_name_buf;
> +=09}
> +
> +=09if (additional_name) {
> +=09=09if (udev->product) {
> +=09=09=09snprintf(dev->name, sizeof(dev->name), "%s: %s",
> +=09=09=09=09 udev->product, additional_name);
> +=09=09} else {
> +=09=09=09snprintf(dev->name, sizeof(dev->name),
> +=09=09=09=09 "UVC Camera: %s (%04x:%04x)",
> +=09=09=09=09 additional_name,
> +=09=09=09=09 le16_to_cpu(udev->descriptor.idVendor),
> +=09=09=09=09 le16_to_cpu(udev->descriptor.idProduct));
> +=09=09}
> +=09} else if (udev->product) {
> +=09=09strlcpy(dev->name, udev->product, sizeof(dev->name));
> +=09} else {
> +=09=09snprintf(dev->name, sizeof(dev->name),
> +=09=09=09 "UVC Camera (%04x:%04x)",
> +=09=09=09 le16_to_cpu(udev->descriptor.idVendor),
> +=09=09=09 le16_to_cpu(udev->descriptor.idProduct));
> +=09}

This makes sense to me, but I think we could come up with a version of =
the
same code that wouldn't require the temporary 64 bytes buffer on the st=
ack.
How about the following (untested) code ?

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc=
/uvc_driver.c
index 602256ffe14d..9b90a1ac5945 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2013,6 +2013,7 @@ static int uvc_probe(struct usb_interface *intf,
 {
 =09struct usb_device *udev =3D interface_to_usbdev(intf);
 =09struct uvc_device *dev;
+=09int string;
 =09int ret;
=20
 =09if (id->idVendor && id->idProduct)
@@ -2048,6 +2049,24 @@ static int uvc_probe(struct usb_interface *intf,=

 =09=09=09le16_to_cpu(udev->descriptor.idVendor),
 =09=09=09le16_to_cpu(udev->descriptor.idProduct));
=20
+=09/*
+=09 * Add iFunction or iInterface to names when available as additiona=
l
+=09 * distinguishers between interfaces. iFunction is prioritized over=

+=09 * iInterface which matches Windows behavior at the point of writin=
g.
+=09 */
+=09string =3D intf->intf_assoc ? intf->intf_assoc->iFunction
+=09       : intf->cur_altsetting->desc.iInterface;
+=09if (string !=3D 0) {
+=09=09size_t len;
+
+=09=09strlcat(dev->name, ": ", sizeof(dev->name));
+=09=09len =3D strlen(dev->name);
+
+=09=09/* usb_string() accounts for the terminating NULL character. */
+=09=09usb_string(udev, string, dev->name + len,
+=09=09=09   sizeof(dev->name) - len);
+=09}
+
 =09/* Parse the Video Class control descriptor. */
 =09if (uvc_parse_control(dev) < 0) {
 =09=09uvc_trace(UVC_TRACE_PROBE, "Unable to parse UVC "
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/u=
vcvideo.h
index 15e415e32c7f..f5bb42c6b023 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -556,7 +556,7 @@ struct uvc_device {
 =09unsigned long warnings;
 =09__u32 quirks;
 =09int intfnum;
-=09char name[32];
+=09char name[64];
=20
 =09struct mutex lock;=09=09/* Protects users */
 =09unsigned int users;

>  =09/* Parse the Video Class control descriptor. */
>  =09if (uvc_parse_control(dev) < 0) {
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 4205e7a423f0..0cbedaee6e19 1=
00644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -541,13 +541,15 @@ struct uvc_streaming {
>  =09} clock;
>  };
>=20
> +#define UVC_DEVICE_NAME_SIZE=0964
> +
>  struct uvc_device {
>  =09struct usb_device *udev;
>  =09struct usb_interface *intf;
>  =09unsigned long warnings;
>  =09__u32 quirks;
>  =09int intfnum;
> -=09char name[32];
> +=09char name[UVC_DEVICE_NAME_SIZE];
>=20
>  =09struct mutex lock;=09=09/* Protects users */
>  =09unsigned int users;

--=20
Regards,

Laurent Pinchart
