Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBDMx9bm010540
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 17:59:09 -0500
Received: from smtp-out28.alice.it (smtp-out28.alice.it [85.33.2.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBDMwtQT019485
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 17:58:55 -0500
Message-Id: <20081213225850.929446310@studenti.unina.it>
References: <20081213225653.943975535@studenti.unina.it>
Date: Sat, 13 Dec 2008 23:56:54 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Content-Disposition: inline; filename=ov534_fix_typo.patch
Cc: 
Subject: [PATCH 1/2] ov534: Fix typo in comment.
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

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -421,7 +421,7 @@
 	remaining_len -= len;
 	next_data += len;
 
-	/* Payloads are prefixed with a the UVC-style header.  We
+	/* Payloads are prefixed with a UVC-style header.  We
 	   consider a frame to start when the FID toggles, or the PTS
 	   changes.  A frame ends when EOF is set, and we've received
 	   the correct number of bytes. */

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
