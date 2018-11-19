Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41844 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729376AbeKTBVv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 20:21:51 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] Various fixes/improvements
Message-ID: <c3324150-61aa-67a1-3c50-00def08194de@xs4all.nl>
Date: Mon, 19 Nov 2018 15:57:57 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21d

for you to fetch changes up to b8e1d6a3dd646b57a7821a4b51796edee64787f4:

  media: vicodec: Add support for 4 planes formats (2018-11-19 15:47:22 +0100)

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
 drivers/media/platform/vicodec/vicodec-core.c         |  43 ++++++++++----
 drivers/media/platform/vim2m.c                        |   3 +-
 drivers/media/platform/vivid/vivid-vid-cap.c          |   9 +--
 drivers/media/v4l2-core/v4l2-ioctl.c                  |   2 +-
 include/media/v4l2-common.h                           |   5 ++
 13 files changed, 326 insertions(+), 134 deletions(-)
