Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:49412 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZCIXQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 19:16:15 -0400
Received: by ewy25 with SMTP id 25so1053312ewy.37
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2009 16:16:12 -0700 (PDT)
Date: Tue, 10 Mar 2009 00:16:00 +0100 (CET)
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [PATCH] pwc : fix LED and power setup for first open
To: linux-media@vger.kernel.org
Message-ID: <tkrat.98fa52cc2386a49f@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Fuzzey <mfuzzey@gmail.com>

Call pwc_construct before trying to talk to device to obtain vc interface so
that LED and power setup works the first time the video device is opened.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 0d81018..e11f422 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1115,6 +1115,7 @@ static int pwc_video_open(struct file *file)
 	}

 	mutex_lock(&pdev->modlock);
+	pwc_construct(pdev); /* set min/max sizes correct */
 	if (!pdev->usb_init) {
 		PWC_DEBUG_OPEN("Doing first time initialization.\n");
 		pdev->usb_init = 1;
@@ -1139,7 +1140,6 @@ static int pwc_video_open(struct file *file)
 	if (pwc_set_leds(pdev, led_on, led_off) < 0)
 		PWC_DEBUG_OPEN("Failed to set LED on/off time.\n");

-	pwc_construct(pdev); /* set min/max sizes correct */

 	/* So far, so good. Allocate memory. */
 	i = pwc_allocate_buffers(pdev);


