Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab2ECWWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 18:22:32 -0400
Received: by dady13 with SMTP id y13so2478171dad.5
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 15:22:32 -0700 (PDT)
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 0/6] drivers/media: randconfig patches for kernel 3.4
Date: Thu,  3 May 2012 16:22:21 -0600
Message-Id: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

These patches fix miscellaneous problems when working
with make randconfig.  They were discovered on kernel
3.1-rc4 and have been reformatted for 3.4.

Arnd Bergmann (6):
  drivers/media: add missing __devexit_p() annotations
  v4l/dvb: fix Kconfig dependencies on VIDEO_CAPTURE_DRIVERS
  media/rc: IR_SONY_DECODER depends on BITREVERSE
  media/video: add I2C dependencies
  dvb/drxd: stub out drxd_attach when not built
  video/omap24xxcam: use __iomem annotations

 drivers/media/dvb/Kconfig                  |    2 +-
 drivers/media/dvb/ddbridge/ddbridge-core.c |    2 +-
 drivers/media/dvb/frontends/drxd.h         |   14 ++++++++++++++
 drivers/media/radio/radio-timb.c           |    2 +-
 drivers/media/radio/saa7706h.c             |    2 +-
 drivers/media/radio/tef6862.c              |    2 +-
 drivers/media/rc/Kconfig                   |    1 +
 drivers/media/rc/imon.c                    |    2 +-
 drivers/media/rc/mceusb.c                  |    2 +-
 drivers/media/rc/redrat3.c                 |    2 +-
 drivers/media/video/davinci/Kconfig        |    1 +
 drivers/media/video/omap24xxcam-dma.c      |   20 ++++++++++----------
 drivers/media/video/omap24xxcam.c          |    3 +--
 drivers/media/video/omap24xxcam.h          |   14 +++++++-------
 14 files changed, 42 insertions(+), 27 deletions(-)

-- 
1.7.5.4

