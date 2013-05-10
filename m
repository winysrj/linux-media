Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4071 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3EJLUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 07:20:24 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4ABKKti074489
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 10 May 2013 13:20:23 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 46FAF130009A
	for <linux-media@vger.kernel.org>; Fri, 10 May 2013 13:20:20 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates for 3.11.
Date: Fri, 10 May 2013 13:20:19 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201305101320.19258.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 02615ed5e1b2283db2495af3cf8f4ee172c77d80:

  [media] cx88: make core less verbose (2013-04-28 12:40:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to 2bd7485bcca252128e518829ccffb807c92db2bb:

  saa7115: Add register setup and config for gm7113c (2013-05-10 13:19:08 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      wl128x: do not call copy_to_user() while holding spinlocks

Hans Verkuil (2):
      bttv: Add Adlink MPG24 entry to the bttv cardlist
      CARDLIST.bttv: add new cards.

Ismael Luceno (2):
      videodev2.h: Make V4L2_PIX_FMT_MPEG4 comment more specific about its usage
      solo6x10: Approximate frame intervals with non-standard denominator

Jakob Haufe (2):
      rc: Add rc-delock-61959
      em28xx: Add support for 1b80:e1cc Delock 61959

Jon Arne Jørgensen (1):
      saa7115: Add register setup and config for gm7113c

Lad, Prabhakar (4):
      media: davinci: vpif: remove unwanted header file inclusion
      media: davinci: vpif_display: move displaying of error to approppraite place
      media: davinci: vpbe: fix checkpatch warning for CamelCase
      media: i2c: tvp7002: enable TVP7002 decoder for media controller based usage

Lars-Peter Clausen (1):
      media:adv7180: Use dev_pm_ops

Leonid Kegulskiy (2):
      hdpvr: Removed unnecessary get_video_info() call from hdpvr_device_init()
      hdpvr: Added some error handling in hdpvr_start_streaming()

Mauro Carvalho Chehab (2):
      saa7115: move the autodetection code out of the probe function
      saa7115: add detection code for gm7113c

Ondrej Zary (2):
      bttv: Add noname Bt848 capture card with 14MHz xtal
      bttv: Add CyberVision CV06

Scott Jiang (2):
      blackfin: add display support in ppi driver
      bfin_capture: add query_dv_timings/enum_dv_timings support

 Documentation/video4linux/CARDLIST.bttv            |    3 ++
 drivers/media/i2c/adv7180.c                        |   19 ++++---
 drivers/media/i2c/saa7115.c                        |  206 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
 drivers/media/i2c/tvp7002.c                        |   96 +++++++++++++++++++++++++++++++--
 drivers/media/pci/bt8xx/bttv-cards.c               |   52 +++++++++++++++---
 drivers/media/pci/bt8xx/bttv.h                     |    4 ++
 drivers/media/platform/blackfin/bfin_capture.c     |   28 +++++++---
 drivers/media/platform/blackfin/ppi.c              |   12 +++++
 drivers/media/platform/davinci/vpbe_display.c      |    2 +-
 drivers/media/platform/davinci/vpbe_osd.c          |   24 ++++-----
 drivers/media/platform/davinci/vpif_capture.c      |   19 ++-----
 drivers/media/platform/davinci/vpif_capture.h      |    5 +-
 drivers/media/platform/davinci/vpif_display.c      |   25 ++-------
 drivers/media/platform/davinci/vpif_display.h      |    5 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   24 +++++----
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-delock-61959.c         |   83 +++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-cards.c            |   16 ++++++
 drivers/media/usb/em28xx/em28xx-dvb.c              |    5 +-
 drivers/media/usb/em28xx/em28xx.h                  |    1 +
 drivers/media/usb/hdpvr/hdpvr-core.c               |    8 ---
 drivers/media/usb/hdpvr/hdpvr-video.c              |    6 ++-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   38 ++++++-------
 include/media/davinci/vpbe_osd.h                   |    4 +-
 include/media/rc-map.h                             |    1 +
 include/media/tvp7002.h                            |    2 +
 include/media/v4l2-chip-ident.h                    |    2 +
 include/uapi/linux/videodev2.h                     |    2 +-
 28 files changed, 509 insertions(+), 184 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-delock-61959.c
