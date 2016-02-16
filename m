Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:11797 "EHLO
	mailgw02.hq.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753501AbcBPGhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 01:37:38 -0500
Message-ID: <1455604653.19396.68.camel@mtksdaap41>
Subject: Re: [PATCH v4 5/8] [Media] vcodec: mediatek: Add Mediatek V4L2
 Video Encoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Date: Tue, 16 Feb 2016 14:37:33 +0800
In-Reply-To: <56C1B4AF.1030207@xs4all.nl>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
	 <56C1B4AF.1030207@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your time.
On Mon, 2016-02-15 at 12:21 +0100, Hans Verkuil wrote:
> On 02/04/2016 12:35 PM, Tiffany Lin wrote:
> > From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> > 
> > Add v4l2 layer encoder driver for MT8173
> > 
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> 
> If Andrew is the author, shouldn't there be a Signed-off-by from him as well?
> 
> And in copyright notices (might want to update the year to 2016 BTW) PC Chen
> is mentioned among others. It might be useful to update the Signed-off-by lines.
> 

Author is PC Chen and Tiffany Lin, Andrew-CT Chen is author of mtk-vpu
module.
We will fix copyright and this in next version.

> > ---
> >  drivers/media/platform/Kconfig                     |   11 +
> >  drivers/media/platform/Makefile                    |    2 +
> >  drivers/media/platform/mtk-vcodec/Makefile         |    8 +
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  388 ++++++
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1380 ++++++++++++++++++++
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   46 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  476 +++++++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  132 ++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |  102 ++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   29 +
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h  |   26 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |  106 ++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   85 ++
> >  drivers/media/platform/mtk-vcodec/venc_drv_base.h  |   62 +
> >  drivers/media/platform/mtk-vcodec/venc_drv_if.c    |  100 ++
> >  drivers/media/platform/mtk-vcodec/venc_drv_if.h    |  175 +++
> >  drivers/media/platform/mtk-vcodec/venc_ipi_msg.h   |  212 +++
> >  include/uapi/linux/v4l2-controls.h                 |    4 +
> >  18 files changed, 3344 insertions(+)
> >  create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_base.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
> >  mode change 100644 => 100755 include/uapi/linux/v4l2-controls.h
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index ba812d6..3e831c5 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -157,6 +157,17 @@ config VIDEO_MEDIATEK_VPU
> >  	    codec embedded in new Mediatek's SOCs. It is able
> >  	    to handle video decoding/encoding in a range of formats.
> >  
> > +config VIDEO_MEDIATEK_VCODEC
> > +        tristate "Mediatek Video Codec driver"
> > +        depends on VIDEO_DEV && VIDEO_V4L2
> > +        depends on ARCH_MEDIATEK || COMPILE_TEST
> > +        select VIDEOBUF2_DMA_CONTIG
> > +        select V4L2_MEM2MEM_DEV
> > +        select MEDIATEK_VPU
> > +        default n
> > +        ---help---
> > +            Mediatek video codec driver for V4L2
> > +
> >  config VIDEO_MEM2MEM_DEINTERLACE
> >  	tristate "Deinterlace support"
> >  	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
> > diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> > index e5b19c6..510e06b 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -57,3 +57,5 @@ obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
> >  ccflags-y += -I$(srctree)/drivers/media/i2c
> >  
> >  obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
> > +
> > +obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
> > diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
> > new file mode 100644
> > index 0000000..ce38689
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/Makefile
> > @@ -0,0 +1,8 @@
> > +obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk_vcodec_intr.o \
> > +				       mtk_vcodec_util.o \
> > +				       mtk_vcodec_enc_drv.o \
> > +				       mtk_vcodec_enc.o \
> > +				       mtk_vcodec_enc_pm.o \
> > +				       venc_drv_if.o
> > +
> > +ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vpu
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> > new file mode 100644
> > index 0000000..9da2818
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> > @@ -0,0 +1,388 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: PC Chen <pc.chen@mediatek.com>
> > +*         Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#ifndef _MTK_VCODEC_DRV_H_
> > +#define _MTK_VCODEC_DRV_H_
> > +
> > +#include <linux/platform_device.h>
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/videobuf2-core.h>
> > +
> > +#include "mtk_vcodec_util.h"
> > +
> > +#define MTK_VCODEC_MAX_INSTANCES		10
> > +#define MTK_VCODEC_MAX_ENCODER_INSTANCES	3
> > +
> > +#define MTK_VCODEC_MAX_FRAME_SIZE	0x800000
> > +#define MTK_VIDEO_MAX_FRAME		32
> > +#define MTK_MAX_CTRLS			20
> > +
> > +#define MTK_VCODEC_DRV_NAME		"mtk_vcodec_drv"
> > +#define MTK_VCODEC_ENC_NAME		"mtk-vcodec-enc"
> > +#define MTK_PLATFORM_STR		"platform:mt8173"
> > +
> > +#define MTK_VENC_IRQ_STATUS_SPS          0x1
> > +#define MTK_VENC_IRQ_STATUS_PPS          0x2
> > +#define MTK_VENC_IRQ_STATUS_FRM          0x4
> > +#define MTK_VENC_IRQ_STATUS_DRAM         0x8
> > +#define MTK_VENC_IRQ_STATUS_PAUSE        0x10
> > +#define MTK_VENC_IRQ_STATUS_SWITCH       0x20
> > +
> > +#define MTK_VENC_IRQ_STATUS_OFFSET       0x05C
> > +#define MTK_VENC_IRQ_ACK_OFFSET          0x060
> > +
> > +#define MTK_VCODEC_MAX_PLANES		3
> > +
> > +#define VDEC_HW_ACTIVE	0x10
> > +#define VDEC_IRQ_CFG    0x11
> > +#define VDEC_IRQ_CLR    0x10
> > +
> > +#define VDEC_IRQ_CFG_REG	0xa4
> > +#define WAIT_INTR_TIMEOUT	1000
> > +
> > +/**
> > + * enum mtk_hw_reg_idx - MTK hw register base index
> > + */
> > +enum mtk_hw_reg_idx {
> > +	VDEC_SYS,
> > +	VDEC_MISC,
> > +	VDEC_LD,
> > +	VDEC_TOP,
> > +	VDEC_CM,
> > +	VDEC_AD,
> > +	VDEC_AV,
> > +	VDEC_PP,
> > +	VDEC_HWD,
> > +	VDEC_HWQ,
> > +	VDEC_HWB,
> > +	VDEC_HWG,
> > +	NUM_MAX_VDEC_REG_BASE,
> > +	VENC_SYS = NUM_MAX_VDEC_REG_BASE,
> > +	VENC_LT_SYS,
> > +	NUM_MAX_VCODEC_REG_BASE
> > +};
> > +
> > +/**
> > + * enum mtk_instance_type - The type of an MTK Vcodec instance.
> > + */
> > +enum mtk_instance_type {
> > +	MTK_INST_DECODER		= 0,
> > +	MTK_INST_ENCODER		= 1,
> > +};
> > +
> > +/**
> > + * enum mtk_instance_state - The state of an MTK Vcodec instance.
> > + * @MTK_STATE_FREE - default state when instance is created
> > + * @MTK_STATE_INIT - vcodec instance is initialized
> > + * @MTK_STATE_HEADER - vdec had sps/pps header parsed or venc
> > + *			had sps/pps header encoded
> > + * @MTK_STATE_FLUSH - vdec is flushing. Only used by decoder
> > + * @MTK_STATE_RES_CHANGE - vdec detect resolution change.
> > + * 			Only used by decoder
> > + * @MTK_STATE_ABORT - vcodec should be aborted
> > + */
> > +enum mtk_instance_state {
> > +	MTK_STATE_FREE = 0,
> > +	MTK_STATE_INIT = 1,
> > +	MTK_STATE_HEADER = 2,
> > +	MTK_STATE_FLUSH = 3,
> > +	MTK_STATE_RES_CHANGE = 4,
> > +	MTK_STATE_ABORT = 5,
> > +};
> > +
> > +/**
> > + * struct mtk_param_change - General encoding parameters type
> > + */
> > +enum mtk_encode_param {
> > +	MTK_ENCODE_PARAM_NONE = 0,
> > +	MTK_ENCODE_PARAM_BITRATE = (1 << 0),
> > +	MTK_ENCODE_PARAM_FRAMERATE = (1 << 1),
> > +	MTK_ENCODE_PARAM_INTRA_PERIOD = (1 << 2),
> > +	MTK_ENCODE_PARAM_FRAME_TYPE = (1 << 3),
> > +};
> > +
> > +/**
> > + * enum mtk_fmt_type - Type of the pixelformat
> > + * @MTK_FMT_FRAME - mtk vcodec raw frame
> > + */
> > +enum mtk_fmt_type {
> > +	MTK_FMT_DEC		= 0,
> > +	MTK_FMT_ENC		= 1,
> > +	MTK_FMT_FRAME		= 2,
> > +};
> > +
> > +/**
> > + * struct mtk_video_fmt - Structure used to store information about pixelformats
> > + */
> > +struct mtk_video_fmt {
> > +	u32 fourcc;
> > +	enum mtk_fmt_type type;
> > +	u32 num_planes;
> > +};
> > +
> > +/**
> > + * struct mtk_codec_framesizes - Structure used to store information about framesizes
> > + */
> > +struct mtk_codec_framesizes {
> > +	u32 fourcc;
> > +	struct	v4l2_frmsize_stepwise	stepwise;
> > +};
> > +
> > +/**
> > + * struct mtk_q_type - Type of queue
> > + */
> > +enum mtk_q_type {
> > +	MTK_Q_DATA_SRC		= 0,
> > +	MTK_Q_DATA_DST		= 1,
> > +};
> > +
> > +/**
> > + * struct mtk_q_data - Structure used to store information about queue
> > + * @colorspace	reserved for encoder
> > + * @field		reserved for encoder
> 
> struct is only partially documented here.
We will fix this in next version.

> 
> > + */
> > +struct mtk_q_data {
> > +	unsigned int		width;
> > +	unsigned int		height;
> > +	enum v4l2_field		field;
> > +	enum v4l2_colorspace	colorspace;
> > +	unsigned int		bytesperline[MTK_VCODEC_MAX_PLANES];
> > +	unsigned int		sizeimage[MTK_VCODEC_MAX_PLANES];
> > +	struct mtk_video_fmt	*fmt;
> > +};
> > +
> > +/**
> > + * struct mtk_enc_params - General encoding parameters
> > + * @bitrate - target bitrate
> > + * @num_b_frame - number of b frames between p-frame
> > + * @rc_frame - frame based rate control
> > + * @rc_mb - macroblock based rate control
> > + * @seq_hdr_mode - H.264 sequence header is encoded separately or joined with the first frame
> > + * @gop_size - group of picture size, it's used as the intra frame period
> > + * @framerate_num - frame rate numerator
> > + * @framerate_denom - frame rate denominator
> > + * @h264_max_qp - Max value for H.264 quantization parameter
> > + * @h264_profile - V4L2 defined H.264 profile
> > + * @h264_level - V4L2 defined H.264 level
> > + * @force_intra - force/insert intra frame
> > + * @skip_frame - encode in skip frame mode that use minimum number of bits
> 
> skip_frame isn't in the struct anymore.
We will remove this in next version.

> 
> > + */
> > +struct mtk_enc_params {
> > +	unsigned int	bitrate;
> > +	unsigned int	num_b_frame;
> > +	unsigned int	rc_frame;
> > +	unsigned int	rc_mb;
> > +	unsigned int	seq_hdr_mode;
> > +	unsigned int	gop_size;
> > +	unsigned int	framerate_num;
> > +	unsigned int	framerate_denom;
> > +	unsigned int	h264_max_qp;
> > +	unsigned int	h264_profile;
> > +	unsigned int	h264_level;
> > +	unsigned int	force_intra;
> > +};
> > +
> > +/**
> > + * struct mtk_vcodec_pm - Power management data structure
> > + */
> > +struct mtk_vcodec_pm {
> > +	struct clk	*vcodecpll;
> > +	struct clk	*univpll_d2;
> > +	struct clk	*clk_cci400_sel;
> > +	struct clk	*vdecpll;
> > +	struct clk	*vdec_sel;
> > +	struct clk	*vencpll_d2;
> > +	struct clk	*venc_sel;
> > +	struct clk	*univpll1_d2;
> > +	struct clk	*venc_lt_sel;
> > +	struct device	*larbvdec;
> > +	struct device	*larbvenc;
> > +	struct device	*larbvenclt;
> > +	struct device	*dev;
> > +	struct mtk_vcodec_dev *mtkdev;
> > +};
> > +
> > +
> > +/**
> > + * struct mtk_vcodec_ctx - Context (instance) private data.
> > + *
> > + * @type:		type of the instance - decoder or encoder
> > + * @dev:		pointer to the mtk_vcodec_dev of the device
> > + * @fh:			struct v4l2_fh
> > + * @m2m_ctx:		pointer to the v4l2_m2m_ctx of the context
> > + * @q_data:		store information of input and output queue
> > + *			of the context
> > + * @idx:		index of the context that this structure describes
> > + * @state:		state of the context
> > + * @param_change:	encode parameters
> > + * @enc_params:		encoding parameters
> > + * @colorspace:
> > + * @enc_if:		hoooked encoder driver interface
> > + * @drv_handle:		driver handle for specific decode/encode instance
> > + *
> > + * @picinfo:		store width/height of image and buffer and planes' size for decoder
> > + *			and encoder
> > + * @dpb_count:		count of the DPB buffers required by MTK Vcodec hw
> > + *
> > + * @int_cond:		variable used by the waitqueue
> > + * @int_type:		type of the last interrupt
> > + * @queue:		waitqueue that can be used to wait for this context to
> > + *			finish
> > + * @irq_status:		irq status
> > + *
> > + * @ctrl_hdl:		handler for v4l2 framework
> > + * @ctrls:		array of controls, used when adding controls to the
> > + *			v4l2 control framework
> > + *
> > + * @encode_work:	worker for the encoding
> > + */
> 
> These comments are out of date with the actual struct!
We will fix these in next version.

