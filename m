Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39719 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752355AbcJKKfW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>
Subject: [PATCH v2 00/31]  Don't use stack for DMA transers on media usb drivers
Date: Tue, 11 Oct 2016 07:09:15 -0300
Message-Id: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sending URB control messages from stack was never supported. Yet, on x86,
the stack was usually at a memory region that allows DMA transfer.

So, several drivers got it wrong. On Kernel 4.9, if VMAP_STACK=y, none of
those drivers will work, as the stack won't be on a DMA-able area anymore.

So, fix the media drivers that requre it. It should noticed that the vast
majority are at dvb-usb.

Please notice that those patches are compile-tested only.  So, I really 
appreciate if people with devices using those drivers could test and 
report if they don't break anything. I intend to send this 

PS.: I didn't verify any media driver inside staging.

Version 2:

- Added other USB drivers that are out of dvb-usb. After this series, all
  drivers will use kmalloc'ed buffers, although I won't doubt that some
  implementations may still have issues.

- Be sure that, on all places where it is using a buffer allocated at the
  dvb-usb state structs, they'll be protected by some mutex. On some
  such cases, there was already a mutex at the DVB core. So, I didn't
  need to add a new one. Thanks to Antti that reminded me about such
  need.


Mauro Carvalho Chehab (31):
  af9005: don't do DMA on stack
  cinergyT2-core: don't do DMA on stack
  cinergyT2-core: handle error code on RC query
  cinergyT2-fe: cache stats at cinergyt2_fe_read_status()
  cinergyT2-fe: don't do DMA on stack
  cxusb: don't do DMA on stack
  dib0700: be sure that dib0700_ctrl_rd() users can do DMA
  dib0700_core: don't use stack on I2C reads
  dibusb: don't do DMA on stack
  dibusb: handle error code on RC query
  digitv: don't do DMA on stack
  dtt200u-fe: don't keep waiting for lock at set_frontend()
  dtt200u-fe: don't do DMA on stack
  dtt200u-fe: handle errors on USB control messages
  dtt200u: don't do DMA on stack
  dtt200u: handle USB control message errors
  dtv5100: don't do DMA on stack
  gp8psk: don't do DMA on stack
  gp8psk: don't go past the buffer size
  nova-t-usb2: don't do DMA on stack
  pctv452e: don't do DMA on stack
  pctv452e: don't call BUG_ON() on non-fatal error
  technisat-usb2: use DMA buffers for I2C transfers
  dvb-usb: warn if return value for USB read/write routines is not
    checked
  nova-t-usb2: handle error code on RC query
  dw2102: return error if su3000_power_ctrl() fails
  digitv: handle error code on RC query
  cpia2_usb: don't use stack for DMA
  s2255drv: don't use stack for DMA
  stk-webcam: don't use stack for DMA
  flexcop-usb: don't use stack for DMA

 drivers/media/usb/b2c2/flexcop-usb.c        | 105 +++++----
 drivers/media/usb/b2c2/flexcop-usb.h        |   4 +
 drivers/media/usb/cpia2/cpia2_usb.c         |  32 ++-
 drivers/media/usb/dvb-usb/af9005.c          | 317 ++++++++++++++++------------
 drivers/media/usb/dvb-usb/cinergyT2-core.c  |  90 +++++---
 drivers/media/usb/dvb-usb/cinergyT2-fe.c    | 100 ++++-----
 drivers/media/usb/dvb-usb/cxusb.c           |  62 +++---
 drivers/media/usb/dvb-usb/cxusb.h           |   6 +
 drivers/media/usb/dvb-usb/dib0700_core.c    |  31 ++-
 drivers/media/usb/dvb-usb/dib0700_devices.c |  25 +--
 drivers/media/usb/dvb-usb/dibusb-common.c   | 113 +++++++---
 drivers/media/usb/dvb-usb/dibusb.h          |   3 +
 drivers/media/usb/dvb-usb/digitv.c          |  26 ++-
 drivers/media/usb/dvb-usb/digitv.h          |   3 +
 drivers/media/usb/dvb-usb/dtt200u-fe.c      | 128 +++++++----
 drivers/media/usb/dvb-usb/dtt200u.c         | 120 ++++++++---
 drivers/media/usb/dvb-usb/dtv5100.c         |  10 +-
 drivers/media/usb/dvb-usb/dvb-usb.h         |   6 +-
 drivers/media/usb/dvb-usb/dw2102.c          |   2 +-
 drivers/media/usb/dvb-usb/gp8psk.c          |  25 ++-
 drivers/media/usb/dvb-usb/nova-t-usb2.c     |  25 ++-
 drivers/media/usb/dvb-usb/pctv452e.c        | 136 +++++++-----
 drivers/media/usb/dvb-usb/technisat-usb2.c  |  16 +-
 drivers/media/usb/s2255/s2255drv.c          |  15 +-
 drivers/media/usb/stkwebcam/stk-webcam.c    |  16 +-
 25 files changed, 918 insertions(+), 498 deletions(-)

-- 
2.7.4


