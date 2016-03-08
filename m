Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33283 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcCHVpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 16:45:06 -0500
Received: by mail-lb0-f180.google.com with SMTP id k15so38295958lbg.0
        for <linux-media@vger.kernel.org>; Tue, 08 Mar 2016 13:45:05 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Mar 2016 15:45:04 -0600
Message-ID: <CAL0vL9yc=d_2LSUui=vWD2tttB0-oFathrEG8P35EoKtJEkSMQ@mail.gmail.com>
Subject: HVR-850 2040:b140 fails to initialize
From: Scott Robinson <scott.robinson55@gmail.com>
To: linux-media@vger.kernel.org,
	User discussion about IVTV <ivtv-users@ivtvdriver.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to above device with kernel 4.1.13-100.fc21.x86_64.

kernel: usb 2-2: New USB device found, idVendor=2040, idProduct=b140
kernel: usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
kernel: usb 2-2: Product: Hauppauge Device
kernel: usb 2-2: Manufacturer: Hauppauge
kernel: usb 2-2: SerialNumber: 4035391470
kernel: [5789620.592751] cx231xx 2-2:1.1: New device Hauppauge
Hauppauge Device @ 480 Mbps (2040:b140) with 7 interfaces
kernel: [5789620.592959] cx231xx 2-2:1.1: Identified as Hauppauge
EXETER (card=8)
kernel: cx231xx 2-2:1.1: New device Hauppauge Hauppauge Device @ 480
Mbps (2040:b140) with 7 interfaces
kernel: cx231xx 2-2:1.1: Identified as Hauppauge EXETER (card=8)
kernel: [5789620.593974] i2c i2c-8: Added multiplexed i2c bus 10
kernel: [5789620.594031] i2c i2c-8: Added multiplexed i2c bus 11
kernel: i2c i2c-8: Added multiplexed i2c bus 10
kernel: i2c i2c-8: Added multiplexed i2c bus 11
kernel: [5789620.755944] cx25840 7-0044: cx23102 A/V decoder found @
0x88 (cx231xx #0-0)
kernel: cx25840 7-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0-0)
kernel: [5789622.682697] cx25840 7-0044: loaded
v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
kernel: cx25840 7-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
kernel: [5789622.719317] Chip ID is not zero. It is not a TEA5767
kernel: [5789622.719327] tuner 10-0060: Tuner -1 found with type(s) Radio TV.
kernel: [5789622.719349] tda18271 10-0060: creating new instance
kernel: Chip ID is not zero. It is not a TEA5767
kernel: tuner 10-0060: Tuner -1 found with type(s) Radio TV.
kernel: tda18271 10-0060: creating new instance
kernel: [5789622.721440] Unknown device (110) detected @ 10-0060,
device not supported.
kernel: [5789622.721445] tda18271_attach: [10-0060|M] error -22 on line 1285
kernel: [5789622.721447] tda18271 10-0060: destroying instance
kernel: Unknown device (110) detected @ 10-0060, device not supported.
kernel: tda18271_attach: [10-0060|M] error -22 on line 1285
kernel: tda18271 10-0060: destroying instance
kernel: [5789622.726935] tuner 10-0060: Tuner has no way to set tv freq
kernel: tuner 10-0060: Tuner has no way to set tv freq
kernel: [5789622.728068] cx231xx 2-2:1.1: v4l2 driver version 0.0.3
kernel: cx231xx 2-2:1.1: v4l2 driver version 0.0.3
kernel: [5789622.856428] tuner 10-0060: Tuner has no way to set tv freq
kernel: [5789622.856582] cx231xx 2-2:1.1: Registered video device video1 [v4l2]
kernel: [5789622.856695] cx231xx 2-2:1.1: Registered VBI device vbi1
kernel: [5789622.856964] cx231xx 2-2:1.1: audio EndPoint Addr 0x83,
Alternate settings: 3
kernel: tuner 10-0060: Tuner has no way to set tv freq
kernel: cx231xx 2-2:1.1: Registered video device video1 [v4l2]
kernel: cx231xx 2-2:1.1: Registered VBI device vbi1
kernel: cx231xx 2-2:1.1: audio EndPoint Addr 0x83, Alternate settings: 3
kernel: [5789622.893807] cx231xx 2-2:1.1: dvb_init: looking for tuner
/ demod on i2c bus: 10
kernel: cx231xx 2-2:1.1: dvb_init: looking for tuner / demod on i2c bus: 10
kernel: cx231xx 2-2:1.1: cx231xx_send_usb_command: failed with status --32
kernel: lgdt3305_read_reg: error (addr 0e reg 0001 error (ret == -32)
kernel: lgdt3305_attach: error -32 on line 1143
kernel: lgdt3305_attach: unable to detect LGDT3305 hardware
kernel: cx231xx 2-2:1.1: Failed to attach LG3305 front end
kernel: [5789622.894206] cx231xx 2-2:1.1: cx231xx_send_usb_command:
failed with status --32
kernel: [5789622.894210] lgdt3305_read_reg: error (addr 0e reg 0001
error (ret == -32)
kernel: [5789622.894212] lgdt3305_attach: error -32 on line 1143
kernel: [5789622.894214] lgdt3305_attach: unable to detect LGDT3305 hardware
kernel: [5789622.894218] cx231xx 2-2:1.1: Failed to attach LG3305 front end
kernel: [5789622.894919] cx231xx 2-2:1.1: video EndPoint Addr 0x84,
Alternate settings: 5
kernel: [5789622.894925] cx231xx 2-2:1.1: VBI EndPoint Addr 0x85,
Alternate settings: 2
kernel: [5789622.894928] cx231xx 2-2:1.1: sliced CC EndPoint Addr
0x86, Alternate settings: 2
kernel: [5789622.894931] cx231xx 2-2:1.1: TS EndPoint Addr 0x81,
Alternate settings: 6
kernel: cx231xx 2-2:1.1: video EndPoint Addr 0x84, Alternate settings: 5
kernel: cx231xx 2-2:1.1: VBI EndPoint Addr 0x85, Alternate settings: 2
kernel: cx231xx 2-2:1.1: sliced CC EndPoint Addr 0x86, Alternate settings: 2

Appreciate some advice.

Regards,
Scott
