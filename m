Return-path: <linux-media-owner@vger.kernel.org>
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50191 "EHLO
	new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932172AbcCNCDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 22:03:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailnew.nyi.internal (Postfix) with ESMTP id 2D704FCF
	for <linux-media@vger.kernel.org>; Sun, 13 Mar 2016 21:55:43 -0400 (EDT)
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] Add tw5864 driver
Date: Mon, 14 Mar 2016 03:55:14 +0200
Message-Id: <1457920514-20792-1-git-send-email-andrey_utkin@fastmail.com>
In-Reply-To: <1457920461-20713-1-git-send-email-andrey_utkin@fastmail.com>
References: <1457920461-20713-1-git-send-email-andrey_utkin@fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>

Support for boards based on Techwell TW5864 chip which provides
multichannel video & audio grabbing and encoding (H.264, MJPEG,
ADPCM G.726).

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 MAINTAINERS                                  |    7 +
 drivers/staging/media/Kconfig                |    2 +
 drivers/staging/media/Makefile               |    1 +
 drivers/staging/media/tw5864/Kconfig         |   11 +
 drivers/staging/media/tw5864/Makefile        |    3 +
 drivers/staging/media/tw5864/tw5864-bs.h     |  154 ++
 drivers/staging/media/tw5864/tw5864-config.c |  359 +++++
 drivers/staging/media/tw5864/tw5864-core.c   |  453 ++++++
 drivers/staging/media/tw5864/tw5864-h264.c   |  183 +++
 drivers/staging/media/tw5864/tw5864-reg.h    | 2200 ++++++++++++++++++++++++++
 drivers/staging/media/tw5864/tw5864-tables.h |  237 +++
 drivers/staging/media/tw5864/tw5864-video.c  | 1364 ++++++++++++++++
 drivers/staging/media/tw5864/tw5864.h        |  280 ++++
 include/linux/pci_ids.h                      |    1 +
 14 files changed, 5255 insertions(+)
 create mode 100644 drivers/staging/media/tw5864/Kconfig
 create mode 100644 drivers/staging/media/tw5864/Makefile
 create mode 100644 drivers/staging/media/tw5864/tw5864-bs.h
 create mode 100644 drivers/staging/media/tw5864/tw5864-config.c
 create mode 100644 drivers/staging/media/tw5864/tw5864-core.c
 create mode 100644 drivers/staging/media/tw5864/tw5864-h264.c
 create mode 100644 drivers/staging/media/tw5864/tw5864-reg.h
 create mode 100644 drivers/staging/media/tw5864/tw5864-tables.h
 create mode 100644 drivers/staging/media/tw5864/tw5864-video.c
 create mode 100644 drivers/staging/media/tw5864/tw5864.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 409509d..7bb1fa9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11195,6 +11195,13 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/usb/tm6000/
 
+TW5864 VIDEO4LINUX DRIVER
+M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
+M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
+L:	linux-media@vger.kernel.org
+S:	Supported
+F:	drivers/staging/media/tw5864/
+
 TW68 VIDEO4LINUX DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 0078b6a..15ac585 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -37,6 +37,8 @@ source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/timb/Kconfig"
 
+source "drivers/staging/media/tw5864/Kconfig"
+
 # Keep LIRC at the end, as it has sub-menus
 source "drivers/staging/media/lirc/Kconfig"
 
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 9149588..2f356ef 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_VIDEO_OMAP1)	+= omap1/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_DVB_MN88472)       += mn88472/
 obj-$(CONFIG_VIDEO_TIMBERDALE)  += timb/
