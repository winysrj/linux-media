Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43085 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab3HQXKn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 19:10:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH STAGING 2/3] msi3101: change stream format 384
Date: Sun, 18 Aug 2013 02:09:31 +0300
Message-Id: <1376780972-8977-3-git-send-email-crope@iki.fi>
In-Reply-To: <1376780972-8977-1-git-send-email-crope@iki.fi>
References: <1376780972-8977-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After feeding different signal levels using RF generator and looking
GNU Radio FFT sink I made decision to change bit shift 3 to bit shift
2 as there was very (too) huge visible leap in FFT sink GUI. Now it
looks more natural.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index bf735f9..839e601 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -589,7 +589,7 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u32 *dst,
 }
 
 /*
- * Converts signed ~10+3-bit integer into 32-bit IEEE floating point
+ * Converts signed ~10+2-bit integer into 32-bit IEEE floating point
  * representation.
  */
 static u32 msi3101_convert_sample_384(struct msi3101_state *s, u16 x, int shift)
@@ -601,12 +601,15 @@ static u32 msi3101_convert_sample_384(struct msi3101_state *s, u16 x, int shift)
 	if (!x)
 		return 0;
 
-	/* Convert 10-bit two's complement to 13-bit */
+	if (shift == 3)
+		shift =	2;
+
+	/* Convert 10-bit two's complement to 12-bit */
 	if (x & (1 << 9)) {
 		x |= ~0U << 10; /* set all the rest bits to one */
 		x <<= shift;
 		x = -x;
-		x &= 0xfff; /* result is 12 bit ... + sign */
+		x &= 0x7ff; /* result is 11 bit ... + sign */
 		sign = 1 << 31;
 	} else {
 		x <<= shift;
-- 
1.7.11.7

