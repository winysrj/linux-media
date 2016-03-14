Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41976 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933867AbcCNIHE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 04:07:04 -0400
Subject: Re: [PATCH] Add tw5864 driver
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>
References: <1457920713-21009-1-git-send-email-andrey.utkin@corp.bluecherry.net>
 <1457920751-21101-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E6711F.8020403@xs4all.nl>
Date: Mon, 14 Mar 2016 09:06:55 +0100
MIME-Version: 1.0
In-Reply-To: <1457920751-21101-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

See below for a quick review of the code.

I agree with Greg's comment why this is added to staging instead of drivers/media/pci?

When you post the v2 patch, can you add the output of 'v4l2-compliance -s' to the
cover letter? Please use the latest v4l2-compliance version from the v4l-utils.git
repository when testing.

On 03/14/2016 02:59 AM, Andrey Utkin wrote:
> Support for boards based on Techwell TW5864 chip which provides
> multichannel video & audio grabbing and encoding (H.264, MJPEG,
> ADPCM G.726).
> 
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> ---
>  MAINTAINERS                                  |    7 +
>  drivers/staging/media/Kconfig                |    2 +
>  drivers/staging/media/Makefile               |    1 +
>  drivers/staging/media/tw5864/Kconfig         |   11 +
>  drivers/staging/media/tw5864/Makefile        |    3 +
>  drivers/staging/media/tw5864/tw5864-bs.h     |  154 ++
>  drivers/staging/media/tw5864/tw5864-config.c |  359 +++++
>  drivers/staging/media/tw5864/tw5864-core.c   |  453 ++++++
>  drivers/staging/media/tw5864/tw5864-h264.c   |  183 +++
>  drivers/staging/media/tw5864/tw5864-reg.h    | 2200 ++++++++++++++++++++++++++
>  drivers/staging/media/tw5864/tw5864-tables.h |  237 +++
>  drivers/staging/media/tw5864/tw5864-video.c  | 1364 ++++++++++++++++
>  drivers/staging/media/tw5864/tw5864.h        |  280 ++++
>  include/linux/pci_ids.h                      |    1 +
>  14 files changed, 5255 insertions(+)
>  create mode 100644 drivers/staging/media/tw5864/Kconfig
>  create mode 100644 drivers/staging/media/tw5864/Makefile
>  create mode 100644 drivers/staging/media/tw5864/tw5864-bs.h
>  create mode 100644 drivers/staging/media/tw5864/tw5864-config.c
>  create mode 100644 drivers/staging/media/tw5864/tw5864-core.c
>  create mode 100644 drivers/staging/media/tw5864/tw5864-h264.c
>  create mode 100644 drivers/staging/media/tw5864/tw5864-reg.h
>  create mode 100644 drivers/staging/media/tw5864/tw5864-tables.h
>  create mode 100644 drivers/staging/media/tw5864/tw5864-video.c
>  create mode 100644 drivers/staging/media/tw5864/tw5864.h
> 

<snip>

> diff --git a/drivers/staging/media/tw5864/tw5864-bs.h b/drivers/staging/media/tw5864/tw5864-bs.h
> new file mode 100644
> index 0000000..8c1df7a
> --- /dev/null
> +++ b/drivers/staging/media/tw5864/tw5864-bs.h
> @@ -0,0 +1,154 @@

<snip>

> +static inline void bs_direct_write(struct bs *s, u8 value)
> +{
> +	*s->p = value;
> +	s->p++;
> +	s->i_left = 8;
> +}
> +
> +static inline void bs_write(struct bs *s, int i_count, u32 i_bits)

This one is a bit too big to be an inline IMHO.

> +{
> +	if (s->p >= s->p_end - 4)
> +		return;
> +	while (i_count > 0) {
> +		if (i_count < 32)
> +			i_bits &= (1 << i_count) - 1;
> +		if (i_count < s->i_left) {
> +			*s->p = (*s->p << i_count) | i_bits;
> +			s->i_left -= i_count;
> +			break;
> +		}
> +		*s->p = (*s->p << s->i_left) | (i_bits >> (i_count -
> +							   s->i_left));
> +		i_count -= s->i_left;
> +		s->p++;
> +		s->i_left = 8;
> +	}
> +}
> +

<snip>

