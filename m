Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from agogare.doit.wisc.edu ([144.92.197.211])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tonejc@math.wisc.edu>) id 1JkAXm-0005Xm-N1
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 06:07:19 +0200
MIME-version: 1.0
Received: from avs-daemon.smtpauth2.wiscmail.wisc.edu by
	smtpauth2.wiscmail.wisc.edu
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit)) id <0JZ50080A7F77V00@smtpauth2.wiscmail.wisc.edu> for
	linux-dvb@linuxtv.org; Thu, 10 Apr 2008 23:06:43 -0500 (CDT)
Received: from [192.168.200.10]
	(204-11-134-71.restechservices.net [204.11.134.71])
	by smtpauth2.wiscmail.wisc.edu
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit))
	with ESMTPSA id <0JZ500G9A7EXV570@smtpauth2.wiscmail.wisc.edu> for
	linux-dvb@linuxtv.org; Thu, 10 Apr 2008 23:06:38 -0500 (CDT)
Date: Thu, 10 Apr 2008 23:05:56 -0500 (CDT)
From: Jernej Tonejc <tonejc@math.wisc.edu>
To: linux-dvb@linuxtv.org
Message-id: <Pine.LNX.4.64.0804102256540.3892@garbadale.math.wisc.edu>
Subject: [linux-dvb] Pinnacle PCTV HD pro USB stick 801e
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

I was wondering if anyone is working on enabling this device under linux. 
I took it apart and it contains the following chips:

DIBcom 0700C-XCCXa-G
USB 2.0 D3LTK.1
0804-0100-C
-----------------
SAMSUNG
S5H1411X01-Y0
NOTKRSUI H0801
-----------------
XCeive
XC5000AQ
BK66326.1
0802MYE3
-----------------
Cirrus
5340CZZ
0748
-----------------
CONEXANT
CX25843-24Z
71035657
0742 KOREA
-----------------

It seems that all parts should be more or less supported. I played around 
with the code and managed to get the IR receiver to work, however the 
frontend and tuner do not get attached no matter what kind of combination 
I try. The firmware for DiBcom chip  gets loaded successfully. Output in 
dmesg:
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
...
input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb7/7-2/input/input20

The output of lsusb -v is

Bus 007 Device 023: ID 2304:023a Pinnacle Systems, Inc. [hex] 
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x2304 Pinnacle Systems, Inc. [hex]
   idProduct          0x023a
   bcdDevice            1.00
   iManufacturer           1 YUANRD
   iProduct                2 PCTV 801e
   iSerial                 3 01004E0F9F
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


Thanks,

   Jernej

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
