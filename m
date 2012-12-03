Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59959 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2LCCxo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 21:53:44 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so1048160qaq.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 18:53:44 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 21:53:44 -0500
Message-ID: <CAPgLHd_6Jnu5x0rEwVr-3Uw04f1MjB96AVQ1KAWFSoeCB2Gupg@mail.gmail.com>
Subject: [PATCH -next] [media] davinci: vpbe: remove unused variable in vpbe_initialize()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: manjunath.hadli@ti.com, prabhakar.lad@ti.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable 'output_index' is initialized but never used
otherwise, so remove the unused variable.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/davinci/vpbe.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 7f5cf9b..e0c79c1 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -584,7 +584,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	struct v4l2_subdev **enc_subdev;
 	struct osd_state *osd_device;
 	struct i2c_adapter *i2c_adap;
-	int output_index;
 	int num_encoders;
 	int ret = 0;
 	int err;
@@ -731,7 +730,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	/* set the current encoder and output to that of venc by default */
 	vpbe_dev->current_sd_index = 0;
 	vpbe_dev->current_out_index = 0;
-	output_index = 0;
 
 	mutex_unlock(&vpbe_dev->lock);
 


