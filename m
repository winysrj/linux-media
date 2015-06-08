Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48415 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbbFHJyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 05:54:05 -0400
Message-ID: <55756637.80607@xs4all.nl>
Date: Mon, 08 Jun 2015 11:53:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] stk1160: fix sequence handling
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the sequence counter: we're counting frames, not fields.

Also remove the unused 'field' field. That would only be needed if this driver
would support V4L2_FIELD_ALTERNATE.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 4d313ed..7291cca 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -194,6 +194,8 @@ static int stk1160_start_streaming(struct stk1160 *dev)
 	/* Start saa711x */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
 
+	dev->sequence = 0;
+
 	/* Start stk1160 */
 	stk1160_write_reg(dev, STK1160_DCTRL, 0xb3);
 	stk1160_write_reg(dev, STK1160_DCTRL+3, 0x00);
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 39f1aae..940c3ea 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -96,9 +96,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 {
 	struct stk1160_buffer *buf = dev->isoc_ctl.buf;
 
-	dev->field_count++;
-
-	buf->vb.v4l2_buf.sequence = dev->field_count >> 1;
+	buf->vb.v4l2_buf.sequence = dev->sequence++;
 	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	buf->vb.v4l2_buf.bytesused = buf->bytesused;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index abdea48..3922a6c 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -151,8 +151,7 @@ struct stk1160 {
 	v4l2_std_id norm;	  /* current norm */
 	struct stk1160_fmt *fmt;  /* selected format */
 
-	unsigned int field_count; /* not sure ??? */
-	enum v4l2_field field;    /* also not sure :/ */
+	unsigned int sequence;
 
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap;
