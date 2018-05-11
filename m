Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:59791 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753120AbeEKPEM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:04:12 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Jasmin J." <jasmin@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] lgdt330x.h: fix compiler warning
Message-ID: <5c5c6f48-fe2c-5da8-ee43-d866c48f720e@xs4all.nl>
Date: Fri, 11 May 2018 17:04:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing 'inline' to fix this compiler warning:

In file included from drivers/media/common/b2c2/flexcop-fe-tuner.c:21:0:
drivers/media/dvb-frontends/lgdt330x.h:61:22: warning: 'lgdt330x_attach' defined but not used [-Wunused-function]
 struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
                      ^~~~~~~~~~~~~~~

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Suggested-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
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
2.14.1
