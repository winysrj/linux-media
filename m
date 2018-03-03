Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63605 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbeCCKsn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 05:48:43 -0500
Date: Sat, 3 Mar 2018 07:48:36 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.16-rc4] media fixes
Message-ID: <20180303074836.3af9d4bd@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.16-3

For:
  - some build fixes with randconfigs;
  - a fix at m88ds3103 to prevent an OOPS if the chip doesn't provide
    a right version during probe (with can happen if the hardware hangs);
  - a potential risk at tvp5150 to go out of an array;
  - Some fixed and improvements at the DVB memory mapped API (added for Kernel 4.16).

Thanks!
Mauro


The following changes since commit 91ab883eb21325ad80f3473633f794c78ac87f51:

  Linux 4.16-rc2 (2018-02-18 17:29:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.16-3

for you to fetch changes up to 7dbdd16a79a9d27d7dca0a49029fc8966dcfecc5:

  media: vb2: Makefile: place vb2-trace together with vb2-core (2018-02-26 11:39:04 -0500)

----------------------------------------------------------------
media fixes for v4.16-rc4

----------------------------------------------------------------
Arnd Bergmann (3):
      media: dvb: fix DVB_MMAP symbol name
      media: dvb: fix DVB_MMAP dependency
      media: au0828: add VIDEO_V4L2 dependency

Mauro Carvalho Chehab (8):
      media: videobuf2: fix build issues with vb2-trace
      media: m88ds3103: don't call a non-initalized function
      media: dmxdev: fix error code for invalid ioctls
      media: dmxdev: Fix the logic that enables DMA mmap support
      media: dvb: add continuity error indicators for memory mapped buffers
      media: dvb: update buffer mmaped flags and frame counter
      media: Don't let tvp5150_get_vbi() go out of vbi_ram_default array
      media: vb2: Makefile: place vb2-trace together with vb2-core

Sakari Ailus (1):
      media: videobuf2: Add VIDEOBUF2_V4L2 Kconfig option for VB2 V4L2 part

 Documentation/media/dmx.h.rst.exceptions           |  14 ++-
 Documentation/media/uapi/dvb/dmx-qbuf.rst          |   7 +-
 drivers/media/Kconfig                              |   2 +
 drivers/media/common/videobuf2/Kconfig             |   3 +
 drivers/media/common/videobuf2/Makefile            |   9 +-
 .../{v4l2-core => common/videobuf2}/vb2-trace.c    |   0
 drivers/media/dvb-core/Makefile                    |   2 +-
 drivers/media/dvb-core/dmxdev.c                    | 115 ++++++++++++---------
 drivers/media/dvb-core/dvb_demux.c                 | 112 +++++++++++++-------
 drivers/media/dvb-core/dvb_net.c                   |   5 +-
 drivers/media/dvb-core/dvb_vb2.c                   |  31 ++++--
 drivers/media/dvb-frontends/m88ds3103.c            |   7 +-
 drivers/media/i2c/tvp5150.c                        |  88 ++++++++--------
 drivers/media/pci/ttpci/av7110.c                   |   5 +-
 drivers/media/pci/ttpci/av7110_av.c                |   6 +-
 drivers/media/usb/au0828/Kconfig                   |   2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |  10 +-
 drivers/media/v4l2-core/Kconfig                    |   1 +
 drivers/media/v4l2-core/Makefile                   |   3 +-
 include/media/demux.h                              |  21 +++-
 include/media/dmxdev.h                             |   2 +
 include/media/dvb_demux.h                          |   4 +
 include/media/dvb_vb2.h                            |  20 +++-
 include/uapi/linux/dvb/dmx.h                       |  35 +++++++
 24 files changed, 329 insertions(+), 175 deletions(-)
 rename drivers/media/{v4l2-core => common/videobuf2}/vb2-trace.c (100%)
