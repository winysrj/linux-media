Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938762AbcJGRYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:46 -0400
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
Subject: [PATCH 00/26] Don't use stack for DMA transers on dvb-usb drivers
Date: Fri,  7 Oct 2016 14:24:10 -0300
Message-Id: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sending URB control messages from stack was never supported. Yet, on x86,
the stack was usually at a memory region that allows DMA transfer.

So, several drivers got it wrong. On Kernel 4.9, if VMAP_STACK=y, none of
those drivers will work, as the stack won't be on a DMA-able area anymore.

So, fix the dvb-usb drivers that requre it.

Please notice that, while all those patches compile, I don't have devices
using those drivers to test. So, I really appreciate if people with devices
using those drivers could test and report if they don't break anything.

Thanks!
Mauro

Mauro Carvalho Chehab (26):
  af9005: don't do DMA on stack
  cinergyT2-core: don't do DMA on stack
  cinergyT2-core:: handle error code on RC query
  cinergyT2-fe: cache stats at cinergyt2_fe_read_status()
  cinergyT2-fe: don't do DMA on stack
  cxusb: don't do DMA on stack
  dib0700: be sure that dib0700_ctrl_rd() users can do DMA
  dib0700_core: don't use stack on I2C reads
  dibusb: don't do DMA on stack
  dibusb: handle error code on RC query
  digitv: don't do DMA on stack
  dtt200u-fe: don't do DMA on stack
  dtt200u-fe: handle errors on USB control messages
  dtt200u: don't do DMA on stack
  dtt200u: handle USB control message errors
  dtv5100: : don't do DMA on stack
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

 drivers/media/usb/dvb-usb/af9005.c          | 211 +++++++++++++++-------------
 drivers/media/usb/dvb-usb/cinergyT2-core.c  |  52 ++++---
 drivers/media/usb/dvb-usb/cinergyT2-fe.c    |  91 ++++--------
 drivers/media/usb/dvb-usb/cxusb.c           |  20 +--
 drivers/media/usb/dvb-usb/cxusb.h           |   5 +
 drivers/media/usb/dvb-usb/dib0700_core.c    |  31 +++-
 drivers/media/usb/dvb-usb/dib0700_devices.c |  25 ++--
 drivers/media/usb/dvb-usb/dibusb-common.c   | 112 +++++++++++----
 drivers/media/usb/dvb-usb/dibusb.h          |   5 +
 drivers/media/usb/dvb-usb/digitv.c          |  26 ++--
 drivers/media/usb/dvb-usb/digitv.h          |   3 +
 drivers/media/usb/dvb-usb/dtt200u-fe.c      |  90 ++++++++----
 drivers/media/usb/dvb-usb/dtt200u.c         |  80 +++++++----
 drivers/media/usb/dvb-usb/dtv5100.c         |  10 +-
 drivers/media/usb/dvb-usb/dvb-usb.h         |   6 +-
 drivers/media/usb/dvb-usb/dw2102.c          |   2 +-
 drivers/media/usb/dvb-usb/gp8psk.c          |  25 +++-
 drivers/media/usb/dvb-usb/nova-t-usb2.c     |  25 +++-
 drivers/media/usb/dvb-usb/pctv452e.c        | 118 ++++++++--------
 drivers/media/usb/dvb-usb/technisat-usb2.c  |  16 ++-
 20 files changed, 577 insertions(+), 376 deletions(-)

-- 
2.7.4


