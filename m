Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52388 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbeC1Lqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 07:46:50 -0400
Date: Wed, 28 Mar 2018 14:46:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: dvb-core: Check for allocation failure in
 dvb_module_probe()
Message-ID: <20180328114640.GA29050@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should check if kzalloc() fails.

Fixes: 8f569c0b4e6b ("media: dvb-core: add helper functions for I2C binding")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index cf747d753a79..787fe06df217 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -953,6 +953,8 @@ struct i2c_client *dvb_module_probe(const char *module_name,
 	struct i2c_board_info *board_info;
 
 	board_info = kzalloc(sizeof(*board_info), GFP_KERNEL);
+	if (!board_info)
+		return NULL;
 
 	if (name)
 		strlcpy(board_info->type, name, I2C_NAME_SIZE);