> diff --git a/drivers/staging/media/tw5864/tw5864-config.c b/drivers/staging/media/tw5864/tw5864-config.c
> new file mode 100644
> index 0000000..ff3e308
> --- /dev/null
> +++ b/drivers/staging/media/tw5864/tw5864-config.c
> @@ -0,0 +1,359 @@
> +/*
> + *  TW5864 driver - analog decoders configuration functions
> + *
> + *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
> + *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
> +#include "tw5864.h"
> +#include "tw5864-reg.h"
> +
> +#define TW5864_IIC_TIMEOUT  (30000)
> +
> +static unsigned char tbl_pal_tw2864_common[] __used = {

Just use static const and remove the __used.

It would be nice to have a short comment before each array that gives a bit
more information.

> +	0x00, 0x00, 0x64, 0x11,
> +	0x80, 0x80, 0x00, 0x12,
> +	0x12, 0x20, 0x0a, 0xD0,
> +	0x00, 0x00, 0x07, 0x7F,
> +};
> +

<snip>

> +static int __used i2c_multi_read(struct tw5864_dev *dev, u8 devid, u8 devfn,
> +				 u8 *buf, u32 count)

Again, what's up with the __used? Just remove it.

> +{
> +	int i = 0;
> +	u32 val = 0;
> +	int timeout = TW5864_IIC_TIMEOUT;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	for (i = 0; i < count; i++) {
> +		val = (1 << 24) | ((devid | 0x01) << 16) | ((devfn + i) << 8);
> +
> +		tw_writel(TW5864_IIC, val);
> +
> +		do {
> +			val = tw_readl(TW5864_IIC) & (0x01000000);
> +		} while ((!val) && (--timeout));
> +		if (!timeout) {
> +			local_irq_restore(flags);
> +			dev_err(&dev->pci->dev, "dev 0x%x, fn 0x%x\n", devid,
> +				devfn);
> +			return -ETIMEDOUT;
> +		}
> +		buf[i] = (u8)tw_readl(TW5864_IIC);
> +	}
> +	local_irq_restore(flags);
> +
> +	return 0;
> +}
> diff --git a/drivers/staging/media/tw5864/tw5864-core.c b/drivers/staging/media/tw5864/tw5864-core.c
> new file mode 100644
> index 0000000..c41ba4c
> --- /dev/null
> +++ b/drivers/staging/media/tw5864/tw5864-core.c

<snip>

> +static void tw5864_h264_isr(struct tw5864_dev *dev)
> +{
> +	int channel = tw_readl(TW5864_DSP) & TW5864_DSP_ENC_CHN;
> +	struct tw5864_input *input = &dev->inputs[channel];
> +	int cur_frame_index, next_frame_index;
> +	struct tw5864_h264_frame *cur_frame, *next_frame;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->slock, flags);
> +
> +	cur_frame_index = dev->h264_buf_w_index;
> +	next_frame_index = (cur_frame_index + 1) % H264_BUF_CNT;
> +	cur_frame = &dev->h264_buf[cur_frame_index];
> +	next_frame = &dev->h264_buf[next_frame_index];
> +
> +	dma_sync_single_for_cpu(&dev->pci->dev, cur_frame->vlc.dma_addr,
> +				H264_VLC_BUF_SIZE, DMA_FROM_DEVICE);
> +	dma_sync_single_for_cpu(&dev->pci->dev, cur_frame->mv.dma_addr,
> +				H264_MV_BUF_SIZE, DMA_FROM_DEVICE);
> +
> +	if (next_frame_index != dev->h264_buf_r_index) {
> +		cur_frame->vlc_len = tw_readl(TW5864_VLC_LENGTH) << 2;
> +		cur_frame->checksum = tw_readl(TW5864_VLC_CRC_REG);
> +		cur_frame->input = input;
> +		cur_frame->timestamp = ktime_get_ns();
> +
> +		dev->h264_buf_w_index = next_frame_index;
> +		tasklet_schedule(&dev->tasklet);
> +
> +		cur_frame = next_frame;
> +	} else {
> +		dev_err(&dev->pci->dev,
> +			"Skipped frame on input %d because all buffers busy\n",
> +			channel);
> +	}
> +
> +	dev->encoder_busy = 0;
> +
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +
> +	input->frame_seqno++;
> +
> +	dma_sync_single_for_device(&dev->pci->dev,
> +				   cur_frame->vlc.dma_addr,
> +				   H264_VLC_BUF_SIZE, DMA_FROM_DEVICE);
> +	dma_sync_single_for_device(&dev->pci->dev,
> +				   cur_frame->mv.dma_addr,
> +				   H264_MV_BUF_SIZE, DMA_FROM_DEVICE);
> +
> +	tw_writel(TW5864_VLC_STREAM_BASE_ADDR, cur_frame->vlc.dma_addr);
> +	tw_writel(TW5864_MV_STREAM_BASE_ADDR, cur_frame->mv.dma_addr);
> +}
> +
> +static void tw5864_timer_isr(struct tw5864_dev *dev)

This function is unused?! Left-over from old code?

> +{
> +	unsigned long flags;
> +	int i;
> +	int encoder_busy;
> +
> +	spin_lock_irqsave(&dev->slock, flags);
> +	encoder_busy = dev->encoder_busy;
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +
> +	if (encoder_busy)
> +		return;
> +
> +	/*
> +	 * Traversing inputs in round-robin fashion, starting from next to the
> +	 * last processed one
> +	 */
> +	for (i = 0; i < TW5864_INPUTS; i++) {
> +		int next_input = (i + dev->next_i) % TW5864_INPUTS;
> +		struct tw5864_input *input = &dev->inputs[next_input];
> +		int raw_buf_id; /* id of internal buf with last raw frame */
> +
> +		spin_lock_irqsave(&input->slock, flags);
> +		if (!input->enabled)
> +			goto next;
> +
> +		raw_buf_id = tw_mask_shift_readl(TW5864_SENIF_ORG_FRM_PTR1, 0x3,
> +						 2 * input->input_number);
> +
> +		/* Check if new raw frame is available */
> +		if (input->buf_id == raw_buf_id)
> +			goto next;
> +
> +		input->buf_id = raw_buf_id;
> +		spin_unlock_irqrestore(&input->slock, flags);
> +
> +		spin_lock_irqsave(&dev->slock, flags);
> +		dev->encoder_busy = 1;
> +		spin_unlock_irqrestore(&dev->slock, flags);
> +		tw5864_request_encoded_frame(input);
> +		break;
> +next:
> +		spin_unlock_irqrestore(&input->slock, flags);
> +		continue;
> +	}
> +}
> +
> +static size_t regs_dump(struct tw5864_dev *dev, char *buf, size_t size)
> +{

Instead of implementing this I would recommend that you implement VIDIOC_DBG_G/S_REGISTER.
See for example drivers/media/pci/ivtv/ivtv-ioctl.c.

Together with the v4l2-dbg utility you have what you need with less code.

You can add a patch to v4l2-dbg.cpp to have these 5 ranges printed as the default
(around line 720 in that source).

> +	size_t count = 0;
> +	u32 reg_addr;
> +	u32 value;
> +	int i;
> +	struct range {
> +		int start;
> +		int end;
> +	} ranges[] = {
> +		{ 0x0000, 0x2FFC },
> +		{ 0x4000, 0x4FFC },
> +		{ 0x8000, 0x180DC },
> +		{ 0x18100, 0x1817C },
> +		{ 0x80000, 0x87FFF },
> +	};
> +
> +	/*
> +	 * Dumping direct registers space,
> +	 * except some spots which trigger hanging
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(ranges); i++)
> +		for (reg_addr = ranges[i].start;
> +		     (count < size) && (reg_addr <= ranges[i].end);
> +		     reg_addr += 4) {
> +			value = tw_readl(reg_addr);
> +			count += scnprintf(buf + count, size - count,
> +					   "[0x%05x] = 0x%08x\n",
> +					   reg_addr, value);
> +		}
> +
> +	/* Dumping indirect register space */
> +	for (reg_addr = 0x0; (count < size) && (reg_addr <= 0xEFE);
> +	     reg_addr += 1) {
> +		value = tw_indir_readb(dev, reg_addr);
> +		count += scnprintf(buf + count, size - count,
> +				   "indir[0x%03x] = 0x%02x\n", reg_addr, value);
> +	}
> +
> +	return count;
> +}
> +
> +#define DEBUGFS_BUF_SIZE (1024 * 1024)
> +
> +struct debugfs_buffer {
> +	size_t count;
> +	char data[DEBUGFS_BUF_SIZE];
> +};
> +
> +static int debugfs_regs_dump_open(struct inode *inode, struct file *file)
> +{
> +	struct tw5864_dev *dev = inode->i_private;
> +	struct debugfs_buffer *buf;
> +
> +	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	buf->count = regs_dump(dev, buf->data, sizeof(buf->data));
> +
> +	file->private_data = buf;
> +	return 0;
> +}
> +
> +static ssize_t debugfs_regs_dump_read(struct file *file, char __user *user_buf,
> +				      size_t nbytes, loff_t *ppos)
> +{
> +	struct debugfs_buffer *buf = file->private_data;
> +
> +	return simple_read_from_buffer(user_buf, nbytes, ppos, buf->data,
> +				       buf->count);
> +}
> +
> +static int debugfs_regs_dump_release(struct inode *inode, struct file *file)
> +{
> +	kfree(file->private_data);
> +	file->private_data = NULL;
> +
> +	return 0;
> +}
> +
> +static const struct file_operations debugfs_regs_dump_fops = {
> +	.owner = THIS_MODULE,
> +	.open = debugfs_regs_dump_open,
> +	.llseek = no_llseek,
> +	.read = debugfs_regs_dump_read,
> +	.release = debugfs_regs_dump_release,
> +};

<snip>

