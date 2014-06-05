Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:59785 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaFEMu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 08:50:27 -0400
Date: Thu, 05 Jun 2014 09:50:20 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.16-rc1] add DT support for vsp1
Message-id: <20140605095020.2cc862a2.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/vsp1

for Device Tree support for the VSP1 driver.

Thanks!
Mauro

-

The following changes since commit ce9c22443e77594531be84ba8d523f4148ba09fe:

  [media] vb2: fix compiler warning (2014-04-23 10:13:57 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/vsp1

for you to fetch changes up to 0b82fb95d9edf7bdfc6486c67a42dbf9b1e97765:

  [media] v4l: vsp1: Add DT support (2014-04-23 10:21:58 -0300)

----------------------------------------------------------------
Laurent Pinchart (6):
      [media] v4l: vsp1: Remove unexisting rt clocks
      [media] v4l: vsp1: uds: Enable scaling of alpha layer
      [media] v4l: vsp1: Support multi-input entities
      [media] v4l: vsp1: Add BRU support
      [media] v4l: vsp1: Add DT bindings documentation
      [media] v4l: vsp1: Add DT support

 .../devicetree/bindings/media/renesas,vsp1.txt     |  43 +++
 drivers/media/platform/vsp1/Makefile               |   2 +-
 drivers/media/platform/vsp1/vsp1.h                 |   3 +-
 drivers/media/platform/vsp1/vsp1_bru.c             | 395 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_bru.h             |  39 ++
 drivers/media/platform/vsp1/vsp1_drv.c             | 101 +++---
 drivers/media/platform/vsp1/vsp1_entity.c          |  57 +--
 drivers/media/platform/vsp1/vsp1_entity.h          |  24 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |   7 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |   1 -
 drivers/media/platform/vsp1/vsp1_lut.c             |   1 -
 drivers/media/platform/vsp1/vsp1_regs.h            |  98 +++++
 drivers/media/platform/vsp1/vsp1_rpf.c             |   7 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   4 +
 drivers/media/platform/vsp1/vsp1_sru.c             |   1 -
 drivers/media/platform/vsp1/vsp1_uds.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  26 +-
 drivers/media/platform/vsp1/vsp1_video.h           |   1 +
 drivers/media/platform/vsp1/vsp1_wpf.c             |  13 +-
 19 files changed, 733 insertions(+), 94 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,vsp1.txt
 create mode 100644 drivers/media/platform/vsp1/vsp1_bru.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_bru.h

