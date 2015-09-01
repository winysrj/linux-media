Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38752 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbbIAV7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 17:59:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/13] hackrf: do not set human readable name for formats
Date: Wed,  2 Sep 2015 00:59:27 +0300
Message-Id: <1441144769-29211-12-git-send-email-crope@iki.fi>
In-Reply-To: <1441144769-29211-1-git-send-email-crope@iki.fi>
References: <1441144769-29211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Format names are set by core nowadays. Remove name from driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hackrf/hackrf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index b6415b9..5878f19 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -69,7 +69,6 @@ static const struct v4l2_frequency_band bands_rx_tx[] = {
 
 /* stream formats */
 struct hackrf_format {
-	char	*name;
 	u32	pixelformat;
 	u32	buffersize;
 };
@@ -77,7 +76,6 @@ struct hackrf_format {
 /* format descriptions for capture and preview */
 static struct hackrf_format formats[] = {
 	{
-		.name		= "Complex S8",
 		.pixelformat	= V4L2_SDR_FMT_CS8,
 		.buffersize	= BULK_BUFFER_SIZE,
 	},
@@ -1006,7 +1004,6 @@ static int hackrf_enum_fmt_sdr(struct file *file, void *priv,
 	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
 	f->pixelformat = formats[f->index].pixelformat;
 
 	return 0;
-- 
http://palosaari.fi/