> diff --git a/drivers/staging/media/tw5864/tw5864-video.c b/drivers/staging/media/tw5864/tw5864-video.c
> new file mode 100644
> index 0000000..71b79df
> --- /dev/null
> +++ b/drivers/staging/media/tw5864/tw5864-video.c
> @@ -0,0 +1,1364 @@
> +/*
> + *  TW5864 driver - video encoding functions
> + *
> + *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
> + *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
> +#include "tw5864-tables.h"
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
> +	u8 indir_0x00e = tw_indir_readb(dev,
> +					0x00e + input->input_number * 0x010);
> +	std = (indir_0x00e & 0x70) >> 4;
> +
> +	if (indir_0x00e & 0x80) {
> +		dev_err(&dev->pci->dev,
> +			"Video format detection is in progress, please wait\n");
> +		return -EAGAIN;
> +	}
> +
> +	if (std == STD_INVALID) {
> +		dev_err(&dev->pci->dev, "No valid video format detected\n");
> +		return -1;
> +	}
> +
> +	*std_arg = std;
> +	return 0;
> +}

Ah, this is a common mistake. The only time a driver should detect the standard
is from the querystd ioctl. In all other cases it should just use the standard that
is currently set. So this code belongs in the querystd implementation.

> +
> +static int tw5864_enable_input(struct tw5864_input *input)
> +{
> +	struct tw5864_dev *dev = input->root;
> +	int input_number = input->input_number;
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
> +	dev_dbg(&dev->pci->dev, "Enabling channel %d\n", input_number);
> +
> +	ret = tw5864_input_std_get(input, &input->std);

So this is wrong, just store the current std in the tw5864 struct (or perhaps
tw5864_input, but the std is probably a global property).

> +	if (ret)
> +		return ret;

As a side benefit of that change this function no longer returns an error and you
can make it a void function.

> +	input->v4l2_std = tw5864_get_v4l2_std(input->std);

It is generally not a good idea to convert between the internal std representation
and v4l2_std_id. Just store both when they are set with VIDIOC_S_STD.

The problem is that if userspace sets STD_PAL_H, then after converting and reading it
back it ends up as STD_PAL, which is unexpected.

> +
> +	input->frame_seqno = 0;
> +	input->h264_idr_pic_id = 0;
> +	input->h264_frame_seqno_in_gop = 0;
> +
> +	input->reg_dsp_qp = input->qp;
> +	input->reg_dsp_ref_mvp_lambda = lambda_lookup_table[input->qp];
> +	input->reg_dsp_i4x4_weight = intra4x4_lambda3[input->qp];
> +	input->reg_emu = TW5864_EMU_EN_LPF | TW5864_EMU_EN_BHOST
> +		| TW5864_EMU_EN_SEN | TW5864_EMU_EN_ME | TW5864_EMU_EN_DDR;
> +	input->reg_dsp = input_number /* channel id */
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

Why support multiple resolutions when you hardcode it to D1 anyway? Just curious.

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
> +		tw_setl(TW5864_FULL_HALF_FLAG, 1 << input_number);
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
> +		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << input_number);
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
> +		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << input_number);
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
> +		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << input_number);
> +		break;
> +	}
> +
> +	/* analog input width / 4 */
> +	tw_indir_writeb(dev, TW5864_INDIR_IN_PIC_WIDTH(input_number),
> +			d1_width / 4);
> +	tw_indir_writeb(dev, TW5864_INDIR_IN_PIC_HEIGHT(input_number),
> +			d1_height / 4);
> +
> +	/* output width / 4 */
> +	tw_indir_writeb(dev, TW5864_INDIR_OUT_PIC_WIDTH(input_number),
> +			input->width / 4);
> +	tw_indir_writeb(dev, TW5864_INDIR_OUT_PIC_HEIGHT(input_number),
> +			input->height / 4);
> +
> +	tw_writel(TW5864_DSP_PIC_MAX_MB,
> +		  ((input->width / 16) << 8) | (input->height / 16));
> +
> +	tw_writel(TW5864_FRAME_WIDTH_BUS_A(input_number),
> +		  frame_width_bus_value);
> +	tw_writel(TW5864_FRAME_WIDTH_BUS_B(input_number),
> +		  frame_width_bus_value);
> +	tw_writel(TW5864_FRAME_HEIGHT_BUS_A(input_number),
> +		  frame_height_bus_value);
> +	tw_writel(TW5864_FRAME_HEIGHT_BUS_B(input_number),
> +		  (frame_height_bus_value + 1) / 2 - 1);
> +
> +	tw5864_frame_interval_set(input);
> +
> +	if (downscale_enabled)
> +		tw_setl(TW5864_H264EN_CH_DNS, 1 << input_number);
> +
> +	tw_mask_shift_writel(TW5864_H264EN_CH_FMT_REG1, 0x3, 2 * input_number,
> +			     fmt_reg_value);
> +
> +	tw_mask_shift_writel(
> +			     (input_number < 2
> +			      ? TW5864_H264EN_RATE_MAX_LINE_REG1
> +			      : TW5864_H264EN_RATE_MAX_LINE_REG2),
> +			     0x1f, 5 * (input_number % 2),
> +			     input->std == STD_NTSC ? 29 : 24);
> +
> +	tw_mask_shift_writel((input_number < 2) ? TW5864_FRAME_BUS1 :
> +			     TW5864_FRAME_BUS2, 0xff, (input_number % 2) * 8,
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
> +	/* 16x16 */
> +	tw_mask_shift_writel(TW5864_DSP_INTRA_MODE, TW5864_DSP_INTRA_MODE_MASK,
> +			     TW5864_DSP_INTRA_MODE_SHIFT,
> +			     TW5864_DSP_INTRA_MODE_16x16);
> +
> +	if (input->frame_seqno % input->gop == 0) {
> +		/* Produce I-frame */
> +		tw_writel(TW5864_MOTION_SEARCH_ETC, TW5864_INTRA_EN);
> +		input->h264_frame_seqno_in_gop = 0;
> +		input->h264_idr_pic_id++;
> +		input->h264_idr_pic_id &= TW5864_DSP_REF_FRM;
> +	} else {
> +		/* Produce P-frame */
> +		tw_writel(TW5864_MOTION_SEARCH_ETC,
> +			  TW5864_INTRA_EN
> +			  | TW5864_ME_EN
> +			  | BIT(5) /* SRCH_OPT default */
> +			 );
> +		input->h264_frame_seqno_in_gop++;
> +	}
> +	tw5864_prepare_frame_headers(input);
> +	tw_writel(TW5864_VLC,
> +		  TW5864_VLC_PCI_SEL | ((input->tail_nb_bits + 24) <<
> +					TW5864_VLC_BIT_ALIGN_SHIFT) |
> +		  input->reg_dsp_qp);
> +
> +	enc_buf_id_new = tw_mask_shift_readl(TW5864_ENC_BUF_PTR_REC1, 0x3,
> +					     2 * input->input_number);
> +	tw_writel(TW5864_DSP_ENC_ORG_PTR_REG,
> +		  ((enc_buf_id_new + 1) % 4) << TW5864_DSP_ENC_ORG_PTR_SHIFT);
> +	tw_writel(TW5864_DSP_ENC_REC,
> +		  (((enc_buf_id_new + 1) % 4) << 12) | (enc_buf_id_new & 0x3));
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
> +	dev_dbg(&dev->pci->dev, "Disabling channel %d\n", input->input_number);
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
> +	tw5864_enable_input(input);

Normally you would have to check the error here, but as mentioned above this function
can become a void function, so this code would be OK.

> +	return 0;
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
> +		tw_indir_writeb(dev,
> +				TW5864_INDIR_VIN_A_BRIGHT(input->input_number),
> +				(u8)ctrl->val);
> +		break;
> +	case V4L2_CID_HUE:
> +		tw_indir_writeb(dev,
> +				TW5864_INDIR_VIN_7_HUE(input->input_number),
> +				(u8)ctrl->val);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		tw_indir_writeb(dev,
> +				TW5864_INDIR_VIN_9_CNTRST(input->input_number),
> +				(u8)ctrl->val);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		tw_indir_writeb(dev,
> +				TW5864_INDIR_VIN_B_SAT_U(input->input_number),
> +				(u8)ctrl->val);
> +		tw_indir_writeb(dev,
> +				TW5864_INDIR_VIN_C_SAT_V(input->input_number),
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
> +static int tw5864_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	enum tw5864_vid_std std;
> +	int ret;
> +
> +	ret = tw5864_input_std_get(input, &std);
> +	if (ret)
> +		return ret;

No autodetect here! Just use the current std value.

> +
> +	f->fmt.pix.width = 720;
> +	switch (std) {
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
> +	f->fmt.pix.pixelformat = V4L2_PIX_FMT_H264;
> +	f->fmt.pix.sizeimage = H264_VLC_BUF_SIZE;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	f->fmt.pix.priv = 0;

This priv = 0 is no longer needed, just drop it.

> +	return 0;
> +}
> +
> +static int tw5864_enum_input(struct file *file, void *priv,
> +			     struct v4l2_input *i)
> +{
> +	struct tw5864_input *dev = video_drvdata(file);
> +
> +	u8 indir_0x000 = tw_indir_readb(dev->root,
> +			TW5864_INDIR_VIN_0(dev->input_number));
> +	u8 indir_0x00d = tw_indir_readb(dev->root,
> +			TW5864_INDIR_VIN_D(dev->input_number));
> +	u8 v1 = indir_0x000;
> +	u8 v2 = indir_0x00d;
> +
> +	if (i->index)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	snprintf(i->name, sizeof(i->name), "Encoder %d", dev->input_number);
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
> +	struct tw5864_input *dev = video_drvdata(file);
> +
> +	strcpy(cap->driver, "tw5864");
> +	snprintf(cap->card, sizeof(cap->card), "TW5864 Encoder %d",
> +		 dev->input_number);
> +	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->root->pci));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
> +		V4L2_CAP_STREAMING;
> +
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int tw5864_g_std(struct file *file, void *priv, v4l2_std_id *id)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	enum tw5864_vid_std std;
> +	int ret;
> +
> +	ret = tw5864_input_std_get(input, &std);
> +	if (ret)
> +		return ret;
> +
> +	*id = tw5864_get_v4l2_std(std);

So just return e.g. input->std (or dev->std if the std is a global property).

> +	return 0;
> +}
> +
> +static int tw5864_s_std(struct file *file, void *priv, v4l2_std_id id)
> +{
> +	struct tw5864_input *input = video_drvdata(file);
> +	enum tw5864_vid_std std;
> +	int ret;
> +
> +	ret = tw5864_input_std_get(input, &std);
> +	if (ret)
> +		return ret;
> +
> +	/* Allow only if matches with currently detected */
> +	if (id != tw5864_get_v4l2_std(std))
> +		return -EINVAL;

This is wrong. Just set the std regardless of what is currently detected.

> +
> +	return 0;
> +}

