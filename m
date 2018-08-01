Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:51832 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732437AbeHALEx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Aug 2018 07:04:53 -0400
From: Wei Yongjun <weiyongjun1@huawei.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Nasser Afshin" <afshin.nasser@gmail.com>
CC: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-media@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] media: tvp5150: make function tvp5150_volatile_reg() static
Date: Wed, 1 Aug 2018 09:27:45 +0000
Message-ID: <1533115665-90439-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:

drivers/media/i2c/tvp5150.c:1457:6: warning:
 symbol 'tvp5150_volatile_reg' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/i2c/tvp5150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 7b0d42b..ad3b728 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1454,7 +1454,7 @@ static int tvp5150_registered(struct v4l2_subdev *sd)
 	},
 };
 
-bool tvp5150_volatile_reg(struct device *dev, unsigned int reg)
+static bool tvp5150_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case TVP5150_VERT_LN_COUNT_MSB:
