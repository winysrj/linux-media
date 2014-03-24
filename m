Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward12.mail.yandex.net ([95.108.130.94]:44184 "EHLO
	forward12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaCXJyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 05:54:06 -0400
Received: from web16j.yandex.ru (web16j.yandex.ru [5.45.198.57])
	by forward12.mail.yandex.net (Yandex) with ESMTP id C0CDCC210D9
	for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 13:54:03 +0400 (MSK)
From: Evgeny Sagatov <sagatov@ya.ru>
To: linux-media@vger.kernel.org
Subject: EM2860 + SAA7113 + STAC9752 no have sound
MIME-Version: 1.0
Message-Id: <217251395654843@web16j.yandex.ru>
Date: Mon, 24 Mar 2014 13:54:03 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I have the EasyCap device with EM2860 + SAA7113 + STAC9752 chips.
Video from composite and from S-Video operate great.
But I not have the sound. I do not see any errors in my logs.
I tried VLC and gstreamer for open alsa device with any rates and options.

I work on Ubuntu 12.04 and tried 3.2, 3.11 and 3.13 kernels.

Mar 24 13:47:38 ip4tv-st2 kernel: [ 1125.942116] usb 3-2: new high-speed USB device number 4 using xhci_hcd
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1125.958937] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1125.958984] em28xx #0: chip ID is em2860
Mar 24 13:47:38 ip4tv-st2 mtp-probe: checking bus 3, device 4: "/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2"
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1126.050300] em28xx #0: board has no eeprom
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1126.117043] em28xx #0: found i2c device @ 0x4a [saa7113h]
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1126.132110] em28xx #0: Your board has no unique USB ID.
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1126.132117] em28xx #0: A hint were successfully done, based on i2c devicelist hash.
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1126.132120] em28xx #0: This method is not 100% failproof.
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1126.132123] em28xx #0: If the board were missdetected, please email this log to:
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1126.132126] em28xx #0:     V4L Mailing List  <linux-media@vger.kernel.org>
Mar 24 13:47:38 ip4tv-st2 kernel: [ 1126.132129] em28xx #0: Board detected as EM2860/SAA711X Reference Design
Mar 24 13:47:39 ip4tv-st2 kernel: [ 1126.209810] em28xx #0: Identified as EM2860/SAA711X Reference Design (card=19)
Mar 24 13:47:39 ip4tv-st2 kernel: [ 1126.209816] em28xx #0: Registering snapshot button...
Mar 24 13:47:39 ip4tv-st2 kernel: [ 1126.209934] input: em28xx snapshot button as /devices/pci0000:00/0000:00:14.0/usb3/3-2/input/input13
Mar 24 13:47:39 ip4tv-st2 kernel: [ 1126.569889] em28xx #0: Config register raw data: 0x10
Mar 24 13:47:39 ip4tv-st2 kernel: [ 1126.593471] em28xx #0: AC97 vendor ID = 0x83847652
Mar 24 13:47:39 ip4tv-st2 kernel: [ 1126.605474] em28xx #0: AC97 features = 0x6a90
Mar 24 13:47:39 ip4tv-st2 kernel: [ 1126.605480] em28xx #0: Sigmatel audio processor detected(stac 9752)
Mar 24 13:47:39 ip4tv-st2 kernel: [ 1127.016889] em28xx #0: v4l2 driver version 0.1.3
Mar 24 13:47:40 ip4tv-st2 mtp-probe: bus: 3, device: 4 was not an MTP device
Mar 24 13:47:40 ip4tv-st2 kernel: [ 1127.944248] em28xx #0: V4L2 video device registered as video1
Mar 24 13:47:40 ip4tv-st2 kernel: [ 1127.944256] em28xx #0: V4L2 VBI device registered as vbi0
Mar 24 13:47:40 ip4tv-st2 kernel: [ 1127.944377] em28xx audio device (eb1a:2861): interface 1, class 1


 0 [PCH            ]: HDA-Intel - HDA Intel PCH
                      HDA Intel PCH at 0xf7e10000 irq 45
 1 [U0xeb1a0x2861  ]: USB-Audio - USB Device 0xeb1a:0x2861
                      USB Device 0xeb1a:0x2861 at usb-0000:00:14.0-2, high speed


  1:        : sequencer
  2: [ 1- 0]: digital audio capture
  3: [ 1]   : control
  4: [ 0- 3]: digital audio playback
  5: [ 0- 0]: digital audio playback
  6: [ 0- 0]: digital audio capture
  7: [ 0- 3]: hardware dependent
  8: [ 0- 0]: hardware dependent
  9: [ 0]   : control
 33:        : timer


/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 480M
    |__ Port 1: Dev 2, If 0, Class=HID, Driver=usbhid, 1.5M                                
    |__ Port 2: Dev 4, If 0, Class=vend., Driver=em28xx, 480M                              
    |__ Port 2: Dev 4, If 1, Class=audio, Driver=snd-usb-audio, 480M                               
    |__ Port 2: Dev 4, If 2, Class=audio, Driver=snd-usb-audio, 480M                               
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/2p, 480M                                 
    |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/6p, 480M                                        
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/2p, 480M                                 
    |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/6p, 480M                                                   
        |__ Port 1: Dev 3, If 0, Class='bInterfaceClass 0xe0 not yet handled', Driver=btusb, 12M              
        |__ Port 1: Dev 3, If 1, Class='bInterfaceClass 0xe0 not yet handled', Driver=btusb, 12M              
        |__ Port 3: Dev 4, If 0, Class='bInterfaceClass 0x0e not yet handled', Driver=uvcvideo, 480M          
        |__ Port 3: Dev 4, If 1, Class='bInterfaceClass 0x0e not yet handled', Driver=uvcvideo, 480M    


Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub                                                                   
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub                                                                          
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 003 Device 002: ID 0458:003a KYE Systems Corp. (Mouse Systems) NetScroll+ Mini Traveler / Genius NetScroll 120
Bus 003 Device 004: ID eb1a:2861 eMPIA Technology, Inc. 
Bus 001 Device 003: ID 8087:07da Intel Corp. 
Bus 001 Device 004: ID 04f2:b33e Chicony Electronics Co., Ltd 


--
Sincerely, Evgeny Sagatov
