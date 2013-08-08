Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1527 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3HHLne (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 07:43:34 -0400
Received: from tschai.lan (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id r78BhV3C009348
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 13:43:33 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7A4332A075D
	for <linux-media@vger.kernel.org>; Thu,  8 Aug 2013 13:43:30 +0200 (CEST)
Message-ID: <52038462.5090000@xs4all.nl>
Date: Thu, 08 Aug 2013 13:43:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.12] Patches for 3.12
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Improvements for saa7115/gm7113c, moving the tea575x driver from sound to drivers/media
(where it really belongs), and some streamlining for dv_timings handling: all dv_timings
related helper code is now in a new module, so it's no longer in v4l2-common. I also
added some helper functions/macros to simplify driver development.

Regards,

	Hans

The following changes since commit dfb9f94e8e5e7f73c8e2bcb7d4fb1de57e7c333d:

  [media] stk1160: Build as a module if SND is m and audio support is selected (2013-08-01 14:55:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.12

for you to fetch changes up to e4313121621be741481838090ba2b31a2b1395dc:

  saa7115: Implement i2c_board_info.platform_data (2013-08-08 13:14:49 +0200)

----------------------------------------------------------------
Hans Verkuil (8):
      v4l2-dv-timings.h: remove duplicate V4L2_DV_BT_DMT_1366X768P60
      v4l2-dv-timings: add new helper module.
      v4l2: move dv-timings related code to v4l2-dv-timings.c
      DocBook/media/v4l: il_* fields always 0 for progressive formats
      videodev2.h: defines to calculate blanking and frame sizes
      v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
      v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
      ths8200/ad9389b: use new dv_timings helpers.

Jon Arne Jørgensen (3):
      saa7115: Fix saa711x_set_v4lstd for gm7113c
      saa7115: Do not load saa7115_init_misc for gm7113c
      saa7115: Implement i2c_board_info.platform_data

Ondrej Zary (2):
      tea575x: Move header from sound to media
      tea575x: Move from sound to media

 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml          |   6 +-
 drivers/media/i2c/ad9389b.c                                      | 115 +++----------
 drivers/media/i2c/adv7604.c                                      |   9 +-
 drivers/media/i2c/saa7115.c                                      | 167 ++++++++++++++----
 drivers/media/i2c/saa711x_regs.h                                 |  19 +++
 drivers/media/i2c/ths7303.c                                      |   6 +-
 drivers/media/i2c/ths8200.c                                      |  64 +++----
 drivers/media/platform/blackfin/bfin_capture.c                   |   9 +-
 drivers/media/platform/davinci/vpif_capture.c                    |  10 +-
 drivers/media/platform/davinci/vpif_display.c                    |  10 +-
 drivers/media/radio/Kconfig                                      |  12 +-
 drivers/media/radio/Makefile                                     |   1 +
 drivers/media/radio/radio-maxiradio.c                            |   2 +-
 drivers/media/radio/radio-sf16fmr2.c                             |   2 +-
 drivers/media/radio/radio-shark.c                                |   2 +-
 sound/i2c/other/tea575x-tuner.c => drivers/media/radio/tea575x.c |   2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                            |   7 +-
 drivers/media/v4l2-core/Makefile                                 |   1 +
 drivers/media/v4l2-core/v4l2-common.c                            | 357 --------------------------------------
 drivers/media/v4l2-core/v4l2-dv-timings.c                        | 548 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/media/saa7115.h                                          |  64 +++++++
 include/{sound/tea575x-tuner.h => media/tea575x.h}               |   0
 include/media/v4l2-common.h                                      |  13 --
 include/media/v4l2-dv-timings.h                                  | 126 ++++++++++++++
 include/uapi/linux/v4l2-dv-timings.h                             |   8 -
 include/uapi/linux/videodev2.h                                   |  10 ++
 sound/i2c/other/Makefile                                         |   2 -
 sound/pci/Kconfig                                                |   9 +-
 sound/pci/es1968.c                                               |   2 +-
 sound/pci/fm801.c                                                |   2 +-
 30 files changed, 979 insertions(+), 606 deletions(-)
 rename sound/i2c/other/tea575x-tuner.c => drivers/media/radio/tea575x.c (99%)
 create mode 100644 drivers/media/v4l2-core/v4l2-dv-timings.c
 rename include/{sound/tea575x-tuner.h => media/tea575x.h} (100%)
 create mode 100644 include/media/v4l2-dv-timings.h
