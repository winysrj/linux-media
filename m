Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40260 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbdGNHeU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 03:34:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jim Lin <jilin@nvidia.com>
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1 V2] media: usb: uvc: Fix incorrect timeout for Get Request
Date: Fri, 14 Jul 2017 10:34:23 +0300
Message-ID: <1696193.EoNaQecsU9@avalon>
In-Reply-To: <3a7d73bb-45f8-4803-ee9b-8bf2ead84017@nvidia.com>
References: <1499669029-3412-1-git-send-email-jilin@nvidia.com> <3026364.oSOK2ZPSm0@avalon> <3a7d73bb-45f8-4803-ee9b-8bf2ead84017@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jim,

On Friday 14 Jul 2017 09:58:11 Jim Lin wrote:
> On 2017=E5=B9=B407=E6=9C=8811=E6=97=A5 03:47, Laurent Pinchart wrote:=

> > On Monday 10 Jul 2017 14:43:49 Jim Lin wrote:
> >> Section 9.2.6.4 of USB 2.0/3.x specification describes that
> >> "device must be able to return the first data packet to host withi=
n
> >> 500 ms of receipt of the request. For subsequent data packet, if a=
ny,
> >> the device must be able to return them within 500 ms".
> >>=20
> >> This is to fix incorrect timeout and change it from 300 ms to 500 =
ms
> >> to meet the timing specified by specification for Get Request.
> >>=20
> >> Signed-off-by: Jim Lin <jilin@nvidia.com>
> >=20
> > The patch looks good to me, so
> >=20
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >=20
> > but I'm curious, have you noticed issues with some devices in pract=
ice ?
>=20
> Sometimes this device takes about 360 ms to respond.
>=20
> usb 1-2: new high-speed USB device number 16
> usb 1-2: New USB device found, idVendor=3D045e, idProduct=3D0772
> usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
0
> usb 1-2: Product: Microsoft=EF=BF=BD=C2=AE LifeCam Studio(TM)
> usb 1-2: Manufacturer: Microsoft
>=20
> uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 4: -110 (ex=
p. 2).
>=20
> And it will be working well with correct timeout value.

Thank you for the information.

I've applied the patch to my tree and will push it to v4.14.

--=20
Regards,

Laurent Pinchart
