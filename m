Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:40623 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab0IKBVz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 21:21:55 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Sat, 11 Sep 2010 03:21:22 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201009110317.54899.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009110321.25852.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This is a V4L2 driver for TI OMAP1 SoC camera interface.

Both videobuf-dma versions are supported, contig and sg, selectable with a 
module option. The former uses less processing power, but often fails to 
allocate contignuous buffer memory. The latter is free of this problem, but 
generates tens of DMA interrupts per frame. If contig memory allocation ever 
fails, the driver falls back to sg automatically on next open, but still can 
be switched back to contig manually. Both paths work stable for me, even 
under heavy load, on my OMAP1510 based Amstrad Delta videophone, that is the 
oldest, least powerfull OMAP1 implementation.

The interface generally works in pass-through mode. Since input data byte 
endianess can be swapped, it provides up to two v4l2 pixel formats per each of 
several soc_mbus formats that have their swapped endian counterparts.

Boards using this driver can provide it with the followning information:
- if and what freqency clock is expected by an on-board camera sensor,
- what is the maximum pixel clock that should be accepted from the sensor,
- what is the polarity of the sensor provided pixel clock,
- if the interface GPIO line is connected to a sensor reset/powerdown input 
  and what is the input polarity.

Created and tested against linux-2.6.36-rc3 on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Friday 30 July 2010 13:07:42 Guennadi Liakhovetski wrote:
> So, I think, a very welcome improvement to the driver would be a 
> cleaner separation between the two cases. Don't try that much to reuse the
> code as much as possible. Would be much better to have clean separation
> between the two implementations - whether dynamically switchable at
> runtime or at config time - would be best to separate the two
> implementations to the point, where each of them becomes understandable
> and maintainable.

Guennadi,
I've tried to rearrange them spearated, as you requested, but finally decided 
to keep them together, as before, only better documented and cleaned up as 
much as possible. I'm rather satisfied with the result, but if you think it 
is still not enough understandable and maintainable, I'll take one more 
iteration and split both paths.

