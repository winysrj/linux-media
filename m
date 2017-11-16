Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:56229 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965192AbdKPP1q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 10:27:46 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 3/4] [media] dibx000_common: Fix line continuation format
Date: Thu, 16 Nov 2017 07:27:28 -0800
Message-Id: <448d510e69dcf7a9195e2d378ddb17724c456221.1510845910.git.joe@perches.com>
In-Reply-To: <cover.1510845910.git.joe@perches.com>
References: <cover.1510845910.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Line continuations with excess spacing causes unexpected output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb-frontends/dibx000_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/dibx000_common.c b/drivers/media/dvb-frontends/dibx000_common.c
index bc28184c7fb0..d981233e458f 100644
--- a/drivers/media/dvb-frontends/dibx000_common.c
+++ b/drivers/media/dvb-frontends/dibx000_common.c
@@ -288,8 +288,8 @@ static int dibx000_i2c_gated_gpio67_xfer(struct i2c_adapter *i2c_adap,
 	int ret;
 
 	if (num > 32) {
-		dprintk("%s: too much I2C message to be transmitted (%i).\
-				Maximum is 32", __func__, num);
+		dprintk("%s: too much I2C message to be transmitted (%i). Maximum is 32",
+			__func__, num);
 		return -ENOMEM;
 	}
 
@@ -335,8 +335,8 @@ static int dibx000_i2c_gated_tuner_xfer(struct i2c_adapter *i2c_adap,
 	int ret;
 
 	if (num > 32) {
-		dprintk("%s: too much I2C message to be transmitted (%i).\
-				Maximum is 32", __func__, num);
+		dprintk("%s: too much I2C message to be transmitted (%i). Maximum is 32",
+			__func__, num);
 		return -ENOMEM;
 	}
 
-- 
2.15.0
