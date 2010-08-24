Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:50464 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399Ab0HXXCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:03 -0400
Subject: [PATCH 0/3] Proposed ir-core (rc-core) changes
To: mchehab@infradead.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@redhat.com, linux-media@vger.kernel.org
Date: Wed, 25 Aug 2010 01:01:57 +0200
Message-ID: <20100824225427.13006.57226.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The following series merges the different files that currently make up
the ir-core module into a single-file rc-core module.

In addition, the ir_input_dev and ir_dev_props structs are replaced
by a single rc_dev struct with an API similar to that of the input
subsystem.

This allows the removal of all knowledge of any input devices from the
rc drivers and paves the way for allowing multiple input devices per
rc device in the future. The namespace conversion from ir_* to rc_*
should mostly be done for the drivers with this patchset.

I have intentionally not signed off on the patches yet since they haven't
been tested. I'd like your feedback on the general approach before I spend
the time to properly test the result.

Also, the imon driver is not converted (and will thus break with this
patchset). The reason is that the imon driver wants to generate mouse
events on the input dev under the control of rc-core. I was hoping that
Jarod would be willing to convert the imon driver to create a separate
input device for sending mouse events to userspace :)

Comments please...

---

David Härdeman (3):
      merge rc-core
      remove remaining users of the ir-functions keyhandlers
      make rc_dev the primary interface for remote control drivers


 drivers/media/IR/Makefile                   |    3 
 drivers/media/IR/ir-core-priv.h             |   26 -
 drivers/media/IR/ir-functions.c             |   96 --
 drivers/media/IR/ir-jvc-decoder.c           |   13 
 drivers/media/IR/ir-keytable.c              |  552 ------------
 drivers/media/IR/ir-lirc-codec.c            |   75 +-
 drivers/media/IR/ir-nec-decoder.c           |   13 
 drivers/media/IR/ir-raw-event.c             |  270 ------
 drivers/media/IR/ir-rc5-decoder.c           |   13 
 drivers/media/IR/ir-rc6-decoder.c           |   17 
 drivers/media/IR/ir-sony-decoder.c          |   11 
 drivers/media/IR/ir-sysfs.c                 |  354 --------
 drivers/media/IR/mceusb.c                   |   99 +-
 drivers/media/IR/rc-core.c                  | 1206 +++++++++++++++++++++++++++
 drivers/media/IR/rc-map.c                   |   84 --
 drivers/media/dvb/dm1105/dm1105.c           |   45 +
 drivers/media/dvb/mantis/mantis_common.h    |    4 
 drivers/media/dvb/mantis/mantis_input.c     |   61 +
 drivers/media/dvb/ttpci/budget-ci.c         |   49 -
 drivers/media/video/bt8xx/bttv-input.c      |   67 +-
 drivers/media/video/bt8xx/bttvp.h           |    1 
 drivers/media/video/cx18/cx18-i2c.c         |    1 
 drivers/media/video/cx23885/cx23885-input.c |   93 --
 drivers/media/video/cx88/cx88-input.c       |   86 +-
 drivers/media/video/em28xx/em28xx-input.c   |   71 +-
 drivers/media/video/ir-kbd-i2c.c            |   41 -
 drivers/media/video/ivtv/ivtv-i2c.c         |    3 
 drivers/media/video/saa7134/saa7134-input.c |  121 +--
 include/media/ir-common.h                   |   32 -
 include/media/ir-core.h                     |  155 ++-
 include/media/ir-kbd-i2c.h                  |    5 
 31 files changed, 1655 insertions(+), 2012 deletions(-)
 delete mode 100644 drivers/media/IR/ir-keytable.c
 delete mode 100644 drivers/media/IR/ir-raw-event.c
 delete mode 100644 drivers/media/IR/ir-sysfs.c
 create mode 100644 drivers/media/IR/rc-core.c
 delete mode 100644 drivers/media/IR/rc-map.c

