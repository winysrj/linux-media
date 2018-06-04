Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:33675 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752293AbeFDNF1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 09:05:27 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.18] Various regression fixes
Message-ID: <42d720c9-782f-1d0d-5500-a98090c20e5a@xs4all.nl>
Date: Mon, 4 Jun 2018 15:05:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes, esp the v4l2-ioctl.c fix is critical.

All for 4.18.

Regards,

	Hans

The following changes since commit a00031c159748f322f771f3c1d5ed944cba4bd30:

  media: ddbridge: conditionally enable fast TS for stv0910-equipped bridges (2018-05-28 17:47:05 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.18g

for you to fetch changes up to c735674fbb38fafafd8463202fd1b27f4cff3089:

  media/radio/Kconfig: add back RADIO_ISA (2018-06-04 14:52:34 +0200)

----------------------------------------------------------------
Akinobu Mita (1):
      media: pxa_camera: ignore -ENOIOCTLCMD from v4l2_subdev_call for s_power

Arnd Bergmann (3):
      media: marvel-ccic: allow ccic and mmp drivers to coexist
      media: omap2: fix compile-testing with FB_OMAP2=m
      media: marvel-ccic: mmp: select VIDEOBUF2_VMALLOC/DMA_CONTIG

Dmitry Osipenko (1):
      media: staging: tegra-vde: Reset VDE regardless of memory client resetting failure

Hans Verkuil (2):
      v4l2-ioctl.c: fix missing unlock in __video_do_ioctl()
      media/radio/Kconfig: add back RADIO_ISA

Jacopo Mondi (1):
      media: arch: sh: migor: Fix TW9910 PDN gpio

 arch/sh/boards/mach-migor/setup.c               |  2 +-
 drivers/media/platform/marvell-ccic/Kconfig     |  2 ++
 drivers/media/platform/marvell-ccic/Makefile    |  9 ++++-----
 drivers/media/platform/marvell-ccic/mcam-core.c |  9 ++++++++-
 drivers/media/platform/omap/Kconfig             |  2 +-
 drivers/media/platform/pxa_camera.c             | 35 +++++++++++++++++++++++------------
 drivers/media/radio/Kconfig                     |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c            |  2 +-
 drivers/staging/media/tegra-vde/tegra-vde.c     | 13 +++++--------
 9 files changed, 46 insertions(+), 29 deletions(-)