> 
> > +struct mtk_vcodec_ctx {
> > +	enum mtk_instance_type type;
> > +	struct mtk_vcodec_dev *dev;
> > +	struct v4l2_fh fh;
> > +	struct v4l2_m2m_ctx *m2m_ctx;
> > +	struct mtk_q_data q_data[2];
> > +	int idx;
> > +	enum mtk_instance_state state;
> > +	enum mtk_encode_param param_change;
> > +	struct mtk_enc_params enc_params;
> > +
> > +	struct venc_common_if *enc_if;
> > +	unsigned long drv_handle;
> > +
> > +
> > +	int int_cond;
> > +	int int_type;
> > +	wait_queue_head_t queue;
> > +	unsigned int irq_status;
> > +
> > +	struct v4l2_ctrl_handler ctrl_hdl;
> > +	struct v4l2_ctrl *ctrls[MTK_MAX_CTRLS];
> > +
> > +	struct work_struct encode_work;
> > +
> > +};
> > +
> > +/**
> > + * struct mtk_vcodec_dev - driver data
> > + * @v4l2_dev:		V4L2 device to register video devices for.
> > + * @vfd_enc:		Video device for encoder.
> > + *
> > + * @m2m_dev_enc:	m2m device for encoder.
> > + * @plat_dev:		platform device
> > + * @alloc_ctx:		VB2 allocator context
> > + *			(for allocations without kernel mapping).
> > + * @ctx:		array of driver contexts
> > + *
> > + * @curr_ctx:		The context that is waiting for codec hardware
> > + *
> > + * @reg_base:		Mapped address of MTK Vcodec registers.
> > + *
> > + * @instance_mask:	used to mark which contexts are opened
> > + * @num_instances:	counter of active MTK Vcodec instances
> > + *
> > + * @encode_workqueue:	encode work queue
> > + *
> > + * @int_cond:		used to identify interrupt condition happen
> > + * @int_type:		used to identify what kind of interrupt condition happen
> > + * @dev_mutex:		video_device lock
> > + * @queue:		waitqueue for waiting for completion of device commands
> > + *
> > + * @enc_irq:		h264 encoder irq resource
> > + * @enc_lt_irq:		vp8 encoder irq resource
> > + *
> > + * @enc_mutex:		encoder hardware lock.
> > + *
> > + * @pm:			power management control
> > + * @dec_capability:	used to identify decode capability, ex: 4k
> > + * @enc_capability:     used to identify encode capability
> > + */
> > +struct mtk_vcodec_dev {
> > +	struct v4l2_device	v4l2_dev;
> > +	struct video_device	*vfd_enc;
> > +
> > +	struct v4l2_m2m_dev	*m2m_dev_enc;
> > +	struct platform_device	*plat_dev;
> > +	struct platform_device 	*vpu_plat_dev;
> > +	struct vb2_alloc_ctx	*alloc_ctx;
> > +	struct mtk_vcodec_ctx	*ctx[MTK_VCODEC_MAX_INSTANCES];
> > +	int curr_ctx;
> > +	void __iomem		*reg_base[NUM_MAX_VCODEC_REG_BASE];
> > +
> > +	unsigned long	instance_mask[BITS_TO_LONGS(MTK_VCODEC_MAX_INSTANCES)];
> > +	int			num_instances;
> > +
> > +	struct workqueue_struct *encode_workqueue;
> > +
> > +	int			int_cond;
> > +	int			int_type;
> > +	struct mutex		dev_mutex;
> > +	wait_queue_head_t	queue;
> > +
> > +	int			enc_irq;
> > +	int			enc_lt_irq;
> > +
> > +	struct mutex		enc_mutex;
> > +
> > +	struct mtk_vcodec_pm	pm;
> > +	unsigned int		dec_capability;
> > +	unsigned int		enc_capability;
> > +};
> > +
> > +/**
> > + * struct mtk_vcodec_ctrl - information about controls to be registered.
> > + * @id:			Control ID.
> > + * @type:		Type of the control.
> > + * @name:		Human readable name of the control.
> > + * @minimum:		Minimum value of the control.
> > + * @maximum:		Maximum value of the control.
> > + * @step:		Control value increase step.
> > + * @menu_skip_mask:	Mask of invalid menu positions.
> > + * @default_value:	Initial value of the control.
> > + * @is_volatile:	Control is volatile.
> > + *
> > + * See also struct v4l2_ctrl_config.
> > + */
> > +struct mtk_vcodec_ctrl {
> > +	u32			id;
> > +	enum v4l2_ctrl_type	type;
> > +	u8			name[32];
> > +	s32			minimum;
> > +	s32			maximum;
> > +	s32			step;
> > +	u32			menu_skip_mask;
> > +	s32			default_value;
> > +	u8			is_volatile;
> > +};
> > +
> > +static inline struct mtk_vcodec_ctx *fh_to_ctx(struct v4l2_fh *fh)
> > +{
> > +	return container_of(fh, struct mtk_vcodec_ctx, fh);
> > +}
> > +
> > +static inline struct mtk_vcodec_ctx *ctrl_to_ctx(struct v4l2_ctrl *ctrl)
> > +{
> > +	return container_of(ctrl->handler, struct mtk_vcodec_ctx, ctrl_hdl);
> > +}
> > +
> > +extern const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops;
> > +extern const struct v4l2_m2m_ops mtk_vdec_m2m_ops;
> > +extern const struct v4l2_ioctl_ops mtk_venc_ioctl_ops;
> > +extern const struct v4l2_m2m_ops mtk_venc_m2m_ops;
> > +
> > +#endif /* _MTK_VCODEC_DRV_H_ */
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > new file mode 100644
> > index 0000000..ee602fe
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > @@ -0,0 +1,1380 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: PC Chen <pc.chen@mediatek.com>
> > +*         Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/videobuf2-dma-contig.h>
> > +
> > +#include "mtk_vcodec_drv.h"
> > +#include "mtk_vcodec_enc.h"
> > +#include "mtk_vcodec_intr.h"
> > +#include "mtk_vcodec_util.h"
> > +#include "venc_drv_if.h"
> > +
> > +#define MTK_VENC_MIN_W	32
> > +#define MTK_VENC_MIN_H	32
> > +#define MTK_VENC_MAX_W	1920
> > +#define MTK_VENC_MAX_H	1080
> > +#define DFT_CFG_WIDTH	MTK_VENC_MIN_W
> > +#define DFT_CFG_HEIGHT	MTK_VENC_MIN_H
> > +
> > +static void mtk_venc_worker(struct work_struct *work);
> > +
> > +static struct mtk_video_fmt mtk_video_formats[] = {
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_YUV420,
> > +		.type		= MTK_FMT_FRAME,
> > +		.num_planes	= 3,
> > +	},
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_YVU420,
> > +		.type		= MTK_FMT_FRAME,
> > +		.num_planes	= 3,
> > +	},
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_NV12,
> > +		.type		= MTK_FMT_FRAME,
> > +		.num_planes	= 2,
> > +	},
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_NV21,
> > +		.type		= MTK_FMT_FRAME,
> > +		.num_planes	= 2,
> > +	},
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_YUV420M,
> > +		.type		= MTK_FMT_FRAME,
> > +		.num_planes	= 3,
> > +	},
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_YVU420M,
> > +		.type		= MTK_FMT_FRAME,
> > +		.num_planes	= 3,
> > +	},
> > +	{
> > +		.fourcc 	= V4L2_PIX_FMT_NV12M,
> > +		.type		= MTK_FMT_FRAME,
> > +		.num_planes	= 2,
> > +	},
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_NV21M,
> > +		.type		= MTK_FMT_FRAME,
> > +		.num_planes	= 2,
> > +	},
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_H264,
> > +		.type		= MTK_FMT_ENC,
> > +		.num_planes	= 1,
> > +	},
> > +	{
> > +		.fourcc		= V4L2_PIX_FMT_VP8,
> > +		.type		= MTK_FMT_ENC,
> > +		.num_planes	= 1,
> > +	},
> > +};
> > +
> > +#define NUM_FORMATS ARRAY_SIZE(mtk_video_formats)
> > +
> > +static const struct mtk_codec_framesizes mtk_venc_framesizes[] = {
> > +	{
> > +		.fourcc	= V4L2_PIX_FMT_H264,
> > +		.stepwise = {  160, 1920, 16, 128, 1088, 16 },
> > +	},
> > +	{
> > +		.fourcc = V4L2_PIX_FMT_VP8,
> > +		.stepwise = {  160, 1920, 16, 128, 1088, 16 },
> > +	},
> > +};
> > +
> > +#define NUM_SUPPORTED_FRAMESIZE ARRAY_SIZE(mtk_venc_framesizes)
> > +
> > +static int vidioc_venc_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = ctrl_to_ctx(ctrl);
> > +	struct mtk_enc_params *p = &ctx->enc_params;
> > +	int ret = 0;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_MPEG_VIDEO_BITRATE:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_BITRATE val = %d",
> > +			ctrl->val);
> > +		p->bitrate = ctrl->val;
> > +		ctx->param_change |= MTK_ENCODE_PARAM_BITRATE;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_B_FRAMES val = %d",
> > +			ctrl->val);
> > +		p->num_b_frame = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE val = %d",
> > +			ctrl->val);
> > +		p->rc_frame = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_MAX_QP val = %d",
> > +			ctrl->val);
> > +		p->h264_max_qp = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_HEADER_MODE val = %d",
> > +			ctrl->val);
> > +		p->seq_hdr_mode = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE val = %d",
> > +			ctrl->val);
> > +		p->rc_mb = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_PROFILE val = %d",
> > +			ctrl->val);
> > +		p->h264_profile = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_LEVEL val = %d",
> > +			ctrl->val);
> > +		p->h264_level = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_I_PERIOD val = %d",
> > +			ctrl->val);
> > +	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_GOP_SIZE val = %d",
> > +			ctrl->val);
> > +		p->gop_size = ctrl->val;
> > +		ctx->param_change |= MTK_ENCODE_PARAM_INTRA_PERIOD;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
> > +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME");
> > +		p->force_intra = 1;
> > +		ctx->param_change |= MTK_ENCODE_PARAM_FRAME_TYPE;
> > +		break;
> > +	default:
> > +		ret = -EINVAL;
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops mtk_vcodec_enc_ctrl_ops = {
> > +	.s_ctrl = vidioc_venc_s_ctrl,
> > +};
> > +
> > +static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
> > +			   bool out)
> > +{
> > +	struct mtk_video_fmt *fmt;
> > +	int i, j = 0;
> > +
> > +	for (i = 0; i < NUM_FORMATS; ++i) {
> > +		if (out && mtk_video_formats[i].type != MTK_FMT_FRAME)
> > +			continue;
> > +		else if (!out && mtk_video_formats[i].type != MTK_FMT_ENC)
> 
> No 'else' needed here.
> 
We will remote it in next version.

> > +			continue;
> > +
> > +		if (j == f->index) {
> > +			fmt = &mtk_video_formats[i];
> > +			f->pixelformat = fmt->fourcc;
> > +			return 0;
> > +		}
> > +		++j;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static int vidioc_enum_framesizes(struct file *file, void *fh,
> > +				  struct v4l2_frmsizeenum *fsize)
> > +{
> > +	int i = 0;
> > +
> > +	for (i = 0; i < NUM_SUPPORTED_FRAMESIZE; ++i) {
> > +		if (fsize->pixel_format != mtk_venc_framesizes[i].fourcc)
> > +			continue;
> > +
> > +		if (!fsize->index) {
> > +			fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> > +			fsize->stepwise = mtk_venc_framesizes[i].stepwise;
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
> > +					  struct v4l2_fmtdesc *f)
> > +{
> > +	return vidioc_enum_fmt(file, f, false);
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
> > +					  struct v4l2_fmtdesc *f)
> > +{
> > +	return vidioc_enum_fmt(file, f, true);
> > +}
> > +
> > +static int vidioc_venc_querycap(struct file *file, void *priv,
> > +				struct v4l2_capability *cap)
> > +{
> > +        strlcpy(cap->driver, MTK_VCODEC_ENC_NAME, strlen(MTK_VCODEC_ENC_NAME));
> 
> This should be:
> 
> 	strlcpy(cap->driver, MTK_VCODEC_ENC_NAME, sizeof(cap->driver));
> 
We will fix this.

> > +        cap->driver[strlen(MTK_VCODEC_ENC_NAME)]=0;
> 
> No need to terminate with 0, strlcpy does that already.
> 
> > +        strlcpy(cap->bus_info, MTK_PLATFORM_STR, strlen(MTK_PLATFORM_STR));
> > +        cap->bus_info[strlen(MTK_PLATFORM_STR)]=0;
> > +        strlcpy(cap->card, MTK_PLATFORM_STR, strlen(MTK_PLATFORM_STR));
> > +        cap->card[strlen(MTK_PLATFORM_STR)]=0;
> 
> Ditto for these two fields. Note that use use spaces instead of a tab here as
> well. Please fix. (checkpatch should have complained about that!)
> 
We will fix this.

> > +
> > +	/*
> > +	 * This is only a mem-to-mem video device. The capture and output
> > +	 * device capability flags are left only for backward compatibility
> > +	 * and are scheduled for removal.
> > +	 */
> 
> Comment is out of date.
> 
We will remove this.

> > +	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> > +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > +
> > +	return 0;
> > +}
> > +static int vidioc_venc_s_parm(struct file *file, void *priv,
> > +			      struct v4l2_streamparm *a)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +
> > +	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		ctx->enc_params.framerate_num =
> > +			a->parm.output.timeperframe.denominator;
> > +		ctx->enc_params.framerate_denom =
> > +			a->parm.output.timeperframe.numerator;
> > +		ctx->param_change |= MTK_ENCODE_PARAM_FRAMERATE;
> > +	} else {
> > +		return -EINVAL;
> > +	}
> 
> I'd invert the test:
> 
> 	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> 		return -EINVAL;
> 
> and now you can just set ctx->enc_params.
> 
We will fix this in next version.


> > +	return 0;
> > +}
> 
> And if there is an s_parm, then there should be a g_parm as well!
> 
Now our driver does not support g_parm, our use cases do not use g_parm
too. 
Do we need to add g_parm at this moment? Or we could add it when we need
g_parm?

> > +
> > +static struct mtk_q_data *mtk_venc_get_q_data(struct mtk_vcodec_ctx *ctx,
> > +					      enum v4l2_buf_type type)
> > +{
> > +	if (V4L2_TYPE_IS_OUTPUT(type))
> > +		return &ctx->q_data[MTK_Q_DATA_SRC];
> > +
> > +	return &ctx->q_data[MTK_Q_DATA_DST];
> > +}
> > +
> > +static struct mtk_video_fmt *mtk_venc_find_format(struct v4l2_format *f)
> > +{
> > +	struct mtk_video_fmt *fmt;
> > +	unsigned int k;
> > +
> > +	for (k = 0; k < NUM_FORMATS; k++) {
> > +		fmt = &mtk_video_formats[k];
> > +		if (fmt->fourcc == f->fmt.pix.pixelformat)
> > +			return fmt;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static void mtk_vcodec_enc_calc_src_size(
> > +	unsigned int num_planes, unsigned int pic_width,
> > +	unsigned int pic_height, unsigned int sizeimage[],
> > +	unsigned int bytesperline[])
> > +{
> > +	unsigned int y_pitch_w_div16;
> > +	unsigned int c_pitch_w_div16;
> > +
> > +	y_pitch_w_div16 = ALIGN(pic_width, 16) >> 4;
> > +	c_pitch_w_div16 = ALIGN(pic_width, 16) >> 4;
> > +
> > +	if (num_planes == 2) {
> > +		sizeimage[0] =
> > +			(y_pitch_w_div16) * (((pic_height + 31) / 32) * 2) * 256 +
> > +			((y_pitch_w_div16 % 8 == 0) ? 0 : ((ALIGN(pic_width, 16) * 2) * 16));
> > +
> > +		sizeimage[1] =
> > +			(c_pitch_w_div16) * (((pic_height + 31) / 32) * 2) * 128 +
> > +			((c_pitch_w_div16 % 8 == 0) ? 0 : (ALIGN(pic_width, 16) * 16));
> > +
> > +		sizeimage[2] = 0;
> > +
> > +		bytesperline[0] = ALIGN(pic_width, 16);
> > +		bytesperline[1] = ALIGN(pic_width, 16);
> > +		bytesperline[2] = 0;
> > +
> > +	} else {
> > +		sizeimage[0] =
> > +			(y_pitch_w_div16) * (((pic_height + 31) / 32) * 2) * 256 +
> > +			((y_pitch_w_div16 % 8 == 0) ? 0 : ((ALIGN(pic_width, 16) * 2) * 16));
> > +
> > +		sizeimage[1] =
> > +			(c_pitch_w_div16) * (((pic_height + 31) / 32) * 2) * 64 +
> > +			((c_pitch_w_div16 % 8 == 0) ? 0 : ((ALIGN(pic_width, 16) / 2) * 16));
> > +
> > +		sizeimage[2] =
> > +			(c_pitch_w_div16) * (((pic_height + 31) / 32) * 2) * 64 +
> > +			((c_pitch_w_div16 % 8 == 0) ? 0 : ((ALIGN(pic_width, 16) / 2) * 16));
> > +
> > +		bytesperline[0] = ALIGN(pic_width, 16);
> > +		bytesperline[1] = ALIGN(pic_width, 16) / 2;
> > +		bytesperline[2] = ALIGN(pic_width, 16) / 2;
> > +	}
> > +}
> > +
> > +static int vidioc_try_fmt(struct v4l2_format *f, struct mtk_video_fmt *fmt)
> > +{
> > +	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> > +
> > +	/* V4L2 specification suggests the driver corrects the format struct
> > +	  * if any of the dimensions is unsupported */
> > +        if (pix_fmt_mp->height < MTK_VENC_MIN_H)
> > +                pix_fmt_mp->height = MTK_VENC_MIN_H;
> > +        else if (pix_fmt_mp->height > MTK_VENC_MAX_H)
> > +                pix_fmt_mp->height = MTK_VENC_MAX_H;
> > +
> > +        if (pix_fmt_mp->width < MTK_VENC_MIN_W)
> > +                pix_fmt_mp->width = MTK_VENC_MIN_W;
> > +        else if (pix_fmt_mp->width > MTK_VENC_MAX_W)
> > +                pix_fmt_mp->width = MTK_VENC_MAX_W;
> 
> Use the clamp macro for this.
> 
We will fix this in next version.

> > +
> > +        pix_fmt_mp->field = V4L2_FIELD_NONE;
> > +
> > +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		int size = pix_fmt_mp->height * pix_fmt_mp->width;
> 
> Add an empty line.
> 
We will fix this in next version.

> > +		if (fmt->num_planes != pix_fmt_mp->num_planes)
> > +			pix_fmt_mp->num_planes = fmt->num_planes;
> > +
> > +		if(pix_fmt_mp->plane_fmt[0].sizeimage != size)
> 
> Add space after if. Again, checkpatch should have complained about that.
> Please run checkpatch first before posting the next version.
> 
We will run checkpatch before posting the next version.

> > +			pix_fmt_mp->plane_fmt[0].sizeimage = size;
> > + 		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
> > +		memset(&(pix_fmt_mp->plane_fmt[0].reserved[0]), 0x0,
> > +			sizeof(pix_fmt_mp->plane_fmt[0].reserved));
> > +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		int i;
> > +		unsigned int sizeimage[VIDEO_MAX_PLANES];
> > +		unsigned int bytesperline[VIDEO_MAX_PLANES];
> > +
> > +		v4l_bound_align_image(&pix_fmt_mp->width, 8, 1920, 1,
> > +				      &pix_fmt_mp->height, 4, 1080, 1, 0);
> > +
> > +		if (fmt->num_planes != pix_fmt_mp->num_planes)
> > +			pix_fmt_mp->num_planes = fmt->num_planes;
> > +
> > +		mtk_vcodec_enc_calc_src_size(pix_fmt_mp->num_planes,
> > +					pix_fmt_mp->width,
> > +					pix_fmt_mp->height,
> > +					sizeimage, bytesperline);
> > +
> > +		for (i=0; i < pix_fmt_mp->num_planes; i++) {
> 
> Spaces around '='.
> 
We will fix this.

> > +			pix_fmt_mp->plane_fmt[i].sizeimage = sizeimage[i];
> > +			pix_fmt_mp->plane_fmt[i].bytesperline = bytesperline[i];
> > +			memset(&(pix_fmt_mp->plane_fmt[i].reserved[0]), 0x0,
> > +				sizeof(pix_fmt_mp->plane_fmt[0].reserved));
> > +		}
> > +	} else {
> > +		return -EINVAL;
> > +	}
> > +
> > +	pix_fmt_mp->flags = 0;
> > +	pix_fmt_mp->ycbcr_enc = 0;
> > +	pix_fmt_mp->quantization = 0;
> > +	pix_fmt_mp->xfer_func = 0;
> > +	memset(&pix_fmt_mp->reserved[0], 0x0, sizeof(pix_fmt_mp->reserved));
> > +
> > +	return 0;
> > +}
> > +
> > +static void mtk_venc_set_param(struct mtk_vcodec_ctx *ctx, void *param)
> > +{
> > +	struct venc_enc_prm *p = (struct venc_enc_prm *)param;
> > +	struct mtk_q_data *q_data_src = &ctx->q_data[MTK_Q_DATA_SRC];
> > +	struct mtk_enc_params *enc_params = &ctx->enc_params;
> > +	unsigned int frame_rate;
> > +
> > +	frame_rate = enc_params->framerate_num / enc_params->framerate_denom;
> > +
> > +	switch (q_data_src->fmt->fourcc) {
> > +	case V4L2_PIX_FMT_YUV420:
> > +	case V4L2_PIX_FMT_YUV420M:
> > +		p->input_fourcc = VENC_YUV_FORMAT_420;
> > +		break;
> > +	case V4L2_PIX_FMT_YVU420:
> > +	case V4L2_PIX_FMT_YVU420M:
> > +		p->input_fourcc = VENC_YUV_FORMAT_YV12;
> > +		break;
> > +	case V4L2_PIX_FMT_NV12:
> > +	case V4L2_PIX_FMT_NV12M:
> > +		p->input_fourcc = VENC_YUV_FORMAT_NV12;
> > +		break;
> > +	case V4L2_PIX_FMT_NV21:
> > +	case V4L2_PIX_FMT_NV21M:
> > +		p->input_fourcc = VENC_YUV_FORMAT_NV21;
> > +		break;
> > +	}
> > +	p->h264_profile = enc_params->h264_profile;
> > +	p->h264_level = enc_params->h264_level;
> > +	p->width = q_data_src->width;
> > +	p->height = q_data_src->height;
> > +	p->buf_width = q_data_src->bytesperline[0];
> > +	p->buf_height = ((q_data_src->height + 0xf) & (~0xf));
> > +	p->frm_rate = frame_rate;
> > +	p->intra_period = enc_params->gop_size;
> > +	p->bitrate = enc_params->bitrate;
> > +
> > +	ctx->param_change = MTK_ENCODE_PARAM_NONE;
> > +
> > +	mtk_v4l2_debug(1, "fmt 0x%x, P/L %d/%d, w/h %d/%d, buf %d/%d, fps/bps %d/%d, gop %d",
> > +		       p->input_fourcc, p->h264_profile, p->h264_level,
> > +		       p->width, p->height, p->buf_width, p->buf_height,
> > +		       p->frm_rate, p->bitrate, p->intra_period);
> > +}
> > +
> > +static int vidioc_venc_s_fmt(struct file *file, void *priv,
> > +			     struct v4l2_format *f)
> 
> I am not convinced that combining capture and output in one function is the
> most readable. I think you are better off with separate functions. Too much is
> different between the two.
> 
Got it. We will separate it to vidioc_venc_s_fmt_cap and
vidioc_venc_s_fmt_out.

> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> > +	struct vb2_queue *vq;
> > +	struct mtk_q_data *q_data;
> > +	struct venc_enc_prm param;
> > +	int i, ret;
> > +	struct mtk_video_fmt *fmt;
> > +
> > +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> > +	if (!vq) {
> > +		mtk_v4l2_err("fail to get vq\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (vb2_is_busy(vq)) {
> > +		mtk_v4l2_err("queue busy\n");
> > +		return -EBUSY;
> > +	}
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, f->type);
> > +	if (!q_data) {
> > +		mtk_v4l2_err("fail to get q data\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	fmt = mtk_venc_find_format(f);
> > +	if (!fmt) {
> > +		if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +			f->fmt.pix.pixelformat = mtk_video_formats[0].fourcc;
> > +			fmt = mtk_venc_find_format(f);
> > +		} else {
> > +			f->fmt.pix.pixelformat = mtk_video_formats[8].fourcc;
> > +			fmt = mtk_venc_find_format(f);
> > +		}
> > +	}
> > +
> > +	q_data->fmt = fmt;
> > +	ret = vidioc_try_fmt(f, q_data->fmt);
> > +	if (ret)
> > +		return ret;
> > +
> > +	q_data->width		= f->fmt.pix_mp.width;
> > +	q_data->height		= f->fmt.pix_mp.height;
> > +	q_data->field		= f->fmt.pix_mp.field;
> > +
> > +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		q_data->colorspace = f->fmt.pix_mp.colorspace;
> > +		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[0] =
> > +			ALIGN(q_data->width, 16);
> > +
> > +		if (q_data->fmt->num_planes == 2) {
> > +			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[1] =
> > +				ALIGN(q_data->width, 16);
> > +			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[2] = 0;
> > +		} else {
> > +			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[1] =
> > +				ALIGN(q_data->width, 16) / 2;
> > +			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[2] =
> > +				ALIGN(q_data->width, 16) / 2;
> > +		}
> > +
> > +		memset(&param, 0, sizeof(param));
> > +		mtk_venc_set_param(ctx, &param);
> > +		if (ctx->state == MTK_STATE_INIT) {
> > +			ret = venc_if_set_param(ctx,
> > +						VENC_SET_PARAM_ENC,
> > +						&param);
> > +			if (ret)
> > +				mtk_v4l2_err("venc_if_set_param failed=%d\n",
> > +						ret);
> > +
> > +			/* Get codec driver advice sizeimage from vpu */
> > +			for (i = 0; i < MTK_VCODEC_MAX_PLANES; i++) {
> > +				q_data->sizeimage[i] = param.sizeimage[i];
> > +				pix_fmt_mp->plane_fmt[i].sizeimage =
> > +					param.sizeimage[i];
> > +			}
> > +			q_data->bytesperline[0] =
> > +				pix_fmt_mp->plane_fmt[0].bytesperline;
> > +			q_data->bytesperline[1] =
> > +				pix_fmt_mp->plane_fmt[1].bytesperline;
> > +			q_data->bytesperline[2] =
> > +				pix_fmt_mp->plane_fmt[2].bytesperline;
> > +		} else {
> > +			for (i = 0; i < MTK_VCODEC_MAX_PLANES; i++) {
> > +				q_data->sizeimage[i] =
> > +					pix_fmt_mp->plane_fmt[i].sizeimage;
> > +				q_data->bytesperline[i] =
> > +					pix_fmt_mp->plane_fmt[i].bytesperline;
> > +			}
> > +		}
> > +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE){
> > +		for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
> > +			struct v4l2_plane_pix_format	*plane_fmt;
> > +
> > +			plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
> > +			q_data->bytesperline[i]	= plane_fmt->bytesperline;
> > +			q_data->sizeimage[i]	= plane_fmt->sizeimage;
> > +		}
> > +
> > +		if (ctx->state == MTK_STATE_FREE) {
> > +			ret = venc_if_create(ctx, q_data->fmt->fourcc);
> > +			if (ret) {
> > +				mtk_v4l2_err("venc_if_create failed=%d, codec type=%x\n",
> > +					ret, q_data->fmt->fourcc);
> > +				return 0;
> > +			}
> > +
> > +			ctx->state = MTK_STATE_INIT;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_venc_g_fmt(struct file *file, void *priv,
> > +			     struct v4l2_format *f)
> > +{
> > +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	struct vb2_queue *vq;
> > +	struct mtk_q_data *q_data;
> > +	int i;
> > +
> > +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> > +	if (!vq)
> > +		return -EINVAL;
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, f->type);
> > +
> > +	pix->width = q_data->width;
> > +	pix->height = q_data->height;
> > +	pix->pixelformat = q_data->fmt->fourcc;
> > +	pix->field = q_data->field;
> > +	pix->colorspace = q_data->colorspace;
> > +	pix->num_planes = q_data->fmt->num_planes;
> > +	for (i = 0; i < pix->num_planes; i++) {
> > +		pix->plane_fmt[i].bytesperline = q_data->bytesperline[i];
> > +		pix->plane_fmt[i].sizeimage = q_data->sizeimage[i];
> > +		memset(&(pix->plane_fmt[i].reserved[0]), 0x0,
> > +			sizeof(pix->plane_fmt[i].reserved));
> > +	}
> > +	pix->flags = 0;
> > +	pix->ycbcr_enc = 0;
> > +	pix->quantization = 0;
> > +	pix->xfer_func = 0;
> > +	memset(&pix->reserved[0], 0x0, sizeof(pix->reserved));
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv,
> > +                                  struct v4l2_format *f)
> > +{
> > +        struct mtk_video_fmt *fmt;
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +
> > +        fmt = mtk_venc_find_format(f);
> > +        if (!fmt) {
> > +                f->fmt.pix.pixelformat = mtk_video_formats[8].fourcc;
> > +                fmt = mtk_venc_find_format(f);
> > +        }
> > +        if (fmt->type != MTK_FMT_ENC) {
> > +		mtk_v4l2_err("Fourcc format (0x%08x) invalid.\n",
> > +			     f->fmt.pix.pixelformat);
> > +		return -EINVAL;
> > +        }
> > +        f->fmt.pix_mp.colorspace = ctx->q_data[MTK_Q_DATA_SRC].colorspace;
> > +
> > +        return vidioc_try_fmt(f, fmt);
> > +}
> > +
> > +static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
> > +                                  struct v4l2_format *f)
> > +{
> > +        struct mtk_video_fmt *fmt;
> > +
> > +        fmt = mtk_venc_find_format(f);
> > +        if (!fmt) {
> > +                f->fmt.pix.pixelformat = mtk_video_formats[0].fourcc;
> > +                fmt = mtk_venc_find_format(f);
> > +        }
> > +        if (!(fmt->type & MTK_FMT_FRAME)) {
> > +		mtk_v4l2_err("Fourcc format (0x%08x) invalid.\n",
> > +			     f->fmt.pix.pixelformat);
> > +		return -EINVAL;
> > +        }
> > +        if (!f->fmt.pix_mp.colorspace)
> > +                f->fmt.pix_mp.colorspace = V4L2_COLORSPACE_REC709;
> > +
> > +        return vidioc_try_fmt(f, fmt);
> > +}
> > +
> > +static int vidioc_venc_g_s_selection(struct file *file, void *priv,
> > +                                struct v4l2_selection *s)
> 
> Why support s_selection if you can only return the current width and height?
> And why support g_selection if you can't change the selection?
> 
> In other words, why implement this at all?
> 
> Unless I am missing something here, I would just drop this.
> 
Now our driver do not support these capabilities, but userspace app will
check whether g/s_crop are implemented when using encoder.
Because g/s_crop are deprecated as you mentioned in previous v2 review
comments. We change to use g_s_selection.
We will check if we could add this capability.

> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	struct mtk_q_data *q_data;
> > +
> > +	if (V4L2_TYPE_IS_OUTPUT(s->type)) {
> > +		if (s->target !=  V4L2_SEL_TGT_COMPOSE)
> > +			return -EINVAL;
> > +	} else {
> > +		if (s->target != V4L2_SEL_TGT_CROP)
> > +			return -EINVAL;
> > +	}
> > +
> > +	if (s->r.left || s->r.top)
> > +		return -EINVAL;
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, s->type);
> > +	if (!q_data)
> > +		return -EINVAL;
> > +
> > +	s->r.width = q_data->width;
> > +	s->r.height = q_data->height;
> > +
> > +	return 0;
> > +}
> > +
> > +
> > +static int vidioc_venc_qbuf(struct file *file, void *priv,
> > +			    struct v4l2_buffer *buf)
> > +{
> > +
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +
> > +	if (ctx->state == MTK_STATE_ABORT) {
> > +		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error\n", ctx->idx);
> > +		return -EIO;
> > +	}
> > +
> > +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> > +}
> > +
> > +static int vidioc_venc_dqbuf(struct file *file, void *priv,
> > +			     struct v4l2_buffer *buf)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	if (ctx->state == MTK_STATE_ABORT) {
> > +		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error\n", ctx->idx);
> > +		return -EIO;
> > +	}
> > +
> > +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> > +}
> > +
> > +
> > +const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
> > +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> > +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
> > +
> > +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> > +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> > +	.vidioc_qbuf			= vidioc_venc_qbuf,
> > +	.vidioc_dqbuf			= vidioc_venc_dqbuf,
> > +
> > +	.vidioc_querycap		= vidioc_venc_querycap,
> > +	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
> > +	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
> > +	.vidioc_enum_framesizes		= vidioc_enum_framesizes,
> > +
> > +	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
> > +	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
> > +	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
> 
> Please add vidioc_create_bufs and vidioc_prepare_buf as well.
> 

