Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2JMJNFj019245
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 18:19:23 -0400
Received: from smtp.reveal.co.nz (203-109-246-148.static.bliink.ihug.co.nz
	[203.109.246.148])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2JMIpjp001858
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 18:18:52 -0400
Received: from mail.reveal.local (revpfe.reveal.local [10.0.0.4])
	by smtp.reveal.co.nz (8.13.1/8.13.1) with ESMTP id m2JMSB88006130
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 11:28:36 +1300
Date: Thu, 20 Mar 2008 11:17:24 +1300
From: Alan McIvor <alan.mcivor@reveal.co.nz>
To: video4linux-list@redhat.com
Message-Id: <20080320111724.3f1045d0.alan.mcivor@reveal.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [PATCH] Increase number of SAA7134 devices supported in a system
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

The SAA7134 device driver currently only supports 8 such devices in a
system. This is too small for many surveillance applications. This
patch increases the number to 32.

Signed-off-by: Alan McIvor <alan.mcivor@reveal.co.nz>

--- linux/drivers/media/video/saa7134/saa7134.h.orig	2008-03-20 10:52:47.000000000 +1300
+++ linux/drivers/media/video/saa7134/saa7134.h	2008-03-20 10:53:30.000000000 +1300
@@ -270,7 +270,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_VIDEOMATE_T750       139
 
 
-#define SAA7134_MAXBOARDS 8
+#define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
 
 /* ----------------------------------------------------------- */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
