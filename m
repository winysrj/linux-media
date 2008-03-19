Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2JMJu4R019466
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 18:19:56 -0400
Received: from smtp.reveal.co.nz (203-109-246-148.static.bliink.ihug.co.nz
	[203.109.246.148])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2JMJOjK002139
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 18:19:25 -0400
Received: from mail.reveal.local (revpfe.reveal.local [10.0.0.4])
	by smtp.reveal.co.nz (8.13.1/8.13.1) with ESMTP id m2JMSB8A006130
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 11:29:09 +1300
Date: Thu, 20 Mar 2008 11:18:11 +1300
From: Alan McIvor <alan.mcivor@reveal.co.nz>
To: video4linux-list@redhat.com
Message-Id: <20080320111811.e1b5ddfc.alan.mcivor@reveal.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [PATCH] Increase number of BT8XX devices supported in a system
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

The BT8XX device driver currently only supports 16 such devices in a
system. This is too small for many surveillance applications. This
patch increases the number to 32.

Signed-off-by: Alan McIvor <alan.mcivor@reveal.co.nz>

--- linux/drivers/media/video/bt8xx/bttvp.h.orig	2008-03-20 10:54:11.000000000 +1300
+++ linux/drivers/media/video/bt8xx/bttvp.h	2008-03-20 10:54:29.000000000 +1300
@@ -478,7 +478,7 @@ struct bttv {
 };
 
 /* our devices */
-#define BTTV_MAX 16
+#define BTTV_MAX 32
 extern unsigned int bttv_num;
 extern struct bttv bttvs[BTTV_MAX];
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
