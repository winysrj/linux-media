Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59563 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0JUTWZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 15:22:25 -0400
Date: Thu, 21 Oct 2010 21:22:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@hauppauge.com>,
	Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: cx231xx: fix double lock typo
Message-ID: <20101021192214.GI5985@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This was supposed to be an unlock on the error path.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-i2c.c b/drivers/media/video/cx231xx/cx231xx-i2c.c
index cce74e5..8356706 100644
--- a/drivers/media/video/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/video/cx231xx/cx231xx-i2c.c
@@ -372,7 +372,7 @@ static int cx231xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			rc = cx231xx_i2c_check_for_device(i2c_adap, &msgs[i]);
 			if (rc < 0) {
 				dprintk2(2, " no device\n");
-				mutex_lock(&dev->i2c_lock);
+				mutex_unlock(&dev->i2c_lock);
 				return rc;
 			}
 
