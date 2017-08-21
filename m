Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57458 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753021AbdHULuF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 07:50:05 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] More constify & venus fixes
Message-ID: <337ca7e4-995c-9829-192e-c073123e1dd3@xs4all.nl>
Date: Mon, 21 Aug 2017 13:50:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14j

for you to fetch changes up to b7573e3c684cb552cfbc86712279c131a691acef:

  media: venus: venc: drop VP9 codec support (2017-08-21 13:43:07 +0200)

----------------------------------------------------------------
Arvind Yadav (6):
      ad9389b: constify i2c_device_id
      adv7511: constify i2c_device_id
      adv7842: constify i2c_device_id
      saa7127: constify i2c_device_id
      tc358743: constify i2c_device_id
      ths8200: constify i2c_device_id

Bhumika Goyal (5):
      usb: make i2c_algorithm const
      i2c: make device_type const
      media: pci: make i2c_adapter const
      radio-usb-si4713: make i2c_adapter const
      usb: make i2c_adapter const

Stanimir Varbanov (5):
      media: venus: mark venc and vdec PM functions as __maybe_unused
      media: venus: fill missing video_device name
      media: venus: add helper to check supported codecs
      media: venus: use helper function to check supported codecs
      media: venus: venc: drop VP9 codec support

 drivers/media/i2c/ad9389b.c                       |  2 +-
 drivers/media/i2c/adv7511.c                       |  2 +-
 drivers/media/i2c/adv7842.c                       |  2 +-
 drivers/media/i2c/saa7127.c                       |  2 +-
 drivers/media/i2c/soc_camera/mt9t031.c            |  2 +-
 drivers/media/i2c/tc358743.c                      |  2 +-
 drivers/media/i2c/ths8200.c                       |  2 +-
 drivers/media/pci/cobalt/cobalt-i2c.c             |  2 +-
 drivers/media/pci/cx18/cx18-i2c.c                 |  2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c           |  2 +-
 drivers/media/pci/cx25821/cx25821-i2c.c           |  2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                 |  4 ++--
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c |  2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c           |  2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c           |  2 +-
 drivers/media/platform/qcom/venus/helpers.c       | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h       |  1 +
 drivers/media/platform/qcom/venus/vdec.c          | 31 ++++++++++++++++++++-----------
 drivers/media/platform/qcom/venus/venc.c          | 39 ++++++++++++++++++++++-----------------
 drivers/media/radio/si4713/radio-usb-si4713.c     |  2 +-
 drivers/media/usb/au0828/au0828-i2c.c             |  4 ++--
 drivers/media/usb/cx231xx/cx231xx-i2c.c           |  2 +-
 drivers/media/usb/em28xx/em28xx-i2c.c             |  2 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c               |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c      |  4 ++--
 drivers/media/usb/stk1160/stk1160-i2c.c           |  2 +-
 drivers/media/usb/usbvision/usbvision-i2c.c       |  4 ++--
 27 files changed, 119 insertions(+), 55 deletions(-)
