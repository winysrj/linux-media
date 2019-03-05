Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE122C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 07:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2571020675
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 07:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CO9TBkXK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfCEH5X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 02:57:23 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42299 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfCEH5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 02:57:23 -0500
Received: by mail-oi1-f196.google.com with SMTP id s16so6113208oih.9
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2019 23:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=due81MSr3h7oRfadGi+yrAXNr0J9syz3tvbNBo8kKtg=;
        b=CO9TBkXKkYsgd63d8TKudgLjiU3FJJSxHTIprdJbRvwZfvt2uScm4carT4yjpmoEjr
         GwksjmM9tthv309htsbZdGVIxoClAiaijet0PU6GqhbW68uE8ZYH0jUv7dLdEHqJZnBb
         FquXVDpMpCtzdlj9aabAPmaMM9rSC2+Ifshvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=due81MSr3h7oRfadGi+yrAXNr0J9syz3tvbNBo8kKtg=;
        b=TxmVH6M/w7p1mVa9iVlo+NQrzyBN4d96CMkSeFVG568iUYuuxYLoynjeuotKgDjLrb
         +b1ppUQ0Ku82b2PxhF7NSWjmMLmhCQ4SGhRSrsQbpy7O9EnOxLAf490++r8mgBYO453m
         77Zz6FG+evjX7A5ayPe8FcOvBlUt9aIPlzHD3kEvsV4+uZblcIKD3Fe4BVmzcZUbb9bs
         /i5+bFXUv6vbCvc5MdmV5Rmh8DgYnKbAo8bcggwnF4qPi/UM1s9W8QwAVXJ7Uz4YkF0r
         wPtpDtGMZTYA9mYDYVUSvdRviL/b1jo0NDRFV+tmJz0lhwD3WHk70hb8ERSmMGgpqT+f
         088A==
X-Gm-Message-State: AHQUAuY3Lzi6ZOQyIFMJpHFba4gNqAWwa3m4PfbXNLxzLGSUh6IZNt7K
        CFRGwQcOXKM4mu3T/iNM3f/Ux4CVYdk=
X-Google-Smtp-Source: AHgI3Ib6NGBjTgzIBjJegeWiXmZf+y04RgDLBxn2RIjgwKP/kUsaj91HbDHpZyqNpvVLCUjK1KymvQ==
X-Received: by 2002:aca:5f09:: with SMTP id t9mr13535167oib.89.1551772636798;
        Mon, 04 Mar 2019 23:57:16 -0800 (PST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com. [209.85.210.48])
        by smtp.gmail.com with ESMTPSA id m15sm3309315otl.32.2019.03.04.23.57.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Mar 2019 23:57:16 -0800 (PST)
Received: by mail-ot1-f48.google.com with SMTP id g1so6654485otj.11
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2019 23:57:16 -0800 (PST)
X-Received: by 2002:a9d:4c85:: with SMTP id m5mr126064otf.367.1551772147884;
 Mon, 04 Mar 2019 23:49:07 -0800 (PST)
MIME-Version: 1.0
References: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com> <1550648893-42050-8-git-send-email-Jerry-Ch.chen@mediatek.com>
In-Reply-To: <1550648893-42050-8-git-send-email-Jerry-Ch.chen@mediatek.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 5 Mar 2019 16:48:54 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CfQVa-qU1qiapc07Ey2KNDEO+MOq6v98ZCVP8w8u=C4Q@mail.gmail.com>
Message-ID: <CAAFQd5CfQVa-qU1qiapc07Ey2KNDEO+MOq6v98ZCVP8w8u=C4Q@mail.gmail.com>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek FD driver
To:     Jerry-ch Chen <Jerry-Ch.chen@mediatek.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        yuzhao@chromium.org, zwisler@chromium.org,
        linux-mediatek@lists.infradead.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?U2VhbiBDaGVuZyAo6YSt5piH5byYKQ==?= 
        <Sean.Cheng@mediatek.com>, Sj Huang <sj.huang@mediatek.com>,
        =?UTF-8?B?Q2hyaXN0aWUgWXUgKOa4uOmbheaDoCk=?= 
        <christie.yu@mediatek.com>,
        =?UTF-8?B?SG9sbWVzIENoaW91ICjpgrHmjLop?= 
        <holmes.chiou@mediatek.com>,
        =?UTF-8?B?RnJlZGVyaWMgQ2hlbiAo6Zmz5L+K5YWDKQ==?= 
        <frederic.chen@mediatek.com>,
        =?UTF-8?B?SnVuZ28gTGluICjmnpfmmI7kv4op?= <jungo.lin@mediatek.com>,
        =?UTF-8?B?UnlubiBXdSAo5ZCz6IKy5oGpKQ==?= <Rynn.Wu@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        srv_heupstream@mediatek.com, devicetree@vger.kernel.org,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Shik Chen <shik@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

+CC Shik and Keiichi

