Return-path: <mchehab@pedra>
Received: from mail-px0-f179.google.com ([209.85.212.179]:36396 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1DRJs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 05:48:59 -0400
Received: by pxi2 with SMTP id 2so3190113pxi.10
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 02:48:59 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Apr 2011 19:48:57 +1000
Message-ID: <BANLkTinV=2OW09Fz+NfM+qbO+SbgdKXChQ@mail.gmail.com>
Subject: Leadtek DTV2000DS half working
From: Ian Marshall <itmarshall@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

In July last year, I set up a Mythbuntu 10.04 system, which used a
Leadtek DTV2000DS (af9013/af9015) dual tuner PCI card. I used the 4.95
firmware, with the v4l compiled over the top of the 2.6.32 kernel, and
successfully got both tuners working.

A week ago, I bought a second DTV2000DS new, to increase the
concurrent recording capability of the box, thinking that it would be
a safe bet - one works, why not two? Unfortunately, I have been unable
to get the new card to work correctly.

I can get one of the two tuners on the new card to work, but the
second is being stubborn. In my dmesg log, I get the line "af9015:
firmware copy to 2nd frontend failed, will disable it", and no
"frontend0" device is created for the adapter. Down below, I have
pasted the output of "find /dev/dvb/", to show what device files are
being created. I have also pasted the dvb related lines from "dmesg".

After it initially failed with my existing kernel, I tried upgrading
to a 2.6.35 kernel, as that includes the drivers for the capture cards
by default. No luck.

I then found the page on the linux tv wiki
(http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV2000DS) and
followed all the instructions (including the fix for 5.1 firmware) and
still only got only one tuner working.

I also tried the 5.1 firmware, but it was worse, none of the blue
lights on either DTV card came on, so I am sticking with the 4.95
firmware for now!

To try and isolate whether it is a combination of both cards that's
causing problems, I tried uninstalling the original card, but that
just left me with one working tuner, so I put it back in to keep the
family happy.

I saw on the wiki page (and Google searches) that I am not the only
one having problems with the 2nd tuner. However, I think that I may be
in the unique position of having one working and one problematic card
- something must have changed in the hardware between the cards. I
have pasted in the output of the "lsusb" command - but the only
difference, apart from the bus number, is the "iManufacturer" line,
which is "1" for the working card, and "1 Afatech" for the new card.

My thinking is that some hardware has changed on Leadtek's end, but
not the model number, and that change is breaking the driver. A quick
visual inspection of the cards didn't show anything, but I didn't look
at individual chip identifications.

Is there anything anyone can suggest to look into to see what has
changed? Can my old/new combination in one PC help ferret out this
problem for those that only own the new card? (And also fix it for
me!)

Sorry for the length of this post, I hope that I haven't gone too far
in trying to get all the pertinent information in here!

Thanks,

Ian Marshall

----

Output of "find /dev/dvb/":

/dev/dvb/adapter3
/dev/dvb/adapter3/net0
/dev/dvb/adapter3/dvr0
/dev/dvb/adapter3/demux0
/dev/dvb/adapter2
/dev/dvb/adapter2/frontend0
/dev/dvb/adapter2/net0
/dev/dvb/adapter2/dvr0
/dev/dvb/adapter2/demux0
/dev/dvb/adapter1
/dev/dvb/adapter1/frontend0
/dev/dvb/adapter1/net0
/dev/dvb/adapter1/dvr0
/dev/dvb/adapter1/demux0
/dev/dvb/adapter0
/dev/dvb/adapter0/frontend0
/dev/dvb/adapter0/net0
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/demux0

Lines from "dmesg" (unrelated lines removed):

[   15.695132] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in cold
state, will try to load a firmware
[   15.746678] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[   15.817171] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in warm state.
[   15.817221] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   15.817567] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
[   15.882809] af9013: firmware version:4.95.0
[   15.886310] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
[   15.905524] tda18271 1-00c0: creating new instance
[   15.911875] TDA18271HD/C2 detected @ 1-00c0
[   16.277677] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   16.278075] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
[   17.013415] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
[   17.016041] af9013: firmware version:4.95.0
[   17.027414] DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
[   17.027555] tda18271 2-00c0: creating new instance
[   17.032539] TDA18271HD/C2 detected @ 2-00c0
[   17.390342] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:14.4/0000:03:05.2/usb3/3-1/input/input2
[   17.390389] dvb-usb: schedule remote query interval to 150 msecs.
[   17.390393] dvb-usb: Leadtek WinFast DTV2000DS successfully
initialized and connected.
[   17.894086] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in cold
state, will try to load a firmware
[   17.895515] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[   17.966737] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in warm state.
[   17.966786] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   17.967132] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
[   17.969229] af9013: firmware version:4.95.0
[   17.972732] DVB: registering adapter 2 frontend 0 (Afatech AF9013 DVB-T)...
[   17.972840] tda18271 5-00c0: creating new instance
[   17.978859] TDA18271HD/C2 detected @ 5-00c0
[   18.336712] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   18.337108] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
[   18.443267] af9015: command failed:2
[   18.443270] af9015: firmware copy to 2nd frontend failed, will disable it
[   18.443273] dvb-usb: no frontend was attached by 'Leadtek WinFast DTV2000DS'
[   18.443335] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:14.4/0000:03:06.2/usb4/4-1/input/input3
[   18.443378] dvb-usb: schedule remote query interval to 150 msecs.
[   18.443381] dvb-usb: Leadtek WinFast DTV2000DS successfully
initialized and connected.
[   18.565063] usbcore: registered new interface driver dvb_usb_af9015

Output from "lsusb -v -s 3:2" (the one that works):

Bus 003 Device 002: ID 0413:6a04 Leadtek Research, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0413 Leadtek Research, Inc.
  idProduct          0x6a04
  bcdDevice            2.00
  iManufacturer           1 Afatech
  iProduct                2 DVB-T 2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
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
      bNumEndpoints           4
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
Device Status:     0x0000
  (Bus Powered)

Output from "lsusb -v -s 4:2":

Bus 004 Device 002: ID 0413:6a04 Leadtek Research, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0413 Leadtek Research, Inc.
  idProduct          0x6a04
  bcdDevice            2.00
  iManufacturer           1 Afatech
  iProduct                2 DVB-T 2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
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
      bNumEndpoints           4
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
