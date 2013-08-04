Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:39944 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab3HDWUf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Aug 2013 18:20:35 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: Yaroslav Zakharuk <slavikz@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org, 1173723@bugs.launchpad.net
Subject: [PATCH RFC] [media] gspca-ov534: don't call sd_start() from sd_init()
Date: Mon,  5 Aug 2013 00:20:27 +0200
Message-Id: <1375654827-14270-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <20130731133634.fbfe99f97026454593d3518f@studenti.unina.it>
References: <20130731133634.fbfe99f97026454593d3518f@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---

Hi Yaroslav,

the patch below should fix the Oops caused by sd_start() called too early, but
I am not sure about why sd_start() was called from sd_init() for Hercules
webcams in the first place, maybe the snippet marked with:

  /* (from ms-win trace) */

in sd_start() must be moved to sd_init() too.

Let me know if the change below alone is enough and the webcam keeps working,
a test with suspend and resume would good to have too.

Thanks,
   Antonio

 drivers/media/usb/gspca/ov534.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 2e28c81..03a33c4 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -1305,8 +1305,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	ov534_set_led(gspca_dev, 1);
 	sccb_w_array(gspca_dev, sensor_init[sd->sensor].val,
 			sensor_init[sd->sensor].len);
-	if (sd->sensor == SENSOR_OV767x)
-		sd_start(gspca_dev);
+
 	sd_stopN(gspca_dev);
 /*	set_frame_rate(gspca_dev);	*/
 
-- 
1.8.4.rc1

