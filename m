Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:42302 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934209AbeEIKss (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 06:48:48 -0400
Received: by mail-lf0-f68.google.com with SMTP id u21-v6so50276118lfu.9
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 03:48:48 -0700 (PDT)
From: Anders Roxell <anders.roxell@linaro.org>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] media: lgdt330x: add inline to lgdt330x_attach function
Date: Wed,  9 May 2018 12:48:42 +0200
Message-Id: <20180509104842.7621-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_DVB_LGDT330X is disabled, we get a build warning:
In file included from drivers/media/common/b2c2/flexcop-fe-tuner.c:21:0:
drivers/media/dvb-frontends/lgdt330x.h:61:22: warning: ‘lgdt330x_attach’ defined but not used [-Wunused-function]
 struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
                      ^~~~~~~~~~~~~~~

The affected function should be "static inline" and not only static
since the function is in a .h file.

Fixes: 23ba635d45f5 ("media: lgdt330x: convert it to the new I2C binding way")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/media/dvb-frontends/lgdt330x.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.h b/drivers/media/dvb-frontends/lgdt330x.h
index 94cc09d15ece..8ab6b39d02a8 100644
--- a/drivers/media/dvb-frontends/lgdt330x.h
+++ b/drivers/media/dvb-frontends/lgdt330x.h
@@ -57,7 +57,7 @@ struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
 				     u8 demod_address,
 				     struct i2c_adapter *i2c);
 #else
-static
+static inline
 struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
 				     u8 demod_address,
 				     struct i2c_adapter *i2c)
-- 
2.17.0
