Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:39290 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbeFGHMU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 03:12:20 -0400
Date: Thu, 7 Jun 2018 04:12:16 -0300
From: Gabriel Fanelli <gabrielfanelli61@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: bcm2048: match alignment with open
 parenthesis
Message-ID: <20180607071216.GA31855@kaufman.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the checkpatch.pl issue:

CHECK: Alignment should match open parenthesis

Signed-off-by: Gabriel Fanelli <gabrielfanelli61@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 06d1920150da..a90b2eb112f9 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2175,7 +2175,7 @@ static int bcm2048_fops_release(struct file *file)
 }
 
 static __poll_t bcm2048_fops_poll(struct file *file,
-				      struct poll_table_struct *pts)
+				  struct poll_table_struct *pts)
 {
 	struct bcm2048_device *bdev = video_drvdata(file);
 	__poll_t retval = 0;
-- 
2.17.1
