Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9NLhWV000355
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 18:21:43 -0500
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9NLUuL004099
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 18:21:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <45eba6ab2f4cdcaf7aeb.1226272762@roadrunner.athome>
In-Reply-To: <patchbomb.1226272760@roadrunner.athome>
Date: Mon, 10 Nov 2008 00:19:22 +0100
From: Marton Balint <cus@fazekas.hu>
To: video4linux-list@redhat.com
Cc: mchehab@infradead.org
Subject: [PATCH 2 of 2] cx88: add optional stereo detection to PAL-BG mode
	with A2 sound system
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

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1226268742 -3600
# Node ID 45eba6ab2f4cdcaf7aebd707e1ac545b66ae66bc
# Parent  e9f7514f435ad89666cd12e8384d88114c21b5ee
cx88: add optional stereo detection to PAL-BG mode with A2 sound system

From: Marton Balint <cus@fazekas.hu>

This patch adds a module parameter detect_stereo which can be used to
enable stereo detection for PAL-BG mode, using the following method:

AUD_NICAM_STATUS1 and AUD_NICAM_STATUS2 registers change randomly if and only
if the second audio channel is missing, so if these registers are constant
(Usually 0x0000 and 0x01), we can assume that the tv channel has two audio
channels, so we can use STEREO mode. This method seems a bit ugly, but nicam
detection works the same way.

This stereo detection method is not perfect. For example, it works quite well
for me using tvtime, but it misdetects some of the channels using mplayer.
Since the stereo detection is disabled by default, it should not harm the
average user, but an advanced user may try setting the parameter and may have
mostly working stereo detection.

Priority: normal

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r e9f7514f435a -r 45eba6ab2f4c linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Wed Jul 30 22:50:09 2008 +0200
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Sun Nov 09 23:12:22 2008 +0100
@@ -69,6 +69,11 @@
 module_param(radio_deemphasis,int,0644);
 MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant, "
 		 "0=None, 1=50us (elsewhere), 2=75us (USA)");
+
+static unsigned int detect_stereo;
+module_param(detect_stereo,int,0644);
+MODULE_PARM_DESC(detect_stereo,"enable unreliable but often working "
+		 "stereo detection code for PAL-BG audio");
 
 #define dprintk(fmt, arg...)	if (audio_debug) \
 	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
@@ -718,31 +723,52 @@
 
 /* ----------------------------------------------------------- */
 
-static int cx88_detect_nicam(struct cx88_core *core)
+static int cx88_detect_nicam_or_stereo(struct cx88_core *core)
 {
-	int i, j = 0;
+	int i, stereo = 0;
+	u32 status1, status2;
+	u32 last_status1, last_status2;
 
 	dprintk("start nicam autodetect.\n");
+	last_status1 = cx_read(AUD_NICAM_STATUS1);
+	last_status2 = cx_read(AUD_NICAM_STATUS2);
 
-	for (i = 0; i < 6; i++) {
+	/* wait here max 50 ms or if stereo is ambigous then max 70 ms */
+	for (i = 0; i < 5 || (stereo > 0 && stereo < 3 && i < 7); i++) {
+		/* wait a little bit for next reading status */
+		msleep(10);
+
+		status1 = cx_read(AUD_NICAM_STATUS1);
+		status2 = cx_read(AUD_NICAM_STATUS2);
+
 		/* if bit1=1 then nicam is detected */
-		j += ((cx_read(AUD_NICAM_STATUS2) & 0x02) >> 1);
-
-		if (j == 1) {
+		if (status2 & 0x02) {
 			dprintk("nicam is detected.\n");
 			return 1;
 		}
 
-		/* wait a little bit for next reading status */
-		msleep(10);
+		/* try stereo detection only for PAL-BG */
+		if (core->tvaudio == WW_BG && detect_stereo) {
+			if (last_status1 == status1 && last_status2 == status2)
+				stereo++;
+			else
+				stereo = 0;
+			last_status1 = status1;
+			last_status2 = status2;
+		}
 	}
 
 	dprintk("nicam is not detected.\n");
-	return 0;
+	if (core->tvaudio == WW_BG && detect_stereo)
+		dprintk("stereo detection result: %d\n", stereo);
+
+	return stereo >= 3 ? 2 : 0;
 }
 
 void cx88_set_tvaudio(struct cx88_core *core)
 {
+	int nicam_or_stereo;
+
 	switch (core->tvaudio) {
 	case WW_BTSC:
 		set_audio_standard_BTSC(core, 0, EN_BTSC_AUTO_STEREO);
@@ -757,12 +783,15 @@
 		/* set nicam mode - otherwise
 		   AUD_NICAM_STATUS2 contains wrong values */
 		set_audio_standard_NICAM(core, EN_NICAM_AUTO_STEREO);
-		if (0 == cx88_detect_nicam(core)) {
-			/* fall back to fm / am mono */
-			set_audio_standard_A2(core, EN_A2_FORCE_MONO1);
+		nicam_or_stereo = cx88_detect_nicam_or_stereo(core);
+		if (nicam_or_stereo == 1) {
+			core->use_nicam = 1;
+		} else {
+			/* fall back to fm / am stereo or mono */
+			set_audio_standard_A2(core, (nicam_or_stereo == 2)
+						    ? EN_A2_FORCE_STEREO
+						    : EN_A2_FORCE_MONO1);
 			core->use_nicam = 0;
-		} else {
-			core->use_nicam = 1;
 		}
 		break;
 	case WW_EIAJ:

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
