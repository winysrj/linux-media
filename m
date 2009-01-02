Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1LIaSy-0002Iw-8d
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 04:12:55 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2251910fga.25
	for <linux-dvb@linuxtv.org>; Thu, 01 Jan 2009 19:12:48 -0800 (PST)
Message-ID: <495D862C.3020805@gmail.com>
Date: Fri, 02 Jan 2009 04:12:44 +0100
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: [linux-dvb] [BUG]2.6.28 breaks dvb-usb devices FE i2c,
	hg 5bfadacec8a2 mchehab
Reply-To: thomas.schorpp@gmail.com
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

hi,

usb 2-2: Product: TvTUNER
usb 2-2: Manufacturer: SKGZ
ID 04ca:f001 Lite-On Technology Corp.

FE has been (mostly, until the 3rd try) detected until 2.6.27.10: 

Dec 31 12:01:33 tom1 kernel: MT2060: successfully identified (IF1 = 1241)

but no more with 2.6.28.

can see no recent changes here:

http://linuxtv.org/hg/v4l-dvb/log/6a189bc8f115/linux/drivers/media/dvb/frontends/dib3000mc.c
http://linuxtv.org/hg/v4l-dvb/log/6a189bc8f115/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c

this should be the breaking changeset included in 2.6.28 stable kernel release, others are too old:

http://linuxtv.org/hg/v4l-dvb/log/6a189bc8f115/linux/drivers/media/dvb/dvb-usb/dibusb-common.c
http://linuxtv.org/hg/v4l-dvb/log/6a189bc8f115/linux/drivers/media/dvb/frontends/dibx000_common.c
http://linuxtv.org/hg/v4l-dvb/rev/5bfadacec8a2 
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

y
tom

-------------------------------------------------
usb 2-2: new high speed USB device using ehci_hcd and address 6
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: New USB device found, idVendor=04ca, idProduct=f000
usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
*dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in cold state, will try to load a firmware*
usb 2-2: firmware: requesting dvb-usb-dibusb-6.0.0.8.fw
dvb-usb: downloading firmware from file 'dvb-usb-dibusb-6.0.0.8.fw'
usbcore: registered new interface driver dvb_usb_dibusb_mc

usb 2-2: USB disconnect, address 6
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.

usb 2-2: new high speed USB device using ehci_hcd and address 7
usb 2-2: configuration #1 chosen from 1 choice
*dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.*
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
*DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0x5a00)*
DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0x5a00)
*dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'*
dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
usb 2-2: New USB device found, idVendor=04ca, idProduct=f001
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: TvTUNER
usb 2-2: Manufacturer: SKGZ

usbcore: deregistering interface driver dvb_usb_dibusb_mc
dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully deinitialized and disconnected.

dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
*dvb-usb: bulk message failed: -22 (3/2)*
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
*dvb-usb: bulk message failed: -22 (6/-1)*
*DiB3000MC/P:i2c read error on 1025*
DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0x292c)
dvb-usb: bulk message failed: -22 (6/-1)
DiB3000MC/P:i2c read error on 1025
DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0xc044)
dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dibusb_mc

usbcore: deregistering interface driver dvb_usb_dibusb_mc
dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully deinitialized and disconnected.

tom1:~# lsusb -d 04ca:f001 -vvv

Bus 002 Device 007: ID 04ca:f001 Lite-On Technology Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x04ca Lite-On Technology Corp.
  idProduct          0xf001 
  bcdDevice            0.01
  iManufacturer           1 SKGZ
  iProduct                2 TvTUNER
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
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
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
        bEndpointAddress     0x86  EP 6 IN
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
Device Status:     0x0002
  (Bus Powered)
  Remote Wakeup Enabled
tom1:~# 

tom1:~# uname -a
Linux tom1 2.6.28 #9 PREEMPT Thu Jan 1 09:17:55 CET 2009 x86_64 GNU/Linux



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
