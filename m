Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:9821 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZD0IU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 04:20:56 -0400
Received: by mu-out-0910.google.com with SMTP id i2so649323mue.1
        for <linux-media@vger.kernel.org>; Mon, 27 Apr 2009 01:20:55 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Apr 2009 10:20:55 +0200
Message-ID: <617be8890904270120w430b1757h4870497630c51db@mail.gmail.com>
Subject: Hauppauge Nova-T 500 completely nailed after rebooting
From: Eduard Huguet <eduardhc@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    This is something that has been hapening lately (since some months
ago). I'm currently using Gentoo 64 bits (kernel 2.6.29, but using
LinuxTV HG code for DVB), and I've observed that rebooting the system
gets the card completely hanged.

This is what happens:
    · after rebooting, the card initializes itself as normal, and is
detected as in 'warm' state (firmware loaded)
    · then, the following entry appears iun dmesg:

ehci_hcd 0000:01:0e.2: force halt; handhake ffffc20000042014 00004000
00000000 -> -110

    · then, once the mythbackend starts scanning EIT data (or just
recording or whatever...) the dmesg is completely filled with this:

[   35.422678] mt2060 I2C write failed (len=2)
[   35.422682] mt2060 I2C write failed (len=6)
[   35.422684] mt2060 I2C read failed
[   35.430001] mt2060 I2C read failed
[   35.440001] mt2060 I2C read failed
[   35.450002] mt2060 I2C read failed
[   35.460007] mt2060 I2C read failed
[   35.470000] mt2060 I2C read failed
[   35.480006] mt2060 I2C read failed
[   35.490003] mt2060 I2C read failed
[   35.502033] mt2060 I2C read failed
[   35.510000] mt2060 I2C read failed
[   35.954276] mt2060 I2C write failed
[   35.959139] mt2060 I2C write failed (len=2)
[   35.959143] mt2060 I2C write failed (len=6)
(at infinitum...)


The card is unable to record anything. If I stop the backend, unload
dvb_usb_0700 module and reload it then I get the following:

[  397.692455] usbcore: deregistering interface driver dvb_usb_dib0700
[  397.692937] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
deinitialized and disconnected.
[  408.229251] dib0700: loaded with support for 9 different device-types
[  408.229283] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
cold state, will try to load a firmware
[  408.229286] usb 2-1: firmware: requesting dvb-usb-dib0700-1.20.fw
[  408.244217] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[  408.244227] dib0700: firmware download failed at 7 with -108
[  408.244260] usbcore: registered new interface driver dvb_usb_dib0700

As seen, the card is unable to reinit itself properly any more, so the
DVB devices are simply not created.
Sometimes, this can be solved by just rebooting a couple of times, but
sometimes not.

The only real way to fix is to completely power down the machine,
unplug AC cord, press power button (which empties capacitors and
so...), replug and booting again. This method ensures that the
firmware card is unloaded and then properly reloaded, which makes it
work fine again.

Any ideas? Should I discard LinuxTV drivers and use those in-tree for 2.6.29?

Best regards,
  Eduard
