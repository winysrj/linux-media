Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56457 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452AbcGVKor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 06:44:47 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 8698A180050
	for <linux-media@vger.kernel.org>; Fri, 22 Jul 2016 12:44:41 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] (v3) Various fixes/cleanups
Message-ID: <bd5d0f94-7f79-a040-5c1a-71357e5f9cc7@xs4all.nl>
Date: Fri, 22 Jul 2016 12:44:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Another bunch of bug fixes and small cleanups for 4.8.

The vb2 fix is particularly nasty, the others are all pretty trivial.

Regards,

	Hans

New for v3: added patch "cec: fix off-by-one memset"
New for v2: added patch "staging: add MEDIA_SUPPORT dependency"


The following changes since commit 009a620848218d521f008141c62f56bf19294dd9:

  [media] cec: always check all_device_types and features (2016-07-19 13:27:46 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8a

for you to fetch changes up to d96ab0b4929b026d040e4c01de2c5d2558722425:

  cec: fix off-by-one memset (2016-07-22 12:42:52 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      staging: add MEDIA_SUPPORT dependency

Bhaktipriya Shridhar (6):
      pvrusb2: Remove deprecated create_singlethread_workqueue
      gspca: sonixj: Remove deprecated create_singlethread_workqueue
      gspca: vicam: Remove deprecated create_singlethread_workqueue
      gspca: jl2005bcd: Remove deprecated create_singlethread_workqueue
      gspca: finepix: Remove deprecated create_singlethread_workqueue
      ad9389b: Remove deprecated create_singlethread_workqueue

Hans Verkuil (6):
      adv7511: fix VIC autodetect
      cobalt: support reduced fps
      vim2m: copy the other colorspace-related fields as well
      vivid: don't handle CEC_MSG_SET_STREAM_PATH
      airspy: fix compiler warning
      cec: fix off-by-one memset

Markus Elfring (4):
      tw686x-kh: Delete an unnecessary check before the function call "video_unregister_device"
      cec: Delete an unnecessary check before the function call "rc_free_device"
      v4l2-common: Delete an unnecessary check before the function call "spi_unregister_device"
      tw686x: Delete an unnecessary check before the function call "video_unregister_device"

Steve Longerbeam (3):
      media: adv7180: Fix broken interrupt register access
      media: adv7180: define more registers
      media: adv7180: add power pin control

Vincent Stehlé (1):
      vb2: Fix allocation size of dma_parms

 Documentation/devicetree/bindings/media/i2c/adv7180.txt |   5 +++
 drivers/media/i2c/Kconfig                               |   2 +-
 drivers/media/i2c/ad9389b.c                             |  22 +++----------
 drivers/media/i2c/adv7180.c                             | 118 +++++++++++++++++++++++++++++++++++++++++++++++-------------------
 drivers/media/i2c/adv7511.c                             |  24 +++++++++++---
 drivers/media/pci/cobalt/cobalt-v4l2.c                  |   7 ++--
 drivers/media/pci/tw686x/tw686x-video.c                 |   3 +-
 drivers/media/platform/vim2m.c                          |  15 ++++++++-
 drivers/media/platform/vivid/vivid-cec.c                |  10 ------
 drivers/media/usb/airspy/airspy.c                       |   1 -
 drivers/media/usb/gspca/finepix.c                       |   8 ++---
 drivers/media/usb/gspca/jl2005bcd.c                     |   8 ++---
 drivers/media/usb/gspca/sonixj.c                        |  13 +++-----
 drivers/media/usb/gspca/vicam.c                         |   8 ++---
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h        |   1 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                 |  23 ++++---------
 drivers/media/v4l2-core/v4l2-common.c                   |   2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c          |   2 +-
 drivers/staging/media/Kconfig                           |   2 +-
 drivers/staging/media/cec/cec-adap.c                    |   2 +-
 drivers/staging/media/cec/cec-core.c                    |   3 +-
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c       |   3 +-
 22 files changed, 158 insertions(+), 124 deletions(-)
