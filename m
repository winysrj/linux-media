Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5486EC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DAB0214AE
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfCLIRC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:17:02 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:36977 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726218AbfCLIRB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 04:17:01 -0400
X-UUID: fba0fb9859cc4a82a96ba7b5c4b6e607-20190312
X-UUID: fba0fb9859cc4a82a96ba7b5c4b6e607-20190312
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <jungo.lin@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1790535354; Tue, 12 Mar 2019 16:16:49 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 12 Mar 2019 16:16:47 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 12 Mar 2019 16:16:47 +0800
Message-ID: <1552378607.13953.71.camel@mtksdccf07>
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
        <holmes.chiou@mediatek.com>,
        Jerry-ch Chen <Jerry-ch.Chen@mediatek.com>,
        Rynn Wu =?UTF-8?Q?=28=E5=90=B3=E8=82=B2=E6=81=A9=29?= 
        <Rynn.Wu@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <yuzhao@chromium.org>,
        <zwisler@chromium.org>
Date:   Tue, 12 Mar 2019 16:16:47 +0800
In-Reply-To: <CAAFQd5BGFmTbRF+LdRvXs0MBZifRd9zB_+OT6Xwo=dzwqajgGA@mail.gmail.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
         <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
         <CAAFQd5BGFmTbRF+LdRvXs0MBZifRd9zB_+OT6Xwo=dzwqajgGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 75450C119F6FCFD075FF7169549EA3A78A40218C6FDC630F9AD7E8AB198538FA2000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-03-07 at 19:04 +0900, Tomasz Figa wrote:
> Hi Frederic, Jungo,
> 
> Sorry for making you wait. Here comes the second part. Please see my
> comments inline.
> 
> [snip]
> > +
> > +#define MTK_CAM_IO_CON_PADS (1)
> > +
> > +/* mtk_cam_io_connection --> sensor IF --> sensor 1 */
> > +/*                                     --> sensor 2 */
> 
> nit: Comment style.
> 
> Also, isn't the direction opposite?
> 

Hi Tomasz:

Thanks for your part 2's comment.
Below is our feedback.

For coding style issue, we will fix in next patch.

