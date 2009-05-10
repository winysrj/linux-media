Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51100 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZEJDFM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 May 2009 23:05:12 -0400
Date: Sun, 10 May 2009 00:03:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.30] V4L/DVB fixes
Message-ID: <20090510000351.0a43fcab@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following driver fixes:

   - zoran: fix bug when enumerating format -1;
   - cx23885: Frontend wasn't locking on HVR-1500;
   - ivtv: fix compiler warning;
   - uvc: fix uvc resume failed and  fix a compile warning;
   - ivtv: fix incorrect bit tests;
   - ivtv/radio: fix V4L2_TUNER_MODE/V4L2_TUNER_SUB confusion;
   - cafe_ccic: fix sensor detection;

And for two fixes at v4l-core:
   - v4l2-ioctl: Check buffer types using g_fmt instead of try_fmt
   - v4l2-ioctl: Clear buffer type specific trailing fields/padding

Cheers,
Mauro.

---

 drivers/media/radio/radio-sf16fmi.c       |    2 +-
 drivers/media/radio/radio-sf16fmr2.c      |    2 +-
 drivers/media/video/cafe_ccic.c           |    1 +
 drivers/media/video/cx23885/cx23885-dvb.c |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c    |    9 ++++--
 drivers/media/video/ivtv/ivtv-gpio.c      |    4 +-
 drivers/media/video/ivtv/ivtv-ioctl.c     |    5 ++-
 drivers/media/video/ivtv/ivtv-irq.c       |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c       |    3 +-
 drivers/media/video/ivtv/ivtvfb.c         |    3 +-
 drivers/media/video/uvc/uvc_driver.c      |    9 ++++--
 drivers/media/video/uvc/uvc_video.c       |    2 +-
 drivers/media/video/v4l2-ioctl.c          |   45 +++++++++++++++++++++++------
 drivers/media/video/zoran/zoran_driver.c  |   28 ++++++++---------
 14 files changed, 76 insertions(+), 41 deletions(-)

Hans Verkuil (5):
      V4L/DVB (11668): ivtv: fix compiler warning.
      V4L/DVB (11669): uvc: fix compile warning
      V4L/DVB (11674): ivtv: fix incorrect bit tests
      V4L/DVB (11675): ivtv/radio: fix V4L2_TUNER_MODE/V4L2_TUNER_SUB confusion
      V4L/DVB (11679): cafe_ccic: fix sensor detection

Mauro Carvalho Chehab (1):
      V4L/DVB (11680): cafe_ccic: use = instead of == for setting a value at a var

Ming Lei (1):
      V4L/DVB (11575): uvcvideo: fix uvc resume failed

Steven Toth (1):
      V4L/DVB (11664): cx23885: Frontend wasn't locking on HVR-1500

Trent Piepho (3):
      V4L/DVB (11660): zoran: fix bug when enumerating format -1
      V4L/DVB (11661): v4l2-ioctl: Check buffer types using g_fmt instead of try_fmt
      V4L/DVB (11662): v4l2-ioctl: Clear buffer type specific trailing fields/padding

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

