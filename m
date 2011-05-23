Return-path: <mchehab@pedra>
Received: from mailfe02.c2i.net ([212.247.154.34]:44706 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932399Ab1EWTyD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 15:54:03 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Alternate setting 1 must be selected for interface 0 on the model that I received. Else the rest is identical.
Date: Mon, 23 May 2011 21:52:49 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <201105231637.39053.hselasky@c2i.net> <201105232117.22890.hselasky@c2i.net> <4DDAB9ED.1020309@redhat.com>
In-Reply-To: <4DDAB9ED.1020309@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105232152.49155.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 23 May 2011 21:47:57 Mauro Carvalho Chehab wrote:
> Em 23-05-2011 16:17, Hans Petter Selasky escreveu:
> > On Monday 23 May 2011 21:06:32 Mauro Carvalho Chehab wrote:
> >> Em 23-05-2011 15:48, Hans Petter Selasky escreveu:
> >>> On Monday 23 May 2011 20:14:45 Mauro Carvalho Chehab wrote:
> >>>> Em 23-05-2011 11:37, Hans Petter Selasky escreveu:
> >>>> 
> >>>> I don't have any ttusb device here, but I doubt that this would work.
> >>> 
> >>> Hi,
> >>> 
> >>> It is already tested and works fine.
> >> 
> >> This will work for you, but it will likely break for the others. Your
> >> patch is assuming that returning an error if selecting alt 1 is enough
> >> to know that alt 0 should be used.
> >> 
> >>> What I see is that interface 1 does not have an alternate setting like
> >>> the driver code expects, while interface 0 does. So it is the opposite
> >>> of what the driver expects. Maybe the manufacturer changed something.
> >>> Endpoints are still the same.
> >> 
> >> That sometimes happen. Or maybe you just need a different size.
> >> 
> >>> Please find attached an USB descriptor dump from this device.
> >> 
> >> Int 0, endpoint 0:
> >>     Interface 0
> >>     
> >>       bLength = 0x0009
> >>       bDescriptorType = 0x0004
> >>       bInterfaceNumber = 0x0000
> >>       bAlternateSetting = 0x0000
> >>       bNumEndpoints = 0x0003
> >>       bInterfaceClass = 0x0000
> >>       bInterfaceSubClass = 0x0000
> >>       bInterfaceProtocol = 0x0000
> >>       iInterface = 0x0000  <no string>
> >> 
> >> ...
> >> 
> >>      Endpoint 2
> >>      
> >>         bLength = 0x0007
> >>         bDescriptorType = 0x0005
> >>         bEndpointAddress = 0x0082  <IN>
> >>         bmAttributes = 0x0001  <ISOCHRONOUS>
> >>         wMaxPacketSize = 0x0000
> >>         bInterval = 0x0001
> >>         bRefresh = 0x0000
> >>         bSynchAddress = 0x0000
> >> 
> >> ...
> >> 
> >>     Interface 0 Alt 1
> >>     
> >>       bLength = 0x0009
> >>       bDescriptorType = 0x0004
> >>       bInterfaceNumber = 0x0000
> >>       bAlternateSetting = 0x0001
> >>       bNumEndpoints = 0x0003
> >>       bInterfaceClass = 0x0000
> >>       bInterfaceSubClass = 0x0000
> >>       bInterfaceProtocol = 0x0000
> >>       iInterface = 0x0000  <no string>
> >> 
> >> ...
> >> 
> >>      Endpoint 2
> >>      
> >>         bLength = 0x0007
> >>         bDescriptorType = 0x0005
> >>         bEndpointAddress = 0x0082  <IN>
> >>         bmAttributes = 0x0001  <ISOCHRONOUS>
> >>         wMaxPacketSize = 0x0390
> >>         bInterval = 0x0001
> >>         bRefresh = 0x0000
> >>         bSynchAddress = 0x0000
> > 
> > Hi,
> > 
> >> Hmm... assuming that the driver is using ISOC transfers, the difference
> >> between alt 0 and alt 1 is that, on alt0, the mwMaxPacketSize is 0 (so,
> >> you can't use it for isoc transfers), while, on alt 1, wMaxPacketSize is
> >> 0x390.
> >> 
> >> What the driver should be doing is to select an alt mode where the
> >> wMaxPacketSize is big enough to handle the transfer.
> > 
> > I can write the code to do that. Summed up:
> > 
> > 1) Search interface 0, for alternate settings that have an ISOC-IN and
> > wMaxPacket != 0. Select this alternate setting.
> > 
> > 2) Search interface 1, for alternate settings that have an ISOC-IN and
> > wMaxPacket != 0. Select this alternate setting.
> > 
> > 3) Done.
> > 
> > Do you think this will work better?
> > 
> >> Calculating what "big enough"   is device-dependent, but, basically, a
> >> 480 Mbps USB bus is capable of providing 800 isoc slots per interval.
> >> If the packets are bigger, the max bandwidth is bigger.
> > 
> > This is a FULL speed device, max 10MBit/second.
> 
> Hmm... USB 1.1 devices are even more limited on the amount of used
> bandwidth. The above procedure is better than the one you've proposed, but
> yet you may not be able to receive channels with higher bandwidths.
> 
> The usb "max" limit is lower than the maximum bandwidth. I think that full
> speed provides 900 isoc slots per interval, but the interval for usb 1.1 is
> higher (1s, while the interval for usb 2.0 is 125 us), but you need to
> double check such constraints at the USB 1.1 and 2.0 specs, as I may be
> wrong on that, as I read it a long time ago ;)

Hi,

There are 1000 frames per second when using Full Speed USB. I know the device 
cannot receive all streams, but it is very well suited for DVB radio.

--HPS
