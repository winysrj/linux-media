Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:32973 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752345AbbLAKmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2015 05:42:38 -0500
Message-ID: <1448966550.7534.95.camel@mtksdaap41>
Subject: Re: [RESEND RFC/PATCH 6/8] media: platform: mtk-vcodec: Add
 Mediatek V4L2 Video Encoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	"Mark Rutland" <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"Catalin Marinas" <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	"Hans Verkuil" <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	"Benoit Parrot" <bparrot@ti.com>,
	Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
	<Andrew-CT.Chen@mediatek.com>,
	Eddie Huang =?UTF-8?Q?=28=E9=BB=83=E6=99=BA=E5=82=91=29?=
	<eddie.huang@mediatek.com>,
	Yingjoe Chen =?UTF-8?Q?=28=E9=99=B3=E8=8B=B1=E6=B4=B2=29?=
	<Yingjoe.Chen@mediatek.com>,
	JamesJJ Liao =?UTF-8?Q?=28=E5=BB=96=E5=BB=BA=E6=99=BA=29?=
	<jamesjj.liao@mediatek.com>,
	Daniel Hsiao =?UTF-8?Q?=28=E8=95=AD=E4=BC=AF=E5=89=9B=29?=
	<daniel.hsiao@mediatek.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	PoChun Lin =?UTF-8?Q?=28=E6=9E=97=E6=9F=8F=E5=90=9B=29?=
	<PoChun.Lin@mediatek.com>
Date: Tue, 1 Dec 2015 18:42:30 +0800
In-Reply-To: <CAMTL27FchgtJZS4YpVge-x+TstnVHmG1aAnaOV32qCU3zMUbAQ@mail.gmail.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
	 <1447764885-23100-7-git-send-email-tiffany.lin@mediatek.com>
	 <56588622.8060600@linaro.org>	<1448883594.25093.45.camel@mtksdaap41>
	 <CAMTL27FchgtJZS4YpVge-x+TstnVHmG1aAnaOV32qCU3zMUbAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2015-11-30 at 22:58 +0800, Daniel Thompson wrote:
> On 30 November 2015 at 11:39, tiffany lin <tiffany.lin@mediatek.com> wrote:
> >> > diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
> >> > new file mode 100644
> >> > index 0000000..c7f7174
> >> > --- /dev/null
> >> > +++ b/drivers/media/platform/mtk-vcodec/Makefile
> >> > @@ -0,0 +1,12 @@
> >> > +obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk_vcodec_intr.o \
> >> > +                                  mtk_vcodec_util.o \
> >> > +                                  mtk_vcodec_enc_drv.o \
> >> > +                                  mtk_vcodec_enc.o \
> >> > +                                  mtk_vcodec_enc_pm.o
> >> > +
> >> > +obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += common/
> >> > +
> >> > +ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
> >> > +        -I$(srctree)/drivers/media/platform/mtk-vcodec \
> >> > +        -I$(srctree)/drivers/media/platform/mtk-vpu
> >>
> >> Seems like there's a lot of directories here. Are these files
> >> (framework, common, vcodec, etc) so unrelated they really need to live
> >> in separate directories?
> >>
> >> Why not just drivers/media/platform/mediatek?
> > This is because VPU and Vcodec are two different drivers.
> > Driver in mtk-vpu is for controlling VPU device and provide
> > communication API to VPU.
> > Driver in mtk-vcodec is for control different encoder (vp8, h264), it
> > include v4l2 driver layer, glue layer between encoders and vp8 and h264
> > encoder.
> 
> They may be separate pieces of hardware the drivers for them are very
> clearly interlinked. This is obvious because the Makefiles are having
> to set ccflags to pick up the headers of the other drivers.
> 
> No other V4L2 driver uses ccflags-y in this manner.
> 
Got it.
We will remove -I from Makefile and put VPU header file in
include/soc/mediatek

