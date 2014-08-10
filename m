Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaHJArl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:41 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 00/18] au0828: Fix suspend/resume
Date: Sat,  9 Aug 2014 21:47:06 -0300
Message-Id: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Suspend/resume can be very tricky. That's the second attempt to fix
it with au0828.

With this patchset, suspend/resume to ram works fine if the device
is not being used. After resume, IR, digital TV and analog TV
keeps working.

On my tests, however, trying to suspend while watching TV caused
my test machine to crash. I suspect, however, that the bug could
be at the USB driver level.

Anyway, before this series, the device even didn't suspend, so
it is clearly a progress.

Tested on an Odroid-U3 running Tizen with a very light stack. I'll 
test this also on some x86_64 hardware.

Mauro Carvalho Chehab (16):
  [media] au0828: avoid race conditions at RC stop
  [media] au0828: handle IR int during suspend/resume
  [media] au0828: don't let the IR polling thread to run at suspend
  [media] au0828: be sure to reenable the bridge and GPIOs on resume
  [media] au0828: Add suspend code for DVB
  [media] au0828: properly handle stream on/off state
  [media] au0828: add suspend/resume code for V4L2
  [media] au0828: Remove a bad whitespace
  [media] au0828: use pr_foo macros
  [media] au0828: add pr_info to track au0828 suspend/resume code
  [media] dvb-frontend: add core support for tuner suspend/resume
  [media] xc5000: fix xc5000 suspend
  [media] au0828: move the code that sets DTV on a separate function
  [media] xc5000: Split config and set code for analog/radio
  [media] xc5000: add a resume function
  [media] xc5000: better name the functions

Shuah Khan (2):
  [media] au0828: add au0828_rc_*() stubs for VIDEO_AU0828_RC disabled
    case
  [media] au0828: remove CONFIG_VIDEO_AU0828_RC scope around
    au0828_rc_*()

 drivers/media/dvb-core/dvb_frontend.c   |   8 +-
 drivers/media/dvb-core/dvb_frontend.h   |   2 +
 drivers/media/tuners/xc5000.c           | 184 +++++++++++++++++++++-----------
 drivers/media/usb/au0828/au0828-cards.c |  13 ++-
 drivers/media/usb/au0828/au0828-core.c  |  84 +++++++++++----
 drivers/media/usb/au0828/au0828-dvb.c   |  85 ++++++++++-----
 drivers/media/usb/au0828/au0828-i2c.c   |  15 +--
 drivers/media/usb/au0828/au0828-input.c |  20 +++-
 drivers/media/usb/au0828/au0828-vbi.c   |   4 +-
 drivers/media/usb/au0828/au0828-video.c |  90 +++++++++++++---
 drivers/media/usb/au0828/au0828.h       |  29 +++--
 drivers/media/v4l2-core/tuner-core.c    |   8 +-
 12 files changed, 387 insertions(+), 155 deletions(-)

-- 
1.9.3

