Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61046 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753350AbdFWLhF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 07:37:05 -0400
MIME-Version: 1.0
Message-ID: <trinity-e0ba80e1-d931-4469-a929-6c34e24440bf-1498217795542@3capp-mailcom-bs06>
From: juvann@caramail.fr
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] em28xx TerraTec Cinergy Hybrid T USB XS with
 demodulator MT352 is not detect by em28xx
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 Jun 2017 13:36:35 +0200
In-Reply-To: <20170623073816.5ef3610c@vento.lan>
References: <trinity-3ccfe6a4-860f-4c5c-a2cc-d3027dbb4777-1497078814431@3capp-mailcom-bs10>
 <0c26e44d-c317-771e-0faa-2ae637b9ecfe@xs4all.nl>
 <20170623073816.5ef3610c@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

this is the output of lsusb -v of my device with demodulator MT352 which works with EM2880.

Bus 002 Device 002: ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid T XS
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0ccd TerraTec Electronic GmbH
  idProduct          0x0042 Cinergy Hybrid T XS
  bcdDevice            1.00
  iManufacturer           2 TerraTec Electronic GmbH
  iProduct                1 Cinergy Hybrid T USB XS
  iSerial                 0 
  bNumConfigurations      1

Regards,
Giovanni

> Sent: Friday, June 23, 2017 at 12:38 PM
> From: "Mauro Carvalho Chehab" <mchehab@infradead.org>
> To: "Hans Verkuil" <hverkuil@xs4all.nl>
> Cc: juvann@caramail.fr, linux-media@vger.kernel.org
> Subject: Re: [PATCH] [media] em28xx TerraTec Cinergy Hybrid T USB XS with demodulator MT352 is not detect by em28xx
>
> Em Fri, 23 Jun 2017 11:22:50 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Hi Giovanni,
> > 
> > On 06/10/17 09:13, juvann@caramail.fr wrote:
> > > TerraTec Cinergy Hybrid T USB XS with demodulator MT352 stop working with kernel 3.xx and newer.
> > > I have already sent this patch without a success reply, I hope this time you can accept it.
> > > 
> > > --- /usr/src/linux-3.14.3/drivers/media/usb/em28xx/em28xx-cards.c.orig   2014-05-06 16:59:58.000000000 +0200
> > > +++ /usr/src/linux-3.14.3/drivers/media/usb/em28xx/em28xx-cards.c   2014-05-07 15:18:31.719524453 +0200
> > > @@ -2233,7 +2233,7 @@
> > >         { USB_DEVICE(0x0ccd, 0x005e),
> > >                         .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
> > >         { USB_DEVICE(0x0ccd, 0x0042),
> > > -                       .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
> > > +                       .driver_info = EM2880_BOARD_TERRATEC_HYBRID_XS },
> > >         { USB_DEVICE(0x0ccd, 0x0043),
> > >                         .driver_info = EM2870_BOARD_TERRATEC_XS },
> > >         { USB_DEVICE(0x0ccd, 0x008e),   /* Cinergy HTC USB XS Rev. 1 */
> > > 
> > > This patch is working also on kernel 4.xx I have tested kernel 4.3 and 4.9  
> > 
> > I checked the commit that changed the original EM2880_BOARD_TERRATEC_HYBRID_XS
> > to EM2882_BOARD_TERRATEC_HYBRID_XS and it says this:
> > 
> > commit 9124544320bd36d5aa21769d17a5781ba729aebf
> > Author: Philippe Bourdin <richel@AngieBecker.ch>
> > Date:   Sun Oct 31 09:57:58 2010 -0300
> > 
> >     [media] Terratec Cinergy Hybrid T USB XS
> > 
> >     I found that the problems people have reported with the USB-TV-stick
> >     "Terratec Cinergy Hybrid T USB XS" (USB-ID: 0ccd:0042)
> >     are coming from a wrong header file in the v4l-sources.
> > 
> >     Attached is a diff, which fixes the problem (tested successfully here).
> >     Obviously the USB-ID has been associated with a wrong chip: EM2880
> >     instead of EM2882, which would be correct.
> > 
> >     Reported-by: Philippe Bourdin <richel@AngieBecker.ch>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > So it looks like there are two variants with the same USB ID: one uses
> > the EM2880, one uses the EM2882. Since nobody else complained I expect
> > that most devices with this USB ID are in fact using the EM2882.
> > 
> > I won't apply this patch, since that would break it for others.
> > 
> > The best solution for you is to explicitly set the card using the
> > 'card=11' em28xx module option.
> > 
> > I've CC-ed Mauro in case he knows a better solution.
> 
> If the newest original driver from the manufacturer supports both
> versions, perhaps the *.INF file there would help to identify what
> version is there, by using the USB revision numbers.
> 
> We have this for USB ID 1554:5010, for example. That specific USB ID
> actually use two different drivers, depending on the review.
> 
> Either cx231xx:
> 
> 	{USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000, 0x4001),
> 	 .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},
> 
> or dib0700:
> 
> 	{ USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x000, 0x3f00) },
> 
> Unfortunately, I don't have any contacts at Terratec anymore, so we'll
> need to get it the hard way: people with this hardware should report the
> version of the hardware, by using lsusb -v. It should report something
> like:
> 
> 	Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> 	Couldn't open device, some information will be missing
> 	Device Descriptor:
> 	  bLength                18
> 	  bDescriptorType         1
> 	  bcdUSB               2.00
> 	  bDeviceClass            9 Hub
> 	  bDeviceSubClass         0 
> 	  bDeviceProtocol         1 Single TT
> 	  bMaxPacketSize0        64
> 	  idVendor           0x1d6b Linux Foundation
> 	  idProduct          0x0002 2.0 root hub
> 	  bcdDevice            4.10
> 	  iManufacturer           3 
> 	  iProduct                2 
> 	  iSerial                 1 
> 
> The USB_DEVICE_VER macro is:
> 
> 	#define USB_DEVICE_VER(vend, prod, lo, hi) \
> 		.match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION, \
> 		.idVendor = (vend), \
> 		.idProduct = (prod), \
> 		.bcdDevice_lo = (lo), \
> 		.bcdDevice_hi = (hi)
> 
> So, it basically uses the field "bcdDevice" in order to detect for a
> specific hardware version.
> 
> Please notice that, ideally, we need the "bcdDevice" data for both the 
> em2880 and em2882 versions in to fix it and be sure that the
> manufacturer changed it on the newest version. The *.INF file may
> contain such information, with would make our lives a way easier.
> 
> Regards,
> Mauro
> 
