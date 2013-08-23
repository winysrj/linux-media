Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:31092 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3HWMYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:49 -0400
Received: from [10.61.200.28] ([10.61.200.28])
	(authenticated bits=0)
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id r7NCOiVU032556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 23 Aug 2013 12:24:46 GMT
Message-ID: <5217548C.10502@cisco.com>
Date: Fri, 23 Aug 2013 14:24:44 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.12] Updates for v3.12
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of fixes and two new drivers: adv7842 and adv7511.

Regards,

	Hans

The following changes since commit bfd22c490bc74f9603ea90c37823036660a313e2:

  v4l2-common: warning fix (W=1): add a missed function prototype (2013-08-18 10:18:30 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.12

for you to fetch changes up to 72230f27e0c7668e14dbcbd8abc1ed1c08451931:

  MAINTAINERS: add entries for adv7511 and adv7842. (2013-08-23 14:12:44 +0200)

----------------------------------------------------------------
Hans Verkuil (13):
      v4l2-dv-timings: add v4l2_print_dv_timings helper
      ad9389b/adv7604/ths8200: use new v4l2_print_dv_timings helper.
      v4l2-dv-timings: rename v4l_match_dv_timings to v4l2_match_dv_timings
      adv7604/ad9389b/ths8200: decrease min_pixelclock to 25MHz
      v4l2-dv-timings: fill in type field
      v4l2-dv-timings: export the timings list.
      v4l2-dv-timings: rename v4l2_dv_valid_timings to v4l2_valid_dv_timings
      v4l2-dv-timings: add callback to handle exceptions
      adv7604: set is_private only after successfully creating all controls
      ad9389b: set is_private only after successfully creating all controls
      adv7842: add new video decoder driver.
      adv7511: add new video encoder.
      MAINTAINERS: add entries for adv7511 and adv7842.

Lad, Prabhakar (2):
      media: OF: add "sync-on-green-active" property
      media: i2c: tvp7002: add OF support

Martin Bugge (4):
      v4l2-dv-timings: fix CVT calculation
      adv7604: pixel-clock depends on deep-color-mode
      ad9389b: trigger edid re-read by power-cycle chip
      adv7604: corrected edid crc-calculation

Mats Randgaard (5):
      adv7604: debounce "format change" notifications
      adv7604: improve log_status for HDMI/DVI-D signals
      adv7604: print flags and standards in timing information
      ad9389b: no monitor if EDID is wrong
      ad9389b: change initial register configuration in ad9389b_setup()

Ricardo Ribalda (1):
      v4l2-dev: Fix race condition on __video_register_device

Sylwester Nawrocki (1):
      v4l2-ctrl: Suppress build warning from v4l2_ctrl_new_std_menu()

 Documentation/devicetree/bindings/media/i2c/tvp7002.txt      |   53 ++
 Documentation/devicetree/bindings/media/video-interfaces.txt |    2 +
 MAINTAINERS                                                  |   12 +
 drivers/media/i2c/Kconfig                                    |   23 +
 drivers/media/i2c/Makefile                                   |    2 +
 drivers/media/i2c/ad9389b.c                                  |   60 +-
 drivers/media/i2c/adv7511.c                                  | 1198 +++++++++++++++++++++++++
 drivers/media/i2c/adv7604.c                                  |  147 +--
 drivers/media/i2c/adv7842.c                                  | 2946 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ths8200.c                                  |   49 +-
 drivers/media/i2c/tvp7002.c                                  |   67 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c                     |    2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                        |    2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c                         |    2 +-
 drivers/media/v4l2-core/v4l2-dev.c                           |    5 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c                    |  121 ++-
 drivers/media/v4l2-core/v4l2-of.c                            |    4 +
 include/media/adv7511.h                                      |   48 +
 include/media/adv7842.h                                      |  226 +++++
 include/media/v4l2-dv-timings.h                              |   59 +-
 include/media/v4l2-mediabus.h                                |    3 +
 21 files changed, 4846 insertions(+), 185 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
 create mode 100644 drivers/media/i2c/adv7511.c
 create mode 100644 drivers/media/i2c/adv7842.c
 create mode 100644 include/media/adv7511.h
 create mode 100644 include/media/adv7842.h