> 
> >> > diff --git a/drivers/media/platform/mtk-vcodec/common/Makefile b/drivers/media/platform/mtk-vcodec/common/Makefile
> >> > new file mode 100644
> >> > index 0000000..477ab80
> >> > --- /dev/null
> >> > +++ b/drivers/media/platform/mtk-vcodec/common/Makefile
> >> > @@ -0,0 +1,8 @@
> >> > +obj-y += \
> >> > +    venc_drv_if.o
> >> > +
> >> > +ccflags-y += \
> >> > +    -I$(srctree)/include/ \
> >> > +    -I$(srctree)/drivers/media/platform/mtk-vcodec \
> >> > +    -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
> >> > +    -I$(srctree)/drivers/media/platform/mtk-vpu
> >>
> >> As above, this appears to be a directory to hold just one file.
> >>
> > Sorry, I didn't get it. Could you explain more?
> 
> Just that this is another example of the excessive directory structure.
> 
> A directory that contains only one source file is a strong indication
> that the splitting of the V4L2 implementation into directories is
> excessive.
> 
The directory that contains only one source file is because now we only
upstream encoder patches. We have decoder patches in future.
We will remove "common", "include" two directories and put files in
mtk-vcodec in next version.

> 
> >>  > diff --git a/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
> >> b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
> >>  > new file mode 100644
> >>  > index 0000000..9b3f025
> >>  > --- /dev/null
> >>  > +++ b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
> >>  > @@ -0,0 +1,152 @@
> >>  > +/*
> >>  > + * Copyright (c) 2015 MediaTek Inc.
> >>  > + * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
> >>  > + *         Jungchang Tsao <jungchang.tsao@mediatek.com>
> >>  > + *
> >>  > + * This program is free software; you can redistribute it and/or
> >>  > + * modify
> >>  > + * it under the terms of the GNU General Public License version 2 as
> >>  > + * published by the Free Software Foundation.
> >>  > + *
> >>  > + * This program is distributed in the hope that it will be useful,
> >>  > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>  > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>  > + * GNU General Public License for more details.
> >>  > + */
> >>  > +
> >>  > +#include <linux/interrupt.h>
> >>  > +#include <linux/kernel.h>
> >>  > +#include <linux/slab.h>
> >>  > +
> >>  > +#include "mtk_vcodec_drv.h"
> >>  > +#include "mtk_vcodec_enc.h"
> >>  > +#include "mtk_vcodec_pm.h"
> >>  > +#include "mtk_vcodec_util.h"
> >>  > +#include "mtk_vpu_core.h"
> >>  > +
> >>  > +#include "venc_drv_if.h"
> >>  > +#include "venc_drv_base.h"
> >>  > +
> >>  > +
> >>  > +int venc_if_create(void *ctx, unsigned int fourcc, unsigned long
> >> *handle)
> >>  > +{
> >>  > +  struct venc_handle *h;
> >>  > +  char str[10];
> >>  > +
> >>  > +  mtk_vcodec_fmt2str(fourcc, str);
> >>  > +
> >>  > +  h = kzalloc(sizeof(*h), GFP_KERNEL);
> >>  > +  if (!h)
> >>  > +          return -ENOMEM;
> >>  > +
> >>  > +  h->fourcc = fourcc;
> >>  > +  h->ctx = ctx;
> >>  > +  mtk_vcodec_debug(h, "fmt = %s handle = %p", str, h);
> >>  > +
> >>  > +  switch (fourcc) {
> >>  > +  default:
> >>  > +          mtk_vcodec_err(h, "invalid format %s", str);
> >>  > +          goto err_out;
> >>  > +  }
> >>  > +
> >>  > +  *handle = (unsigned long)h;
> >>  > +  return 0;
> >>  > +
> >>  > +err_out:
> >>  > +  kfree(h);
> >>  > +  return -EINVAL;
> >>  > +}
> >>  > +
> >>  > +int venc_if_init(unsigned long handle)
> >>  > +{
> >>  > +  int ret = 0;
> >>  > +  struct venc_handle *h = (struct venc_handle *)handle;
> >>  > +
> >>  > +  mtk_vcodec_debug_enter(h);
> >>  > +
> >>  > +  mtk_venc_lock(h->ctx);
> >>  > +  mtk_vcodec_enc_clock_on();
> >>  > +  vpu_enable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
> >>  > +  ret = h->enc_if->init(h->ctx, (unsigned long *)&h->drv_handle);
> >>  > +  vpu_disable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
> >>  > +  mtk_vcodec_enc_clock_off();
> >>  > +  mtk_venc_unlock(h->ctx);
> >>  > +
> >>  > +  return ret;
> >>  > +}
> >>
> >> To me this looks more like an obfuscation layer rather than a
> >> abstraction layer. I don't understand why we need to hide things from
> >> the V4L2 implementation that this code forms part of.
> >>
> >> More importantly, if this code was included somewhere where it could be
> >> properly integrated with the device model you might be able to use the
> >> pm_runtime system to avoid this sort of "heroics" to manage the clocks
> >> anyway.
> >>
> > We want to abstract common part from encoder driver.
> > Every encoder driver follow same calling flow and only need to take care
> > about how to communicate with vpu to encode specific format.
> > Encoder driver do not need to take care clock and multiple instance
> > issue.
> 
> Looking at each of those stages:
> 
> mtk_venc_lock():
> Why isn't one of the existing V4L2 locking strategies ok for you?
> 
We only has one encoder hw.
To support multiple encode instances.
When one encoder ctx access encoder hw, it need to get lock first.

