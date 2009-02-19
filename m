Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f176.google.com ([209.85.218.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <threnard@gmail.com>) id 1LaEbS-0000yD-Eh
	for linux-dvb@linuxtv.org; Thu, 19 Feb 2009 20:30:35 +0100
Received: by bwz24 with SMTP id 24so1534902bwz.17
	for <linux-dvb@linuxtv.org>; Thu, 19 Feb 2009 11:30:00 -0800 (PST)
Message-ID: <499DB335.50807@laposte.net>
Date: Thu, 19 Feb 2009 20:29:57 +0100
From: Thomas RENARD <threnard@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Can I use AVerTV Volar Black HD (A850) with Linux ?
Reply-To: linux-media@vger.kernel.org
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

Hello,

I bought this USB card : AVerTV Volar Black HD (A850) - 
http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=460&tab=APDriver.
I don't find anything relevant about using this card on linux.

Can I use this card on Linux ? How ?

Here is some information :

thomas@trubuntu:~$ dmesg
[  204.468031] usb 1-3: new full speed USB device using ohci_hcd and 
address 11
[  204.648022] usb 1-3: device descriptor read/64, error -62
[  204.932027] usb 1-3: device descriptor read/64, error -62
[  205.212025] usb 1-3: new full speed USB device using ohci_hcd and 
address 12
[  205.392026] usb 1-3: device descriptor read/64, error -62
[  205.676267] usb 1-3: device descriptor read/64, error -62
[  205.956026] usb 1-3: new full speed USB device using ohci_hcd and 
address 13
[  206.367700] usb 1-3: device not accepting address 13, error -62
[  206.544046] usb 1-3: new full speed USB device using ohci_hcd and 
address 14
[  206.952015] usb 1-3: device not accepting address 14, error -62
[  206.952696] hub 1-0:1.0: unable to enumerate USB device on port 3
[  206.953461] ppdev0: registered pardevice
[  207.000249] ppdev0: unregistered pardevice
[  207.134128] ppdev0: registered pardevice
[  207.180716] ppdev0: unregistered pardevice
[  207.420177] ppdev0: registered pardevice
[  207.468035] ppdev0: unregistered pardevice
[  213.643907] type=1503 audit(1235066401.409:6): 
operation="inode_permission" requested_mask="::x" denied_mask="::x" 
fsuid=7 name="/usr/NX/bin/nxspool" pid=7880 profile="/usr/sbin/cupsd"
[  681.700334] usb 3-6: new high speed USB device using ehci_hcd and 
address 3
[  681.889296] usb 3-6: configuration #1 chosen from 1 choice
[  719.776030] usb 1-3: new full speed USB device using ohci_hcd and 
address 15
[  719.960026] usb 1-3: device descriptor read/64, error -62
[  720.244031] usb 1-3: device descriptor read/64, error -62
[  720.524031] usb 1-3: new full speed USB device using ohci_hcd and 
address 16
[  720.706552] usb 1-3: device descriptor read/64, error -62
[  720.988024] usb 1-3: device descriptor read/64, error -62
[  721.272059] usb 1-3: new full speed USB device using ohci_hcd and 
address 17
[  721.680021] usb 1-3: device not accepting address 17, error -62
[  721.856043] usb 1-3: new full speed USB device using ohci_hcd and 
address 18
[  722.264442] usb 1-3: device not accepting address 18, error -62
[  722.264790] hub 1-0:1.0: unable to enumerate USB device on port 3


--------------------------------------------------------------


thomas@trubuntu:~$ dmesg | grep dvb
thomas@trubuntu:~$


--------------------------------------------------------------
thomas@trubuntu:~$ lsusb -v

Bus 003 Device 003: ID 07ca:850a AVerMedia Technologies, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x07ca AVerMedia Technologies, Inc.
  idProduct          0x850a
  bcdDevice            1.01
  iManufacturer           1 AVerMedia
  iProduct                2 A850 DVBT
  iSerial                 3 301475201032000
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


Thank you !


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
