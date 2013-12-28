Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3L1MQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 00/24] em28xx: split analog part into a separate module
Date: Sat, 28 Dec 2013 10:15:52 -0200
Message-Id: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series split em28xx into a separate V4L2 driver,
allowing the new dvb-only chips to be supported without requiring
V4L2.

While testing the original patchset, I noticed several issues with
HVR-950. The remaining patches on this series fix most of those
issues.

There's one remaining issue: on my tests, when connecting the device
into an USB 3.0 port, the AC97 EMP202 is not properly detected. 
Also, the audio doesn't work fine. I'm still investigating what
would be the root cause for that.

Mauro Carvalho Chehab (24):
  em28xx: move some video-specific functions to em28xx-video
  em28xx: some cosmetic changes
  em28xx: move analog-specific init to em28xx-video
  em28xx: make em28xx-video to be a separate module
  em28xx: initialize analog I2C devices at the right place
  em28xx-cards: remove a now dead code
  em28xx: fix a cut and paste error
  em28xx: add warn messages for timeout
  em28xx: improve extension information messages
  em28xx: convert i2c wait completion logic to use jiffies
  tvp5150: make read operations atomic
  tuner-xc2028: remove unused code
  em28xx: retry I2C ops if failed by timeout
  em28xx: remove a false positive warning
  em28xx: check if a device has audio earlier
  em28xx: properly implement AC97 wait code
  em28xx: initialize audio latter
  em28xx: improve I2C timeout error message
  em28xx: unify module version
  em28xx: Fix em28xx deplock
  em28xx: USB: adjust for changed 3.8 USB API
  em28xx: use a better value for I2C timeouts
  em28xx: don't return -ENODEV for I2C xfer errors
  em28xx: cleanup I2C debug messages

 drivers/media/i2c/tvp5150.c              |  22 +-
 drivers/media/tuners/tuner-xc2028.c      |   9 -
 drivers/media/usb/em28xx/Kconfig         |   6 +-
 drivers/media/usb/em28xx/Makefile        |   5 +-
 drivers/media/usb/em28xx/em28xx-audio.c  |   9 +-
 drivers/media/usb/em28xx/em28xx-camera.c |   1 +
 drivers/media/usb/em28xx/em28xx-cards.c  | 310 ++--------------
 drivers/media/usb/em28xx/em28xx-core.c   | 295 +--------------
 drivers/media/usb/em28xx/em28xx-dvb.c    |  11 +-
 drivers/media/usb/em28xx/em28xx-i2c.c    | 226 ++++++------
 drivers/media/usb/em28xx/em28xx-input.c  |   7 +-
 drivers/media/usb/em28xx/em28xx-v4l.h    |  24 ++
 drivers/media/usb/em28xx/em28xx-vbi.c    |   1 +
 drivers/media/usb/em28xx/em28xx-video.c  | 607 +++++++++++++++++++++++++++++--
 drivers/media/usb/em28xx/em28xx.h        |  52 +--
 15 files changed, 835 insertions(+), 750 deletions(-)
 create mode 100644 drivers/media/usb/em28xx/em28xx-v4l.h

-- 
1.8.3.1

