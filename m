Return-path: <mchehab@pedra>
Received: from relay9.bol.com.br ([200.147.0.249]:58144 "EHLO
	relay9.bol.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab1BKOlJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Feb 2011 09:41:09 -0500
Received: from a2-salsa1.bol.com.br (a2-salsa1.host.intranet [10.129.137.0])
	by a1-sato2.bol.com.br (Postfix) with ESMTP id 8016E70001C1D
	for <linux-media@vger.kernel.org>; Fri, 11 Feb 2011 12:41:04 -0200 (BRST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by a2-salsa1.bol.com.br (Postfix) with ESMTP id 07B9C9C804A
	for <linux-media@vger.kernel.org>; Fri, 11 Feb 2011 12:39:33 -0200 (BRST)
Received: from a2-salsa1.adm.intranet (localhost.localdomain [127.0.0.1])
	by a2-salsa1.bol.com.br (Postfix) with ESMTP id 206FE9C8043
	for <linux-media@vger.kernel.org>; Fri, 11 Feb 2011 12:39:30 -0200 (BRST)
Received: from localhost.localdomain (a2-winter4.host.intranet [10.129.136.231])
	by a2-salsa1.adm.intranet (Postfix) with ESMTP id 9A045A0072
	for <linux-media@vger.kernel.org>; Fri, 11 Feb 2011 12:39:30 -0200 (BRST)
Date: Fri, 11 Feb 2011 12:39:30 -0200
From: jamenson@bol.com.br
To: linux-media@vger.kernel.org
Message-Id: <4d554a2295c4b_de09815034196@a2-winter4.tmail>
Subject: Siano SMS1140 DVB Receiver on Debian 5.0 (Lenny)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everyone.

I'm sorry if my question is a newbie question. I have a DVB receiver (Siano SMS1140).


<lsusb -v -d 187f:0201 >> lsusb.log> output:

Bus 002 Device 003: ID 187f:0201 Siano Mobile Silicon Nova B

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 2.00

bDeviceClass 0 (Defined at Interface level)

bDeviceSubClass 0

bDeviceProtocol 0

bMaxPacketSize0 64

idVendor 0x187f Siano Mobile Silicon

idProduct 0x0201 Nova B

bcdDevice 0.01

iManufacturer 1 Test EEPROM Manufacturer String

iProduct 2 Test EEPROM Product String

iSerial 0

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 32

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0

bmAttributes 0x80

(Bus Powered)

MaxPower 100mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 2

bInterfaceClass 255 Vendor Specific Class

bInterfaceSubClass 255 Vendor Specific Subclass

bInterfaceProtocol 255 Vendor Specific Protocol

iInterface 0

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 0

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x02 EP 2 OUT

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 0

Device Qualifier (for other device speed):

bLength 10

bDescriptorType 6

bcdUSB 2.00

bDeviceClass 255 Vendor Specific Class

bDeviceSubClass 255 Vendor Specific Subclass

bDeviceProtocol 255 Vendor Specific Protocol

bMaxPacketSize0 64

bNumConfigurations 1

Device Status: 0x0000

(Bus Powered)

__________________________________________________________________________________________________________________

syslogd output:

Jan 21 01:30:34 comp01 acpid: client connected from 3409[0:0]

Jan 21 02:00:09 comp01 kernel: [ 7588.475485] usb 2-1.2: new high speed USB device using ehci_hcd and address 3

Jan 21 02:00:10 comp01 kernel: [ 7588.569182] usb 2-1.2: configuration #1 chosen from 1 choice

Jan 21 02:00:10 comp01 kernel: [ 7588.569182] usb 2-1.2: New USB device found, idVendor=187f, idProduct=0201

Jan 21 02:00:10 comp01 kernel: [ 7588.569182] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0

Jan 21 02:00:10 comp01 kernel: [ 7588.569182] usb 2-1.2: Product: Test EEPROM Product String

Jan 21 02:00:10 comp01 kernel: [ 7588.569182] usb 2-1.2: Manufacturer: Test EEPROM Manufacturer String

Jan 21 02:00:10 comp01 NetworkManager: <debug> [1295586010.065552] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_187f_201_noserial').

Jan 21 02:00:10 comp01 NetworkManager: <debug> [1295586010.113148] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_187f_201_noserial_if0').

Jan 21 02:00:10 comp01 NetworkManager: <debug> [1295586010.123770] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_187f_201_noserial_usbraw').

_________________________________________________________________________________________________________________________

dmesg output:



[ 343.193191] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004

[ 343.193474] hub 2-1:1.0: port 2, status 0101, change 0001, 12 Mb/s

[ 343.297207] hub 2-1:1.0: debounce: port 2: total 100ms stable 100ms status 0x101

[ 343.308191] hub 2-1:1.0: port 2 not reset yet, waiting 10ms

[ 343.369999] usb 2-1.2: new high speed USB device using ehci_hcd and address 3

[ 343.380964] hub 2-1:1.0: port 2 not reset yet, waiting 10ms

[ 343.455532] usb 2-1.2: default language 0x0409

[ 343.456027] usb 2-1.2: udev 3, busnum 2, minor = 130

[ 343.456031] usb 2-1.2: New USB device found, idVendor=187f, idProduct=0201

[ 343.456035] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0

[ 343.456039] usb 2-1.2: Product: Test EEPROM Product String

[ 343.456042] usb 2-1.2: Manufacturer: Test EEPROM Manufacturer String

[ 343.456141] usb 2-1.2: usb_probe_device

[ 343.456146] usb 2-1.2: configuration #1 chosen from 1 choice

[ 343.456330] usb 2-1.2: adding 2-1.2:1.0 (config #1, interface 0)

[ 343.456456] drivers/usb/core/inode.c: creating file '003'

[ 343.578653] smsusb 2-1.2:1.0: usb_probe_interface

[ 343.578656] smsusb 2-1.2:1.0: usb_probe_interface - got id

[ 344.177738] smscore_set_device_mode: firmware download success: dvb_nova_12mhz_b0.inp

[ 344.178232] usbcore: registered new interface driver smsusb

_______________________________________________________________________________________________________________________

As you can see, driver is not registering the devices. So I did registration:

<ls -l /dev/bus/usb/002/003> output:

crw-rw-r-- 1 root root 189, 130 Fev 4 05:38 /dev/bus/usb/002/003

<cat /var/log/syslog | grep '04:30:40' | grep becomes> output:

Feb 4 04:30:40 comp01 udevd-event[2870]: udev_rules_get_name: rule applied, '2-1.2' becomes 'bus/usb/002/003'

Feb 4 04:30:40 comp01 udevd-event[2873]: udev_rules_get_name: rule applied, 'usbdev2.3' becomes 'bus/usb/002/003'

 

<ls -l /dev/dvb/adapter0/> output:

total 0

crwxrw-rw- 1 root root 189, 130 Fev 4 05:35 audio0

crwxrw-rw- 1 root root 189, 130 Fev 4 05:35 ca0

crwxrw-rw- 1 root root 189, 130 Fev 4 05:35 demux0

crwxrw-rw- 1 root root 189, 130 Fev 4 05:35 dvr0

crwxrw-rw- 1 root root 189, 130 Fev 4 05:35 frontend0

crwxrw-rw- 1 root root 189, 130 Fev 4 05:35 net0

crwxrw-rw- 1 root root 189, 130 Fev 4 05:35 osd0

crwxrw-rw- 1 root root 189, 130 Fev 4 05:35 video0


Unfortunatly <dvbtune -i> output is:

<transponder type="T" freq="0">

PAT - DMX_SET_FILTER:: Inappropriate ioctl for device

SDT - DMX_SET_FILTER:: Inappropriate ioctl for device

</transponder>

 

<scan -c> output is:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

main:2287: FATAL: FE_GET_INFO failed: 1 Operation not permitted

 

<w_scan -c BR -a 0> output is:

w_scan version 20100316 (compiled for DVB API 5.1)

using settings for BRAZIL

Country identifier BR not defined. Using defaults.

frontend_type DVB-T, channellist 4

output format vdr-1.6

-_-_-_-_ Getting frontend capabilities-_-_-_-_

main:2937: FATAL: FE_GET_INFO failed: 25 Inappropriate ioctl for device

________________________________________________________________________________________________________________________

I'm using kernel 2.6.37 (downloaded from kernel.org) with Debian GNU/Linux 5.0 (Lenny).

What should I do to solve this?

Thank you.

