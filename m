Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46546 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199AbaBAOYr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:24:47 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/17] msi3101: add default FMT and ADC frequency
Date: Sat,  1 Feb 2014 16:24:25 +0200
Message-Id: <1391264674-4395-9-git-send-email-crope@iki.fi>
In-Reply-To: <1391264674-4395-1-git-send-email-crope@iki.fi>
References: <1391264674-4395-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Default ADC to smallest/worst possible configuration on probe.
Also enhance some FMT debug logs.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 0a2bb12..061c705 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1339,7 +1339,7 @@ static int msi3101_enum_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_fmtdesc *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, f->index);
 
 	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
@@ -1354,7 +1354,8 @@ static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+			(char *)&s->pixelformat);
 
 	f->fmt.sdr.pixelformat = s->pixelformat;
 
@@ -1631,8 +1632,9 @@ static int msi3101_probe(struct usb_interface *intf,
 	mutex_init(&s->vb_queue_lock);
 	spin_lock_init(&s->queued_bufs_lock);
 	INIT_LIST_HEAD(&s->queued_bufs);
-
 	s->udev = udev;
+	s->f_adc = bands_adc[0].rangelow;
+	s->pixelformat = V4L2_PIX_FMT_SDR_U8;
 
 	/* Init videobuf2 queue structure */
 	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
-- 
1.8.5.3

