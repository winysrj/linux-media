Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:62341 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab2KNSB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 13:01:29 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so575247lag.19
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 10:01:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352760432-7194-1-git-send-email-sakari.ailus@iki.fi>
References: <20121112224655.GP25623@valkosipuli.retiisi.org.uk>
	<1352760432-7194-1-git-send-email-sakari.ailus@iki.fi>
Date: Wed, 14 Nov 2012 10:01:27 -0800
Message-ID: <CAPqfFkACqV4+d1VMrD9xSxis3oMJkdm=qEg7BLRoUqd7tW+X3Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] omap24xxcam: Remove driver
From: David Cohen <dacohen@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 12, 2012 at 2:47 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Remove the driver for omap24xxcam. It uses the obsolete V4L2 int device
> framework and does not even work.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Cool! R.I.P. omap24xxcam driver.

Acked-by: David Cohen <dacohen@gmail.com>

> ---
>  drivers/media/platform/Kconfig           |    7 -
>  drivers/media/platform/Makefile          |    3 -
>  drivers/media/platform/omap24xxcam-dma.c |  601 ----------
>  drivers/media/platform/omap24xxcam.c     | 1881 ------------------------------
>  drivers/media/platform/omap24xxcam.h     |  593 ----------
>  5 files changed, 0 insertions(+), 3085 deletions(-)
>  delete mode 100644 drivers/media/platform/omap24xxcam-dma.c
>  delete mode 100644 drivers/media/platform/omap24xxcam.c
>  delete mode 100644 drivers/media/platform/omap24xxcam.h
>
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 181c768..36bcad3 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -90,13 +90,6 @@ config VIDEO_M32R_AR_M64278
>           To compile this driver as a module, choose M here: the
>           module will be called arv.
>
> -config VIDEO_OMAP2
> -       tristate "OMAP2 Camera Capture Interface driver"
> -       depends on VIDEO_DEV && ARCH_OMAP2
> -       select VIDEOBUF_DMA_SG
> -       ---help---
> -         This is a v4l2 driver for the TI OMAP2 camera capture interface
> -
>  config VIDEO_OMAP3
>         tristate "OMAP 3 Camera support (EXPERIMENTAL)"
>         depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3 && EXPERIMENTAL
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index baaa550..7228278 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -2,8 +2,6 @@
>  # Makefile for the video capture/playback device drivers.
>  #
>
> -omap2cam-objs  :=      omap24xxcam.o omap24xxcam-dma.o
> -
>  obj-$(CONFIG_VIDEO_VINO) += indycam.o
>  obj-$(CONFIG_VIDEO_VINO) += vino.o
>
> @@ -14,7 +12,6 @@ obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
>  obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
>  obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
>
> -obj-$(CONFIG_VIDEO_OMAP2)              += omap2cam.o
>  obj-$(CONFIG_VIDEO_OMAP3)      += omap3isp/
>
>  obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
> diff --git a/drivers/media/platform/omap24xxcam-dma.c b/drivers/media/platform/omap24xxcam-dma.c
> deleted file mode 100644
> index 9c00776..0000000
> --- a/drivers/media/platform/omap24xxcam-dma.c
> +++ /dev/null
> @@ -1,601 +0,0 @@
> -/*
> - * drivers/media/platform/omap24xxcam-dma.c
> - *
> - * Copyright (C) 2004 MontaVista Software, Inc.
> - * Copyright (C) 2004 Texas Instruments.
> - * Copyright (C) 2007 Nokia Corporation.
> - *
> - * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> - *
> - * Based on code from Andy Lowe <source@mvista.com> and
> - *                    David Cohen <david.cohen@indt.org.br>.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * version 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> - * 02110-1301 USA
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/io.h>
> -#include <linux/scatterlist.h>
> -
> -#include "omap24xxcam.h"
> -
> -/*
> - *
> - * DMA hardware.
> - *
> - */
> -
> -/* Ack all interrupt on CSR and IRQSTATUS_L0 */
> -static void omap24xxcam_dmahw_ack_all(void __iomem *base)
> -{
> -       u32 csr;
> -       int i;
> -
> -       for (i = 0; i < NUM_CAMDMA_CHANNELS; ++i) {
> -               csr = omap24xxcam_reg_in(base, CAMDMA_CSR(i));
> -               /* ack interrupt in CSR */
> -               omap24xxcam_reg_out(base, CAMDMA_CSR(i), csr);
> -       }
> -       omap24xxcam_reg_out(base, CAMDMA_IRQSTATUS_L0, 0xf);
> -}
> -
> -/* Ack dmach on CSR and IRQSTATUS_L0 */
> -static u32 omap24xxcam_dmahw_ack_ch(void __iomem *base, int dmach)
> -{
> -       u32 csr;
> -
> -       csr = omap24xxcam_reg_in(base, CAMDMA_CSR(dmach));
> -       /* ack interrupt in CSR */
> -       omap24xxcam_reg_out(base, CAMDMA_CSR(dmach), csr);
> -       /* ack interrupt in IRQSTATUS */
> -       omap24xxcam_reg_out(base, CAMDMA_IRQSTATUS_L0, (1 << dmach));
> -
> -       return csr;
> -}
> -
> -static int omap24xxcam_dmahw_running(void __iomem *base, int dmach)
> -{
> -       return omap24xxcam_reg_in(base, CAMDMA_CCR(dmach)) & CAMDMA_CCR_ENABLE;
> -}
> -
> -static void omap24xxcam_dmahw_transfer_setup(void __iomem *base, int dmach,
> -                                            dma_addr_t start, u32 len)
> -{
> -       omap24xxcam_reg_out(base, CAMDMA_CCR(dmach),
> -                           CAMDMA_CCR_SEL_SRC_DST_SYNC
> -                           | CAMDMA_CCR_BS
> -                           | CAMDMA_CCR_DST_AMODE_POST_INC
> -                           | CAMDMA_CCR_SRC_AMODE_POST_INC
> -                           | CAMDMA_CCR_FS
> -                           | CAMDMA_CCR_WR_ACTIVE
> -                           | CAMDMA_CCR_RD_ACTIVE
> -                           | CAMDMA_CCR_SYNCHRO_CAMERA);
> -       omap24xxcam_reg_out(base, CAMDMA_CLNK_CTRL(dmach), 0);
> -       omap24xxcam_reg_out(base, CAMDMA_CEN(dmach), len);
> -       omap24xxcam_reg_out(base, CAMDMA_CFN(dmach), 1);
> -       omap24xxcam_reg_out(base, CAMDMA_CSDP(dmach),
> -                           CAMDMA_CSDP_WRITE_MODE_POSTED
> -                           | CAMDMA_CSDP_DST_BURST_EN_32
> -                           | CAMDMA_CSDP_DST_PACKED
> -                           | CAMDMA_CSDP_SRC_BURST_EN_32
> -                           | CAMDMA_CSDP_SRC_PACKED
> -                           | CAMDMA_CSDP_DATA_TYPE_8BITS);
> -       omap24xxcam_reg_out(base, CAMDMA_CSSA(dmach), 0);
> -       omap24xxcam_reg_out(base, CAMDMA_CDSA(dmach), start);
> -       omap24xxcam_reg_out(base, CAMDMA_CSEI(dmach), 0);
> -       omap24xxcam_reg_out(base, CAMDMA_CSFI(dmach), DMA_THRESHOLD);
> -       omap24xxcam_reg_out(base, CAMDMA_CDEI(dmach), 0);
> -       omap24xxcam_reg_out(base, CAMDMA_CDFI(dmach), 0);
> -       omap24xxcam_reg_out(base, CAMDMA_CSR(dmach),
> -                           CAMDMA_CSR_MISALIGNED_ERR
> -                           | CAMDMA_CSR_SECURE_ERR
> -                           | CAMDMA_CSR_TRANS_ERR
> -                           | CAMDMA_CSR_BLOCK
> -                           | CAMDMA_CSR_DROP);
> -       omap24xxcam_reg_out(base, CAMDMA_CICR(dmach),
> -                           CAMDMA_CICR_MISALIGNED_ERR_IE
> -                           | CAMDMA_CICR_SECURE_ERR_IE
> -                           | CAMDMA_CICR_TRANS_ERR_IE
> -                           | CAMDMA_CICR_BLOCK_IE
> -                           | CAMDMA_CICR_DROP_IE);
> -}
> -
> -static void omap24xxcam_dmahw_transfer_start(void __iomem *base, int dmach)
> -{
> -       omap24xxcam_reg_out(base, CAMDMA_CCR(dmach),
> -                           CAMDMA_CCR_SEL_SRC_DST_SYNC
> -                           | CAMDMA_CCR_BS
> -                           | CAMDMA_CCR_DST_AMODE_POST_INC
> -                           | CAMDMA_CCR_SRC_AMODE_POST_INC
> -                           | CAMDMA_CCR_ENABLE
> -                           | CAMDMA_CCR_FS
> -                           | CAMDMA_CCR_SYNCHRO_CAMERA);
> -}
> -
> -static void omap24xxcam_dmahw_transfer_chain(void __iomem *base, int dmach,
> -                                            int free_dmach)
> -{
> -       int prev_dmach, ch;
> -
> -       if (dmach == 0)
> -               prev_dmach = NUM_CAMDMA_CHANNELS - 1;
> -       else
> -               prev_dmach = dmach - 1;
> -       omap24xxcam_reg_out(base, CAMDMA_CLNK_CTRL(prev_dmach),
> -                           CAMDMA_CLNK_CTRL_ENABLE_LNK | dmach);
> -       /* Did we chain the DMA transfer before the previous one
> -        * finished?
> -        */
> -       ch = (dmach + free_dmach) % NUM_CAMDMA_CHANNELS;
> -       while (!(omap24xxcam_reg_in(base, CAMDMA_CCR(ch))
> -                & CAMDMA_CCR_ENABLE)) {
> -               if (ch == dmach) {
> -                       /* The previous transfer has ended and this one
> -                        * hasn't started, so we must not have chained
> -                        * to the previous one in time.  We'll have to
> -                        * start it now.
> -                        */
> -                       omap24xxcam_dmahw_transfer_start(base, dmach);
> -                       break;
> -               } else
> -                       ch = (ch + 1) % NUM_CAMDMA_CHANNELS;
> -       }
> -}
> -
> -/* Abort all chained DMA transfers. After all transfers have been
> - * aborted and the DMA controller is idle, the completion routines for
> - * any aborted transfers will be called in sequence. The DMA
> - * controller may not be idle after this routine completes, because
> - * the completion routines might start new transfers.
> - */
> -static void omap24xxcam_dmahw_abort_ch(void __iomem *base, int dmach)
> -{
> -       /* mask all interrupts from this channel */
> -       omap24xxcam_reg_out(base, CAMDMA_CICR(dmach), 0);
> -       /* unlink this channel */
> -       omap24xxcam_reg_merge(base, CAMDMA_CLNK_CTRL(dmach), 0,
> -                             CAMDMA_CLNK_CTRL_ENABLE_LNK);
> -       /* disable this channel */
> -       omap24xxcam_reg_merge(base, CAMDMA_CCR(dmach), 0, CAMDMA_CCR_ENABLE);
> -}
> -
> -static void omap24xxcam_dmahw_init(void __iomem *base)
> -{
> -       omap24xxcam_reg_out(base, CAMDMA_OCP_SYSCONFIG,
> -                           CAMDMA_OCP_SYSCONFIG_MIDLEMODE_FSTANDBY
> -                           | CAMDMA_OCP_SYSCONFIG_SIDLEMODE_FIDLE
> -                           | CAMDMA_OCP_SYSCONFIG_AUTOIDLE);
> -
> -       omap24xxcam_reg_merge(base, CAMDMA_GCR, 0x10,
> -                             CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH);
> -
> -       omap24xxcam_reg_out(base, CAMDMA_IRQENABLE_L0, 0xf);
> -}
> -
> -/*
> - *
> - * Individual DMA channel handling.
> - *
> - */
> -
> -/* Start a DMA transfer from the camera to memory.
> - * Returns zero if the transfer was successfully started, or non-zero if all
> - * DMA channels are already in use or starting is currently inhibited.
> - */
> -static int omap24xxcam_dma_start(struct omap24xxcam_dma *dma, dma_addr_t start,
> -                                u32 len, dma_callback_t callback, void *arg)
> -{
> -       unsigned long flags;
> -       int dmach;
> -
> -       spin_lock_irqsave(&dma->lock, flags);
> -
> -       if (!dma->free_dmach || atomic_read(&dma->dma_stop)) {
> -               spin_unlock_irqrestore(&dma->lock, flags);
> -               return -EBUSY;
> -       }
> -
> -       dmach = dma->next_dmach;
> -
> -       dma->ch_state[dmach].callback = callback;
> -       dma->ch_state[dmach].arg = arg;
> -
> -       omap24xxcam_dmahw_transfer_setup(dma->base, dmach, start, len);
> -
> -       /* We're ready to start the DMA transfer. */
> -
> -       if (dma->free_dmach < NUM_CAMDMA_CHANNELS) {
> -               /* A transfer is already in progress, so try to chain to it. */
> -               omap24xxcam_dmahw_transfer_chain(dma->base, dmach,
> -                                                dma->free_dmach);
> -       } else {
> -               /* No transfer is in progress, so we'll just start this one
> -                * now.
> -                */
> -               omap24xxcam_dmahw_transfer_start(dma->base, dmach);
> -       }
> -
> -       dma->next_dmach = (dma->next_dmach + 1) % NUM_CAMDMA_CHANNELS;
> -       dma->free_dmach--;
> -
> -       spin_unlock_irqrestore(&dma->lock, flags);
> -
> -       return 0;
> -}
> -
> -/* Abort all chained DMA transfers. After all transfers have been
> - * aborted and the DMA controller is idle, the completion routines for
> - * any aborted transfers will be called in sequence. The DMA
> - * controller may not be idle after this routine completes, because
> - * the completion routines might start new transfers.
> - */
> -static void omap24xxcam_dma_abort(struct omap24xxcam_dma *dma, u32 csr)
> -{
> -       unsigned long flags;
> -       int dmach, i, free_dmach;
> -       dma_callback_t callback;
> -       void *arg;
> -
> -       spin_lock_irqsave(&dma->lock, flags);
> -
> -       /* stop any DMA transfers in progress */
> -       dmach = (dma->next_dmach + dma->free_dmach) % NUM_CAMDMA_CHANNELS;
> -       for (i = 0; i < NUM_CAMDMA_CHANNELS; i++) {
> -               omap24xxcam_dmahw_abort_ch(dma->base, dmach);
> -               dmach = (dmach + 1) % NUM_CAMDMA_CHANNELS;
> -       }
> -
> -       /* We have to be careful here because the callback routine
> -        * might start a new DMA transfer, and we only want to abort
> -        * transfers that were started before this routine was called.
> -        */
> -       free_dmach = dma->free_dmach;
> -       while ((dma->free_dmach < NUM_CAMDMA_CHANNELS) &&
> -              (free_dmach < NUM_CAMDMA_CHANNELS)) {
> -               dmach = (dma->next_dmach + dma->free_dmach)
> -                       % NUM_CAMDMA_CHANNELS;
> -               callback = dma->ch_state[dmach].callback;
> -               arg = dma->ch_state[dmach].arg;
> -               dma->free_dmach++;
> -               free_dmach++;
> -               if (callback) {
> -                       /* leave interrupts disabled during callback */
> -                       spin_unlock(&dma->lock);
> -                       (*callback) (dma, csr, arg);
> -                       spin_lock(&dma->lock);
> -               }
> -       }
> -
> -       spin_unlock_irqrestore(&dma->lock, flags);
> -}
> -
> -/* Abort all chained DMA transfers. After all transfers have been
> - * aborted and the DMA controller is idle, the completion routines for
> - * any aborted transfers will be called in sequence. If the completion
> - * routines attempt to start a new DMA transfer it will fail, so the
> - * DMA controller will be idle after this routine completes.
> - */
> -static void omap24xxcam_dma_stop(struct omap24xxcam_dma *dma, u32 csr)
> -{
> -       atomic_inc(&dma->dma_stop);
> -       omap24xxcam_dma_abort(dma, csr);
> -       atomic_dec(&dma->dma_stop);
> -}
> -
> -/* Camera DMA interrupt service routine. */
> -void omap24xxcam_dma_isr(struct omap24xxcam_dma *dma)
> -{
> -       int dmach;
> -       dma_callback_t callback;
> -       void *arg;
> -       u32 csr;
> -       const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
> -               | CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
> -               | CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
> -
> -       spin_lock(&dma->lock);
> -
> -       if (dma->free_dmach == NUM_CAMDMA_CHANNELS) {
> -               /* A camera DMA interrupt occurred while all channels
> -                * are idle, so we'll acknowledge the interrupt in the
> -                * IRQSTATUS register and exit.
> -                */
> -               omap24xxcam_dmahw_ack_all(dma->base);
> -               spin_unlock(&dma->lock);
> -               return;
> -       }
> -
> -       while (dma->free_dmach < NUM_CAMDMA_CHANNELS) {
> -               dmach = (dma->next_dmach + dma->free_dmach)
> -                       % NUM_CAMDMA_CHANNELS;
> -               if (omap24xxcam_dmahw_running(dma->base, dmach)) {
> -                       /* This buffer hasn't finished yet, so we're done. */
> -                       break;
> -               }
> -               csr = omap24xxcam_dmahw_ack_ch(dma->base, dmach);
> -               if (csr & csr_error) {
> -                       /* A DMA error occurred, so stop all DMA
> -                        * transfers in progress.
> -                        */
> -                       spin_unlock(&dma->lock);
> -                       omap24xxcam_dma_stop(dma, csr);
> -                       return;
> -               } else {
> -                       callback = dma->ch_state[dmach].callback;
> -                       arg = dma->ch_state[dmach].arg;
> -                       dma->free_dmach++;
> -                       if (callback) {
> -                               spin_unlock(&dma->lock);
> -                               (*callback) (dma, csr, arg);
> -                               spin_lock(&dma->lock);
> -                       }
> -               }
> -       }
> -
> -       spin_unlock(&dma->lock);
> -
> -       omap24xxcam_sgdma_process(
> -               container_of(dma, struct omap24xxcam_sgdma, dma));
> -}
> -
> -void omap24xxcam_dma_hwinit(struct omap24xxcam_dma *dma)
> -{
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&dma->lock, flags);
> -
> -       omap24xxcam_dmahw_init(dma->base);
> -
> -       spin_unlock_irqrestore(&dma->lock, flags);
> -}
> -
> -static void omap24xxcam_dma_init(struct omap24xxcam_dma *dma,
> -                                void __iomem *base)
> -{
> -       int ch;
> -
> -       /* group all channels on DMA IRQ0 and unmask irq */
> -       spin_lock_init(&dma->lock);
> -       dma->base = base;
> -       dma->free_dmach = NUM_CAMDMA_CHANNELS;
> -       dma->next_dmach = 0;
> -       for (ch = 0; ch < NUM_CAMDMA_CHANNELS; ch++) {
> -               dma->ch_state[ch].callback = NULL;
> -               dma->ch_state[ch].arg = NULL;
> -       }
> -}
> -
> -/*
> - *
> - * Scatter-gather DMA.
> - *
> - * High-level DMA construct for transferring whole picture frames to
> - * memory that is discontinuous.
> - *
> - */
> -
> -/* DMA completion routine for the scatter-gather DMA fragments. */
> -static void omap24xxcam_sgdma_callback(struct omap24xxcam_dma *dma, u32 csr,
> -                                      void *arg)
> -{
> -       struct omap24xxcam_sgdma *sgdma =
> -               container_of(dma, struct omap24xxcam_sgdma, dma);
> -       int sgslot = (int)arg;
> -       struct sgdma_state *sg_state;
> -       const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
> -               | CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
> -               | CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
> -
> -       spin_lock(&sgdma->lock);
> -
> -       /* We got an interrupt, we can remove the timer */
> -       del_timer(&sgdma->reset_timer);
> -
> -       sg_state = sgdma->sg_state + sgslot;
> -       if (!sg_state->queued_sglist) {
> -               spin_unlock(&sgdma->lock);
> -               printk(KERN_ERR "%s: sgdma completed when none queued!\n",
> -                      __func__);
> -               return;
> -       }
> -
> -       sg_state->csr |= csr;
> -       if (!--sg_state->queued_sglist) {
> -               /* Queue for this sglist is empty, so check to see if we're
> -                * done.
> -                */
> -               if ((sg_state->next_sglist == sg_state->sglen)
> -                   || (sg_state->csr & csr_error)) {
> -                       sgdma_callback_t callback = sg_state->callback;
> -                       void *arg = sg_state->arg;
> -                       u32 sg_csr = sg_state->csr;
> -                       /* All done with this sglist */
> -                       sgdma->free_sgdma++;
> -                       if (callback) {
> -                               spin_unlock(&sgdma->lock);
> -                               (*callback) (sgdma, sg_csr, arg);
> -                               return;
> -                       }
> -               }
> -       }
> -
> -       spin_unlock(&sgdma->lock);
> -}
> -
> -/* Start queued scatter-gather DMA transfers. */
> -void omap24xxcam_sgdma_process(struct omap24xxcam_sgdma *sgdma)
> -{
> -       unsigned long flags;
> -       int queued_sgdma, sgslot;
> -       struct sgdma_state *sg_state;
> -       const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
> -               | CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
> -               | CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
> -
> -       spin_lock_irqsave(&sgdma->lock, flags);
> -
> -       queued_sgdma = NUM_SG_DMA - sgdma->free_sgdma;
> -       sgslot = (sgdma->next_sgdma + sgdma->free_sgdma) % NUM_SG_DMA;
> -       while (queued_sgdma > 0) {
> -               sg_state = sgdma->sg_state + sgslot;
> -               while ((sg_state->next_sglist < sg_state->sglen) &&
> -                      !(sg_state->csr & csr_error)) {
> -                       const struct scatterlist *sglist;
> -                       unsigned int len;
> -
> -                       sglist = sg_state->sglist + sg_state->next_sglist;
> -                       /* try to start the next DMA transfer */
> -                       if (sg_state->next_sglist + 1 == sg_state->sglen) {
> -                               /*
> -                                *  On the last sg, we handle the case where
> -                                *  cam->img.pix.sizeimage % PAGE_ALIGN != 0
> -                                */
> -                               len = sg_state->len - sg_state->bytes_read;
> -                       } else {
> -                               len = sg_dma_len(sglist);
> -                       }
> -
> -                       if (omap24xxcam_dma_start(&sgdma->dma,
> -                                                 sg_dma_address(sglist),
> -                                                 len,
> -                                                 omap24xxcam_sgdma_callback,
> -                                                 (void *)sgslot)) {
> -                               /* DMA start failed */
> -                               spin_unlock_irqrestore(&sgdma->lock, flags);
> -                               return;
> -                       } else {
> -                               unsigned long expires;
> -                               /* DMA start was successful */
> -                               sg_state->next_sglist++;
> -                               sg_state->bytes_read += len;
> -                               sg_state->queued_sglist++;
> -
> -                               /* We start the reset timer */
> -                               expires = jiffies + HZ;
> -                               mod_timer(&sgdma->reset_timer, expires);
> -                       }
> -               }
> -               queued_sgdma--;
> -               sgslot = (sgslot + 1) % NUM_SG_DMA;
> -       }
> -
> -       spin_unlock_irqrestore(&sgdma->lock, flags);
> -}
> -
> -/*
> - * Queue a scatter-gather DMA transfer from the camera to memory.
> - * Returns zero if the transfer was successfully queued, or non-zero
> - * if all of the scatter-gather slots are already in use.
> - */
> -int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
> -                           const struct scatterlist *sglist, int sglen,
> -                           int len, sgdma_callback_t callback, void *arg)
> -{
> -       unsigned long flags;
> -       struct sgdma_state *sg_state;
> -
> -       if ((sglen < 0) || ((sglen > 0) && !sglist))
> -               return -EINVAL;
> -
> -       spin_lock_irqsave(&sgdma->lock, flags);
> -
> -       if (!sgdma->free_sgdma) {
> -               spin_unlock_irqrestore(&sgdma->lock, flags);
> -               return -EBUSY;
> -       }
> -
> -       sg_state = sgdma->sg_state + sgdma->next_sgdma;
> -
> -       sg_state->sglist = sglist;
> -       sg_state->sglen = sglen;
> -       sg_state->next_sglist = 0;
> -       sg_state->bytes_read = 0;
> -       sg_state->len = len;
> -       sg_state->queued_sglist = 0;
> -       sg_state->csr = 0;
> -       sg_state->callback = callback;
> -       sg_state->arg = arg;
> -
> -       sgdma->next_sgdma = (sgdma->next_sgdma + 1) % NUM_SG_DMA;
> -       sgdma->free_sgdma--;
> -
> -       spin_unlock_irqrestore(&sgdma->lock, flags);
> -
> -       omap24xxcam_sgdma_process(sgdma);
> -
> -       return 0;
> -}
> -
> -/* Sync scatter-gather DMA by aborting any DMA transfers currently in progress.
> - * Any queued scatter-gather DMA transactions that have not yet been started
> - * will remain queued.  The DMA controller will be idle after this routine
> - * completes.  When the scatter-gather queue is restarted, the next
> - * scatter-gather DMA transfer will begin at the start of a new transaction.
> - */
> -void omap24xxcam_sgdma_sync(struct omap24xxcam_sgdma *sgdma)
> -{
> -       unsigned long flags;
> -       int sgslot;
> -       struct sgdma_state *sg_state;
> -       u32 csr = CAMDMA_CSR_TRANS_ERR;
> -
> -       /* stop any DMA transfers in progress */
> -       omap24xxcam_dma_stop(&sgdma->dma, csr);
> -
> -       spin_lock_irqsave(&sgdma->lock, flags);
> -
> -       if (sgdma->free_sgdma < NUM_SG_DMA) {
> -               sgslot = (sgdma->next_sgdma + sgdma->free_sgdma) % NUM_SG_DMA;
> -               sg_state = sgdma->sg_state + sgslot;
> -               if (sg_state->next_sglist != 0) {
> -                       /* This DMA transfer was in progress, so abort it. */
> -                       sgdma_callback_t callback = sg_state->callback;
> -                       void *arg = sg_state->arg;
> -                       sgdma->free_sgdma++;
> -                       if (callback) {
> -                               /* leave interrupts masked */
> -                               spin_unlock(&sgdma->lock);
> -                               (*callback) (sgdma, csr, arg);
> -                               spin_lock(&sgdma->lock);
> -                       }
> -               }
> -       }
> -
> -       spin_unlock_irqrestore(&sgdma->lock, flags);
> -}
> -
> -void omap24xxcam_sgdma_init(struct omap24xxcam_sgdma *sgdma,
> -                           void __iomem *base,
> -                           void (*reset_callback)(unsigned long data),
> -                           unsigned long reset_callback_data)
> -{
> -       int sg;
> -
> -       spin_lock_init(&sgdma->lock);
> -       sgdma->free_sgdma = NUM_SG_DMA;
> -       sgdma->next_sgdma = 0;
> -       for (sg = 0; sg < NUM_SG_DMA; sg++) {
> -               sgdma->sg_state[sg].sglen = 0;
> -               sgdma->sg_state[sg].next_sglist = 0;
> -               sgdma->sg_state[sg].bytes_read = 0;
> -               sgdma->sg_state[sg].queued_sglist = 0;
> -               sgdma->sg_state[sg].csr = 0;
> -               sgdma->sg_state[sg].callback = NULL;
> -               sgdma->sg_state[sg].arg = NULL;
> -       }
> -
> -       omap24xxcam_dma_init(&sgdma->dma, base);
> -       setup_timer(&sgdma->reset_timer, reset_callback, reset_callback_data);
> -}
> diff --git a/drivers/media/platform/omap24xxcam.c b/drivers/media/platform/omap24xxcam.c
> deleted file mode 100644
> index 70f45c3..0000000
> --- a/drivers/media/platform/omap24xxcam.c
> +++ /dev/null
> @@ -1,1881 +0,0 @@
> -/*
> - * drivers/media/platform/omap24xxcam.c
> - *
> - * OMAP 2 camera block driver.
> - *
> - * Copyright (C) 2004 MontaVista Software, Inc.
> - * Copyright (C) 2004 Texas Instruments.
> - * Copyright (C) 2007-2008 Nokia Corporation.
> - *
> - * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> - *
> - * Based on code from Andy Lowe <source@mvista.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * version 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> - * 02110-1301 USA
> - */
> -
> -#include <linux/delay.h>
> -#include <linux/kernel.h>
> -#include <linux/interrupt.h>
> -#include <linux/videodev2.h>
> -#include <linux/pci.h>         /* needed for videobufs */
> -#include <linux/platform_device.h>
> -#include <linux/clk.h>
> -#include <linux/io.h>
> -#include <linux/slab.h>
> -#include <linux/sched.h>
> -#include <linux/module.h>
> -
> -#include <media/v4l2-common.h>
> -#include <media/v4l2-ioctl.h>
> -
> -#include "omap24xxcam.h"
> -
> -#define OMAP24XXCAM_VERSION "0.0.1"
> -
> -#define RESET_TIMEOUT_NS 10000
> -
> -static void omap24xxcam_reset(struct omap24xxcam_device *cam);
> -static int omap24xxcam_sensor_if_enable(struct omap24xxcam_device *cam);
> -static void omap24xxcam_device_unregister(struct v4l2_int_device *s);
> -static int omap24xxcam_remove(struct platform_device *pdev);
> -
> -/* module parameters */
> -static int video_nr = -1;      /* video device minor (-1 ==> auto assign) */
> -/*
> - * Maximum amount of memory to use for capture buffers.
> - * Default is 4800KB, enough to double-buffer SXGA.
> - */
> -static int capture_mem = 1280 * 960 * 2 * 2;
> -
> -static struct v4l2_int_device omap24xxcam;
> -
> -/*
> - *
> - * Clocks.
> - *
> - */
> -
> -static void omap24xxcam_clock_put(struct omap24xxcam_device *cam)
> -{
> -       if (cam->ick != NULL && !IS_ERR(cam->ick))
> -               clk_put(cam->ick);
> -       if (cam->fck != NULL && !IS_ERR(cam->fck))
> -               clk_put(cam->fck);
> -
> -       cam->ick = cam->fck = NULL;
> -}
> -
> -static int omap24xxcam_clock_get(struct omap24xxcam_device *cam)
> -{
> -       int rval = 0;
> -
> -       cam->fck = clk_get(cam->dev, "fck");
> -       if (IS_ERR(cam->fck)) {
> -               dev_err(cam->dev, "can't get camera fck");
> -               rval = PTR_ERR(cam->fck);
> -               omap24xxcam_clock_put(cam);
> -               return rval;
> -       }
> -
> -       cam->ick = clk_get(cam->dev, "ick");
> -       if (IS_ERR(cam->ick)) {
> -               dev_err(cam->dev, "can't get camera ick");
> -               rval = PTR_ERR(cam->ick);
> -               omap24xxcam_clock_put(cam);
> -       }
> -
> -       return rval;
> -}
> -
> -static void omap24xxcam_clock_on(struct omap24xxcam_device *cam)
> -{
> -       clk_enable(cam->fck);
> -       clk_enable(cam->ick);
> -}
> -
> -static void omap24xxcam_clock_off(struct omap24xxcam_device *cam)
> -{
> -       clk_disable(cam->fck);
> -       clk_disable(cam->ick);
> -}
> -
> -/*
> - *
> - * Camera core
> - *
> - */
> -
> -/*
> - * Set xclk.
> - *
> - * To disable xclk, use value zero.
> - */
> -static void omap24xxcam_core_xclk_set(const struct omap24xxcam_device *cam,
> -                                     u32 xclk)
> -{
> -       if (xclk) {
> -               u32 divisor = CAM_MCLK / xclk;
> -
> -               if (divisor == 1)
> -                       omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
> -                                           CC_CTRL_XCLK,
> -                                           CC_CTRL_XCLK_DIV_BYPASS);
> -               else
> -                       omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
> -                                           CC_CTRL_XCLK, divisor);
> -       } else
> -               omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
> -                                   CC_CTRL_XCLK, CC_CTRL_XCLK_DIV_STABLE_LOW);
> -}
> -
> -static void omap24xxcam_core_hwinit(const struct omap24xxcam_device *cam)
> -{
> -       /*
> -        * Setting the camera core AUTOIDLE bit causes problems with frame
> -        * synchronization, so we will clear the AUTOIDLE bit instead.
> -        */
> -       omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_SYSCONFIG,
> -                           CC_SYSCONFIG_AUTOIDLE);
> -
> -       /* program the camera interface DMA packet size */
> -       omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL_DMA,
> -                           CC_CTRL_DMA_EN | (DMA_THRESHOLD / 4 - 1));
> -
> -       /* enable camera core error interrupts */
> -       omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_IRQENABLE,
> -                           CC_IRQENABLE_FW_ERR_IRQ
> -                           | CC_IRQENABLE_FSC_ERR_IRQ
> -                           | CC_IRQENABLE_SSC_ERR_IRQ
> -                           | CC_IRQENABLE_FIFO_OF_IRQ);
> -}
> -
> -/*
> - * Enable the camera core.
> - *
> - * Data transfer to the camera DMA starts from next starting frame.
> - */
> -static void omap24xxcam_core_enable(const struct omap24xxcam_device *cam)
> -{
> -
> -       omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL,
> -                           cam->cc_ctrl);
> -}
> -
> -/*
> - * Disable camera core.
> - *
> - * The data transfer will be stopped immediately (CC_CTRL_CC_RST). The
> - * core internal state machines will be reset. Use
> - * CC_CTRL_CC_FRAME_TRIG instead if you want to transfer the current
> - * frame completely.
> - */
> -static void omap24xxcam_core_disable(const struct omap24xxcam_device *cam)
> -{
> -       omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL,
> -                           CC_CTRL_CC_RST);
> -}
> -
> -/* Interrupt service routine for camera core interrupts. */
> -static void omap24xxcam_core_isr(struct omap24xxcam_device *cam)
> -{
> -       u32 cc_irqstatus;
> -       const u32 cc_irqstatus_err =
> -               CC_IRQSTATUS_FW_ERR_IRQ
> -               | CC_IRQSTATUS_FSC_ERR_IRQ
> -               | CC_IRQSTATUS_SSC_ERR_IRQ
> -               | CC_IRQSTATUS_FIFO_UF_IRQ
> -               | CC_IRQSTATUS_FIFO_OF_IRQ;
> -
> -       cc_irqstatus = omap24xxcam_reg_in(cam->mmio_base + CC_REG_OFFSET,
> -                                         CC_IRQSTATUS);
> -       omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_IRQSTATUS,
> -                           cc_irqstatus);
> -
> -       if (cc_irqstatus & cc_irqstatus_err
> -           && !atomic_read(&cam->in_reset)) {
> -               dev_dbg(cam->dev, "resetting camera, cc_irqstatus 0x%x\n",
> -                       cc_irqstatus);
> -               omap24xxcam_reset(cam);
> -       }
> -}
> -
> -/*
> - *
> - * videobuf_buffer handling.
> - *
> - * Memory for mmapped videobuf_buffers is not allocated
> - * conventionally, but by several kmalloc allocations and then
> - * creating the scatterlist on our own. User-space buffers are handled
> - * normally.
> - *
> - */
> -
> -/*
> - * Free the memory-mapped buffer memory allocated for a
> - * videobuf_buffer and the associated scatterlist.
> - */
> -static void omap24xxcam_vbq_free_mmap_buffer(struct videobuf_buffer *vb)
> -{
> -       struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
> -       size_t alloc_size;
> -       struct page *page;
> -       int i;
> -
> -       if (dma->sglist == NULL)
> -               return;
> -
> -       i = dma->sglen;
> -       while (i) {
> -               i--;
> -               alloc_size = sg_dma_len(&dma->sglist[i]);
> -               page = sg_page(&dma->sglist[i]);
> -               do {
> -                       ClearPageReserved(page++);
> -               } while (alloc_size -= PAGE_SIZE);
> -               __free_pages(sg_page(&dma->sglist[i]),
> -                            get_order(sg_dma_len(&dma->sglist[i])));
> -       }
> -
> -       kfree(dma->sglist);
> -       dma->sglist = NULL;
> -}
> -
> -/* Release all memory related to the videobuf_queue. */
> -static void omap24xxcam_vbq_free_mmap_buffers(struct videobuf_queue *vbq)
> -{
> -       int i;
> -
> -       mutex_lock(&vbq->vb_lock);
> -
> -       for (i = 0; i < VIDEO_MAX_FRAME; i++) {
> -               if (NULL == vbq->bufs[i])
> -                       continue;
> -               if (V4L2_MEMORY_MMAP != vbq->bufs[i]->memory)
> -                       continue;
> -               vbq->ops->buf_release(vbq, vbq->bufs[i]);
> -               omap24xxcam_vbq_free_mmap_buffer(vbq->bufs[i]);
> -               kfree(vbq->bufs[i]);
> -               vbq->bufs[i] = NULL;
> -       }
> -
> -       mutex_unlock(&vbq->vb_lock);
> -
> -       videobuf_mmap_free(vbq);
> -}
> -
> -/*
> - * Allocate physically as contiguous as possible buffer for video
> - * frame and allocate and build DMA scatter-gather list for it.
> - */
> -static int omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
> -{
> -       unsigned int order;
> -       size_t alloc_size, size = vb->bsize; /* vb->bsize is page aligned */
> -       struct page *page;
> -       int max_pages, err = 0, i = 0;
> -       struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
> -
> -       /*
> -        * allocate maximum size scatter-gather list. Note this is
> -        * overhead. We may not use as many entries as we allocate
> -        */
> -       max_pages = vb->bsize >> PAGE_SHIFT;
> -       dma->sglist = kcalloc(max_pages, sizeof(*dma->sglist), GFP_KERNEL);
> -       if (dma->sglist == NULL) {
> -               err = -ENOMEM;
> -               goto out;
> -       }
> -
> -       while (size) {
> -               order = get_order(size);
> -               /*
> -                * do not over-allocate even if we would get larger
> -                * contiguous chunk that way
> -                */
> -               if ((PAGE_SIZE << order) > size)
> -                       order--;
> -
> -               /* try to allocate as many contiguous pages as possible */
> -               page = alloc_pages(GFP_KERNEL, order);
> -               /* if allocation fails, try to allocate smaller amount */
> -               while (page == NULL) {
> -                       order--;
> -                       page = alloc_pages(GFP_KERNEL, order);
> -                       if (page == NULL && !order) {
> -                               err = -ENOMEM;
> -                               goto out;
> -                       }
> -               }
> -               size -= (PAGE_SIZE << order);
> -
> -               /* append allocated chunk of pages into scatter-gather list */
> -               sg_set_page(&dma->sglist[i], page, PAGE_SIZE << order, 0);
> -               dma->sglen++;
> -               i++;
> -
> -               alloc_size = (PAGE_SIZE << order);
> -
> -               /* clear pages before giving them to user space */
> -               memset(page_address(page), 0, alloc_size);
> -
> -               /* mark allocated pages reserved */
> -               do {
> -                       SetPageReserved(page++);
> -               } while (alloc_size -= PAGE_SIZE);
> -       }
> -       /*
> -        * REVISIT: not fully correct to assign nr_pages == sglen but
> -        * video-buf is passing nr_pages for e.g. unmap_sg calls
> -        */
> -       dma->nr_pages = dma->sglen;
> -       dma->direction = PCI_DMA_FROMDEVICE;
> -
> -       return 0;
> -
> -out:
> -       omap24xxcam_vbq_free_mmap_buffer(vb);
> -       return err;
> -}
> -
> -static int omap24xxcam_vbq_alloc_mmap_buffers(struct videobuf_queue *vbq,
> -                                             unsigned int count)
> -{
> -       int i, err = 0;
> -       struct omap24xxcam_fh *fh =
> -               container_of(vbq, struct omap24xxcam_fh, vbq);
> -
> -       mutex_lock(&vbq->vb_lock);
> -
> -       for (i = 0; i < count; i++) {
> -               err = omap24xxcam_vbq_alloc_mmap_buffer(vbq->bufs[i]);
> -               if (err)
> -                       goto out;
> -               dev_dbg(fh->cam->dev, "sglen is %d for buffer %d\n",
> -                       videobuf_to_dma(vbq->bufs[i])->sglen, i);
> -       }
> -
> -       mutex_unlock(&vbq->vb_lock);
> -
> -       return 0;
> -out:
> -       while (i) {
> -               i--;
> -               omap24xxcam_vbq_free_mmap_buffer(vbq->bufs[i]);
> -       }
> -
> -       mutex_unlock(&vbq->vb_lock);
> -
> -       return err;
> -}
> -
> -/*
> - * This routine is called from interrupt context when a scatter-gather DMA
> - * transfer of a videobuf_buffer completes.
> - */
> -static void omap24xxcam_vbq_complete(struct omap24xxcam_sgdma *sgdma,
> -                                    u32 csr, void *arg)
> -{
> -       struct omap24xxcam_device *cam =
> -               container_of(sgdma, struct omap24xxcam_device, sgdma);
> -       struct omap24xxcam_fh *fh = cam->streaming->private_data;
> -       struct videobuf_buffer *vb = (struct videobuf_buffer *)arg;
> -       const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
> -               | CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
> -               | CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
> -       if (--cam->sgdma_in_queue == 0)
> -               omap24xxcam_core_disable(cam);
> -       spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
> -
> -       do_gettimeofday(&vb->ts);
> -       vb->field_count = atomic_add_return(2, &fh->field_count);
> -       if (csr & csr_error) {
> -               vb->state = VIDEOBUF_ERROR;
> -               if (!atomic_read(&fh->cam->in_reset)) {
> -                       dev_dbg(cam->dev, "resetting camera, csr 0x%x\n", csr);
> -                       omap24xxcam_reset(cam);
> -               }
> -       } else
> -               vb->state = VIDEOBUF_DONE;
> -       wake_up(&vb->done);
> -}
> -
> -static void omap24xxcam_vbq_release(struct videobuf_queue *vbq,
> -                                   struct videobuf_buffer *vb)
> -{
> -       struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
> -
> -       /* wait for buffer, especially to get out of the sgdma queue */
> -       videobuf_waiton(vbq, vb, 0, 0);
> -       if (vb->memory == V4L2_MEMORY_MMAP) {
> -               dma_unmap_sg(vbq->dev, dma->sglist, dma->sglen,
> -                            dma->direction);
> -               dma->direction = DMA_NONE;
> -       } else {
> -               videobuf_dma_unmap(vbq->dev, videobuf_to_dma(vb));
> -               videobuf_dma_free(videobuf_to_dma(vb));
> -       }
> -
> -       vb->state = VIDEOBUF_NEEDS_INIT;
> -}
> -
> -/*
> - * Limit the number of available kernel image capture buffers based on the
> - * number requested, the currently selected image size, and the maximum
> - * amount of memory permitted for kernel capture buffers.
> - */
> -static int omap24xxcam_vbq_setup(struct videobuf_queue *vbq, unsigned int *cnt,
> -                                unsigned int *size)
> -{
> -       struct omap24xxcam_fh *fh = vbq->priv_data;
> -
> -       if (*cnt <= 0)
> -               *cnt = VIDEO_MAX_FRAME; /* supply a default number of buffers */
> -
> -       if (*cnt > VIDEO_MAX_FRAME)
> -               *cnt = VIDEO_MAX_FRAME;
> -
> -       *size = fh->pix.sizeimage;
> -
> -       /* accessing fh->cam->capture_mem is ok, it's constant */
> -       if (*size * *cnt > fh->cam->capture_mem)
> -               *cnt = fh->cam->capture_mem / *size;
> -
> -       return 0;
> -}
> -
> -static int omap24xxcam_dma_iolock(struct videobuf_queue *vbq,
> -                                 struct videobuf_dmabuf *dma)
> -{
> -       int err = 0;
> -
> -       dma->direction = PCI_DMA_FROMDEVICE;
> -       if (!dma_map_sg(vbq->dev, dma->sglist, dma->sglen, dma->direction)) {
> -               kfree(dma->sglist);
> -               dma->sglist = NULL;
> -               dma->sglen = 0;
> -               err = -EIO;
> -       }
> -
> -       return err;
> -}
> -
> -static int omap24xxcam_vbq_prepare(struct videobuf_queue *vbq,
> -                                  struct videobuf_buffer *vb,
> -                                  enum v4l2_field field)
> -{
> -       struct omap24xxcam_fh *fh = vbq->priv_data;
> -       int err = 0;
> -
> -       /*
> -        * Accessing pix here is okay since it's constant while
> -        * streaming is on (and we only get called then).
> -        */
> -       if (vb->baddr) {
> -               /* This is a userspace buffer. */
> -               if (fh->pix.sizeimage > vb->bsize) {
> -                       /* The buffer isn't big enough. */
> -                       err = -EINVAL;
> -               } else
> -                       vb->size = fh->pix.sizeimage;
> -       } else {
> -               if (vb->state != VIDEOBUF_NEEDS_INIT) {
> -                       /*
> -                        * We have a kernel bounce buffer that has
> -                        * already been allocated.
> -                        */
> -                       if (fh->pix.sizeimage > vb->size) {
> -                               /*
> -                                * The image size has been changed to
> -                                * a larger size since this buffer was
> -                                * allocated, so we need to free and
> -                                * reallocate it.
> -                                */
> -                               omap24xxcam_vbq_release(vbq, vb);
> -                               vb->size = fh->pix.sizeimage;
> -                       }
> -               } else {
> -                       /* We need to allocate a new kernel bounce buffer. */
> -                       vb->size = fh->pix.sizeimage;
> -               }
> -       }
> -
> -       if (err)
> -               return err;
> -
> -       vb->width = fh->pix.width;
> -       vb->height = fh->pix.height;
> -       vb->field = field;
> -
> -       if (vb->state == VIDEOBUF_NEEDS_INIT) {
> -               if (vb->memory == V4L2_MEMORY_MMAP)
> -                       /*
> -                        * we have built the scatter-gather list by ourself so
> -                        * do the scatter-gather mapping as well
> -                        */
> -                       err = omap24xxcam_dma_iolock(vbq, videobuf_to_dma(vb));
> -               else
> -                       err = videobuf_iolock(vbq, vb, NULL);
> -       }
> -
> -       if (!err)
> -               vb->state = VIDEOBUF_PREPARED;
> -       else
> -               omap24xxcam_vbq_release(vbq, vb);
> -
> -       return err;
> -}
> -
> -static void omap24xxcam_vbq_queue(struct videobuf_queue *vbq,
> -                                 struct videobuf_buffer *vb)
> -{
> -       struct omap24xxcam_fh *fh = vbq->priv_data;
> -       struct omap24xxcam_device *cam = fh->cam;
> -       enum videobuf_state state = vb->state;
> -       unsigned long flags;
> -       int err;
> -
> -       /*
> -        * FIXME: We're marking the buffer active since we have no
> -        * pretty way of marking it active exactly when the
> -        * scatter-gather transfer starts.
> -        */
> -       vb->state = VIDEOBUF_ACTIVE;
> -
> -       err = omap24xxcam_sgdma_queue(&fh->cam->sgdma,
> -                                     videobuf_to_dma(vb)->sglist,
> -                                     videobuf_to_dma(vb)->sglen, vb->size,
> -                                     omap24xxcam_vbq_complete, vb);
> -
> -       if (!err) {
> -               spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
> -               if (++cam->sgdma_in_queue == 1
> -                   && !atomic_read(&cam->in_reset))
> -                       omap24xxcam_core_enable(cam);
> -               spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
> -       } else {
> -               /*
> -                * Oops. We're not supposed to get any errors here.
> -                * The only way we could get an error is if we ran out
> -                * of scatter-gather DMA slots, but we are supposed to
> -                * have at least as many scatter-gather DMA slots as
> -                * video buffers so that can't happen.
> -                */
> -               dev_err(cam->dev, "failed to queue a video buffer for dma!\n");
> -               dev_err(cam->dev, "likely a bug in the driver!\n");
> -               vb->state = state;
> -       }
> -}
> -
> -static struct videobuf_queue_ops omap24xxcam_vbq_ops = {
> -       .buf_setup   = omap24xxcam_vbq_setup,
> -       .buf_prepare = omap24xxcam_vbq_prepare,
> -       .buf_queue   = omap24xxcam_vbq_queue,
> -       .buf_release = omap24xxcam_vbq_release,
> -};
> -
> -/*
> - *
> - * OMAP main camera system
> - *
> - */
> -
> -/*
> - * Reset camera block to power-on state.
> - */
> -static void omap24xxcam_poweron_reset(struct omap24xxcam_device *cam)
> -{
> -       int max_loop = RESET_TIMEOUT_NS;
> -
> -       /* Reset whole camera subsystem */
> -       omap24xxcam_reg_out(cam->mmio_base,
> -                           CAM_SYSCONFIG,
> -                           CAM_SYSCONFIG_SOFTRESET);
> -
> -       /* Wait till it's finished */
> -       while (!(omap24xxcam_reg_in(cam->mmio_base, CAM_SYSSTATUS)
> -                & CAM_SYSSTATUS_RESETDONE)
> -              && --max_loop) {
> -               ndelay(1);
> -       }
> -
> -       if (!(omap24xxcam_reg_in(cam->mmio_base, CAM_SYSSTATUS)
> -             & CAM_SYSSTATUS_RESETDONE))
> -               dev_err(cam->dev, "camera soft reset timeout\n");
> -}
> -
> -/*
> - * (Re)initialise the camera block.
> - */
> -static void omap24xxcam_hwinit(struct omap24xxcam_device *cam)
> -{
> -       omap24xxcam_poweron_reset(cam);
> -
> -       /* set the camera subsystem autoidle bit */
> -       omap24xxcam_reg_out(cam->mmio_base, CAM_SYSCONFIG,
> -                           CAM_SYSCONFIG_AUTOIDLE);
> -
> -       /* set the camera MMU autoidle bit */
> -       omap24xxcam_reg_out(cam->mmio_base,
> -                           CAMMMU_REG_OFFSET + CAMMMU_SYSCONFIG,
> -                           CAMMMU_SYSCONFIG_AUTOIDLE);
> -
> -       omap24xxcam_core_hwinit(cam);
> -
> -       omap24xxcam_dma_hwinit(&cam->sgdma.dma);
> -}
> -
> -/*
> - * Callback for dma transfer stalling.
> - */
> -static void omap24xxcam_stalled_dma_reset(unsigned long data)
> -{
> -       struct omap24xxcam_device *cam = (struct omap24xxcam_device *)data;
> -
> -       if (!atomic_read(&cam->in_reset)) {
> -               dev_dbg(cam->dev, "dma stalled, resetting camera\n");
> -               omap24xxcam_reset(cam);
> -       }
> -}
> -
> -/*
> - * Stop capture. Mark we're doing a reset, stop DMA transfers and
> - * core. (No new scatter-gather transfers will be queued whilst
> - * in_reset is non-zero.)
> - *
> - * If omap24xxcam_capture_stop is called from several places at
> - * once, only the first call will have an effect. Similarly, the last
> - * call omap24xxcam_streaming_cont will have effect.
> - *
> - * Serialisation is ensured by using cam->core_enable_disable_lock.
> - */
> -static void omap24xxcam_capture_stop(struct omap24xxcam_device *cam)
> -{
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
> -
> -       if (atomic_inc_return(&cam->in_reset) != 1) {
> -               spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
> -               return;
> -       }
> -
> -       omap24xxcam_core_disable(cam);
> -
> -       spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
> -
> -       omap24xxcam_sgdma_sync(&cam->sgdma);
> -}
> -
> -/*
> - * Reset and continue streaming.
> - *
> - * Note: Resetting the camera FIFO via the CC_RST bit in the CC_CTRL
> - * register is supposed to be sufficient to recover from a camera
> - * interface error, but it doesn't seem to be enough. If we only do
> - * that then subsequent image captures are out of sync by either one
> - * or two times DMA_THRESHOLD bytes. Resetting and re-initializing the
> - * entire camera subsystem prevents the problem with frame
> - * synchronization.
> - */
> -static void omap24xxcam_capture_cont(struct omap24xxcam_device *cam)
> -{
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
> -
> -       if (atomic_read(&cam->in_reset) != 1)
> -               goto out;
> -
> -       omap24xxcam_hwinit(cam);
> -
> -       omap24xxcam_sensor_if_enable(cam);
> -
> -       omap24xxcam_sgdma_process(&cam->sgdma);
> -
> -       if (cam->sgdma_in_queue)
> -               omap24xxcam_core_enable(cam);
> -
> -out:
> -       atomic_dec(&cam->in_reset);
> -       spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
> -}
> -
> -static ssize_t
> -omap24xxcam_streaming_show(struct device *dev, struct device_attribute *attr,
> -               char *buf)
> -{
> -       struct omap24xxcam_device *cam = dev_get_drvdata(dev);
> -
> -       return sprintf(buf, "%s\n", cam->streaming ?  "active" : "inactive");
> -}
> -static DEVICE_ATTR(streaming, S_IRUGO, omap24xxcam_streaming_show, NULL);
> -
> -/*
> - * Stop capture and restart it. I.e. reset the camera during use.
> - */
> -static void omap24xxcam_reset(struct omap24xxcam_device *cam)
> -{
> -       omap24xxcam_capture_stop(cam);
> -       omap24xxcam_capture_cont(cam);
> -}
> -
> -/*
> - * The main interrupt handler.
> - */
> -static irqreturn_t omap24xxcam_isr(int irq, void *arg)
> -{
> -       struct omap24xxcam_device *cam = (struct omap24xxcam_device *)arg;
> -       u32 irqstatus;
> -       unsigned int irqhandled = 0;
> -
> -       irqstatus = omap24xxcam_reg_in(cam->mmio_base, CAM_IRQSTATUS);
> -
> -       if (irqstatus &
> -           (CAM_IRQSTATUS_DMA_IRQ2 | CAM_IRQSTATUS_DMA_IRQ1
> -            | CAM_IRQSTATUS_DMA_IRQ0)) {
> -               omap24xxcam_dma_isr(&cam->sgdma.dma);
> -               irqhandled = 1;
> -       }
> -       if (irqstatus & CAM_IRQSTATUS_CC_IRQ) {
> -               omap24xxcam_core_isr(cam);
> -               irqhandled = 1;
> -       }
> -       if (irqstatus & CAM_IRQSTATUS_MMU_IRQ)
> -               dev_err(cam->dev, "unhandled camera MMU interrupt!\n");
> -
> -       return IRQ_RETVAL(irqhandled);
> -}
> -
> -/*
> - *
> - * Sensor handling.
> - *
> - */
> -
> -/*
> - * Enable the external sensor interface. Try to negotiate interface
> - * parameters with the sensor and start using the new ones. The calls
> - * to sensor_if_enable and sensor_if_disable need not to be balanced.
> - */
> -static int omap24xxcam_sensor_if_enable(struct omap24xxcam_device *cam)
> -{
> -       int rval;
> -       struct v4l2_ifparm p;
> -
> -       rval = vidioc_int_g_ifparm(cam->sdev, &p);
> -       if (rval) {
> -               dev_err(cam->dev, "vidioc_int_g_ifparm failed with %d\n", rval);
> -               return rval;
> -       }
> -
> -       cam->if_type = p.if_type;
> -
> -       cam->cc_ctrl = CC_CTRL_CC_EN;
> -
> -       switch (p.if_type) {
> -       case V4L2_IF_TYPE_BT656:
> -               if (p.u.bt656.frame_start_on_rising_vs)
> -                       cam->cc_ctrl |= CC_CTRL_NOBT_SYNCHRO;
> -               if (p.u.bt656.bt_sync_correct)
> -                       cam->cc_ctrl |= CC_CTRL_BT_CORRECT;
> -               if (p.u.bt656.swap)
> -                       cam->cc_ctrl |= CC_CTRL_PAR_ORDERCAM;
> -               if (p.u.bt656.latch_clk_inv)
> -                       cam->cc_ctrl |= CC_CTRL_PAR_CLK_POL;
> -               if (p.u.bt656.nobt_hs_inv)
> -                       cam->cc_ctrl |= CC_CTRL_NOBT_HS_POL;
> -               if (p.u.bt656.nobt_vs_inv)
> -                       cam->cc_ctrl |= CC_CTRL_NOBT_VS_POL;
> -
> -               switch (p.u.bt656.mode) {
> -               case V4L2_IF_TYPE_BT656_MODE_NOBT_8BIT:
> -                       cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT8;
> -                       break;
> -               case V4L2_IF_TYPE_BT656_MODE_NOBT_10BIT:
> -                       cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT10;
> -                       break;
> -               case V4L2_IF_TYPE_BT656_MODE_NOBT_12BIT:
> -                       cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT12;
> -                       break;
> -               case V4L2_IF_TYPE_BT656_MODE_BT_8BIT:
> -                       cam->cc_ctrl |= CC_CTRL_PAR_MODE_BT8;
> -                       break;
> -               case V4L2_IF_TYPE_BT656_MODE_BT_10BIT:
> -                       cam->cc_ctrl |= CC_CTRL_PAR_MODE_BT10;
> -                       break;
> -               default:
> -                       dev_err(cam->dev,
> -                               "bt656 interface mode %d not supported\n",
> -                               p.u.bt656.mode);
> -                       return -EINVAL;
> -               }
> -               /*
> -                * The clock rate that the sensor wants has changed.
> -                * We have to adjust the xclk from OMAP 2 side to
> -                * match the sensor's wish as closely as possible.
> -                */
> -               if (p.u.bt656.clock_curr != cam->if_u.bt656.xclk) {
> -                       u32 xclk = p.u.bt656.clock_curr;
> -                       u32 divisor;
> -
> -                       if (xclk == 0)
> -                               return -EINVAL;
> -
> -                       if (xclk > CAM_MCLK)
> -                               xclk = CAM_MCLK;
> -
> -                       divisor = CAM_MCLK / xclk;
> -                       if (divisor * xclk < CAM_MCLK)
> -                               divisor++;
> -                       if (CAM_MCLK / divisor < p.u.bt656.clock_min
> -                           && divisor > 1)
> -                               divisor--;
> -                       if (divisor > 30)
> -                               divisor = 30;
> -
> -                       xclk = CAM_MCLK / divisor;
> -
> -                       if (xclk < p.u.bt656.clock_min
> -                           || xclk > p.u.bt656.clock_max)
> -                               return -EINVAL;
> -
> -                       cam->if_u.bt656.xclk = xclk;
> -               }
> -               omap24xxcam_core_xclk_set(cam, cam->if_u.bt656.xclk);
> -               break;
> -       default:
> -               /* FIXME: how about other interfaces? */
> -               dev_err(cam->dev, "interface type %d not supported\n",
> -                       p.if_type);
> -               return -EINVAL;
> -       }
> -
> -       return 0;
> -}
> -
> -static void omap24xxcam_sensor_if_disable(const struct omap24xxcam_device *cam)
> -{
> -       switch (cam->if_type) {
> -       case V4L2_IF_TYPE_BT656:
> -               omap24xxcam_core_xclk_set(cam, 0);
> -               break;
> -       }
> -}
> -
> -/*
> - * Initialise the sensor hardware.
> - */
> -static int omap24xxcam_sensor_init(struct omap24xxcam_device *cam)
> -{
> -       int err = 0;
> -       struct v4l2_int_device *sdev = cam->sdev;
> -
> -       omap24xxcam_clock_on(cam);
> -       err = omap24xxcam_sensor_if_enable(cam);
> -       if (err) {
> -               dev_err(cam->dev, "sensor interface could not be enabled at "
> -                       "initialisation, %d\n", err);
> -               cam->sdev = NULL;
> -               goto out;
> -       }
> -
> -       /* power up sensor during sensor initialization */
> -       vidioc_int_s_power(sdev, 1);
> -
> -       err = vidioc_int_dev_init(sdev);
> -       if (err) {
> -               dev_err(cam->dev, "cannot initialize sensor, error %d\n", err);
> -               /* Sensor init failed --- it's nonexistent to us! */
> -               cam->sdev = NULL;
> -               goto out;
> -       }
> -
> -       dev_info(cam->dev, "sensor is %s\n", sdev->name);
> -
> -out:
> -       omap24xxcam_sensor_if_disable(cam);
> -       omap24xxcam_clock_off(cam);
> -
> -       vidioc_int_s_power(sdev, 0);
> -
> -       return err;
> -}
> -
> -static void omap24xxcam_sensor_exit(struct omap24xxcam_device *cam)
> -{
> -       if (cam->sdev)
> -               vidioc_int_dev_exit(cam->sdev);
> -}
> -
> -static void omap24xxcam_sensor_disable(struct omap24xxcam_device *cam)
> -{
> -       omap24xxcam_sensor_if_disable(cam);
> -       omap24xxcam_clock_off(cam);
> -       vidioc_int_s_power(cam->sdev, 0);
> -}
> -
> -/*
> - * Power-up and configure camera sensor. It's ready for capturing now.
> - */
> -static int omap24xxcam_sensor_enable(struct omap24xxcam_device *cam)
> -{
> -       int rval;
> -
> -       omap24xxcam_clock_on(cam);
> -
> -       omap24xxcam_sensor_if_enable(cam);
> -
> -       rval = vidioc_int_s_power(cam->sdev, 1);
> -       if (rval)
> -               goto out;
> -
> -       rval = vidioc_int_init(cam->sdev);
> -       if (rval)
> -               goto out;
> -
> -       return 0;
> -
> -out:
> -       omap24xxcam_sensor_disable(cam);
> -
> -       return rval;
> -}
> -
> -static void omap24xxcam_sensor_reset_work(struct work_struct *work)
> -{
> -       struct omap24xxcam_device *cam =
> -               container_of(work, struct omap24xxcam_device,
> -                            sensor_reset_work);
> -
> -       if (atomic_read(&cam->reset_disable))
> -               return;
> -
> -       omap24xxcam_capture_stop(cam);
> -
> -       if (vidioc_int_reset(cam->sdev) == 0) {
> -               vidioc_int_init(cam->sdev);
> -       } else {
> -               /* Can't reset it by vidioc_int_reset. */
> -               omap24xxcam_sensor_disable(cam);
> -               omap24xxcam_sensor_enable(cam);
> -       }
> -
> -       omap24xxcam_capture_cont(cam);
> -}
> -
> -/*
> - *
> - * IOCTL interface.
> - *
> - */
> -
> -static int vidioc_querycap(struct file *file, void *fh,
> -                          struct v4l2_capability *cap)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -
> -       strlcpy(cap->driver, CAM_NAME, sizeof(cap->driver));
> -       strlcpy(cap->card, cam->vfd->name, sizeof(cap->card));
> -       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> -
> -       return 0;
> -}
> -
> -static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh,
> -                                  struct v4l2_fmtdesc *f)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       rval = vidioc_int_enum_fmt_cap(cam->sdev, f);
> -
> -       return rval;
> -}
> -
> -static int vidioc_g_fmt_vid_cap(struct file *file, void *fh,
> -                               struct v4l2_format *f)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       rval = vidioc_int_g_fmt_cap(cam->sdev, f);
> -       mutex_unlock(&cam->mutex);
> -
> -       return rval;
> -}
> -
> -static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
> -                               struct v4l2_format *f)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       if (cam->streaming) {
> -               rval = -EBUSY;
> -               goto out;
> -       }
> -
> -       rval = vidioc_int_s_fmt_cap(cam->sdev, f);
> -
> -out:
> -       mutex_unlock(&cam->mutex);
> -
> -       if (!rval) {
> -               mutex_lock(&ofh->vbq.vb_lock);
> -               ofh->pix = f->fmt.pix;
> -               mutex_unlock(&ofh->vbq.vb_lock);
> -       }
> -
> -       memset(f, 0, sizeof(*f));
> -       vidioc_g_fmt_vid_cap(file, fh, f);
> -
> -       return rval;
> -}
> -
> -static int vidioc_try_fmt_vid_cap(struct file *file, void *fh,
> -                                 struct v4l2_format *f)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       rval = vidioc_int_try_fmt_cap(cam->sdev, f);
> -       mutex_unlock(&cam->mutex);
> -
> -       return rval;
> -}
> -
> -static int vidioc_reqbufs(struct file *file, void *fh,
> -                         struct v4l2_requestbuffers *b)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       if (cam->streaming) {
> -               mutex_unlock(&cam->mutex);
> -               return -EBUSY;
> -       }
> -
> -       omap24xxcam_vbq_free_mmap_buffers(&ofh->vbq);
> -       mutex_unlock(&cam->mutex);
> -
> -       rval = videobuf_reqbufs(&ofh->vbq, b);
> -
> -       /*
> -        * Either videobuf_reqbufs failed or the buffers are not
> -        * memory-mapped (which would need special attention).
> -        */
> -       if (rval < 0 || b->memory != V4L2_MEMORY_MMAP)
> -               goto out;
> -
> -       rval = omap24xxcam_vbq_alloc_mmap_buffers(&ofh->vbq, rval);
> -       if (rval)
> -               omap24xxcam_vbq_free_mmap_buffers(&ofh->vbq);
> -
> -out:
> -       return rval;
> -}
> -
> -static int vidioc_querybuf(struct file *file, void *fh,
> -                          struct v4l2_buffer *b)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -
> -       return videobuf_querybuf(&ofh->vbq, b);
> -}
> -
> -static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -
> -       return videobuf_qbuf(&ofh->vbq, b);
> -}
> -
> -static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       struct videobuf_buffer *vb;
> -       int rval;
> -
> -videobuf_dqbuf_again:
> -       rval = videobuf_dqbuf(&ofh->vbq, b, file->f_flags & O_NONBLOCK);
> -       if (rval)
> -               goto out;
> -
> -       vb = ofh->vbq.bufs[b->index];
> -
> -       mutex_lock(&cam->mutex);
> -       /* _needs_reset returns -EIO if reset is required. */
> -       rval = vidioc_int_g_needs_reset(cam->sdev, (void *)vb->baddr);
> -       mutex_unlock(&cam->mutex);
> -       if (rval == -EIO)
> -               schedule_work(&cam->sensor_reset_work);
> -       else
> -               rval = 0;
> -
> -out:
> -       /*
> -        * This is a hack. We don't want to show -EIO to the user
> -        * space. Requeue the buffer and try again if we're not doing
> -        * this in non-blocking mode.
> -        */
> -       if (rval == -EIO) {
> -               videobuf_qbuf(&ofh->vbq, b);
> -               if (!(file->f_flags & O_NONBLOCK))
> -                       goto videobuf_dqbuf_again;
> -               /*
> -                * We don't have a videobuf_buffer now --- maybe next
> -                * time...
> -                */
> -               rval = -EAGAIN;
> -       }
> -
> -       return rval;
> -}
> -
> -static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       if (cam->streaming) {
> -               rval = -EBUSY;
> -               goto out;
> -       }
> -
> -       rval = omap24xxcam_sensor_if_enable(cam);
> -       if (rval) {
> -               dev_dbg(cam->dev, "vidioc_int_g_ifparm failed\n");
> -               goto out;
> -       }
> -
> -       rval = videobuf_streamon(&ofh->vbq);
> -       if (!rval) {
> -               cam->streaming = file;
> -               sysfs_notify(&cam->dev->kobj, NULL, "streaming");
> -       }
> -
> -out:
> -       mutex_unlock(&cam->mutex);
> -
> -       return rval;
> -}
> -
> -static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       struct videobuf_queue *q = &ofh->vbq;
> -       int rval;
> -
> -       atomic_inc(&cam->reset_disable);
> -
> -       flush_work(&cam->sensor_reset_work);
> -
> -       rval = videobuf_streamoff(q);
> -       if (!rval) {
> -               mutex_lock(&cam->mutex);
> -               cam->streaming = NULL;
> -               mutex_unlock(&cam->mutex);
> -               sysfs_notify(&cam->dev->kobj, NULL, "streaming");
> -       }
> -
> -       atomic_dec(&cam->reset_disable);
> -
> -       return rval;
> -}
> -
> -static int vidioc_enum_input(struct file *file, void *fh,
> -                            struct v4l2_input *inp)
> -{
> -       if (inp->index > 0)
> -               return -EINVAL;
> -
> -       strlcpy(inp->name, "camera", sizeof(inp->name));
> -       inp->type = V4L2_INPUT_TYPE_CAMERA;
> -
> -       return 0;
> -}
> -
> -static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
> -{
> -       *i = 0;
> -
> -       return 0;
> -}
> -
> -static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
> -{
> -       if (i > 0)
> -               return -EINVAL;
> -
> -       return 0;
> -}
> -
> -static int vidioc_queryctrl(struct file *file, void *fh,
> -                           struct v4l2_queryctrl *a)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       rval = vidioc_int_queryctrl(cam->sdev, a);
> -
> -       return rval;
> -}
> -
> -static int vidioc_g_ctrl(struct file *file, void *fh,
> -                        struct v4l2_control *a)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       rval = vidioc_int_g_ctrl(cam->sdev, a);
> -       mutex_unlock(&cam->mutex);
> -
> -       return rval;
> -}
> -
> -static int vidioc_s_ctrl(struct file *file, void *fh,
> -                        struct v4l2_control *a)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       rval = vidioc_int_s_ctrl(cam->sdev, a);
> -       mutex_unlock(&cam->mutex);
> -
> -       return rval;
> -}
> -
> -static int vidioc_g_parm(struct file *file, void *fh,
> -                        struct v4l2_streamparm *a) {
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       rval = vidioc_int_g_parm(cam->sdev, a);
> -       mutex_unlock(&cam->mutex);
> -
> -       return rval;
> -}
> -
> -static int vidioc_s_parm(struct file *file, void *fh,
> -                        struct v4l2_streamparm *a)
> -{
> -       struct omap24xxcam_fh *ofh = fh;
> -       struct omap24xxcam_device *cam = ofh->cam;
> -       struct v4l2_streamparm old_streamparm;
> -       int rval;
> -
> -       mutex_lock(&cam->mutex);
> -       if (cam->streaming) {
> -               rval = -EBUSY;
> -               goto out;
> -       }
> -
> -       old_streamparm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -       rval = vidioc_int_g_parm(cam->sdev, &old_streamparm);
> -       if (rval)
> -               goto out;
> -
> -       rval = vidioc_int_s_parm(cam->sdev, a);
> -       if (rval)
> -               goto out;
> -
> -       rval = omap24xxcam_sensor_if_enable(cam);
> -       /*
> -        * Revert to old streaming parameters if enabling sensor
> -        * interface with the new ones failed.
> -        */
> -       if (rval)
> -               vidioc_int_s_parm(cam->sdev, &old_streamparm);
> -
> -out:
> -       mutex_unlock(&cam->mutex);
> -
> -       return rval;
> -}
> -
> -/*
> - *
> - * File operations.
> - *
> - */
> -
> -static unsigned int omap24xxcam_poll(struct file *file,
> -                                    struct poll_table_struct *wait)
> -{
> -       struct omap24xxcam_fh *fh = file->private_data;
> -       struct omap24xxcam_device *cam = fh->cam;
> -       struct videobuf_buffer *vb;
> -
> -       mutex_lock(&cam->mutex);
> -       if (cam->streaming != file) {
> -               mutex_unlock(&cam->mutex);
> -               return POLLERR;
> -       }
> -       mutex_unlock(&cam->mutex);
> -
> -       mutex_lock(&fh->vbq.vb_lock);
> -       if (list_empty(&fh->vbq.stream)) {
> -               mutex_unlock(&fh->vbq.vb_lock);
> -               return POLLERR;
> -       }
> -       vb = list_entry(fh->vbq.stream.next, struct videobuf_buffer, stream);
> -       mutex_unlock(&fh->vbq.vb_lock);
> -
> -       poll_wait(file, &vb->done, wait);
> -
> -       if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
> -               return POLLIN | POLLRDNORM;
> -
> -       return 0;
> -}
> -
> -static int omap24xxcam_mmap_buffers(struct file *file,
> -                                   struct vm_area_struct *vma)
> -{
> -       struct omap24xxcam_fh *fh = file->private_data;
> -       struct omap24xxcam_device *cam = fh->cam;
> -       struct videobuf_queue *vbq = &fh->vbq;
> -       unsigned int first, last, size, i, j;
> -       int err = 0;
> -
> -       mutex_lock(&cam->mutex);
> -       if (cam->streaming) {
> -               mutex_unlock(&cam->mutex);
> -               return -EBUSY;
> -       }
> -       mutex_unlock(&cam->mutex);
> -       mutex_lock(&vbq->vb_lock);
> -
> -       /* look for first buffer to map */
> -       for (first = 0; first < VIDEO_MAX_FRAME; first++) {
> -               if (NULL == vbq->bufs[first])
> -                       continue;
> -               if (V4L2_MEMORY_MMAP != vbq->bufs[first]->memory)
> -                       continue;
> -               if (vbq->bufs[first]->boff == (vma->vm_pgoff << PAGE_SHIFT))
> -                       break;
> -       }
> -
> -       /* look for last buffer to map */
> -       for (size = 0, last = first; last < VIDEO_MAX_FRAME; last++) {
> -               if (NULL == vbq->bufs[last])
> -                       continue;
> -               if (V4L2_MEMORY_MMAP != vbq->bufs[last]->memory)
> -                       continue;
> -               size += vbq->bufs[last]->bsize;
> -               if (size == (vma->vm_end - vma->vm_start))
> -                       break;
> -       }
> -
> -       size = 0;
> -       for (i = first; i <= last && i < VIDEO_MAX_FRAME; i++) {
> -               struct videobuf_dmabuf *dma = videobuf_to_dma(vbq->bufs[i]);
> -
> -               for (j = 0; j < dma->sglen; j++) {
> -                       err = remap_pfn_range(
> -                               vma, vma->vm_start + size,
> -                               page_to_pfn(sg_page(&dma->sglist[j])),
> -                               sg_dma_len(&dma->sglist[j]), vma->vm_page_prot);
> -                       if (err)
> -                               goto out;
> -                       size += sg_dma_len(&dma->sglist[j]);
> -               }
> -       }
> -
> -out:
> -       mutex_unlock(&vbq->vb_lock);
> -
> -       return err;
> -}
> -
> -static int omap24xxcam_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -       struct omap24xxcam_fh *fh = file->private_data;
> -       int rval;
> -
> -       /* let the video-buf mapper check arguments and set-up structures */
> -       rval = videobuf_mmap_mapper(&fh->vbq, vma);
> -       if (rval)
> -               return rval;
> -
> -       vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -
> -       /* do mapping to our allocated buffers */
> -       rval = omap24xxcam_mmap_buffers(file, vma);
> -       /*
> -        * In case of error, free vma->vm_private_data allocated by
> -        * videobuf_mmap_mapper.
> -        */
> -       if (rval)
> -               kfree(vma->vm_private_data);
> -
> -       return rval;
> -}
> -
> -static int omap24xxcam_open(struct file *file)
> -{
> -       struct omap24xxcam_device *cam = omap24xxcam.priv;
> -       struct omap24xxcam_fh *fh;
> -       struct v4l2_format format;
> -
> -       if (!cam || !cam->vfd)
> -               return -ENODEV;
> -
> -       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
> -       if (fh == NULL)
> -               return -ENOMEM;
> -
> -       mutex_lock(&cam->mutex);
> -       if (cam->sdev == NULL || !try_module_get(cam->sdev->module)) {
> -               mutex_unlock(&cam->mutex);
> -               goto out_try_module_get;
> -       }
> -
> -       if (atomic_inc_return(&cam->users) == 1) {
> -               omap24xxcam_hwinit(cam);
> -               if (omap24xxcam_sensor_enable(cam)) {
> -                       mutex_unlock(&cam->mutex);
> -                       goto out_omap24xxcam_sensor_enable;
> -               }
> -       }
> -       mutex_unlock(&cam->mutex);
> -
> -       fh->cam = cam;
> -       mutex_lock(&cam->mutex);
> -       vidioc_int_g_fmt_cap(cam->sdev, &format);
> -       mutex_unlock(&cam->mutex);
> -       /* FIXME: how about fh->pix when there are more users? */
> -       fh->pix = format.fmt.pix;
> -
> -       file->private_data = fh;
> -
> -       spin_lock_init(&fh->vbq_lock);
> -
> -       videobuf_queue_sg_init(&fh->vbq, &omap24xxcam_vbq_ops, NULL,
> -                               &fh->vbq_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -                               V4L2_FIELD_NONE,
> -                               sizeof(struct videobuf_buffer), fh, NULL);
> -
> -       return 0;
> -
> -out_omap24xxcam_sensor_enable:
> -       omap24xxcam_poweron_reset(cam);
> -       module_put(cam->sdev->module);
> -
> -out_try_module_get:
> -       kfree(fh);
> -
> -       return -ENODEV;
> -}
> -
> -static int omap24xxcam_release(struct file *file)
> -{
> -       struct omap24xxcam_fh *fh = file->private_data;
> -       struct omap24xxcam_device *cam = fh->cam;
> -
> -       atomic_inc(&cam->reset_disable);
> -
> -       flush_work(&cam->sensor_reset_work);
> -
> -       /* stop streaming capture */
> -       videobuf_streamoff(&fh->vbq);
> -
> -       mutex_lock(&cam->mutex);
> -       if (cam->streaming == file) {
> -               cam->streaming = NULL;
> -               mutex_unlock(&cam->mutex);
> -               sysfs_notify(&cam->dev->kobj, NULL, "streaming");
> -       } else {
> -               mutex_unlock(&cam->mutex);
> -       }
> -
> -       atomic_dec(&cam->reset_disable);
> -
> -       omap24xxcam_vbq_free_mmap_buffers(&fh->vbq);
> -
> -       /*
> -        * Make sure the reset work we might have scheduled is not
> -        * pending! It may be run *only* if we have users. (And it may
> -        * not be scheduled anymore since streaming is already
> -        * disabled.)
> -        */
> -       flush_work(&cam->sensor_reset_work);
> -
> -       mutex_lock(&cam->mutex);
> -       if (atomic_dec_return(&cam->users) == 0) {
> -               omap24xxcam_sensor_disable(cam);
> -               omap24xxcam_poweron_reset(cam);
> -       }
> -       mutex_unlock(&cam->mutex);
> -
> -       file->private_data = NULL;
> -
> -       module_put(cam->sdev->module);
> -       kfree(fh);
> -
> -       return 0;
> -}
> -
> -static struct v4l2_file_operations omap24xxcam_fops = {
> -       .ioctl   = video_ioctl2,
> -       .poll    = omap24xxcam_poll,
> -       .mmap    = omap24xxcam_mmap,
> -       .open    = omap24xxcam_open,
> -       .release = omap24xxcam_release,
> -};
> -
> -/*
> - *
> - * Power management.
> - *
> - */
> -
> -#ifdef CONFIG_PM
> -static int omap24xxcam_suspend(struct platform_device *pdev, pm_message_t state)
> -{
> -       struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
> -
> -       if (atomic_read(&cam->users) == 0)
> -               return 0;
> -
> -       if (!atomic_read(&cam->reset_disable))
> -               omap24xxcam_capture_stop(cam);
> -
> -       omap24xxcam_sensor_disable(cam);
> -       omap24xxcam_poweron_reset(cam);
> -
> -       return 0;
> -}
> -
> -static int omap24xxcam_resume(struct platform_device *pdev)
> -{
> -       struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
> -
> -       if (atomic_read(&cam->users) == 0)
> -               return 0;
> -
> -       omap24xxcam_hwinit(cam);
> -       omap24xxcam_sensor_enable(cam);
> -
> -       if (!atomic_read(&cam->reset_disable))
> -               omap24xxcam_capture_cont(cam);
> -
> -       return 0;
> -}
> -#endif /* CONFIG_PM */
> -
> -static const struct v4l2_ioctl_ops omap24xxcam_ioctl_fops = {
> -       .vidioc_querycap        = vidioc_querycap,
> -       .vidioc_enum_fmt_vid_cap        = vidioc_enum_fmt_vid_cap,
> -       .vidioc_g_fmt_vid_cap   = vidioc_g_fmt_vid_cap,
> -       .vidioc_s_fmt_vid_cap   = vidioc_s_fmt_vid_cap,
> -       .vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
> -       .vidioc_reqbufs         = vidioc_reqbufs,
> -       .vidioc_querybuf        = vidioc_querybuf,
> -       .vidioc_qbuf            = vidioc_qbuf,
> -       .vidioc_dqbuf           = vidioc_dqbuf,
> -       .vidioc_streamon        = vidioc_streamon,
> -       .vidioc_streamoff       = vidioc_streamoff,
> -       .vidioc_enum_input      = vidioc_enum_input,
> -       .vidioc_g_input         = vidioc_g_input,
> -       .vidioc_s_input         = vidioc_s_input,
> -       .vidioc_queryctrl       = vidioc_queryctrl,
> -       .vidioc_g_ctrl          = vidioc_g_ctrl,
> -       .vidioc_s_ctrl          = vidioc_s_ctrl,
> -       .vidioc_g_parm          = vidioc_g_parm,
> -       .vidioc_s_parm          = vidioc_s_parm,
> -};
> -
> -/*
> - *
> - * Camera device (i.e. /dev/video).
> - *
> - */
> -
> -static int omap24xxcam_device_register(struct v4l2_int_device *s)
> -{
> -       struct omap24xxcam_device *cam = s->u.slave->master->priv;
> -       struct video_device *vfd;
> -       int rval;
> -
> -       /* We already have a slave. */
> -       if (cam->sdev)
> -               return -EBUSY;
> -
> -       cam->sdev = s;
> -
> -       if (device_create_file(cam->dev, &dev_attr_streaming) != 0) {
> -               dev_err(cam->dev, "could not register sysfs entry\n");
> -               rval = -EBUSY;
> -               goto err;
> -       }
> -
> -       /* initialize the video_device struct */
> -       vfd = cam->vfd = video_device_alloc();
> -       if (!vfd) {
> -               dev_err(cam->dev, "could not allocate video device struct\n");
> -               rval = -ENOMEM;
> -               goto err;
> -       }
> -       vfd->release = video_device_release;
> -
> -       vfd->parent = cam->dev;
> -
> -       strlcpy(vfd->name, CAM_NAME, sizeof(vfd->name));
> -       vfd->fops                = &omap24xxcam_fops;
> -       vfd->ioctl_ops           = &omap24xxcam_ioctl_fops;
> -
> -       omap24xxcam_hwinit(cam);
> -
> -       rval = omap24xxcam_sensor_init(cam);
> -       if (rval)
> -               goto err;
> -
> -       if (video_register_device(vfd, VFL_TYPE_GRABBER, video_nr) < 0) {
> -               dev_err(cam->dev, "could not register V4L device\n");
> -               rval = -EBUSY;
> -               goto err;
> -       }
> -
> -       omap24xxcam_poweron_reset(cam);
> -
> -       dev_info(cam->dev, "registered device %s\n",
> -                video_device_node_name(vfd));
> -
> -       return 0;
> -
> -err:
> -       omap24xxcam_device_unregister(s);
> -
> -       return rval;
> -}
> -
> -static void omap24xxcam_device_unregister(struct v4l2_int_device *s)
> -{
> -       struct omap24xxcam_device *cam = s->u.slave->master->priv;
> -
> -       omap24xxcam_sensor_exit(cam);
> -
> -       if (cam->vfd) {
> -               if (!video_is_registered(cam->vfd)) {
> -                       /*
> -                        * The device was never registered, so release the
> -                        * video_device struct directly.
> -                        */
> -                       video_device_release(cam->vfd);
> -               } else {
> -                       /*
> -                        * The unregister function will release the
> -                        * video_device struct as well as
> -                        * unregistering it.
> -                        */
> -                       video_unregister_device(cam->vfd);
> -               }
> -               cam->vfd = NULL;
> -       }
> -
> -       device_remove_file(cam->dev, &dev_attr_streaming);
> -
> -       cam->sdev = NULL;
> -}
> -
> -static struct v4l2_int_master omap24xxcam_master = {
> -       .attach = omap24xxcam_device_register,
> -       .detach = omap24xxcam_device_unregister,
> -};
> -
> -static struct v4l2_int_device omap24xxcam = {
> -       .module = THIS_MODULE,
> -       .name   = CAM_NAME,
> -       .type   = v4l2_int_type_master,
> -       .u      = {
> -               .master = &omap24xxcam_master
> -       },
> -};
> -
> -/*
> - *
> - * Driver initialisation and deinitialisation.
> - *
> - */
> -
> -static int __devinit omap24xxcam_probe(struct platform_device *pdev)
> -{
> -       struct omap24xxcam_device *cam;
> -       struct resource *mem;
> -       int irq;
> -
> -       cam = kzalloc(sizeof(*cam), GFP_KERNEL);
> -       if (!cam) {
> -               dev_err(&pdev->dev, "could not allocate memory\n");
> -               goto err;
> -       }
> -
> -       platform_set_drvdata(pdev, cam);
> -
> -       cam->dev = &pdev->dev;
> -
> -       /*
> -        * Impose a lower limit on the amount of memory allocated for
> -        * capture. We require at least enough memory to double-buffer
> -        * QVGA (300KB).
> -        */
> -       if (capture_mem < 320 * 240 * 2 * 2)
> -               capture_mem = 320 * 240 * 2 * 2;
> -       cam->capture_mem = capture_mem;
> -
> -       /* request the mem region for the camera registers */
> -       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!mem) {
> -               dev_err(cam->dev, "no mem resource?\n");
> -               goto err;
> -       }
> -       if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
> -               dev_err(cam->dev,
> -                       "cannot reserve camera register I/O region\n");
> -               goto err;
> -       }
> -       cam->mmio_base_phys = mem->start;
> -       cam->mmio_size = resource_size(mem);
> -
> -       /* map the region */
> -       cam->mmio_base = ioremap_nocache(cam->mmio_base_phys, cam->mmio_size);
> -       if (!cam->mmio_base) {
> -               dev_err(cam->dev, "cannot map camera register I/O region\n");
> -               goto err;
> -       }
> -
> -       irq = platform_get_irq(pdev, 0);
> -       if (irq <= 0) {
> -               dev_err(cam->dev, "no irq for camera?\n");
> -               goto err;
> -       }
> -
> -       /* install the interrupt service routine */
> -       if (request_irq(irq, omap24xxcam_isr, 0, CAM_NAME, cam)) {
> -               dev_err(cam->dev,
> -                       "could not install interrupt service routine\n");
> -               goto err;
> -       }
> -       cam->irq = irq;
> -
> -       if (omap24xxcam_clock_get(cam))
> -               goto err;
> -
> -       INIT_WORK(&cam->sensor_reset_work, omap24xxcam_sensor_reset_work);
> -
> -       mutex_init(&cam->mutex);
> -       spin_lock_init(&cam->core_enable_disable_lock);
> -
> -       omap24xxcam_sgdma_init(&cam->sgdma,
> -                              cam->mmio_base + CAMDMA_REG_OFFSET,
> -                              omap24xxcam_stalled_dma_reset,
> -                              (unsigned long)cam);
> -
> -       omap24xxcam.priv = cam;
> -
> -       if (v4l2_int_device_register(&omap24xxcam))
> -               goto err;
> -
> -       return 0;
> -
> -err:
> -       omap24xxcam_remove(pdev);
> -       return -ENODEV;
> -}
> -
> -static int omap24xxcam_remove(struct platform_device *pdev)
> -{
> -       struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
> -
> -       if (!cam)
> -               return 0;
> -
> -       if (omap24xxcam.priv != NULL)
> -               v4l2_int_device_unregister(&omap24xxcam);
> -       omap24xxcam.priv = NULL;
> -
> -       omap24xxcam_clock_put(cam);
> -
> -       if (cam->irq) {
> -               free_irq(cam->irq, cam);
> -               cam->irq = 0;
> -       }
> -
> -       if (cam->mmio_base) {
> -               iounmap((void *)cam->mmio_base);
> -               cam->mmio_base = 0;
> -       }
> -
> -       if (cam->mmio_base_phys) {
> -               release_mem_region(cam->mmio_base_phys, cam->mmio_size);
> -               cam->mmio_base_phys = 0;
> -       }
> -
> -       kfree(cam);
> -
> -       return 0;
> -}
> -
> -static struct platform_driver omap24xxcam_driver = {
> -       .probe   = omap24xxcam_probe,
> -       .remove  = omap24xxcam_remove,
> -#ifdef CONFIG_PM
> -       .suspend = omap24xxcam_suspend,
> -       .resume  = omap24xxcam_resume,
> -#endif
> -       .driver  = {
> -               .name = CAM_NAME,
> -               .owner = THIS_MODULE,
> -       },
> -};
> -
> -module_platform_driver(omap24xxcam_driver);
> -
> -MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
> -MODULE_DESCRIPTION("OMAP24xx Video for Linux camera driver");
> -MODULE_LICENSE("GPL");
> -MODULE_VERSION(OMAP24XXCAM_VERSION);
> -module_param(video_nr, int, 0);
> -MODULE_PARM_DESC(video_nr,
> -                "Minor number for video device (-1 ==> auto assign)");
> -module_param(capture_mem, int, 0);
> -MODULE_PARM_DESC(capture_mem, "Maximum amount of memory for capture "
> -                "buffers (default 4800kiB)");
> diff --git a/drivers/media/platform/omap24xxcam.h b/drivers/media/platform/omap24xxcam.h
> deleted file mode 100644
> index c439595..0000000
> --- a/drivers/media/platform/omap24xxcam.h
> +++ /dev/null
> @@ -1,593 +0,0 @@
> -/*
> - * drivers/media/platform/omap24xxcam.h
> - *
> - * Copyright (C) 2004 MontaVista Software, Inc.
> - * Copyright (C) 2004 Texas Instruments.
> - * Copyright (C) 2007 Nokia Corporation.
> - *
> - * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> - *
> - * Based on code from Andy Lowe <source@mvista.com>.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * version 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> - * 02110-1301 USA
> - */
> -
> -#ifndef OMAP24XXCAM_H
> -#define OMAP24XXCAM_H
> -
> -#include <media/videobuf-dma-sg.h>
> -#include <media/v4l2-int-device.h>
> -
> -/*
> - *
> - * General driver related definitions.
> - *
> - */
> -
> -#define CAM_NAME                               "omap24xxcam"
> -
> -#define CAM_MCLK                               96000000
> -
> -/* number of bytes transferred per DMA request */
> -#define DMA_THRESHOLD                          32
> -
> -/*
> - * NUM_CAMDMA_CHANNELS is the number of logical channels provided by
> - * the camera DMA controller.
> - */
> -#define NUM_CAMDMA_CHANNELS                    4
> -
> -/*
> - * NUM_SG_DMA is the number of scatter-gather DMA transfers that can
> - * be queued. (We don't have any overlay sglists now.)
> - */
> -#define NUM_SG_DMA                             (VIDEO_MAX_FRAME)
> -
> -/*
> - *
> - * Register definitions.
> - *
> - */
> -
> -/* subsystem register block offsets */
> -#define CC_REG_OFFSET                          0x00000400
> -#define CAMDMA_REG_OFFSET                      0x00000800
> -#define CAMMMU_REG_OFFSET                      0x00000C00
> -
> -/* define camera subsystem register offsets */
> -#define CAM_REVISION                           0x000
> -#define CAM_SYSCONFIG                          0x010
> -#define CAM_SYSSTATUS                          0x014
> -#define CAM_IRQSTATUS                          0x018
> -#define CAM_GPO                                        0x040
> -#define CAM_GPI                                        0x050
> -
> -/* define camera core register offsets */
> -#define CC_REVISION                            0x000
> -#define CC_SYSCONFIG                           0x010
> -#define CC_SYSSTATUS                           0x014
> -#define CC_IRQSTATUS                           0x018
> -#define CC_IRQENABLE                           0x01C
> -#define CC_CTRL                                        0x040
> -#define CC_CTRL_DMA                            0x044
> -#define CC_CTRL_XCLK                           0x048
> -#define CC_FIFODATA                            0x04C
> -#define CC_TEST                                        0x050
> -#define CC_GENPAR                              0x054
> -#define CC_CCPFSCR                             0x058
> -#define CC_CCPFECR                             0x05C
> -#define CC_CCPLSCR                             0x060
> -#define CC_CCPLECR                             0x064
> -#define CC_CCPDFR                              0x068
> -
> -/* define camera dma register offsets */
> -#define CAMDMA_REVISION                                0x000
> -#define CAMDMA_IRQSTATUS_L0                    0x008
> -#define CAMDMA_IRQSTATUS_L1                    0x00C
> -#define CAMDMA_IRQSTATUS_L2                    0x010
> -#define CAMDMA_IRQSTATUS_L3                    0x014
> -#define CAMDMA_IRQENABLE_L0                    0x018
> -#define CAMDMA_IRQENABLE_L1                    0x01C
> -#define CAMDMA_IRQENABLE_L2                    0x020
> -#define CAMDMA_IRQENABLE_L3                    0x024
> -#define CAMDMA_SYSSTATUS                       0x028
> -#define CAMDMA_OCP_SYSCONFIG                   0x02C
> -#define CAMDMA_CAPS_0                          0x064
> -#define CAMDMA_CAPS_2                          0x06C
> -#define CAMDMA_CAPS_3                          0x070
> -#define CAMDMA_CAPS_4                          0x074
> -#define CAMDMA_GCR                             0x078
> -#define CAMDMA_CCR(n)                          (0x080 + (n)*0x60)
> -#define CAMDMA_CLNK_CTRL(n)                    (0x084 + (n)*0x60)
> -#define CAMDMA_CICR(n)                         (0x088 + (n)*0x60)
> -#define CAMDMA_CSR(n)                          (0x08C + (n)*0x60)
> -#define CAMDMA_CSDP(n)                         (0x090 + (n)*0x60)
> -#define CAMDMA_CEN(n)                          (0x094 + (n)*0x60)
> -#define CAMDMA_CFN(n)                          (0x098 + (n)*0x60)
> -#define CAMDMA_CSSA(n)                         (0x09C + (n)*0x60)
> -#define CAMDMA_CDSA(n)                         (0x0A0 + (n)*0x60)
> -#define CAMDMA_CSEI(n)                         (0x0A4 + (n)*0x60)
> -#define CAMDMA_CSFI(n)                         (0x0A8 + (n)*0x60)
> -#define CAMDMA_CDEI(n)                         (0x0AC + (n)*0x60)
> -#define CAMDMA_CDFI(n)                         (0x0B0 + (n)*0x60)
> -#define CAMDMA_CSAC(n)                         (0x0B4 + (n)*0x60)
> -#define CAMDMA_CDAC(n)                         (0x0B8 + (n)*0x60)
> -#define CAMDMA_CCEN(n)                         (0x0BC + (n)*0x60)
> -#define CAMDMA_CCFN(n)                         (0x0C0 + (n)*0x60)
> -#define CAMDMA_COLOR(n)                                (0x0C4 + (n)*0x60)
> -
> -/* define camera mmu register offsets */
> -#define CAMMMU_REVISION                                0x000
> -#define CAMMMU_SYSCONFIG                       0x010
> -#define CAMMMU_SYSSTATUS                       0x014
> -#define CAMMMU_IRQSTATUS                       0x018
> -#define CAMMMU_IRQENABLE                       0x01C
> -#define CAMMMU_WALKING_ST                      0x040
> -#define CAMMMU_CNTL                            0x044
> -#define CAMMMU_FAULT_AD                                0x048
> -#define CAMMMU_TTB                             0x04C
> -#define CAMMMU_LOCK                            0x050
> -#define CAMMMU_LD_TLB                          0x054
> -#define CAMMMU_CAM                             0x058
> -#define CAMMMU_RAM                             0x05C
> -#define CAMMMU_GFLUSH                          0x060
> -#define CAMMMU_FLUSH_ENTRY                     0x064
> -#define CAMMMU_READ_CAM                                0x068
> -#define CAMMMU_READ_RAM                                0x06C
> -#define CAMMMU_EMU_FAULT_AD                    0x070
> -
> -/* Define bit fields within selected registers */
> -#define CAM_REVISION_MAJOR                     (15 << 4)
> -#define CAM_REVISION_MAJOR_SHIFT               4
> -#define CAM_REVISION_MINOR                     (15 << 0)
> -#define CAM_REVISION_MINOR_SHIFT               0
> -
> -#define CAM_SYSCONFIG_SOFTRESET                        (1 <<  1)
> -#define CAM_SYSCONFIG_AUTOIDLE                 (1 <<  0)
> -
> -#define CAM_SYSSTATUS_RESETDONE                        (1 <<  0)
> -
> -#define CAM_IRQSTATUS_CC_IRQ                   (1 <<  4)
> -#define CAM_IRQSTATUS_MMU_IRQ                  (1 <<  3)
> -#define CAM_IRQSTATUS_DMA_IRQ2                 (1 <<  2)
> -#define CAM_IRQSTATUS_DMA_IRQ1                 (1 <<  1)
> -#define CAM_IRQSTATUS_DMA_IRQ0                 (1 <<  0)
> -
> -#define CAM_GPO_CAM_S_P_EN                     (1 <<  1)
> -#define CAM_GPO_CAM_CCP_MODE                   (1 <<  0)
> -
> -#define CAM_GPI_CC_DMA_REQ1                    (1 << 24)
> -#define CAP_GPI_CC_DMA_REQ0                    (1 << 23)
> -#define CAP_GPI_CAM_MSTANDBY                   (1 << 21)
> -#define CAP_GPI_CAM_WAIT                       (1 << 20)
> -#define CAP_GPI_CAM_S_DATA                     (1 << 17)
> -#define CAP_GPI_CAM_S_CLK                      (1 << 16)
> -#define CAP_GPI_CAM_P_DATA                     (0xFFF << 3)
> -#define CAP_GPI_CAM_P_DATA_SHIFT               3
> -#define CAP_GPI_CAM_P_VS                       (1 <<  2)
> -#define CAP_GPI_CAM_P_HS                       (1 <<  1)
> -#define CAP_GPI_CAM_P_CLK                      (1 <<  0)
> -
> -#define CC_REVISION_MAJOR                      (15 << 4)
> -#define CC_REVISION_MAJOR_SHIFT                        4
> -#define CC_REVISION_MINOR                      (15 << 0)
> -#define CC_REVISION_MINOR_SHIFT                        0
> -
> -#define CC_SYSCONFIG_SIDLEMODE                 (3 <<  3)
> -#define CC_SYSCONFIG_SIDLEMODE_FIDLE           (0 <<  3)
> -#define CC_SYSCONFIG_SIDLEMODE_NIDLE           (1 <<  3)
> -#define CC_SYSCONFIG_SOFTRESET                 (1 <<  1)
> -#define CC_SYSCONFIG_AUTOIDLE                  (1 <<  0)
> -
> -#define CC_SYSSTATUS_RESETDONE                 (1 <<  0)
> -
> -#define CC_IRQSTATUS_FS_IRQ                    (1 << 19)
> -#define CC_IRQSTATUS_LE_IRQ                    (1 << 18)
> -#define CC_IRQSTATUS_LS_IRQ                    (1 << 17)
> -#define CC_IRQSTATUS_FE_IRQ                    (1 << 16)
> -#define CC_IRQSTATUS_FW_ERR_IRQ                        (1 << 10)
> -#define CC_IRQSTATUS_FSC_ERR_IRQ               (1 <<  9)
> -#define CC_IRQSTATUS_SSC_ERR_IRQ               (1 <<  8)
> -#define CC_IRQSTATUS_FIFO_NOEMPTY_IRQ          (1 <<  4)
> -#define CC_IRQSTATUS_FIFO_FULL_IRQ             (1 <<  3)
> -#define CC_IRQSTATUS_FIFO_THR_IRQ              (1 <<  2)
> -#define CC_IRQSTATUS_FIFO_OF_IRQ               (1 <<  1)
> -#define CC_IRQSTATUS_FIFO_UF_IRQ               (1 <<  0)
> -
> -#define CC_IRQENABLE_FS_IRQ                    (1 << 19)
> -#define CC_IRQENABLE_LE_IRQ                    (1 << 18)
> -#define CC_IRQENABLE_LS_IRQ                    (1 << 17)
> -#define CC_IRQENABLE_FE_IRQ                    (1 << 16)
> -#define CC_IRQENABLE_FW_ERR_IRQ                        (1 << 10)
> -#define CC_IRQENABLE_FSC_ERR_IRQ               (1 <<  9)
> -#define CC_IRQENABLE_SSC_ERR_IRQ               (1 <<  8)
> -#define CC_IRQENABLE_FIFO_NOEMPTY_IRQ          (1 <<  4)
> -#define CC_IRQENABLE_FIFO_FULL_IRQ             (1 <<  3)
> -#define CC_IRQENABLE_FIFO_THR_IRQ              (1 <<  2)
> -#define CC_IRQENABLE_FIFO_OF_IRQ               (1 <<  1)
> -#define CC_IRQENABLE_FIFO_UF_IRQ               (1 <<  0)
> -
> -#define CC_CTRL_CC_ONE_SHOT                    (1 << 20)
> -#define CC_CTRL_CC_IF_SYNCHRO                  (1 << 19)
> -#define CC_CTRL_CC_RST                         (1 << 18)
> -#define CC_CTRL_CC_FRAME_TRIG                  (1 << 17)
> -#define CC_CTRL_CC_EN                          (1 << 16)
> -#define CC_CTRL_NOBT_SYNCHRO                   (1 << 13)
> -#define CC_CTRL_BT_CORRECT                     (1 << 12)
> -#define CC_CTRL_PAR_ORDERCAM                   (1 << 11)
> -#define CC_CTRL_PAR_CLK_POL                    (1 << 10)
> -#define CC_CTRL_NOBT_HS_POL                    (1 <<  9)
> -#define CC_CTRL_NOBT_VS_POL                    (1 <<  8)
> -#define CC_CTRL_PAR_MODE                       (7 <<  1)
> -#define CC_CTRL_PAR_MODE_SHIFT                 1
> -#define CC_CTRL_PAR_MODE_NOBT8                 (0 <<  1)
> -#define CC_CTRL_PAR_MODE_NOBT10                        (1 <<  1)
> -#define CC_CTRL_PAR_MODE_NOBT12                        (2 <<  1)
> -#define CC_CTRL_PAR_MODE_BT8                   (4 <<  1)
> -#define CC_CTRL_PAR_MODE_BT10                  (5 <<  1)
> -#define CC_CTRL_PAR_MODE_FIFOTEST              (7 <<  1)
> -#define CC_CTRL_CCP_MODE                       (1 <<  0)
> -
> -#define CC_CTRL_DMA_EN                         (1 <<  8)
> -#define CC_CTRL_DMA_FIFO_THRESHOLD             (0x7F << 0)
> -#define CC_CTRL_DMA_FIFO_THRESHOLD_SHIFT       0
> -
> -#define CC_CTRL_XCLK_DIV                       (0x1F << 0)
> -#define CC_CTRL_XCLK_DIV_SHIFT                 0
> -#define CC_CTRL_XCLK_DIV_STABLE_LOW            (0 <<  0)
> -#define CC_CTRL_XCLK_DIV_STABLE_HIGH           (1 <<  0)
> -#define CC_CTRL_XCLK_DIV_BYPASS                        (31 << 0)
> -
> -#define CC_TEST_FIFO_RD_POINTER                        (0xFF << 24)
> -#define CC_TEST_FIFO_RD_POINTER_SHIFT          24
> -#define CC_TEST_FIFO_WR_POINTER                        (0xFF << 16)
> -#define CC_TEST_FIFO_WR_POINTER_SHIFT          16
> -#define CC_TEST_FIFO_LEVEL                     (0xFF <<  8)
> -#define CC_TEST_FIFO_LEVEL_SHIFT               8
> -#define CC_TEST_FIFO_LEVEL_PEAK                        (0xFF <<  0)
> -#define CC_TEST_FIFO_LEVEL_PEAK_SHIFT          0
> -
> -#define CC_GENPAR_FIFO_DEPTH                   (7 <<  0)
> -#define CC_GENPAR_FIFO_DEPTH_SHIFT             0
> -
> -#define CC_CCPDFR_ALPHA                                (0xFF <<  8)
> -#define CC_CCPDFR_ALPHA_SHIFT                  8
> -#define CC_CCPDFR_DATAFORMAT                   (15 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_SHIFT             0
> -#define CC_CCPDFR_DATAFORMAT_YUV422BE          (0 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_YUV422            (1 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_YUV420            (2 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RGB444            (4 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RGB565            (5 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RGB888NDE         (6 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RGB888            (7 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RAW8NDE           (8 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RAW8              (9 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RAW10NDE          (10 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RAW10             (11 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RAW12NDE          (12 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_RAW12             (13 <<  0)
> -#define CC_CCPDFR_DATAFORMAT_JPEG8             (15 <<  0)
> -
> -#define CAMDMA_REVISION_MAJOR                  (15 << 4)
> -#define CAMDMA_REVISION_MAJOR_SHIFT            4
> -#define CAMDMA_REVISION_MINOR                  (15 << 0)
> -#define CAMDMA_REVISION_MINOR_SHIFT            0
> -
> -#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE         (3 << 12)
> -#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_FSTANDBY        (0 << 12)
> -#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_NSTANDBY        (1 << 12)
> -#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_SSTANDBY        (2 << 12)
> -#define CAMDMA_OCP_SYSCONFIG_FUNC_CLOCK                (1 <<  9)
> -#define CAMDMA_OCP_SYSCONFIG_OCP_CLOCK         (1 <<  8)
> -#define CAMDMA_OCP_SYSCONFIG_EMUFREE           (1 <<  5)
> -#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE         (3 <<  3)
> -#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_FIDLE   (0 <<  3)
> -#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_NIDLE   (1 <<  3)
> -#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_SIDLE   (2 <<  3)
> -#define CAMDMA_OCP_SYSCONFIG_SOFTRESET         (1 <<  1)
> -#define CAMDMA_OCP_SYSCONFIG_AUTOIDLE          (1 <<  0)
> -
> -#define CAMDMA_SYSSTATUS_RESETDONE             (1 <<  0)
> -
> -#define CAMDMA_GCR_ARBITRATION_RATE            (0xFF << 16)
> -#define CAMDMA_GCR_ARBITRATION_RATE_SHIFT      16
> -#define CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH      (0xFF << 0)
> -#define CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH_SHIFT        0
> -
> -#define CAMDMA_CCR_SEL_SRC_DST_SYNC            (1 << 24)
> -#define CAMDMA_CCR_PREFETCH                    (1 << 23)
> -#define CAMDMA_CCR_SUPERVISOR                  (1 << 22)
> -#define CAMDMA_CCR_SECURE                      (1 << 21)
> -#define CAMDMA_CCR_BS                          (1 << 18)
> -#define CAMDMA_CCR_TRANSPARENT_COPY_ENABLE     (1 << 17)
> -#define CAMDMA_CCR_CONSTANT_FILL_ENABLE                (1 << 16)
> -#define CAMDMA_CCR_DST_AMODE                   (3 << 14)
> -#define CAMDMA_CCR_DST_AMODE_CONST_ADDR                (0 << 14)
> -#define CAMDMA_CCR_DST_AMODE_POST_INC          (1 << 14)
> -#define CAMDMA_CCR_DST_AMODE_SGL_IDX           (2 << 14)
> -#define CAMDMA_CCR_DST_AMODE_DBL_IDX           (3 << 14)
> -#define CAMDMA_CCR_SRC_AMODE                   (3 << 12)
> -#define CAMDMA_CCR_SRC_AMODE_CONST_ADDR                (0 << 12)
> -#define CAMDMA_CCR_SRC_AMODE_POST_INC          (1 << 12)
> -#define CAMDMA_CCR_SRC_AMODE_SGL_IDX           (2 << 12)
> -#define CAMDMA_CCR_SRC_AMODE_DBL_IDX           (3 << 12)
> -#define CAMDMA_CCR_WR_ACTIVE                   (1 << 10)
> -#define CAMDMA_CCR_RD_ACTIVE                   (1 <<  9)
> -#define CAMDMA_CCR_SUSPEND_SENSITIVE           (1 <<  8)
> -#define CAMDMA_CCR_ENABLE                      (1 <<  7)
> -#define CAMDMA_CCR_PRIO                                (1 <<  6)
> -#define CAMDMA_CCR_FS                          (1 <<  5)
> -#define CAMDMA_CCR_SYNCHRO                     ((3 << 19) | (31 << 0))
> -#define CAMDMA_CCR_SYNCHRO_CAMERA              0x01
> -
> -#define CAMDMA_CLNK_CTRL_ENABLE_LNK            (1 << 15)
> -#define CAMDMA_CLNK_CTRL_NEXTLCH_ID            (0x1F << 0)
> -#define CAMDMA_CLNK_CTRL_NEXTLCH_ID_SHIFT      0
> -
> -#define CAMDMA_CICR_MISALIGNED_ERR_IE          (1 << 11)
> -#define CAMDMA_CICR_SUPERVISOR_ERR_IE          (1 << 10)
> -#define CAMDMA_CICR_SECURE_ERR_IE              (1 <<  9)
> -#define CAMDMA_CICR_TRANS_ERR_IE               (1 <<  8)
> -#define CAMDMA_CICR_PACKET_IE                  (1 <<  7)
> -#define CAMDMA_CICR_BLOCK_IE                   (1 <<  5)
> -#define CAMDMA_CICR_LAST_IE                    (1 <<  4)
> -#define CAMDMA_CICR_FRAME_IE                   (1 <<  3)
> -#define CAMDMA_CICR_HALF_IE                    (1 <<  2)
> -#define CAMDMA_CICR_DROP_IE                    (1 <<  1)
> -
> -#define CAMDMA_CSR_MISALIGNED_ERR              (1 << 11)
> -#define CAMDMA_CSR_SUPERVISOR_ERR              (1 << 10)
> -#define CAMDMA_CSR_SECURE_ERR                  (1 <<  9)
> -#define CAMDMA_CSR_TRANS_ERR                   (1 <<  8)
> -#define CAMDMA_CSR_PACKET                      (1 <<  7)
> -#define CAMDMA_CSR_SYNC                                (1 <<  6)
> -#define CAMDMA_CSR_BLOCK                       (1 <<  5)
> -#define CAMDMA_CSR_LAST                                (1 <<  4)
> -#define CAMDMA_CSR_FRAME                       (1 <<  3)
> -#define CAMDMA_CSR_HALF                                (1 <<  2)
> -#define CAMDMA_CSR_DROP                                (1 <<  1)
> -
> -#define CAMDMA_CSDP_SRC_ENDIANNESS             (1 << 21)
> -#define CAMDMA_CSDP_SRC_ENDIANNESS_LOCK                (1 << 20)
> -#define CAMDMA_CSDP_DST_ENDIANNESS             (1 << 19)
> -#define CAMDMA_CSDP_DST_ENDIANNESS_LOCK                (1 << 18)
> -#define CAMDMA_CSDP_WRITE_MODE                 (3 << 16)
> -#define CAMDMA_CSDP_WRITE_MODE_WRNP            (0 << 16)
> -#define CAMDMA_CSDP_WRITE_MODE_POSTED          (1 << 16)
> -#define CAMDMA_CSDP_WRITE_MODE_POSTED_LAST_WRNP        (2 << 16)
> -#define CAMDMA_CSDP_DST_BURST_EN               (3 << 14)
> -#define CAMDMA_CSDP_DST_BURST_EN_1             (0 << 14)
> -#define CAMDMA_CSDP_DST_BURST_EN_16            (1 << 14)
> -#define CAMDMA_CSDP_DST_BURST_EN_32            (2 << 14)
> -#define CAMDMA_CSDP_DST_BURST_EN_64            (3 << 14)
> -#define CAMDMA_CSDP_DST_PACKED                 (1 << 13)
> -#define CAMDMA_CSDP_WR_ADD_TRSLT               (15 << 9)
> -#define CAMDMA_CSDP_WR_ADD_TRSLT_ENABLE_MREQADD        (3 <<  9)
> -#define CAMDMA_CSDP_SRC_BURST_EN               (3 <<  7)
> -#define CAMDMA_CSDP_SRC_BURST_EN_1             (0 <<  7)
> -#define CAMDMA_CSDP_SRC_BURST_EN_16            (1 <<  7)
> -#define CAMDMA_CSDP_SRC_BURST_EN_32            (2 <<  7)
> -#define CAMDMA_CSDP_SRC_BURST_EN_64            (3 <<  7)
> -#define CAMDMA_CSDP_SRC_PACKED                 (1 <<  6)
> -#define CAMDMA_CSDP_RD_ADD_TRSLT               (15 << 2)
> -#define CAMDMA_CSDP_RD_ADD_TRSLT_ENABLE_MREQADD        (3 <<  2)
> -#define CAMDMA_CSDP_DATA_TYPE                  (3 <<  0)
> -#define CAMDMA_CSDP_DATA_TYPE_8BITS            (0 <<  0)
> -#define CAMDMA_CSDP_DATA_TYPE_16BITS           (1 <<  0)
> -#define CAMDMA_CSDP_DATA_TYPE_32BITS           (2 <<  0)
> -
> -#define CAMMMU_SYSCONFIG_AUTOIDLE              (1 <<  0)
> -
> -/*
> - *
> - * Declarations.
> - *
> - */
> -
> -/* forward declarations */
> -struct omap24xxcam_sgdma;
> -struct omap24xxcam_dma;
> -
> -typedef void (*sgdma_callback_t)(struct omap24xxcam_sgdma *cam,
> -                                u32 status, void *arg);
> -typedef void (*dma_callback_t)(struct omap24xxcam_dma *cam,
> -                              u32 status, void *arg);
> -
> -struct channel_state {
> -       dma_callback_t callback;
> -       void *arg;
> -};
> -
> -/* sgdma state for each of the possible videobuf_buffers + 2 overlays */
> -struct sgdma_state {
> -       const struct scatterlist *sglist;
> -       int sglen;               /* number of sglist entries */
> -       int next_sglist;         /* index of next sglist entry to process */
> -       unsigned int bytes_read; /* number of bytes read */
> -       unsigned int len;        /* total length of sglist (excluding
> -                                 * bytes due to page alignment) */
> -       int queued_sglist;       /* number of sglist entries queued for DMA */
> -       u32 csr;                 /* DMA return code */
> -       sgdma_callback_t callback;
> -       void *arg;
> -};
> -
> -/* physical DMA channel management */
> -struct omap24xxcam_dma {
> -       spinlock_t lock;        /* Lock for the whole structure. */
> -
> -       void __iomem *base;     /* base address for dma controller */
> -
> -       /* While dma_stop!=0, an attempt to start a new DMA transfer will
> -        * fail.
> -        */
> -       atomic_t dma_stop;
> -       int free_dmach;         /* number of dma channels free */
> -       int next_dmach;         /* index of next dma channel to use */
> -       struct channel_state ch_state[NUM_CAMDMA_CHANNELS];
> -};
> -
> -/* scatter-gather DMA (scatterlist stuff) management */
> -struct omap24xxcam_sgdma {
> -       struct omap24xxcam_dma dma;
> -
> -       spinlock_t lock;        /* Lock for the fields below. */
> -       int free_sgdma;         /* number of free sg dma slots */
> -       int next_sgdma;         /* index of next sg dma slot to use */
> -       struct sgdma_state sg_state[NUM_SG_DMA];
> -
> -       /* Reset timer data */
> -       struct timer_list reset_timer;
> -};
> -
> -/* per-device data structure */
> -struct omap24xxcam_device {
> -       /*** mutex  ***/
> -       /*
> -        * mutex serialises access to this structure. Also camera
> -        * opening and releasing is synchronised by this.
> -        */
> -       struct mutex mutex;
> -
> -       /*** general driver state information ***/
> -       atomic_t users;
> -       /*
> -        * Lock to serialise core enabling and disabling and access to
> -        * sgdma_in_queue.
> -        */
> -       spinlock_t core_enable_disable_lock;
> -       /*
> -        * Number or sgdma requests in scatter-gather queue, protected
> -        * by the lock above.
> -        */
> -       int sgdma_in_queue;
> -       /*
> -        * Sensor interface parameters: interface type, CC_CTRL
> -        * register value and interface specific data.
> -        */
> -       int if_type;
> -       union {
> -               struct parallel {
> -                       u32 xclk;
> -               } bt656;
> -       } if_u;
> -       u32 cc_ctrl;
> -
> -       /*** subsystem structures ***/
> -       struct omap24xxcam_sgdma sgdma;
> -
> -       /*** hardware resources ***/
> -       unsigned int irq;
> -       void __iomem *mmio_base;
> -       unsigned long mmio_base_phys;
> -       unsigned long mmio_size;
> -
> -       /*** interfaces and device ***/
> -       struct v4l2_int_device *sdev;
> -       struct device *dev;
> -       struct video_device *vfd;
> -
> -       /*** camera and sensor reset related stuff ***/
> -       struct work_struct sensor_reset_work;
> -       /*
> -        * We're in the middle of a reset. Don't enable core if this
> -        * is non-zero! This exists to help decisionmaking in a case
> -        * where videobuf_qbuf is called while we are in the middle of
> -        * a reset.
> -        */
> -       atomic_t in_reset;
> -       /*
> -        * Non-zero if we don't want any resets for now. Used to
> -        * prevent reset work to run when we're about to stop
> -        * streaming.
> -        */
> -       atomic_t reset_disable;
> -
> -       /*** video device parameters ***/
> -       int capture_mem;
> -
> -       /*** camera module clocks ***/
> -       struct clk *fck;
> -       struct clk *ick;
> -
> -       /*** capture data ***/
> -       /* file handle, if streaming is on */
> -       struct file *streaming;
> -};
> -
> -/* Per-file handle data. */
> -struct omap24xxcam_fh {
> -       spinlock_t vbq_lock; /* spinlock for the videobuf queue */
> -       struct videobuf_queue vbq;
> -       struct v4l2_pix_format pix; /* serialise pix by vbq->lock */
> -       atomic_t field_count; /* field counter for videobuf_buffer */
> -       /* accessing cam here doesn't need serialisation: it's constant */
> -       struct omap24xxcam_device *cam;
> -};
> -
> -/*
> - *
> - * Register I/O functions.
> - *
> - */
> -
> -static inline u32 omap24xxcam_reg_in(u32 __iomem *base, u32 offset)
> -{
> -       return readl(base + offset);
> -}
> -
> -static inline u32 omap24xxcam_reg_out(u32 __iomem *base, u32 offset,
> -                                         u32 val)
> -{
> -       writel(val, base + offset);
> -       return val;
> -}
> -
> -static inline u32 omap24xxcam_reg_merge(u32 __iomem *base, u32 offset,
> -                                           u32 val, u32 mask)
> -{
> -       u32 __iomem *addr = base + offset;
> -       u32 new_val = (readl(addr) & ~mask) | (val & mask);
> -
> -       writel(new_val, addr);
> -       return new_val;
> -}
> -
> -/*
> - *
> - * Function prototypes.
> - *
> - */
> -
> -/* dma prototypes */
> -
> -void omap24xxcam_dma_hwinit(struct omap24xxcam_dma *dma);
> -void omap24xxcam_dma_isr(struct omap24xxcam_dma *dma);
> -
> -/* sgdma prototypes */
> -
> -void omap24xxcam_sgdma_process(struct omap24xxcam_sgdma *sgdma);
> -int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
> -                           const struct scatterlist *sglist, int sglen,
> -                           int len, sgdma_callback_t callback, void *arg);
> -void omap24xxcam_sgdma_sync(struct omap24xxcam_sgdma *sgdma);
> -void omap24xxcam_sgdma_init(struct omap24xxcam_sgdma *sgdma,
> -                           void __iomem *base,
> -                           void (*reset_callback)(unsigned long data),
> -                           unsigned long reset_callback_data);
> -void omap24xxcam_sgdma_exit(struct omap24xxcam_sgdma *sgdma);
> -
> -#endif
> --
> 1.7.2.5
>
