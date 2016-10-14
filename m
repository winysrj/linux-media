Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48647 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755051AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal.gundjalam@gmail.com>,
        Claudiu Beznea <claudiu.beznea@gmail.com>,
        Joseph Marrero <jmarrero@gmail.com>,
        Sandhya Bankar <bankarsandhya512@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 10/25] [media] radio-bcm2048: don't ignore errors
Date: Fri, 14 Oct 2016 14:45:48 -0300
Message-Id: <936c737b983c97387a654febc7f9b71098d1b3a5.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove this warning:

drivers/staging/media/bcm2048/radio-bcm2048.c: In function 'bcm2048_set_rds_no_lock':
drivers/staging/media/bcm2048/radio-bcm2048.c:467:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
  int err;
      ^~~

By returning the error code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index ea15cc638097..4d9bd02ede47 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -482,6 +482,8 @@ static int bcm2048_set_rds_no_lock(struct bcm2048_device *bdev, u8 rds_on)
 					   flags);
 		memset(&bdev->rds_info, 0, sizeof(bdev->rds_info));
 	}
+	if (err)
+		return err;
 
 	return bcm2048_send_command(bdev, BCM2048_I2C_FM_RDS_SYSTEM,
 				    bdev->cache_fm_rds_system);
-- 
2.7.4