> > +struct mtk_cam_io_connection {
> > +       const char *name;
> 
> Do we need this name? Could we just use subdev.name instead?
> 
> > +       struct platform_device *pdev;
> 
> This is assigned to mtk_cam_dev::pdev in the code and mtk_cam_dev is a
> superclass of this struct, so we always have access to it and can get
> pdev from it. No need to store it here as well. (And not sure why one
> would normally need to access pdev. Perhaps storing the struct device
> pointer inside mtk_cam_dev would be more practical?)
> 

Yes, you are right.
We will remove these two fields in next patch.

> > +       struct v4l2_subdev subdev;
> 
> Do we need a subdev for an IO connection? Normally the processing part
> of the ISP would be represented as a subdev and then it would have its
> pads linked to other entities.
> 

After internal discussion, we will revise the current CIO design.
We will use the same ISP sub-dev to connect with sensor-IF without
creating one new sub-device.

> > +       int enable;
> > +       /* sensor connected */
> > +       struct v4l2_subdev *sensor;
> > +       /* sensor interface connected */
> > +       struct v4l2_subdev *sensor_if;
> > +       struct media_pad subdev_pads[MTK_CAM_IO_CON_PADS];
> > +       /* Current sensor input format*/
> > +       struct v4l2_mbus_framefmt subdev_fmt;
> 
> To summarize, it sounds like only "enable", "sensor", "sensor_if" and
> "subdev_fmt" would be appropriate attributes for an "IO connection".
> All the rest would normally be considered to be a part of the ISP
> device (and "pdev" and "name" are redundant).
> 

After simplifying, we will only keep "enable", "sensor" and "sensor_f"
for an "IO connection" as below:

/*
 * struct mtk_cam_io_connection - CIO (Camera IO) information.
 *
 * @enabled: indicate stream on or off
 * @sensor: sensor sub-device
 * @sensor_if: sensor_if sub-device
 *
 * Below is the graph topology.
 * sensor 1 (main) --> sensor IF --> P1 sub-device
 * sensor 2 (sub)  -->
 *
 */
struct mtk_cam_io_connection {
	int enabled;
	struct v4l2_subdev *sensor;
	struct v4l2_subdev *sensor_if;
};


> > +};
> > +
> > +struct mtk_cam_dev_video_device {
> 
> nit: Why not just mtk_cam_video_device?
> 

OK, rename in next patch.

> > +       const char *name;
> 
> Why not use vdev.name?
> 

OK, remove this field and change to use vdev.name in next patch.

> > +       int output;
> 
> Already available in vdev.vfl_dir, although not sure why it would be
> normally needed.
> 

OK, remove this field in next patch.

> > +       int immutable;
> 

It is removed based on comment part 1's change.

> Only master queue seems to be immutable, so maybe just check if the
> queue is master, wherever this is used currently?
> 
> > +       int enabled;
> > +       int queued;
> 
> Looks unused.
> 

For "enabled", it indicates the video device is enabled or not during
the media link setup phase. Based on this information, we could know how
many video devices (DMAs) are enabled. So we will keep this. For
"queued", we will remove in next patch.

> > +       struct v4l2_format vdev_fmt;
> > +       struct video_device vdev;
> > +       struct media_pad vdev_pad;
> > +       struct v4l2_mbus_framefmt pad_fmt;
> > +       struct vb2_queue vbq;
> > +       struct list_head buffers;
> > +       struct mutex lock; /* vb2 queue and video device data protection */
> 
> It's actually about operations, not data. I'd write it "Serializes vb2
> queue and video device operations.".
> 

Ok, we will fix the comment wording to clarify the correct usage.
Below is the revised structure.

/*
 * struct mtk_cam_video_device - Mediatek video device structure.
 *
 * @enabled: indicate stream on or off
 * @queue_id: queue id for mtk_cam_ctx_queue
 * @pending_list: list for pending buffer
 * @lock: serializes vb2 queue and video device operations.
 * @slock: protect for pending_list.
 *
 */
struct mtk_cam_video_device {
	int enabled;
	int queue_id;
	struct v4l2_format vdev_fmt;
	struct video_device vdev;
	struct media_pad vdev_pad;
	struct vb2_queue vbq;
	struct list_head pending_list;
	/* Used for vbq & vdev */
	struct mutex lock;
	/* protect for pending_list */
	spinlock_t slock;
};

> > +       atomic_t sequence;
> > +};
> > +
> > +struct mtk_cam_mem2mem2_device {
> > +       const char *name;
> > +       const char *model;
> 
> For both of the fields above, they seem to be always
> MTK_CAM_DEV_P1_NAME, so we can just use the macro directly whenever
> needed. No need for this indirection.
> 

OK. These two fields will be removed in next patch.

> > +       struct device *dev;
> > +       int num_nodes;
> > +       struct mtk_cam_dev_video_device *nodes;
> > +       const struct vb2_mem_ops *vb2_mem_ops;
> 
> This is always "vb2_dma_contig_memops", so it can be used directly.
> 

Ditto.

> > +       unsigned int buf_struct_size;
> 
> This is always sizeof(struct mtk_cam_dev_buffer), so no need to save
> it in the struct.
> 

Ditto.

> > +       int streaming;
> > +       struct v4l2_device *v4l2_dev;
> > +       struct media_device *media_dev;
> 
> These 2 fields are already in mtk_cam_dev which is a superclass of
> this struct. One can just access them from there directly.
> 

Ditto.

> > +       struct media_pipeline pipeline;
> > +       struct v4l2_subdev subdev;
> 
> Could you remind me what was the media topology exposed by this
> driver? This is already the second subdev I spotted in this patch,
> which looks strange.
> 


For sub-device design, we will remove the sub-device for CIO and keep
only one sub-device for ISP driver in next patch. We will also provide
the media topology in RFC v1 patch to clarify.

> > +       struct media_pad *subdev_pads;
> > +       struct v4l2_file_operations v4l2_file_ops;
> > +       const struct file_operations fops;
> > +};
> 
> Given most of the comments above, it looks like the remaining useful
> fields in this struct could be just moved to mtk_cam_dev, without the
> need for this separate struct.
> 

This is the final revision for these two structures.
Do you suggest to merge it to simplify?

struct mtk_cam_mem2mem2_device {
	struct mtk_cam_video_device *nodes;
	struct media_pipeline pipeline;
	struct v4l2_subdev subdev;
	struct media_pad *subdev_pads;
};

