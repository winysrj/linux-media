Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:40931 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752033AbeBZCYX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 21:24:23 -0500
Received: by mail-qt0-f177.google.com with SMTP id u11so5165855qtg.7
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 18:24:23 -0800 (PST)
Date: Sun, 25 Feb 2018 21:24:06 -0500
From: Douglas Fischer <fischerdouglasc@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH v3] media: radio: Tuning bugfix for si470x over i2c
Message-ID: <20180225212406.6af82d07@Constantine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed si470x_set_channel() trying to tune before chip is turned
on, which causes warnings in dmesg and when probing, makes driver
wait for 3s for tuning timeout. This issue did not affect USB
devices because they have a different probing sequence.

Changed from v2: radio power check returns if power is off instead
of putting the rest of the function in the conditional.

Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
---

diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x-common.c linux/drivers/media/radio/si470x/radio-si470x-common.c
--- linux.orig/drivers/media/radio/si470x/radio-si470x-common.c	2018-01-15 21:58:10.675620432 -0500
+++ linux/drivers/media/radio/si470x/radio-si470x-common.c	2018-02-25 19:18:11.108930138 -0500
@@ -207,6 +207,15 @@ static int si470x_set_chan(struct si470x
 	unsigned long time_left;
 	bool timed_out = false;
 
+	retval = si470x_get_register(radio, POWERCFG);
+	if (retval)
+		return retval;
+
+	if ( (radio->registers[POWERCFG] & (POWERCFG_ENABLE|POWERCFG_DMUTE))
+		!= (POWERCFG_ENABLE|POWERCFG_DMUTE) ) {
+		return 0;
+	}
+
 	/* start tuning */
 	radio->registers[CHANNEL] &= ~CHANNEL_CHAN;
 	radio->registers[CHANNEL] |= CHANNEL_TUNE | chan;
