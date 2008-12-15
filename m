Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFAxtDt025967
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 05:59:55 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBFAxWcE020262
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 05:59:32 -0500
Received: by wa-out-1112.google.com with SMTP id j4so1258746wah.19
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 02:59:31 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Mon, 15 Dec 2008 19:57:42 +0900
Message-Id: <20081215105742.20533.42076.sendpatchset@rx1.opensource.se>
Cc: g.liakhovetski@gmx.de
Subject: [PATCH] video: sh_mobile_ceu cleanups and comments
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Magnus Damm <damm@igel.co.jp>

This patch cleans up the sh_mobile_ceu driver and adds comments and
constants to clarify the magic sequence in sh_mobile_ceu_capture().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Applies on top of the NV16 patch. The interlace patch is excluded.

 drivers/media/video/sh_mobile_ceu_camera.c |   40 ++++++++++++++++------------
 1 file changed, 23 insertions(+), 17 deletions(-)

--- 0029/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2008-12-15 19:48:38.000000000 +0900
@@ -103,14 +103,12 @@ struct sh_mobile_ceu_dev {
 	const struct soc_camera_data_format *camera_fmt;
 };
 
-static void ceu_write(struct sh_mobile_ceu_dev *priv,
-		      unsigned long reg_offs, unsigned long data)
+static void ceu_write(struct sh_mobile_ceu_dev *priv, u32 reg_offs, u32 data)
 {
 	iowrite32(data, priv->base + reg_offs);
 }
 
-static unsigned long ceu_read(struct sh_mobile_ceu_dev *priv,
-			      unsigned long reg_offs)
+static u32 ceu_read(struct sh_mobile_ceu_dev *priv, u32 reg_offs)
 {
 	return ioread32(priv->base + reg_offs);
 }
@@ -158,18 +156,26 @@ static void free_buffer(struct videobuf_
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
+#define CEU_CETCR_MAGIC 0x0317f313 /* acknowledge magical interrupt sources */
+#define CEU_CETCR_IGRW (1 << 4) /* prohibited register access interrupt bit */
+#define CEU_CEIER_CPEIE (1 << 0) /* one-frame capture end interrupt */
+#define CEU_CAPCR_CTNCP (1 << 16) /* continuous capture mode (if set) */
+
+
 static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 {
 	struct soc_camera_device *icd = pcdev->icd;
-	unsigned long phys_addr;
-
-	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~1);
-	ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & 0x0317f313);
-	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | 1);
+	dma_addr_t phys_addr;
 
-	ceu_write(pcdev, CAPCR, ceu_read(pcdev, CAPCR) & ~0x10000);
-
-	ceu_write(pcdev, CETCR, 0x0317f313 ^ 0x10);
+	/* The hardware is _very_ picky about this sequence. Especially
+	 * the CEU_CETCR_MAGIC value. It seems like we need to acknowledge
+	 * several not-so-well documented interrupt sources in CETCR.
+	 */
+	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~CEU_CEIER_CPEIE);
+	ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & CEU_CETCR_MAGIC);
+	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | CEU_CEIER_CPEIE);
+	ceu_write(pcdev, CAPCR, ceu_read(pcdev, CAPCR) & ~CEU_CAPCR_CTNCP);
+	ceu_write(pcdev, CETCR, CEU_CETCR_MAGIC ^ CEU_CETCR_IGRW);
 
 	if (!pcdev->active)
 		return;
@@ -182,7 +188,7 @@ static void sh_mobile_ceu_capture(struct
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
-		phys_addr += (icd->width * icd->height);
+		phys_addr += icd->width * icd->height;
 		ceu_write(pcdev, CDACR, phys_addr);
 	}
 
@@ -452,13 +458,13 @@ static int sh_mobile_ceu_set_bus_param(s
 
 	if (yuv_mode) {
 		width = icd->width * 2;
-		width = (buswidth == 16) ? width / 2 : width;
+		width = buswidth == 16 ? width / 2 : width;
 		cfszr_width = cdwdr_width = icd->width;
 	} else {
 		width = icd->width * ((icd->current_fmt->depth + 7) >> 3);
-		width = (buswidth == 16) ? width / 2 : width;
-		cfszr_width = (buswidth == 8) ? width / 2 : width;
-		cdwdr_width = (buswidth == 16) ? width * 2 : width;
+		width = buswidth == 16 ? width / 2 : width;
+		cfszr_width = buswidth == 8 ? width / 2 : width;
+		cdwdr_width = buswidth == 16 ? width * 2 : width;
 	}
 
 	ceu_write(pcdev, CAMOR, 0);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
