Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54947 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393741AbeKWTY1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 14:24:27 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21 v2] Various fixes/improvements
Message-ID: <387d3330-5b15-d7a6-dacb-5b0cbf33446e@xs4all.nl>
Date: Fri, 23 Nov 2018 09:41:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 5200ab6a32d6055428896a49ec9e3b1652c1a100:

  media: vidioc_cropcap -> vidioc_g_pixelaspect (2018-11-20 13:57:21 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20d3

for you to fetch changes up to d5d871b0c676aed893d928a2ad3ac69c55f1da8c:

  media: vicodec: Add support for 4 planes formats (2018-11-23 09:37:43 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Akinobu Mita (5):
      media: video-i2c: avoid accessing released memory area when removing driver
      media: video-i2c: use i2c regmap
      media: v4l2-common: add V4L2_FRACT_COMPARE
      media: vivid: use V4L2_FRACT_COMPARE
      media: video-i2c: support changing frame interval

Alexey Khoroshilov (1):
      media: mtk-vcodec: Release device nodes in mtk_vcodec_init_enc_pm()

Dafna Hirschfeld (3):
      media: vicodec: prepare support for various number of planes
      media: vicodec: Add support of greyscale format
      media: vicodec: Add support for 4 planes formats

Eric Biggers (1):
      media: v4l: constify v4l2_ioctls[]

Hans Verkuil (2):
      vim2m/vicodec: set device_caps in video_device struct
      vidioc-enum-fmt.rst: update list of valid buftypes

Julia Lawall (1):
      media: video-i2c: hwmon: constify vb2_ops structure

Malathi Gottam (1):
      media: venus: change the default value of GOP size

 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst      |   8 ++-
 drivers/media/i2c/video-i2c.c                         | 153 +++++++++++++++++++++++++++++++++++--------------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c |  10 ++--
 drivers/media/platform/qcom/venus/venc_ctrls.c        |   2 +-
 drivers/media/platform/vicodec/codec-fwht.c           |  84 +++++++++++++++++----------
 drivers/media/platform/vicodec/codec-fwht.h           |  15 +++--
 drivers/media/platform/vicodec/codec-v4l2-fwht.c      | 123 +++++++++++++++++++++++++++++----------
 drivers/media/platform/vicodec/codec-v4l2-fwht.h      |   3 +-
 drivers/media/platform/vicodec/vicodec-core.c         |  45 +++++++++++----
 drivers/media/platform/vim2m.c                        |   3 +-
 drivers/media/platform/vivid/vivid-vid-cap.c          |   9 +--
 drivers/media/v4l2-core/v4l2-ioctl.c                  |   2 +-
 include/media/v4l2-common.h                           |   5 ++
 13 files changed, 328 insertions(+), 134 deletions(-)
