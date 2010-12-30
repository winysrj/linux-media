Return-path: <mchehab@gaivota>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42779 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab0L3Ks0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 05:48:26 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC V8 0/7] FM V4L2 drivers for WL128x
Date: Thu, 30 Dec 2010 06:11:40 -0500
Message-Id: <1293707507-3376-1-git-send-email-manjunatha_halli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Manjunatha Halli <manjunatha_halli@ti.com>

Mauro and the list,

This is the v8 version of the TI WL128x FM V4L2 drivers patchset.
This introduces wl128x folder under the drivers/media/radio which cater
to FM core on Texas Instrument's WL128x (also compatible with WL127x)
WiLink chipsets.
WL128x's FM can work in either Rx or Tx mode, and V4L2 interfaces are
provided for both.

** patch description **

Texas Instrument's WL128x chipset packs BT, FM, GPS and WLAN in a single
die with BT, FM and GPS being interfaced over a single UART.
This driver works on top of the shared transport line discipline driver.
This driver can also be made use for the WL127x version of the chip which packs
BT, FM and WLAN only.

Comments on the last version of the patches have been taken care,
such as,
- Using .unlocked_ioctl instead of .ioctl in fmdrv_v4l2.c

Thanks & Regards,
Manjunatha Halli

Manjunatha Halli (7):
  drivers:media:radio: wl128x: fmdrv common header file
  drivers:media:radio: wl128x: fmdrv_v4l2 sources
  drivers:media:radio: wl128x: fmdrv_common sources
  drivers:media:radio: wl128x: FM driver RX sources
  drivers:media:radio: wl128x: FM driver TX sources
  drivers:media:radio: wl128x: Kconfig & Makefile for wl128x driver
  drivers:media:radio: Update Kconfig and Makefile for wl128x FM
    driver.

 drivers/media/radio/Kconfig               |    3 +
 drivers/media/radio/Makefile              |    1 +
 drivers/media/radio/wl128x/Kconfig        |   17 +
 drivers/media/radio/wl128x/Makefile       |    6 +
 drivers/media/radio/wl128x/fmdrv.h        |  248 ++++
 drivers/media/radio/wl128x/fmdrv_common.c | 1970 +++++++++++++++++++++++++++++
 drivers/media/radio/wl128x/fmdrv_common.h |  402 ++++++
 drivers/media/radio/wl128x/fmdrv_rx.c     |  904 +++++++++++++
 drivers/media/radio/wl128x/fmdrv_rx.h     |   59 +
 drivers/media/radio/wl128x/fmdrv_tx.c     |  438 +++++++
 drivers/media/radio/wl128x/fmdrv_tx.h     |   37 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c   |  593 +++++++++
 drivers/media/radio/wl128x/fmdrv_v4l2.h   |   33 +
 13 files changed, 4711 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/wl128x/Kconfig
 create mode 100644 drivers/media/radio/wl128x/Makefile
 create mode 100644 drivers/media/radio/wl128x/fmdrv.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_common.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_common.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h

