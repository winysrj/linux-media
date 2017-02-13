Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:60194 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751604AbdBMKwM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 05:52:12 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.11] MediaTek JPEG encoder
Message-ID: <0e07065d-9e0a-6ce7-9b39-197b04f4f67c@xs4all.nl>
Date: Mon, 13 Feb 2017 11:52:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This adds the MediaTek JPEG encoder to the media subsystem.

This patch https://patchwork.linuxtv.org/patch/38645/ needs to go through
Matthias Brugger, so you need to coordinate with him for which kernel this
driver will be merged. This pull request is for 4.11, but since it is so
late in the cycle I can understand if this slips to 4.12.

In any case, this should be coordinated.

Regards,

	Hans

The following changes since commit 9eeb0ed0f30938f31a3d9135a88b9502192c18dd:

  [media] mtk-vcodec: fix build warnings without DEBUG (2017-02-08 12:08:20 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.11e

for you to fetch changes up to 0f492f30d15aec43248fbdd4d6ceea8f495f4457:

  vcodec: mediatek: Add Maintainers entry for Mediatek JPEG driver (2017-02-13 11:35:29 +0100)

----------------------------------------------------------------
Rick Chang (3):
      dt-bindings: mediatek: Add a binding for Mediatek JPEG Decoder
      vcodec: mediatek: Add Mediatek JPEG Decoder Driver
      vcodec: mediatek: Add Maintainers entry for Mediatek JPEG driver

 Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt |   37 +
 MAINTAINERS                                                       |    7 +
 drivers/media/platform/Kconfig                                    |   15 +
 drivers/media/platform/Makefile                                   |    2 +
 drivers/media/platform/mtk-jpeg/Makefile                          |    2 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c                   | 1306 +++++++++++++++++++++++++++++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h                   |  139 ++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c                     |  417 +++++++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h                     |   91 +++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c                  |  160 ++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h                  |   25 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h                    |   58 ++
 12 files changed, 2259 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
 create mode 100644 drivers/media/platform/mtk-jpeg/Makefile
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h
