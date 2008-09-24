Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ONZAYg031214
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:35:10 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8ONYqMj014996
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:34:55 -0400
Message-Id: <200809242334.m8ONYqMj014996@mx3.redhat.com>
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 25 Sep 2008 00:21:50 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 2/6] si470x: improvement of module device support
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

this patch improves support for multiple radio devices.
In previous versions all region relevant settings were derived from one module parameter.
As in future versions, the region and other configuration should be configurable per device from the user space, this patch already retrieves all relevant information from the actual device specific settings.

Best regards,
Toby


Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- a/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
+++ b/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
@@ -672,23 +672,29 @@ static int si470x_get_freq(struct si470x
 	int retval;
 
 	/* Spacing (kHz) */
-	switch (space) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_SPACE) >> 4) {
 	/* 0: 200 kHz (USA, Australia) */
-	case 0 : spacing = 0.200 * FREQ_MUL; break;
+	case 0:
+		spacing = 0.200 * FREQ_MUL; break;
 	/* 1: 100 kHz (Europe, Japan) */
-	case 1 : spacing = 0.100 * FREQ_MUL; break;
+	case 1:
+		spacing = 0.100 * FREQ_MUL; break;
 	/* 2:  50 kHz */
-	default: spacing = 0.050 * FREQ_MUL; break;
+	default:
+		spacing = 0.050 * FREQ_MUL; break;
 	};
 
 	/* Bottom of Band (MHz) */
-	switch (band) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe) */
-	case 0 : band_bottom = 87.5 * FREQ_MUL; break;
+	case 0:
+		band_bottom = 87.5 * FREQ_MUL; break;
 	/* 1: 76   - 108 MHz (Japan wide band) */
-	default: band_bottom = 76   * FREQ_MUL; break;
+	default:
+		band_bottom = 76   * FREQ_MUL; break;
 	/* 2: 76   -  90 MHz (Japan) */
-	case 2 : band_bottom = 76   * FREQ_MUL; break;
+	case 2:
+		band_bottom = 76   * FREQ_MUL; break;
 	};
 
 	/* read channel */
@@ -711,23 +717,29 @@ static int si470x_set_freq(struct si470x
 	unsigned short chan;
 
 	/* Spacing (kHz) */
-	switch (space) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_SPACE) >> 4) {
 	/* 0: 200 kHz (USA, Australia) */
-	case 0 : spacing = 0.200 * FREQ_MUL; break;
+	case 0:
+		spacing = 0.200 * FREQ_MUL; break;
 	/* 1: 100 kHz (Europe, Japan) */
-	case 1 : spacing = 0.100 * FREQ_MUL; break;
+	case 1:
+		spacing = 0.100 * FREQ_MUL; break;
 	/* 2:  50 kHz */
-	default: spacing = 0.050 * FREQ_MUL; break;
+	default:
+		spacing = 0.050 * FREQ_MUL; break;
 	};
 
 	/* Bottom of Band (MHz) */
-	switch (band) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe) */
-	case 0 : band_bottom = 87.5 * FREQ_MUL; break;
+	case 0:
+		band_bottom = 87.5 * FREQ_MUL; break;
 	/* 1: 76   - 108 MHz (Japan wide band) */
-	default: band_bottom = 76   * FREQ_MUL; break;
+	default:
+		band_bottom = 76   * FREQ_MUL; break;
 	/* 2: 76   -  90 MHz (Japan) */
-	case 2 : band_bottom = 76   * FREQ_MUL; break;
+	case 2:
+		band_bottom = 76   * FREQ_MUL; break;
 	};
 
 	/* Chan = [ Freq (Mhz) - Bottom of Band (MHz) ] / Spacing (kHz) */
@@ -1430,7 +1442,8 @@ static int si470x_vidioc_g_tuner(struct 
 		goto done;
 
 	strcpy(tuner->name, "FM");
-	switch (band) {
+	/* range limits */
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe, default) */
 	default:
 		tuner->rangelow  =  87.5 * FREQ_MUL;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