Besides, there are a few my not yet answered questions or suggestions (see 
http://www.spinics.net/lists/linux-media/msg21615.html for original message):

Friday 30 July 2010 20:49:05 Janusz Krzysztofik wrote:
> Friday 30 July 2010 13:07:42 Guennadi Liakhovetski wrote:
> > On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:
> > > This is a V4L2 driver for TI OMAP1 SoC camera interface.

...
> > > +
> > > +	u32			reg_cache[OMAP1_CAMERA_IOSIZE / sizeof(u32)];
> >
> > Don't think you'd lose much performance without cache, for that the code
> > would become less error-prone.
>
> The reason is my bad experience with my hardware audio interface. For my
> rationale regarding OMAP McBSP register caching, please look at this
> commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=96fbd74551e9cae8fd5e9cb62a0a19336a3064fa 
> or the foregoing discussions (links both to my initial and final submitions):
> http://thread.gmane.org/gmane.linux.alsa.devel/65675
> http://thread.gmane.org/gmane.linux.ports.arm.omap/29708
>
> However, I haven't noticed any similiar flaws in camera interface yet, so
> if you think that caching would not be helpful in any possible future
> (context save/restore) enhancements here, then I can drop it.
...
> > Don't you have to update the cache on a direct read?
>
> If I do it unconditionally, I'd loose the read error prevention function of
> register caching idea.

I've kept register caching for now, only replaced a few not intentional reads 
from hardware with more sensible reads from cache. Please confirm if you 
prefere me dropping register caching anyways.

...
> > > +static void videobuf_done(struct omap1_cam_dev *pcdev,
> > > +		enum videobuf_state result)
> > > +{
> > > +	...
> > > +	if (waitqueue_active(&vb->done)) {
> >
> > I'm not sure this is a good idea. Why are you reusing the buffer, if
> > noone is waiting for it _now_? It can well be, that the task is doing
> > something else atm. Like processing the previous frame. Or it has been
> > preempted by another process, before it called poll() or select() on your
> > device?
>
> I've introduced this way of videobuf handling after learning, form the
> Documentation/video4linux/videobuf, what the first step of filling a buffer
> should be:
>
> "- Obtain the next available buffer and make sure that somebody is actually
>    waiting for it."
>
> Since I had no idea how I could implement it, I decided to do it a bit
> differently: start filling a buffer unconditionally, then drop its contents
> if not awaited by any user when done
> 
> > > ...
> > > +	} else if (pcdev->ready) {
> > > +		dev_dbg(dev, "%s: nobody waiting on videobuf, swap with next\n",
> > > +				__func__);
> >
> > Not sure this is a wise decision... If there are more buffers in the
> > queue, they stay there waiting. Best remove this waitqueue_active() check
> > entirely, just complete buffers and wake up the user regardless. If no
> > more buffers - go to sleep.
>
> If you think I don't have to follow the above mentioned requirement for not
> servicing a buffer unless someone is waiting for it, then yes, I'll drop
> these overcomplicated bits. Please confirm.

One more reference to Documentation/video4linux/videobuf:

"It is equally possible that nobody is yet interested in the
buffer; the driver should not remove it from the list or fill it until a
process is waiting on it."

Please review my now better commented code again, and confirm if you still 
expect me to rearrange it, ignoring the documentation provided requirements.

...
> > > +static int omap1_cam_set_crop(struct soc_camera_device *icd,
> > > +			       struct v4l2_crop *crop)
> > > +{
> > > ...
> > > +	icd->user_width	 = rect->width;
> > > +	icd->user_height = rect->height;
> >
> > No, this is wrong. user_width and user_height are _user_ sizes, i.e., a
> > result sensor cropping and scaling and host cropping and scaling. Whereas
> > set_crop sets sensor input rectangle.
>
> I'm not sure if I understand what you mean. Should I drop these
> assignments? Or correct them? If yes, how they should be calculated?
>
> In Documentation/video4linux/soc-camera.txt, you say:
> "The core updates these fields upon successful completion of a .s_fmt()
> call, but if these fields change elsewhere, e.g., during .s_crop()
> processing, the host driver is responsible for updating them."
>
> I thought this is the case we're dealing with here.

Please confirm if I my understanding of what the documentation says is wrong 
and I should really correct the above.

Thanks,
Janusz


v1->v2 changes:

requested by Guennadi Liakhovetski (thanks!):
- first try contig, and if it fails - fall back to sg; invalidates next two,
- invalidated: Kconfig: VIDEO_OMAP1_SG: not need "if", the "depends on" should 
  suffice,
- invalidated: include both <media/videobuf-dma-contig.h> and 
  <media/videobuf-dma-sg.h> headers,
- extensively document buffer manipulations, better yet clean it up,
- a copyright / licence header was missing form a header file, 
- need to #include <linux/bitops.h> if using BIT() macro,
- don't need macros representing frequencies - use numbers directly,
- add a few missing "static" qualifiers,
- use u32 type for register content handling,
- some cached registers were unnecessarily read from the hardware directly,
- use true/false constants instead of 0/1 for booleans,
- avoid assigning variables inside other constructs,
- don't need to test if RAZ_FIFO is cleared,
- no need to split "\n" to a new line, don't worry about > 80 characters,
- don't increment field_count in case of a VIDEOBUF_ERROR,
- adjust mbus format codes to the new names,
- make is_dma_aligned() return value a bool,
- no need to align frame line lenghts to integer number of DMA elements,
- drop a few superflous whitespace, braces, etc.,
- use correct multiline comment style,
- follow some good-style rules when defining a multi-line function-like macro,
- drop tests for impossible bool < 0,
- that's not an error when S_FMT sets a format different from what the user
  has requested, just use whatever you managed to configure,
- as a general rule, try_fmt shouldn't fail,
- use sensor_reset() instead of duplicating its code,
- first shut down the hardware, and only then unconfigure software,

suggested by Ralph Corderoy (thanks!):
- include vb->state's value in the debug messages instead of just "unknown",
- correct a few print formats,
- don't use goto if return is all that needs to be done,

other:
- correct a few issues reported with "checkpatch.pl --strict".
- refreshed against linux-2.6.36-rc3


 drivers/media/video/Kconfig        |    8
 drivers/media/video/Makefile       |    1
 drivers/media/video/omap1_camera.c | 1781 +++++++++++++++++++++++++++++++++++++
 include/media/omap1_camera.h       |   35
 4 files changed, 1825 insertions(+)


diff -upr linux-2.6.36-rc3.orig/drivers/media/video/Kconfig linux-2.6.36-rc3/drivers/media/video/Kconfig
--- linux-2.6.36-rc3.orig/drivers/media/video/Kconfig	2010-09-03 22:29:37.000000000 +0200
+++ linux-2.6.36-rc3/drivers/media/video/Kconfig	2010-09-09 17:55:52.000000000 +0200
@@ -890,6 +890,14 @@ config VIDEO_SH_MOBILE_CEU
 	---help---
 	  This is a v4l2 driver for the SuperH Mobile CEU Interface
 
+config VIDEO_OMAP1
+	tristate "OMAP1 Camera Interface driver"
+	depends on VIDEO_DEV && ARCH_OMAP1 && SOC_CAMERA
+	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF_DMA_SG
+	---help---
+	  This is a v4l2 driver for the TI OMAP1 camera interface
+
 config VIDEO_OMAP2
 	tristate "OMAP2 Camera Capture Interface driver"
 	depends on VIDEO_DEV && ARCH_OMAP2
diff -upr linux-2.6.36-rc3.orig/drivers/media/video/Makefile linux-2.6.36-rc3/drivers/media/video/Makefile
--- linux-2.6.36-rc3.orig/drivers/media/video/Makefile	2010-09-03 22:29:37.000000000 +0200
+++ linux-2.6.36-rc3/drivers/media/video/Makefile	2010-09-09 17:55:52.000000000 +0200
@@ -163,6 +163,7 @@ obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
+obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
diff -upr linux-2.6.36-rc3.orig/drivers/media/video/omap1_camera.c linux-2.6.36-rc3/drivers/media/video/omap1_camera.c
--- linux-2.6.36-rc3.orig/drivers/media/video/omap1_camera.c	2010-09-03 22:34:02.000000000 +0200
+++ linux-2.6.36-rc3/drivers/media/video/omap1_camera.c	2010-09-09 15:58:22.000000000 +0200
@@ -0,0 +1,1781 @@
+/*
+ * V4L2 SoC Camera driver for OMAP1 Camera Interface
+ *
+ * Copyright (C) 2010, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
+ *
+ * Based on V4L2 Driver for i.MXL/i.MXL camera (CSI) host
+ * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
+ * Copyright (C) 2009, Darius Augulis <augulis.darius@gmail.com>
+ *
+ * Based on PXA SoC camera driver
+ * Copyright (C) 2006, Sascha Hauer, Pengutronix
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * Hardware specific bits initialy based on former work by Matt Callow
+ * drivers/media/video/omap/omap1510cam.c
+ * Copyright (C) 2006 Matt Callow
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+
+#include <media/omap1_camera.h>
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
+#include <media/videobuf-dma-contig.h>
+#include <media/videobuf-dma-sg.h>
+
+#include <plat/dma.h>
+
+
+#define DRIVER_NAME		"omap1-camera"
+#define VERSION_CODE		KERNEL_VERSION(0, 0, 1)
+
+
+/*
+ * ---------------------------------------------------------------------------
+ *  OMAP1 Camera Interface registers
+ * ---------------------------------------------------------------------------
+ */
+
+#define REG_CTRLCLOCK		0x00
+#define REG_IT_STATUS		0x04
+#define REG_MODE		0x08
+#define REG_STATUS		0x0C
+#define REG_CAMDATA		0x10
+#define REG_GPIO		0x14
+#define REG_PEAK_COUNTER	0x18
+
+/* CTRLCLOCK bit shifts */
+#define LCLK_EN			BIT(7)
+#define DPLL_EN			BIT(6)
+#define MCLK_EN			BIT(5)
+#define CAMEXCLK_EN		BIT(4)
+#define POLCLK			BIT(3)
+#define FOSCMOD_SHIFT		0
+#define FOSCMOD_MASK		(0x7 << FOSCMOD_SHIFT)
+#define FOSCMOD_12MHz		0x0
+#define FOSCMOD_6MHz		0x2
+#define FOSCMOD_9_6MHz		0x4
+#define FOSCMOD_24MHz		0x5
+#define FOSCMOD_8MHz		0x6
+
+/* IT_STATUS bit shifts */
+#define DATA_TRANSFER		BIT(5)
+#define FIFO_FULL		BIT(4)
+#define H_DOWN			BIT(3)
+#define H_UP			BIT(2)
+#define V_DOWN			BIT(1)
+#define V_UP			BIT(0)
+
+/* MODE bit shifts */
+#define RAZ_FIFO		BIT(18)
+#define EN_FIFO_FULL		BIT(17)
+#define EN_NIRQ			BIT(16)
+#define THRESHOLD_SHIFT		9
+#define THRESHOLD_MASK		(0x7f << THRESHOLD_SHIFT)
+#define DMA			BIT(8)
+#define EN_H_DOWN		BIT(7)
+#define EN_H_UP			BIT(6)
+#define EN_V_DOWN		BIT(5)
+#define EN_V_UP			BIT(4)
+#define ORDERCAMD		BIT(3)
+
+#define IRQ_MASK		(EN_V_UP | EN_V_DOWN | EN_H_UP | EN_H_DOWN | \
+				 EN_NIRQ | EN_FIFO_FULL)
+
+/* STATUS bit shifts */
+#define HSTATUS			BIT(1)
+#define VSTATUS			BIT(0)
+
+/* GPIO bit shifts */
+#define CAM_RST			BIT(0)
+
+/* end of OMAP1 Camera Interface registers */
+
+
+#define SOCAM_BUS_FLAGS	(SOCAM_MASTER | \
+			SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH | \
+			SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING | \
+			SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8)
+
+
+#define FIFO_SIZE		((THRESHOLD_MASK >> THRESHOLD_SHIFT) + 1)
+#define FIFO_SHIFT		__fls(FIFO_SIZE)
+
+#define DMA_BURST_SHIFT		(1 + OMAP_DMA_DATA_BURST_4)
+#define DMA_BURST_SIZE		(1 << DMA_BURST_SHIFT)
+
+#define DMA_ELEMENT_SHIFT	OMAP_DMA_DATA_TYPE_S32
+#define DMA_ELEMENT_SIZE	(1 << DMA_ELEMENT_SHIFT)
+
+#define DMA_FRAME_SHIFT_CONTIG	(FIFO_SHIFT - 1)
+#define DMA_FRAME_SHIFT_SG	DMA_BURST_SHIFT
+
+#define DMA_FRAME_SHIFT(x)	(x ? DMA_FRAME_SHIFT_SG : \
+						DMA_FRAME_SHIFT_CONTIG)
+#define DMA_FRAME_SIZE(x)	(1 << DMA_FRAME_SHIFT(x))
+#define DMA_SYNC		OMAP_DMA_SYNC_FRAME
+#define THRESHOLD_LEVEL		DMA_FRAME_SIZE
+
+
+#define MAX_VIDEO_MEM		4	/* arbitrary video memory limit in MB */
+
+
+/*
+ * Structures
+ */
+
+/* buffer for one video frame */
+struct omap1_cam_buf {
+	struct videobuf_buffer		vb;
+	enum v4l2_mbus_pixelcode	code;
+	int				inwork;
+	struct scatterlist		*sgbuf;
+	int				sgcount;
+	int				bytes_left;
+	enum videobuf_state		result;
+};
+
+struct omap1_cam_dev {
+	struct soc_camera_host		soc_host;
+	struct soc_camera_device	*icd;
+	struct clk			*clk;
+
+	unsigned int			irq;
+	void __iomem			*base;
+
+	int				dma_ch;
+
+	struct omap1_cam_platform_data	*pdata;
+	struct resource			*res;
+	unsigned long			pflags;
+	unsigned long			camexclk;
+
+	struct list_head		capture;
+
+	/* lock used to protect videobuf */
+	spinlock_t			lock;
+
+	u32				reg_cache[OMAP1_CAMERA_IOSIZE /
+							sizeof(u32)];
+
+	/* Pointers to DMA buffers */
+	struct omap1_cam_buf		*active;
+	struct omap1_cam_buf		*ready;
+
+	enum omap1_cam_vb_mode		vb_mode;
+	int				(*mmap_mapper)(struct videobuf_queue *q,
+						struct videobuf_buffer *buf,
+						struct vm_area_struct *vma);
+};
+
+
+static void cam_write(struct omap1_cam_dev *pcdev, u16 reg, u32 val)
+{
+	pcdev->reg_cache[reg / sizeof(u32)] = val;
+	__raw_writel(val, pcdev->base + reg);
+}
+
+static u32 cam_read(struct omap1_cam_dev *pcdev, u16 reg, bool from_cache)
+{
+	return !from_cache ? __raw_readl(pcdev->base + reg) :
+			pcdev->reg_cache[reg / sizeof(u32)];
+}
+
+#define CAM_READ(pcdev, reg) \
+		cam_read(pcdev, REG_##reg, false)
+#define CAM_WRITE(pcdev, reg, val) \
+		cam_write(pcdev, REG_##reg, val)
+#define CAM_READ_CACHE(pcdev, reg) \
+		cam_read(pcdev, REG_##reg, true)
+
+/*
+ *  Videobuf operations
+ */
+static int omap1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
+		unsigned int *size)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+			icd->current_fmt->host_fmt);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	*size = bytes_per_line * icd->user_height;
+
+	if (!*count || *count < OMAP1_CAMERA_MIN_BUF_COUNT(pcdev->vb_mode))
+		*count = OMAP1_CAMERA_MIN_BUF_COUNT(pcdev->vb_mode);
+
+	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
+		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
+
+	dev_dbg(icd->dev.parent,
+			"%s: count=%d, size=%d\n", __func__, *count, *size);
+
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct omap1_cam_buf *buf,
+		enum omap1_cam_vb_mode vb_mode)
+{
+	struct videobuf_buffer *vb = &buf->vb;
+
+	BUG_ON(in_interrupt());
+
+	videobuf_waiton(vb, 0, 0);
+
+	if (vb_mode == CONTIG) {
+		videobuf_dma_contig_free(vq, vb);
+	} else {
+		struct soc_camera_device *icd = vq->priv_data;
+		struct device *dev = icd->dev.parent;
+		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+
+		videobuf_dma_unmap(dev, dma);
+		videobuf_dma_free(dma);
+	}
+
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int omap1_videobuf_prepare(struct videobuf_queue *vq,
+		struct videobuf_buffer *vb, enum v4l2_field field)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct omap1_cam_buf *buf = container_of(vb, struct omap1_cam_buf, vb);
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+			icd->current_fmt->host_fmt);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	int ret;
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	WARN_ON(!list_empty(&vb->queue));
+
+	BUG_ON(NULL == icd->current_fmt);
+
+	buf->inwork = 1;
+
+	if (buf->code != icd->current_fmt->code || vb->field != field ||
+			vb->width  != icd->user_width ||
+			vb->height != icd->user_height) {
+		buf->code  = icd->current_fmt->code;
+		vb->width  = icd->user_width;
+		vb->height = icd->user_height;
+		vb->field  = field;
+		vb->state  = VIDEOBUF_NEEDS_INIT;
+	}
+
+	vb->size = bytes_per_line * vb->height;
+
+	if (vb->baddr && vb->bsize < vb->size) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret)
+			goto fail;
+
+		vb->state = VIDEOBUF_PREPARED;
+	}
+	buf->inwork = 0;
+
+	return 0;
+fail:
+	free_buffer(vq, buf, pcdev->vb_mode);
+out:
+	buf->inwork = 0;
+	return ret;
+}
+
+static void set_dma_dest_params(int dma_ch, struct omap1_cam_buf *buf,
+		enum omap1_cam_vb_mode vb_mode)
+{
+	dma_addr_t dma_addr;
+	unsigned int block_size;
+
+	if (vb_mode == CONTIG) {
+		dma_addr = videobuf_to_dma_contig(&buf->vb);
+		block_size = buf->vb.size;
+	} else {
+		if (WARN_ON(!buf->sgbuf)) {
+			buf->result = VIDEOBUF_ERROR;
+			return;
+		}
+		dma_addr = sg_dma_address(buf->sgbuf);
+		if (WARN_ON(!dma_addr)) {
+			buf->sgbuf = NULL;
+			buf->result = VIDEOBUF_ERROR;
+			return;
+		}
+		block_size = sg_dma_len(buf->sgbuf);
+		if (WARN_ON(!block_size)) {
+			buf->sgbuf = NULL;
+			buf->result = VIDEOBUF_ERROR;
+			return;
+		}
+		if (unlikely(buf->bytes_left < block_size))
+			block_size = buf->bytes_left;
+		if (WARN_ON(dma_addr & (DMA_FRAME_SIZE(vb_mode) *
+				DMA_ELEMENT_SIZE - 1))) {
+			dma_addr = ALIGN(dma_addr, DMA_FRAME_SIZE(vb_mode) *
+					DMA_ELEMENT_SIZE);
+			block_size &= ~(DMA_FRAME_SIZE(vb_mode) *
+					DMA_ELEMENT_SIZE - 1);
+		}
+		buf->bytes_left -= block_size;
+		buf->sgcount++;
+	}
+
+	omap_set_dma_dest_params(dma_ch,
+		OMAP_DMA_PORT_EMIFF, OMAP_DMA_AMODE_POST_INC, dma_addr, 0, 0);
+	omap_set_dma_transfer_params(dma_ch,
+		OMAP_DMA_DATA_TYPE_S32, DMA_FRAME_SIZE(vb_mode),
+		block_size >> (DMA_FRAME_SHIFT(vb_mode) + DMA_ELEMENT_SHIFT),
+		DMA_SYNC, 0, 0);
+}
+
+static struct omap1_cam_buf *prepare_next_vb(struct omap1_cam_dev *pcdev)
+{
+	struct omap1_cam_buf *buf;
+
+	/*
+	 * If there is already a buffer pointed out by the pcdev->ready,
+	 * (re)use it, otherwise try to fetch and configure a new one.
+	 */
+	buf = pcdev->ready;
+	if (!buf) {
+		if (list_empty(&pcdev->capture))
+			return buf;
+		buf = list_entry(pcdev->capture.next,
+				struct omap1_cam_buf, vb.queue);
+		buf->vb.state = VIDEOBUF_ACTIVE;
+		pcdev->ready = buf;
+		list_del_init(&buf->vb.queue);
+	}
+
+	if (pcdev->vb_mode == CONTIG) {
+		/*
+		 * In CONTIG mode, we can safely enter next buffer parameters
+		 * into the DMA programming register set after the DMA
+		 * has already been activated on the previous buffer
+		 */
+		set_dma_dest_params(pcdev->dma_ch, buf, pcdev->vb_mode);
+	} else {
+		/*
+		 * In SG mode, the above is not safe since there are probably
+		 * a bunch of sgbufs from previous sglist still pending.
+		 * Instead, mark the sglist fresh for the upcoming
+		 * try_next_sgbuf().
+		 */
+		buf->sgbuf = NULL;
+	}
+
+	return buf;
+}
+
+static struct scatterlist *try_next_sgbuf(int dma_ch, struct omap1_cam_buf *buf)
+{
+	struct scatterlist *sgbuf;
+
+	if (likely(buf->sgbuf)) {
+		/* current sglist is active */
+		if (unlikely(!buf->bytes_left)) {
+			/* indicate sglist complete */
+			sgbuf = NULL;
+		} else {
+			/* process next sgbuf */
+			sgbuf = sg_next(buf->sgbuf);
+			if (WARN_ON(!sgbuf)) {
+				buf->result = VIDEOBUF_ERROR;
+			} else if (WARN_ON(!sg_dma_len(sgbuf))) {
+				sgbuf = NULL;
+				buf->result = VIDEOBUF_ERROR;
+			}
+		}
+		buf->sgbuf = sgbuf;
+	} else {
+		/* sglist is fresh, initialize it before using */
+		struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
+
+		sgbuf = dma->sglist;
+		if (!(WARN_ON(!sgbuf))) {
+			buf->sgbuf = sgbuf;
+			buf->sgcount = 0;
+			buf->bytes_left = buf->vb.size;
+			buf->result = VIDEOBUF_DONE;
+		}
+	}
+	if (sgbuf)
+		/*
+		 * Put our next sgbuf parameters (address, size)
+		 * into the DMA programming register set.
+		 */
+		set_dma_dest_params(dma_ch, buf, SG);
+
+	return sgbuf;
+}
+
+static void start_capture(struct omap1_cam_dev *pcdev)
+{
+	struct omap1_cam_buf *buf = pcdev->active;
+	u32 ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
+	u32 mode = CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN;
+
+	if (WARN_ON(!buf))
+		return;
+
+	/*
+	 * Enable start of frame interrupt, which we will use for activating
+	 * our end of frame watchdog when capture actually starts.
+	 */
+	mode |= EN_V_UP;
+
+	if (unlikely(ctrlclock & LCLK_EN))
+		/* stop pixel clock before FIFO reset */
+		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
+	/* reset FIFO */
+	CAM_WRITE(pcdev, MODE, mode | RAZ_FIFO);
+
+	omap_start_dma(pcdev->dma_ch);
+
+	if (pcdev->vb_mode == SG) {
+		/*
+		 * In SG mode, it's a good moment for fetching next sgbuf
+		 * from the current sglist and, if available, already putting
+		 * its parameters into the DMA programming register set.
+		 */
+		try_next_sgbuf(pcdev->dma_ch, buf);
+	}
+
+	/* (re)enable pixel clock */
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock | LCLK_EN);
+	/* release FIFO reset */
+	CAM_WRITE(pcdev, MODE, mode);
+}
+
+static void suspend_capture(struct omap1_cam_dev *pcdev)
+{
+	u32 ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
+
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
+	omap_stop_dma(pcdev->dma_ch);
+}
+
+static void disable_capture(struct omap1_cam_dev *pcdev)
+{
+	u32 mode = CAM_READ_CACHE(pcdev, MODE);
+
+	CAM_WRITE(pcdev, MODE, mode & ~(IRQ_MASK | DMA));
+}
+
+static void omap1_videobuf_queue(struct videobuf_queue *vq,
+						struct videobuf_buffer *vb)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	struct omap1_cam_buf *buf;
+	u32 mode;
+
+	list_add_tail(&vb->queue, &pcdev->capture);
+	vb->state = VIDEOBUF_QUEUED;
+
+	if (pcdev->active)
+		return;
+
+	WARN_ON(pcdev->ready);
+
+	buf = prepare_next_vb(pcdev);
+	if (WARN_ON(!buf))
+		return;
+
+	pcdev->active = buf;
+	pcdev->ready = NULL;
+
+	dev_dbg(icd->dev.parent,
+		"%s: capture not active, setup FIFO, start DMA\n", __func__);
+	mode = CAM_READ_CACHE(pcdev, MODE) & ~THRESHOLD_MASK;
+	mode |= THRESHOLD_LEVEL(pcdev->vb_mode) << THRESHOLD_SHIFT;
+	CAM_WRITE(pcdev, MODE, mode | EN_FIFO_FULL | DMA);
+
+	if (pcdev->vb_mode == SG) {
+		/*
+		 * In SG mode, the above prepare_next_vb() didn't actually
+		 * put anything into the DMA programming register set,
+		 * so we have to do it now, before activating DMA.
+		 */
+		try_next_sgbuf(pcdev->dma_ch, buf);
+	}
+
+	start_capture(pcdev);
+}
+
+static void omap1_videobuf_release(struct videobuf_queue *vq,
+				 struct videobuf_buffer *vb)
+{
+	struct omap1_cam_buf *buf =
+			container_of(vb, struct omap1_cam_buf, vb);
+	struct soc_camera_device *icd = vq->priv_data;
+	struct device *dev = icd->dev.parent;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+
+	switch (vb->state) {
+	case VIDEOBUF_DONE:
+		dev_dbg(dev, "%s (done)\n", __func__);
+		break;
+	case VIDEOBUF_ACTIVE:
+		dev_dbg(dev, "%s (active)\n", __func__);
+		break;
+	case VIDEOBUF_QUEUED:
+		dev_dbg(dev, "%s (queued)\n", __func__);
+		break;
+	case VIDEOBUF_PREPARED:
+		dev_dbg(dev, "%s (prepared)\n", __func__);
+		break;
+	default:
+		dev_dbg(dev, "%s (unknown %d)\n", __func__, vb->state);
+		break;
+	}
+
+	free_buffer(vq, buf, pcdev->vb_mode);
+}
+
+static void videobuf_done(struct omap1_cam_dev *pcdev,
+		enum videobuf_state result)
+{
+	struct omap1_cam_buf *buf = pcdev->active;
+	struct videobuf_buffer *vb;
+	struct device *dev = pcdev->icd->dev.parent;
+
+	if (WARN_ON(!buf)) {
+		suspend_capture(pcdev);
+		disable_capture(pcdev);
+		return;
+	}
+
+	if (result == VIDEOBUF_ERROR)
+		suspend_capture(pcdev);
+
+	vb = &buf->vb;
+	if (waitqueue_active(&vb->done)) {
+		if (!pcdev->ready && result != VIDEOBUF_ERROR)
+			/*
+			 * No next buffer has been entered into the DMA
+			 * programming register set on time, so best we can do
+			 * is stopping the capture before last DMA block,
+			 * whether our CONTIG mode whole buffer or its last
+			 * sgbuf in SG mode, gets overwritten by next frame.
+			 */
+			suspend_capture(pcdev);
+		vb->state = result;
+		do_gettimeofday(&vb->ts);
+		if (result != VIDEOBUF_ERROR)
+			vb->field_count++;
+		wake_up(&vb->done);
+
+		/* shift in next buffer */
+		buf = pcdev->ready;
+		pcdev->active = buf;
+		pcdev->ready = NULL;
+
+		if (!buf) {
+			/*
+			 * No next buffer was ready on time (see above), so
+			 * indicate error condition to force capture restart or
+			 * stop, depending on next buffer already queued or not.
+			 */
+			result = VIDEOBUF_ERROR;
+			prepare_next_vb(pcdev);
+
+			buf = pcdev->ready;
+			pcdev->active = buf;
+			pcdev->ready = NULL;
+		}
+	} else if (pcdev->ready) {
+		/*
+		 * In both CONTIG and SG mode, the DMA engine has (might)
+		 * already been autoreinitialized with the preprogrammed
+		 * pcdev->ready buffer.  We can either accept this fact
+		 * and just swap the buffers, or provoke an error condition
+		 * and restart capture.  The former seems less intrusive.
+		 */
+		dev_dbg(dev, "%s: nobody waiting on videobuf, swap with next\n",
+				__func__);
+		pcdev->active = pcdev->ready;
+
+		if (pcdev->vb_mode == SG) {
+			/*
+			 * In SG mode, we have to make sure that the buffer we
+			 * are putting back into the pcdev->ready is marked
+			 * fresh.
+			 */
+			buf->sgbuf = NULL;
+		}
+		pcdev->ready = buf;
+
+		buf = pcdev->active;
+	} else {
+		/*
+		 * No next buffer has been entered into
+		 * the DMA programming register set on time.
+		 */
+		if (pcdev->vb_mode == CONTIG) {
+			/*
+			 * In CONTIG mode, the DMA engine has already been
+			 * reinitialized with the current buffer. Best we can do
+			 * is not touching it.
+			 */
+			dev_dbg(dev,
+				"%s: nobody waiting on videobuf, reuse it\n",
+				__func__);
+		} else {
+			/*
+			 * In SG mode, the DMA engine has just been
+			 * autoreinitialized with the last sgbuf from the
+			 * current list. Restart capture in order to transfer
+			 * next frame start into the first sgbuf, not the last
+			 * one.
+			 */
+			if (result != VIDEOBUF_ERROR) {
+				suspend_capture(pcdev);
+				result = VIDEOBUF_ERROR;
+			}
+		}
+	}
+
+	if (!buf) {
+		dev_dbg(dev, "%s: no more videobufs, stop capture\n", __func__);
+		disable_capture(pcdev);
+		return;
+	}
+
+	if (pcdev->vb_mode == CONTIG) {
+		/*
+		 * In CONTIG mode, the current buffer parameters had already
+		 * been entered into the DMA programming register set while the
+		 * buffer was fetched with prepare_next_vb(), they may have also
+		 * been transfered into the runtime set and already active if
+		 * the DMA still running.
+		 */
+	} else {
+		/* In SG mode, extra steps are required */
+		if (result == VIDEOBUF_ERROR)
+			/* make sure we (re)use sglist from start on error */
+			buf->sgbuf = NULL;
+
+		/*
+		 * In any case, enter the next sgbuf parameters into the DMA
+		 * programming register set.  They will be used either during
+		 * nearest DMA autoreinitialization or, in case of an error,
+		 * on DMA startup below.
+		 */
+		try_next_sgbuf(pcdev->dma_ch, buf);
+	}
+
+	if (result == VIDEOBUF_ERROR) {
+		dev_dbg(dev, "%s: videobuf error; reset FIFO, restart DMA\n",
+				__func__);
+		start_capture(pcdev);
+		/*
+		 * In SG mode, the above also resulted in the next sgbuf
+		 * parameters being entered into the DMA programming register
+		 * set, making them ready for next DMA autoreinitialization.
+		 */
+	}
+
+	/*
+	 * Finally, try fetching next buffer.  In CONTIG mode, it will also
+	 * get entered it into the DMA programming register set,
+	 * making it ready for next DMA autoreinitialization.
+	 */
+	prepare_next_vb(pcdev);
+}
+
+static void dma_isr(int channel, unsigned short status, void *data)
+{
+	struct omap1_cam_dev *pcdev = data;
+	struct omap1_cam_buf *buf = pcdev->active;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	if (WARN_ON(!buf)) {
+		suspend_capture(pcdev);
+		disable_capture(pcdev);
+		goto out;
+	}
+
+	if (pcdev->vb_mode == CONTIG) {
+		/*
+		 * In CONTIG mode, assume we have just managed to collect the
+		 * whole frame, hopefully before our end of frame watchdog is
+		 * triggered. Then, all we have to do is disabling the watchdog
+		 * for this frame, and calling videobuf_done() with success
+		 * indicated.
+		 */
+		CAM_WRITE(pcdev, MODE,
+				CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN);
+		videobuf_done(pcdev, VIDEOBUF_DONE);
+	} else {
+		/*
+		 * In SG mode, we have to process every sgbuf from the current
+		 * sglist, one after another.
+		 */
+		if (buf->sgbuf) {
+			/*
+			 * Current sglist not completed yet, try fetching next
+			 * sgbuf, hopefully putting it into the DMA programming
+			 * register set, making it ready for next DMA
+			 * autoreinitialization.
+			 */
+			try_next_sgbuf(pcdev->dma_ch, buf);
+			if (buf->sgbuf)
+				goto out;
+
+			/* no more sgbufs in the current sglist */
+			if (buf->result != VIDEOBUF_ERROR) {
+				/*
+				 * Video frame collected without errors, we can
+				 * prepare for collecting a next one as soon as
+				 * DMA gets autoreinitialized after the currennt
+				 * (last) sgbuf is completed.
+				 */
+				buf = prepare_next_vb(pcdev);
+				if (!buf)
+					goto out;
+
+				try_next_sgbuf(pcdev->dma_ch, buf);
+				goto out;
+			}
+		}
+		/* end of videobuf */
+		videobuf_done(pcdev, buf->result);
+	}
+
+out:
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+}
+
+static irqreturn_t cam_isr(int irq, void *data)
+{
+	struct omap1_cam_dev *pcdev = data;
+	struct device *dev = pcdev->icd->dev.parent;
+	struct omap1_cam_buf *buf = pcdev->active;
+	u32 it_status;
+	unsigned long flags;
+
+	it_status = CAM_READ(pcdev, IT_STATUS);
+	if (!it_status)
+		return IRQ_NONE;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	if (WARN_ON(!buf)) {
+		dev_warn(dev, "%s: unhandled camera interrupt, status == "
+				"0x%0x\n", __func__, it_status);
+		suspend_capture(pcdev);
+		disable_capture(pcdev);
+		goto out;
+	}
+
+	if (unlikely(it_status & FIFO_FULL)) {
+		dev_warn(dev, "%s: FIFO overflow\n", __func__);
+
+	} else if (it_status & V_DOWN) {
+		/* end of video frame watchdog */
+		if (pcdev->vb_mode == CONTIG) {
+			/*
+			 * In CONTIG mode, the watchdog is disabled with
+			 * successful DMA end of block interrupt, and reenabled
+			 * on next frame start. If we get here, there is nothing
+			 * to check, we must be out of sync.
+			 */
+		} else {
+			if (buf->sgcount == 2) {
+				/*
+				 * If exactly 2 sgbufs from the next sglist has
+				 * been programmed into the DMA engine (the
+				 * frist one already transfered into the DMA
+				 * runtime register set, the second one still
+				 * in the programming set), then we are in sync.
+				 */
+				goto out;
+			}
+		}
+		dev_notice(dev, "%s: unexpected end of video frame\n",
+				__func__);
+
+	} else if (it_status & V_UP) {
+		u32 mode;
+
+		if (pcdev->vb_mode == CONTIG) {
+			/*
+			 * In CONTIG mode, we need this interrupt every frame
+			 * in oredr to reenable our end of frame watchdog.
+			 */
+			mode = CAM_READ_CACHE(pcdev, MODE);
+		} else {
+			/*
+			 * In SG mode, the below enabled end of frame watchdog
+			 * is kept on permanently, so we can turn this one shot
+			 * setup off.
+			 */
+			mode = CAM_READ_CACHE(pcdev, MODE) & ~EN_V_UP;
+		}
+
+		if (!(mode & EN_V_DOWN)) {
+			/* (re)enable end of frame watchdog interrupt */
+			mode |= EN_V_DOWN;
+		}
+		CAM_WRITE(pcdev, MODE, mode);
+		goto out;
+
+	} else {
+		dev_warn(dev, "%s: unhandled camera interrupt, status == "
+				"0x%0x\n", __func__, it_status);
+		goto out;
+	}
+
+	videobuf_done(pcdev, VIDEOBUF_ERROR);
+out:
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+	return IRQ_HANDLED;
+}
+
+static struct videobuf_queue_ops omap1_videobuf_ops = {
+	.buf_setup	= omap1_videobuf_setup,
+	.buf_prepare	= omap1_videobuf_prepare,
+	.buf_queue	= omap1_videobuf_queue,
+	.buf_release	= omap1_videobuf_release,
+};
+
+
+/*
+ * SOC Camera host operations
+ */
+
+static void sensor_reset(struct omap1_cam_dev *pcdev, bool reset)
+{
+	/* apply/release camera sensor reset if requested by platform data */
+	if (pcdev->pflags & OMAP1_CAMERA_RST_HIGH)
+		CAM_WRITE(pcdev, GPIO, reset);
+	else if (pcdev->pflags & OMAP1_CAMERA_RST_LOW)
+		CAM_WRITE(pcdev, GPIO, !reset);
+}
+
+/*
+ * The following two functions absolutely depend on the fact, that
+ * there can be only one camera on OMAP1 camera sensor interface
+ */
+static int omap1_cam_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	u32 ctrlclock;
+
+	if (pcdev->icd)
+		return -EBUSY;
+
+	clk_enable(pcdev->clk);
+
+	/* setup sensor clock */
+	ctrlclock = CAM_READ(pcdev, CTRLCLOCK);
+	ctrlclock &= ~(CAMEXCLK_EN | MCLK_EN | DPLL_EN);
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
+
+	ctrlclock &= ~FOSCMOD_MASK;
+	switch (pcdev->camexclk) {
+	case 6000000:
+		ctrlclock |= CAMEXCLK_EN | FOSCMOD_6MHz;
+		break;
+	case 8000000:
+		ctrlclock |= CAMEXCLK_EN | FOSCMOD_8MHz | DPLL_EN;
+		break;
+	case 9600000:
+		ctrlclock |= CAMEXCLK_EN | FOSCMOD_9_6MHz | DPLL_EN;
+		break;
+	case 12000000:
+		ctrlclock |= CAMEXCLK_EN | FOSCMOD_12MHz;
+		break;
+	case 24000000:
+		ctrlclock |= CAMEXCLK_EN | FOSCMOD_24MHz | DPLL_EN;
+	default:
+		break;
+	}
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~DPLL_EN);
+
+	/* enable internal clock */
+	ctrlclock |= MCLK_EN;
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
+
+	sensor_reset(pcdev, false);
+
+	pcdev->icd = icd;
+
+	dev_info(icd->dev.parent, "OMAP1 Camera driver attached to camera %d\n",
+			icd->devnum);
+	return 0;
+}
+
+static void omap1_cam_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	u32 ctrlclock;
+
+	BUG_ON(icd != pcdev->icd);
+
+	suspend_capture(pcdev);
+	disable_capture(pcdev);
+
+	sensor_reset(pcdev, true);
+
+	/* disable and release system clocks */
+	ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
+	ctrlclock &= ~(MCLK_EN | DPLL_EN | CAMEXCLK_EN);
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
+
+	ctrlclock = (ctrlclock & ~FOSCMOD_MASK) | FOSCMOD_12MHz;
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock | MCLK_EN);
+
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~MCLK_EN);
+
+	clk_disable(pcdev->clk);
+
+	pcdev->icd = NULL;
+
+	dev_info(icd->dev.parent,
+		"OMAP1 Camera driver detached from camera %d\n", icd->devnum);
+}
+
+/* Duplicate standard formats based on host capability of byte swapping */
+static const struct soc_mbus_pixelfmt omap1_cam_formats[] = {
+	[V4L2_MBUS_FMT_UYVY8_2X8] = {
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.name			= "YUYV",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+	[V4L2_MBUS_FMT_VYUY8_2X8] = {
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.name			= "YVYU",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+	[V4L2_MBUS_FMT_YUYV8_2X8] = {
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "UYVY",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+	[V4L2_MBUS_FMT_YVYU8_2X8] = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.name			= "VYUY",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+	[V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE] = {
+		.fourcc			= V4L2_PIX_FMT_RGB555,
+		.name			= "RGB555",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+	[V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE] = {
+		.fourcc			= V4L2_PIX_FMT_RGB555X,
+		.name			= "RGB555X",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+	[V4L2_MBUS_FMT_RGB565_2X8_BE] = {
+		.fourcc			= V4L2_PIX_FMT_RGB565,
+		.name			= "RGB565",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+	[V4L2_MBUS_FMT_RGB565_2X8_LE] = {
+		.fourcc			= V4L2_PIX_FMT_RGB565X,
+		.name			= "RGB565X",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+};
+
+static int omap1_cam_get_formats(struct soc_camera_device *icd,
+		unsigned int idx, struct soc_camera_format_xlate *xlate)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct device *dev = icd->dev.parent;
+	int formats = 0, ret;
+	enum v4l2_mbus_pixelcode code;
+	const struct soc_mbus_pixelfmt *fmt;
+
+	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
+
+	fmt = soc_mbus_get_fmtdesc(code);
+	if (!fmt) {
+		dev_err(dev, "%s: invalid format code #%d: %d\n", __func__,
+				idx, code);
+		return 0;
+	}
+
+	/* Check support for the requested bits-per-sample */
+	if (fmt->bits_per_sample != 8)
+		return 0;
+
+	switch (code) {
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
+	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
+	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+		formats++;
+		if (xlate) {
+			xlate->host_fmt	= &omap1_cam_formats[code];
+			xlate->code	= code;
+			xlate++;
+			dev_dbg(dev, "%s: providing format %s "
+					"as byte swapped code #%d\n", __func__,
+					omap1_cam_formats[code].name, code);
+		}
+	default:
+		if (xlate)
+			dev_dbg(dev, "%s: providing format %s "
+					"in pass-through mode\n", __func__,
+					fmt->name);
+	}
+	formats++;
+	if (xlate) {
+		xlate->host_fmt	= fmt;
+		xlate->code	= code;
+		xlate++;
+	}
+
+	return formats;
+}
+
+static bool is_dma_aligned(s32 bytes_per_line, unsigned int height)
+{
+	int size = bytes_per_line * height;
+
+	return IS_ALIGNED(bytes_per_line, DMA_ELEMENT_SIZE) &&
+			IS_ALIGNED(size, DMA_FRAME_SIZE(CONTIG) *
+			DMA_ELEMENT_SIZE);
+}
+
+static int dma_align(int *width, int *height,
+		const struct soc_mbus_pixelfmt *fmt, bool enlarge)
+{
+	s32 bytes_per_line = soc_mbus_bytes_per_line(*width, fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	if (!is_dma_aligned(bytes_per_line, *height)) {
+		unsigned int pxalign = __fls(bytes_per_line / *width);
+		unsigned int salign  = DMA_FRAME_SHIFT(CONTIG) +
+				DMA_ELEMENT_SHIFT - pxalign;
+		unsigned int incr    = enlarge << salign;
+
+		v4l_bound_align_image(width, 1, *width + incr, 0,
+				height, 1, *height + incr, 0, salign);
+		return 0;
+	}
+	return 1;
+}
+
+/* returns 1 on g_crop() success, 0 on cropcap() success, <0 on error */
+static int get_crop(struct soc_camera_device *icd, struct v4l2_rect *rect)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct device *dev = icd->dev.parent;
+	struct v4l2_crop crop;
+	int ret;
+
+	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = v4l2_subdev_call(sd, video, g_crop, &crop);
+	if (ret == -ENOIOCTLCMD) {
+		struct v4l2_cropcap cc;
+
+		dev_dbg(dev, "%s: g_crop() missing, trying cropcap() instead\n",
+				__func__);
+		cc.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		ret = v4l2_subdev_call(sd, video, cropcap, &cc);
+		if (ret < 0)
+			return ret;
+		*rect = cc.defrect;
+		return 0;
+	} else if (ret < 0) {
+		return ret;
+	}
+	*rect = crop.c;
+	return 1;
+}
+
+/*
+ * returns 1 on g_mbus_fmt() or g_crop() success, 0 on cropcap() success,
+ * <0 on error
+ */
+static int get_geometry(struct soc_camera_device *icd, struct v4l2_rect *rect,
+		enum v4l2_mbus_pixelcode code)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct device *dev = icd->dev.parent;
+	struct v4l2_mbus_framefmt mf;
+	int ret;
+
+	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	if (ret == -ENOIOCTLCMD) {
+		struct v4l2_rect c;
+
+		dev_dbg(dev,
+			"%s: g_mbus_fmt() missing, trying g_crop() instead\n",
+			__func__);
+		ret = get_crop(icd, &c);
+		if (ret < 0)
+			return ret;
+
+		if (ret) {
+			*rect = c;	/* use g_crop() result */
+		} else {
+			dev_warn(dev, "%s: current geometry not available\n",
+					__func__);
+			return 0;
+		}
+	} else if (ret < 0) {
+		return ret;
+	} else if (mf.code != code) {
+		return -EINVAL;
+	} else {
+		rect->width  = mf.width;
+		rect->height = mf.height;
+	}
+	return 1;
+}
+
+#define subdev_call_with_sense(pcdev, dev, icd, sd, function, args...)	   \
+({									   \
+	struct soc_camera_sense sense = {				   \
+		.master_clock		= pcdev->camexclk,		   \
+		.pixel_clock_max	= 0,				   \
+	};								   \
+	int __ret;							   \
+									   \
+	if (pcdev->pdata)						   \
+		sense.pixel_clock_max = pcdev->pdata->lclk_khz_max * 1000; \
+	icd->sense = &sense;						   \
+	__ret = v4l2_subdev_call(sd, video, function, ##args);		   \
+	icd->sense = NULL;						   \
+									   \
+	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {			   \
+		if (sense.pixel_clock > sense.pixel_clock_max) {	   \
+			dev_err(dev, "%s: pixel clock %lu "		   \
+					"set by the camera too high!\n",   \
+					__func__, sense.pixel_clock);	   \
+			__ret = -EINVAL;				   \
+		}							   \
+	}								   \
+	__ret;								   \
+})
+
+static int omap1_cam_set_crop(struct soc_camera_device *icd,
+			       struct v4l2_crop *crop)
+{
+	struct v4l2_rect *rect = &crop->c;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	struct device *dev = icd->dev.parent;
+	s32 bytes_per_line;
+	int ret;
+
+	ret = dma_align(&rect->width, &rect->height, icd->current_fmt->host_fmt,
+			false);
+	if (ret < 0) {
+		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
+				__func__, rect->width, rect->height,
+				icd->current_fmt->host_fmt->name);
+		return ret;
+	}
+
+	subdev_call_with_sense(pcdev, dev, icd, sd, s_crop, crop);
+	if (ret < 0) {
+		dev_warn(dev, "%s: failed to crop to %ux%u@%u:%u\n", __func__,
+			 rect->width, rect->height, rect->left, rect->top);
+		return ret;
+	}
+
+	ret = get_geometry(icd, rect, icd->current_fmt->code);
+	if (ret < 0) {
+		dev_err(dev, "%s: get_geometry() failed\n", __func__);
+		return ret;
+	}
+	if (!ret)
+		dev_warn(dev, "%s: unable to verify s_crop() results\n",
+				__func__);
+
+	bytes_per_line = soc_mbus_bytes_per_line(rect->width,
+			icd->current_fmt->host_fmt);
+	if (bytes_per_line < 0) {
+		dev_err(dev, "%s: soc_mbus_bytes_per_line() failed\n",
+				__func__);
+		return bytes_per_line;
+	}
+
+	ret = is_dma_aligned(bytes_per_line, rect->height);
+	if (!ret) {
+		dev_err(dev, "%s: resulting geometry %ux%u not DMA aligned\n",
+				__func__, rect->width, rect->height);
+		return -EINVAL;
+	}
+
+	icd->user_width	 = rect->width;
+	icd->user_height = rect->height;
+
+	return ret;
+}
+
+static int omap1_cam_set_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_camera_format_xlate *xlate;
+	struct device *dev = icd->dev.parent;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
+	struct v4l2_crop crop;
+	struct v4l2_rect *rect = &crop.c;
+	int bytes_per_line;
+	int ret;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(dev, "%s: format %#x not found\n", __func__,
+				pix->pixelformat);
+		return -EINVAL;
+	}
+
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
+
+	ret = subdev_call_with_sense(pcdev, dev, icd, sd, s_mbus_fmt, &mf);
+	if (ret < 0) {
+		dev_err(dev, "%s: failed to set format\n", __func__);
+		return ret;
+	}
+
+	if (mf.code != xlate->code) {
+		dev_err(dev, "%s: unexpected pixel code change\n", __func__);
+		return -EINVAL;
+	}
+
+	pix->width		= mf.width;
+	pix->height		= mf.height;
+	pix->field		= mf.field;
+	pix->colorspace		= mf.colorspace;
+	icd->current_fmt	= xlate;
+
+	ret = dma_align(&pix->width, &pix->height, xlate->host_fmt, false);
+	if (ret < 0) {
+		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
+				__func__, pix->width, pix->height,
+				xlate->host_fmt->name);
+		return ret;
+	}
+
+	if (ret == 1) {
+		/* sensor returned geometry was already DMA aligned */
+		return 0;
+	}
+
+	dev_notice(dev, "%s: sensor geometry not DMA aligned, trying to crop to"
+			" %ux%u\n", __func__, pix->width, pix->height);
+	ret = get_crop(icd, rect);
+	if (ret < 0) {
+		dev_err(dev, "%s: get_crop() failed\n", __func__);
+		return ret;
+	}
+
+	rect->width  = pix->width;
+	rect->height = pix->height;
+
+	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	subdev_call_with_sense(pcdev, dev, icd, sd, s_crop, &crop);
+	if (ret < 0) {
+		dev_err(dev, "%s: failed to crop to %ux%u@%u:%u\n", __func__,
+			 rect->width, rect->height, rect->left, rect->top);
+		return ret;
+	}
+
+	ret = get_geometry(icd, rect, xlate->code);
+	if (ret < 0) {
+		dev_err(dev, "%s: get_geometry() failed\n", __func__);
+		return ret;
+	}
+
+	if (!ret)
+		dev_warn(dev, "%s: s_crop() results not confirmed\n", __func__);
+
+	bytes_per_line = soc_mbus_bytes_per_line(rect->width, xlate->host_fmt);
+	if (bytes_per_line < 0) {
+		dev_err(dev, "%s: soc_mbus_bytes_per_line() failed\n",
+				__func__);
+		return bytes_per_line;
+	}
+
+	ret = is_dma_aligned(bytes_per_line, rect->height);
+	if (!ret) {
+		dev_err(dev, "%s: resulting geometry %ux%u not DMA aligned\n",
+				__func__, rect->width, rect->height);
+		return -EINVAL;
+	}
+
+	pix->width  = rect->width;
+	pix->height = rect->height;
+
+	return 0;
+}
+
+static int omap1_cam_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
+	int ret;
+	/* TODO: limit to mx1 hardware capabilities */
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(icd->dev.parent, "Format %#x not found\n",
+			 pix->pixelformat);
+		return -EINVAL;
+	}
+
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
+
+	/* limit to sensor capabilities */
+	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
+
+	pix->width	= mf.width;
+	pix->height	= mf.height;
+	pix->field	= mf.field;
+	pix->colorspace	= mf.colorspace;
+
+	return 0;
+}
+
+static bool sg_mode;
+
+/*
+ * Local mmap_mapper wrapper,
+ * used for detecting videobuf-dma-contig buffer allocation failures
+ * and switching to videobuf-dma-sg automatically for future attempts.
+ */
+static int omap1_cam_mmap_mapper(struct videobuf_queue *q,
+				  struct videobuf_buffer *buf,
+				  struct vm_area_struct *vma)
+{
+	struct soc_camera_device *icd = q->priv_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	int ret;
+
+	ret = pcdev->mmap_mapper(q, buf, vma);
+
+	if (ret == -ENOMEM)
+		sg_mode = 1;
+
+	return ret;
+}
+
+static void omap1_cam_init_videobuf(struct videobuf_queue *q,
+				     struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+
+	if (!sg_mode)
+		videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
+				icd->dev.parent, &pcdev->lock,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
+				sizeof(struct omap1_cam_buf), icd);
+	else
+		videobuf_queue_sg_init(q, &omap1_videobuf_ops,
+				icd->dev.parent, &pcdev->lock,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
+				sizeof(struct omap1_cam_buf), icd);
+
+	/* use videobuf mode (auto)selected with the module parameter */
+	pcdev->vb_mode = sg_mode ? SG : CONTIG;
+
+	/*
+	 * Ensure we substitute the videobuf-dma-contig version of the
+	 * mmap_mapper() callback with our own wrapper, used for switching
+	 * automatically to videobuf-dma-sg on buffer allocation failure.
+	 */
+	if (!sg_mode && q->int_ops->mmap_mapper != omap1_cam_mmap_mapper) {
+		pcdev->mmap_mapper = q->int_ops->mmap_mapper;
+		q->int_ops->mmap_mapper = omap1_cam_mmap_mapper;
+	}
+}
+
+static int omap1_cam_reqbufs(struct soc_camera_file *icf,
+			      struct v4l2_requestbuffers *p)
+{
+	int i;
+
+	/*
+	 * This is for locking debugging only. I removed spinlocks and now I
+	 * check whether .prepare is ever called on a linked buffer, or whether
+	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
+	 * it hadn't triggered
+	 */
+	for (i = 0; i < p->count; i++) {
+		struct omap1_cam_buf *buf = container_of(icf->vb_vidq.bufs[i],
+						      struct omap1_cam_buf, vb);
+		buf->inwork = 0;
+		INIT_LIST_HEAD(&buf->vb.queue);
+	}
+
+	return 0;
+}
+
+static int omap1_cam_querycap(struct soc_camera_host *ici,
+			       struct v4l2_capability *cap)
+{
+	/* cap->name is set by the friendly caller:-> */
+	strlcpy(cap->card, "OMAP1 Camera", sizeof(cap->card));
+	cap->version = VERSION_CODE;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int omap1_cam_set_bus_param(struct soc_camera_device *icd,
+		__u32 pixfmt)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct omap1_cam_dev *pcdev = ici->priv;
+	struct device *dev = icd->dev.parent;
+	const struct soc_camera_format_xlate *xlate;
+	const struct soc_mbus_pixelfmt *fmt;
+	unsigned long camera_flags, common_flags;
+	u32 ctrlclock, mode;
+	int ret;
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+	common_flags = soc_camera_bus_param_compatible(camera_flags,
+			SOCAM_BUS_FLAGS);
+	if (!common_flags)
+		return -EINVAL;
+
+	/* Make choices, possibly based on platform configuration */
+	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
+			(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+		if (!pcdev->pdata ||
+				pcdev->pdata->flags & OMAP1_CAMERA_LCLK_RISING)
+			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+		else
+			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+	}
+
+	ret = icd->ops->set_bus_param(icd, common_flags);
+	if (ret < 0)
+		return ret;
+
+	ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
+	if (ctrlclock & LCLK_EN)
+		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
+
+	if (common_flags & SOCAM_PCLK_SAMPLE_RISING) {
+		dev_dbg(dev, "CTRLCLOCK_REG |= POLCLK\n");
+		ctrlclock |= POLCLK;
+	} else {
+		dev_dbg(dev, "CTRLCLOCK_REG &= ~POLCLK\n");
+		ctrlclock &= ~POLCLK;
+	}
+	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
+
+	if (ctrlclock & LCLK_EN)
+		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
+
+	/* select bus endianess */
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	fmt = xlate->host_fmt;
+
+	mode = CAM_READ(pcdev, MODE) & ~(RAZ_FIFO | IRQ_MASK | DMA);
+	if (fmt->order == SOC_MBUS_ORDER_LE) {
+		dev_dbg(dev, "MODE_REG &= ~ORDERCAMD\n");
+		CAM_WRITE(pcdev, MODE, mode & ~ORDERCAMD);
+	} else {
+		dev_dbg(dev, "MODE_REG |= ORDERCAMD\n");
+		CAM_WRITE(pcdev, MODE, mode | ORDERCAMD);
+	}
+
+	return 0;
+}
+
+static unsigned int omap1_cam_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct omap1_cam_buf *buf;
+
+	buf = list_entry(icf->vb_vidq.stream.next, struct omap1_cam_buf,
+			 vb.stream);
+
+	poll_wait(file, &buf->vb.done, pt);
+
+	if (buf->vb.state == VIDEOBUF_DONE ||
+	    buf->vb.state == VIDEOBUF_ERROR)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static struct soc_camera_host_ops omap1_host_ops = {
+	.owner		= THIS_MODULE,
+	.add		= omap1_cam_add_device,
+	.remove		= omap1_cam_remove_device,
+	.get_formats	= omap1_cam_get_formats,
+	.set_crop	= omap1_cam_set_crop,
+	.set_fmt	= omap1_cam_set_fmt,
+	.try_fmt	= omap1_cam_try_fmt,
+	.init_videobuf	= omap1_cam_init_videobuf,
+	.reqbufs	= omap1_cam_reqbufs,
+	.querycap	= omap1_cam_querycap,
+	.set_bus_param	= omap1_cam_set_bus_param,
+	.poll		= omap1_cam_poll,
+};
+
+static int __init omap1_cam_probe(struct platform_device *pdev)
+{
+	struct omap1_cam_dev *pcdev;
+	struct resource *res;
+	struct clk *clk;
+	void __iomem *base;
+	unsigned int irq;
+	int err = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!res || (int)irq <= 0) {
+		err = -ENODEV;
+		goto exit;
+	}
+
+	clk = clk_get(&pdev->dev, "armper_ck");
+	if (IS_ERR(clk)) {
+		err = PTR_ERR(clk);
+		goto exit;
+	}
+
+	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
+	if (!pcdev) {
+		dev_err(&pdev->dev, "Could not allocate pcdev\n");
+		err = -ENOMEM;
+		goto exit_put_clk;
+	}
+
+	pcdev->res = res;
+	pcdev->clk = clk;
+
+	pcdev->pdata = pdev->dev.platform_data;
+	pcdev->pflags = pcdev->pdata->flags;
+
+	if (pcdev->pdata)
+		pcdev->camexclk = pcdev->pdata->camexclk_khz * 1000;
+
+	switch (pcdev->camexclk) {
+	case 6000000:
+	case 8000000:
+	case 9600000:
+	case 12000000:
+	case 24000000:
+		break;
+	default:
+		dev_warn(&pdev->dev,
+				"Incorrect sensor clock frequency %ld kHz, "
+				"should be one of 0, 6, 8, 9.6, 12 or 24 MHz, "
+				"please correct your platform data\n",
+				pcdev->pdata->camexclk_khz);
+		pcdev->camexclk = 0;
+	case 0:
+		dev_info(&pdev->dev,
+				"Not providing sensor clock\n");
+	}
+
+	INIT_LIST_HEAD(&pcdev->capture);
+	spin_lock_init(&pcdev->lock);
+
+	/*
+	 * Request the region.
+	 */
+	if (!request_mem_region(res->start, resource_size(res), DRIVER_NAME)) {
+		err = -EBUSY;
+		goto exit_kfree;
+	}
+
+	base = ioremap(res->start, resource_size(res));
+	if (!base) {
+		err = -ENOMEM;
+		goto exit_release;
+	}
+	pcdev->irq = irq;
+	pcdev->base = base;
+
+	sensor_reset(pcdev, true);
+
+	err = omap_request_dma(OMAP_DMA_CAMERA_IF_RX, DRIVER_NAME,
+			dma_isr, (void *)pcdev, &pcdev->dma_ch);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Can't request DMA for OMAP1 Camera\n");
+		err = -EBUSY;
+		goto exit_iounmap;
+	}
+	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_ch);
+
+	/* preconfigure DMA */
+	omap_set_dma_src_params(pcdev->dma_ch, OMAP_DMA_PORT_TIPB,
+			OMAP_DMA_AMODE_CONSTANT, res->start + REG_CAMDATA,
+			0, 0);
+	omap_set_dma_dest_burst_mode(pcdev->dma_ch, OMAP_DMA_DATA_BURST_4);
+	/* setup DMA autoinitialization */
+	omap_dma_link_lch(pcdev->dma_ch, pcdev->dma_ch);
+
+	err = request_irq(pcdev->irq, cam_isr, 0, DRIVER_NAME, pcdev);
+	if (err) {
+		dev_err(&pdev->dev, "Camera interrupt register failed\n");
+		goto exit_free_dma;
+	}
+
+	pcdev->soc_host.drv_name	= DRIVER_NAME;
+	pcdev->soc_host.ops		= &omap1_host_ops;
+	pcdev->soc_host.priv		= pcdev;
+	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
+	pcdev->soc_host.nr		= pdev->id;
+
+	err = soc_camera_host_register(&pcdev->soc_host);
+	if (err)
+		goto exit_free_irq;
+
+	dev_info(&pdev->dev, "OMAP1 Camera Interface driver loaded\n");
+
+	return 0;
+
+exit_free_irq:
+	free_irq(pcdev->irq, pcdev);
+exit_free_dma:
+	omap_free_dma(pcdev->dma_ch);
+exit_iounmap:
+	iounmap(base);
+exit_release:
+	release_mem_region(res->start, resource_size(res));
+exit_kfree:
+	kfree(pcdev);
+exit_put_clk:
+	clk_put(clk);
+exit:
+	return err;
+}
+
+static int __exit omap1_cam_remove(struct platform_device *pdev)
+{
+	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
+	struct omap1_cam_dev *pcdev = container_of(soc_host,
+					struct omap1_cam_dev, soc_host);
+	struct resource *res;
+
+	free_irq(pcdev->irq, pcdev);
+
+	omap_free_dma(pcdev->dma_ch);
+
+	soc_camera_host_unregister(soc_host);
+
+	iounmap(pcdev->base);
+
+	res = pcdev->res;
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(pcdev);
+
+	clk_put(pcdev->clk);
+
+	dev_info(&pdev->dev, "OMAP1 Camera Interface driver unloaded\n");
+
+	return 0;
+}
+
+static struct platform_driver omap1_cam_driver = {
+	.driver		= {
+		.name	= DRIVER_NAME,
+	},
+	.probe		= omap1_cam_probe,
+	.remove		= __exit_p(omap1_cam_remove),
+};
+
+static int __init omap1_cam_init(void)
+{
+	return platform_driver_register(&omap1_cam_driver);
+}
+module_init(omap1_cam_init);
+
+static void __exit omap1_cam_exit(void)
+{
+	platform_driver_unregister(&omap1_cam_driver);
+}
+module_exit(omap1_cam_exit);
+
+module_param(sg_mode, bool, 0644);
+MODULE_PARM_DESC(sg_mode, "videobuf mode, 0: dma-contig (default), 1: dma-sg");
+
+MODULE_DESCRIPTION("OMAP1 Camera Interface driver");
+MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -upr linux-2.6.36-rc3.orig/include/media/omap1_camera.h linux-2.6.36-rc3/include/media/omap1_camera.h
--- linux-2.6.36-rc3.orig/include/media/omap1_camera.h	2010-09-03 22:34:02.000000000 +0200
+++ linux-2.6.36-rc3/include/media/omap1_camera.h	2010-09-08 23:41:12.000000000 +0200
@@ -0,0 +1,35 @@
+/*
+ * Header for V4L2 SoC Camera driver for OMAP1 Camera Interface
+ *
+ * Copyright (C) 2010, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MEDIA_OMAP1_CAMERA_H_
+#define __MEDIA_OMAP1_CAMERA_H_
+
+#include <linux/bitops.h>
+
+#define OMAP1_CAMERA_IOSIZE		0x1c
+
+enum omap1_cam_vb_mode {
+	CONTIG = 0,
+	SG,
+};
+
+#define OMAP1_CAMERA_MIN_BUF_COUNT(x)	((x) == CONTIG ? 3 : 2)
+
+struct omap1_cam_platform_data {
+	unsigned long	camexclk_khz;
+	unsigned long	lclk_khz_max;
+	unsigned long	flags;
+};
+
+#define OMAP1_CAMERA_LCLK_RISING	BIT(0)
+#define OMAP1_CAMERA_RST_LOW		BIT(1)
+#define OMAP1_CAMERA_RST_HIGH		BIT(2)
+
+#endif /* __MEDIA_OMAP1_CAMERA_H_ */
