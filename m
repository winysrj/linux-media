Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <little.linux.girl@gmail.com>) id 1L8ipw-00032F-PU
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 23:07:49 +0100
Received: by ey-out-2122.google.com with SMTP id 25so87899eya.17
	for <linux-dvb@linuxtv.org>; Fri, 05 Dec 2008 14:07:45 -0800 (PST)
Message-ID: <9e27f5bf0812051407g687a280ao7d9599a4bebcab8@mail.gmail.com>
Date: Fri, 5 Dec 2008 23:07:44 +0100
From: "litlle girl" <little.linux.girl@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] EMTEC S826 (ID 1164:1f08 YUAN STK7700D)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0654064641=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0654064641==
Content-Type: multipart/alternative;
	boundary="----=_Part_45857_928416.1228514864915"

------=_Part_45857_928416.1228514864915
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,
im trying my friends usb tv card EMTEC S826 to run on my linux,
so far without succes :(
I can make further test with this device if somebody has idea what is wrong.
Will this device be supported in linux?
Which usb stick you advice to use with linux?
(is any hybrid analog/digital stick fully supported with linux?)
Regards,
LLG

my kernel:      2.6.27 SMP x86_64
v4l version:
 v4l-dvb-7100e78482d7.tar.bz2   (md5sum 14cd47ad149ec1515ce20ff0b2f03354)
firmware:
 dvb-usb-dib0700-1.20.fw        (md5sum f42f86e2971fd994003186a055813237)
 xc3028-v27.fw                  (md5sum 293dc5e915d9a0f74a368f8a2ce3cc10)

lsusb -vv:
Bus 001 Device 002: ID 1164:1f08 YUAN High-Tech Development Co., Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1164 YUAN High-Tech Development Co., Ltd
  idProduct          0x1f08
  bcdDevice            1.00
  iManufacturer           1 YUANRD
  iProduct                2 STK7700D
  iSerial                 3 0000000001
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

plug usb stick -> messages:
Dec  4 21:07:33 FuSioN usb 1-5: new high speed USB device using ehci_hcd and
address 2
Dec  4 21:07:33 FuSioN usb 1-5: configuration #1 chosen from 1 choice
Dec  4 21:07:33 FuSioN usb 1-5: New USB device found, idVendor=1164,
idProduct=1f08
Dec  4 21:07:33 FuSioN usb 1-5: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
Dec  4 21:07:33 FuSioN usb 1-5: Product: STK7700D
Dec  4 21:07:33 FuSioN usb 1-5: Manufacturer: YUANRD
Dec  4 21:07:33 FuSioN usb 1-5: SerialNumber: 0000000001
Dec  4 21:07:33 FuSioN dib0700: loaded with support for 8 different
device-types
Dec  4 21:07:33 FuSioN dvb-usb: found a 'YUAN High-Tech STK7700PH' in cold
state, will try to load a firmware
Dec  4 21:07:33 FuSioN firmware: requesting dvb-usb-dib0700-1.20.fw
Dec  4 21:07:33 FuSioN dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
Dec  4 21:07:34 FuSioN dib0700: firmware started successfully.
Dec  4 21:07:34 FuSioN dvb-usb: found a 'YUAN High-Tech STK7700PH' in warm
state.
Dec  4 21:07:34 FuSioN dvb-usb: will pass the complete MPEG2 transport
stream to the software demuxer.
Dec  4 21:07:34 FuSioN DVB: registering new adapter (YUAN High-Tech
STK7700PH)
Dec  4 21:07:34 FuSioN DVB: registering adapter 0 frontend 0 (DiBcom
7000PC)...
Dec  4 21:07:34 FuSioN xc2028 4-0061: creating new instance
Dec  4 21:07:34 FuSioN xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
Dec  4 21:07:34 FuSioN input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb1/1-5/input/input7
Dec  4 21:07:34 FuSioN dvb-usb: schedule remote query interval to 150 msecs.
Dec  4 21:07:34 FuSioN dvb-usb: YUAN High-Tech STK7700PH successfully
initialized and connected.
Dec  4 21:07:34 FuSioN usbcore: registered new interface driver
dvb_usb_dib0700
(Red led on usb stick turns on)

ls /dev/dvb/adapter0/:
demux0  dvr0  frontend0  net0

dvbscan /usr/share/dvb/dvb-t/* -vv -> messages:
Dec  4 21:08:04 FuSioN firmware: requesting xc3028-v27.fw
Dec  4 21:08:04 FuSioN xc2028 4-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Dec  4 21:08:04 FuSioN xc2028 4-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000.
Dec  4 21:08:11 FuSioN xc2028 4-0061: Loading firmware for type=D2620 DTV8
(208), id 0000000000000000.
Dec  4 21:08:11 FuSioN xc2028 4-0061: Loading SCODE for type=DTV7 DTV78 DTV8
DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0000000000000000.

dvbscan /usr/share/dvb/dvb-t/* -vv:
scanning /usr/share/dvb/dvb-t/*
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 530000000 0 2 9 3 1 0 0
>>> tune to:
530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:T
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
WARNING: >>> tuning failed!!!
>>> tune to:
530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:T
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

------=_Part_45857_928416.1228514864915
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,<br>im trying my friends usb tv card EMTEC S826 to run on my linux,<br>so far without succes :(<br>I can make further test with this device if somebody has idea what is wrong.<br>Will this device be supported in linux?<br>
Which usb stick you advice to use with linux?<br>(is any hybrid analog/digital stick fully supported with linux?)<br>Regards,<br>LLG<br><br>my kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.27 SMP x86_64<br>v4l version:<br>&nbsp;v4l-dvb-7100e78482d7.tar.bz2&nbsp;&nbsp; (md5sum 14cd47ad149ec1515ce20ff0b2f03354)<br>
firmware:<br>&nbsp;dvb-usb-dib0700-1.20.fw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (md5sum f42f86e2971fd994003186a055813237)<br>&nbsp;xc3028-v27.fw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (md5sum 293dc5e915d9a0f74a368f8a2ce3cc10)<br><br>lsusb -vv:<br>Bus 001 Device 002: ID 1164:1f08 YUAN High-Tech Development Co., Ltd<br>
Device Descriptor:<br>&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18<br>&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>&nbsp; bcdUSB&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.00<br>&nbsp; bDeviceClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 (Defined at Interface level)<br>&nbsp; bDeviceSubClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&nbsp; bDeviceProtocol&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
&nbsp; bMaxPacketSize0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 64<br>&nbsp; idVendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0x1164 YUAN High-Tech Development Co., Ltd<br>&nbsp; idProduct&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0x1f08<br>&nbsp; bcdDevice&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.00<br>&nbsp; iManufacturer&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 YUANRD<br>&nbsp; iProduct&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 STK7700D<br>
&nbsp; iSerial&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 0000000001<br>&nbsp; bNumConfigurations&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>&nbsp; Configuration Descriptor:<br>&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9<br>&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp; wTotalLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 46<br>&nbsp;&nbsp;&nbsp; bNumInterfaces&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
&nbsp;&nbsp;&nbsp; bConfigurationValue&nbsp;&nbsp;&nbsp;&nbsp; 1<br>&nbsp;&nbsp;&nbsp; iConfiguration&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0xa0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (Bus Powered)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Remote Wakeup<br>&nbsp;&nbsp;&nbsp; MaxPower&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 500mA<br>&nbsp;&nbsp;&nbsp; Interface Descriptor:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterfaceNumber&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bAlternateSetting&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bNumEndpoints&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterfaceClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 255 Vendor Specific Class<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterfaceSubClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterfaceProtocol&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iInterface&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Endpoint Descriptor:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bEndpointAddress&nbsp;&nbsp;&nbsp;&nbsp; 0x01&nbsp; EP 1 OUT<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Transfer Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bulk<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Synch Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Usage Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wMaxPacketSize&nbsp;&nbsp;&nbsp;&nbsp; 0x0200&nbsp; 1x 512 bytes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Endpoint Descriptor:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bEndpointAddress&nbsp;&nbsp;&nbsp;&nbsp; 0x81&nbsp; EP 1 IN<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Transfer Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bulk<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Synch Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Usage Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wMaxPacketSize&nbsp;&nbsp;&nbsp;&nbsp; 0x0200&nbsp; 1x 512 bytes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Endpoint Descriptor:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bEndpointAddress&nbsp;&nbsp;&nbsp;&nbsp; 0x82&nbsp; EP 2 IN<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Transfer Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bulk<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Synch Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Usage Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wMaxPacketSize&nbsp;&nbsp;&nbsp;&nbsp; 0x0200&nbsp; 1x 512 bytes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Endpoint Descriptor:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bEndpointAddress&nbsp;&nbsp;&nbsp;&nbsp; 0x83&nbsp; EP 3 IN<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bmAttributes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Transfer Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bulk<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Synch Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Usage Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wMaxPacketSize&nbsp;&nbsp;&nbsp;&nbsp; 0x0200&nbsp; 1x 512 bytes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bInterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
Device Qualifier (for other device speed):<br>&nbsp; bLength&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10<br>&nbsp; bDescriptorType&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6<br>&nbsp; bcdUSB&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.00<br>&nbsp; bDeviceClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 (Defined at Interface level)<br>&nbsp; bDeviceSubClass&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
&nbsp; bDeviceProtocol&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>&nbsp; bMaxPacketSize0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 64<br>&nbsp; bNumConfigurations&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>Device Status:&nbsp;&nbsp;&nbsp;&nbsp; 0x0000<br>&nbsp; (Bus Powered)<br><br>plug usb stick -&gt; messages:<br>Dec&nbsp; 4 21:07:33 FuSioN usb 1-5: new high speed USB device using ehci_hcd and address 2<br>
Dec&nbsp; 4 21:07:33 FuSioN usb 1-5: configuration #1 chosen from 1 choice<br>Dec&nbsp; 4 21:07:33 FuSioN usb 1-5: New USB device found, idVendor=1164, idProduct=1f08<br>Dec&nbsp; 4 21:07:33 FuSioN usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3<br>
Dec&nbsp; 4 21:07:33 FuSioN usb 1-5: Product: STK7700D<br>Dec&nbsp; 4 21:07:33 FuSioN usb 1-5: Manufacturer: YUANRD<br>Dec&nbsp; 4 21:07:33 FuSioN usb 1-5: SerialNumber: 0000000001<br>Dec&nbsp; 4 21:07:33 FuSioN dib0700: loaded with support for 8 different device-types<br>
Dec&nbsp; 4 21:07:33 FuSioN dvb-usb: found a &#39;YUAN High-Tech STK7700PH&#39; in cold state, will try to load a firmware<br>Dec&nbsp; 4 21:07:33 FuSioN firmware: requesting dvb-usb-dib0700-1.20.fw<br>Dec&nbsp; 4 21:07:33 FuSioN dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.20.fw&#39;<br>
Dec&nbsp; 4 21:07:34 FuSioN dib0700: firmware started successfully.<br>Dec&nbsp; 4 21:07:34 FuSioN dvb-usb: found a &#39;YUAN High-Tech STK7700PH&#39; in warm state.<br>Dec&nbsp; 4 21:07:34 FuSioN dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
Dec&nbsp; 4 21:07:34 FuSioN DVB: registering new adapter (YUAN High-Tech STK7700PH)<br>Dec&nbsp; 4 21:07:34 FuSioN DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...<br>Dec&nbsp; 4 21:07:34 FuSioN xc2028 4-0061: creating new instance<br>
Dec&nbsp; 4 21:07:34 FuSioN xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner<br>Dec&nbsp; 4 21:07:34 FuSioN input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb1/1-5/input/input7<br>Dec&nbsp; 4 21:07:34 FuSioN dvb-usb: schedule remote query interval to 150 msecs.<br>
Dec&nbsp; 4 21:07:34 FuSioN dvb-usb: YUAN High-Tech STK7700PH successfully initialized and connected.<br>Dec&nbsp; 4 21:07:34 FuSioN usbcore: registered new interface driver dvb_usb_dib0700<br>(Red led on usb stick turns on)<br><br>
ls /dev/dvb/adapter0/:<br>demux0&nbsp; dvr0&nbsp; frontend0&nbsp; net0<br><br>dvbscan /usr/share/dvb/dvb-t/* -vv -&gt; messages:<br>Dec&nbsp; 4 21:08:04 FuSioN firmware: requesting xc3028-v27.fw<br>Dec&nbsp; 4 21:08:04 FuSioN xc2028 4-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7<br>
Dec&nbsp; 4 21:08:04 FuSioN xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.<br>Dec&nbsp; 4 21:08:11 FuSioN xc2028 4-0061: Loading firmware for type=D2620 DTV8 (208), id 0000000000000000.<br>Dec&nbsp; 4 21:08:11 FuSioN xc2028 4-0061: Loading SCODE for type=DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0000000000000000.<br>
<br>dvbscan /usr/share/dvb/dvb-t/* -vv:<br>scanning /usr/share/dvb/dvb-t/*<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>initial transponder 530000000 0 2 9 3 1 0 0<br>&gt;&gt;&gt; tune to: 530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:T<br>
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>
&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:T<br>RANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>
&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>
&gt;&gt;&gt; tuning status == 0x01<br>&gt;&gt;&gt; tuning status == 0x01<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>ERROR: initial tuning failed<br>dumping lists (0 services)<br>Done.<br><br>

------=_Part_45857_928416.1228514864915--


--===============0654064641==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0654064641==--
