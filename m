Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34755 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbaHYRMQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/12] rtl2832_sdr: enhance sample rate debug calculation precision
Date: Mon, 25 Aug 2014 20:11:57 +0300
Message-Id: <1408986718-3881-11-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sample rate calculation gives a little bit too large results because
in real life there was around one milliseconds (~one usb packet) too
much data for given time. Calculate time more accurate in order to
provide better results.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index ba305a0..4f75753 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -365,17 +365,19 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
 		dst_len = 0;
 	}
 
-	/* calculate samping rate and output it in 10 seconds intervals */
+	/* calculate sample rate and output it in 10 seconds intervals */
 	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
-#define MSECS 10000UL
+		#define MSECS 10000UL
+		unsigned int msecs = jiffies_to_msecs(jiffies -
+				s->jiffies_next + msecs_to_jiffies(MSECS));
 		unsigned int samples = s->sample - s->sample_measured;
 
 		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample_measured = s->sample;
 		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, MSECS,
-				samples * 1000UL / MSECS);
+				"slen=%u samples=%u msecs=%u sample rate=%lu\n",
+				src_len, samples, msecs,
+				samples * 1000UL / msecs);
 	}
 
 	/* total number of I+Q pairs */
-- 
http://palosaari.fi/

