Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47638 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751465AbdFGLQq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 07:16:46 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Alan Cox <alan@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Various fixes
Message-ID: <26c778bb-e8d8-77b7-8e26-d00d2a03a84d@xs4all.nl>
Date: Wed, 7 Jun 2017 13:16:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Another set of fixes, including all (I hope) pending atomisp-related patches.

Regards,

	Hans

The following changes since commit 6fb05e0dd32e566facb96ea61a48c7488daa5ac3:

  [media] saa7164: fix double fetch PCIe access condition (2017-06-06 16:55:50 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.13d

for you to fetch changes up to b7bbde98a91f1116e4cd95e82708623c62ea936c:

  staging: atomisp: Fix endless recursion in hmm_init (2017-06-07 13:11:14 +0200)

----------------------------------------------------------------
Alan Cox (10):
      atompisp: HAS_BL is never defined so lose it
      atomisp: remove NUM_OF_BLS
      atomisp2: remove HRT_UNSCHED
      atomisp2: tidy up confused ifdefs
      atomisp: eliminate dead code under HAS_RES_MGR
      atomisp: unify sh_css_hmm_buffer_record_acquire
      atomisp: Unify load_preview_binaries for the most part
      atomisp: Unify lut free logic
      atomisp: remove sh_css_irq - it contains nothing
      atomisp: de-duplicate sh_css_mmu_set_page_table_base_index

Chen Guanqiao (1):
      staging: atomisp: lm3554: fix sparse warnings(was not declared. Should it be static?)

Christoph Fanelsa (1):
      staging: media: cxd2099: Fix checkpatch issues

Dan Carpenter (1):
      atomisp2: off by one in atomisp_s_input()

Daniel Kurtz (1):
      media: mtk-mdp: Fix mdp device tree

Hans de Goede (8):
      staging: atomisp: Fix calling efivar_entry_get() with unaligned arguments
      staging: atomisp: Do not call dev_warn with a NULL device
      staging: atomisp: Set step to 0 for mt9m114 menu control
      staging: atomisp: Add INT0310 ACPI id to gc0310 driver
      staging: atomisp: Add OVTI2680 ACPI id to ov2680 driver
      staging: atomisp: Ignore errors from second gpio in ov2680 driver
      staging: atomisp: Make ov2680 driver less chatty
      staging: atomisp: Fix endless recursion in hmm_init

Hirokazu Honda (1):
      mtk-vcodec: Show mtk driver error without DEBUG definition

Jia-Ju Bai (2):
      ivtv: Fix a sleep-in-atomic bug in snd_ivtv_pcm_hw_free
      cx18: Fix a sleep-in-atomic bug in snd_cx18_pcm_hw_free

Juan Antonio Pedreira Martos (1):
      staging: media: atomisp: fix non static symbol warnings

Kevin Hilman (4):
      davinci: vpif_capture: drop compliance hack
      davinci: vpif_capture: get subdevs from DT when available
      davinci: vpif_capture: cleanup raw camera support
      davinci: vpif: adaptions for DT support

Minghsiu Tsai (1):
      dt-bindings: mt8173: Fix mdp device tree

Paolo Cretaro (1):
      atomisp: use NULL instead of 0 for pointers

Philipp Zabel (2):
      coda: implement forced key frames
      coda: copy headers in front of every I-frame

 Documentation/devicetree/bindings/media/mediatek-mdp.txt                 |  12 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c                                   |   4 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c                                   |   4 +-
 drivers/media/platform/coda/coda-bit.c                                   |  21 ++-
 drivers/media/platform/coda/coda-common.c                                |   3 +
 drivers/media/platform/coda/coda.h                                       |   1 +
 drivers/media/platform/davinci/vpif.c                                    |  49 +++++-
 drivers/media/platform/davinci/vpif_capture.c                            | 223 +++++++++++++++++++++++---
 drivers/media/platform/davinci/vpif_display.c                            |   5 +
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c                            |  12 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h                      |  20 ++-
 drivers/staging/media/atomisp/i2c/gc0310.c                               |   1 +
 drivers/staging/media/atomisp/i2c/lm3554.c                               |   4 +-
 drivers/staging/media/atomisp/i2c/mt9m114.c                              |   2 +-
 drivers/staging/media/atomisp/i2c/ov2680.c                               |  15 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c                        |   2 +-
 drivers/staging/media/atomisp/pci/atomisp2/Makefile                      |   1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c               |   2 +-
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c                |   4 +-
 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mmu_private.h  |   2 -
 .../media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_const.h   |  16 --
 .../media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_exprs.h   |  23 ---
 .../media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c       |  34 ----
 .../staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |   2 +-
 .../media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c  |   7 -
 .../media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c       |  10 +-
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c              | 278 ++-------------------------------
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c     |  34 +---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_internal.h     |   7 -
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_irq.c          |  16 --
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mmu.c          |   6 -
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c       |  14 --
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c                     |   8 +-
 drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c     |   4 +-
 drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c |  19 +--
 drivers/staging/media/cxd2099/cxd2099.c                                  |   6 +-
 include/media/davinci/vpif_types.h                                       |   9 +-
 37 files changed, 364 insertions(+), 516 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_irq.c
