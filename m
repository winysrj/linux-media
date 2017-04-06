Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:36487 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdDFS2l (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 14:28:41 -0400
Received: by mail-vk0-f47.google.com with SMTP id s68so50697363vke.3
        for <linux-media@vger.kernel.org>; Thu, 06 Apr 2017 11:28:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170406175825.90406-1-pbos@google.com>
References: <20170406175825.90406-1-pbos@google.com>
From: =?UTF-8?Q?Peter_Bostr=C3=B6m?= <pbos@google.com>
Date: Thu, 6 Apr 2017 14:28:39 -0400
Message-ID: <CAGFX3sHzt6jF_gG65sfDGFGBg6D1F==27tqGAOZq==Bt_SsOtQ@mail.gmail.com>
Subject: Re: [PATCH] [media] uvcvideo: Add iFunction or iInterface to device names.
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'll put some more info/discussion points inline. Very happy for
feedback/input here, thanks!

On Thu, Apr 6, 2017 at 1:58 PM Peter Bostr=C3=B6m <pbos@google.com> wrote:
>
> Permits distinguishing between two /dev/videoX entries from the same
> physical UVC device (that naturally share the same iProduct name).

The device under test has interface associations (and has iFunction
present, but not iInterface present). This device is enumerated as
"Camera Name: Interface Function" after this patch, instead of two
/dev/videoX entries showing up as "Camera Name" with different
functions not user visible (apart from lsusb). My tested "Logitech
Webcam C930e" shows no additional string (has only iProduct out of
these). I haven't tested any other devices (none with iInterface
present), and this device is still under development, so any
experience or input from interpretating the USB standard is
appreciated here.

> This change matches current Windows behavior by prioritizing iFunction
> over iInterface, but unlike Windows it displays both iProduct and
> iFunction/iInterface strings when both are available.

Windows only displays one of them, but I thought removing iProduct
from the string was scary. Do we want to match Windows for
consistency/keeping names short here, or is displaying both (which I
personally thinks make more sense) a good strategy here? "Should"
iFunction be expected to include the product name? Otherwise I think
it's fair to display both since something generic like "main video
feed" doesn't tie back to a specific device.

-------------------------------------------------------------------------
String descriptors present              |    Device function name used
-------------------------------------------------------------------------
iProduct                                |    iProduct
iProduct + iFunction                    |    iFunction
iProduct + iFunction + iInterface       |    iFunction
iProduct + iInterface                   |    iInterface
-------------------------------------------------------------------------


> Signed-off-by: Peter Bostr=C3=B6m <pbos@google.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 43 +++++++++++++++++++++++++++++++-=
------
>  drivers/media/usb/uvc/uvcvideo.h   |  4 +++-
>  2 files changed, 39 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/u=
vc_driver.c
> index 04bf35063c4c..66adf8a77e56 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1998,6 +1998,8 @@ static int uvc_probe(struct usb_interface *intf,
>  {
>         struct usb_device *udev =3D interface_to_usbdev(intf);
>         struct uvc_device *dev;
> +       char additional_name_buf[UVC_DEVICE_NAME_SIZE];
> +       const char *additional_name =3D NULL;
>         int ret;
>
>         if (id->idVendor && id->idProduct)
> @@ -2025,13 +2027,40 @@ static int uvc_probe(struct usb_interface *intf,
>         dev->quirks =3D (uvc_quirks_param =3D=3D -1)
>                     ? id->driver_info : uvc_quirks_param;
>
> -       if (udev->product !=3D NULL)
> -               strlcpy(dev->name, udev->product, sizeof dev->name);
> -       else
> -               snprintf(dev->name, sizeof dev->name,
> -                       "UVC Camera (%04x:%04x)",
> -                       le16_to_cpu(udev->descriptor.idVendor),
> -                       le16_to_cpu(udev->descriptor.idProduct));
> +       /*
> +        * Add iFunction or iInterface to names when available as additio=
nal
> +        * distinguishers between interfaces. iFunction is prioritized ov=
er
> +        * iInterface which matches Windows behavior at the point of writ=
ing.
> +        */
> +       if (intf->intf_assoc && intf->intf_assoc->iFunction !=3D 0) {
> +               usb_string(udev, intf->intf_assoc->iFunction,
> +                          additional_name_buf, sizeof(additional_name_bu=
f));
> +               additional_name =3D additional_name_buf;
> +       } else if (intf->cur_altsetting->desc.iInterface !=3D 0) {
> +               usb_string(udev, intf->cur_altsetting->desc.iInterface,
> +                          additional_name_buf, sizeof(additional_name_bu=
f));
> +               additional_name =3D additional_name_buf;
> +       }
> +
> +       if (additional_name) {
> +               if (udev->product) {
> +                       snprintf(dev->name, sizeof(dev->name), "%s: %s",
> +                                udev->product, additional_name);
> +               } else {
> +                       snprintf(dev->name, sizeof(dev->name),
> +                                "UVC Camera: %s (%04x:%04x)",
> +                                additional_name,
> +                                le16_to_cpu(udev->descriptor.idVendor),
> +                                le16_to_cpu(udev->descriptor.idProduct))=
;
> +               }
> +       } else if (udev->product) {
> +               strlcpy(dev->name, udev->product, sizeof(dev->name));
> +       } else {
> +               snprintf(dev->name, sizeof(dev->name),
> +                        "UVC Camera (%04x:%04x)",
> +                        le16_to_cpu(udev->descriptor.idVendor),
> +                        le16_to_cpu(udev->descriptor.idProduct));
> +       }
>
>         /* Parse the Video Class control descriptor. */
>         if (uvc_parse_control(dev) < 0) {
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvc=
video.h
> index 4205e7a423f0..0cbedaee6e19 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -541,13 +541,15 @@ struct uvc_streaming {
>         } clock;
>  };
>
> +#define UVC_DEVICE_NAME_SIZE   64

Note that this expands the device name, and is used because I believe
iProduct + iFunction strings can reasonably extend the previous 32
character max.

> +
>  struct uvc_device {
>         struct usb_device *udev;
>         struct usb_interface *intf;
>         unsigned long warnings;
>         __u32 quirks;
>         int intfnum;
> -       char name[32];
> +       char name[UVC_DEVICE_NAME_SIZE];
>
>         struct mutex lock;              /* Protects users */
>         unsigned int users;
> --
> 2.12.2.715.g7642488e1d-goog
>

Best,
- Peter
