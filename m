Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPM09cL025095
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 17:00:10 -0500
Received: from smtp-out114.alice.it (smtp-out114.alice.it [85.37.17.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAPLx2lN011382
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 16:59:03 -0500
Date: Tue, 25 Nov 2008 22:58:50 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081125225850.2f311353.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH] gspca_ov534: Fix printing "frame_rate = 0" when using
 default frame_rate.
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

Fix printing "frame_rate = 0" when using default frame_rate.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

diff -r 8d178f462ba7 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Mon Nov 24 10:38:21 2008 +0100
+++ b/linux/drivers/media/video/gspca/ov534.c	Tue Nov 25 21:58:41 2008 +0100
@@ -363,6 +363,8 @@
 
 	if (frame_rate > 0)
 		sd->frame_rate = frame_rate;
+	else
+		sd->frame_rate = 30;
 
 	PDEBUG(D_PROBE, "frame_rate = %d", sd->frame_rate);
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
