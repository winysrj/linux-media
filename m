Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025Ab2AKAWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:22:15 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0B0MFvb024949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 19:22:15 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/6] [media] cx231xx: fix device disconnect checks
Date: Tue, 10 Jan 2012 22:20:26 -0200
Message-Id: <1326241226-6734-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
References: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver were using DEV_MISCONFIGURED on some places, and
DEV_DISCONNECTED on others. In a matter of fact, DEV_MISCONFIGURED
were set only during the usb disconnect callback, with
was confusing.

Also, the alsa driver never checks if the device is present,
before doing some dangerous things.

Remove DEV_MISCONFIGURED, replacing it by DEV_DISCONNECTED.

Also, fixes the other usecases for DEV_DISCONNECTED.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/cx231xx/cx231xx-audio.c |   20 ++++++++++++++++++++
 drivers/media/video/cx231xx/cx231xx-cards.c |    5 ++---
 drivers/media/video/cx231xx/cx231xx-dvb.c   |    4 ++--
 drivers/media/video/cx231xx/cx231xx-vbi.c   |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c |   14 ++++----------
 drivers/media/video/cx231xx/cx231xx.h       |    1 -
 6 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-audio.c b/drivers/media/video/cx231xx/cx231xx-audio.c
index 30d13c1..e5742a0 100644
--- a/drivers/media/video/cx231xx/cx231xx-audio.c
+++ b/drivers/media/video/cx231xx/cx231xx-audio.c
@@ -111,6 +111,9 @@ static void cx231xx_audio_isocirq(struct urb *urb)
 	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime *runtime;
 
