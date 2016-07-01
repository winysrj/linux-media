Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53536 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbcGANf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 09:35:57 -0400
Subject: Re: [PATCH v2] Add tw5864 driver
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kozlov Sergey <serjk@netup.ru>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <20160609221142.10139-1-andrey.utkin@corp.bluecherry.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey_utkin@fastmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0166f7df-2d34-f937-5cc0-0596fc14c5b1@xs4all.nl>
Date: Fri, 1 Jul 2016 15:35:40 +0200
MIME-Version: 1.0
In-Reply-To: <20160609221142.10139-1-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2016 12:11 AM, Andrey Utkin wrote:
> Fixed most of issues discovered by v1 and RFCv0 reviewers. Refactored a lot.
> 
> The only thing from previous review I haven't got my head around yet is
> framerate control - Hans Verkuil has told to support 1001/30000 frame interval,
> but it's hard for me to fit it into current model. I see that I'm still not
> getting this aspect right so I'd be grateful for some more spoon-feeding on
> this. Otherwise, it would be nice to get some more reviews while I'm figuring
> this out by myself, so I dare to submit the current state for review.
> 
> This submission is awkward in a way. There was a code to "initialize" the
> subordinate chips tw286{4,5} which are connected to main chip via I2C, by means
> of special r/w procedure on dedicated register. I was told to organize the
> I2C-related code using kernel-provided interfaces (struct i2c_adapter etc.),
> which I have accomplished. It was tested and traced in runtime, and supposedly
> this new code works. But after that, I figured out that this
> initialize-chips-via-i2c code is not necessary at all. So now there are
> "proper" I2C I/O routines, but they are unused. Also, there remains a very
> similar mechanism which is called "indirect space map" which exposes mostly the
> same registers which tw286{4,5} chips expose by themselves and which could be
> accessed also by "i2c communication" routines. But address mapping between
> these spaces seems inconsistent: some addresses match, some don't, and both
> current code and reference driver use mostly "indirect space map" mechanism. In
> current code there are 33 invocations of "indirect" i/o. They are left intact
> for now, but if maintainers insist on reworking that to "i2c communication",
> I'm ok to do this.

So if I understand this correctly instead of using i2c you can now use the
indirect i/o to program these internal tw286{4,5} devices? I assume these
are integrated on the same die and the i2c bus is internal to the tw5864 chip?

Assuming this is true, then I would just drop the i2c part since it is unused
and since I suspect that the indirect i/o is faster anyway.

> 
> checkpatch.pl gives no notices on a patch nor on individual source files.
> 
> sparse ("make C=2 M=drivers/media/pci/tw5864") also gives no notices.
> 
> root@localhost:~# v4l2-compliance -d 6 -s
> Driver Info:
>         Driver name   : tw5864
>         Card type     : TW5864 Encoder 2
>         Bus info      : PCI:0000:06:05.0
>         Driver version: 4.7.0
>         Capabilities  : 0x85200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x05200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video6 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 11 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Streaming ioctls:
>         test read/write: OK
>         test MMAP: OK                                     
>         test USERPTR: OK (Not Supported)
>         test DMABUF: Cannot test, specify --expbuf-device
> 
> 
> Total: 45, Succeeded: 45, Failed: 0, Warnings: 0
> 
> 
> ---8<---
> 
> Support for boards based on Techwell TW5864 chip which provides
> multichannel video & audio grabbing and encoding (H.264, MJPEG,
> ADPCM G.726).
> 
> This submission implements only H.264 encoding of all channels at D1
> resolution.
> 
> Thanks to Mark Thompson <sw@jkqxz.net> for help, and for contribution of
> H.264 startcode emulation prevention code.
> 
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> ---
>  MAINTAINERS                             |    8 +
>  drivers/media/pci/Kconfig               |    1 +
>  drivers/media/pci/Makefile              |    1 +
>  drivers/media/pci/tw5864/Kconfig        |   11 +
>  drivers/media/pci/tw5864/Makefile       |    3 +
>  drivers/media/pci/tw5864/tw5864-core.c  |  343 +++++
>  drivers/media/pci/tw5864/tw5864-h264.c  |  259 ++++
>  drivers/media/pci/tw5864/tw5864-i2c.c   |  139 ++
>  drivers/media/pci/tw5864/tw5864-reg.h   | 2133 +++++++++++++++++++++++++++++++
>  drivers/media/pci/tw5864/tw5864-util.c  |   37 +
>  drivers/media/pci/tw5864/tw5864-video.c | 1503 ++++++++++++++++++++++
>  drivers/media/pci/tw5864/tw5864.h       |  228 ++++
>  12 files changed, 4666 insertions(+)
>  create mode 100644 drivers/media/pci/tw5864/Kconfig
>  create mode 100644 drivers/media/pci/tw5864/Makefile
>  create mode 100644 drivers/media/pci/tw5864/tw5864-core.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864-h264.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864-i2c.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864-reg.h
>  create mode 100644 drivers/media/pci/tw5864/tw5864-util.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864-video.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864.h
> 

