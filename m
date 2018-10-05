Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:35901 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727750AbeJEPcC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 11:32:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Add Rockchip VPU JPEG encoder
Message-ID: <12e4b124-7a0c-aa0a-40f4-f6fcd0dfb19e@xs4all.nl>
Date: Fri, 5 Oct 2018 10:34:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the Rockchip VPU JPEG encoder staging driver.

Note: this goes on top of the request_api branch!

It does not use the request API as such, but it would otherwise conflict
with that series, so it is easier to just base it on top of the request_api
branch.

You will get a linker warning about a missing sunxi_sram_release symbol. That is
resolved by this patch:

https://lkml.org/lkml/2018/9/9/113

Which will go into 4.20 through another subsystem.

Regards,

	Hans

The following changes since commit 50e761516f2b8c0cdeb31a8c6ca1b4ef98cd13f1:

  media: platform: Add Cedrus VPU decoder driver (2018-09-24 10:47:10 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-rkjpeg

for you to fetch changes up to 8241137a4f3fb2c83a212887862c38f309736e82:

  media: add Rockchip VPU JPEG encoder driver (2018-10-05 10:28:55 +0200)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Ezequiel Garcia (2):
      dt-bindings: Document the Rockchip VPU bindings
      media: add Rockchip VPU JPEG encoder driver

Shunqian Zheng (2):
      media: Add JPEG_RAW format
      media: Add controls for JPEG quantization tables

 Documentation/devicetree/bindings/media/rockchip-vpu.txt    |  29 +++
 Documentation/media/uapi/v4l/extended-controls.rst          |  25 ++
 Documentation/media/uapi/v4l/pixfmt-compressed.rst          |   9 +
 Documentation/media/videodev2.h.rst.exceptions              |   1 +
 MAINTAINERS                                                 |   7 +
 drivers/media/v4l2-core/v4l2-ctrls.c                        |   8 +
 drivers/media/v4l2-core/v4l2-ioctl.c                        |   1 +
 drivers/staging/media/Kconfig                               |   2 +
 drivers/staging/media/Makefile                              |   1 +
 drivers/staging/media/rockchip/vpu/Kconfig                  |  12 +
 drivers/staging/media/rockchip/vpu/Makefile                 |   9 +
 drivers/staging/media/rockchip/vpu/TODO                     |   9 +
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c          | 125 ++++++++++
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 127 +++++++++++
 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h        | 442 ++++++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c          | 125 ++++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 155 +++++++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h        | 600 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu.h           | 278 +++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h    |  31 +++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c       | 527 ++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c       | 606 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h        |  65 ++++++
 include/uapi/linux/v4l2-controls.h                          |  10 +
 include/uapi/linux/videodev2.h                              |   2 +
 25 files changed, 3206 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
 create mode 100644 drivers/staging/media/rockchip/vpu/Kconfig
 create mode 100644 drivers/staging/media/rockchip/vpu/Makefile
 create mode 100644 drivers/staging/media/rockchip/vpu/TODO
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
