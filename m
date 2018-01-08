Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:52021 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S932172AbeAHMrK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 07:47:10 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangxiongfeng2@huawei.com>, <arnd@arndb.de>
Subject: [PATCH] [media] dibx000_common: use strlcpy() instead of strncpy()
Date: Mon, 8 Jan 2018 20:52:34 +0800
Message-ID: <1515415954-10963-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Xiongfeng Wang <xiongfeng.wang@linaro.org>

gcc-8 reports

drivers/media/dvb-frontends/dibx000_common.c: In function
'i2c_adapter_init':
./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
bound 48 equals destination size [-Wstringop-truncation]

We need to use strlcpy() to make sure the dest string is
nul-terminated.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 drivers/media/dvb-frontends/dibx000_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dibx000_common.c b/drivers/media/dvb-frontends/dibx000_common.c
index bc28184..6486f17 100644
--- a/drivers/media/dvb-frontends/dibx000_common.c
+++ b/drivers/media/dvb-frontends/dibx000_common.c
@@ -424,7 +424,7 @@ static int i2c_adapter_init(struct i2c_adapter *i2c_adap,
 				struct i2c_algorithm *algo, const char *name,
 				struct dibx000_i2c_master *mst)
 {
-	strncpy(i2c_adap->name, name, sizeof(i2c_adap->name));
+	strlcpy(i2c_adap->name, name, sizeof(i2c_adap->name));
 	i2c_adap->algo = algo;
 	i2c_adap->algo_data = NULL;
 	i2c_set_adapdata(i2c_adap, mst);
-- 
1.8.3.1
