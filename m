Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46884 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2DNMeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Apr 2012 08:34:50 -0400
Message-ID: <4F896EEA.8070201@Berthereau.net>
Date: Sat, 14 Apr 2012 14:34:50 +0200
From: Daniel <daniel.videodvb@berthereau.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: gennarone@gmail.com
Subject: Re: Add a new usb id for Elgato EyeTV DTT
References: <4F891F54.6030802@Berthereau.net> <4F894ADE.60703@gmail.com>
In-Reply-To: <4F894ADE.60703@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 14/04/2012 12:01, Gianluca Gennari wrote:
> Il 14/04/2012 08:55, Daniel ha scritto:
>> Hi,
>>
>> I've got an Elgato EyeTV for Mac and PC
>> (http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_DTT). It is given as
>> compatible since Linux 2.6.31, but the usb id can be not only 0fd9:0021,
>> but 0fd9:003f too. This id is currently not recognized...
>>
>> Some pages explain how to change the id (see
>> http://ubuntuforums.org/archive/index.php/t-1510188.html,
>> http://ubuntuforums.org/archive/index.php/t-1756828.html and
>> https://sites.google.com/site/slackwarestuff/home/elgato-eyetv).
>>
>> Why this id is not included by default? When will it be included in the
>> code?
>>
>> Sincerely,
>>
> Hi Daniel,
> new USB PIDs are added when someone reports on this list that they are
> working.
> That's exactly what you did, so now it's possible to add it.
> If you know how to do it, you can create a patch to add the new ID.
> Of course you have to define a new PID, as you cannot overwrite an
> existing PID like they suggest on the Ubuntu forums.
> If you don't know hot to do a patch, I can do it for you, as long as you
> are willing to test it.
>
> It would be nice to know the exact name of the new product. I see people
> reporting it as a new revision of the Elgato EyeTV DTT and others as the
> Elgato EyeTV Deluxe. Which one do you have exactly?
>
> Regards,
> Gianluca
Hi,

The exact name of the product is Elgato EyeTV DTT seen on LinuxTv.org 
(http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_DTT) and Elgato site 
(http://www.elgato.com/elgato/int/mainmenu/products/tuner/DTT08/product1.en.html).

With dmesg, it's:
usb 1-1: new high-speed USB device number 11 using ehci_hcd
usb 1-1: New USB device found, idVendor=0fd9, idProduct=003f
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: EyeTV DTT
usb 1-1: Manufacturer: Elgato
usb 1-1: SerialNumber: 005

With lsusb, it's:
Bus 001 Device 011: ID 0fd9:003f Elgato Systems GmbH
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0fd9 Elgato Systems GmbH
   idProduct          0x003f
   bcdDevice            1.00
   iManufacturer           1 Elgato
   iProduct                2 EyeTV DTT
   iSerial                 3 005
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

I use Debian Sid and Linux kernel 3.2 and 3.3 (64 bits).

Could you send me your package so I can check it?

Sincerely,

Daniel


