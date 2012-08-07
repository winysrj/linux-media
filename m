Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab2HGCrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:47 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:47 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 02/24] au8522: Fix off-by-one in SNR table for QAM256
Date: Mon,  6 Aug 2012 22:46:52 -0400
Message-Id: <1344307634-11673-3-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The table of valid SNR values for QAM 256 is off by one, and as a result if
the SNR is oscillating between 40.0 and 39.9 dB, tools like azap show it
going back and forth between 40.0 and 0 (misleading some people, including
myself, to think signal lock is being lost or there is a problem with register
reads).

Fix the table so that 40.0 dB is properly represented.

Cc: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb/frontends/au8522_dig.c |   96 +++++++++++++++---------------
 1 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb/frontends/au8522_dig.c
index 5fc70d6..ee8cf81 100644
--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -157,54 +157,54 @@ static struct mse2snr_tab qam64_mse2snr_tab[] = {
 
 /* QAM256 SNR lookup table */
 static struct mse2snr_tab qam256_mse2snr_tab[] = {
-	{  16,   0 },
-	{  17, 400 },
-	{  18, 398 },
-	{  19, 396 },
-	{  20, 394 },
-	{  21, 392 },
-	{  22, 390 },
-	{  23, 388 },
-	{  24, 386 },
-	{  25, 384 },
-	{  26, 382 },
-	{  27, 380 },
-	{  28, 379 },
-	{  29, 378 },
-	{  30, 377 },
-	{  31, 376 },
-	{  32, 375 },
-	{  33, 374 },
-	{  34, 373 },
-	{  35, 372 },
-	{  36, 371 },
-	{  37, 370 },
-	{  38, 362 },
-	{  39, 354 },
-	{  40, 346 },
-	{  41, 338 },
-	{  42, 330 },
-	{  43, 328 },
-	{  44, 326 },
-	{  45, 324 },
-	{  46, 322 },
-	{  47, 320 },
-	{  48, 319 },
-	{  49, 318 },
-	{  50, 317 },
-	{  51, 316 },
-	{  52, 315 },
-	{  53, 314 },
-	{  54, 313 },
-	{  55, 312 },
-	{  56, 311 },
-	{  57, 310 },
-	{  58, 308 },
-	{  59, 306 },
-	{  60, 304 },
-	{  61, 302 },
-	{  62, 300 },
-	{  63, 298 },
+	{  15,   0 },
+	{  16, 400 },
+	{  17, 398 },
+	{  18, 396 },
+	{  19, 394 },
+	{  20, 392 },
+	{  21, 390 },
+	{  22, 388 },
+	{  23, 386 },
+	{  24, 384 },
+	{  25, 382 },
+	{  26, 380 },
+	{  27, 379 },
+	{  28, 378 },
+	{  29, 377 },
+	{  30, 376 },
+	{  31, 375 },
+	{  32, 374 },
+	{  33, 373 },
+	{  34, 372 },
+	{  35, 371 },
+	{  36, 370 },
+	{  37, 362 },
+	{  38, 354 },
+	{  39, 346 },
+	{  40, 338 },
+	{  41, 330 },
+	{  42, 328 },
+	{  43, 326 },
+	{  44, 324 },
+	{  45, 322 },
+	{  46, 320 },
+	{  47, 319 },
+	{  48, 318 },
+	{  49, 317 },
+	{  50, 316 },
+	{  51, 315 },
+	{  52, 314 },
+	{  53, 313 },
+	{  54, 312 },
+	{  55, 311 },
+	{  56, 310 },
+	{  57, 308 },
+	{  58, 306 },
+	{  59, 304 },
+	{  60, 302 },
+	{  61, 300 },
+	{  62, 298 },
 	{  65, 295 },
 	{  68, 294 },
 	{  70, 293 },
-- 
1.7.1

