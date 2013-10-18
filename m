Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14069 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3JRKqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 06:46:22 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MUV00AZ31WFYM90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Oct 2013 11:46:20 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MUV003IH1X79590@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Oct 2013 11:46:20 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.13] mem2mem patches
Date: Fri, 18 Oct 2013 12:46:19 +0200
Message-id: <000f01cecbef$47b54f50$d71fedf0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are the mem2mem patches for v3.13.

Best wishes,
Kamil Debski

The following changes since commit 4699b5f34a09e6fcc006567876b0c3d35a188c62:

  [media] cx24117: prevent mutex to be stuck on locked state if FE init
fails (2013-10-14 06:38:56 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media.git for-v3.13

for you to fetch changes up to 89ef209d3f943ab8039304f7d41de5721dd67ff5:

  s5p-mfc: remove deprecated IRQF_DISABLED (2013-10-18 10:52:42 +0200)

----------------------------------------------------------------
Archit Taneja (4):
      v4l: ti-vpe: Create a vpdma helper library
      v4l: ti-vpe: Add helpers for creating VPDMA descriptors
      v4l: ti-vpe: Add VPE mem to mem driver
      v4l: ti-vpe: Add de-interlacer support in VPE

Arun Kumar K (1):
      s5p-mfc: Adjust the default values of some encoder params

Fabio Estevam (1):
      platform: Kconfig: Select SRAM for VIDEO_CODA

Jingoo Han (3):
      s5p-g2d: Remove casting the return value which is a void pointer
      m2m-deinterlace: Remove casting the return value which is a void
pointer
      mem2mem_testdev: Remove casting the return value which is a void
pointer

Michael Opdenacker (1):
      s5p-mfc: remove deprecated IRQF_DISABLED

Philipp Zabel (12):
      v4l2-mem2mem: fix context removal from job queue in v4l2_m2m_streamoff
      v4l2-mem2mem: clear m2m queue ready counter in v4l2_m2m_streamoff
      coda: allow more than four instances on CODA7541
      coda: only set buffered input queue for decoder
      coda: add compressed flag to format enumeration output
      coda: fix FMO value setting for CodaDx6
      coda: move coda_product_name above vidioc_querycap
      coda: use picture type returned from hardware
      coda: prefix v4l2_ioctl_ops with coda_ instead of vidioc_
      coda: v4l2-compliance fix: overwrite invalid pixel formats with the
current setting
      coda: v4l2-compliance fix: implement try_decoder_cmd
      coda: v4l2-compliance fix: zero pixel format priv field

Prathyush K (1):
      s5p-mfc: call wake_up_dev if in suspend mode

Shaik Ameer Basha (2):
      exynos-gsc: Handle ctx job finish when aborted
      v4l2-mem2mem: Don't schedule the context if abort job is called

 drivers/media/platform/Kconfig               |   17 +
 drivers/media/platform/Makefile              |    2 +
 drivers/media/platform/coda.c                |  278 ++--
 drivers/media/platform/exynos-gsc/gsc-core.h |    1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |   29 +-
 drivers/media/platform/m2m-deinterlace.c     |    3 +-
 drivers/media/platform/mem2mem_testdev.c     |    3 +-
 drivers/media/platform/s5p-g2d/g2d.c         |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c     |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    8 +-
 drivers/media/platform/ti-vpe/Makefile       |    5 +
 drivers/media/platform/ti-vpe/vpdma.c        |  846 +++++++++++
 drivers/media/platform/ti-vpe/vpdma.h        |  203 +++
 drivers/media/platform/ti-vpe/vpdma_priv.h   |  641 ++++++++
 drivers/media/platform/ti-vpe/vpe.c          | 2099
++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpe_regs.h     |  496 ++++++
 drivers/media/v4l2-core/v4l2-mem2mem.c       |   16 +-
 include/uapi/linux/v4l2-controls.h           |    4 +
 18 files changed, 4531 insertions(+), 134 deletions(-)
 create mode 100644 drivers/media/platform/ti-vpe/Makefile
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
 create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h
 create mode 100644 drivers/media/platform/ti-vpe/vpe.c
 create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h

