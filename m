Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51428C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0188B21917
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbfBQC4R (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 21:56:17 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:54490 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728005AbfBQC4Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 21:56:16 -0500
X-UUID: 2a333ec6b03447b9b139ed55caec62d8-20190217
X-UUID: 2a333ec6b03447b9b139ed55caec62d8-20190217
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <jungo.lin@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 301683896; Sun, 17 Feb 2019 10:56:03 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 17 Feb 2019 10:56:03 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 17 Feb 2019 10:56:03 +0800
Message-ID: <1550372163.11724.59.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
From:   Jungo Lin <jungo.lin@mediatek.com>
To:     Tomasz Figa <tfiga@chromium.org>
CC:     Frederic Chen <frederic.chen@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg 
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Sean Cheng =?UTF-8?Q?=28=E9=84=AD=E6=98=87=E5=BC=98=29?= 
        <Sean.Cheng@mediatek.com>, "Sj Huang" <sj.huang@mediatek.com>,
        Christie Yu =?UTF-8?Q?=28=E6=B8=B8=E9=9B=85=E6=83=A0=29?= 
        <christie.yu@mediatek.com>,
        Holmes Chiou =?UTF-8?Q?=28=E9=82=B1=E6=8C=BA=29?= 
        <holmes.chiou@mediatek.com>, <Jerry-ch.Chen@mediatek.com>,
        Rynn Wu =?UTF-8?Q?=28=E5=90=B3=E8=82=B2=E6=81=A9=29?= 
        <Rynn.Wu@mediatek.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <yuzhao@chromium.org>,
        <zwisler@chromium.org>, <seraph_huang@mediatek.com>,
        <frankie_chiu@mediatek.com>, <ryan_yu@mediatek.com>
Date:   Sun, 17 Feb 2019 10:56:03 +0800
In-Reply-To: <CAAFQd5CWdZUXVb4F9BLhQdN8WHjzA8acPDx1i+WcoudsdGsfUg@mail.gmail.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
         <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
         <CAAFQd5CWdZUXVb4F9BLhQdN8WHjzA8acPDx1i+WcoudsdGsfUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: D6DA6202870410ABDFE69FC9E9A3AC990EFD04D757A893A6AD98D43183FA79FC2000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dear Thomas:

Thanks for your comments.

We will revise the source codes based on your comments.
Since there are many comments to fix/revise, we will categorize &
prioritize these with below list:

1. Coding style issues.
2. Coding defects, including unused codes. 
3. Driver architecture refactoring, such as removing mtk_cam_ctx,
unnecessary abstraction layer, etc.


On Wed, 2019-02-13 at 18:50 +0900, Tomasz Figa wrote:
> (() . ( strHi Frederic, Jungo,
> 
> On Tue, Feb 5, 2019 at 3:43 PM Frederic Chen <frederic.chen@mediatek.com> wrote:
> >
> > From: Jungo Lin <jungo.lin@mediatek.com>
> >
> > This patch adds the driver for Pass unit in Mediatek's camera
> > ISP system. Pass 1 unit is embedded in Mediatek SOCs. It
> > provides RAW processing which includes optical black correction,
> > defect pixel correction, W/IR imbalance correction and lens
> > shading correction.
> >
> > The mtk-isp directory will contain drivers for multiple IP
> > blocks found in Mediatek ISP system. It will include ISP Pass 1
> > driver, sensor interface driver, DIP driver and face detection
> > driver.
> 
> Thanks for the patches! Please see my comments inline.
> 
> [snip]
> > diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h
> > new file mode 100644
> > index 0000000..11a60a6
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h
> > @@ -0,0 +1,327 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2018 MediaTek Inc.
> > + * Author: Frederic Chen <frederic.chen@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MTK_CAM_CTX_H__
> > +#define __MTK_CAM_CTX_H__
> > +
> > +#include <linux/types.h>
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/videobuf2-core.h>
> > +#include <media/v4l2-subdev.h>
> > +#include "mtk_cam-v4l2-util.h"
> > +
> > +#define MTK_CAM_CTX_QUEUES (16)
> > +#define MTK_CAM_CTX_FRAME_BUNDLE_BUFFER_MAX (MTK_CAM_CTX_QUEUES)
> > +#define MTK_CAM_CTX_DESC_MAX (MTK_CAM_CTX_QUEUES)
> > +
> > +#define MTK_CAM_CTX_MODE_DEBUG_OFF (0)
> > +#define MTK_CAM_CTX_MODE_DEBUG_BYPASS_JOB_TRIGGER (1)
> > +#define MTK_CAM_CTX_MODE_DEBUG_BYPASS_ALL (2)
> 
> nit: No need for parentheses for simple values. Also please align
> macro values together using tabs.
> 

1. Coding style issues
- Fix in next release.

> > +
> > +#define MTK_CAM_GET_CTX_ID_FROM_SEQUENCE(sequence) \
> > +       ((sequence) >> 16 & 0x0000FFFF)
> 
> Sounds like a job for a static inline function, with appropriate
> argument and return types enforced by the compiler.
> 

2. Coding defects
- Plan to fix.

> > +
> > +#define MTK_CAM_CTX_META_BUF_DEFAULT_SIZE (1110 * 1024)
> > +
> > +struct mtk_cam_ctx;
> > +struct mtk_cam_ctx_open_param;
> > +struct mtk_cam_ctx_release_param;
> > +struct mtk_cam_ctx_streamon_param;
> > +struct mtk_cam_ctx_streamoff_param;
> > +struct mtk_cam_ctx_start_param;
> > +struct mtk_cam_ctx_finish_param;
> > +
> > +/* struct mtk_cam_ctx_ops - background hardware driving ops */
> > +/* sdefines background driver specific callback APIs  */
> > +struct mtk_cam_ctx_ops {
> > +       int (*open)(struct mtk_cam_ctx *dev_ctx,
> > +                   struct mtk_cam_ctx_open_param *param);
> > +       int (*release)(struct mtk_cam_ctx *dev_ctx,
> > +                      struct mtk_cam_ctx_release_param *param);
> > +       int (*start)(struct mtk_cam_ctx *dev_ctx,
> > +                    struct mtk_cam_ctx_start_param *param);
> > +       int (*finish)(struct mtk_cam_ctx *dev_ctx,
> > +                     struct mtk_cam_ctx_finish_param *param);
> > +       int (*streamon)(struct mtk_cam_ctx *dev_ctx,
> > +                       struct mtk_cam_ctx_streamon_param *param);
> > +       int (*streamoff)(struct mtk_cam_ctx *dev_ctx,
> > +                        struct mtk_cam_ctx_streamoff_param *param);
> > +};
> 
> We only have one driver here and these ops look really close to what
> vb2 already provides. Why do we need this indirection?
> 

3. Driver architecture refactoring
- Plan to fix.

> > +
> > +/* Attributes setup by device context owner */
> > +struct mtk_cam_ctx_queue_desc {
> > +       int id; /* id of the context queue */
> 
> Please use kerneldoc syntax for documenting the structures.
> (https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txtjjj
> 

1. Coding style issues
- Fix in next release.

> > +       char *name;
> > +       /* Will be exported to media entity name */
> > +       int capture;
> > +       /* true for capture queue (device to user), false for output queue */
> > +       /* (from user to device) */
> > +       int image;
> > +       /* Using the cam_smem_drv as alloc ctx or not */
> > +       int smem_alloc;
> > +       /* true for image, false for meta data */
> > +       unsigned int dma_port; /*The dma port associated to the buffer*/
> > +       /* Supported format */
> > +       struct mtk_cam_ctx_format *fmts;
> > +       int num_fmts;
> > +       /* Default format of this queue */
> > +       int default_fmt_idx;
> > +};
> > +
> > +/* Supported format and the information used for */
> > +/* size calculation */
> 
> CodingStyle:
> /*
>  * This is the kernel style for multi-line
>  * comments.
>  */
> 

1. Coding style issues
- Fix in next release.

> > +struct mtk_cam_ctx_meta_format {
> > +       u32 dataformat;
> > +       u32 max_buffer_size;
> > +       u8 flags;
> > +};
> > +
> > +struct mtk_cam_ctx_img_format {
> > +       u32     pixelformat;
> > +       u8      depth[VIDEO_MAX_PLANES];
> > +       u8      row_depth[VIDEO_MAX_PLANES];
> > +       u8      num_planes;
> > +       u32     flags;
> > +};
> > +
> > +struct mtk_cam_ctx_format {
> > +       union {
> > +               struct mtk_cam_ctx_meta_format meta;
> > +               struct mtk_cam_ctx_img_format img;
> > +       } fmt;
> > +};
> > +
> > +union mtk_v4l2_fmt {
> > +       struct v4l2_pix_format_mplane pix_mp;
> > +       struct v4l2_meta_format meta;
> > +};
> 
> Why not just use the standard v4l2_format?
> 

3. Driver architecture refactoring
- yes, it is possible to use v4l2_format and will depended on how to
remove mtk_cam_ctx structure.

> > +
> > +/* Attributes setup by device context owner */
> > +struct mtk_cam_ctx_queues_setting {
> > +       int master;
> > +       /* The master input node to trigger the frame data enqueue */
> > +       struct mtk_cam_ctx_queue_desc *output_queue_descs;
> > +       int total_output_queues;
> > +       struct mtk_cam_ctx_queue_desc *capture_queue_descs;
> > +       int total_capture_queues;
> > +};
> > +
> > +struct mtk_cam_ctx_queue_attr {
> > +       int master;
> > +       int input_offset;
> > +       int total_num;
> > +};
> > +
> > +/* Video node context. Since we use */
> > +/* mtk_cam_ctx_frame_bundle to manage enqueued */
> > +/* buffers by frame now, we don't use bufs filed of */
> > +/* mtk_cam_ctx_queue now */
> > +struct mtk_cam_ctx_queue {
> > +       union mtk_v4l2_fmt fmt;
> > +       struct mtk_cam_ctx_format *ctx_fmt;
> > +       /* Currently we used in standard v4l2 image format */
> > +       /* in the device context */
> > +       unsigned int width_pad; /* bytesperline, reserved */
> 
> What's the meaning of this field?

2. Coding defects
- Unused field. Should be removed in next release.

> 
> > +       struct mtk_cam_ctx_queue_desc desc;
> > +       struct list_head bufs; /* Reserved, not used now */
> > +};
> > +
> > +enum mtk_cam_ctx_frame_bundle_state {
> > +       MTK_CAM_CTX_FRAME_NEW,  /* Not allocated */
> > +       MTK_CAM_CTX_FRAME_PREPARED, /* Allocated but has not be processed */
> > +       MTK_CAM_CTX_FRAME_PROCESSING,   /* Queued, waiting to be filled */
> > +};
> 
> Feels like duplicating the media_request::state. (and eliminating the
> benefit of the state machine being fully managed by the Request API
> core).
> 

3. Driver architecture refactoring
- Plan to remove based on Request API mechanism.

> > +
> > +/* The definiation is compatible with DIP driver's state definiation */
> > +/* currently and will be decoupled after further integration */
> > +enum mtk_cam_ctx_frame_data_state {
> > +       MTK_CAM_CTX_FRAME_DATA_EMPTY = 0, /* FRAME_STATE_INIT */
> > +       MTK_CAM_CTX_FRAME_DATA_DONE = 3, /* FRAME_STATE_DONE */
> > +       MTK_CAM_CTX_FRAME_DATA_STREAMOFF_DONE = 4, /*FRAME_STATE_STREAMOFF*/
> > +       MTK_CAM_CTX_FRAME_DATA_ERROR = 5, /*FRAME_STATE_ERROR*/
> > +};
> 
> What are these states for?
> 

3. Driver architecture refactoring
- Plan to replace with VB2 state.


> > +
> > +struct mtk_cam_ctx_frame_bundle {
> > +       struct mtk_cam_ctx_buffer*
> > +               buffers[MTK_CAM_CTX_FRAME_BUNDLE_BUFFER_MAX];
> > +       int id;
> > +       int num_img_capture_bufs;
> > +       int num_img_output_bufs;
> > +       int num_meta_capture_bufs;
> > +       int num_meta_output_bufs;
> > +       int last_index;
> > +       int state;
> > +       struct list_head list;
> > +};
> > +
> > +struct mtk_cam_ctx_frame_bundle_list {
> > +       struct list_head list;
> > +};
> 
> This sounds like duplicating the request API core functionality, which
> aggregates all the buffers in the request.
> 

3. Driver architecture refactoring
- Plan to remove based on Request API mechanism.

> > +
> > +struct mtk_cam_ctx {
> > +       struct platform_device *pdev;
> > +       struct platform_device *smem_device;
> > +       /* buffer queues will be added later */
> > +       unsigned short ctx_id;
> > +       char *device_name;
> > +       const struct mtk_cam_ctx_ops *ops;
> > +       struct mtk_cam_dev_node_mapping *mtk_cam_dev_node_map;
> > +       unsigned int dev_node_num;
> > +       /* mtk_cam_ctx_queue is the context for the video nodes */
> > +       struct mtk_cam_ctx_queue queue[MTK_CAM_CTX_QUEUES];
> > +       struct mtk_cam_ctx_queue_attr queues_attr;
> > +       atomic_t frame_param_sequence;
> > +       int streaming;
> > +       void *default_vb2_alloc_ctx;
> > +       void *smem_vb2_alloc_ctx;
> > +       struct v4l2_subdev_fh *fh;
> > +       struct mtk_cam_ctx_frame_bundle frame_bundles[VB2_MAX_FRAME];
> > +       struct mtk_cam_ctx_frame_bundle_list processing_frames;
> > +       struct mtk_cam_ctx_frame_bundle_list free_frames;
> > +       int enabled_dma_ports;
> > +       int num_frame_bundle;
> > +       spinlock_t qlock; /* frame queues protection */
> > +};
> > +
> > +enum mtk_cam_ctx_buffer_state {
> > +       MTK_CAM_CTX_BUFFER_NEW,
> > +       MTK_CAM_CTX_BUFFER_PROCESSING,
> > +       MTK_CAM_CTX_BUFFER_DONE,
> > +       MTK_CAM_CTX_BUFFER_FAILED,
> > +};
> 
> Why these custom states? VB2 already manages buffer states for you and
> the driver should just obtain available buffers in the .buf_queue
> callback and return them with appropriate state using
> vb2_buffer_done() when they are no longer in use.
> 

3. Driver architecture refactoring
- Plan to replace with VB2 state.

> > +
> > +struct mtk_cam_ctx_buffer {
> > +       union mtk_v4l2_fmt fmt;
> > +       struct mtk_cam_ctx_format *ctx_fmt;
> > +       int capture;
> > +       int image;
> > +       int frame_id;
> > +       int user_sequence; /* Sequence number assigned by user */
> 
> What's this user_sequence? There shouldn't be any sequence coming from
> the user, since the requests are used to aggregate buffers.
> 

2. Coding defects 
- It is used without Request API support.
In current design, it should be removed in next release.

> > +       dma_addr_t daddr;
> > +       void *vaddr;
> 
> We shouldn't need to touch the buffers from the kernel driver.
> 

2. Coding defects
- Will remove in next release.

> > +       phys_addr_t paddr;
> 
> We shouldn't need physical address either. I suppose this is for the
> SCP, but then it should be a DMA address obtained from dma_map_*()
> with struct device pointer of the SCP.
> 

Yes, this physical address is designed for SCP.
For tuning buffer, it will be touched by SCP and
SCP can't get the physical address by itself. So we need to get
this physical address in the kernel space via mtk_cam_smem_iova_to_phys
function call and pass it to the SCP. At the same time, DMA address
(daddr) is used for ISP HW.

> > +       unsigned int queue;
> > +       enum mtk_cam_ctx_buffer_state state;
> > +       struct list_head list;
> > +};
> > +
> > +struct mtk_cam_ctx_setting {
> > +       struct mtk_cam_ctx_ops *ops;
> > +       char *device_name;
> > +};
> > +
> > +struct mtk_cam_ctx_desc {
> > +       char *proc_dev_phandle;
> > +       /* The context device's compatble string name in device tree*/
> > +       int (*init)(struct mtk_cam_ctx *ctx);
> > +       /* configure the core functions of the device context */
> > +};
> > +
> > +struct mtk_cam_ctx_init_table {
> > +       int total_dev_ctx;
> > +       struct mtk_cam_ctx_desc *ctx_desc_tbl;
> > +};
> > +
> > +struct mtk_cam_ctx_open_param {
> > +       /* Bitmask used to notify that the DMA port is enabled or not */
> > +       unsigned int enabled_dma_ports;
> > +};
> > +
> > +struct mtk_cam_ctx_streamon_param {
> > +       unsigned int enabled_dma_ports;
> > +};
> > +
> > +struct mtk_cam_ctx_streamoff_param {
> > +       unsigned int enabled_dma_ports;
> > +};
> 
> Hmm, the 3 structs above are identical. Is there a need to have all 3 of them?
> 

3. Driver architecture refactoring
- Plan to revise.

> > +
> > +struct mtk_cam_ctx_start_param {
> > +       /* carry buffer information of the frame */
> > +       struct mtk_cam_ctx_frame_bundle *frame_bundle;
> > +};
> > +
> > +struct mtk_cam_ctx_release_param {
> > +       unsigned int enabled_dma_ports;
> > +};
> 
> One more identical struct.
> 

Same as above.

> [snip]
> > diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c
> > new file mode 100644
> > index 0000000..7d0197b
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c
> > @@ -0,0 +1,986 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2018 MediaTek Inc.
> > + * Author: Frederic Chen <frederic.chen@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/platform_device.h>
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <linux/dma-mapping.h>
> > +#include <media/v4l2-event.h>
> > +
> > +#include "mtk_cam-dev.h"
> > +#include "mtk_cam-v4l2-util.h"
> > +#include "mtk_cam-v4l2.h"
> > +#include "mtk_cam-smem.h"
> > +
> > +static struct mtk_cam_ctx_format *mtk_cam_ctx_find_fmt
> > +       (struct mtk_cam_ctx_queue *queue,
> > +        u32 format);
> > +
> > +static int mtk_cam_ctx_process_frame(struct mtk_cam_ctx *dev_ctx,
> > +                                    struct mtk_cam_ctx_frame_bundle
> > +                                    *frame_bundle);
> > +
> > +static int mtk_cam_ctx_free_frame(struct mtk_cam_ctx *dev_ctx,
> > +                                 struct mtk_cam_ctx_frame_bundle
> > +                                 *frame_bundle);
> > +
> > +static struct mtk_cam_ctx_frame_bundle *mtk_cam_ctx_get_free_frame
> > +       (struct mtk_cam_ctx *dev_ctx);
> > +
> > +static struct mtk_cam_ctx_frame_bundle *mtk_cam_ctx_get_processing_frame
> > +(struct mtk_cam_ctx *dev_ctx, int frame_id);
> > +
> > +static int mtk_cam_ctx_init_frame_bundles(struct mtk_cam_ctx *dev_ctx);
> > +
> > +static void mtk_cam_ctx_queue_event_frame_done
> > +       (struct mtk_cam_ctx *dev_ctx,
> > +       struct mtk_cam_dev_frame_done_event_data *fdone);
> > +
> > +static void debug_bundle(struct mtk_cam_ctx  *dev_ctx,
> > +                        struct mtk_cam_ctx_frame_bundle *bundle_data);
> 
> Could you reorder the functions in this file so that there is no need
> for forward declarations? In general, a kernel source file should be
> ordered in such way that the reader can understand what's happening by
> reading from the top to bottom, without jumping between functions.
> 

2. Coding defects 
- Will fix in next release.

> > +
> > +struct vb2_v4l2_buffer *mtk_cam_ctx_buffer_get_vb2_v4l2_buffer
> > +(struct mtk_cam_ctx_buffer *ctx_buf)
> > +{
> > +       struct mtk_cam_dev_buffer *dev_buf = NULL;
> > +
> > +       if (!ctx_buf) {
> > +               pr_err("Failed to convert ctx_buf to dev_buf: Null pointer\n");
> > +               return NULL;
> > +       }
> > +
> > +       dev_buf = mtk_cam_ctx_buf_to_dev_buf(ctx_buf);
> > +
> > +       return &dev_buf->m2m2_buf.vbb;
> > +}
> 
> I also added a comment to where mtk_cam_dev_buffer struct is defined,
> but let me repeat here. I don't think we need to split these structs
> so much. We just need one driver-specific struct that encapsulates the
> vb2_v4l2_buffer struct, e.g. mtk_cam_buffer.
> 

3. Driver architecture refactoring
- Yes, we will plan to refactoring current implementation.

> > +
> > +/* The helper to configure the device context */
> > +int mtk_cam_ctx_core_steup(struct mtk_cam_ctx *ctx,
> > +                          struct mtk_cam_ctx_setting *ctx_setting)
> > +{
> > +       if (!ctx || !ctx_setting)
> > +               return -EINVAL;
> > +
> > +       ctx->ops = ctx_setting->ops;
> > +       ctx->device_name = ctx_setting->device_name;
> > +
> > +       return 0;
> > +}
> 
> I don't understand what's the point of this. We only have one device,
> P1, and only one context ops, for this P1 device. Do we need this
> abstraction?
> 

3. Driver architecture refactoring
- Yes, we will plan to remove this abstraction.

> > +
> > +int mtk_cam_ctx_core_queue_setup(struct mtk_cam_ctx *ctx,
> > +                                struct mtk_cam_ctx_queues_setting
> > +                                *queues_setting)
> > +{
> > +       int queue_idx = 0;
> > +       int i = 0;
> > +
> > +       for (i = 0; i < queues_setting->total_output_queues; i++) {
> > +               struct mtk_cam_ctx_queue_desc *queue_desc =
> > +                       queues_setting->output_queue_descs + i;
> 
> The typical kernel convention would be &queues_setting->output_queue_descs[i].
> 

2. Coding defects 
- Fix in next release.

> > +
> > +               if (!queue_desc)
> > +                       return -EINVAL;
> 
> I don't think this can ever happen, especially for i > 0.
> 

2. Coding defects 
- Remove in next release.

> > +
> > +               /* Since the *ctx->queue has been initialized to 0 */
> > +               /* when it is allocated with mtk_cam_dev , */
> > +               /* I don't initialize the struct here */
> > +               ctx->queue[queue_idx].desc = *queue_desc;
> > +               queue_idx++;
> > +       }
> > +
> > +       ctx->queues_attr.input_offset = queue_idx;
> 
> This input_offset doesn't seem to be used in the driver in any
> meaningful way. The only place it's read is in
> mtk_cam_dev_mem2mem2_init() and that could be easily replaced with
> checking for (!isp_dev->ctx.queue[i].capture).
> 

2. Coding defects 
- Plan to revise in next release.

> > +
> > +       /* Setup the capture queue */
> > +       for (i = 0; i < queues_setting->total_capture_queues; i++) {
> > +               struct mtk_cam_ctx_queue_desc *queue_desc =
> > +                       queues_setting->capture_queue_descs + i;
> > +
> > +               if (!queue_desc)
> > +                       return -EINVAL;
> 
> Ditto.
> 

Same as above.

> > +
> > +               /* Since the *ctx->queue has been initialized to 0 */
> > +               /* when allocating the memory, I don't */
> > +               /* reinitialied the struct here */
> > +               ctx->queue[queue_idx].desc = *queue_desc;
> > +               queue_idx++;
> > +       }
> > +
> > +       ctx->queues_attr.master = queues_setting->master;
> > +       ctx->queues_attr.total_num = queue_idx;
> > +       ctx->dev_node_num = ctx->queues_attr.total_num;
> > +       return 0;
> > +}
> 
> This function just copies some compile-time constant data at runtime.
> Why couldn't we just use the compile-time constants directly?
> 
> Also, I don't see vb2 queues handled here. What a V4L2 driver would
> normally do is:
> - have a driver-private struct to represent the queue (e.g.
> mtk_cam_queue) and encapsulating vb2_queue,
> - set vb2_queue::drv_priv to point to the mtk_cam_queue struct encapsulating it,
> - both the vb2_queue and internal data fields would be initialized in
> the same function, to keep queue-initialization code in the same part
> of the driver.
> 

3. Driver architecture refactoring
- Yes, we will plan to refactoring current implementation.

> > +
> > +/* Mediatek ISP context core initialization */
> > +int mtk_cam_ctx_core_init(struct mtk_cam_ctx *ctx,
> > +                         struct platform_device *pdev, int ctx_id,
> > +       struct mtk_cam_ctx_desc *ctx_desc,
> > +       struct platform_device *proc_pdev,
> > +       struct platform_device *smem_pdev)
> > +{
> > +       /* Initialize main data structure */
> > +       int r = 0;
> 
> Please don't initialize return value variables, unless really
> necessary. It prevents the compiler from detecting forgotten
> assignments further in the function.
> 

2. Coding defects 
- Fix in next release.

> > +
> > +       ctx->smem_vb2_alloc_ctx = &smem_pdev->dev;
> > +       ctx->default_vb2_alloc_ctx = &pdev->dev;
> > +
> > +       if (IS_ERR((__force void *)ctx->smem_vb2_alloc_ctx))
> > +               pr_err("Failed to alloc vb2 dma context: smem_vb2_alloc_ctx");
> > +
> > +       if (IS_ERR((__force void *)ctx->default_vb2_alloc_ctx))
> > +               pr_err("Failed to alloc vb2 dma context: default_vb2_alloc_ctx");
> 
> It's impossible for the two conditions above to happen.
> 

2. Coding defects 
- Remove in next release.


> > +
> > +       ctx->pdev = pdev;
> > +       ctx->ctx_id = ctx_id;
> > +       /* keep th smem pdev to use related iommu functions */
> > +       ctx->smem_device = smem_pdev;
> 
> nit: Perhaps the field could be renamed to smem_pdev?
> 

2. Coding defects 
- Fix in next release.


> > +
> > +       /* initialized the global frame index of the device context */
> > +       atomic_set(&ctx->frame_param_sequence, 0);
> > +       spin_lock_init(&ctx->qlock);
> > +
> > +       /* setup the core operation of the device context */
> > +       if (ctx_desc && ctx_desc->init)
> > +               r = ctx_desc->init(ctx);
> 
> There is only one possible descriptor in this driver -
> mtk_cam_ctx_desc_p1. Please remove this unnecessary abstraction and
> just call the right functions directly.
> 

3. Driver architecture refactoring
- Yes, we will plan to remove this abstraction.

> > +
> > +       return r;
> > +}
> > +EXPORT_SYMBOL_GPL(mtk_cam_ctx_core_init);
> > +
> > +int mtk_cam_ctx_core_exit(struct mtk_cam_ctx *ctx)
> > +{
> > +       ctx->smem_vb2_alloc_ctx = NULL;
> > +       ctx->default_vb2_alloc_ctx = NULL;
> 
> ctx is going to be freed soon after this function returns, so there is
> no need to set these pointers to NULL. (And so, no need for this
> function at all.)
> 

2. Coding defects 
- Remove in next release.

> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(mtk_cam_ctx_core_exit);
> > +
> > +/* Get the corrospnd FH of a specific buffer */
> 
> typo: corresponding
> What's FH?
> This function doesn't seem to accept a buffer pointer, so not sure
> what you mean by "a specific buffer".
> Also, the function increments ctx->frame_param_sequence, so it's not
> just a "get".
> 

2. Coding defects 
- The purpose of this function is to generate one unique frame sequence.
We will correct the comment of this function. 


> > +int mtk_cam_ctx_next_global_frame_sequence(struct mtk_cam_ctx *ctx,
> > +                                          int locked)
> > +{
> > +       int global_frame_sequence =
> > +               atomic_inc_return(&ctx->frame_param_sequence);
> > +
> > +       if (!locked)
> > +               spin_lock(&ctx->qlock);
> > +
> > +       global_frame_sequence =
> > +               (global_frame_sequence & 0x0000FFFF) | (ctx->ctx_id << 16);
> > +
> > +       if (!locked)
> > +               spin_unlock(&ctx->qlock);
> > +
> > +       return global_frame_sequence;
> > +}
> > +EXPORT_SYMBOL_GPL(mtk_cam_ctx_next_global_frame_sequence);
> 
> Please don't make a function change locking behavior based on
> arguments - it's super error prone and hard to debug. Instead, please
> provide 2 variants:
> 
> __mtk_cam_ctx_next_global_frame_sequence_locked() which does
> everything except locking
> 
> and
> 
> mtk_cam_ctx_next_global_frame_sequence() which simply grabs the lock
> and calls __mtk_cam_ctx_next_global_frame_sequence_locked().
> 
> But, do you really need a _locked() variant here? I can see this
> function being called only once in mtk_cam_ctx_trigger_job(), with
> dev_ctx->ctx_id as the second argument, which sounds like a bug. Also,
> why do you even need to acquire ctx->qlock here, if
> ctx->frame_param_sequence is atomic?
> 

3. Driver architecture refactoring
- We will plan to remove context implementation in the P1 driver.
So this function may be removed in future.
If we still keep this function, we will revise based on your suggestion.

> > +
> > +static void mtk_cam_ctx_buffer_done
> > +       (struct mtk_cam_ctx_buffer *ctx_buf, int state)
> > +{
> > +               if (!ctx_buf ||
> > +                   state != MTK_CAM_CTX_BUFFER_DONE ||
> > +                       state != MTK_CAM_CTX_BUFFER_FAILED)
> > +                       return;
> > +
> > +               ctx_buf->state = state;
> > +}
> 
> I don't see why this function could even be useful. VB2 already tracks
> buffer states, as I mentioned in my earlier comment.
> 
> [snip]
> 

3. Driver architecture refactoring
- Plan to remove during driver refactoring.

> > +#define file_to_mtk_cam_node(__file) \
> > +       container_of(video_devdata(__file),\
> > +       struct mtk_cam_dev_video_device, vdev)
> > +
> > +#define mtk_cam_ctx_to_dev(__ctx) \
> > +       container_of(__ctx,\
> > +       struct mtk_cam_dev, ctx)
> > +
> > +#define mtk_cam_m2m_to_dev(__m2m) \
> > +       container_of(__m2m,\
> > +       struct mtk_cam_dev, mem2mem2)
> > +
> > +#define mtk_cam_subdev_to_dev(__sd) \
> > +       container_of(__sd, \
> > +       struct mtk_cam_dev, mem2mem2.subdev)
> > +
> > +#define mtk_cam_vbq_to_isp_node(__vq) \
> > +       container_of(__vq, \
> > +       struct mtk_cam_dev_video_device, vbq)
> > +
> > +#define mtk_cam_ctx_buf_to_dev_buf(__ctx_buf) \
> > +       container_of(__ctx_buf, \
> > +       struct mtk_cam_dev_buffer, ctx_buf)
> > +
> > +#define mtk_cam_vb2_buf_to_dev_buf(__vb) \
> > +       container_of(vb, \
> > +       struct mtk_cam_dev_buffer, \
> > +       m2m2_buf.vbb.vb2_buf)
> > +
> > +#define mtk_cam_vb2_buf_to_m2m_buf(__vb) \
> > +       container_of(__vb, \
> > +       struct mtk_cam_mem2mem2_buffer, \
> > +       vbb.vb2_buf)
> > +
> > +#define mtk_cam_subdev_to_m2m(__sd) \
> > +       container_of(__sd, \
> > +       struct mtk_cam_mem2mem2_device, subdev)
> 
> All the macros above need to be replaced with static inline functions
> to guarantee the right argument and return types at compilation time.
> 

3. Driver architecture refactoring
- Plan to revise during driver refactoring.

> > +
> > +struct mtk_cam_mem2mem2_device;
> > +
> > +struct mtk_cam_mem2mem2_buffer {
> > +       struct vb2_v4l2_buffer vbb;
> > +       struct list_head list;
> > +};
> > +
> > +struct mtk_cam_dev_buffer {
> > +       struct mtk_cam_mem2mem2_buffer m2m2_buf;
> > +       /* Intenal part */
> > +       struct mtk_cam_ctx_buffer ctx_buf;
> 
> Why do we need to separate this? All the data here belongs to this driver.
> 

3. Driver architecture refactoring
- Plan to revise during driver refactoring.

> The reply is quite long already, so let me send it. Second part to follow.
> 
> Best regards,
> Tomasz

Appreciate your patience to provide these helpful comments. We look
forward to further comments.

Thanks,

Jungo

