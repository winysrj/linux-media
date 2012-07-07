Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59356 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GGT1V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2012 15:27:21 -0400
Received: by werb14 with SMTP id b14so7264855wer.19
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2012 12:27:20 -0700 (PDT)
MIME-Version: 1.0
From: Ben Barker <ben@bbarker.co.uk>
Date: Sat, 7 Jul 2012 20:27:00 +0100
Message-ID: <CALefuyj-7XGdRMRCcLPWPdXNF7EwowcggdG5gcu7ui=jEs9tiA@mail.gmail.com>
Subject: WinTV-Duet
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firstly, let me apologise if this is not an appropriate place to ask
what is not really a development question...

I have been playing around with the Hauppauge WinTV Duet dual USB tuner today.
dmesg seems happy when it is connected, and detects it as two devices

This:
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-Duet-HD-Stick

Suggests the device may be supported, though the "HD" vestion does not
seem to exist as far as I can tell.

I can run "scan" to get a channels list from the device no problem,
and whilst VLC will not play from it, tzap works fine.
Using mplayer I can access either tuner - but not both at once - so:

mplayer "dvb://0@" works, as does mplayer "dvb://1@", but not both
together, which whichever is second giving:

ERROR OPENING FRONTEND DEVICE /dev/dvb/adapter0/frontend0: ERRNO 16
DVB_SET_CHANNEL2, COULDN'T OPEN DEVICES OF CARD: 0, EXIT
ERROR, COULDN'T SET CHANNEL  0: Failed to open dvb://1@.

dmesg reveals:

[   17.402977] DiB0070: successfully identified
[   17.402984] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   17.403290] DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))
[   17.502811] [drm] fb mappable at 0xE0142000
[   17.502815] [drm] vram apper at 0xE0000000
[   17.502817] [drm] size 9216000
[   17.502819] [drm] fb depth is 24
[   17.502821] [drm]    pitch is 7680
[   17.502945] fbcon: radeondrmfb (fb0) is primary device
[   17.503041] Console: switching to colour frame buffer device 100x37
[   17.503063] fb0: radeondrmfb frame buffer device
[   17.503065] drm: registered panic notifier
[   17.503073] [drm] Initialized radeon 2.10.0 20080528 for
0000:02:00.0 on minor 0
[   17.503517] ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
[   17.503526] HDA Intel 0000:02:00.1: PCI INT B -> Link[APC5] -> GSI
16 (level, low) -> IRQ 16
[   17.503604] HDA Intel 0000:02:00.1: irq 43 for MSI/MSI-X
[   17.503635] HDA Intel 0000:02:00.1: setting latency timer to 64
[   17.546958] HDMI status: Pin=3 Presence_Detect=0 ELD_Valid=0
[   17.547313] input: HDA ATI HDMI HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:09.0/0000:02:00.1/sound/card2/input6
[   17.588731] DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
[   17.722284] scsi 4:0:0:0: Direct-Access     Generic  Flash HS-CF
  5.39 PQ: 0 ANSI: 0
[   17.725421] scsi 4:0:0:1: Direct-Access     Generic  Flash HS-COMBO
  5.39 PQ: 0 ANSI: 0
[   17.806976] DiB0070: successfully identified
[   17.832059] Registered IR keymap rc-dib0700-rc5
[   17.832229] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb1/1-7/rc/rc1/input7
[   17.832314] rc1: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb1/1-7/rc/rc1
[   17.833518] dvb-usb: schedule remote query interval to 50 msecs.
[   17.833525] dvb-usb: Hauppauge Nova-TD Stick (52009) successfully
initialized and connected.

Whilst lsusb -d 2040:5200 -v gives:

Bus 001 Device 004: ID 2040:5200 Hauppauge
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x2040 Hauppauge
  idProduct          0x5200
  bcdDevice            0.01
  iManufacturer           1 Hauppauge
  iProduct                2 NovaT 500Stick
  iSerial                 3 4034702860
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
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              10
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

There is also a PCI tuner installed (DVB-T 500) - but this is working
fine and has done for a while.

Can anybody offer any suggestions?
