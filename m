Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab0JKPlW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:41:22 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFfLBO002149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:41:21 -0400
Received: from pedra (vpn-225-124.phx2.redhat.com [10.3.225.124])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFdDOX032640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:41:20 -0400
Date: Mon, 11 Oct 2010 12:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] V4L/DVB: tm6000-alsa: fix some locking issues
Message-ID: <20101011123717.1be2d1ae@pedra>
In-Reply-To: <cover.1286807828.git.mchehab@redhat.com>
References: <cover.1286807828.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those locking issues affect tvtime, causing a kernel oops/panic, due to
a race condition.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index c4cfcab..9c3a926 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -462,6 +462,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USBLIVE2},
 	{USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000, 0x4001),
 	 .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},
+	{USB_DEVICE(0x1b80, 0xe424),
+	 .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},
 	{},
 };
 
diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index a99101f..e379e3e 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -201,6 +201,14 @@ _error:
  */
 static int snd_tm6000_close(struct snd_pcm_substream *substream)
 {
+	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
+	struct tm6000_core *core = chip->core;
+
+	if (atomic_read(&core->stream_started) > 0) {
+		atomic_set(&core->stream_started, 0);
+		schedule_work(&core->wq_trigger);
+	}
+
 	return 0;
 }
 
@@ -213,6 +221,9 @@ static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
 	unsigned int stride, buf_pos;
 	int length;
 
+	if (atomic_read(&core->stream_started) == 0)
+		return 0;
+
 	if (!size || !substream) {
 		dprintk(1, "substream was NULL\n");
 		return -EINVAL;
@@ -298,8 +309,12 @@ static int snd_tm6000_hw_params(struct snd_pcm_substream *substream,
 static int snd_tm6000_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
+	struct tm6000_core *core = chip->core;
 
-	_tm6000_stop_audio_dma(chip);
+	if (atomic_read(&core->stream_started) > 0) {
+		atomic_set(&core->stream_started, 0);
+		schedule_work(&core->wq_trigger);
+	}
 
 	return 0;
 }
@@ -321,30 +336,42 @@ static int snd_tm6000_prepare(struct snd_pcm_substream *substream)
 /*
  * trigger callback
  */
+static void audio_trigger(struct work_struct *work)
+{
+	struct tm6000_core *core = container_of(work, struct tm6000_core,
+						wq_trigger);
+	struct snd_tm6000_card *chip = core->adev;
+
+	if (atomic_read(&core->stream_started)) {
+		dprintk(1, "starting capture");
+		_tm6000_start_audio_dma(chip);
+	} else {
+		dprintk(1, "stopping capture");
+		_tm6000_stop_audio_dma(chip);
+	}
+}
+
 static int snd_tm6000_card_trigger(struct snd_pcm_substream *substream, int cmd)
 {
 	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
-	int err;
-
-	spin_lock(&chip->reg_lock);
+	struct tm6000_core *core = chip->core;
+	int err = 0;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-		err = _tm6000_start_audio_dma(chip);
+		atomic_set(&core->stream_started, 1);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		err = _tm6000_stop_audio_dma(chip);
+		atomic_set(&core->stream_started, 0);
 		break;
 	default:
 		err = -EINVAL;
 		break;
 	}
-
-	spin_unlock(&chip->reg_lock);
+	schedule_work(&core->wq_trigger);
 
 	return err;
 }
-
 /*
  * pointer callback
  */
@@ -437,6 +464,7 @@ int tm6000_audio_init(struct tm6000_core *dev)
 
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_tm6000_pcm_ops);
 
+	INIT_WORK(&dev->wq_trigger, audio_trigger);
 	rc = snd_card_register(card);
 	if (rc < 0)
 		goto error;
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 1ec1bff..5d9dcab 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -205,6 +205,9 @@ struct tm6000_core {
 
 	/* audio support */
 	struct snd_tm6000_card		*adev;
+	struct work_struct		wq_trigger;   /* Trigger to start/stop audio for alsa module */
+	atomic_t			stream_started;  /* stream should be running if true */
+
 
 	struct tm6000_IR		*ir;
 
-- 
1.7.1


