Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab2HNUzl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 16:55:41 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7EKtf7M030288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 16:55:41 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: =?true?q?=5BPATCH=2006/12=5D=20=5Bmedia=5D=20move=20the=20remaining=20PCI=20devices=20to=20drivers/media/pci?=
Date: Tue, 14 Aug 2012 17:55:21 -0300
Message-Id: <1344977727-16319-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
References: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move meye and sta2x11_vip into the drivers/media/pci subdirs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/Kconfig               |    6 +
 drivers/media/pci/Makefile              |    2 +
 drivers/media/pci/meye/Kconfig          |   13 +
 drivers/media/pci/meye/Makefile         |    1 +
 drivers/media/pci/meye/meye.c           | 1964 +++++++++++++++++++++++++++++++
 drivers/media/pci/meye/meye.h           |  324 +++++
 drivers/media/pci/sta2x11/Kconfig       |   12 +
 drivers/media/pci/sta2x11/Makefile      |    1 +
 drivers/media/pci/sta2x11/sta2x11_vip.c | 1550 ++++++++++++++++++++++++
 drivers/media/pci/sta2x11/sta2x11_vip.h |   40 +
 drivers/media/video/Kconfig             |   45 -
 drivers/media/video/Makefile            |    2 -
 drivers/media/video/meye.c              | 1964 -------------------------------
 drivers/media/video/meye.h              |  324 -----
 drivers/media/video/sta2x11_vip.c       | 1550 ------------------------
 drivers/media/video/sta2x11_vip.h       |   40 -
 16 files changed, 3913 insertions(+), 3925 deletions(-)
 create mode 100644 drivers/media/pci/meye/Kconfig
 create mode 100644 drivers/media/pci/meye/Makefile
 create mode 100644 drivers/media/pci/meye/meye.c
 create mode 100644 drivers/media/pci/meye/meye.h
 create mode 100644 drivers/media/pci/sta2x11/Kconfig
 create mode 100644 drivers/media/pci/sta2x11/Makefile
 create mode 100644 drivers/media/pci/sta2x11/sta2x11_vip.c
 create mode 100644 drivers/media/pci/sta2x11/sta2x11_vip.h
 delete mode 100644 drivers/media/video/meye.c
 delete mode 100644 drivers/media/video/meye.h
 delete mode 100644 drivers/media/video/sta2x11_vip.c
 delete mode 100644 drivers/media/video/sta2x11_vip.h

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index e1a9e1a..4243d5d 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -5,6 +5,12 @@
 menu "Media PCI Adapters"
 	visible if PCI && MEDIA_SUPPORT
 
+if MEDIA_CAMERA_SUPPORT
+	comment "Media capture support"
+source "drivers/media/pci/meye/Kconfig"
+source "drivers/media/pci/sta2x11/Kconfig"
+endif
+
 if MEDIA_ANALOG_TV_SUPPORT
 	comment "Media capture/analog TV support"
 source "drivers/media/pci/ivtv/Kconfig"
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index bb71e30..c8dc6c7 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -22,3 +22,5 @@ obj-$(CONFIG_VIDEO_CX88) += cx88/
 obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
 obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
