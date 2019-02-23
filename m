Return-Path: <SRS0=tcVs=Q6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609ECC43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 06:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB95206A3
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 06:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbfBWGT1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 23 Feb 2019 01:19:27 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:29215 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725886AbfBWGT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Feb 2019 01:19:26 -0500
X-UUID: 3d240d295ca0485194ffb7945c5a520f-20190223
X-UUID: 3d240d295ca0485194ffb7945c5a520f-20190223
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 190225088; Sat, 23 Feb 2019 14:19:02 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 23 Feb 2019 14:19:01 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 23 Feb 2019 14:18:54 +0800
Message-ID: <1550902734.18654.36.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek DIP
 driver
From:   Frederic Chen <frederic.chen@mediatek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "tfiga@chromium.org" <tfiga@chromium.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sean Cheng =?UTF-8?Q?=28=E9=84=AD=E6=98=87=E5=BC=98=29?= 
        <Sean.Cheng@mediatek.com>,
        "Sj Huang =?UTF-8?Q?=28=E9=BB=83=E4=BF=A1=E7=92=8B=29?=" 
        <sj.huang@mediatek.com>,
        Christie Yu =?UTF-8?Q?=28=E6=B8=B8=E9=9B=85=E6=83=A0=29?= 
        <christie.yu@mediatek.com>,
        Holmes Chiou =?UTF-8?Q?=28=E9=82=B1=E6=8C=BA=29?= 
        <holmes.chiou@mediatek.com>,
        Jerry-ch Chen =?UTF-8?Q?=28=E9=99=B3=E6=95=AC=E6=86=B2=29?= 
        <Jerry-ch.Chen@mediatek.com>,
        Jungo Lin =?UTF-8?Q?=28=E6=9E=97=E6=98=8E=E4=BF=8A=29?= 
        <jungo.lin@mediatek.com>,
        Rynn Wu =?UTF-8?Q?=28=E5=90=B3=E8=82=B2=E6=81=A9=29?= 
        <Rynn.Wu@mediatek.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        "laurent.pinchart+renesas@ideasonboard.com" 
        <laurent.pinchart+renesas@ideasonboard.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>
Date:   Sat, 23 Feb 2019 14:18:54 +0800
In-Reply-To: <1550756198.11724.86.camel@mtksdccf07>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
         <1549020091-42064-8-git-send-email-frederic.chen@mediatek.com>
         <20190207190824.GA98164@google.com> <1550756198.11724.86.camel@mtksdccf07>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 315D94603BE020902756E76FB1D82D126F957D1C9FECB4CA1226383EC4895F812000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dear Brian,

I appreciate your comments. I'm really sorry for the delay in responding
to the comments due to some mail subscribing failed issue inside my company.

On Thu, 2019-02-21 at 21:36 +0800, Jungo Lin wrote:
> Re-sent to Frederic due to company Mail system issue.
> 
> On Thu, 2019-02-07 at 11:08 -0800, Brian Norris wrote:
> > Hi,
> > 
> > On Fri, Feb 01, 2019 at 07:21:31PM +0800, Frederic Chen wrote:
> > > This patch adds the driver of Digital Image Processing (DIP)
> > > unit in Mediatek ISP system, providing image format conversion,
> > > resizing, and rotation features.
> > > 
> > > The mtk-isp directory will contain drivers for multiple IP
> > > blocks found in Mediatek ISP system. It will include ISP Pass 1
> > > driver (CAM), sensor interface driver, DIP driver and face
> > > detection driver.
> > > 
> > > Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
> > > ---
> > >  drivers/media/platform/mtk-isp/Makefile            |   18 +
> > >  drivers/media/platform/mtk-isp/isp_50/Makefile     |   17 +
> > >  drivers/media/platform/mtk-isp/isp_50/dip/Makefile |   35 +
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-core.h     |  188 +++
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c     |  173 +++
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h     |   43 +
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h      |  319 ++++
> > >  .../mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c      | 1643 ++++++++++++++++++++
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-dev.c      |  374 +++++
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-dev.h      |  191 +++
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c |  452 ++++++
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-smem.h     |   25 +
> > >  .../mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c         | 1000 ++++++++++++
> > >  .../mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h         |   38 +
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c     |  292 ++++
> > >  .../platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h     |   60 +
> > >  .../media/platform/mtk-isp/isp_50/dip/mtk_dip.c    | 1385 +++++++++++++++++
> > >  .../media/platform/mtk-isp/isp_50/dip/mtk_dip.h    |   93 ++
> > >  18 files changed, 6346 insertions(+)
> > >  create mode 100644 drivers/media/platform/mtk-isp/Makefile
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/Makefile
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/Makefile
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-core.h
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.c
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.h
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem.h
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c
> > >  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.h
> > > 
> > 
> > ...
> > 
> > > diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c
> > > new file mode 100644
> > > index 0000000..9d29507
> > > --- /dev/null
> > > +++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c
> > > @@ -0,0 +1,173 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2018 MediaTek Inc.
> > > + * Author: Frederic Chen <frederic.chen@mediatek.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +#include <linux/device.h>
> > > +#include <linux/platform_device.h>
> > > +#include "mtk_dip-dev.h"
> > > +#include "mtk_dip-ctrl.h"
> > > +
> > > +#define CONFIG_MTK_DIP_COMMON_UT
> > 
> > Please don't do this. You're pretending to have configurability that you
> > don't actually have.
> > 

I got it. I will remove CONFIG_MTK_DIP_COMMON_UT and other similar macro in
the next patch.

> > > +
> > > +static void handle_buf_usage_config(struct v4l2_ctrl *ctrl);
> > > +static void handle_buf_rotate_config(struct v4l2_ctrl *ctrl);
> > > +static int mtk_dip_ctx_s_ctrl(struct v4l2_ctrl *ctrl);
> > > +
> > > +static void handle_buf_usage_config(struct v4l2_ctrl *ctrl)
> > > +{
> > > +	struct mtk_dip_ctx_queue *queue =
> > > +		container_of(ctrl->handler,
> > > +			     struct mtk_dip_ctx_queue, ctrl_handler);
> > > +
> > > +	if (ctrl->val < MTK_DIP_V4l2_BUF_USAGE_DEFAULT ||
> > > +	    ctrl->val >= MTK_DIP_V4l2_BUF_USAGE_NONE) {
> > > +		pr_err("Invalid buffer usage id %d", ctrl->val);
> > > +		return;
> > > +	}
> > > +	queue->buffer_usage = ctrl->val;
> > > +}
> > > +
> > > +static void handle_buf_rotate_config(struct v4l2_ctrl *ctrl)
> > > +{
> > > +	struct mtk_dip_ctx_queue *queue =
> > > +		container_of(ctrl->handler,
> > > +			     struct mtk_dip_ctx_queue, ctrl_handler);
> > > +
> > > +	if (ctrl->val != 0 || ctrl->val != 90 ||
> > > +	    ctrl->val != 180 || ctrl->val != 270) {
> > > +		pr_err("Invalid buffer rotation %d", ctrl->val);
> > > +		return;
> > > +	}
> > > +	queue->rotation = ctrl->val;
> > > +}
> > > +
> > > +static const struct v4l2_ctrl_ops mtk_dip_ctx_ctrl_ops = {
> > > +	.s_ctrl = mtk_dip_ctx_s_ctrl,
> > > +};
> > > +
> > > +#ifdef CONFIG_MTK_DIP_COMMON_UT
> > 
> > Kill the #ifdef if you're not actually going to make this a Kconfig.
> > Same elsewhere.
> > 

I will remove CONFIG_MTK_DIP_COMMON_UT and the related codes in the next patch.

