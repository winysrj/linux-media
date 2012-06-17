Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61454 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab2FQN65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jun 2012 09:58:57 -0400
Received: by yenl2 with SMTP id l2so2752941yen.19
        for <linux-media@vger.kernel.org>; Sun, 17 Jun 2012 06:58:56 -0700 (PDT)
Message-ID: <4FDDE29B.9040500@gmail.com>
Date: Sun, 17 Jun 2012 10:58:51 -0300
From: Rodolfo Timoteo da Silva <zhushazang@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DiBcom adapter problems
Content-Type: multipart/mixed;
 boundary="------------020407080607040700080600"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020407080607040700080600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi, every time that i try to syntonize DVB-T channels i receive a
message in kernel like in log1.txt arch.

There are in log2.txt some usefull information about the device.

My kernel/system is:


Linux version 3.4.2-gentoo-r1-asgard (root@asgard) (gcc version 4.6.3
(Gentoo 4.6.3 p1.3, pie-0.5.2) ) #1 SMP PREEMPT Thu Jun 14 07:45:19 BRT 2012

Best Regards

--------------020407080607040700080600
Content-Type: text/plain; charset=UTF-8;
 name="log1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="log1.txt"

dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to delivery system 0
dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to delivery system 0
dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0
dtv_property_cache_sync: doesn't know how to handle a DVBv3 call to delivery system 0

--------------020407080607040700080600
Content-Type: text/plain; charset=UTF-8;
 name="log2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="log2.txt"

usb 2-1.2: new high-speed USB device number 4 using ehci_hcd
usb 2-1.2: New USB device found, idVendor=10b8, idProduct=1fa0
usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.2: Product: STK8096GP
usb 2-1.2: Manufacturer: DiBcom
usb 2-1.2: SerialNumber: 1
dvb-usb: found a 'DiBcom STK8096GP reference design' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'DiBcom STK8096GP reference design' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (DiBcom STK8096GP reference design)
DVB: registering adapter 0 frontend 0 (DiBcom 8000 ISDB-T)...
DiB0090: successfully identified
Registered IR keymap rc-dib0700-rc5
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/rc/rc0/input14
rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/rc/rc0
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: DiBcom STK8096GP reference design successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700



Bus 002 Device 004: ID 10b8:1fa0 DiBcom 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x10b8 DiBcom
  idProduct          0x1fa0 
  bcdDevice            1.00
  iManufacturer           1 DiBcom
  iProduct                2 STK8096GP
  iSerial                 3 1
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

--------------020407080607040700080600--
