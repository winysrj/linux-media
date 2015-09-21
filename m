Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:37850 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052AbbIUKAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 06:00:18 -0400
Received: from [10.61.104.16] (unknown [173.38.220.50])
	by tschai.lan (Postfix) with ESMTPSA id 1AF652A00AE
	for <linux-media@vger.kernel.org>; Mon, 21 Sep 2015 11:58:53 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.4] Fixes, enhancements, etc.
Message-ID: <55FFD52D.9040502@xs4all.nl>
Date: Mon, 21 Sep 2015 12:00:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request is a pile of fixes and enhancements.

The main changes are a new colorspace and a new transfer function and a cleaned
up saa7164 (now passes v4l2-compliance).

Arnd also did some preparation to simplify future y2038 work.

Regards,

	Hans

The following changes since commit 9ddf9071ea17b83954358b2dac42b34e5857a9af:

  Merge tag 'v4.3-rc1' into patchwork (2015-09-13 11:10:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.4b

for you to fetch changes up to d8af0338c98cd184eb8753fb1ba4291756ba30d6:

  go7007: Fix returned errno code in gen_mjpeghdr_to_package() (2015-09-21 11:50:40 +0200)

----------------------------------------------------------------
Arnd Bergmann (2):
      exynos4-is: use monotonic timestamps as advertized
      use v4l2_get_timestamp where possible

Geliang Tang (1):
      media: fix kernel-doc warnings in v4l2-dv-timings.h

Hans Verkuil (24):
      v4l2-compat-ioctl32: replace pr_warn by pr_debug
      vivid: use ARRAY_SIZE to calculate max control value
      vivid: use Bradford method when converting Rec. 709 to NTSC 1953
      videodev2.h: add support for the DCI-P3 colorspace
      DocBook media: document the new DCI-P3 colorspace
      vivid-tpg: support the DCI-P3 colorspace
      vivid: add support for the DCI-P3 colorspace
      videodev2.h: add SMPTE 2084 transfer function define
      vivid-tpg: add support for SMPTE 2084 transfer function
      vivid: add support for SMPTE 2084 transfer function
      DocBook media: Document the SMPTE 2084 transfer function
      vim2m: small cleanup: use assignment instead of memcpy
      v4l2-compat-ioctl32: add missing SDR support
      vivid: add 10 and 12 bit Bayer formats
      saa7164: convert to the control framework
      saa7164: add v4l2_fh support
      saa7164: fix poll bugs
      saa7164: add support for control events
      saa7164: fix format ioctls
      saa7164: remove unused videobuf references
      saa7164: fix input and tuner compliance problems
      saa7164: video and vbi ports share the same input/tuner/std
      v4l2-ctrls: arrays are also considered compound controls
      DocBook/media: clarify control documentation

Javier Martinez Canillas (2):
      s5c73m3: Export OF module alias information
      go7007: Fix returned errno code in gen_mjpeghdr_to_package()

Ricardo Ribalda Delgado (2):
      videodev2.h: Fix typo in comment
      media/v4l2-compat-ioctl32: Simple stylechecks

Sergei Shtylyov (1):
      ml86v7667: implement g_std() method

 Documentation/DocBook/media/v4l/biblio.xml             |  18 +++
 Documentation/DocBook/media/v4l/pixfmt.xml             | 109 +++++++++++++
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |   7 +
 Documentation/DocBook/media/v4l/vidioc-queryctrl.xml   |  21 ++-
 drivers/media/i2c/ml86v7667.c                          |  10 ++
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c                |   1 +
 drivers/media/pci/bt8xx/bttv-driver.c                  |   5 +-
 drivers/media/pci/cx18/cx18-mailbox.c                  |   2 +-
 drivers/media/pci/saa7164/Kconfig                      |   1 -
 drivers/media/pci/saa7164/saa7164-encoder.c            | 653 +++++++++++++++++++++--------------------------------------------------------
 drivers/media/pci/saa7164/saa7164-vbi.c                | 629 +++-----------------------------------------------------------------------
 drivers/media/pci/saa7164/saa7164.h                    |  26 +++-
 drivers/media/platform/exynos4-is/fimc-capture.c       |   8 +-
 drivers/media/platform/exynos4-is/fimc-lite.c          |   7 +-
 drivers/media/platform/omap3isp/ispstat.c              |   5 +-
 drivers/media/platform/omap3isp/ispstat.h              |   2 +-
 drivers/media/platform/s3c-camif/camif-capture.c       |   8 +-
 drivers/media/platform/vim2m.c                         |   7 +-
 drivers/media/platform/vivid/vivid-core.h              |   1 +
 drivers/media/platform/vivid/vivid-ctrls.c             |  18 ++-
 drivers/media/platform/vivid/vivid-tpg-colors.c        | 328 +++++++++++++++++++++++++++++++++------
 drivers/media/platform/vivid/vivid-tpg-colors.h        |   4 +-
 drivers/media/platform/vivid/vivid-tpg.c               |  91 +++++++++++
 drivers/media/platform/vivid/vivid-vid-common.c        |  56 +++++++
 drivers/media/usb/go7007/go7007-fw.c                   |   6 +-
 drivers/media/usb/gspca/gspca.c                        |   4 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c          |  40 +++--
 drivers/media/v4l2-core/v4l2-ctrls.c                   |   4 +-
 drivers/staging/media/omap4iss/iss_video.c             |   5 +-
 include/media/v4l2-dv-timings.h                        |  32 ++--
 include/uapi/linux/videodev2.h                         |  21 ++-
 31 files changed, 899 insertions(+), 1230 deletions(-)
