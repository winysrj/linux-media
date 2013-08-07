Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34637 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/16] msi3101: changes for tuner PLL freq limits
Date: Wed,  7 Aug 2013 21:51:46 +0300
Message-Id: <1375901507-26661-16-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I made some tuner freq limit tests against RF signal generator.
Adjust some PLL limits according to these test results.

Here are the results, taken from two different devices.
Numbers are RF limits and calculated and VCO limits.

Mirics MSi3101 SDR Dongle:
VHF_MODE  52 - 132  1664 - 4224
B3_MODE  103 - 263  1648 - 4208
B45_MODE 413 - 960  1652 - 3840

Hauppauge WinTV 133559 LF:
VHF_MODE  49 - 130  1568 - 4160
B3_MODE   98 - 259  1568 - 4144
B45_MODE 391 - 960  1564 - 3840

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index c4bd963..e7a21a2 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1306,11 +1306,11 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 		u8 mode;
 		u8 lo_div;
 	} band_lut[] = {
-		{ 30000000, 0x01, 16}, /* AM_MODE1 */
+		{ 47000000, 0x01, 16}, /* AM_MODE1 */
 		{108000000, 0x02, 32}, /* VHF_MODE */
-		{240000000, 0x04, 16}, /* B3_MODE */
+		{330000000, 0x04, 16}, /* B3_MODE */
 		{960000000, 0x08,  4}, /* B45_MODE */
-		{167500000, 0x10,  2}, /* BL_MODE */
+		{      ~0U, 0x10,  2}, /* BL_MODE */
 	};
 	static const struct {
 		u32 freq;
-- 
1.7.11.7

