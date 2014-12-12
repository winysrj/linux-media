Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56989 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967792AbaLLNrN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:47:13 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DE4AB2A008C
	for <linux-media@vger.kernel.org>; Fri, 12 Dec 2014 14:47:05 +0100 (CET)
Message-ID: <548AF1D9.3040907@xs4all.nl>
Date: Fri, 12 Dec 2014 14:47:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v3.19] Fixes/deprecated drivers
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The first 9 patches are all fixes that need to go to kernel 3.19.

The last three patches deprecate drivers. Since I haven't seen a reply from
Ondrej yet regarding the parport drivers, I will leave it up to you whether
you will apply the last patch to 3.19 or not. I pinged him again, so I hope
he'll clarify his email soon.

I am OK with that last one being postponed to 3.20 if there is no alternative.

Regards,

	Hans

The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

  [media] mn88473: One function call less in mn88473_init() after error (2014-12-04 16:00:47 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19m

for you to fetch changes up to a7222ae6b6a303aa2377dc0e58fea6715bf41890:

  bq/c-qcam, w9966, pms: move to staging in preparation for removal (2014-12-12 14:42:50 +0100)

----------------------------------------------------------------
Hans Verkuil (12):
      v4l2-mediabus.h: use two __u16 instead of two __u32
      DocBook media: add missing ycbcr_enc and quantization fields
      vivid.txt: document new controls
      DocBook media: update version number and document changes.
      vivid: fix CROP_BOUNDS typo for video output
      v4l2-ioctl: WARN_ON if querycap didn't fill device_caps
      cx88: add missing alloc_ctx support
      cx88: remove leftover start_video_dma() call
      MAINTAINERS: vivi -> vivid
      vino/saa7191: move to staging in preparation for removal
      tlg2300: move to staging in preparation for removal
      bq/c-qcam, w9966, pms: move to staging in preparation for removal

 Documentation/DocBook/media/v4l/compat.xml                | 12 ++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml                | 36 ++++++++++++++++++++++++++++++++++--
 Documentation/DocBook/media/v4l/subdev-formats.xml        | 18 +++++++++++++++++-
 Documentation/DocBook/media/v4l/v4l2.xml                  | 11 ++++++++++-
 Documentation/video4linux/vivid.txt                       | 15 +++++++++++++++
 MAINTAINERS                                               |  4 ++--
 drivers/media/Kconfig                                     |  1 -
 drivers/media/Makefile                                    |  2 +-
 drivers/media/i2c/Kconfig                                 |  9 ---------
 drivers/media/i2c/Makefile                                |  1 -
 drivers/media/pci/cx88/cx88-blackbird.c                   |  4 +---
 drivers/media/pci/cx88/cx88-dvb.c                         |  4 +---
 drivers/media/pci/cx88/cx88-mpeg.c                        | 11 +++++++----
 drivers/media/pci/cx88/cx88-vbi.c                         |  9 +--------
 drivers/media/pci/cx88/cx88-video.c                       | 18 +++++++++---------
 drivers/media/pci/cx88/cx88.h                             |  2 ++
 drivers/media/platform/Kconfig                            |  8 --------
 drivers/media/platform/Makefile                           |  3 ---
 drivers/media/platform/vivid/vivid-vid-out.c              |  2 +-
 drivers/media/usb/Kconfig                                 |  1 -
 drivers/media/usb/Makefile                                |  1 -
 drivers/media/v4l2-core/v4l2-ioctl.c                      |  6 ++++++
 drivers/staging/media/Kconfig                             |  6 ++++++
 drivers/staging/media/Makefile                            |  3 +++
 drivers/{ => staging}/media/parport/Kconfig               | 24 ++++++++++++++++++++----
 drivers/{ => staging}/media/parport/Makefile              |  0
 drivers/{ => staging}/media/parport/bw-qcam.c             |  0
 drivers/{ => staging}/media/parport/c-qcam.c              |  0
 drivers/{ => staging}/media/parport/pms.c                 |  0
 drivers/{ => staging}/media/parport/w9966.c               |  0
 drivers/{media/usb => staging/media}/tlg2300/Kconfig      |  6 +++++-
 drivers/{media/usb => staging/media}/tlg2300/Makefile     |  0
 drivers/{media/usb => staging/media}/tlg2300/pd-alsa.c    |  0
 drivers/{media/usb => staging/media}/tlg2300/pd-common.h  |  0
 drivers/{media/usb => staging/media}/tlg2300/pd-dvb.c     |  0
 drivers/{media/usb => staging/media}/tlg2300/pd-main.c    |  0
 drivers/{media/usb => staging/media}/tlg2300/pd-radio.c   |  0
 drivers/{media/usb => staging/media}/tlg2300/pd-video.c   |  0
 drivers/{media/usb => staging/media}/tlg2300/vendorcmds.h |  0
 drivers/staging/media/vino/Kconfig                        | 24 ++++++++++++++++++++++++
 drivers/staging/media/vino/Makefile                       |  3 +++
 drivers/{media/platform => staging/media/vino}/indycam.c  |  0
 drivers/{media/platform => staging/media/vino}/indycam.h  |  0
 drivers/{media/i2c => staging/media/vino}/saa7191.c       |  0
 drivers/{media/i2c => staging/media/vino}/saa7191.h       |  0
 drivers/{media/platform => staging/media/vino}/vino.c     |  0
 drivers/{media/platform => staging/media/vino}/vino.h     |  0
 include/uapi/linux/v4l2-mediabus.h                        |  6 +++---
 48 files changed, 183 insertions(+), 67 deletions(-)
 rename drivers/{ => staging}/media/parport/Kconfig (65%)
 rename drivers/{ => staging}/media/parport/Makefile (100%)
 rename drivers/{ => staging}/media/parport/bw-qcam.c (100%)
 rename drivers/{ => staging}/media/parport/c-qcam.c (100%)
 rename drivers/{ => staging}/media/parport/pms.c (100%)
 rename drivers/{ => staging}/media/parport/w9966.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/Kconfig (63%)
 rename drivers/{media/usb => staging/media}/tlg2300/Makefile (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-alsa.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-common.h (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-dvb.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-main.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-radio.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-video.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/vendorcmds.h (100%)
 create mode 100644 drivers/staging/media/vino/Kconfig
 create mode 100644 drivers/staging/media/vino/Makefile
 rename drivers/{media/platform => staging/media/vino}/indycam.c (100%)
 rename drivers/{media/platform => staging/media/vino}/indycam.h (100%)
 rename drivers/{media/i2c => staging/media/vino}/saa7191.c (100%)
 rename drivers/{media/i2c => staging/media/vino}/saa7191.h (100%)
 rename drivers/{media/platform => staging/media/vino}/vino.c (100%)
 rename drivers/{media/platform => staging/media/vino}/vino.h (100%)