Currently we do not support these use cases, do we need to add
vidioc_create_bufs and vidioc_prepare_buf now?


> > +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> > +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> > +
> > +	.vidioc_s_parm			= vidioc_venc_s_parm,
> > +
> > +	.vidioc_s_fmt_vid_cap_mplane	= vidioc_venc_s_fmt,
> > +	.vidioc_s_fmt_vid_out_mplane	= vidioc_venc_s_fmt,
> > +
> > +	.vidioc_g_fmt_vid_cap_mplane	= vidioc_venc_g_fmt,
> > +	.vidioc_g_fmt_vid_out_mplane	= vidioc_venc_g_fmt,
> > +
> > +	.vidioc_g_selection		= vidioc_venc_g_s_selection,
> > +	.vidioc_s_selection		= vidioc_venc_g_s_selection,
> > +};
> > +
> > +static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
> > +				   const void *parg,
> > +				   unsigned int *nbuffers,
> > +				   unsigned int *nplanes,
> > +				   unsigned int sizes[], void *alloc_ctxs[])
> > +{
> > +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vq);
> > +	struct mtk_q_data *q_data;
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, vq->type);
> > +
> > +	if (*nbuffers < 1)
> > +		*nbuffers = 1;
> 
> *nbuffers can never be 0, so no need to check.
> 
We will remove this in next version.

> > +	if (*nbuffers > MTK_VIDEO_MAX_FRAME)
> 
> That should be (q->num_buffers + *nbuffers > MTK_VIDEO_MAX_FRAME)
> 
We will fix this in next version.

> > +		*nbuffers = MTK_VIDEO_MAX_FRAME;
> 
> and *nbuffers = MTK_VIDEO_MAX_FRAME - q->num_buffers;
> 
> And you will need a check if q->num_buffers == MTK_VIDEO_MAX_FRAME) too
> (otherwise *nbuffers could become <= 0).
> 
> In order to correctly handle create_bufs you will need to make a few changes
> here. Read the queue_setup description in include/media/videobuf2-core.h and
> look at queue_setup() in Documentation/video4linux/v4l2-pci-skeleton.c.
> 
Got it. We will check this.


