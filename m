Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1ONAT4e014035
	for <video4linux-list@redhat.com>; Sun, 24 Feb 2008 18:10:29 -0500
Received: from smtp.reveal.co.nz (203-109-246-148.static.bliink.ihug.co.nz
	[203.109.246.148])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1ON9roW007271
	for <video4linux-list@redhat.com>; Sun, 24 Feb 2008 18:09:58 -0500
Received: from mail.reveal.local (revpfe.reveal.local [10.0.0.4])
	by smtp.reveal.co.nz (8.13.1/8.13.1) with ESMTP id m1ONJdLZ025395
	for <video4linux-list@redhat.com>; Mon, 25 Feb 2008 12:19:40 +1300
Date: Mon, 25 Feb 2008 12:09:36 +1300
From: Alan McIvor <alan.mcivor@reveal.co.nz>
To: video4linux-list@redhat.com
Message-Id: <20080225120936.f65ba568.alan.mcivor@reveal.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [PATCH] SAA7134 number of devices check
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

Hi,

The SAA7134 device driver has a array for storing device information
in. This array is of size SAA7134_MAXBOARDS. This patch adds a check
of the number of boards already existing before adding a new
one. Without it, the device driver currently does strange things if 9
or more SAA7134 devices exist in a system.

Dr Alan M. McIvor
Reveal Limited



--- linux/drivers/media/video/saa7134/saa7134-core.c.orig	2008-02-25 11:51:39.000000000 +1300
+++ linux/drivers/media/video/saa7134/saa7134-core.c	2008-02-25 11:56:24.000000000 +1300
@@ -994,6 +994,9 @@ static int __devinit saa7134_initdev(str
 	struct saa7134_mpeg_ops *mops;
 	int err;
 
+	if (saa7134_devcount == SAA7134_MAXBOARDS)
+		return -ENOMEM;
+
 	dev = kzalloc(sizeof(*dev),GFP_KERNEL);
 	if (NULL == dev)
 		return -ENOMEM;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
