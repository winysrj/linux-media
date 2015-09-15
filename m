Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:54758 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbbIOPte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 11:49:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/7] [media] y2038 conversion for subsystem
Date: Tue, 15 Sep 2015 17:49:01 +0200
Message-Id: <1442332148-488079-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This is a conversion of all subsystem-wide v4l2 code to avoid the
use of types based on time_t. The first five patches should all
be harmless and obvious, so they can get applied for 4.3 after
normal review.

The last two patches are marked RFC for now because their possible
impact on the user space ABI and to decide if this is the best
approach or whether we should instead introduce extra code in
the kernel to handle modified user space.

There are a few device drivers beyond this series that rely on
time_t/timeval/timespec internally, but they are all easy to fix
and can be taken care of later.

	Arnd

Arnd Bergmann (7):
  [media] dvb: use ktime_t for internal timeout
  [media] dvb: remove unused systime() function
  [media] dvb: don't use 'time_t' in event ioctl
  [media] exynos4-is: use monotonic timestamps as advertized
  [media] use v4l2_get_timestamp where possible
  [RFC] [media]: v4l2: introduce v4l2_timeval
  [RFC] [media] introduce v4l2_timespec type for timestamps

 drivers/media/dvb-core/demux.h                   |  2 +-
 drivers/media/dvb-core/dmxdev.c                  |  2 +-
 drivers/media/dvb-core/dvb_demux.c               | 17 ++++++-----------
 drivers/media/dvb-core/dvb_demux.h               |  4 ++--
 drivers/media/dvb-core/dvb_net.c                 |  2 +-
 drivers/media/dvb-frontends/dibx000_common.c     | 10 ----------
 drivers/media/dvb-frontends/dibx000_common.h     |  2 --
 drivers/media/pci/bt8xx/bttv-driver.c            |  7 ++-----
 drivers/media/pci/cx18/cx18-mailbox.c            |  2 +-
 drivers/media/pci/meye/meye.h                    |  2 +-
 drivers/media/pci/zoran/zoran.h                  |  2 +-
 drivers/media/platform/coda/coda.h               |  2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c |  8 +-------
 drivers/media/platform/exynos4-is/fimc-lite.c    |  7 +------
 drivers/media/platform/omap/omap_vout.c          |  4 ++--
 drivers/media/platform/omap3isp/ispstat.c        |  5 ++---
 drivers/media/platform/omap3isp/ispstat.h        |  2 +-
 drivers/media/platform/s3c-camif/camif-capture.c |  8 +-------
 drivers/media/platform/vim2m.c                   |  2 +-
 drivers/media/platform/vivid/vivid-ctrls.c       |  2 +-
 drivers/media/usb/cpia2/cpia2.h                  |  2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c              |  2 +-
 drivers/media/usb/gspca/gspca.c                  |  6 +++---
 drivers/media/usb/usbvision/usbvision.h          |  2 +-
 drivers/media/v4l2-core/v4l2-common.c            |  6 +++---
 drivers/media/v4l2-core/v4l2-event.c             | 20 +++++++++++++-------
 drivers/staging/media/omap4iss/iss_video.c       |  5 +----
 include/media/v4l2-common.h                      |  2 +-
 include/media/videobuf-core.h                    |  2 +-
 include/trace/events/v4l2.h                      | 12 ++++++++++--
 include/uapi/linux/dvb/video.h                   |  3 ++-
 include/uapi/linux/omap3isp.h                    |  2 +-
 include/uapi/linux/videodev2.h                   | 16 ++++++++++++++--
 33 files changed, 79 insertions(+), 93 deletions(-)

-- 
2.1.0.rc2

