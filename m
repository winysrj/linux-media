Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:37853 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757012AbcKCOSz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 10:18:55 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] Bug fixes and cleanups
Message-ID: <dc7970d8-10ea-ad7f-bc0b-e6b15eb69928@xs4all.nl>
Date: Thu, 3 Nov 2016 15:18:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The subject says it all...

	Hans

The following changes since commit bd676c0c04ec94bd830b9192e2c33f2c4532278d:

   [media] v4l2-flash-led-class: remove a now unused var (2016-10-24 
18:51:29 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v4.10a

for you to fetch changes up to 8039fedca469a6cd9df2298adbd8d9f5ad64aa6f:

   hdpvr: fix interrupted recording (2016-11-03 15:02:58 +0100)

----------------------------------------------------------------
Andrey Utkin (1):
       media: solo6x10: fix lockup by avoiding delayed register write

Arnd Bergmann (1):
       s5p-cec: mark PM functions as __maybe_unused again

Colin Ian King (1):
       st-hva: fix a copy-and-paste variable name error

Dan Carpenter (1):
       st-hva: fix some error handling in hva_hw_probe()

Fengguang Wu (1):
       media: fix platform_no_drv_owner.cocci warnings

Javier Martinez Canillas (5):
       v4l: vsp1: Fix module autoload for OF registration
       v4l: rcar-fcp: Fix module autoload for OF registration
       rc: meson-ir: Fix module autoload
       s5p-cec: Fix module autoload
       st-cec: Fix module autoload

Jonathan Sims (1):
       hdpvr: fix interrupted recording

Lubomir Rintel (1):
       usbtv: add video controls

Markus Elfring (38):
       dvb-tc90522: Use kmalloc_array() in tc90522_master_xfer()
       dvb-tc90522: Rename a jump label in tc90522_probe()
       cx88-dsp: Use kmalloc_array() in read_rds_samples()
       cx88-dsp: Add some spaces for better code readability
       blackfin-capture: Use kcalloc() in bcap_init_sensor_formats()
       blackfin-capture: Delete an error message for a failed memory 
allocation
       DaVinci-VPBE: Use kmalloc_array() in vpbe_initialize()
       DaVinci-VPBE: Delete two error messages for a failed memory 
allocation
       DaVinci-VPBE: Adjust 16 checks for null pointers
       DaVinci-VPBE: Return an error code only as a constant in vpbe_probe()
       DaVinci-VPBE: Return an error code only by a single variable in 
vpbe_initialize()
       DaVinci-VPBE: Delete an unnecessary variable initialisation in 
vpbe_initialize()
       DaVinci-VPBE: Return the success indication only as a constant in 
vpbe_set_mode()
       DaVinci-VPBE: Reduce the scope for a variable in 
vpbe_set_default_output()
       DaVinci-VPBE: Rename a jump label in vpbe_set_output()
       DaVinci-VPBE: Delete an unnecessary variable initialisation in 
vpbe_set_output()
       DaVinci-VPFE-Capture: Use kmalloc_array() in vpfe_probe()
       DaVinci-VPFE-Capture: Delete three error messages for a failed 
memory allocation
       DaVinci-VPFE-Capture: Improve another size determination in 
vpfe_probe()
       DaVinci-VPFE-Capture: Delete an unnecessary variable 
initialisation in vpfe_probe()
       DaVinci-VPFE-Capture: Improve another size determination in 
vpfe_open()
       DaVinci-VPFE-Capture: Adjust 13 checks for null pointers
       DaVinci-VPFE-Capture: Delete an unnecessary variable 
initialisation in 11 functions
       DaVinci-VPFE-Capture: Move two assignments in vpfe_s_input()
       DaVinci-VPFE-Capture: Delete unnecessary braces in vpfe_isr()
       DaVinci-VPFE-Capture: Delete an unnecessary return statement in 
vpfe_unregister_ccdc_device()
       DaVinci-VPIF-Capture: Use kcalloc() in vpif_probe()
       DaVinci-VPIF-Capture: Delete an error message for a failed memory 
allocation
       DaVinci-VPIF-Capture: Adjust ten checks for null pointers
       DaVinci-VPIF-Capture: Delete an unnecessary variable 
initialisation in vpif_querystd()
       DaVinci-VPIF-Capture: Delete an unnecessary variable 
initialisation in vpif_channel_isr()
       DaVinci-VPIF-Display: Use kcalloc() in vpif_probe()
       DaVinci-VPIF-Display: Delete an error message for a failed memory 
allocation
       DaVinci-VPIF-Display: Adjust 11 checks for null pointers
       DaVinci-VPIF-Display: Delete an unnecessary variable 
initialisation in vpif_channel_isr()
       DaVinci-VPIF-Display: Delete an unnecessary variable 
initialisation in process_progressive_mode()
       au0828-video: Use kcalloc() in au0828_init_isoc()
       au0828-video: Delete three error messages for a failed memory 
allocation

Masahiro Yamada (1):
       squash lines for simple wrapper functions

Masanari Iida (1):
       v4l: doc: Fix typo in vidioc-g-tuner.rst

Sakari Ailus (1):
       v4l: Document that m2m devices have a file handle specific context

Vincent Stehlé (1):
       media: mtk-mdp: NULL-terminate mtk_mdp_comp_dt_ids

Wei Yongjun (1):
       s5p-cec: remove unused including <linux/version.h>

  Documentation/media/uapi/v4l/dev-codec.rst        |  2 +-
  Documentation/media/uapi/v4l/vidioc-g-tuner.rst   |  4 +--
  drivers/media/dvb-core/dvb_frontend.c             |  8 ++---
  drivers/media/dvb-frontends/tc90522.c             |  7 ++--
  drivers/media/pci/cx88/cx88-dsp.c                 | 43 
++++++++++++------------
  drivers/media/pci/meye/meye.c                     |  5 +--
  drivers/media/pci/solo6x10/solo6x10.h             |  3 ++
  drivers/media/pci/ttpci/av7110.c                  |  4 +--
  drivers/media/platform/blackfin/bfin_capture.c    |  6 ++--
  drivers/media/platform/davinci/vpbe.c             | 69 
+++++++++++++++++---------------------
  drivers/media/platform/davinci/vpfe_capture.c     | 82 
+++++++++++++++++++++------------------------
  drivers/media/platform/davinci/vpif_capture.c     | 28 ++++++++--------
  drivers/media/platform/davinci/vpif_display.c     | 30 ++++++++---------
  drivers/media/platform/mtk-mdp/mtk_mdp_core.c     |  4 +--
  drivers/media/platform/rcar-fcp.c                 |  1 +
  drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 17 ++--------
  drivers/media/platform/sti/hva/hva-hw.c           |  8 ++---
  drivers/media/platform/ti-vpe/cal.c               |  6 +---
  drivers/media/platform/vsp1/vsp1_drv.c            |  1 +
  drivers/media/rc/fintek-cir.c                     |  6 +---
  drivers/media/rc/meson-ir.c                       |  1 +
  drivers/media/usb/au0828/au0828-video.c           | 19 +++++------
  drivers/media/usb/dvb-usb-v2/lmedm04.c            | 14 ++++----
  drivers/media/usb/dvb-usb/m920x.c                 | 10 ++----
  drivers/media/usb/gspca/jl2005bcd.c               |  5 +--
  drivers/media/usb/gspca/sq905c.c                  |  5 +--
  drivers/media/usb/hdpvr/hdpvr-video.c             | 22 +++++++++++--
  drivers/media/usb/usbtv/usbtv-video.c             | 97 
+++++++++++++++++++++++++++++++++++++++++++++++++++++-
  drivers/media/usb/usbtv/usbtv.h                   |  3 ++
  drivers/staging/media/s5p-cec/s5p_cec.c           |  6 ++--
  drivers/staging/media/st-cec/stih-cec.c           |  1 +
  include/media/v4l2-mem2mem.h                      |  3 ++
  32 files changed, 289 insertions(+), 231 deletions(-)
