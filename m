Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45908 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1AQUop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 15:44:45 -0500
Received: by bwz15 with SMTP id 15so2754750bwz.19
        for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 12:44:44 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Jan 2011 15:44:44 -0500
Message-ID: <AANLkTinSeEq+JV_GHqn8KQgq4ra69Zq4NXNBoK-vyc_9@mail.gmail.com>
Subject: [PATCH] follow-up to previous email: em28xx-cards.c modification to
 enable Plextor ConvertX PX-AV100U; uses eMPIA EM2820 chip
From: Don Kramer <donkramer@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

this might be a little easier to read on the em28xx-cards.c changes,
my apologies on pasting the entire file in-line.

[EM2820_BOARD_PINNACLE_DVC_90] = {
		.name         = "Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas
Video to DVD maker "
-				"/ Kworld DVD Maker 2",
+                               " / Kworld DVD Maker 2 "
+                                "/ Plextor ConvertX PX-AV100U",

.
.

{ USB_DEVICE(0x0413, 0x6023),
			.driver_info = EM2800_BOARD_LEADTEK_WINFAST_USBII },
+	{ USB_DEVICE(0x093b, 0xa003),
+  		        .driver_info = EM2820_BOARD_PINNACLE_DVC_90 },
	{ USB_DEVICE(0x093b, 0xa005),
			.driver_info = EM2861_BOARD_PLEXTOR_PX_TV100U },

Signed-off-by: Don Kramer <donkramer@gmail.com>

This is for the Plextor
ConvertX PX-AV100U which uses eMPIA EM2820 chip.  The device has a
device_id of '0x093b, 0xa003'.  I am using the existing
EM2820_BOARD_PINNACLE_DVC_90 board profile, as the Pinnacle Dazzle DVC
90/100/101/107, Kaiser Baas Video to DVD maker, and Kworld DVD Maker 2
were already mapped to it. Plextor has never released device drivers
for the PX-AV100U other than 32-bit Windows XP, and displeasure has
been voiced about this on message boards ... so I'm happy to be a
Linux evangelist and spread the word of it's support under Linux.  I
have gotten this device to work successfully under Ubuntu 10.10
64-bit, and previously Ubuntu 10.04 LTS 32-bit.
