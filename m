Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38287 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaC2QKt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 12:10:49 -0400
Subject: [PATCH 00/11] rc-core: My current patch queue
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: james.hogan@imgtec.com, m.chehab@samsung.com
Date: Sat, 29 Mar 2014 17:10:45 +0100
Message-ID: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is my current patch queue, I've resent the whole queue since there
are some patches that conflict with patches that James have sent to the
list.

The first three patches should not be controversial since they only do
cleanups/documentation (already posted to the list).

The next three patches are mostly for James to review.

Then there are three more patches to make sure NECX is handled in a
consitent manner (I've already asked for feedback for some of these).

The last two patches are only RFCs at this stage, but they show how
I think we should solve the NEC scancode issue in the long run (by
treating NEC16, NECX, NEC32 as NEC32 simply...and converting as
necessary...also a new ioctl to make the protocol explicit, which
has value for all protocols).

---

David Härdeman (11):
      bt8xx: fixup RC5 decoding
      rc-core: improve ir-kbd-i2c get_key functions
      rc-core: document the protocol type
      rc-core: do not change 32bit NEC scancode format for now
      rc-core: split dev->s_filter
      rc-core: remove generic scancode filter
      dib0700: NEC scancode cleanup
      lmedm04: NEC scancode cleanup
      saa7134: NEC scancode fix
      [RFC] rc-core: use the full 32 bits for NEC scancodes
      [RFC] rc-core: don't throw away protocol information


 drivers/media/i2c/ir-kbd-i2c.c              |   91 ++++---
 drivers/media/pci/bt8xx/bttv-input.c        |   78 +++---
 drivers/media/pci/bt8xx/bttvp.h             |    2 
 drivers/media/pci/cx88/cx88-input.c         |   34 ++-
 drivers/media/pci/dm1105/dm1105.c           |    3 
 drivers/media/pci/ivtv/ivtv-i2c.c           |    9 -
 drivers/media/pci/saa7134/saa7134-input.c   |   86 ++++---
 drivers/media/pci/ttpci/budget-ci.c         |    8 -
 drivers/media/rc/img-ir/img-ir-hw.c         |   23 +-
 drivers/media/rc/img-ir/img-ir-hw.h         |    3 
 drivers/media/rc/img-ir/img-ir-jvc.c        |    4 
 drivers/media/rc/img-ir/img-ir-nec.c        |   80 +-----
 drivers/media/rc/img-ir/img-ir-sanyo.c      |    4 
 drivers/media/rc/img-ir/img-ir-sharp.c      |    4 
 drivers/media/rc/img-ir/img-ir-sony.c       |   12 +
 drivers/media/rc/ir-jvc-decoder.c           |    2 
 drivers/media/rc/ir-nec-decoder.c           |   33 ---
 drivers/media/rc/ir-rc5-decoder.c           |    5 
 drivers/media/rc/ir-rc5-sz-decoder.c        |    2 
 drivers/media/rc/ir-rc6-decoder.c           |   37 ++-
 drivers/media/rc/ir-sanyo-decoder.c         |    2 
 drivers/media/rc/ir-sharp-decoder.c         |    2 
 drivers/media/rc/ir-sony-decoder.c          |    6 
 drivers/media/rc/keymaps/rc-behold.c        |   68 +++--
 drivers/media/rc/keymaps/rc-lme2510.c       |   80 +++---
 drivers/media/rc/keymaps/rc-nebula.c        |  112 ++++-----
 drivers/media/rc/keymaps/rc-tivo.c          |   95 ++++---
 drivers/media/rc/rc-main.c                  |  344 ++++++++++++++++++++-------
 drivers/media/usb/cx231xx/cx231xx-input.c   |   20 +-
 drivers/media/usb/dvb-usb-v2/af9015.c       |   22 --
 drivers/media/usb/dvb-usb-v2/af9035.c       |   16 -
 drivers/media/usb/dvb-usb-v2/anysee.c       |    3 
 drivers/media/usb/dvb-usb-v2/az6007.c       |   17 -
 drivers/media/usb/dvb-usb-v2/lmedm04.c      |   25 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |   18 -
 drivers/media/usb/dvb-usb/dib0700_core.c    |   39 +--
 drivers/media/usb/dvb-usb/dib0700_devices.c |   24 +-
 drivers/media/usb/dvb-usb/dw2102.c          |    7 -
 drivers/media/usb/dvb-usb/m920x.c           |    2 
 drivers/media/usb/dvb-usb/pctv452e.c        |    8 -
 drivers/media/usb/dvb-usb/ttusb2.c          |    6 
 drivers/media/usb/em28xx/em28xx-input.c     |   98 ++++----
 drivers/media/usb/tm6000/tm6000-input.c     |   51 +++-
 include/media/ir-kbd-i2c.h                  |    6 
 include/media/rc-core.h                     |   34 ++-
 include/media/rc-map.h                      |   26 ++
 46 files changed, 930 insertions(+), 721 deletions(-)

-- 
David Härdeman
