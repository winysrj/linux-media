Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37192 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdBBLSz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 06:18:55 -0500
Received: by mail-wm0-f48.google.com with SMTP id v77so82948398wmv.0
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2017 03:18:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161130090229.GB639@shambles.local>
References: <20161118220107.GA3510@shambles.local> <20161120132948.GA23247@gofer.mess.org>
 <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
 <20161122092043.GA8630@gofer.mess.org> <20161123123851.GB14257@shambles.local>
 <20161123223419.GA25515@gofer.mess.org> <20161124121253.GA17639@shambles.local>
 <20161124133459.GA32385@gofer.mess.org> <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
 <20161127193510.GA20548@gofer.mess.org> <20161130090229.GB639@shambles.local>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Thu, 2 Feb 2017 22:18:52 +1100
Message-ID: <CAEsFdVOb8tWN=6OfnpdJqb9BZ4s-DARF53zgbyhz-_a0zac0Gg@mail.gmail.com>
Subject: Re: ir-keytable: infinite loops, segfaults
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey there

On 11/30/16, Vincent McIntyre <vincent.mcintyre@gmail.com> wrote:
> On Sun, Nov 27, 2016 at 07:35:10PM +0000, Sean Young wrote:
>>
>> > I wanted to mention that the IR protocol is still showing as unknown.
>> > Is there anything that can be done to sort that out?
>>
>> It would be nice if that could be sorted out, although that would be
>> a separate patch.
>>
>> So all we know right now is what scancode the IR receiver hardware
>> produces but we have no idea what IR protocol is being used. In order to
>> figure this out we need a recording of the IR the remote sends, for which
>> a different IR receiver is needed. Neither your imon nor your
>> dvb_usb_af9035 can do this, something like a mce usb IR receiver would
>> be best. Do you have access to one? One with an IR emitter would be
>> best.
>>
>> So with that we can have a recording of the IR the remote sends, and
>> with the emitter we can see which IR protocols the IR receiver
>> understands.
>
> Haven't been able to find anything suitable. I would order something
> but I won't be able to follow up for several weeks.
> I'll ask on the myth list to see if anyone is up for trying this.
>

I bought one of these, but I am not sure how to make the recording:

# lsusb -d 1934:5168 -v

Bus 008 Device 003: ID 1934:5168 Feature Integration Technology Inc.
(Fintek) F71610A or F71612A Consumer Infrared Receiver/Transceiver
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        16
  idVendor           0x1934 Feature Integration Technology Inc. (Fintek)
  idProduct          0x5168 F71610A or F71612A Consumer Infrared
Receiver/Transceiver
  bcdDevice            0.01
  iManufacturer           1 FINTEK
  iProduct                2 eHome Infrared Transceiver
  iSerial                 3 88636562727801
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
Device Status:     0x0000
  (Bus Powered)


# ir-keytable -v
Found device /sys/class/rc/rc0/
Found device /sys/class/rc/rc1/
Found device /sys/class/rc/rc2/
Found device /sys/class/rc/rc3/                          <---- the new device
Input sysfs node is /sys/class/rc/rc0/input8/
Event sysfs node is /sys/class/rc/rc0/input8/event5/
Parsing uevent /sys/class/rc/rc0/input8/event5/uevent
/sys/class/rc/rc0/input8/event5/uevent uevent MAJOR=13
/sys/class/rc/rc0/input8/event5/uevent uevent MINOR=69
/sys/class/rc/rc0/input8/event5/uevent uevent DEVNAME=input/event5
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-imon-mce
/sys/class/rc/rc0/uevent uevent DRV_NAME=imon
input device is /dev/input/event5
/sys/class/rc/rc0/protocols protocol rc-6 (enabled)
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
	Driver imon, table rc-imon-mce
	Supported protocols: rc-6
	Enabled protocols: rc-6
	Name: iMON Remote (15c2:ffdc)
	bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
	Repeat delay = 500 ms, repeat period = 125 ms
Input sysfs node is /sys/class/rc/rc1/input18/
Event sysfs node is /sys/class/rc/rc1/input18/event15/
Parsing uevent /sys/class/rc/rc1/input18/event15/uevent
/sys/class/rc/rc1/input18/event15/uevent uevent MAJOR=13
/sys/class/rc/rc1/input18/event15/uevent uevent MINOR=79
/sys/class/rc/rc1/input18/event15/uevent uevent DEVNAME=input/event15
Parsing uevent /sys/class/rc/rc1/uevent
/sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
/sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
input device is /dev/input/event15
/sys/class/rc/rc1/protocols protocol unknown (disabled)
Found /sys/class/rc/rc1/ (/dev/input/event15) with:
	Driver dvb_usb_cxusb, table rc-dvico-mce
	Supported protocols: unknown
	Enabled protocols:
	Name: IR-receiver inside an USB DVB re
	bus: 3, vendor/product: 0fe9:db78, version: 0x827b
	Repeat delay = 500 ms, repeat period = 125 ms
