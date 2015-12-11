Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38050 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbbLKW5W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 17:57:22 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v5 0/3] [media] Fix race between graph enumeration and entities registration
Date: Fri, 11 Dec 2015 19:57:06 -0300
Message-Id: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series fixes the issue of media device nodes being registered before
all the media entities and pads links are created so if user-space tries
to enumerate the graph too early, it may get a partial graph enumeration
since everything may not been registered yet.

The solution (suggested by Sakari Ailus) is to separate the media device
registration from the initialization so drivers can first initialize the
media device, create the graph and then finally register the media device
node once is finished.

This is the fifth version of the series and is a rebase on top of latest
MC next gen and the only important change is the addition of patch 3/3.

Patch #1 adds a check to the media_device_unregister() function to know if
the media device has been registed yet so calling it will be safe and the
cleanup functions of the drivers won't need to be changed in case register
failed.

Patch #2 does the init and registration split, changing all the drivers to
make the change atomic and also adds a cleanup function for media devices.

Patch #3 sets a topology version 0 at media device registration to allow
user-space to know that the graph is "static" (i.e: no graph updates after
the media device was registered).

Best regards,
Javier

Changes in v5:
- Add kernel-doc for media_device_init() and media_device_register().

Changes in v4:
- Remove the model check from BUG_ON() since shold not be fatal.
  Suggested by Sakari Ailus.

Changes in v3:
- Replace the WARN_ON() in media_device_init() for a BUG_ON().
  Suggested by Sakari Ailus.

Changes in v2:
- Reword the documentation for media_device_unregister(). Suggested by Sakari.
- Added Sakari's Acked-by tag for patch #1.
- Reword the documentation for media_device_unregister(). Suggested by Sakari.
- Added Sakari's Acked-by tag for patch #1.
- Change media_device_init() to return void instead of an error.
  Suggested by Sakari Ailus.
- Remove the error messages when media_device_register() fails.
  Suggested by Sakari Ailus.
- Fix typos in commit message of patch #2. Suggested by Sakari Ailus.

Javier Martinez Canillas (3):
  [media] media-device: check before unregister if mdev was registered
  [media] media-device: split media initialization and registration
  [media] media-device: set topology version 0 at media registration

 drivers/media/common/siano/smsdvb-main.c      |  1 +
 drivers/media/media-device.c                  | 46 +++++++++++++++++++++++----
 drivers/media/platform/exynos4-is/media-dev.c | 15 ++++-----
 drivers/media/platform/omap3isp/isp.c         | 14 ++++----
 drivers/media/platform/s3c-camif/camif-core.c | 15 ++++++---
 drivers/media/platform/vsp1/vsp1_drv.c        | 12 +++----
 drivers/media/platform/xilinx/xilinx-vipp.c   | 12 +++----
 drivers/media/usb/au0828/au0828-core.c        | 27 ++++++++--------
 drivers/media/usb/cx231xx/cx231xx-cards.c     | 30 ++++++++---------
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 23 ++++++++------
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 24 ++++++++------
 drivers/media/usb/siano/smsusb.c              |  5 +--
 drivers/media/usb/uvc/uvc_driver.c            | 10 ++++--
 include/media/media-device.h                  | 26 +++++++++++++++
 14 files changed, 165 insertions(+), 95 deletions(-)

-- 
2.4.3

