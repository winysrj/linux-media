Return-path: <linux-media-owner@vger.kernel.org>
Received: from condef001-v.nifty.com ([210.131.4.238]:36464 "EHLO
        condef001-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932133AbcIFXIm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 19:08:42 -0400
From: Masahiro Yamada <yamada.masahiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, Kukjin Kim <kgene@kernel.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        linux-kernel@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Max Kellermann <max@duempel.org>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Abhilash Jindal <klock.android@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH] [media] squash lines for simple wrapper functions
Date: Wed,  7 Sep 2016 07:52:24 +0900
Message-Id: <1473202344-5218-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unneeded variables and assignments.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/media/dvb-core/dvb_frontend.c             |  8 ++------
 drivers/media/pci/meye/meye.c                     |  5 +----
 drivers/media/pci/ttpci/av7110.c                  |  4 +---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 17 +++--------------
 drivers/media/platform/ti-vpe/cal.c               |  6 +-----
 drivers/media/rc/fintek-cir.c                     |  6 +-----
 drivers/media/usb/dvb-usb-v2/lmedm04.c            | 14 ++++++--------
 drivers/media/usb/dvb-usb/m920x.c                 | 10 +++-------
 drivers/media/usb/gspca/jl2005bcd.c               |  5 +----
 drivers/media/usb/gspca/sq905c.c                  |  5 +----
 10 files changed, 20 insertions(+), 60 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index be99c8d..43fcbb8 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1515,12 +1515,8 @@ static int dtv_set_frontend(struct dvb_frontend *fe);
 
 static bool is_dvbv3_delsys(u32 delsys)
 {
-	bool status;
-
-	status = (delsys == SYS_DVBT) || (delsys == SYS_DVBC_ANNEX_A) ||
-		 (delsys == SYS_DVBS) || (delsys == SYS_ATSC);
-
-	return status;
+	return (delsys == SYS_DVBT) || (delsys == SYS_DVBC_ANNEX_A) ||
+	       (delsys == SYS_DVBS) || (delsys == SYS_ATSC);
 }
 
 /**
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index ba887e8..7727d59 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -587,10 +587,7 @@ static void mchip_hic_stop(void)
 /* get the next ready frame from the dma engine */
 static u32 mchip_get_frame(void)
 {
-	u32 v;
-
-	v = mchip_read(MCHIP_MM_FIR(meye.mchip_fnum));
-	return v;
+	return mchip_read(MCHIP_MM_FIR(meye.mchip_fnum));
 }
 
 /* frees the current frame from the dma engine */
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 382caf2..aee26af 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -2930,9 +2930,7 @@ static struct saa7146_extension av7110_extension_driver = {
 
 static int __init av7110_init(void)
 {
-	int retval;
-	retval = saa7146_register_extension(&av7110_extension_driver);
-	return retval;
+	return saa7146_register_extension(&av7110_extension_driver);
 }
 
 
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index 0912d0a..a1d823a 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -178,20 +178,12 @@ void exynos4_jpeg_set_interrupt(void __iomem *base, unsigned int version)
 
 unsigned int exynos4_jpeg_get_int_status(void __iomem *base)
 {
-	unsigned int	int_status;
-
-	int_status = readl(base + EXYNOS4_INT_STATUS_REG);
-
-	return int_status;
+	return readl(base + EXYNOS4_INT_STATUS_REG);
 }
 
 unsigned int exynos4_jpeg_get_fifo_status(void __iomem *base)
 {
-	unsigned int fifo_status;
-
-	fifo_status = readl(base + EXYNOS4_FIFO_STATUS_REG);
-
-	return fifo_status;
+	return readl(base + EXYNOS4_FIFO_STATUS_REG);
 }
 
 void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value)
