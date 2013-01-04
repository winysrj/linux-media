Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52284 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3ADU7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 15:59:52 -0500
Received: by mail-vc0-f175.google.com with SMTP id fy7so16801234vcb.20
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:59:52 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 00/15] em28xx VBI2 port and v4l2-compliance fixes
Date: Fri,  4 Jan 2013 15:59:30 -0500
Message-Id: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts the em28xx driver to videobuf2 and fixes
a number of issues found with v4l2-compliance on em28xx.

Devin Heitmueller (1):
  em28xx: convert to videobuf2

Hans Verkuil (14):
  em28xx: fix querycap.
  em28xx: remove bogus input/audio ioctls for the radio device.
  em28xx: fix VIDIOC_DBG_G_CHIP_IDENT compliance errors.
  em28xx: fix tuner/frequency handling
  v4l2-ctrls: add a notify callback.
  em28xx: convert to the control framework.
  em28xx: convert to v4l2_fh, fix priority handling.
  em28xx: add support for control events.
  em28xx: fill in readbuffers and fix incorrect return code.
  em28xx: fix broken TRY_FMT.
  tvp5150: remove compat control ops.
  em28xx: std fixes: don't implement in webcam mode, and fix std
    changes.
  em28xx: remove sliced VBI support.
  em28xx: zero vbi_format reserved array and add try_vbi_fmt.

 Documentation/video4linux/v4l2-controls.txt |   22 +-
 drivers/media/i2c/tvp5150.c                 |    7 -
 drivers/media/usb/em28xx/Kconfig            |    3 +-
 drivers/media/usb/em28xx/em28xx-cards.c     |   31 +-
 drivers/media/usb/em28xx/em28xx-dvb.c       |    4 +-
 drivers/media/usb/em28xx/em28xx-vbi.c       |  123 ++-
 drivers/media/usb/em28xx/em28xx-video.c     | 1159 ++++++++-------------------
 drivers/media/usb/em28xx/em28xx.h           |   38 +-
 drivers/media/v4l2-core/v4l2-ctrls.c        |   18 +
 include/media/v4l2-ctrls.h                  |   25 +
 10 files changed, 504 insertions(+), 926 deletions(-)

-- 
1.7.9.5

