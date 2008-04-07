Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <julien@fhtagn.net>) id 1Jiuol-0003rK-E0
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 19:07:40 +0200
Received: from [80.221.26.142] (80.221.26.142) by
	pne-smtpout3-sn2.hy.skanova.net (7.3.129)
	id 478BDB96004A4D93 for linux-dvb@linuxtv.org;
	Mon, 7 Apr 2008 19:07:04 +0200
From: Julien Rebetez <julien@fhtagn.net>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="=-ZuDO5amf2A8GZqTRnrP+"
Date: Mon, 07 Apr 2008 20:07:04 +0300
Message-Id: <1207588024.14924.12.camel@silver-laptop>
Mime-Version: 1.0
Subject: [linux-dvb] Yuan EC372S no frontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-ZuDO5amf2A8GZqTRnrP+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

I have some problems with a Yuan EC372S card. I am using the latest (rev
7499:1abbd650fe07) v4l-dvb from mercurial head. 

The card is correctly detected and the firmware loaded but no frontend
is attached to it.

I'm running kernel 2.6.22-14-generic on an Ubuntu Gutsy.

I have attached the relevant output of dmesg and lsusb -v and of course
I'll be glad to give more informations if needed.

Regards,
Julien


--=-ZuDO5amf2A8GZqTRnrP+
Content-Disposition: attachment; filename=usb.txt
Content-Type: text/plain; name=usb.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit


Bus 006 Device 004: ID 1164:1edc YUAN High-Tech Development Co., Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1164 YUAN High-Tech Development Co., Ltd
  idProduct          0x1edc 
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

--=-ZuDO5amf2A8GZqTRnrP+
Content-Disposition: attachment; filename=dmesg.txt
Content-Type: text/plain; name=dmesg.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit

[ 6880.516000] dib0700: loaded with support for 7 different device-types
[ 6880.516000] dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a firmware
[ 6880.520000] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
[ 6880.624000] dib0700: firmware started successfully.
[ 6881.128000] dvb-usb: found a 'Yuan EC372S' in warm state.
[ 6881.128000] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[ 6881.128000] DVB: registering new adapter (Yuan EC372S)
[ 6881.220000] dvb-usb: no frontend was attached by 'Yuan EC372S'
[ 6881.220000] dvb-usb: Yuan EC372S successfully initialized and connected.
[ 6881.220000] dib0700: ir protocol setup failed
[ 6881.220000] usbcore: registered new interface driver dvb_usb_dib0700

--=-ZuDO5amf2A8GZqTRnrP+
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-ZuDO5amf2A8GZqTRnrP+--
