Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38951 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab3KFSNc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 13:13:32 -0500
Message-ID: <527A86CA.6040900@iki.fi>
Date: Wed, 06 Nov 2013 20:13:30 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rodolphe M <rudy1210@free.fr>, linux-media@vger.kernel.org
Subject: Re: em28xx: new board id [0213:0258]
References: <52531ADE.3000107@free.fr>
In-Reply-To: <52531ADE.3000107@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for top posting, but I just posted driver for that stick! Look 
latest LMML messages.

regards
Antti


On 07.10.2013 23:34, Rodolphe M wrote:
> Hello
>
> Got this DVB-S2 USB stick from PCTV Model 461e.
>
> Firmware for 460e does not work. Chipset must be different.
>
> Here are data from Windows driver : PCTV Empia
>
> PCTVEMP_x86_x64.inf
>
> %PCTV461e.DeviceDesc% = USB28179_461e,USB\VID_2013&PID_0258           ;
> PCTV 461e
>
> [USB28179_461e.NTx86]
> Include       = ks.inf, kscaptur.inf, ksfilter.inf, bda.inf
> Needs         = KS.Registration, KSCAPTUR.Registration.NT,
> BDA.Installation.NT
> DelReg          = OEM.DelReg, UTL.DelReg
> AddReg        = CAP.AddRegx86, OEM.AddReg, OEM.Defaults.AddReg,
> UTL.AddReg, OEM_461e.AddReg
> CopyFiles     = CAP.CopySYSx86, CAP.CopyDLLx86, UTL.CopyList
>
> [USB28179_461e.NTx86.HW]
> AddReg = InstFilter28xx
>
> [USB28179_461e.NTx86.Interfaces]
> AddInterface = %KSCATEGORY_BDA_RECEIVER%,%BDACapFilter%,
> BDACap28179.Interface
> AddInterface = %KSCATEGORY_BDA_TUNER%,
> %BDATunerFilter%,BDATuner28179.Interface
> AddInterface = %KSCATEGORY_BDA_TUNER%,
> %BDATunerFilterC%,BDATuner28179-C.Interface
> AddInterface = %KSCATEGORY_BDA_TUNER%,
> %BDATunerFilterS%,BDATuner28179-S.Interface
>
>
>
> lsusb -vvv
>
> Bus 001 Device 002: ID 2013:0258 PCTV Systems
> Couldn't open device, some information will be missing
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    idVendor           0x2013 PCTV Systems
>    idProduct          0x0258
>    bcdDevice            1.00
>    iManufacturer           3
>    iProduct                1
>    iSerial                 2
>    bNumConfigurations      1
>    Configuration Descriptor:
>      bLength                 9
>      bDescriptorType         2
>      wTotalLength           41
>      bNumInterfaces          1
>      bConfigurationValue     1
>      iConfiguration          0
>      bmAttributes         0x80
>        (Bus Powered)
>      MaxPower              500mA
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       0
>        bNumEndpoints           1
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass      0
>        bInterfaceProtocol      0
>        iInterface              0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x84  EP 4 IN
>          bmAttributes            1
>            Transfer Type            Isochronous
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0000  1x 0 bytes
>          bInterval               1
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       1
>        bNumEndpoints           1
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass      0
>        bInterfaceProtocol      0
>        iInterface              0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x84  EP 4 IN
>          bmAttributes            1
>            Transfer Type            Isochronous
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x03ac  1x 940 bytes
>          bInterval               1
>
>
> dmesg
>
> [    1.283468] usb 1-1: New USB device found, idVendor=2013, idProduct=0258
> [    1.283473] usb 1-1: New USB device strings: Mfr=3, Product=1,
> SerialNumber=2
> [    1.283476] usb 1-1: Product: PCTV 461
> [    1.283478] usb 1-1: Manufacturer: PCTV
> [    1.283481] usb 1-1: SerialNumber: 0011317106
>
>
> Thanks for helping to get this work...
>
> Cheerio
> Rudy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
