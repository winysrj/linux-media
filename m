Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957Ab2I2RdV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 13:33:21 -0400
Date: Sat, 29 Sep 2012 14:33:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, Damien Bally <biribi@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] usb id addition for Terratec Cinergy T Stick Dual rev.
 2
Message-ID: <20120929143305.4859603e@redhat.com>
In-Reply-To: <1348860617.2782.26.camel@Route3278>
References: <5064A3AD.70009@free.fr>
	<5064ABD2.2060106@iki.fi>
	<5065D1AC.5030800@free.fr>
	<5065E487.80502@iki.fi>
	<1348860617.2782.26.camel@Route3278>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Sep 2012 20:30:17 +0100
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> On Fri, 2012-09-28 at 20:55 +0300, Antti Palosaari wrote:
> > On 09/28/2012 07:34 PM, Damien Bally wrote:
> > >   > I will NACK that initially because that USB ID already used by AF9015
> > >> driver. You have to explain / study what happens when AF9015 driver
> > >> claims that device same time.
> > >>
> > >
> > > Hi Antti
> > >
> > > With the Cinergy stick alone, dvb_usb_af9015 is predictably loaded, but
> > > doesn't prevent dvb_usb_it913x from working nicely.
> > >
> > > If an afatech 9015 stick is connected, such as an AverTV Volar Black HD
> > > (A850), it will be recognized and doesn't affect the other device.
> > >
> > > *But* it runs into trouble if the two devices were connected at bootup,
> > > or if the Cinergy stick is inserted after the other one :
> > 
> > I am not sure what you do here but let it be clear.
> > There is same ID used by af9015 and it913x. Both drivers are loaded when 
> > that ID appears. What I understand *both* drivers, af9015 and it913x 
> > should detect if device is correct or not. If device is af9015 then 
> > it913x should reject it with -ENODEV most likely without a I/O. If 
> > device is it913x then af9015 should reject the device similarly. And you 
> > must find out how to do that. It is not acceptable both drivers starts 
> > doing I/O for same device same time.
> > 
> Hi All
> 
> Which module is loaded first depends on the order in 
> 
> /lib/modules/$(uname -r)/modules.usbmap
> 
> Its is likely that af9015 will be first, so the it913x will need to be
> loaded first by added it to /etc/modules.

Well, builtin modules are loaded before, so if it931x is built with 'Y'
and af9015 with 'M', then it913x will be the first one.

As a general rule, don't trust on one being loaded before the other: the
best thing to do is to detect different USB ID and bcdDevice at the USB
Table. It seems that the it931x variant has bcdDevice equal to 2.00,
from Damien's email:

   idVendor           0x0ccd TerraTec Electronic GmbH
   idProduct          0x0099
   bcdDevice            2.00
   iManufacturer           1 ITE Technologies, Inc.
   iProduct                2 DVB-T TV Stick
   iSerial                 0

If the af9015 variant uses another bcdDevice, the fix should be simple.

Btw, cx231xx and dib0700 does that for some Pixelviel devices. This is
how cx231xx declares his device (bcd 40.00 to 40.01):

        {USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000, 0x4001),
         .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},

And dib0700 declares the same USB ID with bcdDevice range from 0.00 to 3f.00:

        { USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x000, 0x3f00) },

If the bcdDevice is identical, then the driver should find a way to check it during
.probe time, and return -ENODEV if the device doesn't match. The other USB driver
will handle it properly.

Regards,
Mauro