> mtk_vcodec_enc_clock_on():
> This does seem like something a sub-driver *should* be doing for itself
This is for enabling encoder hw related clock.
To support multiple instances, one encode ctx must get hw lock first
then clock on/off hw relate clock.

> vpu_enable_clock():
> Why can't the VPU driver manage this internally using pm_runtime?
> 
Our VPU do not have power domain.
We will remove VPU clock on/off and let vpu control it in next version.

> 
> That is why I described this as an obfuscation layer. It is collecting
> a bunch of stuff that can be handled using the kernel driver model and
> clumping them together in a special middle layer.
> 
We do use kernel driver model, but we put it in
mtk_vcodec_enc_clock_on/mtk_vcodec_enc_clock_off.
Every sub-driver has no need to write the same code.
And once clock configuration change or porting to other chips, we don't
need to change sub-driver one-by-one, just change abstract layer.

> 
> >> > +/**
> >> > + * enum mtk_instance_type - The type of an MTK Vcodec instance.
> >> > + */
> >> > +enum mtk_instance_type {
> >> > +   MTK_INST_DECODER                = 0,
> >> > +   MTK_INST_ENCODER                = 1,
> >> > +};
> >> > +
> >> > +/**
> >> > + * enum mtk_instance_state - The state of an MTK Vcodec instance.
> >> > + * @MTK_STATE_FREE - default state when instance create
> >> > + * @MTK_STATE_CREATE - vdec instance is create
> >> > + * @MTK_STATE_INIT - vdec instance is init
> >> > + * @MTK_STATE_CONFIG - reserved for encoder
> >> > + * @MTK_STATE_HEADER - vdec had sps/pps header parsed
> >> > + * @MTK_STATE_RUNNING - vdec is decoding
> >> > + * @MTK_STATE_FLUSH - vdec is flushing
> >> > + * @MTK_STATE_RES_CHANGE - vdec detect resolution change
> >> > + * @MTK_STATE_FINISH - ctx instance is stopped streaming
> >> > + * @MTK_STATE_DEINIT - before release ctx instance
> >> > + * @MTK_STATE_ERROR - vdec has something wrong
> >> > + * @MTK_STATE_ABORT - abort work in working thread
> >> > + */
> >> > +enum mtk_instance_state {
> >> > +   MTK_STATE_FREE          = 0,
> >> > +   MTK_STATE_CREATE        = (1 << 0),
> >> > +   MTK_STATE_INIT          = (1 << 1),
> >> > +   MTK_STATE_CONFIG        = (1 << 2),
> >> > +   MTK_STATE_HEADER        = (1 << 3),
> >> > +   MTK_STATE_RUNNING       = (1 << 4),
> >> > +   MTK_STATE_FLUSH         = (1 << 5),
> >> > +   MTK_STATE_RES_CHANGE    = (1 << 6),
> >> > +   MTK_STATE_FINISH        = (1 << 7),
> >> > +   MTK_STATE_DEINIT        = (1 << 8),
> >> > +   MTK_STATE_ERROR         = (1 << 9),
> >> > +   MTK_STATE_ABORT         = (1 << 10),
> >>
> >> This looks like it started as a state machine and somehow turned into
> >> flags, resulting in a state machine with 2048 states or, to give it a
> >> different name, a debugging nightmare.
> >>
> > It's define some state happened rather than state machine.
> > Though some states are for v4l2 decoder driver and not used in encoder
> > driver.
> 
> Saying the flags track when "something happened" doesn't stop this
> from being an extremely complex (and poorly documented) state machine.
> 
> There are way too many states compared to what is needed to implement
> V4L2 correctly. To make clear why I am raising this point: with the
> current driver state management code it is close to impossible to
> properly review the error paths in this driver. The cause of error and
> the recovery after error are too decoupled.
Some state defines are shared with decoder that we will upstream in
future.
We will review if each state is really needed and reduce state that
encoder need in next version.

> 
> >> If the start streaming operation implemented cleanup-on-error properly
> >> then there would only be two useful states: Started and stopped. Even
> >> the "sticky" error behavior looks unnecessary to me (meaning we don't
> >> need to track its state).
> >>
> > We cannot guaranteed that IOCTLs called from the user space follow
> > required sequence.
> > We need states to know if our driver could accept IOCTL command.
> 
> I believe that knowing whether the streaming is started or stopped
> (e.g. two states) is sufficient for a driver to correctly handle
> abitrary ioctls from userspace and even then, the core code tracks
> this state for you so there's no need for you do it.
> 
> The queue/dequeue ioctls succeed or fail based on the length of the
> queue (i.e. is the buffer queue overflowing or not) and have no need
> to check the streaming state.

> If you are absolutely sure that the other states are needed then
> please provide an example of an ioctl() sequence where the additional
> state is needed.
> 
I know your point that we have too many state changes in start_streaming
and stop_streaming function.
We will refine these two functions in next version.

For the example, we need MTK_STATE_HEADER state, to make sure before
encode start, driver already get information to set encode parameters.
We need MTK_STATE_ABORT to inform encoder thread (mtk_venc_worker) that
stop encodeing job from stopped ctx instance.
When user space qbuf, we need to make sure everything is ready to sent
buf to encode.


> 
> >> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> >> > new file mode 100644
> >> > index 0000000..8e1b6f0
> >> > --- /dev/null
> >> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> >> > @@ -0,0 +1,1773 @@
> >> > [...]
> >> > +static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
> >> > +{
> >> > +   struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> >> > +   struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
> >> > +   int ret;
> >> > +#if MTK_V4L2_BENCHMARK
> >> > +   struct timeval begin, end;
> >> > +
> >> > +   do_gettimeofday(&begin);
> >> > +#endif
> >> > +
> >> > +   if (!(vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q) &
> >> > +         vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q))) {
> >> > +           mtk_v4l2_debug(1, "[%d]-> out=%d cap=%d",
> >> > +            ctx->idx,
> >> > +            vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q),
> >> > +            vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q));
> >> > +           return 0;
> >> > +   }
> >> > +
> >> > +   if ((ctx->state & (MTK_STATE_ERROR | MTK_STATE_ABORT)))
> >> > +           return -EINVAL;
> >>
> >> This is the sort of thing I mean.
> >>
> >> This sticky error behaviour means that every subsequent call to
> >> vb2ops_venc_start_streaming() will fail. Note also that the user will
> >> never try to stop streaming (which can clear the error state) because
> >> according to the return code it got when it tried to start streaming we
> >> never actually started.
> >>
> >> This is what I mean about having two many states. From the user's
> >> perspective there are only two states. There needs to be a good reason
> >> for the driver to manage so many extra secret states internally.
> >>
> > For my understanding, that vb2ops_venc_start_streaming cannot fail.
> 
> I disagree: See
> http://lxr.free-electrons.com/source/include/media/videobuf2-core.h#L288
> 
> How did you confirm your understanding before replying?
> 
Sorry that I did not explain well.
What I want to said about "cannot fail" is that once start streaming
fail, all subsequent calls will fail.
The only recover step is close this instance and open instance again.

