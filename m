Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36898 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab2DKAzr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 20:55:47 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: trivial@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 03/11] cx231xx: replace open-coded ARRAY_SIZE with macro
Date: Tue, 10 Apr 2012 18:55:40 -0600
Message-Id: <1334105740-9120-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/media/video/cx231xx/cx231xx-avcore.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index 53ff26e..460d148 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -1606,8 +1606,8 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 	}
 
 	cx231xx_info("Enter IF=%zd\n",
-			sizeof(Dif_set_array)/sizeof(struct dif_settings));
-	for (i = 0; i < sizeof(Dif_set_array)/sizeof(struct dif_settings); i++) {
+			ARRAY_SIZE(Dif_set_array));
+	for (i = 0; i < ARRAY_SIZE(Dif_set_array); i++) {
 		if (Dif_set_array[i].if_freq == if_freq) {
 			status = vid_blk_write_word(dev,
 			Dif_set_array[i].register_address, Dif_set_array[i].value);
-- 
1.7.8.1

