Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:48737 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0HBNNT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 09:13:19 -0400
From: raja_mani@ti.com
To: olbpdev@list.ti.com, linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Raja-Mani <x0102026@ti.com>
Subject: [RFC 0/4] FM V4L2 driver for WL128x
Date: Mon,  2 Aug 2010 08:13:08 -0500
Message-Id: <1280754792-14943-1-git-send-email-raja_mani@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Raja-Mani <x0102026@ti.com>

The following patches are FM V4L2-Radio drivers for WL128x
(backward compatible for WL127x).
This driver makes use of TI Shared Transport driver for its
transport via UART/TTY.

Only FM Rx is supported as of now. Any FM V4L2 Radio standard application
can make use of the '/dev/radioX' interface exposed by this driver to
communicate with the TI FM chip.

This doesn't include the handling of audio path and has support for
RDS, FM firmware download, HW Seek, Tune, Volume control,etc.

Tested with internal FM app and as well as with open source gnome-radio
application and verified on SDP4430, kernel 2.6.35-rc5.

Note: The patches however are re-based to the Stephen Rothwell's linux-next's
drivers/staging/ti-st since the latest version of ST drivers exist there.

Raja-Mani (4):
  drivers:staging:ti-st: sources for FM common interfaces
  drivers:staging:ti-st: Sources for FM RX
  drivers:staging:ti-st: Sources for FM V4L2 interfaces
  drivers:staging:ti-st: Sources for FM common header

 drivers/staging/ti-st/fmdrv.h        |  225 ++++
 drivers/staging/ti-st/fmdrv_common.c | 2127 ++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_common.h |  459 ++++++++
 drivers/staging/ti-st/fmdrv_rx.c     |  805 +++++++++++++
 drivers/staging/ti-st/fmdrv_rx.h     |   56 +
 drivers/staging/ti-st/fmdrv_v4l2.c   |  550 +++++++++
 drivers/staging/ti-st/fmdrv_v4l2.h   |   32 +
 7 files changed, 4254 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/fmdrv.h
 create mode 100644 drivers/staging/ti-st/fmdrv_common.c
 create mode 100644 drivers/staging/ti-st/fmdrv_common.h
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h

