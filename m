Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <germano.paciocco@gmail.com>) id 1K1pz3-0000fD-7c
	for linux-dvb@linuxtv.org; Thu, 29 May 2008 23:48:33 +0200
Received: by yx-out-2324.google.com with SMTP id 8so404416yxg.41
	for <linux-dvb@linuxtv.org>; Thu, 29 May 2008 14:48:24 -0700 (PDT)
Message-ID: <8ffdeb6d0805291448oe0cb37coa5ae2a6fcc2308ea@mail.gmail.com>
Date: Thu, 29 May 2008 23:48:23 +0200
From: "Germano Paciocco" <germano.paciocco@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Problem with AF9015
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi.
I installed this device on a gentoo. I think I have made all correct
things. In fact I have no errors on dmesg (i post it below).
modules loaded are these:

af9013                 12868  1
dvb_usb_af9015         13252  0
dvb_usb                20684  1 dvb_usb_af9015
i2c_core               22336  5 mt2060,af9013,v4l2_common,dvb_usb,i2c_i801

I have downlaoded source with command "hg clone
http://linuxtv.org/hg/~anttip/af9015/" and compiled succesfully, but
kaffeine says that dvb device is af9013, and nothing is shown!
I downloades this firmware

http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw

and placed into /lib/firmware. It seems it is loaded correctly, how
you can see in the dmesg pasted below

Thank you in advance for the help.

here my lsusb

Bus 001 Device 009: ID 15a4:9016
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x15a4
  idProduct          0x9016
  bcdDevice            2.00
  iManufacturer           1 Afatech
  iProduct                2 DVB-T
  iSerial                 3 010101010600001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           71
    bNumInterfaces          2
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              16
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

and here my dmesg

May 29 23:30:15 jimi usb 1-4: new high speed USB device using ehci_hcd
and address 8
May 29 23:30:15 jimi usb 1-4: configuration #1 chosen from 1 choice
May 29 23:30:15 jimi af9015_usb_probe: interface:0
May 29 23:30:15 jimi af9015_identify_state: reply:01
May 29 23:30:15 jimi dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0
stick' in cold state, will try to load a firmware
May 29 23:30:15 jimi dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
May 29 23:30:15 jimi af9015_download_firmware:
May 29 23:30:15 jimi af9015_usb_probe: interface:1
May 29 23:30:15 jimi usb 1-4: USB disconnect, address 8
May 29 23:30:15 jimi dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
May 29 23:30:15 jimi dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
May 29 23:30:15 jimi usb 1-4: new high speed USB device using ehci_hcd
and address 9
May 29 23:30:16 jimi usb 1-4: configuration #1 chosen from 1 choice
May 29 23:30:16 jimi af9015_usb_probe: interface:0
May 29 23:30:16 jimi af9015_identify_state: reply:02
May 29 23:30:16 jimi dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0
stick' in warm state.
May 29 23:30:16 jimi dvb-usb: will pass the complete MPEG2 transport
stream to the software demuxer.
May 29 23:30:16 jimi DVB: registering new adapter (Afatech AF9015
DVB-T USB2.0 stick)
May 29 23:30:16 jimi af9015_eeprom_dump:
May 29 23:30:16 jimi 00: 2c 1f 97 0b 00 00 00 00 a4 15 16 90 00 02 01 02
May 29 23:30:16 jimi 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 31 32 31
May 29 23:30:16 jimi 20: 33 30 37 30 30 30 30 32 ff ff ff ff ff ff ff ff
May 29 23:30:16 jimi 30: 00 00 3a 01 00 08 02 00 1d 8d c4 04 82 ff ff ff
May 29 23:30:16 jimi 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
May 29 23:30:16 jimi 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
May 29 23:30:16 jimi 60: 66 00 61 00 74 00 65 00 63 00 68 00 0c 03 44 00
May 29 23:30:16 jimi 70: 56 00 42 00 2d 00 54 00 20 03 30 00 31 00 30 00
May 29 23:30:16 jimi 80: 31 00 30 00 31 00 30 00 31 00 30 00 36 00 30 00
May 29 23:30:16 jimi 90: 30 00 30 00 30 00 31 00 00 ff ff ff ff ff ff ff
May 29 23:30:16 jimi a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 29 23:30:16 jimi b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 29 23:30:16 jimi c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 29 23:30:16 jimi d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 29 23:30:16 jimi e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 29 23:30:16 jimi f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
May 29 23:30:16 jimi af9015_read_config: xtal:2 set adc_clock:28000
May 29 23:30:16 jimi af9015_read_config: IF1:36125
May 29 23:30:16 jimi af9015_read_config: MT2060 IF1:1220
May 29 23:30:16 jimi af9015_read_config: tuner id1:130
May 29 23:30:16 jimi af9015_read_config: spectral inversion:0
May 29 23:30:16 jimi af9013: firmware version:4.95.0
May 29 23:30:16 jimi DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
May 29 23:30:16 jimi af9015_tuner_attach:
May 29 23:30:16 jimi af9015_set_gpio: gpio:3 gpioval:03
May 29 23:30:16 jimi af9015_rw_udev: command failed: 2
May 29 23:30:16 jimi mt2060 I2C read failed
May 29 23:30:16 jimi dvb-usb: Afatech AF9015 DVB-T USB2.0 stick
successfully initialized and connected.
May 29 23:30:16 jimi af9015_init:
May 29 23:30:16 jimi af9015_init_endpoint: USB speed:3
May 29 23:30:16 jimi af9015_download_ir_table:
May 29 23:30:16 jimi input: Afatech DVB-T as /class/input/input12
May 29 23:30:16 jimi input: USB HID v1.01 Keyboard [Afatech DVB-T] on
usb-0000:00:1d.7-4

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
