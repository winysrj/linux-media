Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46855 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933431AbdKAVGR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH v2 19/26] media: ov9650: fix bogus warnings
Date: Wed,  1 Nov 2017 17:05:56 -0400
Message-Id: <a4092bf193d3a1c9ccd0dae4a735a1cbf5261ecd.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The smatch logic gets confused with the syntax used to check if the
ov9650x_read() reads succedded:
	drivers/media/i2c/ov9650.c:895 __g_volatile_ctrl() error: uninitialized symbol 'reg2'.
	drivers/media/i2c/ov9650.c:895 __g_volatile_ctrl() error: uninitialized symbol 'reg1'.

There's nothing wrong with the original logic, except that
it is a little more harder to review.

So, let's stick with the syntax that won't cause read
issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov9650.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 69433e1e2533..e519f278d5f9 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -886,10 +886,12 @@ static int __g_volatile_ctrl(struct ov965x *ov965x, struct v4l2_ctrl *ctrl)
 		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
 			return 0;
 		ret = ov965x_read(client, REG_COM1, &reg0);
-		if (!ret)
-			ret = ov965x_read(client, REG_AECH, &reg1);
-		if (!ret)
-			ret = ov965x_read(client, REG_AECHM, &reg2);
+		if (ret < 0)
+			return ret;
+		ret = ov965x_read(client, REG_AECH, &reg1);
+		if (ret < 0)
+			return ret;
+		ret = ov965x_read(client, REG_AECHM, &reg2);
 		if (ret < 0)
 			return ret;
 		exposure = ((reg2 & 0x3f) << 10) | (reg1 << 2) |
-- 
2.13.6
