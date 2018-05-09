Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr50112.outbound.protection.outlook.com ([40.107.5.112]:56668
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965773AbeEITsU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 15:48:20 -0400
From: Peter Rosin <peda@axentia.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] saa7146: fix error return from master_xfer
Date: Wed,  9 May 2018 21:48:07 +0200
Message-Id: <20180509194807.29286-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Returning -1 (-EPERM) is not appropriate here, go with -EIO.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/common/saa7146/saa7146_i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_i2c.c b/drivers/media/common/saa7146/saa7146_i2c.c
index f9e099d812c8..3feddc52c446 100644
--- a/drivers/media/common/saa7146/saa7146_i2c.c
+++ b/drivers/media/common/saa7146/saa7146_i2c.c
@@ -308,7 +308,7 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 	/* prepare the message(s), get number of u32s to transfer */
 	count = saa7146_i2c_msg_prepare(msgs, num, buffer);
 	if ( 0 > count ) {
-		err = -1;
+		err = -EIO;
 		goto out;
 	}
 
@@ -360,7 +360,7 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 	/* if any things had to be read, get the results */
 	if ( 0 != saa7146_i2c_msg_cleanup(msgs, num, buffer)) {
 		DEB_I2C("could not cleanup i2c-message\n");
-		err = -1;
+		err = -EIO;
 		goto out;
 	}
 
-- 
2.11.0
