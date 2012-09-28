Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36103 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030245Ab2I1Ta0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 15:30:26 -0400
Received: by eekb15 with SMTP id b15so1644236eek.19
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2012 12:30:25 -0700 (PDT)
Message-ID: <1348860617.2782.26.camel@Route3278>
Subject: Re: [PATCH] usb id addition for Terratec Cinergy T Stick Dual rev. 2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Damien Bally <biribi@free.fr>, linux-media@vger.kernel.org,
	MauroCarvalhoChehab <mchehab@redhat.com>
Date: Fri, 28 Sep 2012 20:30:17 +0100
In-Reply-To: <5065E487.80502@iki.fi>
References: <5064A3AD.70009@free.fr> <5064ABD2.2060106@iki.fi>
	 <5065D1AC.5030800@free.fr> <5065E487.80502@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-09-28 at 20:55 +0300, Antti Palosaari wrote:
> On 09/28/2012 07:34 PM, Damien Bally wrote:
> >   > I will NACK that initially because that USB ID already used by AF9015
> >> driver. You have to explain / study what happens when AF9015 driver
> >> claims that device same time.
> >>
> >
> > Hi Antti
> >
> > With the Cinergy stick alone, dvb_usb_af9015 is predictably loaded, but
> > doesn't prevent dvb_usb_it913x from working nicely.
> >
> > If an afatech 9015 stick is connected, such as an AverTV Volar Black HD
> > (A850), it will be recognized and doesn't affect the other device.
> >
> > *But* it runs into trouble if the two devices were connected at bootup,
> > or if the Cinergy stick is inserted after the other one :
> 
> I am not sure what you do here but let it be clear.
> There is same ID used by af9015 and it913x. Both drivers are loaded when 
> that ID appears. What I understand *both* drivers, af9015 and it913x 
> should detect if device is correct or not. If device is af9015 then 
> it913x should reject it with -ENODEV most likely without a I/O. If 
> device is it913x then af9015 should reject the device similarly. And you 
> must find out how to do that. It is not acceptable both drivers starts 
> doing I/O for same device same time.
> 
Hi All

Which module is loaded first depends on the order in 

/lib/modules/$(uname -r)/modules.usbmap

Its is likely that af9015 will be first, so the it913x will need to be
loaded first by added it to /etc/modules.

I recall a similar problem exists with the DiB3000M-B driver with its
faulty IDs.

A solution may be for Cinergy to have its own module with extern access
to both dvb_usb_device_properties structures and dvb_usbv2_probe them
twice.


Regards


Malcolm








