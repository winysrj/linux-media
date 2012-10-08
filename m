Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36573 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2JHONl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 10:13:41 -0400
Received: by mail-qc0-f174.google.com with SMTP id d3so2885333qch.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 07:13:41 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 22:13:41 +0800
Message-ID: <CAPgLHd_dS4oPpEnTG2uJ-5dGgcU9Ebxk-TEggOU5Z94iY3qBpg@mail.gmail.com>
Subject: [PATCH] i2c: adv7183: use module_i2c_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_i2c_driver() macro to make the code smaller
and a bit simpler.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/i2c/adv7183.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index e1d4c89..10c3c1d 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -681,18 +681,7 @@ static struct i2c_driver adv7183_driver = {
 	.id_table       = adv7183_id,
 };
 
-static __init int adv7183_init(void)
-{
-	return i2c_add_driver(&adv7183_driver);
-}
-
-static __exit void adv7183_exit(void)
-{
-	i2c_del_driver(&adv7183_driver);
-}
-
-module_init(adv7183_init);
-module_exit(adv7183_exit);
+module_i2c_driver(adv7183_driver);
 
 MODULE_DESCRIPTION("Analog Devices ADV7183 video decoder driver");
 MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");


