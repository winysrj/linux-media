Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3803 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2BBL47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 06:56:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Subject: [PATCH 0/6] Add support functions and the radio-keene driver
Date: Thu,  2 Feb 2012 12:56:30 +0100
Message-Id: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is for 3.4. It adds a V4L2 driver for the Keene USB FM
Transmitter:

http://www.amazon.co.uk/Keene-Electronics-USB-FM-Transmitter/dp/B003GCHPDY

This device is very useful to test V4L2 FM radio receivers.

Changes since RFCv2 of the radio-keene driver:

- Use the new v4l2 support functions.
- Fix a QUERYCAP compliancy issue for 3.4.

The first four add some v4l2 support functions that are used by the
radio-keene driver in the fifth patch (and upcoming driver improvements
in the near future).

Note that the Keene FM transmitter USB device has the same USB ID as
the Logitech AudioHub Speaker. Since the radio-keene driver needs to
hijack the HID something needed to be done to differentiate the two.

So hid-core was modified to decide this based on the product name.

I have tested that this works with both a Keene device and a Logitech
AudioHub device hooked up at the same time.

Jiri is OK with it as well. This sixth patch is independent from the
other five and can be merged either through linux-media (makes the most
sense to me) or through linux-input. I leave that up to Mauro and Jiri.

This patch series is also available in my git tree:

The following changes since commit 59b30294e14fa6a370fdd2bc2921cca1f977ef16:

  Merge branch 'v4l_for_linus' into staging/for_v3.4 (2012-01-23 18:11:30 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git keene

Hans Verkuil (6):
      v4l2: standardize log start/end message.
      v4l2-subdev: add start/end messages for log_status.
      v4l2-ctrls: add helper functions for control events.
      vivi: use v4l2_ctrl_subscribe_event.
      radio-keene: add a driver for the Keene FM Transmitter.
      hid-core: ignore the Keene FM transmitter.

 drivers/hid/hid-core.c                        |   10 +
 drivers/hid/hid-ids.h                         |    1 +
 drivers/media/radio/Kconfig                   |   10 +
 drivers/media/radio/Makefile                  |    1 +
 drivers/media/radio/radio-keene.c             |  427 +++++++++++++++++++++++++
 drivers/media/video/bt8xx/bttv-driver.c       |    4 -
 drivers/media/video/cx18/cx18-ioctl.c         |    4 -
 drivers/media/video/ivtv/ivtv-ioctl.c         |    5 -
 drivers/media/video/pwc/pwc-v4l.c             |   10 +-
 drivers/media/video/saa7164/saa7164-encoder.c |    6 -
 drivers/media/video/saa7164/saa7164-vbi.c     |    6 -                                                               
 drivers/media/video/v4l2-ctrls.c              |   32 ++                                                              
 drivers/media/video/v4l2-ioctl.c              |    6 +                                                               
 drivers/media/video/v4l2-subdev.c             |   12 +-                                                              
 drivers/media/video/vivi.c                    |   23 +--                                                             
 include/media/v4l2-ctrls.h                    |   13 +                                                               
 16 files changed, 513 insertions(+), 57 deletions(-)                                                                 
 create mode 100644 drivers/media/radio/radio-keene.c 

Regards,

	Hans