@@ -296,10 +288,7 @@ void exynos4_jpeg_set_encode_hoff_cnt(void __iomem *base, unsigned int fmt)
 
 unsigned int exynos4_jpeg_get_stream_size(void __iomem *base)
 {
-	unsigned int size;
-
-	size = readl(base + EXYNOS4_BITSTREAM_SIZE_REG);
-	return size;
+	return readl(base + EXYNOS4_BITSTREAM_SIZE_REG);
 }
 
 void exynos4_jpeg_set_dec_bitstream_size(void __iomem *base, unsigned int size)
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index e967fcf..2a9de42 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -483,11 +483,7 @@ static void cal_get_hwinfo(struct cal_dev *dev)
 
 static inline int cal_runtime_get(struct cal_dev *dev)
 {
-	int r;
-
-	r = pm_runtime_get_sync(&dev->pdev->dev);
-
-	return r;
+	return pm_runtime_get_sync(&dev->pdev->dev);
 }
 
 static inline void cal_runtime_put(struct cal_dev *dev)
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index bd7b3bd..ecab69e 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -104,11 +104,7 @@ static inline void fintek_cir_reg_write(struct fintek_dev *fintek, u8 val, u8 of
 /* read val from cir config register */
 static u8 fintek_cir_reg_read(struct fintek_dev *fintek, u8 offset)
 {
-	u8 val;
-
-	val = inb(fintek->cir_addr + offset);
-
-	return val;
+	return inb(fintek->cir_addr + offset);
 }
 
 /* dump current cir register contents */
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 3721ee6..8a28e87 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -156,21 +156,19 @@ struct lme2510_state {
 static int lme2510_bulk_write(struct usb_device *dev,
 				u8 *snd, int len, u8 pipe)
 {
-	int ret, actual_l;
+	int actual_l;
 
-	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
-				snd, len , &actual_l, 100);
-	return ret;
+	return usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
+			    snd, len, &actual_l, 100);
 }
 
 static int lme2510_bulk_read(struct usb_device *dev,
 				u8 *rev, int len, u8 pipe)
 {
-	int ret, actual_l;
+	int actual_l;
 
-	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
-				 rev, len , &actual_l, 200);
-	return ret;
+	return usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
+			    rev, len, &actual_l, 200);
 }
 
 static int lme2510_usb_talk(struct dvb_usb_device *d,
diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index eafc5c8..70672e1 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -55,13 +55,9 @@ static inline int m920x_read(struct usb_device *udev, u8 request, u16 value,
 static inline int m920x_write(struct usb_device *udev, u8 request,
 			      u16 value, u16 index)
 {
-	int ret;
-
-	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
-			      request, USB_TYPE_VENDOR | USB_DIR_OUT,
-			      value, index, NULL, 0, 2000);
-
-	return ret;
+	return usb_control_msg(udev, usb_sndctrlpipe(udev, 0), request,
+			       USB_TYPE_VENDOR | USB_DIR_OUT, value, index,
+			       NULL, 0, 2000);
 }
 
 static inline int m920x_write_seq(struct usb_device *udev, u8 request,
diff --git a/drivers/media/usb/gspca/jl2005bcd.c b/drivers/media/usb/gspca/jl2005bcd.c
index 5b481fa..229c66a 100644
--- a/drivers/media/usb/gspca/jl2005bcd.c
+++ b/drivers/media/usb/gspca/jl2005bcd.c
@@ -300,10 +300,7 @@ static int jl2005c_stream_start_cif_small(struct gspca_dev *gspca_dev)
 
 static int jl2005c_stop(struct gspca_dev *gspca_dev)
 {
-	int retval;
-
-	retval = jl2005c_write_reg(gspca_dev, 0x07, 0x00);
-	return retval;
+	return jl2005c_write_reg(gspca_dev, 0x07, 0x00);
 }
 
 /*
diff --git a/drivers/media/usb/gspca/sq905c.c b/drivers/media/usb/gspca/sq905c.c
index aa21edc..9eaed32 100644
--- a/drivers/media/usb/gspca/sq905c.c
+++ b/drivers/media/usb/gspca/sq905c.c
@@ -257,11 +257,8 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	int ret;
-
 	/* connect to the camera and reset it. */
-	ret = sq905c_command(gspca_dev, SQ905C_CLEAR, 0);
-	return ret;
+	return sq905c_command(gspca_dev, SQ905C_CLEAR, 0);
 }
 
 /* Set up for getting frames. */
-- 
1.9.1

