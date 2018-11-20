Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51108 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbeKTVcZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 16:32:25 -0500
Date: Tue, 20 Nov 2018 09:03:44 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.20-rc4] media fixes
Message-ID: <20181120090344.6ba64433@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-3

For a series of fixes:
  - add a missing include at v4l2-controls uAPI header;
  - minor kAPI update for the request API;
  - some fixes at CEC core;
  - use a lower minimum height for the virtual codec driver;
  - cleanup a gcc warning due to the lack of a fall though markup;
  - tc358743: Remove unnecessary self assignment
  - fix the V4L event subscription logic
  - docs: Document metadata format in struct v4l2_format
  - omap3isp and ipu3-cio2: fix unbinding logic

PS.: I was meant to send this two weeks ago, but LPC/KS trip ended by
delaying this pull request.

Regards,
Mauro

-

The following changes since commit 651022382c7f8da46cb4872a545ee1da6d097d2a:

  Linux 4.20-rc1 (2018-11-04 15:37:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-3

for you to fetch changes up to 4e26f692e2e2aa4d7d6ddb3c4d3dec17f45d6495:

  media: ipu3-cio2: Use cio2_queues_exit (2018-11-06 07:11:59 -0500)

----------------------------------------------------------------
media fixes for v4.20-rc4

----------------------------------------------------------------
Arnd Bergmann (1):
      media: v4l: fix uapi mpeg slice params definition

Ezequiel Garcia (1):
      media: Rename vb2_m2m_request_queue -> v4l2_m2m_request_queue

Hans Verkuil (3):
      media: vicodec: lower minimum height to 360
      media: cec: check for non-OK/NACK conditions while claiming a LA
      media: cec: increase debug level for 'queue full'

Mauro Carvalho Chehab (3):
      v4l2-controls: add a missing include
      Merge tag 'v4.20-rc1' into patchwork
      media: dm365_ipipeif: better annotate a fall though

Nathan Chancellor (1):
      media: tc358743: Remove unnecessary self assignment

Sakari Ailus (5):
      media: v4l: event: Add subscription to list before calling "add" operation
      media: docs: Document metadata format in struct v4l2_format
      media: omap3isp: Unregister media device as first
      media: ipu3-cio2: Unregister device nodes first, then release resources
      media: ipu3-cio2: Use cio2_queues_exit

 Documentation/media/uapi/v4l/dev-meta.rst          |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |  5 +++
 drivers/media/cec/cec-adap.c                       | 49 +++++++++++++++++-----
 drivers/media/i2c/tc358743.c                       |  1 -
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |  6 +--
 drivers/media/platform/omap3isp/isp.c              |  3 +-
 drivers/media/platform/vicodec/vicodec-core.c      |  2 +-
 drivers/media/platform/vim2m.c                     |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  5 +++
 drivers/media/v4l2-core/v4l2-event.c               | 43 ++++++++++---------
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  4 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  1 +
 drivers/staging/media/sunxi/cedrus/cedrus.c        |  2 +-
 include/media/v4l2-mem2mem.h                       |  2 +-
 include/uapi/linux/v4l2-controls.h                 |  5 +++
 15 files changed, 89 insertions(+), 43 deletions(-)
