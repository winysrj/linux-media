Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPMr6Kx018853
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 17:53:06 -0500
Received: from smtp-out25.alice.it (smtp-out25.alice.it [85.33.2.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAPMr4Ph003968
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 17:53:05 -0500
Date: Tue, 25 Nov 2008 23:52:49 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081125235249.d45b50f4.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH] gspca_ov534: Print only frame_rate actually used.
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

Print only frame_rate actually used.

It is better to avoid altogether misleading prints of to be discarded values.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

diff -r 8d178f462ba7 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Mon Nov 24 10:38:21 2008 +0100
+++ b/linux/drivers/media/video/gspca/ov534.c	Tue Nov 25 23:41:10 2008 +0100
@@ -364,10 +364,9 @@
 	if (frame_rate > 0)
 		sd->frame_rate = frame_rate;
 
-	PDEBUG(D_PROBE, "frame_rate = %d", sd->frame_rate);
-
 	switch (sd->frame_rate) {
 	case 50:
+		PDEBUG(D_PROBE, "frame_rate = 50");
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x01);
 		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
@@ -375,6 +374,7 @@
 		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x02);
 		break;
 	case 40:
+		PDEBUG(D_PROBE, "frame_rate = 40");
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x02);
 		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0xc1);
@@ -383,6 +383,7 @@
 		break;
 	case 30:
 	default:
+		PDEBUG(D_PROBE, "frame_rate = 30");
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x04);
 		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x81);
@@ -390,6 +391,7 @@
 		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x02);
 		break;
 	case 15:
+		PDEBUG(D_PROBE, "frame_rate = 15");
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x03);
 		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
