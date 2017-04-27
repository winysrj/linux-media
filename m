Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:55209 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755330AbdD0Ud4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 16:33:56 -0400
Subject: [PATCH 0/6] rc-core - protocol in keytables
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Thu, 27 Apr 2017 22:33:52 +0200
Message-ID: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first three patches are just some cleanups that I noticed
while working on the other patches.

The fourth and fifth patch change rc-core over to use NEC32
scancodes everywhere. That might seem like a recipe for
breaking userspace...but, as you'll see with the sixth patch,
we can't really avoid it if we want to improve the
EVIOC[GS]KEYCODE_V2 ioctl():s to support protocols.

And since it was requested last time around, I have written
a much longer explanation of the NEC32/ioctl patches and
posted here (with pretty pictures):
https://david.hardeman.nu/rccore/

Most of you might want to skip the introduction part :)

---

David Härdeman (6):
      rc-core: fix input repeat handling
      rc-core: cleanup rc_register_device
      rc-core: cleanup rc_register_device pt2
      rc-core: use the full 32 bits for NEC scancodes in wakefilters
      rc-core: use the full 32 bits for NEC scancodes
      rc-core: add protocol to EVIOC[GS]KEYCODE_V2 ioctl


 drivers/media/pci/cx88/cx88-input.c       |    4 
 drivers/media/pci/saa7134/saa7134-input.c |    4 
 drivers/media/rc/ati_remote.c             |    1 
 drivers/media/rc/igorplugusb.c            |    4 
 drivers/media/rc/img-ir/img-ir-nec.c      |   92 +------
 drivers/media/rc/imon.c                   |    7 -
 drivers/media/rc/ir-nec-decoder.c         |   63 +----
 drivers/media/rc/rc-core-priv.h           |    2 
 drivers/media/rc/rc-ir-raw.c              |   34 ++
 drivers/media/rc/rc-main.c                |  406 ++++++++++++++++++-----------
 drivers/media/rc/winbond-cir.c            |   32 --
 drivers/media/usb/au0828/au0828-input.c   |    3 
 drivers/media/usb/dvb-usb-v2/af9015.c     |   30 --
 drivers/media/usb/dvb-usb-v2/af9035.c     |   27 --
 drivers/media/usb/dvb-usb-v2/az6007.c     |   25 --
 drivers/media/usb/dvb-usb-v2/lmedm04.c    |    5 
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c   |   29 +-
 drivers/media/usb/dvb-usb/dib0700_core.c  |   25 --
 drivers/media/usb/dvb-usb/dtt200u.c       |   25 +-
 drivers/media/usb/em28xx/em28xx-input.c   |   22 --
 include/media/rc-core.h                   |   28 ++
 include/media/rc-map.h                    |   53 ++--
 22 files changed, 412 insertions(+), 509 deletions(-)

--
David Härdeman