> > +
> > +	*nplanes = q_data->fmt->num_planes;
> > +
> > +	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		unsigned int i;
> > +
> > +		for (i = 0; i < *nplanes; i++) {
> > +			sizes[i] = q_data->sizeimage[i];
> > +			alloc_ctxs[i] = ctx->dev->alloc_ctx;
> > +		}
> > +	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		sizes[0] = q_data->sizeimage[0];
> > +		alloc_ctxs[0] = ctx->dev->alloc_ctx;
> > +	} else {
> > +		return -EINVAL;
> > +	}
> > +
> > +	mtk_v4l2_debug(2, "[%d]get %d buffer(s) of size 0x%x each, vq->memory=%d",
> > +		       ctx->idx, *nbuffers, sizes[0], vq->memory);
> > +
> > +	return 0;
> > +}
> > +
> > +static int vb2ops_venc_buf_prepare(struct vb2_buffer *vb)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> > +	struct mtk_q_data *q_data;
> > +	int i;
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, vb->vb2_queue->type);
> > +
> > +	for (i = 0; i < q_data->fmt->num_planes; i++) {
> > +		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
> > +			mtk_v4l2_debug(2, "data will not fit into plane %d (%lu < %d)",
> > +				       i, vb2_plane_size(vb, i),
> > +				       q_data->sizeimage[i]);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void vb2ops_venc_buf_queue(struct vb2_buffer *vb)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> > +	struct vb2_v4l2_buffer *vb2_v4l2 =
> > +			container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
> > +	struct mtk_video_enc_buf *mtk_buf =
> > +			container_of(vb2_v4l2, struct mtk_video_enc_buf, vb);
> > +
> > +	if ((vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
> > +		(ctx->param_change != MTK_ENCODE_PARAM_NONE)) {
> > +		mtk_v4l2_debug(1,
> > +				"[%d] Before id=%d encode parameter change %x",
> > +				ctx->idx, vb->index,
> > +				ctx->param_change);
> > +		mtk_buf->param_change = ctx->param_change;
> > +		if (mtk_buf->param_change & MTK_ENCODE_PARAM_BITRATE) {
> > +			mtk_buf->enc_params.bitrate = ctx->enc_params.bitrate;
> > +			mtk_v4l2_debug(1, "[%d] idx=%d change param br=%d",
> > +				ctx->idx,
> > +				mtk_buf->vb.vb2_buf.index,
> > +				mtk_buf->enc_params.bitrate);
> > +		}
> > +		if (ctx->param_change & MTK_ENCODE_PARAM_FRAMERATE) {
> > +			mtk_buf->enc_params.framerate_num =
> > +				ctx->enc_params.framerate_num;
> > +			mtk_buf->enc_params.framerate_denom =
> > +				ctx->enc_params.framerate_denom;
> > +			mtk_v4l2_debug(1, "[%d] idx=%d, change param fr=%d/%d",
> > +					ctx->idx,
> > +					mtk_buf->vb.vb2_buf.index,
> > +					mtk_buf->enc_params.framerate_num,
> > +					mtk_buf->enc_params.framerate_denom);
> > +		}
> > +		if (ctx->param_change & MTK_ENCODE_PARAM_INTRA_PERIOD) {
> > +			mtk_buf->enc_params.gop_size = ctx->enc_params.gop_size;
> > +			mtk_v4l2_debug(1, "[%d] idx=%d, change param intra period=%d",
> > +					ctx->idx,
> > +					mtk_buf->vb.vb2_buf.index,
> > +					mtk_buf->enc_params.gop_size);
> > +		}
> > +		if (ctx->param_change & MTK_ENCODE_PARAM_FRAME_TYPE) {
> > +			mtk_buf->enc_params.force_intra =
> > +				ctx->enc_params.force_intra;
> > +			mtk_v4l2_debug(1, "[%d] idx=%d, change param force I=%d",
> > +					ctx->idx,
> > +					mtk_buf->vb.vb2_buf.index,
> > +					mtk_buf->enc_params.force_intra);
> > +		}
> > +		ctx->param_change = MTK_ENCODE_PARAM_NONE;
> > +	}
> > +
> > +	v4l2_m2m_buf_queue(ctx->m2m_ctx, to_vb2_v4l2_buffer(vb));
> > +}
> > +
> > +static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> > +	struct venc_enc_prm param;
> > +	int ret;
> > +	int i;
> > +
> > +	/* Once state turn into MTK_STATE_ABORT, we need stop_streaming to clear it */
> > +	if ((ctx->state == MTK_STATE_ABORT) || (ctx->state == MTK_STATE_FREE))
> > +		goto err_set_param;
> > +
> > +	if (!(vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q) &
> > +	      vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q))) {
> > +		mtk_v4l2_debug(1, "[%d]-> out=%d cap=%d",
> > +		 ctx->idx,
> > +		 vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q),
> > +		 vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q));
> > +		return 0;
> > +	}
> > +
> > +	mtk_venc_set_param(ctx, &param);
> > +	ret = venc_if_set_param(ctx,
> > +				VENC_SET_PARAM_ENC,
> > +				&param);
> > +	if (ret) {
> > +		mtk_v4l2_err("venc_if_set_param failed=%d\n", ret);
> > +		ctx->state = MTK_STATE_ABORT;
> > +		goto err_set_param;
> > +	}
> > +
> > +	if ((ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc == V4L2_PIX_FMT_H264) &&
> > +	    (ctx->enc_params.seq_hdr_mode != V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE)) {
> > +		ret = venc_if_set_param(ctx,
> > +					VENC_SET_PARAM_PREPEND_HEADER,
> > +					0);
> > +		if (ret) {
> > +			mtk_v4l2_err("venc_if_set_param failed=%d\n", ret);
> > +			ctx->state = MTK_STATE_ABORT;
> > +			goto err_set_param;
> > +		}
> > +		ctx->state = MTK_STATE_HEADER;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_set_param:
> > +	for (i = 0; i < q->num_buffers; ++i) {
> > +		if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
> > +			mtk_v4l2_debug(0, "[%d] idx=%d, type=%d, %d -> VB2_BUF_STATE_QUEUED",
> > +					ctx->idx, i, q->type,
> > +					(int)q->bufs[i]->state );
> > +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(q->bufs[i]), VB2_BUF_STATE_QUEUED);
> > +		}
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> > +	struct vb2_buffer *src_buf, *dst_buf;
> > +	int ret;
> > +
> > +	mtk_v4l2_debug(2, "[%d]-> type=%d", ctx->idx, q->type);
> > +
> > +	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
> > +			dst_buf->planes[0].bytesused = 0;
> > +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
> > +						VB2_BUF_STATE_ERROR);
> > +		}
> > +	} else {
> > +		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)))
> > +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> > +						VB2_BUF_STATE_ERROR);
> > +	}
> > +
> > +	if ((q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> > +	     vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q)) ||
> > +	    (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
> > +	     vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q))) {
> > +		mtk_v4l2_debug(1, "[%d]-> q type %d out=%d cap=%d",
> > +			       ctx->idx, q->type,
> > +			       vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q),
> > +			       vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q));
> > +		return;
> > +	}
> > +
> > +	ret = venc_if_release(ctx);
> > +	if (ret)
> > +		mtk_v4l2_err("venc_if_release failed=%d\n", ret);
> > +
> > +	ctx->state = MTK_STATE_FREE;
> > +}
> > +
> > +static struct vb2_ops mtk_venc_vb2_ops = {
> > +	.queue_setup			= vb2ops_venc_queue_setup,
> > +	.buf_prepare			= vb2ops_venc_buf_prepare,
> > +	.buf_queue			= vb2ops_venc_buf_queue,
> > +	.wait_prepare			= vb2_ops_wait_prepare,
> > +	.wait_finish			= vb2_ops_wait_finish,
> > +	.start_streaming		= vb2ops_venc_start_streaming,
> > +	.stop_streaming			= vb2ops_venc_stop_streaming,
> > +};
> > +
> > +static int mtk_venc_encode_header(void *priv)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = priv;
> > +	int ret;
> > +	struct vb2_buffer *dst_buf;
> > +	struct mtk_vcodec_mem bs_buf;
> > +	struct venc_done_result enc_result;
> > +
> > +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> > +	if (!dst_buf) {
> > +		mtk_v4l2_debug(1, "No dst buffer");
> > +		return -EINVAL;
> > +	}
> > +
> > +	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
> > +	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> > +	bs_buf.size = (unsigned int)dst_buf->planes[0].length;
> > +
> > +	mtk_v4l2_debug(1,
> > +			"[%d] buf idx=%d va=0x%p dma_addr=0x%llx size=0x%lx",
> > +			ctx->idx,
> > +			dst_buf->index, bs_buf.va,
> > +			(u64)bs_buf.dma_addr,
> > +			bs_buf.size);
> > +
> > +	ret = venc_if_encode(ctx,
> > +			VENC_START_OPT_ENCODE_SEQUENCE_HEADER,
> > +			0, &bs_buf, &enc_result);
> > +
> > +	if (ret) {
> > +		dst_buf->planes[0].bytesused = 0;
> > +		ctx->state = MTK_STATE_ABORT;
> > +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_ERROR);
> > +		mtk_v4l2_err("venc_if_encode failed=%d", ret);
> > +		return -EINVAL;
> > +	}
> > +
> > +	ctx->state = MTK_STATE_HEADER;
> > +	dst_buf->planes[0].bytesused = enc_result.bs_size;
> > +
> > +#if defined(DEBUG)
> > +{
> > +	int i;
> > +	mtk_v4l2_debug(1, "[%d] venc_if_encode header len=%d",
> > +			ctx->idx,
> > +			enc_result.bs_size);
> > +	for (i = 0; i < enc_result.bs_size; i++) {
> > +		unsigned char *p = (unsigned char *)bs_buf.va;
> > +
> > +		mtk_v4l2_debug(1, "[%d] buf[%d]=0x%2x", ctx->idx, i, p[i]);
> > +	}
> > +}
> > +#endif
> > +	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_venc_param_change(struct mtk_vcodec_ctx *ctx, void *priv)
> > +{
> > +	struct vb2_buffer *vb = priv;
> > +	struct vb2_v4l2_buffer *vb2_v4l2 =
> > +			container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
> > +	struct mtk_video_enc_buf *mtk_buf =
> > +			container_of(vb2_v4l2, struct mtk_video_enc_buf, vb);
> > +	int ret = 0;
> > +
> > +	if (mtk_buf->param_change == MTK_ENCODE_PARAM_NONE)
> > +		return 0;
> > +
> > +	mtk_v4l2_debug(1, "encode parameters change id=%d", vb->index);
> > +	if (mtk_buf->param_change & MTK_ENCODE_PARAM_BITRATE) {
> > +		struct venc_enc_prm enc_prm;
> > +
> > +		enc_prm.bitrate = mtk_buf->enc_params.bitrate;
> > +		mtk_v4l2_debug(1, "[%d] idx=%d, change param br=%d",
> > +				ctx->idx,
> > +				mtk_buf->vb.vb2_buf.index,
> > +				enc_prm.bitrate);
> > +		ret |= venc_if_set_param(ctx,
> > +					 VENC_SET_PARAM_ADJUST_BITRATE,
> > +					 &enc_prm);
> > +	}
> > +	if (mtk_buf->param_change & MTK_ENCODE_PARAM_FRAMERATE) {
> > +		struct venc_enc_prm enc_prm;
> > +
> > +		enc_prm.frm_rate = mtk_buf->enc_params.framerate_num /
> > +				   mtk_buf->enc_params.framerate_denom;
> > +		mtk_v4l2_debug(1, "[%d] idx=%d, change param fr=%d",
> > +			       ctx->idx,
> > +			       mtk_buf->vb.vb2_buf.index,
> > +			       enc_prm.frm_rate);
> > +		ret |= venc_if_set_param(ctx,
> > +					 VENC_SET_PARAM_ADJUST_FRAMERATE,
> > +					 &enc_prm);
> > +	}
> > +	if (mtk_buf->param_change & MTK_ENCODE_PARAM_INTRA_PERIOD) {
> > +		mtk_v4l2_debug(1, "change param intra period=%d",
> > +				 mtk_buf->enc_params.gop_size);
> > +		ret |= venc_if_set_param(ctx,
> > +					 VENC_SET_PARAM_I_FRAME_INTERVAL,
> > +					 &mtk_buf->enc_params.gop_size);
> > +	}
> > +	if (mtk_buf->param_change & MTK_ENCODE_PARAM_FRAME_TYPE) {
> > +		mtk_v4l2_debug(1, "[%d] idx=%d, change param force I=%d",
> > +				ctx->idx,
> > +				mtk_buf->vb.vb2_buf.index,
> > +				mtk_buf->enc_params.force_intra);
> > +		if (mtk_buf->enc_params.force_intra)
> > +			ret |= venc_if_set_param(ctx,
> > +						 VENC_SET_PARAM_FORCE_INTRA,
> > +						 0);
> > +	}
> > +
> > +	mtk_buf->param_change = MTK_ENCODE_PARAM_NONE;
> > +
> > +	if (ret) {
> > +		ctx->state = MTK_STATE_ABORT;
> > +		mtk_v4l2_err("venc_if_set_param %d failed=%d\n",
> > +			MTK_ENCODE_PARAM_FRAME_TYPE, ret);
> > +		return -1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void mtk_venc_worker(struct work_struct *work)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
> > +				    encode_work);
> > +	struct vb2_buffer *src_buf, *dst_buf;
> > +	struct venc_frm_buf frm_buf;
> > +	struct mtk_vcodec_mem bs_buf;
> > +	struct venc_done_result enc_result;
> > +	int ret;
> > +	struct vb2_v4l2_buffer *v4l2_vb;
> > +
> > +	if ((ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc == V4L2_PIX_FMT_H264) &&
> > +	    (ctx->state != MTK_STATE_HEADER)) {
> > +		/* encode h264 sps/pps header */
> > +		mtk_venc_encode_header(ctx);
> > +		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> > +		return;
> > +	}
> > +
> > +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> > +	if (!src_buf) {
> > +		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> > +		return;
> > +	}
> > +
> > +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> > +	if (!dst_buf) {
> > +		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> > +		return;
> > +	}
> > +
> > +	mtk_venc_param_change(ctx, src_buf);
> > +
> > +	frm_buf.fb_addr.va = vb2_plane_vaddr(src_buf, 0);
> > +	frm_buf.fb_addr.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> > +	frm_buf.fb_addr.size = (unsigned int)src_buf->planes[0].length;
> > +	frm_buf.fb_addr1.va = vb2_plane_vaddr(src_buf, 1);
> > +	frm_buf.fb_addr1.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 1);
> > +	frm_buf.fb_addr1.size = (unsigned int)src_buf->planes[1].length;
> > +	if (src_buf->num_planes == 3) {
> > +		frm_buf.fb_addr2.va = vb2_plane_vaddr(src_buf, 2);
> > +		frm_buf.fb_addr2.dma_addr =
> > +			vb2_dma_contig_plane_dma_addr(src_buf, 2);
> > +		frm_buf.fb_addr2.size =
> > +			(unsigned int)src_buf->planes[2].length;
> > +	} else {
> > +		frm_buf.fb_addr2.va = NULL;
> > +		frm_buf.fb_addr2.dma_addr = 0;
> > +		frm_buf.fb_addr2.size = 0;
> > +	}
> > +	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
> > +	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> > +	bs_buf.size = (unsigned int)dst_buf->planes[0].length;
> > +
> > +	mtk_v4l2_debug(2,
> > +			"Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx",
> > +			frm_buf.fb_addr.va,
> > +			(u64)frm_buf.fb_addr.dma_addr,
> > +			frm_buf.fb_addr.size,
> > +			frm_buf.fb_addr1.va,
> > +			(u64)frm_buf.fb_addr1.dma_addr,
> > +			frm_buf.fb_addr1.size,
> > +			frm_buf.fb_addr2.va,
> > +			(u64)frm_buf.fb_addr2.dma_addr,
> > +			frm_buf.fb_addr2.size);
> > +
> > +	ret = venc_if_encode(ctx, VENC_START_OPT_ENCODE_FRAME,
> > +			     &frm_buf, &bs_buf, &enc_result);
> > +
> > +	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> > +	if (enc_result.msg == VENC_MESSAGE_OK)
> > +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_DONE);
> > +	else
> > +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_ERROR);
> > +
> > +	if (enc_result.is_key_frm) {
> > +		v4l2_vb = to_vb2_v4l2_buffer(dst_buf);
> > +		v4l2_vb->flags |= V4L2_BUF_FLAG_KEYFRAME;
> > +	}
> > +
> > +	if (ret) {
> > +		dst_buf->planes[0].bytesused = 0;
> > +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_ERROR);
> > +		mtk_v4l2_err("venc_if_encode failed=%d", ret);
> > +	} else {
> > +		dst_buf->planes[0].bytesused = enc_result.bs_size;
> > +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
> > +		mtk_v4l2_debug(2, "venc_if_encode bs size=%d",
> > +				 enc_result.bs_size);
> > +	}
> > +
> > +	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> > +
> > +	mtk_v4l2_debug(1, "<=== src_buf[%d] dst_buf[%d] venc_if_encode ret=%d Size=%u===>",
> > +			src_buf->index, dst_buf->index, ret,
> > +			enc_result.bs_size);
> > +}
> > +
> > +static void m2mops_venc_device_run(void *priv)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = priv;
> 
> Add empty line.
> 
We will fix this.

> > +	queue_work(ctx->dev->encode_workqueue, &ctx->encode_work);
> > +}
> > +
> > +static int m2mops_venc_job_ready(void *m2m_priv)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> > +
> > +	if (!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)) {
> > +		mtk_v4l2_debug(3, "[%d]Not ready: not enough video dst buffers.",
> > +			       ctx->idx);
> > +		return 0;
> > +	}
> > +
> > +	if (!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx)) {
> > +		mtk_v4l2_debug(3, "[%d]Not ready: not enough video src buffers.",
> > +			       ctx->idx);
> > +			return 0;
> > +		}
> 
> Broken indentation.
> 
We will fix this.

