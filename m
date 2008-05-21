Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4L1K6rX006658
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 21:20:06 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4L1JYeA009701
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 21:19:35 -0400
Received: by ug-out-1314.google.com with SMTP id s2so48665uge.6
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 18:19:34 -0700 (PDT)
Date: Wed, 21 May 2008 11:20:34 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080521112034.4477f3db@glory.loctelecom.ru>
In-Reply-To: <1211331167.4235.26.camel@pc10.localdom.local>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
	<20080520152426.5540ee7f@glory.loctelecom.ru>
	<1211331167.4235.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Y0WZEf3xN9Kd5u6BTXhuoVX"
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] saa7134_empress
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

--MP_/Y0WZEf3xN9Kd5u6BTXhuoVX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

This is patch for fix data structure in querycap syscall.

diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 21 05:12:37 2008 +1000
@@ -172,8 +172,7 @@ static int empress_querycap(struct file 
 static int empress_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	strcpy(cap->driver, "saa7134");
 	strlcpy(cap->card, saa7134_boards[dev->board].name,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/Y0WZEf3xN9Kd5u6BTXhuoVX
Content-Type: text/x-patch; name=beholder_empress_01.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=beholder_empress_01.diff

diff -r 9d04bba82511 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Wed May 21 05:12:37 2008 +1000
@@ -172,8 +172,7 @@ static int empress_querycap(struct file 
 static int empress_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	strcpy(cap->driver, "saa7134");
 	strlcpy(cap->card, saa7134_boards[dev->board].name,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/Y0WZEf3xN9Kd5u6BTXhuoVX
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/Y0WZEf3xN9Kd5u6BTXhuoVX--
