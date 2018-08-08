Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:4065 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbeHHHn1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 03:43:27 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH v2 0/7] add UniPhier DVB Frontend system support
Date: Wed,  8 Aug 2018 14:25:12 +0900
Message-Id: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for DVB Frontend system named HSC support
for UniPhier LD11/LD20 SoCs. This driver supports MPEG2-TS serial
signal input from external demodulator and DMA MPEG2-TS stream data
onto memory.

UniPhier HSC driver provides many ports of TS input. Since the HSC
has mixed register map for those ports. It hard to split each register
areas.

---

Changes from v1:
  DT bindings
    - Fix mistakes of spelling
    - Rename uniphier,hsc.txt -> socionext,uniphier-hsc.txt
  Kconfig, Makefile
    - Add COMPILE_TEST, REGMAP_MMIO
    - Add $(srctree) to include path option
  Headers
    - Split large patch
    - Remove more unused definitions
    - Remove unneeded const
    - Replace enum that has special value into #define
    - Remove weird macro from register definitions
    - Remove field_get/prop inline functions
  Modules
    - Split register definitions, function prototypes
    - Fix include lines
    - Fix depended config
    - Remove redundant conditions
    - Drop adapter patches, and need no patches to build
    - Merge uniphier-adapter.o into each adapter drivers
    - Split 3 modules (core, ld11, ld20) to build adapter drivers as
      module
    - Fix compile error if build as module
    - Use hardware spec table to remove weird macro from register
      definitions
    - Use usleep_range instead of msleep
    - Use shift and mask instead of field_get/prop inline functions

Katsuhiro Suzuki (7):
  media: uniphier: add DT bindings documentation for UniPhier HSC
  media: uniphier: add DMA common file of HSC
  media: uniphier: add CSS common file of HSC
  media: uniphier: add TS common file of HSC
  media: uniphier: add ucode load common file of HSC
  media: uniphier: add platform driver module of HSC
  media: uniphier: add LD11/LD20 HSC support

 .../bindings/media/socionext,uniphier-hsc.txt |  38 ++
 drivers/media/platform/Kconfig                |   1 +
 drivers/media/platform/Makefile               |   2 +
 drivers/media/platform/uniphier/Kconfig       |  19 +
 drivers/media/platform/uniphier/Makefile      |   5 +
 drivers/media/platform/uniphier/hsc-core.c    | 515 ++++++++++++++++++
 drivers/media/platform/uniphier/hsc-css.c     | 250 +++++++++
 drivers/media/platform/uniphier/hsc-dma.c     | 212 +++++++
 drivers/media/platform/uniphier/hsc-ld11.c    | 273 ++++++++++
 drivers/media/platform/uniphier/hsc-reg.h     | 272 +++++++++
 drivers/media/platform/uniphier/hsc-ts.c      | 127 +++++
 drivers/media/platform/uniphier/hsc-ucode.c   | 416 ++++++++++++++
 drivers/media/platform/uniphier/hsc.h         | 389 +++++++++++++
 13 files changed, 2519 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/socionext,uniphier-hsc.txt
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

-- 
2.18.0
