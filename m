Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33993 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbbJJQvZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 12:51:25 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv5 11/13] hackrf: do not set human readable name for formats
Date: Sat, 10 Oct 2015 19:51:07 +0300
Message-Id: <1444495869-1969-12-git-send-email-crope@iki.fi>
In-Reply-To: <1444495869-1969-1-git-send-email-crope@iki.fi>
References: <1444495869-1969-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Format names are set by core nowadays. Remove name from driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hackrf/hackrf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index b64acbb..a2fe582 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -70,7 +70,6 @@ static const struct v4l2_frequency_band bands_rx_tx[] = {
 
 /* stream formats */
 struct hackrf_format {
-	char	*name;
 	u32	pixelformat;
 	u32	buffersize;
 };
@@ -78,7 +77,6 @@ struct hackrf_format {
 /* format descriptions for capture and preview */
 static struct hackrf_format formats[] = {
 	{
-		.name		= "Complex S8",
 		.pixelformat	= V4L2_SDR_FMT_CS8,
 		.buffersize	= BULK_BUFFER_SIZE,
 	},
@@ -1008,7 +1006,6 @@ static int hackrf_enum_fmt_sdr(struct file *file, void *priv,
 	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
 	f->pixelformat = formats[f->index].pixelformat;
 
 	return 0;
-- 
http://palosaari.fi/