struct mtk_cam_dev {
	struct platform_device *pdev;
	struct mtk_cam_video_device     mem2mem2_nodes[MTK_CAM_DEV_NODE_MAX];
	struct mtk_cam_mem2mem2_device mem2mem2;
	struct mtk_cam_io_connection cio;
	struct v4l2_device v4l2_dev;
	struct media_device media_dev;
	struct mtk_cam_ctx ctx;
	struct v4l2_async_notifier notifier;
};


> > +
> > +struct mtk_cam_dev {
> > +       struct platform_device *pdev;
> > +       struct mtk_cam_dev_video_device mem2mem2_nodes[MTK_CAM_DEV_NODE_MAX];
> > +       int queue_enabled[MTK_CAM_DEV_NODE_MAX];
> 
> Isn't this redundant with struct mtk_cam_dev_video_device::enabled?
> 

Yes, we have removed this.

> > +       struct mtk_cam_mem2mem2_device mem2mem2;
> > +       struct mtk_cam_io_connection cio;
> > +       struct v4l2_device v4l2_dev;
> > +       struct media_device media_dev;
> > +       struct mtk_cam_ctx ctx;
> > +       struct v4l2_async_notifier notifier;
> > +       struct mutex lock; /* device level data protection */
> 
> Just a side note: As a rule of thumb, mutex is normally used to
> protect operations not data (with some exceptions). For simple data
> protection, where accesses would normally take very short time,
> spinlock would be used. Of course a mutex would technically work too,
> so let's keep it for now and we can optimize later.
> 

After review, the mutex is useless and will remove it in next patch.
Btw, thanks for your explanation the difference between mutex &
spinlock. 

> > +};
> > +
> > +int mtk_cam_media_register(struct device *dev,
> > +                          struct media_device *media_dev,
> > +       const char *model);
> > +int mtk_cam_v4l2_register(struct device *dev,
> > +                         struct media_device *media_dev,
> > +       struct v4l2_device *v4l2_dev,
> > +       struct v4l2_ctrl_handler *ctrl_handler);
> > +int mtk_cam_v4l2_unregister(struct mtk_cam_dev *dev);
> > +int mtk_cam_mem2mem2_v4l2_register(struct mtk_cam_dev *dev,
> > +                                  struct media_device *media_dev,
> > +       struct v4l2_device *v4l2_dev);
> > +
> > +int mtk_cam_v4l2_async_register(struct mtk_cam_dev *isp_dev);
> > +
> > +void mtk_cam_v4l2_async_unregister(struct mtk_cam_dev *isp_dev);
> > +
> > +int mtk_cam_v4l2_discover_sensor(struct mtk_cam_dev *isp_dev);
> > +
> > +void mtk_cam_v4l2_buffer_done(struct vb2_buffer *vb,
> > +                             enum vb2_buffer_state state);
> > +extern int mtk_cam_dev_queue_buffers
> > +       (struct mtk_cam_dev *dev, int initial);
> 
> Remove extern (here and other places too).
> 

This coding style issue has been fixed in comment part 1.

> > +extern int mtk_cam_dev_get_total_node
> > +       (struct mtk_cam_dev *mtk_cam_dev);
> > +extern char *mtk_cam_dev_get_node_name
> > +       (struct mtk_cam_dev *mtk_cam_dev_obj, int node);
> > +int mtk_cam_dev_init(struct mtk_cam_dev *isp_dev,
> > +                    struct platform_device *pdev,
> > +                    struct media_device *media_dev,
> > +                    struct v4l2_device *v4l2_dev);
> > +extern void mtk_cam_dev_mem2mem2_exit
> > +       (struct mtk_cam_dev *mtk_cam_dev_obj);
> > +int mtk_cam_dev_mem2mem2_init(struct mtk_cam_dev *isp_dev,
> > +                             struct media_device *media_dev,
> > +       struct v4l2_device *v4l2_dev);
> > +int mtk_cam_dev_get_queue_id_of_dev_node
> > +       (struct mtk_cam_dev *mtk_cam_dev_obj,
> > +        struct mtk_cam_dev_video_device *node);
> > +int mtk_cam_dev_core_init(struct platform_device *pdev,
> > +                         struct mtk_cam_dev *isp_dev,
> > +       struct mtk_cam_ctx_desc *ctx_desc);
> > +int mtk_cam_dev_core_init_ext(struct platform_device *pdev,
> > +                             struct mtk_cam_dev *isp_dev,
> > +       struct mtk_cam_ctx_desc *ctx_desc,
> > +       struct media_device *media_dev,
> > +       struct v4l2_device *v4l2_dev);
> > +extern int mtk_cam_dev_core_release
> > +(struct platform_device *pdev, struct mtk_cam_dev *isp_dev);
> 
> nit: Strange line break. Some more usual examples:
> 
> int mtk_cam_dev_core_release(struct platform_device *pdev,
>                              struct mtk_cam_dev *isp_dev);
> 
> struct long_struct_name *mtk_cam_dev_core_release(
>         struct platform_device *pdev,
>         struct mtk_cam_dev *isp_dev);
> 
> struct very_very_very_long_struct_name *
> my_function(int a, int b);
> 

