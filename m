Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcGRSar (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/18] Complete moving media documentation to ReST format
Date: Mon, 18 Jul 2016 15:30:22 -0300
Message-Id: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series finally ends the conversion of the media documents to ReST
format.

After this series, *all* media documentation will be inside a ReST book.

They'll be:

- Linux Media Infrastructure userspace API 
  - With 5 parts:
    - Video for Linux API
    - Digital TV API
    - Remote Controller API
    - Media Controller API
    - CEC API
-  Media subsystem kernel internal API
-  Linux Digital TV driver-specific documentation
- Video4Linux (V4L) driver-specific documentation

All those documents are built automatically, once by day, at linuxtv.org:

uAPI:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/media_uapi.html

kAPI:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/media_kapi.html

DVB drivers:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/dvb-drivers/index.html

V4L drivers:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/v4l-drivers/index.html

That's said, there are lots of old/deprecated information there. Also, as the books
are actually an aggregation of stuff written on different times, by different people,
they don't look all the same.

I tried to fix some things while doing the documentation patch series, but there are
still lots of things to be done, specially at the DVB and V4L drivers documentation.

There are also several V4L2 core functions not documented at the kAPI book, and
the V4L framework document there is not properly cross referenced.

Anyway, now that everything can be seen on 4 books via html, maybe it will now
be easier to identify and fix the gaps. I intend do do it for Kernel 4.9.

I'm merging all stuff on my main development tree:
	https://git.linuxtv.org//mchehab/experimental.git/log/?h=docs-next

I should be merge soon today what we currently have at media mainstream tree.

Regards,
Mauro

