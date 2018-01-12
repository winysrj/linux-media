Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49234 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933947AbeALPjt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 10:39:49 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.16] Various fixes
Message-ID: <9c8d9e7e-ee61-4c12-e045-b82cff165514@xs4all.nl>
Date: Fri, 12 Jan 2018 16:39:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some fixes for 4.16. Note the cec-gpio.txt patch: that has a CC to stable for
4.15. It's probably too late to get that in for 4.15 itself, but it definitely
should be backported to 4.15. Otherwise you can fry your Rpi if you aren't aware
of the voltages involved.

Regards,

	Hans

The following changes since commit e3ee691dbf24096ea51b3200946b11d68ce75361:

  media: ov5640: add support of RGB565 and YUYV formats (2018-01-05 12:54:14 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.16f

for you to fetch changes up to 2b7d6056e7f0e235bc6abe70acf52afdb3a02448:

  drivers/media/common/videobuf2: rename from videobuf (2018-01-12 16:33:34 +0100)

----------------------------------------------------------------
Arnd Bergmann (2):
      media: staging: tegra-vde: select DMA_SHARED_BUFFER
      media: cobalt: select CONFIG_SND_PCM

Hans Verkuil (2):
      dt-bindings/media/cec-gpio.txt: mention the CEC/HPD max voltages
      drivers/media/common/videobuf2: rename from videobuf

 Documentation/devicetree/bindings/media/cec-gpio.txt                | 6 +++++-
 drivers/media/common/Kconfig                                        | 2 +-
 drivers/media/common/Makefile                                       | 2 +-
 drivers/media/common/{videobuf => videobuf2}/Kconfig                | 0
 drivers/media/common/{videobuf => videobuf2}/Makefile               | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-core.c       | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-dma-contig.c | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-dma-sg.c     | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-dvb.c        | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-memops.c     | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-v4l2.c       | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-vmalloc.c    | 0
 drivers/media/pci/cobalt/Kconfig                                    | 1 +
 drivers/staging/media/tegra-vde/Kconfig                             | 1 +
 14 files changed, 9 insertions(+), 3 deletions(-)
 rename drivers/media/common/{videobuf => videobuf2}/Kconfig (100%)
 rename drivers/media/common/{videobuf => videobuf2}/Makefile (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-core.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-dma-contig.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-dma-sg.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-dvb.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-memops.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-v4l2.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-vmalloc.c (100%)