Thanks for your comment.
We will revise our coding style based on your hint.

> > +
> > +#endif /* __MTK_CAM_DEV_H__ */
> > diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-regs.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-regs.h
> > new file mode 100644
> > index 0000000..b5067d6
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-regs.h
> > @@ -0,0 +1,146 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2018 MediaTek Inc.
> > + * Author: Ryan Yu <ryan.yu@mediatek.com>
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
> > +#ifndef _CAM_REGS_H
> > +#define _CAM_REGS_H
> > +
> > +/* TG Bit Mask */
> > +#define VFDATA_EN_BIT BIT(0)
> > +#define CMOS_EN_BIT BIT(0)
> > +
> > +/* normal signal bit */
> > +#define VS_INT_ST      BIT(0)
> > +#define HW_PASS1_DON_ST        BIT(11)
> > +#define SOF_INT_ST     BIT(12)
> > +#define SW_PASS1_DON_ST        BIT(30)
> > +
> > +/* err status bit */
> > +#define TG_ERR_ST      BIT(4)
> > +#define TG_GBERR_ST    BIT(5)
> > +#define CQ_CODE_ERR_ST BIT(6)
> > +#define CQ_APB_ERR_ST  BIT(7)
> > +#define CQ_VS_ERR_ST   BIT(8)
> > +#define AMX_ERR_ST     BIT(15)
> > +#define RMX_ERR_ST     BIT(16)
> > +#define BMX_ERR_ST     BIT(17)
> > +#define RRZO_ERR_ST    BIT(18)
> > +#define AFO_ERR_ST     BIT(19)
> > +#define IMGO_ERR_ST    BIT(20)
> > +#define AAO_ERR_ST     BIT(21)
> > +#define PSO_ERR_ST     BIT(22)
> > +#define LCSO_ERR_ST    BIT(23)
> > +#define BNR_ERR_ST     BIT(24)
> > +#define LSCI_ERR_ST    BIT(25)
> > +#define DMA_ERR_ST     BIT(29)
> > +
> > +/* CAM DMA done status */
> > +#define FLKO_DONE_ST   BIT(4)
> > +#define AFO_DONE_ST    BIT(5)
> > +#define AAO_DONE_ST    BIT(7)
> > +#define PSO_DONE_ST    BIT(14)
> > +
> > +/* IRQ signal mask */
> > +#define INT_ST_MASK_CAM        ( \
> > +                       VS_INT_ST |\
> > +                       HW_PASS1_DON_ST |\
> > +                       SOF_INT_ST |\
> > +                       SW_PASS1_DON_ST)
> > +
> > +/* IRQ Warning Mask */
> > +#define INT_ST_MASK_CAM_WARN   (\
> > +                               RRZO_ERR_ST |\
> > +                               AFO_ERR_ST |\
> > +                               IMGO_ERR_ST |\
> > +                               AAO_ERR_ST |\
> > +                               PSO_ERR_ST | \
> > +                               LCSO_ERR_ST |\
> > +                               BNR_ERR_ST |\
> > +                               LSCI_ERR_ST)
> > +
> > +/* IRQ Error Mask */
> > +#define INT_ST_MASK_CAM_ERR    (\
> > +                               TG_ERR_ST |\
> > +                               TG_GBERR_ST |\
> > +                               CQ_CODE_ERR_ST |\
> > +                               CQ_APB_ERR_ST |\
> > +                               CQ_VS_ERR_ST |\
> > +                               BNR_ERR_ST |\
> > +                               RMX_ERR_ST |\
> > +                               BMX_ERR_ST |\
> > +                               BNR_ERR_ST |\
> > +                               LSCI_ERR_ST |\
> > +                               DMA_ERR_ST)
> > +
> > +/* IRQ Signal Log Mask */
> > +#define INT_ST_LOG_MASK_CAM    (\
> > +                               SOF_INT_ST |\
> > +                               SW_PASS1_DON_ST |\
> > +                               VS_INT_ST |\
> > +                               TG_ERR_ST |\
> > +                               TG_GBERR_ST |\
> > +                               RRZO_ERR_ST |\
> > +                               AFO_ERR_ST |\
> > +                               IMGO_ERR_ST |\
> > +                               AAO_ERR_ST |\
> > +                               DMA_ERR_ST)
> > +
> > +/* DMA Event Notification Mask */
> > +#define DMA_ST_MASK_CAM        (\
> > +                       AFO_DONE_ST |\
> > +                       AAO_DONE_ST |\
> > +                       PSO_DONE_ST |\
> > +                       FLKO_DONE_ST)
> > +
> > +/* Status check */
> > +#define REG_CTL_EN                     0x0004
> > +#define REG_CTL_DMA_EN                 0x0008
> > +#define REG_CTL_FMT_SEL                0x0010
> > +#define REG_CTL_EN2                    0x0018
> > +#define REG_CTL_RAW_INT_EN             0x0020
> > +#define REG_CTL_RAW_INT_STAT           0x0024
> > +#define REG_CTL_RAW_INT2_STAT          0x0034
> > +#define REG_CTL_RAW_INT3_STAT          0x00C4
> 
> nit: Please use lowercase hex literals.
> 
> [snip]

