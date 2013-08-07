Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51403 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/16] msi3101: add debug dump for unknown stream data
Date: Wed,  7 Aug 2013 21:51:39 +0300
Message-Id: <1375901507-26661-9-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dump all unknown 'garbage' data - maybe we will discover someday if there
is something rational...

Also fix comment in USB frame description.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 152415a..2b73fc1 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -432,7 +432,7 @@ leave:
 
 /*
  * +===========================================================================
- * |   00-1024 | USB packet
+ * |   00-1023 | USB packet
  * +===========================================================================
  * |   00-  03 | sequence number of first sample in that USB packet
  * +---------------------------------------------------------------------------
@@ -462,7 +462,7 @@ leave:
  * +---------------------------------------------------------------------------
  * |  996- 999 | control bits for previous samples
  * +---------------------------------------------------------------------------
- * | 1000-1024 | garbage
+ * | 1000-1023 | garbage
  * +---------------------------------------------------------------------------
  *
  * Bytes 4 - 7 could have some meaning?
@@ -522,7 +522,7 @@ static u32 msi3101_convert_sample(struct msi3101_state *s, u16 x, int shift)
 #define MSI3101_CONVERT_IN_URB_HANDLER
 #define MSI3101_EXTENSIVE_DEBUG
 static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
-		const u8 *src, unsigned int src_len)
+		u8 *src, unsigned int src_len)
 {
 	int i, j, k, l, i_max, dst_len = 0;
 	u16 sample[4];
@@ -541,6 +541,15 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 					sample_num[0] - s->next_sample,
 					src_len, s->next_sample, sample_num[0]);
 		}
+
+		/*
+		 * Dump all unknown 'garbage' data - maybe we will discover
+		 * someday if there is something rational...
+		 */
+		dev_dbg_ratelimited(&s->udev->dev,
+				"%*ph  %*ph\n", 12, &src[4], 24, &src[1000]);
+		memset(&src[4], 0, 12);
+		memset(&src[1000], 0, 24);
 #endif
 		src += 16;
 		for (j = 0; j < 6; j++) {
-- 
1.7.11.7