+obj-$(CONFIG_VIDEO_TW5864)      += tw5864/
diff --git a/drivers/staging/media/tw5864/Kconfig b/drivers/staging/media/tw5864/Kconfig
new file mode 100644
index 0000000..5d6871a
--- /dev/null
+++ b/drivers/staging/media/tw5864/Kconfig
@@ -0,0 +1,11 @@
+config VIDEO_TW5864
+	tristate "Techwell TW5864 video/audio grabber and encoder"
+	depends on VIDEO_DEV && PCI && VIDEO_V4L2
+	select VIDEOBUF2_DMA_SG
+	---help---
+	  Support for boards based on Techwell TW5864 chip which provides
+	  multichannel video & audio grabbing and encoding (H.264, MJPEG,
+	  ADPCM G.726).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tw5864.
diff --git a/drivers/staging/media/tw5864/Makefile b/drivers/staging/media/tw5864/Makefile
new file mode 100644
index 0000000..1da77d4
--- /dev/null
+++ b/drivers/staging/media/tw5864/Makefile
@@ -0,0 +1,3 @@
+tw5864-objs := tw5864-core.o tw5864-video.o tw5864-config.o tw5864-h264.o
+
+obj-$(CONFIG_VIDEO_TW5864) += tw5864.o
diff --git a/drivers/staging/media/tw5864/tw5864-bs.h b/drivers/staging/media/tw5864/tw5864-bs.h
new file mode 100644
index 0000000..8c1df7a
--- /dev/null
+++ b/drivers/staging/media/tw5864/tw5864-bs.h
@@ -0,0 +1,154 @@
+/*
+ *  TW5864 driver - Exp-Golomb code functions
+ *
+ *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
+struct bs {
+	u8 *p_start;
+	u8 *p;
+	u8 *p_end;
+	int i_left; /* number of available bits */
+};
+
+static inline void bs_init(struct bs *s, void *buf, int size)
+{
+	s->p_start = buf;
+	s->p = buf;
+	s->p_end = s->p + size;
+	s->i_left = 8;
+}
+
+static inline int bs_pos(struct bs *s)
+{
+	return 8 * (s->p - s->p_start) + 8 - s->i_left;
+}
+
+static inline bool bs_eof(struct bs *s)
+{
+	return s->p >= s->p_end;
+}
+
+static inline int bs_len(struct bs *s)
+{
+	return s->p - s->p_start;
+}
+
+static inline int bs_left(struct bs *s)
+{
+	return 8 - s->i_left;
+}
+
+static inline void bs_direct_write(struct bs *s, u8 value)
+{
+	*s->p = value;
+	s->p++;
+	s->i_left = 8;
+}
+
+static inline void bs_write(struct bs *s, int i_count, u32 i_bits)
+{
+	if (s->p >= s->p_end - 4)
+		return;
+	while (i_count > 0) {
+		if (i_count < 32)
+			i_bits &= (1 << i_count) - 1;
+		if (i_count < s->i_left) {
+			*s->p = (*s->p << i_count) | i_bits;
+			s->i_left -= i_count;
+			break;
+		}
+		*s->p = (*s->p << s->i_left) | (i_bits >> (i_count -
+							   s->i_left));
+		i_count -= s->i_left;
+		s->p++;
+		s->i_left = 8;
+	}
+}
+
+static inline void bs_write1(struct bs *s, u32 i_bit)
+{
+	if (s->p < s->p_end) {
+		*s->p <<= 1;
+		*s->p |= i_bit;
+		s->i_left--;
+		if (s->i_left == 0) {
+			s->p++;
+			s->i_left = 8;
+		}
+	}
+}
+
+static inline void bs_align_0(struct bs *s)
+{
+	if (s->i_left != 8) {
+		*s->p <<= s->i_left;
+		s->i_left = 8;
+		s->p++;
+	}
+}
+
+static inline void bs_sh_align(struct bs *s)
+{
+	if (s->i_left != 8) {
+		*s->p <<= s->i_left;
+		s->i_left = 8;
+	}
+}
+
+static inline void bs_align_1(struct bs *s)
+{
+	if (s->i_left != 8) {
+		*s->p <<= s->i_left;
+		*s->p |= (1 << s->i_left) - 1;
+		s->i_left = 8;
+		s->p++;
+	}
+}
+
+static inline void bs_align(struct bs *s)
+{
+	bs_align_0(s);
+}
+
+/* golomb functions */
+static inline void bs_write_ue(struct bs *s, u32 val)
+{
+	if (val == 0) {
+		bs_write1(s, 1);
+	} else {
+		val++;
+		bs_write(s, 2 * fls(val) - 1, val);
+	}
+}
+
+static inline void bs_write_se(struct bs *s, int val)
+{
+	bs_write_ue(s, val <= 0 ? -val * 2 : val * 2 - 1);
+}
+
+static inline void bs_write_te(struct bs *s, int x, int val)
+{
+	if (x == 1)
+		bs_write1(s, 1 & ~val);
+	else if (x > 1)
+		bs_write_ue(s, val);
+}
+
+static inline void bs_rbsp_trailing(struct bs *s)
+{
+	bs_write1(s, 1);
+	if (s->i_left != 8)
+		bs_write(s, s->i_left, 0x00);
+}
diff --git a/drivers/staging/media/tw5864/tw5864-config.c b/drivers/staging/media/tw5864/tw5864-config.c
new file mode 100644
index 0000000..ff3e308
--- /dev/null
+++ b/drivers/staging/media/tw5864/tw5864-config.c
@@ -0,0 +1,359 @@
+/*
+ *  TW5864 driver - analog decoders configuration functions
+ *
+ *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
+#include "tw5864.h"
+#include "tw5864-reg.h"
+
+#define TW5864_IIC_TIMEOUT  (30000)
+
+static unsigned char tbl_pal_tw2864_common[] __used = {
+	0x00, 0x00, 0x64, 0x11,
+	0x80, 0x80, 0x00, 0x12,
+	0x12, 0x20, 0x0a, 0xD0,
+	0x00, 0x00, 0x07, 0x7F,
+};
+
+static unsigned char tbl_ntsc_tw2864_common[] __used = {
+	0x00, 0x00, 0x64, 0x11,
+	0x80, 0x80, 0x00, 0x02,
+	0x12, 0xF0, 0x0C, 0xD0,
+	0x00, 0x00, 0x07, 0x7F
+};
+
+static unsigned char tbl_pal_tw2864_common2[] __used = {
+	0x00, 0x22, 0x00, 0x00,
+	0x22, 0x00, 0x00, 0x22,
+	0x00, 0x00, 0x22, 0x00,
+};
+
+static unsigned char tbl_tw2864_other[] __used = {
+	0xfb, 0x6f, 0xfc, 0xff,
+	0xdb, 0xc1, 0xd2, 0x01,
+	0xdd, 0x00, 0xde, 0x00,
+	0xe1, 0xc0, 0xe2, 0xaa,
+	0xe3, 0xaa, 0xf8, 0x64,
+	0xf9, 0x11, 0xaa, 0x00,
+	0x9e, 0x72, 0x9c, 0x20,
+	0x94, 0x14, 0xca, 0xaa,
+	0xcb, 0x00, 0x89, 0x02,
+	0xfa, 0xc6, 0xcf, 0x83,
+	0x9f, 0x00, 0xb1, 0x2a,
+	0x9e, 0x7a,
+};
+
+static unsigned char tbl_pal_tw2865_common[] __used = {
+	0x00, 0x00, 0x64, 0x11,
+	0x80, 0x80, 0x00, 0x12,
+	0x17, 0x20, 0x0C, 0xD0,
+	0x00, 0x00, 0x07, 0x7F,
+};
+
+static unsigned char tbl_ntsc_tw2865_common[] __used = {
+	0x00, 0x00, 0x64, 0x11,
+	0x80, 0x80, 0x00, 0x02,
+	0x12, 0xF0, 0x0C, 0xD0,
+	0x00, 0x00, 0x07, 0x7F
+};
+
+static unsigned char tbl_tw2865_other1[] __used = {
+	0xfa, 0x4a, 0xfb, 0x6f,
+	0xfc, 0xff, 0x9c, 0x20,
+	0x9e, 0x72, 0xca, 0x02,
+	0xf9, 0x51, 0xaa, 0x00,
+	0x41, 0xd4, 0x43, 0x08,
+	0x6b, 0x0f, 0x6c, 0x0f,
+	0x61, 0x02, 0x96, 0xe6,
+	0x97, 0xc3, 0x9f, 0x03,
+	0xb1, 0x2a, 0x9e, 0x7a,
+	0x18, 0x19, 0x1a, 0x06,
+	0x28, 0x19, 0x2a, 0x06,
+	0x38, 0x19, 0x3a, 0x06,
+	0x60, 0x15,
+};
+
+static unsigned char tbl_tw2866_other1[] __used = {
+	0xfa, 0x4a, 0xfb, 0x6f,
+	0xfc, 0xff, 0x9c, 0x20,
+	0x9e, 0x72, 0xca, 0x02,
+	0xf9, 0x51, 0xaa, 0x00,
+	0x41, 0xd4, 0x43, 0x08,
+	0x6b, 0x0f, 0x6c, 0x0f,
+	0x61, 0x02, 0x96, 0xe6,
+	0x97, 0xc3, 0x9f, 0x00,
+	0xb1, 0x2a, 0x9e, 0x7a,
+	0x5b, 0xff, 0x08, 0x19,
+	0x0a, 0x06, 0x18, 0x19,
+	0x1a, 0x06, 0x28, 0x19,
+	0x2a, 0x06, 0x38, 0x19,
+	0x3a, 0x06, 0x60, 0x15,
+};
+
+static unsigned char tbl_tw2865_other2[] __used = {
+	0x73, 0x01, 0xf8, 0xc4,
+	0xf9, 0x51, 0x70, 0x08,
+	0x7f, 0x80, 0xcf, 0x80
+};
+
+static unsigned char tbl_tw2865_other3[] __used = {
+	0x89, 0x05, 0x7e, 0xc0,
+	0xe0, 0x00
+};
+
+static unsigned char audio_tw2865_common[] __used = {
+	0x33, 0x33, 0x03, 0x31,
+	0x75, 0xb9, 0xfd, 0x20,
+	0x64, 0xa8, 0xec, 0xC1,
+	0x00, 0x00, 0x00, 0x80,
+	0x00, 0xC0, 0xAA, 0xAA
+};
+
+static unsigned char audio_tbl_pal_tw2865_8KHz[] __used = {
+	0x83, 0xB5, 0x09, 0x00,
+	0xA0, 0x00
+};
+
+static unsigned char audio_tbl_pal_tw2865_16KHz[] __used = {
+	0x07, 0x6B, 0x13, 0x00, 0x40, 0x01
+};
+
+static unsigned char audio_tbl_ntsc_tw2865_8KHz[] __used = {
+	0x83, 0xB5, 0x09, 0x78, 0x85, 0x00
+};
+
+static unsigned char audio_tbl_ntsc_tw2865_16KHz[] __used = {
+	0x07, 0x6B, 0x13, 0xEF, 0x0A, 0x01
+};
+
+static int i2c_read(struct tw5864_dev *dev, u8 devid, u8 devfn, u8 *buf);
+
+static int __used i2c_multi_read(struct tw5864_dev *dev, u8 devid, u8 devfn,
+				 u8 *buf, u32 count)
+{
+	int i = 0;
+	u32 val = 0;
+	int timeout = TW5864_IIC_TIMEOUT;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	for (i = 0; i < count; i++) {
+		val = (1 << 24) | ((devid | 0x01) << 16) | ((devfn + i) << 8);
+
+		tw_writel(TW5864_IIC, val);
+
+		do {
+			val = tw_readl(TW5864_IIC) & (0x01000000);
+		} while ((!val) && (--timeout));
+		if (!timeout) {
+			local_irq_restore(flags);
+			dev_err(&dev->pci->dev, "dev 0x%x, fn 0x%x\n", devid,
+				devfn);
+			return -ETIMEDOUT;
+		}
+		buf[i] = (u8)tw_readl(TW5864_IIC);
+	}
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static int i2c_multi_write(struct tw5864_dev *dev, u8 devid, u8 devfn, u8 *buf,
+			   u32 count)
+{
+	int i = 0;
+	u32 val = 0;
+	int timeout = TW5864_IIC_TIMEOUT;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	for (i = 0; i < count; i++) {
+		val = (1 << 24) | ((devid & 0xfe) << 16) | ((devfn + i) << 8) |
+			buf[i];
+		tw_writel(TW5864_IIC, val);
+		do {
+			val = tw_readl(TW5864_IIC) & (0x01000000);
+		} while ((!val) && (--timeout));
+		if (!timeout) {
+			local_irq_restore(flags);
+			dev_err(&dev->pci->dev, "dev 0x%x, fn 0x%x, 0x%x\n",
+				devid, devfn, buf[i]);
+			return -ETIMEDOUT;
+		}
+	}
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static int i2c_read(struct tw5864_dev *dev, u8 devid, u8 devfn, u8 *buf)
+{
+	u32 val = 0;
+	int timeout = TW5864_IIC_TIMEOUT;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	val = (1 << 24) | ((devid | 0x01) << 16) | (devfn << 8);
+
+	tw_writel(TW5864_IIC, val);
+	do {
+		val = tw_readl(TW5864_IIC) & (0x01000000);
+	} while ((!val) && (--timeout));
+	if (!timeout) {
+		local_irq_restore(flags);
+		dev_err(&dev->pci->dev, "dev 0x%x, fn 0x%x\n", devid, devfn);
+		return -ETIMEDOUT;
+	}
+
+	*buf = (u8)tw_readl(TW5864_IIC);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static int i2c_write(struct tw5864_dev *dev, u8 devid, u8 devfn, u8 buf)
+{
+	u32 val = 0;
+	int timeout = TW5864_IIC_TIMEOUT;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	val = (1 << 24) + ((devid & 0xfe) << 16) + (devfn << 8) + buf;
+	tw_writel(TW5864_IIC, val);
+	do {
+		val = tw_readl(TW5864_IIC) & (0x01000000);
+	} while ((!val) && (--timeout));
+	local_irq_restore(flags);
+	if (!timeout) {
+		dev_err(&dev->pci->dev, "dev 0x%x, fn 0x%x, 0x%x\n", devid,
+			devfn, buf);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int i2c_wscatter(struct tw5864_dev *dev, u8 devid, u8 *buf, u32 count)
+{
+	int i = 0;
+	u32 val = 0;
+	int timeout = TW5864_IIC_TIMEOUT;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	for (i = 0; i < count; i++) {
+		val = (1 << 24) + ((devid & 0xfe) << 16) + (buf[i * 2 + 0] << 8)
+			+ buf[i * 2 + 1];
+		tw_writel(TW5864_IIC, val);
+		do {
+			val = tw_readl(TW5864_IIC) & (0x01000000);
+		} while ((!val) && (--timeout));
+		if (!timeout) {
+			local_irq_restore(flags);
+			dev_err(&dev->pci->dev, "dev 0x%x, fn 0x%x, 0x%x\n",
+				devid, buf[i * 2], buf[i * 2 + 1]);
+			return -ETIMEDOUT;
+		}
+	}
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static void init_tw2864(struct tw5864_dev *dev, u8 iic)
+{
+	u32 ch;
+
+	for (ch = 0; ch < 4; ch++)
+		i2c_multi_write(dev, iic, ch * 0x10, tbl_pal_tw2864_common, 16);
+
+	i2c_wscatter(dev, iic, tbl_tw2864_other, 23);
+	i2c_write(dev, iic, 0xcf, 0x83);
+	i2c_write(dev, iic, 0xe0, 0x00);
+}
+
+static __used void init_tw2865(struct tw5864_dev *dev, u8 iic)
+{
+	u32 ch;
+
+	for (ch = 0; ch < 4; ch++)
+		i2c_multi_write(dev, iic, ch * 0x10, tbl_pal_tw2865_common, 16);
+
+	i2c_wscatter(dev, iic, tbl_tw2865_other1,
+		     sizeof(tbl_tw2865_other1) >> 1);
+	i2c_multi_write(dev, iic, 0xd0, audio_tw2865_common, 20);
+	i2c_wscatter(dev, iic, tbl_tw2865_other2, 6);
+	i2c_multi_write(dev, iic, 0xf0, audio_tbl_pal_tw2865_8KHz, 6);
+	i2c_wscatter(dev, iic, tbl_tw2865_other3, 3);
+	i2c_write(dev, iic, 0xe0, 0x10);
+}
+
+#define ISIL_PHY_VD_CHAN_NUMBER   (16)
+
+/*auto detect CLKP_DEL delay*/
+static int tw28xx_clkp_delay(struct tw5864_dev *dev, u8 devid, u32 base_ch,
+			     u32 limit)
+{
+	if (dev && (base_ch < ISIL_PHY_VD_CHAN_NUMBER) &&
+	    (limit <= (ISIL_PHY_VD_CHAN_NUMBER >> 2))) {
+		int delay;
+		u8 flags = 0;
+
+		delay = -1;
+		i2c_read(dev, devid, 0x9f, &flags);
+		while ((++delay) < 0x10) {
+			i2c_write(dev, devid, 0x9f, delay);
+			/* only bus0 can detect colume and line */
+			tw_writel(TW5864_H264EN_BUS0_MAP, base_ch);
+			/* clear error flags */
+			tw_writel(TW5864_UNDEFINED_ERROR_FLAGS_0x9218, 0x1);
+			mdelay(100);
+			if (tw_readl(TW5864_UNDEFINED_ERROR_FLAGS_0x9218))
+				continue;
+			dev_dbg(&dev->pci->dev, "auto detect CLKP_DEL = %02x\n",
+				delay);
+			break;
+		}
+		if (delay >= 0x10) {
+			dev_err(&dev->pci->dev,
+				"can't find suitable clkp_del for devid 0x%02x\n",
+				devid);
+			i2c_write(dev, devid, 0x9f, flags);
+
+			return -EFAULT;
+		}
+		return 0;
+	}
+
+	return 1;
+}
+
+void tw5864_init_ad(struct tw5864_dev *dev)
+{
+	unsigned int val;
+
+	val = tw_readl(TW5864_IIC_ENB);
+	val |= 0x01;
+	tw_writel(TW5864_IIC_ENB, val);
+	tw_writel(TW5864_I2C_PHASE_CFG, 0x01);
+
+	init_tw2864(dev, 0x52);
+	tw28xx_clkp_delay(dev, 0x52, 4, 4);
+	init_tw2864(dev, 0x54);
+	tw28xx_clkp_delay(dev, 0x54, 8, 4);
+	init_tw2864(dev, 0x56);
+	tw28xx_clkp_delay(dev, 0x56, 12, 4);
+	init_tw2865(dev, 0x50);
+}
diff --git a/drivers/staging/media/tw5864/tw5864-core.c b/drivers/staging/media/tw5864/tw5864-core.c
new file mode 100644
index 0000000..c41ba4c
--- /dev/null
+++ b/drivers/staging/media/tw5864/tw5864-core.c
@@ -0,0 +1,453 @@
+/*
+ *  TW5864 driver - core functions
+ *
+ *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
+#include <linux/debugfs.h>
+#include <linux/pci_ids.h>
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
+void tw_indir_writeb(struct tw5864_dev *dev, u16 addr, u8 data)
+{
+	int retries = 30000;
+
+	addr <<= 2;
+
+	while ((tw_readl(TW5864_IND_CTL) >> 31) && (retries--))
+		;
+	if (!retries)
+		dev_err(&dev->pci->dev,
+			"tw_indir_writel() retries exhausted before writing\n");
+
+	tw_writel(TW5864_IND_DATA, data);
+	tw_writel(TW5864_IND_CTL, addr | TW5864_RW | TW5864_ENABLE);
+}
+
+u8 tw_indir_readb(struct tw5864_dev *dev, u16 addr)
+{
+	int retries = 30000;
+	u32 data = 0;
+
+	addr <<= 2;
+
+	while ((tw_readl(TW5864_IND_CTL) >> 31) && (retries--))
+		;
+	if (!retries)
+		dev_err(&dev->pci->dev,
+			"tw_indir_readl() retries exhausted before reading\n");
+
+	tw_writel(TW5864_IND_CTL, addr | TW5864_ENABLE);
+
+	retries = 30000;
+	while ((tw_readl(TW5864_IND_CTL) >> 31) && (retries--))
+		;
+	if (!retries)
+		dev_err(&dev->pci->dev,
+			"tw_indir_readl() retries exhausted at reading\n");
+
+	data = tw_readl(TW5864_IND_DATA);
+	return data & 0xff;
+}
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
+	status = tw_readl(TW5864_INTR_STATUS_L)
+		| (tw_readl(TW5864_INTR_STATUS_H) << 16);
+	if (!status)
+		return IRQ_NONE;
+
+	tw_writel(TW5864_INTR_CLR_L, 0xffff);
+	tw_writel(TW5864_INTR_CLR_H, 0xffff);
+
+	if (status & TW5864_INTR_VLC_DONE) {
+		tw5864_h264_isr(dev);
+		tw_writel(TW5864_VLC_DSP_INTR, 0x00000001);
+		tw_writel(TW5864_PCI_INTR_STATUS, TW5864_VLC_DONE_INTR);
+	}
+
+	if (status & TW5864_INTR_TIMER) {
+		tw5864_timer_isr(dev);
+		tw_writel(TW5864_PCI_INTR_STATUS, TW5864_TIMER_INTR);
+	}
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
+	dma_sync_single_for_cpu(&dev->pci->dev, cur_frame->vlc.dma_addr,
+				H264_VLC_BUF_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(&dev->pci->dev, cur_frame->mv.dma_addr,
+				H264_MV_BUF_SIZE, DMA_FROM_DEVICE);
+
+	if (next_frame_index != dev->h264_buf_r_index) {
+		cur_frame->vlc_len = tw_readl(TW5864_VLC_LENGTH) << 2;
+		cur_frame->checksum = tw_readl(TW5864_VLC_CRC_REG);
+		cur_frame->input = input;
+		cur_frame->timestamp = ktime_get_ns();
+
+		dev->h264_buf_w_index = next_frame_index;
+		tasklet_schedule(&dev->tasklet);
+
+		cur_frame = next_frame;
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
+	input->frame_seqno++;
+
+	dma_sync_single_for_device(&dev->pci->dev,
+				   cur_frame->vlc.dma_addr,
+				   H264_VLC_BUF_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(&dev->pci->dev,
+				   cur_frame->mv.dma_addr,
+				   H264_MV_BUF_SIZE, DMA_FROM_DEVICE);
+
+	tw_writel(TW5864_VLC_STREAM_BASE_ADDR, cur_frame->vlc.dma_addr);
+	tw_writel(TW5864_MV_STREAM_BASE_ADDR, cur_frame->mv.dma_addr);
+}
+
+static void tw5864_timer_isr(struct tw5864_dev *dev)
+{
+	unsigned long flags;
+	int i;
+	int encoder_busy;
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
+		int next_input = (i + dev->next_i) % TW5864_INPUTS;
+		struct tw5864_input *input = &dev->inputs[next_input];
+		int raw_buf_id; /* id of internal buf with last raw frame */
+
+		spin_lock_irqsave(&input->slock, flags);
+		if (!input->enabled)
+			goto next;
+
+		raw_buf_id = tw_mask_shift_readl(TW5864_SENIF_ORG_FRM_PTR1, 0x3,
+						 2 * input->input_number);
+
+		/* Check if new raw frame is available */
+		if (input->buf_id == raw_buf_id)
+			goto next;
+
+		input->buf_id = raw_buf_id;
+		spin_unlock_irqrestore(&input->slock, flags);
+
+		spin_lock_irqsave(&dev->slock, flags);
+		dev->encoder_busy = 1;
+		spin_unlock_irqrestore(&dev->slock, flags);
+		tw5864_request_encoded_frame(input);
+		break;
+next:
+		spin_unlock_irqrestore(&input->slock, flags);
+		continue;
+	}
+}
+
+static size_t regs_dump(struct tw5864_dev *dev, char *buf, size_t size)
+{
+	size_t count = 0;
+	u32 reg_addr;
+	u32 value;
+	int i;
+	struct range {
+		int start;
+		int end;
+	} ranges[] = {
+		{ 0x0000, 0x2FFC },
+		{ 0x4000, 0x4FFC },
+		{ 0x8000, 0x180DC },
+		{ 0x18100, 0x1817C },
+		{ 0x80000, 0x87FFF },
+	};
+
+	/*
+	 * Dumping direct registers space,
+	 * except some spots which trigger hanging
+	 */
+	for (i = 0; i < ARRAY_SIZE(ranges); i++)
+		for (reg_addr = ranges[i].start;
+		     (count < size) && (reg_addr <= ranges[i].end);
+		     reg_addr += 4) {
+			value = tw_readl(reg_addr);
+			count += scnprintf(buf + count, size - count,
+					   "[0x%05x] = 0x%08x\n",
+					   reg_addr, value);
+		}
+
+	/* Dumping indirect register space */
+	for (reg_addr = 0x0; (count < size) && (reg_addr <= 0xEFE);
+	     reg_addr += 1) {
+		value = tw_indir_readb(dev, reg_addr);
+		count += scnprintf(buf + count, size - count,
+				   "indir[0x%03x] = 0x%02x\n", reg_addr, value);
+	}
+
+	return count;
+}
+
+#define DEBUGFS_BUF_SIZE (1024 * 1024)
+
+struct debugfs_buffer {
+	size_t count;
+	char data[DEBUGFS_BUF_SIZE];
+};
+
+static int debugfs_regs_dump_open(struct inode *inode, struct file *file)
+{
+	struct tw5864_dev *dev = inode->i_private;
+	struct debugfs_buffer *buf;
+
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	buf->count = regs_dump(dev, buf->data, sizeof(buf->data));
+
+	file->private_data = buf;
+	return 0;
+}
+
+static ssize_t debugfs_regs_dump_read(struct file *file, char __user *user_buf,
+				      size_t nbytes, loff_t *ppos)
+{
+	struct debugfs_buffer *buf = file->private_data;
+
+	return simple_read_from_buffer(user_buf, nbytes, ppos, buf->data,
+				       buf->count);
+}
+
+static int debugfs_regs_dump_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	file->private_data = NULL;
+
+	return 0;
+}
+
+static const struct file_operations debugfs_regs_dump_fops = {
+	.owner = THIS_MODULE,
+	.open = debugfs_regs_dump_open,
+	.llseek = no_llseek,
+	.read = debugfs_regs_dump_read,
+	.release = debugfs_regs_dump_release,
+};
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
+		goto v4l2_reg_fail;
+
+	/* pci init */
+	dev->pci = pci_dev;
+	if (pci_enable_device(pci_dev)) {
+		err = -EIO;
+		goto pci_enable_fail;
+	}
+
+	pci_set_master(pci_dev);
+
+	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	if (err) {
+		dev_err(&dev->pci->dev, "32bit PCI DMA is not supported\n");
+		goto req_mem_fail;
+	}
+
+	/* get mmio */
+	if (!request_mem_region(pci_resource_start(pci_dev, 0),
+				pci_resource_len(pci_dev, 0), dev->name)) {
+		err = -EBUSY;
+		dev_err(&dev->pci->dev, "can't get MMIO memory @ 0x%llx\n",
+			(unsigned long long)pci_resource_start(pci_dev, 0));
+		goto req_mem_fail;
+	}
+	dev->mmio = ioremap_nocache(pci_resource_start(pci_dev, 0),
+				    pci_resource_len(pci_dev, 0));
+	if (!dev->mmio) {
+		err = -EIO;
+		dev_err(&dev->pci->dev, "can't ioremap() MMIO memory\n");
+		goto ioremap_fail;
+	}
+
+	spin_lock_init(&dev->slock);
+
+	dev->debugfs_dir = debugfs_create_dir(dev->name, NULL);
+	err = tw5864_video_init(dev, video_nr);
+	if (err)
+		goto video_init_fail;
+
+	/* get irq */
+	err = devm_request_irq(&pci_dev->dev, pci_dev->irq, tw5864_isr,
+			       IRQF_SHARED, "tw5864", dev);
+	if (err < 0) {
+		dev_err(&dev->pci->dev, "can't get IRQ %d\n", pci_dev->irq);
+		goto irq_req_fail;
+	}
+
+	debugfs_create_file("regs_dump", S_IRUGO, dev->debugfs_dir, dev,
+			    &debugfs_regs_dump_fops);
+
+	return 0;
+
+irq_req_fail:
+	tw5864_video_fini(dev);
+video_init_fail:
+	iounmap(dev->mmio);
+ioremap_fail:
+	release_mem_region(pci_resource_start(pci_dev, 0),
+			   pci_resource_len(pci_dev, 0));
+req_mem_fail:
+	pci_disable_device(pci_dev);
+pci_enable_fail:
+	v4l2_device_unregister(&dev->v4l2_dev);
+v4l2_reg_fail:
+	devm_kfree(&pci_dev->dev, dev);
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
+	debugfs_remove_recursive(dev->debugfs_dir);
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
diff --git a/drivers/staging/media/tw5864/tw5864-h264.c b/drivers/staging/media/tw5864/tw5864-h264.c
new file mode 100644
index 0000000..8203e3a
--- /dev/null
+++ b/drivers/staging/media/tw5864/tw5864-h264.c
@@ -0,0 +1,183 @@
+/*
+ *  TW5864 driver - H.264 headers generation functions
+ *
+ *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
+#include "tw5864.h"
+#include "tw5864-bs.h"
+
+static u8 marker[] = { 0x00, 0x00, 0x00, 0x01 };
+
+/* log2 of max GOP size, taken 8 as V4L2-advertised max GOP size is 255 */
+#define i_log2_max_frame_num 8
+#define i_log2_max_poc_lsb i_log2_max_frame_num
+
+static int tw5864_h264_gen_sps_rbsp(u8 *buf, size_t size, int width, int height)
+{
+	struct bs bs, *s;
+	const int i_mb_width = width / 16;
+	const int i_mb_height = height / 16;
+
+	s = &bs;
+	bs_init(s, buf, size);
+	bs_write(s, 8, 0x42 /* profile == 66, baseline */);
+	bs_write(s, 8, 0 /* constraints */);
+	bs_write(s, 8, 0x1E /* level */);
+	bs_write_ue(s, 0 /* SPS id */);
+	bs_write_ue(s, i_log2_max_frame_num - 4);
+	bs_write_ue(s, 0 /* i_poc_type */);
+	bs_write_ue(s, i_log2_max_poc_lsb - 4);
+
+	bs_write_ue(s, 1 /* i_num_ref_frames */);
+	bs_write(s, 1, 0 /* b_gaps_in_frame_num_value_allowed */);
+	bs_write_ue(s, i_mb_width - 1);
+	bs_write_ue(s, i_mb_height - 1);
+	bs_write(s, 1, 1 /* b_frame_mbs_only */);
+	bs_write(s, 1, 0 /* b_direct8x8_inference */);
+	bs_write(s, 1, 0);
+	bs_write(s, 1, 0);
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
+	bs_write_ue(s, 0 /* PPS id */);
+	bs_write_ue(s, 0 /* SPS id */);
+	bs_write(s, 1, 0 /* b_cabac */);
+	bs_write(s, 1, 0 /* b_pic_order */);
+	bs_write_ue(s, (1 /* i_num_slice_groups */) - 1);
+	bs_write_ue(s, (1 /* i_num_ref_idx_l0_active */) - 1);
+	bs_write_ue(s, (1 /* i_num_ref_idx_l1_active */) - 1);
+	bs_write(s, 1, 0 /* b_weighted_pred */);
+	bs_write(s, 2, 0 /* b_weighted_bipred */);
+	bs_write_se(s, qp - 26);
+	bs_write_se(s, qp - 26);
+	bs_write_se(s, 0 /* i_chroma_qp_index_offset */);
+	bs_write(s, 1, 0 /* b_deblocking_filter_control */);
+	bs_write(s, 1, 0 /* b_constrained_intra_pred */);
+	bs_write(s, 1, 0 /* b_redundant_pic_cnt */);
+	bs_rbsp_trailing(s);
+	return bs_len(s);
+}
+
+static int tw5864_h264_gen_slice_head(u8 *buf, size_t size,
+				      unsigned int idr_pic_id,
+				      unsigned int frame_seqno_in_gop,
+				      int *tail_nb_bits, u8 *tail)
+{
+	struct bs bs, *s;
+	int is_i_frame = frame_seqno_in_gop == 0;
+	int i_poc_lsb = frame_seqno_in_gop;
+
+	s = &bs;
+	bs_init(s, buf, size);
+	bs_write_ue(s, 0 /* i_first_mb */);
+	bs_write_ue(s, is_i_frame ? 2 : 5 /* slice type - I or P */);
+	bs_write_ue(s, 0 /* PPS id */);
+	bs_write(s, i_log2_max_frame_num, frame_seqno_in_gop);
+	if (is_i_frame)
+		bs_write_ue(s, idr_pic_id);
+
+	bs_write(s, i_log2_max_poc_lsb, i_poc_lsb);
+
+	if (!is_i_frame)
+		bs_write1(s, 0 /*b_num_ref_idx_override */);
+
+	/* ref pic list reordering */
+	if (!is_i_frame)
+		bs_write1(s, 0 /* b_ref_pic_list_reordering_l0 */);
+
+	if (is_i_frame) {
+		bs_write1(s, 0); /* no output of prior pics flag */
+		bs_write1(s, 0); /* long term reference flag */
+	} else {
+		bs_write1(s, 0); /* adaptive_ref_pic_marking_mode_flag */
+	}
+
+	bs_write_se(s, 0 /* i_qp_delta */);
+
+	if (s->i_left != 8) {
+		*tail = ((s->p[0]) << s->i_left);
+		*tail_nb_bits = 8 - s->i_left;
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
+	WARN_ON_ONCE(*space_left < 4);
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
+	WARN_ON_ONCE(*space_left < 4);
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
+				  unsigned int frame_seqno_in_gop,
+				  int *tail_nb_bits, u8 *tail)
+{
+	int nal_len;
+
+	WARN_ON_ONCE(*space_left < 4);
+	memcpy(*buf, marker, sizeof(marker));
+	*buf += 4;
+	*space_left -= 4;
+
+	/* Frame NAL header */
+	**buf = (frame_seqno_in_gop == 0) ? 0x25 : 0x21;
+	*buf += 1;
+	*space_left -= 1;
+
+	nal_len = tw5864_h264_gen_slice_head(*buf, *space_left, idr_pic_id,
+					     frame_seqno_in_gop, tail_nb_bits,
+					     tail);
+	*buf += nal_len;
+	*space_left -= nal_len;
+}
diff --git a/drivers/staging/media/tw5864/tw5864-reg.h b/drivers/staging/media/tw5864/tw5864-reg.h
new file mode 100644
index 0000000..a6fdcc1
--- /dev/null
+++ b/drivers/staging/media/tw5864/tw5864-reg.h
@@ -0,0 +1,2200 @@
+/*
+ *  TW5864 driver - registers description
+ *
+ *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
+/* 0x0000 ~ 0x1FFC - H264 Register Map */
+/* [15:0] The Version register for H264 core (Read Only) */
+#define TW5864_H264REV             0x0000
+
+#define TW5864_EMU                 0x0004
+/* Define controls in register TW5864_EMU */
+/* DDR controller enabled */
+#define TW5864_EMU_EN_DDR        BIT(0)
+/* Enable bit for Inter module */
+#define TW5864_EMU_EN_ME         BIT(1)
+/* Enable bit for Sensor Interface module */
+#define TW5864_EMU_EN_SEN        BIT(2)
+/* Enable bit for Host Burst Access */
+#define TW5864_EMU_EN_BHOST      BIT(3)
+/* Enable bit for Loop Filter module */
+#define TW5864_EMU_EN_LPF        BIT(4)
+/* Enable bit for PLBK module */
+#define TW5864_EMU_EN_PLBK       BIT(5)
+/*
+ * Video Frame mapping in DDR
+ * 00 CIF
+ * 01 D1
+ * 10 Reserved
+ * 11 Reserved
+ *
+ */
+#define TW5864_DSP_FRAME_TYPE    (3 << 6)
+#define TW5864_DSP_FRAME_TYPE_D1 BIT(6)
+
+/*  */
+#define TW5864_SLICE               0x000C
+/* Define controls in register TW5864_SLICE */
+/* VLC Slice end flag */
+#define TW5864_VLC_SLICE_END     BIT(0)
+/* Master Slice End Flag */
+#define TW5864_MAS_SLICE_END     BIT(4)
+/* Host to start a new slice Address */
+#define TW5864_START_NSLICE     BIT(15)
+
+/*
+ * [15:0] Two bit for each channel
+ * (channel 0 ~ 7). Each two bits are
+ * the buffer pointer for the last
+ * encoded frame of the corresponding
+ * channel.
+ */
+#define TW5864_ENC_BUF_PTR_REC1    0x0010
+
+/* [5:0] DSP_MB_QP and [15:10] DSP_LPF_OFFSET */
+#define TW5864_DSP_QP              0x0018
+/* Define controls in register TW5864_DSP_QP */
+/* [5:0] H264 QP Value for codec */
+#define TW5864_DSP_MB_QP           0x003f
+/*
+ * [15:10] H264 LPF_OFFSET Address
+ * (Default 0)
+ */
+#define TW5864_DSP_LPF_OFFSET      0xfc00
+
+/*  */
+#define TW5864_DSP_CODEC           0x001C
+/* Define controls in register TW5864_DSP_CODEC */
+/*
+ * 0: Encode (TW5864 Default)
+ * 1: Decode
+ */
+#define TW5864_DSP_CODEC_MODE    BIT(0)
+/*
+ * 0->3 4 VLC data buffer in DDR (1M each)
+ * 0->7 8 VLC data buffer in DDR (512k each)
+ */
+#define TW5864_VLC_BUF_ID        (7 << 2)
+/*
+ * 0 4CIF in 1 MB
+ * 1 1CIF in 1 MB
+ */
+#define TW5864_CIF_MAP_MD        BIT(6)
+/*
+ * 0 2 falf D1 in 1 MB
+ * 1 1 half D1 in 1 MB
+ */
+#define TW5864_HD1_MAP_MD        BIT(7)
+/* VLC Stream valid */
+#define TW5864_VLC_VLD           BIT(8)
+/* MV Vector Valid */
+#define TW5864_MV_VECT_VLD       BIT(9)
+/* MV Flag Valid */
+#define TW5864_MV_FLAG_VLD      BIT(10)
+
+/*  */
+#define TW5864_DSP_SEN             0x0020
+/* Define controls in register TW5864_DSP_SEN */
+/* Org Buffer Base for Luma (default 0) */
+#define TW5864_DSP_SEN_PIC_LU      0x000f
+/* Org Buffer Base for Chroma (default 4) */
+#define TW5864_DSP_SEN_PIC_CHM     0x00f0
+/* Maximum Number of Buffers (default 4) */
+#define TW5864_DSP_SEN_PIC_MAX     0x0700
+/*
+ * Original Frame D1 or HD1 switch
+ * (Default 0)
+ */
+#define TW5864_DSP_SEN_HFULL       0x1000
+
+/*  */
+#define TW5864_DSP_REF_PIC         0x0024
+/* Define controls in register TW5864_DSP_REF_PIC */
+/* Ref Buffer Base for Luma (default 0) */
+#define TW5864_DSP_REF_PIC_LU      0x000f
+/* Ref Buffer Base for Chroma (default 4) */
+#define TW5864_DSP_REF_PIC_CHM     0x00f0
+/* Maximum Number of Buffers (default 4) */
+#define TW5864_DSP_REF_PIC_MAX     0x0700
+
+/*
+ * [15:0] SEN_EN_CH[n] SENIF
+ * original frame capture enable for
+ * each channel
+ */
+#define TW5864_SEN_EN_CH           0x0028
+
+/*  */
+#define TW5864_DSP                 0x002C
+/* Define controls in register TW5864_DSP */
+/*
+ * The ID for channel selected for
+ * encoding operation
+ */
+#define TW5864_DSP_ENC_CHN         0x000f
+/* See DSP_MB_DELAY below */
+#define TW5864_DSP_MB_WAIT         0x0010
+/*
+ * DSP Chroma Switch
+ * 0 DDRB
+ * 1 DDRA
+ */
+#define TW5864_DSP_CHROM_SW        0x0020
+/* VLC Flow Control: 1 for enable */
+#define TW5864_DSP_FLW_CNTL        0x0040
+/*
+ * If DSP_MB_WAIT == 0, MB delay is
+ * DSP_MB_DELAY * 16
+ * If DSP_MB_DELAY == 1, MB delay is
+ * DSP_MB_DELAY * 128
+ */
+#define TW5864_DSP_MB_DELAY        0x0f00
+
+/*  */
+#define TW5864_DDR                 0x0030
+/* Define controls in register TW5864_DDR */
+/* DDR Single Access Page Number */
+#define TW5864_DDR_PAGE_CNTL       0x00ff
+/* DDR-DPR Burst Read Enable */
+#define TW5864_DDR_BRST_EN      BIT(13)
+/*
+ * DDR A/B Select as HOST access
+ * 0 Select DDRA
+ * 1 Select DDRB
+ */
+#define TW5864_DDR_AB_SEL       BIT(14)
+/*
+ * DDR Access Mode Select
+ * 0 Single R/W Access (Host <-> DDR)
+ * 1 Burst R/W Access (Host <-> DPR)
+ */
+#define TW5864_DDR_MODE         BIT(15)
+
+/* The original frame capture pointer. Two bits for each channel */
+/* SENIF_ORG_FRM_PTR [15:0] */
+#define TW5864_SENIF_ORG_FRM_PTR1  0x0038
+/* SENIF_ORG_FRM_PTR [31:16] */
+#define TW5864_SENIF_ORG_FRM_PTR2  0x003C
+
+#define TW5864_DSP_SEN_MODE        0x0040
+/* Define controls in register TW5864_DSP_SEN_MODE */
+#define TW5864_DSP_SEN_MODE_CH0    0x000f
+#define TW5864_DSP_SEN_MODE_CH1    0x00f0
+
+/*
+ * [15:0]: ENC_BUF_PTR_REC[31:16]
+ * Two bit for each channel (channel
+ * 8 ~ 15). Each two bits are the
+ * buffer pointer for the last
+ * encoded frame of a channel
+ */
+#define TW5864_ENC_BUF_PTR_REC2    0x004C
+
+/* Current MV Flag Status Pointer for Channel n. (Read only) */
+/*
+ * [1:0] CH0_MV_PTR,
+ * ..., [15:14] CH7_MV_PTR
+ */
+#define TW5864_CH_MV_PTR1          0x0060
+/*
+ * [1:0] CH8_MV_PTR,
+ * ..., [15:14] CH15_MV_PTR
+ */
+#define TW5864_CH_MV_PTR2          0x0064
+
+/*
+ * [15:0] Reset Current MV Flag
+ * Status Pointer for Channel n
+ * (one bit each)
+ */
+#define TW5864_RST_MV_PTR          0x0068
+#define TW5864_INTERLACING         0x0200
+/* Define controls in register TW5864_INTERLACING */
+/*
+ * Inter_Mode Start. 2-nd bit? A
+ * guess. Missing in datasheet.
+ * Without this bit set, the output video is interlaced (stripy).
+ */
+#define TW5864_DSP_INTER_ST      BIT(1)
+/* Deinterlacer Enable */
+#define TW5864_DI_EN             BIT(2)
+/*
+ * De-interlacer Mode
+ * 1 Shuffled frame
+ * 0 Normal Un-Shuffled Frame
+ */
+#define TW5864_DI_MD             BIT(3)
+/*
+ * Down scale original frame in X direction
+ * 11: Un-used
+ * 10: down-sample to 1/4
+ * 01: down-sample to 1/2
+ * 00: down-sample disabled
+ */
+#define TW5864_DSP_DWN_X         (3 << 4)
+/*
+ * Down scale original frame in Y direction
+ * 11: Un-used
+ * 10: down-sample to 1/4
+ * 01: down-sample to 1/2
+ * 00: down-sample disabled
+ */
+#define TW5864_DSP_DWN_Y         (3 << 6)
+/*
+ * 1 Dual Stream
+ * 0 Single Stream
+ */
+#define TW5864_DUAL_STR          BIT(8)
+
+#define TW5864_DSP_REF             0x0204
+/* Define controls in register TW5864_DSP_REF */
+/* Number of reference frame (Default 1 for TW5864B) */
+#define TW5864_DSP_REF_FRM         0x000f
+/* Window size */
+#define TW5864_DSP_WIN_SIZE        0x02f0
+
+#define TW5864_DSP_SKIP            0x0208
+/* Define controls in register TW5864_DSP_SKIP */
+/*
+ * Skip Offset Enable bit
+ * 0 DSP_SKIP_OFFSET value is not used (default 8)
+ * 1 DSP_SKIP_OFFSET value is used in HW
+ */
+#define TW5864_DSP_SKIP_OFEN       0x0080
+/* Skip mode cost offset (default 8) */
+#define TW5864_DSP_SKIP_OFFSET     0x007f
+
+#define TW5864_MOTION_SEARCH_ETC   0x020C
+/* Define controls in register TW5864_MOTION_SEARCH_ETC */
+/* Enable quarter pel search mode */
+#define TW5864_QPEL_EN           BIT(0)
+/* Enable half pel search mode */
+#define TW5864_HPEL_EN           BIT(1)
+/* Enable motion search mode */
+#define TW5864_ME_EN             BIT(2)
+/* Enable Intra mode */
+#define TW5864_INTRA_EN          BIT(3)
+/* Enable Skip Mode */
+#define TW5864_SKIP_EN           BIT(4)
+/* Search Option (Default 2"b01) */
+#define TW5864_SRCH_OPT          (3 << 5)
+
+#define TW5864_DSP_ENC_REC         0x0210
+/* Define controls in register TW5864_DSP_ENC_REC */
+/* Reference Buffer Pointer for encoding */
+#define TW5864_DSP_ENC_REF_PTR     0x0007
+/* Reconstruct Buffer pointer */
+#define TW5864_DSP_REC_BUF_PTR     0x7000
+
+/* [15:0] Lambda Value for H264 */
+#define TW5864_DSP_REF_MVP_LAMBDA  0x0214
+
+#define TW5864_DSP_PIC_MAX_MB      0x0218
+/* Define controls in register TW5864_DSP_PIC_MAX_MB */
+/* The MB number in Y direction for a frame */
+#define TW5864_DSP_PIC_MAX_MB_Y    0x007f
+/* The MB number in X direction for a frame */
+#define TW5864_DSP_PIC_MAX_MB_X    0x7f00
+
+/* The original frame pointer for encoding */
+#define TW5864_DSP_ENC_ORG_PTR_REG  0x021C
+/* Mask to use with TW5864_DSP_ENC_ORG_PTR */
+#define TW5864_DSP_ENC_ORG_PTR_MASK 0x7000
+/* Number of bits to shift with TW5864_DSP_ENC_ORG_PTR */
+#define TW5864_DSP_ENC_ORG_PTR_SHIFT    12
+
+/* DDR base address of OSD rectangle attribute data */
+#define TW5864_DSP_OSD_ATTRI_BASE  0x0220
+/* OSD enable bit for each channel */
+#define TW5864_DSP_OSD_ENABLE      0x0228
+
+/* 0x0280 ~ 0x029C – Motion Vector for 1st 4x4 Block, e.g., 80 (X), 84 (Y) */
+#define TW5864_ME_MV_VEC1          0x0280
+/* 0x02A0 ~ 0x02BC – Motion Vector for 2nd 4x4 Block, e.g., A0 (X), A4 (Y) */
+#define TW5864_ME_MV_VEC2          0x02A0
+/* 0x02C0 ~ 0x02DC – Motion Vector for 3rd 4x4 Block, e.g., C0 (X), C4 (Y) */
+#define TW5864_ME_MV_VEC3          0x02C0
+/* 0x02E0 ~ 0x02FC – Motion Vector for 4th 4x4 Block, e.g., E0 (X), E4 (Y) */
+#define TW5864_ME_MV_VEC4          0x02E0
+
+/*
+ * [5:0]
+ * if (intra16x16_cost < (intra4x4_cost+dsp_i4x4_offset))
+ * Intra_mode = intra16x16_mode
+ * Else
+ * Intra_mode = intra4x4_mode
+ */
+#define TW5864_DSP_I4x4_OFFSET     0x040C
+
+/*
+ * [6:4]
+ * 0x5 Only 4x4
+ * 0x6 Only 16x16
+ * 0x7 16x16 & 4x4
+ */
+#define TW5864_DSP_INTRA_MODE      0x0410
+#define TW5864_DSP_INTRA_MODE_SHIFT     4
+#define TW5864_DSP_INTRA_MODE_MASK (7 << TW5864_DSP_INTRA_MODE_SHIFT)
+#define TW5864_DSP_INTRA_MODE_4x4 0x5
+#define TW5864_DSP_INTRA_MODE_16x16 0x6
+#define TW5864_DSP_INTRA_MODE_4x4_AND_16x16 0x7
+/*
+ * [5:0]
+ * WEIGHT Factor for I4x4 cost
+ * calculation (QP dependent)
+ */
+#define TW5864_DSP_I4x4_WEIGHT     0x0414
+
+/*
+ * [7:0]
+ * Offset used to affect Intra/ME model decision
+ * If (me_cost < intra_cost + dsp_resid_mode_offset)
+ * Pred_Mode = me_mode
+ * Else
+ * Pred_mode = intra_mode
+ */
+#define TW5864_DSP_RESID_MODE_OFFSET 0x0604
+
+/* 0x0800 ~ 0x09FF - Quantization TABLE Values */
+#define TW5864_QUAN_TAB            0x0800
+
+/* Valid channel value [0; f], frame value [0; 3] */
+#define TW5864_RT_CNTR_CH_FRM(channel, frame) \
+	(0x0C00 | (channel << 4) | (frame << 2))
+
+/*  */
+#define TW5864_FRAME_BUS1          0x0D00
+/*
+ * 1 Progressive in part A in bus n
+ * 0 Interlaced in part A in bus n
+ */
+#define TW5864_PROG_A            BIT(0)
+/*
+ * 1 Progressive in part B in bus n
+ * 0 Interlaced in part B in bus n
+ */
+#define TW5864_PROG_B            BIT(1)
+/*
+ * 1 Frame Mode in bus n
+ * 0 Field Mode in bus n
+ */
+#define TW5864_FRAME             BIT(2)
+/*
+ * 0 4CIF in bus n
+ * 1 1D1 + 4 CIF in bus n
+ * 2 2D1 in bus n
+ */
+#define TW5864_BUS_D1            (3 << 3)
+/* Bus 1 goes in TW5864_FRAME_BUS1 in [4:0] */
+/* Bus 2 goes in TW5864_FRAME_BUS1 in [12:8] */
+/*  */
+#define TW5864_FRAME_BUS2          0x0D04
+/* Bus 3 goes in TW5864_FRAME_BUS2 in [4:0] */
+/* Bus 4 goes in TW5864_FRAME_BUS2 in [12:8] */
+
+/* [15:0] Horizontal Mirror for channel n */
+#define TW5864_SENIF_HOR_MIR       0x0D08
+/* [15:0] Vertical Mirror for channel n */
+#define TW5864_SENIF_VER_MIR       0x0D0C
+
+/*
+ * FRAME_WIDTH_BUSn_A 0x15F: 4 CIF
+ *                    0x2CF: 1 D1 + 3 CIF
+ *                    0x2CF: 2 D1
+ * FRAME_WIDTH_BUSn_B 0x15F: 4 CIF
+ *                    0x2CF: 1 D1 + 3 CIF
+ *                    0x2CF: 2 D1
+ * FRAME_HEIGHT_BUSn_A 0x11F: 4CIF (PAL)
+ *                     0x23F: 1D1 + 3CIF (PAL)
+ *                     0x23F: 2 D1 (PAL)
+ *                     0x0EF: 4CIF (NTSC)
+ *                     0x1DF: 1D1 + 3CIF (NTSC)
+ *                     0x1DF: 2 D1 (NTSC)
+ * FRAME_HEIGHT_BUSn_B 0x11F: 4CIF (PAL)
+ *                     0x23F: 1D1 + 3CIF (PAL)
+ *                     0x23F: 2 D1 (PAL)
+ *                     0x0EF: 4CIF (NTSC)
+ *                     0x1DF: 1D1 + 3CIF (NTSC)
+ *                     0x1DF: 2 D1 (NTSC)
+ */
+#define TW5864_FRAME_WIDTH_BUS_A(bus)  (0x0D10 + 0x0010 * bus)
+#define TW5864_FRAME_WIDTH_BUS_B(bus)  (0x0D14 + 0x0010 * bus)
+#define TW5864_FRAME_HEIGHT_BUS_A(bus) (0x0D18 + 0x0010 * bus)
+#define TW5864_FRAME_HEIGHT_BUS_B(bus) (0x0D1C + 0x0010 * bus)
+
+/*
+ * 1: the bus mapped Channel n Full D1
+ * 0: the bus mapped Channel n Half D1
+ */
+#define TW5864_FULL_HALF_FLAG      0x0D50
+
+/*
+ * 0 The bus mapped Channel select
+ * partA Mode
+ * 1 The bus mapped Channel select
+ * partB Mode
+ */
+#define TW5864_FULL_HALF_MODE_SEL  0x0D54
+
+#define TW5864_VLC                 0x1000
+/* Define controls in register TW5864_VLC */
+/* QP Value used by H264 CAVLC */
+#define TW5864_VLC_SLICE_QP        0x003f
+/*
+ * Swap byte order of VLC stream in d-word.
+ * 1 Normal (VLC output= [31:0])
+ * 0 Swap (VLC output={[23:16],[31:24],[7:0], [15:8]})
+ */
+#define TW5864_VLC_BYTE_SWP      BIT(6)
+/* Enable Adding 03 circuit for VLC stream */
+#define TW5864_VLC_ADD03_EN      BIT(7)
+/* Number of bit for VLC bit Align */
+#define TW5864_VLC_BIT_ALIGN_SHIFT      8
+#define TW5864_VLC_BIT_ALIGN_MASK (0x1f << TW5864_VLC_BIT_ALIGN_SHIFT)
+/*
+ * Synchronous Interface select for VLC Stream
+ * 1 CDC_VLCS_MAS read VLC stream
+ * 0 CPU read VLC stream
+ */
+#define TW5864_VLC_INF_SEL      BIT(13)
+/* Enable VLC overflow control */
+#define TW5864_VLC_OVFL_CNTL    BIT(14)
+/*
+ * 1 PCI Master Mode
+ * 0 Non PCI Master Mode
+ */
+#define TW5864_VLC_PCI_SEL      BIT(15)
+/*
+ * 0 Enable Adding 03 to VLC header and stream
+ * 1 Disable Adding 03 to VLC header of "00000001"
+ */
+#define TW5864_VLC_A03_DISAB    BIT(16)
+/*
+ * Status of VLC stream in DDR (one bit for each buffer)
+ * 1 VLC is ready in buffer n (HW set)
+ * 0 VLC is not ready in buffer n (SW clear)
+ */
+#define TW5864_VLC_BUF_RDY_SHIFT       24
+#define TW5864_VLC_BUF_RDY_MASK (0xff << TW5864_VLC_BUF_RDY_SHIFT)
+
+/* Total number of bit in the slice */
+#define TW5864_SLICE_TOTAL_BIT     0x1004
+/* Total number of bit in the residue */
+#define TW5864_RES_TOTAL_BIT       0x1008
+
+#define TW5864_VLC_BUF             0x100C
+/* Define controls in register TW5864_VLC_BUF */
+/* VLC BK0 full status, write ‘1’ to clear */
+#define TW5864_VLC_BK0_FULL      BIT(0)
+/* VLC BK1 full status, write ‘1’ to clear */
+#define TW5864_VLC_BK1_FULL      BIT(1)
+/* VLC end slice status, write ‘1’ to clear */
+#define TW5864_VLC_END_SLICE     BIT(2)
+/* VLC Buffer overflow status, write ‘1’ to clear */
+#define TW5864_DSP_RD_OF         BIT(3)
+/* VLC string length in either buffer 0 or 1 at end of frame */
+#define TW5864_VLC_STREAM_LEN_SHIFT     4
+#define TW5864_VLC_STREAM_LEN_MASK (0x1ff << TW5864_VLC_STREAM_LEN_SHIFT)
+
+/* [15:0] Total coefficient number in a frame */
+#define TW5864_TOTAL_COEF_NO       0x1010
+/* [0] VLC Encoder Interrupt. Write ‘1’ to clear */
+#define TW5864_VLC_DSP_INTR        0x1014
+/* [31:0] VLC stream CRC checksum */
+#define TW5864_VLC_STREAM_CRC      0x1018
+
+#define TW5864_VLC_RD              0x101C
+/* Define controls in register TW5864_VLC_RD */
+/*
+ * 1 Read VLC lookup Memory
+ * 0 Read VLC Stream Memory
+ */
+#define TW5864_VLC_RD_MEM        BIT(0)
+/*
+ * 1 Read VLC Stream Memory in burst mode
+ * 0 Read VLC Stream Memory in single mode
+ */
+#define TW5864_VLC_RD_BRST       BIT(1)
+
+/* 0x2000 ~ 0x2FFC -- H264 Stream Memory Map */
+/*
+ * A word is 4 bytes. I.e.,
+ * VLC_STREAM_MEM[0] address: 0x2000
+ * VLC_STREAM_MEM[1] address: 0x2004
+ * ...
+ * VLC_STREAM_MEM[3FF] address: 0x2FFC
+ */
+#define TW5864_VLC_STREAM_MEM_START 0x2000
+#define TW5864_VLC_STREAM_MEM_MAX_OFFSET 0x3ff
+#define TW5864_VLC_STREAM_MEM(offset) (TW5864_VLC_STREAM_MEM_START + 4 * offset)
+
+/* 0x4000 ~ 0x4FFC -- Audio Register Map */
+/* [31:0] config 1ms cnt = Realtime clk/1000 */
+#define TW5864_CFG_1MS_CNT         0x4000
+
+#define TW5864_ADPCM               0x4004
+/* Define controls in register TW5864_ADPCM */
+/* ADPCM decoder enable */
+#define TW5864_ADPCM_DEC         BIT(0)
+/* ADPCM input data enable */
+#define TW5864_ADPCM_IN_DATA     BIT(1)
+/* ADPCM encoder enable */
+#define TW5864_ADPCM_ENC         BIT(2)
+
+#define TW5864_AUD                 0x4008
+/* Define controls in register TW5864_AUD */
+/*
+ * Record path PCM Audio enable bit
+ * for each channel
+ */
+#define TW5864_AUD_ORG_CH_EN       0x00ff
+/* Speaker path PCM Audio Enable */
+#define TW5864_SPK_ORG_EN       BIT(16)
+/*
+ * 0 16bit
+ * 1 8bit
+ */
+#define TW5864_AD_BIT_MODE      BIT(17)
+#define TW5864_AUD_TYPE_SHIFT          18
+/*
+ * 0 PCM
+ * 3 ADPCM
+ */
+#define TW5864_AUD_TYPE (0xf << TW5864_AUD_TYPE_SHIFT)
+#define TW5864_AUD_SAMPLE_RATE_SHIFT   22
+/*
+ * 0 8K
+ * 1 16K
+ */
+#define TW5864_AUD_SAMPLE_RATE (3 << TW5864_AUD_SAMPLE_RATE_SHIFT)
+/* Channel ID used to select audio channel (0 to 16) for loopback */
+#define TW5864_TESTLOOP_CHID_SHIFT     24
+#define TW5864_TESTLOOP_CHID (0x1f << TW5864_TESTLOOP_CHID_SHIFT)
+/* Enable AD Loopback Test */
+#define TW5864_TEST_ADLOOP_EN   BIT(30)
+/*
+ * 0 Asynchronous Mode or PCI target mode
+ * 1 PCI Initiator Mode
+ */
+#define TW5864_AUD_MODE         BIT(31)
+
+#define TW5864_AUD_ADPCM           0x400C
+/* Define controls in register TW5864_AUD_ADPCM */
+/*
+ * Record path ADPCM audio channel
+ * enable, one bit for each
+ */
+#define TW5864_AUD_ADPCM_CH_EN     0x00ff
+/* Speaker path ADPCM audio channel enable */
+#define TW5864_SPK_ADPCM_EN     BIT(16)
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
+#define TW5864_ADPCM_ENC_XX_MASK   0x3fff
+#define TW5864_ADPCM_ENC_XX_PTR2_SHIFT 30
+/* ADPCM_ENC_WR_PTR[29:0] */
+#define TW5864_ADPCM_ENC_WR_PTR1   0x401C
+/* ADPCM_ENC_WR_PTR[50:30] */
+#define TW5864_ADPCM_ENC_WR_PTR2   0x4020
+
+/* ADPCM_ENC_RD_PTR[29:0] */
+#define TW5864_ADPCM_ENC_RD_PTR1   0x4024
+/* ADPCM_ENC_RD_PTR[50:30] */
+#define TW5864_ADPCM_ENC_RD_PTR2   0x4028
+
+/*
+ * [3:0] rd ch0, [7:4] rd ch1,
+ * [11:8] wr ch0, [15:12] wr ch1
+ */
+#define TW5864_ADPCM_DEC_RD_WR_PTR 0x402C
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
+#define TW5864_AD_ORIG_WR_PTR1     0x4030
+/* AD_ORIG_WR_PTR[63:32] */
+#define TW5864_AD_ORIG_WR_PTR2     0x4034
+/* AD_ORIG_WR_PTR[67:64] */
+#define TW5864_AD_ORIG_WR_PTR3     0x4038
+
+/* AD_ORIG_RD_PTR[31:0] */
+#define TW5864_AD_ORIG_RD_PTR1     0x403C
+/* AD_ORIG_RD_PTR[63:32] */
+#define TW5864_AD_ORIG_RD_PTR2     0x4040
+/* AD_ORIG_RD_PTR[67:64] */
+#define TW5864_AD_ORIG_RD_PTR3     0x4044
+
+#define TW5864_PC_BLOCK_ORIG_RD_NO 0x4048
+#define TW5864_PC_BLOCK_ORIG_RD_NO_MASK 0x1f
+
+#define TW5864_PCI_AUD             0x404C
+/* Define controls in register TW5864_PCI_AUD */
+/*
+ * The register is applicable to PCI
+ * initiator mode only. Used to
+ * select PCM(0) or ADPCM(1) audio
+ * data sent to PC. One bit for each
+ * channel
+ */
+#define TW5864_PCI_DATA_SEL        0xffff
+/*
+ * Audio flow control mode selection bit.
+ * 0 Flow control disabled. TW5864
+ * continuously sends audio frame to
+ * PC (initiator mode)
+ * 1 Flow control enabled
+ */
+#define TW5864_PCI_FLOW_EN      BIT(16)
+/*
+ * When PCI_FLOW_EN is set, PCI need
+ * to toggle this bit to send an
+ * audio frame to PC. One toggle to
+ * send one frame.
+ */
+#define TW5864_PCI_AUD_FRM_EN   BIT(17)
+
+/* [1:0] CS valid to data valid CLK cycles when writing operation */
+#define TW5864_CS2DAT_CNT          0x8000
+/* [2:0] Data valid signal width by system clock cycles */
+#define TW5864_DATA_VLD_WIDTH      0x8004
+
+#define TW5864_SYNC                0x8008
+/* Define controls in register TW5864_SYNC */
+/*
+ * 0 vlc stream to syncrous port
+ * 1 vlc stream to ddr buffers
+ */
+#define TW5864_SYNC_CFG          BIT(7)
+/*
+ * 0 SYNC Address sampled on Rising edge
+ * 1 SYNC Address sampled on Falling edge
+ */
+#define TW5864_SYNC_ADR_EDGE     BIT(0)
+#define TW5864_VLC_STR_DELAY_SHIFT      1
+/*
+ * 0 No system delay
+ * 1 One system clock delay
+ * 2 Two system clock delay
+ * 3 Three system clock delay
+ */
+#define TW5864_VLC_STR_DELAY     (3 << TW5864_VLC_STR_DELAY_SHIFT)
+/*
+ * 0 Rising edge output
+ * 1 Falling edge output
+ */
+#define TW5864_VLC_OUT_EDGE      BIT(3)
+
+/*
+ * [1:0]
+ * 2’b00 phase set to 180 degree
+ * 2’b01 phase set to 270 degree
+ * 2’b10 phase set to 0 degree
+ * 2’b11 phase set to 90 degree
+ */
+#define TW5864_I2C_PHASE_CFG       0x800C
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
+#define TW5864_SYSPLL1             0x8018
+/* Define controls in register TW5864_SYSPLL1 */
+#define TW5864_SYSPLL_M_LOW        0x00ff
+
+/* [2:0]: SYSPLL_M[10:8], [7:3]: SYSPLL_N[4:0] */
+#define TW5864_SYSPLL2             0x8019
+/* Define controls in register TW5864_SYSPLL2 */
+#define TW5864_SYSPLL_M_HI           0x07
+#define TW5864_SYSPLL_N_LOW_SHIFT       3
+#define TW5864_SYSPLL_N_LOW (0x1f << TW5864_SYSPLL_N_LOW_SHIFT)
+
+/*
+ * [1:0]: SYSPLL_N[6:5], [3:2]: SYSPLL_P, [4]: SYSPLL_IREF,
+ * [7:5]: SYSPLL_CP_SEL
+ */
+#define TW5864_SYSPLL3             0x8020
+/* Define controls in register TW5864_SYSPLL3 */
+#define TW5864_SYSPLL_N_HI           0x03
+#define TW5864_SYSPLL_P_SHIFT           2
+#define TW5864_SYSPLL_P (0x03 << TW5864_SYSPLL_P_SHIFT)
+/*
+ * SYSPLL bias current control
+ * 0 Lower current (default)
+ * 1 30% higher current
+ */
+#define TW5864_SYSPLL_IREF       BIT(4)
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
+#define TW5864_SYSPLL_CP_SEL_SHIFT      5
+#define TW5864_SYSPLL_CP_SEL (0x07 << TW5864_SYSPLL_CP_SEL_SHIFT)
+
+/*
+ * [1:0]: SYSPLL_VCO, [3:2]: SYSPLL_LP_X8, [5:4]: SYSPLL_ICP_SEL, [6]:
+ * SYSPLL_LPF_5PF, [7]: SYSPLL_ED_SEL
+ */
+#define TW5864_SYSPLL4             0x8021
+/* Define controls in register TW5864_SYSPLL4 */
+/*
+ * SYSPLL_VCO VCO Range selection
+ * 00 5 ~ 75 MHz
+ * 01 50 ~ 140 MHz
+ * 10 110 ~ 320 MHz
+ * 11 270 ~ 700 MHz
+ */
+#define TW5864_SYSPLL_VCO            0x03
+#define TW5864_SYSPLL_LP_X8_SHIFT       2
+/*
+ * Loop resister
+ * 0 38.5K ohms
+ * 1 6.6K ohms (default)
+ * 2 2.2K ohms
+ * 3 1.1K ohms
+ */
+#define TW5864_SYSPLL_LP_X8 (0x03 << TW5864_SYSPLL_LP_X8_SHIFT)
+#define TW5864_SYSPLL_ICP_SEL_SHIFT     4
+/*
+ * PLL charge pump fine tune
+ * 00 x1 (default)
+ * 01 x1/2
+ * 10 x1/7
+ * 11 x1/8
+ */
+#define TW5864_SYSPLL_ICP_SEL (0x03 << TW5864_SYSPLL_ICP_SEL_SHIFT)
+/*
+ * PLL low pass filter phase margin adjustment
+ * 0 no 5pF (default)
+ * 1 5pF added
+ */
+#define TW5864_SYSPLL_LPF_5PF    BIT(6)
+/*
+ * PFD select edge for detection
+ * 0 Falling edge (default)
+ * 1 Rising edge
+ */
+#define TW5864_SYSPLL_ED_SEL     BIT(7)
+
+/* [0]: SYSPLL_RST, [4]: SYSPLL_PD */
+#define TW5864_SYSPLL5             0x8024
+/* Define controls in register TW5864_SYSPLL5 */
+/* Reset SYSPLL */
+#define TW5864_SYSPLL_RST        BIT(0)
+/* Power down SYSPLL */
+#define TW5864_SYSPLL_PD         BIT(4)
+
+#define TW5864_PLL_CFG             0x801C
+/* Define controls in register TW5864_PLL_CFG */
+/*
+ * Issue Soft Reset from Async Host Interface / PCI Interface clock domain.
+ * Become valid after sync to the xtal clock domain. This bit is set only if
+ * LOAD register bit is also set to 1.
+ */
+#define TW5864_SRST              BIT(0)
+/*
+ * Issue SYSPLL (166 MHz) configuration latch from Async host interface / PCI
+ * Interface clock domain. The configuration setting becomes effective only if
+ * LOAD register bit is also set to 1.
+ */
+#define TW5864_SYSPLL_CFG        BIT(2)
+/*
+ * Issue SPLL (108 MHz) configuration load from Async host interface / PCI
+ * Interface clock domain. The configuration setting becomes effective only if
+ * the LOAD register bit is also set to 1.
+ */
+#define TW5864_SPLL_CFG          BIT(4)
+/*
+ * Set this bit to latch the SRST, SYSPLL_CFG, SPLL_CFG setting into the xtal
+ * clock domain to restart the PLL. This bit is self cleared.
+ */
+#define TW5864_LOAD              BIT(3)
+
+/* SPLL_IREF, SPLL_LPX4, SPLL_CPX4, SPLL_PD, SPLL_DBG */
+#define TW5864_SPLL                0x8028
+
+/* 0x8800 ~ 0x88FC -- Interrupt Register Map */
+/*
+ * Trigger mode of interrupt source 0 ~ 15
+ * 1 Edge trigger mode
+ * 0 Level trigger mode
+ */
+#define TW5864_TRIGGER_MODE_L      0x8800
+/* Trigger mode of interrupt source 16 ~ 31 */
+#define TW5864_TRIGGER_MODE_H      0x8804
+/* Enable of interrupt source 0 ~ 15 */
+#define TW5864_INTR_ENABLE_L       0x8808
+/* Enable of interrupt source 16 ~ 31 */
+#define TW5864_INTR_ENABLE_H       0x880C
+/* Clear interrupt command of interrupt source 0 ~ 15 */
+#define TW5864_INTR_CLR_L          0x8810
+/* Clear interrupt command of interrupt source 16 ~ 31 */
+#define TW5864_INTR_CLR_H          0x8814
+/*
+ * Assertion of interrupt source 0 ~ 15
+ * 1 High level or pos-edge is assertion
+ * 0 Low level or neg-edge is assertion
+ */
+#define TW5864_INTR_ASSERT_L       0x8818
+/* Assertion of interrupt source 16 ~ 31 */
+#define TW5864_INTR_ASSERT_H       0x881C
+/*
+ * Output level of interrupt
+ * 1 Interrupt output is high assertion
+ * 0 Interrupt output is low assertion
+ */
+#define TW5864_INTR_OUT_LEVEL      0x8820
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
+#define TW5864_INTR_STATUS_L       0x8838
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
+#define TW5864_INTR_STATUS_H       0x883C
+
+/* Defines of interrupt bits, united for both low and high word registers */
+#define TW5864_INTR_VLC_RAM      BIT(0)
+#define TW5864_INTR_BURST        BIT(1)
+#define TW5864_INTR_MV_DSP       BIT(2)
+#define TW5864_INTR_VIN_LOST     BIT(3)
+/* n belongs to [0; 7] */
+#define TW5864_INTR_GPIO(n)      (1 << (4 + n))
+#define TW5864_INTR_JPEG        BIT(12)
+#define TW5864_INTR_VLC_DONE    BIT(17)
+#define TW5864_INTR_AD_VSYNC    BIT(19)
+#define TW5864_INTR_PV_EOF      BIT(20)
+#define TW5864_INTR_PV_OVERFLOW BIT(21)
+#define TW5864_INTR_TIMER       BIT(22)
+#define TW5864_INTR_AUD_EOF     BIT(24)
+#define TW5864_INTR_I2C_DONE    BIT(25)
+#define TW5864_INTR_AD          BIT(26)
+
+/* 0x9000 ~ 0x920C -- Video Capture (VIF) Register Map */
+/*
+ * H264EN_CH_STATUS[n] Status of
+ * Vsync synchronized H264EN_CH_EN
+ * (Read Only)
+ * 1 Channel Enabled
+ * 0 Channel Disabled
+ */
+#define TW5864_H264EN_CH_STATUS    0x9000
+/*
+ * [15:0] H264EN_CH_EN[n] H264
+ * Encoding Path Enable for channel
+ * 1 Channel Enabled
+ * 0 Channel Disabled
+ */
+#define TW5864_H264EN_CH_EN        0x9004
+/*
+ * H264EN_CH_DNS[n] H264 Encoding
+ * Path Downscale Video Decoder
+ * Input for channel n
+ * 1 Downscale Y to 1/2
+ * 0 Does not downscale
+ */
+#define TW5864_H264EN_CH_DNS       0x9008
+/*
+ * H264EN_CH_PROG[n] H264 Encoding
+ * Path channel n is progressive
+ * 1 Progressive (Not valid for TW5864)
+ * 0 Interlaced (TW5864 default)
+ */
+#define TW5864_H264EN_CH_PROG      0x900C
+/*
+ * [3:0] H264EN_BUS_MAX_CH[n]
+ * H264 Encoding Path maximum number
+ * of channel on BUS n
+ * 0 Max 4 channels
+ * 1 Max 2 channels
+ */
+#define TW5864_H264EN_BUS_MAX_CH   0x9010
+
+/*
+ * H264EN_RATE_MAX_LINE_n H264 Encoding path Rate Mapping Maximum Line Number
+ * on Bus n
+ */
+#define TW5864_H264EN_RATE_MAX_LINE_EVEN 0x1f
+#define TW5864_H264EN_RATE_MAX_LINE_ODD_SHIFT 5
+#define TW5864_H264EN_RATE_MAX_LINE_ODD \
+	(0x1f << TW5864_H264EN_RATE_MAX_LINE_ODD_SHIFT)
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
+#define TW5864_H264EN_CH_FMT_REG1  0x9020
+/*
+ * [1:0]: H264EN_CH8_FMT (?),
+ * ..., [15:14]: H264EN_CH15_FMT (?)
+ */
+#define TW5864_H264EN_CH_FMT_REG2  0x9024
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
+#define TW5864_H264EN_BUS0_MAP     0x9200
+#define TW5864_H264EN_BUS1_MAP     0x9204
+#define TW5864_H264EN_BUS2_MAP     0x9208
+#define TW5864_H264EN_BUS3_MAP     0x920C
+
+/* This register is not defined in datasheet, but used in reference driver */
+#define TW5864_UNDEFINED_ERROR_FLAGS_0x9218 0x9218
+
+#define TW5864_GPIO1               0x9800
+#define TW5864_GPIO2               0x9804
+/* Define controls in registers TW5864_GPIO1, TW5864_GPIO2 */
+/* GPIO DATA of Group n */
+#define TW5864_GPIO_DATA           0x00ff
+#define TW5864_GPIO_OEN_SHIFT           8
+/* GPIO Output Enable of Group n */
+#define TW5864_GPIO_OEN (0xff << TW5864_GPIO_OEN_SHIFT)
+
+/* 0xA000 ~ 0xA8FF – DDR Controller Register Map */
+/* DDR Controller A */
+/*
+ * [2:0] Data valid counter after
+ * read command to DDR. This is the
+ * delay value to show how many
+ * cycles the data will be back from
+ * DDR after we issue a read
+ * command.
+ */
+#define TW5864_RD_ACK_VLD_MUX      0xA000
+
+#define TW5864_DDR_PERIODS         0xA004
+/* Define controls in register TW5864_DDR_PERIODS */
+/*
+ * Tras value, the minimum cycle of
+ * active to precharge command
+ * period, default is 7
+ */
+#define TW5864_TRAS_CNT_MAX        0x000f
+/* Trfc value, the minimum cycle of refresh to active or refresh command
+ * period, default is 4"hf
+ */
+#define TW5864_RFC_CNT_MAX_SHIFT        8
+#define TW5864_RFC_CNT_MAX (0x0f << TW5864_RFC_CNT_MAX_SHIFT)
+/* Trcd value, the minimum cycle of active to internal read/write command
+ * period, default is 4"h2
+ */
+#define TW5864_TCD_CNT_MAX_SHIFT        4
+#define TW5864_TCD_CNT_MAX (0x0f << TW5864_TCD_CNT_MAX_SHIFT)
+/* Twr value, write recovery time, default is 4"h3 */
+#define TW5864_TWR_CNT_MAX_SHIFT       12
+#define TW5864_TWR_CNT_MAX (0x0f << TW5864_TWR_CNT_MAX_SHIFT)
+
+/*
+ * [2:0] CAS latency, the delay
+ * cycle between internal read
+ * command and the availability of
+ * the first bit of output data,
+ * default is 3
+ */
+#define TW5864_CAS_LATENCY         0xA008
+/*
+ * [15:0] Maximum average periodic
+ * refresh, the value is based on
+ * the current frequency to match
+ * 7.8mcs
+ */
+#define TW5864_DDR_REF_CNTR_MAX    0xA00C
+/*
+ * DDR_ON_CHIP_MAP [1:0] 0x0 256M DDR on board
+ * 0x1 512M DDR on board
+ * 0x2 1G DDR on board
+ * DDR_ON_CHIP_MAP [2] 0x0 Only one DDR chip
+ * 0x1 Two DDR chips
+ */
+#define TW5864_DDR_ON_CHIP_MAP     0xA01C
+#define TW5864_DDR_SELFTEST_MODE   0xA020
+/* Define controls in register TW5864_DDR_SELFTEST_MODE */
+/*
+ * 0 Common read/write mode
+ * 1 DDR self-test mode
+ */
+#define TW5864_MASTER_MODE       BIT(0)
+/*
+ * 0 DDR self-test single read/write
+ * 1 DDR self-test burst read/write
+ */
+#define TW5864_SINGLE_PROC       BIT(1)
+/*
+ * 0 DDR self-test write command
+ * 1 DDR self-test read command
+ */
+#define TW5864_WRITE_FLAG        BIT(2)
+#define TW5864_DATA_MODE_SHIFT          4
+/*
+ * 0x0 write 32'haaaa5555 to DDR
+ * 0x1 write 32'hffffffff to DDR
+ * 0x2 write 32'hha5a55a5a to DDR
+ * 0x3 write increasing data to DDR
+ */
+#define TW5864_DATA_MODE (0x3 << TW5864_DATA_MODE_SHIFT)
+
+/* [7:0] The maximum data of one burst in DDR self-test mode */
+#define TW5864_BURST_CNTR_MAX      0xA024
+/* [15:0] The maximum burst counter (bit 15~0) in DDR self-test mode */
+#define TW5864_DDR_PROC_CNTR_MAX_L 0xA028
+/* The maximum burst counter (bit 31~16) in DDR self-test mode */
+#define TW5864_DDR_PROC_CNTR_MAX_H 0xA02C
+/* [0]: Start one DDR self-test */
+#define TW5864_DDR_SELF_TEST_CMD   0xA030
+/* The maximum error counter (bit 15 ~ 0) in DDR self-test */
+#define TW5864_ERR_CNTR_L          0xA034
+
+#define TW5864_ERR_CNTR_H_AND_FLAG 0xA038
+/* Define controls in register TW5864_ERR_CNTR_H_AND_FLAG */
+/* The maximum error counter (bit 30 ~ 16) in DDR self-test */
+#define TW5864_ERR_CNTR_H_MASK     0x3fff
+/* DDR self-test end flag */
+#define TW5864_END_FLAG            0x8000
+
+/*
+ * DDR Controller B: same as 0xA000 ~ 0xA038,
+ * but add TW5864_DDR_B_OFFSET to all addresses
+ */
+#define TW5864_DDR_B_OFFSET        0x0800
+
+/* 0xB004 ~ 0xB018 – HW version/ARB12 Register Map */
+/* [15:0] Default is C013 */
+#define TW5864_HW_VERSION          0xB004
+
+#define TW5864_REQS_ENABLE         0xB010
+/* Define controls in register TW5864_REQS_ENABLE */
+/* Audio data in to DDR enable (default 1) */
+#define TW5864_AUD_DATA_IN_ENB   BIT(0)
+/* Audio encode request to DDR enable (default 1) */
+#define TW5864_AUD_ENC_REQ_ENB   BIT(1)
+/* Audio decode request0 to DDR enable (default 1) */
+#define TW5864_AUD_DEC_REQ0_ENB  BIT(2)
+/* Audio decode request1 to DDR enable (default 1) */
+#define TW5864_AUD_DEC_REQ1_ENB  BIT(3)
+/* VLC stream request to DDR enable (default 1) */
+#define TW5864_VLC_STRM_REQ_ENB  BIT(4)
+/* H264 MV request to DDR enable (default 1) */
+#define TW5864_DVM_MV_REQ_ENB    BIT(5)
+/* mux_core MVD request to DDR enable (default 1) */
+#define TW5864_MVD_REQ_ENB       BIT(6)
+/* mux_core MVD temp data request to DDR enable (default 1) */
+#define TW5864_MVD_TMP_REQ_ENB   BIT(7)
+/* JPEG request to DDR enable (default 1) */
+#define TW5864_JPEG_REQ_ENB      BIT(8)
+/* mv_flag request to DDR enable (default 1) */
+#define TW5864_MV_FLAG_REQ_ENB   BIT(9)
+
+#define TW5864_ARB12               0xB018
+/* Define controls in register TW5864_ARB12 */
+/* ARB12 Enable (default 1) */
+#define TW5864_ARB12_ENB        BIT(15)
+/* ARB12 maximum value of time out counter (default 15"h1FF) */
+#define TW5864_ARB12_TIME_OUT_CNT  0x7fff
+
+/* 0xB800 ~ 0xB80C -- Indirect Access Register Map */
+/*
+ * In order to access the indirect register space,
+ * the following procedure is followed.
+ *
+ * Write Registers:
+ * (1) Write IND_DATA at 0xB804 ~ 0xB807
+ * (2) Read BUSY flag from 0xB803. Wait until BUSY signal is 0.
+ * (3) Write IND_ADDR at 0xB800 ~ 0xB801. Set R/W to "1", ENABLE to "1"
+ * Read Registers:
+ * (1) Read BUSY flag from 0xB803. Wait until BUSY signal is 0.
+ * (2) Write IND_ADDR at 0xB800 ~ 0xB801. Set R/W to "0", ENABLE to "1"
+ * (3) Read BUSY flag from 0xB803. Wait until BUSY signal is 0.
+ * (4) Read IND_DATA from 0xB804 ~ 0xB807
+ */
+#define TW5864_IND_CTL             0xB800
+/* Define controls in register TW5864_IND_CTL */
+/* Address used to access indirect register space */
+#define TW5864_IND_ADDR        0x0000ffff
+/* Wait until this bit is "0" before using indirect access */
+#define TW5864_BUSY             BIT(31)
+/* Activate the indirect access. This bit is self cleared */
+#define TW5864_ENABLE           BIT(25)
+/* Read/Write command */
+#define TW5864_RW               BIT(24)
+
+/* [31:0] Data used to read/write indirect register space */
+#define TW5864_IND_DATA            0xB804
+
+/* 0xC000 ~ 0xC7FC -- Preview Register Map */
+/* Mostly skipped this section. */
+/*
+ * [15:0] Status of Vsync Synchronized PCI_PV_CH_EN (Read Only)
+ * 1 Channel Enabled
+ * 0 Channel Disabled
+ */
+#define TW5864_PCI_PV_CH_STATUS    0xC000
+/*
+ * [15:0] PCI Preview Path Enable for channel n
+ * 1 Channel Enable
+ * 0 Channel Disable
+ */
+#define TW5864_PCI_PV_CH_EN       0xC004
+
+/* 0xC800 ~ 0xC804 -- JPEG Capture Register Map */
+/* Skipped. */
+/* 0xD000 ~ 0xD0FC -- JPEG Control Register Map */
+/* Skipped. */
+
+/* 0xE000 ~ 0xFC04 – Motion Vector Register Map */
+
+/* ME Motion Vector data (Four Byte Each) 0xE000 ~ 0xE7FC */
+#define TW5864_ME_MV_VEC_START     0xE000
+#define TW5864_ME_MV_VEC_MAX_OFFSET 0x1ff
+#define TW5864_ME_MV_VEC(offset) (TW5864_ME_MV_VEC_START + 4 * offset)
+
+#define TW5864_MV                  0xFC00
+/* Define controls in register TW5864_MV */
+/* mv bank0 full status , write "1" to clear */
+#define TW5864_MV_BK0_FULL       BIT(0)
+/* mv bank1 full status , write "1" to clear */
+#define TW5864_MV_BK1_FULL       BIT(1)
+/* slice end status; write "1" to clear */
+#define TW5864_MV_EOF            BIT(2)
+/* mv encode interrupt status; write "1" to clear */
+#define TW5864_MV_DSP_INTR       BIT(3)
+/* mv write memory overflow, write "1" to clear */
+#define TW5864_DSP_WR_OF         BIT(4)
+#define TW5864_MV_LEN_SHIFT             5
+/* mv stream length */
+#define TW5864_MV_LEN (0xff << TW5864_MV_LEN_SHIFT)
+/* The configured status bit written into bit 15 of 0xFC04 */
+#define TW5864_MPI_DDR_SEL      BIT(13)
+
+#define TW5864_MPI_DDR_SEL_REG     0xFC04
+/* Define controls in register TW5864_MPI_DDR_SEL_REG */
+/*
+ * SW configure register
+ * 0 MV is saved in internal DPR
+ * 1 MV is saved in DDR
+ */
+#define TW5864_MPI_DDR_SEL2     BIT(15)
+
+/* 0x18000 ~ 0x181FC – PCI Master/Slave Control Map */
+#define TW5864_PCI_INTR_STATUS    0x18000
+/* Define controls in register TW5864_PCI_INTR_STATUS */
+/* vlc done */
+#define TW5864_VLC_DONE_INTR     BIT(1)
+/* ad vsync */
+#define TW5864_AD_VSYNC_INTR     BIT(3)
+/* preview eof */
+#define TW5864_PREV_EOF_INTR     BIT(4)
+/* preview overflow interrupt */
+#define TW5864_PREV_OVERFLOW_INTR BIT(5)
+/* timer interrupt */
+#define TW5864_TIMER_INTR        BIT(6)
+/* audio eof */
+#define TW5864_AUDIO_EOF_INTR    BIT(8)
+/* IIC done */
+#define TW5864_IIC_DONE_INTR    BIT(24)
+/* ad interrupt (e.g.: video lost, video format changed) */
+#define TW5864_AD_INTR_REG      BIT(25)
+
+#define TW5864_PCI_INTR_CTL       0x18004
+/* Define controls in register TW5864_PCI_INTR_CTL */
+/* master enable */
+#define TW5864_PCI_MAST_ENB      BIT(0)
+/* mvd&vlc master enable */
+#define TW5864_MVD_VLC_MAST_ENB      0x06
+/* (Need to set 0 in TW5864A) */
+#define TW5864_AD_MAST_ENB       BIT(3)
+/* preview master enable */
+#define TW5864_PREV_MAST_ENB     BIT(4)
+/* preview overflow enable */
+#define TW5864_PREV_OVERFLOW_ENB BIT(5)
+/* timer interrupt enable */
+#define TW5864_TIMER_INTR_ENB    BIT(6)
+/* JPEG master (push mode) enable */
+#define TW5864_JPEG_MAST_ENB     BIT(7)
+#define TW5864_AU_MAST_ENB_CHN_SHIFT    8
+/* audio master channel enable */
+#define TW5864_AU_MAST_ENB_CHN (0xffff << TW5864_AU_MAST_ENB_CHN_SHIFT)
+/* IIC interrupt enable */
+#define TW5864_IIC_INTR_ENB     BIT(24)
+/* ad interrupt enable */
+#define TW5864_AD_INTR_ENB      BIT(25)
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
+#define TW5864_PREV_AND_AU_INTR   0x18008
+/* Define controls in register TW5864_PREV_AND_AU_INTR */
+/* preview eof interrupt flag */
+#define TW5864_PREV_INTR_REG   0x0000ffff
+#define TW5864_AU_INTR_REG_SHIFT       16
+/* audio eof interrupt flag */
+#define TW5864_AU_INTR_REG (0xffff << TW5864_AU_INTR_REG_SHIFT)
+
+#define TW5864_MASTER_ENB_REG     0x1800C
+/* Define controls in register TW5864_MASTER_ENB_REG */
+/* master enable */
+#define TW5864_PCI_VLC_INTR_ENB  BIT(1)
+/* mvd and vlc master enable */
+#define TW5864_PCI_PREV_INTR_ENB BIT(4)
+/* ad vsync master enable */
+#define TW5864_PCI_PREV_OF_INTR_ENB BIT(5)
+/* jpeg master enable */
+#define TW5864_PCI_JPEG_INTR_ENB  BIT(7)
+/* preview master enable */
+#define TW5864_PCI_AUD_INTR_ENB  BIT(8)
+
+/*
+ * Every channel of preview and audio have ping-pong buffers in system memory,
+ * this register is the buffer flag to notify software which buffer is been
+ * operated.
+ */
+#define TW5864_PREV_AND_AU_BUF_FLAG 0x18010
+/* Define controls in register TW5864_PREV_AND_AU_BUF_FLAG */
+/* preview buffer A/B flag */
+#define TW5864_PREV_BUF_FLAG       0xffff
+#define TW5864_AUDIO_BUF_FLAG_SHIFT    16
+/* audio buffer A/B flag */
+#define TW5864_AUDIO_BUF_FLAG (0xffff << TW5864_AUDIO_BUF_FLAG_SHIFT)
+
+#define TW5864_IIC                0x18014
+/* Define controls in register TW5864_IIC */
+/* register data */
+#define TW5864_IIC_DATA            0x00ff
+#define TW5864_IIC_REG_ADDR_SHIFT       8
+/* register addr */
+#define TW5864_IIC_REG_ADDR (0xff << TW5864_IIC_REG_ADDR_SHIFT)
+/* rd/wr flag rd=1,wr=0 */
+#define TW5864_IIC_RW           BIT(16)
+#define TW5864_IIC_DEV_ADDR_SHIFT      17
+/* device addr */
+#define TW5864_IIC_DEV_ADDR (0x7f << TW5864_IIC_DEV_ADDR_SHIFT)
+/*
+ * iic done, software kick off one time iic transaction through setting this
+ * bit to 1. Then poll this bit, value 1 indicate iic transaction have
+ * completed, if read, valid data have been stored in iic_data
+ */
+#define TW5864_IIC_DONE         BIT(24)
+
+#define TW5864_RST_AND_IF_INFO    0x18018
+/* Define controls in register TW5864_RST_AND_IF_INFO */
+/* application software soft reset */
+#define TW5864_APP_SOFT_RST      BIT(0)
+#define TW5864_PCI_INF_VERSION_SHIFT 16
+/* PCI interface version, read only */
+#define TW5864_PCI_INF_VERSION (0xffff << TW5864_PCI_INF_VERSION_SHIFT)
+
+/* vlc stream crc value, it is calculated in pci module */
+#define TW5864_VLC_CRC_REG        0x1801C
+/*
+ * vlc max length, it is defined by software based on software assign
+ * memory space for vlc
+ */
+#define TW5864_VLC_MAX_LENGTH     0x18020
+/* vlc length of one frame */
+#define TW5864_VLC_LENGTH         0x18024
+/* vlc original crc value */
+#define TW5864_VLC_INTRA_CRC_I_REG 0x18028
+/* vlc original crc value */
+#define TW5864_VLC_INTRA_CRC_O_REG 0x1802C
+/* mv stream crc value, it is calculated in pci module */
+#define TW5864_VLC_PAR_CRC_REG    0x18030
+/* mv length */
+#define TW5864_VLC_PAR_LENGTH_REG 0x18034
+/* mv original crc value */
+#define TW5864_VLC_PAR_I_REG      0x18038
+/* mv original crc value */
+#define TW5864_VLC_PAR_O_REG      0x1803C
+
+/*
+ * Configuration register for 9[or 10] CIFs or 1D1+15QCIF Preview mode.
+ * PREV_PCI_ENB_CHN[0] Enable 9th preview channel (9CIF prev)
+ * or 1D1 channel in (1D1+15QCIF prev)
+ * PREV_PCI_ENB_CHN[1] Enable 10th preview channel
+ */
+#define TW5864_PREV_PCI_ENB_CHN   0x18040
+/* Description skipped. */
+#define TW5864_PREV_FRAME_FORMAT_IN 0x18044
+/* IIC enable */
+#define TW5864_IIC_ENB            0x18048
+/*
+ * Timer interrupt interval
+ * 0 1ms
+ * 1 2ms
+ * 2 4ms
+ * 3 8ms
+ */
+#define TW5864_PCI_INTTM_SCALE    0x1804C
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
+/* 0x180C0 ~ 0x180DC – JPEG Push Mode Buffer Base Address. Skipped. */
+/* 0x18100 – 0x1817c: preview burst base address. Skipped. */
+
+/* 0x80000 ~ 0x87FFF -- DDR Burst RW Register Map */
+#define TW5864_DDR_CTL            0x80000
+/* Define controls in register TW5864_DDR_CTL */
+#define TW5864_BRST_LENGTH_SHIFT        2
+/* Length of 32-bit data burst */
+#define TW5864_BRST_LENGTH (0x3fff << TW5864_BRST_LENGTH_SHIFT)
+/*
+ * Burst Read/Write
+ * 0 Read Burst from DDR
+ * 1 Write Burst to DDR
+ */
+#define TW5864_BRST_RW          BIT(16)
+/* Begin a new DDR Burst. This bit is self cleared */
+#define TW5864_NEW_BRST_CMD     BIT(17)
+/* DDR Burst End Flag */
+#define TW5864_BRST_END         BIT(24)
+/* Enable Error Interrupt for Single DDR Access */
+#define TW5864_SING_ERR_INTR    BIT(25)
+/* Enable Error Interrupt for Burst DDR Access */
+#define TW5864_BRST_ERR_INTR    BIT(26)
+/* Enable Interrupt for End of DDR Burst Access */
+#define TW5864_BRST_END_INTR    BIT(27)
+/* DDR Single Access Error Flag */
+#define TW5864_SINGLE_ERR       BIT(28)
+/* DDR Single Access Busy Flag */
+#define TW5864_SINGLE_BUSY      BIT(29)
+/* DDR Burst Access Error Flag */
+#define TW5864_BRST_ERR         BIT(30)
+/* DDR Burst Access Busy Flag */
+#define TW5864_BRST_BUSY        BIT(31)
+
+/* [27:0] DDR Access Address. Bit [1:0] has to be 0 */
+#define TW5864_DDR_ADDR           0x80004
+/* DDR Access Internal Buffer Address. Bit [1:0] has to be 0 */
+#define TW5864_DPR_BUF_ADDR       0x80008
+/* SRAM Buffer MPI Access Space. Totally 16 KB */
+#define TW5864_DPR_BUF_START      0x84000
+/* 0x84000 - 0x87FFC */
+#define TW5864_DPR_BUF_SIZE        0x4000
+
+/* Indirect Map Space */
+/*
+ * The indirect space is accessed through 0xB800 ~ 0xB807 registers in direct
+ * access space
+ */
+/* Analog Video / Audio Decoder / Encoder */
+/* Allowed channel values: [0; 3] */
+/* Read-only register */
+#define TW5864_INDIR_VIN_0(channel) (0x000 + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_0 */
+/*
+ * 1 Video not present. (sync is not detected in number of
+ * consecutive line periods specified by MISSCNT register)
+ * 0 Video detected.
+ */
+#define TW5864_INDIR_VIN_0_VDLOSS BIT(7)
+/*
+ * 1 Horizontal sync PLL is locked to the incoming video
+ * source.
+ * 0 Horizontal sync PLL is not locked.
+ */
+#define TW5864_INDIR_VIN_0_HLOCK  BIT(6)
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
+ * The actual vertical scanning frequency depends on the current
+ * standard invoked.
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
+#define TW5864_INDIR_VIN_6_HACTIVE_XY_HI \
+	(0x03 << TW5864_INDIR_VIN_6_HACTIVE_XY_HI_SHIFT)
+#define TW5864_INDIR_VIN_6_VDELAY_XY_HI BIT(4)
+#define TW5864_INDIR_VIN_6_VACTIVE_XY_HI BIT(5)
+
+/*
+ * HDELAY_XY This 10bit register defines the starting location of horizontal
+ * active pixel for display / record path. A unit is 1 pixel. The default value
+ * is 0x00F for NTSC and 0x00A for PAL.
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
+#define TW5864_INDIR_VIN_8_CTI (0x03 << TW5864_INDIR_VIN_8_CTI_SHIFT)
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
+#define TW5864_INDIR_VIN_A_BRIGHT(channel) (0x00A + channel * 0x010)
+
+/*
+ * These bits control the digital gain adjustment to the U (or Cb) component of
+ * the digital video signal. The color saturation can be adjusted by adjusting
+ * the U and V color gain components by the same amount in the normal
+ * situation. The U and V can also be adjusted independently to provide greater
+ * flexibility. The range of adjustment is 0 to 200%. A value of 128 (80h) has
+ * gain of 100%. The default is 80h.
+ */
+#define TW5864_INDIR_VIN_B_SAT_U(channel) (0x00B + channel * 0x010)
+
+/*
+ * These bits control the digital gain adjustment to the V (or Cr) component of
+ * the digital video signal. The color saturation can be adjusted by adjusting
+ * the U and V color gain components by the same amount in the normal
+ * situation. The U and V can also be adjusted independently to provide greater
+ * flexibility. The range of adjustment is 0 to 200%. A value of 128 (80h) has
+ * gain of 100%. The default is 80h.
+ */
+#define TW5864_INDIR_VIN_C_SAT_V(channel) (0x00C + channel * 0x010)
+
+/* Read-only */
+#define TW5864_INDIR_VIN_D(channel) (0x00D + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_D */
+/* Macrovision color stripe detection may be un-reliable */
+#define TW5864_INDIR_VIN_D_CSBAD BIT(3)
+/* Macrovision AGC pulse detected */
+#define TW5864_INDIR_VIN_D_MCVSN BIT(2)
+/* Macrovision color stripe protection burst detected */
+#define TW5864_INDIR_VIN_D_CSTRIPE BIT(1)
+/*
+ * This bit is valid only when color stripe protection is detected, i.e.
+ * if CSTRIPE=1,
+ * 1 Type 2 color stripe protection
+ * 0 Type 3 color stripe protection
+ */
+#define TW5864_INDIR_VIN_D_CTYPE2 BIT(0)
+
+/* Read-only */
+#define TW5864_INDIR_VIN_E(channel) (0x00E + channel * 0x010)
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
+#define TW5864_INDIR_VIN_E_STDNOW (0x07 << TW5864_INDIR_VIN_E_STDNOW_SHIFT)
+
+/*
+ * 1 Disable the shadow registers
+ * 0 Enable VACTIVE and HDELAY shadow registers value
+ * depending on STANDARD. (Default)
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
+#define TW5864_INDIR_VIN_F(channel) (0x00F + channel * 0x010)
+/* Define controls in register TW5864_INDIR_VIN_F */
+/*
+ * 1 Writing 1 to this bit will manually initiate the auto format
+ * detection process. This bit is a self-clearing bit
+ * 0 Manual initiation of auto format detection is done.
+ * (Default)
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
+#define TW5864_INDIR_AIN_0x06D 0x06D
+/* Define controls in register TW5864_INDIR_AIN_0x06D */
+/*
+ * LAWMD Select u-Law/A-Law/PCM/SB data output format on ADATR and ADATM pin.
+ * 0 PCM output (default)
+ * 1 SB (Signed MSB bit in PCM data is inverted) output
+ * 2 u-Law output
+ * 3 A-Law output
+ */
+#define TW5864_INDIR_AIN_LAWMD_SHIFT 6
+#define TW5864_INDIR_AIN_LAWMD (0x03 << TW5864_INDIR_AIN_LAWMD_SHIFT)
+/*
+ * Disable the mixing ratio value for all audio.
+ * 0 Apply individual mixing ratio value for each audio
+ * (default)
+ * 1 Apply nominal value for all audio commonly
+ */
+#define TW5864_INDIR_AIN_MIX_DERATIO BIT(5)
+/* Enable the mute function for audio channel AINn when n is 0 to 3. It effects
+ * only for mixing. When n = 4, it enable the mute function of the playback
+ * audio input. It effects only for single chip or the last stage chip
+ * 0 Normal
+ * 1 Muted (default)
+ */
+#define TW5864_INDIR_AIN_MIX_MUTE 0x1f
+
+/* Some registers skipped */
+
+#define TW5864_INDIR_AIN_0x0E3 0x0E3
+/* Define controls in register TW5864_INDIR_AIN_0x0E3 */
+/*
+ * ADATP signal is coming from external ADPCM decoder, instead
+ * of on-chip ADPCM decoder
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
+#define TW5864_INDIR_AIN_0x0E4 0x0E4
+/* Define controls in register TW5864_INDIR_AIN_0x0ED */
+/*
+ * 8bit I2S Record output mode.
+ * 0 L/R half length separated output (Default).
+ * 1 One continuous packed output equal to DSP output
+ * format.
+ */
+#define TW5864_INDIR_AIN_0x0E4_I2S8MODE BIT(7)
+/*
+ * Audio Clock Master ACLKR output wave format.
+ * 0 High periods is one 27MHz clock period (default).
+ * 1 Almost duty 50-50% clock output on ACLKR pin. If this
+ * mode is selected, two times bigger number value need
+ * to be set up on the ACKI register. If AFAUTO=1, ACKI
+ * control is automatically set up even if MASCKMD=1.
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
+ * 0 No delay (Default).This is for I2S type 1T delay input
+ * interface.
+ * 1 Add 1 ACLKP clock delay in ADATP input data. This is
+ * for left-justified type 0T delay input interface.
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
+#define TW5864_INDIR_AIN_A5DETENA 0x0E5
+
+/* Some registers skipped */
+
+/*
+ * [7:3]: DEV_ID The TW5864 product ID code is 01000
+ * [2:0]: REV_ID The revision number is 0h
+ */
+#define TW5864_INDIR_ID 0x0FE
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
+/* 0x2D0~0x2D7: [63:0] bits */
+#define TW5864_INDIR_INTERRUPT1 0x2D0
+/* 0x2E0~0x2E3: [95:64] bits */
+#define TW5864_INDIR_INTERRUPT2 0x2E0
+
+/*
+ * Interrupt mask register for interrupts in 0x2D0 ~ 0x2D7
+ * 15:0 Motion detection interrupt for channel 0 ~ 15
+ * 31:16 Night detection interrupt for channel 0 ~ 15
+ * 47:32 Blind detection interrupt for channel 0 ~ 15
+ * 63:48 No video interrupt for channel 0 ~ 15
+ * 79:64 Line mode underflow interrupt for channel 0 ~ 15
+ * 95:80 Line mode overflow interrupt for channel 0 ~ 15
+ */
+/* 0x2D8~0x2DF: [63:0] bits */
+#define TW5864_INDIR_INTERRUPT_MASK1 0x2D8
+/* 0x2E8~0x2EB: [95:64] bits */
+#define TW5864_INDIR_INTERRUPT_MASK2 0x2E8
+
+/* [11:0]: Interrupt summary register for interrupts & interrupt mask from in
+ * 0x2D0 ~ 0x2D7 and 0x2D8 ~ 0x2DF
+ * bit 0: interrupt occurs in 0x2D0 & 0x2D8
+ * bit 1: interrupt occurs in 0x2D1 & 0x2D9
+ * bit 2: interrupt occurs in 0x2D2 & 0x2DA
+ * bit 3: interrupt occurs in 0x2D3 & 0x2DB
+ * bit 4: interrupt occurs in 0x2D4 & 0x2DC
+ * bit 5: interrupt occurs in 0x2D5 & 0x2DD
+ * bit 6: interrupt occurs in 0x2D6 & 0x2DE
+ * bit 7: interrupt occurs in 0x2D7 & 0x2DF
+ * bit 8: interrupt occurs in 0x2E0 & 0x2E8
+ * bit 9: interrupt occurs in 0x2E1 & 0x2E9
+ * bit 10: interrupt occurs in 0x2E2 & 0x2EA
+ * bit 11: interrupt occurs in 0x2E3 & 0x2EB
+ */
+#define TW5864_INDIR_INTERRUPT_SUMMARY 0x2F0
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
+#define TW5864_INDIR_DETECTION_CTL1_MD_TMPSENS \
+	(0x0f << TW5864_INDIR_DETECTION_CTL1_MD_TMPSENS_SHIFT)
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
+#define TW5864_INDIR_DETECTION_CTL2_MD_FIELD \
+	(0x03 << TW5864_INDIR_DETECTION_CTL2_MD_FIELD_SHIFT)
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
+#define TW5864_INDIR_DETECTION_CTL3_MD_CELSENS \
+	(0x03 << TW5864_INDIR_DETECTION_CTL3_MD_CELSENS_SHIFT)
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
+#define TW5864_INDIR_DETECTION_CTL4_MD_SPSENS \
+	(0x0f << TW5864_INDIR_DETECTION_CTL4_MD_SPSENS_SHIFT)
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
+#define TW5864_INDIR_DETECTION_CTL5_ND_TMPSENS \
+	(0x0f << TW5864_INDIR_DETECTION_CTL5_ND_TMPSENS_SHIFT)
+/*
+ * Define the threshold of level for night detection.
+ * 0 Low threshold (More sensitive) (default)
+ * : :
+ * 3 High threshold (Less sensitive)
+ */
+#define TW5864_INDIR_DETECTION_CTL5_ND_LVSENS 0x0f
+
+/*
+ * [11:0] The base address of the motion detection buffer. This address is
+ * in unit of 64K bytes. The generated DDR address will be
+ * {MD_BASE_ADDR, 16"h0000}. The default value should be
+ * 12"h000
+ */
+#define TW5864_INDIR_MD_BASE_ADDR 0x380
+
+/* This controls the channel of the motion detection result shown in register
+ * 0x3A0 ~ 0x3B7. Before reading back motion result, always set this first.
+ */
+#define TW5864_INDIR_RGR_MOTION_SEL 0x382
+
+/* [15:0] MD strobe has been performed at channel n (read only) */
+#define TW5864_INDIR_MD_STRB 0x386
+/* NO_VIDEO Detected from channel n (read only) */
+#define TW5864_INDIR_NOVID_DET 0x388
+/* Motion Detected from channel n (read only) */
+#define TW5864_INDIR_MD_DET 0x38A
+/* Blind Detected from channel n (read only) */
+#define TW5864_INDIR_BD_DET 0x38C
+/* Night Detected from channel n (read only) */
+#define TW5864_INDIR_ND_DET 0x38E
+
+/* 192 bit motion flag of the channel specified by
+ * RGR_MOTION_SEL in 0x382
+ */
+#define TW5864_INDIR_MOTION_FLAG 0x3A0
+#define TW5864_INDIR_MOTION_FLAG_BYTE_COUNT 24
+
+/*
+ * [9:0] The motion cell count of a
+ * specific channel selected by 0x382.
+ * This is for DI purpose
+ */
+#define TW5864_INDIR_MD_DI_CNT 0x3B8
+/* The motion detection cell sensitivity for DI purpose */
+#define TW5864_INDIR_MD_DI_CELLSENS 0x3BA
+/* The motion detection threshold level for DI purpose */
+#define TW5864_INDIR_MD_DI_LVSENS 0x3BB
+
+/* 192 bit motion mask of the channel specified by MASK_CH_SEL in 0x3FE */
+#define TW5864_INDIR_MOTION_MASK 0x3E0
+#define TW5864_INDIR_MOTION_MASK_BYTE_COUNT 24
+
+/* [4:0] The channel selection to access masks in 0x3E0 ~ 0x3F7 */
+#define TW5864_INDIR_MASK_CH_SEL 0x3FE
+
+/* Clock PLL / Analog IP Control */
+/* Some registers skipped */
+
+#define TW5864_INDIR_DDRA_DLL_DQS_SEL0 0xEE6
+#define TW5864_INDIR_DDRA_DLL_DQS_SEL1 0xEE7
+#define TW5864_INDIR_DDRA_DLL_CLK90_SEL 0xEE8
+#define TW5864_INDIR_DDRA_DLL_TEST_SEL_AND_TAP_S 0xEE9
+
+#define TW5864_INDIR_DDRB_DLL_DQS_SEL0 0xEEB
+#define TW5864_INDIR_DDRB_DLL_DQS_SEL1 0xEEC
+#define TW5864_INDIR_DDRB_DLL_CLK90_SEL 0xEED
+#define TW5864_INDIR_DDRB_DLL_TEST_SEL_AND_TAP_S 0xEEE
+
+#define TW5864_INDIR_RESET 0xEF0
+#define TW5864_INDIR_RESET_VD BIT(7)
+#define TW5864_INDIR_RESET_DLL BIT(6)
+#define TW5864_INDIR_RESET_MUX_CORE BIT(5)
+
+#define TW5864_INDIR_PV_VD_CK_POL 0xEFD
+#define TW5864_INDIR_PV_VD_CK_POL_PV(channel) BIT(channel)
+#define TW5864_INDIR_PV_VD_CK_POL_VD(channel) BIT(channel + 4)
+
+#define TW5864_INDIR_CLK0_SEL 0xEFE
+#define TW5864_INDIR_CLK0_SEL_VD_SHIFT 0
+#define TW5864_INDIR_CLK0_SEL_VD_MASK (0x3 << TW5864_INDIR_CLK0_SEL_VD_SHIFT)
+#define TW5864_INDIR_CLK0_SEL_PV_SHIFT 2
+#define TW5864_INDIR_CLK0_SEL_PV_MASK (0x3 << TW5864_INDIR_CLK0_SEL_PV_SHIFT)
+#define TW5864_INDIR_CLK0_SEL_PV2_SHIFT 4
+#define TW5864_INDIR_CLK0_SEL_PV2_MASK (0x3 << TW5864_INDIR_CLK0_SEL_PV2_SHIFT)
diff --git a/drivers/staging/media/tw5864/tw5864-tables.h b/drivers/staging/media/tw5864/tw5864-tables.h
new file mode 100644
index 0000000..3a3e0ad
--- /dev/null
+++ b/drivers/staging/media/tw5864/tw5864-tables.h
@@ -0,0 +1,237 @@
+/*
+ *  TW5864 driver - precomputed tables
+ *
+ *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
+#define QUANTIZATION_TABLE_LEN 96
+#define VLC_LOOKUP_TABLE_LEN 1024
+
+static const u16 forward_quantization_table[QUANTIZATION_TABLE_LEN] = {
+	0x3333, 0x1f82, 0x3333, 0x1F82, 0x1F82, 0x147B, 0x1F82, 0x147B, 0x3333,
+	0x1F82,
+	0x3333, 0x1F82, 0x1F82, 0x147B, 0x1F82, 0x147B, 0x2E8C, 0x1D42, 0x2E8C,
+	0x1D42,
+	0x1D42, 0x1234, 0x1D42, 0x1234, 0x2E8C, 0x1D42, 0x2E8C, 0x1D42, 0x1D42,
+	0x1234,
+	0x1D42, 0x1234, 0x2762, 0x199A, 0x2762, 0x199A, 0x199A, 0x1062, 0x199A,
+	0x1062,
+	0x2762, 0x199A, 0x2762, 0x199A, 0x199A, 0x1062, 0x199A, 0x1062, 0x2492,
+	0x16C1,
+	0x2492, 0x16C1, 0x16C1, 0x0E3F, 0x16C1, 0x0E3F, 0x2492, 0x16C1, 0x2492,
+	0x16C1,
+	0x16C1, 0x0E3F, 0x16C1, 0x0E3F, 0x2000, 0x147B, 0x2000, 0x147B, 0x147B,
+	0x0D1B,
+	0x147B, 0x0D1B, 0x2000, 0x147B, 0x2000, 0x147B, 0x147B, 0x0D1B, 0x147B,
+	0x0D1B,
+	0x1C72, 0x11CF, 0x1C72, 0x11CF, 0x11CF, 0x0B4D, 0x11CF, 0x0B4D, 0x1C72,
+	0x11CF,
+	0x1C72, 0x11CF, 0x11CF, 0x0B4D, 0x11CF, 0x0B4D
+};
+
+static const u16 inverse_quantization_table[QUANTIZATION_TABLE_LEN] = {
+	0x800A, 0x800D, 0x800A, 0x800D, 0x800D, 0x8010, 0x800D, 0x8010, 0x800A,
+	0x800D,
+	0x800A, 0x800D, 0x800D, 0x8010, 0x800D, 0x8010, 0x800B, 0x800E, 0x800B,
+	0x800E,
+	0x800E, 0x8012, 0x800E, 0x8012, 0x800B, 0x800E, 0x800B, 0x800E, 0x800E,
+	0x8012,
+	0x800E, 0x8012, 0x800D, 0x8010, 0x800D, 0x8010, 0x8010, 0x8014, 0x8010,
+	0x8014,
+	0x800D, 0x8010, 0x800D, 0x8010, 0x8010, 0x8014, 0x8010, 0x8014, 0x800E,
+	0x8012,
+	0x800E, 0x8012, 0x8012, 0x8017, 0x8012, 0x8017, 0x800E, 0x8012, 0x800E,
+	0x8012,
+	0x8012, 0x8017, 0x8012, 0x8017, 0x8010, 0x8014, 0x8010, 0x8014, 0x8014,
+	0x8019,
+	0x8014, 0x8019, 0x8010, 0x8014, 0x8010, 0x8014, 0x8014, 0x8019, 0x8014,
+	0x8019,
+	0x8012, 0x8017, 0x8012, 0x8017, 0x8017, 0x801D, 0x8017, 0x801D, 0x8012,
+	0x8017,
+	0x8012, 0x8017, 0x8017, 0x801D, 0x8017, 0x801D
+};
+
+static const u16 encoder_vlc_lookup_table[VLC_LOOKUP_TABLE_LEN] = {
+	0x011, 0x000, 0x000, 0x000, 0x065, 0x021, 0x000, 0x000, 0x087, 0x064,
+	0x031, 0x000,
+	0x097, 0x086, 0x075, 0x053, 0x0a7, 0x096, 0x085, 0x063, 0x0b7, 0x0a6,
+	0x095, 0x074,
+	0x0df, 0x0b6, 0x0a5, 0x084, 0x0db, 0x0de, 0x0b5, 0x094, 0x0d8, 0x0da,
+	0x0dd, 0x0a4,
+	0x0ef, 0x0ee, 0x0d9, 0x0b4, 0x0eb, 0x0ea, 0x0ed, 0x0dc, 0x0ff, 0x0fe,
+	0x0e9, 0x0ec,
+	0x0fb, 0x0fa, 0x0fd, 0x0e8, 0x10f, 0x0f1, 0x0f9, 0x0fc, 0x10b, 0x10e,
+	0x10d, 0x0f8,
+	0x107, 0x10a, 0x109, 0x10c, 0x104, 0x106, 0x105, 0x108, 0x023, 0x000,
+	0x000, 0x000,
+	0x06b, 0x022, 0x000, 0x000, 0x067, 0x057, 0x033, 0x000, 0x077, 0x06a,
+	0x069, 0x045,
+	0x087, 0x066, 0x065, 0x044, 0x084, 0x076, 0x075, 0x056, 0x097, 0x086,
+	0x085, 0x068,
+	0x0bf, 0x096, 0x095, 0x064, 0x0bb, 0x0be, 0x0bd, 0x074, 0x0cf, 0x0ba,
+	0x0b9, 0x094,
+	0x0cb, 0x0ce, 0x0cd, 0x0bc, 0x0c8, 0x0ca, 0x0c9, 0x0b8, 0x0df, 0x0de,
+	0x0dd, 0x0cc,
+	0x0db, 0x0da, 0x0d9, 0x0dc, 0x0d7, 0x0eb, 0x0d6, 0x0d8, 0x0e9, 0x0e8,
+	0x0ea, 0x0d1,
+	0x0e7, 0x0e6, 0x0e5, 0x0e4, 0x04f, 0x000, 0x000, 0x000, 0x06f, 0x04e,
+	0x000, 0x000,
+	0x06b, 0x05f, 0x04d, 0x000, 0x068, 0x05c, 0x05e, 0x04c, 0x07f, 0x05a,
+	0x05b, 0x04b,
+	0x07b, 0x058, 0x059, 0x04a, 0x079, 0x06e, 0x06d, 0x049, 0x078, 0x06a,
+	0x069, 0x048,
+	0x08f, 0x07e, 0x07d, 0x05d, 0x08b, 0x08e, 0x07a, 0x06c, 0x09f, 0x08a,
+	0x08d, 0x07c,
+	0x09b, 0x09e, 0x089, 0x08c, 0x098, 0x09a, 0x09d, 0x088, 0x0ad, 0x097,
+	0x099, 0x09c,
+	0x0a9, 0x0ac, 0x0ab, 0x0aa, 0x0a5, 0x0a8, 0x0a7, 0x0a6, 0x0a1, 0x0a4,
+	0x0a3, 0x0a2,
+	0x021, 0x000, 0x000, 0x000, 0x067, 0x011, 0x000, 0x000, 0x064, 0x066,
+	0x031, 0x000,
+	0x063, 0x073, 0x072, 0x065, 0x062, 0x083, 0x082, 0x070, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x011, 0x010, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x011, 0x021, 0x020, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x023, 0x022,
+	0x021, 0x020,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x023, 0x022, 0x021, 0x031, 0x030, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x023, 0x022, 0x033, 0x032, 0x031, 0x030,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x023, 0x030,
+	0x031, 0x033,
+	0x032, 0x035, 0x034, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x037, 0x036, 0x035, 0x034, 0x033, 0x032, 0x031, 0x041, 0x051, 0x061,
+	0x071, 0x081,
+	0x091, 0x0a1, 0x0b1, 0x000, 0x002, 0x000, 0x0e4, 0x011, 0x0f4, 0x002,
+	0x024, 0x003,
+	0x005, 0x012, 0x034, 0x013, 0x065, 0x024, 0x013, 0x063, 0x015, 0x022,
+	0x075, 0x034,
+	0x044, 0x023, 0x023, 0x073, 0x054, 0x033, 0x033, 0x004, 0x043, 0x014,
+	0x011, 0x043,
+	0x014, 0x001, 0x025, 0x015, 0x035, 0x025, 0x064, 0x055, 0x045, 0x035,
+	0x074, 0x065,
+	0x085, 0x0d5, 0x012, 0x095, 0x055, 0x045, 0x095, 0x0e5, 0x084, 0x075,
+	0x022, 0x0a5,
+	0x094, 0x085, 0x032, 0x0b5, 0x003, 0x0c5, 0x001, 0x044, 0x0a5, 0x032,
+	0x0b5, 0x094,
+	0x0c5, 0x0a4, 0x0a4, 0x054, 0x0d5, 0x0b4, 0x0b4, 0x064, 0x0f5, 0x0f5,
+	0x053, 0x0d4,
+	0x0e5, 0x0c4, 0x105, 0x105, 0x0c4, 0x074, 0x063, 0x0e4, 0x0d4, 0x084,
+	0x073, 0x0f4,
+	0x004, 0x005, 0x000, 0x053, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x011, 0x021, 0x031, 0x030, 0x011, 0x021,
+	0x020, 0x000,
+	0x011, 0x010, 0x000, 0x000, 0x011, 0x033, 0x032, 0x043, 0x042, 0x053,
+	0x052, 0x063,
+	0x062, 0x073, 0x072, 0x083, 0x082, 0x093, 0x092, 0x091, 0x037, 0x036,
+	0x035, 0x034,
+	0x033, 0x045, 0x044, 0x043, 0x042, 0x053, 0x052, 0x063, 0x062, 0x061,
+	0x060, 0x000,
+	0x045, 0x037, 0x036, 0x035, 0x044, 0x043, 0x034, 0x033, 0x042, 0x053,
+	0x052, 0x061,
+	0x051, 0x060, 0x000, 0x000, 0x053, 0x037, 0x045, 0x044, 0x036, 0x035,
+	0x034, 0x043,
+	0x033, 0x042, 0x052, 0x051, 0x050, 0x000, 0x000, 0x000, 0x045, 0x044,
+	0x043, 0x037,
+	0x036, 0x035, 0x034, 0x033, 0x042, 0x051, 0x041, 0x050, 0x000, 0x000,
+	0x000, 0x000,
+	0x061, 0x051, 0x037, 0x036, 0x035, 0x034, 0x033, 0x032, 0x041, 0x031,
+	0x060, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x061, 0x051, 0x035, 0x034, 0x033, 0x023,
+	0x032, 0x041,
+	0x031, 0x060, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x061, 0x041,
+	0x051, 0x033,
+	0x023, 0x022, 0x032, 0x031, 0x060, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x061, 0x060, 0x041, 0x023, 0x022, 0x031, 0x021, 0x051, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x051, 0x050, 0x031, 0x023, 0x022, 0x021,
+	0x041, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x040, 0x041,
+	0x031, 0x032,
+	0x011, 0x033, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x040, 0x041, 0x021, 0x011, 0x031, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x030, 0x031, 0x011, 0x021, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x020, 0x021,
+	0x011, 0x000,
+	0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x010, 0x011, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000, 0x000,
+	0x000, 0x000,
+	0x000, 0x000, 0x000, 0x000
+};
diff --git a/drivers/staging/media/tw5864/tw5864-video.c b/drivers/staging/media/tw5864/tw5864-video.c
new file mode 100644
index 0000000..71b79df
--- /dev/null
+++ b/drivers/staging/media/tw5864/tw5864-video.c
@@ -0,0 +1,1364 @@
+/*
+ *  TW5864 driver - video encoding functions
+ *
+ *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
+#include "tw5864-tables.h"
+
+static void tw5864_handle_frame_task(unsigned long data);
+static void tw5864_handle_frame(struct tw5864_h264_frame *frame);
+static void tw5864_frame_interval_set(struct tw5864_input *input);
+
+static int tw5864_queue_setup(struct vb2_queue *q,
+			      unsigned int *num_buffers,
+			      unsigned int *num_planes, unsigned int sizes[],
+			      void *alloc_ctxs[])
+{
+	struct tw5864_input *dev = vb2_get_drv_priv(q);
+
+	if (q->num_buffers + *num_buffers < 12)
+		*num_buffers = 12 - q->num_buffers;
+
+	alloc_ctxs[0] = dev->alloc_ctx;
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
+	u8 indir_0x00e = tw_indir_readb(dev,
+					0x00e + input->input_number * 0x010);
+	std = (indir_0x00e & 0x70) >> 4;
+
+	if (indir_0x00e & 0x80) {
+		dev_err(&dev->pci->dev,
+			"Video format detection is in progress, please wait\n");
+		return -EAGAIN;
+	}
+
+	if (std == STD_INVALID) {
+		dev_err(&dev->pci->dev, "No valid video format detected\n");
+		return -1;
+	}
+
+	*std_arg = std;
+	return 0;
+}
+
+static int tw5864_enable_input(struct tw5864_input *input)
+{
+	struct tw5864_dev *dev = input->root;
+	int input_number = input->input_number;
+	unsigned long flags;
+	int ret;
+	int d1_width = 720;
+	int d1_height;
+	int frame_width_bus_value = 0;
+	int frame_height_bus_value = 0;
+	int reg_frame_bus = 0x1c;
+	int fmt_reg_value = 0;
+	int downscale_enabled = 0;
+
+	dev_dbg(&dev->pci->dev, "Enabling channel %d\n", input_number);
+
+	ret = tw5864_input_std_get(input, &input->std);
+	if (ret)
+		return ret;
+	input->v4l2_std = tw5864_get_v4l2_std(input->std);
+
+	input->frame_seqno = 0;
+	input->h264_idr_pic_id = 0;
+	input->h264_frame_seqno_in_gop = 0;
+
+	input->reg_dsp_qp = input->qp;
+	input->reg_dsp_ref_mvp_lambda = lambda_lookup_table[input->qp];
+	input->reg_dsp_i4x4_weight = intra4x4_lambda3[input->qp];
+	input->reg_emu = TW5864_EMU_EN_LPF | TW5864_EMU_EN_BHOST
+		| TW5864_EMU_EN_SEN | TW5864_EMU_EN_ME | TW5864_EMU_EN_DDR;
+	input->reg_dsp = input_number /* channel id */
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
+		tw_setl(TW5864_FULL_HALF_FLAG, 1 << input_number);
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
+		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << input_number);
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
+		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << input_number);
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
+		tw_clearl(TW5864_FULL_HALF_FLAG, 1 << input_number);
+		break;
+	}
+
+	/* analog input width / 4 */
+	tw_indir_writeb(dev, TW5864_INDIR_IN_PIC_WIDTH(input_number),
+			d1_width / 4);
+	tw_indir_writeb(dev, TW5864_INDIR_IN_PIC_HEIGHT(input_number),
+			d1_height / 4);
+
+	/* output width / 4 */
+	tw_indir_writeb(dev, TW5864_INDIR_OUT_PIC_WIDTH(input_number),
+			input->width / 4);
+	tw_indir_writeb(dev, TW5864_INDIR_OUT_PIC_HEIGHT(input_number),
+			input->height / 4);
+
+	tw_writel(TW5864_DSP_PIC_MAX_MB,
+		  ((input->width / 16) << 8) | (input->height / 16));
+
+	tw_writel(TW5864_FRAME_WIDTH_BUS_A(input_number),
+		  frame_width_bus_value);
+	tw_writel(TW5864_FRAME_WIDTH_BUS_B(input_number),
+		  frame_width_bus_value);
+	tw_writel(TW5864_FRAME_HEIGHT_BUS_A(input_number),
+		  frame_height_bus_value);
+	tw_writel(TW5864_FRAME_HEIGHT_BUS_B(input_number),
+		  (frame_height_bus_value + 1) / 2 - 1);
+
+	tw5864_frame_interval_set(input);
+
+	if (downscale_enabled)
+		tw_setl(TW5864_H264EN_CH_DNS, 1 << input_number);
+
+	tw_mask_shift_writel(TW5864_H264EN_CH_FMT_REG1, 0x3, 2 * input_number,
+			     fmt_reg_value);
+
+	tw_mask_shift_writel(
+			     (input_number < 2
+			      ? TW5864_H264EN_RATE_MAX_LINE_REG1
+			      : TW5864_H264EN_RATE_MAX_LINE_REG2),
+			     0x1f, 5 * (input_number % 2),
+			     input->std == STD_NTSC ? 29 : 24);
+
+	tw_mask_shift_writel((input_number < 2) ? TW5864_FRAME_BUS1 :
+			     TW5864_FRAME_BUS2, 0xff, (input_number % 2) * 8,
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
+	/* 16x16 */
+	tw_mask_shift_writel(TW5864_DSP_INTRA_MODE, TW5864_DSP_INTRA_MODE_MASK,
+			     TW5864_DSP_INTRA_MODE_SHIFT,
+			     TW5864_DSP_INTRA_MODE_16x16);
+
+	if (input->frame_seqno % input->gop == 0) {
+		/* Produce I-frame */
+		tw_writel(TW5864_MOTION_SEARCH_ETC, TW5864_INTRA_EN);
+		input->h264_frame_seqno_in_gop = 0;
+		input->h264_idr_pic_id++;
+		input->h264_idr_pic_id &= TW5864_DSP_REF_FRM;
+	} else {
+		/* Produce P-frame */
+		tw_writel(TW5864_MOTION_SEARCH_ETC,
+			  TW5864_INTRA_EN
+			  | TW5864_ME_EN
+			  | BIT(5) /* SRCH_OPT default */
+			 );
+		input->h264_frame_seqno_in_gop++;
+	}
+	tw5864_prepare_frame_headers(input);
+	tw_writel(TW5864_VLC,
+		  TW5864_VLC_PCI_SEL | ((input->tail_nb_bits + 24) <<
+					TW5864_VLC_BIT_ALIGN_SHIFT) |
+		  input->reg_dsp_qp);
+
+	enc_buf_id_new = tw_mask_shift_readl(TW5864_ENC_BUF_PTR_REC1, 0x3,
+					     2 * input->input_number);
+	tw_writel(TW5864_DSP_ENC_ORG_PTR_REG,
+		  ((enc_buf_id_new + 1) % 4) << TW5864_DSP_ENC_ORG_PTR_SHIFT);
+	tw_writel(TW5864_DSP_ENC_REC,
+		  (((enc_buf_id_new + 1) % 4) << 12) | (enc_buf_id_new & 0x3));
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
+	dev_dbg(&dev->pci->dev, "Disabling channel %d\n", input->input_number);
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
+
+	tw5864_enable_input(input);
+	return 0;
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
+		struct tw5864_buf *buf = container_of(input->active.next,
+						      struct tw5864_buf, list);
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
+		tw_indir_writeb(dev,
+				TW5864_INDIR_VIN_A_BRIGHT(input->input_number),
+				(u8)ctrl->val);
+		break;
+	case V4L2_CID_HUE:
+		tw_indir_writeb(dev,
+				TW5864_INDIR_VIN_7_HUE(input->input_number),
+				(u8)ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		tw_indir_writeb(dev,
+				TW5864_INDIR_VIN_9_CNTRST(input->input_number),
+				(u8)ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		tw_indir_writeb(dev,
+				TW5864_INDIR_VIN_B_SAT_U(input->input_number),
+				(u8)ctrl->val);
+		tw_indir_writeb(dev,
+				TW5864_INDIR_VIN_C_SAT_V(input->input_number),
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
+static int tw5864_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	enum tw5864_vid_std std;
+	int ret;
+
+	ret = tw5864_input_std_get(input, &std);
+	if (ret)
+		return ret;
+
+	f->fmt.pix.width = 720;
+	switch (std) {
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
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_H264;
+	f->fmt.pix.sizeimage = H264_VLC_BUF_SIZE;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+	return 0;
+}
+
+static int tw5864_enum_input(struct file *file, void *priv,
+			     struct v4l2_input *i)
+{
+	struct tw5864_input *dev = video_drvdata(file);
+
+	u8 indir_0x000 = tw_indir_readb(dev->root,
+			TW5864_INDIR_VIN_0(dev->input_number));
+	u8 indir_0x00d = tw_indir_readb(dev->root,
+			TW5864_INDIR_VIN_D(dev->input_number));
+	u8 v1 = indir_0x000;
+	u8 v2 = indir_0x00d;
+
+	if (i->index)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	snprintf(i->name, sizeof(i->name), "Encoder %d", dev->input_number);
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
+	struct tw5864_input *dev = video_drvdata(file);
+
+	strcpy(cap->driver, "tw5864");
+	snprintf(cap->card, sizeof(cap->card), "TW5864 Encoder %d",
+		 dev->input_number);
+	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->root->pci));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+		V4L2_CAP_STREAMING;
+
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int tw5864_g_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	enum tw5864_vid_std std;
+	int ret;
+
+	ret = tw5864_input_std_get(input, &std);
+	if (ret)
+		return ret;
+
+	*id = tw5864_get_v4l2_std(std);
+	return 0;
+}
+
+static int tw5864_s_std(struct file *file, void *priv, v4l2_std_id id)
+{
+	struct tw5864_input *input = video_drvdata(file);
+	enum tw5864_vid_std std;
+	int ret;
+
+	ret = tw5864_input_std_get(input, &std);
+	if (ret)
+		return ret;
+
+	/* Allow only if matches with currently detected */
+	if (id != tw5864_get_v4l2_std(std))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int tw5864_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	return tw5864_g_fmt_vid_cap(file, priv, f);
+}
+
+static int tw5864_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return tw5864_try_fmt_vid_cap(file, priv, f);
+}
+
+static int tw5864_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	if (f->index)
+		return -EINVAL;
+
+	f->pixelformat = V4L2_PIX_FMT_H264;
+	strcpy(f->description, "H.264");
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
+	 * For 1 FPS - 0x00000001
+	 * 00000000 00000000 00000000 00000001
+	 *
+	 * For 2 FPS - 0x00010001.
+	 * 00000000 00000001 00000000 00000001
+	 *
+	 * For 4 FPS - 0x01010101.
+	 * 00000001 00000001 00000001 00000001
+	 *
+	 * For 8 FPS - 0x11111111.
+	 * 00010001 00010001 00010001 00010001
+	 *
+	 * For 16 FPS - 0x55555555.
+	 * 01010101 01010101 01010101 01010101
+	 *
+	 * For 32 FPS (not reached - capped by 25/30 limit) - 0xffffffff.
+	 * 11111111 11111111 11111111 11111111
+	 *
+	 * Et cetera.
+	 */
+	struct tw5864_dev *dev = input->root;
+	u32 unary_framerate = 0;
+	int shift = 0;
+
+	for (shift = 0; shift <= 32; shift += input->frame_interval)
+		unary_framerate |= 0x00000001 << shift;
+
+	tw_writel(TW5864_H264EN_RATE_CNTL_LO_WORD(input->input_number, 0),
+		  unary_framerate >> 16);
+	tw_writel(TW5864_H264EN_RATE_CNTL_HI_WORD(input->input_number, 0),
+		  unary_framerate & 0xffff);
+}
+
+static int tw5864_frameinterval_get(struct tw5864_input *input,
+				    struct v4l2_fract *frameinterval)
+{
+	int ret;
+	enum tw5864_vid_std std;
+
+	ret = tw5864_input_std_get(input, &std);
+	if (ret)
+		return ret;
+
+	frameinterval->numerator = 1;
+
+	switch (std) {
+	case STD_NTSC:
+	case STD_SECAM:
+		frameinterval->denominator = 25;
+		break;
+	case STD_PAL:
+		frameinterval->denominator = 30;
+		break;
+	default:
+		WARN(1, "tw5864_frameinterval_get requested for unknown std %d\n",
+		     std);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int tw5864_enum_frameintervals(struct file *file, void *priv,
+				      struct v4l2_frmivalenum *fintv)
+{
+	struct tw5864_input *input = video_drvdata(file);
+
+	if (fintv->pixel_format != V4L2_PIX_FMT_H264)
+		return -EINVAL;
+	if (fintv->index)
+		return -EINVAL;
+
+	fintv->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+
+	return tw5864_frameinterval_get(input, &fintv->discrete);
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
+		dev_err(&input->root->pci->dev,
+			"weird timeperframe %u/%u, using current %u/%u\n",
+			t->numerator, t->denominator,
+			input->frame_interval, time_base.denominator);
+		t->numerator = input->frame_interval;
+		t->denominator = time_base.denominator;
+	} else if (t->denominator != time_base.denominator) {
+		t->numerator = t->numerator * time_base.denominator /
+			t->denominator;
+		t->denominator = time_base.denominator;
+	}
+
+	input->frame_interval = t->numerator;
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
+static const struct v4l2_ioctl_ops video_ioctl_ops = {
+	.vidioc_querycap = tw5864_querycap,
+	.vidioc_enum_fmt_vid_cap = tw5864_enum_fmt_vid_cap,
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_expbuf = vb2_ioctl_expbuf,
+	.vidioc_s_std = tw5864_s_std,
+	.vidioc_g_std = tw5864_g_std,
+	.vidioc_enum_input = tw5864_enum_input,
+	.vidioc_g_input = tw5864_g_input,
+	.vidioc_s_input = tw5864_s_input,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+	.vidioc_try_fmt_vid_cap = tw5864_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = tw5864_s_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = tw5864_g_fmt_vid_cap,
+	.vidioc_log_status = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = tw5864_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_enum_frameintervals = tw5864_enum_frameintervals,
+	.vidioc_s_parm = tw5864_s_parm,
+	.vidioc_g_parm = tw5864_g_parm,
+};
+
+static struct video_device tw5864_video_template = {
+	.name = "tw5864_video",
+	.fops = &video_fops,
+	.ioctl_ops = &video_ioctl_ops,
+	.release = video_device_release_empty,
+	.tvnorms = TW5864_NORMS,
+};
+
+/* The TW5864 uses 192 (16x12) detection cells in full screen for motion
+ * detection. Each detection cell is composed of 44 pixels and 20 lines for
+ * NTSC and 24 lines for PAL.
+ */
+#define MD_CELLS_HOR 16
+#define MD_CELLS_VERT 12
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
+static void tw5864_tables_upload(struct tw5864_dev *dev);
+
+int tw5864_video_init(struct tw5864_dev *dev, int *video_nr)
+{
+	int i;
+	int ret = -1;
+
+	for (i = 0; i < H264_BUF_CNT; i++) {
+		dev->h264_buf[i].vlc.addr =
+			dma_alloc_coherent(&dev->pci->dev, H264_VLC_BUF_SIZE,
+					   &dev->h264_buf[i].vlc.dma_addr,
+					   GFP_KERNEL | GFP_DMA32);
+		dev->h264_buf[i].mv.addr =
+			dma_alloc_coherent(&dev->pci->dev, H264_MV_BUF_SIZE,
+					   &dev->h264_buf[i].mv.dma_addr,
+					   GFP_KERNEL | GFP_DMA32);
+		if (!dev->h264_buf[i].vlc.addr || !dev->h264_buf[i].mv.addr) {
+			dev_err(&dev->pci->dev, "dma alloc & map fail\n");
+			ret = -ENOMEM;
+			goto dma_alloc_fail;
+		}
+	}
+
+	tw5864_tables_upload(dev);
+	tw5864_init_ad(dev);
+
+	/* Picture is distorted without this block */
+	/* use falling edge to sample 54M to 108M */
+	tw_indir_writeb(dev, TW5864_INDIR_VD_108_POL,
+			TW5864_INDIR_VD_108_POL_BOTH);
+	tw_indir_writeb(dev, TW5864_INDIR_CLK0_SEL, 0x00);
+
+	tw_indir_writeb(dev, TW5864_INDIR_DDRA_DLL_DQS_SEL0, 0x02);
+	tw_indir_writeb(dev, TW5864_INDIR_DDRA_DLL_DQS_SEL1, 0x02);
+	tw_indir_writeb(dev, TW5864_INDIR_DDRA_DLL_CLK90_SEL, 0x02);
+	tw_indir_writeb(dev, TW5864_INDIR_DDRB_DLL_DQS_SEL0, 0x02);
+	tw_indir_writeb(dev, TW5864_INDIR_DDRB_DLL_DQS_SEL1, 0x02);
+	tw_indir_writeb(dev, TW5864_INDIR_DDRB_DLL_CLK90_SEL, 0x02);
+
+	/* video input reset */
+	tw_indir_writeb(dev, TW5864_INDIR_RESET, 0);
+	tw_indir_writeb(dev, TW5864_INDIR_RESET, TW5864_INDIR_RESET_VD |
+			TW5864_INDIR_RESET_DLL | TW5864_INDIR_RESET_MUX_CORE);
+	mdelay(10);
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
+	tw_indir_writeb(dev, TW5864_INDIR_PV_VD_CK_POL,
+			TW5864_INDIR_PV_VD_CK_POL_VD(0) |
+			TW5864_INDIR_PV_VD_CK_POL_VD(1) |
+			TW5864_INDIR_PV_VD_CK_POL_VD(2) |
+			TW5864_INDIR_PV_VD_CK_POL_VD(3));
+
+	dev->h264_buf_r_index = 0;
+	dev->h264_buf_w_index = 0;
+	tw_writel(TW5864_VLC_STREAM_BASE_ADDR,
+		  dev->h264_buf[dev->h264_buf_w_index].vlc.dma_addr);
+	tw_writel(TW5864_MV_STREAM_BASE_ADDR,
+		  dev->h264_buf[dev->h264_buf_w_index].mv.dma_addr);
+
+	for (i = 0; i < TW5864_INPUTS; i++) {
+		tw_indir_writeb(dev, TW5864_INDIR_VIN_E(i), 0x07);
+		/* to initiate auto format recognition */
+		tw_indir_writeb(dev, TW5864_INDIR_VIN_F(i), 0xff);
+	}
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
+	tw_writel(TW5864_PCI_INTTM_SCALE, 3);
+
+	tw_writel(TW5864_INTERLACING, TW5864_DI_EN);
+	tw_writel(TW5864_MASTER_ENB_REG, TW5864_PCI_VLC_INTR_ENB);
+	tw_writel(TW5864_PCI_INTR_CTL,
+		  TW5864_TIMER_INTR_ENB | TW5864_PCI_MAST_ENB |
+		  TW5864_MVD_VLC_MAST_ENB);
+
+	dev->encoder_busy = 0;
+
+	dev->irqmask |= TW5864_INTR_VLC_DONE | TW5864_INTR_TIMER;
+	tw5864_irqmask_apply(dev);
+
+	tasklet_init(&dev->tasklet, tw5864_handle_frame_task,
+		     (unsigned long)dev);
+
+	for (i = 0; i < TW5864_INPUTS; i++) {
+		dev->inputs[i].root = dev;
+		dev->inputs[i].input_number = i;
+		ret = tw5864_video_input_init(&dev->inputs[i], video_nr[i]);
+		if (ret)
+			goto input_init_fail;
+	}
+
+	return 0;
+
+dma_alloc_fail:
+	for (i = 0; i < H264_BUF_CNT; i++) {
+		dma_free_coherent(&dev->pci->dev, H264_VLC_BUF_SIZE,
+				  dev->h264_buf[i].vlc.addr,
+				  dev->h264_buf[i].vlc.dma_addr);
+		dma_free_coherent(&dev->pci->dev, H264_MV_BUF_SIZE,
+				  dev->h264_buf[i].mv.addr,
+				  dev->h264_buf[i].mv.dma_addr);
+	}
+
+	i = TW5864_INPUTS;
+
+input_init_fail:
+	for (; i >= 0; i--)
+		tw5864_video_input_fini(&dev->inputs[i]);
+
+	tasklet_kill(&dev->tasklet);
+
+	return ret;
+}
+
+static int tw5864_video_input_init(struct tw5864_input *input, int video_nr)
+{
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
+	input->vidq.gfp_flags = __GFP_DMA32;
+	input->vidq.buf_struct_size = sizeof(struct tw5864_buf);
+	input->vidq.lock = &input->lock;
+	input->vidq.min_buffers_needed = 12;
+	ret = vb2_queue_init(&input->vidq);
+	if (ret)
+		goto vb2_q_init_fail;
+
+	input->vdev = tw5864_video_template;
+	input->vdev.v4l2_dev = &input->root->v4l2_dev;
+	input->vdev.lock = &input->lock;
+	input->vdev.queue = &input->vidq;
+	video_set_drvdata(&input->vdev, input);
+
+	/* Initialize the device control structures */
+	input->alloc_ctx = vb2_dma_contig_init_ctx(&input->root->pci->dev);
+	if (IS_ERR(input->alloc_ctx)) {
+		ret = PTR_ERR(input->alloc_ctx);
+		goto vb2_dma_contig_init_ctx_fail;
+	}
+
+	v4l2_ctrl_handler_init(hdl, 6);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0, 255, 1, 100);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_SATURATION, 0, 255, 1, 128);
+	/* NTSC only */
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops, V4L2_CID_HUE, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, &tw5864_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, GOP_SIZE);
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
+		goto v4l2_ctrl_fail;
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
+		goto v4l2_ctrl_fail;
+
+	dev_info(&input->root->pci->dev, "Registered video device %s\n",
+		 video_device_node_name(&input->vdev));
+
+	return 0;
+
+v4l2_ctrl_fail:
+	v4l2_ctrl_handler_free(hdl);
+	vb2_dma_contig_cleanup_ctx(input->alloc_ctx);
+vb2_dma_contig_init_ctx_fail:
+	vb2_queue_release(&input->vidq);
+vb2_q_init_fail:
+	mutex_destroy(&input->lock);
+
+	return ret;
+}
+
+static void tw5864_video_input_fini(struct tw5864_input *dev)
+{
+	video_unregister_device(&dev->vdev);
+	v4l2_ctrl_handler_free(&dev->hdl);
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
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
+	unsigned long dst_size;
+	size_t dst_space;
+	unsigned long flags;
+
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
+	dst_size = vb2_plane_size(&vb->vb.vb2_buf, 0);
+	dst_space = dst_size;
+
+	/*
+	 * Generate H264 headers:
+	 * If this is first frame, put SPS and PPS
+	 */
+	if (input->frame_seqno == 0)
+		tw5864_h264_put_stream_header(&dst, &dst_space, input->qp,
+					      input->width, input->height);
+
+	/* Put slice header */
+	sl_hdr = dst;
+	space_before_sl_hdr = dst_space;
+	tw5864_h264_put_slice_header(&dst, &dst_space, input->h264_idr_pic_id,
+				     input->h264_frame_seqno_in_gop,
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
+	unsigned int md_cells = MD_CELLS_HOR * MD_CELLS_VERT;
+
+#ifdef DEBUG
+	/* Stats */
+	unsigned int max = 0;
+	unsigned int min = UINT_MAX;
+	unsigned int sum = 0;
+	unsigned int cnt_above_thresh = 0;
+#endif
+
+	for (i = 0; i < md_cells; i++) {
+		const u16 thresh = input->md_threshold_grid_values[i];
+		const unsigned int metric = tw5864_md_metric_from_mvd(mv[i]);
+
+		if (metric > thresh)
+			detected = 1;
+
+#ifdef DEBUG
+		if (metric > thresh)
+			cnt_above_thresh++;
+		if (metric > max)
+			max = metric;
+		if (metric < min)
+			min = metric;
+		sum += metric;
+#else
+		if (detected)
+			break;
+#endif
+	}
+#ifdef DEBUG
+	dev_dbg(&input->root->pci->dev,
+		"input %d, frame md stats: min %u, max %u, avg %u, cells above threshold: %u\n",
+		input->input_number, min, max, sum / md_cells,
+		cnt_above_thresh);
+#endif
+	return detected;
+}
+
+#ifdef MD_DUMP
+static void tw5864_md_dump(struct tw5864_input *input)
+{
+	struct tw5864_dev *dev = input->root;
+	u32 *mv = (u32 *)dev->h264_mv_buf[dev->h264_buf_index].addr;
+	int offset = 0;
+	int i;
+
+	if (input->h264_frame_seqno_in_gop) {
+		offset = 0;
+		for (i = 0; i < MD_CELLS_VERT; i++) {
+			dev_dbg(&dev->pci->dev,
+				"MVD [%02d]: %08x %08x %08x %08x   %08x %08x %08x %08x   %08x %08x %08x %08x   %08x %08x %08x %08x\n",
+				i, mv[offset + 0], mv[offset + 1],
+				mv[offset + 2], mv[offset + 3], mv[offset + 4],
+				mv[offset + 5], mv[offset + 6], mv[offset + 7],
+				mv[offset + 8], mv[offset + 9], mv[offset + 10],
+				mv[offset + 11], mv[offset + 12],
+				mv[offset + 13], mv[offset + 14],
+				mv[offset + 15]
+			       );
+			offset += MD_CELLS_HOR;
+		}
+		offset = 0;
+		for (i = 0; i < MD_CELLS_VERT; i++) {
+			dev_dbg(&dev->pci->dev,
+				"MD heur [%02d]: % 2x % 2x % 2x % 2x   % 2x % 2x % 2x % 2x   % 2x % 2x % 2x % 2x   % 2x % 2x % 2x % 2x\n",
+				i, tw5864_md_metric_from_mvd(mv[offset + 0]),
+				tw5864_md_metric_from_mvd(mv[offset + 1]),
+				tw5864_md_metric_from_mvd(mv[offset + 2]),
+				tw5864_md_metric_from_mvd(mv[offset + 3]),
+				tw5864_md_metric_from_mvd(mv[offset + 4]),
+				tw5864_md_metric_from_mvd(mv[offset + 5]),
+				tw5864_md_metric_from_mvd(mv[offset + 6]),
+				tw5864_md_metric_from_mvd(mv[offset + 7]),
+				tw5864_md_metric_from_mvd(mv[offset + 8]),
+				tw5864_md_metric_from_mvd(mv[offset + 9]),
+				tw5864_md_metric_from_mvd(mv[offset + 10]),
+				tw5864_md_metric_from_mvd(mv[offset + 11]),
+				tw5864_md_metric_from_mvd(mv[offset + 12]),
+				tw5864_md_metric_from_mvd(mv[offset + 13]),
+				tw5864_md_metric_from_mvd(mv[offset + 14]),
+				tw5864_md_metric_from_mvd(mv[offset + 15])
+			       );
+			offset += MD_CELLS_HOR;
+		}
+	}
+}
+#endif
+
+static void tw5864_handle_frame_task(unsigned long data)
+{
+	struct tw5864_dev *dev = (struct tw5864_dev *)data;
+	unsigned long flags;
+	int batch_size = H264_BUF_CNT;
+
+	spin_lock_irqsave(&dev->slock, flags);
+	while (dev->h264_buf_r_index != dev->h264_buf_w_index && batch_size--) {
+		spin_unlock_irqrestore(&dev->slock, flags);
+		tw5864_handle_frame(&dev->h264_buf[dev->h264_buf_r_index]);
+		spin_lock_irqsave(&dev->slock, flags);
+
+		dev->h264_buf_r_index++;
+		dev->h264_buf_r_index %= H264_BUF_CNT;
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+#ifdef DEBUG
+static u32 checksum(u32 *data, int len)
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
+	struct tw5864_input *input = frame->input;
+	struct tw5864_dev *dev = input->root;
+	struct tw5864_buf *vb;
+	struct vb2_v4l2_buffer *v4l2_buf;
+	int frame_len = frame->vlc_len;
+	unsigned long dst_size;
+	unsigned long dst_space;
+	int skip_bytes = 3;
+	u8 *dst = input->buf_cur_ptr;
+	u8 tail_mask, vlc_mask = 0;
+	int i;
+	u8 vlc_first_byte = ((u8 *)(frame->vlc.addr + skip_bytes))[0];
+	unsigned long flags;
+
+#ifdef DEBUG
+	if (frame->checksum != checksum((u32 *)frame->vlc.addr, frame_len))
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
+	dst_size = vb2_plane_size(&vb->vb.vb2_buf, 0);
+
+	dst_space = input->buf_cur_space_left;
+	frame_len -= skip_bytes;
+	if (WARN_ON_ONCE(dst_space < frame_len)) {
+		dev_err_once(&dev->pci->dev,
+			     "Left space in vb2 buffer %lu is insufficient for frame length %d, writing truncated frame\n",
+			     dst_space, frame_len);
+		frame_len = dst_space;
+	}
+
+	for (i = 0; i < 8 - input->tail_nb_bits; i++)
+		vlc_mask |= 1 << i;
+	tail_mask = (~vlc_mask) & 0xff;
+
+	dst[0] = (input->tail & tail_mask) | (vlc_first_byte & vlc_mask);
+	skip_bytes++;
+	frame_len--;
+	dst++;
+	dst_space--;
+	memcpy(dst, frame->vlc.addr + skip_bytes, frame_len);
+	dst_space -= frame_len;
+	vb2_set_plane_payload(&vb->vb.vb2_buf, 0, dst_size - dst_space);
+
+	vb->vb.vb2_buf.timestamp = frame->timestamp;
+	v4l2_buf->field = V4L2_FIELD_NONE;
+	v4l2_buf->sequence = input->frame_seqno - 1;
+
+	/* Check for motion flags */
+	if (input->h264_frame_seqno_in_gop /* P-frame */ &&
+	    tw5864_is_motion_triggered(frame)) {
+		struct v4l2_event ev = {
+			.type = V4L2_EVENT_MOTION_DET,
+			.u.motion_det = {
+				.flags =
+					V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ,
+				.frame_sequence =
+					v4l2_buf->sequence,
+			},
+		};
+
+		v4l2_event_queue(&input->vdev, &ev);
+	}
+
+	vb2_buffer_done(&vb->vb.vb2_buf, VB2_BUF_STATE_DONE);
+
+#ifdef MD_DUMP
+	tw5864_md_dump(input);
+#endif
+}
+
+v4l2_std_id tw5864_get_v4l2_std(enum tw5864_vid_std std)
+{
+	switch (std) {
+	case STD_NTSC:
+		return V4L2_STD_NTSC_M;
+	case STD_PAL:
+		return V4L2_STD_PAL_B;
+	case STD_SECAM:
+		return V4L2_STD_SECAM_B;
+	case STD_INVALID:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+	return 0;
+}
+
+enum tw5864_vid_std tw5864_from_v4l2_std(v4l2_std_id v4l2_std)
+{
+	if (v4l2_std & V4L2_STD_NTSC)
+		return STD_NTSC;
+	if (v4l2_std & V4L2_STD_PAL)
+		return STD_PAL;
+	if (v4l2_std & V4L2_STD_SECAM)
+		return STD_SECAM;
+	WARN_ON_ONCE(1);
+	return STD_AUTO;
+}
+
+static void tw5864_tables_upload(struct tw5864_dev *dev)
+{
+	int i;
+
+	tw_writel(TW5864_VLC_RD, 0x1);
+	for (i = 0; i < VLC_LOOKUP_TABLE_LEN; i++) {
+		tw_writel((TW5864_VLC_STREAM_MEM_START + (i << 2)),
+			  encoder_vlc_lookup_table[i]);
+	}
+	tw_writel(TW5864_VLC_RD, 0x0);
+
+	for (i = 0; i < QUANTIZATION_TABLE_LEN; i++) {
+		tw_writel((TW5864_QUAN_TAB + (i << 2)),
+			  forward_quantization_table[i]);
+	}
+
+	for (i = 0; i < QUANTIZATION_TABLE_LEN; i++) {
+		tw_writel((TW5864_QUAN_TAB + (i << 2)),
+			  inverse_quantization_table[i]);
+	}
+}
diff --git a/drivers/staging/media/tw5864/tw5864.h b/drivers/staging/media/tw5864/tw5864.h
new file mode 100644
index 0000000..d140fee
--- /dev/null
+++ b/drivers/staging/media/tw5864/tw5864.h
@@ -0,0 +1,280 @@
+/*
+ *  TW5864 driver  - common header file
+ *
+ *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
+ *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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
+#include <linux/debugfs.h>
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
+#define TW5864_NORMS ( \
+		       V4L2_STD_NTSC  | V4L2_STD_PAL    | V4L2_STD_SECAM | \
+		       V4L2_STD_PAL_M | V4L2_STD_PAL_Nc | V4L2_STD_PAL_60)
+
+/* ----------------------------------------------------------- */
+/* static data                                                 */
+
+struct tw5864_tvnorm {
+	char *name;
+	v4l2_std_id id;
+
+	/* video decoder */
+	u32 sync_control;
+	u32 luma_control;
+	u32 chroma_ctrl1;
+	u32 chroma_gain;
+	u32 chroma_ctrl2;
+	u32 vgate_misc;
+
+	/* video scaler */
+	u32 h_delay;
+	u32 h_start;
+	u32 h_stop;
+	u32 v_delay;
+	u32 video_v_start;
+	u32 video_v_stop;
+	u32 vbi_v_start_0;
+	u32 vbi_v_stop_0;
+	u32 vbi_v_start_1;
+
+	/* Techwell specific */
+	u32 format;
+};
+
+struct tw5864_format {
+	char *name;
+	u32 fourcc;
+	u32 depth;
+	u32 twformat;
+};
+
+/* ----------------------------------------------------------- */
+/* card configuration   */
+
+#define TW5864_INPUTS 4
+
+#define H264_VLC_BUF_SIZE 0x80000
+#define H264_MV_BUF_SIZE 0x40000
+#define QP_VALUE 28
+#define BITALIGN_VALUE_IN_TIMER 0
+#define BITALIGN_VALUE_IN_INIT 0
+#define GOP_SIZE 32
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
+struct tw5864_fmt {
+	char *name;
+	u32 fourcc; /* v4l2 format id */
+	int depth;
+	int flags;
+	u32 twformat;
+};
+
+struct tw5864_dma_buf {
+	void *addr;
+	dma_addr_t dma_addr;
+};
+
+enum tw5864_vid_std {
+	STD_NTSC = 0,
+	STD_PAL = 1,
+	STD_SECAM = 2,
+
+	STD_INVALID = 7,
+	STD_AUTO = 7,
+};
+
+v4l2_std_id tw5864_get_v4l2_std(enum tw5864_vid_std std);
+enum tw5864_vid_std tw5864_from_v4l2_std(v4l2_std_id v4l2_std);
+
+struct tw5864_input {
+	int input_number;
+	struct tw5864_dev *root;
+	struct mutex lock; /* used for vidq and vdev */
+	spinlock_t slock; /* used for sync between ISR, tasklet & V4L2 API */
+	struct video_device vdev;
+	struct v4l2_ctrl_handler hdl;
+	const struct tw5864_tvnorm *tvnorm;
+	void *alloc_ctx;
+	struct vb2_queue vidq;
+	struct list_head active;
+	const struct tw5864_format *fmt;
+	enum resolution resolution;
+	unsigned int width, height;
+	unsigned int frame_seqno;
+	unsigned int h264_idr_pic_id;
+	unsigned int h264_frame_seqno_in_gop;
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
+};
+
+struct tw5864_h264_frame {
+	struct tw5864_dma_buf vlc;
+	struct tw5864_dma_buf mv;
+
+	int vlc_len;
+	u32 checksum;
+	struct tw5864_input *input;
+
+	u64 timestamp;
+};
+
+/* global device status */
+struct tw5864_dev {
+	spinlock_t slock; /* used for sync between ISR, tasklet & V4L2 API */
+	struct v4l2_device v4l2_dev;
+	struct tw5864_input inputs[TW5864_INPUTS];
+#define H264_BUF_CNT 64
+	struct tw5864_h264_frame h264_buf[H264_BUF_CNT];
+	int h264_buf_r_index;
+	int h264_buf_w_index;
+
+	struct tasklet_struct tasklet;
+
+	int encoder_busy;
+	/* Input number to check next (in RR fashion) */
+	int next_i;
+
+	/* pci i/o */
+	char name[64];
+	struct pci_dev *pci;
+	void __iomem *mmio;
+	u32 irqmask;
+	u32 frame_seqno;
+
+	u32 stored_len;
+
+	struct dentry *debugfs_dir;
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
+u8 tw_indir_readb(struct tw5864_dev *dev, u16 addr);
+void tw_indir_writeb(struct tw5864_dev *dev, u16 addr, u8 data);
+
+void tw5864_set_tvnorm_hw(struct tw5864_dev *dev);
+
+void tw5864_irqmask_apply(struct tw5864_dev *dev);
+void tw5864_init_ad(struct tw5864_dev *dev);
+int tw5864_video_init(struct tw5864_dev *dev, int *video_nr);
+void tw5864_video_fini(struct tw5864_dev *dev);
+void tw5864_prepare_frame_headers(struct tw5864_input *input);
+void tw5864_h264_put_stream_header(u8 **buf, size_t *space_left, int qp,
+				   int width, int height);
+void tw5864_h264_put_slice_header(u8 **buf, size_t *space_left,
+				  unsigned int idr_pic_id,
+				  unsigned int frame_seqno_in_gop,
+				  int *tail_nb_bits, u8 *tail);
+void tw5864_request_encoded_frame(struct tw5864_input *input);
+void tw5864_push_to_make_it_roll(struct tw5864_input *input);
+
+static const unsigned int lambda_lookup_table[52] = {
+	0x0020, 0x0020, 0x0020, 0x0020,
+	0x0020, 0x0020, 0x0020, 0x0020,
+	0x0020, 0x0020, 0x0020, 0x0020,
+	0x0020, 0x0020, 0x0020, 0x0020,
+	0x0040, 0x0040, 0x0040, 0x0040,
+	0x0060, 0x0060, 0x0060, 0x0080,
+	0x0080, 0x0080, 0x00a0, 0x00c0,
+	0x00c0, 0x00e0, 0x0100, 0x0120,
+	0x0140, 0x0160, 0x01a0, 0x01c0,
+	0x0200, 0x0240, 0x0280, 0x02e0,
+	0x0320, 0x03a0, 0x0400, 0x0480,
+	0x0500, 0x05a0, 0x0660, 0x0720,
+	0x0800, 0x0900, 0x0a20, 0x0b60
+};
+
+static const unsigned int intra4x4_lambda3[52] = {
+	1, 1, 1, 1, 1, 1, 1, 1,
+	1, 1, 1, 1, 1, 1, 1, 1,
+	2, 2, 2, 2, 3, 3, 3, 4,
+	4, 4, 5, 6, 6, 7, 8, 9,
+	10, 11, 13, 14, 16, 18, 20, 23,
+	25, 29, 32, 36, 40, 45, 51, 57,
+	64, 72, 81, 91
+};
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 37f05cb..231afead 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2333,6 +2333,7 @@
 #define PCI_VENDOR_ID_CAVIUM		0x177d
 
 #define PCI_VENDOR_ID_TECHWELL		0x1797
+#define PCI_DEVICE_ID_TECHWELL_5864	0x5864
 #define PCI_DEVICE_ID_TECHWELL_6800	0x6800
 #define PCI_DEVICE_ID_TECHWELL_6801	0x6801
 #define PCI_DEVICE_ID_TECHWELL_6804	0x6804
-- 
2.7.1.380.g0fea050.dirty

