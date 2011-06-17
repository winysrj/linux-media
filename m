Return-path: <mchehab@pedra>
Received: from r02s01.colo.vollmar.net ([83.151.24.194]:54982 "EHLO
	holzeisen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab1FQKjf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 06:39:35 -0400
Message-ID: <4DFB2EE4.2030400@holzeisen.de>
Date: Fri, 17 Jun 2011 12:39:32 +0200
From: Thomas Holzeisen <thomas@holzeisen.de>
MIME-Version: 1.0
To: =?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>
CC: linux-media@vger.kernel.org,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: RTL2831U wont compile against 2.6.38
References: <4DF9BCAA.3030301@holzeisen.de> <4DF9EA62.2040008@killerhippy.de>
In-Reply-To: <4DF9EA62.2040008@killerhippy.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sascha,

this solution is not working for me. When compiling and installing the "media_build", it works
fine. Here in combination with a Digivox Duo Stick:

> Bus 002 Device 002: ID 1462:8801 Micro Star International

# lsmod | grep dvb
dvb_usb_af9015         21067  5
dvb_usb                22011  1 dvb_usb_af9015
dvb_core               67624  1 dvb_usb
rc_core                17813  12
dvb_usb_af9015,ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,dvb_usb,ir_rc5_decoder,rc_imon_pad,ir_nec_decoder,imon
i2c_core               18989  6 mxl5005s,af9013,nvidia,dvb_usb_af9015,dvb_usb,i2c_nforce2
usbcore                99058  11
lirc_imon,dvb_usb_af9015,dvb_usb,usbhid,imon,usb_storage,uas,ohci_hcd,ehci_hcd

One very strange behavior is, when theres no dvb-adapter at all, the system loads dvb_ttpci, but
no such card is installed, nor gets any /dev/dvb/ created or anything logged in dmsg:

# lsmod  | grep dvb
dvb_ttpci              71007  0
dvb_core               67624  1 dvb_ttpci
saa7146_vv             39558  1 dvb_ttpci
saa7146                17148  2 dvb_ttpci,saa7146_vv
ttpci_eeprom           12344  1 dvb_ttpci
i2c_core               18989  5 dvb_ttpci,videodev,ttpci_eeprom,nvidia,i2c_nforce2

Building and installing "new_build" as suggested, ends up with

# dmesg | grep dvb
[   26.828625] dvb_ttpci: Unknown symbol dvb_net_init (err 0)
[   26.830730] dvb_ttpci: Unknown symbol dvb_net_release (err 0)

Here no dvb-adapter was attached, now insert the rtl2831u ...

[  161.752088] usb 1-2: new high speed USB device using ehci_hcd and address 4
[  161.886020] usb 1-2: New USB device found, idVendor=14aa, idProduct=0160
[  161.886030] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  161.886036] usb 1-2: Product: DTV Receiver
[  161.886041] usb 1-2: Manufacturer: DTV Receiver
[  161.886046] usb 1-2: SerialNumber: 0000000000067936

... device got identified, but no module was loaded at all, doing it by hand ...

# modprobe -v dvb-usb-rtl2832u
WARNING: All config files need .conf: /etc/modprobe.d/usbhid, it will be ignored in a future release.
insmod /lib/modules/2.6.38-bpo.2-686/kernel/drivers/media/dvb/dvb-usb/dvb-usb.ko
WARNING: Error inserting dvb_usb
(/lib/modules/2.6.38-bpo.2-686/kernel/drivers/media/dvb/dvb-usb/dvb-usb.ko): Invalid argument
FATAL: Error inserting dvb_usb_rtl2832u
(/lib/modules/2.6.38-bpo.2-686/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl2832u.ko): Invalid argument

lets ignore the usbhid warning, its made out of comments anyway, checking dmsg ...

[  296.652984] dvb_usb: disagrees about version of symbol rc_register_device
[  296.652997] dvb_usb: Unknown symbol rc_register_device (err -22)
[  296.654001] dvb_usb: disagrees about version of symbol rc_free_device
[  296.654007] dvb_usb: Unknown symbol rc_free_device (err -22)
[  296.654823] dvb_usb: disagrees about version of symbol rc_allocate_device
[  296.654828] dvb_usb: Unknown symbol rc_allocate_device (err -22)
[  296.656427] dvb_usb: disagrees about version of symbol rc_unregister_device
[  296.656440] dvb_usb: Unknown symbol rc_unregister_device (err -22)

>From there on, those errors appear attaching any dvb-usb adapter i have, there seem to be a
problem. The rtl2831u adapter identifies as following and is labeled "Digitus DA-70781-B/A1" and
worked fine with Jan Hoogenraads driver under 2.6.32.

lsusb -v -s 001:004

Bus 001 Device 004: ID 14aa:0160 WideView Technology Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x14aa WideView Technology Inc.
  idProduct          0x0160
  bcdDevice            1.00
  iManufacturer           1 DTV Receiver
  iProduct                2 DTV Receiver
  iSerial                 3 0000000000067936
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           41
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 USB2.0-Bulk&Iso
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              5 Bulk-In, Interface
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              6 Iso-In, Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x03ac  1x 940 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      2
Device Status:     0x0000
  (Bus Powered)

Finally the kernel version (the only one installed):

# uname -a
Linux xbmc 2.6.38-bpo.2-686 #1 SMP Tue Jun 14 11:43:18 UTC 2011 i686 GNU/Linux

Greetings, from Germany as well ;-)
Thomas

Sascha Wüstemann wrote:
> Thomas Holzeisen wrote:
>> Hi there,
>>
>> I tried to get an RTL2831U dvb-t usb-stick running with a more recent kernel (2.6.38) and failed.
>>
>> The hg respository ~jhoogenraad/rtl2831-r2 aborts on countless drivers, the rc coding seem have to
>> changed a lot since it got touched the last time.
>>
>> The hg respository ~anttip/rtl2831u wont compile as well, since its even older.
>>
>> The recent git respositories for media_tree and anttip dont contain drivers for the rtl2831u.
>>
>> Has this device been abandoned, or is anyone working on it?
>>
>> greetings,
>> Thomas
> 
> There are still people working on it and there is new sources, e.g. look at
> http://www.spinics.net/lists/linux-media/msg24890.html
> at the very bottom. Worked like a charm at my system with kernel 2.6.39.
> 
> I think, there will be announcements later at
> http://wiki.zeratul.org/doku.php?id=linux:v4l:realtek:start
> 
> Greetings from Braunschweig, Germany.
> Sascha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