> > > +
> > > +static void handle_ctrl_common_util_ut_set_debug_mode
> > > +	(struct v4l2_ctrl *ctrl)
> > > +{
> > > +	struct mtk_dip_ctx *dev_ctx =
> > > +		container_of(ctrl->handler, struct mtk_dip_ctx, ctrl_handler);
> > > +	dev_ctx->mode = ctrl->val;
> > > +	dev_dbg(&dev_ctx->pdev->dev, "Set ctx(id = %d) mode to %d\n",
> > > +		dev_ctx->ctx_id, dev_ctx->mode);
> > > +}
> > > +
> > > +static const struct v4l2_ctrl_config mtk_dip_mode_config = {
> > > +	.ops	= &mtk_dip_ctx_ctrl_ops,
> > > +	.id	= V4L2_CID_PRIVATE_SET_CTX_MODE_NUM,
> > > +	.name	= "MTK ISP UNIT TEST CASE",
> > > +	.type	= V4L2_CTRL_TYPE_INTEGER,
> > > +	.min	= 0,
> > > +	.max	= 65535,
> > > +	.step	= 1,
> > > +	.def	= 0,
> > > +	.flags	= V4L2_CTRL_FLAG_SLIDER | V4L2_CTRL_FLAG_EXECUTE_ON_WRITE,
> > > +};
> > > +#endif /* CONFIG_MTK_DIP_COMMON_UT */
> > > +
> > > +static int mtk_dip_ctx_s_ctrl(struct v4l2_ctrl *ctrl)
> > > +{
> > > +	switch (ctrl->id) {
> > > +	#ifdef CONFIG_MTK_DIP_COMMON_UT
> > > +	case V4L2_CID_PRIVATE_SET_CTX_MODE_NUM:
> > > +		handle_ctrl_common_util_ut_set_debug_mode(ctrl);
> > > +		break;
> > > +	#endif /* CONFIG_MTK_DIP_COMMON_UT */
> > > +	default:
> > > +			break;
> > > +	}
> > > +	return 0;
> > > +}
> > > +
> > 
> > ...
> > 
> > > diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c
> > > new file mode 100644
> > > index 0000000..c735919
> > > --- /dev/null
> > > +++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c
> > > @@ -0,0 +1,1643 @@
> > ...
> > 
> > > +#ifdef MTK_DIP_CTX_DIP_V4L2_UT
> > 
> > What is this #ifdef'ery? I don't see MTK_DIP_CTX_DIP_V4L2_UT anywhere.
> > 

MTK_DIP_CTX_DIP_V4L2_UT is only used for our internal test. I will also
remove it in the next patch.


