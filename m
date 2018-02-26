Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:43119 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbeBZC13 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 21:27:29 -0500
Received: by mail-qt0-f176.google.com with SMTP id d26so17143026qtk.10
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 18:27:29 -0800 (PST)
Date: Sun, 25 Feb 2018 21:27:13 -0500
From: Douglas Fischer <fischerdouglasc@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH v3] media: radio: Critical interrupt bugfix for si470x over
 i2c
Message-ID: <20180225212713.3d78dead@Constantine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed si470x_start() disabling the interrupt signal, causing tune
operations to never complete. This does not affect USB radios
because they poll the registers instead of using the IRQ line.

Stylistic and comment changes from v2.

Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
---

diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x-common.c linux/drivers/media/radio/si470x/radio-si470x-common.c
--- linux.orig/drivers/media/radio/si470x/radio-si470x-common.c	2018-01-15 21:58:10.675620432 -0500
+++ linux/drivers/media/radio/si470x/radio-si470x-common.c	2018-02-25 19:16:31.785934211 -0500
@@ -377,8 +377,11 @@ int si470x_start(struct si470x_device *r
 		goto done;
 
 	/* sysconfig 1 */
-	radio->registers[SYSCONFIG1] =
-		(de << 11) & SYSCONFIG1_DE;		/* DE*/
+	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN|SYSCONFIG1_STCIEN|SYSCONFIG1_RDS;
+	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_GPIO2;
+	radio->registers[SYSCONFIG1] |= (0x01 << 2); /* GPIO2 */
+	if (de)
+		radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		goto done;
