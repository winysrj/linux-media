Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1M9NIK022947
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 17:09:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1M99ne015277
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 17:09:09 -0500
Date: Mon, 1 Dec 2008 20:08:53 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20081201200853.7b6f4b0e@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

For the following driver fixes:

   - af9015: don't reconnect device in USB-bus
   - dib0700: make remote control support work with firmware v1.20
   - dm1105: Fix section mismatch
   - dvb-ttusb-budget: Add NULL pointer validation
   - dvb-ttusb-budget: Add validation for ttusb_alloc_iso_urbs
   - em28xx: Avoid i2c register error for boards without eeprom
   - em28xx: Avoid memory leaks if registration fails
   - em28xx: avoid allocating/dealocating memory on every control urb
   - em28xx: avoid having two concurrent control URB's
   - em28xx: fix oops audio
   - em28xx: fix compile warning
   - em28xx: fix a race condition with hald
   - em28xx: make em28xx aux audio input work
   - em28xx: Make sure the i2c gate is open before powering down tuner
   - em28xx-alsa: implement another locking schema
   - gspca: Memory leak when disconnect while streaming.
   - gspca: Lock the subdrivers via module_get/put.
   - gspca: Move the video device to a separate area.
   - s2255drv: fix firmware test on big-endian
   - sms1xxx: use new firmware for Hauppauge WinTV MiniStick
   - ttusb_dec: Add NULL pointer validation
   - ttusb_dec: fix memory leak
   - usb-urb: fix memory leak

Also, one DVB api fix:
   - Make s2api work for ATSC

Cheers,
Mauro.

---

 drivers/media/dvb/dm1105/dm1105.c                 |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c         |    5 +-
 drivers/media/dvb/dvb-usb/af9015.c                |    8 +-
 drivers/media/dvb/dvb-usb/dib0700.h               |    5 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c          |   16 +++
 drivers/media/dvb/dvb-usb/dib0700_devices.c       |  139 ++++++++++++++++++++-
 drivers/media/dvb/dvb-usb/usb-urb.c               |   19 ++-
 drivers/media/dvb/siano/sms-cards.c               |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   15 ++-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |    7 +
 drivers/media/video/em28xx/em28xx-audio.c         |   33 +++---
 drivers/media/video/em28xx/em28xx-core.c          |   58 ++++++----
 drivers/media/video/em28xx/em28xx-i2c.c           |   10 +-
 drivers/media/video/em28xx/em28xx-video.c         |  140 ++++++++++++---------
 drivers/media/video/em28xx/em28xx.h               |    6 +
 drivers/media/video/gspca/conex.c                 |    3 +
 drivers/media/video/gspca/finepix.c               |    8 ++
 drivers/media/video/gspca/gspca.c                 |   56 +++++----
 drivers/media/video/gspca/gspca.h                 |    6 +-
 drivers/media/video/gspca/pac7311.c               |    3 +
 drivers/media/video/gspca/spca501.c               |    3 +
 drivers/media/video/gspca/spca505.c               |    4 +
 drivers/media/video/gspca/spca561.c               |    3 +
 drivers/media/video/gspca/vc032x.c                |    3 +
 drivers/media/video/gspca/zc3xx.c                 |    3 +
 drivers/media/video/s2255drv.c                    |    2 +-
 26 files changed, 410 insertions(+), 149 deletions(-)

Devin Heitmueller (4):
      V4L/DVB (9631): Make s2api work for ATSC support
      V4L/DVB (9632): make em28xx aux audio input work
      V4L/DVB (9634): Make sure the i2c gate is open before powering down tuner
      V4L/DVB (9639): Make dib0700 remote control support work with firmware v1.20

Douglas Schilling Landgraf (6):
      V4L/DVB (9601): ttusb_dec: Add NULL pointer validation
      V4L/DVB (9602): dvb-ttusb-budget: Add NULL pointer validation
      V4L/DVB (9603): dvb-ttusb-budget: Add validation for ttusb_alloc_iso_urbs
      V4L/DVB (9604): ttusb_dec: fix memory leak
      V4L/DVB (9605): usb-urb: fix memory leak
      V4L/DVB (9743): em28xx: fix oops audio

Hans Verkuil (1):
      V4L/DVB (9748): em28xx: fix compile warning

Harvey Harrison (1):
      V4L/DVB (9635): v4l: s2255drv fix firmware test on big-endian

Igor M. Liplianin (1):
      V4L/DVB (9608): Fix section mismatch warning for dm1105 during make

Jean-Francois Moine (3):
      V4L/DVB (9689): gspca: Memory leak when disconnect while streaming.
      V4L/DVB (9690): gspca: Lock the subdrivers via module_get/put.
      V4L/DVB (9691): gspca: Move the video device to a separate area.

Jose Alberto Reguero (1):
      V4L/DVB (9664): af9015: don't reconnect device in USB-bus

Mauro Carvalho Chehab (7):
      V4L/DVB (9627): em28xx: Avoid i2c register error for boards without eeprom
      V4L/DVB (9645): em28xx: Avoid memory leaks if registration fails
      V4L/DVB (9646): em28xx: avoid allocating/dealocating memory on every control urb
      V4L/DVB (9647): em28xx: void having two concurrent control URB's
      V4L/DVB (9668): em28xx: fix a race condition with hald
      V4L/DVB (9742): em28xx-alsa: implement another locking schema
      em28xx: remove backward compat macro added on a previous fix

Michael Krufky (1):
      V4L/DVB (9732): sms1xxx: use new firmware for Hauppauge WinTV MiniStick

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
