Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QKZ8DE007682
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:35:08 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4QKYnjd031608
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:34:49 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 26 May 2008 22:34:42 +0200
References: <200805072253.23219.tobias.lorenz@gmx.net>
	<20080526104146.7ef1bc91@gaivota>
In-Reply-To: <20080526104146.7ef1bc91@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200805262234.42735.tobias.lorenz@gmx.net>
Content-Transfer-Encoding: 8bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 4/6] si470x: afc indication
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

> Please, don't send a patch with several different things on it. Instead, send me incremental patches. with just one change. So, you would send me:
>       a patch for harware seek support;
>       a patch for afc indication; 
>       ...

I splitted PATCH 2/2 into six separate parts.
Again this applies to vanilla 2.6.25.
For 5/6 and 6/6 also the previous general hw seek support PATCH 1/2 is necessary.

1/6: unplugging fixed
- problem fixed, when unplugging the device while still in use
- version bump to 1.0.7 finally made, was inconsistent in linux-2.6.25!

2/6: let si470x_get_freq return errno
- version bumped to 1.0.8 for all the following patches
- si470x_get_freq now returns errno

3/6: a lot of small code cleanups
- comment on how to listen to an usb audio device
  (i get so many questions about that...)
- code cleanup (error handling, more warnings, spacing, ...)

4/6: afc indication
- afc indication:
  device has no indication whether freq is too low or too high
  therefore afc always return 1, when freq is wrong

5/6: hardware frequency seek support
- this now finally adds hardware frequency seek support

6/6: private video controls
- private video controls
  - to control seek behaviour
  - to module parameters
  - corrected access rights of module parameters
  - separate header file to let the user space know about it

Best regards,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 3_code_style/drivers/media/radio/radio-si470x.c 4_afc/drivers/media/radio/radio-si470x.c
--- 3_code_style/drivers/media/radio/radio-si470x.c	2008-05-26 22:07:02.000000000 +0200
+++ 4_afc/drivers/media/radio/radio-si470x.c	2008-05-26 22:06:41.000000000 +0200
@@ -101,6 +101,7 @@
  *		- unplugging fixed
  * 2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
  *		Version 1.0.8
+ *		- afc indication
  *		- more safety checks, let si470x_get_freq return errno
  *
  * ToDo:
@@ -1391,7 +1392,8 @@ static int si470x_vidioc_g_tuner(struct 
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
