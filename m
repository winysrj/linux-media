Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:3614 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab3EWKwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 06:52:32 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id r4NAqQZa003138
	for <linux-media@vger.kernel.org>; Thu, 23 May 2013 10:52:26 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates for 3.11
Date: Thu, 23 May 2013 12:52:12 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231252.12515.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6a084d6b3dc200b855ae8a3c6771abe285a3835d:

  [media] saa7115: Don't use a dynamic array (2013-05-21 12:04:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to 012b0eaea1af98022246f7bc360a0ae0ac8d2992:

  media: pci: remove duplicate checks for EPERM (2013-05-23 12:51:20 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      bw-qcam: fix timestamp handling

Jean Delvare (1):
      sony-btf-mpx: Drop needless newline in param description

Lad, Prabhakar (7):
      videodev2.h: fix typos
      media: i2c: tvp7002: remove duplicate define
      media: i2c: tvp7002: rearrange description of structure members
      media: i2c: remove duplicate checks for EPERM in dbg_g/s_register
      media: dvb-frontends: remove duplicate checks for EPERM in dbg_g/s_register
      media: usb: remove duplicate checks for EPERM in vidioc_g/s_register
      media: pci: remove duplicate checks for EPERM

Leonid Kegulskiy (2):
      hdpvr: Removed unnecessary use of kzalloc() in get_video_info()
      hdpvr: Cleaned up error handling

Philipp Zabel (6):
      coda: v4l2-compliance fix: add bus_info prefix 'platform'
      coda: use devm_ioremap_resource
      coda: enable dmabuf support
      coda: set umask 0644 on debug module param
      coda: fix error return value if v4l2_m2m_ctx_init fails
      coda: do not use v4l2_dev in coda_timeout

Sachin Kamat (2):
      timblogiw: Remove redundant platform_set_drvdata()
      rc: gpio-ir-recv: Remove redundant platform_set_drvdata()

Wei Yongjun (6):
      v4l: vb2: fix error return code in __vb2_init_fileio()
      vpif_display: fix error return code in vpif_probe()
      vpif_capture: fix error return code in vpif_probe()
      ad9389b: fix error return code in ad9389b_probe()
      blackfin: fix error return code in bcap_probe()
      sta2x11_vip: fix error return code in sta2x11_vip_init_one()

 drivers/media/dvb-frontends/au8522_decoder.c   |    4 ----
 drivers/media/i2c/ad9389b.c                    |    6 ++---
 drivers/media/i2c/adv7183.c                    |    4 ----
 drivers/media/i2c/adv7604.c                    |    4 ----
 drivers/media/i2c/cs5345.c                     |    4 ----
 drivers/media/i2c/cx25840/cx25840-core.c       |    4 ----
 drivers/media/i2c/m52790.c                     |    4 ----
 drivers/media/i2c/mt9v011.c                    |    4 ----
 drivers/media/i2c/ov7670.c                     |    4 ----
 drivers/media/i2c/saa7115.c                    |    4 ----
 drivers/media/i2c/saa7127.c                    |    4 ----
 drivers/media/i2c/saa717x.c                    |    4 ----
 drivers/media/i2c/sony-btf-mpx.c               |    2 +-
 drivers/media/i2c/ths7303.c                    |    4 ----
 drivers/media/i2c/tvp5150.c                    |    4 ----
 drivers/media/i2c/tvp7002.c                    |   13 ++--------
 drivers/media/i2c/upd64031a.c                  |    4 ----
 drivers/media/i2c/upd64083.c                   |    4 ----
 drivers/media/i2c/vs6624.c                     |    4 ----
 drivers/media/parport/bw-qcam.c                |    2 ++
 drivers/media/pci/bt8xx/bttv-driver.c          |    6 -----
 drivers/media/pci/cx18/cx18-av-core.c          |    4 ----
 drivers/media/pci/cx23885/cx23885-ioctl.c      |    6 -----
 drivers/media/pci/cx23885/cx23888-ir.c         |    4 ----
 drivers/media/pci/ivtv/ivtv-ioctl.c            |    2 --
 drivers/media/pci/saa7146/mxb.c                |    4 ----
 drivers/media/pci/saa7164/saa7164-encoder.c    |    6 -----
 drivers/media/pci/sta2x11/sta2x11_vip.c        |    3 ++-
 drivers/media/platform/blackfin/bfin_capture.c |    8 ++-----
 drivers/media/platform/coda.c                  |   35 +++++++++++++--------------
 drivers/media/platform/davinci/vpif_capture.c  |    1 +
 drivers/media/platform/davinci/vpif_display.c  |    1 +
 drivers/media/platform/timblogiw.c             |    4 ----
 drivers/media/rc/gpio-ir-recv.c                |    2 --
 drivers/media/usb/hdpvr/hdpvr-control.c        |   22 +++++------------
 drivers/media/usb/hdpvr/hdpvr-video.c          |   64 +++++++++++++++++++++++++++-----------------------
 drivers/media/usb/hdpvr/hdpvr.h                |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c        |    2 --
 drivers/media/v4l2-core/videobuf2-core.c       |    4 +++-
 include/media/tvp7002.h                        |   44 ++++++++++++++++------------------
 include/uapi/linux/videodev2.h                 |    8 +++----
 41 files changed, 99 insertions(+), 220 deletions(-)
