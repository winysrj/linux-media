Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail16.syd.optusnet.com.au ([211.29.132.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1JsqdC-000788-Hc
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 04:40:52 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail16.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m452ec7X013381
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Mon, 5 May 2008 12:40:39 +1000
Received: from [192.168.200.201] (emma.home.pjama.net [192.168.200.201])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m452ePS5028130
	for <linux-dvb@linuxtv.org>; Mon, 5 May 2008 12:40:26 +1000 (EST)
Message-ID: <481E7399.1040909@optusnet.com.au>
Date: Mon, 05 May 2008 12:40:25 +1000
From: pjama <pjama@optusnet.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] probs with af901x on mythbuntu
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

Hi,
I have a DigitalNow TinyTwin DVB-T Receiver which I believe to be a Afatech 9015 (9013?) TV card on a USB stick. It works just fine in Windoze but I'm trying to get it going in MythBuntu 8.04.

I've compiled and installed the bleeding edge af9015-74e494a9496 drivers from http://linuxtv.org/hg/~anttip/af9015 and dvb-usb-af9015.fw ver 4.95.0 from http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/

however I cant get it to find any TV stations with kaffeine or scan. Kaffiene just doesn't find anything, scan gives me:

peter@SunU20:~$ sudo scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Brisbane
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Brisbane
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
main:2247: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 16 Device or resource busy
peter@SunU20:~$

Relevant stuff from dmesg

[   33.795048] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb1/1-2/1-2:1.1/input/input1
[   33.807958] input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2
....
[ 6666.511668] af9015_usb_probe: interface:0
[ 6666.513096] af9015_identify_state: reply:02
[ 6666.513101] dvb-usb: found a 'DigitalNow TinyTwin DVB-T Receiver' in warm state.
[ 6666.513517] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[ 6666.514236] DVB: registering new adapter (DigitalNow TinyTwin DVB-T Receiver)
[ 6666.514982] af9015_eeprom_dump:
[ 6666.546073] 00: 2a 88 9b 0b 00 00 00 00 d3 13 26 32 00 02 01 02
[ 6666.578049] 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 30 39 31
[ 6666.610025] 20: 34 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
[ 6666.642003] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 1e ff ff ff
[ 6666.673980] 40: ff ff ff ff ff 08 02 00 da 11 00 00 1e ff ff ff
[ 6666.705956] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[ 6666.737931] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
[ 6666.769901] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
[ 6666.801885] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
[ 6666.833861] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
[ 6666.865838] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 6666.897814] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 6666.929790] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 6666.961767] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 6666.993743] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 6667.025712] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 6667.027720] af9015_read_config: xtal:2 set adc_clock:28000
[ 6667.031717] af9015_read_config: IF1:4570
[ 6667.035715] af9015_read_config: MT2060 IF1:0
[ 6667.037704] af9015_read_config: tuner id1:30
[ 6667.039708] af9015_read_config: spectral inversion:0
[ 6667.045704] af9013: firmware version:4.73.0
[ 6667.045926] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[ 6667.046223] af9015_tuner_attach:
[ 6667.046228] af9015_set_gpio: gpio:1 gpioval:03
[ 6667.087916] mxl500x_attach: Attaching ...
[ 6667.087924] mxl500x_attach: MXL500x tuner succesfully attached
[ 6667.087929] dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully initialized and connected.
[ 6667.087933] af9015_init:
[ 6667.087936] af9015_init_endpoint: USB speed:3
[ 6667.109656] af9015_download_ir_table:
[ 6667.361511] usbcore: registered new interface driver dvb_usb_af9015


peter@SunU20:~$ sudo lsusb -v
[sudo] password for peter:

Bus 002 Device 002: ID 13d3:3226 IMC Networks
Device Descriptor:
 bLength                18
 bDescriptorType         1
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 idVendor           0x13d3 IMC Networks
 idProduct          0x3226
 bcdDevice            2.00
 iManufacturer           1 Afatech
 iProduct                2 DVB-T 2
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


Any assistance appreciated.

WARNING: I'm not all that familiar with TV cards/sticks in general please write slowly ;)

Peter 

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
