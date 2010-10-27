Return-path: <mchehab@pedra>
Received: from mail.pripojeni.net ([217.66.174.14]:45681 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0J0LsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 07:48:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	jirislaby@gmail.com, Devin Heitmueller <dheitmueller@hauppauge.com>
Subject: [PATCH 1/4] V4L: cx231xx, fix lock imbalance
Date: Wed, 27 Oct 2010 13:47:37 +0200
Message-Id: <1288180057-19656-1-git-send-email-jslaby@suse.cz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Stanse found that there is mutex_lock in a fail path of
cx231xx_i2c_xfer instead of mutex_unlock (i.e. double lock + leaving a
function in locked state). So fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@hauppauge.com>
---
 drivers/media/video/cx231xx/cx231xx-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
 
-- 
1.7.3.1