<snip>

> diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
> new file mode 100644
> index 0000000..10a4905
> --- /dev/null
> +++ b/drivers/media/pci/tw5864/tw5864-video.c
> @@ -0,0 +1,1503 @@
> +/*
> + *  TW5864 driver - video encoding functions
> + *
> + *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-event.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "tw5864.h"
> +#include "tw5864-reg.h"
> +
> +#define QUANTIZATION_TABLE_LEN 96
> +#define VLC_LOOKUP_TABLE_LEN 1024
> +

<snip>

> +
> +
> +static v4l2_std_id tw5864_get_v4l2_std(enum tw5864_vid_std std);
> +static enum tw5864_vid_std tw5864_from_v4l2_std(v4l2_std_id v4l2_std);
> +
> +static void tw5864_handle_frame_task(unsigned long data);
> +static void tw5864_handle_frame(struct tw5864_h264_frame *frame);
> +static void tw5864_frame_interval_set(struct tw5864_input *input);
> +
> +static int tw5864_queue_setup(struct vb2_queue *q,
> +			      unsigned int *num_buffers,
> +			      unsigned int *num_planes, unsigned int sizes[],
> +			      void *alloc_ctxs[])
> +{
> +	struct tw5864_input *dev = vb2_get_drv_priv(q);
> +
> +	if (q->num_buffers + *num_buffers < 12)
> +		*num_buffers = 12 - q->num_buffers;

This test can be dropped since min_buffers_needed is already set to 12. So
vb2 will check this for you.

> +
> +	alloc_ctxs[0] = dev->alloc_ctx;
> +	if (*num_planes)
> +		return sizes[0] < H264_VLC_BUF_SIZE ? -EINVAL : 0;
> +
> +	sizes[0] = H264_VLC_BUF_SIZE;
> +	*num_planes = 1;
> +
> +	return 0;
> +}
> +
> +static void tw5864_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct tw5864_input *dev = vb2_get_drv_priv(vq);
> +	struct tw5864_buf *buf = container_of(vbuf, struct tw5864_buf, vb);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->slock, flags);
> +	list_add_tail(&buf->list, &dev->active);
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +}
> +
> +static int tw5864_input_std_get(struct tw5864_input *input,
> +				enum tw5864_vid_std *std_arg)
> +{
> +	struct tw5864_dev *dev = input->root;
> +	enum tw5864_vid_std std;
> +	u8 std_reg = tw_indir_readb(TW5864_INDIR_VIN_E(input->nr));
> +
> +	std = (std_reg & 0x70) >> 4;
> +
> +	if (std_reg & 0x80) {
> +		dev_err(&dev->pci->dev,
> +			"Video format detection is in progress, please wait\n");
> +		return -EAGAIN;
> +	}
> +
> +	if (std == STD_INVALID) {
> +		dev_err(&dev->pci->dev, "No valid video format detected\n");
> +		return -EPERM;
> +	}
> +
> +	*std_arg = std;
> +	return 0;
> +}
> +
> +static int tw5864_enable_input(struct tw5864_input *input)
> +{
> +	struct tw5864_dev *dev = input->root;
> +	int nr = input->nr;
> +	unsigned long flags;
> +	int ret;
> +	int d1_width = 720;
> +	int d1_height;
> +	int frame_width_bus_value = 0;
> +	int frame_height_bus_value = 0;
> +	int reg_frame_bus = 0x1c;
> +	int fmt_reg_value = 0;
> +	int downscale_enabled = 0;
> +
> +	dev_dbg(&dev->pci->dev, "Enabling channel %d\n", nr);
> +
> +	ret = tw5864_input_std_get(input, &input->std);
> +	if (ret)
> +		return ret;

Most (all?) drivers just allow streaming even if there is no signal/lock. Depending
on the hardware, either it's just waiting for data (i.e. for the user to plug in
a source), or it streams static.

You can test here, of course, but then what happens if you pull out the cable while
streaming? It's the same situation, so this doesn't help you much.

> +	input->v4l2_std = tw5864_get_v4l2_std(input->std);

Never autodetect the standard unless it is from QUERYSTD.

The sequence from userspace is to call querystd, then s_std if a standard is detected.
Internally in the driver you always use the last set standard and some initial
default standard when the driver is loaded for the first time.

It is less of an issue with compressed formats, but still the kernel should never
change the standard on the fly, it is really unexpected from the point of view of
the application. As a bonus, this usually simplifies the driver too.

> +
> +	input->frame_seqno = 0;
> +	input->frame_gop_seqno = 0;
> +	input->h264_idr_pic_id = 0;
> +
> +	input->reg_dsp_qp = input->qp;
> +	input->reg_dsp_ref_mvp_lambda = lambda_lookup_table[input->qp];
> +	input->reg_dsp_i4x4_weight = intra4x4_lambda3[input->qp];
> +	input->reg_emu = TW5864_EMU_EN_LPF | TW5864_EMU_EN_BHOST
> +		| TW5864_EMU_EN_SEN | TW5864_EMU_EN_ME | TW5864_EMU_EN_DDR;
> +	input->reg_dsp = nr /* channel id */
> +		| TW5864_DSP_CHROM_SW
> +		| ((0xa << 8) & TW5864_DSP_MB_DELAY)
> +		;
> +
> +	input->resolution = D1;
> +
> +	d1_height = (input->std == STD_NTSC) ? 480 : 576;
> +
> +	input->width = d1_width;
> +	input->height = d1_height;
> +
> +	input->reg_interlacing = 0x4;
> +
> +	switch (input->resolution) {
> +	case D1:
> +		frame_width_bus_value = 0x2cf;
> +		frame_height_bus_value = input->height - 1;
> +		reg_frame_bus = 0x1c;
> +		fmt_reg_value = 0;
> +		downscale_enabled = 0;
> +		input->reg_dsp_codec |= TW5864_CIF_MAP_MD | TW5864_HD1_MAP_MD;
> +		input->reg_emu |= TW5864_DSP_FRAME_TYPE_D1;
> +		input->reg_interlacing = TW5864_DI_EN | TW5864_DSP_INTER_ST;
> +
> +		tw_setl(TW5864_FULL_HALF_FLAG, 1 << nr);
> +		break;
> +	case HD1:
> +		input->height /= 2;
> +		input->width /= 2;
> +		frame_width_bus_value = 0x2cf;
> +		frame_height_bus_value = input->height * 2 - 1;
> +		reg_frame_bus = 0x1c;
> +		fmt_reg_value = 0;
> +		downscale_enabled = 0;
> +		input->reg_dsp_codec |= TW5864_HD1_MAP_MD;
> +		input->reg_emu |= TW5864_DSP_FRAME_TYPE_D1;
> +
> +		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << nr);
> +
> +		break;
> +	case CIF:
> +		input->height /= 4;
> +		input->width /= 2;
> +		frame_width_bus_value = 0x15f;
> +		frame_height_bus_value = input->height * 2 - 1;
> +		reg_frame_bus = 0x07;
> +		fmt_reg_value = 1;
> +		downscale_enabled = 1;
> +		input->reg_dsp_codec |= TW5864_CIF_MAP_MD;
> +
> +		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << nr);
> +		break;
> +	case QCIF:
> +		input->height /= 4;
> +		input->width /= 4;
> +		frame_width_bus_value = 0x15f;
> +		frame_height_bus_value = input->height * 2 - 1;
> +		reg_frame_bus = 0x07;
> +		fmt_reg_value = 1;
> +		downscale_enabled = 1;
> +		input->reg_dsp_codec |= TW5864_CIF_MAP_MD;
> +
> +		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << nr);
> +		break;
> +	}
> +
> +	/* analog input width / 4 */
> +	tw_indir_writeb(TW5864_INDIR_IN_PIC_WIDTH(nr), d1_width / 4);
> +	tw_indir_writeb(TW5864_INDIR_IN_PIC_HEIGHT(nr), d1_height / 4);
> +
> +	/* output width / 4 */
> +	tw_indir_writeb(TW5864_INDIR_OUT_PIC_WIDTH(nr), input->width / 4);
> +	tw_indir_writeb(TW5864_INDIR_OUT_PIC_HEIGHT(nr), input->height / 4);
> +
> +	tw_writel(TW5864_DSP_PIC_MAX_MB,
> +		  ((input->width / 16) << 8) | (input->height / 16));
> +
> +	tw_writel(TW5864_FRAME_WIDTH_BUS_A(nr),
> +		  frame_width_bus_value);
> +	tw_writel(TW5864_FRAME_WIDTH_BUS_B(nr),
> +		  frame_width_bus_value);
> +	tw_writel(TW5864_FRAME_HEIGHT_BUS_A(nr),
> +		  frame_height_bus_value);
> +	tw_writel(TW5864_FRAME_HEIGHT_BUS_B(nr),
> +		  (frame_height_bus_value + 1) / 2 - 1);
> +
> +	tw5864_frame_interval_set(input);
> +
> +	if (downscale_enabled)
> +		tw_setl(TW5864_H264EN_CH_DNS, 1 << nr);
> +
> +	tw_mask_shift_writel(TW5864_H264EN_CH_FMT_REG1, 0x3, 2 * nr,
> +			     fmt_reg_value);
> +
> +	tw_mask_shift_writel((nr < 2
> +			      ? TW5864_H264EN_RATE_MAX_LINE_REG1
> +			      : TW5864_H264EN_RATE_MAX_LINE_REG2),
> +			     0x1f, 5 * (nr % 2),
> +			     input->std == STD_NTSC ? 29 : 24);
> +
> +	tw_mask_shift_writel((nr < 2) ? TW5864_FRAME_BUS1 :
> +			     TW5864_FRAME_BUS2, 0xff, (nr % 2) * 8,
> +			     reg_frame_bus);
> +
> +	spin_lock_irqsave(&dev->slock, flags);
> +	input->enabled = 1;
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +
> +	return 0;
> +}
> +
> +void tw5864_request_encoded_frame(struct tw5864_input *input)
> +{
> +	struct tw5864_dev *dev = input->root;
> +	u32 enc_buf_id_new;
> +
> +	tw_setl(TW5864_DSP_CODEC, TW5864_CIF_MAP_MD | TW5864_HD1_MAP_MD);
> +	tw_writel(TW5864_EMU, input->reg_emu);
> +	tw_writel(TW5864_INTERLACING, input->reg_interlacing);
> +	tw_writel(TW5864_DSP, input->reg_dsp);
> +
> +	tw_writel(TW5864_DSP_QP, input->reg_dsp_qp);
> +	tw_writel(TW5864_DSP_REF_MVP_LAMBDA, input->reg_dsp_ref_mvp_lambda);
> +	tw_writel(TW5864_DSP_I4x4_WEIGHT, input->reg_dsp_i4x4_weight);
> +	tw_mask_shift_writel(TW5864_DSP_INTRA_MODE, TW5864_DSP_INTRA_MODE_MASK,
> +			     TW5864_DSP_INTRA_MODE_SHIFT,
> +			     TW5864_DSP_INTRA_MODE_16x16);
> +
> +	if (input->frame_gop_seqno == 0) {
> +		/* Produce I-frame */
> +		tw_writel(TW5864_MOTION_SEARCH_ETC, TW5864_INTRA_EN);
> +		input->h264_idr_pic_id++;
> +		input->h264_idr_pic_id &= TW5864_DSP_REF_FRM;
> +	} else {
> +		/* Produce P-frame */
> +		tw_writel(TW5864_MOTION_SEARCH_ETC, TW5864_INTRA_EN |
> +			  TW5864_ME_EN | BIT(5) /* SRCH_OPT default */);
> +	}
> +	tw5864_prepare_frame_headers(input);
> +	tw_writel(TW5864_VLC,
> +		  TW5864_VLC_PCI_SEL |
> +		  ((input->tail_nb_bits + 24) << TW5864_VLC_BIT_ALIGN_SHIFT) |
> +		  input->reg_dsp_qp);
> +
> +	enc_buf_id_new = tw_mask_shift_readl(TW5864_ENC_BUF_PTR_REC1, 0x3,
> +					     2 * input->nr);
> +	tw_writel(TW5864_DSP_ENC_ORG_PTR_REG,
> +		  enc_buf_id_new << TW5864_DSP_ENC_ORG_PTR_SHIFT);
> +	tw_writel(TW5864_DSP_ENC_REC,
> +		  enc_buf_id_new << 12 | ((enc_buf_id_new + 3) & 3));
> +
> +	tw_writel(TW5864_SLICE, TW5864_START_NSLICE);
> +	tw_writel(TW5864_SLICE, 0);
> +}
> +
> +static int tw5864_disable_input(struct tw5864_input *input)
> +{
> +	struct tw5864_dev *dev = input->root;
> +	unsigned long flags;
> +
> +	dev_dbg(&dev->pci->dev, "Disabling channel %d\n", input->nr);
> +
> +	spin_lock_irqsave(&dev->slock, flags);
> +	input->enabled = 0;
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +	return 0;
> +}
> +
> +static int tw5864_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct tw5864_input *input = vb2_get_drv_priv(q);
> +
> +	return tw5864_enable_input(input);

