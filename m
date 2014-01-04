Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43682 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaADN7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 08:59:16 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 00/22] em28xx: split analog part into a separate module
Date: Sat,  4 Jan 2014 08:55:29 -0200
Message-Id: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
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

There's one remaining issue: connecting an em28xx device into an USB 3.0
port is known to have issues. This is not addressed on this patch series.

v4:
	- Fixed the issues pointed by Frank Shäfer;
	- Removed I2C write retry patch from this series;
	- Removed experimental patch that removes URB_ISO_ASAP from
	  the urb::transfer_flags.

The removed patches are experimental, and will be submitted in
separate.

Mauro Carvalho Chehab (22):
  [media] em28xx: move some video-specific functions to em28xx-video
  [media] em28xx: some cosmetic changes
  [media] em28xx: move analog-specific init to em28xx-video
  [media] em28xx: make em28xx-video to be a separate module
  [media] em28xx: initialize analog I2C devices at the right place
  [media] em28xx: add warn messages for timeout
  [media] em28xx: improve extension information messages
  [media] em28xx: convert i2c wait completion logic to use jiffies
  [media] tvp5150: make read operations atomic
  [media] tuner-xc2028: remove unused code
  [media] em28xx: check if a device has audio earlier
  [media] em28xx: properly implement AC97 wait code
  [media] em28xx: initialize audio latter
  [media] em28xx: unify module version
  [media] em28xx: Fix em28xx deplock
  [media] em28xx: use a better value for I2C timeouts
  [media] em28xx-i2c: Fix error code for I2C error transfers
  [media] em28xx: don't return -ENODEV for I2C xfer errors
  [media] em28xx: cleanup I2C debug messages
  [media] em28xx: use usb_alloc_coherent() for audio
  [media] em28xx-audio: allocate URBs at device driver init
  [media] em28xx: retry read operation if it fails

 drivers/media/i2c/tvp5150.c              |  26 +-
 drivers/media/tuners/tuner-xc2028.c      |   9 -
 drivers/media/usb/em28xx/Kconfig         |   6 +-
 drivers/media/usb/em28xx/Makefile        |   5 +-
 drivers/media/usb/em28xx/em28xx-audio.c  | 134 ++++---
 drivers/media/usb/em28xx/em28xx-camera.c |   1 +
 drivers/media/usb/em28xx/em28xx-cards.c  | 305 ++--------------
 drivers/media/usb/em28xx/em28xx-core.c   | 292 +--------------
 drivers/media/usb/em28xx/em28xx-dvb.c    |  11 +-
 drivers/media/usb/em28xx/em28xx-i2c.c    | 237 ++++++------
 drivers/media/usb/em28xx/em28xx-input.c  |   7 +-
 drivers/media/usb/em28xx/em28xx-v4l.h    |  20 ++
 drivers/media/usb/em28xx/em28xx-vbi.c    |   1 +
 drivers/media/usb/em28xx/em28xx-video.c  | 598 +++++++++++++++++++++++++++++--
 drivers/media/usb/em28xx/em28xx.h        |  52 +--
 15 files changed, 905 insertions(+), 799 deletions(-)
 create mode 100644 drivers/media/usb/em28xx/em28xx-v4l.h

-- 
1.8.3.1

