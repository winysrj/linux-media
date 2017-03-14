Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28547 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdCNHzJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 03:55:09 -0400
Date: Tue, 14 Mar 2017 10:53:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
Subject: [patch] Staging: atomisp: kfreeing a devm allocated pointer
Message-ID: <20170314075352.GA6274@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We shouldn't pass devm allocated pointers to kfree() or it leads to a
double free.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/i2c/imx/otp_brcc064_e2prom.c b/drivers/staging/media/atomisp/i2c/imx/otp_brcc064_e2prom.c
index 242e934a6030..b11f90c5960c 100644
--- a/drivers/staging/media/atomisp/i2c/imx/otp_brcc064_e2prom.c
+++ b/drivers/staging/media/atomisp/i2c/imx/otp_brcc064_e2prom.c
@@ -69,7 +69,6 @@ void *brcc064_otp_read(struct v4l2_subdev *sd, u8 dev_addr,
 
 		r = i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
 		if (r != ARRAY_SIZE(msg)) {
-			kfree(buffer);
 			dev_err(&client->dev, "read failed at 0x%03x\n", addr);
 			return NULL;
 		}
diff --git a/drivers/staging/media/atomisp/i2c/imx/otp_e2prom.c b/drivers/staging/media/atomisp/i2c/imx/otp_e2prom.c
index ce4e7ab7781c..73d041f97811 100644
--- a/drivers/staging/media/atomisp/i2c/imx/otp_e2prom.c
+++ b/drivers/staging/media/atomisp/i2c/imx/otp_e2prom.c
@@ -79,7 +79,6 @@ void *e2prom_otp_read(struct v4l2_subdev *sd, u8 dev_addr,
 
 		r = i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
 		if (r != ARRAY_SIZE(msg)) {
-			kfree(buffer);
 			dev_err(&client->dev, "read failed at 0x%03x\n", addr);
 			return NULL;
 		}
