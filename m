Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOEE4w3010511
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 09:14:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOEDmbi025622
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 09:13:48 -0500
Date: Wed, 24 Dec 2008 12:12:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20081224121252.7560391e@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.28] V4L/DVB fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For a few last time driver fixes:

   - dib0700: Stop repeating after user stops pushing button
   - Cablestar 2 I2C retries (fix CableStar2 support)
   - gspca - main: Fix vidioc_s_jpegcomp locking.
   - drivers/media Kconfig fix (bugzilla #12204)
   - v4l2-compat: test for unlocked_ioctl as well.
   - MAINTAINERS: mark linux-uvc-devel as subscribers only
   - em28xx: fix NULL pointer dereference in call to VIDIOC_INT_RESET command

Cheers,
Mauro.

---

 MAINTAINERS                                 |    2 +-
 drivers/media/dvb/b2c2/Kconfig              |    2 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c   |    2 +
 drivers/media/dvb/b2c2/flexcop-i2c.c        |    6 +++-
 drivers/media/dvb/bt8xx/Kconfig             |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig           |   46 +++++++++++++-------------
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    6 ++--
 drivers/media/dvb/ttpci/Kconfig             |    2 +-
 drivers/media/video/compat_ioctl32.c        |    2 +-
 drivers/media/video/cx18/Kconfig            |    2 +-
 drivers/media/video/cx23885/Kconfig         |    4 +-
 drivers/media/video/cx88/Kconfig            |    2 +-
 drivers/media/video/em28xx/em28xx-video.c   |    3 +-
 drivers/media/video/gspca/gspca.c           |    4 +-
 drivers/media/video/pvrusb2/Kconfig         |    2 +-
 drivers/media/video/saa7134/Kconfig         |    4 +-
 16 files changed, 49 insertions(+), 42 deletions(-)


Antti Seppälä (1):
      V4L/DVB (9781): [PATCH] Cablestar 2 I2C retries (fix CableStar2 support)

Devin Heitmueller (2):
      V4L/DVB (9780): dib0700: Stop repeating after user stops pushing button
      V4L/DVB (9920): em28xx: fix NULL pointer dereference in call to VIDIOC_INT_RESET command

Hans Verkuil (1):
      V4L/DVB (9906): v4l2-compat: test for unlocked_ioctl as well.

Jim Paris (1):
      V4L/DVB (9875): gspca - main: Fix vidioc_s_jpegcomp locking.

Jiri Slaby (1):
      V4L/DVB (9908a): MAINTAINERS: mark linux-uvc-devel as subscribers only

Mauro Carvalho Chehab (1):
      V4L/DVB (9885): drivers/media Kconfig's: fix bugzilla #12204

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