Ok, we will fix this coding style issue in next patch.

> > diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
> > new file mode 100644
> > index 0000000..020c38c
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
> 
> I don't think we need any of the code that is in this file. We should
> just use the DMA API. We should be able to create appropriate reserved
> memory pools in DT and properly assign them to the right allocating
> devices.
> 
> Skipping review of this file for the time being.
> 

For this file, we may need your help.
Its purpose is same as DIP SMEM driver.
It is used for creating the ISP P1 specific vb2 buffer allocation
context with reserved memory. Unfortunately, the implementation of
mtk_cam-smem-drive.c is our best solution now.

Could you give us more hints how to implement?
Or do you think we could leverage the implementation from "Samsung S5P
Multi Format Codec driver"?
drivers/media/platform/s5p-mfc/s5p_mfc.c
- s5p_mfc_configure_dma_memory function
  - s5p_mfc_configure_2port_memory
     - s5p_mfc_alloc_memdev

> [snip]
> > diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem.h
> > new file mode 100644
> > index 0000000..4e1cf20
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem.h
> 
> Ditto.
> 
> [snip]
> > diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c
> > new file mode 100644
> > index 0000000..7da312d
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c
> > @@ -0,0 +1,1555 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2018 Mediatek Corporation.
> > + * Copyright (c) 2017 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License version
> > + * 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + *
> > + * MTK_CAM-v4l2 is highly based on Intel IPU 3 chrome driver
> 
> To be precise, it's not a "chrome driver". I think you could just say
> "IPU3 ImgU driver". (The driver was merged in Linux 5.0.)
> 

OK, we will revise our wording.

> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <media/v4l2-subdev.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-fwnode.h>
> > +#include <linux/device.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/of.h>
> > +#include <linux/of_graph.h>
> > +#include <media/v4l2-common.h>
> > +#include <media/media-entity.h>
> > +#include <media/v4l2-async.h>
> > +
> > +#include "mtk_cam.h"
> > +#include "mtk_cam-dev.h"
> > +#include "mtk_cam-v4l2.h"
> > +#include "mtk_cam-v4l2-util.h"
> > +
> > +#define CONFIG_MEDIATEK_MEDIA_REQUEST
> 
> I guess this is for testing, but I'd suggest switching to the target
> setup sooner than later and dropping this and related #ifdefs.
> 

Yes, it is testing purpose and has been removed in our latest codebase.

