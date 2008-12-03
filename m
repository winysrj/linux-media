Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3KmHpj024145
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 15:48:17 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3Km3gn010667
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 15:48:04 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <fa4fcbdb237a065c4033.1228337220@hypnosis.jim>
In-Reply-To: <patchbomb.1228337219@hypnosis.jim>
Date: Wed, 03 Dec 2008 15:47:00 -0500
From: Jim Paris <jim@jtan.com>
To: video4linux-list@redhat.com
Cc: 
Subject: [PATCH 1 of 4] ov534: don't check status twice
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

# HG changeset patch
# User jim@jtan.com
# Date 1228334704 18000
# Node ID fa4fcbdb237a065c4033bd51be28fa9da9016cef
# Parent  ee27d949bfa5e050f858b5bae4cc9a050ff5b119
ov534: don't check status twice

sccb_reg_write already calls sccb_check_status, no need to do it
again.

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r ee27d949bfa5 -r fa4fcbdb237a linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Tue Dec 02 19:00:57 2008 +0100
+++ b/linux/drivers/media/video/gspca/ov534.c	Wed Dec 03 15:05:04 2008 -0500
@@ -369,31 +369,23 @@
 	switch (sd->frame_rate) {
 	case 50:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x01);
-		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
-		sccb_check_status(gspca_dev->dev);
 		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x02);
 		break;
 	case 40:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x02);
-		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0xc1);
-		sccb_check_status(gspca_dev->dev);
 		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x04);
 		break;
 	case 30:
 	default:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x04);
-		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x81);
-		sccb_check_status(gspca_dev->dev);
 		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x02);
 		break;
 	case 15:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x03);
-		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
-		sccb_check_status(gspca_dev->dev);
 		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x04);
 		break;
 	};

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
