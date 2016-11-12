Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51882 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938787AbcKLOrA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 09:47:00 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] Media fixes for Kernel 4.9-rc5
Date: Sat, 12 Nov 2016 12:46:25 -0200
Message-Id: <cover.1478960480.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

This patch series contain two patches fixing problems with my
patch series meant to make USB drivers to work again after the
DMA on stack changes.

The last patch on this series is actually not related to DMA on
stack. It solves a longstanding bug affecting module unload,
causing module_put() to be called twice. It was reported by the
user who reported and tested the issues with the gp8psk driver
with the DMA fixup patches. As we're late at -rc cycle, maybe you
prefer to not apply it right now. If this is the case, I'll
add to the pile of patches for 4.10.

Regards,
Mauro

PS.: Exceptionally this time, I'm sending the patches via e-mail,
because I'm on another trip, and won't be able to use the usual
procedure until Monday. Also, it is only three patches, and you
followed already the discussions about the first one.

Mauro Carvalho Chehab (3):
  [media] dvb-usb: move data_mutex to struct dvb_usb_device
  [media] gp8psk: fix gp8psk_usb_in_op() logic
  [media] gp8psk: Fix DVB frontend attach

 drivers/media/dvb-frontends/Kconfig                |   5 +
 drivers/media/dvb-frontends/Makefile               |   1 +
 .../{usb/dvb-usb => dvb-frontends}/gp8psk-fe.c     | 139 ++++++++++++---------
 drivers/media/dvb-frontends/gp8psk-fe.h            |  82 ++++++++++++
 drivers/media/usb/dvb-usb/Makefile                 |   2 +-
 drivers/media/usb/dvb-usb/af9005.c                 |  33 ++---
 drivers/media/usb/dvb-usb/cinergyT2-core.c         |  33 ++---
 drivers/media/usb/dvb-usb/cxusb.c                  |  39 +++---
 drivers/media/usb/dvb-usb/cxusb.h                  |   1 -
 drivers/media/usb/dvb-usb/dtt200u.c                |  40 +++---
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   1 +
 drivers/media/usb/dvb-usb/dvb-usb.h                |   9 +-
 drivers/media/usb/dvb-usb/gp8psk.c                 | 111 +++++++++++-----
 drivers/media/usb/dvb-usb/gp8psk.h                 |  63 ----------
 14 files changed, 310 insertions(+), 249 deletions(-)
 rename drivers/media/{usb/dvb-usb => dvb-frontends}/gp8psk-fe.c (72%)
 create mode 100644 drivers/media/dvb-frontends/gp8psk-fe.h

-- 
2.9.3

