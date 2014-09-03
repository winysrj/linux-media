Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: [PATCH 21/46] [media] radio: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:53 -0300
Message-Id: <f04d3c7cf7122496bd39282854d1a6d5ebb855de.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 235c0e349820..cff1eb144a5c 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -332,7 +332,7 @@ static int __init gemtek_init(void)
 
 static void __exit gemtek_exit(void)
 {
-	hardmute = 1;	/* Turn off PLL */
+	hardmute = true;	/* Turn off PLL */
 #ifdef CONFIG_PNP
 	pnp_unregister_driver(&gemtek_driver.pnp_driver);
 #endif
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index d7ce8fe6b5ae..bcd0946c84a5 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -285,7 +285,7 @@ static int __init fmi_init(void)
 				io = isapnp_fmi_probe();
 				if (io < 0)
 					continue;
-				pnp_attached = 1;
+				pnp_attached = true;
 			}
 			if (!request_region(io, 2, "radio-sf16fmi")) {
 				if (pnp_attached)
@@ -349,7 +349,7 @@ static int __init fmi_init(void)
 	mutex_init(&fmi->lock);
 
 	/* mute card and set default frequency */
-	fmi->mute = 1;
+	fmi->mute = true;
 	fmi->curfreq = RSF16_MINFREQ;
 	fmi_set_freq(fmi);
 
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 0e750aef656a..909c3f92d839 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -208,7 +208,7 @@ static int si470x_set_band(struct si470x_device *radio, int band)
 static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 {
 	int retval;
-	bool timed_out = 0;
+	bool timed_out = false;
 
 	/* start tuning */
 	radio->registers[CHANNEL] &= ~CHANNEL_CHAN;
@@ -300,7 +300,7 @@ static int si470x_set_seek(struct si470x_device *radio,
 {
 	int band, retval;
 	unsigned int freq;
-	bool timed_out = 0;
+	bool timed_out = false;
 
 	/* set band */
 	if (seek->rangelow || seek->rangehigh) {
-- 
1.9.3

