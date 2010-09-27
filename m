Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38167 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849Ab0I0NFG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:05:06 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3244338bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:05:05 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 07/13] Staging: cx25821: fix tabs and space coding style issue in cx25821-medusa-video.c
Date: Mon, 27 Sep 2010 16:04:56 +0300
Message-Id: <1285592696-32475-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the cx25821-medusa-video.c file that fixed up a tabs
    and space warnings found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821-medusa-video.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index ef9f2b8..1e11e0c 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -778,9 +778,9 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 
 int medusa_video_init(struct cx25821_dev *dev)
 {
-       u32 value = 0, tmp = 0;
-       int ret_val = 0;
-       int i = 0;
+	u32 value = 0, tmp = 0;
+	int ret_val = 0;
+	int i = 0;
 
 	mutex_lock(&dev->lock);
 
@@ -829,7 +829,7 @@ int medusa_video_init(struct cx25821_dev *dev)
 	/* select AFE clock to output mode */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL, &tmp);
 	value &= 0x83FFFFFF;
-       ret_val =
+	ret_val =
 	   cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
 			     value | 0x10000000);
 
-- 
1.7.0.4

