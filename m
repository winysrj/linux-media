Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:55707 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757510AbcGKF6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 01:58:48 -0400
Subject: Re: [PATCH v3] Add tw5864 driver
To: Andrey Utkin <andrey_utkin@fastmail.com>,
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
References: <20160709194618.15609-1-andrey_utkin@fastmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cac4c81a-9065-2337-7d34-eea8b8482519@xs4all.nl>
Date: Mon, 11 Jul 2016 07:58:38 +0200
MIME-Version: 1.0
In-Reply-To: <20160709194618.15609-1-andrey_utkin@fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

Thanks for this driver. Some review comments below:

On 07/09/2016 09:46 PM, Andrey Utkin wrote:
> From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> 
> 
> Changes in v3 since v2:
>  - Kconfig: select VIDEOBUF2_DMA_CONTIG, not SG
>  - drop i2c code as unused
>  - Dropped num_buffers check in queue_setup as suggested by Hans
>  - Drop std autodetect on streaming start as suggested by Hans
>  - Cleanup buf queue on enable_input() failure
>  - Change container_of() to list_entry() where applicable
>  - Changed V4L2_FIELD_NONE to V4L2_FIELD_INTERLACED as suggested
>  - frameinterval rework suggested by Hans
>  - Add enum_framesizes
>  - Report framesize based on std, not input w/h
>  - Add printed warning about known video quality issues
>  - MAINTAINERS: fix path
>  - request_mem_region() -> pci_request_regions()
>  - Rebase onto Hans' "for-v4.8i" branch
>  - Follow changes from patchset "vb2: replace allocation context by device pointer"
> 
> Below log is produced by today's v4l2-compliance from v4l-utils git, and this
> patch based on branch "for-v4.8i" of git://linuxtv.org/hverkuil/media_tree.git .
> Compliance test runs fine.
> 
> checkpatch.pl is happy with this patch except for artifacts_warning which
> produces a bunch of such warnings:
> 
> WARNING: quoted string split across lines
> #155: FILE: drivers/media/pci/tw5864/tw5864-core.c:44:
> +"This driver was developed by Bluecherry LLC by deducing behaviour of original"
> +" manufacturer's driver, from both source code and execution traces.\n"
> 
> I believe I'd better not join all the lines to avoid them looking like
> 
> "Paragraph one.\Paragraph two.\Paragraph three.\n"
> 
>  # v4l2-compliance -d 6 -s
> v4l2-compliance SHA   : 5e74f6a15aa14c01d8319e086d98f33d96a6a04d
> 
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
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
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
>         test DMABUF: OK (Not Supported)
> 
> 
> Total: 46, Succeeded: 46, Failed: 0, Warnings: 0
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
>  drivers/media/pci/tw5864/tw5864-core.c  |  373 ++++++
>  drivers/media/pci/tw5864/tw5864-h264.c  |  259 ++++
>  drivers/media/pci/tw5864/tw5864-reg.h   | 2133 +++++++++++++++++++++++++++++++
>  drivers/media/pci/tw5864/tw5864-util.c  |   37 +
>  drivers/media/pci/tw5864/tw5864-video.c | 1510 ++++++++++++++++++++++
>  drivers/media/pci/tw5864/tw5864.h       |  205 +++
>  11 files changed, 4541 insertions(+)
>  create mode 100644 drivers/media/pci/tw5864/Kconfig
>  create mode 100644 drivers/media/pci/tw5864/Makefile
>  create mode 100644 drivers/media/pci/tw5864/tw5864-core.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864-h264.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864-reg.h
>  create mode 100644 drivers/media/pci/tw5864/tw5864-util.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864-video.c
>  create mode 100644 drivers/media/pci/tw5864/tw5864.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a975b8e..46daa99 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11598,6 +11598,14 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Odd fixes
>  F:	drivers/media/usb/tm6000/
>  
> +TW5864 VIDEO4LINUX DRIVER
> +M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
> +M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> +M:	Andrey Utkin <andrey_utkin@fastmail.com>
> +L:	linux-media@vger.kernel.org
> +S:	Supported
> +F:	drivers/media/pci/tw5864/
> +
>  TW68 VIDEO4LINUX DRIVER
>  M:	Hans Verkuil <hverkuil@xs4all.nl>
>  L:	linux-media@vger.kernel.org
> diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
> index 4f6467f..da28e68 100644
> --- a/drivers/media/pci/Kconfig
> +++ b/drivers/media/pci/Kconfig
> @@ -13,6 +13,7 @@ if MEDIA_CAMERA_SUPPORT
>  source "drivers/media/pci/meye/Kconfig"
>  source "drivers/media/pci/solo6x10/Kconfig"
>  source "drivers/media/pci/sta2x11/Kconfig"
> +source "drivers/media/pci/tw5864/Kconfig"
>  source "drivers/media/pci/tw68/Kconfig"
>  source "drivers/media/pci/tw686x/Kconfig"
>  source "drivers/media/pci/zoran/Kconfig"
> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> index 2e54c36..a7e8af0 100644
> --- a/drivers/media/pci/Makefile
> +++ b/drivers/media/pci/Makefile
> @@ -31,3 +31,4 @@ obj-$(CONFIG_VIDEO_MEYE) += meye/
>  obj-$(CONFIG_STA2X11_VIP) += sta2x11/
>  obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
>  obj-$(CONFIG_VIDEO_COBALT) += cobalt/
> +obj-$(CONFIG_VIDEO_TW5864) += tw5864/
> diff --git a/drivers/media/pci/tw5864/Kconfig b/drivers/media/pci/tw5864/Kconfig
> new file mode 100644
> index 0000000..760fb11
> --- /dev/null
> +++ b/drivers/media/pci/tw5864/Kconfig
> @@ -0,0 +1,11 @@
> +config VIDEO_TW5864
> +	tristate "Techwell TW5864 video/audio grabber and encoder"
> +	depends on VIDEO_DEV && PCI && VIDEO_V4L2
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  Support for boards based on Techwell TW5864 chip which provides
> +	  multichannel video & audio grabbing and encoding (H.264, MJPEG,
> +	  ADPCM G.726).
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called tw5864.
> diff --git a/drivers/media/pci/tw5864/Makefile b/drivers/media/pci/tw5864/Makefile
> new file mode 100644
> index 0000000..4fc8b3b
> --- /dev/null
> +++ b/drivers/media/pci/tw5864/Makefile
> @@ -0,0 +1,3 @@
> +tw5864-objs := tw5864-core.o tw5864-video.o tw5864-h264.o tw5864-util.o
> +
> +obj-$(CONFIG_VIDEO_TW5864) += tw5864.o
> diff --git a/drivers/media/pci/tw5864/tw5864-core.c b/drivers/media/pci/tw5864/tw5864-core.c
> new file mode 100644
> index 0000000..c9ab32f
> --- /dev/null
> +++ b/drivers/media/pci/tw5864/tw5864-core.c
> @@ -0,0 +1,373 @@
> +/*
> + *  TW5864 driver - core functions
> + *
> + *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>

2016?

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
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/kmod.h>
> +#include <linux/sound.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/pm.h>
> +#include <linux/pci_ids.h>
> +#include <linux/jiffies.h>
> +#include <asm/dma.h>
> +#include <media/v4l2-dev.h>
> +
> +#include "tw5864.h"
> +#include "tw5864-reg.h"
> +
> +MODULE_DESCRIPTION("V4L2 driver module for tw5864-based multimedia capture & encoding devices");
> +MODULE_AUTHOR("Bluecherry Maintainers <maintainers@bluecherrydvr.com>");
> +MODULE_AUTHOR("Andrey Utkin <andrey.utkin@corp.bluecherry.net>");
> +MODULE_LICENSE("GPL");
> +
> +static char *artifacts_warning = "BEWARE OF KNOWN ISSUES WITH VIDEO QUALITY\n"

const char * const

> +"\n"
> +"This driver was developed by Bluecherry LLC by deducing behaviour of original"
> +" manufacturer's driver, from both source code and execution traces.\n"

All these strings are way too long. Please keep each line under 80 chars.

I'm talking about the string that is output in the kernel log, not about the line
length in this source.

> +"It is known that there are some artifacts on output video with this driver:\n"
> +" - on all known hardware samples: random pixels of wrong color (mostly white,"
> +" red or blue) appearing and disappearing on sequences of P-frames;\n"
> +" - on some hardware samples (known with H.264 core version e006:2800):"
> +" total madness on P-frames: blocks of wrong luminance; blocks of wrong colors"
> +" \"creeping\" across the picture.\n"
> +"There is a workaround for both issues: avoid P-frames by setting GOP size to 1"
> +". To do that, run such command on device files created by this driver:\n"

s/such/this/

> +"\n"
> +"for dev in /dev/video*; do"

Drop this line

> +" v4l2-ctl --device $dev --set-ctrl=video_gop_size=1; done\n"

Replace $dev by /dev/videoX

Wouldn't it make more sense to default to this? And show the warning only if
P-frames are enabled?

> +"\n";
> +
> +static char *artifacts_warning_continued = ""
> +"These issues are not decoding errors; all produced H.264 streams are decoded"
> +" properly. Streams without P-frames don't have these artifacts so it's not"
> +" analog-to-digital conversion issues nor internal memory errors; we conclude"
> +" it's internal H.264 encoder issues.\n"
> +"We cannot even check the original driver's behaviour because it has never"
> +" worked properly at all in our development environment. So these issues may be"
> +" actually related to firmware or hardware. However it may be that there's just"
> +" some more register settings missing in the driver which would please the"
> +" hardware.\n"
> +"Manufacturer didn't help much on our inquiries, but feel free to disturb again"
> +" the support of Intersil (owner of former Techwell).\n"
> +"\n";
> +
> +/* take first free /dev/videoX indexes by default */
> +static unsigned int video_nr[] = {[0 ... (TW5864_INPUTS - 1)] = -1 };
> +
> +module_param_array(video_nr, int, NULL, 0444);
> +MODULE_PARM_DESC(video_nr, "video devices numbers array");
> +
> +/*
> + * Please add any new PCI IDs to: http://pci-ids.ucw.cz.  This keeps
> + * the PCI ID database up to date.  Note that the entries must be
> + * added under vendor 0x1797 (Techwell Inc.) as subsystem IDs.
> + */
> +static const struct pci_device_id tw5864_pci_tbl[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_5864)},
> +	{0,}
> +};
> +
> +void tw5864_irqmask_apply(struct tw5864_dev *dev)
> +{
> +	tw_writel(TW5864_INTR_ENABLE_L, dev->irqmask & 0xffff);
> +	tw_writel(TW5864_INTR_ENABLE_H, (dev->irqmask >> 16));
> +}
> +
> +static void tw5864_interrupts_disable(struct tw5864_dev *dev)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->slock, flags);
> +	dev->irqmask = 0;
> +	tw5864_irqmask_apply(dev);
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +}
> +
> +static void tw5864_timer_isr(struct tw5864_dev *dev);
> +static void tw5864_h264_isr(struct tw5864_dev *dev);
> +
> +static irqreturn_t tw5864_isr(int irq, void *dev_id)
> +{
> +	struct tw5864_dev *dev = dev_id;
> +	u32 status;
> +
> +	status = tw_readl(TW5864_INTR_STATUS_L) |
> +		tw_readl(TW5864_INTR_STATUS_H) << 16;
> +	if (!status)
> +		return IRQ_NONE;
> +
> +	tw_writel(TW5864_INTR_CLR_L, 0xffff);
> +	tw_writel(TW5864_INTR_CLR_H, 0xffff);
> +
> +	if (status & TW5864_INTR_VLC_DONE)
> +		tw5864_h264_isr(dev);
> +
> +	if (status & TW5864_INTR_TIMER)
> +		tw5864_timer_isr(dev);
> +
> +	if (!(status & (TW5864_INTR_TIMER | TW5864_INTR_VLC_DONE))) {
> +		dev_dbg(&dev->pci->dev, "Unknown interrupt, status 0x%08X\n",
> +			status);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
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

This is almost certainly the wrong place. This should probably happen in the
tasklet. The tasklet runs after the isr, so by the time the tasklet runs
you've already called dma_sync_single_for_device.

> +
> +	if (next_frame_index != dev->h264_buf_r_index) {
> +		cur_frame->vlc_len = tw_readl(TW5864_VLC_LENGTH) << 2;
> +		cur_frame->checksum = tw_readl(TW5864_VLC_CRC_REG);
> +		cur_frame->input = input;
> +		cur_frame->timestamp = ktime_get_ns();
> +		cur_frame->seqno = input->frame_seqno;
> +		cur_frame->gop_seqno = input->frame_gop_seqno;
> +
> +		dev->h264_buf_w_index = next_frame_index;
> +		tasklet_schedule(&dev->tasklet);
> +
> +		cur_frame = next_frame;
> +
> +		spin_lock_irqsave(&input->slock, flags);
> +		input->frame_seqno++;
> +		input->frame_gop_seqno++;
> +		if (input->frame_gop_seqno >= input->gop)
> +			input->frame_gop_seqno = 0;
> +		spin_unlock_irqrestore(&input->slock, flags);
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
> +	dma_sync_single_for_device(&dev->pci->dev,
> +				   cur_frame->vlc.dma_addr,
> +				   H264_VLC_BUF_SIZE, DMA_FROM_DEVICE);
> +	dma_sync_single_for_device(&dev->pci->dev,
> +				   cur_frame->mv.dma_addr,
> +				   H264_MV_BUF_SIZE, DMA_FROM_DEVICE);
> +
> +	tw_writel(TW5864_VLC_STREAM_BASE_ADDR, cur_frame->vlc.dma_addr);
> +	tw_writel(TW5864_MV_STREAM_BASE_ADDR, cur_frame->mv.dma_addr);
> +
> +	/* Additional ack for this interrupt */
> +	tw_writel(TW5864_VLC_DSP_INTR, 0x00000001);
> +	tw_writel(TW5864_PCI_INTR_STATUS, TW5864_VLC_DONE_INTR);
> +}
> +
> +static void tw5864_input_deadline_update(struct tw5864_input *input)
> +{
> +	input->new_frame_deadline = jiffies + msecs_to_jiffies(1000);
> +}
> +
> +static void tw5864_timer_isr(struct tw5864_dev *dev)
> +{
> +	unsigned long flags;
> +	int i;
> +	int encoder_busy;
> +
> +	/* Additional ack for this interrupt */
> +	tw_writel(TW5864_PCI_INTR_STATUS, TW5864_TIMER_INTR);
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
> +		int next_input = (i + dev->next_input) % TW5864_INPUTS;
> +		struct tw5864_input *input = &dev->inputs[next_input];
> +		int raw_buf_id; /* id of internal buf with last raw frame */
> +
> +		spin_lock_irqsave(&input->slock, flags);
> +		if (!input->enabled)
> +			goto next;
> +
> +		/* Check if new raw frame is available */
> +		raw_buf_id = tw_mask_shift_readl(TW5864_SENIF_ORG_FRM_PTR1, 0x3,
> +						 2 * input->nr);
> +
> +		if (input->buf_id != raw_buf_id) {
> +			input->buf_id = raw_buf_id;
> +			tw5864_input_deadline_update(input);
> +			spin_unlock_irqrestore(&input->slock, flags);
> +
> +			spin_lock_irqsave(&dev->slock, flags);
> +			dev->encoder_busy = 1;
> +			dev->next_input = (next_input + 1) % TW5864_INPUTS;
> +			spin_unlock_irqrestore(&dev->slock, flags);
> +
> +			tw5864_request_encoded_frame(input);
> +			break;
> +		}
> +
> +		/* No new raw frame; check if channel is stuck */
> +		if (time_is_after_jiffies(input->new_frame_deadline)) {
> +			/* If stuck, request new raw frames again */
> +			tw_mask_shift_writel(TW5864_ENC_BUF_PTR_REC1, 0x3,
> +					     2 * input->nr, input->buf_id + 3);
> +			tw5864_input_deadline_update(input);
> +		}
> +next:
> +		spin_unlock_irqrestore(&input->slock, flags);
> +	}
> +}
> +
> +static int tw5864_initdev(struct pci_dev *pci_dev,
> +			  const struct pci_device_id *pci_id)
> +{
> +	struct tw5864_dev *dev;
> +	int err;
> +
> +	dev = devm_kzalloc(&pci_dev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	snprintf(dev->name, sizeof(dev->name), "tw5864:%s", pci_name(pci_dev));
> +
> +	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
> +	if (err)
> +		return err;
> +
> +	/* pci init */
> +	dev->pci = pci_dev;
> +	err = pci_enable_device(pci_dev);
> +	if (err) {
> +		dev_err(&dev->pci->dev, "pci_enable_device() failed\n");
> +		goto unreg_v4l2;
> +	}
> +
> +	pci_set_master(pci_dev);
> +
> +	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
> +	if (err) {
> +		dev_err(&dev->pci->dev, "32 bit PCI DMA is not supported\n");
> +		goto disable_pci;
> +	}
> +
> +	/* get mmio */
> +	err = pci_request_regions(pci_dev, dev->name);
> +	if (err) {
> +		dev_err(&dev->pci->dev, "Cannot request regions for MMIO\n");
> +		goto disable_pci;
> +	}
> +	dev->mmio = pci_ioremap_bar(pci_dev, 0);
> +	if (!dev->mmio) {
> +		err = -EIO;
> +		dev_err(&dev->pci->dev, "can't ioremap() MMIO memory\n");
> +		goto release_mmio;
> +	}
> +
> +	spin_lock_init(&dev->slock);
> +
> +	dev_info(&pci_dev->dev, "TW5864 hardware version: %04x\n",
> +		 tw_readl(TW5864_HW_VERSION));
> +	dev_info(&pci_dev->dev, "TW5864 H.264 core version: %04x:%04x\n",
> +		 tw_readl(TW5864_H264REV),
> +		 tw_readl(TW5864_UNDECLARED_H264REV_PART2));
> +
> +	err = tw5864_video_init(dev, video_nr);
> +	if (err)
> +		goto unmap_mmio;
> +
> +	/* get irq */
> +	err = devm_request_irq(&pci_dev->dev, pci_dev->irq, tw5864_isr,
> +			       IRQF_SHARED, "tw5864", dev);
> +	if (err < 0) {
> +		dev_err(&dev->pci->dev, "can't get IRQ %d\n", pci_dev->irq);
> +		goto fini_video;
> +	}
> +
> +	dev_warn(&pci_dev->dev, "%s", artifacts_warning);
> +	dev_warn(&pci_dev->dev, "%s", artifacts_warning_continued);
> +
> +	return 0;
> +
> +fini_video:
> +	tw5864_video_fini(dev);
> +unmap_mmio:
> +	iounmap(dev->mmio);
> +release_mmio:
> +	pci_release_regions(pci_dev);
> +disable_pci:
> +	pci_disable_device(pci_dev);
> +unreg_v4l2:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	return err;
> +}
> +
> +static void tw5864_finidev(struct pci_dev *pci_dev)
> +{
> +	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
> +	struct tw5864_dev *dev =
> +		container_of(v4l2_dev, struct tw5864_dev, v4l2_dev);
> +
> +	/* shutdown subsystems */
> +	tw5864_interrupts_disable(dev);
> +
> +	/* unregister */
> +	tw5864_video_fini(dev);
> +
> +	/* release resources */
> +	iounmap(dev->mmio);
> +	release_mem_region(pci_resource_start(pci_dev, 0),
> +			   pci_resource_len(pci_dev, 0));
> +
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	devm_kfree(&pci_dev->dev, dev);
> +}
> +
> +static struct pci_driver tw5864_pci_driver = {
> +	.name = "tw5864",
> +	.id_table = tw5864_pci_tbl,
> +	.probe = tw5864_initdev,
> +	.remove = tw5864_finidev,
> +};
> +
> +module_pci_driver(tw5864_pci_driver);

<snip>

> diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
> new file mode 100644
> index 0000000..473cc5f
> --- /dev/null
> +++ b/drivers/media/pci/tw5864/tw5864-video.c
> @@ -0,0 +1,1510 @@

<snip>

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
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

This line can be dropped, the core will fill in the capabilities field for you.

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

Add newline.

> +	*std = input->v4l2_std;
> +	return 0;
> +}
> +

<snip>

> +static int tw5864_video_input_init(struct tw5864_input *input, int video_nr)
> +{
> +	struct tw5864_dev *dev = input->root;
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
> +	input->vidq.io_modes = VB2_MMAP | VB2_READ;

Add VB2_DMABUF here.

> +	input->vidq.ops = &tw5864_video_qops;
> +	input->vidq.mem_ops = &vb2_dma_contig_memops;
> +	input->vidq.drv_priv = input;
> +	input->vidq.gfp_flags = 0;
> +	input->vidq.buf_struct_size = sizeof(struct tw5864_buf);
> +	input->vidq.lock = &input->lock;
> +	input->vidq.min_buffers_needed = 2;
> +	input->vidq.dev = &input->root->pci->dev;
> +	ret = vb2_queue_init(&input->vidq);
> +	if (ret)
> +		goto free_mutex;
> +
> +	input->vdev = tw5864_video_template;
> +	input->vdev.v4l2_dev = &input->root->v4l2_dev;
> +	input->vdev.lock = &input->lock;
> +	input->vdev.queue = &input->vidq;
> +	video_set_drvdata(&input->vdev, input);
> +
> +	/* Initialize the device control structures */
> +	v4l2_ctrl_handler_init(hdl, 6);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_CONTRAST, 0, 255, 1, 100);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
> +			  V4L2_CID_SATURATION, 0, 255, 1, 128);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops, V4L2_CID_HUE, -128, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops, V4L2_CID_MPEG_VIDEO_GOP_SIZE,
> +			  1, MAX_GOP_SIZE, 1, GOP_SIZE);
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
> +		goto free_v4l2_hdl;
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
> +		goto free_v4l2_hdl;
> +
> +	dev_info(&input->root->pci->dev, "Registered video device %s\n",
> +		 video_device_node_name(&input->vdev));
> +
> +	/*
> +	 * Set default video standard. Doesn't matter which, the detected value
> +	 * will be found out by VIDIOC_QUERYSTD handler.
> +	 */
> +	input->v4l2_std = V4L2_STD_NTSC_M;
> +	input->std = STD_NTSC;
> +
> +	tw_indir_writeb(TW5864_INDIR_VIN_E(video_nr), 0x07);
> +	/* to initiate auto format recognition */
> +	tw_indir_writeb(TW5864_INDIR_VIN_F(video_nr), 0xff);
> +
> +	return 0;
> +
> +free_v4l2_hdl:
> +	v4l2_ctrl_handler_free(hdl);
> +	vb2_queue_release(&input->vidq);
> +free_mutex:
> +	mutex_destroy(&input->lock);
> +
> +	return ret;
> +}

Regards,

	Hans
