Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:35258 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0KBURp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 16:17:45 -0400
Subject: [PATCH 0/6] rc-core: ir-core to rc-core conversion
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Tue, 02 Nov 2010 21:17:38 +0100
Message-ID: <20101102201733.12010.30019.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is my current patch queue, the main change is to make struct rc_dev
the primary interface for rc drivers and to abstract away the fact that
there's an input device lurking in there somewhere.

In addition, the cx88 and winbond-cir drivers are converted to use rc-core.

The patchset is now based on current linux-2.6 upstream git tree since it
carries both the v4l patches from the staging/for_v2.6.37-rc1 branch, large
scancode support and bugfixes.

Given the changes, these patches touch every single driver. Obviously I
haven't tested them all due to a lack of hardware (I have made sure that
all drivers compile without any warnings and I have tested the end result
on mceusb and winbond-cir hardware, Jarod Wilson has tested nuvoton-cir,
imon and several mceusb devices).

---

David Härdeman (6):
      ir-core: convert drivers/media/video/cx88 to ir-core
      ir-core: remove remaining users of the ir-functions keyhandlers
      ir-core: more cleanups of ir-functions.c
      ir-core: merge and rename to rc-core
      ir-core: make struct rc_dev the primary interface
      rc-core: convert winbond-cir


 drivers/input/misc/Kconfig                  |   18 
 drivers/input/misc/Makefile                 |    1 
 drivers/input/misc/winbond-cir.c            | 1608 ---------------------------
 drivers/media/IR/Kconfig                    |   19 
 drivers/media/IR/Makefile                   |    7 
 drivers/media/IR/ene_ir.c                   |  129 +-
 drivers/media/IR/ene_ir.h                   |    3 
 drivers/media/IR/imon.c                     |   67 -
 drivers/media/IR/ir-core-priv.h             |   26 
 drivers/media/IR/ir-functions.c             |  254 ----
 drivers/media/IR/ir-jvc-decoder.c           |   13 
 drivers/media/IR/ir-keytable.c              |  710 ------------
 drivers/media/IR/ir-lirc-codec.c            |  121 +-
 drivers/media/IR/ir-nec-decoder.c           |   15 
 drivers/media/IR/ir-raw-event.c             |  382 ------
 drivers/media/IR/ir-rc5-decoder.c           |   13 
 drivers/media/IR/ir-rc5-sz-decoder.c        |   13 
 drivers/media/IR/ir-rc6-decoder.c           |   17 
 drivers/media/IR/ir-sony-decoder.c          |   11 
 drivers/media/IR/ir-sysfs.c                 |  362 ------
 drivers/media/IR/mceusb.c                   |  105 +-
 drivers/media/IR/nuvoton-cir.c              |   85 +
 drivers/media/IR/nuvoton-cir.h              |    3 
 drivers/media/IR/rc-main.c                  | 1135 +++++++++++++++++++
 drivers/media/IR/rc-map.c                   |  107 --
 drivers/media/IR/rc-raw.c                   |  371 ++++++
 drivers/media/IR/streamzap.c                |   66 -
 drivers/media/IR/winbond-cir.c              |  932 ++++++++++++++++
 drivers/media/dvb/dm1105/Kconfig            |    3 
 drivers/media/dvb/dm1105/dm1105.c           |   42 -
 drivers/media/dvb/dvb-usb/af9015.c          |   16 
 drivers/media/dvb/dvb-usb/anysee.c          |    2 
 drivers/media/dvb/dvb-usb/dib0700.h         |    2 
 drivers/media/dvb/dvb-usb/dib0700_core.c    |    8 
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  144 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c  |   77 +
 drivers/media/dvb/dvb-usb/dvb-usb.h         |   12 
 drivers/media/dvb/dvb-usb/lmedm04.c         |   42 -
 drivers/media/dvb/mantis/mantis_common.h    |    4 
 drivers/media/dvb/mantis/mantis_input.c     |   71 +
 drivers/media/dvb/siano/smscoreapi.c        |    2 
 drivers/media/dvb/siano/smsir.c             |   52 -
 drivers/media/dvb/siano/smsir.h             |    3 
 drivers/media/dvb/ttpci/Kconfig             |    3 
 drivers/media/dvb/ttpci/budget-ci.c         |   49 -
 drivers/media/video/Kconfig                 |    2 
 drivers/media/video/bt8xx/Kconfig           |    4 
 drivers/media/video/bt8xx/bttv-input.c      |   73 -
 drivers/media/video/bt8xx/bttvp.h           |    1 
 drivers/media/video/cx18/Kconfig            |    3 
 drivers/media/video/cx231xx/Kconfig         |    4 
 drivers/media/video/cx23885/cx23885-input.c |   64 +
 drivers/media/video/cx23885/cx23885.h       |    3 
 drivers/media/video/cx88/Kconfig            |    3 
 drivers/media/video/cx88/cx88-input.c       |  233 +---
 drivers/media/video/em28xx/Kconfig          |    4 
 drivers/media/video/em28xx/em28xx-input.c   |   72 +
 drivers/media/video/ir-kbd-i2c.c            |   28 
 drivers/media/video/ivtv/Kconfig            |    3 
 drivers/media/video/saa7134/Kconfig         |    2 
 drivers/media/video/saa7134/saa7134-input.c |  121 +-
 drivers/media/video/tlg2300/Kconfig         |    4 
 drivers/staging/cx25821/Kconfig             |    4 
 drivers/staging/go7007/Kconfig              |    4 
 drivers/staging/tm6000/tm6000-input.c       |   98 +-
 include/media/ir-common.h                   |   38 -
 include/media/ir-core.h                     |  201 ++-
 include/media/ir-kbd-i2c.h                  |    7 
 68 files changed, 3410 insertions(+), 4691 deletions(-)
 delete mode 100644 drivers/input/misc/winbond-cir.c
 delete mode 100644 drivers/media/IR/ir-keytable.c
 delete mode 100644 drivers/media/IR/ir-raw-event.c
 delete mode 100644 drivers/media/IR/ir-sysfs.c
 create mode 100644 drivers/media/IR/rc-main.c
 delete mode 100644 drivers/media/IR/rc-map.c
 create mode 100644 drivers/media/IR/rc-raw.c
 create mode 100644 drivers/media/IR/winbond-cir.c

-- 
David Härdeman
