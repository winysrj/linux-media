Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:35838 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968694AbeE3JJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 05:09:50 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH 0/8] add UniPhier DVB Frontend system support
Date: Wed, 30 May 2018 18:09:38 +0900
Message-Id: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for DVB Frontend system named HSC support
for UniPhier LD11/LD20 SoCs. This driver supports MPEG2-TS serial
signal input from external demodulator and DMA MPEG2-TS stream data
onto memory.

UniPhier HSC driver provides many ports of TS input. Since the HSC
has mixed register map for those ports. It hard to split each register
areas.

Katsuhiro Suzuki (8):
  media: uniphier: add DT bindings documentation for UniPhier HSC
  media: uniphier: add headers of HSC MPEG2-TS I/O driver
  media: uniphier: add submodules of HSC MPEG2-TS I/O driver
  media: uniphier: add common module of HSC MPEG2-TS I/O driver
  media: uniphier: add LD11/LD20 HSC support
  media: uniphier: add common module of DVB adapter drivers
  media: uniphier: add LD11 adapter driver for ISDB
  media: uniphier: add LD20 adapter driver for ISDB

 .../bindings/media/uniphier,hsc.txt           |  38 ++
 drivers/media/platform/Kconfig                |   1 +
 drivers/media/platform/Makefile               |   2 +
 drivers/media/platform/uniphier/Kconfig       |  37 ++
 drivers/media/platform/uniphier/Makefile      |  12 +
 drivers/media/platform/uniphier/hsc-core.c    | 506 ++++++++++++++++++
 drivers/media/platform/uniphier/hsc-css.c     | 258 +++++++++
 drivers/media/platform/uniphier/hsc-dma.c     | 302 +++++++++++
 drivers/media/platform/uniphier/hsc-ld11.c    | 219 ++++++++
 drivers/media/platform/uniphier/hsc-reg.h     | 491 +++++++++++++++++
 drivers/media/platform/uniphier/hsc-ts.c      |  99 ++++
 drivers/media/platform/uniphier/hsc-ucode.c   | 436 +++++++++++++++
 drivers/media/platform/uniphier/hsc.h         | 480 +++++++++++++++++
 .../platform/uniphier/ld11-mn884433-helene.c  | 265 +++++++++
 .../platform/uniphier/ld20-mn884434-helene.c  | 274 ++++++++++
 .../platform/uniphier/uniphier-adapter.c      |  54 ++
 .../platform/uniphier/uniphier-adapter.h      |  42 ++
 17 files changed, 3516 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/uniphier,hsc.txt
 create mode 100644 drivers/media/platform/uniphier/Kconfig
 create mode 100644 drivers/media/platform/uniphier/Makefile
 create mode 100644 drivers/media/platform/uniphier/hsc-core.c
 create mode 100644 drivers/media/platform/uniphier/hsc-css.c
 create mode 100644 drivers/media/platform/uniphier/hsc-dma.c
 create mode 100644 drivers/media/platform/uniphier/hsc-ld11.c
 create mode 100644 drivers/media/platform/uniphier/hsc-reg.h
 create mode 100644 drivers/media/platform/uniphier/hsc-ts.c
 create mode 100644 drivers/media/platform/uniphier/hsc-ucode.c
 create mode 100644 drivers/media/platform/uniphier/hsc.h
 create mode 100644 drivers/media/platform/uniphier/ld11-mn884433-helene.c
 create mode 100644 drivers/media/platform/uniphier/ld20-mn884434-helene.c
 create mode 100644 drivers/media/platform/uniphier/uniphier-adapter.c
 create mode 100644 drivers/media/platform/uniphier/uniphier-adapter.h

-- 
2.17.0
