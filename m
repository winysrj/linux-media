Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55371
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753137AbcKEKwA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 Nov 2016 06:52:00 -0400
Date: Sat, 5 Nov 2016 08:51:53 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.9-rc4] media fixes
Message-ID: <20161105085153.38ecb45a@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.9-3

For a series of fixup patches meant to fix the usage of DMA on stack, 
plus one warning fixup.

---

PS.: I tried to send it earlier, but I was unable to send this patch series
from Santa Fé. I guess kernel.org doesn't like very much a different IP
block than the one I usually use.

The following changes since commit 9fce0c226536fc36c7fb0a80000ca38a995be43e:

  Merge tag 'v4.8' into patchwork (2016-10-05 16:43:53 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.9-3

for you to fetch changes up to 1aeb5b615cd10db7324d4e4d167c4916dfeca311:

  [media] radio-bcm2048: don't ignore errors (2016-10-17 12:13:36 -0200)

----------------------------------------------------------------
media fixes for v4.9-rc4

----------------------------------------------------------------
Mauro Carvalho Chehab (31):
      [media] af9005: don't do DMA on stack
      [media] cinergyT2-core: don't do DMA on stack
      [media] cinergyT2-core: handle error code on RC query
      [media] cinergyT2-fe: cache stats at cinergyt2_fe_read_status()
      [media] cinergyT2-fe: don't do DMA on stack
      [media] cxusb: don't do DMA on stack
      [media] dib0700: be sure that dib0700_ctrl_rd() users can do DMA
      [media] dib0700_core: don't use stack on I2C reads
      [media] dibusb: don't do DMA on stack
      [media] dibusb: handle error code on RC query
      [media] digitv: don't do DMA on stack
      [media] dtt200u-fe: don't keep waiting for lock at set_frontend()
      [media] dtt200u-fe: don't do DMA on stack
      [media] dtt200u-fe: handle errors on USB control messages
      [media] dtt200u: don't do DMA on stack
      [media] dtt200u: handle USB control message errors
      [media] dtv5100: don't do DMA on stack
      [media] gp8psk: don't do DMA on stack
      [media] gp8psk: don't go past the buffer size
      [media] nova-t-usb2: don't do DMA on stack
      [media] pctv452e: don't do DMA on stack
      [media] pctv452e: don't call BUG_ON() on non-fatal error
      [media] technisat-usb2: use DMA buffers for I2C transfers
      [media] nova-t-usb2: handle error code on RC query
      [media] dw2102: return error if su3000_power_ctrl() fails
      [media] digitv: handle error code on RC query
      [media] cpia2_usb: don't use stack for DMA
      [media] s2255drv: don't use stack for DMA
      [media] stk-webcam: don't use stack for DMA
      [media] flexcop-usb: don't use stack for DMA
      [media] radio-bcm2048: don't ignore errors

kbuild test robot (1):
      [media] pctv452e: fix semicolon.cocci warnings

 drivers/media/usb/b2c2/flexcop-usb.c          | 105 ++++++---
 drivers/media/usb/b2c2/flexcop-usb.h          |   4 +
 drivers/media/usb/cpia2/cpia2_usb.c           |  34 ++-
 drivers/media/usb/dvb-usb/af9005.c            | 319 +++++++++++++++-----------
 drivers/media/usb/dvb-usb/cinergyT2-core.c    |  90 ++++++--
 drivers/media/usb/dvb-usb/cinergyT2-fe.c      | 100 +++-----
 drivers/media/usb/dvb-usb/cxusb.c             |  62 ++---
 drivers/media/usb/dvb-usb/cxusb.h             |   6 +
 drivers/media/usb/dvb-usb/dib0700_core.c      |  31 ++-
 drivers/media/usb/dvb-usb/dib0700_devices.c   |  25 +-
 drivers/media/usb/dvb-usb/dibusb-common.c     | 113 ++++++---
 drivers/media/usb/dvb-usb/dibusb.h            |   3 +
 drivers/media/usb/dvb-usb/digitv.c            |  26 ++-
 drivers/media/usb/dvb-usb/digitv.h            |   5 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c        | 128 +++++++----
 drivers/media/usb/dvb-usb/dtt200u.c           | 120 +++++++---
 drivers/media/usb/dvb-usb/dtv5100.c           |  10 +-
 drivers/media/usb/dvb-usb/dw2102.c            |   2 +-
 drivers/media/usb/dvb-usb/gp8psk.c            |  25 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c       |  25 +-
 drivers/media/usb/dvb-usb/pctv452e.c          | 136 ++++++-----
 drivers/media/usb/dvb-usb/technisat-usb2.c    |  16 +-
 drivers/media/usb/s2255/s2255drv.c            |  15 +-
 drivers/media/usb/stkwebcam/stk-webcam.c      |  16 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c |   2 +
 25 files changed, 919 insertions(+), 499 deletions(-)

