Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36273 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0KIOz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 09:55:27 -0500
Received: by yxe1 with SMTP id 1so119028yxe.19
        for <linux-media@vger.kernel.org>; Tue, 09 Nov 2010 06:55:27 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 9 Nov 2010 15:48:16 +0100
Message-ID: <AANLkTikpXa7SSNm=esBBSVLHahO0zmsJsHEX4KmOvmpL@mail.gmail.com>
Subject: Trying to get unlisted Terratec Cinergy to work
From: Mark van Reijn <mvreijn@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everyone,

I have been trying to get my "Terratec Cinergy HT USB PVR" tuner to
work (on DVB-T). This is a hybrid analog/dvb-t tuner with a hardware
MPEG encoder.
Inserting the device does not cause any driver to respond and load.
The USB ID is "0ccd:006b". The PID is not listed in dvb-usb-ids.h.

After quite a bit of research I have a lot of information on the
device. I also opened it up to check the actual chip versions (took me
back to slackware 3 and graphics cards).
The various components are:
* Cypress CY7C68013A FX2 USB controller
* Intel CE6353 demodulator (should be the same as Zarlink ZL10353)
* XCeive XC3028 tuner
(* Conexant CX25843 a/v decoder)
(* Conexant CX23416 MPEG encoder)

The last two should not be really necessary from what I have learned.

>From what I can see, all components are supported in one way or
another. There are several drivers that mention the combination of
FX2, ZL10353 and XC2028/XC3028, "cxusb" seems to be closest. A
copy-paste from existing code might do the trick.

One thing stands in my way: I have never written C code in my life. I
can read the code and more or less understand what the purpose is, but
to combine stuff into a working driver requires real skills :-)

I have the correct xceive and conexant firmwares, a windows driver
with INF file, etc. at my disposal.
Can anyone help me assemble a driver for my device?
TIA,

Mark
