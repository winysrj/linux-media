Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:47463 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757469AbcGKFOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 01:14:34 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 021B0180144
	for <linux-media@vger.kernel.org>; Mon, 11 Jul 2016 07:14:28 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Various fixes
Message-ID: <902805c9-3715-5747-3391-8358ef6961fc@xs4all.nl>
Date: Mon, 11 Jul 2016 07:14:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a4d020e97d8e65d57061677c15c89e99609d0b37:

  [media] Convert Wideview WT220 DVB USB driver to rc-core (2016-07-09 12:10:33 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8i

for you to fetch changes up to 2c8a580725db08a7639f449a43b05328810c7bcb:

  cx23885: Add support for Hauppauge WinTV quadHD DVB version (2016-07-11 07:09:05 +0200)

----------------------------------------------------------------
Andrey Utkin (1):
      media: solo6x10: increase FRAME_BUF_SIZE

Fengguang Wu (1):
      mtk-vcodec: fix platform_no_drv_owner.cocci warnings

Hans Verkuil (10):
      vivid: set V4L2_CAP_TIMEPERFRAME
      af9033: fix compiler warnings
      adv7511: drop adv7511_set_IT_content_AVI_InfoFrame
      adv7511: fix quantization range handling
      adv7604/adv7842: fix quantization range handling
      ezkit/cobalt: drop unused op_656_range setting
      adv7604/adv7842: drop unused op_656_range and alt_data_sat fields.
      v4l2-ioctl: zero the v4l2_bt_timings reserved field
      adv7511: the h/vsync polarities were always positive
      cec: add check if adapter is unregistered.

Matthew Leach (1):
      media: usbtv: prevent access to free'd resources

Stephen Backway (1):
      cx23885: Add support for Hauppauge WinTV quadHD DVB version

Tiffany Lin (1):
      mtk-vcodec: fix sparse warning

 Documentation/video4linux/CARDLIST.cx23885             |   1 +
 arch/blackfin/mach-bf609/boards/ezkit.c                |   2 -
 drivers/media/dvb-frontends/af9033.c                   |   4 +-
 drivers/media/i2c/adv7511.c                            |  44 +++++++++-----------
 drivers/media/i2c/adv7604.c                            |  27 +++++++-----
 drivers/media/i2c/adv7842.c                            |  26 ++++++++----
 drivers/media/pci/cobalt/cobalt-driver.c               |   2 -
 drivers/media/pci/cx23885/cx23885-cards.c              |  59 ++++++++++++++++++++------
 drivers/media/pci/cx23885/cx23885-dvb.c                | 100 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/pci/cx23885/cx23885.h                    |   1 +
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c         |   2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |   1 -
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c   |   7 +++-
 drivers/media/platform/vivid/vivid-vid-cap.c           |   1 +
 drivers/media/usb/usbtv/usbtv-audio.c                  |   5 +++
 drivers/media/v4l2-core/v4l2-ioctl.c                   |   4 +-
 drivers/staging/media/cec/cec-adap.c                   |   5 ++-
 include/media/i2c/adv7604.h                            |   2 -
 include/media/i2c/adv7842.h                            |   2 -
 19 files changed, 220 insertions(+), 75 deletions(-)
