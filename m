Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55485 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbbAGNqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 08:46:02 -0500
Received: by mail-pa0-f50.google.com with SMTP id bj1so4947532pad.9
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 05:46:02 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 0/2] split dvb-usb-friio into parts
Date: Wed,  7 Jan 2015 22:45:31 +0900
Message-Id: <1420638333-7002-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>a

This patch series decomposes the friio driver which was monolithic
into adapter,demod,tuner modules.

Akihiro Tsukada (2):
  dvb: tua6034: add a new driver for Infineon tua6034 tuner
  dvb-usb-friio: split and merge into dvb-usbv2-gl861

 drivers/media/tuners/Kconfig               |   7 +
 drivers/media/tuners/Makefile              |   1 +
 drivers/media/tuners/tua6034.c             | 464 +++++++++++++++++++++++++
 drivers/media/tuners/tua6034.h             | 113 +++++++
 drivers/media/usb/dvb-usb-v2/Kconfig       |   5 +-
 drivers/media/usb/dvb-usb-v2/Makefile      |   2 +-
 drivers/media/usb/dvb-usb-v2/gl861-friio.c | 318 ++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/gl861.c       | 125 ++++++-
 drivers/media/usb/dvb-usb-v2/gl861.h       |  11 +
 drivers/media/usb/dvb-usb/Kconfig          |   6 -
 drivers/media/usb/dvb-usb/Makefile         |   3 -
 drivers/media/usb/dvb-usb/friio-fe.c       | 472 --------------------------
 drivers/media/usb/dvb-usb/friio.c          | 522 -----------------------------
 drivers/media/usb/dvb-usb/friio.h          |  99 ------
 14 files changed, 1030 insertions(+), 1118 deletions(-)
 create mode 100644 drivers/media/tuners/tua6034.c
 create mode 100644 drivers/media/tuners/tua6034.h
 create mode 100644 drivers/media/usb/dvb-usb-v2/gl861-friio.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio-fe.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.h

-- 
2.2.1

