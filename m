Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37685 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932575AbcIEOeF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 10:34:05 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id 75EB41858C8
        for <linux-media@vger.kernel.org>; Mon,  5 Sep 2016 16:34:01 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Various fixes
Message-ID: <857b705b-740b-bb3c-7c5a-baeed4cfb5f8@xs4all.nl>
Date: Mon, 5 Sep 2016 16:34:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit fb6609280db902bd5d34445fba1c926e95e63914:

  [media] dvb_frontend: Use memdup_user() rather than duplicating its implementation (2016-08-24 17:20:45 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.9c

for you to fetch changes up to fb1f780359fcf558a4c2a41f29aef52b96ade94a:

  cobalt: update EDID (2016-09-05 16:30:39 +0200)

----------------------------------------------------------------
Andrey Utkin (1):
      tw5864-core: remove excessive irqsave

Ezequiel Garcia (1):
      media: tw686x: Support frame sizes and frame intervals enumeration

Hans Verkuil (3):
      Revert "[media] tw5864: remove double irq lock code"
      vivid: update EDID
      cobalt: update EDID

Johan Fjeldtvedt (5):
      cec: allow configuration both from within driver and from user space
      pulse8-cec: serialize communication with adapter
      pulse8-cec: add notes about behavior in autonomous mode
      pulse8-cec: sync configuration with adapter
      pulse8-cec: fixes

Markus Elfring (2):
      media/i2c: Delete owner assignment
      radio-si470x-i2c: Delete owner assignment

Songjun Wu (1):
      atmel-isc: remove the warning

Tiffany Lin (1):
      vcodec: mediatek: Add g/s_selection support for V4L2 Encoder

 drivers/media/i2c/ad9389b.c                        |   1 -
 drivers/media/i2c/adv7183.c                        |   1 -
 drivers/media/i2c/adv7393.c                        |   1 -
 drivers/media/i2c/cs3308.c                         |   1 -
 drivers/media/i2c/s5k4ecgx.c                       |   1 -
 drivers/media/i2c/s5k6a3.c                         |   1 -
 drivers/media/i2c/ths8200.c                        |   1 -
 drivers/media/i2c/tlv320aic23b.c                   |   1 -
 drivers/media/i2c/tvp514x.c                        |   1 -
 drivers/media/i2c/tvp7002.c                        |   1 -
 drivers/media/i2c/vs6624.c                         |   1 -
 drivers/media/pci/cobalt/cobalt-driver.c           |  47 +++----
 drivers/media/pci/tw5864/tw5864-core.c             |   2 +
 drivers/media/pci/tw686x/tw686x-video.c            |  38 +++++
 drivers/media/platform/atmel/atmel-isc.c           |   2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |  66 +++++++++
 drivers/media/platform/vivid/vivid-core.c          |  58 ++++----
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   1 -
 drivers/staging/media/cec/cec-adap.c               |   4 -
 drivers/staging/media/pulse8-cec/pulse8-cec.c      | 366 ++++++++++++++++++++++++++++++++++++++-----------
 20 files changed, 449 insertions(+), 146 deletions(-)
