Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.alice.nl ([217.149.195.8]:39220 "EHLO smtp.alice.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab0D1SaH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 14:30:07 -0400
Received: from [192.168.80.107] (93-125-200-5.dsl.alice.nl [93.125.200.5])
	by smtp.alice.nl (Postfix) with ESMTP id 107AFC1A0
	for <linux-media@vger.kernel.org>; Wed, 28 Apr 2010 20:29:59 +0200 (CEST)
Message-ID: <4BD87EA2.5090700@cobradevil.org>
Date: Wed, 28 Apr 2010 20:29:54 +0200
From: william <kc@cobradevil.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: debugging my Tevii S660 usb 2.0 dvb-s2 device
References: <59062.192.87.141.196.1272466066.squirrel@webmail.spothost.nl>
In-Reply-To: <59062.192.87.141.196.1272466066.squirrel@webmail.spothost.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First some additional info.

my current dmesg is full with messages like:
[93953.934121] ds3000_readreg: read reg 0xfe, value 0x92
[93953.934128] ds3000_writereg: write reg 0xfe, value 0x9b
[93953.953980] ds3000_writereg: write reg 0x29, value 0x80
[93953.974481] ds3000_writereg: write reg 0x25, value 0x8a
[93953.991359] ds3000_writereg: write reg 0xc3, value 0x06
[93954.030037] ds3000_writereg: write reg 0xc8, value 0x0a
[93954.050038] ds3000_writereg: write reg 0xc4, value 0x05
[93954.070040] ds3000_writereg: write reg 0xc7, value 0x24
[93954.090041] ds3000_writereg: write reg 0x61, value 0xab
[93954.110048] ds3000_writereg: write reg 0x62, value 0x3a
[93954.130037] ds3000_writereg: write reg 0x56, value 0x00
[93954.150036] ds3000_writereg: write reg 0x76, value 0x00
[93954.170041] ds3000_writereg: write reg 0x00, value 0x00
[93954.212100] ds3000_writereg: write reg 0xb2, value 0x00

filename:       
/lib/modules/2.6.33-020633-generic/kernel/drivers/media/dvb/frontends/ds3000.ko
license:        GPL
author:         Konstantin Dimitrov
description:    DVB Frontend module for Montage Technology DS3000/TS2020 
hardware
srcversion:     68E19175166A175DA0F8DA5
depends:
vermagic:       2.6.33-020633-generic SMP mod_unload modversions
parm:           debug:Activates frontend debugging (default:0) (int)


filename:       
/lib/modules/2.6.33-020633-generic/kernel/drivers/media/dvb/dvb-usb/teviis660.ko
license:        GPL
version:        0.2
description:    Driver for TEVII S660
author:         Bob Liu
srcversion:     12CD426AC8F3EB7F840E7F8
alias:          usb:v04B4pD660d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v9022pD660d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb
vermagic:       2.6.33-020633-generic SMP mod_unload modversions
parm:           debug:set debugging level (1=info 2=xfer (or-able)). (int)
parm:           adapter_nr:DVB adapter numbers (array of short)


after unloading and loading i get:

[94168.701559] dvb-usb: found a 'TEVII S660 DVBS2 USB2.0' in cold state, 
will try to load a firmware
[94168.701576] usb 1-3: firmware: requesting dvb-usb-teviis660.fw
[94168.741456] dvb-usb: downloading firmware from file 
'dvb-usb-teviis660.fw'
[94168.741473] usb 1-3: firmware: requesting dvb-usb-teviis660.fw
[94168.753227] teviis660: start downloading TEVIIS660 firmware
[94169.100046] dvb-usb: found a 'TEVII S660 DVBS2 USB2.0' in warm state.
[94169.100161] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[94169.100331] DVB: registering new adapter (TEVII S660 DVBS2 USB2.0)
[94169.229153] dvb-usb: MAC address: 00:18:bd:5c:54:7f
[94169.284778] ds3000_attach
[94169.300277] ds3000_readreg: read reg 0x00, value 0xe0
[94169.320273] ds3000_readreg: read reg 0x01, value 0xc0
[94169.340272] ds3000_readreg: read reg 0x02, value 0x00
[94169.340279] DS3000 chip version: 0.192 attached.
[94169.340285] S660: DS3000 attached.
[94169.340293] DVB: registering adapter 0 frontend 0 (Montage Technology 
DS3000/TS2020)...
[94169.341773] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input6
[94169.341911] dvb-usb: schedule remote query interval to 150 msecs.
[94169.341925] dvb-usb: TEVII S660 DVBS2 USB2.0 successfully initialized 
and connected.
[94169.342015] usbcore: registered new interface driver teviis660

this is the output from lsusb -v for the tevii device

Bus 001 Device 003: ID 9022:d660
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x9022
   idProduct          0xd660
   bcdDevice            0.00
   iManufacturer           1 TBS-Tech
   iProduct                2 DVBS2BOX
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           32
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
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
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval               0
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


Femon is giving me the following output:

FE: Montage Technology DS3000/TS2020 (DVBS)
Problem retrieving frontend information: Success
status SCVYL | signal  73% | snr   0% | ber 1590282272 | unc 1590282296 
| FE_HAS_LOCK
Problem retrieving frontend information: Success
status SCVYL | signal  73% | snr   0% | ber 1590282272 | unc 1590282296 
| FE_HAS_LOCK



Hope this helps a bit.

If any other info would be needed, i will try to collect that info.

With kind regards

William van de Velde


On 04/28/2010 04:47 PM, kc@cobradevil.org wrote:
> Hello all,
>
> I have bought a new tevii s660 device in december 3 months later
> (backorder) when i received my device i was having issues when loading the
> driver from the tevii website.
> First loading went ok but then i got hundreds of debug messages in dmesg.
> Later this device really died so i sent it back for rma.
>
> Now i have received a new device but still have the same issues.
> I got the old drivers from Artem: Re: [vdr] System unresponsive and
> picture breakup with VDR 1.7.10  and Tevii S660 (USB) (thanks for helping
> out)
>
> But still  i have system freezes.
> and a channel scan freaks out my system and device.
>
> Does someone have time/ideas how to make this device work and how can i
> deliver the right info to make it happen.
> I'm no developer so programming is a problem but i'm happy to try patches
> if someone can help me out.
>
> So what info would be needed beside a dmesg/uname -a and how can i get the
> right information
> e.g. lsusb -vvv
>
> With kind regards
>
> William van de Velde
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

