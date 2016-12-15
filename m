Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36849 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755396AbcLOWMD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 17:12:03 -0500
Received: by mail-wm0-f65.google.com with SMTP id m203so902193wma.3
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2016 14:11:52 -0800 (PST)
Date: Thu, 15 Dec 2016 23:11:46 +0100
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4 0/3] stk1160: Let the driver setup the device's internal
 AC97 codec
Message-ID: <20161215221146.GA9398@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset is a result of my attempt to fix a bug (https://bugzilla.kernel.org/show_bug.cgi?id=180071) that eventually turned out to be caused by a missing quirk in snd-usb-audio. My idea was to remove the AC97 interface and setup the codec using the same values and in the same order as the Windows driver does, hoping there might be some "magic" sequence that would make the sound work the way it should. Although this didn't help to fix the problem, I found these changes to be useful nevertheless.

IMHO, having all of the AC97 codec's channels exposed to userspace is confusing since most of them have no meaning for this device anyway. Changing these values in alsamixer has either no effect at all or may even reduce the sound quality since it can actually increase the line-in DC offset (slightly).

In addition, having to re-select the correct capture channel everytime the device has been plugged in is annoying. At least on my systems the mixer setup is only saved if the device is plugged in during shutdown/reboot. I also get error messages in my kernel log when I unplug the device because some process (probably the AC97 driver) ist trying to read from the device after it has been removed. Either way the device should work out-of-the-box without the need for the user to manually setup channels.

The first patch in the set therefore removes the 'stk1160-mixer' and lets the driver setup the AC97 codec using the same values as the Windows driver. Although some of the values seem to be defaults I let the driver set them either way, just to be sure.

The second patch adds a check to determine whether the device is strapped to use the internal 8-bit ADC or an external chip, or whether audio is disabled altogether. There's currently no check in place to determine whether the device uses AC-link or I2S, but then again I haven't heard of any of these devices actually using an I2S chip. If the device uses the internal ADC the AC97 setup can be skipped. I implemented the check inside stk1160-ac97. It could just as well be in stk1160-core but this way just seemed cleaner. If at some point the need arises to check other power-on strap values, it might make sense to refactor this then.

The third patch addresses an issue when reading from the AC97 chip too soon, resulting in corrupt data.

Changes from version 3:
* Removed module param
* Implemented polling read/write bits

Marcel Hasler (3):
  stk1160: Remove stk1160-mixer and setup internal AC97 codec automatically.
  stk1160: Check whether to use AC97 codec.
  stk1160: Wait for completion of transfers to and from AC97 codec.

 drivers/media/usb/stk1160/Kconfig        |  10 +-
 drivers/media/usb/stk1160/Makefile       |   4 +-
 drivers/media/usb/stk1160/stk1160-ac97.c | 183 +++++++++++++++++--------------
 drivers/media/usb/stk1160/stk1160-core.c |   8 +-
 drivers/media/usb/stk1160/stk1160-reg.h  |  10 ++
 drivers/media/usb/stk1160/stk1160.h      |  11 +-
 6 files changed, 116 insertions(+), 110 deletions(-)

-- 
2.10.2

