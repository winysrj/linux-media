Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44888 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754068AbeCWL5h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 29/30] media: tda9840: cleanup a warning
Date: Fri, 23 Mar 2018 07:57:15 -0400
Message-Id: <afdb4ca2be93d02cd1902395a7191097963dd8c1.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a false positive warning there:
	drivers/media/i2c/tda9840.c:79 tda9840_status() error: uninitialized symbol 'byte'.

Change the code to match our coding style, in order to fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tda9840.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tda9840.c b/drivers/media/i2c/tda9840.c
index f31e659588ac..0dd6ff3e6201 100644
--- a/drivers/media/i2c/tda9840.c
+++ b/drivers/media/i2c/tda9840.c
@@ -68,11 +68,15 @@ static void tda9840_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 static int tda9840_status(struct v4l2_subdev *sd)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int rc;
 	u8 byte;
 
-	if (1 != i2c_master_recv(client, &byte, 1)) {
+	rc = i2c_master_recv(client, &byte, 1);
+	if (rc != 1) {
 		v4l2_dbg(1, debug, sd,
 			"i2c_master_recv() failed\n");
+		if (rc < 0)
+			return rc;
 		return -EIO;
 	}
 
-- 
2.14.3
