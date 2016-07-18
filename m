Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44114 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbcGRJN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 05:13:27 -0400
Subject: Re: [PATCH v5] [media] pci: Add tw5864 driver
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
References: <20160713141218.12430-1-andrey.utkin@corp.bluecherry.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey_utkin@fastmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ac079f7d-5a42-64be-cfa4-878434b2c652@xs4all.nl>
Date: Mon, 18 Jul 2016 11:13:18 +0200
MIME-Version: 1.0
In-Reply-To: <20160713141218.12430-1-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

Just a few small comments, I'd say the next version should be ready for merging
in 4.9 (it's too late for 4.8).

On 07/13/2016 04:12 PM, Andrey Utkin wrote:
> Changes since v4:
>  - Decrease motion data buffer to bare minimum
>  - Fix all "checkpatch.pl --strict" notices (whitespace)
> 
> Changes since v3:
>  - updated copyright year
>  - Add VB2_DMABUF flag
>  - fix whitespace as suggested
>  - Move dma_sync_single_for_*() calls to tasklet function
>  - Reflow warning messages (add newlines)
>  - amend caps declaration as suggested
> 
> 
> News here!
> 
> Briefly: there's a new hope for fixing artifacts, but please consider accepting
> current submission.
> 
> One nice guy, a user of tw5864-based board, got in touch with me and
> shared different vendor-provided driver. It was obfuscated, but after trivial
> de-obfuscation it seems much clearer than what I had to tinker with during
> these long 1.5 years of development of this driver.
> https://github.com/bluecherrydvr/linux/blob/new_tw5864/drivers/media/pci/Isil5864/tw5864.c
> 
> I don't swear that I'll fix video artifacts soon, though. I will have time to
> tinker with this not sooner than August (and my free time is going to get very
> limited by then). And what our driver does is still very similar to what this
> new driver does, so the difference must be subtle, so please don't hold your
> breath.
> 
> 
> 
> 16:55:49j@zver /j/Sync/src/linux
>  $ ./scripts/checkpatch.pl --strict 0001-media-pci-Add-tw5864-driver.patch 
> total: 0 errors, 0 warnings, 0 checks, 4555 lines checked
> 
> 0001-media-pci-Add-tw5864-driver.patch has no obvious style problems and is ready for submission.
> [OK]
> 16:56:00j@zver /j/Sync/src/linux
>  $ make M=drivers/media/pci/tw5864 C=2
>   CHECK   drivers/media/pci/tw5864/tw5864-core.c
>   CC [M]  drivers/media/pci/tw5864/tw5864-core.o
>   CHECK   drivers/media/pci/tw5864/tw5864-video.c
>   CC [M]  drivers/media/pci/tw5864/tw5864-video.o
>   CHECK   drivers/media/pci/tw5864/tw5864-h264.c
>   CC [M]  drivers/media/pci/tw5864/tw5864-h264.o
>   CHECK   drivers/media/pci/tw5864/tw5864-util.c
>   CC [M]  drivers/media/pci/tw5864/tw5864-util.o
>   LD [M]  drivers/media/pci/tw5864/tw5864.o
>   Building modules, stage 2.
>   MODPOST 1 modules
>   LD [M]  drivers/media/pci/tw5864/tw5864.ko
> [OK]
> 
> 
> root@localhost:/src/linux# v4l2-compliance -d 6 -s
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
>         test DMABUF: Cannot test, specify --expbuf-device
> 
> 
> Total: 45, Succeeded: 45, Failed: 0, Warnings: 0
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
>  drivers/media/pci/tw5864/tw5864-core.c  |  361 ++++++
>  drivers/media/pci/tw5864/tw5864-h264.c  |  259 ++++
>  drivers/media/pci/tw5864/tw5864-reg.h   | 2133 +++++++++++++++++++++++++++++++
>  drivers/media/pci/tw5864/tw5864-util.c  |   37 +
>  drivers/media/pci/tw5864/tw5864-video.c | 1521 ++++++++++++++++++++++
>  drivers/media/pci/tw5864/tw5864.h       |  205 +++
>  11 files changed, 4540 insertions(+)
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
> index 0000000..d405dc5
> --- /dev/null
> +++ b/drivers/media/pci/tw5864/tw5864-core.c
> @@ -0,0 +1,361 @@
> +/*
> + *  TW5864 driver - core functions
> + *
> + *  Copyright (C) 2016 Bluecherry, LLC <maintainers@bluecherrydvr.com>
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
> +static const char * const artifacts_warning =
> +"BEWARE OF KNOWN ISSUES WITH VIDEO QUALITY\n"
> +"\n"
> +"This driver was developed by Bluecherry LLC by deducing behaviour of\n"
> +"original manufacturer's driver, from both source code and execution traces.\n"
> +"It is known that there are some artifacts on output video with this driver:\n"
> +" - on all known hardware samples: random pixels of wrong color (mostly\n"
> +"   white, red or blue) appearing and disappearing on sequences of P-frames;\n"
> +" - on some hardware samples (known with H.264 core version e006:2800):\n"
> +"   total madness on P-frames: blocks of wrong luminance; blocks of wrong\n"
> +"   colors \"creeping\" across the picture.\n"
> +"There is a workaround for both issues: avoid P-frames by setting GOP size\n"
> +"to 1. To do that, run this command on device files created by this driver:\n"
> +"\n"
> +"v4l2-ctl --device /dev/videoX --set-ctrl=video_gop_size=1\n"
> +"\n";
> +
> +static char *artifacts_warning_continued =
> +"These issues are not decoding errors; all produced H.264 streams are decoded\n"
> +"properly. Streams without P-frames don't have these artifacts so it's not\n"
> +"analog-to-digital conversion issues nor internal memory errors; we conclude\n"
> +"it's internal H.264 encoder issues.\n"
> +"We cannot even check the original driver's behaviour because it has never\n"
> +"worked properly at all in our development environment. So these issues may\n"
> +"be actually related to firmware or hardware. However it may be that there's\n"
> +"just some more register settings missing in the driver which would please\n"
> +"the hardware.\n"
> +"Manufacturer didn't help much on our inquiries, but feel free to disturb\n"
> +"again the support of Intersil (owner of former Techwell).\n"
> +"\n";

<snip>

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

That's too much kernel log spamming.

I propose that you turn those strings into a comment block at the start of the source
and here you just print:

	dev_info(&pci_dev->dev, "Note: there are known video quality issues. For details\n");
	dev_info(&pci_dev->dev, "see the comment in drivers/media/pci/tw5864/tw5864-core.c.\n");

That looks much better to me.

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

<snip>

> diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
> new file mode 100644
> index 0000000..dce0256
> --- /dev/null
> +++ b/drivers/media/pci/tw5864/tw5864-video.c

<snip>

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

In this case set *std_arg to V4L2_STD_UNKNOWN and just return 0. As per the QUERYSTD spec.

> +		return -EPERM;
> +	}
> +
> +	*std_arg = std;
> +	return 0;
> +}

Regards,

	Hans
