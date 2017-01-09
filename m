Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:38433 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760806AbdAINXi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 08:23:38 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.11] New st-delta driver
Message-ID: <b5f8fb46-6507-417c-8f1e-3b3f1410a64d@xs4all.nl>
Date: Mon, 9 Jan 2017 14:23:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

See the v4 series for details:

https://www.spinics.net/lists/linux-media/msg108737.html

Regards,

	Hans

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git delta

for you to fetch changes up to e6f199d01e7b8bc4436738b6c666fda31b9f3340:

  st-delta: debug: trace stream/frame information & summary (2017-01-09 14:16:45 +0100)

----------------------------------------------------------------
Hugues Fruchet (10):
      Documentation: DT: add bindings for ST DELTA
      ARM: dts: STiH410: add DELTA dt node
      ARM: multi_v7_defconfig: enable STMicroelectronics DELTA Support
      MAINTAINERS: add st-delta driver
      st-delta: STiH4xx multi-format video decoder v4l2 driver
      st-delta: add memory allocator helper functions
      st-delta: rpmsg ipc support
      st-delta: EOS (End Of Stream) support
      st-delta: add mjpeg support
      st-delta: debug: trace stream/frame information & summary

 Documentation/devicetree/bindings/media/st,st-delta.txt |   17 +
 MAINTAINERS                                             |    8 +
 arch/arm/boot/dts/stih410.dtsi                          |   10 +
 arch/arm/configs/multi_v7_defconfig                     |    1 +
 drivers/media/platform/Kconfig                          |   27 +
 drivers/media/platform/Makefile                         |    2 +
 drivers/media/platform/sti/delta/Makefile               |    6 +
 drivers/media/platform/sti/delta/delta-cfg.h            |   63 ++
 drivers/media/platform/sti/delta/delta-debug.c          |   72 ++
 drivers/media/platform/sti/delta/delta-debug.h          |   18 +
 drivers/media/platform/sti/delta/delta-ipc.c            |  591 +++++++++++++
 drivers/media/platform/sti/delta/delta-ipc.h            |   76 ++
 drivers/media/platform/sti/delta/delta-mem.c            |   51 ++
 drivers/media/platform/sti/delta/delta-mem.h            |   14 +
 drivers/media/platform/sti/delta/delta-mjpeg-dec.c      |  454 ++++++++++
 drivers/media/platform/sti/delta/delta-mjpeg-fw.h       |  221 +++++
 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c      |  150 ++++
 drivers/media/platform/sti/delta/delta-mjpeg.h          |   35 +
 drivers/media/platform/sti/delta/delta-v4l2.c           | 1977 +++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/sti/delta/delta.h                |  566 +++++++++++++
 20 files changed, 4359 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,st-delta.txt
 create mode 100644 drivers/media/platform/sti/delta/Makefile
 create mode 100644 drivers/media/platform/sti/delta/delta-cfg.h
 create mode 100644 drivers/media/platform/sti/delta/delta-debug.c
 create mode 100644 drivers/media/platform/sti/delta/delta-debug.h
 create mode 100644 drivers/media/platform/sti/delta/delta-ipc.c
 create mode 100644 drivers/media/platform/sti/delta/delta-ipc.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mem.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mem.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-dec.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-fw.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg.h
 create mode 100644 drivers/media/platform/sti/delta/delta-v4l2.c
 create mode 100644 drivers/media/platform/sti/delta/delta.h