> > +
> > +	if (ctx->state == MTK_STATE_ABORT) {
> > +		mtk_v4l2_debug(3, "[%d]Not ready: state=0x%x.",
> > +			       ctx->idx, ctx->state);
> > +		return 0;
> > +	}
> > +
> > +	if (ctx->state == MTK_STATE_FREE) {
> > +		mtk_v4l2_debug(3, "[%d]Not ready: state=0x%x.",
> > +			       ctx->idx, ctx->state);
> > +		return 0;
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> > +static void m2mops_venc_job_abort(void *priv)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = priv;
> > +
> > +	ctx->state = MTK_STATE_ABORT;
> > +}
> > +
> > +static void m2mops_venc_lock(void *m2m_priv)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> > +
> > +	mutex_lock(&ctx->dev->dev_mutex);
> > +}
> > +
> > +static void m2mops_venc_unlock(void *m2m_priv)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> > +
> > +	mutex_unlock(&ctx->dev->dev_mutex);
> > +}
> > +
> > +const struct v4l2_m2m_ops mtk_venc_m2m_ops = {
> > +	.device_run			= m2mops_venc_device_run,
> > +	.job_ready			= m2mops_venc_job_ready,
> > +	.job_abort			= m2mops_venc_job_abort,
> > +	.lock				= m2mops_venc_lock,
> > +	.unlock				= m2mops_venc_unlock,
> > +};
> > +
> > +#define IS_MTK_VENC_PRIV(x) ((V4L2_CTRL_ID2CLASS(x) == V4L2_CTRL_CLASS_MPEG) &&\
> > +			     V4L2_CTRL_DRIVER_PRIV(x))
> > +
> > +void mtk_vcodec_enc_ctx_params_setup(struct mtk_vcodec_ctx *ctx)
> > +{
> > +	struct mtk_q_data *q_data;
> > +	struct mtk_video_fmt *fmt;
> > +
> > +	ctx->m2m_ctx->q_lock = &ctx->dev->dev_mutex;
> > +	ctx->fh.m2m_ctx = ctx->m2m_ctx;
> > +	ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
> > +	INIT_WORK(&ctx->encode_work, mtk_venc_worker);
> > +
> > +	ctx->q_data[MTK_Q_DATA_SRC].width = DFT_CFG_WIDTH;
> > +	ctx->q_data[MTK_Q_DATA_SRC].height = DFT_CFG_HEIGHT;
> > +	ctx->q_data[MTK_Q_DATA_SRC].fmt = &mtk_video_formats[0];
> > +	ctx->q_data[MTK_Q_DATA_SRC].colorspace = V4L2_COLORSPACE_REC709;
> > +	ctx->q_data[MTK_Q_DATA_SRC].field = V4L2_FIELD_NONE;
> > +
> > +	q_data = &ctx->q_data[MTK_Q_DATA_SRC];
> > +	fmt = ctx->q_data[MTK_Q_DATA_SRC].fmt;
> > +	mtk_vcodec_enc_calc_src_size(fmt->num_planes, q_data->width,
> > +			q_data->height,
> > +			ctx->q_data[MTK_Q_DATA_SRC].sizeimage,
> > +			ctx->q_data[MTK_Q_DATA_SRC].bytesperline);
> > +
> > +	ctx->q_data[MTK_Q_DATA_DST].width = DFT_CFG_WIDTH;
> > +	ctx->q_data[MTK_Q_DATA_DST].height = DFT_CFG_HEIGHT;
> > +	ctx->q_data[MTK_Q_DATA_DST].fmt = &mtk_video_formats[9];
> > +	ctx->q_data[MTK_Q_DATA_DST].colorspace = V4L2_COLORSPACE_REC709;
> > +	ctx->q_data[MTK_Q_DATA_DST].field = V4L2_FIELD_NONE;
> > +
> > +	q_data = &ctx->q_data[MTK_Q_DATA_DST];
> > +	fmt = ctx->q_data[MTK_Q_DATA_DST].fmt;
> > +	ctx->q_data[MTK_Q_DATA_DST].sizeimage[0] = q_data->width * q_data->height;
> > +	ctx->q_data[MTK_Q_DATA_DST].bytesperline[0] = 0;
> > +
> > +}
> > +
> > +int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx)
> > +{
> > +	const struct v4l2_ctrl_ops *ops = &mtk_vcodec_enc_ctrl_ops;
> > +	struct v4l2_ctrl_handler *handler = &ctx->ctrl_hdl;
> > +	struct v4l2_ctrl_config cfg;
> > +
> > +	v4l2_ctrl_handler_init(handler, MTK_MAX_CTRLS);
> > +	if (handler->error) {
> > +		mtk_v4l2_err("Init control handler fail %d\n",
> > +				handler->error);
> > +		return handler->error;
> > +	}
> 
> Move this check to just before the v4l2_ctrl_handler_setup(). Any of the
> v4l2_ctrl_new_std* functions can set handler->error, which is why it should
> be check after all controls are added.
> 
Got it. Will move it just before the v4l2_ctrl_handler_setup().

> > +
> > +	ctx->ctrls[0] = v4l2_ctrl_new_std(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_BITRATE,
> > +					1, 4000000, 1, 4000000);
> > +	ctx->ctrls[1] = v4l2_ctrl_new_std(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_B_FRAMES,
> > +					0, 2, 1, 0);
> > +	ctx->ctrls[2] = v4l2_ctrl_new_std(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE,
> > +					0, 1, 1, 1);
> > +	ctx->ctrls[3] = v4l2_ctrl_new_std(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_H264_MAX_QP,
> > +					0, 51, 1, 51);
> > +	ctx->ctrls[4] = v4l2_ctrl_new_std(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_H264_I_PERIOD,
> > +					0, 65535, 1, 30);
> > +	ctx->ctrls[5] = v4l2_ctrl_new_std(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_GOP_SIZE,
> > +					0, 65535, 1, 30);
> > +	ctx->ctrls[6] = v4l2_ctrl_new_std(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE,
> > +					0, 1, 1, 0);
> > +	ctx->ctrls[7] = v4l2_ctrl_new_std_menu(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_HEADER_MODE,
> > +					V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
> > +					0, V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE);
> > +	ctx->ctrls[8] = v4l2_ctrl_new_std_menu(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> > +					V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
> > +					0, V4L2_MPEG_VIDEO_H264_PROFILE_MAIN);
> > +	ctx->ctrls[9] = v4l2_ctrl_new_std_menu(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_H264_LEVEL,
> > +					V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
> > +					0, V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
> > +	ctx->ctrls[6] = v4l2_ctrl_new_std(handler, ops,
> > +					V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME,
> > +					0, 0, 0, 0);
> 
> You are overwriting V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE! Why are you assigning it
> anyway? Unless you are using ctx->ctrls[] you don't need to assign the result
> of v4l2_ctrl_new_std to anything.
> 
Got it. We don't use ctx->ctrls. We will remove it in next version.

> > +
> > +	v4l2_ctrl_handler_setup(&ctx->ctrl_hdl);
> > +
> > +	return 0;
> > +}
> > +
> > +int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
> > +			   struct vb2_queue *dst_vq)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = priv;
> > +	int ret;
> > +
> > +	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> 
> I recomment dropping VB2_USERPTR. That only makes sense for scatter-gather dma,
> and you use physically contiguous DMA.
> 
Now our userspace app use VB2_USERPTR. I need to check if we could drop
VB2_USERPTR.
We use src_vq->mem_ops = &vb2_dma_contig_memops;
And there are
	.get_userptr	= vb2_dc_get_userptr,
	.put_userptr	= vb2_dc_put_userptr,
I was confused why it only make sense for scatter-gather.
Could you kindly explain more?

