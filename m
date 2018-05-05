Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38321 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeEELdx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 07:33:53 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: pt1: fix strncmp() size warning
Date: Sat,  5 May 2018 07:33:48 -0400
Message-Id: <5ebaf32866b649cc4e384725ce2742d705c064e6.1525520023.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/pt1/pt1.c:213 config_demod() error: strncmp() '"tc90522sat"' too small (11 vs 20)

Use the same strncmp() syntax as pt1_init_frontends() does.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/pt1/pt1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index a3126d7caac7..3b7e08a4639a 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -210,7 +210,8 @@ static int config_demod(struct i2c_client *cl, enum pt1_fe_clk clk)
 		return ret;
 	usleep_range(30000, 50000);
 
-	is_sat = !strncmp(cl->name, TC90522_I2C_DEV_SAT, I2C_NAME_SIZE);
+	is_sat = !strncmp(cl->name, TC90522_I2C_DEV_SAT,
+			  strlen(TC90522_I2C_DEV_SAT));
 	if (is_sat) {
 		struct i2c_msg msg[2];
 		u8 wbuf, rbuf;
-- 
2.17.0
