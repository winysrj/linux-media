Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:45421 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424163AbeCBP0K (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 10:26:10 -0500
Received: by mail-qt0-f172.google.com with SMTP id v90so12245203qte.12
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2018 07:26:09 -0800 (PST)
Date: Fri, 2 Mar 2018 10:25:43 -0500
From: Douglas Fischer <fischerdouglasc@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH v4] media: radio: Critical interrupt bugfix for si470x over
 i2c
Message-ID: <20180302102543.076b1c95@Constantine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed si470x_start() disabling the interrupt signal, causing tune
operations to never complete. This does not affect USB radios
because they poll the registers instead of using the IRQ line.

Stylistic and comment changes from v3.

Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
---

diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x-common.c linux/drivers/media/radio/si470x/radio-si470x-common.c
--- linux.orig/drivers/media/radio/si470x/radio-si470x-common.c	2018-01-15 21:58:10.675620432 -0500
+++ linux/drivers/media/radio/si470x/radio-si470x-common.c	2018-03-02 10:22:05.490059995 -0500
@@ -377,8 +377,11 @@ int si470x_start(struct si470x_device *r
 		goto done;
 
 	/* sysconfig 1 */
-	radio->registers[SYSCONFIG1] =
-		(de << 11) & SYSCONFIG1_DE;		/* DE*/
+	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN|SYSCONFIG1_STCIEN|SYSCONFIG1_RDS;
+	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_GPIO2;
+	radio->registers[SYSCONFIG1] |= SYSCONFIG1_GPIO2_INT;
+	if (de)
+		radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		goto done;
diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x.h linux/drivers/media/radio/si470x/radio-si470x.h
--- linux.orig/drivers/media/radio/si470x/radio-si470x.h	2018-01-15 21:58:10.675620432 -0500
+++ linux/drivers/media/radio/si470x/radio-si470x.h	2018-03-02 10:22:05.497059995 -0500
@@ -79,6 +79,8 @@
 #define SYSCONFIG1_BLNDADJ	0x00c0	/* bits 07..06: Stereo/Mono Blend Level Adjustment */
 #define SYSCONFIG1_GPIO3	0x0030	/* bits 05..04: General Purpose I/O 3 */
 #define SYSCONFIG1_GPIO2	0x000c	/* bits 03..02: General Purpose I/O 2 */
+#define SYSCONFIG1_GPIO2_DIS	0x0000	/* Disable GPIO 2 interrupt */
+#define SYSCONFIG1_GPIO2_INT	0x0004	/* Enable STC/RDS interrupt */
 #define SYSCONFIG1_GPIO1	0x0003	/* bits 01..00: General Purpose I/O 1 */
 
 #define SYSCONFIG2		5	/* System Configuration 2 */