And add a tw5864_querystd here that does the actual std detection.

> +
> +static int tw5864_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	return tw5864_g_fmt_vid_cap(file, priv, f);
> +}
> +
> +static int tw5864_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return tw5864_try_fmt_vid_cap(file, priv, f);
> +}

Just rename tw5864_g_fmt_vid_cap to tw5864_fmt_vid_cap and point all three
*_fmt_vid_cap vidioc callbacks to that function instead of having these
two wrapper functions.

> +
> +static int tw5864_enum_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	if (f->index)
> +		return -EINVAL;
> +
> +	f->pixelformat = V4L2_PIX_FMT_H264;
> +	strcpy(f->description, "H.264");

Drop this line. The description field is set in the v4l2 core these days to
ensure consistent naming.

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

Are you sure this is per second interval? I would expect this to be a
per-32-frames register. Have you tested this?

For NTSC standards the number of frames per second can be either 29 or 30,
so that's what makes it weird to do this on a per second basis.

> +	 * So unary representation would work, but more or less equal gaps
> +	 * between the frames should be preserved.
> +	 * For 1 FPS - 0x00000001
> +	 * 00000000 00000000 00000000 00000001
> +	 *
> +	 * For 2 FPS - 0x00010001.
> +	 * 00000000 00000001 00000000 00000001
> +	 *
> +	 * For 4 FPS - 0x01010101.
> +	 * 00000001 00000001 00000001 00000001
> +	 *
> +	 * For 8 FPS - 0x11111111.
> +	 * 00010001 00010001 00010001 00010001
> +	 *
> +	 * For 16 FPS - 0x55555555.
> +	 * 01010101 01010101 01010101 01010101
> +	 *
> +	 * For 32 FPS (not reached - capped by 25/30 limit) - 0xffffffff.
> +	 * 11111111 11111111 11111111 11111111
> +	 *
> +	 * Et cetera.
> +	 */
> +	struct tw5864_dev *dev = input->root;
> +	u32 unary_framerate = 0;
> +	int shift = 0;
> +
> +	for (shift = 0; shift <= 32; shift += input->frame_interval)
> +		unary_framerate |= 0x00000001 << shift;
> +
> +	tw_writel(TW5864_H264EN_RATE_CNTL_LO_WORD(input->input_number, 0),
> +		  unary_framerate >> 16);
> +	tw_writel(TW5864_H264EN_RATE_CNTL_HI_WORD(input->input_number, 0),
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
> +	case STD_SECAM:

Huh? SECAM has the same framerate as PAL.

> +		frameinterval->denominator = 25;

This should be: numerator = 1001, denominator = 30000 (29.97 Hz)

> +		break;
> +	case STD_PAL:
> +		frameinterval->denominator = 30;

This should be 25 (25 Hz).

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
> +
> +	fintv->type = V4L2_FRMIVAL_TYPE_DISCRETE;

You have to check width and height here as well.

> +
> +	return tw5864_frameinterval_get(input, &fintv->discrete);

This makes no sense: this enum function returns only one interval, but
s_parm supports multiple intervals. All those intervals should be
reported by this enum function as well.

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
> +		dev_err(&input->root->pci->dev,
> +			"weird timeperframe %u/%u, using current %u/%u\n",
> +			t->numerator, t->denominator,
> +			input->frame_interval, time_base.denominator);

Not an error. If either value is 0, then a sensible default should be used
as per the spec. In this case it should choose 25 or 29.97 Hz based on the
current standard.

> +		t->numerator = input->frame_interval;
> +		t->denominator = time_base.denominator;
> +	} else if (t->denominator != time_base.denominator) {
> +		t->numerator = t->numerator * time_base.denominator /
> +			t->denominator;
> +		t->denominator = time_base.denominator;
> +	}
> +
> +	input->frame_interval = t->numerator;
> +	tw5864_frame_interval_set(input);
> +	return tw5864_g_parm(file, priv, sp);
> +}
> +
> +static const struct v4l2_ctrl_ops tw5864_ctrl_ops = {
> +	.s_ctrl = tw5864_s_ctrl,
> +};
> +
> +static const struct v4l2_file_operations video_fops = {
> +	.owner = THIS_MODULE,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release,
> +	.read = vb2_fop_read,
> +	.poll = vb2_fop_poll,
> +	.mmap = vb2_fop_mmap,
> +	.unlocked_ioctl = video_ioctl2,
> +};
> +
> +static const struct v4l2_ioctl_ops video_ioctl_ops = {
> +	.vidioc_querycap = tw5864_querycap,
> +	.vidioc_enum_fmt_vid_cap = tw5864_enum_fmt_vid_cap,
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_expbuf = vb2_ioctl_expbuf,
> +	.vidioc_s_std = tw5864_s_std,
> +	.vidioc_g_std = tw5864_g_std,
> +	.vidioc_enum_input = tw5864_enum_input,
> +	.vidioc_g_input = tw5864_g_input,
> +	.vidioc_s_input = tw5864_s_input,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +	.vidioc_try_fmt_vid_cap = tw5864_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = tw5864_s_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap = tw5864_g_fmt_vid_cap,
> +	.vidioc_log_status = v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event = tw5864_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +	.vidioc_enum_frameintervals = tw5864_enum_frameintervals,
> +	.vidioc_s_parm = tw5864_s_parm,
> +	.vidioc_g_parm = tw5864_g_parm,
> +};
> +
> +static struct video_device tw5864_video_template = {
> +	.name = "tw5864_video",
> +	.fops = &video_fops,
> +	.ioctl_ops = &video_ioctl_ops,
> +	.release = video_device_release_empty,
> +	.tvnorms = TW5864_NORMS,
> +};
> +
> +/* The TW5864 uses 192 (16x12) detection cells in full screen for motion
> + * detection. Each detection cell is composed of 44 pixels and 20 lines for
> + * NTSC and 24 lines for PAL.
> + */
> +#define MD_CELLS_HOR 16
> +#define MD_CELLS_VERT 12
> +
> +/* Motion Detection Threshold matrix */
> +static const struct v4l2_ctrl_config tw5864_md_thresholds = {
> +	.ops = &tw5864_ctrl_ops,
> +	.id = V4L2_CID_DETECT_MD_THRESHOLD_GRID,
> +	.dims = {MD_CELLS_HOR, MD_CELLS_VERT},
> +	.def = 14,
> +	/* See tw5864_md_metric_from_mvd() */
> +	.max = 2 * 0x0f,
> +	.step = 1,
> +};
> +
> +static int tw5864_video_input_init(struct tw5864_input *dev, int video_nr);
> +static void tw5864_video_input_fini(struct tw5864_input *dev);
> +static void tw5864_tables_upload(struct tw5864_dev *dev);
> +
> +int tw5864_video_init(struct tw5864_dev *dev, int *video_nr)
> +{
> +	int i;
> +	int ret = -1;
> +
> +	for (i = 0; i < H264_BUF_CNT; i++) {
> +		dev->h264_buf[i].vlc.addr =
> +			dma_alloc_coherent(&dev->pci->dev, H264_VLC_BUF_SIZE,
> +					   &dev->h264_buf[i].vlc.dma_addr,
> +					   GFP_KERNEL | GFP_DMA32);
> +		dev->h264_buf[i].mv.addr =
> +			dma_alloc_coherent(&dev->pci->dev, H264_MV_BUF_SIZE,
> +					   &dev->h264_buf[i].mv.dma_addr,
> +					   GFP_KERNEL | GFP_DMA32);
> +		if (!dev->h264_buf[i].vlc.addr || !dev->h264_buf[i].mv.addr) {
> +			dev_err(&dev->pci->dev, "dma alloc & map fail\n");
> +			ret = -ENOMEM;
> +			goto dma_alloc_fail;
> +		}
> +	}
> +
> +	tw5864_tables_upload(dev);
> +	tw5864_init_ad(dev);
> +
> +	/* Picture is distorted without this block */
> +	/* use falling edge to sample 54M to 108M */
> +	tw_indir_writeb(dev, TW5864_INDIR_VD_108_POL,
> +			TW5864_INDIR_VD_108_POL_BOTH);
> +	tw_indir_writeb(dev, TW5864_INDIR_CLK0_SEL, 0x00);
> +
> +	tw_indir_writeb(dev, TW5864_INDIR_DDRA_DLL_DQS_SEL0, 0x02);
> +	tw_indir_writeb(dev, TW5864_INDIR_DDRA_DLL_DQS_SEL1, 0x02);
> +	tw_indir_writeb(dev, TW5864_INDIR_DDRA_DLL_CLK90_SEL, 0x02);
> +	tw_indir_writeb(dev, TW5864_INDIR_DDRB_DLL_DQS_SEL0, 0x02);
> +	tw_indir_writeb(dev, TW5864_INDIR_DDRB_DLL_DQS_SEL1, 0x02);
> +	tw_indir_writeb(dev, TW5864_INDIR_DDRB_DLL_CLK90_SEL, 0x02);
> +
> +	/* video input reset */
> +	tw_indir_writeb(dev, TW5864_INDIR_RESET, 0);
> +	tw_indir_writeb(dev, TW5864_INDIR_RESET, TW5864_INDIR_RESET_VD |
> +			TW5864_INDIR_RESET_DLL | TW5864_INDIR_RESET_MUX_CORE);
> +	mdelay(10);
> +
> +	/*
> +	 * Select Part A mode for all channels.
> +	 * tw_setl instead of tw_clearl for Part B mode.
> +	 *
> +	 * I guess "Part B" is primarily for downscaled version of same channel
> +	 * which goes in Part A of same bus
> +	 */
> +	tw_writel(TW5864_FULL_HALF_MODE_SEL, 0);
> +
> +	tw_indir_writeb(dev, TW5864_INDIR_PV_VD_CK_POL,
> +			TW5864_INDIR_PV_VD_CK_POL_VD(0) |
> +			TW5864_INDIR_PV_VD_CK_POL_VD(1) |
> +			TW5864_INDIR_PV_VD_CK_POL_VD(2) |
> +			TW5864_INDIR_PV_VD_CK_POL_VD(3));
> +
> +	dev->h264_buf_r_index = 0;
> +	dev->h264_buf_w_index = 0;
> +	tw_writel(TW5864_VLC_STREAM_BASE_ADDR,
> +		  dev->h264_buf[dev->h264_buf_w_index].vlc.dma_addr);
> +	tw_writel(TW5864_MV_STREAM_BASE_ADDR,
> +		  dev->h264_buf[dev->h264_buf_w_index].mv.dma_addr);
> +
> +	for (i = 0; i < TW5864_INPUTS; i++) {
> +		tw_indir_writeb(dev, TW5864_INDIR_VIN_E(i), 0x07);
> +		/* to initiate auto format recognition */
> +		tw_indir_writeb(dev, TW5864_INDIR_VIN_F(i), 0xff);
> +	}
> +
> +	tw_writel(TW5864_SEN_EN_CH, 0x000f);
> +	tw_writel(TW5864_H264EN_CH_EN, 0x000f);
> +
> +	tw_writel(TW5864_H264EN_BUS0_MAP, 0x00000000);
> +	tw_writel(TW5864_H264EN_BUS1_MAP, 0x00001111);
> +	tw_writel(TW5864_H264EN_BUS2_MAP, 0x00002222);
> +	tw_writel(TW5864_H264EN_BUS3_MAP, 0x00003333);
> +
> +	/*
> +	 * Quote from Intersil (manufacturer):
> +	 * 0x0038 is managed by HW, and by default it won't pass the pointer set
> +	 * at 0x0010. So if you don't do encoding, 0x0038 should stay at '3'
> +	 * (with 4 frames in buffer). If you encode one frame and then move
> +	 * 0x0010 to '1' for example, HW will take one more frame and set it to
> +	 * buffer #0, and then you should see 0x0038 is set to '0'.  There is
> +	 * only one HW encoder engine, so 4 channels cannot get encoded
> +	 * simultaneously. But each channel does have its own buffer (for
> +	 * original frames and reconstructed frames). So there is no problem to
> +	 * manage encoding for 4 channels at same time and no need to force
> +	 * I-frames in switching channels.
> +	 * End of quote.
> +	 *
> +	 * If we set 0x0010 (TW5864_ENC_BUF_PTR_REC1) to 0 (for any channel), we
> +	 * have no "rolling" (until we change this value).
> +	 * If we set 0x0010 (TW5864_ENC_BUF_PTR_REC1) to 0x3, it starts to roll
> +	 * continuously together with 0x0038.
> +	 */
> +	tw_writel(TW5864_ENC_BUF_PTR_REC1, 0x00ff);
> +	tw_writel(TW5864_PCI_INTTM_SCALE, 3);
> +
> +	tw_writel(TW5864_INTERLACING, TW5864_DI_EN);
> +	tw_writel(TW5864_MASTER_ENB_REG, TW5864_PCI_VLC_INTR_ENB);
> +	tw_writel(TW5864_PCI_INTR_CTL,
> +		  TW5864_TIMER_INTR_ENB | TW5864_PCI_MAST_ENB |
> +		  TW5864_MVD_VLC_MAST_ENB);
> +
> +	dev->encoder_busy = 0;
> +
> +	dev->irqmask |= TW5864_INTR_VLC_DONE | TW5864_INTR_TIMER;
> +	tw5864_irqmask_apply(dev);
> +
> +	tasklet_init(&dev->tasklet, tw5864_handle_frame_task,
> +		     (unsigned long)dev);
> +
> +	for (i = 0; i < TW5864_INPUTS; i++) {
> +		dev->inputs[i].root = dev;
> +		dev->inputs[i].input_number = i;
> +		ret = tw5864_video_input_init(&dev->inputs[i], video_nr[i]);
> +		if (ret)
> +			goto input_init_fail;
> +	}
> +
> +	return 0;
> +
> +dma_alloc_fail:
> +	for (i = 0; i < H264_BUF_CNT; i++) {
> +		dma_free_coherent(&dev->pci->dev, H264_VLC_BUF_SIZE,
> +				  dev->h264_buf[i].vlc.addr,
> +				  dev->h264_buf[i].vlc.dma_addr);
> +		dma_free_coherent(&dev->pci->dev, H264_MV_BUF_SIZE,
> +				  dev->h264_buf[i].mv.addr,
> +				  dev->h264_buf[i].mv.dma_addr);
> +	}
> +
> +	i = TW5864_INPUTS;
> +
> +input_init_fail:
> +	for (; i >= 0; i--)
> +		tw5864_video_input_fini(&dev->inputs[i]);
> +
> +	tasklet_kill(&dev->tasklet);
> +
> +	return ret;
> +}
> +
> +static int tw5864_video_input_init(struct tw5864_input *input, int video_nr)
> +{
> +	int ret;
> +	struct v4l2_ctrl_handler *hdl = &input->hdl;
> +
> +	mutex_init(&input->lock);
> +	spin_lock_init(&input->slock);
> +
> +	/* setup video buffers queue */
> +	INIT_LIST_HEAD(&input->active);
> +	input->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	input->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	input->vidq.io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
> +	input->vidq.ops = &tw5864_video_qops;
> +	input->vidq.mem_ops = &vb2_dma_contig_memops;
> +	input->vidq.drv_priv = input;
> +	input->vidq.gfp_flags = __GFP_DMA32;
> +	input->vidq.buf_struct_size = sizeof(struct tw5864_buf);
> +	input->vidq.lock = &input->lock;
> +	input->vidq.min_buffers_needed = 12;
> +	ret = vb2_queue_init(&input->vidq);
> +	if (ret)
> +		goto vb2_q_init_fail;
> +
> +	input->vdev = tw5864_video_template;
> +	input->vdev.v4l2_dev = &input->root->v4l2_dev;
> +	input->vdev.lock = &input->lock;
> +	input->vdev.queue = &input->vidq;
> +	video_set_drvdata(&input->vdev, input);
> +
> +	/* Initialize the device control structures */
> +	input->alloc_ctx = vb2_dma_contig_init_ctx(&input->root->pci->dev);
> +	if (IS_ERR(input->alloc_ctx)) {
> +		ret = PTR_ERR(input->alloc_ctx);
> +		goto vb2_dma_contig_init_ctx_fail;
> +	}
> +
> +	v4l2_ctrl_handler_init(hdl, 6);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_CONTRAST, 0, 255, 1, 100);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_SATURATION, 0, 255, 1, 128);
> +	/* NTSC only */

