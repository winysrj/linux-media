Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:56255 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab0IGVvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 17:51:43 -0400
Subject: [PATCH 0/5] rc-core: ir-core to rc-core conversion (v2)
To: mchehab@infradead.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, jarod@redhat.com
Date: Tue, 07 Sep 2010 23:51:38 +0200
Message-ID: <20100907214943.30935.29895.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This is my current patch queue, the main change is to make struct rc_dev
the primary interface for rc drivers and to abstract away the fact that
there's an input device lurking in there somewhere. The first three
patches in the set are preparations for the change.

I've also converted winbond-cir over to rc-core.

Given the changes, these patches touch every single driver. Obviously I
haven't tested them all due to a lack of hardware (I have made sure that
all drivers compile without any warnings and I have tested the end result
on mceusb and winbond-cir hardware).

v2: rebased to take recent streamzap driver changes into account

---

David Härdeman (5):
      rc-code: merge and rename ir-core
      rc-core: remove remaining users of the ir-functions keyhandlers
      imon: split mouse events to a separate input dev
      rc-core: make struct rc_dev the primary interface for rc drivers
      rc-core: convert winbond-cir


 drivers/input/misc/Kconfig                  |   18 
 drivers/input/misc/Makefile                 |    1 
 drivers/input/misc/winbond-cir.c            | 1608 ---------------------------
 drivers/media/IR/Kconfig                    |   17 
 drivers/media/IR/Makefile                   |    4 
 drivers/media/IR/ene_ir.c                   |  121 +-
 drivers/media/IR/ene_ir.h                   |    3 
 drivers/media/IR/imon.c                     |  267 +++-
 drivers/media/IR/ir-core-priv.h             |   26 
 drivers/media/IR/ir-functions.c             |   98 --
 drivers/media/IR/ir-jvc-decoder.c           |   13 
 drivers/media/IR/ir-keytable.c              |  565 ---------
 drivers/media/IR/ir-lirc-codec.c            |  111 +-
 drivers/media/IR/ir-nec-decoder.c           |   15 
 drivers/media/IR/ir-raw-event.c             |  379 ------
 drivers/media/IR/ir-rc5-decoder.c           |   13 
 drivers/media/IR/ir-rc5-sz-decoder.c        |   13 
 drivers/media/IR/ir-rc6-decoder.c           |   17 
 drivers/media/IR/ir-sony-decoder.c          |   11 
 drivers/media/IR/ir-sysfs.c                 |  341 ------
 drivers/media/IR/mceusb.c                   |   93 +-
 drivers/media/IR/rc-core.c                  | 1317 ++++++++++++++++++++++
 drivers/media/IR/rc-map.c                   |  107 --
 drivers/media/IR/streamzap.c                |   68 -
 drivers/media/IR/winbond-cir.c              |  934 ++++++++++++++++
 drivers/media/dvb/dm1105/dm1105.c           |   40 -
 drivers/media/dvb/dvb-usb/dib0700.h         |    2 
 drivers/media/dvb/dvb-usb/dib0700_core.c    |   11 
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  116 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c  |   78 +
 drivers/media/dvb/dvb-usb/dvb-usb.h         |   12 
 drivers/media/dvb/mantis/mantis_common.h    |    4 
 drivers/media/dvb/mantis/mantis_input.c     |   74 +
 drivers/media/dvb/siano/smscoreapi.c        |    2 
 drivers/media/dvb/siano/smsir.c             |   52 -
 drivers/media/dvb/siano/smsir.h             |    3 
 drivers/media/dvb/ttpci/budget-ci.c         |   49 -
 drivers/media/video/bt8xx/bttv-input.c      |   68 -
 drivers/media/video/bt8xx/bttvp.h           |    1 
 drivers/media/video/cx18/cx18-i2c.c         |    1 
 drivers/media/video/cx23885/cx23885-input.c |   64 +
 drivers/media/video/cx23885/cx23885.h       |    3 
 drivers/media/video/cx88/cx88-input.c       |   86 +
 drivers/media/video/em28xx/em28xx-input.c   |   72 +
 drivers/media/video/ir-kbd-i2c.c            |   39 -
 drivers/media/video/ivtv/ivtv-i2c.c         |    3 
 drivers/media/video/saa7134/saa7134-input.c |  122 +-
 drivers/staging/tm6000/tm6000-input.c       |   97 +-
 include/media/ir-common.h                   |   33 -
 include/media/ir-core.h                     |  193 +--
 include/media/ir-kbd-i2c.h                  |    6 
 51 files changed, 3175 insertions(+), 4216 deletions(-)
 delete mode 100644 drivers/input/misc/winbond-cir.c
 delete mode 100644 drivers/media/IR/ir-keytable.c
 delete mode 100644 drivers/media/IR/ir-raw-event.c
 delete mode 100644 drivers/media/IR/ir-sysfs.c
 create mode 100644 drivers/media/IR/rc-core.c
 delete mode 100644 drivers/media/IR/rc-map.c
 create mode 100644 drivers/media/IR/winbond-cir.c

-- 
David Härdeman