Mauro Carvalho Chehab (18):
  [media] doc-rst: move bttv documentation to bttv.rst file
  [media] doc-rst: add documentation for bttv driver
  [media] doc-rst: add documentation for tuners
  [media] doc-rst: start adding documentation for cx2341x
  [media] cx2341x.rst: add fw-decoder-registers.txt content
  [media] cx2341x.rst: Add the contents of fw-encoder-api.txt
  [media] cx2341x.rst: add the contents of fw-calling.txt
  [media] cx2341x.rst: add contents of fw-dma.txt
  [media] cx2341x.rst: add contents of fw-memory.txt
  [media] cx2341x.rst: add the contents of fw-upload.txt
  [media] cx2341x.rst: add contents of fw-osd-api.txt
  [media] cx2341x: add contents of README.hm12
  [media] cx2341x.rst: add contents of README.vbi
  [media] cx88.rst: add contents from not-in-cx2388x-datasheet.txt
  [media] cx88.rst: add contents of hauppauge-wintv-cx88-ir.txt
  [media] get rid of Documentation/video4linux/lifeview.txt
  [media] doc-rst: fix media kAPI documentation
  [media] doc-rst: better name the media books

 Documentation/index.rst                            |    2 +-
 Documentation/media/dvb-drivers/index.rst          |    9 +-
 Documentation/media/kapi/dtv-core.rst              |    4 -
 Documentation/media/kapi/mc-core.rst               |    8 -
 Documentation/media/kapi/rc-core.rst               |    3 +-
 Documentation/media/kapi/v4l2-core.rst             |   21 -
 .../media/{media_drivers.rst => media_kapi.rst}    |    9 +-
 Documentation/media/media_uapi.rst                 |   10 +-
 Documentation/media/v4l-drivers/bttv.rst           | 1923 ++++++++++
 Documentation/media/v4l-drivers/cx2341x.rst        | 3858 ++++++++++++++++++++
 Documentation/media/v4l-drivers/cx88.rst           |  104 +
 Documentation/media/v4l-drivers/index.rst          |   11 +-
 Documentation/media/v4l-drivers/saa7134.rst        |   36 +
 Documentation/media/v4l-drivers/tuners.rst         |  131 +
 Documentation/video4linux/bttv/CONTRIBUTORS        |   25 -
 Documentation/video4linux/bttv/Cards               |  960 -----
 Documentation/video4linux/bttv/ICs                 |   37 -
 Documentation/video4linux/bttv/Insmod-options      |  172 -
 Documentation/video4linux/bttv/MAKEDEV             |   27 -
 Documentation/video4linux/bttv/Modprobe.conf       |   11 -
 Documentation/video4linux/bttv/Modules.conf        |   14 -
 Documentation/video4linux/bttv/PROBLEMS            |   62 -
 Documentation/video4linux/bttv/README              |   90 -
 Documentation/video4linux/bttv/README.WINVIEW      |   33 -
 Documentation/video4linux/bttv/README.freeze       |   74 -
 Documentation/video4linux/bttv/README.quirks       |   83 -
 Documentation/video4linux/bttv/Sound-FAQ           |  148 -
 Documentation/video4linux/bttv/Specs               |    3 -
 Documentation/video4linux/bttv/THANKS              |   24 -
 Documentation/video4linux/bttv/Tuners              |  115 -
 Documentation/video4linux/cx2341x/README.hm12      |  120 -
 Documentation/video4linux/cx2341x/README.vbi       |   45 -
 Documentation/video4linux/cx2341x/fw-calling.txt   |   69 -
 .../video4linux/cx2341x/fw-decoder-api.txt         |  297 --
 .../video4linux/cx2341x/fw-decoder-regs.txt        |  817 -----
 Documentation/video4linux/cx2341x/fw-dma.txt       |   96 -
 .../video4linux/cx2341x/fw-encoder-api.txt         |  709 ----
 Documentation/video4linux/cx2341x/fw-memory.txt    |  139 -
 Documentation/video4linux/cx2341x/fw-osd-api.txt   |  350 --
 Documentation/video4linux/cx2341x/fw-upload.txt    |   49 -
 .../video4linux/cx88/hauppauge-wintv-cx88-ir.txt   |   54 -
 .../video4linux/hauppauge-wintv-cx88-ir.txt        |   54 -
 Documentation/video4linux/lifeview.txt             |   42 -
 .../video4linux/not-in-cx2388x-datasheet.txt       |   41 -
 44 files changed, 6079 insertions(+), 4810 deletions(-)
 rename Documentation/media/{media_drivers.rst => media_kapi.rst} (76%)
 create mode 100644 Documentation/media/v4l-drivers/bttv.rst
 create mode 100644 Documentation/media/v4l-drivers/cx2341x.rst
 create mode 100644 Documentation/media/v4l-drivers/tuners.rst
 delete mode 100644 Documentation/video4linux/bttv/CONTRIBUTORS
 delete mode 100644 Documentation/video4linux/bttv/Cards
 delete mode 100644 Documentation/video4linux/bttv/ICs
 delete mode 100644 Documentation/video4linux/bttv/Insmod-options
 delete mode 100644 Documentation/video4linux/bttv/MAKEDEV
 delete mode 100644 Documentation/video4linux/bttv/Modprobe.conf
 delete mode 100644 Documentation/video4linux/bttv/Modules.conf
 delete mode 100644 Documentation/video4linux/bttv/PROBLEMS
 delete mode 100644 Documentation/video4linux/bttv/README
 delete mode 100644 Documentation/video4linux/bttv/README.WINVIEW
 delete mode 100644 Documentation/video4linux/bttv/README.freeze
 delete mode 100644 Documentation/video4linux/bttv/README.quirks
 delete mode 100644 Documentation/video4linux/bttv/Sound-FAQ
 delete mode 100644 Documentation/video4linux/bttv/Specs
 delete mode 100644 Documentation/video4linux/bttv/THANKS
 delete mode 100644 Documentation/video4linux/bttv/Tuners
 delete mode 100644 Documentation/video4linux/cx2341x/README.hm12
 delete mode 100644 Documentation/video4linux/cx2341x/README.vbi
 delete mode 100644 Documentation/video4linux/cx2341x/fw-calling.txt
 delete mode 100644 Documentation/video4linux/cx2341x/fw-decoder-api.txt
 delete mode 100644 Documentation/video4linux/cx2341x/fw-decoder-regs.txt
 delete mode 100644 Documentation/video4linux/cx2341x/fw-dma.txt
 delete mode 100644 Documentation/video4linux/cx2341x/fw-encoder-api.txt
 delete mode 100644 Documentation/video4linux/cx2341x/fw-memory.txt
 delete mode 100644 Documentation/video4linux/cx2341x/fw-osd-api.txt
 delete mode 100644 Documentation/video4linux/cx2341x/fw-upload.txt
 delete mode 100644 Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
 delete mode 100644 Documentation/video4linux/hauppauge-wintv-cx88-ir.txt
 delete mode 100644 Documentation/video4linux/lifeview.txt
 delete mode 100644 Documentation/video4linux/not-in-cx2388x-datasheet.txt

-- 
2.7.4


