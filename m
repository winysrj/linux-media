Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44347 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729439AbeJAWF2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 18:05:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id 63-v6so7180905wra.11
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 08:27:08 -0700 (PDT)
From: Maxime Jourdan <mjourdan@baylibre.com>
To: linux-firmware@kernel.org
Cc: Maxime Jourdan <mjourdan@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
Subject: [linux-firmware] [GIT PULL] amlogic: add video decoder firmwares
Date: Mon,  1 Oct 2018 17:26:49 +0200
Message-Id: <20181001152649.15975-1-mjourdan@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Below is a pull request to add the firmwares required by the Amlogic video
decoder.

The firmwares were dumped from GPLv2+ in-kernel source files from Amlogic's
vendor kernel, in their buildroot package
"buildroot_openlinux_kernel_4.9_wayland_20180316"

You can find an example of such a file in an older kernel here:
https://github.com/hardkernel/linux/blob/odroidc2-3.14.y/drivers/amlogic/amports/arch/ucode/mpeg12/vmpeg12_mc.c

The corresponding driver is currently being upstreamed:
https://lore.kernel.org/patchwork/cover/993093/

Regards,
Maxime

The following changes since commit 7c81f23ad903f72e87e2102d8f52408305c0f7a2:

  ti-connectivity: add firmware for CC2560(A) Bluetooth (2018-10-01 10:08:30 -0400)

are available in the Git repository at:

  https://github.com/Elyotna/linux-firmware.git 

for you to fetch changes up to b99cf8dcfb6e7a3dd00bdb6aa4f6c71cb6b42e58:

  amlogic: add video decoder firmwares (2018-10-01 17:06:18 +0200)

----------------------------------------------------------------
Maxime Jourdan (1):
      amlogic: add video decoder firmwares

 WHENCE                  |  16 ++++++++++++++++
 amlogic/gx/h263_mc      | Bin 0 -> 16384 bytes
 amlogic/gx/vh265_mc     | Bin 0 -> 16384 bytes
 amlogic/gx/vh265_mc_mmu | Bin 0 -> 16384 bytes
 amlogic/gx/vmjpeg_mc    | Bin 0 -> 16384 bytes
 amlogic/gx/vmpeg12_mc   | Bin 0 -> 16384 bytes
 amlogic/gx/vmpeg4_mc_5  | Bin 0 -> 16384 bytes
 amlogic/gxbb/vh264_mc   | Bin 0 -> 36864 bytes
 amlogic/gxl/vh264_mc    | Bin 0 -> 36864 bytes
 amlogic/gxm/vh264_mc    | Bin 0 -> 36864 bytes
 10 files changed, 16 insertions(+)
 create mode 100644 amlogic/gx/h263_mc
 create mode 100644 amlogic/gx/vh265_mc
 create mode 100644 amlogic/gx/vh265_mc_mmu
 create mode 100644 amlogic/gx/vmjpeg_mc
 create mode 100644 amlogic/gx/vmpeg12_mc
 create mode 100644 amlogic/gx/vmpeg4_mc_5
 create mode 100644 amlogic/gxbb/vh264_mc
 create mode 100644 amlogic/gxl/vh264_mc
 create mode 100644 amlogic/gxm/vh264_mc
