Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab0I1SrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:47:19 -0400
Date: Tue, 28 Sep 2010 15:46:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/10] V4L/DVB: cx231xx: remove a printk warning at -avcore
 and at -417
Message-ID: <20100928154653.785c1f3f@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

drivers/media/video/cx231xx/cx231xx-avcore.c:1608: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long unsigned int’
drivers/media/video/cx231xx/cx231xx-417.c:1047: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘size_t’

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index 402e109..ddaa437 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -1044,7 +1044,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	/* transfer to the chip */
 	dprintk(2, "Loading firmware to GPIO...\n");
 	p_fw_data = (u32 *)firmware->data;
-	dprintk(2, "firmware->size=%d\n", firmware->size);
+	dprintk(2, "firmware->size=%zd\n", firmware->size);
 	for (transfer_size = 0; transfer_size < firmware->size;
 		 transfer_size += 4) {
 		fw_data = *p_fw_data;
diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index b4eda90..ab9fbf8 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -1605,7 +1605,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 	if_freq = 16000000;
     }
 
-    cx231xx_info("Enter IF=%d\n",
+    cx231xx_info("Enter IF=%zd\n",
 		 sizeof(Dif_set_array)/sizeof(struct dif_settings));
     for (i = 0; i < sizeof(Dif_set_array)/sizeof(struct dif_settings); i++) {
 	if (Dif_set_array[i].if_freq == if_freq) {
-- 
1.7.1


