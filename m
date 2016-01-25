Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:38339 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756158AbcAYOwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 09:52:49 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6CE58180B7D
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2016 15:52:32 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] Various fixes
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <56A636B0.2050102@xs4all.nl>
Date: Mon, 25 Jan 2016 15:52:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lot's of fixes, but nothing special. The only interesting fix is the
v4l2-compat-ioctl32 patch that fixes a long-standing compat32 bug (since
kernel 3.7!).

Regards,

	Hans

The following changes since commit 99e44da7928d4abb3028258ac3cd23a48495cd61:

  [media] media: change email address (2016-01-25 12:01:08 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6a

for you to fetch changes up to a750fd7cb32aeb4f4c4ffe044832b01be103aa94:

  vivid: fix broken Bayer text rendering (2016-01-25 15:50:17 +0100)

----------------------------------------------------------------
Dan Carpenter (3):
      vpx3220: signedness bug in vpx3220_fp_read()
      staging: media: lirc: fix MODULE_PARM_DESC typo
      wl128x: fix typo in MODULE_PARM_DESC

Ezequiel Garcia (1):
      stk1160: Remove redundant vb2_buf payload set

Fugang Duan (1):
      radio-si476x: add return value check to avoid dead code

Geliang Tang (1):
      bttv-driver, usbvision-video: use to_video_device()

Hans Verkuil (4):
      saa7134: add DMABUF support
      v4l2-dv-timings: skip standards check for V4L2_DV_BT_CAP_CUSTOM
      DocBook media: make explicit that standard/timings never change automatically
      vivid: fix broken Bayer text rendering

Insu Yun (2):
      cx231xx: correctly handling failed allocation
      usbtv: correctly handling failed allocation

Jean-Baptiste Theou (1):
      cx231xx: Fix memory leak

Julia Lawall (7):
      constify stv6110x_devctl structure
      drivers/media/usb/as102: constify as102_priv_ops_t structure
      go7007: constify go7007_hpi_ops structures
      av7110: constify sp8870_config structure
      drivers/media/usb/dvb-usb-v2: constify mxl111sf_tuner_config structure
      media: bt8xx: constify or51211_config structure
      media: bt8xx: constify sp887x_config structure

Markus Elfring (3):
      bttv: Returning only value constants in two functions
      au0828: Refactoring for start_urb_transfer()
      hdpvr: Refactoring for hdpvr_read()

Mats Randgaard (2):
      tc358743: Print timings only when debug level is set
      tc358743: Use local array with fixed size in i2c write

Niklas Söderlund (1):
      vim2m: return error if driver registration fails

Nikola Forró (1):
      usbtv: discard redundant video fields

Philipp Zabel (1):
      coda: fix first encoded frame payload

Tiffany Lin (1):
      media: v4l2-compat-ioctl32: fix missing length copy in put_v4l2_buffer32

Ulrich Hecht (1):
      media: adv7604: implement get_selection

Wu, Xia (1):
      media: videobuf2-core: Fix one __qbuf_dmabuf() error path

 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml | 14 ++++++++++++--
 Documentation/DocBook/media/v4l/vidioc-querystd.xml         | 10 ++++++++++
 drivers/media/dvb-frontends/stv6110x.c                      |  4 ++--
 drivers/media/dvb-frontends/stv6110x.h                      |  4 ++--
 drivers/media/dvb-frontends/stv6110x_priv.h                 |  2 +-
 drivers/media/i2c/adv7604.c                                 | 21 +++++++++++++++++++++
 drivers/media/i2c/tc358743.c                                | 25 +++++++++++++------------
 drivers/media/i2c/vpx3220.c                                 |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                       | 27 +++++++--------------------
 drivers/media/pci/bt8xx/dvb-bt8xx.c                         |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-core.c                  |  2 +-
 drivers/media/pci/ngene/ngene-cards.c                       |  2 +-
 drivers/media/pci/saa7134/saa7134-empress.c                 |  3 ++-
 drivers/media/pci/saa7134/saa7134-go7007.c                  |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c                   |  3 ++-
 drivers/media/pci/ttpci/av7110.c                            |  2 +-
 drivers/media/pci/ttpci/budget.c                            |  4 ++--
 drivers/media/platform/coda/coda-bit.c                      |  2 +-
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c        |  2 +-
 drivers/media/platform/vim2m.c                              |  2 +-
 drivers/media/platform/vivid/vivid-tpg.h                    |  2 ++
 drivers/media/radio/radio-si476x.c                          |  4 ++--
 drivers/media/radio/wl128x/fmdrv_common.c                   |  2 +-
 drivers/media/usb/as102/as102_drv.h                         |  2 +-
 drivers/media/usb/as102/as102_usb_drv.c                     |  2 +-
 drivers/media/usb/au0828/au0828-dvb.c                       | 12 +++++-------
 drivers/media/usb/cx231xx/cx231xx-417.c                     |  2 ++
 drivers/media/usb/cx231xx/cx231xx-audio.c                   |  5 +++++
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c               |  6 +++---
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h               |  8 ++++----
 drivers/media/usb/dvb-usb-v2/mxl111sf.c                     |  2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c                  |  2 +-
 drivers/media/usb/go7007/go7007-priv.h                      |  2 +-
 drivers/media/usb/go7007/go7007-usb.c                       |  4 ++--
 drivers/media/usb/hdpvr/hdpvr-video.c                       |  6 ++----
 drivers/media/usb/stk1160/stk1160-video.c                   |  1 -
 drivers/media/usb/usbtv/usbtv-video.c                       | 37 +++++++++++++++++++++++--------------
 drivers/media/usb/usbtv/usbtv.h                             |  1 +
 drivers/media/usb/usbvision/usbvision-video.c               | 27 +++++++++------------------
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c               | 21 ++++++++-------------
 drivers/media/v4l2-core/v4l2-dv-timings.c                   |  3 ++-
 drivers/media/v4l2-core/videobuf2-core.c                    |  1 +
 drivers/staging/media/lirc/lirc_parallel.c                  |  2 +-
 43 files changed, 162 insertions(+), 129 deletions(-)
