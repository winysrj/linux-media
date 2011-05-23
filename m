Return-path: <mchehab@pedra>
Received: from mailfe06.c2i.net ([212.247.154.162]:53755 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756556Ab1EWSuD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 14:50:03 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Alternate setting 1 must be selected for interface 0 on the model that I received. Else the rest is identical.
Date: Mon, 23 May 2011 20:48:47 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <201105231637.39053.hselasky@c2i.net> <4DDAA415.40007@redhat.com>
In-Reply-To: <4DDAA415.40007@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Pwq2NwrS6j7TgAh"
Message-Id: <201105232048.47280.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_Pwq2NwrS6j7TgAh
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Monday 23 May 2011 20:14:45 Mauro Carvalho Chehab wrote:
> Em 23-05-2011 11:37, Hans Petter Selasky escreveu:
>
> I don't have any ttusb device here, but I doubt that this would work.

Hi,

It is already tested and works fine.

What I see is that interface 1 does not have an alternate setting like the 
driver code expects, while interface 0 does. So it is the opposite of what the 
driver expects. Maybe the manufacturer changed something. Endpoints are still 
the same.

Please find attached an USB descriptor dump from this device.

> 
> Alternates should be selected depending on the bandwidth needed. The right
> way is to write some logic that will get the maximum packet size for each
> mode, between the alternates that provide the type of transfer (Bulk or
> ISOC) accepted by the driver.

Right, but this driver doesn't do this. It only selects a working one.

--HPS

--Boundary-00=_Pwq2NwrS6j7TgAh
Content-Type: text/plain;
  charset="iso-8859-1";
  name="descriptors.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="descriptors.txt"

ugen6.2: <WinTV NOVA-t USB Hauppauge> at usbus6, cfg=0 md=HOST spd=FULL (12Mbps) pwr=ON

  bLength = 0x0012 
  bDescriptorType = 0x0001 
  bcdUSB = 0x0100 
  bDeviceClass = 0x0000 
  bDeviceSubClass = 0x0000 
  bDeviceProtocol = 0x0000 
  bMaxPacketSize0 = 0x0008 
  idVendor = 0x0b48 
  idProduct = 0x1005 
  bcdDevice = 0x0100 
  iManufacturer = 0x0001  <Hauppauge>
  iProduct = 0x0002  <WinTV NOVA-t USB>
  iSerialNumber = 0x0000  <no string>
  bNumConfigurations = 0x0001 


 Configuration index 0

    bLength = 0x0009 
    bDescriptorType = 0x0002 
    wTotalLength = 0x019f 
    bNumInterfaces = 0x0002 
    bConfigurationValue = 0x0001 
    iConfiguration = 0x0004  <Config0>
    bmAttributes = 0x0040 
    bMaxPower = 0x0000 

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

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0000 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


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

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0390 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 2
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0002 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0360 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 3
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0003 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0338 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 4
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0004 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x02d8 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 5
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0005 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0278 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 6
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0006 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0220 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 7
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0007 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x01c0 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 8
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0008 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0160 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 9
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x0009 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0100 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 10
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x000a 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x00c0 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 11
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x000b 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0080 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 0 Alt 12
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0000 
      bAlternateSetting = 0x000c 
      bNumEndpoints = 0x0003 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0081  <IN>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 1
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0001  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0020 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 

     Endpoint 2
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0082  <IN>
        bmAttributes = 0x0001  <ISOCHRONOUS>
        wMaxPacketSize = 0x0040 
        bInterval = 0x0001 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 


    Interface 1
      bLength = 0x0009 
      bDescriptorType = 0x0004 
      bInterfaceNumber = 0x0001 
      bAlternateSetting = 0x0000 
      bNumEndpoints = 0x0001 
      bInterfaceClass = 0x0000 
      bInterfaceSubClass = 0x0000 
      bInterfaceProtocol = 0x0000 
      iInterface = 0x0000  <no string>

     Endpoint 0
        bLength = 0x0007 
        bDescriptorType = 0x0005 
        bEndpointAddress = 0x0002  <OUT>
        bmAttributes = 0x0002  <BULK>
        wMaxPacketSize = 0x0008 
        bInterval = 0x0000 
        bRefresh = 0x0000 
        bSynchAddress = 0x0000 




--Boundary-00=_Pwq2NwrS6j7TgAh--
