Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36325 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbbKXVaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2015 16:30:23 -0500
Received: by iofh3 with SMTP id h3so34413276iof.3
        for <linux-media@vger.kernel.org>; Tue, 24 Nov 2015 13:30:22 -0800 (PST)
Date: Tue, 24 Nov 2015 21:30:18 +0000
From: Joseph Marrero <jmarrero@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH] This patch fixes a warning message found by checkpatch.pl
 WARNING: suspect code indent for conditional statements
Message-ID: <20151124213018.GA1595@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Joseph Marrero <jmarrero@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 19fcb1c..8fdf0ac 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -999,8 +999,8 @@ static int bcm2048_set_fm_search_tune_mode(struct bcm2048_device *bdev,
 		timeout = BCM2048_AUTO_SEARCH_TIMEOUT;
 
 	if (!wait_for_completion_timeout(&bdev->compl,
-			msecs_to_jiffies(timeout)))
-			dev_err(&bdev->client->dev, "IRQ timeout.\n");
+		msecs_to_jiffies(timeout)))
+		dev_err(&bdev->client->dev, "IRQ timeout.\n");
 
 	if (value)
 		if (!bdev->scan_state)
-- 
2.5.0

