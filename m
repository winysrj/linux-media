Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VFFS7b000677
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:15:28 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4VFFGOi015871
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:15:16 -0400
Content-Disposition: inline
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sat, 31 May 2008 17:09:07 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805311709.08120.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 4/6] si470x: afc indication
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

Hi Mauro,

this patch brings the following changes:
- afc indication:
  device has no indication whether freq is too low or too high
  therefore afc always return 1, when freq is wrong

Best regards,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 3_code_style/drivers/media/radio/radio-si470x.c 4_afc/drivers/media/radio/radio-si470x.c
--- 3_code_style/drivers/media/radio/radio-si470x.c	2008-05-31 16:29:01.000000000 +0200
+++ 4_afc/drivers/media/radio/radio-si470x.c	2008-05-31 16:30:02.000000000 +0200
@@ -101,6 +101,7 @@
  *		- unplugging fixed
  * 2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
  *		Version 1.0.8
+ *		- afc indication
  *		- more safety checks, let si470x_get_freq return errno
  *
  * ToDo:
@@ -1401,7 +1402,8 @@ static int si470x_vidioc_g_tuner(struct 
 				* 0x0101;
 
 	/* automatic frequency control: -1: freq to low, 1 freq to high */
-	tuner->afc = 0;
+	/* AFCRL does only indicate that freq. differs, not if too low/high */
+	tuner->afc = (radio->registers[STATUSRSSI] & STATUSRSSI_AFCRL) ? 1 : 0;
 
 done:
 	if (retval < 0)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
