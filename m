Return-path: <mchehab@pedra>
Received: from nm1.bullet.mail.ukl.yahoo.com ([217.146.183.218]:40051 "HELO
	nm1.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755865Ab1ALUhk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 15:37:40 -0500
Message-ID: <553812.48948.qm@web25908.mail.ukl.yahoo.com>
Date: Wed, 12 Jan 2011 20:37:38 +0000 (GMT)
From: ortenzia konyha <viktoa65@yahoo.es>
Subject: Rv: Re: CyberLink video grabber 2.0
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear linux media developers,
here is the output of my 
"lsusb -v -d 1d19:6105":
Bus 001 Device 007: ID 1d19:6105  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1d19 
  idProduct          0x6105 
  bcdDevice            2.00
  iManufacturer           1 
  iProduct                2 
  iSerial                 3 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           97
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           5
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           5
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
can't get device qualifier: Operation not permitted
can't get debug descriptor: Operation not permitted
cannot read device status, Operation not permitted (1)
Hopefully it will help anybody, 
but does this means that there is no dirver for this device in linux yet?

--- El mié, 12/1/11, Palmax Maverick <palmax@gmail.com> escribió:

> De: Palmax Maverick <palmax@gmail.com>
> Asunto: Re: CyberLink video grabber 2.0
> Para: "ortenzia konyha" <viktoa65@yahoo.es>
> Fecha: miércoles, 12 de enero, 2011 15:04
> You may attach the "lsusb -v -d
> 1d19:6105" output.
> 
> It can help linux media developers.
> 
> 
> Bye
> Palmax
> 
> 2011/1/12 ortenzia konyha <viktoa65@yahoo.es>:
> > Dear all,
> > I have bought a CyberLink video grabber 2.0.
> > when I put in the console the code lsusb,=20
> > the result is this: ID 1d19:6105
> >
> > can you tell me what driver should I try?
> >
> >
> >
> >
> >
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 


      
