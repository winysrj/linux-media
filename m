Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:35896 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752570AbeCZIeP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 04:34:15 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Final set of fixes for 4.17
Message-ID: <f5143b5d-75e4-fc51-20a2-46550376331b@xs4all.nl>
Date: Mon, 26 Mar 2018 10:34:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various code and documentation fixes.

Regards,

	Hans

The following changes since commit 6ccd228e0cfce2a4f44558422d25c60fcb1a6710:

  media: fimc-capture: get rid of two warnings (2018-03-23 08:56:36 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.17f

for you to fetch changes up to 68bb14ace62cda3634ae51cb7a4995bbcd91a639:

  media: imx-media-csi: Do not propagate the error when pinctrl is not found (2018-03-26 10:21:56 +0200)

----------------------------------------------------------------
Alexandre Courbot (1):
      venus: vdec: fix format enumeration

Arnd Bergmann (1):
      media: imx: work around false-positive warning

Colin Ian King (1):
      staging: media: davinci_vpfe: fix spelling of resizer_configure_in_continious_mode

Fabio Estevam (1):
      media: imx-media-csi: Do not propagate the error when pinctrl is not found

Hans Verkuil (5):
      v4l2-tpg-core.c: add space after %
      pixfmt-v4l2-mplane.rst: fix types
      pixfmt-v4l2.rst: fix types
      media-ioc-g-topology.rst: fix 'reserved' sizes
      media-types.rst: rename media-entity-type to media-entity-functions

Jasmin Jessich (1):
      media: cec-pin: Fixed ktime_t to ns conversion

Luca Ceresoli (1):
      media: doc: fix ReST link syntax

Ryder Lee (1):
      vcodec: fix error return value from mtk_jpeg_clk_init()

 Documentation/media/kapi/v4l2-dev.rst                         |  2 +-
 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst |  2 +-
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    |  8 ++++----
 Documentation/media/uapi/mediactl/media-types.rst             |  4 ++--
 Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst           | 36 ++++++++++++++++++++++++------------
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst                  | 36 ++++++++++++++++++++++++------------
 drivers/media/cec/cec-pin.c                                   |  6 +++---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c                 |  2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c               |  4 ++--
 drivers/media/platform/qcom/venus/vdec.c                      | 13 +++++++------
 drivers/media/platform/qcom/venus/venc.c                      | 13 +++++++------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c            |  4 ++--
 drivers/staging/media/imx/imx-media-csi.c                     |  7 +++++--
 13 files changed, 83 insertions(+), 54 deletions(-)