There is no HUE support for PAL? Weird.

> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops, V4L2_CID_HUE, -128, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, GOP_SIZE);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 28, 51, 1, QP_VALUE);
> +	v4l2_ctrl_new_std_menu(hdl, &tw5864_ctrl_ops,
> +			       V4L2_CID_DETECT_MD_MODE,
> +			       V4L2_DETECT_MD_MODE_THRESHOLD_GRID, 0,
> +			       V4L2_DETECT_MD_MODE_DISABLED);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD,
> +			  tw5864_md_thresholds.min, tw5864_md_thresholds.max,
> +			  tw5864_md_thresholds.step, tw5864_md_thresholds.def);
> +	input->md_threshold_grid_ctrl =
> +		v4l2_ctrl_new_custom(hdl, &tw5864_md_thresholds, NULL);
> +	if (hdl->error) {
> +		ret = hdl->error;
> +		goto v4l2_ctrl_fail;
> +	}
> +	input->vdev.ctrl_handler = hdl;
> +	v4l2_ctrl_handler_setup(hdl);
> +
> +	input->qp = QP_VALUE;
> +	input->gop = GOP_SIZE;
> +	input->frame_interval = 1;
> +
> +	ret = video_register_device(&input->vdev, VFL_TYPE_GRABBER, video_nr);
> +	if (ret)
> +		goto v4l2_ctrl_fail;
> +
> +	dev_info(&input->root->pci->dev, "Registered video device %s\n",
> +		 video_device_node_name(&input->vdev));
> +
> +	return 0;
> +
> +v4l2_ctrl_fail:
> +	v4l2_ctrl_handler_free(hdl);
> +	vb2_dma_contig_cleanup_ctx(input->alloc_ctx);
> +vb2_dma_contig_init_ctx_fail:
> +	vb2_queue_release(&input->vidq);
> +vb2_q_init_fail:
> +	mutex_destroy(&input->lock);
> +
> +	return ret;
> +}

