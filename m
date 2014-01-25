Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56053 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbaAYRLJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 45/52] rtl2832_sdr: remove FMT buffer type checks
Date: Sat, 25 Jan 2014 19:10:39 +0200
Message-Id: <1390669846-8131-46-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unneeded buffer type checks from FMT IOTCL handlers. Checks
are already done by V4L core.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 0bc417d..d101409 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -1191,9 +1191,6 @@ static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
-		return -EINVAL;
-
 	f->fmt.sdr.pixelformat = s->pixelformat;
 
 	return 0;
@@ -1208,9 +1205,6 @@ static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&f->fmt.sdr.pixelformat);
 
-	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
-		return -EINVAL;
-
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
@@ -1235,9 +1229,6 @@ static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
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

