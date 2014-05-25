Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60905 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaEYMjr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 08:39:47 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: crope@iki.fi
Cc: m.chehab@samsung.com, gregkh@linuxfoundation.org,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	=?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] msi3103: Use time_before_eq()
Date: Sun, 25 May 2014 14:39:39 +0200
Message-Id: <1401021579-22481-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To be future-proof and for better readability the time comparisons are
modified to use time_before_eq() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/staging/media/msi3101/sdr-msi3101.c |   28 +++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 65d351f..7a0a8ca 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -207,10 +207,10 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
 		dst_len += 1008;
 	}
 
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	/* calculate sampling rate and output it in 10 seconds intervals */
+	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now - s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
 		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
@@ -265,7 +265,7 @@ static int msi3101_convert_stream_504_u8(struct msi3101_state *s, u8 *dst,
 		dst_len += 1008;
 	}
 
-	/* calculate samping rate and output it in 10 seconds intervals */
+	/* calculate sampling rate and output it in 10 seconds intervals */
 	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
 #define MSECS 10000UL
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
@@ -359,10 +359,10 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 		dst_len += 984;
 	}
 
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	/* calculate sampling rate and output it in 10 seconds intervals */
+	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now - s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
 		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
@@ -424,10 +424,10 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 		dst_len += 1008;
 	}
 
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	/* calculate sampling rate and output it in 10 seconds intervals */
+	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now - s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
 		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
@@ -487,10 +487,10 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
 		dst_len += 1008;
 	}
 
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	/* calculate sampling rate and output it in 10 seconds intervals */
+	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now - s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
 		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
@@ -560,7 +560,7 @@ static int msi3101_convert_stream_252_u16(struct msi3101_state *s, u8 *dst,
 		dst_len += 1008;
 	}
 
-	/* calculate samping rate and output it in 10 seconds intervals */
+	/* calculate sampling rate and output it in 10 seconds intervals */
 	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
 #define MSECS 10000UL
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-- 
1.7.10.4

