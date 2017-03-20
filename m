Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22683 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754843AbdCTOw4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:52:56 -0400
Subject: [PATCH 07/24] ov5693: remove unused function
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:39:56 +0000
Message-ID: <149002078811.17109.12866139241727781113.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's commented out in the tree with a note saying to remove it. So let's remove it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c |   23 ---------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index ac75982..5e9dafe 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -82,30 +82,7 @@ static int vcm_ad_i2c_wr8(struct i2c_client *client, u8 reg, u8 val)
 	}
 	return 0;
 }
-/*TODO: remove this unuseful i2c writer helper*/
-/*
-static int vcm_ad_i2c_wr16(struct i2c_client *client, u8 reg, u16 val)
-{
-	int err;
-	struct i2c_msg msg;
-	u8 buf[3];
-	buf[0] = reg;
-	buf[1] = (u8)(val >> 8);
-	buf[2] = (u8)(val & 0xff);
-	msg.addr = VCM_ADDR;
-	msg.flags = 0;
-	msg.len = 3;
-	msg.buf = &buf[0];
 
-	err = i2c_transfer(client->adapter, &msg, 1);
-	if (err != 1) {
-		dev_err(&client->dev, "%s: vcm i2c fail, err code = %d\n",
-			__func__, err);
-		return -EIO;
-	}
-	return 0;
-}
-*/
 static int ad5823_i2c_write(struct i2c_client *client, u8 reg, u8 val)
 {
 	struct i2c_msg msg;