If this fails with an error, then all pending buffers should be returned (vb2_buffer_done)
with state QUEUED.

> +}
> +
> +static void tw5864_stop_streaming(struct vb2_queue *q)
> +{
> +	unsigned long flags;
> +	struct tw5864_input *input = vb2_get_drv_priv(q);
> +
> +	tw5864_disable_input(input);
> +
> +	spin_lock_irqsave(&input->slock, flags);
> +	if (input->vb) {
> +		vb2_buffer_done(&input->vb->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +		input->vb = NULL;
> +	}
> +	while (!list_empty(&input->active)) {
> +		struct tw5864_buf *buf = container_of(input->active.next,
> +						      struct tw5864_buf, list);
> +
> +		list_del(&buf->list);
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	}
> +	spin_unlock_irqrestore(&input->slock, flags);
> +}
> +
> +static struct vb2_ops tw5864_video_qops = {
> +	.queue_setup = tw5864_queue_setup,
> +	.buf_queue = tw5864_buf_queue,
> +	.start_streaming = tw5864_start_streaming,
> +	.stop_streaming = tw5864_stop_streaming,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +};
> +
> +static int tw5864_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct tw5864_input *input =
> +		container_of(ctrl->handler, struct tw5864_input, hdl);
> +	struct tw5864_dev *dev = input->root;
> +	unsigned long flags;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		tw_indir_writeb(TW5864_INDIR_VIN_A_BRIGHT(input->nr),
> +				(u8)ctrl->val);
> +		break;
> +	case V4L2_CID_HUE:
> +		tw_indir_writeb(TW5864_INDIR_VIN_7_HUE(input->nr),
> +				(u8)ctrl->val);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		tw_indir_writeb(TW5864_INDIR_VIN_9_CNTRST(input->nr),
> +				(u8)ctrl->val);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		tw_indir_writeb(TW5864_INDIR_VIN_B_SAT_U(input->nr),
> +				(u8)ctrl->val);
> +		tw_indir_writeb(TW5864_INDIR_VIN_C_SAT_V(input->nr),
> +				(u8)ctrl->val);
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
> +		input->gop = ctrl->val;
> +		return 0;
> +	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
> +		spin_lock_irqsave(&input->slock, flags);
> +		input->qp = ctrl->val;
> +		input->reg_dsp_qp = input->qp;
> +		input->reg_dsp_ref_mvp_lambda = lambda_lookup_table[input->qp];
> +		input->reg_dsp_i4x4_weight = intra4x4_lambda3[input->qp];
> +		spin_unlock_irqrestore(&input->slock, flags);
> +		return 0;
> +	case V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD:
> +		memset(input->md_threshold_grid_values, ctrl->val,
> +		       sizeof(input->md_threshold_grid_values));
> +		return 0;
> +	case V4L2_CID_DETECT_MD_MODE:
> +		return 0;
> +	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
> +		/* input->md_threshold_grid_ctrl->p_new.p_u16 contains data */
> +		memcpy(input->md_threshold_grid_values,
> +		       input->md_threshold_grid_ctrl->p_new.p_u16,
> +		       sizeof(input->md_threshold_grid_values));
> +		return 0;
> +	}
> +	return 0;
> +}
> +
> +static int tw5864_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +
> +	f->fmt.pix.width = 720;
> +	switch (input->std) {
> +	default:
> +		WARN_ON_ONCE(1);
> +	case STD_NTSC:
> +		f->fmt.pix.height = 480;
> +		break;
> +	case STD_PAL:
> +	case STD_SECAM:
> +		f->fmt.pix.height = 576;
> +		break;
> +	}
> +	f->fmt.pix.field = V4L2_FIELD_NONE;

