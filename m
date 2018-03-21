Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37996 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbeCUIyB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 04:54:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Paul Menzel <pmenzel+linux-media@molgen.mpg.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-media@molgen.mpg.de
Subject: Re: uvcvideo: Unknown video format,00000032-0002-0010-8000-00aa00389b71
Date: Wed, 21 Mar 2018 10:55:07 +0200
Message-ID: <8273225.C6Qc70SQRM@avalon>
In-Reply-To: <1521603539.27691.5.camel@ndufresne.ca>
References: <8f7d4aef-84f7-ae22-8adc-cba4fa881675@molgen.mpg.de> <15529671.DGPDy3yHsE@avalon> <1521603539.27691.5.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Wednesday, 21 March 2018 05:38:59 EET Nicolas Dufresne wrote:
> Le mardi 20 mars 2018 =E0 20:04 +0200, Laurent Pinchart a =E9crit :
> > On Tuesday, 20 March 2018 19:45:51 EET Nicolas Dufresne wrote:
> > > Le mardi 20 mars 2018 =E0 13:20 +0100, Paul Menzel a =E9crit :
> > > > Dear Linux folks,
> > > >=20
> > > >=20
> > > > On the Dell XPS 13 9370, Linux 4.16-rc6 outputs the messages below.
> > > >=20
> > > > ```
> > > > [    2.338094] calling  uvc_init+0x0/0x1000 [uvcvideo] @ 295
> > > > [    2.338569] calling  iTCO_wdt_init_module+0x0/0x1000 [iTCO_wdt] @
> > > > 280
> > > > [    2.338570] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> > > > [    2.338713] iTCO_wdt: Found a Intel PCH TCO device (Version=3D4,
> > > > TCOBASE=3D0x0400)
> > > > [    2.338755] uvcvideo: Found UVC 1.00 device Integrated_Webcam_HD
> > > > (0bda:58f4)
> > > > [    2.338827] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=
=3D0)
> > > > [    2.338851] initcall iTCO_wdt_init_module+0x0/0x1000 [iTCO_wdt]
> > > > returned 0 after 271 usecs
> > > > [    2.340669] uvcvideo 1-5:1.0: Entity type for entity Extension 4
> > > > was
> > > > not initialized!
> > > > [    2.340670] uvcvideo 1-5:1.0: Entity type for entity Extension 7
> > > > was
> > > > not initialized!
> > > > [    2.340672] uvcvideo 1-5:1.0: Entity type for entity Processing 2
> > > > was
> > > > not initialized!
> > > > [    2.340673] uvcvideo 1-5:1.0: Entity type for entity Camera 1 was
> > > > not
> > > > initialized!
> > > > [    2.340736] input: Integrated_Webcam_HD: Integrate as
> > > > /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/input/input9
> > > > [    2.341447] uvcvideo: Unknown video format
> > > > 00000032-0002-0010-8000-00aa00389b71
> > >=20
> > > While the 0002 is suspicious, this is pretty close to a color format.
> > > I've recently come across of similar format using D3DFORMAT instead of
> > > GUID. According to the vendor*, this camera module includes an infrar=
ed
> > > camera (340x340), so I suspect this is to specify the format it
> > > outputs. A good guess to start with would be that this is
> > > D3DFMT_X8L8V8U8 (0x32).
> >=20
> > Isn't 0x32 D3DFMT_L8, not D3DFMT_X8L8V8U8 ?
>=20
> You are right, sorry about that, I totally miss-translate. It felt
> weird. This is much more likely yes. So maybe it's the same mapping
> (but with the -00002- instead) as what I added for the HoloLense
> Camera.
>=20
> > > To test it, you could map this
> > > V4L2_PIX_FMT_YUV32/xRGB and see if the driver is happy with the buffer
> > > size.
> >=20
> > VideoStreaming Interface Descriptor:
> >         bLength                            30
> >         bDescriptorType                    36
> >         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
> >         bFrameIndex                         1
> >         bmCapabilities                   0x00
> >        =20
> >           Still image unsupported
> >        =20
> >         wWidth                            340
> >         wHeight                           340
> >         dwMinBitRate                 55488000
> >         dwMaxBitRate                 55488000
> >         dwMaxVideoFrameBufferSize      115600
> >         dwDefaultFrameInterval         166666
> >         bFrameIntervalType                  1
> >         dwFrameInterval( 0)            166666
> >=20
> > 340*340 is 115600, so this should be a 8-bit format.
>=20
> Indeed, that matches.
>=20
> > > Then render it to make sure it looks some image of some sort. A
> > > new format will need to be defined as this format is in the wrong
> > > order, and is ambiguous (it may mean AYUV or xYUV). I'm not sure if we
> > > need specific formats to differentiate infrared data from YUV images,
> > > need to be discussed.
> >=20
> > If the format is indeed D3DFMT_L8, it should map to V4L2_PIX_FMT_GREY
> > (8-bit luminance). I suspect the camera transmits a depth map though.
>=20
> I wonder if we should think of a way to tell userspace this is fnfrared
> data rather then black and white ?

I think we need such a mechanism, yes. Would you like to propose one ? :-)

I've found https://www.magnumdb.com/search?q=3Dvalue%3A
%2200000032-0002-0010-8000-00aa00389b71%22 and https://docs.microsoft.com/e=
n-us/windows-hardware/drivers/stream/infrared-stream-support-in-uvc that co=
nfirm=20
this is a 8-bit IR format.

> > > *https://dustinweb.azureedge.net/media/338953/xps-13-9370.pdf
> > >=20
> > > > [    2.341450] uvcvideo: Found UVC 1.00 device Integrated_Webcam_HD
> > > > (0bda:58f4)
> > > > [    2.343371] uvcvideo: Unable to create debugfs 1-2 directory.
> > > > [    2.343420] uvcvideo 1-5:1.2: Entity type for entity Extension 10
> > > > was
> > > > not initialized!
> > > > [    2.343422] uvcvideo 1-5:1.2: Entity type for entity Extension 12
> > > > was
> > > > not initialized!
> > > > [    2.343423] uvcvideo 1-5:1.2: Entity type for entity Processing 9
> > > > was
> > > > not initialized!
> > > > [    2.343424] uvcvideo 1-5:1.2: Entity type for entity Camera 11 w=
as
> > > > not initialized!
> > > > [    2.343472] input: Integrated_Webcam_HD: Integrate as
> > > > /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.2/input/input10
> > > > [    2.343496] usbcore: registered new interface driver uvcvideo
> > > > [    2.343496] USB Video Class driver (1.1.1)
> > > > [    2.343501] initcall uvc_init+0x0/0x1000 [uvcvideo] returned 0
> > > > after
> > > > 5275 usecs
> > > > ```
> > > >=20
> > > > Please tell me, what I can do to improve the situation.

=2D-=20
Regards,

Laurent Pinchart
