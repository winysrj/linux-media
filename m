Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:34218 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932458AbdHWTTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 15:19:36 -0400
Received: by mail-qt0-f181.google.com with SMTP id p10so5663430qte.1
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 12:19:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGncdOZsA75D8eFOSYDFWzxYfCh2d7ctV_A1z+MWYU+Dn6c6Fw@mail.gmail.com>
References: <CAGncdOZsA75D8eFOSYDFWzxYfCh2d7ctV_A1z+MWYU+Dn6c6Fw@mail.gmail.com>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Wed, 23 Aug 2017 15:19:35 -0400
Message-ID: <CAOcJUbzReZ_PRqrPYK11-tAh49YzktMh3Uxhiy_W8JfNf_AWQQ@mail.gmail.com>
Subject: Re: __tda18271_write_regs ERROR
To: Anders Eriksson <aeriksson2@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 23, 2017 at 7:36 AM, Anders Eriksson <aeriksson2@gmail.com> wrote:
> Hi,
>
> On a freshly booted rpi2, I got this in the logs (3rd line from bottom):
>
> [   12.999134] em28xx 1-1.2.4.1:1.0: New device PCTV Systems PCTV 290e
> @ 480 Mbps (2013:024f, interface 0, class 0)
> [   13.072265] em28xx 1-1.2.4.1:1.0: DVB interface 0 found: isoc
> [   13.082114] em28xx 1-1.2.4.1:1.0: chip ID is em28174
> [   13.477093] em28xx 1-1.2.4.1:1.0: EEPROM ID = 26 00 01 00, EEPROM
> hash = 0x11372abd
> [   13.491322] em28xx 1-1.2.4.1:1.0: EEPROM info:
> [   13.499089] em28xx 1-1.2.4.1:1.0:    microcode start address =
> 0x0004, boot configuration = 0x01
> [   13.538392] em28xx 1-1.2.4.1:1.0:    No audio on board.
> [   13.546833] em28xx 1-1.2.4.1:1.0:    500mA max power
> [   13.554815] em28xx 1-1.2.4.1:1.0:    Table at offset 0x39,
> strings=0x1aa0, 0x14ba, 0x1ace
> [   13.569346] em28xx 1-1.2.4.1:1.0: Identified as PCTV nanoStick T2
> 290e (card=78)
> [   13.583142] em28xx 1-1.2.4.1:1.0: dvb set to isoc mode.
> [   13.592690] em28xx 1-1.2.4.3:1.0: New device PCTV PCTV 292e @ 480
> Mbps (2013:025f, interface 0, class 0)
> [   13.609209] em28xx 1-1.2.4.3:1.0: DVB interface 0 found: isoc
> [   13.618736] em28xx 1-1.2.4.3:1.0: chip ID is em28178
> [   15.742114] em28xx 1-1.2.4.3:1.0: EEPROM ID = 26 00 01 00, EEPROM
> hash = 0x1f10fa04
> [   15.742126] em28xx 1-1.2.4.3:1.0: EEPROM info:
> [   15.742136] em28xx 1-1.2.4.3:1.0:    microcode start address =
> 0x0004, boot configuration = 0x01
> [   15.749999] em28xx 1-1.2.4.3:1.0:    AC97 audio (5 sample rates)
> [   15.750012] em28xx 1-1.2.4.3:1.0:    500mA max power
> [   15.750028] em28xx 1-1.2.4.3:1.0:    Table at offset 0x27,
> strings=0x146a, 0x1888, 0x0a7e
> [   15.750417] em28xx 1-1.2.4.3:1.0: Identified as PCTV tripleStick
> (292e) (card=94)
> [   15.750432] em28xx 1-1.2.4.3:1.0: dvb set to isoc mode.
> [   15.753015] usbcore: registered new interface driver em28xx
> [   15.808636] em28xx 1-1.2.4.1:1.0: Binding DVB extension
> [   15.876054] cxd2820r 4-006c: Sony CXD2820R successfully identified
> [   15.905239] tda18271 4-0060: creating new instance
> [   15.923907] tda18271: TDA18271HD/C2 detected @ 4-0060
> [   16.425196] dvbdev: DVB: registering new adapter (1-1.2.4.1:1.0)
> [   16.435689] em28xx 1-1.2.4.1:1.0: DVB: registering adapter 0
> frontend 0 (Sony CXD2820R)...
> [   16.453437] em28xx 1-1.2.4.1:1.0: DVB extension successfully initialized
> [   16.463783] em28xx 1-1.2.4.3:1.0: Binding DVB extension
> [   16.499683] i2c i2c-6: Added multiplexed i2c bus 7
> [   16.508155] si2168 6-0064: Silicon Labs Si2168-B40 successfully identified
> [   16.518485] si2168 6-0064: firmware version: B 4.0.2
> [   16.545725] si2157 7-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   16.560772] dvbdev: DVB: registering new adapter (1-1.2.4.3:1.0)
> [   16.570481] em28xx 1-1.2.4.3:1.0: DVB: registering adapter 1
> frontend 0 (Silicon Labs Si2168)...
> [   16.592323] em28xx 1-1.2.4.3:1.0: DVB extension successfully initialized
> [   16.602913] em28xx: Registered (Em28xx dvb Extension) extension
> [   16.640109] em28xx 1-1.2.4.1:1.0: Registering input extension
> [   16.651247] rc rc0: 1-1.2.4.1:1.0 IR as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2.4/1-1.2.4.1/1-1.2.4.1:1.0/rc/rc0
> [   16.722038] Registered IR keymap rc-pinnacle-pctv-hd
> [   16.733053] input: 1-1.2.4.1:1.0 IR as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2.4/1-1.2.4.1/1-1.2.4.1:1.0/rc/rc0/input2
> [   16.753630] em28xx 1-1.2.4.1:1.0: Input extension successfully initalized
> [   16.764109] em28xx 1-1.2.4.3:1.0: Registering input extension
> [   16.774447] rc rc1: 1-1.2.4.3:1.0 IR as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2.4/1-1.2.4.3/1-1.2.4.3:1.0/rc/rc1
> [   16.792973] Registered IR keymap rc-pinnacle-pctv-hd
> [   16.802484] input: 1-1.2.4.3:1.0 IR as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2.4/1-1.2.4.3/1-1.2.4.3:1.0/rc/rc1/input3
> [   16.822322] em28xx 1-1.2.4.3:1.0: Input extension successfully initalized
> [   16.832818] em28xx: Registered (Em28xx Input Extension) extension
> [   22.142086] si2168 6-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> [   22.641659] si2168 6-0064: firmware version: B 4.0.11
> [   22.659062] si2157 7-0060: found a 'Silicon Labs Si2157-A30'
> [   22.719300] si2157 7-0060: firmware version: 3.0.5
> [   22.728337] em28xx 1-1.2.4.3:1.0: DVB: adapter 1 frontend 0
> frequency 0 out of range (42000000..870000000)
> [   23.257682] tda18271: performing RF tracking filter calibration
> [   26.994564] em28xx 1-1.2.4.1:1.0: write to i2c device at 0xd8
> failed with unknown error (status=1)
> [   27.021126] __tda18271_write_regs: [4-0060|M] ERROR: idx = 0x21,
> len = 1, i2c_transfer returned: -6
> [   28.125996] tda18271: RF tracking filter calibration complete
> [   28.137028] em28xx 1-1.2.4.1:1.0: DVB: adapter 0 frontend 0
> frequency 0 out of range (45000000..864000000)
>
>
> Is this expected? It's running 4.12.3-v7+ from the rpi tree.
>
>
> -Anders


The TDA18271c2 RF tracking filter calibration is a sensitive process
that requires silence on the i2c bus.  My guess is that the em28xx i2c
bus is not as quiet as it should be during this initialization.

However, first I would check to see whether the device works with the
windows driver.  Maybe it's broken.

-Michael Ira Krufky
