Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36303 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753312AbcIOKjH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 06:39:07 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
        by tschai.lan (Postfix) with ESMTPSA id F1DF418021F
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 12:39:01 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Various fixes, enhancements
Message-ID: <80d4dfb3-a513-62da-690a-0b370c9a2d2d@xs4all.nl>
Date: Thu, 15 Sep 2016 12:39:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.9e

for you to fetch changes up to 1f2f86f0e97a2afcbaf5400de40ef225e8e47a42:

  vivid: fix error return code in vivid_create_instance() (2016-09-15 11:36:30 +0200)

----------------------------------------------------------------
Andrey Utkin (2):
      tw5864: constify vb2_ops structure
      tw5864: constify struct video_device template

Arnd Bergmann (1):
      pulse8-cec: avoid uninitialized data use

Colin Ian King (1):
      pxa_camera: fix spelling mistake: "dequeud" -> "dequeued"

Hans Verkuil (1):
      v4l-drivers/fourcc.rst: fix typo

Jean Delvare (1):
      cec: fix Kconfig help text

Johan Fjeldtvedt (1):
      pulse8-cec: store logical address mask

Songjun Wu (1):
      atmel-isc: set the format on the first open

Tiffany Lin (1):
      vcodec: mediatek: Add V4L2_CAP_TIMEPERFRAME capability setting

Wei Yongjun (3):
      pxa_camera: fix error return code in pxa_camera_probe()
      pxa_camera: remove duplicated include from pxa_camera.c
      vivid: fix error return code in vivid_create_instance()

 Documentation/media/v4l-drivers/fourcc.rst         |  2 +-
 drivers/media/pci/tw5864/tw5864-video.c            |  4 ++--
 drivers/media/platform/atmel/atmel-isc.c           | 30 ++++++++++++++++++------------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |  3 +++
 drivers/media/platform/pxa_camera.c                | 11 +++++++----
 drivers/media/platform/vivid/vivid-core.c          |  5 ++++-
 drivers/staging/media/cec/Kconfig                  |  3 ---
 drivers/staging/media/pulse8-cec/pulse8-cec.c      | 38 +++++++++++++++++++++++++++++++++++++-
 8 files changed, 72 insertions(+), 24 deletions(-)
