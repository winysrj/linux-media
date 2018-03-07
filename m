Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45913 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751036AbeCGJOh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 04:14:37 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: dvbdev: fix building on ia64
Date: Wed,  7 Mar 2018 04:14:31 -0500
Message-Id: <1980bfa67f19d628df30b9b5b76bca37c2a76dde.1520414065.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure why, but, on ia64, with Linaro's gcc 7.3 compiler,
using #ifdef (CONFIG_I2C) is not OK.

So, replace it by IS_ENABLED(CONFIG_I2C), in order to fix the
builds there.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvbdev.c | 2 +-
 include/media/dvbdev.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index a840133feacb..cf747d753a79 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -942,7 +942,7 @@ int dvb_usercopy(struct file *file,
 	return err;
 }
 
-#ifdef CONFIG_I2C
+#if IS_ENABLED(CONFIG_I2C)
 struct i2c_client *dvb_module_probe(const char *module_name,
 				    const char *name,
 				    struct i2c_adapter *adap,
diff --git a/include/media/dvbdev.h b/include/media/dvbdev.h
index 2d2897508590..ee91516ad074 100644
--- a/include/media/dvbdev.h
+++ b/include/media/dvbdev.h
@@ -358,7 +358,7 @@ long dvb_generic_ioctl(struct file *file,
 int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		 int (*func)(struct file *file, unsigned int cmd, void *arg));
 
-#ifdef CONFIG_I2C
+#if IS_ENABLED(CONFIG_I2C)
 
 struct i2c_adapter;
 struct i2c_client;
-- 
2.14.3
