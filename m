Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:52074 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751864AbdA0Vzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 16:55:54 -0500
From: Eric Anholt <eric@anholt.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
Date: Fri, 27 Jan 2017 13:54:57 -0800
Message-Id: <20170127215503.13208-1-eric@anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's my first pass at importing the camera driver.  There's a bunch
of TODO left to it, most of which is documented, and the rest being
standard checkpatch fare.

Unfortunately, when I try modprobing it on my pi3, the USB network
device dies, consistently.  I'm not sure what's going on here yet, but
I'm going to keep working on some debug of it.  I've unfortunately
changed a lot of variables (pi3 vs pi2, upstream vs downstream, vchi's
updates while in staging, 4.9 vs 4.4), so I probably won't figure it
out today.

Note that the "Update the driver to the current VCHI API" patch will
conflict with the outstanding "Add vchi_queue_kernel_message and
vchi_queue_user_message" series, but the fix should be pretty obvious
when that lands.

I built this against 4.10-rc1, but a merge with staging-next was clean
and still built fine.

Eric Anholt (6):
  staging: Import the BCM2835 MMAL-based V4L2 camera driver.
  staging: bcm2835-v4l2: Update the driver to the current VCHI API.
  staging: bcm2835-v4l2: Add a build system for the module.
  staging: bcm2835-v4l2: Add a TODO file for improvements we need.
  staging: bcm2835-v4l2: Apply many whitespace fixes from checkpatch.
  staging: bcm2835-v4l2: Apply spelling fixes from checkpatch.

 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/platform/bcm2835/Kconfig     |   10 +
 drivers/staging/media/platform/bcm2835/Makefile    |   11 +
 drivers/staging/media/platform/bcm2835/TODO        |   39 +
 .../media/platform/bcm2835/bcm2835-camera.c        | 2024 ++++++++++++++++++++
 .../media/platform/bcm2835/bcm2835-camera.h        |  145 ++
 drivers/staging/media/platform/bcm2835/controls.c  | 1335 +++++++++++++
 .../staging/media/platform/bcm2835/mmal-common.h   |   53 +
 .../media/platform/bcm2835/mmal-encodings.h        |  127 ++
 .../media/platform/bcm2835/mmal-msg-common.h       |   50 +
 .../media/platform/bcm2835/mmal-msg-format.h       |   81 +
 .../staging/media/platform/bcm2835/mmal-msg-port.h |  107 ++
 drivers/staging/media/platform/bcm2835/mmal-msg.h  |  404 ++++
 .../media/platform/bcm2835/mmal-parameters.h       |  689 +++++++
 .../staging/media/platform/bcm2835/mmal-vchiq.c    | 1920 +++++++++++++++++++
 .../staging/media/platform/bcm2835/mmal-vchiq.h    |  178 ++
 17 files changed, 7176 insertions(+)
 create mode 100644 drivers/staging/media/platform/bcm2835/Kconfig
 create mode 100644 drivers/staging/media/platform/bcm2835/Makefile
 create mode 100644 drivers/staging/media/platform/bcm2835/TODO
 create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.c
 create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.h
 create mode 100644 drivers/staging/media/platform/bcm2835/controls.c
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-common.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-encodings.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-common.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-format.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-port.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-parameters.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.c
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.h

-- 
2.11.0

