Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3M7lKj7023356
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 03:47:20 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3M7l6kp002574
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 03:47:06 -0400
Received: by yw-out-2324.google.com with SMTP id 3so1736495ywj.81
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 00:47:05 -0700 (PDT)
Date: Wed, 22 Apr 2009 17:48:48 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20090422174848.1be88f61@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/su1eJKv5+EEGmmbSruE5eGY"
Subject: [PATCH] FM1216ME_MK3 some changes
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

--MP_/su1eJKv5+EEGmmbSruE5eGY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

1. Change middle band. In the end of the middle band the sensitivity of receiver not good.
If we switch to higher band, sensitivity more better. Hardware trick.

2. Set correct highest freq of the higher band.

3. Set charge pump bit

diff -r 43dbc8ebb5a2 linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Tue Apr 21 09:44:38 2009 +1000
@@ -557,9 +557,9 @@
 /* ------------ TUNER_PHILIPS_FM1216ME_MK3 - Philips PAL ------------ */
 
 static struct tuner_range tuner_fm1216me_mk3_pal_ranges[] = {
-	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
-	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
-	{ 16 * 999.99        , 0x8e, 0x04, },
+	{ 16 * 158.00 /*MHz*/, 0xc6, 0x01, },
+	{ 16 * 441.00 /*MHz*/, 0xc6, 0x02, },
+	{ 16 * 864.00        , 0xc6, 0x04, },
 };
 


Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/su1eJKv5+EEGmmbSruE5eGY
Content-Type: text/x-patch; name=behold_mk3_range.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_mk3_range.diff

diff -r 43dbc8ebb5a2 linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Tue Apr 21 09:44:38 2009 +1000
@@ -557,9 +557,9 @@
 /* ------------ TUNER_PHILIPS_FM1216ME_MK3 - Philips PAL ------------ */
 
 static struct tuner_range tuner_fm1216me_mk3_pal_ranges[] = {
-	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
-	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
-	{ 16 * 999.99        , 0x8e, 0x04, },
+	{ 16 * 158.00 /*MHz*/, 0xc6, 0x01, },
+	{ 16 * 441.00 /*MHz*/, 0xc6, 0x02, },
+	{ 16 * 864.00        , 0xc6, 0x04, },
 };
 


Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
--MP_/su1eJKv5+EEGmmbSruE5eGY
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/su1eJKv5+EEGmmbSruE5eGY--
