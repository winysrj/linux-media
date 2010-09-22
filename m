Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42801 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab0IVKjJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 06:39:09 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o8MAd8ur010378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 22 Sep 2010 05:39:08 -0500
From: x0130808@ti.com
To: linux-media@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>
Subject: [RFC/PATCH 0/9] V4L2 FM driver for TI WL127x and WL128x
Date: Wed, 22 Sep 2010 07:49:53 -0400
Message-Id: <1285156202-28569-1-git-send-email-x0130808@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Raja Mani <raja_mani@ti.com>

This is third patch set for TI FM driver for TI WiLink chips.
It provides FM Receive and Transmit support for TI WL127x and WL128x chips.
It also extends V4L2 CIDs to support few FM Receive features.

Note:
This patch set re-uses new FM RX CID definitions by Nokia FM driver for
TI WL127x chip. Recent Nokia patch can be found at
http://www.spinics.net/lists/linux-media/msg22484.html.

TI FM driver makes use of TI Shared Transport solution for TI WL chips.
TI Shared Transport driver is available in mainline kernel staging
folder - /drivers/staging/ti-st/.

Raja Mani (9):
  drivers:staging:ti-st: sources for FM common interfaces
  drivers:staging:ti-st: Sources for FM RX
  drivers:staging:ti-st: Sources for FM TX
  drivers:staging:ti-st: Sources for FM V4L2 interfaces
  drivers:staging:ti-st: Sources for FM common header
  drivers:media:video: Adding new CIDs for FM RX ctls
  include:linux:videodev2: Define 2 new CIDs for FM RX ctls
  Documentation:DocBook:v4l: Update the controls.xml for FM driver
  Staging:ti-st: Update Kconfig and Makefile for FM driver

 Documentation/DocBook/v4l/controls.xml |   12 +
 drivers/media/video/v4l2-common.c      |    4 +
 drivers/staging/ti-st/Makefile         |    2 +-
 drivers/staging/ti-st/fm.h             |   13 +
 drivers/staging/ti-st/fmdrv.h          |  230 ++++
 drivers/staging/ti-st/fmdrv_common.c   | 2149 ++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_common.h   |  476 +++++++
 drivers/staging/ti-st/fmdrv_rx.c       |  927 ++++++++++++++
 drivers/staging/ti-st/fmdrv_rx.h       |   57 +
 drivers/staging/ti-st/fmdrv_tx.c       |  451 +++++++
 drivers/staging/ti-st/fmdrv_tx.h       |   37 +
 drivers/staging/ti-st/fmdrv_v4l2.c     |  731 +++++++++++
 drivers/staging/ti-st/fmdrv_v4l2.h     |   32 +
 include/linux/videodev2.h              |    7 +
 14 files changed, 5127 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/ti-st/fm.h
 create mode 100644 drivers/staging/ti-st/fmdrv.h
 create mode 100644 drivers/staging/ti-st/fmdrv_common.c
 create mode 100644 drivers/staging/ti-st/fmdrv_common.h
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h

