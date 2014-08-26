Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 00/35] Enable compilation test for several drivers
Date: Tue, 26 Aug 2014 18:54:36 -0300
Message-Id: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several platform drivers that compile on x86.
Let them to be compiled, if COMPILE_TEST is enabled. This
helped to identify several issues on those drivers.

Also, by doing that, Coverity and other static source code
analyzers can help to identify other issues on those drivers.

I moved the patches that enables the build to the end, in order
to avoid having lots of report from kbuildtest about
potential breakages and/or warnings.

Mauro Carvalho Chehab (35):
  [media] vpif_display: get rid of some unused vars
  [media] vpif_capture: get rid of some unused vars
  [media] dm644x_ccdc: declare some functions as static
  [media] dm355_ccdc: declare a function as static
  [media] gsc-core: Remove useless test
  [media] gsc-m2m: Remove an unused var.
  [media] ti-vpe: use %pad for dma address
  [media] ti-vpe: shut up a casting warning message
  [media] atmel-isi: tag dma_addr_t as such
  [media] atmel-isi: Fix a truncate warning
  [media] s5p_mfc: don't use an external symbol called 'debug'
  [media] vpif: don't cast pointers to int
  [media] dm644x_ccdc: use unsigned long for fpc_table_addr
  [media] dvb_frontend: estimate bandwidth also for DVB-S/S2/Turbo
  [media] gsc: Use %pad for dma_addr_t
  [media] omap: fix compilation if !VIDEO_OMAP2_VOUT_VRFB
  [media] omap_vout: Get rid of a few warnings
  [media] s5p-jpeg: get rid of some warnings
  [media] g2d: remove unused var
  [media] fimc-is-param: get rid of warnings
  [media] s5p_mfc_ctrl: add missing s5p_mfc_ctrl.h header
  [media] s5p_mfc: get rid of several warnings
  [media] mipi-csis: get rid of a warning
  [media] exynos4-is/media-dev: get rid of a warning for a dead code
  [media] mx2_camera: get rid of a warning
  [media] atmel-isi: get rid of a warning
  [media] s5p-jpeg: Get rid of a warning
  Revert "[media] staging: omap4iss: copy paste error in iss_get_clocks"
  [media] enable COMPILE_TEST for MX2 eMMa-PrP driver
  [media] enable COMPILE_TEST for ti-vbe
  [media] allow COMPILE_TEST for SAMSUNG_EXYNOS4_IS
  [media] enable COMPILE_TEST for OMAP2 vout
  [media] enable COMPILE_TEST for media drivers
  [media] be sure that HAS_DMA is enabled for vb2-dma-contig
  [media] omap: be sure that MMU is there for COMPILE_TEST

 drivers/media/dvb-core/dvb_frontend.c              | 17 ++++++++++
 drivers/media/pci/solo6x10/Kconfig                 |  1 +
 drivers/media/pci/sta2x11/Kconfig                  |  1 +
 drivers/media/platform/Kconfig                     | 39 +++++++++++++++++-----
 drivers/media/platform/Makefile                    |  2 +-
 drivers/media/platform/blackfin/Kconfig            |  1 +
 drivers/media/platform/davinci/Kconfig             | 18 +++++++---
 drivers/media/platform/davinci/dm355_ccdc.c        |  2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       | 14 ++++----
 drivers/media/platform/davinci/vpfe_capture.c      |  2 +-
 drivers/media/platform/davinci/vpif_capture.c      |  6 +---
 drivers/media/platform/davinci/vpif_display.c      | 14 +++-----
 drivers/media/platform/exynos-gsc/gsc-core.c       |  6 ++--
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  3 --
 drivers/media/platform/exynos-gsc/gsc-regs.c       |  8 ++---
 drivers/media/platform/exynos4-is/Kconfig          |  5 ++-
 drivers/media/platform/exynos4-is/fimc-is-errno.c  |  4 +--
 drivers/media/platform/exynos4-is/fimc-is-errno.h  |  4 +--
 drivers/media/platform/exynos4-is/fimc-is-param.c  |  2 --
 drivers/media/platform/exynos4-is/media-dev.c      |  4 ++-
 drivers/media/platform/exynos4-is/mipi-csis.c      |  3 +-
 drivers/media/platform/marvell-ccic/Kconfig        |  2 ++
 drivers/media/platform/mx2_emmaprp.c               |  2 +-
 drivers/media/platform/omap/Kconfig                |  2 +-
 drivers/media/platform/omap/omap_vout.c            |  8 ++---
 drivers/media/platform/omap/omap_vout_vrfb.h       | 18 +++++-----
 drivers/media/platform/s5p-g2d/g2d.c               |  7 ++--
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  2 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |  2 ++
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c      |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  6 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h     |  6 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  4 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  7 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |  2 --
 drivers/media/platform/s5p-tv/Kconfig              |  4 ++-
 drivers/media/platform/soc_camera/Kconfig          | 16 +++++++--
 drivers/media/platform/soc_camera/atmel-isi.c      | 13 ++++----
 drivers/media/platform/soc_camera/mx2_camera.c     |  3 +-
 drivers/media/platform/ti-vpe/vpdma.c              |  4 +--
 drivers/media/platform/ti-vpe/vpe.c                |  1 +
 drivers/media/rc/Kconfig                           |  5 +--
 drivers/staging/media/davinci_vpfe/Kconfig         |  1 +
 drivers/staging/media/dt3155v4l/Kconfig            |  1 +
 drivers/staging/media/omap4iss/Kconfig             |  1 +
 drivers/staging/media/omap4iss/iss.c               |  1 -
 include/media/davinci/dm644x_ccdc.h                |  2 +-
 50 files changed, 166 insertions(+), 115 deletions(-)

-- 
1.9.3

