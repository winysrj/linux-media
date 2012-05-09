Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:43514 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752337Ab2EITMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 15:12:21 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Bruno Martins <lists@skorzen.net>
Subject: Re: Dazzle DVC80 under FC16
Date: Wed, 9 May 2012 21:12:00 +0200
Cc: linux-media@vger.kernel.org
References: <4FAA57A3.2030701@skorzen.net> <201205091732.18373.linux@rainbow-software.org> <4FAA9942.5050703@skorzen.net>
In-Reply-To: <4FAA9942.5050703@skorzen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201205092112.02807.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 09 May 2012 18:20:18 Bruno Martins wrote:
> On 05/09/2012 04:32 PM, Ondrej Zary wrote:
> > On Wednesday 09 May 2012, Bruno Martins wrote:
> >> Hello guys,
> >>
> >> Has anyone ever got this to working under any Linux distro, including
> >> Fedora?
> >>
> >> I have just plugged it in and I get this on dmesg:
> >>
> >> [ 1365.932522] usb 2-1.1: new full-speed USB device number 26 using
> >> ehci_hcd [ 1366.073145] usb 2-1.1: New USB device found, idVendor=07d0,
> >> idProduct=0004 [ 1366.073153] usb 2-1.1: New USB device strings: Mfr=0,
> >> Product=0, SerialNumber=0 [ 1366.091741] usbvision_probe: Dazzle Fusion
> >> Model DVC-80 Rev 1 (PAL) found [ 1366.092072] USBVision[0]: registered
> >> USBVision Video device video1 [v4l2] [ 1366.092091] usbvision_probe:
> >> Dazzle Fusion Model DVC-80 Rev 1 (PAL) found [ 1366.092149]
> >> USBVision[1]: registered USBVision Video device video2 [v4l2] [
> >> 1366.092182] usbcore: registered new interface driver usbvision [
> >> 1366.092184] USBVision USB Video Device Driver for Linux : 0.9.11 [
> >> 1366.189268] saa7115 15-0025: saa7113 found (1f7113d0e100000) @ 0x4a
> >> (usbvision-2-1.1) [ 1366.319647] usb 2-1.1: selecting invalid altsetting
> >> 1
> >> [ 1366.319658] usb 2-1.1: cannot change alternate number to 1
> >> (error=-22)
> >>
> >> Device is recognized since it appears in lsusb:
> >>
> >> [skorzen@g62 ~]$ lsusb | grep DVC
> >> Bus 002 Device 026: ID 07d0:0004 Dazzle DVC-800 (PAL) Grabber
> >>
> >> However, I cannot make it work (my goal is to capture video from a
> >> camcorder).
> >> I've tried using cheese for this, but it just crashes and ABRT
> >> launches for me to fill a bug.
> >>
> >> Any ideas?
> >
> > Please include the output of "lsusb -v" for this device (run the command
> > as root).
>
> Here it is, mate. Thanks for your cooperation.
>
> Bus 002 Device 005: ID 07d0:0004 Dazzle DVC-800 (PAL) Grabber
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0         8
>   idVendor           0x07d0 Dazzle
>   idProduct          0x0004 DVC-800 (PAL) Grabber
>   bcdDevice            1.00
>   iManufacturer           0
>   iProduct                0
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          468
>     bNumInterfaces          2
>     bConfigurationValue     2
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x037f  1x 895 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       2
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x033f  1x 831 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       3
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x02ff  1x 767 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       4
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x02bf  1x 703 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       5
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x027f  1x 639 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       6
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x023f  1x 575 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       7
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x01ff  1x 511 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       8
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x01bf  1x 447 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       9
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x017f  1x 383 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting      10
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x013f  1x 319 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting      11
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00ff  1x 255 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting      12
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00bf  1x 191 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting      13
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x007f  1x 127 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting      14
>       bNumEndpoints           3
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            0
>           Transfer Type            Control
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x003f  1x 63 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0042  1x 66 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass         0 (Defined at Interface level)
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
> Device Status:     0x0000
>   (Bus Powered)
>
> Best regards,

Can you test this patch? It should make the driver ignore the second
interface with no endpoints.

--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1504,6 +1504,11 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
 		interface = &dev->actconfig->interface[usbvision_device_data[model].interface]->altsetting[0];
 	else
 		interface = &dev->actconfig->interface[ifnum]->altsetting[0];
+	if (interface->desc.bNumEndpoints < 1) {
+		dev_err(&intf->dev, "%s: interface %d. has no endpoints\n",
+		    __func__, ifnum);
+		return -ENODEV;
+	}
 	endpoint = &interface->endpoint[1].desc;
 	if (!usb_endpoint_xfer_isoc(endpoint)) {
 		dev_err(&intf->dev, "%s: interface %d. has non-ISO endpoint!\n",



-- 
Ondrej Zary
