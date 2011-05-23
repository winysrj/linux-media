Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab1EWTGj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 15:06:39 -0400
Message-ID: <4DDAB038.2060801@redhat.com>
Date: Mon, 23 May 2011 16:06:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Alternate setting 1 must be selected for interface 0
 on the model that I received. Else the rest is identical.
References: <201105231637.39053.hselasky@c2i.net> <4DDAA415.40007@redhat.com> <201105232048.47280.hselasky@c2i.net>
In-Reply-To: <201105232048.47280.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 15:48, Hans Petter Selasky escreveu:
> On Monday 23 May 2011 20:14:45 Mauro Carvalho Chehab wrote:
>> Em 23-05-2011 11:37, Hans Petter Selasky escreveu:
>>
>> I don't have any ttusb device here, but I doubt that this would work.
> 
> Hi,
> 
> It is already tested and works fine.

This will work for you, but it will likely break for the others. Your patch
is assuming that returning an error if selecting alt 1 is enough to know that
alt 0 should be used.

> What I see is that interface 1 does not have an alternate setting like the 
> driver code expects, while interface 0 does. So it is the opposite of what the 
> driver expects. Maybe the manufacturer changed something. Endpoints are still 
> the same.

That sometimes happen. Or maybe you just need a different size.
> 
> Please find attached an USB descriptor dump from this device.

Int 0, endpoint 0:

    Interface 0
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0000 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

...

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0000 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

...

    Interface 0 Alt 1
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0001 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

...
     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0390 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

Hmm... assuming that the driver is using ISOC transfers, the difference between
alt 0 and alt 1 is that, on alt0, the mwMaxPacketSize is 0 (so, you can't use it
for isoc transfers), while, on alt 1, wMaxPacketSize is 0x390.

What the driver should be doing is to select an alt mode where the wMaxPacketSize is 
big enough to handle the transfer.

Calculating what "big enough"   is device-dependent, but, basically, a 480 Mbps
USB bus is capable of providing 800 isoc slots per interval. If the packets are bigger,
the max bandwidth is bigger.

You're able to see the amount of packets per interval by doing a cat /proc/bus/usb/devices:

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 8
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0

The "B:" line above shows the USB bandwidth usage.

> 
>>
>> Alternates should be selected depending on the bandwidth needed. The right
>> way is to write some logic that will get the maximum packet size for each
>> mode, between the alternates that provide the type of transfer (Bulk or
>> ISOC) accepted by the driver.
> 
> Right, but this driver doesn't do this. It only selects a working one.
> 
> --HPS

