Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:33015 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387840AbeKVUSd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 15:18:33 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] Add Rockchip VPU JPEG encoder
Message-ID: <d7afaa30-6d5b-2d4f-4a84-04ad813a3280@xs4all.nl>
Date: Thu, 22 Nov 2018 10:39:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 5200ab6a32d6055428896a49ec9e3b1652c1a100:

  media: vidioc_cropcap -> vidioc_g_pixelaspect (2018-11-20 13:57:21 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-jpeg

for you to fetch changes up to cbf7592cb57ec9986c4d1becfd80b85486fd318a:

  media: add Rockchip VPU JPEG encoder driver (2018-11-22 10:12:29 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Ezequiel Garcia (1):
      media: add Rockchip VPU JPEG encoder driver

 MAINTAINERS                                                 |   7 +
 drivers/staging/media/Kconfig                               |   2 +
 drivers/staging/media/Makefile                              |   1 +
 drivers/staging/media/rockchip/vpu/Kconfig                  |  13 +
 drivers/staging/media/rockchip/vpu/Makefile                 |  10 +
 drivers/staging/media/rockchip/vpu/TODO                     |   6 +
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c          | 118 ++++++++
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 133 ++++++++
 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h        | 442 +++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c          | 118 ++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 160 ++++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h        | 600 ++++++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu.h           | 237 +++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h    |  29 ++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c       | 535 +++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c       | 702 +++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h        |  58 ++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c      | 290 ++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h      |  14 +
 19 files changed, 3475 insertions(+)
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
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
