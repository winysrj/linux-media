Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40629 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754762AbeDTNZU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:25:20 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Dmitry Osipenko <digetx@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.18] tegra-vde, video-i2c and usbtv patches
Message-ID: <992fa6de-b315-2a83-d439-1c0a710743d0@xs4all.nl>
Date: Fri, 20 Apr 2018 15:25:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 1d338b86e17d87215cf57b1ad1d13b2afe582d33:

  media: v4l2-compat-ioctl32: better document the code (2018-04-20 08:24:13 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.18a

for you to fetch changes up to 548ea201716e4f81920f520e47d072f4615164d2:

  usbtv: Use the constant for supported standards (2018-04-20 14:53:18 +0200)

----------------------------------------------------------------
Dmitry Osipenko (5):
      media: staging: tegra-vde: Align bitstream size to 16K
      media: staging: tegra-vde: Silence some of checkpatch warnings
      media: staging: tegra-vde: Correct minimum size of U/V planes
      media: staging: tegra-vde: Do not handle spurious interrupts
      media: staging: tegra-vde: Correct included header

Hugo Grostabussiat (6):
      usbtv: Use same decoder sequence as Windows driver
      usbtv: Add SECAM support
      usbtv: Use V4L2 defines to select capture resolution
      usbtv: Keep norm parameter specific
      usbtv: Enforce standard for color decoding
      usbtv: Use the constant for supported standards

Matt Ranostay (2):
      media: dt-bindings: Add bindings for panasonic,amg88xx
      media: video-i2c: add video-i2c driver

 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt |  19 ++
 MAINTAINERS                                                       |   6 +
 drivers/media/i2c/Kconfig                                         |  13 +
 drivers/media/i2c/Makefile                                        |   1 +
 drivers/media/i2c/video-i2c.c                                     | 564 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/usb/usbtv/usbtv-video.c                             | 115 +++++++--
 drivers/media/usb/usbtv/usbtv.h                                   |   2 +-
 drivers/staging/media/tegra-vde/tegra-vde.c                       |  63 ++---
 8 files changed, 737 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt
 create mode 100644 drivers/media/i2c/video-i2c.c
