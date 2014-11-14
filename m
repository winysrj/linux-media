Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56368 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422728AbaKNWR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 17:17:26 -0500
Received: from [192.168.1.106] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 6B2002A0091
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 23:17:13 +0100 (CET)
Message-ID: <54667F6E.6080000@xs4all.nl>
Date: Fri, 14 Nov 2014 23:17:18 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] omap24xx/tcm825x: remove deprecated omap2 camera
 drivers
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap2 camera driver has been deprecated for a year and it is now
time to remove it. It is unmaintained and it uses an internal API
that has long since been superseded by a much better API. Worse, that
internal API has been abused by out-of-kernel trees (i.MX6).

In addition, Sakari stated that these drivers have never been in a
usable state in the mainline kernel due to missing platform data.

Regards,

	Hans

The following changes since commit dd0a6fe2bc3055cd61e369f97982c88183b1f0a0:

  [media] dvb-usb-dvbsky: fix i2c adapter for sp2 device (2014-11-11 12:55:32 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git omap24xx

for you to fetch changes up to edfb7368e96f0a83f4f80ebd33b4dac81f13e707:

  omap24xx/tcm825x: remove deprecated omap2 camera drivers. (2014-11-14 23:15:12 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      mach-omap2: remove deprecated VIDEO_OMAP2 support
      omap24xx/tcm825x: remove deprecated omap2 camera drivers.

 arch/arm/mach-omap2/devices.c                    |   31 -
 drivers/staging/media/Kconfig                    |    2 -
 drivers/staging/media/Makefile                   |    2 -
 drivers/staging/media/omap24xx/Kconfig           |   35 --
 drivers/staging/media/omap24xx/Makefile          |    5 -
 drivers/staging/media/omap24xx/omap24xxcam-dma.c |  598 -------------------
 drivers/staging/media/omap24xx/omap24xxcam.c     | 1882 -----------------------------------------------------------
 drivers/staging/media/omap24xx/omap24xxcam.h     |  596 -------------------
 drivers/staging/media/omap24xx/tcm825x.c         |  938 -----------------------------
 drivers/staging/media/omap24xx/tcm825x.h         |  200 -------
 drivers/staging/media/omap24xx/v4l2-int-device.c |  164 ------
 drivers/staging/media/omap24xx/v4l2-int-device.h |  305 ----------
 12 files changed, 4758 deletions(-)
 delete mode 100644 drivers/staging/media/omap24xx/Kconfig
 delete mode 100644 drivers/staging/media/omap24xx/Makefile
 delete mode 100644 drivers/staging/media/omap24xx/omap24xxcam-dma.c
 delete mode 100644 drivers/staging/media/omap24xx/omap24xxcam.c
 delete mode 100644 drivers/staging/media/omap24xx/omap24xxcam.h
 delete mode 100644 drivers/staging/media/omap24xx/tcm825x.c
 delete mode 100644 drivers/staging/media/omap24xx/tcm825x.h
 delete mode 100644 drivers/staging/media/omap24xx/v4l2-int-device.c
 delete mode 100644 drivers/staging/media/omap24xx/v4l2-int-device.h
