Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59034 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbeLCSJU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 13:09:20 -0500
Date: Mon, 3 Dec 2018 16:09:11 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.20-rc6] media fixes
Message-ID: <20181203160911.539c9dcd@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-4

For a couple of fixes:

  - Revert a dt-bindings patch whose driver didn't make for 4.20;
  - fix a kernel oops at vicodec driver;
  - fix a frame overflow at gspca with was causing regressions on some
    cameras, making them to not work;
  - use the proper type for wait_queue head;
  - make media request API compatible with 32 bits userspace on 64 bits
    Kernel;
  - fix a regression on Kernel 4.19 at dvb-pll;
  - don't use SPDX headers yet for GFDL.

Thanks!
Mauro

The following changes since commit 4e26f692e2e2aa4d7d6ddb3c4d3dec17f45d6495:

  media: ipu3-cio2: Use cio2_queues_exit (2018-11-06 07:11:59 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-4

for you to fetch changes up to a7c3a0d5f8d8cd5cdb32c06d4d68f5b4e4d2104b:

  media: mediactl docs: Fix licensing message (2018-11-27 13:52:46 -0500)

----------------------------------------------------------------
media fixes for v4.20-rc4

----------------------------------------------------------------
Ezequiel Garcia (1):
      media: Revert "media: dt-bindings: Document the Rockchip VPU bindings"

Hans Verkuil (3):
      media: cedrus: add action item to the TODO
      media: vicodec: fix memchr() kernel oops
      media: gspca: fix frame overflow error

Jasmin Jessich (1):
      media: Use wait_queue_head_t for media_request

Jernej Skrabec (1):
      media: media-request: Add compat ioctl

Mauro Carvalho Chehab (3):
      media: dvb-pll: fix tuner frequency ranges
      media: dvb-pll: don't re-validate tuner frequencies
      media: mediactl docs: Fix licensing message

 .../devicetree/bindings/media/rockchip-vpu.txt     |  29 ------
 .../uapi/mediactl/media-ioc-request-alloc.rst      |  26 ++++-
 .../uapi/mediactl/media-request-ioc-queue.rst      |  26 ++++-
 .../uapi/mediactl/media-request-ioc-reinit.rst     |  26 ++++-
 Documentation/media/uapi/mediactl/request-api.rst  |  26 ++++-
 .../media/uapi/mediactl/request-func-close.rst     |  26 ++++-
 .../media/uapi/mediactl/request-func-ioctl.rst     |  26 ++++-
 .../media/uapi/mediactl/request-func-poll.rst      |  26 ++++-
 drivers/media/dvb-frontends/dvb-pll.c              | 106 ++++++++++-----------
 drivers/media/media-request.c                      |   3 +
 drivers/media/platform/vicodec/vicodec-core.c      |   3 +-
 drivers/media/usb/gspca/gspca.c                    |  11 ++-
 drivers/staging/media/sunxi/cedrus/TODO            |   5 +
 include/media/media-request.h                      |   2 +-
 14 files changed, 240 insertions(+), 101 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
