Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38167 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab0I0NE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:04:27 -0400
Received: by bwz11 with SMTP id 11so3244338bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:04:25 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 05/13] Staging: cx25821: fix space coding style issue in cx25821-i2c.c
Date: Mon, 27 Sep 2010 16:04:14 +0300
Message-Id: <1285592654-32374-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the cx25821-i2c.c file that fixed up a space warning found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index e43572e..2b14bcc 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -283,7 +283,7 @@ static struct i2c_algorithm cx25821_i2c_algo_template = {
 	.master_xfer = i2c_xfer,
 	.functionality = cx25821_functionality,
 #ifdef NEED_ALGO_CONTROL
-       .algo_control = dummy_algo_control,
+	.algo_control = dummy_algo_control,
 #endif
 };
 
-- 
1.7.0.4

