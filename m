Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33776 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204AbaLALrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 06:47:19 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0C2D22A008F
	for <linux-media@vger.kernel.org>; Mon,  1 Dec 2014 12:47:04 +0100 (CET)
Message-ID: <547C5537.8050302@xs4all.nl>
Date: Mon, 01 Dec 2014 12:47:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Various fixes/improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes and improvements.

Regards,

	Hans

The following changes since commit 504febc3f98c87a8bebd8f2f274f32c0724131e4:

  Revert "[media] lmed04: add missing breaks" (2014-11-25 22:16:25 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19k

for you to fetch changes up to bdee6e4c8908a5524c81b2ba5f754f5c2a637068:

  omap_vout: fix compile warnings (2014-12-01 12:44:43 +0100)

----------------------------------------------------------------
Hans Verkuil (7):
      cx18: add device_caps support
      staging/media: fix querycap
      media/usb,pci: fix querycap
      media/radio: fix querycap
      media/platform: fix querycap
      media/platform: fix querycap
      omap_vout: fix compile warnings

Markus Elfring (1):
      V4L2: Deletion of an unnecessary check before the function call "vb2_put_vma"

Prabhakar Lad (3):
      media: marvell-ccic: use vb2_ops_wait_prepare/finish helper
      media: blackfin: use vb2_ops_wait_prepare/finish helper
      media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper

 drivers/media/pci/cx18/cx18-cards.h             |  3 ++-
 drivers/media/pci/cx18/cx18-driver.h            |  1 +
 drivers/media/pci/cx18/cx18-ioctl.c             |  7 ++++---
 drivers/media/pci/cx18/cx18-streams.c           |  9 +++++++++
 drivers/media/pci/meye/meye.c                   |  3 ---
 drivers/media/pci/zoran/zoran_driver.c          |  5 +++--
 drivers/media/platform/blackfin/bfin_capture.c  | 20 +++++---------------
 drivers/media/platform/davinci/vpbe_display.c   |  1 -
 drivers/media/platform/davinci/vpfe_capture.c   |  4 ++--
 drivers/media/platform/davinci/vpif_capture.c   |  2 ++
 drivers/media/platform/fsl-viu.c                |  3 ++-
 drivers/media/platform/marvell-ccic/mcam-core.c | 33 +++++++--------------------------
 drivers/media/platform/mx2_emmaprp.c            |  9 ++-------
 drivers/media/platform/omap/omap_vout.c         | 11 ++++++-----
 drivers/media/platform/s5p-g2d/g2d.c            | 10 ++--------
 drivers/media/platform/s5p-jpeg/jpeg-core.c     |  9 ++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  6 ++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  6 ++----
 drivers/media/platform/sh_vou.c                 |  3 ++-
 drivers/media/platform/via-camera.c             |  4 ++--
 drivers/media/platform/vino.c                   |  6 ++----
 drivers/media/radio/radio-wl1273.c              |  4 +++-
 drivers/media/radio/wl128x/fmdrv_v4l2.c         |  4 +++-
 drivers/media/usb/usbvision/usbvision-video.c   |  3 ++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c     |  3 +--
 drivers/staging/media/bcm2048/radio-bcm2048.c   |  5 +++--
 drivers/staging/media/davinci_vpfe/vpfe_video.c |  8 ++++----
 drivers/staging/media/dt3155v4l/dt3155v4l.c     |  5 ++---
 28 files changed, 77 insertions(+), 110 deletions(-)
