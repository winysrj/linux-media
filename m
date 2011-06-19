Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1FSRni (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:38 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5JHhcl7031704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 13:43:38 -0400
Received: from pedra (vpn-238-25.phx2.redhat.com [10.3.238.25])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p5JHhWq3018286
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 13:43:37 -0400
Date: Sun, 19 Jun 2011 14:42:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/11] [media] em28xx: Don't initialize a var if won't be
 using it
Message-ID: <20110619144232.55b2870b@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fixes most cases of initializing a var but not using it.

There are still 3 cases at em28xx-alsa, were those vars should
probably be used.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index 3c48a72..a24e177 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -286,10 +286,9 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 
 	runtime->hw = snd_em28xx_hw_capture;
 	if (dev->alt == 0 && dev->adev.users == 0) {
-		int errCode;
 		dev->alt = 7;
 		dprintk("changing alternate number to 7\n");
-		errCode = usb_set_interface(dev->udev, 0, 7);
+		usb_set_interface(dev->udev, 0, 7);
 	}
 
 	dev->adev.users++;
@@ -342,6 +341,8 @@ static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
 
 	ret = snd_pcm_alloc_vmalloc_buffer(substream,
 				params_buffer_bytes(hw_params));
+	if (ret < 0)
+		return ret;
 	format = params_format(hw_params);
 	rate = params_rate(hw_params);
 	channels = params_channels(hw_params);
@@ -393,7 +394,7 @@ static int snd_em28xx_capture_trigger(struct snd_pcm_substream *substream,
 				      int cmd)
 {
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
-	int retval;
+	int retval = 0;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -406,7 +407,7 @@ static int snd_em28xx_capture_trigger(struct snd_pcm_substream *substream,
 		retval = -EINVAL;
 	}
 	schedule_work(&dev->wq_trigger);
-	return 0;
+	return retval;
 }
 
 static snd_pcm_uframes_t snd_em28xx_capture_pointer(struct snd_pcm_substream
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 7635a45..bbd67d7 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2660,10 +2660,9 @@ void em28xx_card_setup(struct em28xx *dev)
 			.addr = 0xba >> 1,
 			.platform_data = &pdata,
 		};
-		struct v4l2_subdev *sd;
 
 		pdata.xtal = dev->sensor_xtal;
-		sd = v4l2_i2c_new_subdev_board(&dev->v4l2_dev, &dev->i2c_adap,
+		v4l2_i2c_new_subdev_board(&dev->v4l2_dev, &dev->i2c_adap,
 				&mt9v011_info, NULL);
 	}
 
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index e33f145..55d0d9d 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -917,7 +917,7 @@ EXPORT_SYMBOL_GPL(em28xx_set_mode);
 static void em28xx_irq_callback(struct urb *urb)
 {
 	struct em28xx *dev = urb->context;
-	int rc, i;
+	int i;
 
 	switch (urb->status) {
 	case 0:             /* success */
@@ -934,7 +934,7 @@ static void em28xx_irq_callback(struct urb *urb)
 
 	/* Copy data from URB */
 	spin_lock(&dev->slock);
-	rc = dev->isoc_ctl.isoc_copy(dev, urb);
+	dev->isoc_ctl.isoc_copy(dev, urb);
 	spin_unlock(&dev->slock);
 
 	/* Reset urb buffers */
diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index 4739fc7..4ece685 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -218,9 +218,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, unsigned char addr,
  */
 static int em28xx_i2c_check_for_device(struct em28xx *dev, unsigned char addr)
 {
-	char msg;
 	int ret;
-	msg = addr;
 
 	ret = dev->em28xx_read_reg_req(dev, 2, addr);
 	if (ret < 0) {
-- 
1.7.1


