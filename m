Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36311 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756447AbeATTTx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Jan 2018 14:19:53 -0500
Received: by mail-qt0-f195.google.com with SMTP id z11so11783092qtm.3
        for <linux-media@vger.kernel.org>; Sat, 20 Jan 2018 11:19:52 -0800 (PST)
Date: Sat, 20 Jan 2018 14:19:14 -0500
From: Douglas Fischer <fischerdouglasc@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH] media: radio: Tuning bugfix for si470x over i2c
Message-ID: <20180120141914.233d6d00@Constantine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed si470x_set_channel() trying to tune before chip is turned
on, which causes warnings in dmesg and when probing, makes driver
wait for 3s for tuning timeout. This issue did not affect USB
devices because they have a different probing sequence.

Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
---

diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
linux/drivers/media/radio/si470x/radio-si470x-common.c ---
linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
2018-01-15 21:58:10.675620432 -0500 +++
linux/drivers/media/radio/si470x/radio-si470x-common.c
2018-01-16 17:04:59.706409128 -0500 @@ -207,29 +207,37 @@ static int
si470x_set_chan(struct si470x unsigned long time_left; bool timed_out =
false; 
-	/* start tuning */
-	radio->registers[CHANNEL] &= ~CHANNEL_CHAN;
-	radio->registers[CHANNEL] |= CHANNEL_TUNE | chan;
-	retval = si470x_set_register(radio, CHANNEL);
-	if (retval < 0)
-		goto done;
+	retval = si470x_get_register(radio, POWERCFG);
+	if (retval)
+		return retval;
 
-	/* wait till tune operation has completed */
-	reinit_completion(&radio->completion);
-	time_left = wait_for_completion_timeout(&radio->completion,
-
msecs_to_jiffies(tune_timeout));
-	if (time_left == 0)
-		timed_out = true;
+	if ( (radio->registers[POWERCFG] & POWERCFG_ENABLE) && 
+		(radio->registers[POWERCFG] & POWERCFG_DMUTE) ) { 
 
-	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
-		dev_warn(&radio->videodev.dev, "tune does not
complete\n");
-	if (timed_out)
-		dev_warn(&radio->videodev.dev,
-			"tune timed out after %u ms\n", tune_timeout);
+		/* start tuning */
+		radio->registers[CHANNEL] &= ~CHANNEL_CHAN;
+		radio->registers[CHANNEL] |= CHANNEL_TUNE | chan;
+		retval = si470x_set_register(radio, CHANNEL);
+		if (retval < 0)
+			goto done;
 
-	/* stop tuning */
-	radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
-	retval = si470x_set_register(radio, CHANNEL);
+		/* wait till tune operation has completed */
+		reinit_completion(&radio->completion);
+		time_left =
wait_for_completion_timeout(&radio->completion,
+
msecs_to_jiffies(tune_timeout));
+		if (time_left == 0)
+			timed_out = true;
+	
+		if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) ==
0)
+			dev_warn(&radio->videodev.dev, "tune does not
complete\n");
+		if (timed_out)
+			dev_warn(&radio->videodev.dev,
+				"tune timed out after %u ms\n",
tune_timeout);
+	
+		/* stop tuning */
+		radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
+		retval = si470x_set_register(radio, CHANNEL);
+	}
 
 done:
 	return retval;
