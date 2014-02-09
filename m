Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49538 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaBIIt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:59 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 33/86] msi3101: remove FMT buffer type checks
Date: Sun,  9 Feb 2014 10:48:38 +0200
Message-Id: <1391935771-18670-34-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unneeded buffer type checks from FMT IOTCL handlers. Checks
are already done by V4L core.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 02960c7..6b9f0da 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1679,9 +1679,6 @@ static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
 	struct msi3101_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
-		return -EINVAL;
-
 	f->fmt.sdr.pixelformat = s->pixelformat;
 
 	return 0;
@@ -1696,9 +1693,6 @@ static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&f->fmt.sdr.pixelformat);
 
-	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
-		return -EINVAL;
-
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
@@ -1723,9 +1717,6 @@ static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&f->fmt.sdr.pixelformat);
 
-	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
-		return -EINVAL;
-
 	for (i = 0; i < NUM_FORMATS; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
 			return 0;
-- 
1.8.5.3

