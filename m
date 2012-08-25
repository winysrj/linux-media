Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40351 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2HYVqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 17:46:53 -0400
Subject: [PATCH 0/8] rc-core: patches for 3.7
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jwilson@redhat.com, mchehab@redhat.com, sean@mess.org
Date: Sat, 25 Aug 2012 23:46:47 +0200
Message-ID: <20120825214520.22603.37194.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is two minor winbond-cir fixes as well as the first six patches
from my previous patchbomb.

The latter have been modified so that backwards compatibility is retained
as much as possible (the format of the sysfs files do not change for
example).

---

David Härdeman (8):
      winbond-cir: correctness fix
      winbond-cir: asynchronous tx
      rc-core: add separate defines for protocol bitmaps and numbers
      rc-core: don't throw away protocol information
      rc-core: use the full 32 bits for NEC scancodes
      rc-core: merge rc5 and streamzap decoders
      rc-core: rename ir_input_class to rc_class
      rc-core: initialize rc-core earlier if built-in


 drivers/media/common/siano/smsir.c           |    2 
 drivers/media/i2c/ir-kbd-i2c.c               |   26 +-
 drivers/media/pci/bt8xx/bttv-input.c         |   15 +
 drivers/media/pci/cx18/cx18-i2c.c            |    2 
 drivers/media/pci/cx23885/cx23885-input.c    |    6 
 drivers/media/pci/cx88/cx88-input.c          |   18 +
 drivers/media/pci/dm1105/dm1105.c            |    3 
 drivers/media/pci/ivtv/ivtv-i2c.c            |    8 -
 drivers/media/pci/saa7134/saa7134-input.c    |    8 -
 drivers/media/pci/ttpci/budget-ci.c          |    7 -
 drivers/media/rc/Kconfig                     |   12 -
 drivers/media/rc/Makefile                    |    1 
 drivers/media/rc/ati_remote.c                |   15 +
 drivers/media/rc/ene_ir.c                    |    2 
 drivers/media/rc/fintek-cir.c                |    2 
 drivers/media/rc/gpio-ir-recv.c              |    2 
 drivers/media/rc/iguanair.c                  |    2 
 drivers/media/rc/imon.c                      |   50 ++--
 drivers/media/rc/ir-jvc-decoder.c            |    6 
 drivers/media/rc/ir-lirc-codec.c             |    4 
 drivers/media/rc/ir-mce_kbd-decoder.c        |    4 
 drivers/media/rc/ir-nec-decoder.c            |   32 --
 drivers/media/rc/ir-raw.c                    |    2 
 drivers/media/rc/ir-rc5-decoder.c            |   64 +++--
 drivers/media/rc/ir-rc5-sz-decoder.c         |  154 -----------
 drivers/media/rc/ir-rc6-decoder.c            |   54 ++--
 drivers/media/rc/ir-sanyo-decoder.c          |    6 
 drivers/media/rc/ir-sony-decoder.c           |   17 +
 drivers/media/rc/ite-cir.c                   |    2 
 drivers/media/rc/keymaps/rc-imon-mce.c       |    2 
 drivers/media/rc/keymaps/rc-rc6-mce.c        |    2 
 drivers/media/rc/keymaps/rc-streamzap.c      |    4 
 drivers/media/rc/mceusb.c                    |    2 
 drivers/media/rc/nuvoton-cir.c               |    2 
 drivers/media/rc/rc-core-priv.h              |    9 -
 drivers/media/rc/rc-loopback.c               |    2 
 drivers/media/rc/rc-main.c                   |  354 ++++++++++++++++++--------
 drivers/media/rc/redrat3.c                   |    2 
 drivers/media/rc/streamzap.c                 |   12 -
 drivers/media/rc/ttusbir.c                   |    2 
 drivers/media/rc/winbond-cir.c               |   51 +---
 drivers/media/usb/cx231xx/cx231xx-input.c    |    2 
 drivers/media/usb/dvb-usb-v2/af9015.c        |   24 +-
 drivers/media/usb/dvb-usb-v2/af9035.c        |    4 
 drivers/media/usb/dvb-usb-v2/anysee.c        |    5 
 drivers/media/usb/dvb-usb-v2/az6007.c        |   19 +
 drivers/media/usb/dvb-usb-v2/dvb_usb.h       |    2 
 drivers/media/usb/dvb-usb-v2/it913x.c        |   22 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c       |    4 
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |   26 +-
 drivers/media/usb/dvb-usb/dib0700.h          |    2 
 drivers/media/usb/dvb-usb/dib0700_core.c     |   18 +
 drivers/media/usb/dvb-usb/dib0700_devices.c  |  156 ++++++-----
 drivers/media/usb/dvb-usb/dvb-usb.h          |    4 
 drivers/media/usb/dvb-usb/pctv452e.c         |   15 +
 drivers/media/usb/dvb-usb/technisat-usb2.c   |    2 
 drivers/media/usb/dvb-usb/ttusb2.c           |    4 
 drivers/media/usb/em28xx/em28xx-cards.c      |   15 +
 drivers/media/usb/em28xx/em28xx-input.c      |   44 ++-
 drivers/media/usb/em28xx/em28xx.h            |    1 
 drivers/media/usb/hdpvr/hdpvr-i2c.c          |    2 
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |    4 
 drivers/media/usb/tm6000/tm6000-cards.c      |    2 
 drivers/media/usb/tm6000/tm6000-input.c      |   80 ++++--
 include/media/ir-kbd-i2c.h                   |    2 
 include/media/rc-core.h                      |   32 ++
 include/media/rc-map.h                       |   86 +++++-
 67 files changed, 797 insertions(+), 750 deletions(-)
 delete mode 100644 drivers/media/rc/ir-rc5-sz-decoder.c

-- 
David Härdeman
