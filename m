Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36762 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcGMOM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 10:12:58 -0400
Received: by mail-lf0-f52.google.com with SMTP id q132so40359112lfe.3
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2016 07:12:42 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
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
	=?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Andrey Utkin <andrey_utkin@fastmail.com>
Subject: [PATCH v5] [media] pci: Add tw5864 driver
Date: Wed, 13 Jul 2016 17:12:18 +0300
Message-Id: <20160713141218.12430-1-andrey.utkin@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v4:
 - Decrease motion data buffer to bare minimum
 - Fix all "checkpatch.pl --strict" notices (whitespace)

Changes since v3:
 - updated copyright year
 - Add VB2_DMABUF flag
 - fix whitespace as suggested
 - Move dma_sync_single_for_*() calls to tasklet function
 - Reflow warning messages (add newlines)
 - amend caps declaration as suggested


News here!

Briefly: there's a new hope for fixing artifacts, but please consider accepting
current submission.

One nice guy, a user of tw5864-based board, got in touch with me and
shared different vendor-provided driver. It was obfuscated, but after trivial
de-obfuscation it seems much clearer than what I had to tinker with during
these long 1.5 years of development of this driver.
https://github.com/bluecherrydvr/linux/blob/new_tw5864/drivers/media/pci/Isil5864/tw5864.c

I don't swear that I'll fix video artifacts soon, though. I will have time to
tinker with this not sooner than August (and my free time is going to get very
limited by then). And what our driver does is still very similar to what this
new driver does, so the difference must be subtle, so please don't hold your
breath.



16:55:49j@zver /j/Sync/src/linux
 $ ./scripts/checkpatch.pl --strict 0001-media-pci-Add-tw5864-driver.patch 
total: 0 errors, 0 warnings, 0 checks, 4555 lines checked

0001-media-pci-Add-tw5864-driver.patch has no obvious style problems and is ready for submission.
[OK]
16:56:00j@zver /j/Sync/src/linux
 $ make M=drivers/media/pci/tw5864 C=2
  CHECK   drivers/media/pci/tw5864/tw5864-core.c
  CC [M]  drivers/media/pci/tw5864/tw5864-core.o
  CHECK   drivers/media/pci/tw5864/tw5864-video.c
  CC [M]  drivers/media/pci/tw5864/tw5864-video.o
  CHECK   drivers/media/pci/tw5864/tw5864-h264.c
  CC [M]  drivers/media/pci/tw5864/tw5864-h264.o
  CHECK   drivers/media/pci/tw5864/tw5864-util.c
  CC [M]  drivers/media/pci/tw5864/tw5864-util.o
  LD [M]  drivers/media/pci/tw5864/tw5864.o
  Building modules, stage 2.
  MODPOST 1 modules
  LD [M]  drivers/media/pci/tw5864/tw5864.ko
[OK]


root@localhost:/src/linux# v4l2-compliance -d 6 -s
v4l2-compliance SHA   : 5e74f6a15aa14c01d8319e086d98f33d96a6a04d

Driver Info:
        Driver name   : tw5864
        Card type     : TW5864 Encoder 2
        Bus info      : PCI:0000:06:05.0
        Driver version: 4.7.0
        Capabilities  : 0x85200001
                Video Capture
                Read/Write
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x05200001
                Video Capture
                Read/Write
                Streaming
                Extended Pix Format

Compliance test for device /dev/video6 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 11 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK (Not Supported)
                test Composing: OK (Not Supported)
                test Scaling: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:

Streaming ioctls:
        test read/write: OK
        test MMAP: OK                                     
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device


Total: 45, Succeeded: 45, Failed: 0, Warnings: 0

---8<---

Support for boards based on Techwell TW5864 chip which provides
multichannel video & audio grabbing and encoding (H.264, MJPEG,
ADPCM G.726).

This submission implements only H.264 encoding of all channels at D1
resolution.

Thanks to Mark Thompson <sw@jkqxz.net> for help, and for contribution of
H.264 startcode emulation prevention code.

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 MAINTAINERS                             |    8 +
 drivers/media/pci/Kconfig               |    1 +
 drivers/media/pci/Makefile              |    1 +
 drivers/media/pci/tw5864/Kconfig        |   11 +
 drivers/media/pci/tw5864/Makefile       |    3 +
 drivers/media/pci/tw5864/tw5864-core.c  |  361 ++++++
 drivers/media/pci/tw5864/tw5864-h264.c  |  259 ++++
 drivers/media/pci/tw5864/tw5864-reg.h   | 2133 +++++++++++++++++++++++++++++++
 drivers/media/pci/tw5864/tw5864-util.c  |   37 +
 drivers/media/pci/tw5864/tw5864-video.c | 1521 ++++++++++++++++++++++
 drivers/media/pci/tw5864/tw5864.h       |  205 +++
 11 files changed, 4540 insertions(+)
 create mode 100644 drivers/media/pci/tw5864/Kconfig
 create mode 100644 drivers/media/pci/tw5864/Makefile
 create mode 100644 drivers/media/pci/tw5864/tw5864-core.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-h264.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-reg.h
 create mode 100644 drivers/media/pci/tw5864/tw5864-util.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-video.c
 create mode 100644 drivers/media/pci/tw5864/tw5864.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a975b8e..46daa99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11598,6 +11598,14 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/usb/tm6000/
 
+TW5864 VIDEO4LINUX DRIVER
+M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
+M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
+M:	Andrey Utkin <andrey_utkin@fastmail.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+F:	drivers/media/pci/tw5864/
+
 TW68 VIDEO4LINUX DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 4f6467f..da28e68 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -13,6 +13,7 @@ if MEDIA_CAMERA_SUPPORT
 source "drivers/media/pci/meye/Kconfig"
 source "drivers/media/pci/solo6x10/Kconfig"
 source "drivers/media/pci/sta2x11/Kconfig"
+source "drivers/media/pci/tw5864/Kconfig"
 source "drivers/media/pci/tw68/Kconfig"
 source "drivers/media/pci/tw686x/Kconfig"
 source "drivers/media/pci/zoran/Kconfig"
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 2e54c36..a7e8af0 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_VIDEO_MEYE) += meye/
 obj-$(CONFIG_STA2X11_VIP) += sta2x11/
 obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
 obj-$(CONFIG_VIDEO_COBALT) += cobalt/
