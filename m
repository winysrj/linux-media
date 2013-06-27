Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4833 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3F0Gzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 02:55:51 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5R6tmaH077059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 08:55:50 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 8D53335E019D
	for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 08:55:46 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11]
Date: Thu, 27 Jun 2013 08:55:49 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306270855.49444.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Same as my previous git pull message, but with more cleanup patches and
fixes from Prabhakar.)

Some async/OF work from Prabhakar (the correct version this time) and
assorted improvements and fixes for compiler warnings.

Also some fixes for some fallout from the new requirement that v4l2_dev
must be set when registering a device node. I missed two cases: the wl128x
never had a v4l2_device and it never set the old parent pointer, and the case
where a v4l2_device was created, but it was never set in video_device (and
neither was the old parent pointer).

I've tested the wl128x since it turns out that it tries to load itself on a
regular PC that does not have this chipset. Dubious behavior in any case, but
useful now because it made it easy to test this patch.

Regards,

        Hans

The following changes since commit ee17608d6aa04a86e253a9130d6c6d00892f132b:

  [media] imx074: support asynchronous probing (2013-06-21 16:36:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to 7a95f9fbecf8eb65678cb945f0bc3564018e1950:

  media: davinci: vpif: display: add V4L2-async support (2013-06-27 08:48:38 +0200)

----------------------------------------------------------------
Emil Goode (1):
      saa7134: Fix sparse warnings by adding __user annotation

Hans Verkuil (7):
      ml86v7667: fix compiler warning
      bfin_capture: fix compiler warning
      omap_vout: fix compiler warning
      v4l2-controls.h: fix copy-and-paste error in comment
      saa7164: fix compiler warning
      wl128x: add missing struct v4l2_device.
      mem2mem: set missing v4l2_dev pointer

Lad, Prabhakar (9):
      media: i2c: ths8200: support asynchronous probing
      media: i2c: ths8200: add OF support
      media: i2c: adv7343: add support for asynchronous probing
      media: i2c: tvp7002: add support for asynchronous probing
      media: i2c: tvp7002: remove manual setting of subdev name
      media: i2c: tvp514x: remove manual setting of subdev name
      media: i2c: tvp514x: add support for asynchronous probing
      media: davinci: vpif: capture: add V4L2-async support
      media: davinci: vpif: display: add V4L2-async support

Lars-Peter Clausen (1):
      tvp514x: Fix init seqeunce

 Documentation/devicetree/bindings/media/i2c/ths8200.txt |  19 +++++++
 drivers/media/i2c/adv7343.c                             |  15 ++++--
 drivers/media/i2c/ml86v7667.c                           |   2 +-
 drivers/media/i2c/ths8200.c                             |  18 ++++++-
 drivers/media/i2c/tvp514x.c                             |  31 ++++++-----
 drivers/media/i2c/tvp7002.c                             |   7 ++-
 drivers/media/pci/saa7134/saa7134-video.c               |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c                |   3 +-
 drivers/media/platform/blackfin/bfin_capture.c          |   4 +-
 drivers/media/platform/davinci/vpif_capture.c           | 151 +++++++++++++++++++++++++++++++++++-----------------
 drivers/media/platform/davinci/vpif_capture.h           |   2 +
 drivers/media/platform/davinci/vpif_display.c           | 210 ++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 drivers/media/platform/davinci/vpif_display.h           |   3 +-
 drivers/media/platform/m2m-deinterlace.c                |   1 +
 drivers/media/platform/mem2mem_testdev.c                |   3 +-
 drivers/media/platform/mx2_emmaprp.c                    |   1 +
 drivers/media/platform/omap/omap_vout.c                 |   3 +-
 drivers/media/radio/wl128x/fmdrv.h                      |   2 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c                 |   8 +++
 include/media/davinci/vpif_types.h                      |   4 ++
 include/uapi/linux/v4l2-controls.h                      |   4 +-
 21 files changed, 335 insertions(+), 158 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ths8200.txt
