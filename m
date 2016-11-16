Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49762 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753891AbcKPQnT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Inki Dae <inki.dae@samsung.com>, Ole Ernst <olebowle@gmx.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sean Young <sean@mess.org>, mjpeg-users@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kamil Debski <kamil@wypas.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hansverk@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Backway <stev391@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mike Isely <isely@pobox.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Max Kellermann <max@duempel.org>
Subject: [PATCH 00/35] Some printk fixups and improvements
Date: Wed, 16 Nov 2016 14:42:32 -0200
Message-Id: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Kernel 4.9, the KERN_CONT level is mandatory. So, we need to fix those
at the drivers. However, lots of media drivers don't follow the good practices
of using dev_foo() or pr_foo() macros.

This series convert several drivers the upstream debug macros, and fix
the issues related to KERN_CONT where needed.

I have another set of patches with dev_foo() conversions, but those require
manual testing, as a bad conversion could cause crashes or bad displayed
messages.

So, let's fix the easy cases. I'll keep working on the other patches when I
have spare time.

Please notice that today I merged a series of patches that may cause conflicts
with this series. I'll address it when merging it back at the media_tree.git, in a
couple of days.

Mauro Carvalho Chehab (35):
  [media] stb0899_drv: get rid of continuation lines
  [media] stv090x: get rid of continuation lines
  [media] bt8xx/dst: use a more standard way to print messages
  [media] bt8xx: use pr_foo() macros instead of printk()
  [media] cx23885: use KERN_CONT where needed
  [media] cx23885: convert it to use pr_foo() macros
  [media] cx88: use KERN_CONT where needed
  [media] cx88: convert it to use pr_foo() macros
  [media] cx88: make checkpatch happier
  [media] pluto2: use KERN_CONT where needed
  [media] zoran: use KERN_CONT where needed
  [media] wl128x: use KERNEL_CONT where needed
  [media] pvrusb2: use KERNEL_CONT where needed
  [media] ttusb_dec: use KERNEL_CONT where needed
  [media] ttpci: cleanup debug macros and remove dead code
  [media] dib0070: use pr_foo() instead of printk()
  [media] dib0090: use pr_foo() instead of printk()
  [media] dib3000mb: use pr_foo() instead of printk()
  [media] dib3000mc: use pr_foo() instead of printk()
  [media] dib7000m: use pr_foo() instead of printk()
  [media] dib7000p: use pr_foo() instead of printk()
  [media] dib8000: use pr_foo() instead of printk()
  [media] dib9000: use pr_foo() instead of printk()
  [media] dibx000_common: use pr_foo() instead of printk()
  [media] af9005: remove a printk that would require a KERN_CONT
  [media] tuner-core: use pr_foo, instead of internal printk macros
  [media] v4l2-common: add a debug macro to be used with dev_foo()
  [media] msp3400-driver: don't use KERN_CONT
  [media] msp3400: convert it to use dev_foo() macros
  [media] em28xx: convert it from pr_foo() to dev_foo()
  [media] tvp5150: convert it to use dev_foo() macros
  [media] tvp5150: Get rid of direct calls to printk()
  [media] tvp5150: get rid of KERN_CONT
  [media] rc-main: use pr_foo() macros
  [media] tveeprom: print log messages using pr_foo()

 drivers/media/common/tveeprom.c              |  42 ++--
 drivers/media/dvb-frontends/dib0070.c        |  52 ++---
 drivers/media/dvb-frontends/dib0090.c        | 164 +++++++--------
 drivers/media/dvb-frontends/dib3000mb.c      | 137 ++++++-------
 drivers/media/dvb-frontends/dib3000mb_priv.h |  16 +-
 drivers/media/dvb-frontends/dib3000mc.c      |   8 +-
 drivers/media/dvb-frontends/dib7000m.c       |  73 ++++---
 drivers/media/dvb-frontends/dib7000p.c       | 127 ++++++------
 drivers/media/dvb-frontends/dib8000.c        | 261 ++++++++++++------------
 drivers/media/dvb-frontends/dib9000.c        | 171 ++++++++--------
 drivers/media/dvb-frontends/dibx000_common.c |  36 ++--
 drivers/media/dvb-frontends/stb0899_drv.c    |  21 +-
 drivers/media/dvb-frontends/stv090x.c        |  10 +-
 drivers/media/i2c/msp3400-driver.c           |  90 ++++----
 drivers/media/i2c/msp3400-kthreads.c         | 115 ++++++-----
 drivers/media/i2c/tvp5150.c                  | 295 ++++++++++++++-------------
 drivers/media/pci/bt8xx/btcx-risc.c          |  46 +++--
 drivers/media/pci/bt8xx/dst.c                | 262 +++++++++++-------------
 drivers/media/pci/bt8xx/dvb-bt8xx.c          |  25 ++-
 drivers/media/pci/cx23885/altera-ci.c        |  13 +-
 drivers/media/pci/cx23885/altera-ci.h        |  14 +-
 drivers/media/pci/cx23885/cimax2.c           |   8 +-
 drivers/media/pci/cx23885/cx23885-417.c      |  57 +++---
 drivers/media/pci/cx23885/cx23885-alsa.c     |  21 +-
 drivers/media/pci/cx23885/cx23885-cards.c    |  49 +++--
 drivers/media/pci/cx23885/cx23885-core.c     | 139 ++++++-------
 drivers/media/pci/cx23885/cx23885-dvb.c      |  40 ++--
 drivers/media/pci/cx23885/cx23885-f300.c     |   2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c      |  27 ++-
 drivers/media/pci/cx23885/cx23885-input.c    |   6 +-
 drivers/media/pci/cx23885/cx23885-ir.c       |   4 +-
 drivers/media/pci/cx23885/cx23885-vbi.c      |   7 +-
 drivers/media/pci/cx23885/cx23885-video.c    |  23 ++-
 drivers/media/pci/cx23885/cx23885.h          |   2 +
 drivers/media/pci/cx23885/cx23888-ir.c       |   6 +-
 drivers/media/pci/cx23885/netup-eeprom.c     |   4 +-
 drivers/media/pci/cx23885/netup-init.c       |   8 +-
 drivers/media/pci/cx88/cx88-alsa.c           | 104 +++++-----
 drivers/media/pci/cx88/cx88-blackbird.c      | 125 ++++++------
 drivers/media/pci/cx88/cx88-cards.c          | 188 ++++++++---------
 drivers/media/pci/cx88/cx88-core.c           | 245 +++++++++++-----------
 drivers/media/pci/cx88/cx88-dsp.c            |  37 ++--
 drivers/media/pci/cx88/cx88-dvb.c            | 173 ++++++++--------
 drivers/media/pci/cx88/cx88-i2c.c            | 108 +++++-----
 drivers/media/pci/cx88/cx88-input.c          |  21 +-
 drivers/media/pci/cx88/cx88-mpeg.c           | 216 +++++++++-----------
 drivers/media/pci/cx88/cx88-reg.h            |   5 +-
 drivers/media/pci/cx88/cx88-tvaudio.c        | 102 +++++----
 drivers/media/pci/cx88/cx88-vbi.c            |  32 +--
 drivers/media/pci/cx88/cx88-video.c          | 266 ++++++++++++------------
 drivers/media/pci/cx88/cx88-vp3054-i2c.c     |  50 ++---
 drivers/media/pci/cx88/cx88.h                |  40 ++--
 drivers/media/pci/pluto2/pluto2.c            |   4 +-
 drivers/media/pci/ttpci/av7110.c             |  15 --
 drivers/media/pci/ttpci/av7110.h             |   7 +-
 drivers/media/pci/ttpci/budget.h             |   8 +-
 drivers/media/pci/zoran/zoran_device.c       |  35 ++--
 drivers/media/radio/wl128x/fmdrv_common.c    |  16 +-
 drivers/media/rc/rc-main.c                   |   8 +-
 drivers/media/usb/dvb-usb/af9005.c           |   1 -
 drivers/media/usb/em28xx/em28xx-audio.c      |  64 +++---
 drivers/media/usb/em28xx/em28xx-camera.c     |  60 ++++--
 drivers/media/usb/em28xx/em28xx-cards.c      | 129 +++++++-----
 drivers/media/usb/em28xx/em28xx-core.c       | 154 +++++++-------
 drivers/media/usb/em28xx/em28xx-dvb.c        |  89 ++++----
 drivers/media/usb/em28xx/em28xx-i2c.c        | 284 ++++++++++++++------------
 drivers/media/usb/em28xx/em28xx-input.c      |  42 ++--
 drivers/media/usb/em28xx/em28xx-vbi.c        |   6 +-
 drivers/media/usb/em28xx/em28xx-video.c      | 127 +++++++-----
 drivers/media/usb/em28xx/em28xx.h            |   3 -
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |  14 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c      |  14 +-
 drivers/media/v4l2-core/tuner-core.c         | 106 +++++-----
 include/media/v4l2-common.h                  |   7 +
 74 files changed, 2638 insertions(+), 2648 deletions(-)

-- 
2.7.4