> > +
> > +#define MTK_CAM_SENSOR_MAIN_PAD_SRC 0
> > +#define MTK_CAM_SENSOR_SUB_PAD_SRC 0
> > +#define MTK_CAM_SENSOR_IF_PAD_MAIN_SINK 0
> > +#define MTK_CAM_SENSOR_IF_PAD_SUB_SINK 1
> > +#define MTK_CAM_SENSOR_IF_PAD_SRC 4
> > +#define MTK_CAM_CIO_PAD_SINK 0
> > +
> > +static u32 mtk_cam_node_get_v4l2_cap
> > +       (struct mtk_cam_ctx_queue *node_ctx);
> > +
> > +static int mtk_cam_videoc_s_meta_fmt(struct file *file,
> > +                                    void *fh, struct v4l2_format *f);
> > +
> > +static int mtk_cam_subdev_open(struct v4l2_subdev *sd,
> > +                              struct v4l2_subdev_fh *fh)
> > +{
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_subdev_to_dev(sd);
> > +
> > +       isp_dev->ctx.fh = fh;
> > +       return mtk_cam_ctx_open(&isp_dev->ctx);
> > +}
> > +
> > +static int mtk_cam_subdev_close(struct v4l2_subdev *sd,
> > +                               struct v4l2_subdev_fh *fh)
> > +{
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_subdev_to_dev(sd);
> > +
> > +       return mtk_cam_ctx_release(&isp_dev->ctx);
> > +}
> > +
> > +static int mtk_cam_subdev_s_stream(struct v4l2_subdev *sd,
> > +                                  int enable)
> > +{
> > +       int ret = 0;
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_subdev_to_dev(sd);
> > +       struct mtk_cam_io_connection *cio = &isp_dev->cio;
> > +
> > +       if (enable) {
> 
> Please extract enable and disable cases into separate functions.
> 

Ok, we will revise current implementation as below:

static int mtk_cam_subdev_s_stream(struct v4l2_subdev *sd,
				   int enable)
{
	struct mtk_cam_dev *isp_dev = mtk_cam_subdev_to_dev(sd);
	struct mtk_cam_io_connection *cio = &isp_dev->cio;

	if (enable)
		return mtk_cam_cio_stream_on(isp_dev, cio);
	else
		return mtk_cam_cio_stream_off(isp_dev, cio);
}

> > +               /* Get sensor interace and sensor sub device */
> > +               /* If the call succeeds, sensor if and sensor are filled */
> > +               /* in isp_dev->cio->sensor_if and isp_dev->cio->sensor */
> > +               ret = mtk_cam_v4l2_discover_sensor(isp_dev);
> > +               if (ret) {
> > +                       dev_err(&isp_dev->pdev->dev,
> > +                               "no sensor or sensor if connected (%d)\n",
> > +                               ret);
> > +                       return -EPERM;
> > +               }
> > +
> > +               /* seninf must stream on first */
> > +               ret = v4l2_subdev_call(cio->sensor_if, video, s_stream, 1);
> > +               if (ret) {
> > +                       dev_err(&isp_dev->pdev->dev,
> > +                               "sensor-if(%s) stream on failed (%d)\n",
> > +                               cio->sensor_if->entity.name, ret);
> > +                       return -EPERM;
> > +               }
> > +
> > +               dev_dbg(&isp_dev->pdev->dev, "streamed on sensor-if(%s)\n",
> > +                       cio->sensor_if->entity.name);
> > +
> > +               ret = v4l2_subdev_call(cio->sensor, video, s_stream, 1);
> > +               if (ret) {
> > +                       dev_err(&isp_dev->pdev->dev,
> > +                               "sensor(%s) stream on failed (%d)\n",
> > +                               cio->sensor->entity.name, ret);
> > +                       return -EPERM;
> 
> We should undo any previous operations.
> 

OK, we will add "undo procedure" in the new function.

> > +               }
> > +
> > +               dev_dbg(&isp_dev->pdev->dev, "streamed on sensor(%s)\n",
> > +                       cio->sensor->entity.name);
> > +
> > +               ret = mtk_cam_ctx_streamon(&isp_dev->ctx);
> > +               if (ret) {
> > +                       dev_err(&isp_dev->pdev->dev,
> > +                               "Pass 1 stream on failed (%d)\n", ret);
> > +                       return -EPERM;
> > +               }
> > +
> > +               isp_dev->mem2mem2.streaming = enable;
> > +
> > +               ret = mtk_cam_dev_queue_buffers(isp_dev, true);
> > +               if (ret)
> > +                       dev_err(&isp_dev->pdev->dev,
> > +                               "failed to queue initial buffers (%d)", ret);
> > +
> > +               dev_dbg(&isp_dev->pdev->dev, "streamed on Pass 1\n");
> > +       } else {
> > +               if (cio->sensor) {
> 
> Is it possible to have cio->sensor NULL here? This function would have
> failed if it wasn't found when enabling.
> 

In the original design, it is protected to avoid abnormal double stream
off (s_stream) call from upper layer. For stability reason, it is better
to check.

> > +                       ret = v4l2_subdev_call(cio->sensor, video, s_stream, 0);
> > +                       if (ret) {
> > +                               dev_err(&isp_dev->pdev->dev,
> > +                                       "sensor(%s) stream off failed (%d)\n",
> > +                                       cio->sensor->entity.name, ret);
> > +                       } else {
> > +                               dev_dbg(&isp_dev->pdev->dev,
> > +                                       "streamed off sensor(%s)\n",
> > +                                       cio->sensor->entity.name);
> > +                               cio->sensor = NULL;
> > +                       }
> > +               } else {
> > +                       dev_err(&isp_dev->pdev->dev,
> > +                               "Can't find sensor connected\n");
> > +               }
> > +
> > +               if (cio->sensor_if) {
> 
> Ditto.
> 
> > +                       ret = v4l2_subdev_call(cio->sensor_if, video,
> > +                                              s_stream, 0);
> > +                       if (ret) {
> > +                               dev_err(&isp_dev->pdev->dev,
> > +                                       "sensor if(%s) stream off failed (%d)\n",
> > +                                       cio->sensor_if->entity.name, ret);
> > +                       } else {
> > +                               dev_dbg(&isp_dev->pdev->dev,
> > +                                       "streamed off sensor-if(%s)\n",
> > +                                       cio->sensor_if->entity.name);
> > +                               cio->sensor_if = NULL;
> > +                       }
> > +               } else {
> > +                       dev_err(&isp_dev->pdev->dev,
> > +                               "Can't find sensor-if connected\n");
> > +               }
> > +
> > +               ret = mtk_cam_ctx_streamoff(&isp_dev->ctx);
> > +               if (ret) {
> > +                       dev_err(&isp_dev->pdev->dev,
> > +                               "Pass 1 stream off failed (%d)\n", ret);
> > +                       return -EPERM;
> > +               }
> > +
> > +               isp_dev->mem2mem2.streaming = false;
> > +
> > +               dev_dbg(&isp_dev->pdev->dev, "streamed off Pass 1\n");
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void v4l2_event_merge(const struct v4l2_event *old,
> > +                            struct v4l2_event *new)
> > +{
> > +       struct mtk_cam_dev_stat_event_data *old_evt_stat_data =
> > +               (void *)old->u.data;
> > +       struct mtk_cam_dev_stat_event_data *new_evt_stat_data =
> > +               (void *)new->u.data;
> > +
> > +       if (old->type == V4L2_EVENT_MTK_CAM_ENGINE_STATE &&
> > +           new->type == V4L2_EVENT_MTK_CAM_ENGINE_STATE) {
> > +               pr_debug("%s, merge IRQ, old(type(0x%x) frame no(%d) IRQ(0x%x) DMA(0x%x)), new(type(0x%x) frame_number(%d) IRQ(0x%x) DMA(0x%x))",
> > +                        __func__,
> > +                       old->type,
> > +                       old_evt_stat_data->frame_number,
> > +                       old_evt_stat_data->irq_status_mask,
> > +                       old_evt_stat_data->dma_status_mask,
> > +                       new->type,
> > +                       new_evt_stat_data->frame_number,
> > +                       new_evt_stat_data->irq_status_mask,
> > +                       new_evt_stat_data->dma_status_mask);
> > +
> > +               /* merge IRQ event */
> > +               new_evt_stat_data->irq_status_mask |=
> > +                       old_evt_stat_data->irq_status_mask;
> > +               new_evt_stat_data->dma_status_mask |=
> > +                       old_evt_stat_data->dma_status_mask;
> > +       }
> 
> What are these custom events for? Userspace shouldn't need to know
> anything about IRQ and DMA.
> 

We will remove custom event and change to use V4L2_EVENT_FRAME_SYNC
event.

> [snip]
> > +static void mtk_cam_vb2_buf_queue(struct vb2_buffer *vb)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +       struct mtk_cam_dev *mtk_cam_dev = mtk_cam_m2m_to_dev(m2m2);
> > +
> > +       struct device *dev = &mtk_cam_dev->pdev->dev;
> > +
> 
> nit: Please remove these unnecessary blank lines between variables.
> 

Ok, we will fix this kind of coding style issue in next patch.

> > +       struct mtk_cam_dev_buffer *buf = NULL;
> > +
> > +       struct vb2_v4l2_buffer *v4l2_buf = NULL;
> 
> Please default-initialize local variables only if really needed.
> Otherwise it prevents the compiler from catching missing assignments
> for you.
> 

Ditto.

> > +
> > +       struct mtk_cam_dev_video_device *node =
> > +               mtk_cam_vbq_to_isp_node(vb->vb2_queue);
> > +
> > +       int queue = mtk_cam_dev_get_queue_id_of_dev_node(mtk_cam_dev, node);
> 
> Why not just add queue_id field to mtk_cam_dev_video_device?
> 

Yes, it is a good idea. We will add this field for
mtk_cam_dev_video_device.

> > +
> > +       dev_dbg(dev,
> > +               "queue vb2_buf: Node(%s) queue id(%d)\n",
> > +               node->name,
> > +               queue);
> > +
> > +       if (queue < 0) {
> > +               dev_err(m2m2->dev, "Invalid mtk_cam_dev node.\n");
> > +               return;
> > +       }
> 
> I don't think this is possible.
> 

Ok, we will remove this kind of logic check.

> > +
> > +       if (!vb)
> > +               pr_err("VB can't be null\n");
> 
> Ditto.
> 
> > +
> > +       buf = mtk_cam_vb2_buf_to_dev_buf(vb);
> > +
> > +       if (!buf)
> > +               pr_err("buf can't be null\n");
> 
> Ditto.
> 
> > +
> > +       v4l2_buf = to_vb2_v4l2_buffer(vb);
> > +
> > +       if (!v4l2_buf)
> > +               pr_err("v4l2_buf can't be null\n");
> 
> Ditto.
> 
> > +
> > +       mutex_lock(&mtk_cam_dev->lock);
> > +
> > +       pr_debug("init  mtk_cam_ctx_buf, sequence(%d)\n", v4l2_buf->sequence);
> > +
> > +       /* the dma address will be filled in later frame buffer handling*/
> > +       mtk_cam_ctx_buf_init(&buf->ctx_buf, queue, (dma_addr_t)0);
> > +       pr_debug("set mtk_cam_ctx_buf_init: user seq=%d\n",
> > +                buf->ctx_buf.user_sequence);
> 
> This should normally happen in the buf_init vb2 operation.
> 
> By the way, what's the point of having the DMA address argument to
> mtk_cam_ctx_buf_init() if it's always 0?
> 
> Given the above, is there even a reason for mtk_cam_ctx_buf_init() to
> exist? It sounds like the structure could be just initialize directly
> in buf_init.
> 

Based on comment part 1, we have revised this implementation.
There is no need to perform buffer initialization in this function.


> > +
> > +       /* Added the buffer into the tracking list */
> > +       list_add_tail(&buf->m2m2_buf.list,
> > +                     &m2m2->nodes[node - m2m2->nodes].buffers);
> > +       mutex_unlock(&mtk_cam_dev->lock);
> 
> If this mutex is only for the buffer list, I'd consider replacing it
> with a spinlock.
> 

Yes, in the new version, we change to use spinlock to protect list data,
not mutex lock.

e.g.

	buf = mtk_cam_vb2_buf_to_dev_buf(vb);

	/* Added the buffer into the tracking list */
	spin_lock(&node->slock);
	list_add_tail(&buf->list, &node->pending_list);
	spin_unlock(&node->slock);

> > +
> > +       /* Enqueue the buffer */
> > +       if (mtk_cam_dev->mem2mem2.streaming) {
> > +               pr_debug("%s: mtk_cam_dev_queue_buffers\n",
> > +                        node->name);
> > +               mtk_cam_dev_queue_buffers(mtk_cam_dev, false);
> 
> Doesn't mtk_cam_dev_queue_buffers() already check if streaming is active?
> 

Yes, we could remove the logic check in this function and count on the
checking of mtk_cam_dev_queue_buffers() function.

> Okay, let me send the comments above and continue third part of the
> review in another email.
> 
> Best regards,
> Tomasz

Thanks for your valued comments on part 2.
It is helpful for us to make our driver implementation better.

We'd like to know your opinion about the schedule for RFC V1.
Do you suggest us to send RFC V1 patch set after revising all comments
on part 1 & 2 or wait for part 3 review?

Best regards,


Jungo



