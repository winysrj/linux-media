Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58582 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbbG1JWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 05:22:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2CDC62A0089
	for <linux-media@vger.kernel.org>; Tue, 28 Jul 2015 11:22:15 +0200 (CEST)
Message-ID: <55B749C7.4070005@xs4all.nl>
Date: Tue, 28 Jul 2015 11:22:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request contains a pile of fixes/enhancements, mostly soc-camera
related.

Regards,

	Hans

The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:

  [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 13:32:21 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3e

for you to fetch changes up to 9a400ca65ee917dc438cb9b553c11580269b4460:

  v4l2: export videobuf2 trace points (2015-07-28 11:15:04 +0200)

----------------------------------------------------------------
Ezequiel Garcia (1):
      tw68: Move PCI vendor and device IDs to pci_ids.h

Hans Verkuil (13):
      sh-veu: initialize timestamp_flags and copy timestamp info
      tw9910: don't use COLORSPACE_JPEG
      tw9910: init priv->scale and update standard
      ak881x: simplify standard checks
      mt9t112: JPEG -> SRGB
      sh_mobile_ceu_camera: fix querycap
      sh_mobile_ceu_camera: set field to FIELD_NONE
      soc_camera: fix enum_input
      soc_camera: fix expbuf support
      soc_camera: compliance fixes
      soc_camera: pass on streamoff error
      soc_camera: always release queue for queue owner
      mt9v032: fix uninitialized variable warning

Laurent Pinchart (1):
      v4l: subdev: Add pad config allocator and init

Philipp Zabel (1):
      v4l2: export videobuf2 trace points

Rob Taylor (3):
      media: soc_camera: soc_scale_crop: Use correct pad number in try_fmt
      media: rcar_vin: fill in bus_info field
      media: rcar_vin: Reject videobufs that are too small for current format

William Towle (5):
      media: adv7604: fix probe of ADV7611/7612
      media: adv7604: reduce support to first (digital) input
      media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888 input support
      media: soc_camera pad-aware driver initialisation
      media: rcar_vin: Use correct pad number in try_fmt

 drivers/media/i2c/adv7604.c                              | 19 +++++++++++++++----
 drivers/media/i2c/ak881x.c                               |  8 ++++----
 drivers/media/i2c/mt9v032.c                              |  2 +-
 drivers/media/i2c/soc_camera/mt9t112.c                   |  8 ++++----
 drivers/media/i2c/soc_camera/tw9910.c                    | 35 +++++++++++++++++++++++++++++++----
 drivers/media/pci/tw68/tw68-core.c                       | 21 +++++++++++----------
 drivers/media/pci/tw68/tw68.h                            | 16 ----------------
 drivers/media/platform/sh_veu.c                          |  8 ++++++++
 drivers/media/platform/soc_camera/Kconfig                |  1 +
 drivers/media/platform/soc_camera/rcar_vin.c             | 34 +++++++++++++++++++++++++++-------
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  3 +++
 drivers/media/platform/soc_camera/soc_camera.c           | 67 +++++++++++++++++++++++++++++++++++++++++++++++--------------------
 drivers/media/platform/soc_camera/soc_scale_crop.c       |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c                     |  5 +++++
 drivers/media/v4l2-core/v4l2-subdev.c                    | 19 ++++++++++++++++++-
 include/linux/pci_ids.h                                  |  9 +++++++++
 include/media/soc_camera.h                               |  1 +
 include/media/v4l2-subdev.h                              | 11 +++++++++++
 18 files changed, 197 insertions(+), 71 deletions(-)
