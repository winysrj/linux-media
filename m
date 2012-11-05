Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:45120 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409Ab2KEWcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 17:32:39 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so4656696lag.19
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2012 14:32:37 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 6 Nov 2012 09:32:36 +1100
Message-ID: <CAF3CQPoEauo4cJTrDuUC=opcc59MLzYuTnxaXvH2DdRsaSA0Bg@mail.gmail.com>
Subject: Troubles getting HVR-2200 to work
From: Keith Lockwood <kwlockwo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to get my HVR-2200 in debian wheezy.  Now seeing it is an
a older version of the card and wheezy is a 3.2 kernel I would think
that everything would already be there (which I have read after doing
a lot of googling).

So I have copyied
http://www.steventoth.net/linux/hvr22xx/firmwares/4019072/NXP7164-2010-03-10.1.fw
to my /lib/firmware directory.

This is the errors i am getting in dmesg:

[    8.272156] saa7164 driver loaded
[    8.272601] CORE saa7164[0]: subsystem: 0070:8901, board: Hauppauge
WinTV-HVR2200 [card=6,autodetected]
[    8.272606] saa7164[0]/0: found at 0000:02:00.0, rev: 129, irq: 16,
latency: 0, mmio: 0xfb800000
[    8.272612] saa7164 0000:02:00.0: setting latency timer to 64
[    8.287301] saa7164_downloadfirmware() no first image
[    8.287348] saa7164_downloadfirmware() Waiting for firmware upload
(NXP7164-2010-03-10.1.fw)
[    8.603099] saa7164_downloadfirmware() firmware read 4019072 bytes.
[    8.603102] saa7164_downloadfirmware() firmware loaded.
[    8.603114] saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
[    8.603123] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
[    8.603125] saa7164_downloadfirmware() BSLSize = 0x0
[    8.603127] saa7164_downloadfirmware() Reserved = 0x0
[    8.603129] saa7164_downloadfirmware() Version = 0x1661c00
[   14.010076] saa7164_downloadimage() image corrupt

Can anyone explain to me what image corrupt means, and what I can do
to correct it.

Thanks,
Keith
