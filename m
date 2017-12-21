Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57316 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751655AbdLUQSR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:17 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-fsdevel@vger.kernel.org,
        devendra sharma <devendra.sharma9091@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Inki Dae <inki.dae@samsung.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
Subject: [PATCH 00/11] dvb: add support for memory mapped I/O
Date: Thu, 21 Dec 2017 14:17:59 -0200
Message-Id: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is based on a work made by Samsung in 2015 meant
to add memory-mapped I/O to the Linux media, in order to improve
performance. The preparation patches were merged on that time, but
we didn't have time to test and finish the final patch.

Fortunately, Satendra helped us doing such port. On my tests, even
on USB drivers, where we need to do DMA at URB buffers, the
performance gains seem considerable.

On the tests I did today, with perf stat, the gains were expressive:

	- the number of task clocks reduced by 3,5 times;
	- the number of context switches reduced by about 4,5 times;
	- the number of CPU cycles reduced by almost 3,5 times;
	- the number of executed instructions reduced almost 2 times;
	- the number of cache references reduced by almost 8 times;
	- the number of cache misses reduced more than 4,5 times.

The patches are at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=dvb_mmap

An userspace test patchset is at:
	https://git.linuxtv.org/mchehab/experimental-v4l-utils.git/log/?h=dvb_mmap

More details about my tests can be found on my comments to the
original Satendra's patch:

	https://patchwork.linuxtv.org/patch/46101/

Mauro Carvalho Chehab (9):
  media: vb2-core: add pr_fmt() macro
  media: vb2-core: add a new warning about pending buffers
  media: dvb_vb2: fix a warning about streamoff logic
  media: move videobuf2 to drivers/media/common
  media: dvb uAPI docs: document demux mmap/munmap syscalls
  media: dvb uAPI docs: document mmap-related ioctls
  media: dvb-core: get rid of mmap reserved field
  fs: compat_ioctl: add new DVB demux ioctls
  media: dvb_vb2: add SPDX headers

Satendra Singh Thakur (2):
  media: vb2-core: Fix a bug about unnecessary calls to queue cancel and
    free
  media: videobuf2: Add new uAPI for DVB streaming I/O

 Documentation/media/uapi/dvb/dmx-expbuf.rst        |  88 +++++
 Documentation/media/uapi/dvb/dmx-mmap.rst          | 116 ++++++
 Documentation/media/uapi/dvb/dmx-munmap.rst        |  54 +++
 Documentation/media/uapi/dvb/dmx-qbuf.rst          |  83 ++++
 Documentation/media/uapi/dvb/dmx-querybuf.rst      |  63 +++
 Documentation/media/uapi/dvb/dmx-reqbufs.rst       |  74 ++++
 Documentation/media/uapi/dvb/dmx_fcalls.rst        |   6 +
 drivers/media/common/Kconfig                       |   1 +
 drivers/media/common/Makefile                      |   2 +-
 drivers/media/common/videobuf/Kconfig              |  31 ++
 drivers/media/common/videobuf/Makefile             |   7 +
 .../videobuf}/videobuf2-core.c                     |  38 +-
 .../videobuf}/videobuf2-dma-contig.c               |   0
 .../videobuf}/videobuf2-dma-sg.c                   |   0
 .../{v4l2-core => common/videobuf}/videobuf2-dvb.c |   0
 .../videobuf}/videobuf2-memops.c                   |   0
 .../videobuf}/videobuf2-v4l2.c                     |   0
 .../videobuf}/videobuf2-vmalloc.c                  |   0
 drivers/media/dvb-core/Makefile                    |   2 +-
 drivers/media/dvb-core/dmxdev.c                    | 196 ++++++++--
 drivers/media/dvb-core/dmxdev.h                    |   4 +
 drivers/media/dvb-core/dvb_vb2.c                   | 430 +++++++++++++++++++++
 drivers/media/dvb-core/dvb_vb2.h                   |  74 ++++
 drivers/media/v4l2-core/Kconfig                    |  32 --
 drivers/media/v4l2-core/Makefile                   |   7 -
 fs/compat_ioctl.c                                  |   5 +
 include/uapi/linux/dvb/dmx.h                       |  63 ++-
 27 files changed, 1290 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/media/uapi/dvb/dmx-expbuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-mmap.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-munmap.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-qbuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-querybuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-reqbufs.rst
 create mode 100644 drivers/media/common/videobuf/Kconfig
 create mode 100644 drivers/media/common/videobuf/Makefile
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-core.c (98%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-dma-contig.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-dma-sg.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-dvb.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-memops.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-v4l2.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf}/videobuf2-vmalloc.c (100%)
 create mode 100644 drivers/media/dvb-core/dvb_vb2.c
 create mode 100644 drivers/media/dvb-core/dvb_vb2.h

-- 
2.14.3
