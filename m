Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:33061 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbcCULl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 07:41:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Krzysztof Halasa <khalasa@piap.pl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 0/4] tw686x drivers
Date: Mon, 21 Mar 2016 12:41:17 +0100
Message-Id: <1458560481-16200-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Even though the two tw686x drivers have been posted before I thought I'd
post them again before I make a pull request due to the fact that I had
to make a few changes to the staging driver and because of the unusual
circumstances.

Krzysztof, I renamed the driver (and sources) to tw686x-kh to prevent
conflicts with the name of Ezequiel's driver.

I also prevent it from being built if VIDEO_TW686X is already selected
so we don't install two drivers for the same hardware.

I also added two patches: the first adds the GFP_DMA32 flag to ensure
the DMA buffers are in 32 bit memory (you probably never tested it on
a 64 bit system). The second mentions adds audio support to the TODO list.

For those who haven't paid attention:

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

If there are no comments, then I'll make a pull request, probably next
week.

Regards,

	Hans

Ezequiel Garcia (1):
  media: Support Intersil/Techwell TW686x-based video capture cards

Hans Verkuil (2):
  tw686x-kh: specify that the DMA is 32 bits
  tw686x-kh: add audio support to the TODO list

Krzysztof Hałasa (1):
  TW686x frame grabber driver

 MAINTAINERS                                       |   8 +
 drivers/media/pci/Kconfig                         |   1 +
 drivers/media/pci/Makefile                        |   1 +
 drivers/media/pci/tw686x/Kconfig                  |  18 +
 drivers/media/pci/tw686x/Makefile                 |   3 +
 drivers/media/pci/tw686x/tw686x-audio.c           | 386 +++++++++
 drivers/media/pci/tw686x/tw686x-core.c            | 415 ++++++++++
 drivers/media/pci/tw686x/tw686x-regs.h            | 122 +++
 drivers/media/pci/tw686x/tw686x-video.c           | 927 ++++++++++++++++++++++
 drivers/media/pci/tw686x/tw686x.h                 | 158 ++++
 drivers/staging/media/Kconfig                     |   2 +
 drivers/staging/media/Makefile                    |   1 +
 drivers/staging/media/tw686x-kh/Kconfig           |  17 +
 drivers/staging/media/tw686x-kh/Makefile          |   3 +
 drivers/staging/media/tw686x-kh/TODO              |   6 +
 drivers/staging/media/tw686x-kh/tw686x-kh-core.c  | 140 ++++
 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h  | 103 +++
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c | 821 +++++++++++++++++++
 drivers/staging/media/tw686x-kh/tw686x-kh.h       | 118 +++
 19 files changed, 3250 insertions(+)
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

-- 
2.7.0

