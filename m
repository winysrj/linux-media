Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64052 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab2JURxV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:21 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so1759055wib.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:20 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 04/23] em28xx: rename struct em28xx_usb_isoc_bufs to em28xx_usb_bufs
Date: Sun, 21 Oct 2012 19:52:09 +0300
Message-Id: <1350838349-14763-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It will be used for USB bulk transfers, too.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |    8 ++++----
 drivers/media/usb/em28xx/em28xx.h      |   10 +++++-----
 2 Dateien geändert, 9 Zeilen hinzugefügt(+), 9 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 2520a16..b250a63 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -964,7 +964,7 @@ static void em28xx_irq_callback(struct urb *urb)
 void em28xx_uninit_isoc(struct em28xx *dev, enum em28xx_mode mode)
 {
 	struct urb *urb;
-	struct em28xx_usb_isoc_bufs *isoc_bufs;
+	struct em28xx_usb_bufs *isoc_bufs;
 	int i;
 
 	em28xx_isocdbg("em28xx: called em28xx_uninit_isoc in mode %d\n", mode);
@@ -1012,7 +1012,7 @@ void em28xx_stop_urbs(struct em28xx *dev)
 {
 	int i;
 	struct urb *urb;
-	struct em28xx_usb_isoc_bufs *isoc_bufs = &dev->isoc_ctl.digital_bufs;
+	struct em28xx_usb_bufs *isoc_bufs = &dev->isoc_ctl.digital_bufs;
 
 	em28xx_isocdbg("em28xx: called em28xx_stop_urbs\n");
 
@@ -1036,7 +1036,7 @@ EXPORT_SYMBOL_GPL(em28xx_stop_urbs);
 int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
 		      int num_packets, int num_bufs, int max_pkt_size)
 {
-	struct em28xx_usb_isoc_bufs *isoc_bufs;
+	struct em28xx_usb_bufs *isoc_bufs;
 	int i;
 	int sb_size, pipe;
 	struct urb *urb;
@@ -1134,7 +1134,7 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 {
 	struct em28xx_dmaqueue *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue *vbi_dma_q = &dev->vbiq;
-	struct em28xx_usb_isoc_bufs *isoc_bufs;
+	struct em28xx_usb_bufs *isoc_bufs;
 	int i;
 	int rc;
 	int alloc;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 119dc20..a4a79bd 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -202,7 +202,7 @@ enum em28xx_mode {
 
 struct em28xx;
 
-struct em28xx_usb_isoc_bufs {
+struct em28xx_usb_bufs {
 		/* max packet size of isoc transaction */
 	int				max_pkt_size;
 
@@ -212,19 +212,19 @@ struct em28xx_usb_isoc_bufs {
 		/* number of allocated urbs */
 	int				num_bufs;
 
-		/* urb for isoc transfers */
+		/* urb for isoc/bulk transfers */
 	struct urb			**urb;
 
-		/* transfer buffers for isoc transfer */
+		/* transfer buffers for isoc/bulk transfer */
 	char				**transfer_buffer;
 };
 
 struct em28xx_usb_isoc_ctl {
 		/* isoc transfer buffers for analog mode */
-	struct em28xx_usb_isoc_bufs	analog_bufs;
+	struct em28xx_usb_bufs		analog_bufs;
 
 		/* isoc transfer buffers for digital mode */
-	struct em28xx_usb_isoc_bufs	digital_bufs;
+	struct em28xx_usb_bufs		digital_bufs;
 
 		/* Stores already requested buffers */
 	struct em28xx_buffer    	*vid_buf;
-- 
1.7.10.4