+obj-$(CONFIG_VIDEO_TW5864) += tw5864/
diff --git a/drivers/media/pci/tw5864/Kconfig b/drivers/media/pci/tw5864/Kconfig
new file mode 100644
index 0000000..760fb11
--- /dev/null
+++ b/drivers/media/pci/tw5864/Kconfig
@@ -0,0 +1,11 @@
+config VIDEO_TW5864
+	tristate "Techwell TW5864 video/audio grabber and encoder"
+	depends on VIDEO_DEV && PCI && VIDEO_V4L2
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  Support for boards based on Techwell TW5864 chip which provides
+	  multichannel video & audio grabbing and encoding (H.264, MJPEG,
+	  ADPCM G.726).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tw5864.
diff --git a/drivers/media/pci/tw5864/Makefile b/drivers/media/pci/tw5864/Makefile
new file mode 100644
index 0000000..4fc8b3b
--- /dev/null
+++ b/drivers/media/pci/tw5864/Makefile
@@ -0,0 +1,3 @@
+tw5864-objs := tw5864-core.o tw5864-video.o tw5864-h264.o tw5864-util.o
+
+obj-$(CONFIG_VIDEO_TW5864) += tw5864.o
diff --git a/drivers/media/pci/tw5864/tw5864-core.c b/drivers/media/pci/tw5864/tw5864-core.c
new file mode 100644
index 0000000..d405dc5
--- /dev/null
+++ b/drivers/media/pci/tw5864/tw5864-core.c
@@ -0,0 +1,361 @@
+/*
+ *  TW5864 driver - core functions
+ *
+ *  Copyright (C) 2016 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/kmod.h>
+#include <linux/sound.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/pm.h>
+#include <linux/pci_ids.h>
+#include <linux/jiffies.h>
+#include <asm/dma.h>
+#include <media/v4l2-dev.h>
+
+#include "tw5864.h"
+#include "tw5864-reg.h"
+
+MODULE_DESCRIPTION("V4L2 driver module for tw5864-based multimedia capture & encoding devices");
+MODULE_AUTHOR("Bluecherry Maintainers <maintainers@bluecherrydvr.com>");
+MODULE_AUTHOR("Andrey Utkin <andrey.utkin@corp.bluecherry.net>");
+MODULE_LICENSE("GPL");
+
+static const char * const artifacts_warning =
+"BEWARE OF KNOWN ISSUES WITH VIDEO QUALITY\n"
+"\n"
+"This driver was developed by Bluecherry LLC by deducing behaviour of\n"
+"original manufacturer's driver, from both source code and execution traces.\n"
+"It is known that there are some artifacts on output video with this driver:\n"
+" - on all known hardware samples: random pixels of wrong color (mostly\n"
+"   white, red or blue) appearing and disappearing on sequences of P-frames;\n"
+" - on some hardware samples (known with H.264 core version e006:2800):\n"
+"   total madness on P-frames: blocks of wrong luminance; blocks of wrong\n"
+"   colors \"creeping\" across the picture.\n"
+"There is a workaround for both issues: avoid P-frames by setting GOP size\n"
+"to 1. To do that, run this command on device files created by this driver:\n"
+"\n"
+"v4l2-ctl --device /dev/videoX --set-ctrl=video_gop_size=1\n"
+"\n";
+
+static char *artifacts_warning_continued =
+"These issues are not decoding errors; all produced H.264 streams are decoded\n"
+"properly. Streams without P-frames don't have these artifacts so it's not\n"
+"analog-to-digital conversion issues nor internal memory errors; we conclude\n"
+"it's internal H.264 encoder issues.\n"
+"We cannot even check the original driver's behaviour because it has never\n"
+"worked properly at all in our development environment. So these issues may\n"
+"be actually related to firmware or hardware. However it may be that there's\n"
+"just some more register settings missing in the driver which would please\n"
+"the hardware.\n"
+"Manufacturer didn't help much on our inquiries, but feel free to disturb\n"
+"again the support of Intersil (owner of former Techwell).\n"
+"\n";
+
+/* take first free /dev/videoX indexes by default */
+static unsigned int video_nr[] = {[0 ... (TW5864_INPUTS - 1)] = -1 };
+
+module_param_array(video_nr, int, NULL, 0444);
+MODULE_PARM_DESC(video_nr, "video devices numbers array");
+
+/*
+ * Please add any new PCI IDs to: http://pci-ids.ucw.cz.  This keeps
+ * the PCI ID database up to date.  Note that the entries must be
+ * added under vendor 0x1797 (Techwell Inc.) as subsystem IDs.
+ */
+static const struct pci_device_id tw5864_pci_tbl[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_TECHWELL_5864)},
+	{0,}
+};
+
+void tw5864_irqmask_apply(struct tw5864_dev *dev)
+{
+	tw_writel(TW5864_INTR_ENABLE_L, dev->irqmask & 0xffff);
+	tw_writel(TW5864_INTR_ENABLE_H, (dev->irqmask >> 16));
+}
+
+static void tw5864_interrupts_disable(struct tw5864_dev *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->slock, flags);
+	dev->irqmask = 0;
+	tw5864_irqmask_apply(dev);
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+static void tw5864_timer_isr(struct tw5864_dev *dev);
+static void tw5864_h264_isr(struct tw5864_dev *dev);
+
+static irqreturn_t tw5864_isr(int irq, void *dev_id)
+{
+	struct tw5864_dev *dev = dev_id;
+	u32 status;
+
+	status = tw_readl(TW5864_INTR_STATUS_L) |
+		tw_readl(TW5864_INTR_STATUS_H) << 16;
+	if (!status)
+		return IRQ_NONE;
+
+	tw_writel(TW5864_INTR_CLR_L, 0xffff);
+	tw_writel(TW5864_INTR_CLR_H, 0xffff);
+
+	if (status & TW5864_INTR_VLC_DONE)
+		tw5864_h264_isr(dev);
+
+	if (status & TW5864_INTR_TIMER)
+		tw5864_timer_isr(dev);
+
+	if (!(status & (TW5864_INTR_TIMER | TW5864_INTR_VLC_DONE))) {
+		dev_dbg(&dev->pci->dev, "Unknown interrupt, status 0x%08X\n",
+			status);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void tw5864_h264_isr(struct tw5864_dev *dev)
+{
+	int channel = tw_readl(TW5864_DSP) & TW5864_DSP_ENC_CHN;
+	struct tw5864_input *input = &dev->inputs[channel];
+	int cur_frame_index, next_frame_index;
+	struct tw5864_h264_frame *cur_frame, *next_frame;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->slock, flags);
+
+	cur_frame_index = dev->h264_buf_w_index;
+	next_frame_index = (cur_frame_index + 1) % H264_BUF_CNT;
+	cur_frame = &dev->h264_buf[cur_frame_index];
+	next_frame = &dev->h264_buf[next_frame_index];
+
+	if (next_frame_index != dev->h264_buf_r_index) {
+		cur_frame->vlc_len = tw_readl(TW5864_VLC_LENGTH) << 2;
+		cur_frame->checksum = tw_readl(TW5864_VLC_CRC_REG);
+		cur_frame->input = input;
+		cur_frame->timestamp = ktime_get_ns();
+		cur_frame->seqno = input->frame_seqno;
+		cur_frame->gop_seqno = input->frame_gop_seqno;
+
+		dev->h264_buf_w_index = next_frame_index;
+		tasklet_schedule(&dev->tasklet);
+
+		cur_frame = next_frame;
+
+		spin_lock_irqsave(&input->slock, flags);
+		input->frame_seqno++;
+		input->frame_gop_seqno++;
+		if (input->frame_gop_seqno >= input->gop)
+			input->frame_gop_seqno = 0;
+		spin_unlock_irqrestore(&input->slock, flags);
+	} else {
+		dev_err(&dev->pci->dev,
+			"Skipped frame on input %d because all buffers busy\n",
+			channel);
+	}
+
+	dev->encoder_busy = 0;
+
+	spin_unlock_irqrestore(&dev->slock, flags);
+
+	tw_writel(TW5864_VLC_STREAM_BASE_ADDR, cur_frame->vlc.dma_addr);
+	tw_writel(TW5864_MV_STREAM_BASE_ADDR, cur_frame->mv.dma_addr);
+
+	/* Additional ack for this interrupt */
+	tw_writel(TW5864_VLC_DSP_INTR, 0x00000001);
+	tw_writel(TW5864_PCI_INTR_STATUS, TW5864_VLC_DONE_INTR);
+}
+
+static void tw5864_input_deadline_update(struct tw5864_input *input)
+{
+	input->new_frame_deadline = jiffies + msecs_to_jiffies(1000);
+}
+
+static void tw5864_timer_isr(struct tw5864_dev *dev)
+{
+	unsigned long flags;
+	int i;
+	int encoder_busy;
+
+	/* Additional ack for this interrupt */
+	tw_writel(TW5864_PCI_INTR_STATUS, TW5864_TIMER_INTR);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	encoder_busy = dev->encoder_busy;
+	spin_unlock_irqrestore(&dev->slock, flags);
+
+	if (encoder_busy)
+		return;
+
+	/*
+	 * Traversing inputs in round-robin fashion, starting from next to the
+	 * last processed one
+	 */
+	for (i = 0; i < TW5864_INPUTS; i++) {
+		int next_input = (i + dev->next_input) % TW5864_INPUTS;
+		struct tw5864_input *input = &dev->inputs[next_input];
+		int raw_buf_id; /* id of internal buf with last raw frame */
+
+		spin_lock_irqsave(&input->slock, flags);
+		if (!input->enabled)
+			goto next;
+
+		/* Check if new raw frame is available */
+		raw_buf_id = tw_mask_shift_readl(TW5864_SENIF_ORG_FRM_PTR1, 0x3,
+						 2 * input->nr);
+
+		if (input->buf_id != raw_buf_id) {
+			input->buf_id = raw_buf_id;
+			tw5864_input_deadline_update(input);
+			spin_unlock_irqrestore(&input->slock, flags);
+
+			spin_lock_irqsave(&dev->slock, flags);
+			dev->encoder_busy = 1;
+			dev->next_input = (next_input + 1) % TW5864_INPUTS;
+			spin_unlock_irqrestore(&dev->slock, flags);
+
+			tw5864_request_encoded_frame(input);
+			break;
+		}
+
+		/* No new raw frame; check if channel is stuck */
+		if (time_is_after_jiffies(input->new_frame_deadline)) {
+			/* If stuck, request new raw frames again */
+			tw_mask_shift_writel(TW5864_ENC_BUF_PTR_REC1, 0x3,
+					     2 * input->nr, input->buf_id + 3);
+			tw5864_input_deadline_update(input);
+		}
+next:
+		spin_unlock_irqrestore(&input->slock, flags);
+	}
+}
+
+static int tw5864_initdev(struct pci_dev *pci_dev,
+			  const struct pci_device_id *pci_id)
+{
+	struct tw5864_dev *dev;
+	int err;
+
+	dev = devm_kzalloc(&pci_dev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	snprintf(dev->name, sizeof(dev->name), "tw5864:%s", pci_name(pci_dev));
+
+	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
+	if (err)
+		return err;
+
+	/* pci init */
+	dev->pci = pci_dev;
+	err = pci_enable_device(pci_dev);
+	if (err) {
+		dev_err(&dev->pci->dev, "pci_enable_device() failed\n");
+		goto unreg_v4l2;
+	}
+
+	pci_set_master(pci_dev);
+
+	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	if (err) {
+		dev_err(&dev->pci->dev, "32 bit PCI DMA is not supported\n");
+		goto disable_pci;
+	}
+
+	/* get mmio */
+	err = pci_request_regions(pci_dev, dev->name);
+	if (err) {
+		dev_err(&dev->pci->dev, "Cannot request regions for MMIO\n");
+		goto disable_pci;
+	}
+	dev->mmio = pci_ioremap_bar(pci_dev, 0);
+	if (!dev->mmio) {
+		err = -EIO;
+		dev_err(&dev->pci->dev, "can't ioremap() MMIO memory\n");
+		goto release_mmio;
+	}
+
+	spin_lock_init(&dev->slock);
+
+	dev_info(&pci_dev->dev, "TW5864 hardware version: %04x\n",
+		 tw_readl(TW5864_HW_VERSION));
+	dev_info(&pci_dev->dev, "TW5864 H.264 core version: %04x:%04x\n",
+		 tw_readl(TW5864_H264REV),
+		 tw_readl(TW5864_UNDECLARED_H264REV_PART2));
+
+	err = tw5864_video_init(dev, video_nr);
+	if (err)
+		goto unmap_mmio;
+
+	/* get irq */
+	err = devm_request_irq(&pci_dev->dev, pci_dev->irq, tw5864_isr,
+			       IRQF_SHARED, "tw5864", dev);
+	if (err < 0) {
+		dev_err(&dev->pci->dev, "can't get IRQ %d\n", pci_dev->irq);
+		goto fini_video;
+	}
+
+	dev_warn(&pci_dev->dev, "%s", artifacts_warning);
+	dev_warn(&pci_dev->dev, "%s", artifacts_warning_continued);
+
+	return 0;
+
+fini_video:
+	tw5864_video_fini(dev);
+unmap_mmio:
+	iounmap(dev->mmio);
+release_mmio:
+	pci_release_regions(pci_dev);
+disable_pci:
+	pci_disable_device(pci_dev);
+unreg_v4l2:
+	v4l2_device_unregister(&dev->v4l2_dev);
+	return err;
+}
+
+static void tw5864_finidev(struct pci_dev *pci_dev)
+{
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
+	struct tw5864_dev *dev =
+		container_of(v4l2_dev, struct tw5864_dev, v4l2_dev);
+
+	/* shutdown subsystems */
+	tw5864_interrupts_disable(dev);
+
+	/* unregister */
+	tw5864_video_fini(dev);
+
+	/* release resources */
+	iounmap(dev->mmio);
+	release_mem_region(pci_resource_start(pci_dev, 0),
+			   pci_resource_len(pci_dev, 0));
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+	devm_kfree(&pci_dev->dev, dev);
+}
+
+static struct pci_driver tw5864_pci_driver = {
+	.name = "tw5864",
+	.id_table = tw5864_pci_tbl,
+	.probe = tw5864_initdev,
+	.remove = tw5864_finidev,
+};
+
+module_pci_driver(tw5864_pci_driver);
diff --git a/drivers/media/pci/tw5864/tw5864-h264.c b/drivers/media/pci/tw5864/tw5864-h264.c
new file mode 100644
index 0000000..330d200
--- /dev/null
+++ b/drivers/media/pci/tw5864/tw5864-h264.c
@@ -0,0 +1,259 @@
+/*
+ *  TW5864 driver - H.264 headers generation functions
+ *
+ *  Copyright (C) 2016 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/log2.h>
+
+#include "tw5864.h"
+
+static u8 marker[] = { 0x00, 0x00, 0x00, 0x01 };
+
+/*
+ * Exponential-Golomb coding functions
+ *
+ * These functions are used for generation of H.264 bitstream headers.
+ *
+ * This code is derived from tw5864 reference driver by manufacturers, which
+ * itself apparently was derived from x264 project.
+ */
+
+/* Bitstream writing context */
+struct bs {
+	u8 *buf; /* pointer to buffer beginning */
+	u8 *buf_end; /* pointer to buffer end */
+	u8 *ptr; /* pointer to current byte in buffer */
+	unsigned int bits_left; /* number of available bits in current byte */
+};
+
+static void bs_init(struct bs *s, void *buf, int size)
+{
+	s->buf = buf;
+	s->ptr = buf;
+	s->buf_end = s->ptr + size;
+	s->bits_left = 8;
+}
+
+static int bs_len(struct bs *s)
+{
+	return s->ptr - s->buf;
+}
+
+static void bs_write(struct bs *s, int count, u32 bits)
+{
+	if (s->ptr >= s->buf_end - 4)
+		return;
+	while (count > 0) {
+		if (count < 32)
+			bits &= (1 << count) - 1;
+		if (count < s->bits_left) {
+			*s->ptr = (*s->ptr << count) | bits;
+			s->bits_left -= count;
+			break;
+		}
+		*s->ptr = (*s->ptr << s->bits_left) |
+			(bits >> (count - s->bits_left));
+		count -= s->bits_left;
+		s->ptr++;
+		s->bits_left = 8;
+	}
+}
+
+static void bs_write1(struct bs *s, u32 bit)
+{
+	if (s->ptr < s->buf_end) {
+		*s->ptr <<= 1;
+		*s->ptr |= bit;
+		s->bits_left--;
+		if (s->bits_left == 0) {
+			s->ptr++;
+			s->bits_left = 8;
+		}
+	}
+}
+
+static void bs_write_ue(struct bs *s, u32 val)
+{
+	if (val == 0) {
+		bs_write1(s, 1);
+	} else {
+		val++;
+		bs_write(s, 2 * fls(val) - 1, val);
+	}
+}
+
+static void bs_write_se(struct bs *s, int val)
+{
+	bs_write_ue(s, val <= 0 ? -val * 2 : val * 2 - 1);
+}
+
+static void bs_rbsp_trailing(struct bs *s)
+{
+	bs_write1(s, 1);
+	if (s->bits_left != 8)
+		bs_write(s, s->bits_left, 0x00);
+}
+
+/* H.264 headers generation functions */
+
+static int tw5864_h264_gen_sps_rbsp(u8 *buf, size_t size, int width, int height)
+{
+	struct bs bs, *s;
+
+	s = &bs;
+	bs_init(s, buf, size);
+	bs_write(s, 8, 0x42); /* profile_idc, baseline */
+	bs_write(s, 1, 1); /* constraint_set0_flag */
+	bs_write(s, 1, 1); /* constraint_set1_flag */
+	bs_write(s, 1, 0); /* constraint_set2_flag */
+	bs_write(s, 5, 0); /* reserved_zero_5bits */
+	bs_write(s, 8, 0x1e); /* level_idc */
+	bs_write_ue(s, 0); /* seq_parameter_set_id */
+	bs_write_ue(s, ilog2(MAX_GOP_SIZE) - 4); /* log2_max_frame_num_minus4 */
+	bs_write_ue(s, 0); /* pic_order_cnt_type */
+	/* log2_max_pic_order_cnt_lsb_minus4 */
+	bs_write_ue(s, ilog2(MAX_GOP_SIZE) - 4);
+	bs_write_ue(s, 1); /* num_ref_frames */
+	bs_write(s, 1, 0); /* gaps_in_frame_num_value_allowed_flag */
+	bs_write_ue(s, width / 16 - 1); /* pic_width_in_mbs_minus1 */
+	bs_write_ue(s, height / 16 - 1); /* pic_height_in_map_units_minus1 */
+	bs_write(s, 1, 1); /* frame_mbs_only_flag */
+	bs_write(s, 1, 0); /* direct_8x8_inference_flag */
+	bs_write(s, 1, 0); /* frame_cropping_flag */
+	bs_write(s, 1, 0); /* vui_parameters_present_flag */
+	bs_rbsp_trailing(s);
+	return bs_len(s);
+}
+
+static int tw5864_h264_gen_pps_rbsp(u8 *buf, size_t size, int qp)
+{
+	struct bs bs, *s;
+
+	s = &bs;
+	bs_init(s, buf, size);
+	bs_write_ue(s, 0); /* pic_parameter_set_id */
+	bs_write_ue(s, 0); /* seq_parameter_set_id */
+	bs_write(s, 1, 0); /* entropy_coding_mode_flag */
+	bs_write(s, 1, 0); /* pic_order_present_flag */
+	bs_write_ue(s, 0); /* num_slice_groups_minus1 */
+	bs_write_ue(s, 0); /* i_num_ref_idx_l0_active_minus1 */
+	bs_write_ue(s, 0); /* i_num_ref_idx_l1_active_minus1 */
+	bs_write(s, 1, 0); /* weighted_pred_flag */
+	bs_write(s, 2, 0); /* weighted_bipred_idc */
+	bs_write_se(s, qp - 26); /* pic_init_qp_minus26 */
+	bs_write_se(s, qp - 26); /* pic_init_qs_minus26 */
+	bs_write_se(s, 0); /* chroma_qp_index_offset */
+	bs_write(s, 1, 0); /* deblocking_filter_control_present_flag */
+	bs_write(s, 1, 0); /* constrained_intra_pred_flag */
+	bs_write(s, 1, 0); /* redundant_pic_cnt_present_flag */
+	bs_rbsp_trailing(s);
+	return bs_len(s);
+}
+
+static int tw5864_h264_gen_slice_head(u8 *buf, size_t size,
+				      unsigned int idr_pic_id,
+				      unsigned int frame_gop_seqno,
+				      int *tail_nb_bits, u8 *tail)
+{
+	struct bs bs, *s;
+	int is_i_frame = frame_gop_seqno == 0;
+
+	s = &bs;
+	bs_init(s, buf, size);
+	bs_write_ue(s, 0); /* first_mb_in_slice */
+	bs_write_ue(s, is_i_frame ? 2 : 5); /* slice_type - I or P */
+	bs_write_ue(s, 0); /* pic_parameter_set_id */
+	bs_write(s, ilog2(MAX_GOP_SIZE), frame_gop_seqno); /* frame_num */
+	if (is_i_frame)
+		bs_write_ue(s, idr_pic_id);
+
+	/* pic_order_cnt_lsb */
+	bs_write(s, ilog2(MAX_GOP_SIZE), frame_gop_seqno);
+
+	if (is_i_frame) {
+		bs_write1(s, 0); /* no_output_of_prior_pics_flag */
+		bs_write1(s, 0); /* long_term_reference_flag */
+	} else {
+		bs_write1(s, 0); /* num_ref_idx_active_override_flag */
+		bs_write1(s, 0); /* ref_pic_list_reordering_flag_l0 */
+		bs_write1(s, 0); /* adaptive_ref_pic_marking_mode_flag */
+	}
+
+	bs_write_se(s, 0); /* slice_qp_delta */
+
+	if (s->bits_left != 8) {
+		*tail = ((s->ptr[0]) << s->bits_left);
+		*tail_nb_bits = 8 - s->bits_left;
+	} else {
+		*tail = 0;
+		*tail_nb_bits = 0;
+	}
+
+	return bs_len(s);
+}
+
+void tw5864_h264_put_stream_header(u8 **buf, size_t *space_left, int qp,
+				   int width, int height)
+{
+	int nal_len;
+
+	/* SPS */
+	memcpy(*buf, marker, sizeof(marker));
+	*buf += 4;
+	*space_left -= 4;
+
+	**buf = 0x67; /* SPS NAL header */
+	*buf += 1;
+	*space_left -= 1;
+
+	nal_len = tw5864_h264_gen_sps_rbsp(*buf, *space_left, width, height);
+	*buf += nal_len;
+	*space_left -= nal_len;
+
+	/* PPS */
+	memcpy(*buf, marker, sizeof(marker));
+	*buf += 4;
+	*space_left -= 4;
+
+	**buf = 0x68; /* PPS NAL header */
+	*buf += 1;
+	*space_left -= 1;
+
+	nal_len = tw5864_h264_gen_pps_rbsp(*buf, *space_left, qp);
+	*buf += nal_len;
+	*space_left -= nal_len;
+}
+
+void tw5864_h264_put_slice_header(u8 **buf, size_t *space_left,
+				  unsigned int idr_pic_id,
+				  unsigned int frame_gop_seqno,
+				  int *tail_nb_bits, u8 *tail)
+{
+	int nal_len;
+
+	memcpy(*buf, marker, sizeof(marker));
+	*buf += 4;
+	*space_left -= 4;
+
+	/* Frame NAL header */
+	**buf = (frame_gop_seqno == 0) ? 0x25 : 0x21;
+	*buf += 1;
+	*space_left -= 1;
+
+	nal_len = tw5864_h264_gen_slice_head(*buf, *space_left, idr_pic_id,
+					     frame_gop_seqno, tail_nb_bits,
+					     tail);
+	*buf += nal_len;
+	*space_left -= nal_len;
+}
diff --git a/drivers/media/pci/tw5864/tw5864-reg.h b/drivers/media/pci/tw5864/tw5864-reg.h
new file mode 100644
index 0000000..92a1b07
--- /dev/null
+++ b/drivers/media/pci/tw5864/tw5864-reg.h
@@ -0,0 +1,2133 @@
+/*
+ *  TW5864 driver - registers description
+ *
+ *  Copyright (C) 2016 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+/* According to TW5864_datasheet_0.6d.pdf, tw5864b1-ds.pdf */
+
+/* Register Description - Direct Map Space */
+/* 0x0000 ~ 0x1ffc - H264 Register Map */
+/* [15:0] The Version register for H264 core (Read Only) */
+#define TW5864_H264REV 0x0000
+
+#define TW5864_EMU 0x0004
+/* Define controls in register TW5864_EMU */
+/* DDR controller enabled */
+#define TW5864_EMU_EN_DDR BIT(0)
+/* Enable bit for Inter module */
+#define TW5864_EMU_EN_ME BIT(1)
+/* Enable bit for Sensor Interface module */
+#define TW5864_EMU_EN_SEN BIT(2)
+/* Enable bit for Host Burst Access */
+#define TW5864_EMU_EN_BHOST BIT(3)
+/* Enable bit for Loop Filter module */
+#define TW5864_EMU_EN_LPF BIT(4)
+/* Enable bit for PLBK module */
+#define TW5864_EMU_EN_PLBK BIT(5)
+/*
+ * Video Frame mapping in DDR
+ * 00 CIF
+ * 01 D1
+ * 10 Reserved
+ * 11 Reserved
+ *
+ */
+#define TW5864_DSP_FRAME_TYPE (3 << 6)
+#define TW5864_DSP_FRAME_TYPE_D1 BIT(6)
+
+#define TW5864_UNDECLARED_H264REV_PART2 0x0008
+
+#define TW5864_SLICE 0x000c
+/* Define controls in register TW5864_SLICE */
+/* VLC Slice end flag */
+#define TW5864_VLC_SLICE_END BIT(0)
+/* Master Slice End Flag */
+#define TW5864_MAS_SLICE_END BIT(4)
+/* Host to start a new slice Address */
+#define TW5864_START_NSLICE BIT(15)
+
+/*
+ * [15:0] Two bit for each channel (channel 0 ~ 7). Each two bits are the buffer
+ * pointer for the last encoded frame of the corresponding channel.
+ */
+#define TW5864_ENC_BUF_PTR_REC1 0x0010
+
+/* [5:0] DSP_MB_QP and [15:10] DSP_LPF_OFFSET */
+#define TW5864_DSP_QP 0x0018
+/* Define controls in register TW5864_DSP_QP */
+/* [5:0] H264 QP Value for codec */
+#define TW5864_DSP_MB_QP 0x003f
+/*
+ * [15:10] H264 LPF_OFFSET Address
+ * (Default 0)
+ */
+#define TW5864_DSP_LPF_OFFSET 0xfc00
+
+#define TW5864_DSP_CODEC 0x001c
+/* Define controls in register TW5864_DSP_CODEC */
+/*
+ * 0: Encode (TW5864 Default)
+ * 1: Decode
+ */
+#define TW5864_DSP_CODEC_MODE BIT(0)
+/*
+ * 0->3 4 VLC data buffer in DDR (1M each)
+ * 0->7 8 VLC data buffer in DDR (512k each)
+ */
+#define TW5864_VLC_BUF_ID (7 << 2)
+/*
+ * 0 4CIF in 1 MB
+ * 1 1CIF in 1 MB
+ */
+#define TW5864_CIF_MAP_MD BIT(6)
+/*
+ * 0 2 falf D1 in 1 MB
+ * 1 1 half D1 in 1 MB
+ */
+#define TW5864_HD1_MAP_MD BIT(7)
+/* VLC Stream valid */
+#define TW5864_VLC_VLD BIT(8)
+/* MV Vector Valid */
+#define TW5864_MV_VECT_VLD BIT(9)
+/* MV Flag Valid */
+#define TW5864_MV_FLAG_VLD BIT(10)
+
+#define TW5864_DSP_SEN 0x0020
+/* Define controls in register TW5864_DSP_SEN */
+/* Org Buffer Base for Luma (default 0) */
+#define TW5864_DSP_SEN_PIC_LU 0x000f
+/* Org Buffer Base for Chroma (default 4) */
+#define TW5864_DSP_SEN_PIC_CHM 0x00f0
+/* Maximum Number of Buffers (default 4) */
+#define TW5864_DSP_SEN_PIC_MAX 0x0700
+/*
+ * Original Frame D1 or HD1 switch
+ * (Default 0)
+ */
+#define TW5864_DSP_SEN_HFULL 0x1000
+
+#define TW5864_DSP_REF_PIC 0x0024
+/* Define controls in register TW5864_DSP_REF_PIC */
+/* Ref Buffer Base for Luma (default 0) */
+#define TW5864_DSP_REF_PIC_LU 0x000f
+/* Ref Buffer Base for Chroma (default 4) */
+#define TW5864_DSP_REF_PIC_CHM 0x00f0
+/* Maximum Number of Buffers (default 4) */
+#define TW5864_DSP_REF_PIC_MAX 0x0700
+
+/* [15:0] SEN_EN_CH[n] SENIF original frame capture enable for each channel */
+#define TW5864_SEN_EN_CH 0x0028
+
+#define TW5864_DSP 0x002c
+/* Define controls in register TW5864_DSP */
+/* The ID for channel selected for encoding operation */
+#define TW5864_DSP_ENC_CHN 0x000f
+/* See DSP_MB_DELAY below */
+#define TW5864_DSP_MB_WAIT 0x0010
+/*
+ * DSP Chroma Switch
+ * 0 DDRB
+ * 1 DDRA
+ */
+#define TW5864_DSP_CHROM_SW 0x0020
+/* VLC Flow Control: 1 for enable */
+#define TW5864_DSP_FLW_CNTL 0x0040
+/*
+ * If DSP_MB_WAIT == 0, MB delay is DSP_MB_DELAY * 16
+ * If DSP_MB_DELAY == 1, MB delay is DSP_MB_DELAY * 128
+ */
+#define TW5864_DSP_MB_DELAY 0x0f00
+
+#define TW5864_DDR 0x0030
+/* Define controls in register TW5864_DDR */
+/* DDR Single Access Page Number */
+#define TW5864_DDR_PAGE_CNTL 0x00ff
+/* DDR-DPR Burst Read Enable */
+#define TW5864_DDR_BRST_EN BIT(13)
+/*
+ * DDR A/B Select as HOST access
+ * 0 Select DDRA
+ * 1 Select DDRB
+ */
+#define TW5864_DDR_AB_SEL BIT(14)
+/*
+ * DDR Access Mode Select
+ * 0 Single R/W Access (Host <-> DDR)
+ * 1 Burst R/W Access (Host <-> DPR)
+ */
+#define TW5864_DDR_MODE BIT(15)
+
+/* The original frame capture pointer. Two bits for each channel */
+/* SENIF_ORG_FRM_PTR [15:0] */
+#define TW5864_SENIF_ORG_FRM_PTR1 0x0038
+/* SENIF_ORG_FRM_PTR [31:16] */
+#define TW5864_SENIF_ORG_FRM_PTR2 0x003c
+
+#define TW5864_DSP_SEN_MODE 0x0040
+/* Define controls in register TW5864_DSP_SEN_MODE */
+#define TW5864_DSP_SEN_MODE_CH0 0x000f
+#define TW5864_DSP_SEN_MODE_CH1 0x00f0
+
+/*
+ * [15:0]: ENC_BUF_PTR_REC[31:16] Two bit for each channel (channel 8 ~ 15).
+ * Each two bits are the buffer pointer for the last encoded frame of a channel
+ */
+#define TW5864_ENC_BUF_PTR_REC2 0x004c
+
+/* Current MV Flag Status Pointer for Channel n. (Read only) */
+/*
+ * [1:0] CH0_MV_PTR, ..., [15:14] CH7_MV_PTR
+ */
+#define TW5864_CH_MV_PTR1 0x0060
+/*
+ * [1:0] CH8_MV_PTR, ..., [15:14] CH15_MV_PTR
+ */
+#define TW5864_CH_MV_PTR2 0x0064
+
+/*
+ * [15:0] Reset Current MV Flag Status Pointer for Channel n (one bit each)
+ */
+#define TW5864_RST_MV_PTR 0x0068
+#define TW5864_INTERLACING 0x0200
+/* Define controls in register TW5864_INTERLACING */
+/*
+ * Inter_Mode Start. 2-nd bit? A guess. Missing in datasheet. Without this bit
+ * set, the output video is interlaced (stripy).
+ */
+#define TW5864_DSP_INTER_ST BIT(1)
+/* Deinterlacer Enable */
+#define TW5864_DI_EN BIT(2)
+/*
+ * De-interlacer Mode
+ * 1 Shuffled frame
+ * 0 Normal Un-Shuffled Frame
+ */
+#define TW5864_DI_MD BIT(3)
+/*
+ * Down scale original frame in X direction
+ * 11: Un-used
+ * 10: down-sample to 1/4
+ * 01: down-sample to 1/2
+ * 00: down-sample disabled
+ */
+#define TW5864_DSP_DWN_X (3 << 4)
+/*
+ * Down scale original frame in Y direction
+ * 11: Un-used
+ * 10: down-sample to 1/4
+ * 01: down-sample to 1/2
+ * 00: down-sample disabled
+ */
+#define TW5864_DSP_DWN_Y (3 << 6)
+/*
+ * 1 Dual Stream
+ * 0 Single Stream
+ */
+#define TW5864_DUAL_STR BIT(8)
+
+#define TW5864_DSP_REF 0x0204
+/* Define controls in register TW5864_DSP_REF */
+/* Number of reference frame (Default 1 for TW5864B) */
+#define TW5864_DSP_REF_FRM 0x000f
+/* Window size */
+#define TW5864_DSP_WIN_SIZE 0x02f0
+
+#define TW5864_DSP_SKIP 0x0208
+/* Define controls in register TW5864_DSP_SKIP */
+/*
+ * Skip Offset Enable bit
+ * 0 DSP_SKIP_OFFSET value is not used (default 8)
+ * 1 DSP_SKIP_OFFSET value is used in HW
+ */
+#define TW5864_DSP_SKIP_OFEN 0x0080
+/* Skip mode cost offset (default 8) */
+#define TW5864_DSP_SKIP_OFFSET 0x007f
+
+#define TW5864_MOTION_SEARCH_ETC 0x020c
+/* Define controls in register TW5864_MOTION_SEARCH_ETC */
+/* Enable quarter pel search mode */
+#define TW5864_QPEL_EN BIT(0)
+/* Enable half pel search mode */
+#define TW5864_HPEL_EN BIT(1)
+/* Enable motion search mode */
+#define TW5864_ME_EN BIT(2)
+/* Enable Intra mode */
+#define TW5864_INTRA_EN BIT(3)
+/* Enable Skip Mode */
+#define TW5864_SKIP_EN BIT(4)
+/* Search Option (Default 2"b01) */
+#define TW5864_SRCH_OPT (3 << 5)
+
+#define TW5864_DSP_ENC_REC 0x0210
+/* Define controls in register TW5864_DSP_ENC_REC */
+/* Reference Buffer Pointer for encoding */
+#define TW5864_DSP_ENC_REF_PTR 0x0007
+/* Reconstruct Buffer pointer */
+#define TW5864_DSP_REC_BUF_PTR 0x7000
+
+/* [15:0] Lambda Value for H264 */
+#define TW5864_DSP_REF_MVP_LAMBDA 0x0214
+
+#define TW5864_DSP_PIC_MAX_MB 0x0218
+/* Define controls in register TW5864_DSP_PIC_MAX_MB */
+/* The MB number in Y direction for a frame */
+#define TW5864_DSP_PIC_MAX_MB_Y 0x007f
+/* The MB number in X direction for a frame */
+#define TW5864_DSP_PIC_MAX_MB_X 0x7f00
+
+/* The original frame pointer for encoding */
+#define TW5864_DSP_ENC_ORG_PTR_REG 0x021c
+/* Mask to use with TW5864_DSP_ENC_ORG_PTR */
+#define TW5864_DSP_ENC_ORG_PTR_MASK 0x7000
+/* Number of bits to shift with TW5864_DSP_ENC_ORG_PTR */
+#define TW5864_DSP_ENC_ORG_PTR_SHIFT 12
+
+/* DDR base address of OSD rectangle attribute data */
+#define TW5864_DSP_OSD_ATTRI_BASE 0x0220
+/* OSD enable bit for each channel */
+#define TW5864_DSP_OSD_ENABLE 0x0228
+
+/* 0x0280 ~ 0x029c – Motion Vector for 1st 4x4 Block, e.g., 80 (X), 84 (Y) */
+#define TW5864_ME_MV_VEC1 0x0280
+/* 0x02a0 ~ 0x02bc – Motion Vector for 2nd 4x4 Block, e.g., A0 (X), A4 (Y) */
+#define TW5864_ME_MV_VEC2 0x02a0
+/* 0x02c0 ~ 0x02dc – Motion Vector for 3rd 4x4 Block, e.g., C0 (X), C4 (Y) */
+#define TW5864_ME_MV_VEC3 0x02c0
+/* 0x02e0 ~ 0x02fc – Motion Vector for 4th 4x4 Block, e.g., E0 (X), E4 (Y) */
+#define TW5864_ME_MV_VEC4 0x02e0
+
+/*
+ * [5:0]
+ * if (intra16x16_cost < (intra4x4_cost+dsp_i4x4_offset))
+ * Intra_mode = intra16x16_mode
+ * Else
+ * Intra_mode = intra4x4_mode
+ */
+#define TW5864_DSP_I4x4_OFFSET 0x040c
+
+/*
+ * [6:4]
+ * 0x5 Only 4x4
+ * 0x6 Only 16x16
+ * 0x7 16x16 & 4x4
+ */
+#define TW5864_DSP_INTRA_MODE 0x0410
+#define TW5864_DSP_INTRA_MODE_SHIFT 4
+#define TW5864_DSP_INTRA_MODE_MASK (7 << 4)
+#define TW5864_DSP_INTRA_MODE_4x4 0x5
+#define TW5864_DSP_INTRA_MODE_16x16 0x6
+#define TW5864_DSP_INTRA_MODE_4x4_AND_16x16 0x7
+/*
+ * [5:0] WEIGHT Factor for I4x4 cost calculation (QP dependent)
+ */
+#define TW5864_DSP_I4x4_WEIGHT 0x0414
+
+/*
+ * [7:0] Offset used to affect Intra/ME model decision
+ * If (me_cost < intra_cost + dsp_resid_mode_offset)
+ * Pred_Mode = me_mode
+ * Else
+ * Pred_mode = intra_mode
+ */
+#define TW5864_DSP_RESID_MODE_OFFSET 0x0604
+
+/* 0x0800 ~ 0x09ff - Quantization TABLE Values */
+#define TW5864_QUAN_TAB 0x0800
+
+/* Valid channel value [0; f], frame value [0; 3] */
+#define TW5864_RT_CNTR_CH_FRM(channel, frame) \
+	(0x0c00 | (channel << 4) | (frame << 2))
+
+#define TW5864_FRAME_BUS1 0x0d00
+/*
+ * 1 Progressive in part A in bus n
+ * 0 Interlaced in part A in bus n
+ */
+#define TW5864_PROG_A BIT(0)
+/*
+ * 1 Progressive in part B in bus n
+ * 0 Interlaced in part B in bus n
+ */
+#define TW5864_PROG_B BIT(1)
+/*
+ * 1 Frame Mode in bus n
+ * 0 Field Mode in bus n
+ */
+#define TW5864_FRAME BIT(2)
+/*
+ * 0 4CIF in bus n
+ * 1 1D1 + 4 CIF in bus n
+ * 2 2D1 in bus n
+ */
+#define TW5864_BUS_D1 (3 << 3)
+/* Bus 1 goes in TW5864_FRAME_BUS1 in [4:0] */
+/* Bus 2 goes in TW5864_FRAME_BUS1 in [12:8] */
+#define TW5864_FRAME_BUS2 0x0d04
+/* Bus 3 goes in TW5864_FRAME_BUS2 in [4:0] */
+/* Bus 4 goes in TW5864_FRAME_BUS2 in [12:8] */
+
+/* [15:0] Horizontal Mirror for channel n */
+#define TW5864_SENIF_HOR_MIR 0x0d08
+/* [15:0] Vertical Mirror for channel n */
+#define TW5864_SENIF_VER_MIR 0x0d0c
+
+/*
+ * FRAME_WIDTH_BUSn_A
+ * 0x15f: 4 CIF
+ * 0x2cf: 1 D1 + 3 CIF
+ * 0x2cf: 2 D1
+ * FRAME_WIDTH_BUSn_B
+ * 0x15f: 4 CIF
+ * 0x2cf: 1 D1 + 3 CIF
+ * 0x2cf: 2 D1
+ * FRAME_HEIGHT_BUSn_A
+ * 0x11f: 4CIF (PAL)
+ * 0x23f: 1D1 + 3CIF (PAL)
+ * 0x23f: 2 D1 (PAL)
+ * 0x0ef: 4CIF (NTSC)
+ * 0x1df: 1D1 + 3CIF (NTSC)
+ * 0x1df: 2 D1 (NTSC)
+ * FRAME_HEIGHT_BUSn_B
+ * 0x11f: 4CIF (PAL)
+ * 0x23f: 1D1 + 3CIF (PAL)
+ * 0x23f: 2 D1 (PAL)
+ * 0x0ef: 4CIF (NTSC)
+ * 0x1df: 1D1 + 3CIF (NTSC)
+ * 0x1df: 2 D1 (NTSC)
+ */
+#define TW5864_FRAME_WIDTH_BUS_A(bus) (0x0d10 + 0x0010 * bus)
+#define TW5864_FRAME_WIDTH_BUS_B(bus) (0x0d14 + 0x0010 * bus)
+#define TW5864_FRAME_HEIGHT_BUS_A(bus) (0x0d18 + 0x0010 * bus)
+#define TW5864_FRAME_HEIGHT_BUS_B(bus) (0x0d1c + 0x0010 * bus)
+
+/*
+ * 1: the bus mapped Channel n Full D1
+ * 0: the bus mapped Channel n Half D1
+ */
+#define TW5864_FULL_HALF_FLAG 0x0d50
+
+/*
+ * 0 The bus mapped Channel select partA Mode
+ * 1 The bus mapped Channel select partB Mode
+ */
+#define TW5864_FULL_HALF_MODE_SEL 0x0d54
+
+#define TW5864_VLC 0x1000
+/* Define controls in register TW5864_VLC */
+/* QP Value used by H264 CAVLC */
+#define TW5864_VLC_SLICE_QP 0x003f
+/*
+ * Swap byte order of VLC stream in d-word.
+ * 1 Normal (VLC output= [31:0])
+ * 0 Swap (VLC output={[23:16],[31:24],[7:0], [15:8]})
+ */
+#define TW5864_VLC_BYTE_SWP BIT(6)
+/* Enable Adding 03 circuit for VLC stream */
+#define TW5864_VLC_ADD03_EN BIT(7)
+/* Number of bit for VLC bit Align */
+#define TW5864_VLC_BIT_ALIGN_SHIFT 8
+#define TW5864_VLC_BIT_ALIGN_MASK (0x1f << 8)
+/*
+ * Synchronous Interface select for VLC Stream
+ * 1 CDC_VLCS_MAS read VLC stream
+ * 0 CPU read VLC stream
+ */
+#define TW5864_VLC_INF_SEL BIT(13)
+/* Enable VLC overflow control */
+#define TW5864_VLC_OVFL_CNTL BIT(14)
+/*
+ * 1 PCI Master Mode
+ * 0 Non PCI Master Mode
+ */
+#define TW5864_VLC_PCI_SEL BIT(15)
+/*
+ * 0 Enable Adding 03 to VLC header and stream
+ * 1 Disable Adding 03 to VLC header of "00000001"
+ */
+#define TW5864_VLC_A03_DISAB BIT(16)
+/*
+ * Status of VLC stream in DDR (one bit for each buffer)
+ * 1 VLC is ready in buffer n (HW set)
+ * 0 VLC is not ready in buffer n (SW clear)
+ */
+#define TW5864_VLC_BUF_RDY_SHIFT 24
+#define TW5864_VLC_BUF_RDY_MASK (0xff << 24)
+
+/* Total number of bit in the slice */
+#define TW5864_SLICE_TOTAL_BIT 0x1004
+/* Total number of bit in the residue */
+#define TW5864_RES_TOTAL_BIT 0x1008
+
+#define TW5864_VLC_BUF 0x100c
+/* Define controls in register TW5864_VLC_BUF */
+/* VLC BK0 full status, write ‘1’ to clear */
+#define TW5864_VLC_BK0_FULL BIT(0)
+/* VLC BK1 full status, write ‘1’ to clear */
+#define TW5864_VLC_BK1_FULL BIT(1)
+/* VLC end slice status, write ‘1’ to clear */
+#define TW5864_VLC_END_SLICE BIT(2)
+/* VLC Buffer overflow status, write ‘1’ to clear */
+#define TW5864_DSP_RD_OF BIT(3)
+/* VLC string length in either buffer 0 or 1 at end of frame */
+#define TW5864_VLC_STREAM_LEN_SHIFT 4
+#define TW5864_VLC_STREAM_LEN_MASK (0x1ff << 4)
+
+/* [15:0] Total coefficient number in a frame */
+#define TW5864_TOTAL_COEF_NO 0x1010
+/* [0] VLC Encoder Interrupt. Write ‘1’ to clear */
+#define TW5864_VLC_DSP_INTR 0x1014
+/* [31:0] VLC stream CRC checksum */
+#define TW5864_VLC_STREAM_CRC 0x1018
+
+#define TW5864_VLC_RD 0x101c
+/* Define controls in register TW5864_VLC_RD */
+/*
+ * 1 Read VLC lookup Memory
+ * 0 Read VLC Stream Memory
+ */
+#define TW5864_VLC_RD_MEM BIT(0)
+/*
+ * 1 Read VLC Stream Memory in burst mode
+ * 0 Read VLC Stream Memory in single mode
+ */
+#define TW5864_VLC_RD_BRST BIT(1)
+
+/* 0x2000 ~ 0x2ffc -- H264 Stream Memory Map */
+/*
+ * A word is 4 bytes. I.e.,
+ * VLC_STREAM_MEM[0] address: 0x2000
+ * VLC_STREAM_MEM[1] address: 0x2004
+ * ...
+ * VLC_STREAM_MEM[3FF] address: 0x2ffc
+ */
+#define TW5864_VLC_STREAM_MEM_START 0x2000
+#define TW5864_VLC_STREAM_MEM_MAX_OFFSET 0x3ff
+#define TW5864_VLC_STREAM_MEM(offset) (TW5864_VLC_STREAM_MEM_START + 4 * offset)
+
+/* 0x4000 ~ 0x4ffc -- Audio Register Map */
+/* [31:0] config 1ms cnt = Realtime clk/1000 */
+#define TW5864_CFG_1MS_CNT 0x4000
+
+#define TW5864_ADPCM 0x4004
+/* Define controls in register TW5864_ADPCM */
+/* ADPCM decoder enable */
+#define TW5864_ADPCM_DEC BIT(0)
+/* ADPCM input data enable */
+#define TW5864_ADPCM_IN_DATA BIT(1)
+/* ADPCM encoder enable */
+#define TW5864_ADPCM_ENC BIT(2)
+
+#define TW5864_AUD 0x4008
+/* Define controls in register TW5864_AUD */
+/* Record path PCM Audio enable bit for each channel */
+#define TW5864_AUD_ORG_CH_EN 0x00ff
+/* Speaker path PCM Audio Enable */
+#define TW5864_SPK_ORG_EN BIT(16)
+/*
+ * 0 16bit
+ * 1 8bit
+ */
+#define TW5864_AD_BIT_MODE BIT(17)
+#define TW5864_AUD_TYPE_SHIFT 18
+/*
+ * 0 PCM
+ * 3 ADPCM
+ */
+#define TW5864_AUD_TYPE (0xf << 18)
+#define TW5864_AUD_SAMPLE_RATE_SHIFT 22
+/*
+ * 0 8K
+ * 1 16K
+ */
+#define TW5864_AUD_SAMPLE_RATE (3 << 22)
+/* Channel ID used to select audio channel (0 to 16) for loopback */
+#define TW5864_TESTLOOP_CHID_SHIFT 24
+#define TW5864_TESTLOOP_CHID (0x1f << 24)
+/* Enable AD Loopback Test */
+#define TW5864_TEST_ADLOOP_EN BIT(30)
+/*
+ * 0 Asynchronous Mode or PCI target mode
+ * 1 PCI Initiator Mode
+ */
+#define TW5864_AUD_MODE BIT(31)
+
+#define TW5864_AUD_ADPCM 0x400c
+/* Define controls in register TW5864_AUD_ADPCM */
+/* Record path ADPCM audio channel enable, one bit for each */
+#define TW5864_AUD_ADPCM_CH_EN 0x00ff
+/* Speaker path ADPCM audio channel enable */
+#define TW5864_SPK_ADPCM_EN BIT(16)
+
+#define TW5864_PC_BLOCK_ADPCM_RD_NO 0x4018
+#define TW5864_PC_BLOCK_ADPCM_RD_NO_MASK 0x1f
+
+/*
+ * For ADPCM_ENC_WR_PTR, ADPCM_ENC_RD_PTR (see below):
+ * Bit[2:0] ch0
+ * Bit[5:3] ch1
+ * Bit[8:6] ch2
+ * Bit[11:9] ch3
+ * Bit[14:12] ch4
+ * Bit[17:15] ch5
+ * Bit[20:18] ch6
+ * Bit[23:21] ch7
+ * Bit[26:24] ch8
+ * Bit[29:27] ch9
+ * Bit[32:30] ch10
+ * Bit[35:33] ch11
+ * Bit[38:36] ch12
+ * Bit[41:39] ch13
+ * Bit[44:42] ch14
+ * Bit[47:45] ch15
+ * Bit[50:48] ch16
+ */
+#define TW5864_ADPCM_ENC_XX_MASK 0x3fff
+#define TW5864_ADPCM_ENC_XX_PTR2_SHIFT 30
+/* ADPCM_ENC_WR_PTR[29:0] */
+#define TW5864_ADPCM_ENC_WR_PTR1 0x401c
+/* ADPCM_ENC_WR_PTR[50:30] */
+#define TW5864_ADPCM_ENC_WR_PTR2 0x4020
+
+/* ADPCM_ENC_RD_PTR[29:0] */
+#define TW5864_ADPCM_ENC_RD_PTR1 0x4024
+/* ADPCM_ENC_RD_PTR[50:30] */
+#define TW5864_ADPCM_ENC_RD_PTR2 0x4028
+
+/* [3:0] rd ch0, [7:4] rd ch1, [11:8] wr ch0, [15:12] wr ch1 */
+#define TW5864_ADPCM_DEC_RD_WR_PTR 0x402c
+
+/*
+ * For TW5864_AD_ORIG_WR_PTR, TW5864_AD_ORIG_RD_PTR:
+ * Bit[3:0] ch0
+ * Bit[7:4] ch1
+ * Bit[11:8] ch2
+ * Bit[15:12] ch3
+ * Bit[19:16] ch4
+ * Bit[23:20] ch5
+ * Bit[27:24] ch6
+ * Bit[31:28] ch7
+ * Bit[35:32] ch8
+ * Bit[39:36] ch9
+ * Bit[43:40] ch10
+ * Bit[47:44] ch11
+ * Bit[51:48] ch12
+ * Bit[55:52] ch13
+ * Bit[59:56] ch14
+ * Bit[63:60] ch15
+ * Bit[67:64] ch16
+ */
+/* AD_ORIG_WR_PTR[31:0] */
+#define TW5864_AD_ORIG_WR_PTR1 0x4030
+/* AD_ORIG_WR_PTR[63:32] */
+#define TW5864_AD_ORIG_WR_PTR2 0x4034
+/* AD_ORIG_WR_PTR[67:64] */
+#define TW5864_AD_ORIG_WR_PTR3 0x4038
+
+/* AD_ORIG_RD_PTR[31:0] */
+#define TW5864_AD_ORIG_RD_PTR1 0x403c
+/* AD_ORIG_RD_PTR[63:32] */
+#define TW5864_AD_ORIG_RD_PTR2 0x4040
+/* AD_ORIG_RD_PTR[67:64] */
+#define TW5864_AD_ORIG_RD_PTR3 0x4044
+
+#define TW5864_PC_BLOCK_ORIG_RD_NO 0x4048
+#define TW5864_PC_BLOCK_ORIG_RD_NO_MASK 0x1f
+
+#define TW5864_PCI_AUD 0x404c
+/* Define controls in register TW5864_PCI_AUD */
+/*
+ * The register is applicable to PCI initiator mode only. Used to select PCM(0)
+ * or ADPCM(1) audio data sent to PC. One bit for each channel
+ */
+#define TW5864_PCI_DATA_SEL 0xffff
+/*
+ * Audio flow control mode selection bit.
+ * 0 Flow control disabled. TW5864 continuously sends audio frame to PC
+ * (initiator mode)
+ * 1 Flow control enabled
+ */
+#define TW5864_PCI_FLOW_EN BIT(16)
+/*
+ * When PCI_FLOW_EN is set, PCI need to toggle this bit to send an audio frame
+ * to PC. One toggle to send one frame.
+ */
+#define TW5864_PCI_AUD_FRM_EN BIT(17)
+
+/* [1:0] CS valid to data valid CLK cycles when writing operation */
+#define TW5864_CS2DAT_CNT 0x8000
+/* [2:0] Data valid signal width by system clock cycles */
+#define TW5864_DATA_VLD_WIDTH 0x8004
+
+#define TW5864_SYNC 0x8008
+/* Define controls in register TW5864_SYNC */
+/*
+ * 0 vlc stream to syncrous port
+ * 1 vlc stream to ddr buffers
+ */
+#define TW5864_SYNC_CFG BIT(7)
+/*
+ * 0 SYNC Address sampled on Rising edge
+ * 1 SYNC Address sampled on Falling edge
+ */
+#define TW5864_SYNC_ADR_EDGE BIT(0)
+#define TW5864_VLC_STR_DELAY_SHIFT 1
+/*
+ * 0 No system delay
+ * 1 One system clock delay
+ * 2 Two system clock delay
+ * 3 Three system clock delay
+ */
+#define TW5864_VLC_STR_DELAY (3 << 1)
+/*
+ * 0 Rising edge output
+ * 1 Falling edge output
+ */
+#define TW5864_VLC_OUT_EDGE BIT(3)
+
+/*
+ * [1:0]
+ * 2’b00 phase set to 180 degree
+ * 2’b01 phase set to 270 degree
+ * 2’b10 phase set to 0 degree
+ * 2’b11 phase set to 90 degree
+ */
+#define TW5864_I2C_PHASE_CFG 0x800c
+
+/*
+ * The system / DDR clock (166 MHz) is generated with an on-chip system clock
+ * PLL (SYSPLL) using input crystal clock of 27 MHz. The system clock PLL
+ * frequency is controlled with the following equation.
+ * CLK_OUT = CLK_IN * (M+1) / ((N+1) * P)
+ * SYSPLL_M M parameter
+ * SYSPLL_N N parameter
+ * SYSPLL_P P parameter
+ */
+/* SYSPLL_M[7:0] */
+#define TW5864_SYSPLL1 0x8018
+/* Define controls in register TW5864_SYSPLL1 */
+#define TW5864_SYSPLL_M_LOW 0x00ff
+
+/* [2:0]: SYSPLL_M[10:8], [7:3]: SYSPLL_N[4:0] */
+#define TW5864_SYSPLL2 0x8019
+/* Define controls in register TW5864_SYSPLL2 */
+#define TW5864_SYSPLL_M_HI 0x07
+#define TW5864_SYSPLL_N_LOW_SHIFT 3
+#define TW5864_SYSPLL_N_LOW (0x1f << 3)
+
+/*
+ * [1:0]: SYSPLL_N[6:5], [3:2]: SYSPLL_P, [4]: SYSPLL_IREF, [7:5]: SYSPLL_CP_SEL
+ */
+#define TW5864_SYSPLL3 0x8020
+/* Define controls in register TW5864_SYSPLL3 */
+#define TW5864_SYSPLL_N_HI 0x03
+#define TW5864_SYSPLL_P_SHIFT 2
+#define TW5864_SYSPLL_P (0x03 << 2)
+/*
+ * SYSPLL bias current control
+ * 0 Lower current (default)
+ * 1 30% higher current
+ */
+#define TW5864_SYSPLL_IREF BIT(4)
+/*
+ * SYSPLL charge pump current selection
+ * 0 1,5 uA
+ * 1 4 uA
+ * 2 9 uA
+ * 3 19 uA
+ * 4 39 uA
+ * 5 79 uA
+ * 6 159 uA
+ * 7 319 uA
+ */
+#define TW5864_SYSPLL_CP_SEL_SHIFT 5
+#define TW5864_SYSPLL_CP_SEL (0x07 << 5)
+
+/*
+ * [1:0]: SYSPLL_VCO, [3:2]: SYSPLL_LP_X8, [5:4]: SYSPLL_ICP_SEL,
+ * [6]: SYSPLL_LPF_5PF, [7]: SYSPLL_ED_SEL
+ */
+#define TW5864_SYSPLL4 0x8021
+/* Define controls in register TW5864_SYSPLL4 */
+/*
+ * SYSPLL_VCO VCO Range selection
+ * 00 5 ~ 75 MHz
+ * 01 50 ~ 140 MHz
+ * 10 110 ~ 320 MHz
+ * 11 270 ~ 700 MHz
+ */
+#define TW5864_SYSPLL_VCO 0x03
+#define TW5864_SYSPLL_LP_X8_SHIFT 2
+/*
+ * Loop resister
+ * 0 38.5K ohms
+ * 1 6.6K ohms (default)
+ * 2 2.2K ohms
+ * 3 1.1K ohms
+ */
+#define TW5864_SYSPLL_LP_X8 (0x03 << 2)
+#define TW5864_SYSPLL_ICP_SEL_SHIFT 4
+/*
+ * PLL charge pump fine tune
+ * 00 x1 (default)
+ * 01 x1/2
+ * 10 x1/7
+ * 11 x1/8
+ */
+#define TW5864_SYSPLL_ICP_SEL (0x03 << 4)
+/*
+ * PLL low pass filter phase margin adjustment
+ * 0 no 5pF (default)
+ * 1 5pF added
+ */
+#define TW5864_SYSPLL_LPF_5PF BIT(6)
+/*
+ * PFD select edge for detection
+ * 0 Falling edge (default)
+ * 1 Rising edge
+ */
+#define TW5864_SYSPLL_ED_SEL BIT(7)
+
+/* [0]: SYSPLL_RST, [4]: SYSPLL_PD */
+#define TW5864_SYSPLL5 0x8024
+/* Define controls in register TW5864_SYSPLL5 */
+/* Reset SYSPLL */
+#define TW5864_SYSPLL_RST BIT(0)
+/* Power down SYSPLL */
+#define TW5864_SYSPLL_PD BIT(4)
+
+#define TW5864_PLL_CFG 0x801c
+/* Define controls in register TW5864_PLL_CFG */
+/*
+ * Issue Soft Reset from Async Host Interface / PCI Interface clock domain.
+ * Become valid after sync to the xtal clock domain. This bit is set only if
+ * LOAD register bit is also set to 1.
+ */
+#define TW5864_SRST BIT(0)
+/*
+ * Issue SYSPLL (166 MHz) configuration latch from Async host interface / PCI
+ * Interface clock domain. The configuration setting becomes effective only if
+ * LOAD register bit is also set to 1.
+ */
+#define TW5864_SYSPLL_CFG BIT(2)
+/*
+ * Issue SPLL (108 MHz) configuration load from Async host interface / PCI
+ * Interface clock domain. The configuration setting becomes effective only if
+ * the LOAD register bit is also set to 1.
+ */
+#define TW5864_SPLL_CFG BIT(4)
+/*
+ * Set this bit to latch the SRST, SYSPLL_CFG, SPLL_CFG setting into the xtal
+ * clock domain to restart the PLL. This bit is self cleared.
+ */
+#define TW5864_LOAD BIT(3)
+
+/* SPLL_IREF, SPLL_LPX4, SPLL_CPX4, SPLL_PD, SPLL_DBG */
+#define TW5864_SPLL 0x8028
+
+/* 0x8800 ~ 0x88fc -- Interrupt Register Map */
+/*
+ * Trigger mode of interrupt source 0 ~ 15
+ * 1 Edge trigger mode
+ * 0 Level trigger mode
+ */
+#define TW5864_TRIGGER_MODE_L 0x8800
+/* Trigger mode of interrupt source 16 ~ 31 */
+#define TW5864_TRIGGER_MODE_H 0x8804
+/* Enable of interrupt source 0 ~ 15 */
+#define TW5864_INTR_ENABLE_L 0x8808
+/* Enable of interrupt source 16 ~ 31 */
+#define TW5864_INTR_ENABLE_H 0x880c
+/* Clear interrupt command of interrupt source 0 ~ 15 */
+#define TW5864_INTR_CLR_L 0x8810
+/* Clear interrupt command of interrupt source 16 ~ 31 */
+#define TW5864_INTR_CLR_H 0x8814
+/*
+ * Assertion of interrupt source 0 ~ 15
+ * 1 High level or pos-edge is assertion
+ * 0 Low level or neg-edge is assertion
+ */
+#define TW5864_INTR_ASSERT_L 0x8818
+/* Assertion of interrupt source 16 ~ 31 */
+#define TW5864_INTR_ASSERT_H 0x881c
+/*
+ * Output level of interrupt
+ * 1 Interrupt output is high assertion
+ * 0 Interrupt output is low assertion
+ */
+#define TW5864_INTR_OUT_LEVEL 0x8820
+/*
+ * Status of interrupt source 0 ~ 15
+ * Bit[0]: VLC 4k RAM interrupt
+ * Bit[1]: BURST DDR RAM interrupt
+ * Bit[2]: MV DSP interrupt
+ * Bit[3]: video lost interrupt
+ * Bit[4]: gpio 0 interrupt
+ * Bit[5]: gpio 1 interrupt
+ * Bit[6]: gpio 2 interrupt
+ * Bit[7]: gpio 3 interrupt
+ * Bit[8]: gpio 4 interrupt
+ * Bit[9]: gpio 5 interrupt
+ * Bit[10]: gpio 6 interrupt
+ * Bit[11]: gpio 7 interrupt
+ * Bit[12]: JPEG interrupt
+ * Bit[13:15]: Reserved
+ */
+#define TW5864_INTR_STATUS_L 0x8838
+/*
+ * Status of interrupt source 16 ~ 31
+ * Bit[0]: Reserved
+ * Bit[1]: VLC done interrupt
+ * Bit[2]: Reserved
+ * Bit[3]: AD Vsync interrupt
+ * Bit[4]: Preview eof interrupt
+ * Bit[5]: Preview overflow interrupt
+ * Bit[6]: Timer interrupt
+ * Bit[7]: Reserved
+ * Bit[8]: Audio eof interrupt
+ * Bit[9]: I2C done interrupt
+ * Bit[10]: AD interrupt
+ * Bit[11:15]: Reserved
+ */
+#define TW5864_INTR_STATUS_H 0x883c
+
+/* Defines of interrupt bits, united for both low and high word registers */
+#define TW5864_INTR_VLC_RAM BIT(0)
+#define TW5864_INTR_BURST BIT(1)
+#define TW5864_INTR_MV_DSP BIT(2)
+#define TW5864_INTR_VIN_LOST BIT(3)
+/* n belongs to [0; 7] */
+#define TW5864_INTR_GPIO(n) (1 << (4 + n))
+#define TW5864_INTR_JPEG BIT(12)
+#define TW5864_INTR_VLC_DONE BIT(17)
+#define TW5864_INTR_AD_VSYNC BIT(19)
+#define TW5864_INTR_PV_EOF BIT(20)
+#define TW5864_INTR_PV_OVERFLOW BIT(21)
+#define TW5864_INTR_TIMER BIT(22)
+#define TW5864_INTR_AUD_EOF BIT(24)
+#define TW5864_INTR_I2C_DONE BIT(25)
+#define TW5864_INTR_AD BIT(26)
+
+/* 0x9000 ~ 0x920c -- Video Capture (VIF) Register Map */
+/*
+ * H264EN_CH_STATUS[n] Status of Vsync synchronized H264EN_CH_EN (Read Only)
+ * 1 Channel Enabled
+ * 0 Channel Disabled
+ */
+#define TW5864_H264EN_CH_STATUS 0x9000
+/*
+ * [15:0] H264EN_CH_EN[n] H264 Encoding Path Enable for channel
+ * 1 Channel Enabled
+ * 0 Channel Disabled
+ */
+#define TW5864_H264EN_CH_EN 0x9004
+/*
+ * H264EN_CH_DNS[n] H264 Encoding Path Downscale Video Decoder Input for
+ * channel n
+ * 1 Downscale Y to 1/2
+ * 0 Does not downscale
+ */
+#define TW5864_H264EN_CH_DNS 0x9008
+/*
+ * H264EN_CH_PROG[n] H264 Encoding Path channel n is progressive
+ * 1 Progressive (Not valid for TW5864)
+ * 0 Interlaced (TW5864 default)
+ */
+#define TW5864_H264EN_CH_PROG 0x900c
+/*
+ * [3:0] H264EN_BUS_MAX_CH[n]
+ * H264 Encoding Path maximum number of channel on BUS n
+ * 0 Max 4 channels
+ * 1 Max 2 channels
+ */
+#define TW5864_H264EN_BUS_MAX_CH 0x9010
+
+/*
+ * H264EN_RATE_MAX_LINE_n H264 Encoding path Rate Mapping Maximum Line Number
+ * on Bus n
+ */
+#define TW5864_H264EN_RATE_MAX_LINE_EVEN 0x1f
+#define TW5864_H264EN_RATE_MAX_LINE_ODD_SHIFT 5
+#define TW5864_H264EN_RATE_MAX_LINE_ODD (0x1f << 5)
+/*
+ * [4:0] H264EN_RATE_MAX_LINE_0
+ * [9:5] H264EN_RATE_MAX_LINE_1
+ */
+#define TW5864_H264EN_RATE_MAX_LINE_REG1 0x9014
+/*
+ * [4:0] H264EN_RATE_MAX_LINE_2
+ * [9:5] H264EN_RATE_MAX_LINE_3
+ */
+#define TW5864_H264EN_RATE_MAX_LINE_REG2 0x9018
+
+/*
+ * H264EN_CHn_FMT H264 Encoding Path Format configuration of Channel n
+ * 00 D1 (For D1 and hD1 frame)
+ * 01 (Reserved)
+ * 10 (Reserved)
+ * 11 D1 with 1/2 size in X (for CIF frame)
+ * Note: To be used with 0x9008 register to configure the frame size
+ */
+/*
+ * [1:0]: H264EN_CH0_FMT,
+ * ..., [15:14]: H264EN_CH7_FMT
+ */
+#define TW5864_H264EN_CH_FMT_REG1 0x9020
+/*
+ * [1:0]: H264EN_CH8_FMT (?),
+ * ..., [15:14]: H264EN_CH15_FMT (?)
+ */
+#define TW5864_H264EN_CH_FMT_REG2 0x9024
+
+/*
+ * H264EN_RATE_CNTL_BUSm_CHn H264 Encoding Path BUS m Rate Control for Channel n
+ */
+#define TW5864_H264EN_RATE_CNTL_LO_WORD(bus, channel) \
+	(0x9100 + bus * 0x20 + channel * 0x08)
+#define TW5864_H264EN_RATE_CNTL_HI_WORD(bus, channel) \
+	(0x9104 + bus * 0x20 + channel * 0x08)
+
+/*
+ * H264EN_BUSm_MAP_CHn The 16-to-1 MUX configuration register for each encoding
+ * channel (total of 16 channels). Four bits for each channel.
+ */
+#define TW5864_H264EN_BUS0_MAP 0x9200
+#define TW5864_H264EN_BUS1_MAP 0x9204
+#define TW5864_H264EN_BUS2_MAP 0x9208
+#define TW5864_H264EN_BUS3_MAP 0x920c
+
+/* This register is not defined in datasheet, but used in reference driver */
+#define TW5864_UNDECLARED_ERROR_FLAGS_0x9218 0x9218
+
+#define TW5864_GPIO1 0x9800
+#define TW5864_GPIO2 0x9804
+/* Define controls in registers TW5864_GPIO1, TW5864_GPIO2 */
+/* GPIO DATA of Group n */
+#define TW5864_GPIO_DATA 0x00ff
+#define TW5864_GPIO_OEN_SHIFT 8
+/* GPIO Output Enable of Group n */
+#define TW5864_GPIO_OEN (0xff << 8)
+
+/* 0xa000 ~ 0xa8ff – DDR Controller Register Map */
+/* DDR Controller A */
+/*
+ * [2:0] Data valid counter after read command to DDR. This is the delay value
+ * to show how many cycles the data will be back from DDR after we issue a read
+ * command.
+ */
+#define TW5864_RD_ACK_VLD_MUX 0xa000
+
+#define TW5864_DDR_PERIODS 0xa004
+/* Define controls in register TW5864_DDR_PERIODS */
+/*
+ * Tras value, the minimum cycle of active to precharge command period,
+ * default is 7
+ */
+#define TW5864_TRAS_CNT_MAX 0x000f
+/*
+ * Trfc value, the minimum cycle of refresh to active or refresh command period,
+ * default is 4"hf
+ */
+#define TW5864_RFC_CNT_MAX_SHIFT 8
+#define TW5864_RFC_CNT_MAX (0x0f << 8)
+/*
+ * Trcd value, the minimum cycle of active to internal read/write command
+ * period, default is 4"h2
+ */
+#define TW5864_TCD_CNT_MAX_SHIFT 4
+#define TW5864_TCD_CNT_MAX (0x0f << 4)
+/* Twr value, write recovery time, default is 4"h3 */
+#define TW5864_TWR_CNT_MAX_SHIFT 12
+#define TW5864_TWR_CNT_MAX (0x0f << 12)
+
+/*
+ * [2:0] CAS latency, the delay cycle between internal read command and the
+ * availability of the first bit of output data, default is 3
+ */
+#define TW5864_CAS_LATENCY 0xa008
+/*
+ * [15:0] Maximum average periodic refresh, the value is based on the current
+ * frequency to match 7.8mcs
+ */
+#define TW5864_DDR_REF_CNTR_MAX 0xa00c
+/*
+ * DDR_ON_CHIP_MAP [1:0]
+ * 0 256M DDR on board
+ * 1 512M DDR on board
+ * 2 1G DDR on board
+ * DDR_ON_CHIP_MAP [2]
+ * 0 Only one DDR chip
+ * 1 Two DDR chips
+ */
+#define TW5864_DDR_ON_CHIP_MAP 0xa01c
+#define TW5864_DDR_SELFTEST_MODE 0xa020
+/* Define controls in register TW5864_DDR_SELFTEST_MODE */
+/*
+ * 0 Common read/write mode
+ * 1 DDR self-test mode
+ */
+#define TW5864_MASTER_MODE BIT(0)
+/*
+ * 0 DDR self-test single read/write
+ * 1 DDR self-test burst read/write
+ */
+#define TW5864_SINGLE_PROC BIT(1)
+/*
+ * 0 DDR self-test write command
+ * 1 DDR self-test read command
+ */
+#define TW5864_WRITE_FLAG BIT(2)
+#define TW5864_DATA_MODE_SHIFT 4
+/*
+ * 0 write 32'haaaa5555 to DDR
+ * 1 write 32'hffffffff to DDR
+ * 2 write 32'hha5a55a5a to DDR
+ * 3 write increasing data to DDR
+ */
+#define TW5864_DATA_MODE (0x3 << 4)
+
+/* [7:0] The maximum data of one burst in DDR self-test mode */
+#define TW5864_BURST_CNTR_MAX 0xa024
+/* [15:0] The maximum burst counter (bit 15~0) in DDR self-test mode */
+#define TW5864_DDR_PROC_CNTR_MAX_L 0xa028
+/* The maximum burst counter (bit 31~16) in DDR self-test mode */
+#define TW5864_DDR_PROC_CNTR_MAX_H 0xa02c
+/* [0]: Start one DDR self-test */
+#define TW5864_DDR_SELF_TEST_CMD 0xa030
+/* The maximum error counter (bit 15 ~ 0) in DDR self-test */
+#define TW5864_ERR_CNTR_L 0xa034
+
+#define TW5864_ERR_CNTR_H_AND_FLAG 0xa038
+/* Define controls in register TW5864_ERR_CNTR_H_AND_FLAG */
+/* The maximum error counter (bit 30 ~ 16) in DDR self-test */
+#define TW5864_ERR_CNTR_H_MASK 0x3fff
+/* DDR self-test end flag */
+#define TW5864_END_FLAG 0x8000
+
+/*
+ * DDR Controller B: same as 0xa000 ~ 0xa038, but add TW5864_DDR_B_OFFSET to all
+ * addresses
+ */
+#define TW5864_DDR_B_OFFSET 0x0800
+
+/* 0xb004 ~ 0xb018 – HW version/ARB12 Register Map */
+/* [15:0] Default is C013 */
+#define TW5864_HW_VERSION 0xb004
+
+#define TW5864_REQS_ENABLE 0xb010
+/* Define controls in register TW5864_REQS_ENABLE */
+/* Audio data in to DDR enable (default 1) */
+#define TW5864_AUD_DATA_IN_ENB BIT(0)
+/* Audio encode request to DDR enable (default 1) */
+#define TW5864_AUD_ENC_REQ_ENB BIT(1)
+/* Audio decode request0 to DDR enable (default 1) */
+#define TW5864_AUD_DEC_REQ0_ENB BIT(2)
+/* Audio decode request1 to DDR enable (default 1) */
+#define TW5864_AUD_DEC_REQ1_ENB BIT(3)
+/* VLC stream request to DDR enable (default 1) */
+#define TW5864_VLC_STRM_REQ_ENB BIT(4)
+/* H264 MV request to DDR enable (default 1) */
+#define TW5864_DVM_MV_REQ_ENB BIT(5)
+/* mux_core MVD request to DDR enable (default 1) */
+#define TW5864_MVD_REQ_ENB BIT(6)
+/* mux_core MVD temp data request to DDR enable (default 1) */
+#define TW5864_MVD_TMP_REQ_ENB BIT(7)
+/* JPEG request to DDR enable (default 1) */
+#define TW5864_JPEG_REQ_ENB BIT(8)
+/* mv_flag request to DDR enable (default 1) */
+#define TW5864_MV_FLAG_REQ_ENB BIT(9)
+
+#define TW5864_ARB12 0xb018
+/* Define controls in register TW5864_ARB12 */
+/* ARB12 Enable (default 1) */
+#define TW5864_ARB12_ENB BIT(15)
+/* ARB12 maximum value of time out counter (default 15"h1FF) */
+#define TW5864_ARB12_TIME_OUT_CNT 0x7fff
+
+/* 0xb800 ~ 0xb80c -- Indirect Access Register Map */
+/*
+ * Spec says:
+ * In order to access the indirect register space, the following procedure is
+ * followed.
+ * But reference driver implementation, and current driver, too, does it
+ * differently.
+ *
+ * Write Registers:
+ * (1) Write IND_DATA at 0xb804 ~ 0xb807
+ * (2) Read BUSY flag from 0xb803. Wait until BUSY signal is 0.
+ * (3) Write IND_ADDR at 0xb800 ~ 0xb801. Set R/W to "1", ENABLE to "1"
+ * Read Registers:
+ * (1) Read BUSY flag from 0xb803. Wait until BUSY signal is 0.
+ * (2) Write IND_ADDR at 0xb800 ~ 0xb801. Set R/W to "0", ENABLE to "1"
+ * (3) Read BUSY flag from 0xb803. Wait until BUSY signal is 0.
+ * (4) Read IND_DATA from 0xb804 ~ 0xb807
+ */
+#define TW5864_IND_CTL 0xb800
+/* Define controls in register TW5864_IND_CTL */
+/* Address used to access indirect register space */
+#define TW5864_IND_ADDR 0x0000ffff
+/* Wait until this bit is "0" before using indirect access */
+#define TW5864_BUSY BIT(31)
+/* Activate the indirect access. This bit is self cleared */
+#define TW5864_ENABLE BIT(25)
+/* Read/Write command */
+#define TW5864_RW BIT(24)
+
+/* [31:0] Data used to read/write indirect register space */
+#define TW5864_IND_DATA 0xb804
+
+/* 0xc000 ~ 0xc7fc -- Preview Register Map */
+/* Mostly skipped this section. */
+/*
+ * [15:0] Status of Vsync Synchronized PCI_PV_CH_EN (Read Only)
+ * 1 Channel Enabled
+ * 0 Channel Disabled
+ */
+#define TW5864_PCI_PV_CH_STATUS 0xc000
+/*
+ * [15:0] PCI Preview Path Enable for channel n
+ * 1 Channel Enable
+ * 0 Channel Disable
+ */
+#define TW5864_PCI_PV_CH_EN 0xc004
+
+/* 0xc800 ~ 0xc804 -- JPEG Capture Register Map */
+/* Skipped. */
+/* 0xd000 ~ 0xd0fc -- JPEG Control Register Map */
+/* Skipped. */
+
+/* 0xe000 ~ 0xfc04 – Motion Vector Register Map */
+
+/* ME Motion Vector data (Four Byte Each) 0xe000 ~ 0xe7fc */
+#define TW5864_ME_MV_VEC_START 0xe000
+#define TW5864_ME_MV_VEC_MAX_OFFSET 0x1ff
+#define TW5864_ME_MV_VEC(offset) (TW5864_ME_MV_VEC_START + 4 * offset)
+
+#define TW5864_MV 0xfc00
+/* Define controls in register TW5864_MV */
+/* mv bank0 full status , write "1" to clear */
+#define TW5864_MV_BK0_FULL BIT(0)
+/* mv bank1 full status , write "1" to clear */
+#define TW5864_MV_BK1_FULL BIT(1)
+/* slice end status; write "1" to clear */
+#define TW5864_MV_EOF BIT(2)
+/* mv encode interrupt status; write "1" to clear */
+#define TW5864_MV_DSP_INTR BIT(3)
+/* mv write memory overflow, write "1" to clear */
+#define TW5864_DSP_WR_OF BIT(4)
+#define TW5864_MV_LEN_SHIFT 5
+/* mv stream length */
+#define TW5864_MV_LEN (0xff << 5)
+/* The configured status bit written into bit 15 of 0xfc04 */
+#define TW5864_MPI_DDR_SEL BIT(13)
+
+#define TW5864_MPI_DDR_SEL_REG 0xfc04
+/* Define controls in register TW5864_MPI_DDR_SEL_REG */
+/*
+ * SW configure register
+ * 0 MV is saved in internal DPR
+ * 1 MV is saved in DDR
+ */
+#define TW5864_MPI_DDR_SEL2 BIT(15)
+
+/* 0x18000 ~ 0x181fc – PCI Master/Slave Control Map */
+#define TW5864_PCI_INTR_STATUS 0x18000
+/* Define controls in register TW5864_PCI_INTR_STATUS */
+/* vlc done */
+#define TW5864_VLC_DONE_INTR BIT(1)
+/* ad vsync */
+#define TW5864_AD_VSYNC_INTR BIT(3)
+/* preview eof */
+#define TW5864_PREV_EOF_INTR BIT(4)
+/* preview overflow interrupt */
+#define TW5864_PREV_OVERFLOW_INTR BIT(5)
+/* timer interrupt */
+#define TW5864_TIMER_INTR BIT(6)
+/* audio eof */
+#define TW5864_AUDIO_EOF_INTR BIT(8)
+/* IIC done */
+#define TW5864_IIC_DONE_INTR BIT(24)
+/* ad interrupt (e.g.: video lost, video format changed) */
+#define TW5864_AD_INTR_REG BIT(25)
+
+#define TW5864_PCI_INTR_CTL 0x18004
+/* Define controls in register TW5864_PCI_INTR_CTL */
+/* master enable */
+#define TW5864_PCI_MAST_ENB BIT(0)
+/* mvd&vlc master enable */
+#define TW5864_MVD_VLC_MAST_ENB 0x06
+/* (Need to set 0 in TW5864A) */
+#define TW5864_AD_MAST_ENB BIT(3)
+/* preview master enable */
+#define TW5864_PREV_MAST_ENB BIT(4)
+/* preview overflow enable */
+#define TW5864_PREV_OVERFLOW_ENB BIT(5)
+/* timer interrupt enable */
+#define TW5864_TIMER_INTR_ENB BIT(6)
+/* JPEG master (push mode) enable */
+#define TW5864_JPEG_MAST_ENB BIT(7)
+#define TW5864_AU_MAST_ENB_CHN_SHIFT 8
+/* audio master channel enable */
+#define TW5864_AU_MAST_ENB_CHN (0xffff << 8)
+/* IIC interrupt enable */
+#define TW5864_IIC_INTR_ENB BIT(24)
+/* ad interrupt enable */
+#define TW5864_AD_INTR_ENB BIT(25)
+/* target burst enable */
+#define TW5864_PCI_TAR_BURST_ENB BIT(26)
+/* vlc stream burst enable */
+#define TW5864_PCI_VLC_BURST_ENB BIT(27)
+/* ddr burst enable (1 enable, and must set DDR_BRST_EN) */
+#define TW5864_PCI_DDR_BURST_ENB BIT(28)
+
+/*
+ * Because preview and audio have 16 channels separately, so using this
+ * registers to indicate interrupt status for every channels. This is secondary
+ * interrupt status register. OR operating of the PREV_INTR_REG is
+ * PREV_EOF_INTR, OR operating of the AU_INTR_REG bits is AUDIO_EOF_INTR
+ */
+#define TW5864_PREV_AND_AU_INTR 0x18008
+/* Define controls in register TW5864_PREV_AND_AU_INTR */
+/* preview eof interrupt flag */
+#define TW5864_PREV_INTR_REG 0x0000ffff
+#define TW5864_AU_INTR_REG_SHIFT 16
+/* audio eof interrupt flag */
+#define TW5864_AU_INTR_REG (0xffff << 16)
+
+#define TW5864_MASTER_ENB_REG 0x1800c
+/* Define controls in register TW5864_MASTER_ENB_REG */
+/* master enable */
+#define TW5864_PCI_VLC_INTR_ENB BIT(1)
+/* mvd and vlc master enable */
+#define TW5864_PCI_PREV_INTR_ENB BIT(4)
+/* ad vsync master enable */
+#define TW5864_PCI_PREV_OF_INTR_ENB BIT(5)
+/* jpeg master enable */
+#define TW5864_PCI_JPEG_INTR_ENB BIT(7)
+/* preview master enable */
+#define TW5864_PCI_AUD_INTR_ENB BIT(8)
+
+/*
+ * Every channel of preview and audio have ping-pong buffers in system memory,
+ * this register is the buffer flag to notify software which buffer is been
+ * operated.
+ */
+#define TW5864_PREV_AND_AU_BUF_FLAG 0x18010
+/* Define controls in register TW5864_PREV_AND_AU_BUF_FLAG */
+/* preview buffer A/B flag */
+#define TW5864_PREV_BUF_FLAG 0xffff
+#define TW5864_AUDIO_BUF_FLAG_SHIFT 16
+/* audio buffer A/B flag */
+#define TW5864_AUDIO_BUF_FLAG (0xffff << 16)
+
+#define TW5864_IIC 0x18014
+/* Define controls in register TW5864_IIC */
+/* register data */
+#define TW5864_IIC_DATA 0x00ff
+#define TW5864_IIC_REG_ADDR_SHIFT 8
+/* register addr */
+#define TW5864_IIC_REG_ADDR (0xff << 8)
+/* rd/wr flag rd=1,wr=0 */
+#define TW5864_IIC_RW BIT(16)
+#define TW5864_IIC_DEV_ADDR_SHIFT 17
+/* device addr */
+#define TW5864_IIC_DEV_ADDR (0x7f << 17)
+/*
+ * iic done, software kick off one time iic transaction through setting this
+ * bit to 1. Then poll this bit, value 1 indicate iic transaction have
+ * completed, if read, valid data have been stored in iic_data
+ */
+#define TW5864_IIC_DONE BIT(24)
+
+#define TW5864_RST_AND_IF_INFO 0x18018
+/* Define controls in register TW5864_RST_AND_IF_INFO */
+/* application software soft reset */
+#define TW5864_APP_SOFT_RST BIT(0)
+#define TW5864_PCI_INF_VERSION_SHIFT 16
+/* PCI interface version, read only */
+#define TW5864_PCI_INF_VERSION (0xffff << 16)
+
+/* vlc stream crc value, it is calculated in pci module */
+#define TW5864_VLC_CRC_REG 0x1801c
+/*
+ * vlc max length, it is defined by software based on software assign memory
+ * space for vlc
+ */
+#define TW5864_VLC_MAX_LENGTH 0x18020
+/* vlc length of one frame */
+#define TW5864_VLC_LENGTH 0x18024
+/* vlc original crc value */
+#define TW5864_VLC_INTRA_CRC_I_REG 0x18028
+/* vlc original crc value */
+#define TW5864_VLC_INTRA_CRC_O_REG 0x1802c
+/* mv stream crc value, it is calculated in pci module */
+#define TW5864_VLC_PAR_CRC_REG 0x18030
+/* mv length */
+#define TW5864_VLC_PAR_LENGTH_REG 0x18034
+/* mv original crc value */
+#define TW5864_VLC_PAR_I_REG 0x18038
+/* mv original crc value */
+#define TW5864_VLC_PAR_O_REG 0x1803c
+
+/*
+ * Configuration register for 9[or 10] CIFs or 1D1+15QCIF Preview mode.
+ * PREV_PCI_ENB_CHN[0] Enable 9th preview channel (9CIF prev) or 1D1 channel in
+ * (1D1+15QCIF prev)
+ * PREV_PCI_ENB_CHN[1] Enable 10th preview channel
+ */
+#define TW5864_PREV_PCI_ENB_CHN 0x18040
+/* Description skipped. */
+#define TW5864_PREV_FRAME_FORMAT_IN 0x18044
+/* IIC enable */
+#define TW5864_IIC_ENB 0x18048
+/*
+ * Timer interrupt interval
+ * 0 1ms
+ * 1 2ms
+ * 2 4ms
+ * 3 8ms
+ */
+#define TW5864_PCI_INTTM_SCALE 0x1804c
+
+/*
+ * The above register is pci base address registers. Application software will
+ * initialize them to tell chip where the corresponding stream will be dumped
+ * to. Application software will select appropriate base address interval based
+ * on the stream length.
+ */
+/* VLC stream base address */
+#define TW5864_VLC_STREAM_BASE_ADDR 0x18080
+/* MV stream base address */
+#define TW5864_MV_STREAM_BASE_ADDR 0x18084
+/* 0x180a0 – 0x180bc: audio burst base address. Skipped. */
+/* 0x180c0 ~ 0x180dc – JPEG Push Mode Buffer Base Address. Skipped. */
+/* 0x18100 – 0x1817c: preview burst base address. Skipped. */
+
+/* 0x80000 ~ 0x87fff -- DDR Burst RW Register Map */
+#define TW5864_DDR_CTL 0x80000
+/* Define controls in register TW5864_DDR_CTL */
+#define TW5864_BRST_LENGTH_SHIFT 2
+/* Length of 32-bit data burst */
+#define TW5864_BRST_LENGTH (0x3fff << 2)
+/*
+ * Burst Read/Write
+ * 0 Read Burst from DDR
+ * 1 Write Burst to DDR
+ */
+#define TW5864_BRST_RW BIT(16)
+/* Begin a new DDR Burst. This bit is self cleared */
+#define TW5864_NEW_BRST_CMD BIT(17)
+/* DDR Burst End Flag */
+#define TW5864_BRST_END BIT(24)
+/* Enable Error Interrupt for Single DDR Access */
+#define TW5864_SING_ERR_INTR BIT(25)
+/* Enable Error Interrupt for Burst DDR Access */
+#define TW5864_BRST_ERR_INTR BIT(26)
+/* Enable Interrupt for End of DDR Burst Access */
+#define TW5864_BRST_END_INTR BIT(27)
+/* DDR Single Access Error Flag */
+#define TW5864_SINGLE_ERR BIT(28)
+/* DDR Single Access Busy Flag */
+#define TW5864_SINGLE_BUSY BIT(29)
+/* DDR Burst Access Error Flag */
+#define TW5864_BRST_ERR BIT(30)
+/* DDR Burst Access Busy Flag */
+#define TW5864_BRST_BUSY BIT(31)
+
+/* [27:0] DDR Access Address. Bit [1:0] has to be 0 */
+#define TW5864_DDR_ADDR 0x80004
+/* DDR Access Internal Buffer Address. Bit [1:0] has to be 0 */
+#define TW5864_DPR_BUF_ADDR 0x80008
+/* SRAM Buffer MPI Access Space. Totally 16 KB */
+#define TW5864_DPR_BUF_START 0x84000
+/* 0x84000 - 0x87ffc */
+#define TW5864_DPR_BUF_SIZE 0x4000
+
+/* Indirect Map Space */
+/*
+ * The indirect space is accessed through 0xb800 ~ 0xb807 registers in direct
+ * access space
+ */
+/* Analog Video / Audio Decoder / Encoder */
+/* Allowed channel values: [0; 3] */
+/* Read-only register */
+#define TW5864_INDIR_VIN_0(channel) (0x000 + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_0 */
+/*
+ * 1 Video not present. (sync is not detected in number of consecutive line
+ * periods specified by MISSCNT register)
+ * 0 Video detected.
+ */
+#define TW5864_INDIR_VIN_0_VDLOSS BIT(7)
+/*
+ * 1 Horizontal sync PLL is locked to the incoming video source.
+ * 0 Horizontal sync PLL is not locked.
+ */
+#define TW5864_INDIR_VIN_0_HLOCK BIT(6)
+/*
+ * 1 Sub-carrier PLL is locked to the incoming video source.
+ * 0 Sub-carrier PLL is not locked.
+ */
+#define TW5864_INDIR_VIN_0_SLOCK BIT(5)
+/*
+ * 1 Even field is being decoded.
+ * 0 Odd field is being decoded.
+ */
+#define TW5864_INDIR_VIN_0_FLD BIT(4)
+/*
+ * 1 Vertical logic is locked to the incoming video source.
+ * 0 Vertical logic is not locked.
+ */
+#define TW5864_INDIR_VIN_0_VLOCK BIT(3)
+/*
+ * 1 No color burst signal detected.
+ * 0 Color burst signal detected.
+ */
+#define TW5864_INDIR_VIN_0_MONO BIT(1)
+/*
+ * 0 60Hz source detected
+ * 1 50Hz source detected
+ * The actual vertical scanning frequency depends on the current standard
+ * invoked.
+ */
+#define TW5864_INDIR_VIN_0_DET50 BIT(0)
+
+#define TW5864_INDIR_VIN_1(channel) (0x001 + channel * 0x010)
+/* VCR signal indicator. Read-only. */
+#define TW5864_INDIR_VIN_1_VCR BIT(7)
+/* Weak signal indicator 2. Read-only. */
+#define TW5864_INDIR_VIN_1_WKAIR BIT(6)
+/* Weak signal indicator controlled by WKTH. Read-only. */
+#define TW5864_INDIR_VIN_1_WKAIR1 BIT(5)
+/*
+ * 1 = Standard signal
+ * 0 = Non-standard signal
+ * Read-only
+ */
+#define TW5864_INDIR_VIN_1_VSTD BIT(4)
+/*
+ * 1 = Non-interlaced signal
+ * 0 = interlaced signal
+ * Read-only
+ */
+#define TW5864_INDIR_VIN_1_NINTL BIT(3)
+/*
+ * Vertical Sharpness Control. Writable.
+ * 0 = None (default)
+ * 7 = Highest
+ * **Note: VSHP must be set to ‘0’ if COMB = 0
+ */
+#define TW5864_INDIR_VIN_1_VSHP 0x07
+
+/* HDELAY_XY[7:0] */
+#define TW5864_INDIR_VIN_2_HDELAY_XY_LO(channel) (0x002 + channel * 0x010)
+/* HACTIVE_XY[7:0] */
+#define TW5864_INDIR_VIN_3_HACTIVE_XY_LO(channel) (0x003 + channel * 0x010)
+/* VDELAY_XY[7:0] */
+#define TW5864_INDIR_VIN_4_VDELAY_XY_LO(channel) (0x004 + channel * 0x010)
+/* VACTIVE_XY[7:0] */
+#define TW5864_INDIR_VIN_5_VACTIVE_XY_LO(channel) (0x005 + channel * 0x010)
+
+#define TW5864_INDIR_VIN_6(channel) (0x006 + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_6 */
+#define TW5864_INDIR_VIN_6_HDELAY_XY_HI 0x03
+#define TW5864_INDIR_VIN_6_HACTIVE_XY_HI_SHIFT 2
+#define TW5864_INDIR_VIN_6_HACTIVE_XY_HI (0x03 << 2)
+#define TW5864_INDIR_VIN_6_VDELAY_XY_HI BIT(4)
+#define TW5864_INDIR_VIN_6_VACTIVE_XY_HI BIT(5)
+
+/*
+ * HDELAY_XY This 10bit register defines the starting location of horizontal
+ * active pixel for display / record path. A unit is 1 pixel. The default value
+ * is 0x00f for NTSC and 0x00a for PAL.
+ *
+ * HACTIVE_XY This 10bit register defines the number of horizontal active pixel
+ * for display / record path. A unit is 1 pixel. The default value is decimal
+ * 720.
+ *
+ * VDELAY_XY This 9bit register defines the starting location of vertical
+ * active for display / record path. A unit is 1 line. The default value is
+ * decimal 6.
+ *
+ * VACTIVE_XY This 9bit register defines the number of vertical active lines
+ * for display / record path. A unit is 1 line. The default value is decimal
+ * 240.
+ */
+
+/* HUE These bits control the color hue as 2's complement number. They have
+ * value from +36o (7Fh) to -36o (80h) with an increment of 2.8o. The 2 LSB has
+ * no effect. The positive value gives greenish tone and negative value gives
+ * purplish tone. The default value is 0o (00h). This is effective only on NTSC
+ * system. The default is 00h.
+ */
+#define TW5864_INDIR_VIN_7_HUE(channel) (0x007 + channel * 0x010)
+
+#define TW5864_INDIR_VIN_8(channel) (0x008 + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_8 */
+/*
+ * This bit controls the center frequency of the peaking filter.
+ * The corresponding gain adjustment is HFLT.
+ * 0 Low
+ * 1 center
+ */
+#define TW5864_INDIR_VIN_8_SCURVE BIT(7)
+/* CTI level selection. The default is 1.
+ * 0 None
+ * 3 Highest
+ */
+#define TW5864_INDIR_VIN_8_CTI_SHIFT 4
+#define TW5864_INDIR_VIN_8_CTI (0x03 << 4)
+
+/*
+ * These bits control the amount of sharpness enhancement on the luminance
+ * signals. There are 16 levels of control with "0" having no effect on the
+ * output image. 1 through 15 provides sharpness enhancement with "F" being the
+ * strongest. The default is 1.
+ */
+#define TW5864_INDIR_VIN_8_SHARPNESS 0x0f
+
+/*
+ * These bits control the luminance contrast gain. A value of 100 (64h) has a
+ * gain of 1. The range adjustment is from 0% to 255% at 1% per step. The
+ * default is 64h.
+ */
+#define TW5864_INDIR_VIN_9_CNTRST(channel) (0x009 + channel * 0x010)
+
+/*
+ * These bits control the brightness. They have value of –128 to 127 in 2's
+ * complement form. Positive value increases brightness. A value 0 has no
+ * effect on the data. The default is 00h.
+ */
+#define TW5864_INDIR_VIN_A_BRIGHT(channel) (0x00a + channel * 0x010)
+
+/*
+ * These bits control the digital gain adjustment to the U (or Cb) component of
+ * the digital video signal. The color saturation can be adjusted by adjusting
+ * the U and V color gain components by the same amount in the normal
+ * situation. The U and V can also be adjusted independently to provide greater
+ * flexibility. The range of adjustment is 0 to 200%. A value of 128 (80h) has
+ * gain of 100%. The default is 80h.
+ */
+#define TW5864_INDIR_VIN_B_SAT_U(channel) (0x00b + channel * 0x010)
+
+/*
+ * These bits control the digital gain adjustment to the V (or Cr) component of
+ * the digital video signal. The color saturation can be adjusted by adjusting
+ * the U and V color gain components by the same amount in the normal
+ * situation. The U and V can also be adjusted independently to provide greater
+ * flexibility. The range of adjustment is 0 to 200%. A value of 128 (80h) has
+ * gain of 100%. The default is 80h.
+ */
+#define TW5864_INDIR_VIN_C_SAT_V(channel) (0x00c + channel * 0x010)
+
+/* Read-only */
+#define TW5864_INDIR_VIN_D(channel) (0x00d + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_D */
+/* Macrovision color stripe detection may be un-reliable */
+#define TW5864_INDIR_VIN_D_CSBAD BIT(3)
+/* Macrovision AGC pulse detected */
+#define TW5864_INDIR_VIN_D_MCVSN BIT(2)
+/* Macrovision color stripe protection burst detected */
+#define TW5864_INDIR_VIN_D_CSTRIPE BIT(1)
+/*
+ * This bit is valid only when color stripe protection is detected, i.e. if
+ * CSTRIPE=1,
+ * 1 Type 2 color stripe protection
+ * 0 Type 3 color stripe protection
+ */
+#define TW5864_INDIR_VIN_D_CTYPE2 BIT(0)
+
+/* Read-only */
+#define TW5864_INDIR_VIN_E(channel) (0x00e + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_E */
+/*
+ * Read-only.
+ * 0 Idle
+ * 1 Detection in progress
+ */
+#define TW5864_INDIR_VIN_E_DETSTUS BIT(7)
+/*
+ * STDNOW Current standard invoked
+ * 0 NTSC (M)
+ * 1 PAL (B, D, G, H, I)
+ * 2 SECAM
+ * 3 NTSC4.43
+ * 4 PAL (M)
+ * 5 PAL (CN)
+ * 6 PAL 60
+ * 7 Not valid
+ */
+#define TW5864_INDIR_VIN_E_STDNOW_SHIFT 4
+#define TW5864_INDIR_VIN_E_STDNOW (0x07 << 4)
+
+/*
+ * 1 Disable the shadow registers
+ * 0 Enable VACTIVE and HDELAY shadow registers value depending on STANDARD.
+ * (Default)
+ */
+#define TW5864_INDIR_VIN_E_ATREG BIT(3)
+/*
+ * STANDARD Standard selection
+ * 0 NTSC (M)
+ * 1 PAL (B, D, G, H, I)
+ * 2 SECAM
+ * 3 NTSC4.43
+ * 4 PAL (M)
+ * 5 PAL (CN)
+ * 6 PAL 60
+ * 7 Auto detection (Default)
+ */
+#define TW5864_INDIR_VIN_E_STANDARD 0x07
+
+#define TW5864_INDIR_VIN_F(channel) (0x00f + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_F */
+/*
+ * 1 Writing 1 to this bit will manually initiate the auto format detection
+ * process. This bit is a self-clearing bit
+ * 0 Manual initiation of auto format detection is done. (Default)
+ */
+#define TW5864_INDIR_VIN_F_ATSTART BIT(7)
+/* Enable recognition of PAL60 (Default) */
+#define TW5864_INDIR_VIN_F_PAL60EN BIT(6)
+/* Enable recognition of PAL (CN). (Default) */
+#define TW5864_INDIR_VIN_F_PALCNEN BIT(5)
+/* Enable recognition of PAL (M). (Default) */
+#define TW5864_INDIR_VIN_F_PALMEN BIT(4)
+/* Enable recognition of NTSC 4.43. (Default) */
+#define TW5864_INDIR_VIN_F_NTSC44EN BIT(3)
+/* Enable recognition of SECAM. (Default) */
+#define TW5864_INDIR_VIN_F_SECAMEN BIT(2)
+/* Enable recognition of PAL (B, D, G, H, I). (Default) */
+#define TW5864_INDIR_VIN_F_PALBEN BIT(1)
+/* Enable recognition of NTSC (M). (Default) */
+#define TW5864_INDIR_VIN_F_NTSCEN BIT(0)
+
+/* Some registers skipped. */
+
+/* Use falling edge to sample VD1-VD4 from 54 MHz to 108 MHz */
+#define TW5864_INDIR_VD_108_POL 0x041
+#define TW5864_INDIR_VD_108_POL_VD12 BIT(0)
+#define TW5864_INDIR_VD_108_POL_VD34 BIT(1)
+#define TW5864_INDIR_VD_108_POL_BOTH \
+	(TW5864_INDIR_VD_108_POL_VD12 | TW5864_INDIR_VD_108_POL_VD34)
+
+/* Some registers skipped. */
+
+/*
+ * Audio Input ADC gain control
+ * 0 0.25
+ * 1 0.31
+ * 2 0.38
+ * 3 0.44
+ * 4 0.50
+ * 5 0.63
+ * 6 0.75
+ * 7 0.88
+ * 8 1.00 (default)
+ * 9 1.25
+ * 10 1.50
+ * 11 1.75
+ * 12 2.00
+ * 13 2.25
+ * 14 2.50
+ * 15 2.75
+ */
+/* [3:0] channel 0, [7:4] channel 1 */
+#define TW5864_INDIR_AIGAIN1 0x060
+/* [3:0] channel 2, [7:4] channel 3 */
+#define TW5864_INDIR_AIGAIN2 0x061
+
+/* Some registers skipped */
+
+#define TW5864_INDIR_AIN_0x06D 0x06d
+/* Define controls in register TW5864_INDIR_AIN_0x06D */
+/*
+ * LAWMD Select u-Law/A-Law/PCM/SB data output format on ADATR and ADATM pin.
+ * 0 PCM output (default)
+ * 1 SB (Signed MSB bit in PCM data is inverted) output
+ * 2 u-Law output
+ * 3 A-Law output
+ */
+#define TW5864_INDIR_AIN_LAWMD_SHIFT 6
+#define TW5864_INDIR_AIN_LAWMD (0x03 << 6)
+/*
+ * Disable the mixing ratio value for all audio.
+ * 0 Apply individual mixing ratio value for each audio (default)
+ * 1 Apply nominal value for all audio commonly
+ */
+#define TW5864_INDIR_AIN_MIX_DERATIO BIT(5)
+/*
+ * Enable the mute function for audio channel AINn when n is 0 to 3. It effects
+ * only for mixing. When n = 4, it enable the mute function of the playback
+ * audio input. It effects only for single chip or the last stage chip
+ * 0 Normal
+ * 1 Muted (default)
+ */
+#define TW5864_INDIR_AIN_MIX_MUTE 0x1f
+
+/* Some registers skipped */
+
+#define TW5864_INDIR_AIN_0x0E3 0x0e3
+/* Define controls in register TW5864_INDIR_AIN_0x0E3 */
+/*
+ * ADATP signal is coming from external ADPCM decoder, instead of on-chip ADPCM
+ * decoder
+ */
+#define TW5864_INDIR_AIN_0x0E3_EXT_ADATP BIT(7)
+/* ACLKP output signal polarity inverse */
+#define TW5864_INDIR_AIN_0x0E3_ACLKPPOLO BIT(6)
+/*
+ * ACLKR input signal polarity inverse.
+ * 0 Not inversed (Default)
+ * 1 Inversed
+ */
+#define TW5864_INDIR_AIN_0x0E3_ACLKRPOL BIT(5)
+/*
+ * ACLKP input signal polarity inverse.
+ * 0 Not inversed (Default)
+ * 1 Inversed
+ */
+#define TW5864_INDIR_AIN_0x0E3_ACLKPPOLI BIT(4)
+/*
+ * ACKI [21:0] control automatic set up with AFMD registers
+ * This mode is only effective when ACLKRMASTER=1
+ * 0 ACKI [21:0] registers set up ACKI control
+ * 1 ACKI control is automatically set up by AFMD register values
+ */
+#define TW5864_INDIR_AIN_0x0E3_AFAUTO BIT(3)
+/*
+ * AFAUTO control mode
+ * 0 8kHz setting (Default)
+ * 1 16kHz setting
+ * 2 32kHz setting
+ * 3 44.1kHz setting
+ * 4 48kHz setting
+ */
+#define TW5864_INDIR_AIN_0x0E3_AFMD 0x07
+
+#define TW5864_INDIR_AIN_0x0E4 0x0e4
+/* Define controls in register TW5864_INDIR_AIN_0x0ED */
+/*
+ * 8bit I2S Record output mode.
+ * 0 L/R half length separated output (Default).
+ * 1 One continuous packed output equal to DSP output format.
+ */
+#define TW5864_INDIR_AIN_0x0E4_I2S8MODE BIT(7)
+/*
+ * Audio Clock Master ACLKR output wave format.
+ * 0 High periods is one 27MHz clock period (default).
+ * 1 Almost duty 50-50% clock output on ACLKR pin. If this mode is selected, two
+ * times bigger number value need to be set up on the ACKI register. If
+ * AFAUTO=1, ACKI control is automatically set up even if MASCKMD=1.
+ */
+#define TW5864_INDIR_AIN_0x0E4_MASCKMD BIT(6)
+/* Playback ACLKP/ASYNP/ADATP input data MSB-LSB swapping */
+#define TW5864_INDIR_AIN_0x0E4_PBINSWAP BIT(5)
+/*
+ * ASYNR input signal delay.
+ * 0 No delay
+ * 1 Add one 27MHz period delay in ASYNR signal input
+ */
+#define TW5864_INDIR_AIN_0x0E4_ASYNRDLY BIT(4)
+/*
+ * ASYNP input signal delay.
+ * 0 no delay
+ * 1 add one 27MHz period delay in ASYNP signal input
+ */
+#define TW5864_INDIR_AIN_0x0E4_ASYNPDLY BIT(3)
+/*
+ * ADATP input data delay by one ACLKP clock.
+ * 0 No delay (Default). This is for I2S type 1T delay input interface.
+ * 1 Add 1 ACLKP clock delay in ADATP input data. This is for left-justified
+ * type 0T delay input interface.
+ */
+#define TW5864_INDIR_AIN_0x0E4_ADATPDLY BIT(2)
+/*
+ * Select u-Law/A-Law/PCM/SB data input format on ADATP pin.
+ * 0 PCM input (Default)
+ * 1 SB (Signed MSB bit in PCM data is inverted) input
+ * 2 u-Law input
+ * 3 A-Law input
+ */
+#define TW5864_INDIR_AIN_0x0E4_INLAWMD 0x03
+
+/*
+ * Enable state register updating and interrupt request of audio AIN5 detection
+ * for each input
+ */
+#define TW5864_INDIR_AIN_A5DETENA 0x0e5
+
+/* Some registers skipped */
+
+/*
+ * [7:3]: DEV_ID The TW5864 product ID code is 01000
+ * [2:0]: REV_ID The revision number is 0h
+ */
+#define TW5864_INDIR_ID 0x0fe
+
+#define TW5864_INDIR_IN_PIC_WIDTH(channel) (0x200 + 4 * channel)
+#define TW5864_INDIR_IN_PIC_HEIGHT(channel) (0x201 + 4 * channel)
+#define TW5864_INDIR_OUT_PIC_WIDTH(channel) (0x202 + 4 * channel)
+#define TW5864_INDIR_OUT_PIC_HEIGHT(channel) (0x203 + 4 * channel)
+/*
+ * Interrupt status register from the front-end. Write "1" to each bit to clear
+ * the interrupt
+ * 15:0 Motion detection interrupt for channel 0 ~ 15
+ * 31:16 Night detection interrupt for channel 0 ~ 15
+ * 47:32 Blind detection interrupt for channel 0 ~ 15
+ * 63:48 No video interrupt for channel 0 ~ 15
+ * 79:64 Line mode underflow interrupt for channel 0 ~ 15
+ * 95:80 Line mode overflow interrupt for channel 0 ~ 15
+ */
+/* 0x2d0~0x2d7: [63:0] bits */
+#define TW5864_INDIR_INTERRUPT1 0x2d0
+/* 0x2e0~0x2e3: [95:64] bits */
+#define TW5864_INDIR_INTERRUPT2 0x2e0
+
+/*
+ * Interrupt mask register for interrupts in 0x2d0 ~ 0x2d7
+ * 15:0 Motion detection interrupt for channel 0 ~ 15
+ * 31:16 Night detection interrupt for channel 0 ~ 15
+ * 47:32 Blind detection interrupt for channel 0 ~ 15
+ * 63:48 No video interrupt for channel 0 ~ 15
+ * 79:64 Line mode underflow interrupt for channel 0 ~ 15
+ * 95:80 Line mode overflow interrupt for channel 0 ~ 15
+ */
+/* 0x2d8~0x2df: [63:0] bits */
+#define TW5864_INDIR_INTERRUPT_MASK1 0x2d8
+/* 0x2e8~0x2eb: [95:64] bits */
+#define TW5864_INDIR_INTERRUPT_MASK2 0x2e8
+
+/* [11:0]: Interrupt summary register for interrupts & interrupt mask from in
+ * 0x2d0 ~ 0x2d7 and 0x2d8 ~ 0x2df
+ * bit 0: interrupt occurs in 0x2d0 & 0x2d8
+ * bit 1: interrupt occurs in 0x2d1 & 0x2d9
+ * bit 2: interrupt occurs in 0x2d2 & 0x2da
+ * bit 3: interrupt occurs in 0x2d3 & 0x2db
+ * bit 4: interrupt occurs in 0x2d4 & 0x2dc
+ * bit 5: interrupt occurs in 0x2d5 & 0x2dd
+ * bit 6: interrupt occurs in 0x2d6 & 0x2de
+ * bit 7: interrupt occurs in 0x2d7 & 0x2df
+ * bit 8: interrupt occurs in 0x2e0 & 0x2e8
+ * bit 9: interrupt occurs in 0x2e1 & 0x2e9
+ * bit 10: interrupt occurs in 0x2e2 & 0x2ea
+ * bit 11: interrupt occurs in 0x2e3 & 0x2eb
+ */
+#define TW5864_INDIR_INTERRUPT_SUMMARY 0x2f0
+
+/* Motion / Blind / Night Detection */
+/* valid value for channel is [0:15] */
+#define TW5864_INDIR_DETECTION_CTL0(channel) (0x300 + channel * 0x08)
+/* Define controls in register TW5864_INDIR_DETECTION_CTL0 */
+/*
+ * Disable the motion and blind detection.
+ * 0 Enable motion and blind detection (default)
+ * 1 Disable motion and blind detection
+ */
+#define TW5864_INDIR_DETECTION_CTL0_MD_DIS BIT(5)
+/*
+ * Request to start motion detection on manual trigger mode
+ * 0 None Operation (default)
+ * 1 Request to start motion detection
+ */
+#define TW5864_INDIR_DETECTION_CTL0_MD_STRB BIT(3)
+/*
+ * Select the trigger mode of motion detection
+ * 0 Automatic trigger mode of motion detection (default)
+ * 1 Manual trigger mode for motion detection
+ */
+#define TW5864_INDIR_DETECTION_CTL0_MD_STRB_EN BIT(2)
+/*
+ * Define the threshold of cell for blind detection.
+ * 0 Low threshold (More sensitive) (default)
+ * : :
+ * 3 High threshold (Less sensitive)
+ */
+#define TW5864_INDIR_DETECTION_CTL0_BD_CELSENS 0x03
+
+#define TW5864_INDIR_DETECTION_CTL1(channel) (0x301 + channel * 0x08)
+/* Define controls in register TW5864_INDIR_DETECTION_CTL1 */
+/*
+ * Control the temporal sensitivity of motion detector.
+ * 0 More Sensitive (default)
+ * : :
+ * 15 Less Sensitive
+ */
+#define TW5864_INDIR_DETECTION_CTL1_MD_TMPSENS_SHIFT 4
+#define TW5864_INDIR_DETECTION_CTL1_MD_TMPSENS (0x0f << 4)
+/*
+ * Adjust the horizontal starting position for motion detection
+ * 0 0 pixel (default)
+ * : :
+ * 15 15 pixels
+ */
+#define TW5864_INDIR_DETECTION_CTL1_MD_PIXEL_OS 0x0f
+
+#define TW5864_INDIR_DETECTION_CTL2(channel) (0x302 + channel * 0x08)
+/* Define controls in register TW5864_INDIR_DETECTION_CTL2 */
+/*
+ * Control the updating time of reference field for motion detection.
+ * 0 Update reference field every field (default)
+ * 1 Update reference field according to MD_SPEED
+ */
+#define TW5864_INDIR_DETECTION_CTL2_MD_REFFLD BIT(7)
+/*
+ * Select the field for motion detection.
+ * 0 Detecting motion for only odd field (default)
+ * 1 Detecting motion for only even field
+ * 2 Detecting motion for any field
+ * 3 Detecting motion for both odd and even field
+ */
+#define TW5864_INDIR_DETECTION_CTL2_MD_FIELD_SHIFT 5
+#define TW5864_INDIR_DETECTION_CTL2_MD_FIELD (0x03 << 5)
+/*
+ * Control the level sensitivity of motion detector.
+ * 0 More sensitive (default)
+ * : :
+ * 15 Less sensitive
+ */
+#define TW5864_INDIR_DETECTION_CTL2_MD_LVSENS 0x1f
+
+#define TW5864_INDIR_DETECTION_CTL3(channel) (0x303 + channel * 0x08)
+/* Define controls in register TW5864_INDIR_DETECTION_CTL3 */
+/*
+ * Define the threshold of sub-cell number for motion detection.
+ * 0 Motion is detected if 1 sub-cell has motion (More sensitive) (default)
+ * 1 Motion is detected if 2 sub-cells have motion
+ * 2 Motion is detected if 3 sub-cells have motion
+ * 3 Motion is detected if 4 sub-cells have motion (Less sensitive)
+ */
+#define TW5864_INDIR_DETECTION_CTL3_MD_CELSENS_SHIFT 6
+#define TW5864_INDIR_DETECTION_CTL3_MD_CELSENS (0x03 << 6)
+/*
+ * Control the velocity of motion detector.
+ * Large value is suitable for slow motion detection.
+ * In MD_DUAL_EN = 1, MD_SPEED should be limited to 0 ~ 31.
+ * 0 1 field intervals (default)
+ * 1 2 field intervals
+ * : :
+ * 61 62 field intervals
+ * 62 63 field intervals
+ * 63 Not supported
+ */
+#define TW5864_INDIR_DETECTION_CTL3_MD_SPEED 0x3f
+
+#define TW5864_INDIR_DETECTION_CTL4(channel) (0x304 + channel * 0x08)
+/* Define controls in register TW5864_INDIR_DETECTION_CTL4 */
+/*
+ * Control the spatial sensitivity of motion detector.
+ * 0 More Sensitive (default)
+ * : :
+ * 15 Less Sensitive
+ */
+#define TW5864_INDIR_DETECTION_CTL4_MD_SPSENS_SHIFT 4
+#define TW5864_INDIR_DETECTION_CTL4_MD_SPSENS (0x0f << 4)
+/*
+ * Define the threshold of level for blind detection.
+ * 0 Low threshold (More sensitive) (default)
+ * : :
+ * 15 High threshold (Less sensitive)
+ */
+#define TW5864_INDIR_DETECTION_CTL4_BD_LVSENS 0x0f
+
+#define TW5864_INDIR_DETECTION_CTL5(channel) (0x305 + channel * 0x08)
+/*
+ * Define the threshold of temporal sensitivity for night detection.
+ * 0 Low threshold (More sensitive) (default)
+ * : :
+ * 15 High threshold (Less sensitive)
+ */
+#define TW5864_INDIR_DETECTION_CTL5_ND_TMPSENS_SHIFT 4
+#define TW5864_INDIR_DETECTION_CTL5_ND_TMPSENS (0x0f << 4)
+/*
+ * Define the threshold of level for night detection.
+ * 0 Low threshold (More sensitive) (default)
+ * : :
+ * 3 High threshold (Less sensitive)
+ */
+#define TW5864_INDIR_DETECTION_CTL5_ND_LVSENS 0x0f
+
+/*
+ * [11:0] The base address of the motion detection buffer. This address is in
+ * unit of 64K bytes. The generated DDR address will be {MD_BASE_ADDR,
+ * 16"h0000}. The default value should be 12"h000
+ */
+#define TW5864_INDIR_MD_BASE_ADDR 0x380
+
+/*
+ * This controls the channel of the motion detection result shown in register
+ * 0x3a0 ~ 0x3b7. Before reading back motion result, always set this first.
+ */
+#define TW5864_INDIR_RGR_MOTION_SEL 0x382
+
+/* [15:0] MD strobe has been performed at channel n (read only) */
+#define TW5864_INDIR_MD_STRB 0x386
+/* NO_VIDEO Detected from channel n (read only) */
+#define TW5864_INDIR_NOVID_DET 0x388
+/* Motion Detected from channel n (read only) */
+#define TW5864_INDIR_MD_DET 0x38a
+/* Blind Detected from channel n (read only) */
+#define TW5864_INDIR_BD_DET 0x38c
+/* Night Detected from channel n (read only) */
+#define TW5864_INDIR_ND_DET 0x38e
+
+/* 192 bit motion flag of the channel specified by RGR_MOTION_SEL in 0x382 */
+#define TW5864_INDIR_MOTION_FLAG 0x3a0
+#define TW5864_INDIR_MOTION_FLAG_BYTE_COUNT 24
+
+/*
+ * [9:0] The motion cell count of a specific channel selected by 0x382. This is
+ * for DI purpose
+ */
+#define TW5864_INDIR_MD_DI_CNT 0x3b8
+/* The motion detection cell sensitivity for DI purpose */
+#define TW5864_INDIR_MD_DI_CELLSENS 0x3ba
+/* The motion detection threshold level for DI purpose */
+#define TW5864_INDIR_MD_DI_LVSENS 0x3bb
+
+/* 192 bit motion mask of the channel specified by MASK_CH_SEL in 0x3fe */
+#define TW5864_INDIR_MOTION_MASK 0x3e0
+#define TW5864_INDIR_MOTION_MASK_BYTE_COUNT 24
+
+/* [4:0] The channel selection to access masks in 0x3e0 ~ 0x3f7 */
+#define TW5864_INDIR_MASK_CH_SEL 0x3fe
+
+/* Clock PLL / Analog IP Control */
+/* Some registers skipped */
+
+#define TW5864_INDIR_DDRA_DLL_DQS_SEL0 0xee6
+#define TW5864_INDIR_DDRA_DLL_DQS_SEL1 0xee7
+#define TW5864_INDIR_DDRA_DLL_CLK90_SEL 0xee8
+#define TW5864_INDIR_DDRA_DLL_TEST_SEL_AND_TAP_S 0xee9
+
+#define TW5864_INDIR_DDRB_DLL_DQS_SEL0 0xeeb
+#define TW5864_INDIR_DDRB_DLL_DQS_SEL1 0xeec
+#define TW5864_INDIR_DDRB_DLL_CLK90_SEL 0xeed
+#define TW5864_INDIR_DDRB_DLL_TEST_SEL_AND_TAP_S 0xeee
+
+#define TW5864_INDIR_RESET 0xef0
+#define TW5864_INDIR_RESET_VD BIT(7)
+#define TW5864_INDIR_RESET_DLL BIT(6)
+#define TW5864_INDIR_RESET_MUX_CORE BIT(5)
+
+#define TW5864_INDIR_PV_VD_CK_POL 0xefd
+#define TW5864_INDIR_PV_VD_CK_POL_PV(channel) BIT(channel)
+#define TW5864_INDIR_PV_VD_CK_POL_VD(channel) BIT(channel + 4)
+
+#define TW5864_INDIR_CLK0_SEL 0xefe
+#define TW5864_INDIR_CLK0_SEL_VD_SHIFT 0
+#define TW5864_INDIR_CLK0_SEL_VD_MASK 0x3
+#define TW5864_INDIR_CLK0_SEL_PV_SHIFT 2
+#define TW5864_INDIR_CLK0_SEL_PV_MASK (0x3 << 2)
+#define TW5864_INDIR_CLK0_SEL_PV2_SHIFT 4
+#define TW5864_INDIR_CLK0_SEL_PV2_MASK (0x3 << 4)
diff --git a/drivers/media/pci/tw5864/tw5864-util.c b/drivers/media/pci/tw5864/tw5864-util.c
new file mode 100644
index 0000000..771eef2
--- /dev/null
+++ b/drivers/media/pci/tw5864/tw5864-util.c
@@ -0,0 +1,37 @@
+#include "tw5864.h"
+
+void tw5864_indir_writeb(struct tw5864_dev *dev, u16 addr, u8 data)
+{
+	int retries = 30000;
+
+	while (tw_readl(TW5864_IND_CTL) & BIT(31) && --retries)
+		;
+	if (!retries)
+		dev_err(&dev->pci->dev,
+			"tw_indir_writel() retries exhausted before writing\n");
+
+	tw_writel(TW5864_IND_DATA, data);
+	tw_writel(TW5864_IND_CTL, addr << 2 | TW5864_RW | TW5864_ENABLE);
+}
+
+u8 tw5864_indir_readb(struct tw5864_dev *dev, u16 addr)
+{
+	int retries = 30000;
+
+	while (tw_readl(TW5864_IND_CTL) & BIT(31) && --retries)
+		;
+	if (!retries)
+		dev_err(&dev->pci->dev,
+			"tw_indir_readl() retries exhausted before reading\n");
+
+	tw_writel(TW5864_IND_CTL, addr << 2 | TW5864_ENABLE);
+
+	retries = 30000;
+	while (tw_readl(TW5864_IND_CTL) & BIT(31) && --retries)
+		;
+	if (!retries)
+		dev_err(&dev->pci->dev,
+			"tw_indir_readl() retries exhausted at reading\n");
+
+	return tw_readl(TW5864_IND_DATA);
+}
diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
new file mode 100644
index 0000000..dce0256
--- /dev/null
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -0,0 +1,1521 @@
+/*
+ *  TW5864 driver - video encoding functions
+ *
+ *  Copyright (C) 2016 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "tw5864.h"
+#include "tw5864-reg.h"
+
+#define QUANTIZATION_TABLE_LEN 96
+#define VLC_LOOKUP_TABLE_LEN 1024
+
+static const u16 forward_quantization_table[QUANTIZATION_TABLE_LEN] = {
+	0x3333, 0x1f82, 0x3333, 0x1f82, 0x1f82, 0x147b, 0x1f82, 0x147b,
+	0x3333, 0x1f82, 0x3333, 0x1f82, 0x1f82, 0x147b, 0x1f82, 0x147b,
+	0x2e8c, 0x1d42, 0x2e8c, 0x1d42, 0x1d42, 0x1234, 0x1d42, 0x1234,
+	0x2e8c, 0x1d42, 0x2e8c, 0x1d42, 0x1d42, 0x1234, 0x1d42, 0x1234,
+	0x2762, 0x199a, 0x2762, 0x199a, 0x199a, 0x1062, 0x199a, 0x1062,
+	0x2762, 0x199a, 0x2762, 0x199a, 0x199a, 0x1062, 0x199a, 0x1062,
+	0x2492, 0x16c1, 0x2492, 0x16c1, 0x16c1, 0x0e3f, 0x16c1, 0x0e3f,
+	0x2492, 0x16c1, 0x2492, 0x16c1, 0x16c1, 0x0e3f, 0x16c1, 0x0e3f,
+	0x2000, 0x147b, 0x2000, 0x147b, 0x147b, 0x0d1b, 0x147b, 0x0d1b,
+	0x2000, 0x147b, 0x2000, 0x147b, 0x147b, 0x0d1b, 0x147b, 0x0d1b,
+	0x1c72, 0x11cf, 0x1c72, 0x11cf, 0x11cf, 0x0b4d, 0x11cf, 0x0b4d,
+	0x1c72, 0x11cf, 0x1c72, 0x11cf, 0x11cf, 0x0b4d, 0x11cf, 0x0b4d
+};
+
+static const u16 inverse_quantization_table[QUANTIZATION_TABLE_LEN] = {
+	0x800a, 0x800d, 0x800a, 0x800d, 0x800d, 0x8010, 0x800d, 0x8010,
+	0x800a, 0x800d, 0x800a, 0x800d, 0x800d, 0x8010, 0x800d, 0x8010,
+	0x800b, 0x800e, 0x800b, 0x800e, 0x800e, 0x8012, 0x800e, 0x8012,
+	0x800b, 0x800e, 0x800b, 0x800e, 0x800e, 0x8012, 0x800e, 0x8012,
+	0x800d, 0x8010, 0x800d, 0x8010, 0x8010, 0x8014, 0x8010, 0x8014,
+	0x800d, 0x8010, 0x800d, 0x8010, 0x8010, 0x8014, 0x8010, 0x8014,
+	0x800e, 0x8012, 0x800e, 0x8012, 0x8012, 0x8017, 0x8012, 0x8017,
+	0x800e, 0x8012, 0x800e, 0x8012, 0x8012, 0x8017, 0x8012, 0x8017,
+	0x8010, 0x8014, 0x8010, 0x8014, 0x8014, 0x8019, 0x8014, 0x8019,
+	0x8010, 0x8014, 0x8010, 0x8014, 0x8014, 0x8019, 0x8014, 0x8019,
+	0x8012, 0x8017, 0x8012, 0x8017, 0x8017, 0x801d, 0x8017, 0x801d,
+	0x8012, 0x8017, 0x8012, 0x8017, 0x8017, 0x801d, 0x8017, 0x801d
+};
+
+static const u16 encoder_vlc_lookup_table[VLC_LOOKUP_TABLE_LEN] = {
+	0x011, 0x000, 0x000, 0x000, 0x065, 0x021, 0x000, 0x000, 0x087, 0x064,
+	0x031, 0x000, 0x097, 0x086, 0x075, 0x053, 0x0a7, 0x096, 0x085, 0x063,
+	0x0b7, 0x0a6, 0x095, 0x074, 0x0df, 0x0b6, 0x0a5, 0x084, 0x0db, 0x0de,
+	0x0b5, 0x094, 0x0d8, 0x0da, 0x0dd, 0x0a4, 0x0ef, 0x0ee, 0x0d9, 0x0b4,
+	0x0eb, 0x0ea, 0x0ed, 0x0dc, 0x0ff, 0x0fe, 0x0e9, 0x0ec, 0x0fb, 0x0fa,
+	0x0fd, 0x0e8, 0x10f, 0x0f1, 0x0f9, 0x0fc, 0x10b, 0x10e, 0x10d, 0x0f8,
+	0x107, 0x10a, 0x109, 0x10c, 0x104, 0x106, 0x105, 0x108, 0x023, 0x000,
+	0x000, 0x000, 0x06b, 0x022, 0x000, 0x000, 0x067, 0x057, 0x033, 0x000,
+	0x077, 0x06a, 0x069, 0x045, 0x087, 0x066, 0x065, 0x044, 0x084, 0x076,
+	0x075, 0x056, 0x097, 0x086, 0x085, 0x068, 0x0bf, 0x096, 0x095, 0x064,
+	0x0bb, 0x0be, 0x0bd, 0x074, 0x0cf, 0x0ba, 0x0b9, 0x094, 0x0cb, 0x0ce,
+	0x0cd, 0x0bc, 0x0c8, 0x0ca, 0x0c9, 0x0b8, 0x0df, 0x0de, 0x0dd, 0x0cc,
+	0x0db, 0x0da, 0x0d9, 0x0dc, 0x0d7, 0x0eb, 0x0d6, 0x0d8, 0x0e9, 0x0e8,
+	0x0ea, 0x0d1, 0x0e7, 0x0e6, 0x0e5, 0x0e4, 0x04f, 0x000, 0x000, 0x000,
+	0x06f, 0x04e, 0x000, 0x000, 0x06b, 0x05f, 0x04d, 0x000, 0x068, 0x05c,
+	0x05e, 0x04c, 0x07f, 0x05a, 0x05b, 0x04b, 0x07b, 0x058, 0x059, 0x04a,
+	0x079, 0x06e, 0x06d, 0x049, 0x078, 0x06a, 0x069, 0x048, 0x08f, 0x07e,
+	0x07d, 0x05d, 0x08b, 0x08e, 0x07a, 0x06c, 0x09f, 0x08a, 0x08d, 0x07c,
+	0x09b, 0x09e, 0x089, 0x08c, 0x098, 0x09a, 0x09d, 0x088, 0x0ad, 0x097,
+	0x099, 0x09c, 0x0a9, 0x0ac, 0x0ab, 0x0aa, 0x0a5, 0x0a8, 0x0a7, 0x0a6,
+	0x0a1, 0x0a4, 0x0a3, 0x0a2, 0x021, 0x000, 0x000, 0x000, 0x067, 0x011,
+	0x000, 0x000, 0x064, 0x066, 0x031, 0x000, 0x063, 0x073, 0x072, 0x065,
+	0x062, 0x083, 0x082, 0x070, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x011, 0x010,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x011, 0x021, 0x020, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x023, 0x022, 0x021, 0x020, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x023, 0x022, 0x021, 0x031,
+	0x030, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x023, 0x022, 0x033, 0x032, 0x031, 0x030, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x023, 0x030,
+	0x031, 0x033, 0x032, 0x035, 0x034, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x037, 0x036, 0x035, 0x034, 0x033, 0x032,
+	0x031, 0x041, 0x051, 0x061, 0x071, 0x081, 0x091, 0x0a1, 0x0b1, 0x000,
+	0x002, 0x000, 0x0e4, 0x011, 0x0f4, 0x002, 0x024, 0x003, 0x005, 0x012,
+	0x034, 0x013, 0x065, 0x024, 0x013, 0x063, 0x015, 0x022, 0x075, 0x034,
+	0x044, 0x023, 0x023, 0x073, 0x054, 0x033, 0x033, 0x004, 0x043, 0x014,
+	0x011, 0x043, 0x014, 0x001, 0x025, 0x015, 0x035, 0x025, 0x064, 0x055,
+	0x045, 0x035, 0x074, 0x065, 0x085, 0x0d5, 0x012, 0x095, 0x055, 0x045,
+	0x095, 0x0e5, 0x084, 0x075, 0x022, 0x0a5, 0x094, 0x085, 0x032, 0x0b5,
+	0x003, 0x0c5, 0x001, 0x044, 0x0a5, 0x032, 0x0b5, 0x094, 0x0c5, 0x0a4,
+	0x0a4, 0x054, 0x0d5, 0x0b4, 0x0b4, 0x064, 0x0f5, 0x0f5, 0x053, 0x0d4,
+	0x0e5, 0x0c4, 0x105, 0x105, 0x0c4, 0x074, 0x063, 0x0e4, 0x0d4, 0x084,
+	0x073, 0x0f4, 0x004, 0x005, 0x000, 0x053, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x011, 0x021, 0x031, 0x030, 0x011, 0x021, 0x020, 0x000,
+	0x011, 0x010, 0x000, 0x000, 0x011, 0x033, 0x032, 0x043, 0x042, 0x053,
+	0x052, 0x063, 0x062, 0x073, 0x072, 0x083, 0x082, 0x093, 0x092, 0x091,
+	0x037, 0x036, 0x035, 0x034, 0x033, 0x045, 0x044, 0x043, 0x042, 0x053,
+	0x052, 0x063, 0x062, 0x061, 0x060, 0x000, 0x045, 0x037, 0x036, 0x035,
+	0x044, 0x043, 0x034, 0x033, 0x042, 0x053, 0x052, 0x061, 0x051, 0x060,
+	0x000, 0x000, 0x053, 0x037, 0x045, 0x044, 0x036, 0x035, 0x034, 0x043,
+	0x033, 0x042, 0x052, 0x051, 0x050, 0x000, 0x000, 0x000, 0x045, 0x044,
+	0x043, 0x037, 0x036, 0x035, 0x034, 0x033, 0x042, 0x051, 0x041, 0x050,
+	0x000, 0x000, 0x000, 0x000, 0x061, 0x051, 0x037, 0x036, 0x035, 0x034,
+	0x033, 0x032, 0x041, 0x031, 0x060, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x061, 0x051, 0x035, 0x034, 0x033, 0x023, 0x032, 0x041, 0x031, 0x060,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x061, 0x041, 0x051, 0x033,
+	0x023, 0x022, 0x032, 0x031, 0x060, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x061, 0x060, 0x041, 0x023, 0x022, 0x031, 0x021, 0x051,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x051, 0x050,
+	0x031, 0x023, 0x022, 0x021, 0x041, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x040, 0x041, 0x031, 0x032, 0x011, 0x033,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x040, 0x041, 0x021, 0x011, 0x031, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x030, 0x031, 0x011, 0x021,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x020, 0x021, 0x011, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x010, 0x011,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000
+};
+
+static const unsigned int lambda_lookup_table[] = {
+	0x0020, 0x0020, 0x0020, 0x0020, 0x0020, 0x0020, 0x0020, 0x0020,
+	0x0020, 0x0020, 0x0020, 0x0020, 0x0020, 0x0020, 0x0020, 0x0020,
+	0x0040, 0x0040, 0x0040, 0x0040, 0x0060, 0x0060, 0x0060, 0x0080,
+	0x0080, 0x0080, 0x00a0, 0x00c0, 0x00c0, 0x00e0, 0x0100, 0x0120,
+	0x0140, 0x0160, 0x01a0, 0x01c0, 0x0200, 0x0240, 0x0280, 0x02e0,
+	0x0320, 0x03a0, 0x0400, 0x0480, 0x0500, 0x05a0, 0x0660, 0x0720,
+	0x0800, 0x0900, 0x0a20, 0x0b60
+};
+
+static const unsigned int intra4x4_lambda3[] = {
+	1, 1, 1, 1, 1, 1, 1, 1,
+	1, 1, 1, 1, 1, 1, 1, 1,
+	2, 2, 2, 2, 3, 3, 3, 4,
+	4, 4, 5, 6, 6, 7, 8, 9,
+	10, 11, 13, 14, 16, 18, 20, 23,
+	25, 29, 32, 36, 40, 45, 51, 57,
+	64, 72, 81, 91
+};
+
+static v4l2_std_id tw5864_get_v4l2_std(enum tw5864_vid_std std);
+static enum tw5864_vid_std tw5864_from_v4l2_std(v4l2_std_id v4l2_std);
+
+static void tw5864_handle_frame_task(unsigned long data);
+static void tw5864_handle_frame(struct tw5864_h264_frame *frame);
+static void tw5864_frame_interval_set(struct tw5864_input *input);
+
+static int tw5864_queue_setup(struct vb2_queue *q, unsigned int *num_buffers,
+			      unsigned int *num_planes, unsigned int sizes[],
+			      struct device *alloc_ctxs[])
+{
+	if (*num_planes)
+		return sizes[0] < H264_VLC_BUF_SIZE ? -EINVAL : 0;
+
+	sizes[0] = H264_VLC_BUF_SIZE;
+	*num_planes = 1;
+
+	return 0;
+}
+
+static void tw5864_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct tw5864_input *dev = vb2_get_drv_priv(vq);
+	struct tw5864_buf *buf = container_of(vbuf, struct tw5864_buf, vb);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->slock, flags);
+	list_add_tail(&buf->list, &dev->active);
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+static int tw5864_input_std_get(struct tw5864_input *input,
+				enum tw5864_vid_std *std_arg)
+{
+	struct tw5864_dev *dev = input->root;
+	enum tw5864_vid_std std;
+	u8 std_reg = tw_indir_readb(TW5864_INDIR_VIN_E(input->nr));
+
+	std = (std_reg & 0x70) >> 4;
+
+	if (std_reg & 0x80) {
+		dev_err(&dev->pci->dev,
+			"Video format detection is in progress, please wait\n");
+		return -EAGAIN;
+	}
+
+	if (std == STD_INVALID) {
+		dev_err(&dev->pci->dev, "No valid video format detected\n");
+		return -EPERM;
+	}
+
+	*std_arg = std;
+	return 0;
+}
+
+static int tw5864_enable_input(struct tw5864_input *input)
+{
+	struct tw5864_dev *dev = input->root;
+	int nr = input->nr;
+	unsigned long flags;
+	int d1_width = 720;
+	int d1_height;
+	int frame_width_bus_value = 0;
+	int frame_height_bus_value = 0;
+	int reg_frame_bus = 0x1c;
+	int fmt_reg_value = 0;
+	int downscale_enabled = 0;
+
+	dev_dbg(&dev->pci->dev, "Enabling channel %d\n", nr);
+
+	input->frame_seqno = 0;
+	input->frame_gop_seqno = 0;
+	input->h264_idr_pic_id = 0;
+
+	input->reg_dsp_qp = input->qp;
+	input->reg_dsp_ref_mvp_lambda = lambda_lookup_table[input->qp];
+	input->reg_dsp_i4x4_weight = intra4x4_lambda3[input->qp];
+	input->reg_emu = TW5864_EMU_EN_LPF | TW5864_EMU_EN_BHOST
+		| TW5864_EMU_EN_SEN | TW5864_EMU_EN_ME | TW5864_EMU_EN_DDR;
+	input->reg_dsp = nr /* channel id */
+		| TW5864_DSP_CHROM_SW
+		| ((0xa << 8) & TW5864_DSP_MB_DELAY)
+		;
+
+	input->resolution = D1;
+
+	d1_height = (input->std == STD_NTSC) ? 480 : 576;
+
+	input->width = d1_width;
+	input->height = d1_height;
+
+	input->reg_interlacing = 0x4;
+
+	switch (input->resolution) {
+	case D1:
+		frame_width_bus_value = 0x2cf;
+		frame_height_bus_value = input->height - 1;
+		reg_frame_bus = 0x1c;
+		fmt_reg_value = 0;
+		downscale_enabled = 0;
+		input->reg_dsp_codec |= TW5864_CIF_MAP_MD | TW5864_HD1_MAP_MD;
+		input->reg_emu |= TW5864_DSP_FRAME_TYPE_D1;
+		input->reg_interlacing = TW5864_DI_EN | TW5864_DSP_INTER_ST;
+
+		tw_setl(TW5864_FULL_HALF_FLAG, 1 << nr);
+		break;
+	case HD1:
+		input->height /= 2;
+		input->width /= 2;
+		frame_width_bus_value = 0x2cf;
+		frame_height_bus_value = input->height * 2 - 1;
+		reg_frame_bus = 0x1c;
+		fmt_reg_value = 0;
+		downscale_enabled = 0;
+		input->reg_dsp_codec |= TW5864_HD1_MAP_MD;
+		input->reg_emu |= TW5864_DSP_FRAME_TYPE_D1;
+
+		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << nr);
+
+		break;
+	case CIF:
+		input->height /= 4;
+		input->width /= 2;
+		frame_width_bus_value = 0x15f;
+		frame_height_bus_value = input->height * 2 - 1;
+		reg_frame_bus = 0x07;
+		fmt_reg_value = 1;
+		downscale_enabled = 1;
+		input->reg_dsp_codec |= TW5864_CIF_MAP_MD;
+
+		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << nr);
+		break;
+	case QCIF:
+		input->height /= 4;
+		input->width /= 4;
+		frame_width_bus_value = 0x15f;
+		frame_height_bus_value = input->height * 2 - 1;
+		reg_frame_bus = 0x07;
+		fmt_reg_value = 1;
+		downscale_enabled = 1;
+		input->reg_dsp_codec |= TW5864_CIF_MAP_MD;
+
+		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << nr);
+		break;
+	}
+
+	/* analog input width / 4 */
+	tw_indir_writeb(TW5864_INDIR_IN_PIC_WIDTH(nr), d1_width / 4);
+	tw_indir_writeb(TW5864_INDIR_IN_PIC_HEIGHT(nr), d1_height / 4);
+
+	/* output width / 4 */
+	tw_indir_writeb(TW5864_INDIR_OUT_PIC_WIDTH(nr), input->width / 4);
+	tw_indir_writeb(TW5864_INDIR_OUT_PIC_HEIGHT(nr), input->height / 4);
+
+	tw_writel(TW5864_DSP_PIC_MAX_MB,
+		  ((input->width / 16) << 8) | (input->height / 16));
+
+	tw_writel(TW5864_FRAME_WIDTH_BUS_A(nr),
+		  frame_width_bus_value);
+	tw_writel(TW5864_FRAME_WIDTH_BUS_B(nr),
+		  frame_width_bus_value);
+	tw_writel(TW5864_FRAME_HEIGHT_BUS_A(nr),
+		  frame_height_bus_value);
+	tw_writel(TW5864_FRAME_HEIGHT_BUS_B(nr),
+		  (frame_height_bus_value + 1) / 2 - 1);
+
+	tw5864_frame_interval_set(input);
+
+	if (downscale_enabled)
+		tw_setl(TW5864_H264EN_CH_DNS, 1 << nr);
+
+	tw_mask_shift_writel(TW5864_H264EN_CH_FMT_REG1, 0x3, 2 * nr,
+			     fmt_reg_value);
+
+	tw_mask_shift_writel((nr < 2
+			      ? TW5864_H264EN_RATE_MAX_LINE_REG1
+			      : TW5864_H264EN_RATE_MAX_LINE_REG2),
+			     0x1f, 5 * (nr % 2),
+			     input->std == STD_NTSC ? 29 : 24);
+
+	tw_mask_shift_writel((nr < 2) ? TW5864_FRAME_BUS1 :
+			     TW5864_FRAME_BUS2, 0xff, (nr % 2) * 8,
+			     reg_frame_bus);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	input->enabled = 1;
+	spin_unlock_irqrestore(&dev->slock, flags);
+
+	return 0;
+}
+
+void tw5864_request_encoded_frame(struct tw5864_input *input)
+{
+	struct tw5864_dev *dev = input->root;
+	u32 enc_buf_id_new;
+
+	tw_setl(TW5864_DSP_CODEC, TW5864_CIF_MAP_MD | TW5864_HD1_MAP_MD);
+	tw_writel(TW5864_EMU, input->reg_emu);
+	tw_writel(TW5864_INTERLACING, input->reg_interlacing);
+	tw_writel(TW5864_DSP, input->reg_dsp);
+
+	tw_writel(TW5864_DSP_QP, input->reg_dsp_qp);
+	tw_writel(TW5864_DSP_REF_MVP_LAMBDA, input->reg_dsp_ref_mvp_lambda);
+	tw_writel(TW5864_DSP_I4x4_WEIGHT, input->reg_dsp_i4x4_weight);
+	tw_mask_shift_writel(TW5864_DSP_INTRA_MODE, TW5864_DSP_INTRA_MODE_MASK,
+			     TW5864_DSP_INTRA_MODE_SHIFT,
+			     TW5864_DSP_INTRA_MODE_16x16);
+
+	if (input->frame_gop_seqno == 0) {
+		/* Produce I-frame */
+		tw_writel(TW5864_MOTION_SEARCH_ETC, TW5864_INTRA_EN);
+		input->h264_idr_pic_id++;
+		input->h264_idr_pic_id &= TW5864_DSP_REF_FRM;
+	} else {
+		/* Produce P-frame */
+		tw_writel(TW5864_MOTION_SEARCH_ETC, TW5864_INTRA_EN |
+			  TW5864_ME_EN | BIT(5) /* SRCH_OPT default */);
+	}
+	tw5864_prepare_frame_headers(input);
+	tw_writel(TW5864_VLC,
+		  TW5864_VLC_PCI_SEL |
+		  ((input->tail_nb_bits + 24) << TW5864_VLC_BIT_ALIGN_SHIFT) |
+		  input->reg_dsp_qp);
+
+	enc_buf_id_new = tw_mask_shift_readl(TW5864_ENC_BUF_PTR_REC1, 0x3,
+					     2 * input->nr);
+	tw_writel(TW5864_DSP_ENC_ORG_PTR_REG,
+		  enc_buf_id_new << TW5864_DSP_ENC_ORG_PTR_SHIFT);
+	tw_writel(TW5864_DSP_ENC_REC,
+		  enc_buf_id_new << 12 | ((enc_buf_id_new + 3) & 3));
+
+	tw_writel(TW5864_SLICE, TW5864_START_NSLICE);
+	tw_writel(TW5864_SLICE, 0);
+}
+
+static int tw5864_disable_input(struct tw5864_input *input)
+{
+	struct tw5864_dev *dev = input->root;
+	unsigned long flags;
+
+	dev_dbg(&dev->pci->dev, "Disabling channel %d\n", input->nr);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	input->enabled = 0;
+	spin_unlock_irqrestore(&dev->slock, flags);
+	return 0;
+}
+
+static int tw5864_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct tw5864_input *input = vb2_get_drv_priv(q);
+	int ret;
+
+	ret = tw5864_enable_input(input);
+	if (!ret)
+		return 0;
+
+	while (!list_empty(&input->active)) {
+		struct tw5864_buf *buf = list_entry(input->active.next,
+						    struct tw5864_buf, list);
+
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	}
+	return ret;
+}
+
+static void tw5864_stop_streaming(struct vb2_queue *q)
+{
+	unsigned long flags;
+	struct tw5864_input *input = vb2_get_drv_priv(q);
+
+	tw5864_disable_input(input);
+
+	spin_lock_irqsave(&input->slock, flags);
+	if (input->vb) {
+		vb2_buffer_done(&input->vb->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		input->vb = NULL;
+	}
+	while (!list_empty(&input->active)) {
+		struct tw5864_buf *buf = list_entry(input->active.next,
+						    struct tw5864_buf, list);
+
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&input->slock, flags);
+}
+
+static struct vb2_ops tw5864_video_qops = {
+	.queue_setup = tw5864_queue_setup,
+	.buf_queue = tw5864_buf_queue,
+	.start_streaming = tw5864_start_streaming,
+	.stop_streaming = tw5864_stop_streaming,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+};
+
+static int tw5864_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct tw5864_input *input =
+		container_of(ctrl->handler, struct tw5864_input, hdl);
+	struct tw5864_dev *dev = input->root;
+	unsigned long flags;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		tw_indir_writeb(TW5864_INDIR_VIN_A_BRIGHT(input->nr),
+				(u8)ctrl->val);
+		break;
+	case V4L2_CID_HUE:
+		tw_indir_writeb(TW5864_INDIR_VIN_7_HUE(input->nr),
+				(u8)ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		tw_indir_writeb(TW5864_INDIR_VIN_9_CNTRST(input->nr),
+				(u8)ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		tw_indir_writeb(TW5864_INDIR_VIN_B_SAT_U(input->nr),
+				(u8)ctrl->val);
+		tw_indir_writeb(TW5864_INDIR_VIN_C_SAT_V(input->nr),
+				(u8)ctrl->val);
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		input->gop = ctrl->val;
+		return 0;
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
+		spin_lock_irqsave(&input->slock, flags);
+		input->qp = ctrl->val;
+		input->reg_dsp_qp = input->qp;
+		input->reg_dsp_ref_mvp_lambda = lambda_lookup_table[input->qp];
+		input->reg_dsp_i4x4_weight = intra4x4_lambda3[input->qp];
+		spin_unlock_irqrestore(&input->slock, flags);
+		return 0;
+	case V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD:
+		memset(input->md_threshold_grid_values, ctrl->val,
+		       sizeof(input->md_threshold_grid_values));
+		return 0;
+	case V4L2_CID_DETECT_MD_MODE:
+		return 0;
+	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
+		/* input->md_threshold_grid_ctrl->p_new.p_u16 contains data */
+		memcpy(input->md_threshold_grid_values,
+		       input->md_threshold_grid_ctrl->p_new.p_u16,
+		       sizeof(input->md_threshold_grid_values));
+		return 0;
+	}
+	return 0;
+}
+
+static int tw5864_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *f)
+{
+	struct tw5864_input *input = video_drvdata(file);
+
+	f->fmt.pix.width = 720;
+	switch (input->std) {
+	default:
+		WARN_ON_ONCE(1);
+	case STD_NTSC:
+		f->fmt.pix.height = 480;
+		break;
+	case STD_PAL:
+	case STD_SECAM:
+		f->fmt.pix.height = 576;
+		break;
+	}
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_H264;
+	f->fmt.pix.sizeimage = H264_VLC_BUF_SIZE;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	return 0;
+}
+
+static int tw5864_enum_input(struct file *file, void *priv,
+			     struct v4l2_input *i)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	struct tw5864_dev *dev = input->root;
+
+	u8 indir_0x000 = tw_indir_readb(TW5864_INDIR_VIN_0(input->nr));
+	u8 indir_0x00d = tw_indir_readb(TW5864_INDIR_VIN_D(input->nr));
+	u8 v1 = indir_0x000;
+	u8 v2 = indir_0x00d;
+
+	if (i->index)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	snprintf(i->name, sizeof(i->name), "Encoder %d", input->nr);
+	i->std = TW5864_NORMS;
+	if (v1 & (1 << 7))
+		i->status |= V4L2_IN_ST_NO_SYNC;
+	if (!(v1 & (1 << 6)))
+		i->status |= V4L2_IN_ST_NO_H_LOCK;
+	if (v1 & (1 << 2))
+		i->status |= V4L2_IN_ST_NO_SIGNAL;
+	if (v1 & (1 << 1))
+		i->status |= V4L2_IN_ST_NO_COLOR;
+	if (v2 & (1 << 2))
+		i->status |= V4L2_IN_ST_MACROVISION;
+
+	return 0;
+}
+
+static int tw5864_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int tw5864_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i)
+		return -EINVAL;
+	return 0;
+}
+
+static int tw5864_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct tw5864_input *input = video_drvdata(file);
+
+	strcpy(cap->driver, "tw5864");
+	snprintf(cap->card, sizeof(cap->card), "TW5864 Encoder %d",
+		 input->nr);
+	sprintf(cap->bus_info, "PCI:%s", pci_name(input->root->pci));
+	return 0;
+}
+
+static int tw5864_querystd(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	enum tw5864_vid_std tw_std;
+	int ret;
+
+	ret = tw5864_input_std_get(input, &tw_std);
+	if (ret)
+		return ret;
+	*std = tw5864_get_v4l2_std(tw_std);
+
+	return 0;
+}
+
+static int tw5864_g_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct tw5864_input *input = video_drvdata(file);
+
+	*std = input->v4l2_std;
+	return 0;
+}
+
+static int tw5864_s_std(struct file *file, void *priv, v4l2_std_id std)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	struct tw5864_dev *dev = input->root;
+
+	input->v4l2_std = std;
+	input->std = tw5864_from_v4l2_std(std);
+	tw_indir_writeb(TW5864_INDIR_VIN_E(input->nr), input->std);
+	return 0;
+}
+
+static int tw5864_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	if (f->index)
+		return -EINVAL;
+
+	f->pixelformat = V4L2_PIX_FMT_H264;
+
+	return 0;
+}
+
+static int tw5864_subscribe_event(struct v4l2_fh *fh,
+				  const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	case V4L2_EVENT_MOTION_DET:
+		/*
+		 * Allow for up to 30 events (1 second for NTSC) to be stored.
+		 */
+		return v4l2_event_subscribe(fh, sub, 30, NULL);
+	}
+	return -EINVAL;
+}
+
+static void tw5864_frame_interval_set(struct tw5864_input *input)
+{
+	/*
+	 * This register value seems to follow such approach: In each second
+	 * interval, when processing Nth frame, it checks Nth bit of register
+	 * value and, if the bit is 1, it processes the frame, otherwise the
+	 * frame is discarded.
+	 * So unary representation would work, but more or less equal gaps
+	 * between the frames should be preserved.
+	 *
+	 * For 1 FPS - 0x00000001
+	 * 00000000 00000000 00000000 00000001
+	 *
+	 * For max FPS - set all 25/30 lower bits:
+	 * 00111111 11111111 11111111 11111111 (NTSC)
+	 * 00000001 11111111 11111111 11111111 (PAL)
+	 *
+	 * For half of max FPS - use such pattern:
+	 * 00010101 01010101 01010101 01010101 (NTSC)
+	 * 00000001 01010101 01010101 01010101 (PAL)
+	 *
+	 * Et cetera.
+	 *
+	 * The value supplied to hardware is capped by mask of 25/30 lower bits.
+	 */
+	struct tw5864_dev *dev = input->root;
+	u32 unary_framerate = 0;
+	int shift = 0;
+	int std_max_fps = input->std == STD_NTSC ? 30 : 25;
+
+	for (shift = 0; shift < std_max_fps; shift += input->frame_interval)
+		unary_framerate |= 0x00000001 << shift;
+
+	tw_writel(TW5864_H264EN_RATE_CNTL_LO_WORD(input->nr, 0),
+		  unary_framerate >> 16);
+	tw_writel(TW5864_H264EN_RATE_CNTL_HI_WORD(input->nr, 0),
+		  unary_framerate & 0xffff);
+}
+
+static int tw5864_frameinterval_get(struct tw5864_input *input,
+				    struct v4l2_fract *frameinterval)
+{
+	switch (input->std) {
+	case STD_NTSC:
+		frameinterval->numerator = 1001;
+		frameinterval->denominator = 30000;
+		break;
+	case STD_PAL:
+	case STD_SECAM:
+		frameinterval->numerator = 1;
+		frameinterval->denominator = 25;
+		break;
+	default:
+		WARN(1, "tw5864_frameinterval_get requested for unknown std %d\n",
+		     input->std);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int tw5864_enum_framesizes(struct file *file, void *priv,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct tw5864_input *input = video_drvdata(file);
+
+	if (fsize->index > 0)
+		return -EINVAL;
+	if (fsize->pixel_format != V4L2_PIX_FMT_H264)
+		return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = 720;
+	fsize->discrete.height = input->std == STD_NTSC ? 480 : 576;
+
+	return 0;
+}
+
+static int tw5864_enum_frameintervals(struct file *file, void *priv,
+				      struct v4l2_frmivalenum *fintv)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	struct v4l2_fract frameinterval;
+	int std_max_fps = input->std == STD_NTSC ? 30 : 25;
+	struct v4l2_frmsizeenum fsize = { .index = fintv->index,
+		.pixel_format = fintv->pixel_format };
+	int ret;
+
+	ret = tw5864_enum_framesizes(file, priv, &fsize);
+	if (ret)
+		return ret;
+
+	if (fintv->width != fsize.discrete.width ||
+	    fintv->height != fsize.discrete.height)
+		return -EINVAL;
+
+	fintv->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+
+	ret = tw5864_frameinterval_get(input, &frameinterval);
+	fintv->stepwise.step = frameinterval;
+	fintv->stepwise.min = frameinterval;
+	fintv->stepwise.max = frameinterval;
+	fintv->stepwise.max.numerator *= std_max_fps;
+
+	return ret;
+}
+
+static int tw5864_g_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *sp)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	struct v4l2_captureparm *cp = &sp->parm.capture;
+	int ret;
+
+	cp->capability = V4L2_CAP_TIMEPERFRAME;
+
+	ret = tw5864_frameinterval_get(input, &cp->timeperframe);
+	cp->timeperframe.numerator *= input->frame_interval;
+	cp->capturemode = 0;
+	cp->readbuffers = 2;
+
+	return ret;
+}
+
+static int tw5864_s_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *sp)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	struct v4l2_fract *t = &sp->parm.capture.timeperframe;
+	struct v4l2_fract time_base;
+	int ret;
+
+	ret = tw5864_frameinterval_get(input, &time_base);
+	if (ret)
+		return ret;
+
+	if (!t->numerator || !t->denominator) {
+		t->numerator = time_base.numerator * input->frame_interval;
+		t->denominator = time_base.denominator;
+	} else if (t->denominator != time_base.denominator) {
+		t->numerator = t->numerator * time_base.denominator /
+			t->denominator;
+		t->denominator = time_base.denominator;
+	}
+
+	input->frame_interval = t->numerator / time_base.numerator;
+	if (input->frame_interval < 1)
+		input->frame_interval = 1;
+	tw5864_frame_interval_set(input);
+	return tw5864_g_parm(file, priv, sp);
+}
+
+static const struct v4l2_ctrl_ops tw5864_ctrl_ops = {
+	.s_ctrl = tw5864_s_ctrl,
+};
+
+static const struct v4l2_file_operations video_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.read = vb2_fop_read,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+
+#define INDIR_SPACE_MAP_SHIFT 0x100000
+
+static int tw5864_g_reg(struct file *file, void *fh,
+			struct v4l2_dbg_register *reg)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	struct tw5864_dev *dev = input->root;
+
+	if (reg->reg < INDIR_SPACE_MAP_SHIFT) {
+		if (reg->reg > 0x87fff)
+			return -EINVAL;
+		reg->size = 4;
+		reg->val = tw_readl(reg->reg);
+	} else {
+		__u64 indir_addr = reg->reg - INDIR_SPACE_MAP_SHIFT;
+
+		if (indir_addr > 0xefe)
+			return -EINVAL;
+		reg->size = 1;
+		reg->val = tw_indir_readb(reg->reg);
+	}
+	return 0;
+}
+
+static int tw5864_s_reg(struct file *file, void *fh,
+			const struct v4l2_dbg_register *reg)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	struct tw5864_dev *dev = input->root;
+
+	if (reg->reg < INDIR_SPACE_MAP_SHIFT) {
+		if (reg->reg > 0x87fff)
+			return -EINVAL;
+		tw_writel(reg->reg, reg->val);
+	} else {
+		__u64 indir_addr = reg->reg - INDIR_SPACE_MAP_SHIFT;
+
+		if (indir_addr > 0xefe)
+			return -EINVAL;
+		tw_indir_writeb(reg->reg, reg->val);
+	}
+	return 0;
+}
+#endif
+
+static const struct v4l2_ioctl_ops video_ioctl_ops = {
+	.vidioc_querycap = tw5864_querycap,
+	.vidioc_enum_fmt_vid_cap = tw5864_enum_fmt_vid_cap,
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_expbuf = vb2_ioctl_expbuf,
+	.vidioc_querystd = tw5864_querystd,
+	.vidioc_s_std = tw5864_s_std,
+	.vidioc_g_std = tw5864_g_std,
+	.vidioc_enum_input = tw5864_enum_input,
+	.vidioc_g_input = tw5864_g_input,
+	.vidioc_s_input = tw5864_s_input,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+	.vidioc_try_fmt_vid_cap = tw5864_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = tw5864_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = tw5864_fmt_vid_cap,
+	.vidioc_log_status = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = tw5864_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_enum_framesizes = tw5864_enum_framesizes,
+	.vidioc_enum_frameintervals = tw5864_enum_frameintervals,
+	.vidioc_s_parm = tw5864_s_parm,
+	.vidioc_g_parm = tw5864_g_parm,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register = tw5864_g_reg,
+	.vidioc_s_register = tw5864_s_reg,
+#endif
+};
+
+static struct video_device tw5864_video_template = {
+	.name = "tw5864_video",
+	.fops = &video_fops,
+	.ioctl_ops = &video_ioctl_ops,
+	.release = video_device_release_empty,
+	.tvnorms = TW5864_NORMS,
+	.device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+		V4L2_CAP_STREAMING,
+};
+
+/* Motion Detection Threshold matrix */
+static const struct v4l2_ctrl_config tw5864_md_thresholds = {
+	.ops = &tw5864_ctrl_ops,
+	.id = V4L2_CID_DETECT_MD_THRESHOLD_GRID,
+	.dims = {MD_CELLS_HOR, MD_CELLS_VERT},
+	.def = 14,
+	/* See tw5864_md_metric_from_mvd() */
+	.max = 2 * 0x0f,
+	.step = 1,
+};
+
+static int tw5864_video_input_init(struct tw5864_input *dev, int video_nr);
+static void tw5864_video_input_fini(struct tw5864_input *dev);
+static void tw5864_encoder_tables_upload(struct tw5864_dev *dev);
+
+int tw5864_video_init(struct tw5864_dev *dev, int *video_nr)
+{
+	int i;
+	int ret;
+	unsigned long flags;
+	int last_dma_allocated = -1;
+	int last_input_nr_registered = -1;
+
+	for (i = 0; i < H264_BUF_CNT; i++) {
+		struct tw5864_h264_frame *frame = &dev->h264_buf[i];
+
+		frame->vlc.addr = dma_alloc_coherent(&dev->pci->dev,
+						     H264_VLC_BUF_SIZE,
+						     &frame->vlc.dma_addr,
+						     GFP_KERNEL | GFP_DMA32);
+		if (!frame->vlc.addr) {
+			dev_err(&dev->pci->dev, "dma alloc fail\n");
+			ret = -ENOMEM;
+			goto free_dma;
+		}
+		frame->mv.addr = dma_alloc_coherent(&dev->pci->dev,
+						    H264_MV_BUF_SIZE,
+						    &frame->mv.dma_addr,
+						    GFP_KERNEL | GFP_DMA32);
+		if (!frame->mv.addr) {
+			dev_err(&dev->pci->dev, "dma alloc fail\n");
+			ret = -ENOMEM;
+			dma_free_coherent(&dev->pci->dev, H264_VLC_BUF_SIZE,
+					  frame->vlc.addr, frame->vlc.dma_addr);
+			goto free_dma;
+		}
+		last_dma_allocated = i;
+	}
+
+	tw5864_encoder_tables_upload(dev);
+
+	/* Picture is distorted without this block */
+	/* use falling edge to sample 54M to 108M */
+	tw_indir_writeb(TW5864_INDIR_VD_108_POL, TW5864_INDIR_VD_108_POL_BOTH);
+	tw_indir_writeb(TW5864_INDIR_CLK0_SEL, 0x00);
+
+	tw_indir_writeb(TW5864_INDIR_DDRA_DLL_DQS_SEL0, 0x02);
+	tw_indir_writeb(TW5864_INDIR_DDRA_DLL_DQS_SEL1, 0x02);
+	tw_indir_writeb(TW5864_INDIR_DDRA_DLL_CLK90_SEL, 0x02);
+	tw_indir_writeb(TW5864_INDIR_DDRB_DLL_DQS_SEL0, 0x02);
+	tw_indir_writeb(TW5864_INDIR_DDRB_DLL_DQS_SEL1, 0x02);
+	tw_indir_writeb(TW5864_INDIR_DDRB_DLL_CLK90_SEL, 0x02);
+
+	/* video input reset */
+	tw_indir_writeb(TW5864_INDIR_RESET, 0);
+	tw_indir_writeb(TW5864_INDIR_RESET, TW5864_INDIR_RESET_VD |
+			TW5864_INDIR_RESET_DLL | TW5864_INDIR_RESET_MUX_CORE);
+	msleep(20);
+
+	/*
+	 * Select Part A mode for all channels.
+	 * tw_setl instead of tw_clearl for Part B mode.
+	 *
+	 * I guess "Part B" is primarily for downscaled version of same channel
+	 * which goes in Part A of same bus
+	 */
+	tw_writel(TW5864_FULL_HALF_MODE_SEL, 0);
+
+	tw_indir_writeb(TW5864_INDIR_PV_VD_CK_POL,
+			TW5864_INDIR_PV_VD_CK_POL_VD(0) |
+			TW5864_INDIR_PV_VD_CK_POL_VD(1) |
+			TW5864_INDIR_PV_VD_CK_POL_VD(2) |
+			TW5864_INDIR_PV_VD_CK_POL_VD(3));
+
+	spin_lock_irqsave(&dev->slock, flags);
+	dev->encoder_busy = 0;
+	dev->h264_buf_r_index = 0;
+	dev->h264_buf_w_index = 0;
+	tw_writel(TW5864_VLC_STREAM_BASE_ADDR,
+		  dev->h264_buf[dev->h264_buf_w_index].vlc.dma_addr);
+	tw_writel(TW5864_MV_STREAM_BASE_ADDR,
+		  dev->h264_buf[dev->h264_buf_w_index].mv.dma_addr);
+	spin_unlock_irqrestore(&dev->slock, flags);
+
+	tw_writel(TW5864_SEN_EN_CH, 0x000f);
+	tw_writel(TW5864_H264EN_CH_EN, 0x000f);
+
+	tw_writel(TW5864_H264EN_BUS0_MAP, 0x00000000);
+	tw_writel(TW5864_H264EN_BUS1_MAP, 0x00001111);
+	tw_writel(TW5864_H264EN_BUS2_MAP, 0x00002222);
+	tw_writel(TW5864_H264EN_BUS3_MAP, 0x00003333);
+
+	/*
+	 * Quote from Intersil (manufacturer):
+	 * 0x0038 is managed by HW, and by default it won't pass the pointer set
+	 * at 0x0010. So if you don't do encoding, 0x0038 should stay at '3'
+	 * (with 4 frames in buffer). If you encode one frame and then move
+	 * 0x0010 to '1' for example, HW will take one more frame and set it to
+	 * buffer #0, and then you should see 0x0038 is set to '0'.  There is
+	 * only one HW encoder engine, so 4 channels cannot get encoded
+	 * simultaneously. But each channel does have its own buffer (for
+	 * original frames and reconstructed frames). So there is no problem to
+	 * manage encoding for 4 channels at same time and no need to force
+	 * I-frames in switching channels.
+	 * End of quote.
+	 *
+	 * If we set 0x0010 (TW5864_ENC_BUF_PTR_REC1) to 0 (for any channel), we
+	 * have no "rolling" (until we change this value).
+	 * If we set 0x0010 (TW5864_ENC_BUF_PTR_REC1) to 0x3, it starts to roll
+	 * continuously together with 0x0038.
+	 */
+	tw_writel(TW5864_ENC_BUF_PTR_REC1, 0x00ff);
+	tw_writel(TW5864_PCI_INTTM_SCALE, 0);
+
+	tw_writel(TW5864_INTERLACING, TW5864_DI_EN);
+	tw_writel(TW5864_MASTER_ENB_REG, TW5864_PCI_VLC_INTR_ENB);
+	tw_writel(TW5864_PCI_INTR_CTL,
+		  TW5864_TIMER_INTR_ENB | TW5864_PCI_MAST_ENB |
+		  TW5864_MVD_VLC_MAST_ENB);
+
+	dev->irqmask |= TW5864_INTR_VLC_DONE | TW5864_INTR_TIMER;
+	tw5864_irqmask_apply(dev);
+
+	tasklet_init(&dev->tasklet, tw5864_handle_frame_task,
+		     (unsigned long)dev);
+
+	for (i = 0; i < TW5864_INPUTS; i++) {
+		dev->inputs[i].root = dev;
+		dev->inputs[i].nr = i;
+		ret = tw5864_video_input_init(&dev->inputs[i], video_nr[i]);
+		if (ret)
+			goto fini_video_inputs;
+		last_input_nr_registered = i;
+	}
+
+	return 0;
+
+fini_video_inputs:
+	for (i = last_input_nr_registered; i >= 0; i--)
+		tw5864_video_input_fini(&dev->inputs[i]);
+
+	tasklet_kill(&dev->tasklet);
+
+free_dma:
+	for (i = last_dma_allocated; i >= 0; i--) {
+		dma_free_coherent(&dev->pci->dev, H264_VLC_BUF_SIZE,
+				  dev->h264_buf[i].vlc.addr,
+				  dev->h264_buf[i].vlc.dma_addr);
+		dma_free_coherent(&dev->pci->dev, H264_MV_BUF_SIZE,
+				  dev->h264_buf[i].mv.addr,
+				  dev->h264_buf[i].mv.dma_addr);
+	}
+
+	return ret;
+}
+
+static int tw5864_video_input_init(struct tw5864_input *input, int video_nr)
+{
+	struct tw5864_dev *dev = input->root;
+	int ret;
+	struct v4l2_ctrl_handler *hdl = &input->hdl;
+
+	mutex_init(&input->lock);
+	spin_lock_init(&input->slock);
+
+	/* setup video buffers queue */
+	INIT_LIST_HEAD(&input->active);
+	input->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	input->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	input->vidq.io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
+	input->vidq.ops = &tw5864_video_qops;
+	input->vidq.mem_ops = &vb2_dma_contig_memops;
+	input->vidq.drv_priv = input;
+	input->vidq.gfp_flags = 0;
+	input->vidq.buf_struct_size = sizeof(struct tw5864_buf);
+	input->vidq.lock = &input->lock;
+	input->vidq.min_buffers_needed = 2;
+	input->vidq.dev = &input->root->pci->dev;
+	ret = vb2_queue_init(&input->vidq);
+	if (ret)
+		goto free_mutex;
+
+	input->vdev = tw5864_video_template;
+	input->vdev.v4l2_dev = &input->root->v4l2_dev;
+	input->vdev.lock = &input->lock;
+	input->vdev.queue = &input->vidq;
+	video_set_drvdata(&input->vdev, input);
+
+	/* Initialize the device control structures */
+	v4l2_ctrl_handler_init(hdl, 6);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0, 255, 1, 100);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_SATURATION, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops, V4L2_CID_HUE, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops, V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+			  1, MAX_GOP_SIZE, 1, GOP_SIZE);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 28, 51, 1, QP_VALUE);
+	v4l2_ctrl_new_std_menu(hdl, &tw5864_ctrl_ops,
+			       V4L2_CID_DETECT_MD_MODE,
+			       V4L2_DETECT_MD_MODE_THRESHOLD_GRID, 0,
+			       V4L2_DETECT_MD_MODE_DISABLED);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD,
+			  tw5864_md_thresholds.min, tw5864_md_thresholds.max,
+			  tw5864_md_thresholds.step, tw5864_md_thresholds.def);
+	input->md_threshold_grid_ctrl =
+		v4l2_ctrl_new_custom(hdl, &tw5864_md_thresholds, NULL);
+	if (hdl->error) {
+		ret = hdl->error;
+		goto free_v4l2_hdl;
+	}
+	input->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_setup(hdl);
+
+	input->qp = QP_VALUE;
+	input->gop = GOP_SIZE;
+	input->frame_interval = 1;
+
+	ret = video_register_device(&input->vdev, VFL_TYPE_GRABBER, video_nr);
+	if (ret)
+		goto free_v4l2_hdl;
+
+	dev_info(&input->root->pci->dev, "Registered video device %s\n",
+		 video_device_node_name(&input->vdev));
+
+	/*
+	 * Set default video standard. Doesn't matter which, the detected value
+	 * will be found out by VIDIOC_QUERYSTD handler.
+	 */
+	input->v4l2_std = V4L2_STD_NTSC_M;
+	input->std = STD_NTSC;
+
+	tw_indir_writeb(TW5864_INDIR_VIN_E(video_nr), 0x07);
+	/* to initiate auto format recognition */
+	tw_indir_writeb(TW5864_INDIR_VIN_F(video_nr), 0xff);
+
+	return 0;
+
+free_v4l2_hdl:
+	v4l2_ctrl_handler_free(hdl);
+	vb2_queue_release(&input->vidq);
+free_mutex:
+	mutex_destroy(&input->lock);
+
+	return ret;
+}
+
+static void tw5864_video_input_fini(struct tw5864_input *dev)
+{
+	video_unregister_device(&dev->vdev);
+	v4l2_ctrl_handler_free(&dev->hdl);
+	vb2_queue_release(&dev->vidq);
+}
+
+void tw5864_video_fini(struct tw5864_dev *dev)
+{
+	int i;
+
+	tasklet_kill(&dev->tasklet);
+
+	for (i = 0; i < TW5864_INPUTS; i++)
+		tw5864_video_input_fini(&dev->inputs[i]);
+
+	for (i = 0; i < H264_BUF_CNT; i++) {
+		dma_free_coherent(&dev->pci->dev, H264_VLC_BUF_SIZE,
+				  dev->h264_buf[i].vlc.addr,
+				  dev->h264_buf[i].vlc.dma_addr);
+		dma_free_coherent(&dev->pci->dev, H264_MV_BUF_SIZE,
+				  dev->h264_buf[i].mv.addr,
+				  dev->h264_buf[i].mv.dma_addr);
+	}
+}
+
+void tw5864_prepare_frame_headers(struct tw5864_input *input)
+{
+	struct tw5864_buf *vb = input->vb;
+	u8 *dst;
+	size_t dst_space;
+	unsigned long flags;
+	u8 *sl_hdr;
+	unsigned long space_before_sl_hdr;
+
+	if (!vb) {
+		spin_lock_irqsave(&input->slock, flags);
+		if (list_empty(&input->active)) {
+			spin_unlock_irqrestore(&input->slock, flags);
+			input->vb = NULL;
+			return;
+		}
+		vb = list_first_entry(&input->active, struct tw5864_buf, list);
+		list_del(&vb->list);
+		spin_unlock_irqrestore(&input->slock, flags);
+	}
+
+	dst = vb2_plane_vaddr(&vb->vb.vb2_buf, 0);
+	dst_space = vb2_plane_size(&vb->vb.vb2_buf, 0);
+
+	/*
+	 * Low-level bitstream writing functions don't have a fine way to say
+	 * correctly that supplied buffer is too small. So we just check there
+	 * and warn, and don't care at lower level.
+	 * Currently all headers take below 32 bytes.
+	 * The buffer is supposed to have plenty of free space at this point,
+	 * anyway.
+	 */
+	WARN_ON_ONCE(dst_space < 128);
+
+	/*
+	 * Generate H264 headers:
+	 * If this is first frame, put SPS and PPS
+	 */
+	if (input->frame_gop_seqno == 0)
+		tw5864_h264_put_stream_header(&dst, &dst_space, input->qp,
+					      input->width, input->height);
+
+	/* Put slice header */
+	sl_hdr = dst;
+	space_before_sl_hdr = dst_space;
+	tw5864_h264_put_slice_header(&dst, &dst_space, input->h264_idr_pic_id,
+				     input->frame_gop_seqno,
+				     &input->tail_nb_bits, &input->tail);
+	input->vb = vb;
+	input->buf_cur_ptr = dst;
+	input->buf_cur_space_left = dst_space;
+}
+
+/*
+ * Returns heuristic motion detection metric value from known components of
+ * hardware-provided Motion Vector Data.
+ */
+static unsigned int tw5864_md_metric_from_mvd(u32 mvd)
+{
+	/*
+	 * Format of motion vector data exposed by tw5864, according to
+	 * manufacturer:
+	 * mv_x 10 bits
+	 * mv_y 10 bits
+	 * non_zero_members 8 bits
+	 * mb_type 3 bits
+	 * reserved 1 bit
+	 *
+	 * non_zero_members: number of non-zero residuals in each macro block
+	 * after quantization
+	 *
+	 * unsigned int reserved = mvd >> 31;
+	 * unsigned int mb_type = (mvd >> 28) & 0x7;
+	 * unsigned int non_zero_members = (mvd >> 20) & 0xff;
+	 */
+	unsigned int mv_y = (mvd >> 10) & 0x3ff;
+	unsigned int mv_x = mvd & 0x3ff;
+
+	/* heuristic: */
+	mv_x &= 0x0f;
+	mv_y &= 0x0f;
+
+	return mv_y + mv_x;
+}
+
+static int tw5864_is_motion_triggered(struct tw5864_h264_frame *frame)
+{
+	struct tw5864_input *input = frame->input;
+	u32 *mv = (u32 *)frame->mv.addr;
+	int i;
+	int detected = 0;
+
+	for (i = 0; i < MD_CELLS; i++) {
+		const u16 thresh = input->md_threshold_grid_values[i];
+		const unsigned int metric = tw5864_md_metric_from_mvd(mv[i]);
+
+		if (metric > thresh)
+			detected = 1;
+
+		if (detected)
+			break;
+	}
+	return detected;
+}
+
+static void tw5864_handle_frame_task(unsigned long data)
+{
+	struct tw5864_dev *dev = (struct tw5864_dev *)data;
+	unsigned long flags;
+	int batch_size = H264_BUF_CNT;
+
+	spin_lock_irqsave(&dev->slock, flags);
+	while (dev->h264_buf_r_index != dev->h264_buf_w_index && batch_size--) {
+		struct tw5864_h264_frame *frame =
+			&dev->h264_buf[dev->h264_buf_r_index];
+
+		spin_unlock_irqrestore(&dev->slock, flags);
+		dma_sync_single_for_cpu(&dev->pci->dev, frame->vlc.dma_addr,
+					H264_VLC_BUF_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(&dev->pci->dev, frame->mv.dma_addr,
+					H264_MV_BUF_SIZE, DMA_FROM_DEVICE);
+		tw5864_handle_frame(frame);
+		dma_sync_single_for_device(&dev->pci->dev, frame->vlc.dma_addr,
+					   H264_VLC_BUF_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_device(&dev->pci->dev, frame->mv.dma_addr,
+					   H264_MV_BUF_SIZE, DMA_FROM_DEVICE);
+		spin_lock_irqsave(&dev->slock, flags);
+
+		dev->h264_buf_r_index++;
+		dev->h264_buf_r_index %= H264_BUF_CNT;
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+#ifdef DEBUG
+static u32 tw5864_vlc_checksum(u32 *data, int len)
+{
+	u32 val, count_len = len;
+
+	val = *data++;
+	while (((count_len >> 2) - 1) > 0) {
+		val ^= *data++;
+		count_len -= 4;
+	}
+	val ^= htonl((len >> 2));
+	return val;
+}
+#endif
+
+static void tw5864_handle_frame(struct tw5864_h264_frame *frame)
+{
+#define SKIP_VLCBUF_BYTES 3
+	struct tw5864_input *input = frame->input;
+	struct tw5864_dev *dev = input->root;
+	struct tw5864_buf *vb;
+	struct vb2_v4l2_buffer *v4l2_buf;
+	int frame_len = frame->vlc_len - SKIP_VLCBUF_BYTES;
+	u8 *dst = input->buf_cur_ptr;
+	u8 tail_mask, vlc_mask = 0;
+	int i;
+	u8 vlc_first_byte = ((u8 *)(frame->vlc.addr + SKIP_VLCBUF_BYTES))[0];
+	unsigned long flags;
+	int zero_run;
+	u8 *src;
+	u8 *src_end;
+
+#ifdef DEBUG
+	if (frame->checksum !=
+	    tw5864_vlc_checksum((u32 *)frame->vlc.addr, frame_len))
+		dev_err(&dev->pci->dev,
+			"Checksum of encoded frame doesn't match!\n");
+#endif
+
+	spin_lock_irqsave(&input->slock, flags);
+	vb = input->vb;
+	input->vb = NULL;
+	spin_unlock_irqrestore(&input->slock, flags);
+
+	v4l2_buf = to_vb2_v4l2_buffer(&vb->vb.vb2_buf);
+
+	if (!vb) { /* Gone because of disabling */
+		dev_dbg(&dev->pci->dev, "vb is empty, dropping frame\n");
+		return;
+	}
+
+	/*
+	 * Check for space.
+	 * Mind the overhead of startcode emulation prevention.
+	 */
+	if (input->buf_cur_space_left < frame_len * 5 / 4) {
+		dev_err_once(&dev->pci->dev,
+			     "Left space in vb2 buffer, %d bytes, is less than considered safely enough to put frame of length %d. Dropping this frame.\n",
+			     input->buf_cur_space_left, frame_len);
+		return;
+	}
+
+	for (i = 0; i < 8 - input->tail_nb_bits; i++)
+		vlc_mask |= 1 << i;
+	tail_mask = (~vlc_mask) & 0xff;
+
+	dst[0] = (input->tail & tail_mask) | (vlc_first_byte & vlc_mask);
+	frame_len--;
+	dst++;
+
+	/* H.264 startcode emulation prevention */
+	src = frame->vlc.addr + SKIP_VLCBUF_BYTES + 1;
+	src_end = src + frame_len;
+	zero_run = 0;
+	for (; src < src_end; src++) {
+		if (zero_run < 2) {
+			if (*src == 0)
+				++zero_run;
+			else
+				zero_run = 0;
+		} else {
+			if ((*src & ~0x03) == 0)
+				*dst++ = 0x03;
+			zero_run = *src == 0;
+		}
+		*dst++ = *src;
+	}
+
+	vb2_set_plane_payload(&vb->vb.vb2_buf, 0,
+			      dst - (u8 *)vb2_plane_vaddr(&vb->vb.vb2_buf, 0));
+
+	vb->vb.vb2_buf.timestamp = frame->timestamp;
+	v4l2_buf->field = V4L2_FIELD_INTERLACED;
+	v4l2_buf->sequence = frame->seqno;
+
+	/* Check for motion flags */
+	if (frame->gop_seqno /* P-frame */ &&
+	    tw5864_is_motion_triggered(frame)) {
+		struct v4l2_event ev = {
+			.type = V4L2_EVENT_MOTION_DET,
+			.u.motion_det = {
+				.flags = V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ,
+				.frame_sequence = v4l2_buf->sequence,
+			},
+		};
+
+		v4l2_event_queue(&input->vdev, &ev);
+	}
+
+	vb2_buffer_done(&vb->vb.vb2_buf, VB2_BUF_STATE_DONE);
+}
+
+static v4l2_std_id tw5864_get_v4l2_std(enum tw5864_vid_std std)
+{
+	switch (std) {
+	case STD_NTSC:    return V4L2_STD_NTSC_M;
+	case STD_PAL:     return V4L2_STD_PAL_B;
+	case STD_SECAM:   return V4L2_STD_SECAM_B;
+	case STD_NTSC443: return V4L2_STD_NTSC_443;
+	case STD_PAL_M:   return V4L2_STD_PAL_M;
+	case STD_PAL_CN:  return V4L2_STD_PAL_Nc;
+	case STD_PAL_60:  return V4L2_STD_PAL_60;
+	case STD_INVALID: return V4L2_STD_UNKNOWN;
+	}
+	return 0;
+}
+
+static enum tw5864_vid_std tw5864_from_v4l2_std(v4l2_std_id v4l2_std)
+{
+	if (v4l2_std & V4L2_STD_NTSC_M)
+		return STD_NTSC;
+	if (v4l2_std & V4L2_STD_PAL_B)
+		return STD_PAL;
+	if (v4l2_std & V4L2_STD_SECAM_B)
+		return STD_SECAM;
+	if (v4l2_std & V4L2_STD_NTSC_443)
+		return STD_NTSC443;
+	if (v4l2_std & V4L2_STD_PAL_M)
+		return STD_PAL_M;
+	if (v4l2_std & V4L2_STD_PAL_Nc)
+		return STD_PAL_CN;
+	if (v4l2_std & V4L2_STD_PAL_60)
+		return STD_PAL_60;
+
+	WARN_ON_ONCE(1);
+	return STD_INVALID;
+}
+
+static void tw5864_encoder_tables_upload(struct tw5864_dev *dev)
+{
+	int i;
+
+	tw_writel(TW5864_VLC_RD, 0x1);
+	for (i = 0; i < VLC_LOOKUP_TABLE_LEN; i++) {
+		tw_writel((TW5864_VLC_STREAM_MEM_START + i * 4),
+			  encoder_vlc_lookup_table[i]);
+	}
+	tw_writel(TW5864_VLC_RD, 0x0);
+
+	for (i = 0; i < QUANTIZATION_TABLE_LEN; i++) {
+		tw_writel((TW5864_QUAN_TAB + i * 4),
+			  forward_quantization_table[i]);
+	}
+
+	for (i = 0; i < QUANTIZATION_TABLE_LEN; i++) {
+		tw_writel((TW5864_QUAN_TAB + i * 4),
+			  inverse_quantization_table[i]);
+	}
+}
diff --git a/drivers/media/pci/tw5864/tw5864.h b/drivers/media/pci/tw5864/tw5864.h
new file mode 100644
index 0000000..f5de9f6
--- /dev/null
+++ b/drivers/media/pci/tw5864/tw5864.h
@@ -0,0 +1,205 @@
+/*
+ *  TW5864 driver  - common header file
+ *
+ *  Copyright (C) 2016 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/pci.h>
+#include <linux/videodev2.h>
+#include <linux/notifier.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "tw5864-reg.h"
+
+#define PCI_DEVICE_ID_TECHWELL_5864 0x5864
+
+#define TW5864_NORMS V4L2_STD_ALL
+
+/* ----------------------------------------------------------- */
+/* card configuration   */
+
+#define TW5864_INPUTS 4
+
+/* The TW5864 uses 192 (16x12) detection cells in full screen for motion
+ * detection. Each detection cell is composed of 44 pixels and 20 lines for
+ * NTSC and 24 lines for PAL.
+ */
+#define MD_CELLS_HOR 16
+#define MD_CELLS_VERT 12
+#define MD_CELLS (MD_CELLS_HOR * MD_CELLS_VERT)
+
+#define H264_VLC_BUF_SIZE 0x80000
+#define H264_MV_BUF_SIZE 0x2000 /* device writes 5396 bytes */
+#define QP_VALUE 28
+#define MAX_GOP_SIZE 255
+#define GOP_SIZE MAX_GOP_SIZE
+
+enum resolution {
+	D1 = 1,
+	HD1 = 2, /* half d1 - 360x(240|288) */
+	CIF = 3,
+	QCIF = 4,
+};
+
+/* ----------------------------------------------------------- */
+/* device / file handle status                                 */
+
+struct tw5864_dev; /* forward delclaration */
+
+/* buffer for one video/vbi/ts frame */
+struct tw5864_buf {
+	struct vb2_v4l2_buffer vb;
+	struct list_head list;
+
+	unsigned int size;
+};
+
+struct tw5864_dma_buf {
+	void *addr;
+	dma_addr_t dma_addr;
+};
+
+enum tw5864_vid_std {
+	STD_NTSC = 0, /* NTSC (M) */
+	STD_PAL = 1, /* PAL (B, D, G, H, I) */
+	STD_SECAM = 2, /* SECAM */
+	STD_NTSC443 = 3, /* NTSC4.43 */
+	STD_PAL_M = 4, /* PAL (M) */
+	STD_PAL_CN = 5, /* PAL (CN) */
+	STD_PAL_60 = 6, /* PAL 60 */
+	STD_INVALID = 7,
+	STD_AUTO = 7,
+};
+
+struct tw5864_input {
+	int nr; /* input number */
+	struct tw5864_dev *root;
+	struct mutex lock; /* used for vidq and vdev */
+	spinlock_t slock; /* used for sync between ISR, tasklet & V4L2 API */
+	struct video_device vdev;
+	struct v4l2_ctrl_handler hdl;
+	struct vb2_queue vidq;
+	struct list_head active;
+	enum resolution resolution;
+	unsigned int width, height;
+	unsigned int frame_seqno;
+	unsigned int frame_gop_seqno;
+	unsigned int h264_idr_pic_id;
+	int enabled;
+	enum tw5864_vid_std std;
+	v4l2_std_id v4l2_std;
+	int tail_nb_bits;
+	u8 tail;
+	u8 *buf_cur_ptr;
+	int buf_cur_space_left;
+
+	u32 reg_interlacing;
+	u32 reg_vlc;
+	u32 reg_dsp_codec;
+	u32 reg_dsp;
+	u32 reg_emu;
+	u32 reg_dsp_qp;
+	u32 reg_dsp_ref_mvp_lambda;
+	u32 reg_dsp_i4x4_weight;
+	u32 buf_id;
+
+	struct tw5864_buf *vb;
+
+	struct v4l2_ctrl *md_threshold_grid_ctrl;
+	u16 md_threshold_grid_values[12 * 16];
+	int qp;
+	int gop;
+
+	/*
+	 * In (1/MAX_FPS) units.
+	 * For max FPS (default), set to 1.
+	 * For 1 FPS, set to e.g. 32.
+	 */
+	int frame_interval;
+	unsigned long new_frame_deadline;
+};
+
+struct tw5864_h264_frame {
+	struct tw5864_dma_buf vlc;
+	struct tw5864_dma_buf mv;
+	int vlc_len;
+	u32 checksum;
+	struct tw5864_input *input;
+	u64 timestamp;
+	unsigned int seqno;
+	unsigned int gop_seqno;
+};
+
+/* global device status */
+struct tw5864_dev {
+	spinlock_t slock; /* used for sync between ISR, tasklet & V4L2 API */
+	struct v4l2_device v4l2_dev;
+	struct tw5864_input inputs[TW5864_INPUTS];
+#define H264_BUF_CNT 4
+	struct tw5864_h264_frame h264_buf[H264_BUF_CNT];
+	int h264_buf_r_index;
+	int h264_buf_w_index;
+
+	struct tasklet_struct tasklet;
+
+	int encoder_busy;
+	/* Input number to check next for ready raw picture (in RR fashion) */
+	int next_input;
+
+	/* pci i/o */
+	char name[64];
+	struct pci_dev *pci;
+	void __iomem *mmio;
+	u32 irqmask;
+};
+
+#define tw_readl(reg) readl(dev->mmio + reg)
+#define tw_mask_readl(reg, mask) \
+	(tw_readl(reg) & (mask))
+#define tw_mask_shift_readl(reg, mask, shift) \
+	(tw_mask_readl((reg), ((mask) << (shift))) >> (shift))
+
+#define tw_writel(reg, value) writel((value), dev->mmio + reg)
+#define tw_mask_writel(reg, mask, value) \
+	tw_writel(reg, (tw_readl(reg) & ~(mask)) | ((value) & (mask)))
+#define tw_mask_shift_writel(reg, mask, shift, value) \
+	tw_mask_writel((reg), ((mask) << (shift)), ((value) << (shift)))
+
+#define tw_setl(reg, bit) tw_writel((reg), tw_readl(reg) | (bit))
+#define tw_clearl(reg, bit) tw_writel((reg), tw_readl(reg) & ~(bit))
+
+u8 tw5864_indir_readb(struct tw5864_dev *dev, u16 addr);
+#define tw_indir_readb(addr) tw5864_indir_readb(dev, addr)
+void tw5864_indir_writeb(struct tw5864_dev *dev, u16 addr, u8 data);
+#define tw_indir_writeb(addr, data) tw5864_indir_writeb(dev, addr, data)
+
+void tw5864_irqmask_apply(struct tw5864_dev *dev);
+int tw5864_video_init(struct tw5864_dev *dev, int *video_nr);
+void tw5864_video_fini(struct tw5864_dev *dev);
+void tw5864_prepare_frame_headers(struct tw5864_input *input);
+void tw5864_h264_put_stream_header(u8 **buf, size_t *space_left, int qp,
+				   int width, int height);
+void tw5864_h264_put_slice_header(u8 **buf, size_t *space_left,
+				  unsigned int idr_pic_id,
+				  unsigned int frame_gop_seqno,
+				  int *tail_nb_bits, u8 *tail);
+void tw5864_request_encoded_frame(struct tw5864_input *input);
-- 
2.8.4