Input sysfs node is /sys/class/rc/rc2/input19/
Event sysfs node is /sys/class/rc/rc2/input19/event16/
Parsing uevent /sys/class/rc/rc2/input19/event16/uevent
/sys/class/rc/rc2/input19/event16/uevent uevent MAJOR=13
/sys/class/rc/rc2/input19/event16/uevent uevent MINOR=80
/sys/class/rc/rc2/input19/event16/uevent uevent DEVNAME=input/event16
Parsing uevent /sys/class/rc/rc2/uevent
/sys/class/rc/rc2/uevent uevent NAME=rc-empty
/sys/class/rc/rc2/uevent uevent DRV_NAME=dvb_usb_af9035
input device is /dev/input/event16
/sys/class/rc/rc2/protocols protocol nec (disabled)
Found /sys/class/rc/rc2/ (/dev/input/event16) with:
	Driver dvb_usb_af9035, table rc-empty
	Supported protocols: nec
	Enabled protocols:
	Name: Leadtek WinFast DTV Dongle Dual
	bus: 3, vendor/product: 0413:6a05, version: 0x0200
	Repeat delay = 500 ms, repeat period = 125 ms
Input sysfs node is /sys/class/rc/rc3/input20/
 <---- new device
Event sysfs node is /sys/class/rc/rc3/input20/event2/
Parsing uevent /sys/class/rc/rc3/input20/event2/uevent
/sys/class/rc/rc3/input20/event2/uevent uevent MAJOR=13
/sys/class/rc/rc3/input20/event2/uevent uevent MINOR=66
/sys/class/rc/rc3/input20/event2/uevent uevent DEVNAME=input/event2
Parsing uevent /sys/class/rc/rc3/uevent
/sys/class/rc/rc3/uevent uevent NAME=rc-rc6-mce
/sys/class/rc/rc3/uevent uevent DRV_NAME=mceusb
input device is /dev/input/event2
/sys/class/rc/rc3/protocols protocol other (disabled)
/sys/class/rc/rc3/protocols protocol unknown (disabled)
/sys/class/rc/rc3/protocols protocol rc-5 (disabled)
/sys/class/rc/rc3/protocols protocol nec (disabled)
/sys/class/rc/rc3/protocols protocol rc-6 (enabled)
/sys/class/rc/rc3/protocols protocol jvc (disabled)
/sys/class/rc/rc3/protocols protocol sony (disabled)
/sys/class/rc/rc3/protocols protocol rc-5-sz (disabled)
/sys/class/rc/rc3/protocols protocol sanyo (disabled)
/sys/class/rc/rc3/protocols protocol sharp (disabled)
/sys/class/rc/rc3/protocols protocol mce_kbd (disabled)
/sys/class/rc/rc3/protocols protocol xmp (disabled)
/sys/class/rc/rc3/protocols protocol cec (disabled)
/sys/class/rc/rc3/protocols protocol lirc (enabled)
Found /sys/class/rc/rc3/ (/dev/input/event2) with:
	Driver mceusb, table rc-rc6-mce
	Supported protocols: unknown other lirc rc-5 jvc sony nec sanyo
mce-kbd rc-6 sharp xmp
	Enabled protocols: lirc rc-6
	Name: Media Center Ed. eHome Infrared
	bus: 3, vendor/product: 1934:5168, version: 0x0001
	Repeat delay = 500 ms, repeat period = 125 ms


When I plugged it in, I got this in dmesg:

usb 8-1: new full-speed USB device number 3 using uhci_hcd
usb 8-1: New USB device found, idVendor=1934, idProduct=5168
usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 8-1: Product: eHome Infrared Transceiver
usb 8-1: Manufacturer: FINTEK
usb 8-1: SerialNumber: 88636562727801
Registered IR keymap rc-rc6-mce
input: Media Center Ed. eHome Infrared Remote Transceiver (1934:5168)
as /devices/pci0000:00/0000:00:1d.1/usb8/8-1/8-1:1.0/rc/rc3/input20
rc rc3: Media Center Ed. eHome Infrared Remote Transceiver (1934:5168)
as /devices/pci0000:00/0000:00:1d.1/usb8/8-1/8-1:1.0/rc/rc3
lirc_dev: IR Remote Control driver registered, major 241
rc rc3: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
IR LIRC bridge handler initialized
mceusb 8-1:1.0: Registered FINTEK eHome Infrared Transceiver with mce
emulator interface version 2
mceusb 8-1:1.0: 0 tx ports (0x0 cabled) and 2 rx sensors (0x1 active)
usbcore: registered new interface driver mceusb
IR RC6 protocol handler initialized

Poking around I see lirc has an irrecord program. Is that what I need?

Vince
