Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58605 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbaHYRMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/12] airspy: coding style issues
Date: Mon, 25 Aug 2014 20:11:48 +0300
Message-Id: <1408986718-3881-2-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix issues reported by checkpatch.pl.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/airspy/airspy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 56a1ae0..dee1fe2 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -255,6 +255,7 @@ static unsigned int airspy_convert_stream(struct airspy *s,
 	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
 		#define MSECS 10000UL
 		unsigned int samples = s->sample - s->sample_measured;
+
 		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample_measured = s->sample;
 		dev_dbg(&s->udev->dev,
@@ -462,6 +463,7 @@ static void airspy_cleanup_queued_bufs(struct airspy *s)
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
 	while (!list_empty(&s->queued_bufs)) {
 		struct airspy_frame_buf *buf;
+
 		buf = list_entry(s->queued_bufs.next,
 				struct airspy_frame_buf, list);
 		list_del(&buf->list);
@@ -772,6 +774,7 @@ static int airspy_g_frequency(struct file *file, void *priv,
 {
 	struct airspy *s = video_drvdata(file);
 	int ret  = 0;
+
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
 			__func__, f->tuner, f->type);
 
@@ -829,6 +832,7 @@ static int airspy_enum_freq_bands(struct file *file, void *priv,
 {
 	struct airspy *s = video_drvdata(file);
 	int ret;
+
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
 			__func__, band->tuner, band->type, band->index);
 
-- 
http://palosaari.fi/