<snip>

> +v4l2_std_id tw5864_get_v4l2_std(enum tw5864_vid_std std)
> +{
> +	switch (std) {
> +	case STD_NTSC:
> +		return V4L2_STD_NTSC_M;
> +	case STD_PAL:
> +		return V4L2_STD_PAL_B;
> +	case STD_SECAM:
> +		return V4L2_STD_SECAM_B;

This illustrates the point I made earlier. Just store the original
std value userspace passed in and drop this function.

> +	case STD_INVALID:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +	return 0;
> +}
> +
> +enum tw5864_vid_std tw5864_from_v4l2_std(v4l2_std_id v4l2_std)
> +{
> +	if (v4l2_std & V4L2_STD_NTSC)

This should be STD_525_60. Some PAL variants are 60 Hz and 720x480 as well.

> +		return STD_NTSC;
> +	if (v4l2_std & V4L2_STD_PAL)
> +		return STD_PAL;
> +	if (v4l2_std & V4L2_STD_SECAM)
> +		return STD_SECAM;
> +	WARN_ON_ONCE(1);
> +	return STD_AUTO;

I'd return NTSC or PAL here, not AUTO.

> +}
> +
> +static void tw5864_tables_upload(struct tw5864_dev *dev)
> +{
> +	int i;
> +
> +	tw_writel(TW5864_VLC_RD, 0x1);
> +	for (i = 0; i < VLC_LOOKUP_TABLE_LEN; i++) {
> +		tw_writel((TW5864_VLC_STREAM_MEM_START + (i << 2)),
> +			  encoder_vlc_lookup_table[i]);
> +	}
> +	tw_writel(TW5864_VLC_RD, 0x0);
> +
> +	for (i = 0; i < QUANTIZATION_TABLE_LEN; i++) {
> +		tw_writel((TW5864_QUAN_TAB + (i << 2)),
> +			  forward_quantization_table[i]);
> +	}
> +
> +	for (i = 0; i < QUANTIZATION_TABLE_LEN; i++) {
> +		tw_writel((TW5864_QUAN_TAB + (i << 2)),
> +			  inverse_quantization_table[i]);
> +	}
> +}
> diff --git a/drivers/staging/media/tw5864/tw5864.h b/drivers/staging/media/tw5864/tw5864.h
> new file mode 100644
> index 0000000..d140fee
> --- /dev/null
> +++ b/drivers/staging/media/tw5864/tw5864.h
> @@ -0,0 +1,280 @@
> +/*
> + *  TW5864 driver  - common header file
> + *
> + *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
> + *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
> +#include <linux/pci.h>
> +#include <linux/videodev2.h>
> +#include <linux/notifier.h>
> +#include <linux/delay.h>
> +#include <linux/mutex.h>
> +#include <linux/io.h>
> +#include <linux/debugfs.h>
> +#include <linux/interrupt.h>
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "tw5864-reg.h"
> +
> +#define TW5864_NORMS ( \
> +		       V4L2_STD_NTSC  | V4L2_STD_PAL    | V4L2_STD_SECAM | \
> +		       V4L2_STD_PAL_M | V4L2_STD_PAL_Nc | V4L2_STD_PAL_60)

You can use STD_ALL here. But did you ever test PAL_M/Nc/60 or SECAM?

> +
> +/* ----------------------------------------------------------- */
> +/* static data                                                 */
> +
> +struct tw5864_tvnorm {
> +	char *name;
> +	v4l2_std_id id;
> +
> +	/* video decoder */
> +	u32 sync_control;
> +	u32 luma_control;
> +	u32 chroma_ctrl1;
> +	u32 chroma_gain;
> +	u32 chroma_ctrl2;
> +	u32 vgate_misc;
> +
> +	/* video scaler */
> +	u32 h_delay;
> +	u32 h_start;
> +	u32 h_stop;
> +	u32 v_delay;
> +	u32 video_v_start;
> +	u32 video_v_stop;
> +	u32 vbi_v_start_0;
> +	u32 vbi_v_stop_0;
> +	u32 vbi_v_start_1;
> +
> +	/* Techwell specific */
> +	u32 format;
> +};
> +
> +struct tw5864_format {
> +	char *name;
> +	u32 fourcc;
> +	u32 depth;
> +	u32 twformat;
> +};
> +
> +/* ----------------------------------------------------------- */
> +/* card configuration   */
> +
> +#define TW5864_INPUTS 4
> +
> +#define H264_VLC_BUF_SIZE 0x80000
> +#define H264_MV_BUF_SIZE 0x40000
> +#define QP_VALUE 28
> +#define BITALIGN_VALUE_IN_TIMER 0
> +#define BITALIGN_VALUE_IN_INIT 0
> +#define GOP_SIZE 32
> +
> +enum resolution {
> +	D1 = 1,
> +	HD1 = 2, /* half d1 - 360x(240|288) */
> +	CIF = 3,
> +	QCIF = 4,
> +};
> +
> +/* ----------------------------------------------------------- */
> +/* device / file handle status                                 */
> +
> +struct tw5864_dev; /* forward delclaration */
> +
> +/* buffer for one video/vbi/ts frame */
> +struct tw5864_buf {
> +	struct vb2_v4l2_buffer vb;
> +	struct list_head list;
> +
> +	unsigned int size;
> +};
> +
> +struct tw5864_fmt {
> +	char *name;
> +	u32 fourcc; /* v4l2 format id */
> +	int depth;
> +	int flags;
> +	u32 twformat;
> +};
> +
> +struct tw5864_dma_buf {
> +	void *addr;
> +	dma_addr_t dma_addr;
> +};
> +
> +enum tw5864_vid_std {
> +	STD_NTSC = 0,
> +	STD_PAL = 1,
> +	STD_SECAM = 2,
> +
> +	STD_INVALID = 7,
> +	STD_AUTO = 7,
> +};
> +
> +v4l2_std_id tw5864_get_v4l2_std(enum tw5864_vid_std std);
> +enum tw5864_vid_std tw5864_from_v4l2_std(v4l2_std_id v4l2_std);
> +
> +struct tw5864_input {
> +	int input_number;
> +	struct tw5864_dev *root;
> +	struct mutex lock; /* used for vidq and vdev */
> +	spinlock_t slock; /* used for sync between ISR, tasklet & V4L2 API */
> +	struct video_device vdev;
> +	struct v4l2_ctrl_handler hdl;
> +	const struct tw5864_tvnorm *tvnorm;
> +	void *alloc_ctx;
> +	struct vb2_queue vidq;
> +	struct list_head active;
> +	const struct tw5864_format *fmt;
> +	enum resolution resolution;
> +	unsigned int width, height;
> +	unsigned int frame_seqno;
> +	unsigned int h264_idr_pic_id;
> +	unsigned int h264_frame_seqno_in_gop;
> +	int enabled;
> +	enum tw5864_vid_std std;
> +	v4l2_std_id v4l2_std;
> +	int tail_nb_bits;
> +	u8 tail;
> +	u8 *buf_cur_ptr;
> +	int buf_cur_space_left;
> +
> +	u32 reg_interlacing;
> +	u32 reg_vlc;
> +	u32 reg_dsp_codec;
> +	u32 reg_dsp;
> +	u32 reg_emu;
> +	u32 reg_dsp_qp;
> +	u32 reg_dsp_ref_mvp_lambda;
> +	u32 reg_dsp_i4x4_weight;
> +	u32 buf_id;
> +
> +	struct tw5864_buf *vb;
> +
> +	struct v4l2_ctrl *md_threshold_grid_ctrl;
> +	u16 md_threshold_grid_values[12 * 16];
> +	int qp;
> +	int gop;
> +
> +	/*
> +	 * In (1/MAX_FPS) units.
> +	 * For max FPS (default), set to 1.
> +	 * For 1 FPS, set to e.g. 32.
> +	 */
> +	int frame_interval;
> +};
> +
> +struct tw5864_h264_frame {
> +	struct tw5864_dma_buf vlc;
> +	struct tw5864_dma_buf mv;
> +
> +	int vlc_len;
> +	u32 checksum;
> +	struct tw5864_input *input;
> +
> +	u64 timestamp;
> +};
> +
> +/* global device status */
> +struct tw5864_dev {
> +	spinlock_t slock; /* used for sync between ISR, tasklet & V4L2 API */
> +	struct v4l2_device v4l2_dev;
> +	struct tw5864_input inputs[TW5864_INPUTS];
> +#define H264_BUF_CNT 64
> +	struct tw5864_h264_frame h264_buf[H264_BUF_CNT];
> +	int h264_buf_r_index;
> +	int h264_buf_w_index;
> +
> +	struct tasklet_struct tasklet;
> +
> +	int encoder_busy;
> +	/* Input number to check next (in RR fashion) */
> +	int next_i;
> +
> +	/* pci i/o */
> +	char name[64];
> +	struct pci_dev *pci;
> +	void __iomem *mmio;
> +	u32 irqmask;
> +	u32 frame_seqno;
> +
> +	u32 stored_len;
> +
> +	struct dentry *debugfs_dir;
> +};
> +
> +#define tw_readl(reg) readl(dev->mmio + reg)
> +#define tw_mask_readl(reg, mask) \
> +	(tw_readl(reg) & (mask))
> +#define tw_mask_shift_readl(reg, mask, shift) \
> +	(tw_mask_readl((reg), ((mask) << (shift))) >> (shift))
> +
> +#define tw_writel(reg, value) writel((value), dev->mmio + reg)
> +#define tw_mask_writel(reg, mask, value) \
> +	tw_writel(reg, (tw_readl(reg) & ~(mask)) | ((value) & (mask)))
> +#define tw_mask_shift_writel(reg, mask, shift, value) \
> +	tw_mask_writel((reg), ((mask) << (shift)), ((value) << (shift)))
> +
> +#define tw_setl(reg, bit) tw_writel((reg), tw_readl(reg) | (bit))
> +#define tw_clearl(reg, bit) tw_writel((reg), tw_readl(reg) & ~(bit))
> +
> +u8 tw_indir_readb(struct tw5864_dev *dev, u16 addr);
> +void tw_indir_writeb(struct tw5864_dev *dev, u16 addr, u8 data);
> +
> +void tw5864_set_tvnorm_hw(struct tw5864_dev *dev);
> +
> +void tw5864_irqmask_apply(struct tw5864_dev *dev);
> +void tw5864_init_ad(struct tw5864_dev *dev);
> +int tw5864_video_init(struct tw5864_dev *dev, int *video_nr);
> +void tw5864_video_fini(struct tw5864_dev *dev);
> +void tw5864_prepare_frame_headers(struct tw5864_input *input);
> +void tw5864_h264_put_stream_header(u8 **buf, size_t *space_left, int qp,
> +				   int width, int height);
> +void tw5864_h264_put_slice_header(u8 **buf, size_t *space_left,
> +				  unsigned int idr_pic_id,
> +				  unsigned int frame_seqno_in_gop,
> +				  int *tail_nb_bits, u8 *tail);
> +void tw5864_request_encoded_frame(struct tw5864_input *input);
> +void tw5864_push_to_make_it_roll(struct tw5864_input *input);
> +
> +static const unsigned int lambda_lookup_table[52] = {
> +	0x0020, 0x0020, 0x0020, 0x0020,
> +	0x0020, 0x0020, 0x0020, 0x0020,
> +	0x0020, 0x0020, 0x0020, 0x0020,
> +	0x0020, 0x0020, 0x0020, 0x0020,
> +	0x0040, 0x0040, 0x0040, 0x0040,
> +	0x0060, 0x0060, 0x0060, 0x0080,
> +	0x0080, 0x0080, 0x00a0, 0x00c0,
> +	0x00c0, 0x00e0, 0x0100, 0x0120,
> +	0x0140, 0x0160, 0x01a0, 0x01c0,
> +	0x0200, 0x0240, 0x0280, 0x02e0,
> +	0x0320, 0x03a0, 0x0400, 0x0480,
> +	0x0500, 0x05a0, 0x0660, 0x0720,
> +	0x0800, 0x0900, 0x0a20, 0x0b60
> +};
> +
> +static const unsigned int intra4x4_lambda3[52] = {
> +	1, 1, 1, 1, 1, 1, 1, 1,
> +	1, 1, 1, 1, 1, 1, 1, 1,
> +	2, 2, 2, 2, 3, 3, 3, 4,
> +	4, 4, 5, 6, 6, 7, 8, 9,
> +	10, 11, 13, 14, 16, 18, 20, 23,
> +	25, 29, 32, 36, 40, 45, 51, 57,
> +	64, 72, 81, 91
> +};

Do these two tables belong here? I'd move them to the C source that uses them.

> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 37f05cb..231afead 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2333,6 +2333,7 @@
>  #define PCI_VENDOR_ID_CAVIUM		0x177d
>  
>  #define PCI_VENDOR_ID_TECHWELL		0x1797
> +#define PCI_DEVICE_ID_TECHWELL_5864	0x5864
>  #define PCI_DEVICE_ID_TECHWELL_6800	0x6800
>  #define PCI_DEVICE_ID_TECHWELL_6801	0x6801
>  #define PCI_DEVICE_ID_TECHWELL_6804	0x6804
> 

Regards,

	Hans