> > +	src_vq->drv_priv	= ctx;
> > +	src_vq->buf_struct_size = sizeof(struct mtk_video_enc_buf);
> > +	src_vq->ops		= &mtk_venc_vb2_ops;
> > +	src_vq->mem_ops		= &vb2_dma_contig_memops;
> > +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	src_vq->lock = &ctx->dev->dev_mutex;
> > +
> > +	ret = vb2_queue_init(src_vq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> > +	dst_vq->drv_priv	= ctx;
> > +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> > +	dst_vq->ops		= &mtk_venc_vb2_ops;
> > +	dst_vq->mem_ops		= &vb2_dma_contig_memops;
> > +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	dst_vq->lock = &ctx->dev->dev_mutex;
> > +
> > +	return vb2_queue_init(dst_vq);
> > +}
> > +
> > +int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx)
> > +{
> > +	struct mtk_vcodec_dev *dev = ctx->dev;
> 
> Add empty line.
> 
Will fix this in next version.

> > +	dev->curr_ctx = -1;
> > +	mutex_unlock(&dev->enc_mutex);
> > +	return 0;
> > +}
> > +
> > +int mtk_venc_lock(struct mtk_vcodec_ctx *ctx)
> > +{
> > +	struct mtk_vcodec_dev *dev = ctx->dev;
> > +
> > +	mutex_lock(&dev->enc_mutex);
> > +	dev->curr_ctx = ctx->idx;
> > +	return 0;
> > +}
> > +
> > +void mtk_vcodec_enc_release(struct mtk_vcodec_ctx *ctx)
> > +{
> > +	venc_if_release(ctx);
> > +}
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> > new file mode 100644
> > index 0000000..e09524b
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> > @@ -0,0 +1,46 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: PC Chen <pc.chen@mediatek.com>
> > +*         Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +
> > +#ifndef _MTK_VCODEC_ENC_H_
> > +#define _MTK_VCODEC_ENC_H_
> > +
> > +#include <media/videobuf2-core.h>
> > +#include <media/videobuf2-v4l2.h>
> > +
> > +/**
> > + * struct mtk_video_enc_buf - Private data related to each VB2 buffer.
> > + * @b:			Pointer to related VB2 buffer.
> > + * @param_change:	Types of encode parameter change before encode this
> > + *			buffer
> > + * @enc_params		Encode parameters changed before encode this buffer
> > + */
> > +struct mtk_video_enc_buf {
> > +	struct vb2_v4l2_buffer	vb;
> > +	struct list_head	list;
> > +
> > +	enum mtk_encode_param param_change;
> > +	struct mtk_enc_params enc_params;
> > +};
> > +
> > +int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx);
> > +int mtk_venc_lock(struct mtk_vcodec_ctx *ctx);
> > +int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
> > +					struct vb2_queue *dst_vq);
> > +void mtk_vcodec_enc_release(struct mtk_vcodec_ctx *ctx);
> > +int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx);
> > +void mtk_vcodec_enc_ctx_params_setup(struct mtk_vcodec_ctx *ctx);
> > +
> > +#endif /* _MTK_VCODEC_ENC_H_ */
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> > new file mode 100644
> > index 0000000..e7ab14a
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> > @@ -0,0 +1,476 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: PC Chen <pc.chen@mediatek.com>
> > +*         Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#include <linux/interrupt.h>
> > +#include <linux/irq.h>
> > +#include <linux/module.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <linux/pm_runtime.h>
> > +
> > +#include "mtk_vcodec_drv.h"
> > +#include "mtk_vcodec_enc.h"
> > +#include "mtk_vcodec_pm.h"
> > +#include "mtk_vcodec_intr.h"
> > +#include "mtk_vcodec_util.h"
> > +#include "mtk_vpu.h"
> > +
> > +
> > +/* Wake up context wait_queue */
> > +static void wake_up_ctx(struct mtk_vcodec_ctx *ctx, unsigned int reason)
> > +{
> > +	ctx->int_cond = 1;
> > +	ctx->int_type = reason;
> > +	wake_up_interruptible(&ctx->queue);
> > +}
> > +
> > +static irqreturn_t mtk_vcodec_enc_irq_handler(int irq, void *priv)
> > +{
> > +	struct mtk_vcodec_dev *dev = priv;
> > +	struct mtk_vcodec_ctx *ctx;
> > +	unsigned int irq_status;
> > +
> > +	if (dev->curr_ctx == -1) {
> > +		mtk_v4l2_err("curr_ctx = -1");
> > +		return IRQ_HANDLED;
> > +	}
> > +
> > +	ctx = dev->ctx[dev->curr_ctx];
> > +	if (ctx == NULL) {
> > +		mtk_v4l2_err("curr_ctx==NULL");
> > +		return IRQ_HANDLED;
> > +	}
> > +	mtk_v4l2_debug(1, "idx=%d", ctx->idx);
> > +	irq_status = readl(dev->reg_base[VENC_SYS] +
> > +				(MTK_VENC_IRQ_STATUS_OFFSET));
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_PAUSE)
> > +		writel((MTK_VENC_IRQ_STATUS_PAUSE),
> > +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_SWITCH)
> > +		writel((MTK_VENC_IRQ_STATUS_SWITCH),
> > +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_DRAM)
> > +		writel((MTK_VENC_IRQ_STATUS_DRAM),
> > +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_SPS)
> > +		writel((MTK_VENC_IRQ_STATUS_SPS),
> > +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_PPS)
> > +		writel((MTK_VENC_IRQ_STATUS_PPS),
> > +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_FRM)
> > +		writel((MTK_VENC_IRQ_STATUS_FRM),
> > +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	ctx->irq_status = irq_status;
> > +	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +#if 1 /* VENC_LT */
> > +static irqreturn_t mtk_vcodec_enc_irq_handler2(int irq, void *priv)
> > +{
> > +	struct mtk_vcodec_dev *dev = priv;
> > +	struct mtk_vcodec_ctx *ctx;
> > +	unsigned int irq_status;
> > +
> > +	ctx = dev->ctx[dev->curr_ctx];
> > +	if (ctx == NULL) {
> > +		mtk_v4l2_err("ctx==NULL");
> > +		return IRQ_HANDLED;
> > +	}
> > +	mtk_v4l2_debug(1, "idx=%d", ctx->idx);
> > +	irq_status = readl(dev->reg_base[VENC_LT_SYS] +
> > +				(MTK_VENC_IRQ_STATUS_OFFSET));
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_PAUSE)
> > +		writel((MTK_VENC_IRQ_STATUS_PAUSE),
> > +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_SWITCH)
> > +		writel((MTK_VENC_IRQ_STATUS_SWITCH),
> > +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_DRAM)
> > +		writel((MTK_VENC_IRQ_STATUS_DRAM),
> > +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_SPS)
> > +		writel((MTK_VENC_IRQ_STATUS_SPS),
> > +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_PPS)
> > +		writel((MTK_VENC_IRQ_STATUS_PPS),
> > +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	if (irq_status & MTK_VENC_IRQ_STATUS_FRM)
> > +		writel((MTK_VENC_IRQ_STATUS_FRM),
> > +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> > +
> > +	ctx->irq_status = irq_status;
> > +	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
> > +	return IRQ_HANDLED;
> > +}
> > +#endif
> > +
> > +static void mtk_vcodec_enc_reset_handler(void *priv)
> > +{
> > +	int i;
> > +	struct mtk_vcodec_dev *dev = priv;
> > +	struct mtk_vcodec_ctx *ctx;
> > +
> > +	mtk_v4l2_debug(0, "Watchdog timeout!!");
> > +
> > +	mutex_lock(&dev->dev_mutex);
> > +	for(i = 0; i < MTK_VCODEC_MAX_ENCODER_INSTANCES; i++) {
> > +		ctx = dev->ctx[i];
> > +		if (ctx) {
> > +			ctx->state = MTK_STATE_ABORT;
> > +			mtk_v4l2_debug(0, "[%d] Change to state MTK_STATE_ERROR", ctx->idx);
> > +		}
> > +
> > +	}
> > +	mutex_unlock(&dev->dev_mutex);
> > +}
> > +
> > +static int fops_vcodec_open(struct file *file)
> > +{
> > +	struct video_device *vfd = video_devdata(file);
> > +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> > +	struct mtk_vcodec_ctx *ctx = NULL;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&dev->dev_mutex);
> > +
> > +	ctx = devm_kzalloc(&dev->plat_dev->dev, sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx) {
> > +		ret = -ENOMEM;
> > +		goto err_alloc;
> > +	}
> > +
> > +	if (dev->num_instances >= MTK_VCODEC_MAX_ENCODER_INSTANCES) {
> > +		mtk_v4l2_err("Too many open contexts\n");
> > +		ret = -EBUSY;
> > +		goto err_no_ctx;
> 
> Hmm. I never like it if you can't open a video node because of a reason like this.
> 
> I.e. a simple 'v4l2-ctl -D' (i.e. calling QUERYCAP) should never fail.
> 
> If there are hardware limitation that prevent more than X instances from running at
> the same time, then those limitations typically kick in when you start to stream
> (or possibly when calling REQBUFS). But before that it should always be possible to
> open the device.
> 
> Having this check at open() is an indication of a poor design.
> 
> Is this is a hardware limitation at all?
> 
This is to make sure performance meet requirements, such as bitrate and
framerate.
We got your point. We will remove this and move limitation control to
start_streaming or REQBUFS.
Appreciated for your suggestion.:)


> > +	}
> > +
> > +	ctx->idx = ffz(dev->instance_mask[0]);
> > +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> > +	file->private_data = &ctx->fh;
> > +	v4l2_fh_add(&ctx->fh);
> > +	ctx->dev = dev;
> > +
> > +	if (vfd == dev->vfd_enc) {
> > +		ctx->type = MTK_INST_ENCODER;
> > +
> > +		ret = mtk_vcodec_enc_ctrls_setup(ctx);
> > +		if (ret) {
> > +			mtk_v4l2_err("Failed to setup controls() (%d)\n",
> > +				       ret);
> > +			goto err_ctrls_setup;
> > +		}
> > +		ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_enc, ctx,
> > +						 &mtk_vcodec_enc_queue_init);
> > +		if (IS_ERR(ctx->m2m_ctx)) {
> > +			ret = PTR_ERR(ctx->m2m_ctx);
> > +			mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)\n",
> > +				       ret);
> > +			goto err_ctx_init;
> > +		}
> > +		mtk_vcodec_enc_ctx_params_setup(ctx);
> > +	} else {
> > +		mtk_v4l2_err("Invalid vfd !\n");
> > +		ret = -ENOENT;
> > +		goto err_ctx_init;
> > +	}
> > +
> > +	init_waitqueue_head(&ctx->queue);
> > +	dev->num_instances++;
> > +
> > +	if (dev->num_instances == 1) {
> 
> Having a counter is also not needed. You can use v4l2_fh_is_singular() to check if this
> is the first open.
> 
Got it. Thanks for your information.

> > +		ret = vpu_load_firmware(dev->vpu_plat_dev);
> > +		if (ret < 0) {
> > +				mtk_v4l2_err("vpu_load_firmware failed!\n");
> > +			goto err_load_fw;
> > +		}
> > +
> > +		dev->enc_capability =
> > +			vpu_get_venc_hw_capa(dev->vpu_plat_dev);
> > +		mtk_v4l2_debug(0, "encoder capability %x", dev->enc_capability);
> > +	}
> > +
> > +	mtk_v4l2_debug(2, "Create instance [%d]@%p m2m_ctx=%p type=%d\n",
> > +			 ctx->idx, ctx, ctx->m2m_ctx, ctx->type);
> > +	set_bit(ctx->idx, &dev->instance_mask[0]);
> > +	dev->ctx[ctx->idx] = ctx;
> > +
> > +	mutex_unlock(&dev->dev_mutex);
> > +	mtk_v4l2_debug(0, "%s encoder [%d]", dev_name(&dev->plat_dev->dev), ctx->idx);
> > +	return ret;
> > +
> > +	/* Deinit when failure occurred */
> > +err_load_fw:
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	dev->num_instances--;
> > +err_ctx_init:
> > +err_ctrls_setup:
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > +err_no_ctx:
> > +	devm_kfree(&dev->plat_dev->dev, ctx);
> > +err_alloc:
> > +	mutex_unlock(&dev->dev_mutex);
> > +	return ret;
> > +}
> > +
> > +static int fops_vcodec_release(struct file *file)
> > +{
> > +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> > +
> > +	mtk_v4l2_debug(0, "[%d] encoder\n", ctx->idx);
> > +	mutex_lock(&dev->dev_mutex);
> > +
> > +	mtk_vcodec_enc_release(ctx);
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > +
> > +	dev->ctx[ctx->idx] = NULL;
> > +	dev->num_instances--;
> > +	clear_bit(ctx->idx, &dev->instance_mask[0]);
> > +	devm_kfree(&dev->plat_dev->dev, ctx);
> > +	mutex_unlock(&dev->dev_mutex);
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_file_operations mtk_vcodec_fops = {
> > +	.owner				= THIS_MODULE,
> > +	.open				= fops_vcodec_open,
> > +	.release			= fops_vcodec_release,
> > +	.poll				= v4l2_m2m_fop_poll,
> > +	.unlocked_ioctl			= video_ioctl2,
> > +	.mmap				= v4l2_m2m_fop_mmap,
> > +};
> > +
> > +static int mtk_vcodec_probe(struct platform_device *pdev)
> > +{
> > +	struct mtk_vcodec_dev *dev;
> > +	struct video_device *vfd_enc;
> > +	struct resource *res;
> > +	int i, j, ret;
> > +
> > +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> > +	if (!dev)
> > +		return -ENOMEM;
> > +
> > +	dev->plat_dev = pdev;
> > +
> > +	dev->vpu_plat_dev = vpu_get_plat_device(dev->plat_dev);
> > +	if (dev->vpu_plat_dev == NULL) {
> > +		mtk_v4l2_err("[VPU] vpu device in not ready\n");
> > +		return -EPROBE_DEFER;
> > +	}
> > +
> > +	vpu_wdt_reg_handler(dev->vpu_plat_dev, mtk_vcodec_enc_reset_handler, dev,
> > +			    VPU_RST_ENC);
> > +
> > +	ret = mtk_vcodec_init_enc_pm(dev);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "Failed to get mt vcodec clock source!\n");
> > +		return ret;
> > +	}
> > +
> > +	for (i = VENC_SYS, j = 0; i < NUM_MAX_VCODEC_REG_BASE; i++, j++) {
> > +		res = platform_get_resource(pdev, IORESOURCE_MEM, j);
> > +		if (res == NULL) {
> > +			dev_err(&pdev->dev, "get memory resource failed.\n");
> > +			ret = -ENXIO;
> > +			goto err_res;
> > +		}
> > +		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
> > +		if (IS_ERR(dev->reg_base[i])) {
> > +			dev_err(&pdev->dev,
> > +				"devm_ioremap_resource %d failed.\n", i);
> > +			ret = PTR_ERR(dev->reg_base);
> > +			goto err_res;
> > +		}
> > +		mtk_v4l2_debug(2, "reg[%d] base=0x%p\n", i, dev->reg_base[i]);
> > +	}
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +	if (res == NULL) {
> > +		dev_err(&pdev->dev, "failed to get irq resource\n");
> > +		ret = -ENOENT;
> > +		goto err_res;
> > +	}
> > +
> > +	dev->enc_irq = platform_get_irq(pdev, 0);
> > +	ret = devm_request_irq(&pdev->dev, dev->enc_irq,
> > +			       mtk_vcodec_enc_irq_handler,
> > +			       0, pdev->name, dev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to install dev->enc_irq %d (%d)\n",
> > +			dev->enc_irq,
> > +			ret);
> > +		ret = -EINVAL;
> > +		goto err_res;
> > +	}
> > +
> > +	dev->enc_lt_irq = platform_get_irq(pdev, 1);
> > +	ret = devm_request_irq(&pdev->dev,
> > +			       dev->enc_lt_irq, mtk_vcodec_enc_irq_handler2,
> > +			       0, pdev->name, dev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev,
> > +			"Failed to install dev->enc_lt_irq %d (%d)\n",
> > +			dev->enc_lt_irq, ret);
> > +		ret = -EINVAL;
> > +		goto err_res;
> > +	}
> > +
> > +	disable_irq(dev->enc_irq);
> > +	disable_irq(dev->enc_lt_irq); /* VENC_LT */
> > +	mutex_init(&dev->enc_mutex);
> > +	mutex_init(&dev->dev_mutex);
> > +
> > +	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
> > +		 "[MTK_V4L2_VENC]");
> > +
> > +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > +	if (ret) {
> > +		mtk_v4l2_err("v4l2_device_register err=%d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	init_waitqueue_head(&dev->queue);
> > +
> > +	/* allocate video device for encoder and register it */
> > +	vfd_enc = video_device_alloc();
> > +	if (!vfd_enc) {
> > +		mtk_v4l2_err("Failed to allocate video device\n");
> > +		ret = -ENOMEM;
> > +		goto err_enc_alloc;
> > +	}
> > +	vfd_enc->fops           = &mtk_vcodec_fops;
> > +	vfd_enc->ioctl_ops      = &mtk_venc_ioctl_ops;
> > +	vfd_enc->release        = video_device_release;
> > +	vfd_enc->lock           = &dev->dev_mutex;
> > +	vfd_enc->v4l2_dev       = &dev->v4l2_dev;
> > +	vfd_enc->vfl_dir        = VFL_DIR_M2M;
> > +
> > +	snprintf(vfd_enc->name, sizeof(vfd_enc->name), "%s",
> > +		 MTK_VCODEC_ENC_NAME);
> > +	video_set_drvdata(vfd_enc, dev);
> > +	dev->vfd_enc = vfd_enc;
> > +	platform_set_drvdata(pdev, dev);
> > +	ret = video_register_device(vfd_enc, VFL_TYPE_GRABBER, 1);
> > +	if (ret) {
> > +		mtk_v4l2_err("Failed to register video device\n");
> > +		goto err_enc_reg;
> > +	}
> 
> Do the register last. After registering the device anyone can start using it,
> but since not everything is initialized that might cause crashes.
> 
Got it. We will fix this.

> > +	mtk_v4l2_debug(0, "encoder registered as /dev/video%d\n",
> > +			 vfd_enc->num);
> > +
> > +	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> > +	if (IS_ERR(dev->alloc_ctx)) {
> > +		mtk_v4l2_err("Failed to alloc vb2 dma context 0\n");
> > +		ret = PTR_ERR(dev->alloc_ctx);
> > +		goto err_vb2_ctx_init;
> > +	}
> > +
> > +	dev->m2m_dev_enc = v4l2_m2m_init(&mtk_venc_m2m_ops);
> > +	if (IS_ERR(dev->m2m_dev_enc)) {
> > +		mtk_v4l2_err("Failed to init mem2mem enc device\n");
> > +		ret = PTR_ERR(dev->m2m_dev_enc);
> > +		goto err_enc_mem_init;
> > +	}
> > +
> > +	dev->encode_workqueue =
> > +			alloc_ordered_workqueue(MTK_VCODEC_ENC_NAME, WQ_MEM_RECLAIM | WQ_FREEZABLE);
> > +	if (!dev->encode_workqueue) {
> > +		mtk_v4l2_err("Failed to create encode workqueue\n");
> > +		ret = -EINVAL;
> > +		goto err_event_workq;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_event_workq:
> > +	v4l2_m2m_release(dev->m2m_dev_enc);
> > +err_enc_mem_init:
> > +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> > +err_vb2_ctx_init:
> > +	video_unregister_device(vfd_enc);
> > +err_enc_reg:
> > +	video_device_release(vfd_enc);
> > +err_enc_alloc:
> > +	v4l2_device_unregister(&dev->v4l2_dev);
> > +err_res:
> > +	mtk_vcodec_release_enc_pm(dev);
> > +	return ret;
> > +}
> > +
> > +static const struct of_device_id mtk_vcodec_match[] = {
> > +	{.compatible = "mediatek,mt8173-vcodec-enc",},
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, mtk_vcodec_match);
> > +
> > +static int mtk_vcodec_remove(struct platform_device *pdev)
> > +{
> > +	struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
> > +
> > +	mtk_v4l2_debug_enter();
> > +	flush_workqueue(dev->encode_workqueue);
> > +	destroy_workqueue(dev->encode_workqueue);
> > +	if (dev->m2m_dev_enc)
> > +		v4l2_m2m_release(dev->m2m_dev_enc);
> > +	if (dev->alloc_ctx)
> > +		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> > +
> > +	if (dev->vfd_enc) {
> > +		video_unregister_device(dev->vfd_enc);
> > +		video_device_release(dev->vfd_enc);
> 
> Don't call video_device_release! That will happen automatically once the
> last filehandle is closed.
> 
Got it. We will fix this.

> > +	}
> > +	v4l2_device_unregister(&dev->v4l2_dev);
> > +	mtk_vcodec_release_enc_pm(dev);
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver mtk_vcodec_driver = {
> > +	.probe	= mtk_vcodec_probe,
> > +	.remove	= mtk_vcodec_remove,
> > +	.driver	= {
> > +		.name	= MTK_VCODEC_ENC_NAME,
> > +		.owner	= THIS_MODULE,
> > +		.of_match_table = mtk_vcodec_match,
> > +	},
> > +};
> > +
> > +module_platform_driver(mtk_vcodec_driver);
> > +
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_DESCRIPTION("Mediatek video codec V4L2 driver");
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
> > new file mode 100644
> > index 0000000..518fba7
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
> > @@ -0,0 +1,132 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#include <linux/clk.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/pm_runtime.h>
> > +#include <soc/mediatek/smi.h>
> > +
> > +#include "mtk_vcodec_pm.h"
> > +#include "mtk_vcodec_util.h"
> > +#include "mtk_vpu.h"
> > +
> > +
> > +int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
> > +{
> > +	struct device_node *node;
> > +	struct platform_device *pdev;
> > +	struct device *dev;
> > +	struct mtk_vcodec_pm *pm;
> > +	int ret = 0;
> > +
> > +	pdev = mtkdev->plat_dev;
> > +	pm = &mtkdev->pm;
> > +	memset(pm, 0, sizeof(struct mtk_vcodec_pm));
> > +	pm->mtkdev = mtkdev;
> > +	dev = &pdev->dev;
> > +
> > +	node = of_parse_phandle(dev->of_node, "mediatek,larb", 0);
> > +	if (!node)
> > +		return -1;
> > +	pdev = of_find_device_by_node(node);
> > +	if (WARN_ON(!pdev)) {
> > +		of_node_put(node);
> > +		return -1;
> > +	}
> > +	pm->larbvenc = &pdev->dev;
> > +
> > +	node = of_parse_phandle(dev->of_node, "mediatek,larb", 1);
> > +	if (!node)
> > +		return -1;
> > +
> > +	pdev = of_find_device_by_node(node);
> > +	if (WARN_ON(!pdev)) {
> > +		of_node_put(node);
> > +		return -EINVAL;
> > +	}
> > +	pm->larbvenclt = &pdev->dev;
> > +
> > +	pdev = mtkdev->plat_dev;
> > +	pm->dev = &pdev->dev;
> > +
> > +	pm->vencpll_d2 = devm_clk_get(&pdev->dev, "vencpll_d2");
> > +	if (pm->vencpll_d2 == NULL) {
> > +		mtk_v4l2_err("devm_clk_get vencpll_d2 fail");
> > +		ret = -1;
> > +	}
> > +
> > +	pm->venc_sel = devm_clk_get(&pdev->dev, "venc_sel");
> > +	if (pm->venc_sel == NULL) {
> > +		mtk_v4l2_err("devm_clk_get venc_sel fail");
> > +		ret = -1;
> > +	}
> > +
> > +	pm->univpll1_d2 = devm_clk_get(&pdev->dev, "univpll1_d2");
> > +	if (pm->univpll1_d2 == NULL) {
> > +		mtk_v4l2_err("devm_clk_get univpll1_d2 fail");
> > +		ret = -1;
> > +	}
> > +
> > +	pm->venc_lt_sel = devm_clk_get(&pdev->dev, "venc_lt_sel");
> > +	if (pm->venc_lt_sel == NULL) {
> > +		mtk_v4l2_err("devm_clk_get venc_lt_sel fail");
> > +		ret = -1;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +void mtk_vcodec_release_enc_pm(struct mtk_vcodec_dev *mtkdev)
> > +{
> > +}
> > +
> > +
> > +void mtk_vcodec_enc_clock_on(struct mtk_vcodec_pm *pm)
> > +{
> > +	int ret;
> > +
> > +	ret = clk_prepare_enable(pm->venc_sel);
> > +	if (ret)
> > +		mtk_v4l2_err("venc_sel fail %d", ret);
> > +
> > +	ret = clk_set_parent(pm->venc_sel, pm->vencpll_d2);
> > +	if (ret)
> > +		mtk_v4l2_err("clk_set_parent fail %d", ret);
> > +
> > +	ret = clk_prepare_enable(pm->venc_lt_sel);
> > +	if (ret)
> > +		mtk_v4l2_err("venc_lt_sel fail %d", ret);
> > +
> > +	ret = clk_set_parent(pm->venc_lt_sel, pm->univpll1_d2);
> > +	if (ret)
> > +		mtk_v4l2_err("clk_set_parent fail %d", ret);
> > +
> > +	ret = mtk_smi_larb_get(pm->larbvenc);
> > +	if (ret)
> > +		mtk_v4l2_err("mtk_smi_larb_get larb3 fail %d\n", ret);
> > +
> > +	ret = mtk_smi_larb_get(pm->larbvenclt);
> > +	if (ret)
> > +		mtk_v4l2_err("mtk_smi_larb_get larb4 fail %d\n", ret);
> > +
> > +}
> > +
> > +void mtk_vcodec_enc_clock_off(struct mtk_vcodec_pm *pm)
> > +{
> > +	mtk_smi_larb_put(pm->larbvenc);
> > +	mtk_smi_larb_put(pm->larbvenclt);
> > +	clk_disable_unprepare(pm->venc_lt_sel);
> > +	clk_disable_unprepare(pm->venc_sel);
> > +}
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
> > new file mode 100644
> > index 0000000..919b949
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
> > @@ -0,0 +1,102 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#include <linux/errno.h>
> > +#include <linux/wait.h>
> > +
> > +#include "mtk_vcodec_drv.h"
> > +#include "mtk_vcodec_intr.h"
> > +#include "mtk_vcodec_util.h"
> > +
> > +void mtk_vcodec_clean_dev_int_flags(void *data)
> > +{
> > +	struct mtk_vcodec_dev *dev = (struct mtk_vcodec_dev *)data;
> > +
> > +	dev->int_cond = 0;
> > +	dev->int_type = 0;
> > +}
> > +
> > +int mtk_vcodec_wait_for_done_ctx(void *data, int command,
> > +				 unsigned int timeout_ms, int interrupt)
> > +{
> > +	wait_queue_head_t *waitqueue;
> > +	long timeout_jiff, ret;
> > +	int status = 0;
> > +	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
> > +
> > +	waitqueue = (wait_queue_head_t *)&ctx->queue;
> > +	timeout_jiff = msecs_to_jiffies(timeout_ms);
> > +	if (interrupt) {
> > +		ret = wait_event_interruptible_timeout(*waitqueue,
> > +				(ctx->int_cond &&
> > +				(ctx->int_type == command)),
> > +				timeout_jiff);
> > +	} else {
> > +		ret = wait_event_timeout(*waitqueue,
> > +				(ctx->int_cond &&
> > +				(ctx->int_type == command)),
> > +				 timeout_jiff);
> > +	}
> > +	if (0 == ret) {
> > +		status = -1;	/* timeout */
> > +		mtk_v4l2_err("[%d] cmd=%d, ctx->type=%d, wait_event_interruptible_timeout time=%ums out %d %d!",
> > +				ctx->idx, ctx->type, command, timeout_ms,
> > +				ctx->int_cond, ctx->int_type);
> > +	} else if (-ERESTARTSYS == ret) {
> > +		mtk_v4l2_err("[%d] cmd=%d, ctx->type=%d, wait_event_interruptible_timeout interrupted by a signal %d %d",
> > +				ctx->idx, ctx->type, command, ctx->int_cond,
> > +				ctx->int_type);
> > +		status = -1;
> > +	}
> > +
> > +	ctx->int_cond = 0;
> > +	ctx->int_type = 0;
> > +
> > +	return status;
> > +}
> > +
> > +int mtk_vcodec_wait_for_done_dev(void *data, int command,
> > +				 unsigned int timeout, int interrupt)
> > +{
> > +	wait_queue_head_t *waitqueue;
> > +	long timeout_jiff, ret;
> > +	int status = 0;
> > +	struct mtk_vcodec_dev *dev = (struct mtk_vcodec_dev *)data;
> > +
> > +	waitqueue = (wait_queue_head_t *)&dev->queue;
> > +	timeout_jiff = msecs_to_jiffies(timeout);
> > +	if (interrupt) {
> > +		ret = wait_event_interruptible_timeout(*waitqueue,
> > +				(dev->int_cond &&
> > +				(dev->int_type == command)),
> > +				timeout_jiff);
> > +	} else {
> > +		ret = wait_event_timeout(*waitqueue,
> > +				(dev->int_cond &&
> > +				(dev->int_type == command)),
> > +				timeout_jiff);
> > +	}
> > +	if (0 == ret) {
> > +		status = -1;	/* timeout */
> > +		mtk_v4l2_err("wait_event_interruptible_timeout time=%lu out %d %d!",
> > +				timeout_jiff, dev->int_cond, dev->int_type);
> > +	} else if (-ERESTARTSYS == ret) {
> > +		mtk_v4l2_err("wait_event_interruptible_timeout interrupted by a signal %d %d",
> > +				dev->int_cond, dev->int_type);
> > +		status = -1;
> > +	}
> > +	dev->int_cond = 0;
> > +	dev->int_type = 0;
> > +	return status;
> > +}
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
> > new file mode 100644
> > index 0000000..e9b7f94
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
> > @@ -0,0 +1,29 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#ifndef _MTK_VCODEC_INTR_H_
> > +#define _MTK_VCODEC_INTR_H_
> > +
> > +#define MTK_INST_IRQ_RECEIVED		0x1
> > +#define MTK_INST_WORK_THREAD_ABORT_DONE	0x2
> > +
> > +/* timeout is ms */
> > +int mtk_vcodec_wait_for_done_ctx(void *data, int command, unsigned int timeout,
> > +				 int interrupt);
> > +int mtk_vcodec_wait_for_done_dev(void *data, int command, unsigned int timeout,
> > +				 int interrupt);
> > +
> > +void mtk_vcodec_clean_dev_int_flags(void *data);
> > +
> > +#endif /* _MTK_VCODEC_INTR_H_ */
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h
> > new file mode 100644
> > index 0000000..fdadec9
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h
> > @@ -0,0 +1,26 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#ifndef _MTK_VCODEC_PM_H_
> > +#define _MTK_VCODEC_PM_H_
> > +
> > +#include "mtk_vcodec_drv.h"
> > +
> > +int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *dev);
> > +void mtk_vcodec_release_enc_pm(struct mtk_vcodec_dev *dev);
> > +
> > +void mtk_vcodec_enc_clock_on(struct mtk_vcodec_pm *pm);
> > +void mtk_vcodec_enc_clock_off(struct mtk_vcodec_pm *pm);
> > +
> > +#endif /* _MTK_VCODEC_PM_H_ */
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
> > new file mode 100644
> > index 0000000..3fede8d
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
> > @@ -0,0 +1,106 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: PC Chen <pc.chen@mediatek.com>
> > +*         Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#include <linux/module.h>
> > +
> > +#include "mtk_vcodec_drv.h"
> > +#include "mtk_vcodec_util.h"
> > +#include "mtk_vpu.h"
> > +
> > +bool mtk_vcodec_dbg = false;
> > +int mtk_v4l2_dbg_level = 0;
> > +
> > +module_param(mtk_v4l2_dbg_level, int, S_IRUGO | S_IWUSR);
> > +module_param(mtk_vcodec_dbg, bool, S_IRUGO | S_IWUSR);
> > +
> > +void __iomem *mtk_vcodec_get_reg_addr(void *data, unsigned int reg_idx)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
> > +
> > +	if (!data || reg_idx >= NUM_MAX_VCODEC_REG_BASE) {
> > +		mtk_v4l2_err("Invalid arguments");
> > +		return NULL;
> > +	}
> > +	return ctx->dev->reg_base[reg_idx];
> > +}
> > +
> > +int mtk_vcodec_mem_alloc(void *data, struct mtk_vcodec_mem *mem)
> > +{
> > +	unsigned long size = mem->size;
> > +	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
> > +	struct device *dev = &ctx->dev->plat_dev->dev;
> > +
> > +	mem->va = dma_alloc_coherent(dev, size, &mem->dma_addr, GFP_KERNEL);
> > +
> > +	if (!mem->va) {
> > +		mtk_v4l2_err("%s dma_alloc size=%ld failed!", dev_name(dev),
> > +			       size);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	memset(mem->va, 0, size);
> > +
> > +	mtk_v4l2_debug(3, "[%d]  - va      = %p", ctx->idx, mem->va);
> > +	mtk_v4l2_debug(3, "[%d]  - dma     = 0x%lx", ctx->idx,
> > +			 (unsigned long)mem->dma_addr);
> > +	mtk_v4l2_debug(3, "[%d]    size = 0x%lx", ctx->idx, size);
> > +
> > +	return 0;
> > +}
> > +
> > +void mtk_vcodec_mem_free(void *data, struct mtk_vcodec_mem *mem)
> > +{
> > +	unsigned long size = mem->size;
> > +	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
> > +	struct device *dev = &ctx->dev->plat_dev->dev;
> > +
> > +	dma_free_coherent(dev, size, mem->va, mem->dma_addr);
> > +	mem->va = NULL;
> > +
> > +	mtk_v4l2_debug(3, "[%d]  - va      = %p", ctx->idx, mem->va);
> > +	mtk_v4l2_debug(3, "[%d]  - dma     = 0x%lx", ctx->idx,
> > +			 (unsigned long)mem->dma_addr);
> > +	mtk_v4l2_debug(3, "[%d]    size = 0x%lx", ctx->idx, size);
> > +}
> > +
> > +int mtk_vcodec_get_ctx_id(void *data)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
> > +
> > +	if (!ctx)
> > +		return -1;
> > +
> > +	return ctx->idx;
> > +}
> > +
> > +struct platform_device *mtk_vcodec_get_plat_dev(void *data)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
> > +
> > +	if (!ctx)
> > +		return NULL;
> > +
> > +	return vpu_get_plat_device(ctx->dev->plat_dev);
> > +}
> > +
> > +void mtk_vcodec_fmt2str(u32 fmt, char *str)
> > +{
> > +	char a = fmt & 0xFF;
> > +	char b = (fmt >> 8) & 0xFF;
> > +	char c = (fmt >> 16) & 0xFF;
> > +	char d = (fmt >> 24) & 0xFF;
> > +
> > +	sprintf(str, "%c%c%c%c", a, b, c, d);
> > +}
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> > new file mode 100644
> > index 0000000..47016ae
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> > @@ -0,0 +1,85 @@
> > +/*
> > +* Copyright (c) 2015 MediaTek Inc.
> > +* Author: PC Chen <pc.chen@mediatek.com>
> > +*         Tiffany Lin <tiffany.lin@mediatek.com>
> > +*
> > +* This program is free software; you can redistribute it and/or modify
> > +* it under the terms of the GNU General Public License version 2 as
> > +* published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*/
> > +
> > +#ifndef _MTK_VCODEC_UTIL_H_
> > +#define _MTK_VCODEC_UTIL_H_
> > +
> > +#include <linux/types.h>
> > +#include <linux/dma-direction.h>
> > +
> > +struct mtk_vcodec_mem {
> > +	size_t size;
> > +	void *va;
> > +	dma_addr_t dma_addr;
> > +};
> > +
> > +extern int mtk_v4l2_dbg_level;
> > +extern bool mtk_vcodec_dbg;
> > +
> > +#define DEBUG 	1
> > +
> > +#if defined(DEBUG)
> > +
> > +#define mtk_v4l2_debug(level, fmt, args...)				 \
> > +	do {								 \
> > +		if (mtk_v4l2_dbg_level >= level)			 \
> > +			pr_info("[MTK_V4L2] level=%d %s(),%d: " fmt "\n",\
> > +				level, __func__, __LINE__, ##args);	 \
> > +	} while (0)
> > +
> > +#define mtk_v4l2_err(fmt, args...)                \
> > +	pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
> > +	       ##args)
> > +
> > +
> > +#define mtk_v4l2_debug_enter()  mtk_v4l2_debug(3, "+\n")
> > +#define mtk_v4l2_debug_leave()  mtk_v4l2_debug(3, "-\n")
> > +
> > +#define mtk_vcodec_debug(h, fmt, args...)				\
> > +	do {								\
> > +		if (mtk_vcodec_dbg)					\
> > +			pr_info("[MTK_VCODEC][%d]: %s() " fmt "\n",	\
> > +				((struct mtk_vcodec_ctx *)h->ctx)->idx, \
> > +				__func__, ##args);			\
> > +	} while (0)
> > +
> > +#define mtk_vcodec_err(h, fmt, args...)					\
> > +	pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",		\
> > +	       ((struct mtk_vcodec_ctx *)h->ctx)->idx, __func__, ##args)
> > +
> > +#define mtk_vcodec_debug_enter(h)  mtk_vcodec_debug(h, "+\n")
> > +#define mtk_vcodec_debug_leave(h)  mtk_vcodec_debug(h, "-\n")
> > +
> > +#else
> > +
> > +#define mtk_v4l2_debug(level, fmt, args...)
> > +#define mtk_v4l2_err(fmt, args...)
> > +#define mtk_v4l2_debug_enter()
> > +#define mtk_v4l2_debug_leave()
> > +
> > +#define mtk_vcodec_debug(h, fmt, args...)
> > +#define mtk_vcodec_err(h, fmt, args...)
> > +#define mtk_vcodec_debug_enter(h)
> > +#define mtk_vcodec_debug_leave(h)
> > +
> > +#endif
> > +
> > +void __iomem *mtk_vcodec_get_reg_addr(void *data, unsigned int reg_idx);
> > +int mtk_vcodec_mem_alloc(void *data, struct mtk_vcodec_mem *mem);
> > +void mtk_vcodec_mem_free(void *data, struct mtk_vcodec_mem *mem);
> > +int mtk_vcodec_get_ctx_id(void *data);
> > +struct platform_device *mtk_vcodec_get_plat_dev(void *data);
> > +void mtk_vcodec_fmt2str(u32 fmt, char *str);
> > +#endif /* _MTK_VCODEC_UTIL_H_ */
> > diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_base.h b/drivers/media/platform/mtk-vcodec/venc_drv_base.h
> > new file mode 100644
> > index 0000000..ed9cbf0
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/venc_drv_base.h
> > @@ -0,0 +1,62 @@
> > +/*
> > + * Copyright (c) 2015 MediaTek Inc.
> > + * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
> > + *         Jungchang Tsao <jungchang.tsao@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _VENC_DRV_BASE_
> > +#define _VENC_DRV_BASE_
> > +
> > +#include "mtk_vcodec_drv.h"
> > +
> > +#include "venc_drv_if.h"
> > +
> > +struct venc_common_if {
> > +	/**
> > +	 * (*init)() - initialize driver
> > +	 * @ctx:	[in] mtk v4l2 context
> > +	 * @handle: [out] driver handle
> > +	 */
> > +	int (*init)(struct mtk_vcodec_ctx *ctx, unsigned long *handle);
> > +
> > +	/**
> > +	 * (*encode)() - trigger encode
> > +	 * @handle: [in] driver handle
> > +	 * @opt: [in] encode option
> > +	 * @frm_buf: [in] frame buffer to store input frame
> > +	 * @bs_buf: [in] bitstream buffer to store output bitstream
> > +	 * @result: [out] encode result
> > +	 */
> > +	int (*encode)(unsigned long handle, enum venc_start_opt opt,
> > +		      struct venc_frm_buf *frm_buf,
> > +		      struct mtk_vcodec_mem *bs_buf,
> > +		      struct venc_done_result *result);
> > +
> > +	/**
> > +	 * (*set_param)() - set driver's parameter
> > +	 * @handle: [in] driver handle
> > +	 * @type: [in] parameter type
> > +	 * @in: [in] buffer to store the parameter
> > +	 */
> > +	int (*set_param)(unsigned long handle, enum venc_set_param_type type,
> > +			 void *in);
> > +
> > +	/**
> > +	 * (*deinit)() - deinitialize driver.
> > +	 * @handle: [in] driver handle
> > +	 */
> > +	int (*deinit)(unsigned long handle);
> > +};
> > +
> > +
> > +#endif
> > diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
> > new file mode 100644
> > index 0000000..daa8e93
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
> > @@ -0,0 +1,100 @@
> > +/*
> > + * Copyright (c) 2015 MediaTek Inc.
> > + * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
> > + *         Jungchang Tsao <jungchang.tsao@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/interrupt.h>
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +
> > +#include "venc_drv_if.h"
> > +#include "mtk_vcodec_enc.h"
> > +#include "mtk_vcodec_pm.h"
> > +#include "mtk_vpu.h"
> > +
> > +#include "venc_drv_base.h"
> > +
> > +int venc_if_create(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
> > +{
> > +	char str[10];
> > +	int ret = 0;
> > +
> > +	mtk_vcodec_fmt2str(fourcc, str);
> > +
> > +	switch (fourcc) {
> > +	case V4L2_PIX_FMT_VP8:
> > +	case V4L2_PIX_FMT_H264:
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	mtk_venc_lock(ctx);
> > +	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
> > +	ret = ctx->enc_if->init(ctx, (unsigned long *)&ctx->drv_handle);
> > +	mtk_vcodec_enc_clock_off(&ctx->dev->pm);
> > +	mtk_venc_unlock(ctx);
> > +
> > +	return ret;
> > +
> > +}
> > +
> > +
> > +int venc_if_set_param(struct mtk_vcodec_ctx *ctx,
> > +		      enum venc_set_param_type type, void *in)
> > +{
> > +	int ret = 0;
> > +
> > +	mtk_venc_lock(ctx);
> > +	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
> > +	ret = ctx->enc_if->set_param(ctx->drv_handle, type, in);
> > +	mtk_vcodec_enc_clock_off(&ctx->dev->pm);
> > +	mtk_venc_unlock(ctx);
> > +
> > +	return ret;
> > +}
> > +
> > +int venc_if_encode(struct mtk_vcodec_ctx *ctx,
> > +		   enum venc_start_opt opt, struct venc_frm_buf *frm_buf,
> > +		   struct mtk_vcodec_mem *bs_buf,
> > +		   struct venc_done_result *result)
> > +{
> > +	int ret = 0;
> > +	
> > +	mtk_venc_lock(ctx);
> > +	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
> > +	ret = ctx->enc_if->encode(ctx->drv_handle, opt, frm_buf, bs_buf, result);
> > +	mtk_vcodec_enc_clock_off(&ctx->dev->pm);
> > +	mtk_venc_unlock(ctx);
> > +	
> > +	return ret;
> > +}
> > +
> > +int venc_if_release(struct mtk_vcodec_ctx *ctx)
> > +{
> > +	int ret = 0;
> > +
> > +	if(ctx->drv_handle == 0)
> > +		return 0;
> > +
> > +	mtk_venc_lock(ctx);
> > +	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
> > +	ret = ctx->enc_if->deinit(ctx->drv_handle);
> > +	mtk_vcodec_enc_clock_off(&ctx->dev->pm);
> > +	mtk_venc_unlock(ctx);
> > +
> > +	ctx->drv_handle = 0;
> > +
> > +	return ret;
> > +}
> > +
> > diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_if.h b/drivers/media/platform/mtk-vcodec/venc_drv_if.h
> > new file mode 100644
> > index 0000000..a387011
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/venc_drv_if.h
> > @@ -0,0 +1,175 @@
> > +/*
> > + * Copyright (c) 2015 MediaTek Inc.
> > + * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
> > + *         Jungchang Tsao <jungchang.tsao@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _VENC_DRV_IF_H_
> > +#define _VENC_DRV_IF_H_
> > +
> > +#include "mtk_vcodec_drv.h"
> > +#include "mtk_vcodec_util.h"
> > +
> > +/*
> > + * enum venc_yuv_fmt - The type of input yuv format
> > + * (VPU related: If you change the order, you must also update the VPU codes.)
> > + * @VENC_YUV_FORMAT_420: 420 YUV format
> > + * @VENC_YUV_FORMAT_YV12: YV12 YUV format
> > + * @VENC_YUV_FORMAT_NV12: NV12 YUV format
> > + * @VENC_YUV_FORMAT_NV21: NV21 YUV format
> > + */
> > +enum venc_yuv_fmt {
> > +	VENC_YUV_FORMAT_420 = 3,
> > +	VENC_YUV_FORMAT_YV12 = 5,
> > +	VENC_YUV_FORMAT_NV12 = 6,
> > +	VENC_YUV_FORMAT_NV21 = 7,
> > +};
> > +
> > +/*
> > + * enum venc_start_opt - encode frame option used in venc_if_encode()
> > + * @VENC_START_OPT_ENCODE_SEQUENCE_HEADER: encode SPS/PPS for H264
> > + * @VENC_START_OPT_ENCODE_FRAME: encode normal frame
> > + */
> > +enum venc_start_opt {
> > +	VENC_START_OPT_ENCODE_SEQUENCE_HEADER,
> > +	VENC_START_OPT_ENCODE_FRAME,
> > +};
> > +
> > +/*
> > + * enum venc_drv_msg - The type of encode frame status used in venc_if_encode()
> > + * @VENC_MESSAGE_OK: encode ok
> > + * @VENC_MESSAGE_ERR: encode error
> > + */
> > +enum venc_drv_msg {
> > +	VENC_MESSAGE_OK,
> > +	VENC_MESSAGE_ERR,
> > +};
> > +
> > +/*
> > + * enum venc_set_param_type - The type of set parameter used in venc_if_set_param()
> > + * (VPU related: If you change the order, you must also update the VPU codes.)
> > + * @VENC_SET_PARAM_ENC: set encoder parameters
> > + * @VENC_SET_PARAM_FORCE_INTRA: set force intra frame
> > + * @VENC_SET_PARAM_ADJUST_BITRATE: set to adjust bitrate (in bps)
> > + * @VENC_SET_PARAM_ADJUST_FRAMERATE: set frame rate
> > + * @VENC_SET_PARAM_I_FRAME_INTERVAL: set I frame interval
> > + * @VENC_SET_PARAM_SKIP_FRAME: set H264 skip one frame
> > + * @VENC_SET_PARAM_PREPEND_HEADER: set H264 prepend SPS/PPS before IDR
> > + * @VENC_SET_PARAM_TS_MODE: set VP8 temporal scalability mode
> > + */
> > +enum venc_set_param_type {
> > +	VENC_SET_PARAM_ENC,
> > +	VENC_SET_PARAM_FORCE_INTRA,
> > +	VENC_SET_PARAM_ADJUST_BITRATE,
> > +	VENC_SET_PARAM_ADJUST_FRAMERATE,
> > +	VENC_SET_PARAM_I_FRAME_INTERVAL,
> > +	VENC_SET_PARAM_SKIP_FRAME,
> > +	VENC_SET_PARAM_PREPEND_HEADER,
> > +	VENC_SET_PARAM_TS_MODE,
> > +};
> > +
> > +/*
> > + * struct venc_enc_prm - encoder settings for VENC_SET_PARAM_ENC used in venc_if_set_param()
> > + * @input_fourcc: input fourcc
> > + * @h264_profile: V4L2 defined H.264 profile
> > + * @h264_level: V4L2 defined H.264 level
> > + * @width: image width
> > + * @height: image height
> > + * @buf_width: buffer width
> > + * @buf_height: buffer height
> > + * @frm_rate: frame rate
> > + * @intra_period: intra frame period
> > + * @bitrate: target bitrate in kbps
> > + */
> > +struct venc_enc_prm {
> > +	enum venc_yuv_fmt input_fourcc;
> > +	unsigned int h264_profile;
> > +	unsigned int h264_level;
> > +	unsigned int width;
> > +	unsigned int height;
> > +	unsigned int buf_width;
> > +	unsigned int buf_height;
> > +	unsigned int frm_rate;
> > +	unsigned int intra_period;
> > +	unsigned int bitrate;
> > +	unsigned int sizeimage[MTK_VCODEC_MAX_PLANES];
> > +};
> > +
> > +/*
> > + * struct venc_frm_buf - frame buffer information used in venc_if_encode()
> > + * @fb_addr: plane 0 frame buffer address
> > + * @fb_addr1: plane 1 frame buffer address
> > + * @fb_addr2: plane 2 frame buffer address
> > + */
> > +struct venc_frm_buf {
> > +	struct mtk_vcodec_mem fb_addr;
> > +	struct mtk_vcodec_mem fb_addr1;
> > +	struct mtk_vcodec_mem fb_addr2;
> > +};
> > +
> > +/*
> > + * struct venc_done_result - This is return information used in venc_if_encode()
> > + * @msg: message, such as success or error code
> > + * @bs_size: output bitstream size
> > + * @is_key_frm: output is key frame or not
> > + */
> > +struct venc_done_result {
> > +	enum venc_drv_msg msg;
> > +	unsigned int bs_size;
> > +	bool is_key_frm;
> > +};
> > +
> > +/*
> > + * venc_if_create - Create the driver handle
> > + * @ctx: device context
> > + * @fourcc: encoder output format
> > + * @handle: driver handle
> > + * Return: 0 if creating handle successfully, otherwise it is failed.
> > + */
> > +int venc_if_create(struct mtk_vcodec_ctx *ctx, unsigned int fourcc);
> > +
> > +/*
> > + * venc_if_release - Release the driver handle
> > + * @handle: driver handle
> > + * Return: 0 if releasing handle successfully, otherwise it is failed.
> > + */
> > +int venc_if_release(struct mtk_vcodec_ctx *ctx);
> > +
> > +/*
> > + * venc_if_set_param - Set parameter to driver
> > + * @handle: driver handle
> > + * @type: set type
> > + * @in: input parameter
> > + * @out: output parameter
> > + * Return: 0 if setting param successfully, otherwise it is failed.
> > + */
> > +int venc_if_set_param(struct mtk_vcodec_ctx *ctx,
> > +		      enum venc_set_param_type type,
> > +		      void *in);
> > +
> > +/*
> > + * venc_if_encode - Encode frame
> > + * @handle: driver handle
> > + * @opt: encode frame option
> > + * @frm_buf: input frame buffer information
> > + * @bs_buf: output bitstream buffer infomraiton
> > + * @result: encode result
> > + * Return: 0 if encoding frame successfully, otherwise it is failed.
> > + */
> > +int venc_if_encode(struct mtk_vcodec_ctx *ctx,
> > +		   enum venc_start_opt opt,
> > +		   struct venc_frm_buf *frm_buf,
> > +		   struct mtk_vcodec_mem *bs_buf,
> > +		   struct venc_done_result *result);
> > +
> > +#endif /* _VENC_DRV_IF_H_ */
> > diff --git a/drivers/media/platform/mtk-vcodec/venc_ipi_msg.h b/drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
> > new file mode 100644
> > index 0000000..a345b98
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
> > @@ -0,0 +1,212 @@
> > +/*
> > + * Copyright (c) 2015 MediaTek Inc.
> > + * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
> > + *         Daniel Hsiao <daniel.hsiao@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _VENC_IPI_MSG_H_
> > +#define _VENC_IPI_MSG_H_
> > +
> > +#define IPIMSG_H264_ENC_ID 0x100
> > +#define IPIMSG_VP8_ENC_ID 0x200
> > +
> > +#define AP_IPIMSG_VENC_BASE 0x20000
> > +#define VPU_IPIMSG_VENC_BASE 0x30000
> > +
> > +/**
> > + * enum venc_ipi_msg_id - message id between AP and VPU
> > + * (ipi stands for inter-processor interrupt)
> > + * @AP_IPIMSG_XXX:		AP to VPU cmd message id
> > + * @VPU_IPIMSG_XXX_DONE:	VPU ack AP cmd message id
> > + */
> > +enum venc_ipi_msg_id {
> > +	AP_IPIMSG_H264_ENC_INIT = AP_IPIMSG_VENC_BASE +
> > +				  IPIMSG_H264_ENC_ID,
> > +	AP_IPIMSG_H264_ENC_SET_PARAM,
> > +	AP_IPIMSG_H264_ENC_ENCODE,
> > +	AP_IPIMSG_H264_ENC_DEINIT,
> > +
> > +	AP_IPIMSG_VP8_ENC_INIT = AP_IPIMSG_VENC_BASE +
> > +				 IPIMSG_VP8_ENC_ID,
> > +	AP_IPIMSG_VP8_ENC_SET_PARAM,
> > +	AP_IPIMSG_VP8_ENC_ENCODE,
> > +	AP_IPIMSG_VP8_ENC_DEINIT,
> > +
> > +	VPU_IPIMSG_H264_ENC_INIT_DONE = VPU_IPIMSG_VENC_BASE +
> > +					IPIMSG_H264_ENC_ID,
> > +	VPU_IPIMSG_H264_ENC_SET_PARAM_DONE,
> > +	VPU_IPIMSG_H264_ENC_ENCODE_DONE,
> > +	VPU_IPIMSG_H264_ENC_DEINIT_DONE,
> > +
> > +	VPU_IPIMSG_VP8_ENC_INIT_DONE = VPU_IPIMSG_VENC_BASE +
> > +				       IPIMSG_VP8_ENC_ID,
> > +	VPU_IPIMSG_VP8_ENC_SET_PARAM_DONE,
> > +	VPU_IPIMSG_VP8_ENC_ENCODE_DONE,
> > +	VPU_IPIMSG_VP8_ENC_DEINIT_DONE,
> > +};
> > +
> > +/**
> > + * struct venc_ap_ipi_msg_init - AP to VPU init cmd structure
> > + * @msg_id:	message id (AP_IPIMSG_XXX_ENC_INIT)
> > + * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
> > + */
> > +struct venc_ap_ipi_msg_init {
> > +	uint32_t msg_id;
> > +	uint32_t reserved;
> > +	uint64_t venc_inst;
> > +};
> > +
> > +/**
> > + * struct venc_ap_ipi_msg_set_param - AP to VPU set_param cmd structure
> > + * @msg_id:	message id (AP_IPIMSG_XXX_ENC_SET_PARAM)
> > + * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
> > + * @param_id:	parameter id (venc_set_param_type)
> > + * @data_item:	number of items in the data array
> > + * @data[8]:	data array to store the set parameters
> > + */
> > +struct venc_ap_ipi_msg_set_param {
> > +	uint32_t msg_id;
> > +	uint32_t inst_id;
> > +	uint32_t param_id;
> > +	uint32_t data_item;
> > +	uint32_t data[8];
> > +};
> > +
> > +/**
> > + * struct venc_ap_ipi_msg_enc - AP to VPU enc cmd structure
> > + * @msg_id:	message id (AP_IPIMSG_XXX_ENC_ENCODE)
> > + * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
> > + * @bs_mode:	bitstream mode for h264
> > + *		(H264_BS_MODE_SPS/H264_BS_MODE_PPS/H264_BS_MODE_FRAME)
> > + * @input_addr:	pointer to input image buffer plane
> > + * @bs_addr:	pointer to output bit stream buffer
> > + * @bs_size:	bit stream buffer size
> > + */
> > +struct venc_ap_ipi_msg_enc {
> > +	uint32_t msg_id;
> > +	uint32_t inst_id;
> > +	uint32_t bs_mode;
> > +	uint32_t input_addr[3];
> > +	uint32_t bs_addr;
> > +	uint32_t bs_size;
> > +};
> > +
> > +/**
> > + * struct venc_ap_ipi_msg_deinit - AP to VPU deinit cmd structure
> > + * @msg_id:	message id (AP_IPIMSG_XXX_ENC_DEINIT)
> > + * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
> > + */
> > +struct venc_ap_ipi_msg_deinit {
> > +	uint32_t msg_id;
> > +	uint32_t inst_id;
> > +};
> > +
> > +/**
> > + * enum venc_ipi_msg_status - VPU ack AP cmd status
> > + */
> > +enum venc_ipi_msg_status {
> > +	VENC_IPI_MSG_STATUS_OK,
> > +	VENC_IPI_MSG_STATUS_FAIL,
> > +};
> > +
> > +/**
> > + * struct venc_vpu_ipi_msg_common - VPU ack AP cmd common structure
> > + * @msg_id:	message id (VPU_IPIMSG_XXX_DONE)
> > + * @status:	cmd status (venc_ipi_msg_status)
> > + * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
> > + */
> > +struct venc_vpu_ipi_msg_common {
> > +	uint32_t msg_id;
> > +	uint32_t status;
> > +	uint64_t venc_inst;
> > +};
> > +
> > +/**
> > + * struct venc_vpu_ipi_msg_init - VPU ack AP init cmd structure
> > + * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_SET_PARAM_DONE)
> > + * @status:	cmd status (venc_ipi_msg_status)
> > + * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
> > + * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
> > + */
> > +struct venc_vpu_ipi_msg_init {
> > +	uint32_t msg_id;
> > +	uint32_t status;
> > +	uint64_t venc_inst;
> > +	uint32_t inst_id;
> > +	uint32_t reserved;
> > +};
> > +
> > +/**
> > + * struct venc_vpu_ipi_msg_set_param - VPU ack AP set_param cmd structure
> > + * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_SET_PARAM_DONE)
> > + * @status:	cmd status (venc_ipi_msg_status)
> > + * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
> > + * @param_id:	parameter id (venc_set_param_type)
> > + * @data_item:	number of items in the data array
> > + * @data[6]:	data array to store the return result
> > + */
> > +struct venc_vpu_ipi_msg_set_param {
> > +	uint32_t msg_id;
> > +	uint32_t status;
> > +	uint64_t venc_inst;
> > +	uint32_t param_id;
> > +	uint32_t data_item;
> > +	uint32_t data[6];
> > +};
> > +
> > +/**
> > + * enum venc_ipi_msg_enc_state - Type of encode state
> > + * VEN_IPI_MSG_ENC_STATE_FRAME:	one frame being encoded
> > + * VEN_IPI_MSG_ENC_STATE_PART:	bit stream buffer full
> > + * VEN_IPI_MSG_ENC_STATE_SKIP:	encoded skip frame
> > + * VEN_IPI_MSG_ENC_STATE_ERROR:	encounter error
> > + */
> > +enum venc_ipi_msg_enc_state {
> > +	VEN_IPI_MSG_ENC_STATE_FRAME,
> > +	VEN_IPI_MSG_ENC_STATE_PART,
> > +	VEN_IPI_MSG_ENC_STATE_SKIP,
> > +	VEN_IPI_MSG_ENC_STATE_ERROR,
> > +};
> > +
> > +/**
> > + * struct venc_vpu_ipi_msg_enc - VPU ack AP enc cmd structure
> > + * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_ENCODE_DONE)
> > + * @status:	cmd status (venc_ipi_msg_status)
> > + * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
> > + * @state:	encode state (venc_ipi_msg_enc_state)
> > + * @key_frame:	whether the encoded frame is key frame
> > + * @bs_size:	encoded bitstream size
> 
> 'reserved' isn't documented. I assume this should be set to 0?
> 
Yes. We will fix this.

> > + */
> > +struct venc_vpu_ipi_msg_enc {
> > +	uint32_t msg_id;
> > +	uint32_t status;
> > +	uint64_t venc_inst;
> > +	uint32_t state;
> > +	uint32_t key_frame;
> > +	uint32_t bs_size;
> > +	uint32_t reserved;
> > +};
> > +
> > +/**
> > + * struct venc_vpu_ipi_msg_deinit - VPU ack AP deinit cmd structure
> > + * @msg_id:   message id (VPU_IPIMSG_XXX_ENC_DEINIT_DONE)
> > + * @status:   cmd status (venc_ipi_msg_status)
> > + * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
> > + */
> > +struct venc_vpu_ipi_msg_deinit {
> > +	uint32_t msg_id;
> > +	uint32_t status;
> > +	uint64_t venc_inst;
> > +};
> > +
> > +#endif /* _VENC_IPI_MSG_H_ */
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > old mode 100644
> > new mode 100755
> > index ee9d530..3ac35c4
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -646,6 +646,10 @@ enum v4l2_mpeg_mfc51_video_force_frame_type {
> >  #define V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P		(V4L2_CID_MPEG_MFC51_BASE+54)
> >  
> >  
> > +#define V4L2_CID_MPEG_MTK_BASE					(V4L2_CTRL_CLASS_MPEG | 0x5500)
> > +#define V4L2_CID_MPEG_MTK_VIDEO_FRAME_SKIP_ENABLE		(V4L2_CID_MPEG_MTK_BASE+0)
> > +#define V4L2_CID_MPEG_MTK_VIDEO_FORCE_FRAME_TYPE_I_FRAME	(V4L2_CID_MPEG_MTK_BASE+1)
> 
> Please note that these controls should be documented in DocBook.
> 
Sorry, I do not clean these part.
We plain to remove V4L2_CID_MPEG_MTK_VIDEO_FRAME_SKIP_ENABL and use
V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME in wucheng's patch
https://patchwork.linuxtv.org/patch/32670/.


best regards,
Tiffany

> Regards,
> 
> 	Hans
> 
> > +
> >  /*  Camera class control IDs */
> >  
> >  #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
> > 
> 


