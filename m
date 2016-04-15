Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33448 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbcDOJpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 05:45:06 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id F3907180436
	for <linux-media@vger.kernel.org>; Fri, 15 Apr 2016 11:44:59 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Add tw686x drivers
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <5710B81B.7040303@xs4all.nl>
Date: Fri, 15 Apr 2016 11:44:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request adds two tw686x drivers, one in mainline, one in staging.

We've ended up with two drivers: one only supports V4L2_FIELD_SEQ_BT,
FIELD_TOP and FIELD_BOTTOM interlaced modes and no audio, the other only
supports FIELD_INTERLACED by way of a memcpy and has audio support.

Part of the reason is weird hardware design that has different DMA modes
depending on the field settings. Krzysztof didn't need FIELD_INTERLACED,
so he never implemented that, and unfortunately when Ezequiel took his
code as starting point he only implemented the FIELD_INTERLACED format.
The memcpy was needed due to unstable DMA when using the DMA mode that
can do FIELD_INTERLACED. It is not known at this time if that unstable
behavior is specific to the hardware Ezequiel is using or if it is
inherent to the tw686x.

In the ideal world both feature sets should be merged into one driver.

But for now I decided to add Ezequiel's driver to the mainline and
Krzysztof's driver to staging. The reason for moving Ezequiel's driver
to mainline is that application support for FIELD_INTERLACED is standard,
whereas FIELD_TOP/BOTTOM/SEQ_BT is pretty rare. In addition, Ezequiel's
driver has audio support.

My hope is that someone will merge the feature sets and we can get rid
of one of the two drivers.

I have tested both drivers with this card:

http://www.nanzoom.com/product/nz-2108E.shtml

(available on ebay)

Update: Ezequiel has started work to add the missing features to his
driver, so hopefully we'll be able to drop the staging driver in the near
future.li

Regards,

	Hans


The following changes since commit ecb7b0183a89613c154d1bea48b494907efbf8f9:

  [media] m88ds3103: fix undefined division (2016-04-13 19:17:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tw686x

for you to fetch changes up to 21f8b7cd5a825ed04ca9ffafbbf0c474f156cca2:

  tw686x: Specify that the DMA is 32 bits (2016-04-15 11:35:21 +0200)

----------------------------------------------------------------
Ezequiel Garcia (2):
      media: Support Intersil/Techwell TW686x-based video capture cards
      tw686x: Specify that the DMA is 32 bits

Hans Verkuil (4):
      tw686x-kh: specify that the DMA is 32 bits
      tw686x-kh: add audio support to the TODO list
      tw686x: add missing statics
      tw686x-kh: rename three functions to prevent clash with tw686x driver

Krzysztof Hałasa (1):
      TW686x frame grabber driver

 MAINTAINERS                                       |   8 +
 drivers/media/pci/Kconfig                         |   1 +
 drivers/media/pci/Makefile                        |   1 +
 drivers/media/pci/tw686x/Kconfig                  |  18 +
 drivers/media/pci/tw686x/Makefile                 |   3 +
 drivers/media/pci/tw686x/tw686x-audio.c           | 386 +++++++++++++++++++++
 drivers/media/pci/tw686x/tw686x-core.c            | 415 ++++++++++++++++++++++
 drivers/media/pci/tw686x/tw686x-regs.h            | 122 +++++++
 drivers/media/pci/tw686x/tw686x-video.c           | 928 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/tw686x/tw686x.h                 | 158 +++++++++
 drivers/staging/media/Kconfig                     |   2 +
 drivers/staging/media/Makefile                    |   1 +
 drivers/staging/media/tw686x-kh/Kconfig           |  17 +
 drivers/staging/media/tw686x-kh/Makefile          |   3 +
 drivers/staging/media/tw686x-kh/TODO              |   6 +
 drivers/staging/media/tw686x-kh/tw686x-kh-core.c  | 140 ++++++++
 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h  | 103 ++++++
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c | 821 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/tw686x-kh/tw686x-kh.h       | 118 +++++++
 19 files changed, 3251 insertions(+)
 create mode 100644 drivers/media/pci/tw686x/Kconfig
 create mode 100644 drivers/media/pci/tw686x/Makefile
 create mode 100644 drivers/media/pci/tw686x/tw686x-audio.c
 create mode 100644 drivers/media/pci/tw686x/tw686x-core.c
 create mode 100644 drivers/media/pci/tw686x/tw686x-regs.h
 create mode 100644 drivers/media/pci/tw686x/tw686x-video.c
 create mode 100644 drivers/media/pci/tw686x/tw686x.h
 create mode 100644 drivers/staging/media/tw686x-kh/Kconfig
 create mode 100644 drivers/staging/media/tw686x-kh/Makefile
 create mode 100644 drivers/staging/media/tw686x-kh/TODO
 create mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-core.c
 create mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h
 create mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-video.c
 create mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh.h