On Wed, Feb 20, 2019 at 4:53 PM Jerry-ch Chen
<Jerry-Ch.chen@mediatek.com> wrote:
>
> This patch adds the driver of Face Detection (FD) unit in
> Mediatek camera system, providing face detection function.
>
> The mtk-isp directory will contain drivers for multiple IP
> blocks found in Mediatek ISP system. It will include ISP Pass 1
> driver (CAM), sensor interface driver, DIP driver and face
> detection driver.
>
> Signed-off-by: Jerry-ch Chen <jerry-ch.chen@mediatek.com>
> ---
>  drivers/media/platform/mtk-isp/Makefile            |   16 +
>  drivers/media/platform/mtk-isp/fd/Makefile         |   38 +
>  drivers/media/platform/mtk-isp/fd/mtk_fd-core.h    |  157 +++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h     |  299 ++++++
>  .../platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c      |  912 +++++++++++++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c     |  355 +++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h     |  198 ++++
>  .../media/platform/mtk-isp/fd/mtk_fd-smem-drv.c    |  452 +++++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h    |   25 +
>  .../media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c   | 1046 ++++++++++++++++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c    |  114 +++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h    |   36 +
>  drivers/media/platform/mtk-isp/fd/mtk_fd.c         |  730 ++++++++++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd.h         |  127 +++
>  14 files changed, 4505 insertions(+)
>  create mode 100644 drivers/media/platform/mtk-isp/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/fd/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-core.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-smem-drv.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd.h
>
> diff --git a/drivers/media/platform/mtk-isp/Makefile b/drivers/media/platform/mtk-isp/Makefile
> new file mode 100644
> index 0000000..5e3a9aa
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/Makefile
> @@ -0,0 +1,16 @@
> +#
> +# Copyright (C) 2018 MediaTek Inc.
> +#
> +# This program is free software: you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License version 2 as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +# GNU General Public License for more details.
> +#
> +
> +ifeq ($(CONFIG_VIDEO_MEDIATEK_FD_SUPPORT),y)
> +obj-y += fd/
> +endif
> diff --git a/drivers/media/platform/mtk-isp/fd/Makefile b/drivers/media/platform/mtk-isp/fd/Makefile
> new file mode 100644
> index 0000000..ac168c1
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/Makefile
> @@ -0,0 +1,38 @@
> +#
> +# Copyright (C) 2018 MediaTek Inc.
> +#
> +# This program is free software: you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License version 2 as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +# GNU General Public License for more details.
> +#
> +
> +$(info "FD: makefile start srctree: $(srctree)")
> +ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vpu
> +ccflags-y += -I$(srctree)/drivers/media/platform/mtk-isp/fd
> +#ccflags-y += -I$(srctree)/drivers/media/platform/mtk-isp/common
> +
> +obj-y += mtk_fd.o
> +obj-y += mtk_fd-v4l2.o
> +
> +# To provide alloc context managing memory shared
> +# between CPU and FD coprocessor
> +mtk_fd_smem-objs := \
> +mtk_fd-smem-drv.o
> +
> +obj-y += mtk_fd_smem.o
> +
> +# Utilits to provide frame-based streaming model
> +# with v4l2 user interfaces
> +mtk_fd_util-objs := \
> +mtk_fd-dev.o \
> +mtk_fd-v4l2-util.o \
> +mtk_fd-dev-ctx-core.o
> +
> +obj-y += mtk_fd_util.o
> +
> +$(info "FD: makefile end")
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-core.h b/drivers/media/platform/mtk-isp/fd/mtk_fd-core.h
> new file mode 100644
> index 0000000..a7c1e1d
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-core.h
> @@ -0,0 +1,157 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + * Copyright (C) 2015 MediaTek Inc.
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MTK_FD_CORE_H__
> +#define __MTK_FD_CORE_H__
> +
> +#define SIG_ERESTARTSYS 512
> +
> +#ifndef CONFIG_MTK_CLKMGR
> +#include <linux/clk.h>
> +#endif
> +
> +#ifdef CONFIG_MTK_CLKMGR
> +#include <mach/mt_clkmgr.h>
> +#endif
> +
> +#include "mtk_fd-dev.h"
> +#include "mtk_fd-ctx.h"
> +
> +#include <linux/io.h>
> +
> +#define FD_WR32(v, a) \
> +do { \
> +       __raw_writel((v), (void __force __iomem *)((a))); \
> +       mb(); /* ensure written */ \
> +} while (0)
> +
> +#define FD_RD32(addr)                  ioread32((void *)addr)
> +
> +#define        FD_INT_EN       (0x15c)
> +#define        FD_INT          (0x168)
> +#define        FD_RESULT       (0x178)
> +#define FD_IRQ_MASK    (0x001)
> +
> +#define RS_BUF_SIZE_MAX        (2288788)
> +#define VA_OFFSET      (0xffff000000000000)
> +
> +enum fd_irq {
> +       FD_IRQ_IDX = 0,
> +       FD_IRQ_IDX_NUM
> +};
> +
> +enum fd_state {
> +       FD_INI,
> +       FD_ENQ,
> +       FD_CBD,
> +};
> +
> +enum stream_stat {
> +       STREAM_OFF,
> +       STREAM_ON,
> +};
> +
> +struct ipi_fd_enq_param {
> +       u8 source_img_fmt;
> +       struct fd_buffer output_addr;
> +       struct fd_buffer src_y;
> +       struct fd_buffer src_uv;
> +       struct fd_buffer config_addr;
> +} __packed;
> +
> +struct fd_manager_ctx {
> +       struct fd_buffer learn_data_buf[2][LEARNDATA_NUM];
> +       struct fd_buffer fd_config;
> +       struct fd_buffer rs_config;
> +       struct fd_buffer fd_result;
> +       struct fd_buffer rs_result;
> +       struct fd_buffer src_img;
> +} __packed;
> +
> +struct mtk_fd_drv_ctx {
> +       struct sg_table sgtable;
> +       u32 frame_id;
> +       struct fd_buffer rs_result;
> +       struct fd_buffer scp_mem;
> +       struct platform_device *vpu_pdev;
> +
> +       atomic_t fd_enque_cnt;
> +       atomic_t fd_stream_cnt;
> +       atomic_t fd_user_cnt;
> +};
> +
> +struct mtk_fd_drv_dev {
> +       struct platform_device *pdev;
> +
> +       dev_t fd_devno;
> +       struct cdev   fd_cdev;
> +       struct class *fd_class;
> +       struct mtk_fd_drv_ctx fd_ctx;
> +
> +       struct device *larb_dev;
> +       struct clk *fd_clk;
> +       enum fd_state state;
> +       enum stream_stat streaming;
> +
> +       wait_queue_head_t wq;
> +       u32 fd_irq_result;
> +
> +       void __iomem *fd_base;
> +};
> +
> +struct mtk_isp_fd_drv_data {
> +       struct mtk_fd_dev fd_dev;
> +       struct mtk_fd_drv_dev fd_hw_dev;
> +} __packed;
> +
> +static inline struct mtk_fd_drv_dev *get_fd_hw_device(struct device *dev)
> +{
> +       struct mtk_isp_fd_drv_data *drv_data =
> +               dev_get_drvdata(dev);
> +       if (drv_data)
> +               return &drv_data->fd_hw_dev;
> +       else
> +               return NULL;
> +}
> +
> +#define mtk_fd_us_to_jiffies(us) \
> +       ((((unsigned long)(us) / 1000) * HZ + 512) >> 10)
> +
> +#define mtk_fd_hw_dev_to_drv(__fd_hw_dev) \
> +       container_of(__fd_hw_dev, \
> +       struct mtk_isp_fd_drv_data, fd_hw_dev)
> +
> +#define mtk_fd_ctx_to_drv(__fd_ctx) \
> +       container_of(__fd_ctx, \
> +       struct mtk_isp_fd_drv_data, fd_hw_dev.fd_ctx)
> +
> +enum fd_scp_cmd {
> +       FD_CMD_INIT,
> +       FD_CMD_ENQ,
> +       FD_CMD_EXIT,
> +};
> +
> +enum fd_clk {
> +       clock_off = 0,
> +       clock_on,
> +};
> +
> +struct ipi_message {
> +       u8 cmd_id;
> +       union {
> +               struct fd_buffer fd_manager;
> +               struct v4l2_fd_param fd_param;
> +       };
> +} __packed;
> +
> +#endif/*__MTK_FD_CORE_H__*/
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h b/drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h
> new file mode 100644
> index 0000000..d78a3af
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h
> @@ -0,0 +1,299 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + * Copyright (c) 2018 MediaTek Inc.
> + * Author: Frederic Chen <frederic.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MTK_FD_CTX_H__
> +#define __MTK_FD_CTX_H__
> +
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/videobuf2-core.h>
> +#include <media/v4l2-subdev.h>
> +
> +#define MTK_FD_CTX_QUEUES (16)
> +#define MTK_FD_CTX_FRAME_BUNDLE_BUFFER_MAX (MTK_FD_CTX_QUEUES)
> +#define MTK_FD_CTX_DESC_MAX (MTK_FD_CTX_QUEUES)
> +
> +#define MTK_FD_CTX_MODE_DEBUG_OFF (0)
> +#define MTK_FD_CTX_MODE_DEBUG_BYPASS_JOB_TRIGGER (1)
> +#define MTK_FD_CTX_MODE_DEBUG_BYPASS_ALL (2)
> +
> +#define MTK_FD_GET_CTX_ID_FROM_SEQUENCE(sequence) \
> +       ((sequence) >> 16 & 0x0000FFFF)
> +
> +#define MTK_FD_CTX_META_BUF_DEFAULT_SIZE (1110 * 1024)
> +
> +struct mtk_fd_ctx;
> +struct mtk_fd_ctx_finish_param;
> +
> +/**
> + * Attributes setup by device context owner
> + */
> +struct mtk_fd_ctx_queue_desc {
> +       int id;
> +       /* id of the context queue */
> +       char *name;
> +       /* Will be exported to media entity name */
> +       int capture;
> +       /**
> +        * 1 for capture queue (device to user),
> +        * 0 for output queue (from user to device)
> +        */
> +       int image;
> +       /* 1 for image, 0 for meta data */
> +       unsigned int dma_port;
> +       /*The dma port associated to the buffer*/
> +       struct mtk_fd_ctx_format *fmts;
> +       int num_fmts;
> +       /* Default format of this queue */
> +       int default_fmt_idx;
> +};
> +
> +/**
> + * Supported format and the information used for
> + * size calculation
> + */
> +struct mtk_fd_ctx_meta_format {
> +       u32 dataformat;
> +       u32 max_buffer_size;
> +       u8 flags;
> +};
> +
> +/**
> + * MDP module's private format definitation
> + * (the same as struct mdp_format)
> + * It will be removed and changed to MDP's external interface
> + * after the integration with MDP module.
> + */
> +struct mtk_fd_ctx_mdp_format {
> +       u32     pixelformat;
> +       u32     mdp_color;
> +       u8      depth[VIDEO_MAX_PLANES];
> +       u8      row_depth[VIDEO_MAX_PLANES];
> +       u8      num_planes;
> +       u8      walign;
> +       u8      halign;
> +       u8      salign;
> +       u32     flags;
> +};
> +
> +struct mtk_fd_ctx_format {
> +       union {
> +               struct mtk_fd_ctx_meta_format meta;
> +               struct mtk_fd_ctx_mdp_format img;
> +       } fmt;
> +};
> +
> +union mtk_v4l2_fmt {
> +       struct v4l2_pix_format_mplane pix_mp;
> +       struct v4l2_meta_format meta;
> +};
> +
> +/* Attributes setup by device context owner */
> +struct mtk_fd_ctx_queues_setting {
> +       int master;
> +       /* The master input node to trigger the frame data enqueue */
> +       struct mtk_fd_ctx_queue_desc *output_queue_descs;
> +       int total_output_queues;
> +       struct mtk_fd_ctx_queue_desc *capture_queue_descs;
> +       int total_capture_queues;
> +};
> +
> +struct mtk_fd_ctx_queue_attr {
> +       int master;
> +       int input_offset;
> +       int total_num;
> +};
> +
> +/**
> + * Video node context. Since we use
> + * mtk_fd_ctx_frame_bundle to manage enqueued
> + * buffers by frame now, we don't use bufs filed of
> + * mtk_fd_ctx_queue now
> + */
> +struct mtk_fd_ctx_queue {
> +       union mtk_v4l2_fmt fmt;
> +       struct mtk_fd_ctx_format *ctx_fmt;
> +
> +       unsigned int width_pad;
> +       /* bytesperline, reserved */
> +       struct mtk_fd_ctx_queue_desc desc;
> +       unsigned int buffer_usage;
> +       /* Current buffer usage of the queue */
> +       int rotation;
> +       struct list_head bufs;
> +       /* Reserved, not used now */
> +};
> +
> +enum mtk_fd_ctx_frame_bundle_state {
> +       MTK_FD_CTX_FRAME_NEW,
> +       /* Not allocated */
> +       MTK_FD_CTX_FRAME_PREPARED,
> +       /* Allocated but has not be processed */
> +       MTK_FD_CTX_FRAME_PROCESSING,
> +       /* Queued, waiting to be filled */
> +};
> +
> +/**
> + * The definiation is compatible with FD driver's state definiation
> + * currently and will be decoupled after further integration
> + */
> +enum mtk_fd_ctx_frame_data_state {
> +       MTK_FD_CTX_FRAME_DATA_EMPTY = 0, /* FRAME_STATE_INIT */
> +       MTK_FD_CTX_FRAME_DATA_DONE = 3, /* FRAME_STATE_DONE */
> +       MTK_FD_CTX_FRAME_DATA_STREAMOFF_DONE = 4, /*FRAME_STATE_STREAMOFF*/
> +       MTK_FD_CTX_FRAME_DATA_ERROR = 5, /*FRAME_STATE_ERROR*/
> +};
> +
> +struct mtk_fd_ctx_frame_bundle {
> +       struct mtk_fd_ctx_buffer*
> +               buffers[MTK_FD_CTX_FRAME_BUNDLE_BUFFER_MAX];
> +       int id;
> +       int num_img_capture_bufs;
> +       int num_img_output_bufs;
> +       int num_meta_capture_bufs;
> +       int num_meta_output_bufs;
> +       int last_index;
> +       int state;
> +       struct list_head list;
> +};
> +
> +struct mtk_fd_ctx_frame_bundle_list {
> +       struct list_head list;
> +};
> +
> +struct mtk_fd_ctx {
> +       struct platform_device *pdev;
> +       struct platform_device *smem_device;
> +       unsigned short ctx_id;
> +       char device_name[12];
> +       const struct mtk_fd_ctx_ops *ops;
> +       struct mtk_fd_dev_node_mapping *mtk_fd_dev_node_map;
> +       unsigned int dev_node_num;
> +       struct mtk_fd_ctx_queue queue[MTK_FD_CTX_QUEUES];
> +       struct mtk_fd_ctx_queue_attr queues_attr;
> +       atomic_t frame_param_sequence;
> +       int streaming;
> +       void *img_vb2_alloc_ctx;
> +       void *smem_vb2_alloc_ctx;
> +       struct v4l2_subdev_fh *fh;
> +       struct mtk_fd_ctx_frame_bundle frame_bundles[VB2_MAX_FRAME];
> +       struct mtk_fd_ctx_frame_bundle_list processing_frames;
> +       struct mtk_fd_ctx_frame_bundle_list free_frames;
> +       int enabled_dma_ports;
> +       int num_frame_bundle;
> +       int mode; /* Reserved for debug */
> +       spinlock_t qlock;
> +};
> +
> +enum mtk_fd_ctx_buffer_state {
> +       MTK_FD_CTX_BUFFER_NEW,
> +       MTK_FD_CTX_BUFFER_PROCESSING,
> +       MTK_FD_CTX_BUFFER_DONE,
> +       MTK_FD_CTX_BUFFER_FAILED,
> +};
> +
> +struct mtk_fd_ctx_buffer {
> +       union mtk_v4l2_fmt fmt;
> +       struct mtk_fd_ctx_format *ctx_fmt;
> +       int capture;
> +       int image;
> +       int frame_id;
> +       int user_sequence; /* Sequence number assigned by user */
> +       dma_addr_t daddr;
> +       void *vaddr;
> +       phys_addr_t paddr;
> +       unsigned int queue;
> +       unsigned int buffer_usage;
> +       enum mtk_fd_ctx_buffer_state state;
> +       int rotation;
> +       struct list_head list;
> +};
> +
> +struct mtk_fd_ctx_desc {
> +       char *proc_dev_phandle;
> +       /* The context device's compatble string name in device tree*/
> +       int (*init)(struct mtk_fd_ctx *ctx);
> +       /* configure the core functions of the device context */
> +};
> +
> +struct mtk_fd_ctx_init_table {
> +       int total_dev_ctx;
> +       struct mtk_fd_ctx_desc *ctx_desc_tbl;
> +};
> +
> +struct mtk_fd_ctx_finish_param {
> +       unsigned int frame_id;
> +       u64 timestamp;
> +       unsigned int state;
> +};
> +
> +bool mtk_fd_ctx_is_streaming(struct mtk_fd_ctx *ctx);
> +
> +int mtk_fd_ctx_core_job_finish(struct mtk_fd_ctx *ctx,
> +                              struct mtk_fd_ctx_finish_param *param);
> +
> +int mtk_fd_ctx_core_init(struct mtk_fd_ctx *ctx,
> +                        struct platform_device *pdev, int ctx_id,
> +                        struct mtk_fd_ctx_desc *ctx_desc,
> +                        struct platform_device *proc_pdev,
> +                        struct platform_device *smem_pdev);
> +
> +int mtk_fd_ctx_core_exit(struct mtk_fd_ctx *ctx);
> +
> +void mtk_fd_ctx_buf_init(struct mtk_fd_ctx_buffer *b, unsigned int queue,
> +                        dma_addr_t daddr);
> +
> +enum mtk_fd_ctx_buffer_state
> +       mtk_fd_ctx_get_buffer_state(struct mtk_fd_ctx_buffer *b);
> +
> +int mtk_fd_ctx_next_global_frame_sequence(struct mtk_fd_ctx *ctx, int locked);
> +
> +int mtk_fd_ctx_core_queue_setup
> +       (struct mtk_fd_ctx *ctx,
> +        struct mtk_fd_ctx_queues_setting *queues_setting);
> +
> +int mtk_fd_ctx_core_finish_param_init(void *param, int frame_id, int state);
> +
> +int mtk_fd_ctx_finish_frame(struct mtk_fd_ctx *dev_ctx,
> +                           struct mtk_fd_ctx_frame_bundle *frame_bundle,
> +                           int done);
> +
> +int mtk_fd_ctx_frame_bundle_init(struct mtk_fd_ctx_frame_bundle *frame_bundle);
> +
> +void mtk_fd_ctx_frame_bundle_add(struct mtk_fd_ctx *ctx,
> +                                struct mtk_fd_ctx_frame_bundle *bundle,
> +                                struct mtk_fd_ctx_buffer *ctx_buf);
> +
> +int mtk_fd_ctx_trigger_job(struct mtk_fd_ctx *dev_ctx,
> +                          struct mtk_fd_ctx_frame_bundle *bundle_data);
> +
> +int mtk_fd_ctx_fmt_set_img(struct mtk_fd_ctx *dev_ctx, int queue_id,
> +                          struct v4l2_pix_format_mplane *user_fmt,
> +                          struct v4l2_pix_format_mplane *node_fmt);
> +
> +int mtk_fd_ctx_fmt_set_meta(struct mtk_fd_ctx *dev_ctx, int queue_id,
> +                           struct v4l2_meta_format *user_fmt,
> +                           struct v4l2_meta_format *node_fmt);
> +
> +int mtk_fd_ctx_format_load_default_fmt(struct mtk_fd_ctx_queue *queue,
> +                                      struct v4l2_format *fmt_to_fill);
> +
> +int mtk_fd_ctx_streamon(struct mtk_fd_ctx *dev_ctx);
> +int mtk_fd_ctx_streamoff(struct mtk_fd_ctx *dev_ctx);
> +int mtk_fd_ctx_release(struct mtk_fd_ctx *dev_ctx);
> +int mtk_fd_ctx_open(struct mtk_fd_ctx *dev_ctx);
> +int mtk_fd_ctx_fd_init(struct mtk_fd_ctx *ctx);
> +
> +#endif /*__MTK_FD_CTX_H__*/
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c b/drivers/media/platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c
> new file mode 100644
> index 0000000..7314436
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c
> @@ -0,0 +1,912 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2018 MediaTek Inc.
> + * Author: Frederic Chen <frederic.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <linux/dma-mapping.h>
> +
> +#include "mtk_fd.h"
> +#include "mtk_fd-dev.h"
> +#include "mtk_fd-smem.h"
> +#include "mtk_fd-v4l2.h"
> +
> +#if KERNEL_VERSION(4, 8, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +#include <linux/dma-attrs.h>
> +#endif
> +
> +struct vb2_v4l2_buffer *mtk_fd_ctx_buffer_get_vb2_v4l2_buffer
> +(struct mtk_fd_ctx_buffer *ctx_buf)
> +{
> +       struct mtk_fd_dev_buffer *dev_buf = NULL;
> +
> +       if (!ctx_buf) {
> +               pr_err("Failed to convert ctx_buf to dev_buf: Null pointer\n");
> +               return NULL;
> +       }
> +
> +       dev_buf = mtk_fd_ctx_buf_to_dev_buf(ctx_buf);
> +
> +       return &dev_buf->m2m2_buf.vbb;
> +}
> +
> +int mtk_fd_ctx_core_queue_setup(struct mtk_fd_ctx *ctx,
> +                               struct mtk_fd_ctx_queues_setting *
> +                               queues_setting)
> +{
> +       int queue_idx = 0;
> +       int i = 0;
> +
> +       for (i = 0; i < queues_setting->total_output_queues; i++) {
> +               struct mtk_fd_ctx_queue_desc *queue_desc =
> +                       &queues_setting->output_queue_descs[i];
> +               ctx->queue[queue_idx].desc = *queue_desc;
> +               queue_idx++;
> +       }
> +
> +       /* Setup the capture queue */
> +       for (i = 0; i < queues_setting->total_capture_queues; i++) {
> +               struct mtk_fd_ctx_queue_desc *queue_desc =
> +                       &queues_setting->capture_queue_descs[i];
> +               ctx->queue[queue_idx].desc = *queue_desc;
> +               queue_idx++;
> +       }
> +
> +       ctx->queues_attr.master = queues_setting->master;
> +       ctx->queues_attr.total_num = queue_idx;
> +       ctx->dev_node_num = ctx->queues_attr.total_num;
> +       strcpy(ctx->device_name, MTK_FD_DEV_NAME);
> +       return 0;
> +}
> +
> +/* Mediatek FD context core initialization */
> +int mtk_fd_ctx_core_init(struct mtk_fd_ctx *ctx,
> +                        struct platform_device *pdev, int ctx_id,
> +                        struct mtk_fd_ctx_desc *ctx_desc,
> +                        struct platform_device *proc_pdev,
> +                        struct platform_device *smem_pdev)
> +{
> +       /* Initialize main data structure */
> +       int r = 0;
> +
> +#if KERNEL_VERSION(4, 8, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       ctx->smem_vb2_alloc_ctx =
> +               vb2_dma_contig_init_ctx(&smem_pdev->dev);
> +       ctx->img_vb2_alloc_ctx =
> +               vb2_dma_contig_init_ctx(&pdev->dev);
> +#else
> +       ctx->smem_vb2_alloc_ctx = &smem_pdev->dev;
> +       ctx->img_vb2_alloc_ctx = &pdev->dev;
> +#endif
> +       if (IS_ERR((__force void *)ctx->smem_vb2_alloc_ctx))
> +               pr_err("Failed to alloc vb2 dma context: smem_vb2_alloc_ctx");
> +
> +       if (IS_ERR((__force void *)ctx->img_vb2_alloc_ctx))
> +               pr_err("Failed to alloc vb2 dma context: img_vb2_alloc_ctx");
> +
> +       ctx->pdev = pdev;
> +       ctx->ctx_id = ctx_id;
> +       /* keep th smem pdev to use related iommu functions */
> +       ctx->smem_device = smem_pdev;
> +
> +       /* Will set default enabled after passing the unit test */
> +       ctx->mode = MTK_FD_CTX_MODE_DEBUG_OFF;
> +
> +       /* initialized the global frame index of the device context */
> +       atomic_set(&ctx->frame_param_sequence, 0);
> +       spin_lock_init(&ctx->qlock);
> +
> +       /* setup the core operation of the device context */
> +       if (ctx_desc && ctx_desc->init)
> +               r = ctx_desc->init(ctx);
> +
> +       return r;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_core_init);
> +
> +int mtk_fd_ctx_core_exit(struct mtk_fd_ctx *ctx)
> +{
> +#if KERNEL_VERSION(4, 8, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       vb2_dma_contig_cleanup_ctx(ctx->smem_vb2_alloc_ctx);
> +       vb2_dma_contig_cleanup_ctx(ctx->img_vb2_alloc_ctx);
> +#else
> +       ctx->smem_vb2_alloc_ctx = NULL;
> +       ctx->img_vb2_alloc_ctx = NULL;
> +#endif
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_core_exit);
> +
> +int mtk_fd_ctx_next_global_frame_sequence(struct mtk_fd_ctx *ctx, int locked)
> +{
> +       int global_frame_sequence =
> +               atomic_inc_return(&ctx->frame_param_sequence);
> +
> +       if (!locked)
> +               spin_lock(&ctx->qlock);
> +
> +       global_frame_sequence =
> +               (global_frame_sequence & 0x0000FFFF) | (ctx->ctx_id << 16);
> +
> +       if (!locked)
> +               spin_unlock(&ctx->qlock);
> +
> +       return global_frame_sequence;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_next_global_frame_sequence);
> +
> +static void mtk_fd_ctx_buffer_done
> +       (struct mtk_fd_ctx_buffer *ctx_buf, int state)
> +{
> +               if (!ctx_buf || state != MTK_FD_CTX_BUFFER_DONE ||
> +                   state != MTK_FD_CTX_BUFFER_FAILED)
> +                       return;
> +
> +               ctx_buf->state = state;
> +}
> +
> +struct mtk_fd_ctx_frame_bundle *mtk_fd_ctx_get_processing_frame
> +(struct mtk_fd_ctx *dev_ctx, int frame_id)
> +{
> +       struct mtk_fd_ctx_frame_bundle *frame_bundle = NULL;
> +
> +       spin_lock(&dev_ctx->qlock);
> +
> +       list_for_each_entry(frame_bundle,
> +                           &dev_ctx->processing_frames.list, list) {
> +               if (frame_bundle->id == frame_id) {
> +                       spin_unlock(&dev_ctx->qlock);
> +                       return frame_bundle;
> +               }
> +       }
> +
> +       spin_unlock(&dev_ctx->qlock);
> +
> +       return NULL;
> +}
> +
> +/**
> + * structure mtk_fd_ctx_finish_param must be the first elemt of param
> + * So that the buffer can be return to vb2 queue successfully
> + */
> +int mtk_fd_ctx_core_finish_param_init(void *param, int frame_id, int state)
> +{
> +       struct mtk_fd_ctx_finish_param *fram_param =
> +               (struct mtk_fd_ctx_finish_param *)param;
> +       fram_param->frame_id = frame_id;
> +       fram_param->state = state;
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_core_finish_param_init);
> +
> +void mtk_fd_ctx_frame_bundle_add(struct mtk_fd_ctx *ctx,
> +                                struct mtk_fd_ctx_frame_bundle *bundle,
> +                                struct mtk_fd_ctx_buffer *ctx_buf)
> +{
> +       int queue_id = 0;
> +       struct mtk_fd_ctx_queue *ctx_queue = NULL;
> +
> +       if (!bundle || !ctx_buf) {
> +               pr_warn("Add buffer to frame bundle failed, bundle(%llx),buf(%llx)\n",
> +                       (long long)bundle, (long long)ctx_buf);
> +               return;
> +       }
> +
> +       queue_id = ctx_buf->queue;
> +
> +       if (bundle->buffers[queue_id])
> +               pr_warn("Queue(%d) buffer has alreay in this bundle, overwrite happen\n",
> +                       queue_id);
> +
> +       pr_debug("Add queue(%d) buffer%llx\n",
> +                queue_id, (unsigned long long)ctx_buf);
> +                bundle->buffers[queue_id] = ctx_buf;
> +
> +       /* Fill context queue related information */
> +       ctx_queue = &ctx->queue[queue_id];
> +
> +       if (!ctx_queue) {
> +               pr_err("Can't find ctx queue (%d)\n", queue_id);
> +               return;
> +       }
> +
> +       if (ctx->queue[ctx_buf->queue].desc.image) {
> +               if (ctx->queue[ctx_buf->queue].desc.capture)
> +                       bundle->num_img_capture_bufs++;
> +               else
> +                       bundle->num_img_output_bufs++;
> +       } else {
> +               if (ctx->queue[ctx_buf->queue].desc.capture)
> +                       bundle->num_meta_capture_bufs++;
> +               else
> +                       bundle->num_meta_output_bufs++;
> +       }
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_frame_bundle_add);
> +
> +void mtk_fd_ctx_buf_init(struct mtk_fd_ctx_buffer *b,
> +                        unsigned int queue, dma_addr_t daddr)
> +{
> +       b->state = MTK_FD_CTX_BUFFER_NEW;
> +       b->queue = queue;
> +       b->daddr = daddr;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_buf_init);
> +
> +enum mtk_fd_ctx_buffer_state
> +       mtk_fd_ctx_get_buffer_state(struct mtk_fd_ctx_buffer *b)
> +{
> +       return b->state;
> +}
> +
> +bool mtk_fd_ctx_is_streaming(struct mtk_fd_ctx *ctx)
> +{
> +       return ctx->streaming;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_is_streaming);
> +
> +static int mtk_fd_ctx_free_frame(struct mtk_fd_ctx *dev_ctx,
> +                                struct mtk_fd_ctx_frame_bundle *frame_bundle)
> +{
> +       spin_lock(&dev_ctx->qlock);
> +
> +       frame_bundle->state = MTK_FD_CTX_FRAME_NEW;
> +       list_del(&frame_bundle->list);
> +       list_add_tail(&frame_bundle->list, &dev_ctx->free_frames.list);
> +
> +       spin_unlock(&dev_ctx->qlock);
> +
> +       return 0;
> +}
> +
> +int mtk_fd_ctx_core_job_finish(struct mtk_fd_ctx *dev_ctx,
> +                              struct mtk_fd_ctx_finish_param *param)
> +{
> +       int i = 0;
> +       struct platform_device *pdev = dev_ctx->pdev;
> +       struct mtk_fd_ctx_finish_param *fram_param =
> +               (struct mtk_fd_ctx_finish_param *)param;
> +       struct mtk_fd_dev *fd_dev = NULL;
> +       struct mtk_fd_ctx_frame_bundle *frame = NULL;
> +       enum vb2_buffer_state vbf_state = VB2_BUF_STATE_DONE;
> +       enum mtk_fd_ctx_buffer_state ctxf_state =
> +               MTK_FD_CTX_BUFFER_DONE;
> +       int user_sequence = 0;
> +
> +       const int ctx_id =
> +               MTK_FD_GET_CTX_ID_FROM_SEQUENCE(fram_param->frame_id);
> +       u64 timestamp = 0;
> +
> +       pr_debug("mtk_fd_ctx_core_job_finish_cb: param (%llx), platform_device(%llx)\n",
> +                (unsigned long long)param, (unsigned long long)pdev);
> +
> +       if (!dev_ctx)
> +               pr_err("dev_ctx can't be null, can't release the frame\n");
> +
> +       fd_dev = mtk_fd_ctx_to_dev(dev_ctx);
> +
> +       if (fram_param) {
> +               dev_info(&fd_dev->pdev->dev,
> +                        "CB recvied from ctx(%d), frame(%d), state(%d), fd_dev(%llx)\n",
> +                        ctx_id, fram_param->frame_id,
> +                        fram_param->state, (long long)fd_dev);
> +       } else {
> +               dev_err(&fd_dev->pdev->dev,
> +                       "CB recvied from ctx(%d), frame param is NULL\n",
> +                       ctx_id);
> +                       return -EINVAL;
> +       }
> +
> +       /* Get the buffers of the processed frame */
> +       frame = mtk_fd_ctx_get_processing_frame(&fd_dev->ctx,
> +                                               fram_param->frame_id);
> +
> +       if (!frame) {
> +               pr_err("Can't find the frame boundle, Frame(%d)\n",
> +                      fram_param->frame_id);
> +               return -EINVAL;
> +       }
> +
> +       if (fram_param->state == MTK_FD_CTX_FRAME_DATA_ERROR) {
> +               vbf_state = VB2_BUF_STATE_ERROR;
> +               ctxf_state = MTK_FD_CTX_BUFFER_FAILED;
> +       }
> +
> +       /**
> +        * Set the buffer's VB2 status so that
> +        * the user can dequeue the buffer
> +        */
> +       timestamp = ktime_get_ns();
> +       for (i = 0; i <= frame->last_index; i++) {
> +               struct mtk_fd_ctx_buffer *ctx_buf = frame->buffers[i];
> +
> +               if (!ctx_buf) {
> +                       dev_dbg(&fd_dev->pdev->dev,
> +                               "ctx_buf(queue id= %d) of frame(%d)is NULL\n",
> +                               i, fram_param->frame_id);
> +                       continue;
> +               } else {
> +                       struct vb2_v4l2_buffer *b =
> +                               mtk_fd_ctx_buffer_get_vb2_v4l2_buffer(ctx_buf);
> +                       b->vb2_buf.timestamp = ktime_get_ns();
> +                       user_sequence = ctx_buf->user_sequence;
> +                       mtk_fd_ctx_buffer_done(ctx_buf, ctxf_state);
> +                       mtk_fd_v4l2_buffer_done(&b->vb2_buf, vbf_state);
> +               }
> +       }
> +
> +       mtk_fd_ctx_free_frame(&fd_dev->ctx, frame);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_core_job_finish);
> +
> +int mtk_fd_ctx_finish_frame(struct mtk_fd_ctx *dev_ctx,
> +                           struct mtk_fd_ctx_frame_bundle *frame_bundle,
> +                           int done)
> +{
> +       spin_lock(&dev_ctx->qlock);
> +       frame_bundle->state = MTK_FD_CTX_FRAME_PROCESSING;
> +       list_add_tail(&frame_bundle->list, &dev_ctx->processing_frames.list);
> +       spin_unlock(&dev_ctx->qlock);
> +       return 0;
> +}
> +
> +static void set_img_fmt(struct v4l2_pix_format_mplane *mfmt_to_fill,
> +                       struct mtk_fd_ctx_format *ctx_fmt)
> +{
> +       int i = 0;
> +
> +       mfmt_to_fill->pixelformat = ctx_fmt->fmt.img.pixelformat;
> +       mfmt_to_fill->num_planes = ctx_fmt->fmt.img.num_planes;
> +
> +       pr_info("%s: Fmt(%d),w(%d),h(%d)\n",
> +               __func__,
> +               mfmt_to_fill->pixelformat,
> +               mfmt_to_fill->width,
> +               mfmt_to_fill->height);
> +
> +       /**
> +        * The implementation wil be adjust after integrating MDP module
> +        * since it provides the common format suppporting function
> +        */
> +       for (i = 0 ; i < mfmt_to_fill->num_planes; ++i) {
> +               int bpl = (mfmt_to_fill->width *
> +                          ctx_fmt->fmt.img.row_depth[i]) / 8;
> +               int sizeimage = (mfmt_to_fill->width * mfmt_to_fill->height *
> +                                ctx_fmt->fmt.img.depth[i]) / 8;
> +
> +               mfmt_to_fill->plane_fmt[i].bytesperline = bpl;
> +               mfmt_to_fill->plane_fmt[i].sizeimage = sizeimage;
> +               pr_info("plane(%d):bpl(%d),sizeimage(%u)\n",
> +                       i, bpl, mfmt_to_fill->plane_fmt[i].sizeimage);
> +       }
> +}
> +
> +static void set_meta_fmt(struct v4l2_meta_format *metafmt_to_fill,
> +                        struct mtk_fd_ctx_format *ctx_fmt)
> +{
> +       metafmt_to_fill->dataformat = ctx_fmt->fmt.meta.dataformat;
> +
> +       if (ctx_fmt->fmt.meta.max_buffer_size <= 0 ||
> +           ctx_fmt->fmt.meta.max_buffer_size >
> +           MTK_FD_CTX_META_BUF_DEFAULT_SIZE) {
> +               pr_warn("buf size of meta(%u) can't be 0, use default %u\n",
> +                       ctx_fmt->fmt.meta.dataformat,
> +                       MTK_FD_CTX_META_BUF_DEFAULT_SIZE);
> +               metafmt_to_fill->buffersize = MTK_FD_CTX_META_BUF_DEFAULT_SIZE;
> +       } else {
> +               pr_info("Load the meta size setting %u\n",
> +                       ctx_fmt->fmt.meta.max_buffer_size);
> +               metafmt_to_fill->buffersize = ctx_fmt->fmt.meta.max_buffer_size;
> +       }
> +}
> +
> +/* Get the default format setting */
> +int mtk_fd_ctx_format_load_default_fmt(struct mtk_fd_ctx_queue *queue,
> +                                      struct v4l2_format *fmt_to_fill)
> +{
> +       struct mtk_fd_ctx_format *ctx_fmt = NULL;
> +
> +       if (queue->desc.num_fmts == 0)
> +               return 0; /* no format support list associated to this queue */
> +
> +       if (queue->desc.default_fmt_idx >= queue->desc.num_fmts) {
> +               pr_warn("Queue(%s) err: default idx(%d) must < num_fmts(%d)\n",
> +                       queue->desc.name, queue->desc.default_fmt_idx,
> +                       queue->desc.num_fmts);
> +               queue->desc.default_fmt_idx = 0;
> +               pr_warn("Queue(%s) : reset default idx(%d)\n",
> +                       queue->desc.name, queue->desc.default_fmt_idx);
> +       }
> +
> +       ctx_fmt = &queue->desc.fmts[queue->desc.default_fmt_idx];
> +
> +       /* Check the type of the buffer */
> +       if (queue->desc.image) {
> +               struct v4l2_pix_format_mplane *node_fmt =
> +                       &fmt_to_fill->fmt.pix_mp;
> +
> +               if (queue->desc.capture) {
> +                       fmt_to_fill->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +                       node_fmt->width = MTK_FD_OUTPUT_MAX_WIDTH;
> +                       node_fmt->height = MTK_FD_OUTPUT_MAX_HEIGHT;
> +               } else {
> +                       fmt_to_fill->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +                       node_fmt->width = MTK_FD_INPUT_MAX_WIDTH;
> +                       node_fmt->height = MTK_FD_INPUT_MAX_HEIGHT;
> +               }
> +               set_img_fmt(node_fmt, ctx_fmt);
> +       }       else {
> +               /* meta buffer type */
> +               struct v4l2_meta_format *node_fmt = &fmt_to_fill->fmt.meta;
> +
> +               if (queue->desc.capture)
> +                       fmt_to_fill->type = V4L2_BUF_TYPE_META_CAPTURE;
> +               else
> +                       fmt_to_fill->type = V4L2_BUF_TYPE_META_OUTPUT;
> +
> +               set_meta_fmt(node_fmt, ctx_fmt);
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_format_load_default_fmt);
> +
> +static struct mtk_fd_ctx_format *mtk_fd_ctx_find_fmt
> +       (struct mtk_fd_ctx_queue *queue, u32 format)
> +{
> +       int i;
> +       struct mtk_fd_ctx_format *ctx_fmt;
> +
> +       for (i = 0; i < queue->desc.num_fmts; i++) {
> +               ctx_fmt = &queue->desc.fmts[i];
> +               if (queue->desc.image) {
> +                       pr_debug("idx(%d), pixelformat(%x), fmt(%x)\n",
> +                                i, ctx_fmt->fmt.img.pixelformat, format);
> +                       if (ctx_fmt->fmt.img.pixelformat == format)
> +                               return ctx_fmt;
> +               } else {
> +                       if (ctx_fmt->fmt.meta.dataformat == format)
> +                               return ctx_fmt;
> +               }
> +       }
> +       return NULL;
> +}
> +
> +int mtk_fd_ctx_fmt_set_meta(struct mtk_fd_ctx *dev_ctx, int queue_id,
> +                           struct v4l2_meta_format *user_fmt,
> +                           struct v4l2_meta_format *node_fmt)
> +{
> +       struct mtk_fd_ctx_queue *queue = NULL;
> +       struct mtk_fd_ctx_format *ctx_fmt;
> +
> +       if (queue_id >= dev_ctx->queues_attr.total_num) {
> +               pr_err("Invalid queue id:%d\n", queue_id);
> +               return -EINVAL;
> +       }
> +
> +       queue = &dev_ctx->queue[queue_id];
> +       if (!user_fmt || !node_fmt)
> +               return -EINVAL;
> +
> +       ctx_fmt = mtk_fd_ctx_find_fmt(queue, user_fmt->dataformat);
> +       if (!ctx_fmt)
> +               return -EINVAL;
> +
> +       queue->ctx_fmt = ctx_fmt;
> +       set_meta_fmt(node_fmt, ctx_fmt);
> +       *user_fmt = *node_fmt;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_fmt_set_meta);
> +
> +int mtk_fd_ctx_fmt_set_img(struct mtk_fd_ctx *dev_ctx, int queue_id,
> +                          struct v4l2_pix_format_mplane *user_fmt,
> +                          struct v4l2_pix_format_mplane *node_fmt)
> +{
> +       struct mtk_fd_ctx_queue *queue = NULL;
> +       struct mtk_fd_ctx_format *ctx_fmt;
> +
> +       if (queue_id >= dev_ctx->queues_attr.total_num) {
> +               pr_err("Invalid queue id:%d\n", queue_id);
> +               return -EINVAL;
> +       }
> +
> +       queue = &dev_ctx->queue[queue_id];
> +       if (!user_fmt || !node_fmt)
> +               return -EINVAL;
> +
> +       ctx_fmt = mtk_fd_ctx_find_fmt(queue, user_fmt->pixelformat);
> +       if (!ctx_fmt)
> +               return -EINVAL;
> +
> +       queue->ctx_fmt = ctx_fmt;
> +       node_fmt->width = user_fmt->width;
> +       node_fmt->height = user_fmt->height;
> +
> +       set_img_fmt(node_fmt, ctx_fmt);
> +
> +       *user_fmt = *node_fmt;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_fmt_set_img);
> +
> +int mtk_fd_ctx_streamon(struct mtk_fd_ctx *dev_ctx)
> +{
> +       int ret = 0;
> +
> +       if (dev_ctx->streaming) {
> +               pr_warn("stream on failed, pdev(%llx), ctx(%d) already stream on\n",
> +                       (long long)dev_ctx->pdev, dev_ctx->ctx_id);
> +               return -EBUSY;
> +       }
> +
> +       ret = mtk_fd_streamon(dev_ctx->pdev, dev_ctx->ctx_id);
> +       if (ret) {
> +               pr_err("streamon: ctx(%d) failed, notified by context\n",
> +                      dev_ctx->ctx_id);
> +               return -EBUSY;
> +       }
> +
> +       dev_ctx->streaming = true;
> +       ret = mtk_fd_dev_queue_buffers(mtk_fd_ctx_to_dev(dev_ctx), true);
> +       if (ret)
> +               pr_err("failed to queue initial buffers (%d)", ret);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_streamon);
> +
> +int mtk_fd_ctx_streamoff(struct mtk_fd_ctx *dev_ctx)
> +{
> +       int ret = 0;
> +
> +       if (!dev_ctx->streaming) {
> +               pr_warn("Do nothing, pdev(%llx), ctx(%d) is already stream off\n",
> +                       (long long)dev_ctx->pdev, dev_ctx->ctx_id);
> +               return -EBUSY;
> +       }
> +
> +       ret = mtk_fd_streamoff(dev_ctx->pdev, dev_ctx->ctx_id);
> +       if (ret) {
> +               pr_warn("streamoff: ctx(%d) failed, notified by context\n",
> +                       dev_ctx->ctx_id);
> +               return -EBUSY;
> +       }
> +
> +       dev_ctx->streaming = false;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_streamoff);
> +
> +int mtk_fd_ctx_init_frame_bundles(struct mtk_fd_ctx *dev_ctx)
> +{
> +       int i = 0;
> +
> +       dev_ctx->num_frame_bundle = VB2_MAX_FRAME;
> +
> +       spin_lock(&dev_ctx->qlock);
> +
> +       /* Reset the queue*/
> +       INIT_LIST_HEAD(&dev_ctx->processing_frames.list);
> +       INIT_LIST_HEAD(&dev_ctx->free_frames.list);
> +
> +       for (i = 0; i < dev_ctx->num_frame_bundle; i++) {
> +               struct mtk_fd_ctx_frame_bundle *frame_bundle =
> +                       &dev_ctx->frame_bundles[i];
> +               frame_bundle->state = MTK_FD_CTX_FRAME_NEW;
> +               list_add_tail(&frame_bundle->list, &dev_ctx->free_frames.list);
> +       }
> +
> +       spin_unlock(&dev_ctx->qlock);
> +
> +       return 0;
> +}
> +
> +int mtk_fd_ctx_open(struct mtk_fd_ctx *dev_ctx)
> +{
> +       struct mtk_fd_dev *fd_dev = mtk_fd_ctx_to_dev(dev_ctx);
> +       unsigned int enabled_dma_ports = 0;
> +       int i = 0;
> +
> +       if (!dev_ctx)
> +               return -EINVAL;
> +
> +       /* Get the enabled DMA ports */
> +       for (i = 0; i < fd_dev->mem2mem2.num_nodes; i++) {
> +               if (fd_dev->mem2mem2.nodes[i].enabled)
> +                       enabled_dma_ports |= dev_ctx->queue[i].desc.dma_port;
> +       }
> +
> +       dev_ctx->enabled_dma_ports = enabled_dma_ports;
> +
> +       dev_dbg(&fd_dev->pdev->dev, "open device: (%llx)\n",
> +               (long long)&fd_dev->pdev->dev);
> +
> +       /* Workaround for SCP EMI access */
> +       mtk_fd_smem_enable_mpu(&dev_ctx->smem_device->dev);
> +
> +       /* Init the frame bundle pool */
> +       mtk_fd_ctx_init_frame_bundles(dev_ctx);
> +
> +       return mtk_fd_open(dev_ctx->pdev);
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_open);
> +
> +int mtk_fd_ctx_release(struct mtk_fd_ctx *dev_ctx)
> +{
> +       return mtk_fd_release(dev_ctx->pdev);
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_release);
> +
> +static int mtk_fd_ctx_core_job_start(struct mtk_fd_ctx *dev_ctx,
> +                                    struct mtk_fd_ctx_frame_bundle *bundle)
> +{
> +       struct platform_device *pdev = dev_ctx->pdev;
> +       int ret = 0;
> +       struct v4l2_fd_param fd_param;
> +       struct mtk_fd_ctx_buffer *ctx_buf_yuv_in = NULL;
> +       struct mtk_fd_ctx_buffer *ctx_buf_meta_in = NULL;
> +       struct mtk_fd_ctx_buffer *ctx_buf_meta_out = NULL;
> +
> +       if (!pdev || !bundle) {
> +               dev_err(&pdev->dev,
> +                       "pdev(%llx) and param(%llx) in start can't be NULL\n",
> +                       (long long)pdev, (long long)bundle);
> +               return -EINVAL;
> +       }
> +       memset(&fd_param, 0, sizeof(struct v4l2_fd_param));
> +       fd_param.frame_id = bundle->id;
> +
> +       /* Img-in buffer */
> +       ctx_buf_yuv_in = bundle->buffers[MTK_FD_CTX_FD_YUV_IN];
> +       if (ctx_buf_yuv_in) {
> +               fd_param.src_img.iova = (uint32_t)ctx_buf_yuv_in->daddr;
> +               fd_param.src_img.va = (uint64_t)ctx_buf_yuv_in->vaddr;
> +               fd_param.src_img_h =
> +                       (uint16_t)ctx_buf_yuv_in->fmt.pix_mp.height;
> +               fd_param.src_img_w =
> +                       (uint16_t)ctx_buf_yuv_in->fmt.pix_mp.width;
> +       }
> +
> +       /* Meta-in buffer */
> +       ctx_buf_meta_in = bundle->buffers[MTK_FD_CTX_FD_CONFIG_IN];
> +       if (ctx_buf_meta_in) {
> +               fd_param.fd_user_param.va = (uint64_t)ctx_buf_meta_in->vaddr;
> +               fd_param.fd_user_param.pa = (uint32_t)ctx_buf_meta_in->paddr;
> +               fd_param.fd_user_param.iova = (uint32_t)ctx_buf_meta_in->daddr;
> +       } else {
> +               dev_err(&pdev->dev, "meta in is null!\n");
> +               fd_param.fd_user_param.pa = 0;
> +               fd_param.fd_user_param.va = 0;
> +               fd_param.fd_user_param.iova = 0;
> +       }
> +
> +       /* Meta-out buffer */
> +       ctx_buf_meta_out = bundle->buffers[MTK_FD_CTX_FD_OUT];
> +       if (ctx_buf_meta_out) {
> +               fd_param.fd_user_result.va = (uint64_t)ctx_buf_meta_out->vaddr;
> +               fd_param.fd_user_result.pa = (uint32_t)ctx_buf_meta_out->paddr;
> +               fd_param.fd_user_result.iova =
> +                                       (uint32_t)ctx_buf_meta_out->daddr;
> +       } else {
> +               dev_err(&pdev->dev, "meta out is null!\n");
> +               fd_param.fd_user_result.pa = 0;
> +               fd_param.fd_user_result.va = 0;
> +               fd_param.fd_user_result.iova = 0;
> +       }
> +
> +       dev_info(&pdev->dev,
> +                "Delegate job to mtk_fd_enqueue: pdev(0x%llx), frame(%d)\n",
> +                (long long)pdev, bundle->id);
> +       ret = mtk_fd_enqueue(pdev, &fd_param);
> +
> +       if (ret) {
> +               dev_warn(&pdev->dev, "mtk_fd_enqueue failed: %d\n", ret);
> +               return -EBUSY;
> +       }
> +
> +       return 0;
> +}
> +
> +static void debug_bundle(struct mtk_fd_ctx_frame_bundle *bundle_data)
> +{
> +       int i = 0;
> +
> +       if (!bundle_data) {
> +               pr_warn("bundle_data is NULL\n");
> +               return;
> +       }
> +
> +       pr_debug("bundle buf nums (%d, %d,%d,%d)\n",
> +                bundle_data->num_img_capture_bufs,
> +                bundle_data->num_img_output_bufs,
> +                bundle_data->num_meta_capture_bufs,
> +                bundle_data->num_meta_output_bufs);
> +
> +       for (i = 0; i < 16 ; i++) {
> +               pr_debug("Bundle, buf[%d] = %llx\n",
> +                        i,
> +                        (unsigned long long)bundle_data->buffers[i]);
> +       }
> +
> +       pr_debug("Bundle last idx: %d\n", bundle_data->last_index);
> +}
> +
> +static struct mtk_fd_ctx_frame_bundle *mtk_fd_ctx_get_free_frame
> +       (struct mtk_fd_ctx *dev_ctx)
> +{
> +       struct mtk_fd_ctx_frame_bundle *frame_bundle = NULL;
> +
> +       spin_lock(&dev_ctx->qlock);
> +       list_for_each_entry(frame_bundle,
> +                           &dev_ctx->free_frames.list, list){
> +               pr_debug("Check frame: state %d, new should be %d\n",
> +                        frame_bundle->state, MTK_FD_CTX_FRAME_NEW);
> +               if (frame_bundle->state == MTK_FD_CTX_FRAME_NEW) {
> +                       frame_bundle->state = MTK_FD_CTX_FRAME_PREPARED;
> +                       pr_debug("Found free frame\n");
> +                       spin_unlock(&dev_ctx->qlock);
> +                       return frame_bundle;
> +               }
> +       }
> +       spin_unlock(&dev_ctx->qlock);
> +       pr_err("Can't found any bundle is MTK_FD_CTX_FRAME_NEW\n");
> +       return NULL;
> +}
> +
> +static int mtk_fd_ctx_process_frame
> +       (struct mtk_fd_ctx *dev_ctx,
> +        struct mtk_fd_ctx_frame_bundle *frame_bundle)
> +{
> +       spin_lock(&dev_ctx->qlock);
> +
> +       frame_bundle->state = MTK_FD_CTX_FRAME_PROCESSING;
> +       list_del(&frame_bundle->list);
> +       list_add_tail(&frame_bundle->list, &dev_ctx->processing_frames.list);
> +
> +       spin_unlock(&dev_ctx->qlock);
> +       return 0;
> +}
> +
> +int mtk_fd_ctx_trigger_job(struct mtk_fd_ctx  *dev_ctx,
> +                          struct mtk_fd_ctx_frame_bundle *bundle_data)
> +{
> +       /* Scan all buffers and filled the ipi frame data*/
> +       int i = 0;
> +       struct mtk_fd_ctx_finish_param fram_param;
> +
> +       struct mtk_fd_ctx_frame_bundle *bundle =
> +               mtk_fd_ctx_get_free_frame(dev_ctx);
> +
> +       pr_debug("Bundle data: , ctx id:%d\n",
> +                dev_ctx->ctx_id);
> +
> +       debug_bundle(bundle_data);
> +
> +       if (!bundle) {
> +               pr_err("bundle can't be NULL\n");
> +               goto FAILE_JOB_NOT_TRIGGER;
> +       }
> +       if (!bundle_data) {
> +               pr_err("bundle_data can't be NULL\n");
> +               goto FAILE_JOB_NOT_TRIGGER;
> +       }
> +
> +       pr_debug("Copy bundle_data->buffers to bundle->buffers\n");
> +       memcpy(bundle->buffers, bundle_data->buffers,
> +              sizeof(struct mtk_fd_ctx_buffer *) *
> +              MTK_FD_CTX_FRAME_BUNDLE_BUFFER_MAX);
> +
> +       pr_debug("bundle setup (%d, %d,%d,%d)\n",
> +                bundle_data->num_img_capture_bufs,
> +                bundle_data->num_img_output_bufs,
> +                bundle_data->num_meta_capture_bufs,
> +                bundle_data->num_meta_output_bufs);
> +
> +       bundle->num_img_capture_bufs = bundle_data->num_img_capture_bufs;
> +       bundle->num_img_output_bufs = bundle_data->num_img_output_bufs;
> +       bundle->num_meta_capture_bufs = bundle_data->num_meta_capture_bufs;
> +       bundle->num_meta_output_bufs = bundle_data->num_meta_output_bufs;
> +       bundle->id = mtk_fd_ctx_next_global_frame_sequence(dev_ctx,
> +                                                          dev_ctx->ctx_id);
> +       bundle->last_index = dev_ctx->queues_attr.total_num - 1;
> +
> +       debug_bundle(bundle);
> +
> +       pr_debug("Fill Address data\n");
> +       for (i = 0; i <= bundle->last_index; i++) {
> +               struct mtk_fd_ctx_buffer *ctx_buf = bundle->buffers[i];
> +               struct vb2_v4l2_buffer *b = NULL;
> +
> +               pr_debug("Process queue[%d], ctx_buf:(%llx)\n",
> +                        i, (unsigned long long)ctx_buf);
> +
> +               if (!ctx_buf) {
> +                       pr_warn("queue[%d], ctx_buf is NULL!!\n", i);
> +                       continue;
> +               }
> +
> +               pr_debug("Get VB2 V4L2 buffer\n");
> +               b = mtk_fd_ctx_buffer_get_vb2_v4l2_buffer(ctx_buf);
> +
> +               ctx_buf->image = dev_ctx->queue[ctx_buf->queue].desc.image;
> +               ctx_buf->capture = dev_ctx->queue[ctx_buf->queue].desc.capture;
> +               /* copy the fmt setting for queue's fmt*/
> +               ctx_buf->fmt = dev_ctx->queue[ctx_buf->queue].fmt;
> +               ctx_buf->ctx_fmt = dev_ctx->queue[ctx_buf->queue].ctx_fmt;
> +                       ctx_buf->frame_id = bundle->id;
> +               ctx_buf->daddr =
> +                       vb2_dma_contig_plane_dma_addr(&b->vb2_buf, 0);
> +               pr_debug("%s:vb2_buf: type(%d),idx(%d),mem(%d)\n",
> +                        __func__,
> +                        b->vb2_buf.type,
> +                        b->vb2_buf.index,
> +                        b->vb2_buf.memory);
> +               ctx_buf->vaddr = vb2_plane_vaddr(&b->vb2_buf, 0);
> +               ctx_buf->buffer_usage = dev_ctx->queue[i].buffer_usage;
> +               ctx_buf->rotation = dev_ctx->queue[i].rotation;
> +               pr_debug("Buf: queue(%d), vaddr(%llx), daddr(%llx)",
> +                        ctx_buf->queue, (unsigned long long)ctx_buf->vaddr,
> +                        (unsigned long long)ctx_buf->daddr);
> +
> +               if (!ctx_buf->image) {
> +                       ctx_buf->paddr =
> +                               mtk_fd_smem_iova_to_phys
> +                                       (&dev_ctx->smem_device->dev,
> +                                        ctx_buf->daddr);
> +               } else {
> +                       pr_debug("No pa: it is a image buffer\n");
> +                       ctx_buf->paddr = 0;
> +               }
> +               ctx_buf->state = MTK_FD_CTX_BUFFER_PROCESSING;
> +       }
> +
> +       if (mtk_fd_ctx_process_frame(dev_ctx, bundle)) {
> +               pr_err("mtk_fd_ctx_process_frame failed: frame(%d)\n",
> +                      bundle->id);
> +               goto FAILE_JOB_NOT_TRIGGER;
> +       }
> +
> +       if (dev_ctx->mode == MTK_FD_CTX_MODE_DEBUG_BYPASS_JOB_TRIGGER) {
> +               memset(&fram_param, 0, sizeof(struct mtk_fd_ctx_finish_param));
> +               fram_param.frame_id = bundle->id;
> +               fram_param.state = MTK_FD_CTX_FRAME_DATA_DONE;
> +               pr_debug("Ctx(%d) in HW bypass mode, will not trigger hw\n",
> +                        dev_ctx->ctx_id);
> +
> +               mtk_fd_ctx_core_job_finish(dev_ctx,     (void *)&fram_param);
> +               return 0;
> +       }
> +
> +       if (mtk_fd_ctx_core_job_start(dev_ctx, bundle))
> +               goto FAILE_JOB_NOT_TRIGGER;
> +       return 0;
> +
> +FAILE_JOB_NOT_TRIGGER:
> +       pr_debug("FAILE_JOB_NOT_TRIGGER: init fram_param: %llx\n",
> +                (unsigned long long)&fram_param);
> +       memset(&fram_param, 0, sizeof(struct mtk_fd_ctx_finish_param));
> +       fram_param.frame_id = bundle->id;
> +       fram_param.state = MTK_FD_CTX_FRAME_DATA_ERROR;
> +       pr_debug("Call mtk_fd_ctx_core_job_finish_cb: fram_param: %llx",
> +                (unsigned long long)&fram_param);
> +       mtk_fd_ctx_core_job_finish(dev_ctx, (void *)&fram_param);
> +
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_trigger_job);
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c b/drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c
> new file mode 100644
> index 0000000..7e3acf7
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c
> @@ -0,0 +1,355 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2018 Mediatek Corporation.
> + * Copyright (c) 2017 Intel Corporation.
> + * Copyright (C) 2017 Google, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * MTK_FD-dev is highly based on Intel IPU 3 chrome driver
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include "mtk_fd-dev.h"
> +
> +static struct platform_device *mtk_fd_dev_of_find_smem_dev
> +       (struct platform_device *pdev);
> +
> +/* Initliaze a mtk_fd_dev representing a completed HW FD */
> +/* device */
> +int mtk_fd_dev_init(struct mtk_fd_dev *fd_dev,
> +                   struct platform_device *pdev,
> +                   struct media_device *media_dev,
> +                   struct v4l2_device *v4l2_dev)
> +{
> +       int r = 0;
> +
> +       fd_dev->pdev = pdev;
> +
> +       mutex_init(&fd_dev->lock);
> +       atomic_set(&fd_dev->qbuf_barrier, 0);
> +       init_waitqueue_head(&fd_dev->buf_drain_wq);
> +
> +       /* v4l2 sub-device registration */
> +       r = mtk_fd_dev_mem2mem2_init(fd_dev, media_dev, v4l2_dev);
> +
> +       if (r) {
> +               dev_err(&fd_dev->pdev->dev,
> +                       "failed to create V4L2 devices (%d)\n", r);
> +               goto failed_mem2mem2;
> +       }
> +
> +       return 0;
> +
> +failed_mem2mem2:
> +       mutex_destroy(&fd_dev->lock);
> +       return r;
> +}
> +
> +int mtk_fd_dev_get_total_node(struct mtk_fd_dev *mtk_fd_dev)
> +{
> +       return mtk_fd_dev->ctx.queues_attr.total_num;
> +}
> +
> +int mtk_fd_dev_mem2mem2_init(struct mtk_fd_dev *fd_dev,
> +                            struct media_device *media_dev,
> +                            struct v4l2_device *v4l2_dev)
> +{
> +       int r, i;
> +       const int queue_master = fd_dev->ctx.queues_attr.master;
> +
> +       pr_info("mem2mem2.name: %s\n", fd_dev->ctx.device_name);
> +       fd_dev->mem2mem2.name = fd_dev->ctx.device_name;
> +       fd_dev->mem2mem2.model = fd_dev->ctx.device_name;
> +       fd_dev->mem2mem2.num_nodes =
> +               mtk_fd_dev_get_total_node(fd_dev);
> +       fd_dev->mem2mem2.vb2_mem_ops = &vb2_dma_contig_memops;
> +       fd_dev->mem2mem2.buf_struct_size =
> +               sizeof(struct mtk_fd_dev_buffer);
> +
> +       fd_dev->mem2mem2.nodes = fd_dev->mem2mem2_nodes;
> +       fd_dev->mem2mem2.dev = &fd_dev->pdev->dev;
> +
> +       for (i = 0; i < fd_dev->ctx.dev_node_num; i++) {
> +               fd_dev->mem2mem2.nodes[i].name =
> +                       mtk_fd_dev_get_node_name(fd_dev, i);
> +               fd_dev->mem2mem2.nodes[i].output =
> +                               (!fd_dev->ctx.queue[i].desc.capture);
> +               fd_dev->mem2mem2.nodes[i].immutable = false;
> +               fd_dev->mem2mem2.nodes[i].enabled = false;
> +               atomic_set(&fd_dev->mem2mem2.nodes[i].sequence, 0);
> +       }
> +
> +       /* Master queue is always enabled */
> +       fd_dev->mem2mem2.nodes[queue_master].immutable = true;
> +       fd_dev->mem2mem2.nodes[queue_master].enabled = true;
> +
> +       pr_info("register v4l2 for %llx\n",
> +               (unsigned long long)fd_dev);
> +       r = mtk_fd_mem2mem2_v4l2_register(fd_dev, media_dev, v4l2_dev);
> +
> +       if (r) {
> +               pr_err("v4l2 init failed, dev(ctx:%d)\n", fd_dev->ctx.ctx_id);
> +               return r;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_dev_mem2mem2_init);
> +
> +void mtk_fd_dev_mem2mem2_exit(struct mtk_fd_dev *fd_dev)
> +{
> +       mtk_fd_v4l2_unregister(fd_dev);
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_dev_mem2mem2_exit);
> +
> +char *mtk_fd_dev_get_node_name
> +       (struct mtk_fd_dev *fd_dev, int node)
> +{
> +       struct mtk_fd_ctx_queue_desc *mapped_queue_desc =
> +               &fd_dev->ctx.queue[node].desc;
> +
> +       return mapped_queue_desc->name;
> +}
> +
> +/* Get a free buffer from a video node */
> +static struct mtk_fd_ctx_buffer __maybe_unused *mtk_fd_dev_queue_getbuf
> +       (struct mtk_fd_dev *fd_dev, int node)
> +{
> +       struct mtk_fd_dev_buffer *buf;
> +       int queue = -1;
> +
> +       if (node > fd_dev->ctx.dev_node_num || node < 0) {
> +               dev_err(&fd_dev->pdev->dev, "Invalid mtk_fd_dev node.\n");
> +               return NULL;
> +       }
> +
> +       /* Get the corrosponding queue id of the video node */
> +       /* Currently the queue id is the same as the node number */
> +       queue = node;
> +
> +       if (queue < 0) {
> +               dev_err(&fd_dev->pdev->dev, "Invalid mtk_fd_dev node.\n");
> +               return NULL;
> +       }
> +
> +       /* Find first free buffer from the node */
> +       list_for_each_entry(buf, &fd_dev->mem2mem2.nodes[node].buffers,
> +                           m2m2_buf.list) {
> +               if (mtk_fd_ctx_get_buffer_state(&buf->ctx_buf)
> +                       == MTK_FD_CTX_BUFFER_NEW)
> +                       return &buf->ctx_buf;
> +       }
> +
> +       /* There were no free buffers*/
> +       return NULL;
> +}
> +
> +int mtk_fd_dev_get_queue_id_of_dev_node(struct mtk_fd_dev *fd_dev,
> +                                       struct mtk_fd_dev_video_device *node)
> +{
> +       return (node - fd_dev->mem2mem2.nodes);
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_dev_get_queue_id_of_dev_node);
> +
> +int mtk_fd_dev_queue_buffers(struct mtk_fd_dev *fd_dev,
> +                            bool initial)
> +{
> +       unsigned int node;
> +       int r = 0;
> +       struct mtk_fd_dev_buffer *ibuf;
> +       struct mtk_fd_ctx_frame_bundle bundle;
> +       const int mtk_fd_dev_node_num = mtk_fd_dev_get_total_node(fd_dev);
> +       const int queue_master = fd_dev->ctx.queues_attr.master;
> +
> +       memset(&bundle, 0, sizeof(struct mtk_fd_ctx_frame_bundle));
> +
> +       pr_info("%s, init(%d)\n", __func__, initial);
> +
> +       if (!mtk_fd_ctx_is_streaming(&fd_dev->ctx)) {
> +               pr_info("%s: stream off, no hw enqueue triggered\n", __func__);
> +               return 0;
> +       }
> +
> +       mutex_lock(&fd_dev->lock);
> +
> +       /* Buffer set is queued to background driver (e.g. DIP, FD, and P1) */
> +       /* only when master input buffer is ready */
> +       if (!mtk_fd_dev_queue_getbuf(fd_dev, queue_master)) {
> +               mutex_unlock(&fd_dev->lock);
> +               return 0;
> +       }
> +
> +       /* Check all node from the node after the master node */
> +       for (node = (queue_master + 1) % mtk_fd_dev_node_num;
> +               1; node = (node + 1) % mtk_fd_dev_node_num) {
> +               pr_info("Check node(%d), queue enabled(%d), node enabled(%d)\n",
> +                       node, fd_dev->queue_enabled[node],
> +                       fd_dev->mem2mem2.nodes[node].enabled);
> +
> +               /* May skip some node according the scenario in the future */
> +               if (fd_dev->queue_enabled[node] ||
> +                   fd_dev->mem2mem2.nodes[node].enabled) {
> +                       struct mtk_fd_ctx_buffer *buf =
> +                               mtk_fd_dev_queue_getbuf(fd_dev, node);
> +                       char *node_name =
> +                               mtk_fd_dev_get_node_name(fd_dev, node);
> +
> +                       if (!buf) {
> +                               dev_dbg(&fd_dev->pdev->dev,
> +                                       "No free buffer of enabled node %s\n",
> +                                       node_name);
> +                               break;
> +                       }
> +
> +                       /* To show the debug message */
> +                       ibuf = container_of(buf,
> +                                           struct mtk_fd_dev_buffer, ctx_buf);
> +                       dev_dbg(&fd_dev->pdev->dev,
> +                               "may queue user %s buffer idx(%d) to ctx\n",
> +                               node_name,
> +                               ibuf->m2m2_buf.vbb.vb2_buf.index);
> +                       mtk_fd_ctx_frame_bundle_add(&fd_dev->ctx,
> +                                                   &bundle, buf);
> +               }
> +
> +               /* Stop if there is no free buffer in master input node */
> +               if (node == queue_master) {
> +                       if (mtk_fd_dev_queue_getbuf(fd_dev, queue_master)) {
> +                               /* Has collected all buffer required */
> +                               mtk_fd_ctx_trigger_job(&fd_dev->ctx, &bundle);
> +                       } else {
> +                               pr_debug("no new buffer found in master node, not trigger job\n");
> +                               break;
> +                       }
> +               }
> +       }
> +       mutex_unlock(&fd_dev->lock);
> +
> +       if (r && r != -EBUSY)
> +               goto failed;
> +
> +       return 0;
> +
> +failed:
> +       /*
> +        * On error, mark all buffers as failed which are not
> +        * yet queued to CSS
> +        */
> +       dev_err(&fd_dev->pdev->dev,
> +               "failed to queue buffer to ctx on queue %i (%d)\n",
> +               node, r);
> +
> +       if (initial)
> +               /* If we were called from streamon(), no need to finish bufs */
> +               return r;
> +
> +       for (node = 0; node < mtk_fd_dev_node_num; node++) {
> +               struct mtk_fd_dev_buffer *buf, *buf0;
> +
> +               if (!fd_dev->queue_enabled[node])
> +                       continue;       /* Skip disabled queues */
> +
> +               mutex_lock(&fd_dev->lock);
> +               list_for_each_entry_safe
> +                       (buf, buf0,
> +                        &fd_dev->mem2mem2.nodes[node].buffers,
> +                        m2m2_buf.list) {
> +                       if (mtk_fd_ctx_get_buffer_state(&buf->ctx_buf) ==
> +                               MTK_FD_CTX_BUFFER_PROCESSING)
> +                               continue;       /* Was already queued, skip */
> +
> +                       mtk_fd_v4l2_buffer_done(&buf->m2m2_buf.vbb.vb2_buf,
> +                                               VB2_BUF_STATE_ERROR);
> +               }
> +               mutex_unlock(&fd_dev->lock);
> +       }
> +
> +       return r;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_dev_queue_buffers);
> +
> +int mtk_fd_dev_core_init(struct platform_device *pdev,
> +                        struct mtk_fd_dev *fd_dev,
> +                        struct mtk_fd_ctx_desc *ctx_desc)
> +{
> +       return mtk_fd_dev_core_init_ext(pdev,
> +               fd_dev, ctx_desc, NULL, NULL);
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_dev_core_init);
> +
> +int mtk_fd_dev_core_init_ext(struct platform_device *pdev,
> +                            struct mtk_fd_dev *fd_dev,
> +                            struct mtk_fd_ctx_desc *ctx_desc,
> +                            struct media_device *media_dev,
> +                            struct v4l2_device *v4l2_dev)
> +{
> +       int r;
> +       struct platform_device *smem_dev = NULL;
> +
> +       smem_dev = mtk_fd_dev_of_find_smem_dev(pdev);
> +
> +       if (!smem_dev)
> +               dev_err(&pdev->dev, "failed to find smem_dev\n");
> +
> +       /* Device context must be initialized before device instance */
> +       r = mtk_fd_ctx_core_init(&fd_dev->ctx, pdev,
> +                                0, ctx_desc, pdev, smem_dev);
> +
> +       dev_info(&pdev->dev, "init fd_dev: %llx\n",
> +                (unsigned long long)fd_dev);
> +       /* init other device level members */
> +       mtk_fd_dev_init(fd_dev, pdev, media_dev, v4l2_dev);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_dev_core_init_ext);
> +
> +int mtk_fd_dev_core_release(struct platform_device *pdev,
> +                           struct mtk_fd_dev *fd_dev)
> +{
> +       mtk_fd_dev_mem2mem2_exit(fd_dev);
> +       mtk_fd_ctx_core_exit(&fd_dev->ctx);
> +       mutex_destroy(&fd_dev->lock);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_dev_core_release);
> +
> +static struct platform_device *mtk_fd_dev_of_find_smem_dev
> +       (struct platform_device *pdev)
> +{
> +       struct device_node *smem_dev_node = NULL;
> +
> +       if (!pdev) {
> +               pr_err("Find_smem_dev failed, pdev can't be NULL\n");
> +               return NULL;
> +       }
> +
> +       smem_dev_node = of_parse_phandle(pdev->dev.of_node,
> +                                        "smem_device", 0);
> +
> +       if (!smem_dev_node) {
> +               dev_err(&pdev->dev,
> +                       "failed to find isp smem device for (%s)\n",
> +                       pdev->name);
> +               return NULL;
> +       }
> +
> +       dev_dbg(&pdev->dev, "smem of node found, try to discovery device\n");
> +       return of_find_device_by_node(smem_dev_node);
> +}
> +
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h b/drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h
> new file mode 100644
> index 0000000..d2b7d77
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h
> @@ -0,0 +1,198 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + * Copyright (c) 2018 Mediatek Corporation.
> + * Copyright (c) 2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * MTK_FD-dev is highly based on Intel IPU 3 chrome driver
> + *
> + */
> +
> +#ifndef __MTK_FD_DEV_H__
> +#define __MTK_FD_DEV_H__
> +
> +#include <linux/platform_device.h>
> +#include <linux/version.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-v4l2.h>
> +#include "mtk_fd-ctx.h"
> +
> +/* Added the macro for early stage verification */
> +/* based on kernel 4.4 environment. */
> +/* I will remove the version check after getting */
> +/* the devlopment platform based on 4.14 */
> +#define MTK_FD_KERNEL_BASE_VERSION KERNEL_VERSION(4, 14, 0)
> +
> +#define MTK_FD_DEV_NODE_MAX                    (MTK_FD_CTX_QUEUES)
> +
> +#define MTK_FD_INPUT_MIN_WIDTH         0U
> +#define MTK_FD_INPUT_MIN_HEIGHT                0U
> +#define MTK_FD_INPUT_MAX_WIDTH         480U
> +#define MTK_FD_INPUT_MAX_HEIGHT                640U
> +#define MTK_FD_OUTPUT_MIN_WIDTH                2U
> +#define MTK_FD_OUTPUT_MIN_HEIGHT               2U
> +#define MTK_FD_OUTPUT_MAX_WIDTH                480U
> +#define MTK_FD_OUTPUT_MAX_HEIGHT               640U
> +
> +#define file_to_mtk_fd_node(__file) \
> +       container_of(video_devdata(__file),\
> +       struct mtk_fd_dev_video_device, vdev)
> +
> +#define mtk_fd_ctx_to_dev(__ctx) \
> +       container_of(__ctx,\
> +       struct mtk_fd_dev, ctx)
> +
> +#define mtk_fd_m2m_to_dev(__m2m) \
> +       container_of(__m2m,\
> +       struct mtk_fd_dev, mem2mem2)
> +
> +#define mtk_fd_subdev_to_dev(__sd) \
> +       container_of(__sd, \
> +       struct mtk_fd_dev, mem2mem2.subdev)
> +
> +#define mtk_fd_vbq_to_isp_node(__vq) \
> +       container_of(__vq, \
> +       struct mtk_fd_dev_video_device, vbq)
> +
> +#define mtk_fd_ctx_buf_to_dev_buf(__ctx_buf) \
> +       container_of(__ctx_buf, \
> +       struct mtk_fd_dev_buffer, ctx_buf)
> +
> +#define mtk_fd_vb2_buf_to_dev_buf(__vb) \
> +       container_of(vb, \
> +       struct mtk_fd_dev_buffer, \
> +       m2m2_buf.vbb.vb2_buf)
> +
> +#define mtk_fd_vb2_buf_to_m2m_buf(__vb) \
> +       container_of(__vb, \
> +       struct mtk_fd_mem2mem2_buffer, \
> +       vbb.vb2_buf)
> +
> +#define mtk_fd_subdev_to_m2m(__sd) \
> +       container_of(__sd, \
> +       struct mtk_fd_mem2mem2_device, subdev)
> +
> +struct mtk_fd_mem2mem2_device;
> +
> +struct mtk_fd_mem2mem2_buffer {
> +       struct vb2_v4l2_buffer vbb;
> +       struct list_head list;
> +};
> +
> +struct mtk_fd_dev_buffer {
> +       struct mtk_fd_mem2mem2_buffer m2m2_buf;
> +       /* Intenal part */
> +       struct mtk_fd_ctx_buffer ctx_buf;
> +};
> +
> +struct mtk_fd_dev_video_device {
> +       const char *name;
> +       int output;
> +       int immutable;
> +       int enabled;
> +       int queued;
> +       struct v4l2_format vdev_fmt;
> +       struct video_device vdev;
> +       struct media_pad vdev_pad;
> +       struct v4l2_mbus_framefmt pad_fmt;
> +       struct vb2_queue vbq;
> +       struct list_head buffers;
> +       struct mutex lock; /* Protect node data */
> +       atomic_t sequence;
> +};
> +
> +struct mtk_fd_mem2mem2_device {
> +       const char *name;
> +       const char *model;
> +       struct device *dev;
> +       int num_nodes;
> +       struct mtk_fd_dev_video_device *nodes;
> +       const struct vb2_mem_ops *vb2_mem_ops;
> +       unsigned int buf_struct_size;
> +       int streaming;
> +       struct v4l2_device *v4l2_dev;
> +       struct media_device *media_dev;
> +       struct media_pipeline pipeline;
> +       struct v4l2_subdev subdev;
> +       struct media_pad *subdev_pads;
> +       struct v4l2_file_operations v4l2_file_ops;
> +       const struct file_operations fops;
> +};
> +
> +struct mtk_fd_dev {
> +       struct platform_device *pdev;
> +       struct mtk_fd_dev_video_device mem2mem2_nodes[MTK_FD_DEV_NODE_MAX];
> +       int queue_enabled[MTK_FD_DEV_NODE_MAX];
> +       struct mtk_fd_mem2mem2_device mem2mem2;
> +       struct v4l2_device v4l2_dev;
> +       struct media_device media_dev;
> +       struct mtk_fd_ctx ctx;
> +       struct mutex lock; /* queue protection */
> +       atomic_t qbuf_barrier;
> +       struct {
> +               struct v4l2_rect eff;
> +               struct v4l2_rect bds;
> +               struct v4l2_rect gdc;
> +       } rect;
> +       int suspend_in_stream;
> +       wait_queue_head_t buf_drain_wq;
> +};
> +
> +int mtk_fd_media_register(struct device *dev,
> +                         struct media_device *media_dev,
> +                         const char *model);
> +
> +int mtk_fd_v4l2_register(struct device *dev,
> +                        struct media_device *media_dev,
> +                        struct v4l2_device *v4l2_dev);
> +
> +int mtk_fd_v4l2_unregister(struct mtk_fd_dev *dev);
> +
> +int mtk_fd_mem2mem2_v4l2_register(struct mtk_fd_dev *dev,
> +                                 struct media_device *media_dev,
> +                                 struct v4l2_device *v4l2_dev);
> +
> +void mtk_fd_v4l2_buffer_done(struct vb2_buffer *vb,
> +                            enum vb2_buffer_state state);
> +
> +int mtk_fd_dev_queue_buffers(struct mtk_fd_dev *dev, bool initial);
> +
> +int mtk_fd_dev_get_total_node(struct mtk_fd_dev *mtk_fd_dev);
> +
> +char *mtk_fd_dev_get_node_name(struct mtk_fd_dev *mtk_fd_dev_obj, int node);
> +
> +int mtk_fd_dev_init(struct mtk_fd_dev *fd_dev,
> +                   struct platform_device *pdev,
> +                   struct media_device *media_dev,
> +                   struct v4l2_device *v4l2_dev);
> +
> +void mtk_fd_dev_mem2mem2_exit(struct mtk_fd_dev *mtk_fd_dev_obj);
> +
> +int mtk_fd_dev_mem2mem2_init(struct mtk_fd_dev *fd_dev,
> +                            struct media_device *media_dev,
> +                            struct v4l2_device *v4l2_dev);
> +
> +int mtk_fd_dev_get_queue_id_of_dev_node(struct mtk_fd_dev *mtk_fd_dev_obj,
> +                                       struct mtk_fd_dev_video_device *node);
> +
> +int mtk_fd_dev_core_init(struct platform_device *pdev,
> +                        struct mtk_fd_dev *fd_dev,
> +                        struct mtk_fd_ctx_desc *ctx_desc);
> +
> +int mtk_fd_dev_core_init_ext(struct platform_device *pdev,
> +                            struct mtk_fd_dev *fd_dev,
> +                            struct mtk_fd_ctx_desc *ctx_desc,
> +                            struct media_device *media_dev,
> +                            struct v4l2_device *v4l2_dev);
> +
> +int mtk_fd_dev_core_release(struct platform_device *pdev,
> +                           struct mtk_fd_dev *fd_dev);
> +
> +#endif /* __MTK_FD_DEV_H__ */
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-smem-drv.c b/drivers/media/platform/mtk-isp/fd/mtk_fd-smem-drv.c
> new file mode 100644
> index 0000000..99a852d
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-smem-drv.c
> @@ -0,0 +1,452 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2018 MediaTek Inc.
> + * Author: Frederic Chen <frederic.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_reserved_mem.h>
> +#include <linux/dma-contiguous.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/iommu.h>
> +#include <asm/cacheflush.h>
> +
> +#define MTK_FD_SMEM_DEV_NAME "MTK-FD-SMEM"
> +
> +struct mtk_fd_smem_drv {
> +       struct platform_device *pdev;
> +       struct sg_table sgt;
> +       struct page **smem_pages;
> +       int num_smem_pages;
> +       phys_addr_t smem_base;
> +       dma_addr_t smem_dma_base;
> +       int smem_size;
> +};
> +
> +static struct reserved_mem *isp_reserved_smem;
> +
> +static int mtk_fd_smem_setup_dma_ops(struct device *smem_dev,
> +                                    const struct dma_map_ops *smem_ops);
> +
> +static int mtk_fd_smem_get_sgtable(struct device *dev,
> +                                  struct sg_table *sgt,
> +                                  void *cpu_addr, dma_addr_t dma_addr,
> +                                  size_t size, unsigned long attrs);
> +
> +static const struct dma_map_ops smem_dma_ops = {
> +       .get_sgtable = mtk_fd_smem_get_sgtable,
> +};
> +
> +static int mtk_fd_smem_init(struct mtk_fd_smem_drv **mtk_fd_smem_drv_out,
> +                           struct platform_device *pdev)
> +{
> +       struct mtk_fd_smem_drv *isp_sys = NULL;
> +       struct device *dev = &pdev->dev;
> +
> +       isp_sys = devm_kzalloc(dev,
> +                              sizeof(*isp_sys), GFP_KERNEL);
> +
> +       isp_sys->pdev = pdev;
> +
> +       *mtk_fd_smem_drv_out = isp_sys;
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_smem_drv_probe(struct platform_device *pdev)
> +{
> +       struct mtk_fd_smem_drv *smem_drv = NULL;
> +       int r = 0;
> +       struct device *dev = &pdev->dev;
> +
> +       dev_dbg(dev, "probe mtk_fd_smem_drv\n");
> +
> +       r = mtk_fd_smem_init(&smem_drv, pdev);
> +
> +       if (!smem_drv)
> +               return -ENOMEM;
> +
> +       dev_set_drvdata(dev, smem_drv);
> +
> +       if (isp_reserved_smem) {
> +               dma_addr_t dma_addr;
> +               phys_addr_t addr;
> +               struct iommu_domain *smem_dom;
> +               int i = 0;
> +               int size_align = 0;
> +               struct page **pages = NULL;
> +               int n_pages = 0;
> +               struct sg_table *sgt = &smem_drv->sgt;
> +
> +               size_align = round_down(isp_reserved_smem->size,
> +                                       PAGE_SIZE);
> +               n_pages = size_align >> PAGE_SHIFT;
> +
> +               pages = kmalloc_array(n_pages, sizeof(struct page *),
> +                                     GFP_KERNEL);
> +
> +               if (!pages)
> +                       return -ENOMEM;
> +
> +               for (i = 0; i < n_pages; i++)
> +                       pages[i] = phys_to_page(isp_reserved_smem->base
> +                                               + i * PAGE_SIZE);
> +
> +               r = sg_alloc_table_from_pages(sgt, pages, n_pages, 0,
> +                                             size_align, GFP_KERNEL);
> +
> +               if (r) {
> +                       dev_err(dev, "failed to get alloca sg table\n");
> +                       return -ENOMEM;
> +               }
> +
> +               dma_map_sg_attrs(dev, sgt->sgl, sgt->nents,
> +                                DMA_BIDIRECTIONAL,
> +                                DMA_ATTR_SKIP_CPU_SYNC);
> +
> +               dma_addr = sg_dma_address(sgt->sgl);
> +               smem_dom = iommu_get_domain_for_dev(dev);
> +               addr = iommu_iova_to_phys(smem_dom, dma_addr);
> +
> +               if (addr != isp_reserved_smem->base)
> +                       dev_err(dev,
> +                               "incorrect pa(%llx) from iommu_iova_to_phys, should be %llx\n",
> +                       (unsigned long long)addr,
> +                       (unsigned long long)isp_reserved_smem->base);
> +
> +               r = dma_declare_coherent_memory(dev,
> +                                               isp_reserved_smem->base,
> +                       dma_addr, size_align, DMA_MEMORY_EXCLUSIVE);
> +
> +               dev_dbg(dev,
> +                       "Coherent mem base(%llx,%llx),size(%lx),ret(%d)\n",
> +                       isp_reserved_smem->base,
> +                       dma_addr, size_align, r);
> +
> +               smem_drv->smem_base = isp_reserved_smem->base;
> +               smem_drv->smem_size = size_align;
> +               smem_drv->smem_pages = pages;
> +               smem_drv->num_smem_pages = n_pages;
> +               smem_drv->smem_dma_base = dma_addr;
> +
> +               dev_dbg(dev, "smem_drv setting (%llx,%lx,%llx,%d)\n",
> +                       smem_drv->smem_base, smem_drv->smem_size,
> +                       (unsigned long long)smem_drv->smem_pages,
> +                       smem_drv->num_smem_pages);
> +       }
> +
> +       r = mtk_fd_smem_setup_dma_ops(dev, &smem_dma_ops);
> +
> +       return r;
> +}
> +
> +phys_addr_t mtk_fd_smem_iova_to_phys(struct device *dev,
> +                                    dma_addr_t iova)
> +{
> +               struct iommu_domain *smem_dom;
> +               phys_addr_t addr;
> +               phys_addr_t limit;
> +               struct mtk_fd_smem_drv *smem_dev =
> +                       dev_get_drvdata(dev);
> +
> +               if (!smem_dev)
> +                       return 0;
> +
> +               smem_dom = iommu_get_domain_for_dev(dev);
> +
> +               if (!smem_dom)
> +                       return 0;
> +
> +               addr = iommu_iova_to_phys(smem_dom, iova);
> +
> +               limit = smem_dev->smem_base + smem_dev->smem_size;
> +
> +               if (addr < smem_dev->smem_base || addr >= limit) {
> +                       dev_err(dev,
> +                               "Unexpected paddr %pa (must >= %pa and <%pa)\n",
> +                               &addr, &smem_dev->smem_base, &limit);
> +                       return 0;
> +               }
> +               dev_dbg(dev, "Pa verifcation pass: %pa(>=%pa, <%pa)\n",
> +                       &addr, &smem_dev->smem_base, &limit);
> +               return addr;
> +}
> +
> +static int mtk_fd_smem_drv_remove(struct platform_device *pdev)
> +{
> +       struct mtk_fd_smem_drv *smem_drv =
> +               dev_get_drvdata(&pdev->dev);
> +
> +       kfree(smem_drv->smem_pages);
> +       return 0;
> +}
> +
> +static int mtk_fd_smem_drv_suspend(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static int mtk_fd_smem_drv_resume(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static int mtk_fd_smem_drv_dummy_cb(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops mtk_fd_smem_drv_pm_ops = {
> +       SET_RUNTIME_PM_OPS(&mtk_fd_smem_drv_dummy_cb,
> +                          &mtk_fd_smem_drv_dummy_cb, NULL)
> +       SET_SYSTEM_SLEEP_PM_OPS
> +               (&mtk_fd_smem_drv_suspend, &mtk_fd_smem_drv_resume)
> +};
> +
> +static const struct of_device_id mtk_fd_smem_drv_of_match[] = {
> +       {
> +               .compatible = "mediatek,fd_smem",
> +       },
> +       {},
> +};
> +
> +MODULE_DEVICE_TABLE(of, mtk_fd_smem_drv_of_match);
> +
> +static struct platform_driver mtk_fd_smem_driver = {
> +       .probe = mtk_fd_smem_drv_probe,
> +       .remove = mtk_fd_smem_drv_remove,
> +       .driver = {
> +               .name = MTK_FD_SMEM_DEV_NAME,
> +               .of_match_table =
> +                       of_match_ptr(mtk_fd_smem_drv_of_match),
> +               .pm = &mtk_fd_smem_drv_pm_ops,
> +       },
> +};
> +
> +static int __init mtk_fd_smem_dma_setup(struct reserved_mem
> +                                       *rmem)
> +{
> +       unsigned long node = rmem->fdt_node;
> +
> +       if (of_get_flat_dt_prop(node, "reusable", NULL))
> +               return -EINVAL;
> +
> +       if (!of_get_flat_dt_prop(node, "no-map", NULL)) {
> +               pr_err("Reserved memory: regions without no-map are not yet supported\n");
> +               return -EINVAL;
> +       }
> +
> +       isp_reserved_smem = rmem;
> +
> +       pr_debug("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
> +                &rmem->base, (unsigned long)rmem->size / SZ_1M);
> +       return 0;
> +}
> +
> +RESERVEDMEM_OF_DECLARE(mtk_fd_smem,
> +                      "mediatek,reserve-memory-fd_smem",
> +                      mtk_fd_smem_dma_setup);
> +
> +int __init mtk_fd_smem_drv_init(void)
> +{
> +       int ret = 0;
> +
> +       pr_debug("platform_driver_register: mtk_fd_smem_driver\n");
> +       ret = platform_driver_register(&mtk_fd_smem_driver);
> +
> +       if (ret)
> +               pr_warn("fd smem drv init failed, driver didn't probe\n");
> +
> +       return ret;
> +}
> +subsys_initcall(mtk_fd_smem_drv_init);
> +
> +void __exit mtk_fd_smem_drv_ext(void)
> +{
> +       platform_driver_unregister(&mtk_fd_smem_driver);
> +}
> +module_exit(mtk_fd_smem_drv_ext);
> +
> +/********************************************
> + * MTK FD SMEM DMA ops *
> + ********************************************/
> +
> +struct dma_coherent_mem {
> +       void            *virt_base;
> +       dma_addr_t      device_base;
> +       unsigned long   pfn_base;
> +       int             size;
> +       int             flags;
> +       unsigned long   *bitmap;
> +       spinlock_t      spinlock; /* protect the members in dma_coherent_mem */
> +       bool            use_dev_dma_pfn_offset;
> +};
> +
> +static struct dma_coherent_mem *dev_get_coherent_memory(struct device *dev)
> +{
> +       if (dev && dev->dma_mem)
> +               return dev->dma_mem;
> +       return NULL;
> +}
> +
> +static int mtk_fd_smem_get_sgtable(struct device *dev,
> +                                  struct sg_table *sgt,
> +       void *cpu_addr, dma_addr_t dma_addr,
> +       size_t size, unsigned long attrs)
> +{
> +       struct mtk_fd_smem_drv *smem_dev = dev_get_drvdata(dev);
> +       int n_pages_align = 0;
> +       int size_align = 0;
> +       int page_start = 0;
> +       unsigned long long offset_p = 0;
> +       unsigned long long offset_d = 0;
> +
> +       phys_addr_t paddr = mtk_fd_smem_iova_to_phys(dev, dma_addr);
> +
> +       offset_d = (unsigned long long)dma_addr -
> +               (unsigned long long)smem_dev->smem_dma_base;
> +
> +       offset_p = (unsigned long long)paddr -
> +               (unsigned long long)smem_dev->smem_base;
> +
> +       dev_dbg(dev, "%s:dma_addr:%llx,cpu_addr:%llx,pa:%llx,size:%d\n",
> +               __func__,
> +               (unsigned long long)dma_addr,
> +               (unsigned long long)cpu_addr,
> +               (unsigned long long)paddr,
> +               size
> +               );
> +
> +       dev_dbg(dev, "%s:offset p:%llx,offset d:%llx\n",
> +               __func__,
> +               (unsigned long long)offset_p,
> +               (unsigned long long)offset_d
> +               );
> +
> +       size_align = round_up(size, PAGE_SIZE);
> +       n_pages_align = size_align >> PAGE_SHIFT;
> +       page_start = offset_p >> PAGE_SHIFT;
> +
> +       dev_dbg(dev,
> +               "%s:page idx:%d,page pa:%llx,pa:%llx, aligned size:%d\n",
> +               __func__,
> +               page_start,
> +               (unsigned long long)page_to_phys(*(smem_dev->smem_pages
> +                       + page_start)),
> +               (unsigned long long)paddr,
> +               size_align
> +               );
> +
> +       if (!smem_dev) {
> +               dev_err(dev, "can't get sgtable from smem_dev\n");
> +               return -EINVAL;
> +       }
> +
> +       dev_dbg(dev, "get sgt of the smem: %d pages\n", n_pages_align);
> +
> +       return sg_alloc_table_from_pages(sgt,
> +               smem_dev->smem_pages + page_start,
> +               n_pages_align,
> +               0, size_align, GFP_KERNEL);
> +}
> +
> +static void *mtk_fd_smem_get_cpu_addr(struct mtk_fd_smem_drv *smem_dev,
> +                                     struct scatterlist *sg)
> +{
> +       struct device *dev = &smem_dev->pdev->dev;
> +       struct dma_coherent_mem *dma_mem =
> +               dev_get_coherent_memory(dev);
> +
> +       phys_addr_t addr = (phys_addr_t)sg_phys(sg);
> +
> +       if (addr < smem_dev->smem_base ||
> +           addr > smem_dev->smem_base + smem_dev->smem_size) {
> +               dev_err(dev, "Invalid paddr 0x%llx from sg\n", addr);
> +               return NULL;
> +       }
> +
> +       return dma_mem->virt_base + (addr - smem_dev->smem_base);
> +}
> +
> +static void mtk_fd_smem_sync_sg_for_cpu(struct device *dev,
> +                                       struct scatterlist *sgl, int nelems,
> +                                       enum dma_data_direction dir)
> +{
> +       struct mtk_fd_smem_drv *smem_dev =
> +               dev_get_drvdata(dev);
> +       void *cpu_addr;
> +
> +       cpu_addr = mtk_fd_smem_get_cpu_addr(smem_dev, sgl);
> +
> +       dev_dbg(dev,
> +               "__dma_unmap_area:paddr(0x%llx),vaddr(0x%llx),size(%d)\n",
> +               (unsigned long long)sg_phys(sgl),
> +               (unsigned long long)cpu_addr,
> +               sgl->length);
> +
> +       __dma_unmap_area(cpu_addr, sgl->length, dir);
> +}
> +
> +static void mtk_fd_smem_sync_sg_for_device(struct device *dev,
> +                                          struct scatterlist *sgl, int nelems,
> +                                          enum dma_data_direction dir)
> +{
> +       struct mtk_fd_smem_drv *smem_dev =
> +                       dev_get_drvdata(dev);
> +       void *cpu_addr;
> +
> +       cpu_addr = mtk_fd_smem_get_cpu_addr(smem_dev, sgl);
> +
> +       dev_dbg(dev,
> +               "__dma_map_area:paddr(0x%llx),vaddr(0x%llx),size(%d)\n",
> +               (unsigned long long)sg_phys(sgl),
> +               (unsigned long long)cpu_addr,
> +               sgl->length);
> +
> +       __dma_map_area(cpu_addr, sgl->length, dir);
> +}
> +
> +static int mtk_fd_smem_setup_dma_ops(struct device *dev,
> +                                    const struct dma_map_ops *smem_ops)
> +{
> +       if (!dev->dma_ops)
> +               return -EINVAL;
> +
> +       memcpy((void *)smem_ops, dev->dma_ops, sizeof(*smem_ops));
> +
> +       ((struct dma_map_ops *)smem_ops)->get_sgtable =
> +               mtk_fd_smem_get_sgtable;
> +       ((struct dma_map_ops *)smem_ops)->sync_sg_for_device =
> +               mtk_fd_smem_sync_sg_for_device;
> +       ((struct dma_map_ops *)smem_ops)->sync_sg_for_cpu =
> +               mtk_fd_smem_sync_sg_for_cpu;
> +
> +       dev->dma_ops = smem_ops;
> +
> +       return 0;
> +}
> +
> +void mtk_fd_smem_enable_mpu(struct device *dev)
> +{
> +       dev_warn(dev, "MPU enabling func is not ready now\n");
> +}
> +
> +MODULE_AUTHOR("Frederic Chen <frederic.chen@mediatek.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Mediatek FD shared memory driver");
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h b/drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h
> new file mode 100644
> index 0000000..a19fc37
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2018 MediaTek Inc.
> + * Author: Frederic Chen <frederic.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MTK_FD_SMEM_H__
> +#define __MTK_FD_SMEM_H__
> +
> +#include <linux/dma-mapping.h>
> +
> +phys_addr_t mtk_fd_smem_iova_to_phys(struct device *smem_dev,
> +                                    dma_addr_t iova);
> +void mtk_fd_smem_enable_mpu(struct device *smem_dev);
> +
> +#endif /*__MTK_FD_SMEM_H__*/
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c b/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c
> new file mode 100644
> index 0000000..ab85aea
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c
> @@ -0,0 +1,1046 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2018 Mediatek Corporation.
> + * Copyright (c) 2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * MTK_FD-v4l2 is highly based on Intel IPU 3 chrome driver
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-event.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +
> +#include "mtk_fd-dev.h"
> +
> +static u32 mtk_fd_node_get_v4l2_cap
> +       (struct mtk_fd_ctx_queue *node_ctx);
> +
> +static int mtk_fd_videoc_s_meta_fmt(struct file *file, void *fh,
> +                                   struct v4l2_format *f);
> +
> +static int mtk_fd_subdev_open(struct v4l2_subdev *sd,
> +                             struct v4l2_subdev_fh *fh)
> +{
> +       struct mtk_fd_dev *fd_dev = mtk_fd_subdev_to_dev(sd);
> +
> +       fd_dev->ctx.fh = fh;
> +
> +       return mtk_fd_ctx_open(&fd_dev->ctx);
> +}
> +
> +static int mtk_fd_subdev_close(struct v4l2_subdev *sd,
> +                              struct v4l2_subdev_fh *fh)
> +{
> +       struct mtk_fd_dev *fd_dev = mtk_fd_subdev_to_dev(sd);
> +
> +       return mtk_fd_ctx_release(&fd_dev->ctx);
> +}
> +
> +static int mtk_fd_subdev_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +       int ret = 0;
> +
> +       struct mtk_fd_dev *fd_dev = mtk_fd_subdev_to_dev(sd);
> +
> +       if (enable) {
> +               ret = mtk_fd_ctx_streamon(&fd_dev->ctx);
> +
> +               if (!ret)
> +                       ret = mtk_fd_dev_queue_buffers
> +                               (mtk_fd_ctx_to_dev(&fd_dev->ctx), true);
> +               if (ret)
> +                       pr_err("failed to queue initial buffers (%d)", ret);
> +       }       else {
> +               ret = mtk_fd_ctx_streamoff(&fd_dev->ctx);
> +       }
> +
> +       if (!ret)
> +               fd_dev->mem2mem2.streaming = enable;
> +
> +       return ret;
> +}
> +
> +static int mtk_fd_link_setup(struct media_entity *entity,
> +                            const struct media_pad *local,
> +                            const struct media_pad *remote, u32 flags)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 =
> +               container_of(entity, struct mtk_fd_mem2mem2_device,
> +                            subdev.entity);
> +       struct mtk_fd_dev *fd_dev =
> +               container_of(m2m2, struct mtk_fd_dev, mem2mem2);
> +
> +       u32 pad = local->index;
> +
> +       pr_info("link setup: %d --> %d\n", pad, remote->index);
> +
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       WARN_ON(entity->type != MEDIA_ENT_T_V4L2_SUBDEV);
> +#else
> +       WARN_ON(entity->obj_type != MEDIA_ENTITY_TYPE_V4L2_SUBDEV);
> +#endif
> +
> +       WARN_ON(pad >= m2m2->num_nodes);
> +
> +       m2m2->nodes[pad].enabled = !!(flags & MEDIA_LNK_FL_ENABLED);
> +
> +       /**
> +        * queue_enable can be phase out in the future since
> +        * we don't have internal queue of each node in
> +        * v4l2 common module
> +        */
> +       fd_dev->queue_enabled[pad] = m2m2->nodes[pad].enabled;
> +
> +       return 0;
> +}
> +
> +static void mtk_fd_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = vb2_get_drv_priv(vb->vb2_queue);
> +       struct mtk_fd_dev *mtk_fd_dev = mtk_fd_m2m_to_dev(m2m2);
> +       struct device *dev = &mtk_fd_dev->pdev->dev;
> +       struct mtk_fd_dev_buffer *buf = NULL;
> +       struct vb2_v4l2_buffer *v4l2_buf = NULL;
> +       struct mtk_fd_dev_video_device *node =
> +               mtk_fd_vbq_to_isp_node(vb->vb2_queue);
> +       int queue = mtk_fd_dev_get_queue_id_of_dev_node(mtk_fd_dev, node);
> +
> +       dev_dbg(dev,
> +               "queue vb2_buf: Node(%s) queue id(%d)\n",
> +               node->name,
> +               queue);
> +
> +       if (queue < 0) {
> +               dev_err(m2m2->dev, "Invalid mtk_fd_dev node.\n");
> +               return;
> +       }
> +
> +       if (mtk_fd_dev->ctx.mode == MTK_FD_CTX_MODE_DEBUG_BYPASS_ALL) {
> +               dev_dbg(m2m2->dev, "By pass mode, just loop back the buffer\n");
> +               vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +               return;
> +       }
> +
> +       if (!vb)
> +               pr_err("VB can't be null\n");
> +
> +       buf = mtk_fd_vb2_buf_to_dev_buf(vb);
> +
> +       if (!buf)
> +               pr_err("buf can't be null\n");
> +
> +       v4l2_buf = to_vb2_v4l2_buffer(vb);
> +
> +       if (!v4l2_buf)
> +               pr_err("v4l2_buf can't be null\n");
> +
> +       mutex_lock(&mtk_fd_dev->lock);
> +
> +       pr_err("init  mtk_fd_ctx_buf_init, sequence(%d)\n", v4l2_buf->sequence);
> +
> +       /* the dma address will be filled in later frame buffer handling*/
> +       mtk_fd_ctx_buf_init(&buf->ctx_buf, queue, (dma_addr_t)0);
> +       pr_info("set mtk_fd_ctx_buf_init: user seq=%d\n",
> +               buf->ctx_buf.user_sequence);
> +
> +       /* Added the buffer into the tracking list */
> +       list_add_tail(&buf->m2m2_buf.list,
> +                     &m2m2->nodes[node - m2m2->nodes].buffers);
> +       mutex_unlock(&mtk_fd_dev->lock);
> +
> +       /* Enqueue the buffer */
> +       if (mtk_fd_dev->mem2mem2.streaming) {
> +               pr_info("%s: mtk_fd_dev_queue_buffers\n", node->name);
> +               mtk_fd_dev_queue_buffers(mtk_fd_dev, false);
> +       }
> +}
> +
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +static int mtk_fd_vb2_queue_setup(struct vb2_queue *vq,
> +                                 const void *parg,
> +                                 unsigned int *num_buffers,
> +                                 unsigned int *num_planes,
> +                                 unsigned int sizes[], void *alloc_ctxs[])
> +#else
> +static int mtk_fd_vb2_queue_setup(struct vb2_queue *vq,
> +                                 unsigned int *num_buffers,
> +                                 unsigned int *num_planes,
> +                                 unsigned int sizes[],
> +                                 struct device *alloc_devs[])
> +#endif
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> +       struct mtk_fd_dev_video_device *node = mtk_fd_vbq_to_isp_node(vq);
> +       struct mtk_fd_dev *fd_dev = mtk_fd_m2m_to_dev(m2m2);
> +       void *buf_alloc_ctx = NULL;
> +       int queue = mtk_fd_dev_get_queue_id_of_dev_node(fd_dev, node);
> +       /* Get V4L2 format with the following method */
> +       const struct v4l2_format *fmt = &node->vdev_fmt;
> +
> +       *num_planes = 1;
> +       *num_buffers = clamp_val(*num_buffers, 1, VB2_MAX_FRAME);
> +
> +       vq->dma_attrs |= DMA_ATTR_NON_CONSISTENT;
> +       pr_info("queue(%d): cached mmap enabled\n", queue);
> +
> +       if (vq->type == V4L2_BUF_TYPE_META_CAPTURE ||
> +           vq->type == V4L2_BUF_TYPE_META_OUTPUT) {
> +               sizes[0] = fmt->fmt.meta.buffersize;
> +               buf_alloc_ctx = fd_dev->ctx.smem_vb2_alloc_ctx;
> +               pr_info("Select smem_vb2_alloc_ctx(%llx)\n",
> +                       (unsigned long long)buf_alloc_ctx);
> +       } else {
> +               sizes[0] = fmt->fmt.pix_mp.plane_fmt[0].sizeimage;
> +               buf_alloc_ctx = fd_dev->ctx.img_vb2_alloc_ctx;
> +               pr_info("Select img_vb2_alloc_ctx(%llx)\n",
> +                       (unsigned long long)buf_alloc_ctx);
> +       }
> +
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       alloc_ctxs[0] = buf_alloc_ctx;
> +#else
> +       alloc_devs[0] = (struct device *)buf_alloc_ctx;
> +#endif
> +
> +       pr_info("mtk_fd_vb2_queue_setup:type(%d),size(%d),ctx(%llx)\n",
> +               vq->type, sizes[0], (unsigned long long)buf_alloc_ctx);
> +
> +       /* Initialize buffer queue */
> +       INIT_LIST_HEAD(&node->buffers);
> +
> +       return 0;
> +}
> +
> +static bool mtk_fd_all_nodes_streaming(struct mtk_fd_mem2mem2_device *m2m2,
> +                                      struct mtk_fd_dev_video_device *except)
> +{
> +       int i;
> +
> +       for (i = 0; i < m2m2->num_nodes; i++) {
> +               struct mtk_fd_dev_video_device *node = &m2m2->nodes[i];
> +
> +               if (node == except)
> +                       continue;
> +               if (node->enabled && !vb2_start_streaming_called(&node->vbq))
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +static void mtk_fd_return_all_buffers(struct mtk_fd_mem2mem2_device *m2m2,
> +                                     struct mtk_fd_dev_video_device *node,
> +                                     enum vb2_buffer_state state)
> +{
> +       struct mtk_fd_dev *mtk_fd_dev = mtk_fd_m2m_to_dev(m2m2);
> +       struct mtk_fd_mem2mem2_buffer *b, *b0;
> +
> +       /* Return all buffers */
> +       mutex_lock(&mtk_fd_dev->lock);
> +       list_for_each_entry_safe(b, b0, &node->buffers, list) {
> +               list_del(&b->list);
> +               vb2_buffer_done(&b->vbb.vb2_buf, state);
> +       }
> +       mutex_unlock(&mtk_fd_dev->lock);
> +}
> +
> +static int mtk_fd_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> +       struct mtk_fd_dev_video_device *node =
> +               mtk_fd_vbq_to_isp_node(vq);
> +       int r;
> +
> +       if (m2m2->streaming) {
> +               r = -EBUSY;
> +               goto fail_return_bufs;
> +       }
> +
> +       if (!node->enabled) {
> +               pr_err("Node (%ld) is not enable\n", node - m2m2->nodes);
> +               r = -EINVAL;
> +               goto fail_return_bufs;
> +       }
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       r = media_entity_pipeline_start(&node->vdev.entity, &m2m2->pipeline);
> +#else
> +       r = media_pipeline_start(&node->vdev.entity, &m2m2->pipeline);
> +#endif
> +       if (r < 0) {
> +               pr_err("Node (%ld) media_pipeline_start failed\n",
> +                      node - m2m2->nodes);
> +               goto fail_return_bufs;
> +       }
> +
> +       if (!mtk_fd_all_nodes_streaming(m2m2, node))
> +               return 0;
> +
> +       /* Start streaming of the whole pipeline now */
> +
> +       r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 1);
> +       if (r < 0) {
> +               pr_err("Node (%ld) v4l2_subdev_call s_stream failed\n",
> +                      node - m2m2->nodes);
> +               goto fail_stop_pipeline;
> +       }
> +       return 0;
> +
> +fail_stop_pipeline:
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       media_entity_pipeline_stop(&node->vdev.entity);
> +#else
> +       media_pipeline_stop(&node->vdev.entity);
> +#endif
> +fail_return_bufs:
> +       mtk_fd_return_all_buffers(m2m2, node, VB2_BUF_STATE_QUEUED);
> +
> +       return r;
> +}
> +
> +static void mtk_fd_vb2_stop_streaming(struct vb2_queue *vq)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> +       struct mtk_fd_dev_video_device *node =
> +               mtk_fd_vbq_to_isp_node(vq);
> +       int r;
> +
> +       WARN_ON(!node->enabled);
> +
> +       /* Was this the first node with streaming disabled? */
> +       if (mtk_fd_all_nodes_streaming(m2m2, node)) {
> +               /* Yes, really stop streaming now */
> +               r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 0);
> +               if (r)
> +                       dev_err(m2m2->dev, "failed to stop streaming\n");
> +       }
> +
> +       mtk_fd_return_all_buffers(m2m2, node, VB2_BUF_STATE_ERROR);
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       media_entity_pipeline_stop(&node->vdev.entity);
> +#else
> +       media_pipeline_stop(&node->vdev.entity);
> +#endif
> +}
> +
> +static int mtk_fd_videoc_querycap(struct file *file, void *fh,
> +                                 struct v4l2_capability *cap)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = video_drvdata(file);
> +       struct mtk_fd_dev_video_device *node = file_to_mtk_fd_node(file);
> +       struct mtk_fd_dev *fd_dev = mtk_fd_m2m_to_dev(m2m2);
> +       int queue_id =
> +               mtk_fd_dev_get_queue_id_of_dev_node(fd_dev, node);
> +       struct mtk_fd_ctx_queue *node_ctx = &fd_dev->ctx.queue[queue_id];
> +
> +       strlcpy(cap->driver, m2m2->name, sizeof(cap->driver));
> +       strlcpy(cap->card, m2m2->model, sizeof(cap->card));
> +       snprintf(cap->bus_info, sizeof(cap->bus_info),
> +                "platform:%s", node->name);
> +
> +       cap->device_caps =
> +               mtk_fd_node_get_v4l2_cap(node_ctx) | V4L2_CAP_STREAMING;
> +       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +       return 0;
> +}
> +
> +/* Propagate forward always the format from the CIO2 subdev */
> +static int mtk_fd_videoc_g_fmt(struct file *file, void *fh,
> +                              struct v4l2_format *f)
> +{
> +       struct mtk_fd_dev_video_device *node = file_to_mtk_fd_node(file);
> +
> +       f->fmt = node->vdev_fmt.fmt;
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_videoc_try_fmt(struct file *file, void *fh,
> +                                struct v4l2_format *f)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = video_drvdata(file);
> +       struct mtk_fd_dev *fd_dev = mtk_fd_m2m_to_dev(m2m2);
> +       struct mtk_fd_ctx *dev_ctx = &fd_dev->ctx;
> +       struct mtk_fd_dev_video_device *node = file_to_mtk_fd_node(file);
> +       int queue_id =
> +               mtk_fd_dev_get_queue_id_of_dev_node(fd_dev, node);
> +       int ret = 0;
> +
> +       ret = mtk_fd_ctx_fmt_set_img(dev_ctx, queue_id, &f->fmt.pix_mp,
> +                                    &node->vdev_fmt.fmt.pix_mp);
> +
> +       /* Simply set the format to the node context in the initial version */
> +       if (ret) {
> +               pr_warn("Fmt(%d) not support for queue(%d), load default fmt\n",
> +                       f->fmt.pix_mp.pixelformat, queue_id);
> +
> +               ret = mtk_fd_ctx_format_load_default_fmt
> +                       (&dev_ctx->queue[queue_id], f);
> +       }
> +
> +       if (!ret) {
> +               node->vdev_fmt.fmt.pix_mp = f->fmt.pix_mp;
> +               dev_ctx->queue[queue_id].fmt.pix_mp = node->vdev_fmt.fmt.pix_mp;
> +       }
> +
> +       return ret;
> +}
> +
> +static int mtk_fd_videoc_s_fmt(struct file *file, void *fh,
> +                              struct v4l2_format *f)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = video_drvdata(file);
> +       struct mtk_fd_dev *fd_dev = mtk_fd_m2m_to_dev(m2m2);
> +       struct mtk_fd_ctx *dev_ctx = &fd_dev->ctx;
> +       struct mtk_fd_dev_video_device *node = file_to_mtk_fd_node(file);
> +       int queue_id = mtk_fd_dev_get_queue_id_of_dev_node(fd_dev, node);
> +       int ret = 0;
> +
> +       ret = mtk_fd_ctx_fmt_set_img(dev_ctx, queue_id, &f->fmt.pix_mp,
> +                                    &node->vdev_fmt.fmt.pix_mp);
> +
> +       /* Simply set the format to the node context in the initial version */
> +       if (!ret)
> +               dev_ctx->queue[queue_id].fmt.pix_mp = node->vdev_fmt.fmt.pix_mp;
> +       else
> +               dev_warn(&fd_dev->pdev->dev, "s_fmt, format not support\n");
> +
> +       return ret;
> +}
> +
> +static int mtk_fd_meta_enum_format(struct file *file, void *fh,
> +                                  struct v4l2_fmtdesc *f)
> +{
> +       struct mtk_fd_dev_video_device *node = file_to_mtk_fd_node(file);
> +
> +       if (f->index > 0 || f->type != node->vbq.type)
> +               return -EINVAL;
> +
> +       f->pixelformat = node->vdev_fmt.fmt.meta.dataformat;
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_videoc_s_meta_fmt(struct file *file, void *fh,
> +                                   struct v4l2_format *f)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = video_drvdata(file);
> +       struct mtk_fd_dev *fd_dev = mtk_fd_m2m_to_dev(m2m2);
> +       struct mtk_fd_ctx *dev_ctx = &fd_dev->ctx;
> +       struct mtk_fd_dev_video_device *node = file_to_mtk_fd_node(file);
> +       int queue_id = mtk_fd_dev_get_queue_id_of_dev_node(fd_dev, node);
> +
> +       int ret = 0;
> +
> +       if (f->type != node->vbq.type)
> +               return -EINVAL;
> +
> +       ret = mtk_fd_ctx_format_load_default_fmt(&dev_ctx->queue[queue_id], f);
> +
> +       if (!ret) {
> +               node->vdev_fmt.fmt.meta = f->fmt.meta;
> +               dev_ctx->queue[queue_id].fmt.meta = node->vdev_fmt.fmt.meta;
> +       } else {
> +               dev_warn(&fd_dev->pdev->dev,
> +                        "s_meta_fm failed, format not support\n");
> +       }
> +
> +       return ret;
> +}
> +
> +static int mtk_fd_videoc_g_meta_fmt(struct file *file, void *fh,
> +                                   struct v4l2_format *f)
> +{
> +       struct mtk_fd_dev_video_device *node = file_to_mtk_fd_node(file);
> +
> +       if (f->type != node->vbq.type)
> +               return -EINVAL;
> +
> +       f->fmt = node->vdev_fmt.fmt;
> +
> +       return 0;
> +}
> +
> +int mtk_fd_videoc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct vb2_buffer *vb;
> +       struct mtk_fd_dev_buffer *db;
> +       int r = 0;
> +
> +       /* check if vb2 queue is busy */
> +       if (vdev->queue->owner && vdev->queue->owner != file->private_data)
> +               return -EBUSY;
> +
> +       /**
> +        * Keep the value of sequence in v4l2_buffer
> +        * in ctx buf since vb2_qbuf will set it to 0
> +        */
> +       vb = vdev->queue->bufs[p->index];
> +
> +       if (vb) {
> +               db = mtk_fd_vb2_buf_to_dev_buf(vb);
> +               pr_info("qbuf: p:%llx,vb:%llx, db:%llx\n",
> +                       (unsigned long long)p,
> +                       (unsigned long long)vb,
> +                       (unsigned long long)db);
> +               db->ctx_buf.user_sequence = p->sequence;
> +       }
> +       r = vb2_qbuf(vdev->queue, vdev->v4l2_dev->mdev, p);
> +       if (r)
> +               pr_err("vb2_qbuf failed(err=%d): buf idx(%d)\n", r, p->index);
> +       return r;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_videoc_qbuf);
> +
> +/******************** function pointers ********************/
> +
> +/* subdev internal operations */
> +static const struct v4l2_subdev_internal_ops mtk_fd_subdev_internal_ops = {
> +       .open = mtk_fd_subdev_open,
> +       .close = mtk_fd_subdev_close,
> +};
> +
> +static const struct v4l2_subdev_core_ops mtk_fd_subdev_core_ops = {
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       .g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
> +       .try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
> +       .s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> +       .g_ctrl = v4l2_subdev_g_ctrl,
> +       .s_ctrl = v4l2_subdev_s_ctrl,
> +       .queryctrl = v4l2_subdev_queryctrl,
> +       .querymenu = v4l2_subdev_querymenu,
> +#endif
> +};
> +
> +static const struct v4l2_subdev_video_ops mtk_fd_subdev_video_ops = {
> +       .s_stream = mtk_fd_subdev_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops mtk_fd_subdev_ops = {
> +       .core = &mtk_fd_subdev_core_ops,
> +       .video = &mtk_fd_subdev_video_ops,
> +};
> +
> +static const struct media_entity_operations mtk_fd_media_ops = {
> +       .link_setup = mtk_fd_link_setup,
> +       .link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static const struct vb2_ops mtk_fd_vb2_ops = {
> +       .buf_queue = mtk_fd_vb2_buf_queue,
> +       .queue_setup = mtk_fd_vb2_queue_setup,
> +       .start_streaming = mtk_fd_vb2_start_streaming,
> +       .stop_streaming = mtk_fd_vb2_stop_streaming,
> +       .wait_prepare = vb2_ops_wait_prepare,
> +       .wait_finish = vb2_ops_wait_finish,
> +};
> +
> +static const struct v4l2_file_operations mtk_fd_v4l2_fops = {
> +       .unlocked_ioctl = video_ioctl2,
> +       .open = v4l2_fh_open,
> +       .release = vb2_fop_release,
> +       .poll = vb2_fop_poll,
> +       .mmap = vb2_fop_mmap,
> +#ifdef CONFIG_COMPAT
> +       .compat_ioctl32 = v4l2_compat_ioctl32,
> +#endif
> +};
> +
> +static const struct v4l2_ioctl_ops mtk_fd_v4l2_ioctl_ops = {
> +       .vidioc_querycap = mtk_fd_videoc_querycap,
> +
> +       .vidioc_g_fmt_vid_cap_mplane = mtk_fd_videoc_g_fmt,
> +       .vidioc_s_fmt_vid_cap_mplane = mtk_fd_videoc_s_fmt,
> +       .vidioc_try_fmt_vid_cap_mplane = mtk_fd_videoc_try_fmt,
> +
> +       .vidioc_g_fmt_vid_out_mplane = mtk_fd_videoc_g_fmt,
> +       .vidioc_s_fmt_vid_out_mplane = mtk_fd_videoc_s_fmt,
> +       .vidioc_try_fmt_vid_out_mplane = mtk_fd_videoc_try_fmt,
> +
> +       /* buffer queue management */
> +       .vidioc_reqbufs = vb2_ioctl_reqbufs,
> +       .vidioc_create_bufs = vb2_ioctl_create_bufs,
> +       .vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +       .vidioc_querybuf = vb2_ioctl_querybuf,
> +       .vidioc_qbuf = mtk_fd_videoc_qbuf,
> +       .vidioc_dqbuf = vb2_ioctl_dqbuf,
> +       .vidioc_streamon = vb2_ioctl_streamon,
> +       .vidioc_streamoff = vb2_ioctl_streamoff,
> +       .vidioc_expbuf = vb2_ioctl_expbuf,
> +};
> +
> +static const struct v4l2_ioctl_ops mtk_fd_v4l2_meta_ioctl_ops = {
> +       .vidioc_querycap = mtk_fd_videoc_querycap,
> +
> +       .vidioc_enum_fmt_meta_cap = mtk_fd_meta_enum_format,
> +       .vidioc_g_fmt_meta_cap = mtk_fd_videoc_g_meta_fmt,
> +       .vidioc_s_fmt_meta_cap = mtk_fd_videoc_s_meta_fmt,
> +       .vidioc_try_fmt_meta_cap = mtk_fd_videoc_g_meta_fmt,
> +
> +       .vidioc_enum_fmt_meta_out = mtk_fd_meta_enum_format,
> +       .vidioc_g_fmt_meta_out = mtk_fd_videoc_g_meta_fmt,
> +       .vidioc_s_fmt_meta_out = mtk_fd_videoc_s_meta_fmt,
> +       .vidioc_try_fmt_meta_out = mtk_fd_videoc_g_meta_fmt,
> +
> +       .vidioc_reqbufs = vb2_ioctl_reqbufs,
> +       .vidioc_create_bufs = vb2_ioctl_create_bufs,
> +       .vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +       .vidioc_querybuf = vb2_ioctl_querybuf,
> +       .vidioc_qbuf = mtk_fd_videoc_qbuf,
> +       .vidioc_dqbuf = vb2_ioctl_dqbuf,
> +       .vidioc_streamon = vb2_ioctl_streamon,
> +       .vidioc_streamoff = vb2_ioctl_streamoff,
> +       .vidioc_expbuf = vb2_ioctl_expbuf,
> +};
> +
> +static u32 mtk_fd_node_get_v4l2_cap(struct mtk_fd_ctx_queue *node_ctx)
> +{
> +       u32 cap = 0;
> +
> +       if (node_ctx->desc.capture)
> +               if (node_ctx->desc.image)
> +                       cap = V4L2_CAP_VIDEO_CAPTURE_MPLANE;
> +               else
> +                       cap = V4L2_CAP_META_CAPTURE;
> +       else
> +               if (node_ctx->desc.image)
> +                       cap = V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> +               else
> +                       cap = V4L2_CAP_META_OUTPUT;
> +
> +       return cap;
> +}
> +
> +static u32 mtk_fd_node_get_format_type(struct mtk_fd_ctx_queue *node_ctx)
> +{
> +       u32 type;
> +
> +       if (node_ctx->desc.capture)
> +               if (node_ctx->desc.image)
> +                       type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +               else
> +                       type = V4L2_BUF_TYPE_META_CAPTURE;
> +       else
> +               if (node_ctx->desc.image)
> +                       type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +               else
> +                       type = V4L2_BUF_TYPE_META_OUTPUT;
> +
> +       return type;
> +}
> +
> +static const struct v4l2_ioctl_ops *mtk_fd_node_get_ioctl_ops
> +       (struct mtk_fd_ctx_queue *node_ctx)
> +{
> +       const struct v4l2_ioctl_ops *ops = NULL;
> +
> +       if (node_ctx->desc.image)
> +               ops = &mtk_fd_v4l2_ioctl_ops;
> +       else
> +               ops = &mtk_fd_v4l2_meta_ioctl_ops;
> +       return ops;
> +}
> +
> +/**
> + * Config node's video properties
> + * according to the device context requirement
> + */
> +static void mtk_fd_node_to_v4l2(struct mtk_fd_dev *fd_dev, u32 node,
> +                               struct video_device *vdev,
> +                               struct v4l2_format *f)
> +{
> +       u32 cap;
> +       struct mtk_fd_ctx *device_ctx = &fd_dev->ctx;
> +       struct mtk_fd_ctx_queue *node_ctx = &device_ctx->queue[node];
> +
> +       WARN_ON(node >= mtk_fd_dev_get_total_node(fd_dev));
> +       WARN_ON(!node_ctx);
> +
> +       /* set cap of the node */
> +       cap = mtk_fd_node_get_v4l2_cap(node_ctx);
> +       f->type = mtk_fd_node_get_format_type(node_ctx);
> +       vdev->ioctl_ops = mtk_fd_node_get_ioctl_ops(node_ctx);
> +
> +       if (mtk_fd_ctx_format_load_default_fmt(&device_ctx->queue[node], f)) {
> +               dev_err(&fd_dev->pdev->dev,
> +                       "Can't load default for node (%d): (%s)",
> +                       node, device_ctx->queue[node].desc.name);
> +       } else {
> +               if (device_ctx->queue[node].desc.image) {
> +                       dev_dbg(&fd_dev->pdev->dev,
> +                               "Node (%d): (%s), dfmt (f:0x%x w:%d: h:%d s:%d)\n",
> +                               node, device_ctx->queue[node].desc.name,
> +                               f->fmt.pix_mp.pixelformat,
> +                               f->fmt.pix_mp.width,
> +                               f->fmt.pix_mp.height,
> +                               f->fmt.pix_mp.plane_fmt[0].sizeimage);
> +                       node_ctx->fmt.pix_mp = f->fmt.pix_mp;
> +               } else {
> +                       dev_info(&fd_dev->pdev->dev,
> +                                "Node (%d): (%s), dfmt (f:0x%x s:%u)\n",
> +                                node, device_ctx->queue[node].desc.name,
> +                                f->fmt.meta.dataformat,
> +                                f->fmt.meta.buffersize);
> +                       node_ctx->fmt.meta = f->fmt.meta;
> +               }
> +       }
> +
> +#if KERNEL_VERSION(4, 7, 0) < MTK_FD_KERNEL_BASE_VERSION
> +       /* device_caps was supported after 4.7 */
> +       vdev->device_caps = V4L2_CAP_STREAMING | cap;
> +#endif
> +}
> +
> +int mtk_fd_media_register(struct device *dev, struct media_device *media_dev,
> +                         const char *model)
> +{
> +       int r = 0;
> +
> +       media_dev->dev = dev;
> +       dev_info(dev, "setup media_dev.dev: %llx\n",
> +                (unsigned long long)media_dev->dev);
> +
> +       strlcpy(media_dev->model, model, sizeof(media_dev->model));
> +       dev_info(dev, "setup media_dev.model: %s\n",
> +                media_dev->model);
> +
> +       snprintf(media_dev->bus_info, sizeof(media_dev->bus_info),
> +                "%s", dev_name(dev));
> +       dev_info(dev, "setup media_dev.bus_info: %s\n",
> +                media_dev->bus_info);
> +
> +       media_dev->hw_revision = 0;
> +       dev_info(dev, "setup media_dev.hw_revision: %d\n",
> +                media_dev->hw_revision);
> +
> +#if KERNEL_VERSION(4, 5, 0) <= MTK_FD_KERNEL_BASE_VERSION
> +       dev_info(dev, "media_device_init: media_dev:%llx\n",
> +                (unsigned long long)media_dev);
> +       media_device_init(media_dev);
> +#endif
> +
> +       pr_info("Register media device: %s, %llx",
> +               media_dev->model,
> +               (unsigned long long)media_dev);
> +
> +       r = media_device_register(media_dev);
> +
> +       if (r) {
> +               dev_err(dev, "failed to register media device (%d)\n", r);
> +               goto fail_v4l2_dev;
> +       }
> +       return 0;
> +
> +fail_v4l2_dev:
> +       media_device_unregister(media_dev);
> +#if KERNEL_VERSION(4, 5, 0) <= MTK_FD_KERNEL_BASE_VERSION
> +       media_device_cleanup(media_dev);
> +#endif
> +
> +       return r;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_media_register);
> +
> +int mtk_fd_v4l2_register(struct device *dev,
> +                        struct media_device *media_dev,
> +                        struct v4l2_device *v4l2_dev)
> +{
> +       int r = 0;
> +       /* Set up v4l2 device */
> +       v4l2_dev->mdev = media_dev;
> +       dev_info(dev, "setup v4l2_dev->mdev: %llx",
> +                (unsigned long long)v4l2_dev->mdev);
> +
> +       dev_info(dev, "Register v4l2 device: %llx",
> +                (unsigned long long)v4l2_dev);
> +
> +       r = v4l2_device_register(dev, v4l2_dev);
> +
> +       if (r) {
> +               dev_err(dev, "failed to register V4L2 device (%d)\n", r);
> +               goto fail_v4l2_dev;
> +       }
> +
> +       return 0;
> +
> +fail_v4l2_dev:
> +       media_device_unregister(media_dev);
> +#if KERNEL_VERSION(4, 5, 0) <= MTK_FD_KERNEL_BASE_VERSION
> +       media_device_cleanup(media_dev);
> +#endif
> +
> +       return r;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_v4l2_register);
> +
> +int mtk_fd_mem2mem2_v4l2_register(struct mtk_fd_dev *dev,
> +                                 struct media_device *media_dev,
> +                                 struct v4l2_device *v4l2_dev)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = &dev->mem2mem2;
> +
> +       int i, r;
> +
> +       /**
> +        * If media_dev or v4l2_dev is not set,
> +        * use the default one in mtk_fd_dev
> +        */
> +       if (!media_dev) {
> +               m2m2->media_dev = &dev->media_dev;
> +               r = mtk_fd_media_register(&dev->pdev->dev, m2m2->media_dev,
> +                                         m2m2->model);
> +
> +       if (r) {
> +               dev_err(m2m2->dev, "failed to register media device (%d)\n", r);
> +               goto fail_media_dev;
> +       }
> +       } else {
> +               m2m2->media_dev = media_dev;
> +       }
> +
> +       if (!v4l2_dev) {
> +               m2m2->v4l2_dev = &dev->v4l2_dev;
> +               r = mtk_fd_v4l2_register(&dev->pdev->dev,
> +                                        m2m2->media_dev,
> +                                        m2m2->v4l2_dev);
> +       if (r) {
> +               dev_err(m2m2->dev, "failed to register V4L2 device (%d)\n", r);
> +               goto fail_v4l2_dev;
> +       }
> +       } else {
> +               m2m2->v4l2_dev = v4l2_dev;
> +       }
> +
> +       /* Initialize miscellaneous variables */
> +       m2m2->streaming = false;
> +       m2m2->v4l2_file_ops = mtk_fd_v4l2_fops;
> +
> +       /* Initialize subdev media entity */
> +       m2m2->subdev_pads = kcalloc(m2m2->num_nodes, sizeof(*m2m2->subdev_pads),
> +                                   GFP_KERNEL);
> +       if (!m2m2->subdev_pads) {
> +               r = -ENOMEM;
> +               goto fail_subdev_pads;
> +       }
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +       r = media_entity_init(&m2m2->subdev.entity, m2m2->num_nodes,
> +                             m2m2->subdev_pads, 0);
> +#else
> +       r = media_entity_pads_init(&m2m2->subdev.entity, m2m2->num_nodes,
> +                                  m2m2->subdev_pads);
> +#endif
> +       if (r) {
> +               dev_err(m2m2->dev,
> +                       "failed initialize subdev media entity (%d)\n", r);
> +               goto fail_media_entity;
> +       }
> +
> +       /* Initialize subdev */
> +       v4l2_subdev_init(&m2m2->subdev, &mtk_fd_subdev_ops);
> +
> +       m2m2->subdev.entity.function =
> +               MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> +
> +       m2m2->subdev.entity.ops = &mtk_fd_media_ops;
> +
> +       for (i = 0; i < m2m2->num_nodes; i++) {
> +               m2m2->subdev_pads[i].flags = m2m2->nodes[i].output ?
> +                       MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> +       }
> +
> +       m2m2->subdev.flags =
> +               V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +       snprintf(m2m2->subdev.name, sizeof(m2m2->subdev.name),
> +                "%s", m2m2->name);
> +       v4l2_set_subdevdata(&m2m2->subdev, m2m2);
> +       m2m2->subdev.internal_ops = &mtk_fd_subdev_internal_ops;
> +
> +       pr_info("register subdev: %s\n", m2m2->subdev.name);
> +       r = v4l2_device_register_subdev(m2m2->v4l2_dev, &m2m2->subdev);
> +       if (r) {
> +               dev_err(m2m2->dev, "failed initialize subdev (%d)\n", r);
> +               goto fail_subdev;
> +       }
> +       r = v4l2_device_register_subdev_nodes(m2m2->v4l2_dev);
> +       if (r) {
> +               dev_err(m2m2->dev, "failed to register subdevs (%d)\n", r);
> +               goto fail_subdevs;
> +       }
> +
> +       /* Create video nodes and links */
> +       for (i = 0; i < m2m2->num_nodes; i++) {
> +               struct mtk_fd_dev_video_device *node = &m2m2->nodes[i];
> +               struct video_device *vdev = &node->vdev;
> +               struct vb2_queue *vbq = &node->vbq;
> +               u32 flags;
> +
> +               /* Initialize miscellaneous variables */
> +               mutex_init(&node->lock);
> +               INIT_LIST_HEAD(&node->buffers);
> +
> +               /* Initialize formats to default values */
> +               mtk_fd_node_to_v4l2(dev, i, vdev, &node->vdev_fmt);
> +
> +               /* Initialize media entities */
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +               r = media_entity_init(&vdev->entity, 1, &node->vdev_pad, 0);
> +#else
> +               r = media_entity_pads_init(&vdev->entity, 1, &node->vdev_pad);
> +#endif
> +               if (r) {
> +                       dev_err(m2m2->dev,
> +                               "failed initialize media entity (%d)\n", r);
> +                       goto fail_vdev_media_entity;
> +               }
> +               node->vdev_pad.flags = node->output ?
> +                       MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
> +               vdev->entity.ops = NULL;
> +
> +               /* Initialize vbq */
> +               vbq->type = node->vdev_fmt.type;
> +               vbq->io_modes = VB2_MMAP | VB2_DMABUF;
> +               vbq->ops = &mtk_fd_vb2_ops;
> +               vbq->mem_ops = m2m2->vb2_mem_ops;
> +               m2m2->buf_struct_size = sizeof(struct mtk_fd_dev_buffer);
> +               vbq->buf_struct_size = m2m2->buf_struct_size;
> +               vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +               vbq->min_buffers_needed = 0;    /* Can streamon w/o buffers */
> +               /* Put the process hub sub device in the vb2 private data*/
> +               vbq->drv_priv = m2m2;
> +               vbq->lock = &node->lock;
> +               r = vb2_queue_init(vbq);
> +               if (r) {
> +                       dev_err(m2m2->dev,
> +                               "failed to initialize video queue (%d)\n", r);
> +                       goto fail_vdev;
> +               }
> +
> +               /* Initialize vdev */
> +               snprintf(vdev->name, sizeof(vdev->name), "%s %s",
> +                        m2m2->name, node->name);
> +               vdev->release = video_device_release_empty;
> +               vdev->fops = &m2m2->v4l2_file_ops;
> +               vdev->lock = &node->lock;
> +               vdev->v4l2_dev = m2m2->v4l2_dev;
> +               vdev->queue = &node->vbq;
> +               vdev->vfl_dir = node->output ? VFL_DIR_TX : VFL_DIR_RX;
> +               video_set_drvdata(vdev, m2m2);
> +               pr_info("register vdev: %s\n", vdev->name);
> +               r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +               if (r) {
> +                       dev_err(m2m2->dev,
> +                               "failed to register video device (%d)\n", r);
> +                       goto fail_vdev;
> +               }
> +
> +               /* Create link between video node and the subdev pad */
> +               flags = 0;
> +               if (node->enabled)
> +                       flags |= MEDIA_LNK_FL_ENABLED;
> +               if (node->immutable)
> +                       flags |= MEDIA_LNK_FL_IMMUTABLE;
> +               if (node->output) {
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +                       r = media_entity_create_link
> +#else
> +                       r = media_create_pad_link
> +#endif
> +                                               (&vdev->entity, 0,
> +                                                &m2m2->subdev.entity,
> +                                                i, flags);
> +               } else {
> +#if KERNEL_VERSION(4, 5, 0) >= MTK_FD_KERNEL_BASE_VERSION
> +                       r = media_entity_create_link
> +#else
> +                       r = media_create_pad_link
> +#endif
> +                                               (&m2m2->subdev.entity,
> +                                                i, &vdev->entity, 0,
> +                                                flags);
> +               }
> +               if (r)
> +                       goto fail_link;
> +       }
> +
> +       return 0;
> +
> +       for (; i >= 0; i--) {
> +fail_link:
> +               video_unregister_device(&m2m2->nodes[i].vdev);
> +fail_vdev:
> +               media_entity_cleanup(&m2m2->nodes[i].vdev.entity);
> +fail_vdev_media_entity:
> +               mutex_destroy(&m2m2->nodes[i].lock);
> +       }
> +fail_subdevs:
> +       v4l2_device_unregister_subdev(&m2m2->subdev);
> +fail_subdev:
> +       media_entity_cleanup(&m2m2->subdev.entity);
> +fail_media_entity:
> +       kfree(m2m2->subdev_pads);
> +fail_subdev_pads:
> +       v4l2_device_unregister(m2m2->v4l2_dev);
> +fail_v4l2_dev:
> +fail_media_dev:
> +       pr_err("fail_v4l2_dev: media_device_unregister and clenaup:%llx",
> +              (unsigned long long)m2m2->media_dev);
> +       media_device_unregister(m2m2->media_dev);
> +#if KERNEL_VERSION(4, 5, 0) <= MTK_FD_KERNEL_BASE_VERSION
> +       media_device_cleanup(m2m2->media_dev);
> +#endif
> +
> +       return r;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_mem2mem2_v4l2_register);
> +
> +int mtk_fd_v4l2_unregister(struct mtk_fd_dev *dev)
> +{
> +       struct mtk_fd_mem2mem2_device *m2m2 = &dev->mem2mem2;
> +       unsigned int i;
> +
> +       for (i = 0; i < m2m2->num_nodes; i++) {
> +               video_unregister_device(&m2m2->nodes[i].vdev);
> +               media_entity_cleanup(&m2m2->nodes[i].vdev.entity);
> +               mutex_destroy(&m2m2->nodes[i].lock);
> +       }
> +
> +       v4l2_device_unregister_subdev(&m2m2->subdev);
> +       media_entity_cleanup(&m2m2->subdev.entity);
> +       kfree(m2m2->subdev_pads);
> +       v4l2_device_unregister(m2m2->v4l2_dev);
> +       media_device_unregister(m2m2->media_dev);
> +#if KERNEL_VERSION(4, 5, 0) <= MTK_FD_KERNEL_BASE_VERSION
> +       media_device_cleanup(m2m2->media_dev);
> +#endif
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_v4l2_unregister);
> +
> +void mtk_fd_v4l2_buffer_done(struct vb2_buffer *vb,
> +                            enum vb2_buffer_state state)
> +{
> +       struct mtk_fd_mem2mem2_buffer *b =
> +               container_of(vb, struct mtk_fd_mem2mem2_buffer, vbb.vb2_buf);
> +
> +       list_del(&b->list);
> +       vb2_buffer_done(&b->vbb.vb2_buf, state);
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_v4l2_buffer_done);
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c b/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c
> new file mode 100644
> index 0000000..bd447b7
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2018 MediaTek Inc.
> + * Author: Frederic Chen <frederic.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include "mtk_fd.h"
> +#include "mtk_fd-ctx.h"
> +#include "mtk_fd-v4l2.h"
> +
> +static struct mtk_fd_ctx_format fd_param_fmts[] = {
> +       {
> +               .fmt.meta = {
> +               .dataformat = V4L2_META_FMT_MTISP_PARAMS,
> +               .max_buffer_size = 1024 * 30,
> +               },
> +       },
> +};
> +
> +static struct mtk_fd_ctx_format in_fmts[] = {
> +       {
> +               .fmt.img = {
> +                       .pixelformat  = V4L2_PIX_FMT_VYUY,
> +                       .depth    = { 16 },
> +                       .row_depth  = { 16 },
> +                       .num_planes = 1,
> +               },
> +       },
> +       {
> +               .fmt.img = {
> +                       .pixelformat  = V4L2_PIX_FMT_YUYV,
> +                       .depth    = { 16 },
> +                       .row_depth  = { 16 },
> +                       .num_planes = 1,
> +               },
> +       },
> +       {
> +               .fmt.img = {
> +                       .pixelformat  = V4L2_PIX_FMT_YVYU,
> +                       .depth    = { 16 },
> +                       .row_depth  = { 16 },
> +                       .num_planes = 1,
> +               },
> +       },
> +       {
> +               .fmt.img = {
> +                       .pixelformat  = V4L2_PIX_FMT_UYVY,
> +                       .depth    = { 16 },
> +                       .row_depth  = { 16 },
> +                       .num_planes = 1,
> +               },
> +       },
> +};
> +
> +static struct mtk_fd_ctx_queue_desc
> +output_queues[MTK_FD_CTX_FD_TOTAL_OUTPUT] = {
> +       {
> +               .id = MTK_FD_CTX_FD_YUV_IN,
> +               .name = "FDInput",
> +               .capture = 0,
> +               .image = 1,
> +               .fmts = in_fmts,
> +               .num_fmts = ARRAY_SIZE(in_fmts),
> +               .default_fmt_idx = 1,
> +       },
> +       {
> +               .id = MTK_FD_CTX_FD_CONFIG_IN,
> +               .name = "FDConfig",
> +               .capture = 0,
> +               .image = 0,
> +               .fmts = fd_param_fmts,
> +               .num_fmts = 1,
> +               .default_fmt_idx = 0,
> +       },
> +};
> +
> +static struct mtk_fd_ctx_queue_desc
> +capture_queues[MTK_FD_CTX_FD_TOTAL_CAPTURE] = {
> +       {
> +               .id = MTK_FD_CTX_FD_OUT,
> +               .name = "FDOutput",
> +               .capture = 1,
> +               .image = 0,
> +               .fmts = fd_param_fmts,
> +               .num_fmts = 1,
> +               .default_fmt_idx = 0,
> +       },
> +};
> +
> +static struct mtk_fd_ctx_queues_setting queues_setting = {
> +       .master = MTK_FD_CTX_FD_OUT,
> +       .output_queue_descs = output_queues,
> +       .total_output_queues = MTK_FD_CTX_FD_TOTAL_OUTPUT,
> +       .capture_queue_descs = capture_queues,
> +       .total_capture_queues = MTK_FD_CTX_FD_TOTAL_CAPTURE,
> +};
> +
> +int mtk_fd_ctx_fd_init(struct mtk_fd_ctx *ctx)
> +{
> +       /* Initialize main data structure */
> +       return mtk_fd_ctx_core_queue_setup(ctx, &queues_setting);
> +}
> +EXPORT_SYMBOL_GPL(mtk_fd_ctx_fd_init);
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h b/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h
> new file mode 100644
> index 0000000..0702abc
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2018 MediaTek Inc.
> + * Author: Frederic Chen <frederic.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MTK_FD_V4L2__
> +#define __MTK_FD_V4L2__
> +
> +#include <linux/types.h>
> +#include "mtk_fd-ctx.h"
> +
> +#define MTK_FD_DEV_NAME     "MTK-FD-V4L2"
> +
> +/* Input: YUV image */
> +#define MTK_FD_CTX_FD_YUV_IN           0
> +/* Input: FD Configuration */
> +#define MTK_FD_CTX_FD_CONFIG_IN                1
> +#define MTK_FD_CTX_FD_TOTAL_OUTPUT     2
> +
> +/* OUT: FD output devices*/
> +#define MTK_FD_CTX_FD_OUT              2
> +#define MTK_FD_CTX_FD_TOTAL_CAPTURE    1
> +
> +int mtk_fd_ctx_fd_init(struct mtk_fd_ctx *ctx);
> +
> +#endif /*__MTK_FD_V4L2__*/
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd.c b/drivers/media/platform/mtk-isp/fd/mtk_fd.c
> new file mode 100644
> index 0000000..7e2fd00
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd.c
> @@ -0,0 +1,730 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2015 MediaTek Inc.
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/kdev_t.h>
> +
> +#include <linux/platform_device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/mm_types.h>
> +#include <linux/mm.h>
> +#include <linux/jiffies.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <asm/page.h>
> +#include <linux/vmalloc.h>
> +#include <linux/interrupt.h>
> +#include <linux/wait.h>
> +
> +#include <linux/of_platform.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +
> +#include "mtk_fd.h"
> +#include "mtk_fd-core.h"
> +
> +#include "mtk_vpu.h"
> +
> +#include <linux/pm_runtime.h>
> +#include <linux/clk.h>
> +
> +#ifdef CONFIG_PM_WAKELOCKS
> +#include <linux/pm_wakeup.h>
> +#else
> +#include <linux/wakelock.h>
> +#endif
> +
> +#define FD_DRVNAME     "mtk-fd"
> +
> +static const struct of_device_id mtk_fd_of_ids[] = {
> +       /* Remider: Add this device node manually in .dtsi */
> +       { .compatible = "mediatek,fd", },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, mtk_fd_of_ids);
> +
> +static void mtk_fd_prepare_enable_ccf_clock(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       int ret;
> +
> +       pm_runtime_get_sync(fd_hw_dev->larb_dev);
> +       ret = clk_prepare_enable(fd_hw_dev->fd_clk);
> +       if (ret)
> +               dev_err(&fd_hw_dev->pdev->dev,
> +                       "cannot prepare and enable CG_IMGSYS_FD clock\n");
> +}
> +
> +static void mtk_fd_disable_unprepare_ccf_clock(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       clk_disable_unprepare(fd_hw_dev->fd_clk);
> +}
> +
> +static int mtk_fd_clk_ctrl(struct mtk_fd_drv_dev *fd_hw_dev, int en)
> +{
> +       if (en)
> +               mtk_fd_prepare_enable_ccf_clock(fd_hw_dev);
> +       else
> +               mtk_fd_disable_unprepare_ccf_clock(fd_hw_dev);
> +
> +       dev_dbg(&fd_hw_dev->pdev->dev, "clock en: %d\n", en);
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_wait_irq(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       int timeout;
> +
> +       timeout = wait_event_interruptible_timeout
> +               (fd_hw_dev->wq,
> +                (fd_hw_dev->fd_irq_result & FD_IRQ_MASK),
> +                mtk_fd_us_to_jiffies(1 * 1000000));
> +
> +       if (timeout == 0) {
> +               dev_err(&fd_hw_dev->pdev->dev,
> +                       "%s timeout, %d\n",
> +                       __func__, fd_hw_dev->fd_irq_result);
> +               return -EAGAIN;
> +       }
> +
> +       dev_dbg(&fd_hw_dev->pdev->dev, "irq_res: 0x%8x\n",
> +               fd_hw_dev->fd_irq_result);
> +
> +       if (timeout != 0 && !(fd_hw_dev->fd_irq_result & FD_IRQ_MASK)) {
> +               dev_err(&fd_hw_dev->pdev->dev,
> +                       "%s interrupted by system signal, return value(%d)\n",
> +                       __func__, timeout);
> +               return -ERESTARTSYS;
> +       }
> +
> +       if (!(fd_hw_dev->fd_irq_result & FD_IRQ_MASK)) {
> +               dev_err(&fd_hw_dev->pdev->dev,
> +                       "%s Not FD, %d\n",
> +                       __func__, fd_hw_dev->fd_irq_result);
> +               return -1;
> +       }
> +
> +       fd_hw_dev->fd_irq_result = 0;
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_send_ipi_init(struct platform_device *pdev,
> +                               struct fd_buffer *scp_mem)
> +{
> +       struct ipi_message fd_init_msg;
> +
> +       fd_init_msg.cmd_id = FD_CMD_INIT;
> +       fd_init_msg.fd_manager = *scp_mem;
> +
> +       vpu_ipi_send(pdev, IPI_FD_CMD, &fd_init_msg, sizeof(fd_init_msg));
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_send_ipi_cmd(struct platform_device *pdev,
> +                              struct v4l2_fd_param *fd_param)
> +{
> +       struct ipi_message fd_ipi_msg;
> +
> +       fd_ipi_msg.cmd_id = FD_CMD_ENQ;
> +       fd_ipi_msg.fd_param = *fd_param;
> +
> +       vpu_ipi_send_sync_async(pdev, IPI_FD_CMD, &fd_ipi_msg,
> +                               sizeof(fd_ipi_msg), 0);
> +       return 0;
> +}
> +
> +static irqreturn_t mtk_fd_irq(int irq, void *dev_addr)
> +{
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +
> +       fd_hw_dev = (struct mtk_fd_drv_dev *)dev_addr;
> +       fd_hw_dev->fd_irq_result = FD_RD32(fd_hw_dev->fd_base + FD_INT);
> +       wake_up_interruptible(&fd_hw_dev->wq);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int mtk_fd_do_callback(struct mtk_fd_drv_dev *fd_hw_dev,
> +                             unsigned int frame_state)
> +{
> +       struct mtk_fd_ctx_finish_param fparam;
> +       struct mtk_isp_fd_drv_data *drv_data;
> +       struct device *dev;
> +       int ret = 0;
> +
> +       drv_data = mtk_fd_hw_dev_to_drv(fd_hw_dev);
> +       dev = &drv_data->fd_hw_dev.pdev->dev;
> +
> +       fparam.state = frame_state;
> +       fparam.frame_id = fd_hw_dev->fd_ctx.frame_id;
> +       dev_dbg(dev, "frame_id(%d)\n", fparam.frame_id);
> +
> +       ret = mtk_fd_ctx_core_job_finish(&drv_data->fd_dev.ctx, &fparam);
> +       if (ret)
> +               dev_err(dev, "frame_id(%d), finish op failed: %d\n",
> +                       fparam.frame_id, ret);
> +       else
> +               fd_hw_dev->state = FD_CBD;
> +
> +       return ret;
> +}
> +
> +static int mtk_fd_dequeue(struct mtk_fd_drv_dev *fd_hw_dev,
> +                         struct v4l2_fd_param *fd_param)
> +{
> +       struct mtk_isp_fd_drv_data *drv_data;
> +       struct fd_user_output *fd_output;
> +       u32 num = 0, i = 0;
> +
> +       dev_dbg(&fd_hw_dev->pdev->dev, "-E. %s.\n", __func__);
> +
> +       if ((uint64_t)fd_hw_dev->fd_base < VA_OFFSET) {
> +               dev_info(&fd_hw_dev->pdev->dev,
> +                        "-X. %s. fd_base_error: %p\n",
> +                        __func__, fd_hw_dev->fd_base);
> +               return -1;
> +       }
> +
> +       num = FD_RD32(fd_hw_dev->fd_base + FD_RESULT);
> +       FD_WR32(0x0, fd_hw_dev->fd_base + FD_INT_EN);
> +       fd_output = (struct fd_user_output *)fd_param->fd_user_result.va;
> +       fd_output->face_number = num;
> +
> +       drv_data = mtk_fd_hw_dev_to_drv(fd_hw_dev);
> +       if ((uint64_t)drv_data < VA_OFFSET) {
> +               dev_dbg(&fd_hw_dev->pdev->dev,
> +                       "-X. %s. fd_base_error\n", __func__);
> +               return -1;
> +       }
> +       mtk_fd_do_callback(fd_hw_dev, MTK_FD_CTX_FRAME_DATA_DONE);
> +
> +       for (i = 0; i < num; i++) {
> +               dev_dbg(&fd_hw_dev->pdev->dev,
> +                       "id:%d, typ:%d, x0:%d, y0:%d, x1:%d, y1:%d, fcv:0x%x\n",
> +                       fd_output->face[i].face_idx,
> +                       fd_output->face[i].type,
> +                       fd_output->face[i].x0,
> +                       fd_output->face[i].y0,
> +                       fd_output->face[i].x1,
> +                       fd_output->face[i].y1,
> +                       fd_output->face[i].fcv);
> +       }
> +       dev_dbg(&fd_hw_dev->pdev->dev, "-X. %s.\n", __func__);
> +       return 0;
> +}
> +
> +static int mtk_fd_manager_buf_init(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       struct fd_manager_ctx *manager_ctx;
> +
> +       manager_ctx = (struct fd_manager_ctx *)fd_hw_dev->fd_ctx.scp_mem.va;
> +       manager_ctx->rs_result = fd_hw_dev->fd_ctx.rs_result;
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_alloc_rs_buf(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       u64 va = 0;
> +       dma_addr_t dma_handle = 0;
> +       u32 size = RS_BUF_SIZE_MAX;
> +
> +       va = (uint64_t)dma_alloc_coherent(&fd_hw_dev->pdev->dev, size,
> +       &dma_handle, GFP_KERNEL);
> +
> +       dev_dbg(&fd_hw_dev->pdev->dev, "rsbuffer size: %u\n", size);
> +       dev_dbg(&fd_hw_dev->pdev->dev, "va = 0x%llx, iova = 0x%x\n", va,
> +               dma_handle);
> +
> +       if (va == 0) {
> +               dev_err(&fd_hw_dev->pdev->dev, "dma_alloc null va!\n");
> +               return -1;
> +       }
> +
> +       memset((uint8_t *)va, 0, size);
> +
> +       fd_hw_dev->fd_ctx.rs_result.va = va;
> +       fd_hw_dev->fd_ctx.rs_result.iova = dma_handle;
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_get_reserve_mem(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       phys_addr_t scp_mem_pa;
> +       u64 scp_mem_va;
> +       u32 scp_mem_iova;
> +       u32 size = 0, size_align = 0;
> +       struct sg_table *sgt;
> +       int n_pages = 0, i = 0, ret = 0;
> +       struct page **pages = NULL;
> +       struct mtk_fd_drv_ctx *fd_ctx;
> +       struct platform_device *pdev = fd_hw_dev->pdev;
> +
> +       fd_ctx = &fd_hw_dev->fd_ctx;
> +
> +       scp_mem_iova = 0;
> +       scp_mem_va = vpu_get_reserve_mem_virt(FD_MEM_ID);
> +       scp_mem_pa = vpu_get_reserve_mem_phys(FD_MEM_ID);
> +       size = (u32)vpu_get_reserve_mem_size(FD_MEM_ID);
> +
> +       dev_dbg(&pdev->dev, "fd_scp_mem va: 0x%llx, pa: 0x%llx, sz:0x%x\n",
> +               scp_mem_va, (u64)scp_mem_pa, size);
> +
> +       if (scp_mem_va != 0 && size > 0)
> +               memset((void *)scp_mem_va, 0, size);
> +
> +       /* get iova */
> +       sgt = &fd_ctx->sgtable;
> +       sg_alloc_table(sgt, 1, GFP_KERNEL);
> +
> +       size_align = round_up(size, PAGE_SIZE);
> +       n_pages = size_align >> PAGE_SHIFT;
> +
> +       pages = kmalloc_array(n_pages, sizeof(struct page *), GFP_KERNEL);
> +
> +       for (i = 0; i < n_pages; i++)
> +               pages[i] = phys_to_page(scp_mem_pa + i * PAGE_SIZE);
> +       ret = sg_alloc_table_from_pages(sgt, pages, n_pages,
> +                                       0, size_align, GFP_KERNEL);
> +
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to get allocate sg table\n");
> +               kfree(pages);
> +               return ret;
> +       }
> +
> +       dma_map_sg_attrs(&pdev->dev, sgt->sgl, sgt->nents,
> +                        DMA_BIDIRECTIONAL, DMA_ATTR_SKIP_CPU_SYNC);
> +       scp_mem_iova = sg_dma_address(sgt->sgl);
> +       kfree(pages);
> +
> +       dev_dbg(&fd_hw_dev->pdev->dev, "scpmem size:%u,0x%X\n", size, size);
> +       dev_dbg(&fd_hw_dev->pdev->dev, "pa:0x%08X\n", (u32)scp_mem_pa);
> +       dev_dbg(&fd_hw_dev->pdev->dev, "va:0x%16llX\n", (u64)scp_mem_va);
> +       dev_dbg(&fd_hw_dev->pdev->dev, "iova:0x%08X\n", (u32)scp_mem_iova);
> +
> +       fd_ctx->scp_mem.pa = scp_mem_pa;
> +       fd_ctx->scp_mem.va = scp_mem_va;
> +       fd_ctx->scp_mem.iova = scp_mem_iova;
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_load_vpu(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       struct mtk_fd_drv_ctx *fd_ctx;
> +       int ret = 0;
> +
> +       fd_ctx = &fd_hw_dev->fd_ctx;
> +
> +       /* init vpu */
> +       fd_ctx->vpu_pdev = vpu_get_plat_device(fd_hw_dev->pdev);
> +
> +       if (!fd_ctx->vpu_pdev) {
> +               dev_err(&fd_hw_dev->pdev->dev,
> +                       "Failed to get VPU device\n");
> +               return -EINVAL;
> +       }
> +
> +       ret = vpu_load_firmware(fd_ctx->vpu_pdev);
> +       if (ret < 0) {
> +               /**
> +                * Return 0 if downloading firmware successfully,
> +                * otherwise it is failed
> +                */
> +               dev_err(&fd_hw_dev->pdev->dev,
> +                       "vpu_load_firmware failed!");
> +               return -EINVAL;
> +       }
> +       return ret;
> +}
> +
> +static int mtk_fd_open_context(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       struct mtk_fd_drv_ctx *fd_ctx;
> +
> +       fd_ctx = &fd_hw_dev->fd_ctx;
> +
> +       mtk_fd_load_vpu(fd_hw_dev);
> +
> +       mtk_fd_get_reserve_mem(fd_hw_dev);
> +       mtk_fd_alloc_rs_buf(fd_hw_dev);
> +       mtk_fd_manager_buf_init(fd_hw_dev);
> +
> +       mtk_fd_send_ipi_init(fd_ctx->vpu_pdev, &fd_ctx->scp_mem);
> +       return 0;
> +}
> +
> +static int mtk_fd_release_context(struct mtk_fd_drv_dev *fd_hw_dev)
> +{
> +       struct mtk_fd_drv_ctx *fd_ctx;
> +
> +       fd_ctx = &fd_hw_dev->fd_ctx;
> +
> +       atomic_set(&fd_ctx->fd_user_cnt, 0);
> +       atomic_set(&fd_ctx->fd_stream_cnt, 0);
> +       atomic_set(&fd_ctx->fd_enque_cnt, 0);
> +       sg_free_table(&fd_ctx->sgtable);
> +
> +       return 0;
> +}
> +
> +int mtk_fd_open(struct platform_device *pdev)
> +{
> +       int ret = 0;
> +       s32 usercount;
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +       struct mtk_isp_fd_drv_data *fd_drv;
> +       struct mtk_fd_drv_ctx *fd_ctx;
> +
> +       dev_dbg(&pdev->dev, "- E. %s.\n", __func__);
> +
> +       if (!pdev) {
> +               dev_err(&fd_hw_dev->pdev->dev, "platform device is NULL\n");
> +               return -EINVAL;
> +       }
> +
> +       fd_drv = dev_get_drvdata(&pdev->dev);
> +       fd_hw_dev = &fd_drv->fd_hw_dev;
> +       fd_ctx = &fd_hw_dev->fd_ctx;
> +       dev_dbg(&fd_hw_dev->pdev->dev, "open fd_hw_dev = 0x%p\n", fd_hw_dev);
> +       dev_dbg(&fd_hw_dev->pdev->dev, "open fd_drv = 0x%p\n", fd_drv);
> +
> +       usercount = atomic_inc_return(&fd_hw_dev->fd_ctx.fd_user_cnt);
> +
> +       if (usercount == 1) {
> +               /* Enable clock */
> +               pm_runtime_get_sync(&fd_hw_dev->pdev->dev);
> +
> +               mtk_fd_open_context(fd_hw_dev);
> +               fd_hw_dev->state = FD_INI;
> +               fd_hw_dev->streaming = STREAM_OFF;
> +       }
> +
> +       dev_dbg(&fd_hw_dev->pdev->dev, "usercount = %d",
> +               atomic_read(&fd_ctx->fd_user_cnt));
> +
> +       dev_dbg(&fd_hw_dev->pdev->dev, "X. %s\n", __func__);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(mtk_fd_open);
> +
> +int mtk_fd_streamon(struct platform_device *pdev, u16 id)
> +{
> +       int ret = 0;
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +       struct mtk_isp_fd_drv_data *fd_drv;
> +
> +       fd_drv = dev_get_drvdata(&pdev->dev);
> +       fd_hw_dev = &fd_drv->fd_hw_dev;
> +
> +       dev_dbg(&pdev->dev, "- E. %s\n", __func__);
> +       fd_hw_dev->streaming = STREAM_ON;
> +       atomic_inc_return(&fd_hw_dev->fd_ctx.fd_stream_cnt);
> +
> +       dev_dbg(&pdev->dev, "- X. %s\n", __func__);
> +       return ret;
> +}
> +EXPORT_SYMBOL(mtk_fd_streamon);
> +
> +int mtk_fd_enqueue(struct platform_device *pdev,
> +                  struct v4l2_fd_param *fd_param)
> +{
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +       struct mtk_fd_drv_ctx *fd_ctx;
> +       struct mtk_isp_fd_drv_data *fd_drv;
> +
> +       dev_dbg(&pdev->dev, "- E. %s\n", __func__);
> +       fd_drv = dev_get_drvdata(&pdev->dev);
> +       fd_hw_dev = &fd_drv->fd_hw_dev;
> +       fd_ctx = &fd_hw_dev->fd_ctx;
> +
> +       fd_ctx->frame_id = fd_param->frame_id;
> +
> +       if (fd_hw_dev->streaming == STREAM_OFF || fd_hw_dev->state == FD_ENQ) {
> +               dev_err(&fd_hw_dev->pdev->dev, "enqueue before stream on!\n");
> +               return mtk_fd_do_callback(fd_hw_dev,
> +                                               MTK_FD_CTX_FRAME_DATA_ERROR);
> +       }
> +
> +       fd_hw_dev->state = FD_ENQ;
> +       atomic_inc_return(&fd_ctx->fd_enque_cnt);
> +
> +       if (mtk_fd_send_ipi_cmd(fd_ctx->vpu_pdev, fd_param))
> +               return -2;
> +
> +       if (mtk_fd_wait_irq(fd_hw_dev))
> +               return mtk_fd_do_callback(fd_hw_dev,
> +                                               MTK_FD_CTX_FRAME_DATA_ERROR);
> +
> +       mtk_fd_dequeue(fd_hw_dev, fd_param);
> +
> +       dev_dbg(&pdev->dev, "- E. %s\n", __func__);
> +       return 0;
> +}
> +EXPORT_SYMBOL(mtk_fd_enqueue);
> +
> +int mtk_fd_release(struct platform_device *pdev)
> +{
> +       int ret = 0;
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +       struct mtk_isp_fd_drv_data *fd_drv;
> +
> +       fd_drv = dev_get_drvdata(&pdev->dev);
> +       fd_hw_dev = &fd_drv->fd_hw_dev;
> +       dev_dbg(&fd_hw_dev->pdev->dev, "- E. %s\n", __func__);
> +
> +       if (!pdev) {
> +               dev_err(&fd_hw_dev->pdev->dev, "platform device is NULL\n");
> +               return -EINVAL;
> +       }
> +
> +       dev_info(&fd_hw_dev->pdev->dev, "release fd_hw_dev: 0x%p\n", fd_hw_dev);
> +
> +       if (atomic_dec_and_test(&fd_hw_dev->fd_ctx.fd_user_cnt)) {
> +               if (fd_hw_dev->state == FD_ENQ)
> +                       mtk_fd_wait_irq(fd_hw_dev);
> +
> +               mtk_fd_release_context(fd_hw_dev);
> +
> +               pm_runtime_put_sync(&fd_hw_dev->pdev->dev);
> +       }
> +       dev_info(&fd_hw_dev->pdev->dev, "usercount = %d\n",
> +                atomic_read(&fd_hw_dev->fd_ctx.fd_user_cnt));
> +
> +       dev_dbg(&fd_hw_dev->pdev->dev, "- X. %s\n", __func__);
> +       return ret;
> +}
> +EXPORT_SYMBOL(mtk_fd_release);
> +
> +int mtk_fd_streamoff(struct platform_device *pdev, u16 id)
> +{
> +       int ret = 0;
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +       struct mtk_isp_fd_drv_data *fd_drv;
> +
> +       fd_drv = dev_get_drvdata(&pdev->dev);
> +       fd_hw_dev = &fd_drv->fd_hw_dev;
> +
> +       dev_dbg(&pdev->dev, "- E. %s\n", __func__);
> +
> +       if (fd_hw_dev->state == FD_ENQ)
> +               mtk_fd_wait_irq(fd_hw_dev);
> +
> +       fd_hw_dev->streaming = STREAM_OFF;
> +       atomic_dec_return(&fd_hw_dev->fd_ctx.fd_stream_cnt);
> +
> +       dev_dbg(&pdev->dev, "- X. %s\n", __func__);
> +       return ret;
> +}
> +EXPORT_SYMBOL(mtk_fd_streamoff);
> +
> +static struct mtk_fd_ctx_desc mtk_isp_ctx_desc_fd = {
> +       "proc_device_fd", mtk_fd_ctx_fd_init,};
> +
> +static int mtk_fd_probe(struct platform_device *pdev)
> +{
> +       struct mtk_isp_fd_drv_data *fd_drv;
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +       struct mtk_fd_drv_ctx *fd_ctx;
> +       struct device_node *node;
> +       struct platform_device *larb_pdev;
> +       int irq_num = 0;
> +       int ret = 0;
> +
> +       dev_info(&pdev->dev, "E. %s.\n", __func__);
> +
> +       fd_drv = devm_kzalloc(&pdev->dev, sizeof(*fd_drv), GFP_KERNEL);
> +
> +       if (!fd_drv)
> +               return -ENOMEM;
> +
> +       dev_set_drvdata(&pdev->dev, fd_drv);
> +       fd_hw_dev = &fd_drv->fd_hw_dev;
> +
> +       if (!fd_hw_dev) {
> +               dev_err(&pdev->dev, "Unable to allocate fd_hw_dev\n");
> +               return -ENOMEM;
> +       }
> +
> +       dev_info(&pdev->dev, "open fd_hw_dev = 0x%p\n", fd_hw_dev);
> +       dev_info(&pdev->dev, "open fd_drv = 0x%p\n", fd_drv);
> +
> +       fd_hw_dev->pdev = pdev;
> +       fd_ctx = &fd_hw_dev->fd_ctx;
> +
> +       irq_num = irq_of_parse_and_map(pdev->dev.of_node, FD_IRQ_IDX);
> +       ret = request_irq(irq_num, (irq_handler_t)mtk_fd_irq,
> +                         IRQF_TRIGGER_NONE, FD_DRVNAME, fd_hw_dev);
> +       if (ret) {
> +               dev_info(&pdev->dev, "%s request_irq fail, irq=%d\n",
> +                        __func__, irq_num);
> +               return ret;
> +       }
> +       dev_info(&pdev->dev, "irq_num=%d\n", irq_num);
> +
> +       node = of_parse_phandle(pdev->dev.of_node, "mediatek,larb", 0);
> +       if (!node) {
> +               dev_err(&pdev->dev, "no mediatek, larb found");
> +               return -EINVAL;
> +       }
> +       larb_pdev = of_find_device_by_node(node);
> +       if (!larb_pdev) {
> +               dev_err(&pdev->dev, "no mediatek, larb device found");
> +               return -EINVAL;
> +       }
> +       fd_hw_dev->larb_dev = &larb_pdev->dev;
> +
> +       node = of_find_compatible_node(NULL, NULL, "mediatek,fd");
> +       if (!node) {
> +               dev_err(&pdev->dev, "find fd node failed!!!\n");
> +               return -ENODEV;
> +       }
> +       fd_hw_dev->fd_base = of_iomap(node, 0);
> +       if (!fd_hw_dev->fd_base) {
> +               dev_err(&pdev->dev, "unable to map fd node!!!\n");
> +               return -ENODEV;
> +       }
> +       dev_info(&pdev->dev, "fd_hw_dev->fd_base: %lx\n",
> +                (unsigned long)fd_hw_dev->fd_base);
> +
> +       /* CCF: Grab clock pointer (struct clk*) */
> +       fd_hw_dev->fd_clk = devm_clk_get(&pdev->dev, "FD_CLK_IMG_FD");
> +       if (IS_ERR(fd_hw_dev->fd_clk)) {
> +               dev_err(&pdev->dev, "cannot get FD_CLK_IMG_FD clock\n");
> +               return PTR_ERR(fd_hw_dev->fd_clk);
> +       }
> +
> +       pm_runtime_enable(&pdev->dev);
> +
> +       atomic_set(&fd_ctx->fd_user_cnt, 0);
> +       atomic_set(&fd_ctx->fd_stream_cnt, 0);
> +       atomic_set(&fd_ctx->fd_enque_cnt, 0);
> +
> +       init_waitqueue_head(&fd_hw_dev->wq);
> +
> +       fd_hw_dev->fd_irq_result = 0;
> +       fd_hw_dev->streaming = STREAM_OFF;
> +
> +       ret = mtk_fd_dev_core_init(pdev, &fd_drv->fd_dev, &mtk_isp_ctx_desc_fd);
> +
> +       if (ret)
> +               dev_err(&pdev->dev, "v4l2 init failed: %d\n", ret);
> +
> +       dev_info(&pdev->dev, "X. FD driver probe.\n");
> +
> +       return 0;
> +}
> +
> +static int mtk_fd_remove(struct platform_device *pdev)
> +{
> +       int i4IRQ = 0;
> +       struct mtk_fd_drv_dev *fd_hw_dev = NULL;
> +       struct mtk_isp_fd_drv_data *drv_data = dev_get_drvdata(&pdev->dev);
> +
> +       dev_info(&fd_hw_dev->pdev->dev, "-E. %s\n", __func__);
> +       if (drv_data) {
> +               mtk_fd_dev_core_release(pdev, &drv_data->fd_dev);
> +               fd_hw_dev = &drv_data->fd_hw_dev;
> +       } else {
> +               dev_err(&pdev->dev, "Can't find fd driver data\n");
> +               return -EINVAL;
> +       }
> +
> +       mtk_fd_clk_ctrl(fd_hw_dev, clock_off);
> +       pm_runtime_disable(&pdev->dev);
> +
> +       i4IRQ = platform_get_irq(pdev, 0);
> +       free_irq(i4IRQ, NULL);
> +       kfree(fd_hw_dev);
> +
> +       dev_info(&fd_hw_dev->pdev->dev, "-X. %s\n", __func__);
> +       return 0;
> +}
> +
> +static int mtk_fd_suspend(struct device *dev)
> +{
> +       struct mtk_isp_fd_drv_data *fd_drv;
> +       struct platform_device *pdev;
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +
> +       if (pm_runtime_suspended(dev))
> +               return 0;
> +
> +       fd_drv = dev_get_drvdata(dev);
> +       fd_hw_dev = &fd_drv->fd_hw_dev;
> +       pdev = fd_hw_dev->pdev;
> +
> +       dev_info(&pdev->dev, "E.%s\n", __func__);
> +
> +       if (atomic_read(&fd_hw_dev->fd_ctx.fd_user_cnt) > 0) {
> +               mtk_fd_clk_ctrl(fd_hw_dev, clock_off);
> +               dev_info(&pdev->dev, "Disable clock\n");
> +       }
> +
> +       dev_info(&pdev->dev, "X.%s\n", __func__);
> +       return 0;
> +}
> +
> +static int mtk_fd_resume(struct device *dev)
> +{
> +       struct mtk_isp_fd_drv_data *fd_drv;
> +       struct platform_device *pdev;
> +       struct mtk_fd_drv_dev *fd_hw_dev;
> +
> +       if (pm_runtime_suspended(dev))
> +               return 0;
> +
> +       fd_drv = dev_get_drvdata(dev);
> +       fd_hw_dev = &fd_drv->fd_hw_dev;
> +       pdev = fd_hw_dev->pdev;
> +
> +       dev_info(&pdev->dev, "E.%s\n", __func__);
> +
> +       if (atomic_read(&fd_hw_dev->fd_ctx.fd_user_cnt) > 0) {
> +               mtk_fd_clk_ctrl(fd_hw_dev, clock_on);
> +               dev_info(&pdev->dev, "Enable clock\n");
> +       }
> +
> +       dev_info(&pdev->dev, "X.%s\n", __func__);
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops mtk_fd_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(mtk_fd_suspend, mtk_fd_resume)
> +       SET_RUNTIME_PM_OPS(mtk_fd_suspend, mtk_fd_resume, NULL)
> +};
> +
> +static struct platform_driver mtk_fd_driver = {
> +       .probe   = mtk_fd_probe,
> +       .remove  = mtk_fd_remove,
> +       .driver  = {
> +               .name  = FD_DRVNAME,
> +               .of_match_table = mtk_fd_of_ids,
> +               .pm = &mtk_fd_pm_ops,
> +       }
> +};
> +module_platform_driver(mtk_fd_driver);
> +
> +MODULE_DESCRIPTION("Mediatek FD driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/mtk-isp/fd/mtk_fd.h b/drivers/media/platform/mtk-isp/fd/mtk_fd.h
> new file mode 100644
> index 0000000..6cae440
> --- /dev/null
> +++ b/drivers/media/platform/mtk-isp/fd/mtk_fd.h
> @@ -0,0 +1,127 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + * Copyright (C) 2015 MediaTek Inc.
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MTK_FD_H__
> +#define __MTK_FD_H__
> +
> +#define MTK_FD_MAX_NO          (1024)
> +#define MAX_FACE_SEL_NUM       (MTK_FD_MAX_NO + 2)
> +
> +/* The max number of face sizes could be detected, for feature scaling */
> +#define FACE_SIZE_NUM_MAX      (14)
> +
> +/* FACE_SIZE_NUM_MAX + 1, first scale for input image W/H */
> +#define FD_SCALE_NUM           (15)
> +
> +/* Number of Learning data sets */
> +#define LEARNDATA_NUM          (18)
> +
> +struct fd_buffer {
> +       __u64 va;       /* used by APMCU access */
> +       __u32 pa;       /* used by CM4 access */
> +       __u32 iova;     /* used by HW access */
> +} __packed;
> +
> +enum fd_img_format {
> +       FMT_VYUY = 2,
> +       FMT_UYVY,
> +       FMT_YVYU,
> +       FMT_YUYV,
> +};
> +
> +enum fd_mode {
> +       FDMODE,
> +       SDMODE,
> +       VFB,
> +       CFB,
> +};
> +
> +struct fd_face_result {
> +       __u64 face_idx:12, type:1, x0:10, y0:10, x1:10, y1:10,
> +               fcv:18, rip_dir:4, rop_dir:3, det_size:5;
> +};
> +
> +struct fd_user_output {
> +       struct fd_face_result face[MAX_FACE_SEL_NUM];
> +       __u16 face_number;
> +};
> +
> +struct v4l2_fd_param {
> +       u32 frame_id;
> +       u16 src_img_h;
> +       u16 src_img_w;
> +       struct fd_buffer src_img;
> +       struct fd_buffer fd_user_param;
> +       struct fd_buffer fd_user_result;
> +} __packed;
> +
> +/**
> + * mtk_fd_enqueue - enqueue to fd driver
> + *
> + * @pdev: FD platform device
> + * @fdvtconfig: frame parameters from V4L2 common Framework
> + *
> + * Enqueue a frame to fd driver.
> + *
> + * Return: Return 0 if successfully, otherwise it is failed.
> + */
> +int mtk_fd_enqueue(struct platform_device *pdev,
> +                  struct v4l2_fd_param *fd_param);
> +
> +/**
> + * mtk_fd_open -
> + *
> + * @pdev: FD platform device
> + *
> + * Open the FD device driver
> + *
> + * Return: Return 0 if success, otherwise it is failed.
> + */
> +int mtk_fd_open(struct platform_device *pdev);
> +
> +/**
> + * mtk_fd_release -
> + *
> + * @pdev: FD platform device
> + *
> + * Enqueue a frame to FD driver.
> + *
> + * Return: Return 0 if success, otherwise it is failed.
> + */
> +int mtk_fd_release(struct platform_device *pdev);
> +
> +/**
> + * mtk_fd_streamon -
> + *
> + * @pdev: FD platform device
> + * @id: device context id
> + *
> + * Stream on
> + *
> + * Return: Return 0 if success, otherwise it is failed.
> + */
> +int mtk_fd_streamon(struct platform_device *pdev, u16 id);
> +
> +/**
> + * mtk_fd_streamoff -
> + *
> + * @pdev: FD platform device
> + * @id: device context id
> + *
> + * Stream off
> + *
> + * Return: Return 0 if success, otherwise it is failed.
> + */
> +int mtk_fd_streamoff(struct platform_device *pdev, u16 id);
> +
> +#endif/*__MTK_FD_H__*/
> --
> 1.9.1
>
