Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47350 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752907AbdC0KGH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 06:06:07 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Various fixes, improvements
Message-ID: <b2fb554f-5adf-f208-b259-b767118f8844@xs4all.nl>
Date: Mon, 27 Mar 2017 12:05:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes and improvements.

Regards,

	Hans

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12d

for you to fetch changes up to 6798d00f15b0c965a1a030516c0933684d61a7bd:

  cec-core.rst: document the new cec_get_drvdata() helper (2017-03-27 11:55:58 +0200)

----------------------------------------------------------------
Anton Leontiev (1):
      vb2: Fix queue_setup() callback description

Baruch Siach (1):
      doc: kapi: fix typo

Colin Ian King (2):
      atmel-isc: fix off-by-one comparison and out of bounds read issue
      usb: au0828: remove redundant code

Geliang Tang (1):
      ivtv: use for_each_sg

Hans Verkuil (2):
      vivid: fix g_edid implementation
      cec-core.rst: document the new cec_get_drvdata() helper

Hugues Fruchet (1):
      st-delta: mjpeg: fix static checker warning

Johan Hovold (1):
      gspca: konica: add missing endpoint sanity check

Jose Abreu (8):
      cec: Add cec_get_drvdata()
      staging: st-cec: Use cec_get_drvdata()
      staging: s5p-cec: Use cec_get_drvdata()
      i2c: adv7511: Use cec_get_drvdata()
      i2c: adv7604: Use cec_get_drvdata()
      i2c: adv7842: Use cec_get_drvdata()
      usb: pulse8-cec: Use cec_get_drvdata()
      platform: vivid: Use cec_get_drvdata()

Matthias Kaehlcke (1):
      vcodec: mediatek: Remove double parentheses

Minghsiu Tsai (1):
      media: mtk-jpeg: fix continuous log "Context is NULL"

 Documentation/media/kapi/cec-core.rst                |  5 +++++
 Documentation/media/kapi/v4l2-core.rst               |  2 +-
 drivers/media/i2c/adv7511.c                          |  6 +++---
 drivers/media/i2c/adv7604.c                          |  6 +++---
 drivers/media/i2c/adv7842.c                          |  6 +++---
 drivers/media/pci/ivtv/ivtv-udma.c                   |  2 +-
 drivers/media/platform/atmel/atmel-isc.c             |  2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c      | 14 ++------------
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c |  4 ++--
 drivers/media/platform/sti/delta/delta-mjpeg-dec.c   |  2 +-
 drivers/media/platform/vivid/vivid-cec.c             |  4 ++--
 drivers/media/platform/vivid/vivid-vid-common.c      |  4 ++--
 drivers/media/usb/au0828/au0828-video.c              |  7 -------
 drivers/media/usb/gspca/konica.c                     |  3 +++
 drivers/media/usb/pulse8-cec/pulse8-cec.c            |  6 +++---
 drivers/staging/media/s5p-cec/s5p_cec.c              |  6 +++---
 drivers/staging/media/st-cec/stih-cec.c              |  6 +++---
 include/media/cec.h                                  |  5 +++++
 include/media/videobuf2-core.h                       | 12 ++++++------
 19 files changed, 49 insertions(+), 53 deletions(-)
