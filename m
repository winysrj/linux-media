Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33505 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdF2L3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 07:29:47 -0400
From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tamara Diaconita <diaconitatamara@gmail.com>,
        Jasmin Jessich <jasmin@anw.at>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Pushkar Jambhlekar <pushkar.iit@gmail.com>,
        Eva Rachel Retuya <eraretuya@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/media:  Prefer using  __func__ instead
Date: Thu, 29 Jun 2017 16:59:26 +0530
Message-Id: <1498735766-3068-1-git-send-email-pushkar.iit@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function name is hardcoded. replacing with __func__

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
---
 drivers/staging/media/cxd2099/cxd2099.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index f28916e..c866752 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -100,7 +100,7 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
 				   .buf = val, .len = 1} };
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		dev_err(&adapter->dev, "error in i2c_read_reg\n");
+		dev_err(&adapter->dev, "error in %s\n", __func__);
 		return -1;
 	}
 	return 0;
@@ -115,7 +115,7 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr,
 				   .buf = data, .len = n} };
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		dev_err(&adapter->dev, "error in i2c_read\n");
+		dev_err(&adapter->dev, "error in %s\n",__func__);
 		return -1;
 	}
 	return 0;
-- 
2.7.4