+obj-$(CONFIG_VIDEO_MEYE) += meye/
+obj-$(CONFIG_STA2X11_VIP) += sta2x11/
diff --git a/drivers/media/pci/meye/Kconfig b/drivers/media/pci/meye/Kconfig
new file mode 100644
index 0000000..b4bf848
--- /dev/null
+++ b/drivers/media/pci/meye/Kconfig
@@ -0,0 +1,13 @@
+config VIDEO_MEYE
+	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
+	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
+	---help---
+	  This is the video4linux driver for the Motion Eye camera found
+	  in the Vaio Picturebook laptops. Please read the material in
+	  <file:Documentation/video4linux/meye.txt> for more information.
+
+	  If you say Y or M here, you need to say Y or M to "Sony Laptop
+	  Extras" in the misc device section.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called meye.
diff --git a/drivers/media/pci/meye/Makefile b/drivers/media/pci/meye/Makefile
new file mode 100644
index 0000000..4938851
--- /dev/null
+++ b/drivers/media/pci/meye/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_MEYE) += meye.o
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
new file mode 100644
index 0000000..7bc7752
--- /dev/null
+++ b/drivers/media/pci/meye/meye.c
@@ -0,0 +1,1964 @@
+/*
+ * Motion Eye video4linux driver for Sony Vaio PictureBook
+ *
+ * Copyright (C) 2001-2004 Stelian Pop <stelian@popies.net>
+ *
+ * Copyright (C) 2001-2002 Alcôve <www.alcove.com>
+ *
+ * Copyright (C) 2000 Andrew Tridgell <tridge@valinux.com>
+ *
+ * Earlier work by Werner Almesberger, Paul `Rusty' Russell and Paul Mackerras.
+ *
+ * Some parts borrowed from various video4linux drivers, especially
+ * bttv-driver.c and zoran.c, see original files for credits.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/gfp.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/vmalloc.h>
+#include <linux/dma-mapping.h>
+
+#include "meye.h"
+#include <linux/meye.h>
+
+MODULE_AUTHOR("Stelian Pop <stelian@popies.net>");
+MODULE_DESCRIPTION("v4l2 driver for the MotionEye camera");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(MEYE_DRIVER_VERSION);
+
+/* number of grab buffers */
+static unsigned int gbuffers = 2;
+module_param(gbuffers, int, 0444);
+MODULE_PARM_DESC(gbuffers, "number of capture buffers, default is 2 (32 max)");
+
+/* size of a grab buffer */
+static unsigned int gbufsize = MEYE_MAX_BUFSIZE;
+module_param(gbufsize, int, 0444);
+MODULE_PARM_DESC(gbufsize, "size of the capture buffers, default is 614400"
+		 " (will be rounded up to a page multiple)");
+
+/* /dev/videoX registration number */
+static int video_nr = -1;
+module_param(video_nr, int, 0444);
+MODULE_PARM_DESC(video_nr, "video device to register (0=/dev/video0, etc)");
+
+/* driver structure - only one possible */
+static struct meye meye;
+
+/****************************************************************************/
+/* Memory allocation routines (stolen from bttv-driver.c)                   */
+/****************************************************************************/
+static void *rvmalloc(unsigned long size)
+{
+	void *mem;
+	unsigned long adr;
+
+	size = PAGE_ALIGN(size);
+	mem = vmalloc_32(size);
+	if (mem) {
+		memset(mem, 0, size);
+		adr = (unsigned long) mem;
+		while (size > 0) {
+			SetPageReserved(vmalloc_to_page((void *)adr));
+			adr += PAGE_SIZE;
+			size -= PAGE_SIZE;
+		}
+	}
+	return mem;
+}
+
+static void rvfree(void * mem, unsigned long size)
+{
+	unsigned long adr;
+
+	if (mem) {
+		adr = (unsigned long) mem;
+		while ((long) size > 0) {
+			ClearPageReserved(vmalloc_to_page((void *)adr));
+			adr += PAGE_SIZE;
+			size -= PAGE_SIZE;
+		}
+		vfree(mem);
+	}
+}
+
+/*
+ * return a page table pointing to N pages of locked memory
+ *
+ * NOTE: The meye device expects DMA addresses on 32 bits, we build
+ * a table of 1024 entries = 4 bytes * 1024 = 4096 bytes.
+ */
+static int ptable_alloc(void)
+{
+	u32 *pt;
+	int i;
+
+	memset(meye.mchip_ptable, 0, sizeof(meye.mchip_ptable));
+
+	/* give only 32 bit DMA addresses */
+	if (dma_set_mask(&meye.mchip_dev->dev, DMA_BIT_MASK(32)))
+		return -1;
+
+	meye.mchip_ptable_toc = dma_alloc_coherent(&meye.mchip_dev->dev,
+						   PAGE_SIZE,
+						   &meye.mchip_dmahandle,
+						   GFP_KERNEL);
+	if (!meye.mchip_ptable_toc) {
+		meye.mchip_dmahandle = 0;
+		return -1;
+	}
+
+	pt = meye.mchip_ptable_toc;
+	for (i = 0; i < MCHIP_NB_PAGES; i++) {
+		dma_addr_t dma;
+		meye.mchip_ptable[i] = dma_alloc_coherent(&meye.mchip_dev->dev,
+							  PAGE_SIZE,
+							  &dma,
+							  GFP_KERNEL);
+		if (!meye.mchip_ptable[i]) {
+			int j;
+			pt = meye.mchip_ptable_toc;
+			for (j = 0; j < i; ++j) {
+				dma = (dma_addr_t) *pt;
+				dma_free_coherent(&meye.mchip_dev->dev,
+						  PAGE_SIZE,
+						  meye.mchip_ptable[j], dma);
+				pt++;
+			}
+			dma_free_coherent(&meye.mchip_dev->dev,
+					  PAGE_SIZE,
+					  meye.mchip_ptable_toc,
+					  meye.mchip_dmahandle);
+			meye.mchip_ptable_toc = NULL;
+			meye.mchip_dmahandle = 0;
+			return -1;
+		}
+		*pt = (u32) dma;
+		pt++;
+	}
+	return 0;
+}
+
+static void ptable_free(void)
+{
+	u32 *pt;
+	int i;
+
+	pt = meye.mchip_ptable_toc;
+	for (i = 0; i < MCHIP_NB_PAGES; i++) {
+		dma_addr_t dma = (dma_addr_t) *pt;
+		if (meye.mchip_ptable[i])
+			dma_free_coherent(&meye.mchip_dev->dev,
+					  PAGE_SIZE,
+					  meye.mchip_ptable[i], dma);
+		pt++;
+	}
+
+	if (meye.mchip_ptable_toc)
+		dma_free_coherent(&meye.mchip_dev->dev,
+				  PAGE_SIZE,
+				  meye.mchip_ptable_toc,
+				  meye.mchip_dmahandle);
+
+	memset(meye.mchip_ptable, 0, sizeof(meye.mchip_ptable));
+	meye.mchip_ptable_toc = NULL;
+	meye.mchip_dmahandle = 0;
+}
+
+/* copy data from ptable into buf */
+static void ptable_copy(u8 *buf, int start, int size, int pt_pages)
+{
+	int i;
+
+	for (i = 0; i < (size / PAGE_SIZE) * PAGE_SIZE; i += PAGE_SIZE) {
+		memcpy(buf + i, meye.mchip_ptable[start++], PAGE_SIZE);
+		if (start >= pt_pages)
+			start = 0;
+	}
+	memcpy(buf + i, meye.mchip_ptable[start], size % PAGE_SIZE);
+}
+
+/****************************************************************************/
+/* JPEG tables at different qualities to load into the VRJ chip             */
+/****************************************************************************/
+
+/* return a set of quantisation tables based on a quality from 1 to 10 */
+static u16 *jpeg_quantisation_tables(int *length, int quality)
+{
+	static u16 jpeg_tables[][70] = { {
+		0xdbff, 0x4300, 0xff00, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff,
+		0xdbff, 0x4300, 0xff01, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff,
+	},
+	{
+		0xdbff, 0x4300, 0x5000, 0x3c37, 0x3c46, 0x5032, 0x4146, 0x5a46,
+		0x5055, 0x785f, 0x82c8, 0x6e78, 0x786e, 0xaff5, 0x91b9, 0xffc8,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff,
+		0xdbff, 0x4300, 0x5501, 0x5a5a, 0x6978, 0xeb78, 0x8282, 0xffeb,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
+		0xffff, 0xffff, 0xffff,
+	},
+	{
+		0xdbff, 0x4300, 0x2800, 0x1e1c, 0x1e23, 0x2819, 0x2123, 0x2d23,
+		0x282b, 0x3c30, 0x4164, 0x373c, 0x3c37, 0x587b, 0x495d, 0x9164,
+		0x9980, 0x8f96, 0x8c80, 0xa08a, 0xe6b4, 0xa0c3, 0xdaaa, 0x8aad,
+		0xc88c, 0xcbff, 0xeeda, 0xfff5, 0xffff, 0xc19b, 0xffff, 0xfaff,
+		0xe6ff, 0xfffd, 0xfff8,
+		0xdbff, 0x4300, 0x2b01, 0x2d2d, 0x353c, 0x763c, 0x4141, 0xf876,
+		0x8ca5, 0xf8a5, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8,
+		0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8,
+		0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8,
+		0xf8f8, 0xf8f8, 0xfff8,
+	},
+	{
+		0xdbff, 0x4300, 0x1b00, 0x1412, 0x1417, 0x1b11, 0x1617, 0x1e17,
+		0x1b1c, 0x2820, 0x2b42, 0x2528, 0x2825, 0x3a51, 0x303d, 0x6042,
+		0x6555, 0x5f64, 0x5d55, 0x6a5b, 0x9978, 0x6a81, 0x9071, 0x5b73,
+		0x855d, 0x86b5, 0x9e90, 0xaba3, 0xabad, 0x8067, 0xc9bc, 0xa6ba,
+		0x99c7, 0xaba8, 0xffa4,
+		0xdbff, 0x4300, 0x1c01, 0x1e1e, 0x2328, 0x4e28, 0x2b2b, 0xa44e,
+		0x5d6e, 0xa46e, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4,
+		0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4,
+		0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4,
+		0xa4a4, 0xa4a4, 0xffa4,
+	},
+	{
+		0xdbff, 0x4300, 0x1400, 0x0f0e, 0x0f12, 0x140d, 0x1012, 0x1712,
+		0x1415, 0x1e18, 0x2132, 0x1c1e, 0x1e1c, 0x2c3d, 0x242e, 0x4932,
+		0x4c40, 0x474b, 0x4640, 0x5045, 0x735a, 0x5062, 0x6d55, 0x4556,
+		0x6446, 0x6588, 0x776d, 0x817b, 0x8182, 0x604e, 0x978d, 0x7d8c,
+		0x7396, 0x817e, 0xff7c,
+		0xdbff, 0x4300, 0x1501, 0x1717, 0x1a1e, 0x3b1e, 0x2121, 0x7c3b,
+		0x4653, 0x7c53, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c,
+		0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c,
+		0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c,
+		0x7c7c, 0x7c7c, 0xff7c,
+	},
+	{
+		0xdbff, 0x4300, 0x1000, 0x0c0b, 0x0c0e, 0x100a, 0x0d0e, 0x120e,
+		0x1011, 0x1813, 0x1a28, 0x1618, 0x1816, 0x2331, 0x1d25, 0x3a28,
+		0x3d33, 0x393c, 0x3833, 0x4037, 0x5c48, 0x404e, 0x5744, 0x3745,
+		0x5038, 0x516d, 0x5f57, 0x6762, 0x6768, 0x4d3e, 0x7971, 0x6470,
+		0x5c78, 0x6765, 0xff63,
+		0xdbff, 0x4300, 0x1101, 0x1212, 0x1518, 0x2f18, 0x1a1a, 0x632f,
+		0x3842, 0x6342, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363,
+		0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363,
+		0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363,
+		0x6363, 0x6363, 0xff63,
+	},
+	{
+		0xdbff, 0x4300, 0x0d00, 0x0a09, 0x0a0b, 0x0d08, 0x0a0b, 0x0e0b,
+		0x0d0e, 0x130f, 0x1520, 0x1213, 0x1312, 0x1c27, 0x171e, 0x2e20,
+		0x3129, 0x2e30, 0x2d29, 0x332c, 0x4a3a, 0x333e, 0x4636, 0x2c37,
+		0x402d, 0x4157, 0x4c46, 0x524e, 0x5253, 0x3e32, 0x615a, 0x505a,
+		0x4a60, 0x5251, 0xff4f,
+		0xdbff, 0x4300, 0x0e01, 0x0e0e, 0x1113, 0x2613, 0x1515, 0x4f26,
+		0x2d35, 0x4f35, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f,
+		0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f,
+		0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f,
+		0x4f4f, 0x4f4f, 0xff4f,
+	},
+	{
+		0xdbff, 0x4300, 0x0a00, 0x0707, 0x0708, 0x0a06, 0x0808, 0x0b08,
+		0x0a0a, 0x0e0b, 0x1018, 0x0d0e, 0x0e0d, 0x151d, 0x1116, 0x2318,
+		0x251f, 0x2224, 0x221f, 0x2621, 0x372b, 0x262f, 0x3429, 0x2129,
+		0x3022, 0x3141, 0x3934, 0x3e3b, 0x3e3e, 0x2e25, 0x4944, 0x3c43,
+		0x3748, 0x3e3d, 0xff3b,
+		0xdbff, 0x4300, 0x0a01, 0x0b0b, 0x0d0e, 0x1c0e, 0x1010, 0x3b1c,
+		0x2228, 0x3b28, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b,
+		0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b,
+		0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b,
+		0x3b3b, 0x3b3b, 0xff3b,
+	},
+	{
+		0xdbff, 0x4300, 0x0600, 0x0504, 0x0506, 0x0604, 0x0506, 0x0706,
+		0x0607, 0x0a08, 0x0a10, 0x090a, 0x0a09, 0x0e14, 0x0c0f, 0x1710,
+		0x1814, 0x1718, 0x1614, 0x1a16, 0x251d, 0x1a1f, 0x231b, 0x161c,
+		0x2016, 0x202c, 0x2623, 0x2927, 0x292a, 0x1f19, 0x302d, 0x282d,
+		0x2530, 0x2928, 0xff28,
+		0xdbff, 0x4300, 0x0701, 0x0707, 0x080a, 0x130a, 0x0a0a, 0x2813,
+		0x161a, 0x281a, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828,
+		0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828,
+		0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828,
+		0x2828, 0x2828, 0xff28,
+	},
+	{
+		0xdbff, 0x4300, 0x0300, 0x0202, 0x0203, 0x0302, 0x0303, 0x0403,
+		0x0303, 0x0504, 0x0508, 0x0405, 0x0504, 0x070a, 0x0607, 0x0c08,
+		0x0c0a, 0x0b0c, 0x0b0a, 0x0d0b, 0x120e, 0x0d10, 0x110e, 0x0b0e,
+		0x100b, 0x1016, 0x1311, 0x1514, 0x1515, 0x0f0c, 0x1817, 0x1416,
+		0x1218, 0x1514, 0xff14,
+		0xdbff, 0x4300, 0x0301, 0x0404, 0x0405, 0x0905, 0x0505, 0x1409,
+		0x0b0d, 0x140d, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414,
+		0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414,
+		0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414,
+		0x1414, 0x1414, 0xff14,
+	},
+	{
+		0xdbff, 0x4300, 0x0100, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0101, 0x0101, 0xff01,
+		0xdbff, 0x4300, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0101, 0x0101, 0xff01,
+	} };
+
+	if (quality < 0 || quality > 10) {
+		printk(KERN_WARNING
+		       "meye: invalid quality level %d - using 8\n", quality);
+		quality = 8;
+	}
+
+	*length = ARRAY_SIZE(jpeg_tables[quality]);
+	return jpeg_tables[quality];
+}
+
+/* return a generic set of huffman tables */
+static u16 *jpeg_huffman_tables(int *length)
+{
+	static u16 tables[] = {
+		0xC4FF, 0xB500, 0x0010, 0x0102, 0x0303, 0x0402, 0x0503, 0x0405,
+		0x0004, 0x0100, 0x017D, 0x0302, 0x0400, 0x0511, 0x2112, 0x4131,
+		0x1306, 0x6151, 0x2207, 0x1471, 0x8132, 0xA191, 0x2308, 0xB142,
+		0x15C1, 0xD152, 0x24F0, 0x6233, 0x8272, 0x0A09, 0x1716, 0x1918,
+		0x251A, 0x2726, 0x2928, 0x342A, 0x3635, 0x3837, 0x3A39, 0x4443,
+		0x4645, 0x4847, 0x4A49, 0x5453, 0x5655, 0x5857, 0x5A59, 0x6463,
+		0x6665, 0x6867, 0x6A69, 0x7473, 0x7675, 0x7877, 0x7A79, 0x8483,
+		0x8685, 0x8887, 0x8A89, 0x9392, 0x9594, 0x9796, 0x9998, 0xA29A,
+		0xA4A3, 0xA6A5, 0xA8A7, 0xAAA9, 0xB3B2, 0xB5B4, 0xB7B6, 0xB9B8,
+		0xC2BA, 0xC4C3, 0xC6C5, 0xC8C7, 0xCAC9, 0xD3D2, 0xD5D4, 0xD7D6,
+		0xD9D8, 0xE1DA, 0xE3E2, 0xE5E4, 0xE7E6, 0xE9E8, 0xF1EA, 0xF3F2,
+		0xF5F4, 0xF7F6, 0xF9F8, 0xFFFA,
+		0xC4FF, 0xB500, 0x0011, 0x0102, 0x0402, 0x0304, 0x0704, 0x0405,
+		0x0004, 0x0201, 0x0077, 0x0201, 0x1103, 0x0504, 0x3121, 0x1206,
+		0x5141, 0x6107, 0x1371, 0x3222, 0x0881, 0x4214, 0xA191, 0xC1B1,
+		0x2309, 0x5233, 0x15F0, 0x7262, 0x0AD1, 0x2416, 0xE134, 0xF125,
+		0x1817, 0x1A19, 0x2726, 0x2928, 0x352A, 0x3736, 0x3938, 0x433A,
+		0x4544, 0x4746, 0x4948, 0x534A, 0x5554, 0x5756, 0x5958, 0x635A,
+		0x6564, 0x6766, 0x6968, 0x736A, 0x7574, 0x7776, 0x7978, 0x827A,
+		0x8483, 0x8685, 0x8887, 0x8A89, 0x9392, 0x9594, 0x9796, 0x9998,
+		0xA29A, 0xA4A3, 0xA6A5, 0xA8A7, 0xAAA9, 0xB3B2, 0xB5B4, 0xB7B6,
+		0xB9B8, 0xC2BA, 0xC4C3, 0xC6C5, 0xC8C7, 0xCAC9, 0xD3D2, 0xD5D4,
+		0xD7D6, 0xD9D8, 0xE2DA, 0xE4E3, 0xE6E5, 0xE8E7, 0xEAE9, 0xF3F2,
+		0xF5F4, 0xF7F6, 0xF9F8, 0xFFFA,
+		0xC4FF, 0x1F00, 0x0000, 0x0501, 0x0101, 0x0101, 0x0101, 0x0000,
+		0x0000, 0x0000, 0x0000, 0x0201, 0x0403, 0x0605, 0x0807, 0x0A09,
+		0xFF0B,
+		0xC4FF, 0x1F00, 0x0001, 0x0103, 0x0101, 0x0101, 0x0101, 0x0101,
+		0x0000, 0x0000, 0x0000, 0x0201, 0x0403, 0x0605, 0x0807, 0x0A09,
+		0xFF0B
+	};
+
+	*length = ARRAY_SIZE(tables);
+	return tables;
+}
+
+/****************************************************************************/
+/* MCHIP low-level functions                                                */
+/****************************************************************************/
+
+/* returns the horizontal capture size */
+static inline int mchip_hsize(void)
+{
+	return meye.params.subsample ? 320 : 640;
+}
+
+/* returns the vertical capture size */
+static inline int mchip_vsize(void)
+{
+	return meye.params.subsample ? 240 : 480;
+}
+
+/* waits for a register to be available */
+static void mchip_sync(int reg)
+{
+	u32 status;
+	int i;
+
+	if (reg == MCHIP_MM_FIFO_DATA) {
+		for (i = 0; i < MCHIP_REG_TIMEOUT; i++) {
+			status = readl(meye.mchip_mmregs +
+				       MCHIP_MM_FIFO_STATUS);
+			if (!(status & MCHIP_MM_FIFO_WAIT)) {
+				printk(KERN_WARNING "meye: fifo not ready\n");
+				return;
+			}
+			if (status & MCHIP_MM_FIFO_READY)
+				return;
+			udelay(1);
+		}
+	} else if (reg > 0x80) {
+		u32 mask = (reg < 0x100) ? MCHIP_HIC_STATUS_MCC_RDY
+					 : MCHIP_HIC_STATUS_VRJ_RDY;
+		for (i = 0; i < MCHIP_REG_TIMEOUT; i++) {
+			status = readl(meye.mchip_mmregs + MCHIP_HIC_STATUS);
+			if (status & mask)
+				return;
+			udelay(1);
+		}
+	} else
+		return;
+	printk(KERN_WARNING
+	       "meye: mchip_sync() timeout on reg 0x%x status=0x%x\n",
+	       reg, status);
+}
+
+/* sets a value into the register */
+static inline void mchip_set(int reg, u32 v)
+{
+	mchip_sync(reg);
+	writel(v, meye.mchip_mmregs + reg);
+}
+
+/* get the register value */
+static inline u32 mchip_read(int reg)
+{
+	mchip_sync(reg);
+	return readl(meye.mchip_mmregs + reg);
+}
+
+/* wait for a register to become a particular value */
+static inline int mchip_delay(u32 reg, u32 v)
+{
+	int n = 10;
+	while (--n && mchip_read(reg) != v)
+		udelay(1);
+	return n;
+}
+
+/* setup subsampling */
+static void mchip_subsample(void)
+{
+	mchip_set(MCHIP_MCC_R_SAMPLING, meye.params.subsample);
+	mchip_set(MCHIP_MCC_R_XRANGE, mchip_hsize());
+	mchip_set(MCHIP_MCC_R_YRANGE, mchip_vsize());
+	mchip_set(MCHIP_MCC_B_XRANGE, mchip_hsize());
+	mchip_set(MCHIP_MCC_B_YRANGE, mchip_vsize());
+	mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE);
+}
+
+/* set the framerate into the mchip */
+static void mchip_set_framerate(void)
+{
+	mchip_set(MCHIP_HIC_S_RATE, meye.params.framerate);
+}
+
+/* load some huffman and quantisation tables into the VRJ chip ready
+   for JPEG compression */
+static void mchip_load_tables(void)
+{
+	int i;
+	int length;
+	u16 *tables;
+
+	tables = jpeg_huffman_tables(&length);
+	for (i = 0; i < length; i++)
+		writel(tables[i], meye.mchip_mmregs + MCHIP_VRJ_TABLE_DATA);
+
+	tables = jpeg_quantisation_tables(&length, meye.params.quality);
+	for (i = 0; i < length; i++)
+		writel(tables[i], meye.mchip_mmregs + MCHIP_VRJ_TABLE_DATA);
+}
+
+/* setup the VRJ parameters in the chip */
+static void mchip_vrj_setup(u8 mode)
+{
+	mchip_set(MCHIP_VRJ_BUS_MODE, 5);
+	mchip_set(MCHIP_VRJ_SIGNAL_ACTIVE_LEVEL, 0x1f);
+	mchip_set(MCHIP_VRJ_PDAT_USE, 1);
+	mchip_set(MCHIP_VRJ_IRQ_FLAG, 0xa0);
+	mchip_set(MCHIP_VRJ_MODE_SPECIFY, mode);
+	mchip_set(MCHIP_VRJ_NUM_LINES, mchip_vsize());
+	mchip_set(MCHIP_VRJ_NUM_PIXELS, mchip_hsize());
+	mchip_set(MCHIP_VRJ_NUM_COMPONENTS, 0x1b);
+	mchip_set(MCHIP_VRJ_LIMIT_COMPRESSED_LO, 0xFFFF);
+	mchip_set(MCHIP_VRJ_LIMIT_COMPRESSED_HI, 0xFFFF);
+	mchip_set(MCHIP_VRJ_COMP_DATA_FORMAT, 0xC);
+	mchip_set(MCHIP_VRJ_RESTART_INTERVAL, 0);
+	mchip_set(MCHIP_VRJ_SOF1, 0x601);
+	mchip_set(MCHIP_VRJ_SOF2, 0x1502);
+	mchip_set(MCHIP_VRJ_SOF3, 0x1503);
+	mchip_set(MCHIP_VRJ_SOF4, 0x1596);
+	mchip_set(MCHIP_VRJ_SOS, 0x0ed0);
+
+	mchip_load_tables();
+}
+
+/* sets the DMA parameters into the chip */
+static void mchip_dma_setup(dma_addr_t dma_addr)
+{
+	int i;
+
+	mchip_set(MCHIP_MM_PT_ADDR, (u32)dma_addr);
+	for (i = 0; i < 4; i++)
+		mchip_set(MCHIP_MM_FIR(i), 0);
+	meye.mchip_fnum = 0;
+}
+
+/* setup for DMA transfers - also zeros the framebuffer */
+static int mchip_dma_alloc(void)
+{
+	if (!meye.mchip_dmahandle)
+		if (ptable_alloc())
+			return -1;
+	return 0;
+}
+
+/* frees the DMA buffer */
+static void mchip_dma_free(void)
+{
+	if (meye.mchip_dmahandle) {
+		mchip_dma_setup(0);
+		ptable_free();
+	}
+}
+
+/* stop any existing HIC action and wait for any dma to complete then
+   reset the dma engine */
+static void mchip_hic_stop(void)
+{
+	int i, j;
+
+	meye.mchip_mode = MCHIP_HIC_MODE_NOOP;
+	if (!(mchip_read(MCHIP_HIC_STATUS) & MCHIP_HIC_STATUS_BUSY))
+		return;
+	for (i = 0; i < 20; ++i) {
+		mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_STOP);
+		mchip_delay(MCHIP_HIC_CMD, 0);
+		for (j = 0; j < 100; ++j) {
+			if (mchip_delay(MCHIP_HIC_STATUS,
+					MCHIP_HIC_STATUS_IDLE))
+				return;
+			msleep(1);
+		}
+		printk(KERN_ERR "meye: need to reset HIC!\n");
+
+		mchip_set(MCHIP_HIC_CTL, MCHIP_HIC_CTL_SOFT_RESET);
+		msleep(250);
+	}
+	printk(KERN_ERR "meye: resetting HIC hanged!\n");
+}
+
+/****************************************************************************/
+/* MCHIP frame processing functions                                         */
+/****************************************************************************/
+
+/* get the next ready frame from the dma engine */
+static u32 mchip_get_frame(void)
+{
+	u32 v;
+
+	v = mchip_read(MCHIP_MM_FIR(meye.mchip_fnum));
+	return v;
+}
+
+/* frees the current frame from the dma engine */
+static void mchip_free_frame(void)
+{
+	mchip_set(MCHIP_MM_FIR(meye.mchip_fnum), 0);
+	meye.mchip_fnum++;
+	meye.mchip_fnum %= 4;
+}
+
+/* read one frame from the framebuffer assuming it was captured using
+   a uncompressed transfer */
+static void mchip_cont_read_frame(u32 v, u8 *buf, int size)
+{
+	int pt_id;
+
+	pt_id = (v >> 17) & 0x3FF;
+
+	ptable_copy(buf, pt_id, size, MCHIP_NB_PAGES);
+}
+
+/* read a compressed frame from the framebuffer */
+static int mchip_comp_read_frame(u32 v, u8 *buf, int size)
+{
+	int pt_start, pt_end, trailer;
+	int fsize;
+	int i;
+
+	pt_start = (v >> 19) & 0xFF;
+	pt_end = (v >> 11) & 0xFF;
+	trailer = (v >> 1) & 0x3FF;
+
+	if (pt_end < pt_start)
+		fsize = (MCHIP_NB_PAGES_MJPEG - pt_start) * PAGE_SIZE +
+			pt_end * PAGE_SIZE + trailer * 4;
+	else
+		fsize = (pt_end - pt_start) * PAGE_SIZE + trailer * 4;
+
+	if (fsize > size) {
+		printk(KERN_WARNING "meye: oversized compressed frame %d\n",
+		       fsize);
+		return -1;
+	}
+
+	ptable_copy(buf, pt_start, fsize, MCHIP_NB_PAGES_MJPEG);
+
+#ifdef MEYE_JPEG_CORRECTION
+
+	/* Some mchip generated jpeg frames are incorrect. In most
+	 * (all ?) of those cases, the final EOI (0xff 0xd9) marker
+	 * is not present at the end of the frame.
+	 *
+	 * Since adding the final marker is not enough to restore
+	 * the jpeg integrity, we drop the frame.
+	 */
+
+	for (i = fsize - 1; i > 0 && buf[i] == 0xff; i--) ;
+
+	if (i < 2 || buf[i - 1] != 0xff || buf[i] != 0xd9)
+		return -1;
+
+#endif
+
+	return fsize;
+}
+
+/* take a picture into SDRAM */
+static void mchip_take_picture(void)
+{
+	int i;
+
+	mchip_hic_stop();
+	mchip_subsample();
+	mchip_dma_setup(meye.mchip_dmahandle);
+
+	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_STILL_CAP);
+	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
+
+	mchip_delay(MCHIP_HIC_CMD, 0);
+
+	for (i = 0; i < 100; ++i) {
+		if (mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE))
+			break;
+		msleep(1);
+	}
+}
+
+/* dma a previously taken picture into a buffer */
+static void mchip_get_picture(u8 *buf, int bufsize)
+{
+	u32 v;
+	int i;
+
+	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_STILL_OUT);
+	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
+
+	mchip_delay(MCHIP_HIC_CMD, 0);
+	for (i = 0; i < 100; ++i) {
+		if (mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE))
+			break;
+		msleep(1);
+	}
+	for (i = 0; i < 4; ++i) {
+		v = mchip_get_frame();
+		if (v & MCHIP_MM_FIR_RDY) {
+			mchip_cont_read_frame(v, buf, bufsize);
+			break;
+		}
+		mchip_free_frame();
+	}
+}
+
+/* start continuous dma capture */
+static void mchip_continuous_start(void)
+{
+	mchip_hic_stop();
+	mchip_subsample();
+	mchip_set_framerate();
+	mchip_dma_setup(meye.mchip_dmahandle);
+
+	meye.mchip_mode = MCHIP_HIC_MODE_CONT_OUT;
+
+	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_CONT_OUT);
+	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
+
+	mchip_delay(MCHIP_HIC_CMD, 0);
+}
+
+/* compress one frame into a buffer */
+static int mchip_compress_frame(u8 *buf, int bufsize)
+{
+	u32 v;
+	int len = -1, i;
+
+	mchip_vrj_setup(0x3f);
+	udelay(50);
+
+	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_STILL_COMP);
+	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
+
+	mchip_delay(MCHIP_HIC_CMD, 0);
+	for (i = 0; i < 100; ++i) {
+		if (mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE))
+			break;
+		msleep(1);
+	}
+
+	for (i = 0; i < 4; ++i) {
+		v = mchip_get_frame();
+		if (v & MCHIP_MM_FIR_RDY) {
+			len = mchip_comp_read_frame(v, buf, bufsize);
+			break;
+		}
+		mchip_free_frame();
+	}
+	return len;
+}
+
+#if 0
+/* uncompress one image into a buffer */
+static int mchip_uncompress_frame(u8 *img, int imgsize, u8 *buf, int bufsize)
+{
+	mchip_vrj_setup(0x3f);
+	udelay(50);
+
+	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_STILL_DECOMP);
+	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
+
+	mchip_delay(MCHIP_HIC_CMD, 0);
+
+	return mchip_comp_read_frame(buf, bufsize);
+}
+#endif
+
+/* start continuous compressed capture */
+static void mchip_cont_compression_start(void)
+{
+	mchip_hic_stop();
+	mchip_vrj_setup(0x3f);
+	mchip_subsample();
+	mchip_set_framerate();
+	mchip_dma_setup(meye.mchip_dmahandle);
+
+	meye.mchip_mode = MCHIP_HIC_MODE_CONT_COMP;
+
+	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_CONT_COMP);
+	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
+
+	mchip_delay(MCHIP_HIC_CMD, 0);
+}
+
+/****************************************************************************/
+/* Interrupt handling                                                       */
+/****************************************************************************/
+
+static irqreturn_t meye_irq(int irq, void *dev_id)
+{
+	u32 v;
+	int reqnr;
+	static int sequence;
+
+	v = mchip_read(MCHIP_MM_INTA);
+
+	if (meye.mchip_mode != MCHIP_HIC_MODE_CONT_OUT &&
+	    meye.mchip_mode != MCHIP_HIC_MODE_CONT_COMP)
+		return IRQ_NONE;
+
+again:
+	v = mchip_get_frame();
+	if (!(v & MCHIP_MM_FIR_RDY))
+		return IRQ_HANDLED;
+
+	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
+		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
+			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
+			mchip_free_frame();
+			return IRQ_HANDLED;
+		}
+		mchip_cont_read_frame(v, meye.grab_fbuffer + gbufsize * reqnr,
+				      mchip_hsize() * mchip_vsize() * 2);
+		meye.grab_buffer[reqnr].size = mchip_hsize() * mchip_vsize() * 2;
+		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
+		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
+		meye.grab_buffer[reqnr].sequence = sequence++;
+		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
+				sizeof(int), &meye.doneq_lock);
+		wake_up_interruptible(&meye.proc_list);
+	} else {
+		int size;
+		size = mchip_comp_read_frame(v, meye.grab_temp, gbufsize);
+		if (size == -1) {
+			mchip_free_frame();
+			goto again;
+		}
+		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
+			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
+			mchip_free_frame();
+			goto again;
+		}
+		memcpy(meye.grab_fbuffer + gbufsize * reqnr, meye.grab_temp,
+		       size);
+		meye.grab_buffer[reqnr].size = size;
+		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
+		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
+		meye.grab_buffer[reqnr].sequence = sequence++;
+		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
+				sizeof(int), &meye.doneq_lock);
+		wake_up_interruptible(&meye.proc_list);
+	}
+	mchip_free_frame();
+	goto again;
+}
+
+/****************************************************************************/
+/* video4linux integration                                                  */
+/****************************************************************************/
+
+static int meye_open(struct file *file)
+{
+	int i;
+
+	if (test_and_set_bit(0, &meye.in_use))
+		return -EBUSY;
+
+	mchip_hic_stop();
+
+	if (mchip_dma_alloc()) {
+		printk(KERN_ERR "meye: mchip framebuffer allocation failed\n");
+		clear_bit(0, &meye.in_use);
+		return -ENOBUFS;
+	}
+
+	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
+		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
+	kfifo_reset(&meye.grabq);
+	kfifo_reset(&meye.doneq);
+	return 0;
+}
+
+static int meye_release(struct file *file)
+{
+	mchip_hic_stop();
+	mchip_dma_free();
+	clear_bit(0, &meye.in_use);
+	return 0;
+}
+
+static int meyeioc_g_params(struct meye_params *p)
+{
+	*p = meye.params;
+	return 0;
+}
+
+static int meyeioc_s_params(struct meye_params *jp)
+{
+	if (jp->subsample > 1)
+		return -EINVAL;
+
+	if (jp->quality > 10)
+		return -EINVAL;
+
+	if (jp->sharpness > 63 || jp->agc > 63 || jp->picture > 63)
+		return -EINVAL;
+
+	if (jp->framerate > 31)
+		return -EINVAL;
+
+	mutex_lock(&meye.lock);
+
+	if (meye.params.subsample != jp->subsample ||
+	    meye.params.quality != jp->quality)
+		mchip_hic_stop();	/* need restart */
+
+	meye.params = *jp;
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERASHARPNESS,
+			      meye.params.sharpness);
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAAGC,
+			      meye.params.agc);
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAPICTURE,
+			      meye.params.picture);
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int meyeioc_qbuf_capt(int *nb)
+{
+	if (!meye.grab_fbuffer)
+		return -EINVAL;
+
+	if (*nb >= gbuffers)
+		return -EINVAL;
+
+	if (*nb < 0) {
+		/* stop capture */
+		mchip_hic_stop();
+		return 0;
+	}
+
+	if (meye.grab_buffer[*nb].state != MEYE_BUF_UNUSED)
+		return -EBUSY;
+
+	mutex_lock(&meye.lock);
+
+	if (meye.mchip_mode != MCHIP_HIC_MODE_CONT_COMP)
+		mchip_cont_compression_start();
+
+	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
+	kfifo_in_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
+			 &meye.grabq_lock);
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int meyeioc_sync(struct file *file, void *fh, int *i)
+{
+	int unused;
+
+	if (*i < 0 || *i >= gbuffers)
+		return -EINVAL;
+
+	mutex_lock(&meye.lock);
+	switch (meye.grab_buffer[*i].state) {
+
+	case MEYE_BUF_UNUSED:
+		mutex_unlock(&meye.lock);
+		return -EINVAL;
+	case MEYE_BUF_USING:
+		if (file->f_flags & O_NONBLOCK) {
+			mutex_unlock(&meye.lock);
+			return -EAGAIN;
+		}
+		if (wait_event_interruptible(meye.proc_list,
+			(meye.grab_buffer[*i].state != MEYE_BUF_USING))) {
+			mutex_unlock(&meye.lock);
+			return -EINTR;
+		}
+		/* fall through */
+	case MEYE_BUF_DONE:
+		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
+		if (kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
+				sizeof(int), &meye.doneq_lock) != sizeof(int))
+					break;
+	}
+	*i = meye.grab_buffer[*i].size;
+	mutex_unlock(&meye.lock);
+	return 0;
+}
+
+static int meyeioc_stillcapt(void)
+{
+	if (!meye.grab_fbuffer)
+		return -EINVAL;
+
+	if (meye.grab_buffer[0].state != MEYE_BUF_UNUSED)
+		return -EBUSY;
+
+	mutex_lock(&meye.lock);
+	meye.grab_buffer[0].state = MEYE_BUF_USING;
+	mchip_take_picture();
+
+	mchip_get_picture(meye.grab_fbuffer,
+			mchip_hsize() * mchip_vsize() * 2);
+
+	meye.grab_buffer[0].state = MEYE_BUF_DONE;
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int meyeioc_stilljcapt(int *len)
+{
+	if (!meye.grab_fbuffer)
+		return -EINVAL;
+
+	if (meye.grab_buffer[0].state != MEYE_BUF_UNUSED)
+		return -EBUSY;
+
+	mutex_lock(&meye.lock);
+	meye.grab_buffer[0].state = MEYE_BUF_USING;
+	*len = -1;
+
+	while (*len == -1) {
+		mchip_take_picture();
+		*len = mchip_compress_frame(meye.grab_fbuffer, gbufsize);
+	}
+
+	meye.grab_buffer[0].state = MEYE_BUF_DONE;
+	mutex_unlock(&meye.lock);
+	return 0;
+}
+
+static int vidioc_querycap(struct file *file, void *fh,
+				struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "meye");
+	strcpy(cap->card, "meye");
+	sprintf(cap->bus_info, "PCI:%s", pci_name(meye.mchip_dev));
+
+	cap->version = (MEYE_DRIVER_MAJORVERSION << 8) +
+		       MEYE_DRIVER_MINORVERSION;
+
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+			    V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
+
+	strcpy(i->name, "Camera");
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
+{
+	if (i != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vidioc_queryctrl(struct file *file, void *fh,
+				struct v4l2_queryctrl *c)
+{
+	switch (c->id) {
+
+	case V4L2_CID_BRIGHTNESS:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "Brightness");
+		c->minimum = 0;
+		c->maximum = 63;
+		c->step = 1;
+		c->default_value = 32;
+		c->flags = 0;
+		break;
+	case V4L2_CID_HUE:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "Hue");
+		c->minimum = 0;
+		c->maximum = 63;
+		c->step = 1;
+		c->default_value = 32;
+		c->flags = 0;
+		break;
+	case V4L2_CID_CONTRAST:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "Contrast");
+		c->minimum = 0;
+		c->maximum = 63;
+		c->step = 1;
+		c->default_value = 32;
+		c->flags = 0;
+		break;
+	case V4L2_CID_SATURATION:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "Saturation");
+		c->minimum = 0;
+		c->maximum = 63;
+		c->step = 1;
+		c->default_value = 32;
+		c->flags = 0;
+		break;
+	case V4L2_CID_AGC:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "Agc");
+		c->minimum = 0;
+		c->maximum = 63;
+		c->step = 1;
+		c->default_value = 48;
+		c->flags = 0;
+		break;
+	case V4L2_CID_MEYE_SHARPNESS:
+	case V4L2_CID_SHARPNESS:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "Sharpness");
+		c->minimum = 0;
+		c->maximum = 63;
+		c->step = 1;
+		c->default_value = 32;
+
+		/* Continue to report legacy private SHARPNESS ctrl but
+		 * say it is disabled in preference to ctrl in the spec
+		 */
+		c->flags = (c->id == V4L2_CID_SHARPNESS) ? 0 :
+						V4L2_CTRL_FLAG_DISABLED;
+		break;
+	case V4L2_CID_PICTURE:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "Picture");
+		c->minimum = 0;
+		c->maximum = 63;
+		c->step = 1;
+		c->default_value = 0;
+		c->flags = 0;
+		break;
+	case V4L2_CID_JPEGQUAL:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "JPEG quality");
+		c->minimum = 0;
+		c->maximum = 10;
+		c->step = 1;
+		c->default_value = 8;
+		c->flags = 0;
+		break;
+	case V4L2_CID_FRAMERATE:
+		c->type = V4L2_CTRL_TYPE_INTEGER;
+		strcpy(c->name, "Framerate");
+		c->minimum = 0;
+		c->maximum = 31;
+		c->step = 1;
+		c->default_value = 0;
+		c->flags = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
+{
+	mutex_lock(&meye.lock);
+	switch (c->id) {
+	case V4L2_CID_BRIGHTNESS:
+		sony_pic_camera_command(
+			SONY_PIC_COMMAND_SETCAMERABRIGHTNESS, c->value);
+		meye.brightness = c->value << 10;
+		break;
+	case V4L2_CID_HUE:
+		sony_pic_camera_command(
+			SONY_PIC_COMMAND_SETCAMERAHUE, c->value);
+		meye.hue = c->value << 10;
+		break;
+	case V4L2_CID_CONTRAST:
+		sony_pic_camera_command(
+			SONY_PIC_COMMAND_SETCAMERACONTRAST, c->value);
+		meye.contrast = c->value << 10;
+		break;
+	case V4L2_CID_SATURATION:
+		sony_pic_camera_command(
+			SONY_PIC_COMMAND_SETCAMERACOLOR, c->value);
+		meye.colour = c->value << 10;
+		break;
+	case V4L2_CID_AGC:
+		sony_pic_camera_command(
+			SONY_PIC_COMMAND_SETCAMERAAGC, c->value);
+		meye.params.agc = c->value;
+		break;
+	case V4L2_CID_SHARPNESS:
+	case V4L2_CID_MEYE_SHARPNESS:
+		sony_pic_camera_command(
+			SONY_PIC_COMMAND_SETCAMERASHARPNESS, c->value);
+		meye.params.sharpness = c->value;
+		break;
+	case V4L2_CID_PICTURE:
+		sony_pic_camera_command(
+			SONY_PIC_COMMAND_SETCAMERAPICTURE, c->value);
+		meye.params.picture = c->value;
+		break;
+	case V4L2_CID_JPEGQUAL:
+		meye.params.quality = c->value;
+		break;
+	case V4L2_CID_FRAMERATE:
+		meye.params.framerate = c->value;
+		break;
+	default:
+		mutex_unlock(&meye.lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *c)
+{
+	mutex_lock(&meye.lock);
+	switch (c->id) {
+	case V4L2_CID_BRIGHTNESS:
+		c->value = meye.brightness >> 10;
+		break;
+	case V4L2_CID_HUE:
+		c->value = meye.hue >> 10;
+		break;
+	case V4L2_CID_CONTRAST:
+		c->value = meye.contrast >> 10;
+		break;
+	case V4L2_CID_SATURATION:
+		c->value = meye.colour >> 10;
+		break;
+	case V4L2_CID_AGC:
+		c->value = meye.params.agc;
+		break;
+	case V4L2_CID_SHARPNESS:
+	case V4L2_CID_MEYE_SHARPNESS:
+		c->value = meye.params.sharpness;
+		break;
+	case V4L2_CID_PICTURE:
+		c->value = meye.params.picture;
+		break;
+	case V4L2_CID_JPEGQUAL:
+		c->value = meye.params.quality;
+		break;
+	case V4L2_CID_FRAMERATE:
+		c->value = meye.params.framerate;
+		break;
+	default:
+		mutex_unlock(&meye.lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh,
+				struct v4l2_fmtdesc *f)
+{
+	if (f->index > 1)
+		return -EINVAL;
+
+	if (f->index == 0) {
+		/* standard YUV 422 capture */
+		f->flags = 0;
+		strcpy(f->description, "YUV422");
+		f->pixelformat = V4L2_PIX_FMT_YUYV;
+	} else {
+		/* compressed MJPEG capture */
+		f->flags = V4L2_FMT_FLAG_COMPRESSED;
+		strcpy(f->description, "MJPEG");
+		f->pixelformat = V4L2_PIX_FMT_MJPEG;
+	}
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV &&
+	    f->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG)
+		return -EINVAL;
+
+	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
+	    f->fmt.pix.field != V4L2_FIELD_NONE)
+		return -EINVAL;
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	if (f->fmt.pix.width <= 320) {
+		f->fmt.pix.width = 320;
+		f->fmt.pix.height = 240;
+	} else {
+		f->fmt.pix.width = 640;
+		f->fmt.pix.height = 480;
+	}
+
+	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
+	f->fmt.pix.sizeimage = f->fmt.pix.height *
+			       f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = 0;
+	f->fmt.pix.priv = 0;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *fh,
+				    struct v4l2_format *f)
+{
+	switch (meye.mchip_mode) {
+	case MCHIP_HIC_MODE_CONT_OUT:
+	default:
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
+		break;
+	case MCHIP_HIC_MODE_CONT_COMP:
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_MJPEG;
+		break;
+	}
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.width = mchip_hsize();
+	f->fmt.pix.height = mchip_vsize();
+	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
+	f->fmt.pix.sizeimage = f->fmt.pix.height *
+			       f->fmt.pix.bytesperline;
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
+				    struct v4l2_format *f)
+{
+	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV &&
+	    f->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG)
+		return -EINVAL;
+
+	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
+	    f->fmt.pix.field != V4L2_FIELD_NONE)
+		return -EINVAL;
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	mutex_lock(&meye.lock);
+
+	if (f->fmt.pix.width <= 320) {
+		f->fmt.pix.width = 320;
+		f->fmt.pix.height = 240;
+		meye.params.subsample = 1;
+	} else {
+		f->fmt.pix.width = 640;
+		f->fmt.pix.height = 480;
+		meye.params.subsample = 0;
+	}
+
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+		meye.mchip_mode = MCHIP_HIC_MODE_CONT_OUT;
+		break;
+	case V4L2_PIX_FMT_MJPEG:
+		meye.mchip_mode = MCHIP_HIC_MODE_CONT_COMP;
+		break;
+	}
+
+	mutex_unlock(&meye.lock);
+	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
+	f->fmt.pix.sizeimage = f->fmt.pix.height *
+			       f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = 0;
+	f->fmt.pix.priv = 0;
+
+	return 0;
+}
+
+static int vidioc_reqbufs(struct file *file, void *fh,
+				struct v4l2_requestbuffers *req)
+{
+	int i;
+
+	if (req->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+
+	if (meye.grab_fbuffer && req->count == gbuffers) {
+		/* already allocated, no modifications */
+		return 0;
+	}
+
+	mutex_lock(&meye.lock);
+	if (meye.grab_fbuffer) {
+		for (i = 0; i < gbuffers; i++)
+			if (meye.vma_use_count[i]) {
+				mutex_unlock(&meye.lock);
+				return -EINVAL;
+			}
+		rvfree(meye.grab_fbuffer, gbuffers * gbufsize);
+		meye.grab_fbuffer = NULL;
+	}
+
+	gbuffers = max(2, min((int)req->count, MEYE_MAX_BUFNBRS));
+	req->count = gbuffers;
+	meye.grab_fbuffer = rvmalloc(gbuffers * gbufsize);
+
+	if (!meye.grab_fbuffer) {
+		printk(KERN_ERR "meye: v4l framebuffer allocation"
+				" failed\n");
+		mutex_unlock(&meye.lock);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < gbuffers; i++)
+		meye.vma_use_count[i] = 0;
+
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	unsigned int index = buf->index;
+
+	if (index >= gbuffers)
+		return -EINVAL;
+
+	buf->bytesused = meye.grab_buffer[index].size;
+	buf->flags = V4L2_BUF_FLAG_MAPPED;
+
+	if (meye.grab_buffer[index].state == MEYE_BUF_USING)
+		buf->flags |= V4L2_BUF_FLAG_QUEUED;
+
+	if (meye.grab_buffer[index].state == MEYE_BUF_DONE)
+		buf->flags |= V4L2_BUF_FLAG_DONE;
+
+	buf->field = V4L2_FIELD_NONE;
+	buf->timestamp = meye.grab_buffer[index].timestamp;
+	buf->sequence = meye.grab_buffer[index].sequence;
+	buf->memory = V4L2_MEMORY_MMAP;
+	buf->m.offset = index * gbufsize;
+	buf->length = gbufsize;
+
+	return 0;
+}
+
+static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	if (buf->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+
+	if (buf->index >= gbuffers)
+		return -EINVAL;
+
+	if (meye.grab_buffer[buf->index].state != MEYE_BUF_UNUSED)
+		return -EINVAL;
+
+	mutex_lock(&meye.lock);
+	buf->flags |= V4L2_BUF_FLAG_QUEUED;
+	buf->flags &= ~V4L2_BUF_FLAG_DONE;
+	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
+	kfifo_in_locked(&meye.grabq, (unsigned char *)&buf->index,
+			sizeof(int), &meye.grabq_lock);
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	int reqnr;
+
+	if (buf->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+
+	mutex_lock(&meye.lock);
+
+	if (kfifo_len(&meye.doneq) == 0 && file->f_flags & O_NONBLOCK) {
+		mutex_unlock(&meye.lock);
+		return -EAGAIN;
+	}
+
+	if (wait_event_interruptible(meye.proc_list,
+				     kfifo_len(&meye.doneq) != 0) < 0) {
+		mutex_unlock(&meye.lock);
+		return -EINTR;
+	}
+
+	if (!kfifo_out_locked(&meye.doneq, (unsigned char *)&reqnr,
+		       sizeof(int), &meye.doneq_lock)) {
+		mutex_unlock(&meye.lock);
+		return -EBUSY;
+	}
+
+	if (meye.grab_buffer[reqnr].state != MEYE_BUF_DONE) {
+		mutex_unlock(&meye.lock);
+		return -EINVAL;
+	}
+
+	buf->index = reqnr;
+	buf->bytesused = meye.grab_buffer[reqnr].size;
+	buf->flags = V4L2_BUF_FLAG_MAPPED;
+	buf->field = V4L2_FIELD_NONE;
+	buf->timestamp = meye.grab_buffer[reqnr].timestamp;
+	buf->sequence = meye.grab_buffer[reqnr].sequence;
+	buf->memory = V4L2_MEMORY_MMAP;
+	buf->m.offset = reqnr * gbufsize;
+	buf->length = gbufsize;
+	meye.grab_buffer[reqnr].state = MEYE_BUF_UNUSED;
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
+{
+	mutex_lock(&meye.lock);
+
+	switch (meye.mchip_mode) {
+	case MCHIP_HIC_MODE_CONT_OUT:
+		mchip_continuous_start();
+		break;
+	case MCHIP_HIC_MODE_CONT_COMP:
+		mchip_cont_compression_start();
+		break;
+	default:
+		mutex_unlock(&meye.lock);
+		return -EINVAL;
+	}
+
+	mutex_unlock(&meye.lock);
+
+	return 0;
+}
+
+static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
+{
+	mutex_lock(&meye.lock);
+	mchip_hic_stop();
+	kfifo_reset(&meye.grabq);
+	kfifo_reset(&meye.doneq);
+
+	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
+		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
+
+	mutex_unlock(&meye.lock);
+	return 0;
+}
+
+static long vidioc_default(struct file *file, void *fh, bool valid_prio,
+						int cmd, void *arg)
+{
+	switch (cmd) {
+	case MEYEIOC_G_PARAMS:
+		return meyeioc_g_params((struct meye_params *) arg);
+
+	case MEYEIOC_S_PARAMS:
+		return meyeioc_s_params((struct meye_params *) arg);
+
+	case MEYEIOC_QBUF_CAPT:
+		return meyeioc_qbuf_capt((int *) arg);
+
+	case MEYEIOC_SYNC:
+		return meyeioc_sync(file, fh, (int *) arg);
+
+	case MEYEIOC_STILLCAPT:
+		return meyeioc_stillcapt();
+
+	case MEYEIOC_STILLJCAPT:
+		return meyeioc_stilljcapt((int *) arg);
+
+	default:
+		return -ENOTTY;
+	}
+
+}
+
+static unsigned int meye_poll(struct file *file, poll_table *wait)
+{
+	unsigned int res = 0;
+
+	mutex_lock(&meye.lock);
+	poll_wait(file, &meye.proc_list, wait);
+	if (kfifo_len(&meye.doneq))
+		res = POLLIN | POLLRDNORM;
+	mutex_unlock(&meye.lock);
+	return res;
+}
+
+static void meye_vm_open(struct vm_area_struct *vma)
+{
+	long idx = (long)vma->vm_private_data;
+	meye.vma_use_count[idx]++;
+}
+
+static void meye_vm_close(struct vm_area_struct *vma)
+{
+	long idx = (long)vma->vm_private_data;
+	meye.vma_use_count[idx]--;
+}
+
+static const struct vm_operations_struct meye_vm_ops = {
+	.open		= meye_vm_open,
+	.close		= meye_vm_close,
+};
+
+static int meye_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long start = vma->vm_start;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long page, pos;
+
+	mutex_lock(&meye.lock);
+	if (size > gbuffers * gbufsize) {
+		mutex_unlock(&meye.lock);
+		return -EINVAL;
+	}
+	if (!meye.grab_fbuffer) {
+		int i;
+
+		/* lazy allocation */
+		meye.grab_fbuffer = rvmalloc(gbuffers*gbufsize);
+		if (!meye.grab_fbuffer) {
+			printk(KERN_ERR "meye: v4l framebuffer allocation failed\n");
+			mutex_unlock(&meye.lock);
+			return -ENOMEM;
+		}
+		for (i = 0; i < gbuffers; i++)
+			meye.vma_use_count[i] = 0;
+	}
+	pos = (unsigned long)meye.grab_fbuffer + offset;
+
+	while (size > 0) {
+		page = vmalloc_to_pfn((void *)pos);
+		if (remap_pfn_range(vma, start, page, PAGE_SIZE, PAGE_SHARED)) {
+			mutex_unlock(&meye.lock);
+			return -EAGAIN;
+		}
+		start += PAGE_SIZE;
+		pos += PAGE_SIZE;
+		if (size > PAGE_SIZE)
+			size -= PAGE_SIZE;
+		else
+			size = 0;
+	}
+
+	vma->vm_ops = &meye_vm_ops;
+	vma->vm_flags &= ~VM_IO;	/* not I/O memory */
+	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
+	vma->vm_private_data = (void *) (offset / gbufsize);
+	meye_vm_open(vma);
+
+	mutex_unlock(&meye.lock);
+	return 0;
+}
+
+static const struct v4l2_file_operations meye_fops = {
+	.owner		= THIS_MODULE,
+	.open		= meye_open,
+	.release	= meye_release,
+	.mmap		= meye_mmap,
+	.unlocked_ioctl	= video_ioctl2,
+	.poll		= meye_poll,
+};
+
+static const struct v4l2_ioctl_ops meye_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+	.vidioc_enum_input	= vidioc_enum_input,
+	.vidioc_g_input		= vidioc_g_input,
+	.vidioc_s_input		= vidioc_s_input,
+	.vidioc_queryctrl	= vidioc_queryctrl,
+	.vidioc_s_ctrl		= vidioc_s_ctrl,
+	.vidioc_g_ctrl		= vidioc_g_ctrl,
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+	.vidioc_default		= vidioc_default,
+};
+
+static struct video_device meye_template = {
+	.name		= "meye",
+	.fops		= &meye_fops,
+	.ioctl_ops 	= &meye_ioctl_ops,
+	.release	= video_device_release,
+};
+
+#ifdef CONFIG_PM
+static int meye_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	pci_save_state(pdev);
+	meye.pm_mchip_mode = meye.mchip_mode;
+	mchip_hic_stop();
+	mchip_set(MCHIP_MM_INTA, 0x0);
+	return 0;
+}
+
+static int meye_resume(struct pci_dev *pdev)
+{
+	pci_restore_state(pdev);
+	pci_write_config_word(meye.mchip_dev, MCHIP_PCI_SOFTRESET_SET, 1);
+
+	mchip_delay(MCHIP_HIC_CMD, 0);
+	mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE);
+	msleep(1);
+	mchip_set(MCHIP_VRJ_SOFT_RESET, 1);
+	msleep(1);
+	mchip_set(MCHIP_MM_PCI_MODE, 5);
+	msleep(1);
+	mchip_set(MCHIP_MM_INTA, MCHIP_MM_INTA_HIC_1_MASK);
+
+	switch (meye.pm_mchip_mode) {
+	case MCHIP_HIC_MODE_CONT_OUT:
+		mchip_continuous_start();
+		break;
+	case MCHIP_HIC_MODE_CONT_COMP:
+		mchip_cont_compression_start();
+		break;
+	}
+	return 0;
+}
+#endif
+
+static int __devinit meye_probe(struct pci_dev *pcidev,
+				const struct pci_device_id *ent)
+{
+	struct v4l2_device *v4l2_dev = &meye.v4l2_dev;
+	int ret = -EBUSY;
+	unsigned long mchip_adr;
+
+	if (meye.mchip_dev != NULL) {
+		printk(KERN_ERR "meye: only one device allowed!\n");
+		goto outnotdev;
+	}
+
+	ret = v4l2_device_register(&pcidev->dev, v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
+		return ret;
+	}
+	ret = -ENOMEM;
+	meye.mchip_dev = pcidev;
+	meye.vdev = video_device_alloc();
+	if (!meye.vdev) {
+		v4l2_err(v4l2_dev, "video_device_alloc() failed!\n");
+		goto outnotdev;
+	}
+
+	meye.grab_temp = vmalloc(MCHIP_NB_PAGES_MJPEG * PAGE_SIZE);
+	if (!meye.grab_temp) {
+		v4l2_err(v4l2_dev, "grab buffer allocation failed\n");
+		goto outvmalloc;
+	}
+
+	spin_lock_init(&meye.grabq_lock);
+	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS,
+				GFP_KERNEL)) {
+		v4l2_err(v4l2_dev, "fifo allocation failed\n");
+		goto outkfifoalloc1;
+	}
+	spin_lock_init(&meye.doneq_lock);
+	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS,
+				GFP_KERNEL)) {
+		v4l2_err(v4l2_dev, "fifo allocation failed\n");
+		goto outkfifoalloc2;
+	}
+
+	memcpy(meye.vdev, &meye_template, sizeof(meye_template));
+	meye.vdev->v4l2_dev = &meye.v4l2_dev;
+
+	ret = -EIO;
+	if ((ret = sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 1))) {
+		v4l2_err(v4l2_dev, "meye: unable to power on the camera\n");
+		v4l2_err(v4l2_dev, "meye: did you enable the camera in "
+				"sonypi using the module options ?\n");
+		goto outsonypienable;
+	}
+
+	if ((ret = pci_enable_device(meye.mchip_dev))) {
+		v4l2_err(v4l2_dev, "meye: pci_enable_device failed\n");
+		goto outenabledev;
+	}
+
+	mchip_adr = pci_resource_start(meye.mchip_dev,0);
+	if (!mchip_adr) {
+		v4l2_err(v4l2_dev, "meye: mchip has no device base address\n");
+		goto outregions;
+	}
+	if (!request_mem_region(pci_resource_start(meye.mchip_dev, 0),
+				pci_resource_len(meye.mchip_dev, 0),
+				"meye")) {
+		v4l2_err(v4l2_dev, "meye: request_mem_region failed\n");
+		goto outregions;
+	}
+	meye.mchip_mmregs = ioremap(mchip_adr, MCHIP_MM_REGS);
+	if (!meye.mchip_mmregs) {
+		v4l2_err(v4l2_dev, "meye: ioremap failed\n");
+		goto outremap;
+	}
+
+	meye.mchip_irq = pcidev->irq;
+	if (request_irq(meye.mchip_irq, meye_irq,
+			IRQF_DISABLED | IRQF_SHARED, "meye", meye_irq)) {
+		v4l2_err(v4l2_dev, "request_irq failed\n");
+		goto outreqirq;
+	}
+
+	pci_write_config_byte(meye.mchip_dev, PCI_CACHE_LINE_SIZE, 8);
+	pci_write_config_byte(meye.mchip_dev, PCI_LATENCY_TIMER, 64);
+
+	pci_set_master(meye.mchip_dev);
+
+	/* Ask the camera to perform a soft reset. */
+	pci_write_config_word(meye.mchip_dev, MCHIP_PCI_SOFTRESET_SET, 1);
+
+	mchip_delay(MCHIP_HIC_CMD, 0);
+	mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE);
+
+	msleep(1);
+	mchip_set(MCHIP_VRJ_SOFT_RESET, 1);
+
+	msleep(1);
+	mchip_set(MCHIP_MM_PCI_MODE, 5);
+
+	msleep(1);
+	mchip_set(MCHIP_MM_INTA, MCHIP_MM_INTA_HIC_1_MASK);
+
+	mutex_init(&meye.lock);
+	init_waitqueue_head(&meye.proc_list);
+	meye.brightness = 32 << 10;
+	meye.hue = 32 << 10;
+	meye.colour = 32 << 10;
+	meye.contrast = 32 << 10;
+	meye.params.subsample = 0;
+	meye.params.quality = 8;
+	meye.params.sharpness = 32;
+	meye.params.agc = 48;
+	meye.params.picture = 0;
+	meye.params.framerate = 0;
+
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERABRIGHTNESS, 32);
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAHUE, 32);
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERACOLOR, 32);
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERACONTRAST, 32);
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERASHARPNESS, 32);
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAPICTURE, 0);
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAAGC, 48);
+
+	if (video_register_device(meye.vdev, VFL_TYPE_GRABBER,
+				  video_nr) < 0) {
+		v4l2_err(v4l2_dev, "video_register_device failed\n");
+		goto outvideoreg;
+	}
+
+	v4l2_info(v4l2_dev, "Motion Eye Camera Driver v%s.\n",
+	       MEYE_DRIVER_VERSION);
+	v4l2_info(v4l2_dev, "mchip KL5A72002 rev. %d, base %lx, irq %d\n",
+	       meye.mchip_dev->revision, mchip_adr, meye.mchip_irq);
+
+	return 0;
+
+outvideoreg:
+	free_irq(meye.mchip_irq, meye_irq);
+outreqirq:
+	iounmap(meye.mchip_mmregs);
+outremap:
+	release_mem_region(pci_resource_start(meye.mchip_dev, 0),
+			   pci_resource_len(meye.mchip_dev, 0));
+outregions:
+	pci_disable_device(meye.mchip_dev);
+outenabledev:
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
+outsonypienable:
+	kfifo_free(&meye.doneq);
+outkfifoalloc2:
+	kfifo_free(&meye.grabq);
+outkfifoalloc1:
+	vfree(meye.grab_temp);
+outvmalloc:
+	video_device_release(meye.vdev);
+outnotdev:
+	return ret;
+}
+
+static void __devexit meye_remove(struct pci_dev *pcidev)
+{
+	video_unregister_device(meye.vdev);
+
+	mchip_hic_stop();
+
+	mchip_dma_free();
+
+	/* disable interrupts */
+	mchip_set(MCHIP_MM_INTA, 0x0);
+
+	free_irq(meye.mchip_irq, meye_irq);
+
+	iounmap(meye.mchip_mmregs);
+
+	release_mem_region(pci_resource_start(meye.mchip_dev, 0),
+			   pci_resource_len(meye.mchip_dev, 0));
+
+	pci_disable_device(meye.mchip_dev);
+
+	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
+
+	kfifo_free(&meye.doneq);
+	kfifo_free(&meye.grabq);
+
+	vfree(meye.grab_temp);
+
+	if (meye.grab_fbuffer) {
+		rvfree(meye.grab_fbuffer, gbuffers*gbufsize);
+		meye.grab_fbuffer = NULL;
+	}
+
+	printk(KERN_INFO "meye: removed\n");
+}
+
+static struct pci_device_id meye_pci_tbl[] = {
+	{ PCI_VDEVICE(KAWASAKI, PCI_DEVICE_ID_MCHIP_KL5A72002), 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(pci, meye_pci_tbl);
+
+static struct pci_driver meye_driver = {
+	.name		= "meye",
+	.id_table	= meye_pci_tbl,
+	.probe		= meye_probe,
+	.remove		= __devexit_p(meye_remove),
+#ifdef CONFIG_PM
+	.suspend	= meye_suspend,
+	.resume		= meye_resume,
+#endif
+};
+
+static int __init meye_init(void)
+{
+	gbuffers = max(2, min((int)gbuffers, MEYE_MAX_BUFNBRS));
+	if (gbufsize < 0 || gbufsize > MEYE_MAX_BUFSIZE)
+		gbufsize = MEYE_MAX_BUFSIZE;
+	gbufsize = PAGE_ALIGN(gbufsize);
+	printk(KERN_INFO "meye: using %d buffers with %dk (%dk total) "
+			 "for capture\n",
+			 gbuffers,
+			 gbufsize / 1024, gbuffers * gbufsize / 1024);
+	return pci_register_driver(&meye_driver);
+}
+
+static void __exit meye_exit(void)
+{
+	pci_unregister_driver(&meye_driver);
+}
+
+module_init(meye_init);
+module_exit(meye_exit);
diff --git a/drivers/media/pci/meye/meye.h b/drivers/media/pci/meye/meye.h
new file mode 100644
index 0000000..4bdeb03
--- /dev/null
+++ b/drivers/media/pci/meye/meye.h
@@ -0,0 +1,324 @@
+/*
+ * Motion Eye video4linux driver for Sony Vaio PictureBook
+ *
+ * Copyright (C) 2001-2004 Stelian Pop <stelian@popies.net>
+ *
+ * Copyright (C) 2001-2002 Alcôve <www.alcove.com>
+ *
+ * Copyright (C) 2000 Andrew Tridgell <tridge@valinux.com>
+ *
+ * Earlier work by Werner Almesberger, Paul `Rusty' Russell and Paul Mackerras.
+ *
+ * Some parts borrowed from various video4linux drivers, especially
+ * bttv-driver.c and zoran.c, see original files for credits.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _MEYE_PRIV_H_
+#define _MEYE_PRIV_H_
+
+#define MEYE_DRIVER_MAJORVERSION	 1
+#define MEYE_DRIVER_MINORVERSION	14
+
+#define MEYE_DRIVER_VERSION __stringify(MEYE_DRIVER_MAJORVERSION) "." \
+			    __stringify(MEYE_DRIVER_MINORVERSION)
+
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/kfifo.h>
+
+/****************************************************************************/
+/* Motion JPEG chip registers                                               */
+/****************************************************************************/
+
+/* Motion JPEG chip PCI configuration registers */
+#define MCHIP_PCI_POWER_CSR		0x54
+#define MCHIP_PCI_MCORE_STATUS		0x60		/* see HIC_STATUS   */
+#define MCHIP_PCI_HOSTUSEREQ_SET	0x64
+#define MCHIP_PCI_HOSTUSEREQ_CLR	0x68
+#define MCHIP_PCI_LOWPOWER_SET		0x6c
+#define MCHIP_PCI_LOWPOWER_CLR		0x70
+#define MCHIP_PCI_SOFTRESET_SET		0x74
+
+/* Motion JPEG chip memory mapped registers */
+#define MCHIP_MM_REGS			0x200		/* 512 bytes        */
+#define MCHIP_REG_TIMEOUT		1000		/* reg access, ~us  */
+#define MCHIP_MCC_VRJ_TIMEOUT		1000		/* MCC & VRJ access */
+
+#define MCHIP_MM_PCI_MODE		0x00		/* PCI access mode */
+#define MCHIP_MM_PCI_MODE_RETRY		0x00000001	/* retry mode */
+#define MCHIP_MM_PCI_MODE_MASTER	0x00000002	/* master access */
+#define MCHIP_MM_PCI_MODE_READ_LINE	0x00000004	/* read line */
+
+#define MCHIP_MM_INTA			0x04		/* Int status/mask */
+#define MCHIP_MM_INTA_MCC		0x00000001	/* MCC interrupt */
+#define MCHIP_MM_INTA_VRJ		0x00000002	/* VRJ interrupt */
+#define MCHIP_MM_INTA_HIC_1		0x00000004	/* one frame done */
+#define MCHIP_MM_INTA_HIC_1_MASK	0x00000400	/* 1: enable */
+#define MCHIP_MM_INTA_HIC_END		0x00000008	/* all frames done */
+#define MCHIP_MM_INTA_HIC_END_MASK	0x00000800
+#define MCHIP_MM_INTA_JPEG		0x00000010	/* decompress. error */
+#define MCHIP_MM_INTA_JPEG_MASK		0x00001000
+#define MCHIP_MM_INTA_CAPTURE		0x00000020	/* capture end */
+#define MCHIP_MM_INTA_PCI_ERR		0x00000040	/* PCI error */
+#define MCHIP_MM_INTA_PCI_ERR_MASK	0x00004000
+
+#define MCHIP_MM_PT_ADDR		0x08		/* page table address*/
+							/* n*4kB */
+#define MCHIP_NB_PAGES			1024		/* pages for display */
+#define MCHIP_NB_PAGES_MJPEG		256		/* pages for mjpeg */
+
+#define MCHIP_MM_FIR(n)			(0x0c+(n)*4)	/* Frame info 0-3 */
+#define MCHIP_MM_FIR_RDY		0x00000001	/* frame ready */
+#define MCHIP_MM_FIR_FAILFR_MASK	0xf8000000	/* # of failed frames */
+#define MCHIP_MM_FIR_FAILFR_SHIFT	27
+
+	/* continuous comp/decomp mode */
+#define MCHIP_MM_FIR_C_ENDL_MASK	0x000007fe	/* end DW [10] */
+#define MCHIP_MM_FIR_C_ENDL_SHIFT	1
+#define MCHIP_MM_FIR_C_ENDP_MASK	0x0007f800	/* end page [8] */
+#define MCHIP_MM_FIR_C_ENDP_SHIFT	11
+#define MCHIP_MM_FIR_C_STARTP_MASK	0x07f80000	/* start page [8] */
+#define MCHIP_MM_FIR_C_STARTP_SHIFT	19
+
+	/* continuous picture output mode */
+#define MCHIP_MM_FIR_O_STARTP_MASK	0x7ffe0000	/* start page [10] */
+#define MCHIP_MM_FIR_O_STARTP_SHIFT	17
+
+#define MCHIP_MM_FIFO_DATA		0x1c		/* PCI TGT FIFO data */
+#define MCHIP_MM_FIFO_STATUS		0x20		/* PCI TGT FIFO stat */
+#define MCHIP_MM_FIFO_MASK		0x00000003
+#define MCHIP_MM_FIFO_WAIT_OR_READY	0x00000002      /* Bits common to WAIT & READY*/
+#define MCHIP_MM_FIFO_IDLE		0x0		/* HIC idle */
+#define MCHIP_MM_FIFO_IDLE1		0x1		/* idem ??? */
+#define	MCHIP_MM_FIFO_WAIT		0x2		/* wait request */
+#define MCHIP_MM_FIFO_READY		0x3		/* data ready */
+
+#define MCHIP_HIC_HOST_USEREQ		0x40		/* host uses MCORE */
+
+#define MCHIP_HIC_TP_BUSY		0x44		/* taking picture */
+
+#define MCHIP_HIC_PIC_SAVED		0x48		/* pic in SDRAM */
+
+#define MCHIP_HIC_LOWPOWER		0x4c		/* clock stopped */
+
+#define MCHIP_HIC_CTL			0x50		/* HIC control */
+#define MCHIP_HIC_CTL_SOFT_RESET	0x00000001	/* MCORE reset */
+#define MCHIP_HIC_CTL_MCORE_RDY		0x00000002	/* MCORE ready */
+
+#define MCHIP_HIC_CMD			0x54		/* HIC command */
+#define MCHIP_HIC_CMD_BITS		0x00000003      /* cmd width=[1:0]*/
+#define MCHIP_HIC_CMD_NOOP		0x0
+#define MCHIP_HIC_CMD_START		0x1
+#define MCHIP_HIC_CMD_STOP		0x2
+
+#define MCHIP_HIC_MODE			0x58
+#define MCHIP_HIC_MODE_NOOP		0x0
+#define MCHIP_HIC_MODE_STILL_CAP	0x1		/* still pic capt */
+#define MCHIP_HIC_MODE_DISPLAY		0x2		/* display */
+#define MCHIP_HIC_MODE_STILL_COMP	0x3		/* still pic comp. */
+#define MCHIP_HIC_MODE_STILL_DECOMP	0x4		/* still pic decomp. */
+#define MCHIP_HIC_MODE_CONT_COMP	0x5		/* cont capt+comp */
+#define MCHIP_HIC_MODE_CONT_DECOMP	0x6		/* cont decomp+disp */
+#define MCHIP_HIC_MODE_STILL_OUT	0x7		/* still pic output */
+#define MCHIP_HIC_MODE_CONT_OUT		0x8		/* cont output */
+
+#define MCHIP_HIC_STATUS		0x5c
+#define MCHIP_HIC_STATUS_MCC_RDY	0x00000001	/* MCC reg acc ok */
+#define MCHIP_HIC_STATUS_VRJ_RDY	0x00000002	/* VRJ reg acc ok */
+#define MCHIP_HIC_STATUS_IDLE           0x00000003
+#define MCHIP_HIC_STATUS_CAPDIS		0x00000004	/* cap/disp in prog */
+#define MCHIP_HIC_STATUS_COMPDEC	0x00000008	/* (de)comp in prog */
+#define MCHIP_HIC_STATUS_BUSY		0x00000010	/* HIC busy */
+
+#define MCHIP_HIC_S_RATE		0x60		/* MJPEG # frames */
+
+#define MCHIP_HIC_PCI_VFMT		0x64		/* video format */
+#define MCHIP_HIC_PCI_VFMT_YVYU		0x00000001	/* 0: V Y' U Y */
+							/* 1: Y' V Y U */
+
+#define MCHIP_MCC_CMD			0x80		/* MCC commands */
+#define MCHIP_MCC_CMD_INITIAL		0x0		/* idle ? */
+#define MCHIP_MCC_CMD_IIC_START_SET	0x1
+#define MCHIP_MCC_CMD_IIC_END_SET	0x2
+#define MCHIP_MCC_CMD_FM_WRITE		0x3		/* frame memory */
+#define MCHIP_MCC_CMD_FM_READ		0x4
+#define MCHIP_MCC_CMD_FM_STOP		0x5
+#define MCHIP_MCC_CMD_CAPTURE		0x6
+#define MCHIP_MCC_CMD_DISPLAY		0x7
+#define MCHIP_MCC_CMD_END_DISP		0x8
+#define MCHIP_MCC_CMD_STILL_COMP	0x9
+#define MCHIP_MCC_CMD_STILL_DECOMP	0xa
+#define MCHIP_MCC_CMD_STILL_OUTPUT	0xb
+#define MCHIP_MCC_CMD_CONT_OUTPUT	0xc
+#define MCHIP_MCC_CMD_CONT_COMP		0xd
+#define MCHIP_MCC_CMD_CONT_DECOMP	0xe
+#define MCHIP_MCC_CMD_RESET		0xf		/* MCC reset */
+
+#define MCHIP_MCC_IIC_WR		0x84
+
+#define MCHIP_MCC_MCC_WR		0x88
+
+#define MCHIP_MCC_MCC_RD		0x8c
+
+#define MCHIP_MCC_STATUS		0x90
+#define MCHIP_MCC_STATUS_CAPT		0x00000001	/* capturing */
+#define MCHIP_MCC_STATUS_DISP		0x00000002	/* displaying */
+#define MCHIP_MCC_STATUS_COMP		0x00000004	/* compressing */
+#define MCHIP_MCC_STATUS_DECOMP		0x00000008	/* decompressing */
+#define MCHIP_MCC_STATUS_MCC_WR		0x00000010	/* register ready */
+#define MCHIP_MCC_STATUS_MCC_RD		0x00000020	/* register ready */
+#define MCHIP_MCC_STATUS_IIC_WR		0x00000040	/* register ready */
+#define MCHIP_MCC_STATUS_OUTPUT		0x00000080	/* output in prog */
+
+#define MCHIP_MCC_SIG_POLARITY		0x94
+#define MCHIP_MCC_SIG_POL_VS_H		0x00000001	/* VS active-high */
+#define MCHIP_MCC_SIG_POL_HS_H		0x00000002	/* HS active-high */
+#define MCHIP_MCC_SIG_POL_DOE_H		0x00000004	/* DOE active-high */
+
+#define MCHIP_MCC_IRQ			0x98
+#define MCHIP_MCC_IRQ_CAPDIS_STRT	0x00000001	/* cap/disp started */
+#define MCHIP_MCC_IRQ_CAPDIS_STRT_MASK	0x00000010
+#define MCHIP_MCC_IRQ_CAPDIS_END	0x00000002	/* cap/disp ended */
+#define MCHIP_MCC_IRQ_CAPDIS_END_MASK	0x00000020
+#define MCHIP_MCC_IRQ_COMPDEC_STRT	0x00000004	/* (de)comp started */
+#define MCHIP_MCC_IRQ_COMPDEC_STRT_MASK	0x00000040
+#define MCHIP_MCC_IRQ_COMPDEC_END	0x00000008	/* (de)comp ended */
+#define MCHIP_MCC_IRQ_COMPDEC_END_MASK	0x00000080
+
+#define MCHIP_MCC_HSTART		0x9c		/* video in */
+#define MCHIP_MCC_VSTART		0xa0
+#define MCHIP_MCC_HCOUNT		0xa4
+#define MCHIP_MCC_VCOUNT		0xa8
+#define MCHIP_MCC_R_XBASE		0xac		/* capt/disp */
+#define MCHIP_MCC_R_YBASE		0xb0
+#define MCHIP_MCC_R_XRANGE		0xb4
+#define MCHIP_MCC_R_YRANGE		0xb8
+#define MCHIP_MCC_B_XBASE		0xbc		/* comp/decomp */
+#define MCHIP_MCC_B_YBASE		0xc0
+#define MCHIP_MCC_B_XRANGE		0xc4
+#define MCHIP_MCC_B_YRANGE		0xc8
+
+#define MCHIP_MCC_R_SAMPLING		0xcc		/* 1: 1:4 */
+
+#define MCHIP_VRJ_CMD			0x100		/* VRJ commands */
+
+/* VRJ registers (see table 12.2.4) */
+#define MCHIP_VRJ_COMPRESSED_DATA	0x1b0
+#define MCHIP_VRJ_PIXEL_DATA		0x1b8
+
+#define MCHIP_VRJ_BUS_MODE		0x100
+#define MCHIP_VRJ_SIGNAL_ACTIVE_LEVEL	0x108
+#define MCHIP_VRJ_PDAT_USE		0x110
+#define MCHIP_VRJ_MODE_SPECIFY		0x118
+#define MCHIP_VRJ_LIMIT_COMPRESSED_LO	0x120
+#define MCHIP_VRJ_LIMIT_COMPRESSED_HI	0x124
+#define MCHIP_VRJ_COMP_DATA_FORMAT	0x128
+#define MCHIP_VRJ_TABLE_DATA		0x140
+#define MCHIP_VRJ_RESTART_INTERVAL	0x148
+#define MCHIP_VRJ_NUM_LINES		0x150
+#define MCHIP_VRJ_NUM_PIXELS		0x158
+#define MCHIP_VRJ_NUM_COMPONENTS	0x160
+#define MCHIP_VRJ_SOF1			0x168
+#define MCHIP_VRJ_SOF2			0x170
+#define MCHIP_VRJ_SOF3			0x178
+#define MCHIP_VRJ_SOF4			0x180
+#define MCHIP_VRJ_SOS			0x188
+#define MCHIP_VRJ_SOFT_RESET		0x190
+
+#define MCHIP_VRJ_STATUS		0x1c0
+#define MCHIP_VRJ_STATUS_BUSY		0x00001
+#define MCHIP_VRJ_STATUS_COMP_ACCESS	0x00002
+#define MCHIP_VRJ_STATUS_PIXEL_ACCESS	0x00004
+#define MCHIP_VRJ_STATUS_ERROR		0x00008
+
+#define MCHIP_VRJ_IRQ_FLAG		0x1c8
+#define MCHIP_VRJ_ERROR_REPORT		0x1d8
+
+#define MCHIP_VRJ_START_COMMAND		0x1a0
+
+/****************************************************************************/
+/* Driver definitions.                                                      */
+/****************************************************************************/
+
+/* Sony Programmable I/O Controller for accessing the camera commands */
+#include <linux/sony-laptop.h>
+
+/* private API definitions */
+#include <linux/meye.h>
+#include <linux/mutex.h>
+
+
+/* Enable jpg software correction */
+#define MEYE_JPEG_CORRECTION	1
+
+/* Maximum size of a buffer */
+#define MEYE_MAX_BUFSIZE	614400	/* 640 * 480 * 2 */
+
+/* Maximum number of buffers */
+#define MEYE_MAX_BUFNBRS	32
+
+/* State of a buffer */
+#define MEYE_BUF_UNUSED	0	/* not used */
+#define MEYE_BUF_USING	1	/* currently grabbing / playing */
+#define MEYE_BUF_DONE	2	/* done */
+
+/* grab buffer */
+struct meye_grab_buffer {
+	int state;			/* state of buffer */
+	unsigned long size;		/* size of jpg frame */
+	struct timeval timestamp;	/* timestamp */
+	unsigned long sequence;		/* sequence number */
+};
+
+/* size of kfifos containings buffer indices */
+#define MEYE_QUEUE_SIZE	MEYE_MAX_BUFNBRS
+
+/* Motion Eye device structure */
+struct meye {
+	struct v4l2_device v4l2_dev;	/* Main v4l2_device struct */
+	struct pci_dev *mchip_dev;	/* pci device */
+	u8 mchip_irq;			/* irq */
+	u8 mchip_mode;			/* actual mchip mode: HIC_MODE... */
+	u8 mchip_fnum;			/* current mchip frame number */
+	unsigned char __iomem *mchip_mmregs;/* mchip: memory mapped registers */
+	u8 *mchip_ptable[MCHIP_NB_PAGES];/* mchip: ptable */
+	void *mchip_ptable_toc;		/* mchip: ptable toc */
+	dma_addr_t mchip_dmahandle;	/* mchip: dma handle to ptable toc */
+	unsigned char *grab_fbuffer;	/* capture framebuffer */
+	unsigned char *grab_temp;	/* temporary buffer */
+					/* list of buffers */
+	struct meye_grab_buffer grab_buffer[MEYE_MAX_BUFNBRS];
+	int vma_use_count[MEYE_MAX_BUFNBRS]; /* mmap count */
+	struct mutex lock;		/* mutex for open/mmap... */
+	struct kfifo grabq;		/* queue for buffers to be grabbed */
+	spinlock_t grabq_lock;		/* lock protecting the queue */
+	struct kfifo doneq;		/* queue for grabbed buffers */
+	spinlock_t doneq_lock;		/* lock protecting the queue */
+	wait_queue_head_t proc_list;	/* wait queue */
+	struct video_device *vdev;	/* video device parameters */
+	u16 brightness;
+	u16 hue;
+	u16 contrast;
+	u16 colour;
+	struct meye_params params;	/* additional parameters */
+	unsigned long in_use;		/* set to 1 if the device is in use */
+#ifdef CONFIG_PM
+	u8 pm_mchip_mode;		/* old mchip mode */
+#endif
+};
+
+#endif
diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
new file mode 100644
index 0000000..04a82cb
--- /dev/null
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -0,0 +1,12 @@
+config STA2X11_VIP
+	tristate "STA2X11 VIP Video For Linux"
+	depends on STA2X11
+	select VIDEO_ADV7180 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEOBUF_DMA_CONTIG
+	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
+	help
+	  Say Y for support for STA2X11 VIP (Video Input Port) capture
+	  device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sta2x11_vip.
diff --git a/drivers/media/pci/sta2x11/Makefile b/drivers/media/pci/sta2x11/Makefile
new file mode 100644
index 0000000..d6c471d
--- /dev/null
+++ b/drivers/media/pci/sta2x11/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
new file mode 100644
index 0000000..4c10205
--- /dev/null
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -0,0 +1,1550 @@
+/*
+ * This is the driver for the STA2x11 Video Input Port.
+ *
+ * Copyright (C) 2010       WindRiver Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Author: Andreas Kies <andreas.kies@windriver.com>
+ *		Vlad Lungu <vlad.lungu@windriver.com>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/vmalloc.h>
+
+#include <linux/videodev2.h>
+
+#include <linux/kmod.h>
+
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf-dma-contig.h>
+
+#include "sta2x11_vip.h"
+
+#define DRV_NAME "sta2x11_vip"
+#define DRV_VERSION "1.3"
+
+#ifndef PCI_DEVICE_ID_STMICRO_VIP
+#define PCI_DEVICE_ID_STMICRO_VIP 0xCC0D
+#endif
+
+#define MAX_FRAMES 4
+
+/*Register offsets*/
+#define DVP_CTL		0x00
+#define DVP_TFO		0x04
+#define DVP_TFS		0x08
+#define DVP_BFO		0x0C
+#define DVP_BFS		0x10
+#define DVP_VTP         0x14
+#define DVP_VBP         0x18
+#define DVP_VMP		0x1C
+#define DVP_ITM		0x98
+#define DVP_ITS		0x9C
+#define DVP_STA		0xA0
+#define DVP_HLFLN	0xA8
+#define DVP_RGB		0xC0
+#define DVP_PKZ		0xF0
+
+/*Register fields*/
+#define DVP_CTL_ENA	0x00000001
+#define DVP_CTL_RST	0x80000000
+#define DVP_CTL_DIS	(~0x00040001)
+
+#define DVP_IT_VSB	0x00000008
+#define DVP_IT_VST	0x00000010
+#define DVP_IT_FIFO	0x00000020
+
+#define DVP_HLFLN_SD	0x00000001
+
+#define REG_WRITE(vip, reg, value) iowrite32((value), (vip->iomem)+(reg))
+#define REG_READ(vip, reg) ioread32((vip->iomem)+(reg))
+
+#define SAVE_COUNT 8
+#define AUX_COUNT 3
+#define IRQ_COUNT 1
+
+/**
+ * struct sta2x11_vip - All internal data for one instance of device
+ * @v4l2_dev: device registered in v4l layer
+ * @video_dev: properties of our device
+ * @pdev: PCI device
+ * @adapter: contains I2C adapter information
+ * @register_save_area: All relevant register are saved here during suspend
+ * @decoder: contains information about video DAC
+ * @format: pixel format, fixed UYVY
+ * @std: video standard (e.g. PAL/NTSC)
+ * @input: input line for video signal ( 0 or 1 )
+ * @users: Number of open of device ( max. 1 )
+ * @disabled: Device is in power down state
+ * @mutex: ensures exclusive opening of device
+ * @slock: for excluse acces of registers
+ * @vb_vidq: queue maintained by videobuf layer
+ * @capture: linked list of capture buffer
+ * @active: struct videobuf_buffer currently beingg filled
+ * @started: device is ready to capture frame
+ * @closing: device will be shut down
+ * @tcount: Number of top frames
+ * @bcount: Number of bottom frames
+ * @overflow: Number of FIFO overflows
+ * @mem_spare: small buffer of unused frame
+ * @dma_spare: dma addres of mem_spare
+ * @iomem: hardware base address
+ * @config: I2C and gpio config from platform
+ *
+ * All non-local data is accessed via this structure.
+ */
+
+struct sta2x11_vip {
+	struct v4l2_device v4l2_dev;
+	struct video_device *video_dev;
+	struct pci_dev *pdev;
+	struct i2c_adapter *adapter;
+	unsigned int register_save_area[IRQ_COUNT + SAVE_COUNT + AUX_COUNT];
+	struct v4l2_subdev *decoder;
+	struct v4l2_pix_format format;
+	v4l2_std_id std;
+	unsigned int input;
+	int users;
+	int disabled;
+	struct mutex mutex;	/* exclusive access during open */
+	spinlock_t slock;	/* spin lock for hardware and queue access */
+	struct videobuf_queue vb_vidq;
+	struct list_head capture;
+	struct videobuf_buffer *active;
+	int started, closing, tcount, bcount;
+	int overflow;
+	void *mem_spare;
+	dma_addr_t dma_spare;
+	void *iomem;
+	struct vip_config *config;
+};
+
+static const unsigned int registers_to_save[AUX_COUNT] = {
+	DVP_HLFLN, DVP_RGB, DVP_PKZ
+};
+
+static struct v4l2_pix_format formats_50[] = {
+	{			/*PAL interlaced */
+	 .width = 720,
+	 .height = 576,
+	 .pixelformat = V4L2_PIX_FMT_UYVY,
+	 .field = V4L2_FIELD_INTERLACED,
+	 .bytesperline = 720 * 2,
+	 .sizeimage = 720 * 2 * 576,
+	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
+	{			/*PAL top */
+	 .width = 720,
+	 .height = 288,
+	 .pixelformat = V4L2_PIX_FMT_UYVY,
+	 .field = V4L2_FIELD_TOP,
+	 .bytesperline = 720 * 2,
+	 .sizeimage = 720 * 2 * 288,
+	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
+	{			/*PAL bottom */
+	 .width = 720,
+	 .height = 288,
+	 .pixelformat = V4L2_PIX_FMT_UYVY,
+	 .field = V4L2_FIELD_BOTTOM,
+	 .bytesperline = 720 * 2,
+	 .sizeimage = 720 * 2 * 288,
+	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
+
+};
+
+static struct v4l2_pix_format formats_60[] = {
+	{			/*NTSC interlaced */
+	 .width = 720,
+	 .height = 480,
+	 .pixelformat = V4L2_PIX_FMT_UYVY,
+	 .field = V4L2_FIELD_INTERLACED,
+	 .bytesperline = 720 * 2,
+	 .sizeimage = 720 * 2 * 480,
+	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
+	{			/*NTSC top */
+	 .width = 720,
+	 .height = 240,
+	 .pixelformat = V4L2_PIX_FMT_UYVY,
+	 .field = V4L2_FIELD_TOP,
+	 .bytesperline = 720 * 2,
+	 .sizeimage = 720 * 2 * 240,
+	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
+	{			/*NTSC bottom */
+	 .width = 720,
+	 .height = 240,
+	 .pixelformat = V4L2_PIX_FMT_UYVY,
+	 .field = V4L2_FIELD_BOTTOM,
+	 .bytesperline = 720 * 2,
+	 .sizeimage = 720 * 2 * 240,
+	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
+};
+
+/**
+ * buf_setup - Get size and number of video buffer
+ * @vq: queue in videobuf
+ * @count: Number of buffers (1..MAX_FRAMES).
+ *		0 use default value.
+ * @size:  size of buffer in bytes
+ *
+ * returns size and number of buffers
+ * a preset value of 0 returns the default number.
+ * return value: 0, always succesfull.
+ */
+static int buf_setup(struct videobuf_queue *vq, unsigned int *count,
+		     unsigned int *size)
+{
+	struct sta2x11_vip *vip = vq->priv_data;
+
+	*size = vip->format.width * vip->format.height * 2;
+	if (0 == *count || MAX_FRAMES < *count)
+		*count = MAX_FRAMES;
+	return 0;
+};
+
+/**
+ * buf_prepare - prepare buffer for usage
+ * @vq: queue in videobuf layer
+ * @vb: buffer to be prepared
+ * @field: type of video data (interlaced/non-interlaced)
+ *
+ * Allocate or realloc buffer
+ * return value: 0, successful.
+ *
+ * -EINVAL, supplied buffer is too small.
+ *
+ *  other, buffer could not be locked.
+ */
+static int buf_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
+		       enum v4l2_field field)
+{
+	struct sta2x11_vip *vip = vq->priv_data;
+	int ret;
+
+	vb->size = vip->format.width * vip->format.height * 2;
+	if ((0 != vb->baddr) && (vb->bsize < vb->size))
+		return -EINVAL;
+	vb->width = vip->format.width;
+	vb->height = vip->format.height;
+	vb->field = field;
+
+	if (VIDEOBUF_NEEDS_INIT == vb->state) {
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret)
+			goto fail;
+	}
+	vb->state = VIDEOBUF_PREPARED;
+	return 0;
+fail:
+	videobuf_dma_contig_free(vq, vb);
+	vb->state = VIDEOBUF_NEEDS_INIT;
+	return ret;
+}
+
+/**
+ * buf_queu - queue buffer for filling
+ * @vq: queue in videobuf layer
+ * @vb: buffer to be queued
+ *
+ * if capturing is already running, the buffer will be queued. Otherwise
+ * capture is started and the buffer is used directly.
+ */
+static void buf_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+{
+	struct sta2x11_vip *vip = vq->priv_data;
+	u32 dma;
+
+	vb->state = VIDEOBUF_QUEUED;
+
+	if (vip->active) {
+		list_add_tail(&vb->queue, &vip->capture);
+		return;
+	}
+
+	vip->started = 1;
+	vip->tcount = 0;
+	vip->bcount = 0;
+	vip->active = vb;
+	vb->state = VIDEOBUF_ACTIVE;
+
+	dma = videobuf_to_dma_contig(vb);
+
+	REG_WRITE(vip, DVP_TFO, (0 << 16) | (0));
+	/* despite of interlace mode, upper and lower frames start at zero */
+	REG_WRITE(vip, DVP_BFO, (0 << 16) | (0));
+
+	switch (vip->format.field) {
+	case V4L2_FIELD_INTERLACED:
+		REG_WRITE(vip, DVP_TFS,
+			  ((vip->format.height / 2 - 1) << 16) |
+			  (2 * vip->format.width - 1));
+		REG_WRITE(vip, DVP_BFS, ((vip->format.height / 2 - 1) << 16) |
+			  (2 * vip->format.width - 1));
+		REG_WRITE(vip, DVP_VTP, dma);
+		REG_WRITE(vip, DVP_VBP, dma + vip->format.width * 2);
+		REG_WRITE(vip, DVP_VMP, 4 * vip->format.width);
+		break;
+	case V4L2_FIELD_TOP:
+		REG_WRITE(vip, DVP_TFS,
+			  ((vip->format.height - 1) << 16) |
+			  (2 * vip->format.width - 1));
+		REG_WRITE(vip, DVP_BFS, ((0) << 16) |
+			  (2 * vip->format.width - 1));
+		REG_WRITE(vip, DVP_VTP, dma);
+		REG_WRITE(vip, DVP_VBP, dma);
+		REG_WRITE(vip, DVP_VMP, 2 * vip->format.width);
+		break;
+	case V4L2_FIELD_BOTTOM:
+		REG_WRITE(vip, DVP_TFS, ((0) << 16) |
+			  (2 * vip->format.width - 1));
+		REG_WRITE(vip, DVP_BFS,
+			  ((vip->format.height) << 16) |
+			  (2 * vip->format.width - 1));
+		REG_WRITE(vip, DVP_VTP, dma);
+		REG_WRITE(vip, DVP_VBP, dma);
+		REG_WRITE(vip, DVP_VMP, 2 * vip->format.width);
+		break;
+
+	default:
+		pr_warning("VIP: unknown field format\n");
+		return;
+	}
+
+	REG_WRITE(vip, DVP_CTL, DVP_CTL_ENA);
+}
+
+/**
+ * buff_release - release buffer
+ * @vq: queue in videobuf layer
+ * @vb: buffer to be released
+ *
+ * release buffer in videobuf layer
+ */
+static void buf_release(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+{
+
+	videobuf_dma_contig_free(vq, vb);
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+static struct videobuf_queue_ops vip_qops = {
+	.buf_setup = buf_setup,
+	.buf_prepare = buf_prepare,
+	.buf_queue = buf_queue,
+	.buf_release = buf_release,
+};
+
+/**
+ * vip_open - open video device
+ * @file: descriptor of device
+ *
+ * open device, make sure it is only opened once.
+ * return value: 0, no error.
+ *
+ * -EBUSY, device is already opened
+ *
+ * -ENOMEM, no memory for auxiliary DMA buffer
+ */
+static int vip_open(struct file *file)
+{
+	struct video_device *dev = video_devdata(file);
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	mutex_lock(&vip->mutex);
+	vip->users++;
+
+	if (vip->users > 1) {
+		vip->users--;
+		mutex_unlock(&vip->mutex);
+		return -EBUSY;
+	}
+
+	file->private_data = dev;
+	vip->overflow = 0;
+	vip->started = 0;
+	vip->closing = 0;
+	vip->active = NULL;
+
+	INIT_LIST_HEAD(&vip->capture);
+	vip->mem_spare = dma_alloc_coherent(&vip->pdev->dev, 64,
+					    &vip->dma_spare, GFP_KERNEL);
+	if (!vip->mem_spare) {
+		vip->users--;
+		mutex_unlock(&vip->mutex);
+		return -ENOMEM;
+	}
+
+	mutex_unlock(&vip->mutex);
+	videobuf_queue_dma_contig_init_cached(&vip->vb_vidq,
+					      &vip_qops,
+					      &vip->pdev->dev,
+					      &vip->slock,
+					      V4L2_BUF_TYPE_VIDEO_CAPTURE,
+					      V4L2_FIELD_INTERLACED,
+					      sizeof(struct videobuf_buffer),
+					      vip, NULL);
+	REG_READ(vip, DVP_ITS);
+	REG_WRITE(vip, DVP_HLFLN, DVP_HLFLN_SD);
+	REG_WRITE(vip, DVP_ITM, DVP_IT_VSB | DVP_IT_VST);
+	REG_WRITE(vip, DVP_CTL, DVP_CTL_RST);
+	REG_WRITE(vip, DVP_CTL, 0);
+	REG_READ(vip, DVP_ITS);
+	return 0;
+}
+
+/**
+ * vip_close - close video device
+ * @file: descriptor of device
+ *
+ * close video device, wait until all pending operations are finished
+ * ( maximum FRAME_MAX buffers pending )
+ * Turn off interrupts.
+ *
+ * return value: 0, always succesful.
+ */
+static int vip_close(struct file *file)
+{
+	struct video_device *dev = video_devdata(file);
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	vip->closing = 1;
+	if (vip->active)
+		videobuf_waiton(&vip->vb_vidq, vip->active, 0, 0);
+	spin_lock_irq(&vip->slock);
+
+	REG_WRITE(vip, DVP_ITM, 0);
+	REG_WRITE(vip, DVP_CTL, DVP_CTL_RST);
+	REG_WRITE(vip, DVP_CTL, 0);
+	REG_READ(vip, DVP_ITS);
+
+	vip->started = 0;
+	vip->active = NULL;
+
+	spin_unlock_irq(&vip->slock);
+
+	videobuf_stop(&vip->vb_vidq);
+	videobuf_mmap_free(&vip->vb_vidq);
+
+	dma_free_coherent(&vip->pdev->dev, 64, vip->mem_spare, vip->dma_spare);
+	file->private_data = NULL;
+	mutex_lock(&vip->mutex);
+	vip->users--;
+	mutex_unlock(&vip->mutex);
+	return 0;
+}
+
+/**
+ * vip_read - read from video input
+ * @file: descriptor of device
+ * @data: user buffer
+ * @count: number of bytes to be read
+ * @ppos: position within stream
+ *
+ * read video data from video device.
+ * handling is done in generic videobuf layer
+ * return value: provided by videobuf layer
+ */
+static ssize_t vip_read(struct file *file, char __user *data,
+			size_t count, loff_t *ppos)
+{
+	struct video_device *dev = file->private_data;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_read_stream(&vip->vb_vidq, data, count, ppos, 0,
+				    file->f_flags & O_NONBLOCK);
+}
+
+/**
+ * vip_mmap - map user buffer
+ * @file: descriptor of device
+ * @vma: user buffer
+ *
+ * map user space buffer into kernel mode, including DMA address.
+ * handling is done in generic videobuf layer.
+ * return value: provided by videobuf layer
+ */
+static int vip_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *dev = file->private_data;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_mmap_mapper(&vip->vb_vidq, vma);
+}
+
+/**
+ * vip_poll - poll for event
+ * @file: descriptor of device
+ * @wait: contains events to be waited for
+ *
+ * wait for event related to video device.
+ * handling is done in generic videobuf layer.
+ * return value: provided by videobuf layer
+ */
+static unsigned int vip_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct video_device *dev = file->private_data;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_poll_stream(file, &vip->vb_vidq, wait);
+}
+
+/**
+ * vidioc_querycap - return capabilities of device
+ * @file: descriptor of device (not used)
+ * @priv: points to current videodevice
+ * @cap: contains return values
+ *
+ * the capabilities of the device are returned
+ *
+ * return value: 0, no error.
+ */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	memset(cap, 0, sizeof(struct v4l2_capability));
+	strcpy(cap->driver, DRV_NAME);
+	strcpy(cap->card, DRV_NAME);
+	cap->version = 0;
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
+		 pci_name(vip->pdev));
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+	    V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+/**
+ * vidioc_s_std - set video standard
+ * @file: descriptor of device (not used)
+ * @priv: points to current videodevice
+ * @std: contains standard to be set
+ *
+ * the video standard is set
+ *
+ * return value: 0, no error.
+ *
+ * -EIO, no input signal detected
+ *
+ * other, returned from video DAC.
+ */
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	v4l2_std_id oldstd = vip->std, newstd;
+	int status;
+
+	if (V4L2_STD_ALL == *std) {
+		v4l2_subdev_call(vip->decoder, core, s_std, *std);
+		ssleep(2);
+		v4l2_subdev_call(vip->decoder, video, querystd, &newstd);
+		v4l2_subdev_call(vip->decoder, video, g_input_status, &status);
+		if (status & V4L2_IN_ST_NO_SIGNAL)
+			return -EIO;
+		*std = vip->std = newstd;
+		if (oldstd != *std) {
+			if (V4L2_STD_525_60 & (*std))
+				vip->format = formats_60[0];
+			else
+				vip->format = formats_50[0];
+		}
+		return 0;
+	}
+
+	if (oldstd != *std) {
+		if (V4L2_STD_525_60 & (*std))
+			vip->format = formats_60[0];
+		else
+			vip->format = formats_50[0];
+	}
+
+	return v4l2_subdev_call(vip->decoder, core, s_std, *std);
+}
+
+/**
+ * vidioc_g_std - get video standard
+ * @file: descriptor of device (not used)
+ * @priv: points to current videodevice
+ * @std: contains return values
+ *
+ * the current video standard is returned
+ *
+ * return value: 0, no error.
+ */
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	*std = vip->std;
+	return 0;
+}
+
+/**
+ * vidioc_querystd - get possible video standards
+ * @file: descriptor of device (not used)
+ * @priv: points to current videodevice
+ * @std: contains return values
+ *
+ * all possible video standards are returned
+ *
+ * return value: delivered by video DAC routine.
+ */
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return v4l2_subdev_call(vip->decoder, video, querystd, std);
+
+}
+
+/**
+ * vidioc_queryctl - get possible control settings
+ * @file: descriptor of device (not used)
+ * @priv: points to current videodevice
+ * @ctrl: contains return values
+ *
+ * return possible values for a control
+ * return value: delivered by video DAC routine.
+ */
+static int vidioc_queryctrl(struct file *file, void *priv,
+			    struct v4l2_queryctrl *ctrl)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return v4l2_subdev_call(vip->decoder, core, queryctrl, ctrl);
+}
+
+/**
+ * vidioc_g_ctl - get control value
+ * @file: descriptor of device (not used)
+ * @priv: points to current videodevice
+ * @ctrl: contains return values
+ *
+ * return setting for a control value
+ * return value: delivered by video DAC routine.
+ */
+static int vidioc_g_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return v4l2_subdev_call(vip->decoder, core, g_ctrl, ctrl);
+}
+
+/**
+ * vidioc_s_ctl - set control value
+ * @file: descriptor of device (not used)
+ * @priv: points to current videodevice
+ * @ctrl: contains value to be set
+ *
+ * set value for a specific control
+ * return value: delivered by video DAC routine.
+ */
+static int vidioc_s_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return v4l2_subdev_call(vip->decoder, core, s_ctrl, ctrl);
+}
+
+/**
+ * vidioc_enum_input - return name of input line
+ * @file: descriptor of device (not used)
+ * @priv: points to current videodevice
+ * @inp: contains return values
+ *
+ * the user friendly name of the input line is returned
+ *
+ * return value: 0, no error.
+ *
+ * -EINVAL, input line number out of range
+ */
+static int vidioc_enum_input(struct file *file, void *priv,
+			     struct v4l2_input *inp)
+{
+	if (inp->index > 1)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std = V4L2_STD_ALL;
+	sprintf(inp->name, "Camera %u", inp->index);
+
+	return 0;
+}
+
+/**
+ * vidioc_s_input - set input line
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @i: new input line number
+ *
+ * the current active input line is set
+ *
+ * return value: 0, no error.
+ *
+ * -EINVAL, line number out of range
+ */
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	int ret;
+
+	if (i > 1)
+		return -EINVAL;
+	ret = v4l2_subdev_call(vip->decoder, video, s_routing, i, 0, 0);
+
+	if (!ret)
+		vip->input = i;
+
+	return 0;
+}
+
+/**
+ * vidioc_g_input - return input line
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @i: returned input line number
+ *
+ * the current active input line is returned
+ *
+ * return value: always 0.
+ */
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	*i = vip->input;
+	return 0;
+}
+
+/**
+ * vidioc_enum_fmt_vid_cap - return video capture format
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @f: returned format information
+ *
+ * returns name and format of video capture
+ * Only UYVY is supported by hardware.
+ *
+ * return value: always 0.
+ */
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+
+	if (f->index != 0)
+		return -EINVAL;
+
+	strcpy(f->description, "4:2:2, packed, UYVY");
+	f->pixelformat = V4L2_PIX_FMT_UYVY;
+	f->flags = 0;
+	return 0;
+}
+
+/**
+ * vidioc_try_fmt_vid_cap - set video capture format
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @f: new format
+ *
+ * new video format is set which includes width and
+ * field type. width is fixed to 720, no scaling.
+ * Only UYVY is supported by this hardware.
+ * the minimum height is 200, the maximum is 576 (PAL)
+ *
+ * return value: 0, no error
+ *
+ * -EINVAL, pixel or field format not supported
+ *
+ */
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	int interlace_lim;
+
+	if (V4L2_PIX_FMT_UYVY != f->fmt.pix.pixelformat)
+		return -EINVAL;
+
+	if (V4L2_STD_525_60 & vip->std)
+		interlace_lim = 240;
+	else
+		interlace_lim = 288;
+
+	switch (f->fmt.pix.field) {
+	case V4L2_FIELD_ANY:
+		if (interlace_lim < f->fmt.pix.height)
+			f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+		else
+			f->fmt.pix.field = V4L2_FIELD_BOTTOM;
+		break;
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+		if (interlace_lim < f->fmt.pix.height)
+			f->fmt.pix.height = interlace_lim;
+		break;
+	case V4L2_FIELD_INTERLACED:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	f->fmt.pix.height &= ~1;
+	if (2 * interlace_lim < f->fmt.pix.height)
+		f->fmt.pix.height = 2 * interlace_lim;
+	if (200 > f->fmt.pix.height)
+		f->fmt.pix.height = 200;
+	f->fmt.pix.width = 720;
+	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
+	f->fmt.pix.sizeimage = f->fmt.pix.width * 2 * f->fmt.pix.height;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+	return 0;
+}
+
+/**
+ * vidioc_s_fmt_vid_cap - set current video format parameters
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @f: returned format information
+ *
+ * set new capture format
+ * return value: 0, no error
+ *
+ * other, delivered by video DAC routine.
+ */
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	int ret;
+
+	ret = vidioc_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
+
+	memcpy(&vip->format, &f->fmt.pix, sizeof(struct v4l2_pix_format));
+	return 0;
+}
+
+/**
+ * vidioc_g_fmt_vid_cap - get current video format parameters
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @f: contains format information
+ *
+ * returns current video format parameters
+ *
+ * return value: 0, always successful
+ */
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	memcpy(&f->fmt.pix, &vip->format, sizeof(struct v4l2_pix_format));
+	return 0;
+}
+
+/**
+ * vidioc_reqfs - request buffer
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @p: video buffer
+ *
+ * Handling is done in generic videobuf layer.
+ */
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_reqbufs(&vip->vb_vidq, p);
+}
+
+/**
+ * vidioc_querybuf - query buffer
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @p: video buffer
+ *
+ * query buffer state.
+ * Handling is done in generic videobuf layer.
+ */
+static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_querybuf(&vip->vb_vidq, p);
+}
+
+/**
+ * vidioc_qbuf - queue a buffer
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @p: video buffer
+ *
+ * Handling is done in generic videobuf layer.
+ */
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_qbuf(&vip->vb_vidq, p);
+}
+
+/**
+ * vidioc_dqbuf - dequeue a buffer
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @p: video buffer
+ *
+ * Handling is done in generic videobuf layer.
+ */
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_dqbuf(&vip->vb_vidq, p, file->f_flags & O_NONBLOCK);
+}
+
+/**
+ * vidioc_streamon - turn on streaming
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @type: type of capture
+ *
+ * turn on streaming.
+ * Handling is done in generic videobuf layer.
+ */
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_streamon(&vip->vb_vidq);
+}
+
+/**
+ * vidioc_streamoff - turn off streaming
+ * @file: descriptor of device ( not used)
+ * @priv: points to current videodevice
+ * @type: type of capture
+ *
+ * turn off streaming.
+ * Handling is done in generic videobuf layer.
+ */
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct video_device *dev = priv;
+	struct sta2x11_vip *vip = video_get_drvdata(dev);
+
+	return videobuf_streamoff(&vip->vb_vidq);
+}
+
+static const struct v4l2_file_operations vip_fops = {
+	.owner = THIS_MODULE,
+	.open = vip_open,
+	.release = vip_close,
+	.ioctl = video_ioctl2,
+	.read = vip_read,
+	.mmap = vip_mmap,
+	.poll = vip_poll
+};
+
+static const struct v4l2_ioctl_ops vip_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_s_std = vidioc_s_std,
+	.vidioc_g_std = vidioc_g_std,
+	.vidioc_querystd = vidioc_querystd,
+	.vidioc_queryctrl = vidioc_queryctrl,
+	.vidioc_g_ctrl = vidioc_g_ctrl,
+	.vidioc_s_ctrl = vidioc_s_ctrl,
+	.vidioc_enum_input = vidioc_enum_input,
+	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
+	.vidioc_s_input = vidioc_s_input,
+	.vidioc_g_input = vidioc_g_input,
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
+	.vidioc_reqbufs = vidioc_reqbufs,
+	.vidioc_querybuf = vidioc_querybuf,
+	.vidioc_qbuf = vidioc_qbuf,
+	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_streamon = vidioc_streamon,
+	.vidioc_streamoff = vidioc_streamoff,
+};
+
+static struct video_device video_dev_template = {
+	.name = DRV_NAME,
+	.release = video_device_release,
+	.fops = &vip_fops,
+	.ioctl_ops = &vip_ioctl_ops,
+	.tvnorms = V4L2_STD_ALL,
+};
+
+/**
+ * vip_irq - interrupt routine
+ * @irq: Number of interrupt ( not used, correct number is assumed )
+ * @vip: local data structure containing all information
+ *
+ * check for both frame interrupts set ( top and bottom ).
+ * check FIFO overflow, but limit number of log messages after open.
+ * signal a complete buffer if done.
+ * dequeue a new buffer if available.
+ * disable VIP if no buffer available.
+ *
+ * return value: IRQ_NONE, interrupt was not generated by VIP
+ *
+ * IRQ_HANDLED, interrupt done.
+ */
+static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
+{
+	u32 status, dma;
+	unsigned long flags;
+	struct videobuf_buffer *vb;
+
+	status = REG_READ(vip, DVP_ITS);
+
+	if (!status) {
+		pr_debug("VIP: irq ignored\n");
+		return IRQ_NONE;
+	}
+
+	if (!vip->started)
+		return IRQ_HANDLED;
+
+	if (status & DVP_IT_VSB)
+		vip->bcount++;
+
+	if (status & DVP_IT_VST)
+		vip->tcount++;
+
+	if ((DVP_IT_VSB | DVP_IT_VST) == (status & (DVP_IT_VST | DVP_IT_VSB))) {
+		/* this is bad, we are too slow, hope the condition is gone
+		 * on the next frame */
+		pr_info("VIP: both irqs\n");
+		return IRQ_HANDLED;
+	}
+
+	if (status & DVP_IT_FIFO) {
+		if (5 > vip->overflow++)
+			pr_info("VIP: fifo overflow\n");
+	}
+
+	if (2 > vip->tcount)
+		return IRQ_HANDLED;
+
+	if (status & DVP_IT_VSB)
+		return IRQ_HANDLED;
+
+	spin_lock_irqsave(&vip->slock, flags);
+
+	REG_WRITE(vip, DVP_CTL, REG_READ(vip, DVP_CTL) & ~DVP_CTL_ENA);
+	if (vip->active) {
+		do_gettimeofday(&vip->active->ts);
+		vip->active->field_count++;
+		vip->active->state = VIDEOBUF_DONE;
+		wake_up(&vip->active->done);
+		vip->active = NULL;
+	}
+	if (!vip->closing) {
+		if (list_empty(&vip->capture))
+			goto done;
+
+		vb = list_first_entry(&vip->capture, struct videobuf_buffer,
+				      queue);
+		if (NULL == vb) {
+			pr_info("VIP: no buffer\n");
+			goto done;
+		}
+		vb->state = VIDEOBUF_ACTIVE;
+		list_del(&vb->queue);
+		vip->active = vb;
+		dma = videobuf_to_dma_contig(vb);
+		switch (vip->format.field) {
+		case V4L2_FIELD_INTERLACED:
+			REG_WRITE(vip, DVP_VTP, dma);
+			REG_WRITE(vip, DVP_VBP, dma + vip->format.width * 2);
+			break;
+		case V4L2_FIELD_TOP:
+		case V4L2_FIELD_BOTTOM:
+			REG_WRITE(vip, DVP_VTP, dma);
+			REG_WRITE(vip, DVP_VBP, dma);
+			break;
+		default:
+			pr_warning("VIP: unknown field format\n");
+			goto done;
+			break;
+		}
+		REG_WRITE(vip, DVP_CTL, REG_READ(vip, DVP_CTL) | DVP_CTL_ENA);
+	}
+done:
+	spin_unlock_irqrestore(&vip->slock, flags);
+	return IRQ_HANDLED;
+}
+
+/**
+ * vip_gpio_reserve - reserve gpio pin
+ * @dev: device
+ * @pin: GPIO pin number
+ * @dir: direction, input or output
+ * @name: GPIO pin name
+ *
+ */
+static int vip_gpio_reserve(struct device *dev, int pin, int dir,
+			    const char *name)
+{
+	int ret;
+
+	if (pin == -1)
+		return 0;
+
+	ret = gpio_request(pin, name);
+	if (ret) {
+		dev_err(dev, "Failed to allocate pin %d (%s)\n", pin, name);
+		return ret;
+	}
+
+	ret = gpio_direction_output(pin, dir);
+	if (ret) {
+		dev_err(dev, "Failed to set direction for pin %d (%s)\n",
+			pin, name);
+		gpio_free(pin);
+		return ret;
+	}
+
+	ret = gpio_export(pin, false);
+	if (ret) {
+		dev_err(dev, "Failed to export pin %d (%s)\n", pin, name);
+		gpio_free(pin);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * vip_gpio_release - release gpio pin
+ * @dev: device
+ * @pin: GPIO pin number
+ * @name: GPIO pin name
+ *
+ */
+static void vip_gpio_release(struct device *dev, int pin, const char *name)
+{
+	if (pin != -1) {
+		dev_dbg(dev, "releasing pin %d (%s)\n",	pin, name);
+		gpio_unexport(pin);
+		gpio_free(pin);
+	}
+}
+
+/**
+ * sta2x11_vip_init_one - init one instance of video device
+ * @pdev: PCI device
+ * @ent: (not used)
+ *
+ * allocate reset pins for DAC.
+ * Reset video DAC, this is done via reset line.
+ * allocate memory for managing device
+ * request interrupt
+ * map IO region
+ * register device
+ * find and initialize video DAC
+ *
+ * return value: 0, no error
+ *
+ * -ENOMEM, no memory
+ *
+ * -ENODEV, device could not be detected or registered
+ */
+static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
+					  const struct pci_device_id *ent)
+{
+	int ret;
+	struct sta2x11_vip *vip;
+	struct vip_config *config;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	config = dev_get_platdata(&pdev->dev);
+	if (!config) {
+		dev_info(&pdev->dev, "VIP slot disabled\n");
+		ret = -EINVAL;
+		goto disable;
+	}
+
+	ret = vip_gpio_reserve(&pdev->dev, config->pwr_pin, 0,
+			       config->pwr_name);
+	if (ret)
+		goto disable;
+
+	if (config->reset_pin >= 0) {
+		ret = vip_gpio_reserve(&pdev->dev, config->reset_pin, 0,
+				       config->reset_name);
+		if (ret) {
+			vip_gpio_release(&pdev->dev, config->pwr_pin,
+					 config->pwr_name);
+			goto disable;
+		}
+	}
+
+	if (config->pwr_pin != -1) {
+		/* Datasheet says 5ms between PWR and RST */
+		usleep_range(5000, 25000);
+		ret = gpio_direction_output(config->pwr_pin, 1);
+	}
+
+	if (config->reset_pin != -1) {
+		/* Datasheet says 5ms between PWR and RST */
+		usleep_range(5000, 25000);
+		ret = gpio_direction_output(config->reset_pin, 1);
+	}
+	usleep_range(5000, 25000);
+
+	vip = kzalloc(sizeof(struct sta2x11_vip), GFP_KERNEL);
+	if (!vip) {
+		ret = -ENOMEM;
+		goto release_gpios;
+	}
+
+	vip->pdev = pdev;
+	vip->std = V4L2_STD_PAL;
+	vip->format = formats_50[0];
+	vip->config = config;
+
+	if (v4l2_device_register(&pdev->dev, &vip->v4l2_dev))
+		goto free_mem;
+
+	dev_dbg(&pdev->dev, "BAR #0 at 0x%lx 0x%lx irq %d\n",
+		(unsigned long)pci_resource_start(pdev, 0),
+		(unsigned long)pci_resource_len(pdev, 0), pdev->irq);
+
+	pci_set_master(pdev);
+
+	ret = pci_request_regions(pdev, DRV_NAME);
+	if (ret)
+		goto unreg;
+
+	vip->iomem = pci_iomap(pdev, 0, 0x100);
+	if (!vip->iomem) {
+		ret = -ENOMEM; /* FIXME */
+		goto release;
+	}
+
+	pci_enable_msi(pdev);
+
+	INIT_LIST_HEAD(&vip->capture);
+	spin_lock_init(&vip->slock);
+	mutex_init(&vip->mutex);
+	vip->started = 0;
+	vip->disabled = 0;
+
+	ret = request_irq(pdev->irq,
+			  (irq_handler_t) vip_irq,
+			  IRQF_SHARED, DRV_NAME, vip);
+	if (ret) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		ret = -ENODEV;
+		goto unmap;
+	}
+
+	vip->video_dev = video_device_alloc();
+	if (!vip->video_dev) {
+		ret = -ENOMEM;
+		goto release_irq;
+	}
+
+	*(vip->video_dev) = video_dev_template;
+	video_set_drvdata(vip->video_dev, vip);
+
+	ret = video_register_device(vip->video_dev, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto vrelease;
+
+	vip->adapter = i2c_get_adapter(vip->config->i2c_id);
+	if (!vip->adapter) {
+		ret = -ENODEV;
+		dev_err(&pdev->dev, "no I2C adapter found\n");
+		goto vunreg;
+	}
+
+	vip->decoder = v4l2_i2c_new_subdev(&vip->v4l2_dev, vip->adapter,
+					   "adv7180", vip->config->i2c_addr,
+					   NULL);
+	if (!vip->decoder) {
+		ret = -ENODEV;
+		dev_err(&pdev->dev, "no decoder found\n");
+		goto vunreg;
+	}
+
+	i2c_put_adapter(vip->adapter);
+
+	v4l2_subdev_call(vip->decoder, core, init, 0);
+
+	pr_info("STA2X11 Video Input Port (VIP) loaded\n");
+	return 0;
+
+vunreg:
+	video_set_drvdata(vip->video_dev, NULL);
+vrelease:
+	if (video_is_registered(vip->video_dev))
+		video_unregister_device(vip->video_dev);
+	else
+		video_device_release(vip->video_dev);
+release_irq:
+	free_irq(pdev->irq, vip);
+	pci_disable_msi(pdev);
+unmap:
+	pci_iounmap(pdev, vip->iomem);
+	mutex_destroy(&vip->mutex);
+release:
+	pci_release_regions(pdev);
+unreg:
+	v4l2_device_unregister(&vip->v4l2_dev);
+free_mem:
+	kfree(vip);
+release_gpios:
+	vip_gpio_release(&pdev->dev, config->reset_pin, config->reset_name);
+	vip_gpio_release(&pdev->dev, config->pwr_pin, config->pwr_name);
+disable:
+	/*
+	 * do not call pci_disable_device on sta2x11 because it break all
+	 * other Bus masters on this EP
+	 */
+	return ret;
+}
+
+/**
+ * sta2x11_vip_remove_one - release device
+ * @pdev: PCI device
+ *
+ * Undo everything done in .._init_one
+ *
+ * unregister video device
+ * free interrupt
+ * unmap ioadresses
+ * free memory
+ * free GPIO pins
+ */
+static void __devexit sta2x11_vip_remove_one(struct pci_dev *pdev)
+{
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	struct sta2x11_vip *vip =
+	    container_of(v4l2_dev, struct sta2x11_vip, v4l2_dev);
+
+	video_set_drvdata(vip->video_dev, NULL);
+	video_unregister_device(vip->video_dev);
+	/*do not call video_device_release() here, is already done */
+	free_irq(pdev->irq, vip);
+	pci_disable_msi(pdev);
+	pci_iounmap(pdev, vip->iomem);
+	pci_release_regions(pdev);
+
+	v4l2_device_unregister(&vip->v4l2_dev);
+	mutex_destroy(&vip->mutex);
+
+	vip_gpio_release(&pdev->dev, vip->config->pwr_pin,
+			 vip->config->pwr_name);
+	vip_gpio_release(&pdev->dev, vip->config->reset_pin,
+			 vip->config->reset_name);
+
+	kfree(vip);
+	/*
+	 * do not call pci_disable_device on sta2x11 because it break all
+	 * other Bus masters on this EP
+	 */
+}
+
+#ifdef CONFIG_PM
+
+/**
+ * sta2x11_vip_suspend - set device into power save mode
+ * @pdev: PCI device
+ * @state: new state of device
+ *
+ * all relevant registers are saved and an attempt to set a new state is made.
+ *
+ * return value: 0 always indicate success,
+ * even if device could not be disabled. (workaround for hardware problem)
+ *
+ * reurn value : 0, always succesful, even if hardware does not not support
+ * power down mode.
+ */
+static int sta2x11_vip_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	struct sta2x11_vip *vip =
+	    container_of(v4l2_dev, struct sta2x11_vip, v4l2_dev);
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&vip->slock, flags);
+	vip->register_save_area[0] = REG_READ(vip, DVP_CTL);
+	REG_WRITE(vip, DVP_CTL, vip->register_save_area[0] & DVP_CTL_DIS);
+	vip->register_save_area[SAVE_COUNT] = REG_READ(vip, DVP_ITM);
+	REG_WRITE(vip, DVP_ITM, 0);
+	for (i = 1; i < SAVE_COUNT; i++)
+		vip->register_save_area[i] = REG_READ(vip, 4 * i);
+	for (i = 0; i < AUX_COUNT; i++)
+		vip->register_save_area[SAVE_COUNT + IRQ_COUNT + i] =
+		    REG_READ(vip, registers_to_save[i]);
+	spin_unlock_irqrestore(&vip->slock, flags);
+	/* save pci state */
+	pci_save_state(pdev);
+	if (pci_set_power_state(pdev, pci_choose_state(pdev, state))) {
+		/*
+		 * do not call pci_disable_device on sta2x11 because it
+		 * break all other Bus masters on this EP
+		 */
+		vip->disabled = 1;
+	}
+
+	pr_info("VIP: suspend\n");
+	return 0;
+}
+
+/**
+ * sta2x11_vip_resume - resume device operation
+ * @pdev : PCI device
+ *
+ * re-enable device, set PCI state to powered and restore registers.
+ * resume normal device operation afterwards.
+ *
+ * return value: 0, no error.
+ *
+ * other, could not set device to power on state.
+ */
+static int sta2x11_vip_resume(struct pci_dev *pdev)
+{
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	struct sta2x11_vip *vip =
+	    container_of(v4l2_dev, struct sta2x11_vip, v4l2_dev);
+	unsigned long flags;
+	int ret, i;
+
+	pr_info("VIP: resume\n");
+	/* restore pci state */
+	if (vip->disabled) {
+		ret = pci_enable_device(pdev);
+		if (ret) {
+			pr_warning("VIP: Can't enable device.\n");
+			return ret;
+		}
+		vip->disabled = 0;
+	}
+	ret = pci_set_power_state(pdev, PCI_D0);
+	if (ret) {
+		/*
+		 * do not call pci_disable_device on sta2x11 because it
+		 * break all other Bus masters on this EP
+		 */
+		pr_warning("VIP: Can't enable device.\n");
+		vip->disabled = 1;
+		return ret;
+	}
+
+	pci_restore_state(pdev);
+
+	spin_lock_irqsave(&vip->slock, flags);
+	for (i = 1; i < SAVE_COUNT; i++)
+		REG_WRITE(vip, 4 * i, vip->register_save_area[i]);
+	for (i = 0; i < AUX_COUNT; i++)
+		REG_WRITE(vip, registers_to_save[i],
+			  vip->register_save_area[SAVE_COUNT + IRQ_COUNT + i]);
+	REG_WRITE(vip, DVP_CTL, vip->register_save_area[0]);
+	REG_WRITE(vip, DVP_ITM, vip->register_save_area[SAVE_COUNT]);
+	spin_unlock_irqrestore(&vip->slock, flags);
+	return 0;
+}
+
+#endif
+
+static DEFINE_PCI_DEVICE_TABLE(sta2x11_vip_pci_tbl) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_VIP)},
+	{0,}
+};
+
+static struct pci_driver sta2x11_vip_driver = {
+	.name = DRV_NAME,
+	.probe = sta2x11_vip_init_one,
+	.remove = __devexit_p(sta2x11_vip_remove_one),
+	.id_table = sta2x11_vip_pci_tbl,
+#ifdef CONFIG_PM
+	.suspend = sta2x11_vip_suspend,
+	.resume = sta2x11_vip_resume,
+#endif
+};
+
+static int __init sta2x11_vip_init_module(void)
+{
+	return pci_register_driver(&sta2x11_vip_driver);
+}
+
+static void __exit sta2x11_vip_exit_module(void)
+{
+	pci_unregister_driver(&sta2x11_vip_driver);
+}
+
+#ifdef MODULE
+module_init(sta2x11_vip_init_module);
+module_exit(sta2x11_vip_exit_module);
+#else
+late_initcall_sync(sta2x11_vip_init_module);
+#endif
+
+MODULE_DESCRIPTION("STA2X11 Video Input Port driver");
+MODULE_AUTHOR("Wind River");
+MODULE_LICENSE("GPL v2");
+MODULE_SUPPORTED_DEVICE("sta2x11 video input");
+MODULE_VERSION(DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, sta2x11_vip_pci_tbl);
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.h b/drivers/media/pci/sta2x11/sta2x11_vip.h
new file mode 100644
index 0000000..4f81a13
--- /dev/null
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c) 2011 Wind River Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author:  Anders Wallin <anders.wallin@windriver.com>
+ *
+ */
+
+#ifndef __STA2X11_VIP_H
+#define __STA2X11_VIP_H
+
+/**
+ * struct vip_config - video input configuration data
+ * @pwr_name: ADV powerdown name
+ * @pwr_pin: ADV powerdown pin
+ * @reset_name: ADV reset name
+ * @reset_pin: ADV reset pin
+ */
+struct vip_config {
+	const char *pwr_name;
+	int pwr_pin;
+	const char *reset_name;
+	int reset_pin;
+	int i2c_id;
+	int i2c_addr;
+};
+
+#endif /* __STA2X11_VIP_H */
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4d79dfd..d545d93 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -606,51 +606,6 @@ config VIDEO_VIVI
 	  In doubt, say N.
 
 #