This is really FIELD_INTERLACED.

> +	f->fmt.pix.pixelformat = V4L2_PIX_FMT_H264;
> +	f->fmt.pix.sizeimage = H264_VLC_BUF_SIZE;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	return 0;
> +}
> +
> +static int tw5864_enum_input(struct file *file, void *priv,
> +			     struct v4l2_input *i)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	struct tw5864_dev *dev = input->root;
> +
> +	u8 indir_0x000 = tw_indir_readb(TW5864_INDIR_VIN_0(input->nr));
> +	u8 indir_0x00d = tw_indir_readb(TW5864_INDIR_VIN_D(input->nr));
> +	u8 v1 = indir_0x000;
> +	u8 v2 = indir_0x00d;
> +
> +	if (i->index)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	snprintf(i->name, sizeof(i->name), "Encoder %d", input->nr);
> +	i->std = TW5864_NORMS;
> +	if (v1 & (1 << 7))
> +		i->status |= V4L2_IN_ST_NO_SYNC;
> +	if (!(v1 & (1 << 6)))
> +		i->status |= V4L2_IN_ST_NO_H_LOCK;
> +	if (v1 & (1 << 2))
> +		i->status |= V4L2_IN_ST_NO_SIGNAL;
> +	if (v1 & (1 << 1))
> +		i->status |= V4L2_IN_ST_NO_COLOR;
> +	if (v2 & (1 << 2))
> +		i->status |= V4L2_IN_ST_MACROVISION;
> +
> +	return 0;
> +}
> +
> +static int tw5864_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int tw5864_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	if (i)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int tw5864_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +
> +	strcpy(cap->driver, "tw5864");
> +	snprintf(cap->card, sizeof(cap->card), "TW5864 Encoder %d",
> +		 input->nr);
> +	sprintf(cap->bus_info, "PCI:%s", pci_name(input->root->pci));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
> +		V4L2_CAP_STREAMING;
> +
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