> When this function returns an error the simplest (and easiest to
> review) error recovery strategy is simply to undo any actions which
> have already been performed (like resource allocation) and return an
> error code.#
> 
> There is no need for the driver to remember that it has already
> reported an error. If the userspace tries again then its OK for us to
> fail again.
> 
Our original though is that when start_streaming fail, user space will
close this instance. And if user space called start_streaming again, it
just return fail.
I got what you means now, we will try to reduce state changes and remove
state check in start_streaming/stop_streaming in next version.

> 
> > If it fail, user space will close and release this encoder instance
> > (fd).
> 
> The userspace is not required to do this and the driver must not
> assume that it will. It could attempt some kind of reconfiguration and
> retry.
> 
> 
> > We really need to state driver to see what it should do when receive
> > current IOCTL.
> 
> I think you'll find that the v4l2-core does this for you.
> 
We will review each state and make sure if it really need for encoder in
next version.
> 
> >> > +
> >> > +   if (ctx->state == MTK_STATE_FREE) {
> >> > +           ret = venc_if_create(ctx,
> >> > +                                ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc,
> >> > +                                &ctx->h_enc);
> >> > +
> >> > +           if (ret != 0) {
> >> > +                   ctx->state |= MTK_STATE_ERROR;
> >> > +                   v4l2_err(v4l2_dev, "invalid codec type=%x\n",
> >> > +                            ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc);
> >> > +                   v4l2_err(v4l2_dev, "venc_if_create failed=%d\n", ret);
> >> > +                   return -EINVAL;
> >> > +           }
> >> > +
> >> > +           if (ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc ==
> >> > +                   V4L2_PIX_FMT_H264)
> >> > +                   ctx->hdr = 1;
> >> > +
> >> > +           ctx->state |= MTK_STATE_CREATE;
> >> > +   }
> >> > +
> >> > +   if ((ctx->state & MTK_STATE_CREATE) && !(ctx->state & MTK_STATE_INIT)) {
> >> > +           ret = venc_if_init(ctx->h_enc);
> >> > +           if (ret != 0) {
> >> > +                   ctx->state |= MTK_STATE_ERROR;
> >> > +                   v4l2_err(v4l2_dev, "venc_if_init failed=%d\n", ret);
> >> > +                   return -EINVAL;
> >>
> >> This error path leaves the encoder partially constructed and relies on
> >> something else to tidy things up. It would be much better to tidy things
> >> up from this function and
> >>
> >> Also I don't think both venc_if_create and venc_if_init are needed. They
> >> are only ever called one after the other and thus they only serve to
> >> complicate the error handling code.
> >>
> > venc_if_create is for creating instance in arm side and base on encode
> > format hook corresponding encoder driver interface.
> > venc_if_init is trying to init encoder instance in VPU side.
> > Failures from two functions should have different error handling.
> > We will enhance this part in next version.
> 
> As mentioned above, I'm very uncomfortable about this API in its
> entirety and think it should be reconsidered.
> 
> So whilst I disagree here (the caller does not have any significant
> difference in error handling so using -ENOMEM/-EINVAL/-EIO should be
> quite sufficient to distringuish between errors) I rather you spent
> some time trying to eliminate this API.
I got it. We will merge venc_if_create and venc_if_init in next
version. 

> 
> >> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> >> > new file mode 100644
> >> > index 0000000..a8e683a
> >> > --- /dev/null
> >> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> >> > @@ -0,0 +1,66 @@
> >> > +/*
> >> > +* Copyright (c) 2015 MediaTek Inc.
> >> > +* Author: PC Chen <pc.chen@mediatek.com>
> >> > +*         Tiffany Lin <tiffany.lin@mediatek.com>
> >> > +*
> >> > +* This program is free software; you can redistribute it and/or modify
> >> > +* it under the terms of the GNU General Public License version 2 as
> >> > +* published by the Free Software Foundation.
> >> > +*
> >> > +* This program is distributed in the hope that it will be useful,
> >> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> > +* GNU General Public License for more details.
> >> > +*/
> >> > +
> >> > +#ifndef _MTK_VCODEC_UTIL_H_
> >> > +#define _MTK_VCODEC_UTIL_H_
> >> > +
> >> > +#include <linux/types.h>
> >> > +#include <linux/dma-direction.h>
> >> > +
> >> > +struct mtk_vcodec_mem {
> >> > +   size_t size;
> >> > +   void *va;
> >> > +   dma_addr_t dma_addr;
> >> > +};
> >> > +
> >> > +extern int mtk_v4l2_dbg_level;
> >> > +extern bool mtk_vcodec_dbg;
> >> > +
> >> > +#define mtk_v4l2_debug(level, fmt, args...)                                 \
> >> > +   do {                                                             \
> >> > +           if (mtk_v4l2_dbg_level >= level)                         \
> >> > +                   pr_info("[MTK_V4L2] level=%d %s(),%d: " fmt "\n",\
> >> > +                           level, __func__, __LINE__, ##args);      \
> >> > +   } while (0)
> >>  > +
> >> > +#define mtk_v4l2_err(fmt, args...)                \
> >> > +   pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
> >> > +          ##args)
> >>
> >> Obviously the code should be structured to make use of dev_dbg/dev_err
> >> possible.
> >>
> >> However where this won't work do you really need special macros for
> >> this. Assuming your error messages are well written 'git grep' and the
> >> following should be enough:
> >>
> >> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >>
> > Thanks.
> > For pr_err case, we will try to use "#define pr_fmt(fmt) KBUILD_MODNAME
> > ": " fmt" in next version.
> > For pr_info case, we still need debug level to control output messages.
> 
> To be honest I expect new code to be able to rely on -DDEBUG and/or
> CONFIG_DYNAMIC_DEBUG.
> 
> I really can't see why a single V4L2 driver needs to hand roll a six
> level debug message framework. If it really, really, really needs it
> then it should at least have the good manners to copy the prior art in
> the existing V4L2 drivers.
> 
We will add -DDEBUG in next version.
In development stage, we need it when debugging.
> 
> 
> >
> >>
> >> > +#define mtk_v4l2_debug_enter()  mtk_v4l2_debug(5, "+\n")
> >> > +#define mtk_v4l2_debug_leave()  mtk_v4l2_debug(5, "-\n")
> >>
> >> Remove these. If you care about function entry and exit for debugging
> >> you should be able to use ftrace.
> >>
> > I am not familiar with ftrace.
> > What if we only want to trace v4l2 video encoder driver called flow not
> > called stack? And only for functions we are interested not all
> > functions.
> > I will check if it is convenience for us using ftrace.
> 
> It is find for ftrace to only track a subset of functions.
> 
> 
> Daniel.

best regards,
Tiffany