-# PCI drivers configuration - No devices here are for webcams
-#
-
-menuconfig V4L_PCI_DRIVERS
-	bool "V4L PCI(e) devices"
-	depends on PCI
-	depends on MEDIA_ANALOG_TV_SUPPORT
-	default y
-	---help---
-	  Say Y here to enable support for these PCI(e) drivers.
-
-if V4L_PCI_DRIVERS
-
-config VIDEO_MEYE
-	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
-	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
-	---help---
-	  This is the video4linux driver for the Motion Eye camera found
-	  in the Vaio Picturebook laptops. Please read the material in
-	  <file:Documentation/video4linux/meye.txt> for more information.
-
-	  If you say Y or M here, you need to say Y or M to "Sony Laptop
-	  Extras" in the misc device section.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called meye.
-
-
-
-config STA2X11_VIP
-	tristate "STA2X11 VIP Video For Linux"
-	depends on STA2X11
-	select VIDEO_ADV7180 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEOBUF_DMA_CONTIG
-	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
-	help
-	  Say Y for support for STA2X11 VIP (Video Input Port) capture
-	  device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called sta2x11_vip.
-
-endif # V4L_PCI_DRIVERS
-
-#
 # ISA & parallel port drivers configuration
 #	All devices here are webcam or grabber devices
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 8df694d..f212af3 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -92,8 +92,6 @@ obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
 obj-$(CONFIG_VIDEO_W9966) += w9966.o
 obj-$(CONFIG_VIDEO_PMS) += pms.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
