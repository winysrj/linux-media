Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2Q2EqQ9006619
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 22:14:52 -0400
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2Q2EL1Q006642
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 22:14:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 785C433CC9
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 03:14:20 +0100 (CET)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SS9JUI5lJy52 for <video4linux-list@redhat.com>;
	Wed, 26 Mar 2008 03:14:14 +0100 (CET)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1fabe9b19f0c356704aa.1206497257@bluegene.athome>
In-Reply-To: <patchbomb.1206497254@bluegene.athome>
Date: Wed, 26 Mar 2008 03:07:37 +0100
From: Marton Balint <cus@fazekas.hu>
To: video4linux-list@redhat.com
Subject: [PATCH 3 of 3] cx88: detect stereo output instead of mono fallback
	in A2 sound system
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
# Date 1206489018 -3600
# Node ID 1fabe9b19f0c356704aad5bbb0ce045ff3e05947
# Parent  2c020dc87db5511e6cbaae05389e3bda225d4879
cx88: detect stereo output instead of mono fallback in A2 sound system

From: Marton Balint <cus@fazekas.hu>

Testing proved that AUD_NICAM_STATUS1 and AUD_NICAM_STATUS2 registers
change randomly if and only if the second audio channel is missing, so if
these registers are constant (Usually 0x0000 and 0x01), we can assume that
the tv channel has two audio channels, so we can use STEREO mode. This
method seems a bit ugly, but nicam detection works the same way. And
now stereo channel detection also works for me.

Since my cable TV provider only broadcasts in PAL BG mode with A2 sound
system, i couldn't test other systems, but they should work just like
before.


Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r 2c020dc87db5 -r 1fabe9b19f0c linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Wed Mar 26 00:40:42 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Wed Mar 26 00:50:18 2008 +0100
@@ -725,31 +725,47 @@ static void set_audio_standard_FM(struct
 
 /* ----------------------------------------------------------- */
 
-static int cx88_detect_nicam(struct cx88_core *core)
-{
-	int i, j = 0;
+static int cx88_detect_nicam_or_stereo(struct cx88_core *core)
+{
+	int i, stereo = 0;
+	u32 status1, status2;
+	u32 last_status1, last_status2;
 
 	dprintk("start nicam autodetect.\n");
-
-	for (i = 0; i < 6; i++) {
+	last_status1 = cx_read(AUD_NICAM_STATUS1);
+	last_status2 = cx_read(AUD_NICAM_STATUS2);
+
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
-	}
-
+		if (last_status1 == status1 && last_status2 == status2)
+			stereo++;
+		else
+			stereo = 0;
+		last_status1 = status1;
+		last_status2 = status2;
+	}
+
+	dprintk("stereo detection result: %d\n", stereo);
 	dprintk("nicam is not detected.\n");
-	return 0;
+	return stereo >= 3 ? 2 : 0;
 }
 
 void cx88_set_tvaudio(struct cx88_core *core)
 {
+	int nicam_or_stereo;
+
 	switch (core->tvaudio) {
 	case WW_BTSC:
 		set_audio_standard_BTSC(core, 0, EN_BTSC_AUTO_STEREO);
@@ -764,12 +780,13 @@ void cx88_set_tvaudio(struct cx88_core *
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
+			set_audio_standard_A2(core, nicam_or_stereo == 2 ? EN_A2_FORCE_STEREO : EN_A2_FORCE_MONO1);
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