> > > +static int check_and_refill_dip_ut_start_ipi_param
> > > +	(struct img_ipi_frameparam *ipi_param,
> > > +	 struct mtk_dip_ctx_buffer *ctx_buf_in,
> > > +	 struct mtk_dip_ctx_buffer *ctx_buf_out)
> > > +{
> > > +	/* Check the buffer size information from user space */
> > > +	int ret = 0;
> > > +	unsigned char *buffer_ptr = NULL;
> > > +	const unsigned int src_width = 3264;
> > ...
> > 
> > > diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c
> > > new file mode 100644
> > > index 0000000..b425031
> > > --- /dev/null
> > > +++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c
> > > @@ -0,0 +1,1000 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2018 Mediatek Corporation.
> > > + * Copyright (c) 2017 Intel Corporation.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License version
> > > + * 2 as published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * MTK_DIP-v4l2 is highly based on Intel IPU 3 chrome driver
> > > + *
> > > + */
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/pm_runtime.h>
> > > +#include <linux/videodev2.h>
> > > +#include <media/v4l2-ioctl.h>
> > > +#include <media/videobuf2-dma-contig.h>
> > > +#include <media/v4l2-subdev.h>
> > > +#include <media/v4l2-event.h>
> > > +#include <linux/device.h>
> > > +#include <linux/platform_device.h>
> > > +
> > > +#include "mtk_dip-dev.h"
> > > +#include "mtk_dip-v4l2-util.h"
> > > +
> > > +static u32 mtk_dip_node_get_v4l2_cap
> > > +	(struct mtk_dip_ctx_queue *node_ctx);
> > > +
> > > +static int mtk_dip_videoc_s_meta_fmt(struct file *file,
> > > +				     void *fh, struct v4l2_format *f);
> > > +
> > > +static int mtk_dip_subdev_open(struct v4l2_subdev *sd,
> > > +			       struct v4l2_subdev_fh *fh)
> > > +{
> > > +	struct mtk_dip_dev *isp_dev = mtk_dip_subdev_to_dev(sd);
> > > +
> > > +	isp_dev->ctx.fh = fh;
> > > +
> > > +	return mtk_dip_ctx_open(&isp_dev->ctx);
> > > +}
> > > +
> > > +static int mtk_dip_subdev_close(struct v4l2_subdev *sd,
> > > +				struct v4l2_subdev_fh *fh)
> > > +{
> > > +	struct mtk_dip_dev *isp_dev = mtk_dip_subdev_to_dev(sd);
> > > +
> > > +	return mtk_dip_ctx_release(&isp_dev->ctx);
> > > +}
> > > +
> > > +static int mtk_dip_subdev_s_stream(struct v4l2_subdev *sd,
> > > +				   int enable)
> > > +{
> > > +	int ret = 0;
> > > +
> > > +	struct mtk_dip_dev *isp_dev = mtk_dip_subdev_to_dev(sd);
> > > +
> > > +	if (enable) {
> > > +		ret = mtk_dip_ctx_streamon(&isp_dev->ctx);
> > > +
> > > +		if (!ret)
> > > +			ret = mtk_dip_dev_queue_buffers
> > > +				(mtk_dip_ctx_to_dev(&isp_dev->ctx), 1);
> > > +		if (ret)
> > > +			pr_err("failed to queue initial buffers (%d)", ret);
> > > +	}	else {
> > > +		ret = mtk_dip_ctx_streamoff(&isp_dev->ctx);
> > > +	}
> > > +
> > > +	if (!ret)
> > > +		isp_dev->mem2mem2.streaming = enable;
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +int mtk_dip_subdev_subscribe_event(struct v4l2_subdev *subdev,
> > > +				   struct v4l2_fh *fh,
> > > +				   struct v4l2_event_subscription *sub)
> > 
> > Should be static.

I got it.

> > 
> > > +{
> > > +	pr_info("sub type(%x)", sub->type);
> > 
> > I feel like you have this problem in other places too: this definitely
> > shouldn't be at KERN_INFO level. It seems a bit excessive anyway.

I will use KERN_DEBUG instead and check the same problem in other places.

> > 
> > > +	if (sub->type != V4L2_EVENT_PRIVATE_START &&
> > > +	    sub->type != V4L2_EVENT_MTK_DIP_FRAME_DONE)
> > > +		return -EINVAL;
> > > +
> > > +	return v4l2_event_subscribe(fh, sub, 0, NULL);
> > > +}
> > > +
> > > +int mtk_dip_subdev_unsubscribe_event(struct v4l2_subdev *subdev,
> > > +				     struct v4l2_fh *fh,
> > 
> > Static.
> > 

I got it.

> > > +	struct v4l2_event_subscription *sub)
> > > +{
> > > +	return v4l2_event_unsubscribe(fh, sub);
> > > +}
> > > +
> > > +static int mtk_dip_link_setup(struct media_entity *entity,
> > > +			      const struct media_pad *local,
> > > +	const struct media_pad *remote, u32 flags)
> > > +{
> > > +	struct mtk_dip_mem2mem2_device *m2m2 =
> > > +			container_of(entity,
> > > +				     struct mtk_dip_mem2mem2_device,
> > > +				     subdev.entity);
> > > +	struct mtk_dip_dev *isp_dev =
> > > +		container_of(m2m2, struct mtk_dip_dev, mem2mem2);
> > > +
> > > +	u32 pad = local->index;
> > > +
> > > +	dev_dbg(&isp_dev->pdev->dev,
> > > +		"link setup: %d --> %d\n", pad, remote->index);
> > > +
> > > +	WARN_ON(entity->obj_type != MEDIA_ENTITY_TYPE_V4L2_SUBDEV);
> > > +
> > > +	WARN_ON(pad >= m2m2->num_nodes);
> > > +
> > > +	m2m2->nodes[pad].enabled = !!(flags & MEDIA_LNK_FL_ENABLED);
> > > +
> > > +	/* queue_enable can be phase out in the future since */
> > > +	/* we don't have internal queue of each node in */
> > > +	/* v4l2 common module */
> > > +	isp_dev->queue_enabled[pad] = m2m2->nodes[pad].enabled;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void mtk_dip_vb2_buf_queue(struct vb2_buffer *vb)
> > > +{
> > > +	struct mtk_dip_mem2mem2_device *m2m2 = vb2_get_drv_priv(vb->vb2_queue);
> > > +
> > > +	struct mtk_dip_dev *mtk_dip_dev = mtk_dip_m2m_to_dev(m2m2);
> > > +
> > > +	struct device *dev = &mtk_dip_dev->pdev->dev;
> > > +
> > > +	struct mtk_dip_dev_buffer *buf = NULL;
> > > +
> > > +	struct vb2_v4l2_buffer *v4l2_buf = NULL;
> > > +
> > > +	struct mtk_dip_dev_video_device *node =
> > > +		mtk_dip_vbq_to_isp_node(vb->vb2_queue);
> > > +
> > > +	int queue = mtk_dip_dev_get_queue_id_of_dev_node(mtk_dip_dev, node);
> > 
> > You've got a lot of extra blank lines in here.
> > 

I will remove them in the next patch.

> > > +
> > > +	dev_dbg(dev,
> > > +		"queue vb2_buf: Node(%s) queue id(%d)\n",
> > > +		node->name,
> > > +		queue);
> > > +
> > > +	if (queue < 0) {
> > > +		dev_err(m2m2->dev, "Invalid mtk_dip_dev node.\n");
> > > +		return;
> > > +	}
> > > +
> > > +	if (mtk_dip_dev->ctx.mode == MTK_DIP_CTX_MODE_DEBUG_BYPASS_ALL) {
> > > +		dev_dbg(m2m2->dev, "By pass mode, just loop back the buffer\n");
> > > +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> > > +		return;
> > > +	}
> > > +
> > > +	if (!vb)
> > > +		pr_err("VB can't be null\n");
> > > +
> > > +	buf = mtk_dip_vb2_buf_to_dev_buf(vb);
> > > +
> > > +	if (!buf)
> > > +		pr_err("buf can't be null\n");
> > > +
> > > +	v4l2_buf = to_vb2_v4l2_buffer(vb);
> > > +
> > > +	if (!v4l2_buf)
> > > +		pr_err("v4l2_buf can't be null\n");
> > > +
> > > +	mutex_lock(&mtk_dip_dev->lock);
> > > +
> > > +	/* the dma address will be filled in later frame buffer handling*/
> > > +	mtk_dip_ctx_buf_init(&buf->ctx_buf, queue, (dma_addr_t)0);
> > > +
> > > +	/* Added the buffer into the tracking list */
> > > +	list_add_tail(&buf->m2m2_buf.list,
> > > +		      &m2m2->nodes[node - m2m2->nodes].buffers);
> > > +	mutex_unlock(&mtk_dip_dev->lock);
> > > +
> > > +	/* Enqueue the buffer */
> > > +	if (mtk_dip_dev->mem2mem2.streaming) {
> > > +		dev_dbg(dev, "%s: mtk_dip_dev_queue_buffers\n",
> > > +			node->name);
> > > +		mtk_dip_dev_queue_buffers(mtk_dip_dev, 0);
> > > +	}
> > > +}
> > ...
> > 
> > > diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c
> > > new file mode 100644
> > > index 0000000..ffdc45e
> > > --- /dev/null
> > > +++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c
> > > @@ -0,0 +1,292 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (c) 2018 MediaTek Inc.
> > > + * Author: Frederic Chen <frederic.chen@mediatek.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +#include <linux/device.h>
> > > +#include <linux/platform_device.h>
> > > +#include "mtk_dip-ctx.h"
> > > +#include "mtk_dip.h"
> > > +#include "mtk_dip-v4l2.h"
> > > +#include "mtk-mdp3-regs.h"
> > > +
> > > +#define MTK_DIP_DEV_DIP_MEDIA_MODEL_NAME "MTK-ISP-DIP-V4L2"
> > > +#define MTK_DIP_DEV_DIP_PREVIEW_NAME \
> > > +	MTK_DIP_DEV_DIP_MEDIA_MODEL_NAME
> > > +#define MTK_DIP_DEV_DIP_CAPTURE_NAME "MTK-ISP-DIP-CAP-V4L2"
> > > +
> > > +#ifdef MTK_DIP_CTX_DIP_V4L2_UT
> > > +#include "mtk_dip-dev-ctx-dip-test.h"
> > 
> > The above macros was never defined, and this header doesn't exist.
> > Please remove.
> > 

I will remove them in the next patch.

> > > +#endif
> > > +
> > 
> > ...
> > 
> > > +int mtk_dip_ctx_dip_v4l2_init(struct platform_device *pdev,
> > > +			      struct mtk_dip_dev *isp_preview_dev,
> > > +	struct mtk_dip_dev *isp_capture_dev)
> > > +{
> > > +	struct media_device *media_dev;
> > > +	struct v4l2_device *v4l2_dev;
> > > +	struct v4l2_ctrl_handler *ctrl_handler;
> > > +	int ret = 0;
> > > +
> > > +	/* initialize the v4l2 common part */
> > > +	dev_info(&pdev->dev, "init v4l2 common part: dev=%llx\n",
> > > +		 (unsigned long long)&pdev->dev);
> > > +
> > > +	media_dev = &isp_preview_dev->media_dev;
> > > +	v4l2_dev = &isp_preview_dev->v4l2_dev;
> > > +	ctrl_handler = &isp_preview_dev->ctx.ctrl_handler;
> > > +
> > > +	ret = mtk_dip_media_register(&pdev->dev,
> > > +				     media_dev,
> > > +		MTK_DIP_DEV_DIP_MEDIA_MODEL_NAME);
> > > +
> > > +	ret = mtk_dip_v4l2_register(&pdev->dev,
> > > +				    media_dev,
> > > +		v4l2_dev,
> > > +		ctrl_handler);
> > > +
> > > +	dev_info(&pdev->dev, "init v4l2 preview part\n");
> > > +	ret = mtk_dip_dev_core_init_ext(pdev,
> > > +					isp_preview_dev,
> > > +					&mtk_dip_ctx_desc_dip_preview,
> > > +		media_dev, v4l2_dev);
> > > +
> > > +	if (ret)
> > > +		dev_err(&pdev->dev, "Preview v4l2 part init failed: %d\n", ret);
> > > +
> > > +	dev_info(&pdev->dev, "init v4l2 capture part\n");
> > > +
> > > +	ret = mtk_dip_dev_core_init_ext(pdev,
> > > +					isp_capture_dev,
> > > +					&mtk_dip_ctx_desc_dip_capture,
> > > +		media_dev, v4l2_dev);
> > > +
> > > +	if (ret)
> > > +		dev_err(&pdev->dev, "Capture v4l2 part init failed: %d\n", ret);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +/* MTK ISP context initialization */
> > > +int mtk_dip_ctx_dip_preview_init(struct mtk_dip_ctx *preview_ctx)
> > > +{
> > > +	preview_ctx->ctx_id = MTK_DIP_CTX_P2_ID_PREVIEW;
> > > +
> > > +	/* Initialize main data structure */
> > > +	mtk_dip_ctx_core_queue_setup(preview_ctx, &preview_queues_setting);
> > > +
> > > +	return mtk_dip_ctx_core_steup(preview_ctx,
> > > +		&mtk_dip_ctx_dip_preview_setting);
> > > +}
> > > +EXPORT_SYMBOL_GPL(mtk_dip_ctx_dip_preview_init);
> > > +
> > > +/* MTK ISP context initialization */
> > > +int mtk_dip_ctx_dip_capture_init(struct mtk_dip_ctx *capture_ctx)
> > > +{
> > > +	capture_ctx->ctx_id =  MTK_DIP_CTX_P2_ID_CAPTURE;
> > > +	/* Initialize main data structure */
> > > +	mtk_dip_ctx_core_queue_setup(capture_ctx, &capture_queues_setting);
> > > +
> > > +	return mtk_dip_ctx_core_steup(capture_ctx,
> > > +		&mtk_dip_ctx_dip_capture_setting);
> > > +}
> > > +EXPORT_SYMBOL_GPL(mtk_dip_ctx_dip_capture_init);
> > 
> > ...
> > 
> > > diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c
> > > new file mode 100644
> > > index 0000000..3569c7c
> > > --- /dev/null
> > > +++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c
> > > @@ -0,0 +1,1385 @@
> > > +// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
> > > +/*
> > > + * Copyright (c) 2018 MediaTek Inc.
> > > + * Author: Holmes Chiou <holmes.chiou@mediatek.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +#include <linux/of_device.h>
> > > +#include <linux/module.h>
> > > +#include <linux/device.h>
> > > +#include <linux/kthread.h> /* thread functions */
> > > +#include <linux/pm_runtime.h>
> > > +#include <linux/dma-iommu.h>
> > > +#include <linux/spinlock.h>
> > > +#include <linux/slab.h> /* kzalloc and kfree */
> > > +
> > > +#include "mtk_vpu.h"
> > > +#include "mtk-mdp3-cmdq.h"
> > > +
> > > +#include "mtk_dip-dev.h"
> > > +#include "mtk_dip.h"
> > > +#include "mtk_dip-core.h"
> > > +#include "mtk_dip-v4l2.h"
> > > +
> > > +#define DIP_DEV_NAME		"camera-dip"
> > > +
> > > +#define DIP_COMPOSER_THREAD_TIMEOUT     (16U)
> > > +#define DIP_COMPOSING_WQ_TIMEOUT	(16U)
> > > +#define DIP_COMPOSING_MAX_NUM		(3)
> > > +#define DIP_FLUSHING_WQ_TIMEOUT		(16U)
> > > +
> > > +#define DIP_MAX_ERR_COUNT		(188U)
> > > +
> > > +#define DIP_FRM_SZ		(76 * 1024)
> > > +#define DIP_SUB_FRM_SZ		(16 * 1024)
> > > +#define DIP_TUNING_SZ		(32 * 1024)
> > > +#define DIP_COMP_SZ		(24 * 1024)
> > > +#define DIP_FRAMEPARAM_SZ	(4 * 1024)
> > > +
> > > +#define DIP_TUNING_OFFSET	(DIP_SUB_FRM_SZ)
> > > +#define DIP_COMP_OFFSET		(DIP_TUNING_OFFSET + DIP_TUNING_SZ)
> > > +#define DIP_FRAMEPARAM_OFFSET	(DIP_COMP_OFFSET + DIP_COMP_SZ)
> > > +
> > > +#define DIP_SUB_FRM_DATA_NUM	(32)
> > > +
> > > +#define DIP_SCP_WORKINGBUF_OFFSET	(5 * 1024 * 1024)
> > > +
> > > +#define DIP_GET_ID(x)			(((x) & 0xffff0000) >> 16)
> > > +
> > > +static const struct of_device_id dip_of_ids[] = {
> > > +	/* Remider: Add this device node manually in .dtsi */
> > > +	{ .compatible = "mediatek,mt8183-dip", },
> > > +	{}
> > > +};
> > 
> > Please add:
> > 
> > MODULE_DEVICE_TABLE(of, dip_of_ids);
> > 

I see. I will add this line in the next patch.

> > > +
> > > +static void call_mtk_dip_ctx_finish(struct dip_device *dip_dev,
> > > +				    struct img_ipi_frameparam *iparam);
> > > +
> > > +static struct img_frameparam *dip_create_framejob(int sequence)
> > > +{
> > > +	struct dip_frame_job *fjob = NULL;
> > > +
> > > +	fjob = kzalloc(sizeof(*fjob), GFP_ATOMIC);
> > > +
> > > +	if (!fjob)
> > > +		return NULL;
> > > +
> > > +	fjob->sequence = sequence;
> > > +
> > > +	return &fjob->fparam;
> > > +}
> > > +
> > > +static void dip_free_framejob(struct img_frameparam *fparam)
> > > +{
> > > +	struct dip_frame_job *fjob = NULL;
> > > +
> > > +	fjob = mtk_dip_fparam_to_job(fparam);
> > > +
> > > +	/* to avoid use after free issue */
> > > +	fjob->sequence = -1;
> > > +
> > > +	kfree(fjob);
> > > +}
> > > +
> > > +static void dip_enable_ccf_clock(struct dip_device *dip_dev)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = pm_runtime_get_sync(dip_dev->larb_dev);
> > > +	if (ret < 0)
> > > +		dev_err(&dip_dev->pdev->dev, "cannot get smi larb clock\n");
> > > +
> > > +	ret = clk_prepare_enable(dip_dev->dip_clk.DIP_IMG_LARB5);
> > > +	if (ret)
> > > +		dev_err(&dip_dev->pdev->dev,
> > > +			"cannot prepare and enable DIP_IMG_LARB5 clock\n");
> > > +
> > > +	ret = clk_prepare_enable(dip_dev->dip_clk.DIP_IMG_DIP);
> > > +	if (ret)
> > > +		dev_err(&dip_dev->pdev->dev,
> > > +			"cannot prepare and enable DIP_IMG_DIP clock\n");
> > > +}
> > > +
> > > +static void dip_disable_ccf_clock(struct dip_device *dip_dev)
> > > +{
> > > +	clk_disable_unprepare(dip_dev->dip_clk.DIP_IMG_DIP);
> > > +	clk_disable_unprepare(dip_dev->dip_clk.DIP_IMG_LARB5);
> > > +	pm_runtime_put_sync(dip_dev->larb_dev);
> > > +}
> > > +
> > > +static int dip_send(struct platform_device *pdev, enum ipi_id id,
> > > +		    void *buf, unsigned int  len, unsigned int wait)
> > > +{
> > > +	vpu_ipi_send_sync_async(pdev, id, buf, len, wait);
> > > +	return 0;
> > > +}
> > > +
> > > +static void call_mtk_dip_ctx_finish(struct dip_device *dip_dev,
> > > +				    struct img_ipi_frameparam *iparam)
> > > +{
> > > +	struct mtk_dip_ctx_finish_param fparam;
> > > +	struct mtk_isp_dip_drv_data *drv_data;
> > > +	struct mtk_dip_ctx *dev_ctx;
> > > +	int ctx_id = 0;
> > > +	int r = 0;
> > > +
> > > +	if (!dip_dev) {
> > > +		pr_err("Can't update buffer status, dip_dev can't be NULL\n");
> > > +		return;
> > > +	}
> > > +
> > > +	if (!iparam) {
> > > +		dev_err(&dip_dev->pdev->dev,
> > > +			"%s: iparam can't be NULL\n", __func__);
> > > +		return;
> > > +	}
> > > +
> > > +	drv_data = dip_dev_to_drv(dip_dev);
> > > +
> > > +	frame_param_ipi_to_ctx(iparam, &fparam);
> > > +	ctx_id = MTK_DIP_GET_CTX_ID_FROM_SEQUENCE(fparam.frame_id);
> > > +
> > > +	if (ctx_id == MTK_DIP_CTX_P2_ID_PREVIEW) {
> > > +		dev_ctx = &drv_data->isp_preview_dev.ctx;
> > > +	} else if (ctx_id == MTK_DIP_CTX_P2_ID_CAPTURE) {
> > > +		dev_ctx = &drv_data->isp_capture_dev.ctx;
> > > +	} else {
> > > +		dev_err(&dip_dev->pdev->dev,
> > > +			"unknown ctx id: %d\n", ctx_id);
> > > +		return;
> > > +	}
> > > +
> > > +	r = mtk_dip_ctx_core_job_finish(dev_ctx, &fparam);
> > > +
> > > +	if (r)
> > > +		dev_err(&dip_dev->pdev->dev, "finish op failed: %d\n",
> > > +			r);
> > > +	dev_dbg(&dip_dev->pdev->dev, "Ready to return buffers: CTX(%d), Frame(%d)\n",
> > > +		ctx_id, fparam.frame_id);
> > > +}
> > > +
> > > +static void mtk_dip_notify(void *data)
> > > +{
> > > +	struct dip_device	*dip_dev;
> > > +	struct mtk_dip_hw_ctx	*dip_ctx;
> > > +	struct img_frameparam	*framejob;
> > > +	struct dip_user_id	*user_id;
> > > +	struct dip_subframe	*buf, *tmpbuf;
> > > +	struct img_ipi_frameparam	*frameparam;
> > > +	u32 num;
> > > +	bool found = false;
> > > +
> > > +	frameparam = (struct img_ipi_frameparam *)data;
> > > +	dip_ctx = (struct mtk_dip_hw_ctx *)frameparam->drv_data;
> > > +	dip_dev = container_of(dip_ctx, struct dip_device, dip_ctx);
> > > +	framejob = container_of(frameparam,
> > > +				struct img_frameparam,
> > > +				frameparam);
> > > +
> > > +	if (frameparam->state == FRAME_STATE_HW_TIMEOUT) {
> > > +		dip_send(dip_ctx->vpu_pdev, IPI_DIP_FRAME,
> > > +			 (void *)frameparam, sizeof(*frameparam), 0);
> > > +		dev_err(&dip_dev->pdev->dev, "frame no(%d) HW timeout\n",
> > > +			frameparam->frame_no);
> > > +	}
> > > +
> > > +	mutex_lock(&dip_ctx->dip_usedbufferlist.queuelock);
> > > +	list_for_each_entry_safe(buf, tmpbuf,
> > > +				 &dip_ctx->dip_usedbufferlist.queue,
> > > +				 list_entry) {
> > > +		if (buf->buffer.pa == frameparam->subfrm_data.pa) {
> > > +			list_del(&buf->list_entry);
> > > +			dip_ctx->dip_usedbufferlist.queue_cnt--;
> > > +			found = true;
> > > +			dev_dbg(&dip_dev->pdev->dev,
> > > +				"Find used buffer (%x)\n", buf->buffer.pa);
> > > +			break;
> > > +		}
> > > +	}
> > > +	mutex_unlock(&dip_ctx->dip_usedbufferlist.queuelock);
> > > +
> > > +	if (!found) {
> > > +		dev_err(&dip_dev->pdev->dev,
> > > +			"frame_no(%d) buffer(%x) used buffer count(%d)\n",
> > > +			frameparam->frame_no, frameparam->subfrm_data.pa,
> > > +			dip_ctx->dip_usedbufferlist.queue_cnt);
> > > +
> > > +		frameparam->state = FRAME_STATE_ERROR;
> > > +
> > > +	} else {
> > > +		mutex_lock(&dip_ctx->dip_freebufferlist.queuelock);
> > > +		list_add_tail(&buf->list_entry,
> > > +			      &dip_ctx->dip_freebufferlist.queue);
> > > +		dip_ctx->dip_freebufferlist.queue_cnt++;
> > > +		mutex_unlock(&dip_ctx->dip_freebufferlist.queuelock);
> > > +
> > > +		frameparam->state = FRAME_STATE_DONE;
> > > +	}
> > > +
> > > +	call_mtk_dip_ctx_finish(dip_dev, frameparam);
> > > +
> > > +	found = false;
> > > +	mutex_lock(&dip_ctx->dip_useridlist.queuelock);
> > > +	list_for_each_entry(user_id,
> > > +			    &dip_ctx->dip_useridlist.queue,
> > > +			    list_entry) {
> > > +		if (DIP_GET_ID(frameparam->index) == user_id->id) {
> > > +			user_id->num--;
> > > +			dev_dbg(&dip_dev->pdev->dev,
> > > +				"user_id(%x) is found, and cnt: %d\n",
> > > +				user_id->id, user_id->num);
> > > +			found = true;
> > > +			break;
> > > +		}
> > > +	}
> > > +	mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > +	wake_up(&dip_ctx->flushing_wq);
> > > +	dev_dbg(&dip_dev->pdev->dev,
> > > +		"frame_no(%d) is finished\n", framejob->frameparam.frame_no);
> > > +	dip_free_framejob(framejob);
> > > +
> > > +	num = atomic_dec_return(&dip_ctx->num_running);
> > > +	dev_dbg(&dip_dev->pdev->dev, "Running count: %d\n", num);
> > > +}
> > > +
> > > +static void mdp_cb_worker(struct work_struct *work)
> > > +{
> > > +	struct mtk_mdpcb_work *mdpcb_work;
> > > +
> > > +	mdpcb_work = container_of(work, struct mtk_mdpcb_work, frame_work);
> > > +	mtk_dip_notify(mdpcb_work->frameparams);
> > > +	kfree(mdpcb_work);
> > > +}
> > > +
> > > +static struct img_ipi_frameparam *convert_to_fparam(struct cmdq_cb_data *data)
> > > +{
> > > +	struct device *dev = NULL;
> > 
> > Every use of dev_err() in this function is wrong, since you're
> > guaranteed to be NULL. Either come up with some better way to report
> > device errors using the pointers you have, or else just switch to
> > pr_err().
> > 

I see. I would like to switch to pr_err().

> > > +	struct dip_device *dip_dev = NULL;
> > > +	struct dip_frame_job *fjob = NULL;
> > > +	struct img_ipi_frameparam *ipi_fparam = NULL;
> > > +
> > > +	if (!data) {
> > > +		dev_err(dev, "DIP got NULL in cmdq_cb_data,%s\n",
> > > +			__func__);
> > > +		return NULL;
> > > +	}
> > > +
> > > +	if (data->sta != CMDQ_CB_NORMAL) {
> > > +		dev_warn(dev, "DIP got CMDQ CB (%d) without CMDQ_CB_NORMAL\n",
> > > +			 data->sta);
> > > +	}
> > > +
> > > +	if (!data->data) {
> > > +		dev_err(dev, "DIP got NULL data in cmdq_cb_data,%s\n",
> > > +			__func__);
> > > +		return NULL;
> > > +	}
> > > +
> > > +	fjob = mtk_dip_ipi_fparam_to_job(data->data);
> > > +
> > > +	if (fjob->sequence == -1) {
> > > +		dev_err(dev, "Invalid cmdq_cb_data(%llx)\n",
> > > +			(unsigned long long)data);
> > > +		ipi_fparam = NULL;
> > > +	} else {
> > > +		ipi_fparam = &fjob->fparam.frameparam;
> > > +		dip_dev = dip_hw_ctx_to_dev((void *)ipi_fparam->drv_data);
> > > +		dev = &dip_dev->pdev->dev;
> > > +	}
> > > +
> > > +	dev_dbg(dev, "framejob(0x%llx,seq:%d):\n",
> > > +		(unsigned long long)fjob, fjob->sequence);
> > > +	dev_dbg(dev, "idx(%d),no(%d),s(%d),n_in(%d),n_out(%d),drv(%llx)\n",
> > > +		fjob->fparam.frameparam.index,
> > > +		fjob->fparam.frameparam.frame_no,
> > > +		fjob->fparam.frameparam.state,
> > > +		fjob->fparam.frameparam.num_inputs,
> > > +		fjob->fparam.frameparam.num_outputs,
> > > +		(unsigned long long)fjob->fparam.frameparam.drv_data
> > > +	);
> > > +
> > > +	return ipi_fparam;
> > > +}
> > > +
> > > +/* Maybe in IRQ context of cmdq */
> > > +void dip_mdp_cb_func(struct cmdq_cb_data data)
> > 
> > Make this static.
> > 

I got it.

> > > +{
> > > +	struct img_ipi_frameparam *frameparam;
> > > +	struct mtk_dip_hw_ctx *dip_ctx;
> > > +	struct mtk_mdpcb_work *mdpcb_work;
> > > +
> > > +	frameparam = convert_to_fparam(&data);
> > > +
> > > +	if (!frameparam) {
> > > +		dev_err(NULL, "%s return due to invalid cmdq_cb_data(%llx)",
> > 
> > Don't directly pass NULL to dev_err(). Just use pr_err() or similar.
> >

I will use pr_err() in the next patch.


> > > +			__func__, &data);
> > > +		return;
> > > +	}
> > > +
> > > +	dip_ctx = (struct mtk_dip_hw_ctx *)frameparam->drv_data;
> > > +
> > > +	mdpcb_work = kzalloc(sizeof(*mdpcb_work), GFP_ATOMIC);
> > > +	WARN_ONCE(!mdpcb_work, "frame_no(%d) is lost", frameparam->frame_no);
> > > +	if (!mdpcb_work)
> > > +		return;
> > > +
> > > +	INIT_WORK(&mdpcb_work->frame_work, mdp_cb_worker);
> > > +	mdpcb_work->frameparams = frameparam;
> > > +	if (data.sta != CMDQ_CB_NORMAL)
> > > +		mdpcb_work->frameparams->state = FRAME_STATE_HW_TIMEOUT;
> > > +
> > > +	queue_work(dip_ctx->mdpcb_workqueue, &mdpcb_work->frame_work);
> > > +}
> > > +
> > > +static void dip_vpu_handler(void *data, unsigned int len, void *priv)
> > > +{
> > > +	struct img_frameparam *framejob;
> > > +	struct img_ipi_frameparam *frameparam;
> > > +	struct mtk_dip_hw_ctx *dip_ctx;
> > > +	struct dip_device *dip_dev;
> > > +	unsigned long flags;
> > > +	u32 num;
> > > +
> > > +	WARN_ONCE(!data, "%s is failed due to NULL data\n", __func__);
> > > +	if (!data)
> > 
> > You can combine these lines:
> > 
> > 	
> > 	if (WARN_ONCE(!data, "%s is failed due to NULL data\n", __func__))
> > 		return;
> > 

I got it. I will combine them.

> > > +		return;
> > > +
> > > +	frameparam = (struct img_ipi_frameparam *)data;
> > > +
> > > +	framejob = dip_create_framejob(frameparam->index);
> > > +	WARN_ONCE(!framejob, "frame_no(%d) is lost", frameparam->frame_no);
> > > +	if (!framejob)
> > 
> > Same here.
> > 

I will also combine them here. 

> > > +		return;
> > > +
> > > +	dip_ctx = (struct mtk_dip_hw_ctx *)frameparam->drv_data;
> > > +	dip_dev = container_of(dip_ctx, struct dip_device, dip_ctx);
> > > +
> > > +	wake_up(&dip_ctx->composing_wq);
> > > +	memcpy(&framejob->frameparam, data, sizeof(framejob->frameparam));
> > > +	num = atomic_dec_return(&dip_ctx->num_composing);
> > > +
> > > +	spin_lock_irqsave(&dip_ctx->dip_gcejoblist.queuelock, flags);
> > > +	list_add_tail(&framejob->list_entry, &dip_ctx->dip_gcejoblist.queue);
> > > +	dip_ctx->dip_gcejoblist.queue_cnt++;
> > > +	spin_unlock_irqrestore(&dip_ctx->dip_gcejoblist.queuelock, flags);
> > > +
> > > +	dev_dbg(&dip_dev->pdev->dev,
> > > +		"frame_no(%d) is back, composing num: %d\n",
> > > +		frameparam->frame_no, num);
> > > +
> > > +	wake_up(&dip_ctx->dip_runner_thread.wq);
> > > +}
> > > +
> > 
> > ...
> > > +static int dip_runner_func(void *data)
> > > +{
> > 
> > ...
> > 
> > > +
> > > +			mdp_cmdq_sendtask
> > 
> > I don't see this defined anywhere?
> > 

mdp_cmdq_sendtask() is defined in MDP 3 driver. We will send
the RFC patch for Mediatek MDP 3 driver by 2/28.

> > > +				(dip_ctx->mdp_pdev,
> > > +				 (struct img_config *)
> > > +					framejob->frameparam.config_data.va,
> > > +				 &framejob->frameparam, NULL, false,
> > > +				 dip_mdp_cb_func,
> > > +				 (void *)&framejob->frameparam);
> > > +
> > ...
> > > +	return 0;
> > > +}
> > > +
> > > +static void dip_submit_worker(struct work_struct *work)
> > > +{
> > > +	struct mtk_dip_submit_work *dip_submit_work =
> > > +		container_of(work, struct mtk_dip_submit_work, frame_work);
> > > +
> > > +	struct mtk_dip_hw_ctx  *dip_ctx = dip_submit_work->dip_ctx;
> > > +	struct mtk_dip_work *dip_work;
> > > +	struct dip_device *dip_dev;
> > > +	struct dip_subframe *buf;
> > > +	u32 len, num;
> > > +	int ret;
> > > +
> > > +	dip_dev = container_of(dip_ctx, struct dip_device, dip_ctx);
> > > +	num  = atomic_read(&dip_ctx->num_composing);
> > > +
> > > +	mutex_lock(&dip_ctx->dip_worklist.queuelock);
> > > +	dip_work = list_first_entry(&dip_ctx->dip_worklist.queue,
> > > +				    struct mtk_dip_work, list_entry);
> > > +	mutex_unlock(&dip_ctx->dip_worklist.queuelock);
> > 
> > I see you grab the head of the list here, but then you release the lock.
> > Then you later assume that reference is still valid, throughout this
> > function.
> > 
> > That's usually true, because you only remove/delete entries from this
> > list within this same workqueue (at the end of this function). But it's
> > not true in dip_release_context() (which doesn't even grab the lock,
> > BTW).
> > 
> > I think there could be several ways to solve this, but judging by how
> > this list entry is used...couldn't you just remove it from the list
> > here, while holding the lock? Then you only have to kfree() it when
> > you're done under the free_work_list label.
> > 

I see. I would like to modify the codes as following:

mutex_lock(&dip_ctx->dip_useridlist.queuelock);
dip_work->user_id->num--;
list_del(&dip_work->list_entry);
dip_ctx->dip_worklist.queue_cnt--;
len = dip_ctx->dip_worklist.queue_cnt;
mutex_unlock(&dip_ctx->dip_useridlist.queuelock);

goto free_work_list;

/* ...... */

free_work_list:
	kfree(dip_work);

> > > +
> > > +	mutex_lock(&dip_ctx->dip_useridlist.queuelock);
> > > +	if (dip_work->user_id->state == DIP_STATE_STREAMOFF) {
> > > +		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > +
> > > +		dip_work->frameparams.state = FRAME_STATE_STREAMOFF;
> > > +		call_mtk_dip_ctx_finish(dip_dev, &dip_work->frameparams);
> > > +
> > > +		mutex_lock(&dip_ctx->dip_useridlist.queuelock);
> > > +		dip_work->user_id->num--;
> > > +		dev_dbg(&dip_dev->pdev->dev,
> > > +			"user_id(%x) is streamoff and num: %d, frame_no(%d) index: %x\n",
> > > +			dip_work->user_id->id, dip_work->user_id->num,
> > > +			dip_work->frameparams.frame_no,
> > > +			dip_work->frameparams.index);
> > > +		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > +
> > > +		goto free_work_list;
> > > +	}
> > > +	mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > +
> > > +	while (num >= DIP_COMPOSING_MAX_NUM) {
> > > +		ret = wait_event_interruptible_timeout
> > > +			(dip_ctx->composing_wq,
> > > +			 (num < DIP_COMPOSING_MAX_NUM),
> > > +			 msecs_to_jiffies(DIP_COMPOSING_WQ_TIMEOUT));
> > > +
> > > +		if (ret == -ERESTARTSYS)
> > > +			dev_err(&dip_dev->pdev->dev,
> > > +				"interrupted by a signal!\n");
> > > +		else if (ret == 0)
> > > +			dev_dbg(&dip_dev->pdev->dev,
> > > +				"timeout frame_no(%d), num: %d\n",
> > > +				dip_work->frameparams.frame_no, num);
> > > +		else
> > > +			dev_dbg(&dip_dev->pdev->dev,
> > > +				"wakeup frame_no(%d), num: %d\n",
> > > +				dip_work->frameparams.frame_no, num);
> > > +
> > > +		num = atomic_read(&dip_ctx->num_composing);
> > > +	};
> > > +
> > > +	mutex_lock(&dip_ctx->dip_freebufferlist.queuelock);
> > > +	if (list_empty(&dip_ctx->dip_freebufferlist.queue)) {
> > > +		mutex_unlock(&dip_ctx->dip_freebufferlist.queuelock);
> > > +
> > > +		dev_err(&dip_dev->pdev->dev,
> > > +			"frame_no(%d) index: %x no free buffer: %d\n",
> > > +			dip_work->frameparams.frame_no,
> > > +			dip_work->frameparams.index,
> > > +			dip_ctx->dip_freebufferlist.queue_cnt);
> > > +
> > > +		/* Call callback to notify V4L2 common framework
> > > +		 * for failure of enqueue
> > > +		 */
> > > +		dip_work->frameparams.state = FRAME_STATE_ERROR;
> > > +		call_mtk_dip_ctx_finish(dip_dev, &dip_work->frameparams);
> > > +
> > > +		mutex_lock(&dip_ctx->dip_useridlist.queuelock);
> > > +		dip_work->user_id->num--;
> > > +		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
> > > +
> > > +		goto free_work_list;
> > > +	}
> > > +
> > > +	buf = list_first_entry(&dip_ctx->dip_freebufferlist.queue,
> > > +			       struct dip_subframe,
> > > +			       list_entry);
> > > +	list_del(&buf->list_entry);
> > > +	dip_ctx->dip_freebufferlist.queue_cnt--;
> > > +	mutex_unlock(&dip_ctx->dip_freebufferlist.queuelock);
> > > +
> > > +	mutex_lock(&dip_ctx->dip_usedbufferlist.queuelock);
> > > +	list_add_tail(&buf->list_entry, &dip_ctx->dip_usedbufferlist.queue);
> > > +	dip_ctx->dip_usedbufferlist.queue_cnt++;
> > > +	mutex_unlock(&dip_ctx->dip_usedbufferlist.queuelock);
> > > +
> > > +	memcpy(&dip_work->frameparams.subfrm_data,
> > > +	       &buf->buffer, sizeof(buf->buffer));
> > > +
> > > +	memset((char *)buf->buffer.va, 0, DIP_SUB_FRM_SZ);
> > > +
> > > +	memcpy(&dip_work->frameparams.config_data,
> > > +	       &buf->config_data, sizeof(buf->config_data));
> > > +
> > > +	memset((char *)buf->config_data.va, 0, DIP_COMP_SZ);
> > > +
> > > +	if (dip_work->frameparams.tuning_data.pa == 0) {
> > > +		dev_dbg(&dip_dev->pdev->dev,
> > > +			"frame_no(%d) has no tuning_data\n",
> > > +			dip_work->frameparams.frame_no);
> > > +
> > > +		memcpy(&dip_work->frameparams.tuning_data,
> > > +		       &buf->tuning_buf, sizeof(buf->tuning_buf));
> > > +
> > > +		memset((char *)buf->tuning_buf.va, 0, DIP_TUNING_SZ);
> > > +		/* When user enqueued without tuning buffer,
> > > +		 * it would use driver internal buffer.
> > > +		 * So, tuning_data.va should be 0
> > > +		 */
> > > +		dip_work->frameparams.tuning_data.va = 0;
> > > +	}
> > > +
> > > +	dip_work->frameparams.drv_data = (u64)dip_ctx;
> > > +	dip_work->frameparams.state = FRAME_STATE_COMPOSING;
> > > +
> > > +	memcpy((void *)buf->frameparam.va, &dip_work->frameparams,
> > > +	       sizeof(dip_work->frameparams));
> > > +
> > > +	dip_send(dip_ctx->vpu_pdev, IPI_DIP_FRAME,
> > > +		 (void *)&dip_work->frameparams,
> > > +		 sizeof(dip_work->frameparams), 0);
> > > +	num = atomic_inc_return(&dip_ctx->num_composing);
> > > +
> > > +free_work_list:
> > > +
> > > +	mutex_lock(&dip_ctx->dip_worklist.queuelock);
> > > +	list_del(&dip_work->list_entry);
> > > +	dip_ctx->dip_worklist.queue_cnt--;
> > > +	len = dip_ctx->dip_worklist.queue_cnt;
> > > +	mutex_unlock(&dip_ctx->dip_worklist.queuelock);
> > > +
> > > +	dev_dbg(&dip_dev->pdev->dev,
> > > +		"frame_no(%d) index: %x, worklist count: %d, composing num: %d\n",
> > > +		dip_work->frameparams.frame_no, dip_work->frameparams.index,
> > > +		len, num);
> > > +
> > > +	kfree(dip_work);
> > > +}
> > 
> > ...
> > 
> > > +int dip_open_context(struct dip_device *dip_dev)
> > 
> > Should be static.
> >

I will change it to static.

> > > +{
> > 
> > ...
> > 
> > > +}
> > > +
> > > +int dip_release_context(struct dip_device *dip_dev)
> > 
> > Should be static.
> > 

I will change it to static.

> > > +{
> > > +	u32 i = 0;
> > > +	struct dip_subframe *buf, *tmpbuf;
> > > +	struct mtk_dip_work *dip_work, *tmp_work;
> > > +	struct dip_user_id  *dip_userid, *tmp_id;
> > > +	struct mtk_dip_hw_ctx *dip_ctx;
> > > +
> > > +	dip_ctx = &dip_dev->dip_ctx;
> > > +	dev_dbg(&dip_dev->pdev->dev, "composer work queue = %d\n",
> > > +		dip_ctx->dip_worklist.queue_cnt);
> > > +
> > > +	list_for_each_entry_safe(dip_work, tmp_work,
> > > +				 &dip_ctx->dip_worklist.queue,
> > > +				 list_entry) {
> > 
> > Shouldn't you be holding the mutex for this? Or alternatively, cancel
> > any outstanding work and move the flush_workqueue()/destroy_workqueue()
> > up.
> > 
> > Similar questions for the other lists we're going through here.
> > 

We missed the mutex holding here. I would like to change the codes as following:

mutex_lock(&dip_ctx->dip_worklist.queuelock);
list_for_each_entry_safe(dip_work, tmp_work,
			 &dip_ctx->dip_worklist.queue,
			 list_entry) {
	list_del(&dip_work->list_entry);
	dip_ctx->dip_worklist.queue_cnt--;
	kfree(dip_work);
}
mutex_unlock(&dip_ctx->dip_worklist.queuelock);

I will also modify dip_useridlist and dip_ctx->dip_freebufferlist 
parts like dip_ctx->dip_worklist.

> > > +		list_del(&dip_work->list_entry);
> > > +		dev_dbg(&dip_dev->pdev->dev, "dip work frame no: %d\n",
> > > +			dip_work->frameparams.frame_no);
> > > +		kfree(dip_work);
> > > +		dip_ctx->dip_worklist.queue_cnt--;
> > > +	}
> > > +
> > > +	if (dip_ctx->dip_worklist.queue_cnt != 0)
> > > +		dev_dbg(&dip_dev->pdev->dev,
> > > +			"dip_worklist is not empty (%d)\n",
> > > +			dip_ctx->dip_worklist.queue_cnt);
> > > +
> > > +	list_for_each_entry_safe(dip_userid, tmp_id,
> > > +				 &dip_ctx->dip_useridlist.queue,
> > > +				 list_entry) {
> > > +		list_del(&dip_userid->list_entry);
> > > +		dev_dbg(&dip_dev->pdev->dev, "dip user id: %x\n",
> > > +			dip_userid->id);
> > > +		kfree(dip_userid);
> > > +		dip_ctx->dip_useridlist.queue_cnt--;
> > > +	}
> > > +
> > > +	if (dip_ctx->dip_useridlist.queue_cnt != 0)
> > > +		dev_dbg(&dip_dev->pdev->dev,
> > > +			"dip_useridlist is not empty (%d)\n",
> > > +			dip_ctx->dip_useridlist.queue_cnt);
> > > +
> > > +	flush_workqueue(dip_ctx->mdpcb_workqueue);
> > > +	destroy_workqueue(dip_ctx->mdpcb_workqueue);
> > > +	dip_ctx->mdpcb_workqueue = NULL;
> > > +
> > > +	flush_workqueue(dip_ctx->composer_wq);
> > > +	destroy_workqueue(dip_ctx->composer_wq);
> > > +	dip_ctx->composer_wq = NULL;
> > > +
> > > +	atomic_set(&dip_ctx->num_composing, 0);
> > > +	atomic_set(&dip_ctx->num_running, 0);
> > > +
> > > +	kthread_stop(dip_ctx->dip_runner_thread.thread);
> > > +	dip_ctx->dip_runner_thread.thread = NULL;
> > > +
> > > +	atomic_set(&dip_ctx->dip_user_cnt, 0);
> > > +	atomic_set(&dip_ctx->dip_stream_cnt, 0);
> > > +	atomic_set(&dip_ctx->dip_enque_cnt, 0);
> > > +
> > > +	/* All the buffer should be in the freebufferlist when release */
> > > +	list_for_each_entry_safe(buf, tmpbuf,
> > > +				 &dip_ctx->dip_freebufferlist.queue,
> > > +				 list_entry) {
> > > +		struct sg_table *sgt = &buf->table;
> > > +
> > > +		dev_dbg(&dip_dev->pdev->dev,
> > > +			"buf pa (%d): %x\n", i, buf->buffer.pa);
> > > +		dip_ctx->dip_freebufferlist.queue_cnt--;
> > > +		dma_unmap_sg_attrs(&dip_dev->pdev->dev, sgt->sgl,
> > > +				   sgt->orig_nents,
> > > +				   DMA_BIDIRECTIONAL, DMA_ATTR_SKIP_CPU_SYNC);
> > > +		sg_free_table(sgt);
> > > +		list_del(&buf->list_entry);
> > > +		kfree(buf);
> > > +		buf = NULL;
> > > +		i++;
> > > +	}
> > > +
> > > +	if (dip_ctx->dip_freebufferlist.queue_cnt != 0 &&
> > > +	    i != DIP_SUB_FRM_DATA_NUM)
> > > +		dev_err(&dip_dev->pdev->dev,
> > > +			"dip_freebufferlist is not empty (%d/%d)\n",
> > > +			dip_ctx->dip_freebufferlist.queue_cnt, i);
> > > +
> > > +	mutex_destroy(&dip_ctx->dip_useridlist.queuelock);
> > > +	mutex_destroy(&dip_ctx->dip_worklist.queuelock);
> > > +	mutex_destroy(&dip_ctx->dip_usedbufferlist.queuelock);
> > > +	mutex_destroy(&dip_ctx->dip_freebufferlist.queuelock);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > 
> > ...
> > 
> > > +static int mtk_dip_probe(struct platform_device *pdev)
> > > +{
> > > +	struct mtk_isp_dip_drv_data *dip_drv;
> > > +	struct dip_device *dip_dev;
> > > +	struct mtk_dip_hw_ctx *dip_ctx;
> > > +	struct device_node *node;
> > > +	struct platform_device *larb_pdev;
> > > +
> > > +	int ret = 0;
> > > +
> > > +	dev_info(&pdev->dev, "E. DIP driver probe.\n");
> > > +
> > > +	dip_drv = devm_kzalloc(&pdev->dev, sizeof(*dip_drv), GFP_KERNEL);
> > 
> > Need to check for NULL.
> >

I got it.

> > > +	dev_set_drvdata(&pdev->dev, dip_drv);
> > > +	dip_dev = &dip_drv->dip_dev;
> > > +
> > > +	if (!dip_dev)
> > > +		return -ENOMEM;
> > > +
> > > +	dev_info(&pdev->dev, "Created dip_dev = 0x%p\n", dip_dev);
> > > +
> > > +	dip_dev->pdev = pdev;
> > > +	dip_ctx = &dip_dev->dip_ctx;
> > > +
> > > +	node = of_parse_phandle(pdev->dev.of_node, "mediatek,larb", 0);
> > > +	if (!node) {
> > > +		dev_err(&pdev->dev, "no mediatek,larb found");
> > > +		return -EINVAL;
> > > +	}
> > > +	larb_pdev = of_find_device_by_node(node);
> > > +	if (!larb_pdev) {
> > > +		dev_err(&pdev->dev, "no mediatek,larb device found");
> > > +		return -EINVAL;
> > > +	}
> > > +	dip_dev->larb_dev = &larb_pdev->dev;
> > > +
> > > +	/*CCF: Grab clock pointer (struct clk*) */
> > 
> > Add a space before 'CCF'.
> > 

I got it.

> > > +	dip_dev->dip_clk.DIP_IMG_LARB5 = devm_clk_get(&pdev->dev,
> > > +						      "DIP_CG_IMG_LARB5");
> > > +	dip_dev->dip_clk.DIP_IMG_DIP = devm_clk_get(&pdev->dev,
> > > +						    "DIP_CG_IMG_DIP");
> > > +	if (IS_ERR(dip_dev->dip_clk.DIP_IMG_LARB5)) {
> > > +		dev_err(&pdev->dev, "cannot get DIP_IMG_LARB5 clock\n");
> > > +		return PTR_ERR(dip_dev->dip_clk.DIP_IMG_LARB5);
> > > +	}
> > > +	if (IS_ERR(dip_dev->dip_clk.DIP_IMG_DIP)) {
> > > +		dev_err(&pdev->dev, "cannot get DIP_IMG_DIP clock\n");
> > > +		return PTR_ERR(dip_dev->dip_clk.DIP_IMG_DIP);
> > > +	}
> > > +
> > > +	pm_runtime_enable(&pdev->dev);
> > > +
> > > +	atomic_set(&dip_ctx->dip_user_cnt, 0);
> > > +	atomic_set(&dip_ctx->dip_stream_cnt, 0);
> > > +	atomic_set(&dip_ctx->dip_enque_cnt, 0);
> > > +
> > > +	atomic_set(&dip_ctx->num_composing, 0);
> > > +	atomic_set(&dip_ctx->num_running, 0);
> > > +
> > > +	dip_ctx->dip_worklist.queue_cnt = 0;
> > > +
> > > +	ret = mtk_dip_ctx_dip_v4l2_init(pdev,
> > > +					&dip_drv->isp_preview_dev,
> > > +		&dip_drv->isp_capture_dev);
> > > +
> > > +	if (ret)
> > > +		dev_err(&pdev->dev, "v4l2 init failed: %d\n", ret);
> > > +
> > > +	dev_info(&pdev->dev, "X. DIP driver probe.\n");
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int mtk_dip_remove(struct platform_device *pdev)
> > > +{
> > > +	struct mtk_isp_dip_drv_data *drv_data =
> > > +		dev_get_drvdata(&pdev->dev);
> > > +
> > > +	/*  */
> > 
> > What's with the empty comments? Here and below.
> > 

I will remove them.

> > > +	if (drv_data) {
> > > +		mtk_dip_dev_core_release(pdev, &drv_data->isp_preview_dev);
> > > +		mtk_dip_dev_core_release(pdev, &drv_data->isp_capture_dev);
> > > +		dev_info(&pdev->dev, "E. %s\n", __func__);
> > 
> > Remove this line.
> > 

I will remove this line.

> > > +	}
> > > +
> > > +	pm_runtime_disable(&pdev->dev);
> > > +
> > > +	/*  */
> > > +	return 0;
> > > +}
> > > +
> > 
> > ...
> > 
> > > +static struct platform_driver mtk_dip_driver = {
> > > +	.probe   = mtk_dip_probe,
> > > +	.remove  = mtk_dip_remove,
> > > +	.driver  = {
> > > +		.name  = DIP_DEV_NAME,
> > > +		.owner = THIS_MODULE,
> > 
> > You don't need the .owner line. module_platform_driver() /
> > platform_driver_register() takes care of this for you.
> > 

I got it. I will remove the .owner line

> > Brian
> > 
> > > +		.of_match_table = dip_of_ids,
> > > +		.pm     = &mtk_dip_pm_ops,
> > > +	}
> > > +};
> > > +
> > > +module_platform_driver(mtk_dip_driver);
> > > +
> > > +MODULE_DESCRIPTION("Camera DIP driver");
> > > +MODULE_LICENSE("GPL");
> > ...
> 
> 


Sincerely,

Frederic Chen



