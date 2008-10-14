Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ECxcMp002795
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:59:38 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ECxL1Z012775
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:59:22 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2186740rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 05:59:21 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 14 Oct 2008 21:58:12 +0900
Message-Id: <20081014125812.5224.67473.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH] video: add sh_mobile_ceu comments
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

This patch adds CEU hardware block comments to the sh_mobile_ceu driver.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/sh_mobile_ceu_camera.c |   79 ++++++++++++++++------------
 1 file changed, 46 insertions(+), 33 deletions(-)

--- 0001/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2008-10-14 15:41:48.000000000 +0900
@@ -40,39 +40,39 @@
 
 /* register offsets for sh7722 / sh7723 */
 
-#define CAPSR  0x00
-#define CAPCR  0x04
-#define CAMCR  0x08
-#define CMCYR  0x0c
-#define CAMOR  0x10
-#define CAPWR  0x14
-#define CAIFR  0x18
-#define CSTCR  0x20 /* not on sh7723 */
-#define CSECR  0x24 /* not on sh7723 */
-#define CRCNTR 0x28
-#define CRCMPR 0x2c
-#define CFLCR  0x30
-#define CFSZR  0x34
-#define CDWDR  0x38
-#define CDAYR  0x3c
-#define CDACR  0x40
-#define CDBYR  0x44
-#define CDBCR  0x48
-#define CBDSR  0x4c
-#define CFWCR  0x5c
-#define CLFCR  0x60
-#define CDOCR  0x64
-#define CDDCR  0x68
-#define CDDAR  0x6c
-#define CEIER  0x70
-#define CETCR  0x74
-#define CSTSR  0x7c
-#define CSRTR  0x80
-#define CDSSR  0x84
-#define CDAYR2 0x90
-#define CDACR2 0x94
-#define CDBYR2 0x98
-#define CDBCR2 0x9c
+#define CAPSR  0x00 /* Capture start register */
+#define CAPCR  0x04 /* Capture control register */
+#define CAMCR  0x08 /* Capture interface control register */
+#define CMCYR  0x0c /* Capture interface cycle  register */
+#define CAMOR  0x10 /* Capture interface offset register */
+#define CAPWR  0x14 /* Capture interface width register */
+#define CAIFR  0x18 /* Capture interface input format register */
+#define CSTCR  0x20 /* Camera strobe control register (<= sh7722) */
+#define CSECR  0x24 /* Camera strobe emission count register (<= sh7722) */
+#define CRCNTR 0x28 /* CEU register control register */
+#define CRCMPR 0x2c /* CEU register forcible control register */
+#define CFLCR  0x30 /* Capture filter control register */
+#define CFSZR  0x34 /* Capture filter size clip register */
+#define CDWDR  0x38 /* Capture destination width register */
+#define CDAYR  0x3c /* Capture data address Y register */
+#define CDACR  0x40 /* Capture data address C register */
+#define CDBYR  0x44 /* Capture data bottom-field address Y register */
+#define CDBCR  0x48 /* Capture data bottom-field address C register */
+#define CBDSR  0x4c /* Capture bundle destination size register */
+#define CFWCR  0x5c /* Firewall operation control register */
+#define CLFCR  0x60 /* Capture low-pass filter control register */
+#define CDOCR  0x64 /* Capture data output control register */
+#define CDDCR  0x68 /* Capture data complexity level register */
+#define CDDAR  0x6c /* Capture data complexity level address register */
+#define CEIER  0x70 /* Capture event interrupt enable register */
+#define CETCR  0x74 /* Capture event flag clear register */
+#define CSTSR  0x7c /* Capture status register */
+#define CSRTR  0x80 /* Capture software reset register */
+#define CDSSR  0x84 /* Capture data size register */
+#define CDAYR2 0x90 /* Capture data address Y register 2 */
+#define CDACR2 0x94 /* Capture data address C register 2 */
+#define CDBYR2 0x98 /* Capture data bottom-field address Y register 2 */
+#define CDBCR2 0x9c /* Capture data bottom-field address C register 2 */
 
 static DEFINE_MUTEX(camera_lock);
 
@@ -396,6 +396,19 @@ static int sh_mobile_ceu_set_bus_param(s
 	ceu_write(pcdev, CFLCR, 0); /* data fetch mode - no scaling */
 	ceu_write(pcdev, CFSZR, (icd->height << 16) | cfszr_width);
 	ceu_write(pcdev, CLFCR, 0); /* data fetch mode - no lowpass filter */
+
+	/* A few words about byte order (observed in Big Endian mode)
+	 *
+	 * In data fetch mode bytes are received in chunks of 8 bytes.
+	 * D0, D1, D2, D3, D4, D5, D6, D7 (D0 received first)
+	 *
+	 * The data is however by default written to memory in reverse order:
+	 * D7, D6, D5, D4, D3, D2, D1, D0 (D7 written to lowest byte)
+	 *
+	 * The lowest three bits of CDOCR allows us to do swapping,
+	 * right now we swap the data bytes to the following order:
+	 * D1, D0, D3, D2, D5, D4, D7, D6
+	 */
 	ceu_write(pcdev, CDOCR, 0x00000016);
 
 	ceu_write(pcdev, CDWDR, cdwdr_width);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