-obj-$(CONFIG_VIDEO_MEYE) += meye.o
-obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
deleted file mode 100644
index 7bc7752..0000000
--- a/drivers/media/video/meye.c
+++ /dev/null
@@ -1,1964 +0,0 @@
-/*
- * Motion Eye video4linux driver for Sony Vaio PictureBook
- *
- * Copyright (C) 2001-2004 Stelian Pop <stelian@popies.net>
- *
- * Copyright (C) 2001-2002 Alcôve <www.alcove.com>
- *
- * Copyright (C) 2000 Andrew Tridgell <tridge@valinux.com>
- *
- * Earlier work by Werner Almesberger, Paul `Rusty' Russell and Paul Mackerras.
- *
- * Some parts borrowed from various video4linux drivers, especially
- * bttv-driver.c and zoran.c, see original files for credits.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/gfp.h>
-#include <linux/videodev2.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/vmalloc.h>
-#include <linux/dma-mapping.h>
-
-#include "meye.h"
-#include <linux/meye.h>
-
-MODULE_AUTHOR("Stelian Pop <stelian@popies.net>");
-MODULE_DESCRIPTION("v4l2 driver for the MotionEye camera");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(MEYE_DRIVER_VERSION);
-
-/* number of grab buffers */
-static unsigned int gbuffers = 2;
-module_param(gbuffers, int, 0444);
-MODULE_PARM_DESC(gbuffers, "number of capture buffers, default is 2 (32 max)");
-
-/* size of a grab buffer */
-static unsigned int gbufsize = MEYE_MAX_BUFSIZE;
-module_param(gbufsize, int, 0444);
-MODULE_PARM_DESC(gbufsize, "size of the capture buffers, default is 614400"
-		 " (will be rounded up to a page multiple)");
-
-/* /dev/videoX registration number */
-static int video_nr = -1;
-module_param(video_nr, int, 0444);
-MODULE_PARM_DESC(video_nr, "video device to register (0=/dev/video0, etc)");
-
-/* driver structure - only one possible */
-static struct meye meye;
-
-/****************************************************************************/
-/* Memory allocation routines (stolen from bttv-driver.c)                   */
-/****************************************************************************/
-static void *rvmalloc(unsigned long size)
-{
-	void *mem;
-	unsigned long adr;
-
-	size = PAGE_ALIGN(size);
-	mem = vmalloc_32(size);
-	if (mem) {
-		memset(mem, 0, size);
-		adr = (unsigned long) mem;
-		while (size > 0) {
-			SetPageReserved(vmalloc_to_page((void *)adr));
-			adr += PAGE_SIZE;
-			size -= PAGE_SIZE;
-		}
-	}
-	return mem;
-}
-
-static void rvfree(void * mem, unsigned long size)
-{
-	unsigned long adr;
-
-	if (mem) {
-		adr = (unsigned long) mem;
-		while ((long) size > 0) {
-			ClearPageReserved(vmalloc_to_page((void *)adr));
-			adr += PAGE_SIZE;
-			size -= PAGE_SIZE;
-		}
-		vfree(mem);
-	}
-}
-
-/*
- * return a page table pointing to N pages of locked memory
- *
- * NOTE: The meye device expects DMA addresses on 32 bits, we build
- * a table of 1024 entries = 4 bytes * 1024 = 4096 bytes.
- */
-static int ptable_alloc(void)
-{
-	u32 *pt;
-	int i;
-
-	memset(meye.mchip_ptable, 0, sizeof(meye.mchip_ptable));
-
-	/* give only 32 bit DMA addresses */
-	if (dma_set_mask(&meye.mchip_dev->dev, DMA_BIT_MASK(32)))
-		return -1;
-
-	meye.mchip_ptable_toc = dma_alloc_coherent(&meye.mchip_dev->dev,
-						   PAGE_SIZE,
-						   &meye.mchip_dmahandle,
-						   GFP_KERNEL);
-	if (!meye.mchip_ptable_toc) {
-		meye.mchip_dmahandle = 0;
-		return -1;
-	}
-
-	pt = meye.mchip_ptable_toc;
-	for (i = 0; i < MCHIP_NB_PAGES; i++) {
-		dma_addr_t dma;
-		meye.mchip_ptable[i] = dma_alloc_coherent(&meye.mchip_dev->dev,
-							  PAGE_SIZE,
-							  &dma,
-							  GFP_KERNEL);
-		if (!meye.mchip_ptable[i]) {
-			int j;
-			pt = meye.mchip_ptable_toc;
-			for (j = 0; j < i; ++j) {
-				dma = (dma_addr_t) *pt;
-				dma_free_coherent(&meye.mchip_dev->dev,
-						  PAGE_SIZE,
-						  meye.mchip_ptable[j], dma);
-				pt++;
-			}
-			dma_free_coherent(&meye.mchip_dev->dev,
-					  PAGE_SIZE,
-					  meye.mchip_ptable_toc,
-					  meye.mchip_dmahandle);
-			meye.mchip_ptable_toc = NULL;
-			meye.mchip_dmahandle = 0;
-			return -1;
-		}
-		*pt = (u32) dma;
-		pt++;
-	}
-	return 0;
-}
-
-static void ptable_free(void)
-{
-	u32 *pt;
-	int i;
-
-	pt = meye.mchip_ptable_toc;
-	for (i = 0; i < MCHIP_NB_PAGES; i++) {
-		dma_addr_t dma = (dma_addr_t) *pt;
-		if (meye.mchip_ptable[i])
-			dma_free_coherent(&meye.mchip_dev->dev,
-					  PAGE_SIZE,
-					  meye.mchip_ptable[i], dma);
-		pt++;
-	}
-
-	if (meye.mchip_ptable_toc)
-		dma_free_coherent(&meye.mchip_dev->dev,
-				  PAGE_SIZE,
-				  meye.mchip_ptable_toc,
-				  meye.mchip_dmahandle);
-
-	memset(meye.mchip_ptable, 0, sizeof(meye.mchip_ptable));
-	meye.mchip_ptable_toc = NULL;
-	meye.mchip_dmahandle = 0;
-}
-
-/* copy data from ptable into buf */
-static void ptable_copy(u8 *buf, int start, int size, int pt_pages)
-{
-	int i;
-
-	for (i = 0; i < (size / PAGE_SIZE) * PAGE_SIZE; i += PAGE_SIZE) {
-		memcpy(buf + i, meye.mchip_ptable[start++], PAGE_SIZE);
-		if (start >= pt_pages)
-			start = 0;
-	}
-	memcpy(buf + i, meye.mchip_ptable[start], size % PAGE_SIZE);
-}
-
-/****************************************************************************/
-/* JPEG tables at different qualities to load into the VRJ chip             */
-/****************************************************************************/
-
-/* return a set of quantisation tables based on a quality from 1 to 10 */
-static u16 *jpeg_quantisation_tables(int *length, int quality)
-{
-	static u16 jpeg_tables[][70] = { {
-		0xdbff, 0x4300, 0xff00, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff,
-		0xdbff, 0x4300, 0xff01, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff,
-	},
-	{
-		0xdbff, 0x4300, 0x5000, 0x3c37, 0x3c46, 0x5032, 0x4146, 0x5a46,
-		0x5055, 0x785f, 0x82c8, 0x6e78, 0x786e, 0xaff5, 0x91b9, 0xffc8,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff,
-		0xdbff, 0x4300, 0x5501, 0x5a5a, 0x6978, 0xeb78, 0x8282, 0xffeb,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
-		0xffff, 0xffff, 0xffff,
-	},
-	{
-		0xdbff, 0x4300, 0x2800, 0x1e1c, 0x1e23, 0x2819, 0x2123, 0x2d23,
-		0x282b, 0x3c30, 0x4164, 0x373c, 0x3c37, 0x587b, 0x495d, 0x9164,
-		0x9980, 0x8f96, 0x8c80, 0xa08a, 0xe6b4, 0xa0c3, 0xdaaa, 0x8aad,
-		0xc88c, 0xcbff, 0xeeda, 0xfff5, 0xffff, 0xc19b, 0xffff, 0xfaff,
-		0xe6ff, 0xfffd, 0xfff8,
-		0xdbff, 0x4300, 0x2b01, 0x2d2d, 0x353c, 0x763c, 0x4141, 0xf876,
-		0x8ca5, 0xf8a5, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8,
-		0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8,
-		0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8, 0xf8f8,
-		0xf8f8, 0xf8f8, 0xfff8,
-	},
-	{
-		0xdbff, 0x4300, 0x1b00, 0x1412, 0x1417, 0x1b11, 0x1617, 0x1e17,
-		0x1b1c, 0x2820, 0x2b42, 0x2528, 0x2825, 0x3a51, 0x303d, 0x6042,
-		0x6555, 0x5f64, 0x5d55, 0x6a5b, 0x9978, 0x6a81, 0x9071, 0x5b73,
-		0x855d, 0x86b5, 0x9e90, 0xaba3, 0xabad, 0x8067, 0xc9bc, 0xa6ba,
-		0x99c7, 0xaba8, 0xffa4,
-		0xdbff, 0x4300, 0x1c01, 0x1e1e, 0x2328, 0x4e28, 0x2b2b, 0xa44e,
-		0x5d6e, 0xa46e, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4,
-		0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4,
-		0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4, 0xa4a4,
-		0xa4a4, 0xa4a4, 0xffa4,
-	},
-	{
-		0xdbff, 0x4300, 0x1400, 0x0f0e, 0x0f12, 0x140d, 0x1012, 0x1712,
-		0x1415, 0x1e18, 0x2132, 0x1c1e, 0x1e1c, 0x2c3d, 0x242e, 0x4932,
-		0x4c40, 0x474b, 0x4640, 0x5045, 0x735a, 0x5062, 0x6d55, 0x4556,
-		0x6446, 0x6588, 0x776d, 0x817b, 0x8182, 0x604e, 0x978d, 0x7d8c,
-		0x7396, 0x817e, 0xff7c,
-		0xdbff, 0x4300, 0x1501, 0x1717, 0x1a1e, 0x3b1e, 0x2121, 0x7c3b,
-		0x4653, 0x7c53, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c,
-		0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c,
-		0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c, 0x7c7c,
-		0x7c7c, 0x7c7c, 0xff7c,
-	},
-	{
-		0xdbff, 0x4300, 0x1000, 0x0c0b, 0x0c0e, 0x100a, 0x0d0e, 0x120e,
-		0x1011, 0x1813, 0x1a28, 0x1618, 0x1816, 0x2331, 0x1d25, 0x3a28,
-		0x3d33, 0x393c, 0x3833, 0x4037, 0x5c48, 0x404e, 0x5744, 0x3745,
-		0x5038, 0x516d, 0x5f57, 0x6762, 0x6768, 0x4d3e, 0x7971, 0x6470,
-		0x5c78, 0x6765, 0xff63,
-		0xdbff, 0x4300, 0x1101, 0x1212, 0x1518, 0x2f18, 0x1a1a, 0x632f,
-		0x3842, 0x6342, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363,
-		0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363,
-		0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363,
-		0x6363, 0x6363, 0xff63,
-	},
-	{
-		0xdbff, 0x4300, 0x0d00, 0x0a09, 0x0a0b, 0x0d08, 0x0a0b, 0x0e0b,
-		0x0d0e, 0x130f, 0x1520, 0x1213, 0x1312, 0x1c27, 0x171e, 0x2e20,
-		0x3129, 0x2e30, 0x2d29, 0x332c, 0x4a3a, 0x333e, 0x4636, 0x2c37,
-		0x402d, 0x4157, 0x4c46, 0x524e, 0x5253, 0x3e32, 0x615a, 0x505a,
-		0x4a60, 0x5251, 0xff4f,
-		0xdbff, 0x4300, 0x0e01, 0x0e0e, 0x1113, 0x2613, 0x1515, 0x4f26,
-		0x2d35, 0x4f35, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f,
-		0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f,
-		0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f, 0x4f4f,
-		0x4f4f, 0x4f4f, 0xff4f,
-	},
-	{
-		0xdbff, 0x4300, 0x0a00, 0x0707, 0x0708, 0x0a06, 0x0808, 0x0b08,
-		0x0a0a, 0x0e0b, 0x1018, 0x0d0e, 0x0e0d, 0x151d, 0x1116, 0x2318,
-		0x251f, 0x2224, 0x221f, 0x2621, 0x372b, 0x262f, 0x3429, 0x2129,
-		0x3022, 0x3141, 0x3934, 0x3e3b, 0x3e3e, 0x2e25, 0x4944, 0x3c43,
-		0x3748, 0x3e3d, 0xff3b,
-		0xdbff, 0x4300, 0x0a01, 0x0b0b, 0x0d0e, 0x1c0e, 0x1010, 0x3b1c,
-		0x2228, 0x3b28, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b,
-		0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b,
-		0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b, 0x3b3b,
-		0x3b3b, 0x3b3b, 0xff3b,
-	},
-	{
-		0xdbff, 0x4300, 0x0600, 0x0504, 0x0506, 0x0604, 0x0506, 0x0706,
-		0x0607, 0x0a08, 0x0a10, 0x090a, 0x0a09, 0x0e14, 0x0c0f, 0x1710,
-		0x1814, 0x1718, 0x1614, 0x1a16, 0x251d, 0x1a1f, 0x231b, 0x161c,
-		0x2016, 0x202c, 0x2623, 0x2927, 0x292a, 0x1f19, 0x302d, 0x282d,
-		0x2530, 0x2928, 0xff28,
-		0xdbff, 0x4300, 0x0701, 0x0707, 0x080a, 0x130a, 0x0a0a, 0x2813,
-		0x161a, 0x281a, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828,
-		0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828,
-		0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828, 0x2828,
-		0x2828, 0x2828, 0xff28,
-	},
-	{
-		0xdbff, 0x4300, 0x0300, 0x0202, 0x0203, 0x0302, 0x0303, 0x0403,
-		0x0303, 0x0504, 0x0508, 0x0405, 0x0504, 0x070a, 0x0607, 0x0c08,
-		0x0c0a, 0x0b0c, 0x0b0a, 0x0d0b, 0x120e, 0x0d10, 0x110e, 0x0b0e,
-		0x100b, 0x1016, 0x1311, 0x1514, 0x1515, 0x0f0c, 0x1817, 0x1416,
-		0x1218, 0x1514, 0xff14,
-		0xdbff, 0x4300, 0x0301, 0x0404, 0x0405, 0x0905, 0x0505, 0x1409,
-		0x0b0d, 0x140d, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414,
-		0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414,
-		0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414, 0x1414,
-		0x1414, 0x1414, 0xff14,
-	},
-	{
-		0xdbff, 0x4300, 0x0100, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0101, 0x0101, 0xff01,
-		0xdbff, 0x4300, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0101, 0x0101, 0xff01,
-	} };
-
-	if (quality < 0 || quality > 10) {
-		printk(KERN_WARNING
-		       "meye: invalid quality level %d - using 8\n", quality);
-		quality = 8;
-	}
-
-	*length = ARRAY_SIZE(jpeg_tables[quality]);
-	return jpeg_tables[quality];
-}
-
-/* return a generic set of huffman tables */
-static u16 *jpeg_huffman_tables(int *length)
-{
-	static u16 tables[] = {
-		0xC4FF, 0xB500, 0x0010, 0x0102, 0x0303, 0x0402, 0x0503, 0x0405,
-		0x0004, 0x0100, 0x017D, 0x0302, 0x0400, 0x0511, 0x2112, 0x4131,
-		0x1306, 0x6151, 0x2207, 0x1471, 0x8132, 0xA191, 0x2308, 0xB142,
-		0x15C1, 0xD152, 0x24F0, 0x6233, 0x8272, 0x0A09, 0x1716, 0x1918,
-		0x251A, 0x2726, 0x2928, 0x342A, 0x3635, 0x3837, 0x3A39, 0x4443,
-		0x4645, 0x4847, 0x4A49, 0x5453, 0x5655, 0x5857, 0x5A59, 0x6463,
-		0x6665, 0x6867, 0x6A69, 0x7473, 0x7675, 0x7877, 0x7A79, 0x8483,
-		0x8685, 0x8887, 0x8A89, 0x9392, 0x9594, 0x9796, 0x9998, 0xA29A,
-		0xA4A3, 0xA6A5, 0xA8A7, 0xAAA9, 0xB3B2, 0xB5B4, 0xB7B6, 0xB9B8,
-		0xC2BA, 0xC4C3, 0xC6C5, 0xC8C7, 0xCAC9, 0xD3D2, 0xD5D4, 0xD7D6,
-		0xD9D8, 0xE1DA, 0xE3E2, 0xE5E4, 0xE7E6, 0xE9E8, 0xF1EA, 0xF3F2,
-		0xF5F4, 0xF7F6, 0xF9F8, 0xFFFA,
-		0xC4FF, 0xB500, 0x0011, 0x0102, 0x0402, 0x0304, 0x0704, 0x0405,
-		0x0004, 0x0201, 0x0077, 0x0201, 0x1103, 0x0504, 0x3121, 0x1206,
-		0x5141, 0x6107, 0x1371, 0x3222, 0x0881, 0x4214, 0xA191, 0xC1B1,
-		0x2309, 0x5233, 0x15F0, 0x7262, 0x0AD1, 0x2416, 0xE134, 0xF125,
-		0x1817, 0x1A19, 0x2726, 0x2928, 0x352A, 0x3736, 0x3938, 0x433A,
-		0x4544, 0x4746, 0x4948, 0x534A, 0x5554, 0x5756, 0x5958, 0x635A,
-		0x6564, 0x6766, 0x6968, 0x736A, 0x7574, 0x7776, 0x7978, 0x827A,
-		0x8483, 0x8685, 0x8887, 0x8A89, 0x9392, 0x9594, 0x9796, 0x9998,
-		0xA29A, 0xA4A3, 0xA6A5, 0xA8A7, 0xAAA9, 0xB3B2, 0xB5B4, 0xB7B6,
-		0xB9B8, 0xC2BA, 0xC4C3, 0xC6C5, 0xC8C7, 0xCAC9, 0xD3D2, 0xD5D4,
-		0xD7D6, 0xD9D8, 0xE2DA, 0xE4E3, 0xE6E5, 0xE8E7, 0xEAE9, 0xF3F2,
-		0xF5F4, 0xF7F6, 0xF9F8, 0xFFFA,
-		0xC4FF, 0x1F00, 0x0000, 0x0501, 0x0101, 0x0101, 0x0101, 0x0000,
-		0x0000, 0x0000, 0x0000, 0x0201, 0x0403, 0x0605, 0x0807, 0x0A09,
-		0xFF0B,
-		0xC4FF, 0x1F00, 0x0001, 0x0103, 0x0101, 0x0101, 0x0101, 0x0101,
-		0x0000, 0x0000, 0x0000, 0x0201, 0x0403, 0x0605, 0x0807, 0x0A09,
-		0xFF0B
-	};
-
-	*length = ARRAY_SIZE(tables);
-	return tables;
-}
-
-/****************************************************************************/
-/* MCHIP low-level functions                                                */
-/****************************************************************************/
-
-/* returns the horizontal capture size */
-static inline int mchip_hsize(void)
-{
-	return meye.params.subsample ? 320 : 640;
-}
-
-/* returns the vertical capture size */
-static inline int mchip_vsize(void)
-{
-	return meye.params.subsample ? 240 : 480;
-}
-
-/* waits for a register to be available */
-static void mchip_sync(int reg)
-{
-	u32 status;
-	int i;
-
-	if (reg == MCHIP_MM_FIFO_DATA) {
-		for (i = 0; i < MCHIP_REG_TIMEOUT; i++) {
-			status = readl(meye.mchip_mmregs +
-				       MCHIP_MM_FIFO_STATUS);
-			if (!(status & MCHIP_MM_FIFO_WAIT)) {
-				printk(KERN_WARNING "meye: fifo not ready\n");
-				return;
-			}
-			if (status & MCHIP_MM_FIFO_READY)
-				return;
-			udelay(1);
-		}
-	} else if (reg > 0x80) {
-		u32 mask = (reg < 0x100) ? MCHIP_HIC_STATUS_MCC_RDY
-					 : MCHIP_HIC_STATUS_VRJ_RDY;
-		for (i = 0; i < MCHIP_REG_TIMEOUT; i++) {
-			status = readl(meye.mchip_mmregs + MCHIP_HIC_STATUS);
-			if (status & mask)
-				return;
-			udelay(1);
-		}
-	} else
-		return;
-	printk(KERN_WARNING
-	       "meye: mchip_sync() timeout on reg 0x%x status=0x%x\n",
-	       reg, status);
-}
-
-/* sets a value into the register */
-static inline void mchip_set(int reg, u32 v)
-{
-	mchip_sync(reg);
-	writel(v, meye.mchip_mmregs + reg);
-}
-
-/* get the register value */
-static inline u32 mchip_read(int reg)
-{
-	mchip_sync(reg);
-	return readl(meye.mchip_mmregs + reg);
-}
-
-/* wait for a register to become a particular value */
-static inline int mchip_delay(u32 reg, u32 v)
-{
-	int n = 10;
-	while (--n && mchip_read(reg) != v)
-		udelay(1);
-	return n;
-}
-
-/* setup subsampling */
-static void mchip_subsample(void)
-{
-	mchip_set(MCHIP_MCC_R_SAMPLING, meye.params.subsample);
-	mchip_set(MCHIP_MCC_R_XRANGE, mchip_hsize());
-	mchip_set(MCHIP_MCC_R_YRANGE, mchip_vsize());
-	mchip_set(MCHIP_MCC_B_XRANGE, mchip_hsize());
-	mchip_set(MCHIP_MCC_B_YRANGE, mchip_vsize());
-	mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE);
-}
-
-/* set the framerate into the mchip */
-static void mchip_set_framerate(void)
-{
-	mchip_set(MCHIP_HIC_S_RATE, meye.params.framerate);
-}
-
-/* load some huffman and quantisation tables into the VRJ chip ready
-   for JPEG compression */
-static void mchip_load_tables(void)
-{
-	int i;
-	int length;
-	u16 *tables;
-
-	tables = jpeg_huffman_tables(&length);
-	for (i = 0; i < length; i++)
-		writel(tables[i], meye.mchip_mmregs + MCHIP_VRJ_TABLE_DATA);
-
-	tables = jpeg_quantisation_tables(&length, meye.params.quality);
-	for (i = 0; i < length; i++)
-		writel(tables[i], meye.mchip_mmregs + MCHIP_VRJ_TABLE_DATA);
-}
-
-/* setup the VRJ parameters in the chip */
-static void mchip_vrj_setup(u8 mode)
-{
-	mchip_set(MCHIP_VRJ_BUS_MODE, 5);
-	mchip_set(MCHIP_VRJ_SIGNAL_ACTIVE_LEVEL, 0x1f);
-	mchip_set(MCHIP_VRJ_PDAT_USE, 1);
-	mchip_set(MCHIP_VRJ_IRQ_FLAG, 0xa0);
-	mchip_set(MCHIP_VRJ_MODE_SPECIFY, mode);
-	mchip_set(MCHIP_VRJ_NUM_LINES, mchip_vsize());
-	mchip_set(MCHIP_VRJ_NUM_PIXELS, mchip_hsize());
-	mchip_set(MCHIP_VRJ_NUM_COMPONENTS, 0x1b);
-	mchip_set(MCHIP_VRJ_LIMIT_COMPRESSED_LO, 0xFFFF);
-	mchip_set(MCHIP_VRJ_LIMIT_COMPRESSED_HI, 0xFFFF);
-	mchip_set(MCHIP_VRJ_COMP_DATA_FORMAT, 0xC);
-	mchip_set(MCHIP_VRJ_RESTART_INTERVAL, 0);
-	mchip_set(MCHIP_VRJ_SOF1, 0x601);
-	mchip_set(MCHIP_VRJ_SOF2, 0x1502);
-	mchip_set(MCHIP_VRJ_SOF3, 0x1503);
-	mchip_set(MCHIP_VRJ_SOF4, 0x1596);
-	mchip_set(MCHIP_VRJ_SOS, 0x0ed0);
-
-	mchip_load_tables();
-}
-
-/* sets the DMA parameters into the chip */
-static void mchip_dma_setup(dma_addr_t dma_addr)
-{
-	int i;
-
-	mchip_set(MCHIP_MM_PT_ADDR, (u32)dma_addr);
-	for (i = 0; i < 4; i++)
-		mchip_set(MCHIP_MM_FIR(i), 0);
-	meye.mchip_fnum = 0;
-}
-
-/* setup for DMA transfers - also zeros the framebuffer */
-static int mchip_dma_alloc(void)
-{
-	if (!meye.mchip_dmahandle)
-		if (ptable_alloc())
-			return -1;
-	return 0;
-}
-
-/* frees the DMA buffer */
-static void mchip_dma_free(void)
-{
-	if (meye.mchip_dmahandle) {
-		mchip_dma_setup(0);
-		ptable_free();
-	}
-}
-
-/* stop any existing HIC action and wait for any dma to complete then
-   reset the dma engine */
-static void mchip_hic_stop(void)
-{
-	int i, j;
-
-	meye.mchip_mode = MCHIP_HIC_MODE_NOOP;
-	if (!(mchip_read(MCHIP_HIC_STATUS) & MCHIP_HIC_STATUS_BUSY))
-		return;
-	for (i = 0; i < 20; ++i) {
-		mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_STOP);
-		mchip_delay(MCHIP_HIC_CMD, 0);
-		for (j = 0; j < 100; ++j) {
-			if (mchip_delay(MCHIP_HIC_STATUS,
-					MCHIP_HIC_STATUS_IDLE))
-				return;
-			msleep(1);
-		}
-		printk(KERN_ERR "meye: need to reset HIC!\n");
-
-		mchip_set(MCHIP_HIC_CTL, MCHIP_HIC_CTL_SOFT_RESET);
-		msleep(250);
-	}
-	printk(KERN_ERR "meye: resetting HIC hanged!\n");
-}
-
-/****************************************************************************/
-/* MCHIP frame processing functions                                         */
-/****************************************************************************/
-
-/* get the next ready frame from the dma engine */
-static u32 mchip_get_frame(void)
-{
-	u32 v;
-
-	v = mchip_read(MCHIP_MM_FIR(meye.mchip_fnum));
-	return v;
-}
-
-/* frees the current frame from the dma engine */
-static void mchip_free_frame(void)
-{
-	mchip_set(MCHIP_MM_FIR(meye.mchip_fnum), 0);
-	meye.mchip_fnum++;
-	meye.mchip_fnum %= 4;
-}
-
-/* read one frame from the framebuffer assuming it was captured using
-   a uncompressed transfer */
-static void mchip_cont_read_frame(u32 v, u8 *buf, int size)
-{
-	int pt_id;
-
-	pt_id = (v >> 17) & 0x3FF;
-
-	ptable_copy(buf, pt_id, size, MCHIP_NB_PAGES);
-}
-
-/* read a compressed frame from the framebuffer */
-static int mchip_comp_read_frame(u32 v, u8 *buf, int size)
-{
-	int pt_start, pt_end, trailer;
-	int fsize;
-	int i;
-
-	pt_start = (v >> 19) & 0xFF;
-	pt_end = (v >> 11) & 0xFF;
-	trailer = (v >> 1) & 0x3FF;
-
-	if (pt_end < pt_start)
-		fsize = (MCHIP_NB_PAGES_MJPEG - pt_start) * PAGE_SIZE +
-			pt_end * PAGE_SIZE + trailer * 4;
-	else
-		fsize = (pt_end - pt_start) * PAGE_SIZE + trailer * 4;
-
-	if (fsize > size) {
-		printk(KERN_WARNING "meye: oversized compressed frame %d\n",
-		       fsize);
-		return -1;
-	}
-
-	ptable_copy(buf, pt_start, fsize, MCHIP_NB_PAGES_MJPEG);
-
-#ifdef MEYE_JPEG_CORRECTION
-
-	/* Some mchip generated jpeg frames are incorrect. In most
-	 * (all ?) of those cases, the final EOI (0xff 0xd9) marker
-	 * is not present at the end of the frame.
-	 *
-	 * Since adding the final marker is not enough to restore
-	 * the jpeg integrity, we drop the frame.
-	 */
-
-	for (i = fsize - 1; i > 0 && buf[i] == 0xff; i--) ;
-
-	if (i < 2 || buf[i - 1] != 0xff || buf[i] != 0xd9)
-		return -1;
-
-#endif
-
-	return fsize;
-}
-
-/* take a picture into SDRAM */
-static void mchip_take_picture(void)
-{
-	int i;
-
-	mchip_hic_stop();
-	mchip_subsample();
-	mchip_dma_setup(meye.mchip_dmahandle);
-
-	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_STILL_CAP);
-	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
-
-	mchip_delay(MCHIP_HIC_CMD, 0);
-
-	for (i = 0; i < 100; ++i) {
-		if (mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE))
-			break;
-		msleep(1);
-	}
-}
-
-/* dma a previously taken picture into a buffer */
-static void mchip_get_picture(u8 *buf, int bufsize)
-{
-	u32 v;
-	int i;
-
-	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_STILL_OUT);
-	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
-
-	mchip_delay(MCHIP_HIC_CMD, 0);
-	for (i = 0; i < 100; ++i) {
-		if (mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE))
-			break;
-		msleep(1);
-	}
-	for (i = 0; i < 4; ++i) {
-		v = mchip_get_frame();
-		if (v & MCHIP_MM_FIR_RDY) {
-			mchip_cont_read_frame(v, buf, bufsize);
-			break;
-		}
-		mchip_free_frame();
-	}
-}
-
-/* start continuous dma capture */
-static void mchip_continuous_start(void)
-{
-	mchip_hic_stop();
-	mchip_subsample();
-	mchip_set_framerate();
-	mchip_dma_setup(meye.mchip_dmahandle);
-
-	meye.mchip_mode = MCHIP_HIC_MODE_CONT_OUT;
-
-	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_CONT_OUT);
-	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
-
-	mchip_delay(MCHIP_HIC_CMD, 0);
-}
-
-/* compress one frame into a buffer */
-static int mchip_compress_frame(u8 *buf, int bufsize)
-{
-	u32 v;
-	int len = -1, i;
-
-	mchip_vrj_setup(0x3f);
-	udelay(50);
-
-	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_STILL_COMP);
-	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
-
-	mchip_delay(MCHIP_HIC_CMD, 0);
-	for (i = 0; i < 100; ++i) {
-		if (mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE))
-			break;
-		msleep(1);
-	}
-
-	for (i = 0; i < 4; ++i) {
-		v = mchip_get_frame();
-		if (v & MCHIP_MM_FIR_RDY) {
-			len = mchip_comp_read_frame(v, buf, bufsize);
-			break;
-		}
-		mchip_free_frame();
-	}
-	return len;
-}
-
-#if 0
-/* uncompress one image into a buffer */
-static int mchip_uncompress_frame(u8 *img, int imgsize, u8 *buf, int bufsize)
-{
-	mchip_vrj_setup(0x3f);
-	udelay(50);
-
-	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_STILL_DECOMP);
-	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
-
-	mchip_delay(MCHIP_HIC_CMD, 0);
-
-	return mchip_comp_read_frame(buf, bufsize);
-}
-#endif
-
-/* start continuous compressed capture */
-static void mchip_cont_compression_start(void)
-{
-	mchip_hic_stop();
-	mchip_vrj_setup(0x3f);
-	mchip_subsample();
-	mchip_set_framerate();
-	mchip_dma_setup(meye.mchip_dmahandle);
-
-	meye.mchip_mode = MCHIP_HIC_MODE_CONT_COMP;
-
-	mchip_set(MCHIP_HIC_MODE, MCHIP_HIC_MODE_CONT_COMP);
-	mchip_set(MCHIP_HIC_CMD, MCHIP_HIC_CMD_START);
-
-	mchip_delay(MCHIP_HIC_CMD, 0);
-}
-
-/****************************************************************************/
-/* Interrupt handling                                                       */
-/****************************************************************************/
-
-static irqreturn_t meye_irq(int irq, void *dev_id)
-{
-	u32 v;
-	int reqnr;
-	static int sequence;
-
-	v = mchip_read(MCHIP_MM_INTA);
-
-	if (meye.mchip_mode != MCHIP_HIC_MODE_CONT_OUT &&
-	    meye.mchip_mode != MCHIP_HIC_MODE_CONT_COMP)
-		return IRQ_NONE;
-
-again:
-	v = mchip_get_frame();
-	if (!(v & MCHIP_MM_FIR_RDY))
-		return IRQ_HANDLED;
-
-	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
-		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
-			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
-			mchip_free_frame();
-			return IRQ_HANDLED;
-		}
-		mchip_cont_read_frame(v, meye.grab_fbuffer + gbufsize * reqnr,
-				      mchip_hsize() * mchip_vsize() * 2);
-		meye.grab_buffer[reqnr].size = mchip_hsize() * mchip_vsize() * 2;
-		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
-		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
-		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
-				sizeof(int), &meye.doneq_lock);
-		wake_up_interruptible(&meye.proc_list);
-	} else {
-		int size;
-		size = mchip_comp_read_frame(v, meye.grab_temp, gbufsize);
-		if (size == -1) {
-			mchip_free_frame();
-			goto again;
-		}
-		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
-			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
-			mchip_free_frame();
-			goto again;
-		}
-		memcpy(meye.grab_fbuffer + gbufsize * reqnr, meye.grab_temp,
-		       size);
-		meye.grab_buffer[reqnr].size = size;
-		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
-		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
-		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
-				sizeof(int), &meye.doneq_lock);
-		wake_up_interruptible(&meye.proc_list);
-	}
-	mchip_free_frame();
-	goto again;
-}
-
-/****************************************************************************/
-/* video4linux integration                                                  */
-/****************************************************************************/
-
-static int meye_open(struct file *file)
-{
-	int i;
-
-	if (test_and_set_bit(0, &meye.in_use))
-		return -EBUSY;
-
-	mchip_hic_stop();
-
-	if (mchip_dma_alloc()) {
-		printk(KERN_ERR "meye: mchip framebuffer allocation failed\n");
-		clear_bit(0, &meye.in_use);
-		return -ENOBUFS;
-	}
-
-	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
-		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
-	kfifo_reset(&meye.grabq);
-	kfifo_reset(&meye.doneq);
-	return 0;
-}
-
-static int meye_release(struct file *file)
-{
-	mchip_hic_stop();
-	mchip_dma_free();
-	clear_bit(0, &meye.in_use);
-	return 0;
-}
-
-static int meyeioc_g_params(struct meye_params *p)
-{
-	*p = meye.params;
-	return 0;
-}
-
-static int meyeioc_s_params(struct meye_params *jp)
-{
-	if (jp->subsample > 1)
-		return -EINVAL;
-
-	if (jp->quality > 10)
-		return -EINVAL;
-
-	if (jp->sharpness > 63 || jp->agc > 63 || jp->picture > 63)
-		return -EINVAL;
-
-	if (jp->framerate > 31)
-		return -EINVAL;
-
-	mutex_lock(&meye.lock);
-
-	if (meye.params.subsample != jp->subsample ||
-	    meye.params.quality != jp->quality)
-		mchip_hic_stop();	/* need restart */
-
-	meye.params = *jp;
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERASHARPNESS,
-			      meye.params.sharpness);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAAGC,
-			      meye.params.agc);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAPICTURE,
-			      meye.params.picture);
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int meyeioc_qbuf_capt(int *nb)
-{
-	if (!meye.grab_fbuffer)
-		return -EINVAL;
-
-	if (*nb >= gbuffers)
-		return -EINVAL;
-
-	if (*nb < 0) {
-		/* stop capture */
-		mchip_hic_stop();
-		return 0;
-	}
-
-	if (meye.grab_buffer[*nb].state != MEYE_BUF_UNUSED)
-		return -EBUSY;
-
-	mutex_lock(&meye.lock);
-
-	if (meye.mchip_mode != MCHIP_HIC_MODE_CONT_COMP)
-		mchip_cont_compression_start();
-
-	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
-	kfifo_in_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
-			 &meye.grabq_lock);
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int meyeioc_sync(struct file *file, void *fh, int *i)
-{
-	int unused;
-
-	if (*i < 0 || *i >= gbuffers)
-		return -EINVAL;
-
-	mutex_lock(&meye.lock);
-	switch (meye.grab_buffer[*i].state) {
-
-	case MEYE_BUF_UNUSED:
-		mutex_unlock(&meye.lock);
-		return -EINVAL;
-	case MEYE_BUF_USING:
-		if (file->f_flags & O_NONBLOCK) {
-			mutex_unlock(&meye.lock);
-			return -EAGAIN;
-		}
-		if (wait_event_interruptible(meye.proc_list,
-			(meye.grab_buffer[*i].state != MEYE_BUF_USING))) {
-			mutex_unlock(&meye.lock);
-			return -EINTR;
-		}
-		/* fall through */
-	case MEYE_BUF_DONE:
-		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		if (kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
-				sizeof(int), &meye.doneq_lock) != sizeof(int))
-					break;
-	}
-	*i = meye.grab_buffer[*i].size;
-	mutex_unlock(&meye.lock);
-	return 0;
-}
-
-static int meyeioc_stillcapt(void)
-{
-	if (!meye.grab_fbuffer)
-		return -EINVAL;
-
-	if (meye.grab_buffer[0].state != MEYE_BUF_UNUSED)
-		return -EBUSY;
-
-	mutex_lock(&meye.lock);
-	meye.grab_buffer[0].state = MEYE_BUF_USING;
-	mchip_take_picture();
-
-	mchip_get_picture(meye.grab_fbuffer,
-			mchip_hsize() * mchip_vsize() * 2);
-
-	meye.grab_buffer[0].state = MEYE_BUF_DONE;
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int meyeioc_stilljcapt(int *len)
-{
-	if (!meye.grab_fbuffer)
-		return -EINVAL;
-
-	if (meye.grab_buffer[0].state != MEYE_BUF_UNUSED)
-		return -EBUSY;
-
-	mutex_lock(&meye.lock);
-	meye.grab_buffer[0].state = MEYE_BUF_USING;
-	*len = -1;
-
-	while (*len == -1) {
-		mchip_take_picture();
-		*len = mchip_compress_frame(meye.grab_fbuffer, gbufsize);
-	}
-
-	meye.grab_buffer[0].state = MEYE_BUF_DONE;
-	mutex_unlock(&meye.lock);
-	return 0;
-}
-
-static int vidioc_querycap(struct file *file, void *fh,
-				struct v4l2_capability *cap)
-{
-	strcpy(cap->driver, "meye");
-	strcpy(cap->card, "meye");
-	sprintf(cap->bus_info, "PCI:%s", pci_name(meye.mchip_dev));
-
-	cap->version = (MEYE_DRIVER_MAJORVERSION << 8) +
-		       MEYE_DRIVER_MINORVERSION;
-
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
-			    V4L2_CAP_STREAMING;
-
-	return 0;
-}
-
-static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-
-	strcpy(i->name, "Camera");
-	i->type = V4L2_INPUT_TYPE_CAMERA;
-
-	return 0;
-}
-
-static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
-{
-	if (i != 0)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int vidioc_queryctrl(struct file *file, void *fh,
-				struct v4l2_queryctrl *c)
-{
-	switch (c->id) {
-
-	case V4L2_CID_BRIGHTNESS:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Brightness");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-		c->flags = 0;
-		break;
-	case V4L2_CID_HUE:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Hue");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-		c->flags = 0;
-		break;
-	case V4L2_CID_CONTRAST:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Contrast");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-		c->flags = 0;
-		break;
-	case V4L2_CID_SATURATION:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Saturation");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-		c->flags = 0;
-		break;
-	case V4L2_CID_AGC:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Agc");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 48;
-		c->flags = 0;
-		break;
-	case V4L2_CID_MEYE_SHARPNESS:
-	case V4L2_CID_SHARPNESS:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Sharpness");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 32;
-
-		/* Continue to report legacy private SHARPNESS ctrl but
-		 * say it is disabled in preference to ctrl in the spec
-		 */
-		c->flags = (c->id == V4L2_CID_SHARPNESS) ? 0 :
-						V4L2_CTRL_FLAG_DISABLED;
-		break;
-	case V4L2_CID_PICTURE:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Picture");
-		c->minimum = 0;
-		c->maximum = 63;
-		c->step = 1;
-		c->default_value = 0;
-		c->flags = 0;
-		break;
-	case V4L2_CID_JPEGQUAL:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "JPEG quality");
-		c->minimum = 0;
-		c->maximum = 10;
-		c->step = 1;
-		c->default_value = 8;
-		c->flags = 0;
-		break;
-	case V4L2_CID_FRAMERATE:
-		c->type = V4L2_CTRL_TYPE_INTEGER;
-		strcpy(c->name, "Framerate");
-		c->minimum = 0;
-		c->maximum = 31;
-		c->step = 1;
-		c->default_value = 0;
-		c->flags = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
-{
-	mutex_lock(&meye.lock);
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERABRIGHTNESS, c->value);
-		meye.brightness = c->value << 10;
-		break;
-	case V4L2_CID_HUE:
-		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERAHUE, c->value);
-		meye.hue = c->value << 10;
-		break;
-	case V4L2_CID_CONTRAST:
-		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERACONTRAST, c->value);
-		meye.contrast = c->value << 10;
-		break;
-	case V4L2_CID_SATURATION:
-		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERACOLOR, c->value);
-		meye.colour = c->value << 10;
-		break;
-	case V4L2_CID_AGC:
-		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERAAGC, c->value);
-		meye.params.agc = c->value;
-		break;
-	case V4L2_CID_SHARPNESS:
-	case V4L2_CID_MEYE_SHARPNESS:
-		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERASHARPNESS, c->value);
-		meye.params.sharpness = c->value;
-		break;
-	case V4L2_CID_PICTURE:
-		sony_pic_camera_command(
-			SONY_PIC_COMMAND_SETCAMERAPICTURE, c->value);
-		meye.params.picture = c->value;
-		break;
-	case V4L2_CID_JPEGQUAL:
-		meye.params.quality = c->value;
-		break;
-	case V4L2_CID_FRAMERATE:
-		meye.params.framerate = c->value;
-		break;
-	default:
-		mutex_unlock(&meye.lock);
-		return -EINVAL;
-	}
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *c)
-{
-	mutex_lock(&meye.lock);
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		c->value = meye.brightness >> 10;
-		break;
-	case V4L2_CID_HUE:
-		c->value = meye.hue >> 10;
-		break;
-	case V4L2_CID_CONTRAST:
-		c->value = meye.contrast >> 10;
-		break;
-	case V4L2_CID_SATURATION:
-		c->value = meye.colour >> 10;
-		break;
-	case V4L2_CID_AGC:
-		c->value = meye.params.agc;
-		break;
-	case V4L2_CID_SHARPNESS:
-	case V4L2_CID_MEYE_SHARPNESS:
-		c->value = meye.params.sharpness;
-		break;
-	case V4L2_CID_PICTURE:
-		c->value = meye.params.picture;
-		break;
-	case V4L2_CID_JPEGQUAL:
-		c->value = meye.params.quality;
-		break;
-	case V4L2_CID_FRAMERATE:
-		c->value = meye.params.framerate;
-		break;
-	default:
-		mutex_unlock(&meye.lock);
-		return -EINVAL;
-	}
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh,
-				struct v4l2_fmtdesc *f)
-{
-	if (f->index > 1)
-		return -EINVAL;
-
-	if (f->index == 0) {
-		/* standard YUV 422 capture */
-		f->flags = 0;
-		strcpy(f->description, "YUV422");
-		f->pixelformat = V4L2_PIX_FMT_YUYV;
-	} else {
-		/* compressed MJPEG capture */
-		f->flags = V4L2_FMT_FLAG_COMPRESSED;
-		strcpy(f->description, "MJPEG");
-		f->pixelformat = V4L2_PIX_FMT_MJPEG;
-	}
-
-	return 0;
-}
-
-static int vidioc_try_fmt_vid_cap(struct file *file, void *fh,
-				struct v4l2_format *f)
-{
-	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV &&
-	    f->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG)
-		return -EINVAL;
-
-	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
-	    f->fmt.pix.field != V4L2_FIELD_NONE)
-		return -EINVAL;
-
-	f->fmt.pix.field = V4L2_FIELD_NONE;
-
-	if (f->fmt.pix.width <= 320) {
-		f->fmt.pix.width = 320;
-		f->fmt.pix.height = 240;
-	} else {
-		f->fmt.pix.width = 640;
-		f->fmt.pix.height = 480;
-	}
-
-	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
-	f->fmt.pix.sizeimage = f->fmt.pix.height *
-			       f->fmt.pix.bytesperline;
-	f->fmt.pix.colorspace = 0;
-	f->fmt.pix.priv = 0;
-
-	return 0;
-}
-
-static int vidioc_g_fmt_vid_cap(struct file *file, void *fh,
-				    struct v4l2_format *f)
-{
-	switch (meye.mchip_mode) {
-	case MCHIP_HIC_MODE_CONT_OUT:
-	default:
-		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
-		break;
-	case MCHIP_HIC_MODE_CONT_COMP:
-		f->fmt.pix.pixelformat = V4L2_PIX_FMT_MJPEG;
-		break;
-	}
-
-	f->fmt.pix.field = V4L2_FIELD_NONE;
-	f->fmt.pix.width = mchip_hsize();
-	f->fmt.pix.height = mchip_vsize();
-	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
-	f->fmt.pix.sizeimage = f->fmt.pix.height *
-			       f->fmt.pix.bytesperline;
-
-	return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
-				    struct v4l2_format *f)
-{
-	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV &&
-	    f->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG)
-		return -EINVAL;
-
-	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
-	    f->fmt.pix.field != V4L2_FIELD_NONE)
-		return -EINVAL;
-
-	f->fmt.pix.field = V4L2_FIELD_NONE;
-	mutex_lock(&meye.lock);
-
-	if (f->fmt.pix.width <= 320) {
-		f->fmt.pix.width = 320;
-		f->fmt.pix.height = 240;
-		meye.params.subsample = 1;
-	} else {
-		f->fmt.pix.width = 640;
-		f->fmt.pix.height = 480;
-		meye.params.subsample = 0;
-	}
-
-	switch (f->fmt.pix.pixelformat) {
-	case V4L2_PIX_FMT_YUYV:
-		meye.mchip_mode = MCHIP_HIC_MODE_CONT_OUT;
-		break;
-	case V4L2_PIX_FMT_MJPEG:
-		meye.mchip_mode = MCHIP_HIC_MODE_CONT_COMP;
-		break;
-	}
-
-	mutex_unlock(&meye.lock);
-	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
-	f->fmt.pix.sizeimage = f->fmt.pix.height *
-			       f->fmt.pix.bytesperline;
-	f->fmt.pix.colorspace = 0;
-	f->fmt.pix.priv = 0;
-
-	return 0;
-}
-
-static int vidioc_reqbufs(struct file *file, void *fh,
-				struct v4l2_requestbuffers *req)
-{
-	int i;
-
-	if (req->memory != V4L2_MEMORY_MMAP)
-		return -EINVAL;
-
-	if (meye.grab_fbuffer && req->count == gbuffers) {
-		/* already allocated, no modifications */
-		return 0;
-	}
-
-	mutex_lock(&meye.lock);
-	if (meye.grab_fbuffer) {
-		for (i = 0; i < gbuffers; i++)
-			if (meye.vma_use_count[i]) {
-				mutex_unlock(&meye.lock);
-				return -EINVAL;
-			}
-		rvfree(meye.grab_fbuffer, gbuffers * gbufsize);
-		meye.grab_fbuffer = NULL;
-	}
-
-	gbuffers = max(2, min((int)req->count, MEYE_MAX_BUFNBRS));
-	req->count = gbuffers;
-	meye.grab_fbuffer = rvmalloc(gbuffers * gbufsize);
-
-	if (!meye.grab_fbuffer) {
-		printk(KERN_ERR "meye: v4l framebuffer allocation"
-				" failed\n");
-		mutex_unlock(&meye.lock);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < gbuffers; i++)
-		meye.vma_use_count[i] = 0;
-
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
-{
-	unsigned int index = buf->index;
-
-	if (index >= gbuffers)
-		return -EINVAL;
-
-	buf->bytesused = meye.grab_buffer[index].size;
-	buf->flags = V4L2_BUF_FLAG_MAPPED;
-
-	if (meye.grab_buffer[index].state == MEYE_BUF_USING)
-		buf->flags |= V4L2_BUF_FLAG_QUEUED;
-
-	if (meye.grab_buffer[index].state == MEYE_BUF_DONE)
-		buf->flags |= V4L2_BUF_FLAG_DONE;
-
-	buf->field = V4L2_FIELD_NONE;
-	buf->timestamp = meye.grab_buffer[index].timestamp;
-	buf->sequence = meye.grab_buffer[index].sequence;
-	buf->memory = V4L2_MEMORY_MMAP;
-	buf->m.offset = index * gbufsize;
-	buf->length = gbufsize;
-
-	return 0;
-}
-
-static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
-{
-	if (buf->memory != V4L2_MEMORY_MMAP)
-		return -EINVAL;
-
-	if (buf->index >= gbuffers)
-		return -EINVAL;
-
-	if (meye.grab_buffer[buf->index].state != MEYE_BUF_UNUSED)
-		return -EINVAL;
-
-	mutex_lock(&meye.lock);
-	buf->flags |= V4L2_BUF_FLAG_QUEUED;
-	buf->flags &= ~V4L2_BUF_FLAG_DONE;
-	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
-	kfifo_in_locked(&meye.grabq, (unsigned char *)&buf->index,
-			sizeof(int), &meye.grabq_lock);
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
-{
-	int reqnr;
-
-	if (buf->memory != V4L2_MEMORY_MMAP)
-		return -EINVAL;
-
-	mutex_lock(&meye.lock);
-
-	if (kfifo_len(&meye.doneq) == 0 && file->f_flags & O_NONBLOCK) {
-		mutex_unlock(&meye.lock);
-		return -EAGAIN;
-	}
-
-	if (wait_event_interruptible(meye.proc_list,
-				     kfifo_len(&meye.doneq) != 0) < 0) {
-		mutex_unlock(&meye.lock);
-		return -EINTR;
-	}
-
-	if (!kfifo_out_locked(&meye.doneq, (unsigned char *)&reqnr,
-		       sizeof(int), &meye.doneq_lock)) {
-		mutex_unlock(&meye.lock);
-		return -EBUSY;
-	}
-
-	if (meye.grab_buffer[reqnr].state != MEYE_BUF_DONE) {
-		mutex_unlock(&meye.lock);
-		return -EINVAL;
-	}
-
-	buf->index = reqnr;
-	buf->bytesused = meye.grab_buffer[reqnr].size;
-	buf->flags = V4L2_BUF_FLAG_MAPPED;
-	buf->field = V4L2_FIELD_NONE;
-	buf->timestamp = meye.grab_buffer[reqnr].timestamp;
-	buf->sequence = meye.grab_buffer[reqnr].sequence;
-	buf->memory = V4L2_MEMORY_MMAP;
-	buf->m.offset = reqnr * gbufsize;
-	buf->length = gbufsize;
-	meye.grab_buffer[reqnr].state = MEYE_BUF_UNUSED;
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
-{
-	mutex_lock(&meye.lock);
-
-	switch (meye.mchip_mode) {
-	case MCHIP_HIC_MODE_CONT_OUT:
-		mchip_continuous_start();
-		break;
-	case MCHIP_HIC_MODE_CONT_COMP:
-		mchip_cont_compression_start();
-		break;
-	default:
-		mutex_unlock(&meye.lock);
-		return -EINVAL;
-	}
-
-	mutex_unlock(&meye.lock);
-
-	return 0;
-}
-
-static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
-{
-	mutex_lock(&meye.lock);
-	mchip_hic_stop();
-	kfifo_reset(&meye.grabq);
-	kfifo_reset(&meye.doneq);
-
-	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
-		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
-
-	mutex_unlock(&meye.lock);
-	return 0;
-}
-
-static long vidioc_default(struct file *file, void *fh, bool valid_prio,
-						int cmd, void *arg)
-{
-	switch (cmd) {
-	case MEYEIOC_G_PARAMS:
-		return meyeioc_g_params((struct meye_params *) arg);
-
-	case MEYEIOC_S_PARAMS:
-		return meyeioc_s_params((struct meye_params *) arg);
-
-	case MEYEIOC_QBUF_CAPT:
-		return meyeioc_qbuf_capt((int *) arg);
-
-	case MEYEIOC_SYNC:
-		return meyeioc_sync(file, fh, (int *) arg);
-
-	case MEYEIOC_STILLCAPT:
-		return meyeioc_stillcapt();
-
-	case MEYEIOC_STILLJCAPT:
-		return meyeioc_stilljcapt((int *) arg);
-
-	default:
-		return -ENOTTY;
-	}
-
-}
-
-static unsigned int meye_poll(struct file *file, poll_table *wait)
-{
-	unsigned int res = 0;
-
-	mutex_lock(&meye.lock);
-	poll_wait(file, &meye.proc_list, wait);
-	if (kfifo_len(&meye.doneq))
-		res = POLLIN | POLLRDNORM;
-	mutex_unlock(&meye.lock);
-	return res;
-}
-
-static void meye_vm_open(struct vm_area_struct *vma)
-{
-	long idx = (long)vma->vm_private_data;
-	meye.vma_use_count[idx]++;
-}
-
-static void meye_vm_close(struct vm_area_struct *vma)
-{
-	long idx = (long)vma->vm_private_data;
-	meye.vma_use_count[idx]--;
-}
-
-static const struct vm_operations_struct meye_vm_ops = {
-	.open		= meye_vm_open,
-	.close		= meye_vm_close,
-};
-
-static int meye_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	unsigned long start = vma->vm_start;
-	unsigned long size = vma->vm_end - vma->vm_start;
-	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned long page, pos;
-
-	mutex_lock(&meye.lock);
-	if (size > gbuffers * gbufsize) {
-		mutex_unlock(&meye.lock);
-		return -EINVAL;
-	}
-	if (!meye.grab_fbuffer) {
-		int i;
-
-		/* lazy allocation */
-		meye.grab_fbuffer = rvmalloc(gbuffers*gbufsize);
-		if (!meye.grab_fbuffer) {
-			printk(KERN_ERR "meye: v4l framebuffer allocation failed\n");
-			mutex_unlock(&meye.lock);
-			return -ENOMEM;
-		}
-		for (i = 0; i < gbuffers; i++)
-			meye.vma_use_count[i] = 0;
-	}
-	pos = (unsigned long)meye.grab_fbuffer + offset;
-
-	while (size > 0) {
-		page = vmalloc_to_pfn((void *)pos);
-		if (remap_pfn_range(vma, start, page, PAGE_SIZE, PAGE_SHARED)) {
-			mutex_unlock(&meye.lock);
-			return -EAGAIN;
-		}
-		start += PAGE_SIZE;
-		pos += PAGE_SIZE;
-		if (size > PAGE_SIZE)
-			size -= PAGE_SIZE;
-		else
-			size = 0;
-	}
-
-	vma->vm_ops = &meye_vm_ops;
-	vma->vm_flags &= ~VM_IO;	/* not I/O memory */
-	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
-	vma->vm_private_data = (void *) (offset / gbufsize);
-	meye_vm_open(vma);
-
-	mutex_unlock(&meye.lock);
-	return 0;
-}
-
-static const struct v4l2_file_operations meye_fops = {
-	.owner		= THIS_MODULE,
-	.open		= meye_open,
-	.release	= meye_release,
-	.mmap		= meye_mmap,
-	.unlocked_ioctl	= video_ioctl2,
-	.poll		= meye_poll,
-};
-
-static const struct v4l2_ioctl_ops meye_ioctl_ops = {
-	.vidioc_querycap	= vidioc_querycap,
-	.vidioc_enum_input	= vidioc_enum_input,
-	.vidioc_g_input		= vidioc_g_input,
-	.vidioc_s_input		= vidioc_s_input,
-	.vidioc_queryctrl	= vidioc_queryctrl,
-	.vidioc_s_ctrl		= vidioc_s_ctrl,
-	.vidioc_g_ctrl		= vidioc_g_ctrl,
-	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
-	.vidioc_reqbufs		= vidioc_reqbufs,
-	.vidioc_querybuf	= vidioc_querybuf,
-	.vidioc_qbuf		= vidioc_qbuf,
-	.vidioc_dqbuf		= vidioc_dqbuf,
-	.vidioc_streamon	= vidioc_streamon,
-	.vidioc_streamoff	= vidioc_streamoff,
-	.vidioc_default		= vidioc_default,
-};
-
-static struct video_device meye_template = {
-	.name		= "meye",
-	.fops		= &meye_fops,
-	.ioctl_ops 	= &meye_ioctl_ops,
-	.release	= video_device_release,
-};
-
-#ifdef CONFIG_PM
-static int meye_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	pci_save_state(pdev);
-	meye.pm_mchip_mode = meye.mchip_mode;
-	mchip_hic_stop();
-	mchip_set(MCHIP_MM_INTA, 0x0);
-	return 0;
-}
-
-static int meye_resume(struct pci_dev *pdev)
-{
-	pci_restore_state(pdev);
-	pci_write_config_word(meye.mchip_dev, MCHIP_PCI_SOFTRESET_SET, 1);
-
-	mchip_delay(MCHIP_HIC_CMD, 0);
-	mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE);
-	msleep(1);
-	mchip_set(MCHIP_VRJ_SOFT_RESET, 1);
-	msleep(1);
-	mchip_set(MCHIP_MM_PCI_MODE, 5);
-	msleep(1);
-	mchip_set(MCHIP_MM_INTA, MCHIP_MM_INTA_HIC_1_MASK);
-
-	switch (meye.pm_mchip_mode) {
-	case MCHIP_HIC_MODE_CONT_OUT:
-		mchip_continuous_start();
-		break;
-	case MCHIP_HIC_MODE_CONT_COMP:
-		mchip_cont_compression_start();
-		break;
-	}
-	return 0;
-}
-#endif
-
-static int __devinit meye_probe(struct pci_dev *pcidev,
-				const struct pci_device_id *ent)
-{
-	struct v4l2_device *v4l2_dev = &meye.v4l2_dev;
-	int ret = -EBUSY;
-	unsigned long mchip_adr;
-
-	if (meye.mchip_dev != NULL) {
-		printk(KERN_ERR "meye: only one device allowed!\n");
-		goto outnotdev;
-	}
-
-	ret = v4l2_device_register(&pcidev->dev, v4l2_dev);
-	if (ret < 0) {
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		return ret;
-	}
-	ret = -ENOMEM;
-	meye.mchip_dev = pcidev;
-	meye.vdev = video_device_alloc();
-	if (!meye.vdev) {
-		v4l2_err(v4l2_dev, "video_device_alloc() failed!\n");
-		goto outnotdev;
-	}
-
-	meye.grab_temp = vmalloc(MCHIP_NB_PAGES_MJPEG * PAGE_SIZE);
-	if (!meye.grab_temp) {
-		v4l2_err(v4l2_dev, "grab buffer allocation failed\n");
-		goto outvmalloc;
-	}
-
-	spin_lock_init(&meye.grabq_lock);
-	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS,
-				GFP_KERNEL)) {
-		v4l2_err(v4l2_dev, "fifo allocation failed\n");
-		goto outkfifoalloc1;
-	}
-	spin_lock_init(&meye.doneq_lock);
-	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS,
-				GFP_KERNEL)) {
-		v4l2_err(v4l2_dev, "fifo allocation failed\n");
-		goto outkfifoalloc2;
-	}
-
-	memcpy(meye.vdev, &meye_template, sizeof(meye_template));
-	meye.vdev->v4l2_dev = &meye.v4l2_dev;
-
-	ret = -EIO;
-	if ((ret = sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 1))) {
-		v4l2_err(v4l2_dev, "meye: unable to power on the camera\n");
-		v4l2_err(v4l2_dev, "meye: did you enable the camera in "
-				"sonypi using the module options ?\n");
-		goto outsonypienable;
-	}
-
-	if ((ret = pci_enable_device(meye.mchip_dev))) {
-		v4l2_err(v4l2_dev, "meye: pci_enable_device failed\n");
-		goto outenabledev;
-	}
-
-	mchip_adr = pci_resource_start(meye.mchip_dev,0);
-	if (!mchip_adr) {
-		v4l2_err(v4l2_dev, "meye: mchip has no device base address\n");
-		goto outregions;
-	}
-	if (!request_mem_region(pci_resource_start(meye.mchip_dev, 0),
-				pci_resource_len(meye.mchip_dev, 0),
-				"meye")) {
-		v4l2_err(v4l2_dev, "meye: request_mem_region failed\n");
-		goto outregions;
-	}
-	meye.mchip_mmregs = ioremap(mchip_adr, MCHIP_MM_REGS);
-	if (!meye.mchip_mmregs) {
-		v4l2_err(v4l2_dev, "meye: ioremap failed\n");
-		goto outremap;
-	}
-
-	meye.mchip_irq = pcidev->irq;
-	if (request_irq(meye.mchip_irq, meye_irq,
-			IRQF_DISABLED | IRQF_SHARED, "meye", meye_irq)) {
-		v4l2_err(v4l2_dev, "request_irq failed\n");
-		goto outreqirq;
-	}
-
-	pci_write_config_byte(meye.mchip_dev, PCI_CACHE_LINE_SIZE, 8);
-	pci_write_config_byte(meye.mchip_dev, PCI_LATENCY_TIMER, 64);
-
-	pci_set_master(meye.mchip_dev);
-
-	/* Ask the camera to perform a soft reset. */
-	pci_write_config_word(meye.mchip_dev, MCHIP_PCI_SOFTRESET_SET, 1);
-
-	mchip_delay(MCHIP_HIC_CMD, 0);
-	mchip_delay(MCHIP_HIC_STATUS, MCHIP_HIC_STATUS_IDLE);
-
-	msleep(1);
-	mchip_set(MCHIP_VRJ_SOFT_RESET, 1);
-
-	msleep(1);
-	mchip_set(MCHIP_MM_PCI_MODE, 5);
-
-	msleep(1);
-	mchip_set(MCHIP_MM_INTA, MCHIP_MM_INTA_HIC_1_MASK);
-
-	mutex_init(&meye.lock);
-	init_waitqueue_head(&meye.proc_list);
-	meye.brightness = 32 << 10;
-	meye.hue = 32 << 10;
-	meye.colour = 32 << 10;
-	meye.contrast = 32 << 10;
-	meye.params.subsample = 0;
-	meye.params.quality = 8;
-	meye.params.sharpness = 32;
-	meye.params.agc = 48;
-	meye.params.picture = 0;
-	meye.params.framerate = 0;
-
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERABRIGHTNESS, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAHUE, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERACOLOR, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERACONTRAST, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERASHARPNESS, 32);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAPICTURE, 0);
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERAAGC, 48);
-
-	if (video_register_device(meye.vdev, VFL_TYPE_GRABBER,
-				  video_nr) < 0) {
-		v4l2_err(v4l2_dev, "video_register_device failed\n");
-		goto outvideoreg;
-	}
-
-	v4l2_info(v4l2_dev, "Motion Eye Camera Driver v%s.\n",
-	       MEYE_DRIVER_VERSION);
-	v4l2_info(v4l2_dev, "mchip KL5A72002 rev. %d, base %lx, irq %d\n",
-	       meye.mchip_dev->revision, mchip_adr, meye.mchip_irq);
-
-	return 0;
-
-outvideoreg:
-	free_irq(meye.mchip_irq, meye_irq);
-outreqirq:
-	iounmap(meye.mchip_mmregs);
-outremap:
-	release_mem_region(pci_resource_start(meye.mchip_dev, 0),
-			   pci_resource_len(meye.mchip_dev, 0));
-outregions:
-	pci_disable_device(meye.mchip_dev);
-outenabledev:
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
-outsonypienable:
-	kfifo_free(&meye.doneq);
-outkfifoalloc2:
-	kfifo_free(&meye.grabq);
-outkfifoalloc1:
-	vfree(meye.grab_temp);
-outvmalloc:
-	video_device_release(meye.vdev);
-outnotdev:
-	return ret;
-}
-
-static void __devexit meye_remove(struct pci_dev *pcidev)
-{
-	video_unregister_device(meye.vdev);
-
-	mchip_hic_stop();
-
-	mchip_dma_free();
-
-	/* disable interrupts */
-	mchip_set(MCHIP_MM_INTA, 0x0);
-
-	free_irq(meye.mchip_irq, meye_irq);
-
-	iounmap(meye.mchip_mmregs);
-
-	release_mem_region(pci_resource_start(meye.mchip_dev, 0),
-			   pci_resource_len(meye.mchip_dev, 0));
-
-	pci_disable_device(meye.mchip_dev);
-
-	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
-
-	kfifo_free(&meye.doneq);
-	kfifo_free(&meye.grabq);
-
-	vfree(meye.grab_temp);
-
-	if (meye.grab_fbuffer) {
-		rvfree(meye.grab_fbuffer, gbuffers*gbufsize);
-		meye.grab_fbuffer = NULL;
-	}
-
-	printk(KERN_INFO "meye: removed\n");
-}
-
-static struct pci_device_id meye_pci_tbl[] = {
-	{ PCI_VDEVICE(KAWASAKI, PCI_DEVICE_ID_MCHIP_KL5A72002), 0 },
-	{ }
-};
-
-MODULE_DEVICE_TABLE(pci, meye_pci_tbl);
-
-static struct pci_driver meye_driver = {
-	.name		= "meye",
-	.id_table	= meye_pci_tbl,
-	.probe		= meye_probe,
-	.remove		= __devexit_p(meye_remove),
-#ifdef CONFIG_PM
-	.suspend	= meye_suspend,
-	.resume		= meye_resume,
-#endif
-};
-
-static int __init meye_init(void)
-{
-	gbuffers = max(2, min((int)gbuffers, MEYE_MAX_BUFNBRS));
-	if (gbufsize < 0 || gbufsize > MEYE_MAX_BUFSIZE)
-		gbufsize = MEYE_MAX_BUFSIZE;
-	gbufsize = PAGE_ALIGN(gbufsize);
-	printk(KERN_INFO "meye: using %d buffers with %dk (%dk total) "
-			 "for capture\n",
-			 gbuffers,
-			 gbufsize / 1024, gbuffers * gbufsize / 1024);
-	return pci_register_driver(&meye_driver);
-}
-
-static void __exit meye_exit(void)
-{
-	pci_unregister_driver(&meye_driver);
-}
-
-module_init(meye_init);
-module_exit(meye_exit);
diff --git a/drivers/media/video/meye.h b/drivers/media/video/meye.h
deleted file mode 100644
index 4bdeb03..0000000
--- a/drivers/media/video/meye.h
+++ /dev/null
@@ -1,324 +0,0 @@
-/*
- * Motion Eye video4linux driver for Sony Vaio PictureBook
- *
- * Copyright (C) 2001-2004 Stelian Pop <stelian@popies.net>
- *
- * Copyright (C) 2001-2002 Alcôve <www.alcove.com>
- *
- * Copyright (C) 2000 Andrew Tridgell <tridge@valinux.com>
- *
- * Earlier work by Werner Almesberger, Paul `Rusty' Russell and Paul Mackerras.
- *
- * Some parts borrowed from various video4linux drivers, especially
- * bttv-driver.c and zoran.c, see original files for credits.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef _MEYE_PRIV_H_
-#define _MEYE_PRIV_H_
-
-#define MEYE_DRIVER_MAJORVERSION	 1
-#define MEYE_DRIVER_MINORVERSION	14
-
-#define MEYE_DRIVER_VERSION __stringify(MEYE_DRIVER_MAJORVERSION) "." \
-			    __stringify(MEYE_DRIVER_MINORVERSION)
-
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/kfifo.h>
-
-/****************************************************************************/
-/* Motion JPEG chip registers                                               */
-/****************************************************************************/
-
-/* Motion JPEG chip PCI configuration registers */
-#define MCHIP_PCI_POWER_CSR		0x54
-#define MCHIP_PCI_MCORE_STATUS		0x60		/* see HIC_STATUS   */
-#define MCHIP_PCI_HOSTUSEREQ_SET	0x64
-#define MCHIP_PCI_HOSTUSEREQ_CLR	0x68
-#define MCHIP_PCI_LOWPOWER_SET		0x6c
-#define MCHIP_PCI_LOWPOWER_CLR		0x70
-#define MCHIP_PCI_SOFTRESET_SET		0x74
-
-/* Motion JPEG chip memory mapped registers */
-#define MCHIP_MM_REGS			0x200		/* 512 bytes        */
-#define MCHIP_REG_TIMEOUT		1000		/* reg access, ~us  */
-#define MCHIP_MCC_VRJ_TIMEOUT		1000		/* MCC & VRJ access */
-
-#define MCHIP_MM_PCI_MODE		0x00		/* PCI access mode */
-#define MCHIP_MM_PCI_MODE_RETRY		0x00000001	/* retry mode */
-#define MCHIP_MM_PCI_MODE_MASTER	0x00000002	/* master access */
-#define MCHIP_MM_PCI_MODE_READ_LINE	0x00000004	/* read line */
-
-#define MCHIP_MM_INTA			0x04		/* Int status/mask */
-#define MCHIP_MM_INTA_MCC		0x00000001	/* MCC interrupt */
-#define MCHIP_MM_INTA_VRJ		0x00000002	/* VRJ interrupt */
-#define MCHIP_MM_INTA_HIC_1		0x00000004	/* one frame done */
-#define MCHIP_MM_INTA_HIC_1_MASK	0x00000400	/* 1: enable */
-#define MCHIP_MM_INTA_HIC_END		0x00000008	/* all frames done */
-#define MCHIP_MM_INTA_HIC_END_MASK	0x00000800
-#define MCHIP_MM_INTA_JPEG		0x00000010	/* decompress. error */
-#define MCHIP_MM_INTA_JPEG_MASK		0x00001000
-#define MCHIP_MM_INTA_CAPTURE		0x00000020	/* capture end */
-#define MCHIP_MM_INTA_PCI_ERR		0x00000040	/* PCI error */
-#define MCHIP_MM_INTA_PCI_ERR_MASK	0x00004000
-
-#define MCHIP_MM_PT_ADDR		0x08		/* page table address*/
-							/* n*4kB */
-#define MCHIP_NB_PAGES			1024		/* pages for display */
-#define MCHIP_NB_PAGES_MJPEG		256		/* pages for mjpeg */
-
-#define MCHIP_MM_FIR(n)			(0x0c+(n)*4)	/* Frame info 0-3 */
-#define MCHIP_MM_FIR_RDY		0x00000001	/* frame ready */
-#define MCHIP_MM_FIR_FAILFR_MASK	0xf8000000	/* # of failed frames */
-#define MCHIP_MM_FIR_FAILFR_SHIFT	27
-
-	/* continuous comp/decomp mode */
-#define MCHIP_MM_FIR_C_ENDL_MASK	0x000007fe	/* end DW [10] */
-#define MCHIP_MM_FIR_C_ENDL_SHIFT	1
-#define MCHIP_MM_FIR_C_ENDP_MASK	0x0007f800	/* end page [8] */
-#define MCHIP_MM_FIR_C_ENDP_SHIFT	11
-#define MCHIP_MM_FIR_C_STARTP_MASK	0x07f80000	/* start page [8] */
-#define MCHIP_MM_FIR_C_STARTP_SHIFT	19
-
-	/* continuous picture output mode */
-#define MCHIP_MM_FIR_O_STARTP_MASK	0x7ffe0000	/* start page [10] */
-#define MCHIP_MM_FIR_O_STARTP_SHIFT	17
-
-#define MCHIP_MM_FIFO_DATA		0x1c		/* PCI TGT FIFO data */
-#define MCHIP_MM_FIFO_STATUS		0x20		/* PCI TGT FIFO stat */
-#define MCHIP_MM_FIFO_MASK		0x00000003
-#define MCHIP_MM_FIFO_WAIT_OR_READY	0x00000002      /* Bits common to WAIT & READY*/
-#define MCHIP_MM_FIFO_IDLE		0x0		/* HIC idle */
-#define MCHIP_MM_FIFO_IDLE1		0x1		/* idem ??? */
-#define	MCHIP_MM_FIFO_WAIT		0x2		/* wait request */
-#define MCHIP_MM_FIFO_READY		0x3		/* data ready */
-
-#define MCHIP_HIC_HOST_USEREQ		0x40		/* host uses MCORE */
-
-#define MCHIP_HIC_TP_BUSY		0x44		/* taking picture */
-
-#define MCHIP_HIC_PIC_SAVED		0x48		/* pic in SDRAM */
-
-#define MCHIP_HIC_LOWPOWER		0x4c		/* clock stopped */
-
-#define MCHIP_HIC_CTL			0x50		/* HIC control */
-#define MCHIP_HIC_CTL_SOFT_RESET	0x00000001	/* MCORE reset */
-#define MCHIP_HIC_CTL_MCORE_RDY		0x00000002	/* MCORE ready */
-
-#define MCHIP_HIC_CMD			0x54		/* HIC command */
-#define MCHIP_HIC_CMD_BITS		0x00000003      /* cmd width=[1:0]*/
-#define MCHIP_HIC_CMD_NOOP		0x0
-#define MCHIP_HIC_CMD_START		0x1
-#define MCHIP_HIC_CMD_STOP		0x2
-
-#define MCHIP_HIC_MODE			0x58
-#define MCHIP_HIC_MODE_NOOP		0x0
-#define MCHIP_HIC_MODE_STILL_CAP	0x1		/* still pic capt */
-#define MCHIP_HIC_MODE_DISPLAY		0x2		/* display */
-#define MCHIP_HIC_MODE_STILL_COMP	0x3		/* still pic comp. */
-#define MCHIP_HIC_MODE_STILL_DECOMP	0x4		/* still pic decomp. */
-#define MCHIP_HIC_MODE_CONT_COMP	0x5		/* cont capt+comp */
-#define MCHIP_HIC_MODE_CONT_DECOMP	0x6		/* cont decomp+disp */
-#define MCHIP_HIC_MODE_STILL_OUT	0x7		/* still pic output */
-#define MCHIP_HIC_MODE_CONT_OUT		0x8		/* cont output */
-
-#define MCHIP_HIC_STATUS		0x5c
-#define MCHIP_HIC_STATUS_MCC_RDY	0x00000001	/* MCC reg acc ok */
-#define MCHIP_HIC_STATUS_VRJ_RDY	0x00000002	/* VRJ reg acc ok */
-#define MCHIP_HIC_STATUS_IDLE           0x00000003
-#define MCHIP_HIC_STATUS_CAPDIS		0x00000004	/* cap/disp in prog */
-#define MCHIP_HIC_STATUS_COMPDEC	0x00000008	/* (de)comp in prog */
-#define MCHIP_HIC_STATUS_BUSY		0x00000010	/* HIC busy */
-
-#define MCHIP_HIC_S_RATE		0x60		/* MJPEG # frames */
-
-#define MCHIP_HIC_PCI_VFMT		0x64		/* video format */
-#define MCHIP_HIC_PCI_VFMT_YVYU		0x00000001	/* 0: V Y' U Y */
-							/* 1: Y' V Y U */
-
-#define MCHIP_MCC_CMD			0x80		/* MCC commands */
-#define MCHIP_MCC_CMD_INITIAL		0x0		/* idle ? */
-#define MCHIP_MCC_CMD_IIC_START_SET	0x1
-#define MCHIP_MCC_CMD_IIC_END_SET	0x2
-#define MCHIP_MCC_CMD_FM_WRITE		0x3		/* frame memory */
-#define MCHIP_MCC_CMD_FM_READ		0x4
-#define MCHIP_MCC_CMD_FM_STOP		0x5
-#define MCHIP_MCC_CMD_CAPTURE		0x6
-#define MCHIP_MCC_CMD_DISPLAY		0x7
-#define MCHIP_MCC_CMD_END_DISP		0x8
-#define MCHIP_MCC_CMD_STILL_COMP	0x9
-#define MCHIP_MCC_CMD_STILL_DECOMP	0xa
-#define MCHIP_MCC_CMD_STILL_OUTPUT	0xb
-#define MCHIP_MCC_CMD_CONT_OUTPUT	0xc
-#define MCHIP_MCC_CMD_CONT_COMP		0xd
-#define MCHIP_MCC_CMD_CONT_DECOMP	0xe
-#define MCHIP_MCC_CMD_RESET		0xf		/* MCC reset */
-
-#define MCHIP_MCC_IIC_WR		0x84
-
-#define MCHIP_MCC_MCC_WR		0x88
-
-#define MCHIP_MCC_MCC_RD		0x8c
-
-#define MCHIP_MCC_STATUS		0x90
-#define MCHIP_MCC_STATUS_CAPT		0x00000001	/* capturing */
-#define MCHIP_MCC_STATUS_DISP		0x00000002	/* displaying */
-#define MCHIP_MCC_STATUS_COMP		0x00000004	/* compressing */
-#define MCHIP_MCC_STATUS_DECOMP		0x00000008	/* decompressing */
-#define MCHIP_MCC_STATUS_MCC_WR		0x00000010	/* register ready */
-#define MCHIP_MCC_STATUS_MCC_RD		0x00000020	/* register ready */
-#define MCHIP_MCC_STATUS_IIC_WR		0x00000040	/* register ready */
-#define MCHIP_MCC_STATUS_OUTPUT		0x00000080	/* output in prog */
-
-#define MCHIP_MCC_SIG_POLARITY		0x94
-#define MCHIP_MCC_SIG_POL_VS_H		0x00000001	/* VS active-high */
-#define MCHIP_MCC_SIG_POL_HS_H		0x00000002	/* HS active-high */
-#define MCHIP_MCC_SIG_POL_DOE_H		0x00000004	/* DOE active-high */
-
-#define MCHIP_MCC_IRQ			0x98
-#define MCHIP_MCC_IRQ_CAPDIS_STRT	0x00000001	/* cap/disp started */
-#define MCHIP_MCC_IRQ_CAPDIS_STRT_MASK	0x00000010
-#define MCHIP_MCC_IRQ_CAPDIS_END	0x00000002	/* cap/disp ended */
-#define MCHIP_MCC_IRQ_CAPDIS_END_MASK	0x00000020
-#define MCHIP_MCC_IRQ_COMPDEC_STRT	0x00000004	/* (de)comp started */
-#define MCHIP_MCC_IRQ_COMPDEC_STRT_MASK	0x00000040
-#define MCHIP_MCC_IRQ_COMPDEC_END	0x00000008	/* (de)comp ended */
-#define MCHIP_MCC_IRQ_COMPDEC_END_MASK	0x00000080
-
-#define MCHIP_MCC_HSTART		0x9c		/* video in */
-#define MCHIP_MCC_VSTART		0xa0
-#define MCHIP_MCC_HCOUNT		0xa4
-#define MCHIP_MCC_VCOUNT		0xa8
-#define MCHIP_MCC_R_XBASE		0xac		/* capt/disp */
-#define MCHIP_MCC_R_YBASE		0xb0
-#define MCHIP_MCC_R_XRANGE		0xb4
-#define MCHIP_MCC_R_YRANGE		0xb8
-#define MCHIP_MCC_B_XBASE		0xbc		/* comp/decomp */
-#define MCHIP_MCC_B_YBASE		0xc0
-#define MCHIP_MCC_B_XRANGE		0xc4
-#define MCHIP_MCC_B_YRANGE		0xc8
-
-#define MCHIP_MCC_R_SAMPLING		0xcc		/* 1: 1:4 */
-
-#define MCHIP_VRJ_CMD			0x100		/* VRJ commands */
-
-/* VRJ registers (see table 12.2.4) */
-#define MCHIP_VRJ_COMPRESSED_DATA	0x1b0
-#define MCHIP_VRJ_PIXEL_DATA		0x1b8
-
-#define MCHIP_VRJ_BUS_MODE		0x100
-#define MCHIP_VRJ_SIGNAL_ACTIVE_LEVEL	0x108
-#define MCHIP_VRJ_PDAT_USE		0x110
-#define MCHIP_VRJ_MODE_SPECIFY		0x118
-#define MCHIP_VRJ_LIMIT_COMPRESSED_LO	0x120
-#define MCHIP_VRJ_LIMIT_COMPRESSED_HI	0x124
-#define MCHIP_VRJ_COMP_DATA_FORMAT	0x128
-#define MCHIP_VRJ_TABLE_DATA		0x140
-#define MCHIP_VRJ_RESTART_INTERVAL	0x148
-#define MCHIP_VRJ_NUM_LINES		0x150
-#define MCHIP_VRJ_NUM_PIXELS		0x158
-#define MCHIP_VRJ_NUM_COMPONENTS	0x160
-#define MCHIP_VRJ_SOF1			0x168
-#define MCHIP_VRJ_SOF2			0x170
-#define MCHIP_VRJ_SOF3			0x178
-#define MCHIP_VRJ_SOF4			0x180
-#define MCHIP_VRJ_SOS			0x188
-#define MCHIP_VRJ_SOFT_RESET		0x190
-
-#define MCHIP_VRJ_STATUS		0x1c0
-#define MCHIP_VRJ_STATUS_BUSY		0x00001
-#define MCHIP_VRJ_STATUS_COMP_ACCESS	0x00002
-#define MCHIP_VRJ_STATUS_PIXEL_ACCESS	0x00004
-#define MCHIP_VRJ_STATUS_ERROR		0x00008
-
-#define MCHIP_VRJ_IRQ_FLAG		0x1c8
-#define MCHIP_VRJ_ERROR_REPORT		0x1d8
-
-#define MCHIP_VRJ_START_COMMAND		0x1a0
-
-/****************************************************************************/
-/* Driver definitions.                                                      */
-/****************************************************************************/
-
-/* Sony Programmable I/O Controller for accessing the camera commands */
-#include <linux/sony-laptop.h>
-
-/* private API definitions */
-#include <linux/meye.h>
-#include <linux/mutex.h>
-
-
-/* Enable jpg software correction */
-#define MEYE_JPEG_CORRECTION	1
-
-/* Maximum size of a buffer */
-#define MEYE_MAX_BUFSIZE	614400	/* 640 * 480 * 2 */
-
-/* Maximum number of buffers */
-#define MEYE_MAX_BUFNBRS	32
-
-/* State of a buffer */
-#define MEYE_BUF_UNUSED	0	/* not used */
-#define MEYE_BUF_USING	1	/* currently grabbing / playing */
-#define MEYE_BUF_DONE	2	/* done */
-
-/* grab buffer */
-struct meye_grab_buffer {
-	int state;			/* state of buffer */
-	unsigned long size;		/* size of jpg frame */
-	struct timeval timestamp;	/* timestamp */
-	unsigned long sequence;		/* sequence number */
-};
-
-/* size of kfifos containings buffer indices */
-#define MEYE_QUEUE_SIZE	MEYE_MAX_BUFNBRS
-
-/* Motion Eye device structure */
-struct meye {
-	struct v4l2_device v4l2_dev;	/* Main v4l2_device struct */
-	struct pci_dev *mchip_dev;	/* pci device */
-	u8 mchip_irq;			/* irq */
-	u8 mchip_mode;			/* actual mchip mode: HIC_MODE... */
-	u8 mchip_fnum;			/* current mchip frame number */
-	unsigned char __iomem *mchip_mmregs;/* mchip: memory mapped registers */
-	u8 *mchip_ptable[MCHIP_NB_PAGES];/* mchip: ptable */
-	void *mchip_ptable_toc;		/* mchip: ptable toc */
-	dma_addr_t mchip_dmahandle;	/* mchip: dma handle to ptable toc */
-	unsigned char *grab_fbuffer;	/* capture framebuffer */
-	unsigned char *grab_temp;	/* temporary buffer */
-					/* list of buffers */
-	struct meye_grab_buffer grab_buffer[MEYE_MAX_BUFNBRS];
-	int vma_use_count[MEYE_MAX_BUFNBRS]; /* mmap count */
-	struct mutex lock;		/* mutex for open/mmap... */
-	struct kfifo grabq;		/* queue for buffers to be grabbed */
-	spinlock_t grabq_lock;		/* lock protecting the queue */
-	struct kfifo doneq;		/* queue for grabbed buffers */
-	spinlock_t doneq_lock;		/* lock protecting the queue */
-	wait_queue_head_t proc_list;	/* wait queue */
-	struct video_device *vdev;	/* video device parameters */
-	u16 brightness;
-	u16 hue;
-	u16 contrast;
-	u16 colour;
-	struct meye_params params;	/* additional parameters */
-	unsigned long in_use;		/* set to 1 if the device is in use */
-#ifdef CONFIG_PM
-	u8 pm_mchip_mode;		/* old mchip mode */
-#endif
-};
-
-#endif
diff --git a/drivers/media/video/sta2x11_vip.c b/drivers/media/video/sta2x11_vip.c
deleted file mode 100644
index 4c10205..0000000
--- a/drivers/media/video/sta2x11_vip.c
+++ /dev/null
@@ -1,1550 +0,0 @@
-/*
- * This is the driver for the STA2x11 Video Input Port.
- *
- * Copyright (C) 2010       WindRiver Systems, Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * The full GNU General Public License is included in this distribution in
- * the file called "COPYING".
- *
- * Author: Andreas Kies <andreas.kies@windriver.com>
- *		Vlad Lungu <vlad.lungu@windriver.com>
- *
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/vmalloc.h>
-
-#include <linux/videodev2.h>
-
-#include <linux/kmod.h>
-
-#include <linux/pci.h>
-#include <linux/interrupt.h>
-#include <linux/mutex.h>
-#include <linux/io.h>
-#include <linux/gpio.h>
-#include <linux/i2c.h>
-#include <linux/delay.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
-#include <media/videobuf-dma-contig.h>
-
-#include "sta2x11_vip.h"
-
-#define DRV_NAME "sta2x11_vip"
-#define DRV_VERSION "1.3"
-
-#ifndef PCI_DEVICE_ID_STMICRO_VIP
-#define PCI_DEVICE_ID_STMICRO_VIP 0xCC0D
-#endif
-
-#define MAX_FRAMES 4
-
-/*Register offsets*/
-#define DVP_CTL		0x00
-#define DVP_TFO		0x04
-#define DVP_TFS		0x08
-#define DVP_BFO		0x0C
-#define DVP_BFS		0x10
-#define DVP_VTP         0x14
-#define DVP_VBP         0x18
-#define DVP_VMP		0x1C
-#define DVP_ITM		0x98
-#define DVP_ITS		0x9C
-#define DVP_STA		0xA0
-#define DVP_HLFLN	0xA8
-#define DVP_RGB		0xC0
-#define DVP_PKZ		0xF0
-
-/*Register fields*/
-#define DVP_CTL_ENA	0x00000001
-#define DVP_CTL_RST	0x80000000
-#define DVP_CTL_DIS	(~0x00040001)
-
-#define DVP_IT_VSB	0x00000008
-#define DVP_IT_VST	0x00000010
-#define DVP_IT_FIFO	0x00000020
-
-#define DVP_HLFLN_SD	0x00000001
-
-#define REG_WRITE(vip, reg, value) iowrite32((value), (vip->iomem)+(reg))
-#define REG_READ(vip, reg) ioread32((vip->iomem)+(reg))
-
-#define SAVE_COUNT 8
-#define AUX_COUNT 3
-#define IRQ_COUNT 1
-
-/**
- * struct sta2x11_vip - All internal data for one instance of device
- * @v4l2_dev: device registered in v4l layer
- * @video_dev: properties of our device
- * @pdev: PCI device
- * @adapter: contains I2C adapter information
- * @register_save_area: All relevant register are saved here during suspend
- * @decoder: contains information about video DAC
- * @format: pixel format, fixed UYVY
- * @std: video standard (e.g. PAL/NTSC)
- * @input: input line for video signal ( 0 or 1 )
- * @users: Number of open of device ( max. 1 )
- * @disabled: Device is in power down state
- * @mutex: ensures exclusive opening of device
- * @slock: for excluse acces of registers
- * @vb_vidq: queue maintained by videobuf layer
- * @capture: linked list of capture buffer
- * @active: struct videobuf_buffer currently beingg filled
- * @started: device is ready to capture frame
- * @closing: device will be shut down
- * @tcount: Number of top frames
- * @bcount: Number of bottom frames
- * @overflow: Number of FIFO overflows
- * @mem_spare: small buffer of unused frame
- * @dma_spare: dma addres of mem_spare
- * @iomem: hardware base address
- * @config: I2C and gpio config from platform
- *
- * All non-local data is accessed via this structure.
- */
-
-struct sta2x11_vip {
-	struct v4l2_device v4l2_dev;
-	struct video_device *video_dev;
-	struct pci_dev *pdev;
-	struct i2c_adapter *adapter;
-	unsigned int register_save_area[IRQ_COUNT + SAVE_COUNT + AUX_COUNT];
-	struct v4l2_subdev *decoder;
-	struct v4l2_pix_format format;
-	v4l2_std_id std;
-	unsigned int input;
-	int users;
-	int disabled;
-	struct mutex mutex;	/* exclusive access during open */
-	spinlock_t slock;	/* spin lock for hardware and queue access */
-	struct videobuf_queue vb_vidq;
-	struct list_head capture;
-	struct videobuf_buffer *active;
-	int started, closing, tcount, bcount;
-	int overflow;
-	void *mem_spare;
-	dma_addr_t dma_spare;
-	void *iomem;
-	struct vip_config *config;
-};
-
-static const unsigned int registers_to_save[AUX_COUNT] = {
-	DVP_HLFLN, DVP_RGB, DVP_PKZ
-};
-
-static struct v4l2_pix_format formats_50[] = {
-	{			/*PAL interlaced */
-	 .width = 720,
-	 .height = 576,
-	 .pixelformat = V4L2_PIX_FMT_UYVY,
-	 .field = V4L2_FIELD_INTERLACED,
-	 .bytesperline = 720 * 2,
-	 .sizeimage = 720 * 2 * 576,
-	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
-	{			/*PAL top */
-	 .width = 720,
-	 .height = 288,
-	 .pixelformat = V4L2_PIX_FMT_UYVY,
-	 .field = V4L2_FIELD_TOP,
-	 .bytesperline = 720 * 2,
-	 .sizeimage = 720 * 2 * 288,
-	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
-	{			/*PAL bottom */
-	 .width = 720,
-	 .height = 288,
-	 .pixelformat = V4L2_PIX_FMT_UYVY,
-	 .field = V4L2_FIELD_BOTTOM,
-	 .bytesperline = 720 * 2,
-	 .sizeimage = 720 * 2 * 288,
-	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
-
-};
-
-static struct v4l2_pix_format formats_60[] = {
-	{			/*NTSC interlaced */
-	 .width = 720,
-	 .height = 480,
-	 .pixelformat = V4L2_PIX_FMT_UYVY,
-	 .field = V4L2_FIELD_INTERLACED,
-	 .bytesperline = 720 * 2,
-	 .sizeimage = 720 * 2 * 480,
-	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
-	{			/*NTSC top */
-	 .width = 720,
-	 .height = 240,
-	 .pixelformat = V4L2_PIX_FMT_UYVY,
-	 .field = V4L2_FIELD_TOP,
-	 .bytesperline = 720 * 2,
-	 .sizeimage = 720 * 2 * 240,
-	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
-	{			/*NTSC bottom */
-	 .width = 720,
-	 .height = 240,
-	 .pixelformat = V4L2_PIX_FMT_UYVY,
-	 .field = V4L2_FIELD_BOTTOM,
-	 .bytesperline = 720 * 2,
-	 .sizeimage = 720 * 2 * 240,
-	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
-};
-
-/**
- * buf_setup - Get size and number of video buffer
- * @vq: queue in videobuf
- * @count: Number of buffers (1..MAX_FRAMES).
- *		0 use default value.
- * @size:  size of buffer in bytes
- *
- * returns size and number of buffers
- * a preset value of 0 returns the default number.
- * return value: 0, always succesfull.
- */
-static int buf_setup(struct videobuf_queue *vq, unsigned int *count,
-		     unsigned int *size)
-{
-	struct sta2x11_vip *vip = vq->priv_data;
-
-	*size = vip->format.width * vip->format.height * 2;
-	if (0 == *count || MAX_FRAMES < *count)
-		*count = MAX_FRAMES;
-	return 0;
-};
-
-/**
- * buf_prepare - prepare buffer for usage
- * @vq: queue in videobuf layer
- * @vb: buffer to be prepared
- * @field: type of video data (interlaced/non-interlaced)
- *
- * Allocate or realloc buffer
- * return value: 0, successful.
- *
- * -EINVAL, supplied buffer is too small.
- *
- *  other, buffer could not be locked.
- */
-static int buf_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
-		       enum v4l2_field field)
-{
-	struct sta2x11_vip *vip = vq->priv_data;
-	int ret;
-
-	vb->size = vip->format.width * vip->format.height * 2;
-	if ((0 != vb->baddr) && (vb->bsize < vb->size))
-		return -EINVAL;
-	vb->width = vip->format.width;
-	vb->height = vip->format.height;
-	vb->field = field;
-
-	if (VIDEOBUF_NEEDS_INIT == vb->state) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret)
-			goto fail;
-	}
-	vb->state = VIDEOBUF_PREPARED;
-	return 0;
-fail:
-	videobuf_dma_contig_free(vq, vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
-	return ret;
-}
-
-/**
- * buf_queu - queue buffer for filling
- * @vq: queue in videobuf layer
- * @vb: buffer to be queued
- *
- * if capturing is already running, the buffer will be queued. Otherwise
- * capture is started and the buffer is used directly.
- */
-static void buf_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-	struct sta2x11_vip *vip = vq->priv_data;
-	u32 dma;
-
-	vb->state = VIDEOBUF_QUEUED;
-
-	if (vip->active) {
-		list_add_tail(&vb->queue, &vip->capture);
-		return;
-	}
-
-	vip->started = 1;
-	vip->tcount = 0;
-	vip->bcount = 0;
-	vip->active = vb;
-	vb->state = VIDEOBUF_ACTIVE;
-
-	dma = videobuf_to_dma_contig(vb);
-
-	REG_WRITE(vip, DVP_TFO, (0 << 16) | (0));
-	/* despite of interlace mode, upper and lower frames start at zero */
-	REG_WRITE(vip, DVP_BFO, (0 << 16) | (0));
-
-	switch (vip->format.field) {
-	case V4L2_FIELD_INTERLACED:
-		REG_WRITE(vip, DVP_TFS,
-			  ((vip->format.height / 2 - 1) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_BFS, ((vip->format.height / 2 - 1) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_VTP, dma);
-		REG_WRITE(vip, DVP_VBP, dma + vip->format.width * 2);
-		REG_WRITE(vip, DVP_VMP, 4 * vip->format.width);
-		break;
-	case V4L2_FIELD_TOP:
-		REG_WRITE(vip, DVP_TFS,
-			  ((vip->format.height - 1) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_BFS, ((0) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_VTP, dma);
-		REG_WRITE(vip, DVP_VBP, dma);
-		REG_WRITE(vip, DVP_VMP, 2 * vip->format.width);
-		break;
-	case V4L2_FIELD_BOTTOM:
-		REG_WRITE(vip, DVP_TFS, ((0) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_BFS,
-			  ((vip->format.height) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_VTP, dma);
-		REG_WRITE(vip, DVP_VBP, dma);
-		REG_WRITE(vip, DVP_VMP, 2 * vip->format.width);
-		break;
-
-	default:
-		pr_warning("VIP: unknown field format\n");
-		return;
-	}
-
-	REG_WRITE(vip, DVP_CTL, DVP_CTL_ENA);
-}
-
-/**
- * buff_release - release buffer
- * @vq: queue in videobuf layer
- * @vb: buffer to be released
- *
- * release buffer in videobuf layer
- */
-static void buf_release(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-
-	videobuf_dma_contig_free(vq, vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
-}
-
-static struct videobuf_queue_ops vip_qops = {
-	.buf_setup = buf_setup,
-	.buf_prepare = buf_prepare,
-	.buf_queue = buf_queue,
-	.buf_release = buf_release,
-};
-
-/**
- * vip_open - open video device
- * @file: descriptor of device
- *
- * open device, make sure it is only opened once.
- * return value: 0, no error.
- *
- * -EBUSY, device is already opened
- *
- * -ENOMEM, no memory for auxiliary DMA buffer
- */
-static int vip_open(struct file *file)
-{
-	struct video_device *dev = video_devdata(file);
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	mutex_lock(&vip->mutex);
-	vip->users++;
-
-	if (vip->users > 1) {
-		vip->users--;
-		mutex_unlock(&vip->mutex);
-		return -EBUSY;
-	}
-
-	file->private_data = dev;
-	vip->overflow = 0;
-	vip->started = 0;
-	vip->closing = 0;
-	vip->active = NULL;
-
-	INIT_LIST_HEAD(&vip->capture);
-	vip->mem_spare = dma_alloc_coherent(&vip->pdev->dev, 64,
-					    &vip->dma_spare, GFP_KERNEL);
-	if (!vip->mem_spare) {
-		vip->users--;
-		mutex_unlock(&vip->mutex);
-		return -ENOMEM;
-	}
-
-	mutex_unlock(&vip->mutex);
-	videobuf_queue_dma_contig_init_cached(&vip->vb_vidq,
-					      &vip_qops,
-					      &vip->pdev->dev,
-					      &vip->slock,
-					      V4L2_BUF_TYPE_VIDEO_CAPTURE,
-					      V4L2_FIELD_INTERLACED,
-					      sizeof(struct videobuf_buffer),
-					      vip, NULL);
-	REG_READ(vip, DVP_ITS);
-	REG_WRITE(vip, DVP_HLFLN, DVP_HLFLN_SD);
-	REG_WRITE(vip, DVP_ITM, DVP_IT_VSB | DVP_IT_VST);
-	REG_WRITE(vip, DVP_CTL, DVP_CTL_RST);
-	REG_WRITE(vip, DVP_CTL, 0);
-	REG_READ(vip, DVP_ITS);
-	return 0;
-}
-
-/**
- * vip_close - close video device
- * @file: descriptor of device
- *
- * close video device, wait until all pending operations are finished
- * ( maximum FRAME_MAX buffers pending )
- * Turn off interrupts.
- *
- * return value: 0, always succesful.
- */
-static int vip_close(struct file *file)
-{
-	struct video_device *dev = video_devdata(file);
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	vip->closing = 1;
-	if (vip->active)
-		videobuf_waiton(&vip->vb_vidq, vip->active, 0, 0);
-	spin_lock_irq(&vip->slock);
-
-	REG_WRITE(vip, DVP_ITM, 0);
-	REG_WRITE(vip, DVP_CTL, DVP_CTL_RST);
-	REG_WRITE(vip, DVP_CTL, 0);
-	REG_READ(vip, DVP_ITS);
-
-	vip->started = 0;
-	vip->active = NULL;
-
-	spin_unlock_irq(&vip->slock);
-
-	videobuf_stop(&vip->vb_vidq);
-	videobuf_mmap_free(&vip->vb_vidq);
-
-	dma_free_coherent(&vip->pdev->dev, 64, vip->mem_spare, vip->dma_spare);
-	file->private_data = NULL;
-	mutex_lock(&vip->mutex);
-	vip->users--;
-	mutex_unlock(&vip->mutex);
-	return 0;
-}
-
-/**
- * vip_read - read from video input
- * @file: descriptor of device
- * @data: user buffer
- * @count: number of bytes to be read
- * @ppos: position within stream
- *
- * read video data from video device.
- * handling is done in generic videobuf layer
- * return value: provided by videobuf layer
- */
-static ssize_t vip_read(struct file *file, char __user *data,
-			size_t count, loff_t *ppos)
-{
-	struct video_device *dev = file->private_data;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_read_stream(&vip->vb_vidq, data, count, ppos, 0,
-				    file->f_flags & O_NONBLOCK);
-}
-
-/**
- * vip_mmap - map user buffer
- * @file: descriptor of device
- * @vma: user buffer
- *
- * map user space buffer into kernel mode, including DMA address.
- * handling is done in generic videobuf layer.
- * return value: provided by videobuf layer
- */
-static int vip_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct video_device *dev = file->private_data;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_mmap_mapper(&vip->vb_vidq, vma);
-}
-
-/**
- * vip_poll - poll for event
- * @file: descriptor of device
- * @wait: contains events to be waited for
- *
- * wait for event related to video device.
- * handling is done in generic videobuf layer.
- * return value: provided by videobuf layer
- */
-static unsigned int vip_poll(struct file *file, struct poll_table_struct *wait)
-{
-	struct video_device *dev = file->private_data;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_poll_stream(file, &vip->vb_vidq, wait);
-}
-
-/**
- * vidioc_querycap - return capabilities of device
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @cap: contains return values
- *
- * the capabilities of the device are returned
- *
- * return value: 0, no error.
- */
-static int vidioc_querycap(struct file *file, void *priv,
-			   struct v4l2_capability *cap)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	memset(cap, 0, sizeof(struct v4l2_capability));
-	strcpy(cap->driver, DRV_NAME);
-	strcpy(cap->card, DRV_NAME);
-	cap->version = 0;
-	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
-		 pci_name(vip->pdev));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-	    V4L2_CAP_STREAMING;
-
-	return 0;
-}
-
-/**
- * vidioc_s_std - set video standard
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @std: contains standard to be set
- *
- * the video standard is set
- *
- * return value: 0, no error.
- *
- * -EIO, no input signal detected
- *
- * other, returned from video DAC.
- */
-static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-	v4l2_std_id oldstd = vip->std, newstd;
-	int status;
-
-	if (V4L2_STD_ALL == *std) {
-		v4l2_subdev_call(vip->decoder, core, s_std, *std);
-		ssleep(2);
-		v4l2_subdev_call(vip->decoder, video, querystd, &newstd);
-		v4l2_subdev_call(vip->decoder, video, g_input_status, &status);
-		if (status & V4L2_IN_ST_NO_SIGNAL)
-			return -EIO;
-		*std = vip->std = newstd;
-		if (oldstd != *std) {
-			if (V4L2_STD_525_60 & (*std))
-				vip->format = formats_60[0];
-			else
-				vip->format = formats_50[0];
-		}
-		return 0;
-	}
-
-	if (oldstd != *std) {
-		if (V4L2_STD_525_60 & (*std))
-			vip->format = formats_60[0];
-		else
-			vip->format = formats_50[0];
-	}
-
-	return v4l2_subdev_call(vip->decoder, core, s_std, *std);
-}
-
-/**
- * vidioc_g_std - get video standard
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @std: contains return values
- *
- * the current video standard is returned
- *
- * return value: 0, no error.
- */
-static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	*std = vip->std;
-	return 0;
-}
-
-/**
- * vidioc_querystd - get possible video standards
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @std: contains return values
- *
- * all possible video standards are returned
- *
- * return value: delivered by video DAC routine.
- */
-static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return v4l2_subdev_call(vip->decoder, video, querystd, std);
-
-}
-
-/**
- * vidioc_queryctl - get possible control settings
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @ctrl: contains return values
- *
- * return possible values for a control
- * return value: delivered by video DAC routine.
- */
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *ctrl)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return v4l2_subdev_call(vip->decoder, core, queryctrl, ctrl);
-}
-
-/**
- * vidioc_g_ctl - get control value
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @ctrl: contains return values
- *
- * return setting for a control value
- * return value: delivered by video DAC routine.
- */
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return v4l2_subdev_call(vip->decoder, core, g_ctrl, ctrl);
-}
-
-/**
- * vidioc_s_ctl - set control value
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @ctrl: contains value to be set
- *
- * set value for a specific control
- * return value: delivered by video DAC routine.
- */
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return v4l2_subdev_call(vip->decoder, core, s_ctrl, ctrl);
-}
-
-/**
- * vidioc_enum_input - return name of input line
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @inp: contains return values
- *
- * the user friendly name of the input line is returned
- *
- * return value: 0, no error.
- *
- * -EINVAL, input line number out of range
- */
-static int vidioc_enum_input(struct file *file, void *priv,
-			     struct v4l2_input *inp)
-{
-	if (inp->index > 1)
-		return -EINVAL;
-
-	inp->type = V4L2_INPUT_TYPE_CAMERA;
-	inp->std = V4L2_STD_ALL;
-	sprintf(inp->name, "Camera %u", inp->index);
-
-	return 0;
-}
-
-/**
- * vidioc_s_input - set input line
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @i: new input line number
- *
- * the current active input line is set
- *
- * return value: 0, no error.
- *
- * -EINVAL, line number out of range
- */
-static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-	int ret;
-
-	if (i > 1)
-		return -EINVAL;
-	ret = v4l2_subdev_call(vip->decoder, video, s_routing, i, 0, 0);
-
-	if (!ret)
-		vip->input = i;
-
-	return 0;
-}
-
-/**
- * vidioc_g_input - return input line
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @i: returned input line number
- *
- * the current active input line is returned
- *
- * return value: always 0.
- */
-static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	*i = vip->input;
-	return 0;
-}
-
-/**
- * vidioc_enum_fmt_vid_cap - return video capture format
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @f: returned format information
- *
- * returns name and format of video capture
- * Only UYVY is supported by hardware.
- *
- * return value: always 0.
- */
-static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
-				   struct v4l2_fmtdesc *f)
-{
-
-	if (f->index != 0)
-		return -EINVAL;
-
-	strcpy(f->description, "4:2:2, packed, UYVY");
-	f->pixelformat = V4L2_PIX_FMT_UYVY;
-	f->flags = 0;
-	return 0;
-}
-
-/**
- * vidioc_try_fmt_vid_cap - set video capture format
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @f: new format
- *
- * new video format is set which includes width and
- * field type. width is fixed to 720, no scaling.
- * Only UYVY is supported by this hardware.
- * the minimum height is 200, the maximum is 576 (PAL)
- *
- * return value: 0, no error
- *
- * -EINVAL, pixel or field format not supported
- *
- */
-static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-				  struct v4l2_format *f)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-	int interlace_lim;
-
-	if (V4L2_PIX_FMT_UYVY != f->fmt.pix.pixelformat)
-		return -EINVAL;
-
-	if (V4L2_STD_525_60 & vip->std)
-		interlace_lim = 240;
-	else
-		interlace_lim = 288;
-
-	switch (f->fmt.pix.field) {
-	case V4L2_FIELD_ANY:
-		if (interlace_lim < f->fmt.pix.height)
-			f->fmt.pix.field = V4L2_FIELD_INTERLACED;
-		else
-			f->fmt.pix.field = V4L2_FIELD_BOTTOM;
-		break;
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
-		if (interlace_lim < f->fmt.pix.height)
-			f->fmt.pix.height = interlace_lim;
-		break;
-	case V4L2_FIELD_INTERLACED:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	f->fmt.pix.height &= ~1;
-	if (2 * interlace_lim < f->fmt.pix.height)
-		f->fmt.pix.height = 2 * interlace_lim;
-	if (200 > f->fmt.pix.height)
-		f->fmt.pix.height = 200;
-	f->fmt.pix.width = 720;
-	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
-	f->fmt.pix.sizeimage = f->fmt.pix.width * 2 * f->fmt.pix.height;
-	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
-	return 0;
-}
-
-/**
- * vidioc_s_fmt_vid_cap - set current video format parameters
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @f: returned format information
- *
- * set new capture format
- * return value: 0, no error
- *
- * other, delivered by video DAC routine.
- */
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-	int ret;
-
-	ret = vidioc_try_fmt_vid_cap(file, priv, f);
-	if (ret)
-		return ret;
-
-	memcpy(&vip->format, &f->fmt.pix, sizeof(struct v4l2_pix_format));
-	return 0;
-}
-
-/**
- * vidioc_g_fmt_vid_cap - get current video format parameters
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @f: contains format information
- *
- * returns current video format parameters
- *
- * return value: 0, always successful
- */
-static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	memcpy(&f->fmt.pix, &vip->format, sizeof(struct v4l2_pix_format));
-	return 0;
-}
-
-/**
- * vidioc_reqfs - request buffer
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @p: video buffer
- *
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *p)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_reqbufs(&vip->vb_vidq, p);
-}
-
-/**
- * vidioc_querybuf - query buffer
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @p: video buffer
- *
- * query buffer state.
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_querybuf(&vip->vb_vidq, p);
-}
-
-/**
- * vidioc_qbuf - queue a buffer
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @p: video buffer
- *
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_qbuf(&vip->vb_vidq, p);
-}
-
-/**
- * vidioc_dqbuf - dequeue a buffer
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @p: video buffer
- *
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_dqbuf(&vip->vb_vidq, p, file->f_flags & O_NONBLOCK);
-}
-
-/**
- * vidioc_streamon - turn on streaming
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @type: type of capture
- *
- * turn on streaming.
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type type)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_streamon(&vip->vb_vidq);
-}
-
-/**
- * vidioc_streamoff - turn off streaming
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @type: type of capture
- *
- * turn off streaming.
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_streamoff(struct file *file, void *priv,
-			    enum v4l2_buf_type type)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_streamoff(&vip->vb_vidq);
-}
-
-static const struct v4l2_file_operations vip_fops = {
-	.owner = THIS_MODULE,
-	.open = vip_open,
-	.release = vip_close,
-	.ioctl = video_ioctl2,
-	.read = vip_read,
-	.mmap = vip_mmap,
-	.poll = vip_poll
-};
-
-static const struct v4l2_ioctl_ops vip_ioctl_ops = {
-	.vidioc_querycap = vidioc_querycap,
-	.vidioc_s_std = vidioc_s_std,
-	.vidioc_g_std = vidioc_g_std,
-	.vidioc_querystd = vidioc_querystd,
-	.vidioc_queryctrl = vidioc_queryctrl,
-	.vidioc_g_ctrl = vidioc_g_ctrl,
-	.vidioc_s_ctrl = vidioc_s_ctrl,
-	.vidioc_enum_input = vidioc_enum_input,
-	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
-	.vidioc_s_input = vidioc_s_input,
-	.vidioc_g_input = vidioc_g_input,
-	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
-	.vidioc_reqbufs = vidioc_reqbufs,
-	.vidioc_querybuf = vidioc_querybuf,
-	.vidioc_qbuf = vidioc_qbuf,
-	.vidioc_dqbuf = vidioc_dqbuf,
-	.vidioc_streamon = vidioc_streamon,
-	.vidioc_streamoff = vidioc_streamoff,
-};
-
-static struct video_device video_dev_template = {
-	.name = DRV_NAME,
-	.release = video_device_release,
-	.fops = &vip_fops,
-	.ioctl_ops = &vip_ioctl_ops,
-	.tvnorms = V4L2_STD_ALL,
-};
-
-/**
- * vip_irq - interrupt routine
- * @irq: Number of interrupt ( not used, correct number is assumed )
- * @vip: local data structure containing all information
- *
- * check for both frame interrupts set ( top and bottom ).
- * check FIFO overflow, but limit number of log messages after open.
- * signal a complete buffer if done.
- * dequeue a new buffer if available.
- * disable VIP if no buffer available.
- *
- * return value: IRQ_NONE, interrupt was not generated by VIP
- *
- * IRQ_HANDLED, interrupt done.
- */
-static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
-{
-	u32 status, dma;
-	unsigned long flags;
-	struct videobuf_buffer *vb;
-
-	status = REG_READ(vip, DVP_ITS);
-
-	if (!status) {
-		pr_debug("VIP: irq ignored\n");
-		return IRQ_NONE;
-	}
-
-	if (!vip->started)
-		return IRQ_HANDLED;
-
-	if (status & DVP_IT_VSB)
-		vip->bcount++;
-
-	if (status & DVP_IT_VST)
-		vip->tcount++;
-
-	if ((DVP_IT_VSB | DVP_IT_VST) == (status & (DVP_IT_VST | DVP_IT_VSB))) {
-		/* this is bad, we are too slow, hope the condition is gone
-		 * on the next frame */
-		pr_info("VIP: both irqs\n");
-		return IRQ_HANDLED;
-	}
-
-	if (status & DVP_IT_FIFO) {
-		if (5 > vip->overflow++)
-			pr_info("VIP: fifo overflow\n");
-	}
-
-	if (2 > vip->tcount)
-		return IRQ_HANDLED;
-
-	if (status & DVP_IT_VSB)
-		return IRQ_HANDLED;
-
-	spin_lock_irqsave(&vip->slock, flags);
-
-	REG_WRITE(vip, DVP_CTL, REG_READ(vip, DVP_CTL) & ~DVP_CTL_ENA);
-	if (vip->active) {
-		do_gettimeofday(&vip->active->ts);
-		vip->active->field_count++;
-		vip->active->state = VIDEOBUF_DONE;
-		wake_up(&vip->active->done);
-		vip->active = NULL;
-	}
-	if (!vip->closing) {
-		if (list_empty(&vip->capture))
-			goto done;
-
-		vb = list_first_entry(&vip->capture, struct videobuf_buffer,
-				      queue);
-		if (NULL == vb) {
-			pr_info("VIP: no buffer\n");
-			goto done;
-		}
-		vb->state = VIDEOBUF_ACTIVE;
-		list_del(&vb->queue);
-		vip->active = vb;
-		dma = videobuf_to_dma_contig(vb);
-		switch (vip->format.field) {
-		case V4L2_FIELD_INTERLACED:
-			REG_WRITE(vip, DVP_VTP, dma);
-			REG_WRITE(vip, DVP_VBP, dma + vip->format.width * 2);
-			break;
-		case V4L2_FIELD_TOP:
-		case V4L2_FIELD_BOTTOM:
-			REG_WRITE(vip, DVP_VTP, dma);
-			REG_WRITE(vip, DVP_VBP, dma);
-			break;
-		default:
-			pr_warning("VIP: unknown field format\n");
-			goto done;
-			break;
-		}
-		REG_WRITE(vip, DVP_CTL, REG_READ(vip, DVP_CTL) | DVP_CTL_ENA);
-	}
-done:
-	spin_unlock_irqrestore(&vip->slock, flags);
-	return IRQ_HANDLED;
-}
-
-/**
- * vip_gpio_reserve - reserve gpio pin
- * @dev: device
- * @pin: GPIO pin number
- * @dir: direction, input or output
- * @name: GPIO pin name
- *
- */
-static int vip_gpio_reserve(struct device *dev, int pin, int dir,
-			    const char *name)
-{
-	int ret;
-
-	if (pin == -1)
-		return 0;
-
-	ret = gpio_request(pin, name);
-	if (ret) {
-		dev_err(dev, "Failed to allocate pin %d (%s)\n", pin, name);
-		return ret;
-	}
-
-	ret = gpio_direction_output(pin, dir);
-	if (ret) {
-		dev_err(dev, "Failed to set direction for pin %d (%s)\n",
-			pin, name);
-		gpio_free(pin);
-		return ret;
-	}
-
-	ret = gpio_export(pin, false);
-	if (ret) {
-		dev_err(dev, "Failed to export pin %d (%s)\n", pin, name);
-		gpio_free(pin);
-		return ret;
-	}
-
-	return 0;
-}
-
-/**
- * vip_gpio_release - release gpio pin
- * @dev: device
- * @pin: GPIO pin number
- * @name: GPIO pin name
- *
- */
-static void vip_gpio_release(struct device *dev, int pin, const char *name)
-{
-	if (pin != -1) {
-		dev_dbg(dev, "releasing pin %d (%s)\n",	pin, name);
-		gpio_unexport(pin);
-		gpio_free(pin);
-	}
-}
-
-/**
- * sta2x11_vip_init_one - init one instance of video device
- * @pdev: PCI device
- * @ent: (not used)
- *
- * allocate reset pins for DAC.
- * Reset video DAC, this is done via reset line.
- * allocate memory for managing device
- * request interrupt
- * map IO region
- * register device
- * find and initialize video DAC
- *
- * return value: 0, no error
- *
- * -ENOMEM, no memory
- *
- * -ENODEV, device could not be detected or registered
- */
-static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
-					  const struct pci_device_id *ent)
-{
-	int ret;
-	struct sta2x11_vip *vip;
-	struct vip_config *config;
-
-	ret = pci_enable_device(pdev);
-	if (ret)
-		return ret;
-
-	config = dev_get_platdata(&pdev->dev);
-	if (!config) {
-		dev_info(&pdev->dev, "VIP slot disabled\n");
-		ret = -EINVAL;
-		goto disable;
-	}
-
-	ret = vip_gpio_reserve(&pdev->dev, config->pwr_pin, 0,
-			       config->pwr_name);
-	if (ret)
-		goto disable;
-
-	if (config->reset_pin >= 0) {
-		ret = vip_gpio_reserve(&pdev->dev, config->reset_pin, 0,
-				       config->reset_name);
-		if (ret) {
-			vip_gpio_release(&pdev->dev, config->pwr_pin,
-					 config->pwr_name);
-			goto disable;
-		}
-	}
-
-	if (config->pwr_pin != -1) {
-		/* Datasheet says 5ms between PWR and RST */
-		usleep_range(5000, 25000);
-		ret = gpio_direction_output(config->pwr_pin, 1);
-	}
-
-	if (config->reset_pin != -1) {
-		/* Datasheet says 5ms between PWR and RST */
-		usleep_range(5000, 25000);
-		ret = gpio_direction_output(config->reset_pin, 1);
-	}
-	usleep_range(5000, 25000);
-
-	vip = kzalloc(sizeof(struct sta2x11_vip), GFP_KERNEL);
-	if (!vip) {
-		ret = -ENOMEM;
-		goto release_gpios;
-	}
-
-	vip->pdev = pdev;
-	vip->std = V4L2_STD_PAL;
-	vip->format = formats_50[0];
-	vip->config = config;
-
-	if (v4l2_device_register(&pdev->dev, &vip->v4l2_dev))
-		goto free_mem;
-
-	dev_dbg(&pdev->dev, "BAR #0 at 0x%lx 0x%lx irq %d\n",
-		(unsigned long)pci_resource_start(pdev, 0),
-		(unsigned long)pci_resource_len(pdev, 0), pdev->irq);
-
-	pci_set_master(pdev);
-
-	ret = pci_request_regions(pdev, DRV_NAME);
-	if (ret)
-		goto unreg;
-
-	vip->iomem = pci_iomap(pdev, 0, 0x100);
-	if (!vip->iomem) {
-		ret = -ENOMEM; /* FIXME */
-		goto release;
-	}
-
-	pci_enable_msi(pdev);
-
-	INIT_LIST_HEAD(&vip->capture);
-	spin_lock_init(&vip->slock);
-	mutex_init(&vip->mutex);
-	vip->started = 0;
-	vip->disabled = 0;
-
-	ret = request_irq(pdev->irq,
-			  (irq_handler_t) vip_irq,
-			  IRQF_SHARED, DRV_NAME, vip);
-	if (ret) {
-		dev_err(&pdev->dev, "request_irq failed\n");
-		ret = -ENODEV;
-		goto unmap;
-	}
-
-	vip->video_dev = video_device_alloc();
-	if (!vip->video_dev) {
-		ret = -ENOMEM;
-		goto release_irq;
-	}
-
-	*(vip->video_dev) = video_dev_template;
-	video_set_drvdata(vip->video_dev, vip);
-
-	ret = video_register_device(vip->video_dev, VFL_TYPE_GRABBER, -1);
-	if (ret)
-		goto vrelease;
-
-	vip->adapter = i2c_get_adapter(vip->config->i2c_id);
-	if (!vip->adapter) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "no I2C adapter found\n");
-		goto vunreg;
-	}
-
-	vip->decoder = v4l2_i2c_new_subdev(&vip->v4l2_dev, vip->adapter,
-					   "adv7180", vip->config->i2c_addr,
-					   NULL);
-	if (!vip->decoder) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "no decoder found\n");
-		goto vunreg;
-	}
-
-	i2c_put_adapter(vip->adapter);
-
-	v4l2_subdev_call(vip->decoder, core, init, 0);
-
-	pr_info("STA2X11 Video Input Port (VIP) loaded\n");
-	return 0;
-
-vunreg:
-	video_set_drvdata(vip->video_dev, NULL);
-vrelease:
-	if (video_is_registered(vip->video_dev))
-		video_unregister_device(vip->video_dev);
-	else
-		video_device_release(vip->video_dev);
-release_irq:
-	free_irq(pdev->irq, vip);
-	pci_disable_msi(pdev);
-unmap:
-	pci_iounmap(pdev, vip->iomem);
-	mutex_destroy(&vip->mutex);
-release:
-	pci_release_regions(pdev);
-unreg:
-	v4l2_device_unregister(&vip->v4l2_dev);
-free_mem:
-	kfree(vip);
-release_gpios:
-	vip_gpio_release(&pdev->dev, config->reset_pin, config->reset_name);
-	vip_gpio_release(&pdev->dev, config->pwr_pin, config->pwr_name);
-disable:
-	/*
-	 * do not call pci_disable_device on sta2x11 because it break all
-	 * other Bus masters on this EP
-	 */
-	return ret;
-}
-
-/**
- * sta2x11_vip_remove_one - release device
- * @pdev: PCI device
- *
- * Undo everything done in .._init_one
- *
- * unregister video device
- * free interrupt
- * unmap ioadresses
- * free memory
- * free GPIO pins
- */
-static void __devexit sta2x11_vip_remove_one(struct pci_dev *pdev)
-{
-	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
-	struct sta2x11_vip *vip =
-	    container_of(v4l2_dev, struct sta2x11_vip, v4l2_dev);
-
-	video_set_drvdata(vip->video_dev, NULL);
-	video_unregister_device(vip->video_dev);
-	/*do not call video_device_release() here, is already done */
-	free_irq(pdev->irq, vip);
-	pci_disable_msi(pdev);
-	pci_iounmap(pdev, vip->iomem);
-	pci_release_regions(pdev);
-
-	v4l2_device_unregister(&vip->v4l2_dev);
-	mutex_destroy(&vip->mutex);
-
-	vip_gpio_release(&pdev->dev, vip->config->pwr_pin,
-			 vip->config->pwr_name);
-	vip_gpio_release(&pdev->dev, vip->config->reset_pin,
-			 vip->config->reset_name);
-
-	kfree(vip);
-	/*
-	 * do not call pci_disable_device on sta2x11 because it break all
-	 * other Bus masters on this EP
-	 */
-}
-
-#ifdef CONFIG_PM
-
-/**
- * sta2x11_vip_suspend - set device into power save mode
- * @pdev: PCI device
- * @state: new state of device
- *
- * all relevant registers are saved and an attempt to set a new state is made.
- *
- * return value: 0 always indicate success,
- * even if device could not be disabled. (workaround for hardware problem)
- *
- * reurn value : 0, always succesful, even if hardware does not not support
- * power down mode.
- */
-static int sta2x11_vip_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
-	struct sta2x11_vip *vip =
-	    container_of(v4l2_dev, struct sta2x11_vip, v4l2_dev);
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&vip->slock, flags);
-	vip->register_save_area[0] = REG_READ(vip, DVP_CTL);
-	REG_WRITE(vip, DVP_CTL, vip->register_save_area[0] & DVP_CTL_DIS);
-	vip->register_save_area[SAVE_COUNT] = REG_READ(vip, DVP_ITM);
-	REG_WRITE(vip, DVP_ITM, 0);
-	for (i = 1; i < SAVE_COUNT; i++)
-		vip->register_save_area[i] = REG_READ(vip, 4 * i);
-	for (i = 0; i < AUX_COUNT; i++)
-		vip->register_save_area[SAVE_COUNT + IRQ_COUNT + i] =
-		    REG_READ(vip, registers_to_save[i]);
-	spin_unlock_irqrestore(&vip->slock, flags);
-	/* save pci state */
-	pci_save_state(pdev);
-	if (pci_set_power_state(pdev, pci_choose_state(pdev, state))) {
-		/*
-		 * do not call pci_disable_device on sta2x11 because it
-		 * break all other Bus masters on this EP
-		 */
-		vip->disabled = 1;
-	}
-
-	pr_info("VIP: suspend\n");
-	return 0;
-}
-
-/**
- * sta2x11_vip_resume - resume device operation
- * @pdev : PCI device
- *
- * re-enable device, set PCI state to powered and restore registers.
- * resume normal device operation afterwards.
- *
- * return value: 0, no error.
- *
- * other, could not set device to power on state.
- */
-static int sta2x11_vip_resume(struct pci_dev *pdev)
-{
-	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
-	struct sta2x11_vip *vip =
-	    container_of(v4l2_dev, struct sta2x11_vip, v4l2_dev);
-	unsigned long flags;
-	int ret, i;
-
-	pr_info("VIP: resume\n");
-	/* restore pci state */
-	if (vip->disabled) {
-		ret = pci_enable_device(pdev);
-		if (ret) {
-			pr_warning("VIP: Can't enable device.\n");
-			return ret;
-		}
-		vip->disabled = 0;
-	}
-	ret = pci_set_power_state(pdev, PCI_D0);
-	if (ret) {
-		/*
-		 * do not call pci_disable_device on sta2x11 because it
-		 * break all other Bus masters on this EP
-		 */
-		pr_warning("VIP: Can't enable device.\n");
-		vip->disabled = 1;
-		return ret;
-	}
-
-	pci_restore_state(pdev);
-
-	spin_lock_irqsave(&vip->slock, flags);
-	for (i = 1; i < SAVE_COUNT; i++)
-		REG_WRITE(vip, 4 * i, vip->register_save_area[i]);
-	for (i = 0; i < AUX_COUNT; i++)
-		REG_WRITE(vip, registers_to_save[i],
-			  vip->register_save_area[SAVE_COUNT + IRQ_COUNT + i]);
-	REG_WRITE(vip, DVP_CTL, vip->register_save_area[0]);
-	REG_WRITE(vip, DVP_ITM, vip->register_save_area[SAVE_COUNT]);
-	spin_unlock_irqrestore(&vip->slock, flags);
-	return 0;
-}
-
-#endif
-
-static DEFINE_PCI_DEVICE_TABLE(sta2x11_vip_pci_tbl) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_VIP)},
-	{0,}
-};
-
-static struct pci_driver sta2x11_vip_driver = {
-	.name = DRV_NAME,
-	.probe = sta2x11_vip_init_one,
-	.remove = __devexit_p(sta2x11_vip_remove_one),
-	.id_table = sta2x11_vip_pci_tbl,
-#ifdef CONFIG_PM
-	.suspend = sta2x11_vip_suspend,
-	.resume = sta2x11_vip_resume,
-#endif
-};
-
-static int __init sta2x11_vip_init_module(void)
-{
-	return pci_register_driver(&sta2x11_vip_driver);
-}
-
-static void __exit sta2x11_vip_exit_module(void)
-{
-	pci_unregister_driver(&sta2x11_vip_driver);
-}
-
-#ifdef MODULE
-module_init(sta2x11_vip_init_module);
-module_exit(sta2x11_vip_exit_module);
-#else
-late_initcall_sync(sta2x11_vip_init_module);
-#endif
-
-MODULE_DESCRIPTION("STA2X11 Video Input Port driver");
-MODULE_AUTHOR("Wind River");
-MODULE_LICENSE("GPL v2");
-MODULE_SUPPORTED_DEVICE("sta2x11 video input");
-MODULE_VERSION(DRV_VERSION);
-MODULE_DEVICE_TABLE(pci, sta2x11_vip_pci_tbl);
diff --git a/drivers/media/video/sta2x11_vip.h b/drivers/media/video/sta2x11_vip.h
deleted file mode 100644
index 4f81a13..0000000
--- a/drivers/media/video/sta2x11_vip.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright (c) 2011 Wind River Systems, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- * See the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * Author:  Anders Wallin <anders.wallin@windriver.com>
- *
- */
-
-#ifndef __STA2X11_VIP_H
-#define __STA2X11_VIP_H
-
-/**
- * struct vip_config - video input configuration data
- * @pwr_name: ADV powerdown name
- * @pwr_pin: ADV powerdown pin
- * @reset_name: ADV reset name
- * @reset_pin: ADV reset pin
- */
-struct vip_config {
-	const char *pwr_name;
-	int pwr_pin;
-	const char *reset_name;
-	int reset_pin;
-	int i2c_id;
-	int i2c_addr;
-};
-
-#endif /* __STA2X11_VIP_H */
-- 
1.7.11.2

