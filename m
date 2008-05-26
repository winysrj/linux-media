Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QKWCg3006702
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:32:12 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4QKVl6d030188
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:31:48 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 26 May 2008 22:31:40 +0200
References: <200805072253.23219.tobias.lorenz@gmx.net>
	<20080526104146.7ef1bc91@gaivota>
In-Reply-To: <20080526104146.7ef1bc91@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200805262231.40778.tobias.lorenz@gmx.net>
Content-Transfer-Encoding: 8bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 2/6] si470x: let si470x_get_freq return errno
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
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 1_unplugging/drivers/media/radio/radio-si470x.c 2_ret_get_freq/drivers/media/radio/radio-si470x.c
--- 1_unplugging/drivers/media/radio/radio-si470x.c	2008-05-26 22:07:45.000000000 +0200
+++ 2_ret_get_freq/drivers/media/radio/radio-si470x.c	2008-05-26 22:12:17.000000000 +0200
@@ -24,6 +24,19 @@
 
 
 /*
+ * User Notes:
+ * - USB Audio is provided by the alsa snd_usb_audio module.
+ *   For listing you have to redirect the sound, for example using:
+ *   arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -
+ * - regarding module parameters in /sys/module/radio_si470x/parameters:
+ *   the contents of read-only files (0444) are not updated, even if
+ *   space, band and de are changed using private video controls
+ * - increase tune_timeout, if you often get -EIO errors
+ * - hw_freq_seek returns -EAGAIN, when timed out or band limit is reached
+ */
+
+
+/*
  * History:
  * 2008-01-12	Tobias Lorenz <tobias.lorenz@gmx.net>
  *		Version 1.0.0
@@ -86,6 +99,9 @@
  *		Version 1.0.7
  *		- usb autosuspend support
  *		- unplugging fixed
+ * 2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
+ *		Version 1.0.8
+ *		- let si470x_get_freq return errno
  *
  * ToDo:
  * - add seeking support
@@ -98,10 +114,10 @@
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_NAME "radio-si470x"
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 7)
+#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 8)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.7"
+#define DRIVER_VERSION "1.0.8"
 
 
 /* kernel includes */
@@ -634,9 +650,9 @@ static int si470x_set_chan(struct si470x
 /*
  * si470x_get_freq - get the frequency
  */
-static unsigned int si470x_get_freq(struct si470x_device *radio)
+static int si470x_get_freq(struct si470x_device *radio, unsigned int *freq)
 {
-	unsigned int spacing, band_bottom, freq;
+	unsigned int spacing, band_bottom;
 	unsigned short chan;
 	int retval;
 
@@ -662,14 +678,12 @@ static unsigned int si470x_get_freq(stru
 
 	/* read channel */
 	retval = si470x_get_register(radio, READCHAN);
-	if (retval < 0)
-		return retval;
 	chan = radio->registers[READCHAN] & READCHAN_READCHAN;
 
 	/* Frequency (MHz) = Spacing (kHz) x Channel + Bottom of Band (MHz) */
-	freq = chan * spacing + band_bottom;
+	*freq = chan * spacing + band_bottom;
 
-	return freq;
+	return retval;
 }
 
 
@@ -1352,9 +1366,7 @@ static int si470x_vidioc_g_frequency(str
 		return -EIO;
 
 	freq->type = V4L2_TUNER_RADIO;
-	freq->frequency = si470x_get_freq(radio);
-
-	return 0;
+	return si470x_get_freq(radio, &radio->frequency);
 }
 
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
