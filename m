Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38659 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbeCUJYg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 05:24:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paul Menzel <pmenzel+linux-media@molgen.mpg.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-media@molgen.mpg.de,
        Mario Limonciello <mario.limonciello@dell.com>
Subject: Re: uvcvideo: Unknown video format,00000032-0002-0010-8000-00aa00389b71
Date: Wed, 21 Mar 2018 11:25:42 +0200
Message-ID: <2929738.Pf5m835D8F@avalon>
In-Reply-To: <2b332247-72f6-d9ad-306d-d900759ea5a8@molgen.mpg.de>
References: <8f7d4aef-84f7-ae22-8adc-cba4fa881675@molgen.mpg.de> <6647791.pjJyibMGYG@avalon> <2b332247-72f6-d9ad-306d-d900759ea5a8@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Tuesday, 20 March 2018 18:46:24 EET Paul Menzel wrote:
> On 03/20/18 14:30, Laurent Pinchart wrote:
> > On Tuesday, 20 March 2018 14:20:14 EET Paul Menzel wrote:
> >> On the Dell XPS 13 9370, Linux 4.16-rc6 outputs the messages below.
> >>=20
> >> ```
>=20
> [=E2=80=A6]
>=20
> >> [    2.340736] input: Integrated_Webcam_HD: Integrate as
> >> /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/input/input9
> >> [    2.341447] uvcvideo: Unknown video format
> >> 00000032-0002-0010-8000-00aa00389b71 >> [    2.341450] uvcvideo: Found
> >> UVC 1.00 device Integrated_Webcam_HD (0bda:58f4)
>=20
> [=E2=80=A6]
>=20
> >> ```
> >>=20
> >> Please tell me, what I can do to improve the situation.
> >=20
> > Some vendors routinely implement new formats without bothering to send a
> > patch for the uvcvideo driver. It would be easy to do so, but it requir=
es
> > knowing which format is meant by the GUID. Most format GUIDs are of the
> > form 32595559-0000-0010-8000-00aa00389b71 that starts with a 4CC, but
> > that's not the case here.
>=20
> I am adding Mario to the receiver list, though he is currently on vacatio=
n.
>=20
> > Could you send me the output of
> >=20
> > lsusb -v -d 0bda:58f4
> >=20
> > running as root if possible ?
>=20
> Sure, please find it attached.

Thank you.

Could you please try the following patch ?

commit 7b3dea984b380f5b4b5c1956a9c6c23966af2149
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Wed Mar 21 11:16:40 2018 +0200

    media: uvcvideo: Add KSMedia 8-bit IR format support
   =20
    Add support for the 8-bit IR format GUID defined in the Microsoft Kernel
    Streaming Media API.
   =20
    Reported-by: Paul Menzel <pmenzel+linux-media@molgen.mpg.de>
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc=
_driver.c
index 2469b49b2b30..3691d87ef869 100644
=2D-- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -99,6 +99,11 @@ static struct uvc_format_desc uvc_fmts[] =3D {
 		.guid		=3D UVC_GUID_FORMAT_D3DFMT_L8,
 		.fcc		=3D V4L2_PIX_FMT_GREY,
 	},
+	{
+		.name		=3D "IR 8-bit (L8_IR)",
+		.guid		=3D UVC_GUID_FORMAT_KSMEDIA_L8_IR,
+		.fcc		=3D V4L2_PIX_FMT_GREY,
+	},
 	{
 		.name		=3D "Greyscale 10-bit (Y10 )",
 		.guid		=3D UVC_GUID_FORMAT_Y10,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvi=
deo.h
index be5cf179228b..6b955e0dd956 100644
=2D-- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -157,6 +157,9 @@
 #define UVC_GUID_FORMAT_D3DFMT_L8 \
 	{0x32, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_KSMEDIA_L8_IR \
+	{0x32, 0x00, 0x00, 0x00, 0x02, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
=20
=20
 /* ------------------------------------------------------------------------

=2D-=20
Regards,

Laurent Pinchart
