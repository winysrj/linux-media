Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:51995 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbbIQVUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 17:20:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 2/9] [media] dvb: remove unused systime() function
Date: Thu, 17 Sep 2015 23:19:33 +0200
Message-Id: <1442524780-781677-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1442524780-781677-1-git-send-email-arnd@arndb.de>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The systime function uses struct timespec, which we want to stop
using in the kernel because it overflows in 2038. Fortunately,
this use in dibx000_common is in a function that is never called,
so we can just remove it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb-frontends/dibx000_common.c | 10 ----------
 drivers/media/dvb-frontends/dibx000_common.h |  2 --
 2 files changed, 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/dibx000_common.c b/drivers/media/dvb-frontends/dibx000_common.c
index 43be7238311e..79cb007b401f 100644
--- a/drivers/media/dvb-frontends/dibx000_common.c
+++ b/drivers/media/dvb-frontends/dibx000_common.c
@@ -500,16 +500,6 @@ void dibx000_exit_i2c_master(struct dibx000_i2c_master *mst)
 }
 EXPORT_SYMBOL(dibx000_exit_i2c_master);
 
-
-u32 systime(void)
-{
-	struct timespec t;
-
-	t = current_kernel_time();
-	return (t.tv_sec * 10000) + (t.tv_nsec / 100000);
-}
-EXPORT_SYMBOL(systime);
-
 MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
 MODULE_DESCRIPTION("Common function the DiBcom demodulator family");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dibx000_common.h b/drivers/media/dvb-frontends/dibx000_common.h
index b538e0555c95..61f4152f24ee 100644
--- a/drivers/media/dvb-frontends/dibx000_common.h
+++ b/drivers/media/dvb-frontends/dibx000_common.h
@@ -47,8 +47,6 @@ extern void dibx000_exit_i2c_master(struct dibx000_i2c_master *mst);
 extern void dibx000_reset_i2c_master(struct dibx000_i2c_master *mst);
 extern int dibx000_i2c_set_speed(struct i2c_adapter *i2c_adap, u16 speed);
 
-extern u32 systime(void);
-
 #define BAND_LBAND 0x01
 #define BAND_UHF   0x02
 #define BAND_VHF   0x04
-- 
2.1.0.rc2

