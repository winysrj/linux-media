Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37266 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaCYXj0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 19:39:26 -0400
Subject: [PATCH 0/3] Series short description
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: m.chehab@samsung.com
Date: Wed, 26 Mar 2014 00:39:23 +0100
Message-ID: <20140325232708.3091.38348.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following series implements...

---

David Härdeman (3):
      bt8xx: fixup RC5 decoding
      rc-core: improve ir-kbd-i2c get_key functions
      rc-core: document the protocol type


 drivers/media/i2c/ir-kbd-i2c.c              |   91 +++++++++++-----------
 drivers/media/pci/bt8xx/bttv-input.c        |   78 ++++++++++---------
 drivers/media/pci/bt8xx/bttvp.h             |    2 
 drivers/media/pci/cx88/cx88-input.c         |   34 ++++++--
 drivers/media/pci/dm1105/dm1105.c           |    3 -
 drivers/media/pci/ivtv/ivtv-i2c.c           |    9 +-
 drivers/media/pci/saa7134/saa7134-input.c   |   82 ++++++++++++--------
 drivers/media/pci/ttpci/budget-ci.c         |    8 +-
 drivers/media/rc/img-ir/img-ir-hw.c         |    8 +-
 drivers/media/rc/img-ir/img-ir-hw.h         |    3 -
 drivers/media/rc/img-ir/img-ir-jvc.c        |    4 +
 drivers/media/rc/img-ir/img-ir-nec.c        |    4 +
 drivers/media/rc/img-ir/img-ir-sanyo.c      |    4 +
 drivers/media/rc/img-ir/img-ir-sharp.c      |    4 +
 drivers/media/rc/img-ir/img-ir-sony.c       |   12 ++-
 drivers/media/rc/ir-jvc-decoder.c           |    2 
 drivers/media/rc/ir-nec-decoder.c           |    2 
 drivers/media/rc/ir-rc5-decoder.c           |    5 +
 drivers/media/rc/ir-rc5-sz-decoder.c        |    2 
 drivers/media/rc/ir-rc6-decoder.c           |   37 +++++++--
 drivers/media/rc/ir-sanyo-decoder.c         |    2 
 drivers/media/rc/ir-sharp-decoder.c         |    2 
 drivers/media/rc/ir-sony-decoder.c          |    6 +
 drivers/media/rc/keymaps/rc-nebula.c        |  112 ++++++++++++++-------------
 drivers/media/rc/rc-main.c                  |   32 +++++---
 drivers/media/usb/cx231xx/cx231xx-input.c   |   20 ++---
 drivers/media/usb/dvb-usb-v2/af9015.c       |   18 +++-
 drivers/media/usb/dvb-usb-v2/af9035.c       |    9 +-
 drivers/media/usb/dvb-usb-v2/anysee.c       |    3 -
 drivers/media/usb/dvb-usb-v2/az6007.c       |   25 +++---
 drivers/media/usb/dvb-usb-v2/lmedm04.c      |    9 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |   12 +--
 drivers/media/usb/dvb-usb/dib0700_core.c    |   16 ++--
 drivers/media/usb/dvb-usb/dib0700_devices.c |   24 +++---
 drivers/media/usb/dvb-usb/dw2102.c          |    7 +-
 drivers/media/usb/dvb-usb/m920x.c           |    2 
 drivers/media/usb/dvb-usb/pctv452e.c        |    8 +-
 drivers/media/usb/dvb-usb/ttusb2.c          |    6 +
 drivers/media/usb/em28xx/em28xx-input.c     |   98 ++++++++++++++----------
 drivers/media/usb/tm6000/tm6000-input.c     |   51 ++++++++----
 include/media/ir-kbd-i2c.h                  |    6 +
 include/media/rc-core.h                     |    6 +
 include/media/rc-map.h                      |   10 ++
 43 files changed, 512 insertions(+), 366 deletions(-)

-- 
Signature
