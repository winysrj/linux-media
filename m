Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37937 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2JHONK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 10:13:10 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so2130606qad.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 07:13:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 22:13:09 +0800
Message-ID: <CAPgLHd_EYFLSz-ZabR6W6kjz3MS9x9w20CfduxHk8hE3H9pazg@mail.gmail.com>
Subject: [PATCH] i2c: vs6624: use module_i2c_driver to simplify the code
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
 drivers/media/i2c/vs6624.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 42ae9dc..f434a19 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -910,18 +910,7 @@ static struct i2c_driver vs6624_driver = {
 	.id_table       = vs6624_id,
 };
 
-static __init int vs6624_init(void)
-{
-	return i2c_add_driver(&vs6624_driver);
-}
-
-static __exit void vs6624_exit(void)
-{
-	i2c_del_driver(&vs6624_driver);
-}
-
-module_init(vs6624_init);
-module_exit(vs6624_exit);
+module_i2c_driver(vs6624_driver);
 
 MODULE_DESCRIPTION("VS6624 sensor driver");
 MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");


