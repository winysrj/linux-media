Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63578 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752478AbeCBTfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 14:35:00 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/8] em28xx: some improvements
Date: Fri,  2 Mar 2018 16:34:41 -0300
Message-Id: <cover.1520018558.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch in this series change the em28xx to don't
require coherent memory for DMA transfers. This should bring
some performance gains on non-x86 archs.

The other patches in this series are results of my tests
with the first patch :-)

patch 2 does some cleanups at i2c and Xclock speed settings.

Patches 3 and 4 do something that I'm intending to do for a
long time: it constifies most static structs inside the driver.
Before that, the cards list were modified in runtime, with is
a bad idea when multiple (but different) boards use the same
entry (for example, a webcam and a em28xx capture "generic"
board).

Patch 5 solves a FIXME.

Patch 6 was written by Arnd, as a way to solve an issue with
KASAN: without it, more than 4Kbytes were spent at the stack,
with can cause very bad things. He sent it sometime ago.

As I answered when the patchset was sent, I didn't like very
much that approach, as a way to solve KASAN, as the real solution
is to improve the I2C binding logic inside this (and other)
drivers. Yet, it brings a nice cleanup at em28xx.

So, patch 7 does that! It is something that I'm wanting to do
for a long time, but only today I found the needed time: it 
adds helper functions at the DVB core in order to bind/unbind
I2C modules to a driver. It is aligned with the new I2C
binding work made by Antti.

Patch 8 converts em28xx-dvb to use the new dvb_module_probe()
and dvb_module_release() fuctions, with caused a reduction
of almost 10% on the size of this module!

A side effect of patches 7 and 8 is that we don't to use
noinline_for_stack "black" magic there anymore, with is a
good thing.

Arnd Bergmann (1):
  media: em28xx: split up em28xx_dvb_init to reduce stack size

Mauro Carvalho Chehab (7):
  media: em28xx: don't use coherent buffer for DMA transfers
  media: em28xx: improve the logic with sets Xclk and I2C speed
  media: em28xx: stop rewriting device's struct
  media: em28xx: constify most static structs
  media: em28xx: adjust I2C timeout according with I2C speed
  media: dvb-core: add helper functions for I2C binding
  media: em28xx-dvb: simplify DVB module probing logic

 drivers/media/dvb-core/dvbdev.c         |  48 ++
 drivers/media/usb/em28xx/em28xx-cards.c | 163 +++----
 drivers/media/usb/em28xx/em28xx-core.c  |  57 ++-
 drivers/media/usb/em28xx/em28xx-dvb.c   | 775 ++++++++++++--------------------
 drivers/media/usb/em28xx/em28xx-i2c.c   |  36 +-
 drivers/media/usb/em28xx/em28xx-input.c |   6 +-
 drivers/media/usb/em28xx/em28xx-video.c |  24 +-
 drivers/media/usb/em28xx/em28xx.h       |  39 +-
 include/media/dvbdev.h                  |  65 ++-
 9 files changed, 579 insertions(+), 634 deletions(-)

-- 
2.14.3