This line can be dropped: the v4l2 core will do this automatically.

> +	return 0;
> +}
> +
> +static int tw5864_querystd(struct file *file, void *priv, v4l2_std_id *std)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	enum tw5864_vid_std tw_std;
> +	int ret;
> +
> +	ret = tw5864_input_std_get(input, &tw_std);
> +	if (ret)
> +		return ret;
> +	*std = tw5864_get_v4l2_std(tw_std);
> +
> +	return 0;
> +}
> +
> +static int tw5864_g_std(struct file *file, void *priv, v4l2_std_id *std)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	*std = input->v4l2_std;
> +	return 0;
> +}
> +
> +static int tw5864_s_std(struct file *file, void *priv, v4l2_std_id std)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	struct tw5864_dev *dev = input->root;
> +
> +	input->v4l2_std = std;
> +	input->std = tw5864_from_v4l2_std(std);
> +	tw_indir_writeb(TW5864_INDIR_VIN_E(input->nr), input->std);
> +	return 0;
> +}
> +
> +static int tw5864_enum_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	if (f->index)
> +		return -EINVAL;
> +
> +	f->pixelformat = V4L2_PIX_FMT_H264;
> +
> +	return 0;
> +}
> +
> +static int tw5864_subscribe_event(struct v4l2_fh *fh,
> +				  const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_CTRL:
> +		return v4l2_ctrl_subscribe_event(fh, sub);
> +	case V4L2_EVENT_MOTION_DET:
> +		/*
> +		 * Allow for up to 30 events (1 second for NTSC) to be stored.
> +		 */
> +		return v4l2_event_subscribe(fh, sub, 30, NULL);
> +	}
> +	return -EINVAL;
> +}
> +
> +static void tw5864_frame_interval_set(struct tw5864_input *input)
> +{
> +	/*
> +	 * This register value seems to follow such approach: In each second
> +	 * interval, when processing Nth frame, it checks Nth bit of register
> +	 * value and, if the bit is 1, it processes the frame, otherwise the
> +	 * frame is discarded.
> +	 * So unary representation would work, but more or less equal gaps
> +	 * between the frames should be preserved.
> +	 *
> +	 * For 1 FPS - 0x00000001
> +	 * 00000000 00000000 00000000 00000001
> +	 *
> +	 * For max FPS - set all 25/30 lower bits:
> +	 * 00111111 11111111 11111111 11111111 (NTSC)
> +	 * 00000001 11111111 11111111 11111111 (PAL)
> +	 *
> +	 * For half of max FPS - use such pattern:
> +	 * 00010101 01010101 01010101 01010101 (NTSC)
> +	 * 00000001 01010101 01010101 01010101 (PAL)
> +	 *
> +	 * Et cetera.
> +	 *
> +	 * The value supplied to hardware is capped by mask of 25/30 lower bits.
> +	 */
> +	struct tw5864_dev *dev = input->root;
> +	u32 unary_framerate = 0;
> +	int shift = 0;
> +	int std_max_fps = input->std == STD_NTSC ? 30 : 25;
> +
> +	for (shift = 0; shift < std_max_fps; shift += input->frame_interval)
> +		unary_framerate |= 0x00000001 << shift;
> +
> +	tw_writel(TW5864_H264EN_RATE_CNTL_LO_WORD(input->nr, 0),
> +		  unary_framerate >> 16);
> +	tw_writel(TW5864_H264EN_RATE_CNTL_HI_WORD(input->nr, 0),
> +		  unary_framerate & 0xffff);
> +}
> +
> +static int tw5864_frameinterval_get(struct tw5864_input *input,
> +				    struct v4l2_fract *frameinterval)
> +{
> +	int ret;
> +	enum tw5864_vid_std std;
> +
> +	ret = tw5864_input_std_get(input, &std);
> +	if (ret)
> +		return ret;
> +
> +	frameinterval->numerator = 1;
> +
> +	switch (std) {
> +	case STD_NTSC:
> +		frameinterval->denominator = 30;

Numerator should be 1001, denominator 30000.

> +		break;
> +	case STD_PAL:
> +	case STD_SECAM:
> +		frameinterval->denominator = 25;
> +		break;
> +	default:
> +		WARN(1, "tw5864_frameinterval_get requested for unknown std %d\n",
> +		     std);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tw5864_enum_frameintervals(struct file *file, void *priv,
> +				      struct v4l2_frmivalenum *fintv)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +
> +	if (fintv->pixel_format != V4L2_PIX_FMT_H264)
> +		return -EINVAL;
> +	if (fintv->index)
> +		return -EINVAL;
> +	if (fintv->width != input->width || fintv->height != input->height)
> +		return -EINVAL;
> +
> +	fintv->type = V4L2_FRMIVAL_TYPE_DISCRETE;

Since multiple frameintervals are supported, you likely want TYPE_STEPWISE here.

> +
> +	return tw5864_frameinterval_get(input, &fintv->discrete);
> +}
> +
> +static int tw5864_g_parm(struct file *file, void *priv,
> +			 struct v4l2_streamparm *sp)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	struct v4l2_captureparm *cp = &sp->parm.capture;
> +	int ret;
> +
> +	cp->capability = V4L2_CAP_TIMEPERFRAME;
> +
> +	ret = tw5864_frameinterval_get(input, &cp->timeperframe);
> +	cp->timeperframe.numerator *= input->frame_interval;
> +	cp->capturemode = 0;
> +	cp->readbuffers = 2;
> +
> +	return ret;
> +}
> +
> +static int tw5864_s_parm(struct file *file, void *priv,
> +			 struct v4l2_streamparm *sp)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	struct v4l2_fract *t = &sp->parm.capture.timeperframe;
> +	struct v4l2_fract time_base;
> +	int ret;
> +
> +	ret = tw5864_frameinterval_get(input, &time_base);
> +	if (ret)
> +		return ret;
> +
> +	if (!t->numerator || !t->denominator) {
> +		t->numerator = input->frame_interval;

= time_base.numerator * input->frame_interval

> +		t->denominator = time_base.denominator;
> +	} else if (t->denominator != time_base.denominator) {
> +		t->numerator = t->numerator * time_base.denominator /
> +			t->denominator;
> +		t->denominator = time_base.denominator;
> +	}
> +
> +	input->frame_interval = t->numerator;

= t->numerator / time_base.numerator

> +	tw5864_frame_interval_set(input);
> +	return tw5864_g_parm(file, priv, sp);
> +}

You'll need to implement enum_framesizes as well. Shouldn't be hard since you have a number of
discrete sizes that as supported.

Regards,

	Hans
