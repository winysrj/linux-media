Return-path: <linux-media-owner@vger.kernel.org>
Received: from node1.sciborek.com ([67.18.208.48]:46539 "EHLO ssl.sciborek.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632AbZJSVcv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 17:32:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by ssl.sciborek.com (Postfix) with ESMTP id B982714481
	for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 23:19:58 +0200 (CEST)
Received: from ssl.sciborek.com ([127.0.0.1])
	by localhost (node1.sciborek.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cHG+AXGc5LyL for <linux-media@vger.kernel.org>;
	Mon, 19 Oct 2009 23:19:46 +0200 (CEST)
Received: from [IPv6:2001:6a0:177:0:221:5dff:fe14:cd16] (karaluszek.sciborek.com [IPv6:2001:6a0:177:0:221:5dff:fe14:cd16])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ssl.sciborek.com (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 23:19:46 +0200 (CEST)
Subject: HP/Yuan EC372S DVB-T
From: Patryk =?UTF-8?Q?=C5=9Aciborek?= <patryk@sciborek.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Oct 2009 23:19:45 +0200
Message-Id: <1255987185.7941.35.camel@karaluszek.sciborek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have HP/Yuan EC372S DVB-T tuner. I'm trying to make it working under
Linux but without success. I've tried using modules from 2.6.31.3 and
compiling from Mercurial repository.


Just after inserting card (modules have debugging enabled):

karaluszek:/lib/modules# dmesg | grep -v '>>>' | grep -v '<<<' | grep -v 'writing to address' | tail -36
[85050.640892] dvb-usb: Yuan EC372S successfully deinitialized and disconnected.
[85054.324234] usb 3-3: new high speed USB device using ehci_hcd and address 9
[85054.457258] usb 3-3: New USB device found, idVendor=1164, idProduct=1edc
[85054.457269] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[85054.457275] usb 3-3: Product: STK7700D
[85054.457280] usb 3-3: Manufacturer: YUANRD
[85054.457284] usb 3-3: SerialNumber: 0000000001
[85054.457484] usb 3-3: configuration #1 chosen from 1 choice
[85054.458505] FW GET_VERSION length: -32
[85054.458511] cold: 1
[85054.458515] dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a firmware
[85054.458522] usb 3-3: firmware: requesting dvb-usb-dib0700-1.20.fw
[85054.478061] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[85054.684318] dib0700: firmware started successfully.
[85055.188223] dvb-usb: found a 'Yuan EC372S' in warm state.
[85055.188348] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[85055.188817] DVB: registering new adapter (Yuan EC372S)
[85055.236479] ep 0 write error (status = -32, len: 6)
[85055.236481] DiB7000P: checking demod on I2C address: 128 (80)
[85055.236976] ep 0 read error (status = -32)
[85055.236979] I2C read failed on address 0x40
[85055.236981] DiB7000P: i2c read error on 768
[85055.236983] DiB7000P: wrong Vendor ID (read=0x1200)
[85055.238348] DiB7000P: checking demod on I2C address: 18 (12)
[85055.242480] DiB7000P: setting output mode for demod ffff88007a47b2f0 to 4
[85055.247474] DiB7000P: IC 0 initialized (to i2c_address 0x80)
[85055.250101] DiB7000P: setting output mode for demod ffff88007a47b2f0 to 0
[85055.255865] DiB7000P: checking demod on I2C address: 128 (80)
[85055.296360] DiB7000P: gpio dir: ffff: val: 0, pwm_pos: ffff
[85055.302743] DiB7000P: setting output mode for demod ffff8800300e3000 to 0
[85055.309721] DiB7000P: using default timf
[85055.408997] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[85055.412746] MT2266: successfully identified
[85055.574944] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb3/3-3/input/input19
[85055.575048] dvb-usb: schedule remote query interval to 50 msecs.
[85055.575055] dvb-usb: Yuan EC372S successfully initialized and connected.

karaluszek:/lib/modules# uname -a
Linux karaluszek 2.6.31.3-scibi #1 SMP Sun Oct 11 23:38:13 CEST 2009 x86_64 GNU/Linux


After running dvbscan/dvbtune:
karaluszek:/home/scibi/dvb/v4l-dvb-f6680fa8e7ec# dvbscan /usr/share/dvb/dvb-t/pl-Warszawa 
Unable to query frontend status
karaluszek:/home/scibi/dvb/v4l-dvb-f6680fa8e7ec# dvbtune -f 690000000 
Using DVB card "DiBcom 7000PC"
tuning DVB-T (in United Kingdom) to 690000000 Hz
polling....
Getting frontend event
FE_STATUS:
polling....
polling....
^C

[85473.793547] DiB7000P: setting output mode for demod ffff8800300e3000 to 0
[85473.819971] MT2266: set_parms: tune=376832 band=102 UHF
[85473.819978] MT2266: set_parms: [1..3]:  0  0 2e
[85473.887700] MT2266: Lock when i=3
[85473.913806] DiB7000P: WBD: ref: 3530, sel: 1, active: 0, alpha: 1
[85473.960080] DiB7000P: using default timf
[85474.261493] DiB7000P: using default timf
[85474.265451] DiB7000P: setting output mode for demod ffff8800300e3000 to 5
[85474.277844] DiB7000P: setting output mode for demod ffff8800300e3000 to 0
[85479.607362] DiB7000P: setting output mode for demod ffff8800300e3000 to 0
[85479.631733] MT2266: set_parms: tune=376832 band=102 UHF
[85479.631735] MT2266: set_parms: [1..3]:  0  0 2e
[85479.718610] MT2266: Lock when i=4
[85479.772081] DiB7000P: using default timf
[85480.073558] DiB7000P: using default timf
[85480.077638] DiB7000P: setting output mode for demod ffff8800300e3000 to 5
[85481.083071] DiB7000P: setting output mode for demod ffff8800300e3000 to 0
[85481.107832] MT2266: set_parms: tune=376832 band=102 UHF
[85481.107839] MT2266: set_parms: [1..3]:  0  0 2e
[85481.179685] MT2266: Lock when i=4
[85481.252064] DiB7000P: using default timf
[85481.553570] DiB7000P: using default timf
[85481.557560] DiB7000P: setting output mode for demod ffff8800300e3000 to 5
[85482.563011] DiB7000P: setting output mode for demod ffff8800300e3000 to 0
[85482.587880] MT2266: set_parms: tune=376832 band=102 UHF
[85482.587887] MT2266: set_parms: [1..3]:  0  0 2e
[85482.663631] MT2266: Lock when i=4
[85482.720715] DiB7000P: using default timf
[85483.021653] DiB7000P: using default timf
[85483.025607] DiB7000P: setting output mode for demod ffff8800300e3000 to 5
[85484.031060] DiB7000P: setting output mode for demod ffff8800300e3000 to 0
[85484.055926] MT2266: set_parms: tune=376832 band=102 UHF
[85484.055939] MT2266: set_parms: [1..3]:  0  0 2e
[85484.127552] MT2266: Lock when i=4


I've done some usb snooping on Windows using
http://sourceforge.net/projects/usbsnoop/ during initialization and
start of playback so I can post it here if it's needed. I can also post
not filtered dmesg output.



karaluszek:/lib/modules# lsusb -s 3:9 -v

Bus 003 Device 009: ID 1164:1edc YUAN High-Tech Development Co., Ltd 
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


Best regards,
Patryk Ściborek

