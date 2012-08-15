Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab2HONs0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:26 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmQYe021549
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:26 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/12] [media] rename drivers/media/video to platform
Date: Wed, 15 Aug 2012 10:48:20 -0300
Message-Id: <1345038500-28734-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As now most of the drivers there are platform drivers, rename
the directory. It still makes sense to split mem2mem from
it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                                        |  2 +-
 drivers/media/Makefile                                       |  2 +-
 drivers/media/{video => platform}/Kconfig                    | 12 ++++++------
 drivers/media/{video => platform}/Makefile                   |  0
 drivers/media/{video => platform}/arv.c                      |  0
 drivers/media/{video => platform}/atmel-isi.c                |  0
 drivers/media/{video => platform}/blackfin/Kconfig           |  0
 drivers/media/{video => platform}/blackfin/Makefile          |  0
 drivers/media/{video => platform}/blackfin/bfin_capture.c    |  0
 drivers/media/{video => platform}/blackfin/ppi.c             |  0
 drivers/media/{video => platform}/coda.c                     |  0
 drivers/media/{video => platform}/coda.h                     |  2 +-
 drivers/media/{video => platform}/davinci/Kconfig            |  0
 drivers/media/{video => platform}/davinci/Makefile           |  0
 drivers/media/{video => platform}/davinci/ccdc_hw_device.h   |  0
 drivers/media/{video => platform}/davinci/dm355_ccdc.c       |  0
 drivers/media/{video => platform}/davinci/dm355_ccdc_regs.h  |  0
 drivers/media/{video => platform}/davinci/dm644x_ccdc.c      |  0
 drivers/media/{video => platform}/davinci/dm644x_ccdc_regs.h |  0
 drivers/media/{video => platform}/davinci/isif.c             |  0
 drivers/media/{video => platform}/davinci/isif_regs.h        |  0
 drivers/media/{video => platform}/davinci/vpbe.c             |  0
 drivers/media/{video => platform}/davinci/vpbe_display.c     |  0
 drivers/media/{video => platform}/davinci/vpbe_osd.c         |  0
 drivers/media/{video => platform}/davinci/vpbe_osd_regs.h    |  0
 drivers/media/{video => platform}/davinci/vpbe_venc.c        |  0
 drivers/media/{video => platform}/davinci/vpbe_venc_regs.h   |  0
 drivers/media/{video => platform}/davinci/vpfe_capture.c     |  0
 drivers/media/{video => platform}/davinci/vpif.c             |  0
 drivers/media/{video => platform}/davinci/vpif.h             |  0
 drivers/media/{video => platform}/davinci/vpif_capture.c     |  0
 drivers/media/{video => platform}/davinci/vpif_capture.h     |  0
 drivers/media/{video => platform}/davinci/vpif_display.c     |  0
 drivers/media/{video => platform}/davinci/vpif_display.h     |  0
 drivers/media/{video => platform}/davinci/vpss.c             |  0
 drivers/media/{video => platform}/fsl-viu.c                  |  0
 drivers/media/{video => platform}/indycam.c                  |  0
 drivers/media/{video => platform}/indycam.h                  |  0
 drivers/media/{video => platform}/m2m-deinterlace.c          |  0
 drivers/media/{video => platform}/marvell-ccic/Kconfig       |  0
 drivers/media/{video => platform}/marvell-ccic/Makefile      |  0
 drivers/media/{video => platform}/marvell-ccic/cafe-driver.c |  0
 drivers/media/{video => platform}/marvell-ccic/mcam-core.c   |  0
 drivers/media/{video => platform}/marvell-ccic/mcam-core.h   |  0
 drivers/media/{video => platform}/marvell-ccic/mmp-driver.c  |  0
 drivers/media/{video => platform}/mem2mem_testdev.c          |  0
 drivers/media/{video => platform}/mx1_camera.c               |  0
 drivers/media/{video => platform}/mx2_camera.c               |  0
 drivers/media/{video => platform}/mx2_emmaprp.c              |  0
 drivers/media/{video => platform}/mx3_camera.c               |  0
 drivers/media/{video => platform}/omap/Kconfig               |  0
 drivers/media/{video => platform}/omap/Makefile              |  0
 drivers/media/{video => platform}/omap/omap_vout.c           |  0
 drivers/media/{video => platform}/omap/omap_vout_vrfb.c      |  0
 drivers/media/{video => platform}/omap/omap_vout_vrfb.h      |  0
 drivers/media/{video => platform}/omap/omap_voutdef.h        |  0
 drivers/media/{video => platform}/omap/omap_voutlib.c        |  0
 drivers/media/{video => platform}/omap/omap_voutlib.h        |  0
 drivers/media/{video => platform}/omap1_camera.c             |  2 +-
 drivers/media/{video => platform}/omap24xxcam-dma.c          |  2 +-
 drivers/media/{video => platform}/omap24xxcam.c              |  2 +-
 drivers/media/{video => platform}/omap24xxcam.h              |  2 +-
 drivers/media/{video => platform}/omap3isp/Makefile          |  0
 drivers/media/{video => platform}/omap3isp/cfa_coef_table.h  |  0
 drivers/media/{video => platform}/omap3isp/gamma_table.h     |  0
 drivers/media/{video => platform}/omap3isp/isp.c             |  0
 drivers/media/{video => platform}/omap3isp/isp.h             |  0
 drivers/media/{video => platform}/omap3isp/ispccdc.c         |  0
 drivers/media/{video => platform}/omap3isp/ispccdc.h         |  0
 drivers/media/{video => platform}/omap3isp/ispccp2.c         |  0
 drivers/media/{video => platform}/omap3isp/ispccp2.h         |  0
 drivers/media/{video => platform}/omap3isp/ispcsi2.c         |  0
 drivers/media/{video => platform}/omap3isp/ispcsi2.h         |  0
 drivers/media/{video => platform}/omap3isp/ispcsiphy.c       |  0
 drivers/media/{video => platform}/omap3isp/ispcsiphy.h       |  0
 drivers/media/{video => platform}/omap3isp/isph3a.h          |  0
 drivers/media/{video => platform}/omap3isp/isph3a_aewb.c     |  0
 drivers/media/{video => platform}/omap3isp/isph3a_af.c       |  0
 drivers/media/{video => platform}/omap3isp/isphist.c         |  0
 drivers/media/{video => platform}/omap3isp/isphist.h         |  0
 drivers/media/{video => platform}/omap3isp/isppreview.c      |  0
 drivers/media/{video => platform}/omap3isp/isppreview.h      |  0
 drivers/media/{video => platform}/omap3isp/ispqueue.c        |  0
 drivers/media/{video => platform}/omap3isp/ispqueue.h        |  0
 drivers/media/{video => platform}/omap3isp/ispreg.h          |  0
 drivers/media/{video => platform}/omap3isp/ispresizer.c      |  0
 drivers/media/{video => platform}/omap3isp/ispresizer.h      |  0
 drivers/media/{video => platform}/omap3isp/ispstat.c         |  0
 drivers/media/{video => platform}/omap3isp/ispstat.h         |  0
 drivers/media/{video => platform}/omap3isp/ispvideo.c        |  0
 drivers/media/{video => platform}/omap3isp/ispvideo.h        |  0
 .../media/{video => platform}/omap3isp/luma_enhance_table.h  |  0
 .../media/{video => platform}/omap3isp/noise_filter_table.h  |  0
 drivers/media/{video => platform}/pxa_camera.c               |  0
 drivers/media/{video => platform}/s5p-fimc/Kconfig           |  0
 drivers/media/{video => platform}/s5p-fimc/Makefile          |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-capture.c    |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-core.c       |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-core.h       |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-lite-reg.c   |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-lite-reg.h   |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-lite.c       |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-lite.h       |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-m2m.c        |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-mdevice.c    |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-mdevice.h    |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-reg.c        |  0
 drivers/media/{video => platform}/s5p-fimc/fimc-reg.h        |  0
 drivers/media/{video => platform}/s5p-fimc/mipi-csis.c       |  0
 drivers/media/{video => platform}/s5p-fimc/mipi-csis.h       |  0
 drivers/media/{video => platform}/s5p-g2d/Makefile           |  0
 drivers/media/{video => platform}/s5p-g2d/g2d-hw.c           |  0
 drivers/media/{video => platform}/s5p-g2d/g2d-regs.h         |  0
 drivers/media/{video => platform}/s5p-g2d/g2d.c              |  0
 drivers/media/{video => platform}/s5p-g2d/g2d.h              |  0
 drivers/media/{video => platform}/s5p-jpeg/Makefile          |  0
 drivers/media/{video => platform}/s5p-jpeg/jpeg-core.c       |  2 +-
 drivers/media/{video => platform}/s5p-jpeg/jpeg-core.h       |  2 +-
 drivers/media/{video => platform}/s5p-jpeg/jpeg-hw.h         |  2 +-
 drivers/media/{video => platform}/s5p-jpeg/jpeg-regs.h       |  2 +-
 drivers/media/{video => platform}/s5p-mfc/Makefile           |  0
 drivers/media/{video => platform}/s5p-mfc/regs-mfc.h         |  0
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc.c          |  0
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_cmd.c      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_cmd.h      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_common.h   |  0
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_ctrl.c     |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_ctrl.h     |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_debug.h    |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_dec.c      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_dec.h      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_enc.c      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_enc.h      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_intr.c     |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_intr.h     |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_opr.c      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_opr.h      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_pm.c       |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_pm.h       |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_shm.c      |  2 +-
 drivers/media/{video => platform}/s5p-mfc/s5p_mfc_shm.h      |  2 +-
 drivers/media/{video => platform}/s5p-tv/Kconfig             |  2 +-
 drivers/media/{video => platform}/s5p-tv/Makefile            |  2 +-
 drivers/media/{video => platform}/s5p-tv/hdmi_drv.c          |  0
 drivers/media/{video => platform}/s5p-tv/hdmiphy_drv.c       |  0
 drivers/media/{video => platform}/s5p-tv/mixer.h             |  0
 drivers/media/{video => platform}/s5p-tv/mixer_drv.c         |  0
 drivers/media/{video => platform}/s5p-tv/mixer_grp_layer.c   |  0
 drivers/media/{video => platform}/s5p-tv/mixer_reg.c         |  0
 drivers/media/{video => platform}/s5p-tv/mixer_video.c       |  0
 drivers/media/{video => platform}/s5p-tv/mixer_vp_layer.c    |  0
 drivers/media/{video => platform}/s5p-tv/regs-hdmi.h         |  0
 drivers/media/{video => platform}/s5p-tv/regs-mixer.h        |  0
 drivers/media/{video => platform}/s5p-tv/regs-sdo.h          |  2 +-
 drivers/media/{video => platform}/s5p-tv/regs-vp.h           |  0
 drivers/media/{video => platform}/s5p-tv/sdo_drv.c           |  0
 drivers/media/{video => platform}/s5p-tv/sii9234_drv.c       |  0
 drivers/media/{video => platform}/sh_mobile_ceu_camera.c     |  0
 drivers/media/{video => platform}/sh_vou.c                   |  0
 drivers/media/{video => platform}/soc_camera.c               |  0
 drivers/media/{video => platform}/soc_camera_platform.c      |  0
 drivers/media/{video => platform}/soc_mediabus.c             |  0
 drivers/media/{video => platform}/timblogiw.c                |  0
 drivers/media/{video => platform}/via-camera.c               |  0
 drivers/media/{video => platform}/via-camera.h               |  0
 drivers/media/{video => platform}/vino.c                     |  0
 drivers/media/{video => platform}/vino.h                     |  0
 drivers/media/{video => platform}/vivi.c                     |  0
 168 files changed, 37 insertions(+), 37 deletions(-)
 rename drivers/media/{video => platform}/Kconfig (96%)
 rename drivers/media/{video => platform}/Makefile (100%)
 rename drivers/media/{video => platform}/arv.c (100%)
 rename drivers/media/{video => platform}/atmel-isi.c (100%)
 rename drivers/media/{video => platform}/blackfin/Kconfig (100%)
 rename drivers/media/{video => platform}/blackfin/Makefile (100%)
 rename drivers/media/{video => platform}/blackfin/bfin_capture.c (100%)
 rename drivers/media/{video => platform}/blackfin/ppi.c (100%)
 rename drivers/media/{video => platform}/coda.c (100%)
 rename drivers/media/{video => platform}/coda.h (99%)
 rename drivers/media/{video => platform}/davinci/Kconfig (100%)
 rename drivers/media/{video => platform}/davinci/Makefile (100%)
 rename drivers/media/{video => platform}/davinci/ccdc_hw_device.h (100%)
 rename drivers/media/{video => platform}/davinci/dm355_ccdc.c (100%)
 rename drivers/media/{video => platform}/davinci/dm355_ccdc_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/dm644x_ccdc.c (100%)
 rename drivers/media/{video => platform}/davinci/dm644x_ccdc_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/isif.c (100%)
 rename drivers/media/{video => platform}/davinci/isif_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/vpbe.c (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_display.c (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_osd.c (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_osd_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_venc.c (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_venc_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/vpfe_capture.c (100%)
 rename drivers/media/{video => platform}/davinci/vpif.c (100%)
 rename drivers/media/{video => platform}/davinci/vpif.h (100%)
 rename drivers/media/{video => platform}/davinci/vpif_capture.c (100%)
 rename drivers/media/{video => platform}/davinci/vpif_capture.h (100%)
 rename drivers/media/{video => platform}/davinci/vpif_display.c (100%)
 rename drivers/media/{video => platform}/davinci/vpif_display.h (100%)
 rename drivers/media/{video => platform}/davinci/vpss.c (100%)
 rename drivers/media/{video => platform}/fsl-viu.c (100%)
 rename drivers/media/{video => platform}/indycam.c (100%)
 rename drivers/media/{video => platform}/indycam.h (100%)
 rename drivers/media/{video => platform}/m2m-deinterlace.c (100%)
 rename drivers/media/{video => platform}/marvell-ccic/Kconfig (100%)
 rename drivers/media/{video => platform}/marvell-ccic/Makefile (100%)
 rename drivers/media/{video => platform}/marvell-ccic/cafe-driver.c (100%)
 rename drivers/media/{video => platform}/marvell-ccic/mcam-core.c (100%)
 rename drivers/media/{video => platform}/marvell-ccic/mcam-core.h (100%)
 rename drivers/media/{video => platform}/marvell-ccic/mmp-driver.c (100%)
 rename drivers/media/{video => platform}/mem2mem_testdev.c (100%)
 rename drivers/media/{video => platform}/mx1_camera.c (100%)
 rename drivers/media/{video => platform}/mx2_camera.c (100%)
 rename drivers/media/{video => platform}/mx2_emmaprp.c (100%)
 rename drivers/media/{video => platform}/mx3_camera.c (100%)
 rename drivers/media/{video => platform}/omap/Kconfig (100%)
 rename drivers/media/{video => platform}/omap/Makefile (100%)
 rename drivers/media/{video => platform}/omap/omap_vout.c (100%)
 rename drivers/media/{video => platform}/omap/omap_vout_vrfb.c (100%)
 rename drivers/media/{video => platform}/omap/omap_vout_vrfb.h (100%)
 rename drivers/media/{video => platform}/omap/omap_voutdef.h (100%)
 rename drivers/media/{video => platform}/omap/omap_voutlib.c (100%)
 rename drivers/media/{video => platform}/omap/omap_voutlib.h (100%)
 rename drivers/media/{video => platform}/omap1_camera.c (99%)
 rename drivers/media/{video => platform}/omap24xxcam-dma.c (99%)
 rename drivers/media/{video => platform}/omap24xxcam.c (99%)
 rename drivers/media/{video => platform}/omap24xxcam.h (99%)
 rename drivers/media/{video => platform}/omap3isp/Makefile (100%)
 rename drivers/media/{video => platform}/omap3isp/cfa_coef_table.h (100%)
 rename drivers/media/{video => platform}/omap3isp/gamma_table.h (100%)
 rename drivers/media/{video => platform}/omap3isp/isp.c (100%)
 rename drivers/media/{video => platform}/omap3isp/isp.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispccdc.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispccdc.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispccp2.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispccp2.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispcsi2.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispcsi2.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispcsiphy.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispcsiphy.h (100%)
 rename drivers/media/{video => platform}/omap3isp/isph3a.h (100%)
 rename drivers/media/{video => platform}/omap3isp/isph3a_aewb.c (100%)
 rename drivers/media/{video => platform}/omap3isp/isph3a_af.c (100%)
 rename drivers/media/{video => platform}/omap3isp/isphist.c (100%)
 rename drivers/media/{video => platform}/omap3isp/isphist.h (100%)
 rename drivers/media/{video => platform}/omap3isp/isppreview.c (100%)
 rename drivers/media/{video => platform}/omap3isp/isppreview.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispqueue.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispqueue.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispreg.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispresizer.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispresizer.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispstat.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispstat.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispvideo.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispvideo.h (100%)
 rename drivers/media/{video => platform}/omap3isp/luma_enhance_table.h (100%)
 rename drivers/media/{video => platform}/omap3isp/noise_filter_table.h (100%)
 rename drivers/media/{video => platform}/pxa_camera.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/Kconfig (100%)
 rename drivers/media/{video => platform}/s5p-fimc/Makefile (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-capture.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-core.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-core.h (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-lite-reg.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-lite-reg.h (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-lite.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-lite.h (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-m2m.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-mdevice.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-mdevice.h (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-reg.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-reg.h (100%)
 rename drivers/media/{video => platform}/s5p-fimc/mipi-csis.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/mipi-csis.h (100%)
 rename drivers/media/{video => platform}/s5p-g2d/Makefile (100%)
 rename drivers/media/{video => platform}/s5p-g2d/g2d-hw.c (100%)
 rename drivers/media/{video => platform}/s5p-g2d/g2d-regs.h (100%)
 rename drivers/media/{video => platform}/s5p-g2d/g2d.c (100%)
 rename drivers/media/{video => platform}/s5p-g2d/g2d.h (100%)
 rename drivers/media/{video => platform}/s5p-jpeg/Makefile (100%)
 rename drivers/media/{video => platform}/s5p-jpeg/jpeg-core.c (99%)
 rename drivers/media/{video => platform}/s5p-jpeg/jpeg-core.h (98%)
 rename drivers/media/{video => platform}/s5p-jpeg/jpeg-hw.h (99%)
 rename drivers/media/{video => platform}/s5p-jpeg/jpeg-regs.h (98%)
 rename drivers/media/{video => platform}/s5p-mfc/Makefile (100%)
 rename drivers/media/{video => platform}/s5p-mfc/regs-mfc.h (100%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc.c (100%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_cmd.c (98%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_cmd.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_common.h (100%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_ctrl.c (99%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_ctrl.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_debug.h (95%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_dec.c (99%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_dec.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_enc.c (99%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_enc.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_intr.c (97%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_intr.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_opr.c (99%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_opr.h (98%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_pm.c (98%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_pm.h (92%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_shm.c (96%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_shm.h (98%)
 rename drivers/media/{video => platform}/s5p-tv/Kconfig (98%)
 rename drivers/media/{video => platform}/s5p-tv/Makefile (92%)
 rename drivers/media/{video => platform}/s5p-tv/hdmi_drv.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/hdmiphy_drv.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer.h (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_drv.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_grp_layer.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_reg.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_video.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_vp_layer.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/regs-hdmi.h (100%)
 rename drivers/media/{video => platform}/s5p-tv/regs-mixer.h (100%)
 rename drivers/media/{video => platform}/s5p-tv/regs-sdo.h (97%)
 rename drivers/media/{video => platform}/s5p-tv/regs-vp.h (100%)
 rename drivers/media/{video => platform}/s5p-tv/sdo_drv.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/sii9234_drv.c (100%)
 rename drivers/media/{video => platform}/sh_mobile_ceu_camera.c (100%)
 rename drivers/media/{video => platform}/sh_vou.c (100%)
 rename drivers/media/{video => platform}/soc_camera.c (100%)
 rename drivers/media/{video => platform}/soc_camera_platform.c (100%)
 rename drivers/media/{video => platform}/soc_mediabus.c (100%)
 rename drivers/media/{video => platform}/timblogiw.c (100%)
 rename drivers/media/{video => platform}/via-camera.c (100%)
 rename drivers/media/{video => platform}/via-camera.h (100%)
 rename drivers/media/{video => platform}/vino.c (100%)
 rename drivers/media/{video => platform}/vino.h (100%)
 rename drivers/media/{video => platform}/vivi.c (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 26f3de5..dcaaf8e 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -156,7 +156,7 @@ source "drivers/media/i2c/Kconfig"
 #
 # V4L platform/mem2mem drivers
 #
-source "drivers/media/video/Kconfig"
+source "drivers/media/platform/Kconfig"
 
 source "drivers/media/radio/Kconfig"
 
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index e1be196..b0b0193 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -8,7 +8,7 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += media.o
 endif
 
-obj-y += tuners/ common/ rc/ video/
+obj-y += tuners/ common/ rc/ platform/
 obj-y += i2c/ pci/ usb/ mmc/ firewire/ parport/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/ v4l2-core/
diff --git a/drivers/media/video/Kconfig b/drivers/media/platform/Kconfig
similarity index 96%
rename from drivers/media/video/Kconfig
rename to drivers/media/platform/Kconfig
index 28b25bf..e1959a8 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -27,7 +27,7 @@ menuconfig V4L_PLATFORM_DRIVERS
 
 if V4L_PLATFORM_DRIVERS
 
-source "drivers/media/video/marvell-ccic/Kconfig"
+source "drivers/media/platform/marvell-ccic/Kconfig"
 
 config VIDEO_VIA_CAMERA
 	tristate "VIAFB camera controller support"
@@ -43,11 +43,11 @@ config VIDEO_VIA_CAMERA
 # Platform multimedia device configuration
 #
 
-source "drivers/media/video/davinci/Kconfig"
+source "drivers/media/platform/davinci/Kconfig"
 
-source "drivers/media/video/omap/Kconfig"
+source "drivers/media/platform/omap/Kconfig"
 
-source "drivers/media/video/blackfin/Kconfig"
+source "drivers/media/platform/blackfin/Kconfig"
 
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
@@ -212,8 +212,8 @@ config VIDEO_ATMEL_ISI
 	  This module makes the ATMEL Image Sensor Interface available
 	  as a v4l2 device.
 
-source "drivers/media/video/s5p-fimc/Kconfig"
-source "drivers/media/video/s5p-tv/Kconfig"
+source "drivers/media/platform/s5p-fimc/Kconfig"
+source "drivers/media/platform/s5p-tv/Kconfig"
 
 endif # V4L_PLATFORM_DRIVERS
 
diff --git a/drivers/media/video/Makefile b/drivers/media/platform/Makefile
similarity index 100%
rename from drivers/media/video/Makefile
rename to drivers/media/platform/Makefile
diff --git a/drivers/media/video/arv.c b/drivers/media/platform/arv.c
similarity index 100%
rename from drivers/media/video/arv.c
rename to drivers/media/platform/arv.c
diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/platform/atmel-isi.c
similarity index 100%
rename from drivers/media/video/atmel-isi.c
rename to drivers/media/platform/atmel-isi.c
diff --git a/drivers/media/video/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
similarity index 100%
rename from drivers/media/video/blackfin/Kconfig
rename to drivers/media/platform/blackfin/Kconfig
diff --git a/drivers/media/video/blackfin/Makefile b/drivers/media/platform/blackfin/Makefile
similarity index 100%
rename from drivers/media/video/blackfin/Makefile
rename to drivers/media/platform/blackfin/Makefile
diff --git a/drivers/media/video/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
similarity index 100%
rename from drivers/media/video/blackfin/bfin_capture.c
rename to drivers/media/platform/blackfin/bfin_capture.c
diff --git a/drivers/media/video/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
similarity index 100%
rename from drivers/media/video/blackfin/ppi.c
rename to drivers/media/platform/blackfin/ppi.c
diff --git a/drivers/media/video/coda.c b/drivers/media/platform/coda.c
similarity index 100%
rename from drivers/media/video/coda.c
rename to drivers/media/platform/coda.c
diff --git a/drivers/media/video/coda.h b/drivers/media/platform/coda.h
similarity index 99%
rename from drivers/media/video/coda.h
rename to drivers/media/platform/coda.h
index 4cf4a04..3fbb315 100644
--- a/drivers/media/video/coda.h
+++ b/drivers/media/platform/coda.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/coda/coda_regs.h
+ * linux/drivers/media/platform/coda/coda_regs.h
  *
  * Copyright (C) 2012 Vista Silicon SL
  *    Javier Martin <javier.martin@vista-silicon.com>
diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
similarity index 100%
rename from drivers/media/video/davinci/Kconfig
rename to drivers/media/platform/davinci/Kconfig
diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/platform/davinci/Makefile
similarity index 100%
rename from drivers/media/video/davinci/Makefile
rename to drivers/media/platform/davinci/Makefile
diff --git a/drivers/media/video/davinci/ccdc_hw_device.h b/drivers/media/platform/davinci/ccdc_hw_device.h
similarity index 100%
rename from drivers/media/video/davinci/ccdc_hw_device.h
rename to drivers/media/platform/davinci/ccdc_hw_device.h
diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
similarity index 100%
rename from drivers/media/video/davinci/dm355_ccdc.c
rename to drivers/media/platform/davinci/dm355_ccdc.c
diff --git a/drivers/media/video/davinci/dm355_ccdc_regs.h b/drivers/media/platform/davinci/dm355_ccdc_regs.h
similarity index 100%
rename from drivers/media/video/davinci/dm355_ccdc_regs.h
rename to drivers/media/platform/davinci/dm355_ccdc_regs.h
diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
similarity index 100%
rename from drivers/media/video/davinci/dm644x_ccdc.c
rename to drivers/media/platform/davinci/dm644x_ccdc.c
diff --git a/drivers/media/video/davinci/dm644x_ccdc_regs.h b/drivers/media/platform/davinci/dm644x_ccdc_regs.h
similarity index 100%
rename from drivers/media/video/davinci/dm644x_ccdc_regs.h
rename to drivers/media/platform/davinci/dm644x_ccdc_regs.h
diff --git a/drivers/media/video/davinci/isif.c b/drivers/media/platform/davinci/isif.c
similarity index 100%
rename from drivers/media/video/davinci/isif.c
rename to drivers/media/platform/davinci/isif.c
diff --git a/drivers/media/video/davinci/isif_regs.h b/drivers/media/platform/davinci/isif_regs.h
similarity index 100%
rename from drivers/media/video/davinci/isif_regs.h
rename to drivers/media/platform/davinci/isif_regs.h
diff --git a/drivers/media/video/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
similarity index 100%
rename from drivers/media/video/davinci/vpbe.c
rename to drivers/media/platform/davinci/vpbe.c
diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
similarity index 100%
rename from drivers/media/video/davinci/vpbe_display.c
rename to drivers/media/platform/davinci/vpbe_display.c
diff --git a/drivers/media/video/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
similarity index 100%
rename from drivers/media/video/davinci/vpbe_osd.c
rename to drivers/media/platform/davinci/vpbe_osd.c
diff --git a/drivers/media/video/davinci/vpbe_osd_regs.h b/drivers/media/platform/davinci/vpbe_osd_regs.h
similarity index 100%
rename from drivers/media/video/davinci/vpbe_osd_regs.h
rename to drivers/media/platform/davinci/vpbe_osd_regs.h
diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
similarity index 100%
rename from drivers/media/video/davinci/vpbe_venc.c
rename to drivers/media/platform/davinci/vpbe_venc.c
diff --git a/drivers/media/video/davinci/vpbe_venc_regs.h b/drivers/media/platform/davinci/vpbe_venc_regs.h
similarity index 100%
rename from drivers/media/video/davinci/vpbe_venc_regs.h
rename to drivers/media/platform/davinci/vpbe_venc_regs.h
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
similarity index 100%
rename from drivers/media/video/davinci/vpfe_capture.c
rename to drivers/media/platform/davinci/vpfe_capture.c
diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
similarity index 100%
rename from drivers/media/video/davinci/vpif.c
rename to drivers/media/platform/davinci/vpif.c
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/platform/davinci/vpif.h
similarity index 100%
rename from drivers/media/video/davinci/vpif.h
rename to drivers/media/platform/davinci/vpif.h
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
similarity index 100%
rename from drivers/media/video/davinci/vpif_capture.c
rename to drivers/media/platform/davinci/vpif_capture.c
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
similarity index 100%
rename from drivers/media/video/davinci/vpif_capture.h
rename to drivers/media/platform/davinci/vpif_capture.h
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
similarity index 100%
rename from drivers/media/video/davinci/vpif_display.c
rename to drivers/media/platform/davinci/vpif_display.c
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
similarity index 100%
rename from drivers/media/video/davinci/vpif_display.h
rename to drivers/media/platform/davinci/vpif_display.h
diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
similarity index 100%
rename from drivers/media/video/davinci/vpss.c
rename to drivers/media/platform/davinci/vpss.c
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/platform/fsl-viu.c
similarity index 100%
rename from drivers/media/video/fsl-viu.c
rename to drivers/media/platform/fsl-viu.c
diff --git a/drivers/media/video/indycam.c b/drivers/media/platform/indycam.c
similarity index 100%
rename from drivers/media/video/indycam.c
rename to drivers/media/platform/indycam.c
diff --git a/drivers/media/video/indycam.h b/drivers/media/platform/indycam.h
similarity index 100%
rename from drivers/media/video/indycam.h
rename to drivers/media/platform/indycam.h
diff --git a/drivers/media/video/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
similarity index 100%
rename from drivers/media/video/m2m-deinterlace.c
rename to drivers/media/platform/m2m-deinterlace.c
diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
similarity index 100%
rename from drivers/media/video/marvell-ccic/Kconfig
rename to drivers/media/platform/marvell-ccic/Kconfig
diff --git a/drivers/media/video/marvell-ccic/Makefile b/drivers/media/platform/marvell-ccic/Makefile
similarity index 100%
rename from drivers/media/video/marvell-ccic/Makefile
rename to drivers/media/platform/marvell-ccic/Makefile
diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
similarity index 100%
rename from drivers/media/video/marvell-ccic/cafe-driver.c
rename to drivers/media/platform/marvell-ccic/cafe-driver.c
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
similarity index 100%
rename from drivers/media/video/marvell-ccic/mcam-core.c
rename to drivers/media/platform/marvell-ccic/mcam-core.c
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
similarity index 100%
rename from drivers/media/video/marvell-ccic/mcam-core.h
rename to drivers/media/platform/marvell-ccic/mcam-core.h
diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
similarity index 100%
rename from drivers/media/video/marvell-ccic/mmp-driver.c
rename to drivers/media/platform/marvell-ccic/mmp-driver.c
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
similarity index 100%
rename from drivers/media/video/mem2mem_testdev.c
rename to drivers/media/platform/mem2mem_testdev.c
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/platform/mx1_camera.c
similarity index 100%
rename from drivers/media/video/mx1_camera.c
rename to drivers/media/platform/mx1_camera.c
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/platform/mx2_camera.c
similarity index 100%
rename from drivers/media/video/mx2_camera.c
rename to drivers/media/platform/mx2_camera.c
diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
similarity index 100%
rename from drivers/media/video/mx2_emmaprp.c
rename to drivers/media/platform/mx2_emmaprp.c
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/platform/mx3_camera.c
similarity index 100%
rename from drivers/media/video/mx3_camera.c
rename to drivers/media/platform/mx3_camera.c
diff --git a/drivers/media/video/omap/Kconfig b/drivers/media/platform/omap/Kconfig
similarity index 100%
rename from drivers/media/video/omap/Kconfig
rename to drivers/media/platform/omap/Kconfig
diff --git a/drivers/media/video/omap/Makefile b/drivers/media/platform/omap/Makefile
similarity index 100%
rename from drivers/media/video/omap/Makefile
rename to drivers/media/platform/omap/Makefile
diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
similarity index 100%
rename from drivers/media/video/omap/omap_vout.c
rename to drivers/media/platform/omap/omap_vout.c
diff --git a/drivers/media/video/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
similarity index 100%
rename from drivers/media/video/omap/omap_vout_vrfb.c
rename to drivers/media/platform/omap/omap_vout_vrfb.c
diff --git a/drivers/media/video/omap/omap_vout_vrfb.h b/drivers/media/platform/omap/omap_vout_vrfb.h
similarity index 100%
rename from drivers/media/video/omap/omap_vout_vrfb.h
rename to drivers/media/platform/omap/omap_vout_vrfb.h
diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/platform/omap/omap_voutdef.h
similarity index 100%
rename from drivers/media/video/omap/omap_voutdef.h
rename to drivers/media/platform/omap/omap_voutdef.h
diff --git a/drivers/media/video/omap/omap_voutlib.c b/drivers/media/platform/omap/omap_voutlib.c
similarity index 100%
rename from drivers/media/video/omap/omap_voutlib.c
rename to drivers/media/platform/omap/omap_voutlib.c
diff --git a/drivers/media/video/omap/omap_voutlib.h b/drivers/media/platform/omap/omap_voutlib.h
similarity index 100%
rename from drivers/media/video/omap/omap_voutlib.h
rename to drivers/media/platform/omap/omap_voutlib.h
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/platform/omap1_camera.c
similarity index 99%
rename from drivers/media/video/omap1_camera.c
rename to drivers/media/platform/omap1_camera.c
index c7e4114..fa08c76 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/platform/omap1_camera.c
@@ -12,7 +12,7 @@
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
  *
  * Hardware specific bits initialy based on former work by Matt Callow
- * drivers/media/video/omap/omap1510cam.c
+ * drivers/media/platform/omap/omap1510cam.c
  * Copyright (C) 2006 Matt Callow
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/video/omap24xxcam-dma.c b/drivers/media/platform/omap24xxcam-dma.c
similarity index 99%
rename from drivers/media/video/omap24xxcam-dma.c
rename to drivers/media/platform/omap24xxcam-dma.c
index b5ae170..9c00776 100644
--- a/drivers/media/video/omap24xxcam-dma.c
+++ b/drivers/media/platform/omap24xxcam-dma.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/omap24xxcam-dma.c
+ * drivers/media/platform/omap24xxcam-dma.c
  *
  * Copyright (C) 2004 MontaVista Software, Inc.
  * Copyright (C) 2004 Texas Instruments.
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/platform/omap24xxcam.c
similarity index 99%
rename from drivers/media/video/omap24xxcam.c
rename to drivers/media/platform/omap24xxcam.c
index e5015b0..fde2e66 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/platform/omap24xxcam.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/omap24xxcam.c
+ * drivers/media/platform/omap24xxcam.c
  *
  * OMAP 2 camera block driver.
  *
diff --git a/drivers/media/video/omap24xxcam.h b/drivers/media/platform/omap24xxcam.h
similarity index 99%
rename from drivers/media/video/omap24xxcam.h
rename to drivers/media/platform/omap24xxcam.h
index d59727a..c439595 100644
--- a/drivers/media/video/omap24xxcam.h
+++ b/drivers/media/platform/omap24xxcam.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/omap24xxcam.h
+ * drivers/media/platform/omap24xxcam.h
  *
  * Copyright (C) 2004 MontaVista Software, Inc.
  * Copyright (C) 2004 Texas Instruments.
diff --git a/drivers/media/video/omap3isp/Makefile b/drivers/media/platform/omap3isp/Makefile
similarity index 100%
rename from drivers/media/video/omap3isp/Makefile
rename to drivers/media/platform/omap3isp/Makefile
diff --git a/drivers/media/video/omap3isp/cfa_coef_table.h b/drivers/media/platform/omap3isp/cfa_coef_table.h
similarity index 100%
rename from drivers/media/video/omap3isp/cfa_coef_table.h
rename to drivers/media/platform/omap3isp/cfa_coef_table.h
diff --git a/drivers/media/video/omap3isp/gamma_table.h b/drivers/media/platform/omap3isp/gamma_table.h
similarity index 100%
rename from drivers/media/video/omap3isp/gamma_table.h
rename to drivers/media/platform/omap3isp/gamma_table.h
diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
similarity index 100%
rename from drivers/media/video/omap3isp/isp.c
rename to drivers/media/platform/omap3isp/isp.c
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
similarity index 100%
rename from drivers/media/video/omap3isp/isp.h
rename to drivers/media/platform/omap3isp/isp.h
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
similarity index 100%
rename from drivers/media/video/omap3isp/ispccdc.c
rename to drivers/media/platform/omap3isp/ispccdc.c
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispccdc.h
rename to drivers/media/platform/omap3isp/ispccdc.h
diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
similarity index 100%
rename from drivers/media/video/omap3isp/ispccp2.c
rename to drivers/media/platform/omap3isp/ispccp2.c
diff --git a/drivers/media/video/omap3isp/ispccp2.h b/drivers/media/platform/omap3isp/ispccp2.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispccp2.h
rename to drivers/media/platform/omap3isp/ispccp2.h
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
similarity index 100%
rename from drivers/media/video/omap3isp/ispcsi2.c
rename to drivers/media/platform/omap3isp/ispcsi2.c
diff --git a/drivers/media/video/omap3isp/ispcsi2.h b/drivers/media/platform/omap3isp/ispcsi2.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispcsi2.h
rename to drivers/media/platform/omap3isp/ispcsi2.h
diff --git a/drivers/media/video/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
similarity index 100%
rename from drivers/media/video/omap3isp/ispcsiphy.c
rename to drivers/media/platform/omap3isp/ispcsiphy.c
diff --git a/drivers/media/video/omap3isp/ispcsiphy.h b/drivers/media/platform/omap3isp/ispcsiphy.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispcsiphy.h
rename to drivers/media/platform/omap3isp/ispcsiphy.h
diff --git a/drivers/media/video/omap3isp/isph3a.h b/drivers/media/platform/omap3isp/isph3a.h
similarity index 100%
rename from drivers/media/video/omap3isp/isph3a.h
rename to drivers/media/platform/omap3isp/isph3a.h
diff --git a/drivers/media/video/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
similarity index 100%
rename from drivers/media/video/omap3isp/isph3a_aewb.c
rename to drivers/media/platform/omap3isp/isph3a_aewb.c
diff --git a/drivers/media/video/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
similarity index 100%
rename from drivers/media/video/omap3isp/isph3a_af.c
rename to drivers/media/platform/omap3isp/isph3a_af.c
diff --git a/drivers/media/video/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
similarity index 100%
rename from drivers/media/video/omap3isp/isphist.c
rename to drivers/media/platform/omap3isp/isphist.c
diff --git a/drivers/media/video/omap3isp/isphist.h b/drivers/media/platform/omap3isp/isphist.h
similarity index 100%
rename from drivers/media/video/omap3isp/isphist.h
rename to drivers/media/platform/omap3isp/isphist.h
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
similarity index 100%
rename from drivers/media/video/omap3isp/isppreview.c
rename to drivers/media/platform/omap3isp/isppreview.c
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/platform/omap3isp/isppreview.h
similarity index 100%
rename from drivers/media/video/omap3isp/isppreview.h
rename to drivers/media/platform/omap3isp/isppreview.h
diff --git a/drivers/media/video/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
similarity index 100%
rename from drivers/media/video/omap3isp/ispqueue.c
rename to drivers/media/platform/omap3isp/ispqueue.c
diff --git a/drivers/media/video/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispqueue.h
rename to drivers/media/platform/omap3isp/ispqueue.h
diff --git a/drivers/media/video/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispreg.h
rename to drivers/media/platform/omap3isp/ispreg.h
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
similarity index 100%
rename from drivers/media/video/omap3isp/ispresizer.c
rename to drivers/media/platform/omap3isp/ispresizer.c
diff --git a/drivers/media/video/omap3isp/ispresizer.h b/drivers/media/platform/omap3isp/ispresizer.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispresizer.h
rename to drivers/media/platform/omap3isp/ispresizer.h
diff --git a/drivers/media/video/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
similarity index 100%
rename from drivers/media/video/omap3isp/ispstat.c
rename to drivers/media/platform/omap3isp/ispstat.c
diff --git a/drivers/media/video/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispstat.h
rename to drivers/media/platform/omap3isp/ispstat.h
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
similarity index 100%
rename from drivers/media/video/omap3isp/ispvideo.c
rename to drivers/media/platform/omap3isp/ispvideo.c
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
similarity index 100%
rename from drivers/media/video/omap3isp/ispvideo.h
rename to drivers/media/platform/omap3isp/ispvideo.h
diff --git a/drivers/media/video/omap3isp/luma_enhance_table.h b/drivers/media/platform/omap3isp/luma_enhance_table.h
similarity index 100%
rename from drivers/media/video/omap3isp/luma_enhance_table.h
rename to drivers/media/platform/omap3isp/luma_enhance_table.h
diff --git a/drivers/media/video/omap3isp/noise_filter_table.h b/drivers/media/platform/omap3isp/noise_filter_table.h
similarity index 100%
rename from drivers/media/video/omap3isp/noise_filter_table.h
rename to drivers/media/platform/omap3isp/noise_filter_table.h
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/platform/pxa_camera.c
similarity index 100%
rename from drivers/media/video/pxa_camera.c
rename to drivers/media/platform/pxa_camera.c
diff --git a/drivers/media/video/s5p-fimc/Kconfig b/drivers/media/platform/s5p-fimc/Kconfig
similarity index 100%
rename from drivers/media/video/s5p-fimc/Kconfig
rename to drivers/media/platform/s5p-fimc/Kconfig
diff --git a/drivers/media/video/s5p-fimc/Makefile b/drivers/media/platform/s5p-fimc/Makefile
similarity index 100%
rename from drivers/media/video/s5p-fimc/Makefile
rename to drivers/media/platform/s5p-fimc/Makefile
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-capture.c
rename to drivers/media/platform/s5p-fimc/fimc-capture.c
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-core.c
rename to drivers/media/platform/s5p-fimc/fimc-core.c
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-core.h
rename to drivers/media/platform/s5p-fimc/fimc-core.h
diff --git a/drivers/media/video/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-lite-reg.c
rename to drivers/media/platform/s5p-fimc/fimc-lite-reg.c
diff --git a/drivers/media/video/s5p-fimc/fimc-lite-reg.h b/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-lite-reg.h
rename to drivers/media/platform/s5p-fimc/fimc-lite-reg.h
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-lite.c
rename to drivers/media/platform/s5p-fimc/fimc-lite.c
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-lite.h
rename to drivers/media/platform/s5p-fimc/fimc-lite.h
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-m2m.c
rename to drivers/media/platform/s5p-fimc/fimc-m2m.c
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-mdevice.c
rename to drivers/media/platform/s5p-fimc/fimc-mdevice.c
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-mdevice.h
rename to drivers/media/platform/s5p-fimc/fimc-mdevice.h
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-reg.c
rename to drivers/media/platform/s5p-fimc/fimc-reg.c
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.h b/drivers/media/platform/s5p-fimc/fimc-reg.h
similarity index 100%
rename from drivers/media/video/s5p-fimc/fimc-reg.h
rename to drivers/media/platform/s5p-fimc/fimc-reg.h
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
similarity index 100%
rename from drivers/media/video/s5p-fimc/mipi-csis.c
rename to drivers/media/platform/s5p-fimc/mipi-csis.c
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.h b/drivers/media/platform/s5p-fimc/mipi-csis.h
similarity index 100%
rename from drivers/media/video/s5p-fimc/mipi-csis.h
rename to drivers/media/platform/s5p-fimc/mipi-csis.h
diff --git a/drivers/media/video/s5p-g2d/Makefile b/drivers/media/platform/s5p-g2d/Makefile
similarity index 100%
rename from drivers/media/video/s5p-g2d/Makefile
rename to drivers/media/platform/s5p-g2d/Makefile
diff --git a/drivers/media/video/s5p-g2d/g2d-hw.c b/drivers/media/platform/s5p-g2d/g2d-hw.c
similarity index 100%
rename from drivers/media/video/s5p-g2d/g2d-hw.c
rename to drivers/media/platform/s5p-g2d/g2d-hw.c
diff --git a/drivers/media/video/s5p-g2d/g2d-regs.h b/drivers/media/platform/s5p-g2d/g2d-regs.h
similarity index 100%
rename from drivers/media/video/s5p-g2d/g2d-regs.h
rename to drivers/media/platform/s5p-g2d/g2d-regs.h
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
similarity index 100%
rename from drivers/media/video/s5p-g2d/g2d.c
rename to drivers/media/platform/s5p-g2d/g2d.c
diff --git a/drivers/media/video/s5p-g2d/g2d.h b/drivers/media/platform/s5p-g2d/g2d.h
similarity index 100%
rename from drivers/media/video/s5p-g2d/g2d.h
rename to drivers/media/platform/s5p-g2d/g2d.h
diff --git a/drivers/media/video/s5p-jpeg/Makefile b/drivers/media/platform/s5p-jpeg/Makefile
similarity index 100%
rename from drivers/media/video/s5p-jpeg/Makefile
rename to drivers/media/platform/s5p-jpeg/Makefile
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
similarity index 99%
rename from drivers/media/video/s5p-jpeg/jpeg-core.c
rename to drivers/media/platform/s5p-jpeg/jpeg-core.c
index be04d58..72c3e52 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1,4 +1,4 @@
-/* linux/drivers/media/video/s5p-jpeg/jpeg-core.c
+/* linux/drivers/media/platform/s5p-jpeg/jpeg-core.c
  *
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
similarity index 98%
rename from drivers/media/video/s5p-jpeg/jpeg-core.h
rename to drivers/media/platform/s5p-jpeg/jpeg-core.h
index 9d0cd2b..022b9b9 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -1,4 +1,4 @@
-/* linux/drivers/media/video/s5p-jpeg/jpeg-core.h
+/* linux/drivers/media/platform/s5p-jpeg/jpeg-core.h
  *
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
diff --git a/drivers/media/video/s5p-jpeg/jpeg-hw.h b/drivers/media/platform/s5p-jpeg/jpeg-hw.h
similarity index 99%
rename from drivers/media/video/s5p-jpeg/jpeg-hw.h
rename to drivers/media/platform/s5p-jpeg/jpeg-hw.h
index f12f0fd..b47e887 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-hw.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw.h
@@ -1,4 +1,4 @@
-/* linux/drivers/media/video/s5p-jpeg/jpeg-hw.h
+/* linux/drivers/media/platform/s5p-jpeg/jpeg-hw.h
  *
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
diff --git a/drivers/media/video/s5p-jpeg/jpeg-regs.h b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
similarity index 98%
rename from drivers/media/video/s5p-jpeg/jpeg-regs.h
rename to drivers/media/platform/s5p-jpeg/jpeg-regs.h
index 91f4dd5..38e5081 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-regs.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
@@ -1,4 +1,4 @@
-/* linux/drivers/media/video/s5p-jpeg/jpeg-regs.h
+/* linux/drivers/media/platform/s5p-jpeg/jpeg-regs.h
  *
  * Register definition file for Samsung JPEG codec driver
  *
diff --git a/drivers/media/video/s5p-mfc/Makefile b/drivers/media/platform/s5p-mfc/Makefile
similarity index 100%
rename from drivers/media/video/s5p-mfc/Makefile
rename to drivers/media/platform/s5p-mfc/Makefile
diff --git a/drivers/media/video/s5p-mfc/regs-mfc.h b/drivers/media/platform/s5p-mfc/regs-mfc.h
similarity index 100%
rename from drivers/media/video/s5p-mfc/regs-mfc.h
rename to drivers/media/platform/s5p-mfc/regs-mfc.h
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
similarity index 100%
rename from drivers/media/video/s5p-mfc/s5p_mfc.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc.c
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
similarity index 98%
rename from drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
index f0665ed..91a4155 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
similarity index 93%
rename from drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
index 5ceebfe..8b090d3 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
similarity index 100%
rename from drivers/media/video/s5p-mfc/s5p_mfc_common.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_common.h
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
similarity index 99%
rename from drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 08a5cfe..4d662f1 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
  *
  * Copyright (c) 2010 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
similarity index 93%
rename from drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
index 61dc23b..e1e0c54 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
  *
  * Copyright (c) 2010 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h b/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
similarity index 95%
rename from drivers/media/video/s5p-mfc/s5p_mfc_debug.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
index ecb8616..bd5cd4a 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/samsung/mfc5/s5p_mfc_debug.h
+ * drivers/media/platform/samsung/mfc5/s5p_mfc_debug.h
  *
  * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
  * This file contains debug macros
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
similarity index 99%
rename from drivers/media/video/s5p-mfc/s5p_mfc_dec.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index c5d567f..456f5df 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.h
similarity index 93%
rename from drivers/media/video/s5p-mfc/s5p_mfc_dec.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_dec.h
index fb8b215..fdf1d99 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_dec.h
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
similarity index 99%
rename from drivers/media/video/s5p-mfc/s5p_mfc_enc.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index aa1c244..fdeebb0 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
  *
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.h
similarity index 93%
rename from drivers/media/video/s5p-mfc/s5p_mfc_enc.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_enc.h
index 405bdd3..ca9fd66 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_enc.h
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_intr.c
similarity index 97%
rename from drivers/media/video/s5p-mfc/s5p_mfc_intr.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc_intr.c
index 8f2f8bf..37860e2 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_intr.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/samsung/mfc5/s5p_mfc_intr.c
+ * drivers/media/platform/samsung/mfc5/s5p_mfc_intr.c
  *
  * C file for Samsung MFC (Multi Function Codec - FIMV) driver
  * This file contains functions used to wait for command completion.
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_intr.h
similarity index 93%
rename from drivers/media/video/s5p-mfc/s5p_mfc_intr.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_intr.h
index 122d773..18341a8 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_intr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_intr.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/samsung/mfc5/s5p_mfc_intr.h
+ * drivers/media/platform/samsung/mfc5/s5p_mfc_intr.h
  *
  * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
  * It contains waiting functions declarations.
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
similarity index 99%
rename from drivers/media/video/s5p-mfc/s5p_mfc_opr.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index e6217cb..b5fd3d4 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/samsung/mfc5/s5p_mfc_opr.c
+ * drivers/media/platform/samsung/mfc5/s5p_mfc_opr.c
  *
  * Samsung MFC (Multi Function Codec - FIMV) driver
  * This file contains hw related functions.
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
similarity index 98%
rename from drivers/media/video/s5p-mfc/s5p_mfc_opr.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 5932d1c..2ad3def 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/samsung/mfc5/s5p_mfc_opr.h
+ * drivers/media/platform/samsung/mfc5/s5p_mfc_opr.h
  *
  * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
  * Contains declarations of hw related functions.
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
similarity index 98%
rename from drivers/media/video/s5p-mfc/s5p_mfc_pm.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 738a607..0503d14 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
  *
  * Copyright (c) 2010 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_pm.h b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.h
similarity index 92%
rename from drivers/media/video/s5p-mfc/s5p_mfc_pm.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_pm.h
index 5107914..875c534 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_pm.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_pm.h
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_pm.h
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_shm.c
similarity index 96%
rename from drivers/media/video/s5p-mfc/s5p_mfc_shm.c
rename to drivers/media/platform/s5p-mfc/s5p_mfc_shm.c
index 91fdbac8..b5933d2 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_shm.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_shm.c
  *
  * Copyright (c) 2010 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h b/drivers/media/platform/s5p-mfc/s5p_mfc_shm.h
similarity index 98%
rename from drivers/media/video/s5p-mfc/s5p_mfc_shm.h
rename to drivers/media/platform/s5p-mfc/s5p_mfc_shm.h
index cf962a4..416ebd7 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_shm.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_shm.h
  *
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/platform/s5p-tv/Kconfig
similarity index 98%
rename from drivers/media/video/s5p-tv/Kconfig
rename to drivers/media/platform/s5p-tv/Kconfig
index f248b28..ea11a51 100644
--- a/drivers/media/video/s5p-tv/Kconfig
+++ b/drivers/media/platform/s5p-tv/Kconfig
@@ -1,4 +1,4 @@
-# drivers/media/video/s5p-tv/Kconfig
+# drivers/media/platform/s5p-tv/Kconfig
 #
 # Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
 #	http://www.samsung.com/
diff --git a/drivers/media/video/s5p-tv/Makefile b/drivers/media/platform/s5p-tv/Makefile
similarity index 92%
rename from drivers/media/video/s5p-tv/Makefile
rename to drivers/media/platform/s5p-tv/Makefile
index f49e756..7cd4790 100644
--- a/drivers/media/video/s5p-tv/Makefile
+++ b/drivers/media/platform/s5p-tv/Makefile
@@ -1,4 +1,4 @@
-# drivers/media/video/samsung/tvout/Makefile
+# drivers/media/platform/samsung/tvout/Makefile
 #
 # Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
 #	http://www.samsung.com/
diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
similarity index 100%
rename from drivers/media/video/s5p-tv/hdmi_drv.c
rename to drivers/media/platform/s5p-tv/hdmi_drv.c
diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
similarity index 100%
rename from drivers/media/video/s5p-tv/hdmiphy_drv.c
rename to drivers/media/platform/s5p-tv/hdmiphy_drv.c
diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
similarity index 100%
rename from drivers/media/video/s5p-tv/mixer.h
rename to drivers/media/platform/s5p-tv/mixer.h
diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
similarity index 100%
rename from drivers/media/video/s5p-tv/mixer_drv.c
rename to drivers/media/platform/s5p-tv/mixer_drv.c
diff --git a/drivers/media/video/s5p-tv/mixer_grp_layer.c b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
similarity index 100%
rename from drivers/media/video/s5p-tv/mixer_grp_layer.c
rename to drivers/media/platform/s5p-tv/mixer_grp_layer.c
diff --git a/drivers/media/video/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
similarity index 100%
rename from drivers/media/video/s5p-tv/mixer_reg.c
rename to drivers/media/platform/s5p-tv/mixer_reg.c
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
similarity index 100%
rename from drivers/media/video/s5p-tv/mixer_video.c
rename to drivers/media/platform/s5p-tv/mixer_video.c
diff --git a/drivers/media/video/s5p-tv/mixer_vp_layer.c b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
similarity index 100%
rename from drivers/media/video/s5p-tv/mixer_vp_layer.c
rename to drivers/media/platform/s5p-tv/mixer_vp_layer.c
diff --git a/drivers/media/video/s5p-tv/regs-hdmi.h b/drivers/media/platform/s5p-tv/regs-hdmi.h
similarity index 100%
rename from drivers/media/video/s5p-tv/regs-hdmi.h
rename to drivers/media/platform/s5p-tv/regs-hdmi.h
diff --git a/drivers/media/video/s5p-tv/regs-mixer.h b/drivers/media/platform/s5p-tv/regs-mixer.h
similarity index 100%
rename from drivers/media/video/s5p-tv/regs-mixer.h
rename to drivers/media/platform/s5p-tv/regs-mixer.h
diff --git a/drivers/media/video/s5p-tv/regs-sdo.h b/drivers/media/platform/s5p-tv/regs-sdo.h
similarity index 97%
rename from drivers/media/video/s5p-tv/regs-sdo.h
rename to drivers/media/platform/s5p-tv/regs-sdo.h
index 7f7c2b8..6f22fbf 100644
--- a/drivers/media/video/s5p-tv/regs-sdo.h
+++ b/drivers/media/platform/s5p-tv/regs-sdo.h
@@ -1,4 +1,4 @@
-/* drivers/media/video/s5p-tv/regs-sdo.h
+/* drivers/media/platform/s5p-tv/regs-sdo.h
  *
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/media/video/s5p-tv/regs-vp.h b/drivers/media/platform/s5p-tv/regs-vp.h
similarity index 100%
rename from drivers/media/video/s5p-tv/regs-vp.h
rename to drivers/media/platform/s5p-tv/regs-vp.h
diff --git a/drivers/media/video/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
similarity index 100%
rename from drivers/media/video/s5p-tv/sdo_drv.c
rename to drivers/media/platform/s5p-tv/sdo_drv.c
diff --git a/drivers/media/video/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
similarity index 100%
rename from drivers/media/video/s5p-tv/sii9234_drv.c
rename to drivers/media/platform/s5p-tv/sii9234_drv.c
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/platform/sh_mobile_ceu_camera.c
similarity index 100%
rename from drivers/media/video/sh_mobile_ceu_camera.c
rename to drivers/media/platform/sh_mobile_ceu_camera.c
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/platform/sh_vou.c
similarity index 100%
rename from drivers/media/video/sh_vou.c
rename to drivers/media/platform/sh_vou.c
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/platform/soc_camera.c
similarity index 100%
rename from drivers/media/video/soc_camera.c
rename to drivers/media/platform/soc_camera.c
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/platform/soc_camera_platform.c
similarity index 100%
rename from drivers/media/video/soc_camera_platform.c
rename to drivers/media/platform/soc_camera_platform.c
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/platform/soc_mediabus.c
similarity index 100%
rename from drivers/media/video/soc_mediabus.c
rename to drivers/media/platform/soc_mediabus.c
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/platform/timblogiw.c
similarity index 100%
rename from drivers/media/video/timblogiw.c
rename to drivers/media/platform/timblogiw.c
diff --git a/drivers/media/video/via-camera.c b/drivers/media/platform/via-camera.c
similarity index 100%
rename from drivers/media/video/via-camera.c
rename to drivers/media/platform/via-camera.c
diff --git a/drivers/media/video/via-camera.h b/drivers/media/platform/via-camera.h
similarity index 100%
rename from drivers/media/video/via-camera.h
rename to drivers/media/platform/via-camera.h
diff --git a/drivers/media/video/vino.c b/drivers/media/platform/vino.c
similarity index 100%
rename from drivers/media/video/vino.c
rename to drivers/media/platform/vino.c
diff --git a/drivers/media/video/vino.h b/drivers/media/platform/vino.h
similarity index 100%
rename from drivers/media/video/vino.h
rename to drivers/media/platform/vino.h
diff --git a/drivers/media/video/vivi.c b/drivers/media/platform/vivi.c
similarity index 100%
rename from drivers/media/video/vivi.c
rename to drivers/media/platform/vivi.c
-- 
1.7.11.2

