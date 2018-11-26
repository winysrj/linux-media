Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58669 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725199AbeK0FMV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 00:12:21 -0500
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stoth@kernellabs.com,
        laurent.pinchart@ideasonboard.com, kernel@pengutronix.de,
        mchehab@kernel.org, davem@davemloft.net
Subject: [PATCH v2 0/2] media: Startech usb2hdcapm hdmi2usb framegrabber support
Date: Mon, 26 Nov 2018 19:09:35 +0100
Message-Id: <20181126180937.32535-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for the Startech usb2hdcapm framegrabber. The
code is based on the external kernel module code from Steven Toth's
github page:

https://github.com/stoth68000/hdcapm/

We applied checkpatch.pl --strict and cleaned up the 80 character
length, whitespace issues and replaced simple printks with appropriate
v4l2_* or dev_* helpers, used WARN_ON instead of BUG and changed all
errors and warnings checkpatch was complaining about.

Steven Toth (2):
  media: mst3367: add support for mstar mst3367 HDMI RX
  media: hdcapm: add support for usb2hdcapm hdmi2usb framegrabber from
    startech

 drivers/media/i2c/Kconfig                    |   10 +
 drivers/media/i2c/Makefile                   |    1 +
 drivers/media/i2c/mst3367.c                  | 1104 ++++++++++++++++++
 drivers/media/usb/Kconfig                    |    1 +
 drivers/media/usb/Makefile                   |    1 +
 drivers/media/usb/hdcapm/Kconfig             |   11 +
 drivers/media/usb/hdcapm/Makefile            |    3 +
 drivers/media/usb/hdcapm/hdcapm-buffer.c     |  230 ++++
 drivers/media/usb/hdcapm/hdcapm-compressor.c |  782 +++++++++++++
 drivers/media/usb/hdcapm/hdcapm-core.c       |  743 ++++++++++++
 drivers/media/usb/hdcapm/hdcapm-i2c.c        |  332 ++++++
 drivers/media/usb/hdcapm/hdcapm-reg.h        |  111 ++
 drivers/media/usb/hdcapm/hdcapm-video.c      |  665 +++++++++++
 drivers/media/usb/hdcapm/hdcapm.h            |  283 +++++
 include/media/i2c/mst3367.h                  |   29 +
 15 files changed, 4306 insertions(+)
 create mode 100644 drivers/media/i2c/mst3367.c
 create mode 100644 drivers/media/usb/hdcapm/Kconfig
 create mode 100644 drivers/media/usb/hdcapm/Makefile
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-buffer.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-compressor.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-core.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-i2c.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-reg.h
 create mode 100644 drivers/media/usb/hdcapm/hdcapm-video.c
 create mode 100644 drivers/media/usb/hdcapm/hdcapm.h
 create mode 100644 include/media/i2c/mst3367.h

-- 
2.19.1