+	if (dev->state & DEV_DISCONNECTED)
+		return;
+
 	switch (urb->status) {
 	case 0:		/* success */
 	case -ETIMEDOUT:	/* NAK */
@@ -196,6 +199,9 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
 	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime *runtime;
 
+	if (dev->state & DEV_DISCONNECTED)
+		return;
+
 	switch (urb->status) {
 	case 0:		/* success */
 	case -ETIMEDOUT:	/* NAK */
@@ -273,6 +279,9 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 
 	cx231xx_info("%s: Starting ISO AUDIO transfers\n", __func__);
 
+	if (dev->state & DEV_DISCONNECTED)
+		return -ENODEV;
+
 	sb_size = CX231XX_ISO_NUM_AUDIO_PACKETS * dev->adev.max_pkt_size;
 
 	for (i = 0; i < CX231XX_AUDIO_BUFS; i++) {
@@ -331,6 +340,9 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 
 	cx231xx_info("%s: Starting BULK AUDIO transfers\n", __func__);
 
+	if (dev->state & DEV_DISCONNECTED)
+		return -ENODEV;
+
 	sb_size = CX231XX_NUM_AUDIO_PACKETS * dev->adev.max_pkt_size;
 
 	for (i = 0; i < CX231XX_AUDIO_BUFS; i++) {
@@ -432,6 +444,11 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 		return -ENODEV;
 	}
 
+	if (dev->state & DEV_DISCONNECTED) {
+		cx231xx_errdev("Can't open. the device was removed.\n");
+		return -ENODEV;
+	}
+
 	/* Sets volume, mute, etc */
 	dev->mute = 0;
 
@@ -571,6 +588,9 @@ static int snd_cx231xx_capture_trigger(struct snd_pcm_substream *substream,
 	struct cx231xx *dev = snd_pcm_substream_chip(substream);
 	int retval;
 
+	if (dev->state & DEV_DISCONNECTED)
+		return -ENODEV;
+
 	spin_lock(&dev->adev.slock);
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 1f2fbbf..7577e6e 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -1337,6 +1337,8 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 	if (!dev->udev)
 		return;
 
+	dev->state |= DEV_DISCONNECTED;
+
 	flush_request_modules(dev);
 
 	/* wait until all current v4l2 io is finished then deallocate
@@ -1354,16 +1356,13 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 		/* Even having users, it is safe to remove the RC i2c driver */
 		cx231xx_ir_exit(dev);
 
-		dev->state |= DEV_MISCONFIGURED;
 		if (dev->USE_ISO)
 			cx231xx_uninit_isoc(dev);
 		else
 			cx231xx_uninit_bulk(dev);
-		dev->state |= DEV_DISCONNECTED;
 		wake_up_interruptible(&dev->wait_frame);
 		wake_up_interruptible(&dev->wait_stream);
 	} else {
-		dev->state |= DEV_DISCONNECTED;
 	}
 
 	cx231xx_close_extension(dev);
diff --git a/drivers/media/video/cx231xx/cx231xx-dvb.c b/drivers/media/video/cx231xx/cx231xx-dvb.c
index da9a4a0..7c4e360 100644
--- a/drivers/media/video/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/video/cx231xx/cx231xx-dvb.c
@@ -196,7 +196,7 @@ static inline int dvb_isoc_copy(struct cx231xx *dev, struct urb *urb)
 	if (!dev)
 		return 0;
 
-	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
+	if (dev->state & DEV_DISCONNECTED)
 		return 0;
 
 	if (urb->status < 0) {
@@ -228,7 +228,7 @@ static inline int dvb_bulk_copy(struct cx231xx *dev, struct urb *urb)
 	if (!dev)
 		return 0;
 
-	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
+	if (dev->state & DEV_DISCONNECTED)
 		return 0;
 
 	if (urb->status < 0) {
diff --git a/drivers/media/video/cx231xx/cx231xx-vbi.c b/drivers/media/video/cx231xx/cx231xx-vbi.c
index 1c7a4da..9c5967e 100644
--- a/drivers/media/video/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/video/cx231xx/cx231xx-vbi.c
@@ -93,7 +93,7 @@ static inline int cx231xx_isoc_vbi_copy(struct cx231xx *dev, struct urb *urb)
 	if (!dev)
 		return 0;
 
-	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
+	if (dev->state & DEV_DISCONNECTED)
 		return 0;
 
 	if (urb->status < 0) {
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 6e81f97..829a41b 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -337,7 +337,7 @@ static inline int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
 	if (!dev)
 		return 0;
 
-	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
+	if (dev->state & DEV_DISCONNECTED)
 		return 0;
 
 	if (urb->status < 0) {
@@ -440,7 +440,7 @@ static inline int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
 	if (!dev)
 		return 0;
 
-	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
+	if (dev->state & DEV_DISCONNECTED)
 		return 0;
 
 	if (urb->status < 0) {
@@ -1000,12 +1000,6 @@ static int check_dev(struct cx231xx *dev)
 		cx231xx_errdev("v4l2 ioctl: device not present\n");
 		return -ENODEV;
 	}
-
-	if (dev->state & DEV_MISCONFIGURED) {
-		cx231xx_errdev("v4l2 ioctl: device is misconfigured; "
-			       "close and open it again\n");
-		return -EIO;
-	}
 	return 0;
 }
 
@@ -2347,7 +2341,8 @@ static int cx231xx_v4l2_close(struct file *filp)
 			return 0;
 		}
 
-	if (dev->users == 1) {
+	dev->users--;
+	if (!dev->users) {
 		videobuf_stop(&fh->vb_vidq);
 		videobuf_mmap_free(&fh->vb_vidq);
 
@@ -2374,7 +2369,6 @@ static int cx231xx_v4l2_close(struct file *filp)
 		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 0);
 	}
 	kfree(fh);
-	dev->users--;
 	wake_up_interruptible_nr(&dev->open, 1);
 	return 0;
 }
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 5d498a4..e174475 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -377,7 +377,6 @@ struct cx231xx_board {
 enum cx231xx_dev_state {
 	DEV_INITIALIZED = 0x01,
 	DEV_DISCONNECTED = 0x02,
-	DEV_MISCONFIGURED = 0x04,
 };
 
 enum AFE_MODE {
-- 
1.7.7.5

