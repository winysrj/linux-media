Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35135 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbdBFUsZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 15:48:25 -0500
Received: by mail-it0-f66.google.com with SMTP id 203so10168818ith.2
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2017 12:48:25 -0800 (PST)
MIME-Version: 1.0
From: Matthew Hughes <matt.hughes@shrdlusblocks.com>
Date: Mon, 6 Feb 2017 14:48:04 -0600
Message-ID: <CAHK4VQD9Lka9d7jusbQX7ScAS9s2_jem=tXwAhJfZWoZNo+feQ@mail.gmail.com>
Subject: V4L board mis-identified, Tuner is TDA18271HD not s921
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Plugged in a USB ATSC tuner, has an em28xx bridge along with both a
NXP TDA18271HDC2 and a Trident DRX3933J_B2... stenciled on the board
is EzTV306_1.2

It however registered as a DVB device with a sharp s921 tuner.

[  208.072748] usb 4-1.3: new high-speed USB device number 3 using ehci-pci
[  208.298601] media: Linux media interface: v0.10
[  208.312132] Linux video capture interface: v2.00
[  208.636160] em28xx: New device  USB 2875 Device @ 480 Mbps
(eb1a:2875, interface 0, class 0)
[  208.636162] em28xx: DVB interface 0 found: isoc
[  208.636222] em28xx: chip ID is em2874
[  208.715834] em2874 #0: EEPROM ID = 26 40 03 00, EEPROM hash = 0xe0a5bac9
[  208.715836] em2874 #0: EEPROM info:
[  208.715837] em2874 #0:  microcode start address = 0x4004, boot
configuration = 0x03
[  208.739463] em2874 #0:  I2S audio, 5 sample rates
[  208.739465] em2874 #0:  500mA max power
[  208.739467] em2874 #0:  Table at offset 0x24, strings=0x206a, 0x128a, 0x0000
[  208.741337] em2874 #0: No sensor detected
[  208.769463] em2874 #0: found i2c device @ 0xa0 on bus 0 [eeprom]
[  208.786096] em2874 #0: Your board has no unique USB ID.
[  208.786106] em2874 #0: A hint were successfully done, based on i2c
devicelist hash.
[  208.786110] em2874 #0: This method is not 100% failproof.
[  208.786114] em2874 #0: If the board were missdetected, please email
this log to:
[  208.786117] em2874 #0:  V4L Mailing List  <linux-media@vger.kernel.org>
[  208.786120] em2874 #0: Board detected as EM2874 Leadership ISDBT
[  208.892731] em2874 #0: Identified as EM2874 Leadership ISDBT (card=77)
[  208.892734] em2874 #0: dvb set to isoc mode.
[  208.893013] usbcore: registered new interface driver em28xx
[  209.067077] em2874 #0: Binding DVB extension
[  209.124284] s921: s921_attach:
[  209.124291] DVB: registering new adapter (em2874 #0)
[  209.124299] usb 4-1.3: DVB: registering adapter 0 frontend 0 (Sharp S921)...
[  209.124819] em2874 #0: DVB extension successfully initialized
[  209.124823] em28xx: Registered (Em28xx dvb Extension) extension
