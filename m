Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56557 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab0F2VHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 17:07:23 -0400
Received: by wyb38 with SMTP id 38so48105wyb.19
        for <linux-media@vger.kernel.org>; Tue, 29 Jun 2010 14:07:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTin1Bj__L4p1jEvwLO-2Wjw6-R8ICLsfb2w32jP3@mail.gmail.com>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
	<201006291542.27655.tkrah@fachschaft.imn.htwk-leipzig.de>
	<AANLkTin5iXho6LJP8mOPC-AIIJTi8myxZsy_V6msxSpa@mail.gmail.com>
	<201006292142.48380.tkrah@fachschaft.imn.htwk-leipzig.de>
	<AANLkTin1Bj__L4p1jEvwLO-2Wjw6-R8ICLsfb2w32jP3@mail.gmail.com>
Date: Tue, 29 Jun 2010 23:07:16 +0200
Message-ID: <AANLkTilKBR6q-iNLxT5ut0EXtT5agD0nyr3XjhaoJeR_@mail.gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Thorsten Hirsch <t.hirsch@web.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

success! I could recover my eeprom with Mauro's rewrite_eeprom.pl.
@Torsten: I also had to modprobe i2c-dev manually. And I even
modprobed i2c-smbus.

Unfortunately the driver (kernel 2.6.34) still doesn't work. There's
no /dev/dvb (even after loading em28xx_dvb manually as it has not been
loaded automatically.

Please have another look at the attached dmesg output.

Thorsten


[ 3481.670969] usb 2-3: new high speed USB device using ehci_hcd and address 5
[ 3481.829797] em28xx: New device TerraTec Electronic GmbH Cinergy T
USB XS @ 480 Mbps (0ccd:0043, interface 0, class 0)
[ 3481.829956] em28xx #0: chip ID is em2870
[ 3481.983457] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 43 00 c0 12
81 00 6a 24 8e 34
[ 3481.983483] em28xx #0: i2c eeprom 10: 00 00 06 57 02 0c 00 00 00 00
00 00 00 00 00 00
[ 3481.983504] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00
00 00 5b 00 00 00
[ 3481.983525] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 26 3c e3 49
[ 3481.983547] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 3481.983568] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 3481.983589] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
24 03 43 00 69 00
[ 3481.983611] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00
20 00 54 00 20 00
[ 3481.983632] em28xx #0: i2c eeprom 80: 55 00 53 00 42 00 20 00 58 00
53 00 00 00 34 03
[ 3481.983653] em28xx #0: i2c eeprom 90: 54 00 65 00 72 00 72 00 61 00
54 00 65 00 63 00
[ 3481.983675] em28xx #0: i2c eeprom a0: 20 00 45 00 6c 00 65 00 63 00
74 00 72 00 6f 00
[ 3481.983696] em28xx #0: i2c eeprom b0: 6e 00 69 00 63 00 20 00 47 00
6d 00 62 00 48 00
[ 3481.983717] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 3481.983738] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 3481.983759] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 3481.983781] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 3481.983805] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x5a1fc1df
[ 3481.983810] em28xx #0: EEPROM info:
[ 3481.983814] em28xx #0:       No audio on board.
[ 3481.983817] em28xx #0:       500mA max power
[ 3481.983823] em28xx #0:       Table at 0x06, strings=0x246a, 0x348e, 0x0000
[ 3481.984942] em28xx #0: Identified as Terratec Cinergy T XS (card=43)
[ 3481.984947] em28xx #0:
[ 3481.984949]
[ 3481.984953] em28xx #0: The support for this board weren't valid yet.
[ 3481.984958] em28xx #0: Please send a report of having this working
[ 3481.984962] em28xx #0: not to V4L mailing list (and/or to other addresses)
[ 3481.984965]
[ 3481.990805] Chip ID is not zero. It is not a TEA5767
[ 3481.990980] tuner 5-0060: chip found @ 0xc0 (em28xx #0)
[ 3481.991163] xc2028 5-0060: creating new instance
[ 3481.991169] xc2028 5-0060: type set to XCeive xc2028/xc3028 tuner
[ 3481.991182] usb 2-3: firmware: requesting xc3028-v27.fw
[ 3481.998357] xc2028 5-0060: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 3482.052776] xc2028 5-0060: Loading firmware for type=BASE (1), id
0000000000000000.
[ 3483.003956] xc2028 5-0060: Loading firmware for type=(0), id
000000000000b700.
[ 3483.018947] SCODE (20000000), id 000000000000b700:
[ 3483.018961] xc2028 5-0060: Loading SCODE for type=MONO SCODE
HAS_IF_4320 (60008000), id 0000000000008000.
[ 3483.054451] xc2028 5-0060: Returned an incorrect version. However,
read is not reliable enough. Ignoring it.
[ 3483.220169] em28xx #0: v4l2 driver version 0.1.2
[ 3483.225202] em28xx #0: V4L2 video device registered as video1
[ 3508.137491] Em28xx: Initialized (Em28xx dvb Extension) extension