> regards
> Antti
> 
> > -----------------------------------------------------------------------
> > [    1.264018] usb 2-1: new high speed USB device using ehci_hcd and
> > address 2
> > [    1.382487] usb 2-1: New USB device found, idVendor=0ccd, idProduct=0099
> > [    1.382490] usb 2-1: New USB device strings: Mfr=1, Product=2,
> > SerialNumber=0
> > [    1.382492] usb 2-1: Product: DVB-T TV Stick
> > [    1.382494] usb 2-1: Manufacturer: ITE Technologies, Inc.
> > [    1.385073] input: ITE Technologies, Inc. DVB-T TV Stick as
> > /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.1/input/input1
> > [    1.385147] generic-usb 0003:0CCD:0099.0001: input,hidraw0: USB HID
> > v1.01 Keyboard [ITE Technologies, Inc. DVB-T TV Stick] on
> > usb-0000:00:1d.7-1 input1
> > [    5.045527] usbcore: registered new interface driver dvb_usb_it913x
> > [    5.147276] it913x: Chip Version=01 Chip Type=9135
> > [    5.147524] it913x: Firmware Version 33684956
> > [    5.148649] it913x: Remote HID mode NOT SUPPORTED
> > [    5.149024] it913x: Dual mode=3 Tuner Type=0
> > [    5.149028] usb 2-1: dvb_usbv2: found a 'ITE 9135(9006) Generic' in
> > warm state
> > [    5.149077] usb 2-1: dvb_usbv2: will pass the complete MPEG2
> > transport stream to the software demuxer
> > [    5.149307] DVB: registering new adapter (ITE 9135(9006) Generic)
> > [    5.174907] usb 1-4: dvb_usbv2: downloading firmware from file
> > 'dvb-usb-af9015.fw'
> > [    5.241934] usb 1-4: dvb_usbv2: found a 'AverMedia AVerTV Volar Black
> > HD (A850)' in warm state
> > [    5.614827] usb 1-4: dvb_usbv2: will pass the complete MPEG2
> > transport stream to the software demuxer
> > [    5.614866] DVB: registering new adapter (AverMedia AVerTV Volar
> > Black HD (A850))
> > [    5.710026] af9013: firmware version 4.95.0.0
> > [    5.712151] DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
> > [    5.813139] MXL5005S: Attached at address 0xc6
> > [    5.818896] usb 1-4: dvb_usbv2: 'AverMedia AVerTV Volar Black HD
> > (A850)' successfully initialized and connected
> > [    7.266161] usb 2-1: dvb_usbv2: 2nd usb_bulk_msg() failed=-110
> > [    7.266247] it913x-fe: ADF table value    :00
> > [    9.267200] usb 2-1: dvb_usbv2: 2nd usb_bulk_msg() failed=-110
> > [   11.267153] usb 2-1: dvb_usbv2: 2nd usb_bulk_msg() failed=-110
> > [   13.267250] usb 2-1: dvb_usbv2: 2nd usb_bulk_msg() failed=-110
> > [   15.267089] usb 2-1: dvb_usbv2: 2nd usb_bulk_msg() failed=-110
> > [   17.267162] usb 2-1: dvb_usbv2: 2nd usb_bulk_msg() failed=-110
> > [   19.267139] usb 2-1: dvb_usbv2: 2nd usb_bulk_msg() failed=-110
> > [   19.267218] it913x-fe: Crystal Frequency :12000000 Adc Frequency
> > :20250000 ADC X2: 01
> > [   19.267296] usb 2-1: dvb_usbv2: 'ITE 9135(9006) Generic' error while
> > loading driver (-19)
> > [   19.267472] usb 2-1: dvb_usbv2: 'ITE 9135(9006) Generic' successfully
> > deinitialized and disconnected
> > -----------------------------------------------------------------------
> >
> > I'm unfortunately not able to rewrite the driver, but I'm willing to
> > provide any information about the device to help its correct
> > identification. Here is what lsusb yields :
> > -----------------------------------------------------------------------
> > Bus 002 Device 003: ID 0ccd:0099 TerraTec Electronic GmbH
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               2.00
> >    bDeviceClass            0 (Defined at Interface level)
> >    bDeviceSubClass         0
> >    bDeviceProtocol         0
> >    bMaxPacketSize0        64
> >    idVendor           0x0ccd TerraTec Electronic GmbH
> >    idProduct          0x0099
> >    bcdDevice            2.00
> >    iManufacturer           1 ITE Technologies, Inc.
> >    iProduct                2 DVB-T TV Stick
> >    iSerial                 0
> >    bNumConfigurations      1
> >    Configuration Descriptor:
> >      bLength                 9
> >      bDescriptorType         2
> >      wTotalLength           71
> >      bNumInterfaces          2
> >      bConfigurationValue     1
> >      iConfiguration          0
> >      bmAttributes         0x80
> >        (Bus Powered)
> >      MaxPower              500mA
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        0
> >        bAlternateSetting       0
> >        bNumEndpoints           4
> >        bInterfaceClass       255 Vendor Specific Class
> >        bInterfaceSubClass      0
> >        bInterfaceProtocol      0
> >        iInterface              0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x81  EP 1 IN
> >          bmAttributes            2
> >            Transfer Type            Bulk
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0200  1x 512 bytes
> >          bInterval               0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x02  EP 2 OUT
> >          bmAttributes            2
> >            Transfer Type            Bulk
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0200  1x 512 bytes
> >          bInterval               0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x84  EP 4 IN
> >          bmAttributes            2
> >            Transfer Type            Bulk
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0200  1x 512 bytes
> >          bInterval               0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x85  EP 5 IN
> >          bmAttributes            2
> >            Transfer Type            Bulk
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0200  1x 512 bytes
> >          bInterval               0
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        1
> >        bAlternateSetting       0
> >        bNumEndpoints           1
> >        bInterfaceClass         3 Human Interface Device
> >        bInterfaceSubClass      0 No Subclass
> >        bInterfaceProtocol      1 Keyboard
> >        iInterface              0
> >          HID Device Descriptor:
> >            bLength                 9
> >            bDescriptorType        33
> >            bcdHID               1.01
> >            bCountryCode            0 Not supported
> >            bNumDescriptors         1
> >            bDescriptorType        34 Report
> >            wDescriptorLength      65
> >           Report Descriptors:
> >             ** UNAVAILABLE **
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x83  EP 3 IN
> >          bmAttributes            3
> >            Transfer Type            Interrupt
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0040  1x 64 bytes
> >          bInterval              10
> > Device Qualifier (for other device speed):
> >    bLength                10
> >    bDescriptorType         6
> >    bcdUSB               2.00
> >    bDeviceClass            0 (Defined at Interface level)
> >    bDeviceSubClass         0
> >    bDeviceProtocol         0
> >    bMaxPacketSize0        64
> >    bNumConfigurations      1
> > Device Status:     0x0000
> >    (Bus Powered)
> >
> > Hope that helps...
> >
> > Damien
> 
> 


